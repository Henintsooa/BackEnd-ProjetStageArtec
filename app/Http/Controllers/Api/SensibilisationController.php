<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\OperateurCible;
use App\Models\Operateur;
use App\Models\OperateurCibleDetails;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;
use App\Mail\SendMail;
use Illuminate\Support\Facades\Mail;
use App\Models\Sensibilisation;
use Illuminate\Support\Facades\DB;

class SensibilisationController extends Controller
{
    public function addOperateurCible(Request $request)
    {
        try {
            // Validation des données
            $data = $request->validate([
                'nom' => 'required|string|max:200',
                'email' => 'required|email|max:200|unique:operateurcible,email',
                'idville' => 'required|integer|exists:ville,idville',
                'idregime' => 'required|integer|exists:regime,idregime',
                'adresse' => 'required|string|max:200',
            ], [
                'nom.required' => 'Le nom est requis.',
                'nom.string' => 'Le nom doit être une chaîne de caractères.',
                'nom.max' => 'Le nom ne peut pas dépasser 200 caractères.',
                'email.required' => 'L\'email est requis.',
                'email.email' => 'L\'email doit être valide.',
                'email.max' => 'L\'email ne peut pas dépasser 200 caractères.',
                'email.unique' => 'L\'email est déjà utilisé par un opérateur.',
                'idville.required' => 'L\'ID de la ville est requis.',
                'idville.integer' => 'L\'ID de la ville doit être un entier.',
                'idville.exists' => 'L\'ID de la ville doit exister dans la table des villes.',
                'idregime.required' => 'L\'ID du régime est requis.',
                'idregime.integer' => 'L\'ID du régime doit être un entier.',
                'idregime.exists' => 'L\'ID du régime doit exister dans la table des régimes.',
                'adresse.required' => 'L\'adresse est requise.',
                'adresse.string' => 'L\'adresse doit être une chaîne de caractères.',
                'adresse.max' => 'L\'adresse ne peut pas dépasser 200 caractères.',
            ]);
            // Affichez les données avant l'insertion pour déboguer
            \Log::info('Données reçues : ', $data);

            // Création de l'opérateur cible
            $operateurCible = OperateurCible::create([
                'nom' => $data['nom'],
                'email' => $data['email'],
                'idville' => $data['idville'],
                'idregime' => $data['idregime'],
                'adresse' => $data['adresse'],
            ]);

            return response()->json([
                'message' => 'Opérateur cible créé avec succès.',
                'data' => $operateurCible
            ], 201);

        } catch (\Exception $e) {

            return response()->json([
                'status' => 500,
                'error' => 'Erreur lors de la création de l\'opérateur cible.',
                'message' => $e->getMessage()
            ], 500);
        }
    }


    public function operateurCibles(Request $request)
    {
        $keyword = '%' . $request->keyword . '%';
        $operateurCibles = DB::table('operateurcibledetails')
            ->where('status', '=', 0)
            ->where(function($query) use ($keyword) {
                $query->where('nom', 'ILIKE', $keyword)
                    ->orWhere('email', 'ILIKE', $keyword)
                    ->orWhere('ville', 'ILIKE', $keyword)
                    ->orWhere(DB::raw('TO_CHAR(datesensibilisation, \'YYYY-MM-DD\')'), 'LIKE', $keyword);
            })
            ->orderBy('idoperateurcible', 'desc')
            ->get();

        return response()->json($operateurCibles);
    }

    public function operateurCiblesHistorique(Request $request)
    {
        // Diviser les mots-clés par espaces et les préparer pour la recherche
        $keywords = explode(' ', $request->keyword);
        $status = $request->status;

        // Construire la requête pour les opérateurs cibles
        $operateurCibles = DB::table('operateurcibledetails')
            ->where('status', '=', 0)
            ->where(function($query) use ($keywords) {
                foreach ($keywords as $keyword) {
                    $keyword = '%' . $keyword . '%'; // Préparation pour le LIKE
                    $query->where(function($subQuery) use ($keyword) {
                        $subQuery->where('nom', 'ILIKE', $keyword)
                                 ->orWhere('email', 'ILIKE', $keyword)
                                 ->orWhere('ville', 'ILIKE', $keyword)
                                 ->orWhere('nomregime', 'ILIKE', $keyword)
                                 ->orWhere('adresse', 'ILIKE', $keyword)
                                 ->orWhere(DB::raw('TO_CHAR(datesensibilisation, \'YYYY-MM-DD\')'), 'LIKE', $keyword);
                    });
                }
            })
            // Filtrer par status si fourni
            ->when($status !== '', function ($query) use ($status) {
                if ($status === 'null') {
                    return $query->whereNull('sensibilisationstatus');
                }
                return $query->where('sensibilisationstatus', $status);
            })
            ->when($status !== '', function ($query) use ($status) {
                if ($status === 'null') {
                    return $query->whereNull('sensibilisationstatus');
                }
                return $query->where('sensibilisationstatus', $status);
            })
            // Appliquer le tri conditionnel
            ->orderByRaw('CASE WHEN datesensibilisation IS NOT NULL THEN 0 ELSE 1 END, datesensibilisation DESC, idoperateurcible DESC')
            ->get();

        return response()->json($operateurCibles);
    }



    public function supprimerOperateurCible($id)
    {
        try {
            $operateur = OperateurCible::find($id);
            \Log::info('Données operateur : ', $operateur ? $operateur->toArray() : []);
            if ($operateur) {
                $operateur->status = 1;
                $operateur->save();

                return response()->json(['message' => 'Opérateur supprimé avec succès.']);
            } else {
                return response()->json(['message' => 'Opérateur non trouvé.'], 404);
            }
        } catch (\Exception $e) {
            return response()->json(['error' => 'Erreur lors de la suppression de l\'opérateur.', 'details' => $e->getMessage()], 500);
        }
    }

    public function editOperateurCible(Request $request, $id)
    {
        try {
            // Validation des données
            $data = $request->validate([
                'nom' => 'string|max:200',
                'email' => 'email|max:200|unique:operateurcible,email,' . $id . ',idoperateurcible',
                'idville' => 'integer|exists:ville,idville',
                'idregime' => 'required|integer|exists:regime,idregime',
                'adresse' => 'required|string|max:200',
            ], [
                'nom.string' => 'Le nom doit être une chaîne de caractères.',
                'nom.max' => 'Le nom ne peut pas dépasser 200 caractères.',
                'email.email' => 'L\'email doit être valide.',
                'email.max' => 'L\'email ne peut pas dépasser 200 caractères.',
                'email.unique' => 'L\'email est déjà utilisé.',
                'idville.integer' => 'L\'ID de la ville doit être un entier.',
                'idville.exists' => 'L\'ID de la ville doit exister dans la table des villes.',
                'idregime.required' => 'L\'ID du régime est requis.',
                'idregime.integer' => 'L\'ID du régime doit être un entier.',
                'idregime.exists' => 'L\'ID du régime doit exister dans la table des régimes.',
                'adresse.required' => 'L\'adresse est requise.',
                'adresse.string' => 'L\'adresse doit être une chaîne de caractères.',
                'adresse.max' => 'L\'adresse ne peut pas dépasser 200 caractères.',
            ]);

            // Trouver l'opérateur cible
            $operateurCible = OperateurCible::findOrFail($id);

            // Mise à jour des données (uniquement celles qui sont fournies)
            $operateurCible->update(array_filter([
                'nom' => $data['nom'] ?? $operateurCible->nom,
                'email' => $data['email'] ?? $operateurCible->email,
                'idville' => $data['idville'] ?? $operateurCible->idville,
                'idregime' => $data['idregime'] ?? $operateurCible->idregime,
                'adresse' => $data['adresse'] ?? $operateurCible->adresse,
            ]));

            return response()->json([
                'message' => 'Opérateur cible mis à jour avec succès.',
                'data' => $operateurCible
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'status' => 500,
                'error' => 'Erreur lors de la mise à jour de l\'opérateur cible.',
                'message' => $e->getMessage()
            ], 500);
        }
    }

    public function operateurCibleById($id)
    {
        $operateurCibles = OperateurCibleDetails::where('idoperateurcible', $id)->get();

        return response()->json($operateurCibles);
    }

    public function sendEmailSensibilisation(Request $request)
    {
        $title = 'Sensibilisation à se déclarer en tant que Opérateur auprès de l\'ARTEC.';
        $dateNow = now(); // Récupère la date et l'heure actuelles

        foreach ($request->operators as $operator) {
            $user = [
                'name' => $operator['name'],
                'email' => $operator['email']
            ];

            try {
                // Envoi de l'email
                Mail::to($user['email'])->send(new SendMail($title, $user));

                // Rechercher l'ID de l'opérateur cible basé sur l'email
                $operateurCible = OperateurCible::where('email', $user['email'])->first();

                if ($operateurCible) {
                    // Rechercher une entrée existante dans la table sensibilisation
                    $sensibilisation = Sensibilisation::where('idoperateurcible', $operateurCible->idoperateurcible)->first();

                    if ($sensibilisation) {
                        // Mettre à jour la date de sensibilisation existante
                        $sensibilisation->update([
                            'datesensibilisation' => $dateNow,
                        ]);
                    } else {
                        // Insérer une nouvelle entrée
                        Sensibilisation::create([
                            'idoperateurcible' => $operateurCible->idoperateurcible,
                            'status' => 0,
                            'idoperateur' => null,
                            'datesensibilisation' => $dateNow,
                            'dateconversion' => null
                        ]);
                    }
                } else {
                    return response()->json(['message' => 'Opérateur non trouvé pour l\'email ' . $user['email']], 404);
                }

            } catch (\Exception $e) {
                // Gestion des exceptions
                return response()->json(['message' => 'Email non envoyé à ' . $user['email'], 'error' => $e->getMessage()], 400);
            }
        }

        return response()->json(['message' => 'Emails envoyés et sensibilisations enregistrées'], 200);
    }


    public function updateOrInsertSensibilisation(Request $request)
    {
        // Valider les données de la requête
        $validated = $request->validate([
            'idoperateurcible' => 'integer|exists:operateurcible,idoperateurcible',
            'idoperateur' => 'required|integer|exists:operateur,idoperateur',
            'status' => 'required|integer',
        ]);

        $idoperateurcible = $validated['idoperateurcible'];
        $idoperateur = $validated['idoperateur'];
        $status = $validated['status'];

        $dateconversion = DB::table('demandedetails')
        ->where('idoperateur', $idoperateur)
        ->orderBy('datedemande', 'asc')
        ->value('datedemande');

        // Vérifier si l'enregistrement existe
        $exists = DB::table('sensibilisation')
            ->where('idoperateurcible', $idoperateurcible)
            ->exists();

        // Mettre à jour ou insérer un enregistrement dans la table sensibilisation
        DB::table('sensibilisation')->updateOrInsert(
            ['idoperateurcible' => $idoperateurcible],
            [
                'status' => $status,
                'idoperateur' => $idoperateur,
                'dateconversion' => $dateconversion,
                'datesensibilisation' => $exists ? DB::raw('datesensibilisation') : now(), // Conserver la date si mise à jour
            ]
        );

        return response()->json(['message' => 'Enregistrement de sensibilisation mis à jour ou inséré avec succès.']);
    }




    public function getOperateurs(Request $request)
    {
        $keyword = $request->input('keyword', '');

        $operateurs = DB::table('operateurconvertir')
            ->select('operateurconvertir.*')
            ->when($keyword, function ($query) use ($keyword) {
                return $query->where('nom', 'like', '%' . $keyword . '%');
            })
            ->orderBy('idoperateur', 'desc')
            ->get();

        return response()->json($operateurs);
    }

    public function getOperateurCibles(Request $request)
    {
        $keyword = $request->input('keyword', '');

        $operateurCibles = DB::table('operateurciblesconvertir')
            ->select('operateurciblesconvertir.*')
            ->when($keyword, function ($query) use ($keyword) {
                return $query->where('nom', 'like', '%' . $keyword . '%');
            })
            ->orderBy('idoperateurcible', 'desc')
            ->get();

        return response()->json($operateurCibles);
    }



}
