<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Log;
use App\Models\OperateurInformation;
use App\Models\Demande;


class DemandeController extends Controller
{
    public function store(Request $request)
    {
        DB::beginTransaction();

        try {
            // Validation des données reçues
            $validatedData = $request->validate([
                'id' => 'required|integer|exists:users,id',
                'nomoperateur' => 'required|string|max:200',
                'adresseoperateur' => 'required|string|max:200',
                'idville' => 'required|integer|exists:ville,idville',
                'telephone' => 'nullable|string|max:200',
                'telecopie' => 'nullable|string|max:200',
                'email' => 'nullable|email|max:200',
                'idstructurejuridique' => 'nullable|integer|exists:structurejuridique,idstructurejuridique',
                'idformulaire' => 'required|integer|exists:formulaire,idformulaire',
                'datedeclaration' => 'required|date',
                'reponses' => 'required|array',
                'reponses.*.idquestion' => 'required|integer|exists:question,idquestion',
                'reponses.*.textereponse' => 'nullable|string|max:300',
                'reponses.*.nombrereponse' => 'nullable|numeric',
                'reponses.*.filereponse' => 'nullable|file|mimes:pdf|max:2048'
            ], [
                'id.required' => 'L\'ID de l\'opérateur est requis.',
                'id.integer' => 'L\'ID de l\'opérateur doit être un entier.',
                'id.exists' => 'L\'ID de l\'opérateur n\'existe pas dans la base de données.',
                'nomoperateur.required' => 'Le nom de l\'opérateur est requis.',
                'nomoperateur.string' => 'Le nom de l\'opérateur doit être une chaîne de caractères.',
                'nomoperateur.max' => 'Le nom de l\'opérateur ne peut pas dépasser 200 caractères.',
                'adresseoperateur.required' => 'L\'adresse de l\'opérateur est requise.',
                'adresseoperateur.string' => 'L\'adresse de l\'opérateur doit être une chaîne de caractères.',
                'adresseoperateur.max' => 'L\'adresse de l\'opérateur ne peut pas dépasser 200 caractères.',
                'idville.required' => 'L\'ID de la ville est requis.',
                'idville.integer' => 'L\'ID de la ville doit être un entier.',
                'idville.exists' => 'L\'ID de la ville n\'existe pas dans la base de données.',
                'telephone.string' => 'Le téléphone doit être une chaîne de caractères.',
                'telephone.max' => 'Le téléphone ne peut pas dépasser 200 caractères.',
                'telecopie.string' => 'La télécopie doit être une chaîne de caractères.',
                'telecopie.max' => 'La télécopie ne peut pas dépasser 200 caractères.',
                'email.email' => 'L\'email doit être une adresse email valide.',
                'email.max' => 'L\'email ne peut pas dépasser 200 caractères.',
                'idstructurejuridique.integer' => 'L\'ID de la structure juridique doit être un entier.',
                'idstructurejuridique.exists' => 'L\'ID de la structure juridique n\'existe pas dans la base de données.',
                'idformulaire.required' => 'L\'ID du formulaire est requis.',
                'idformulaire.integer' => 'L\'ID du formulaire doit être un entier.',
                'idformulaire.exists' => 'L\'ID du formulaire n\'existe pas dans la base de données.',
                'datedeclaration.required' => 'La date de déclaration est requise.',
                'datedeclaration.date' => 'La date de déclaration doit être une date valide.',
                'reponses.required' => 'Les réponses sont requises.',
                'reponses.array' => 'Les réponses doivent être un tableau.',
                'reponses.*.idquestion.required' => 'L\'ID de la question est requis.',
                'reponses.*.idquestion.integer' => 'L\'ID de la question doit être un entier.',
                'reponses.*.idquestion.exists' => 'L\'ID de la question n\'existe pas dans la base de données.',
                'reponses.*.texteReponse.string' => 'La réponse textuelle doit être une chaîne de caractères.',
                'reponses.*.texteReponse.max' => 'La réponse textuelle ne peut pas dépasser 300 caractères.',
                'reponses.*.nombreReponse.numeric' => 'La réponse numérique doit être un nombre.',
                'reponses.*.fileReponse.file' => 'Le fichier de réponse doit être un fichier.',
                'reponses.*.fileReponse.mimes' => 'Le fichier de réponse doit être au format PDF.',
                'reponses.*.fileReponse.max' => 'Le fichier de réponse ne peut pas dépasser 2 Mo.'
            ]);

            // Définir la date d'expiration comme 5 ans après la date de déclaration
            $dateexpiration = Carbon::parse($validatedData['datedeclaration'])->addYears(5);

            // Récupérer l'opérateur existant à partir de l'ID utilisateur
            $operateur = DB::table('operateur')
            ->where('id', $validatedData['id'])
            ->first();

            if ($operateur) {
                // Si le nom est différent, on met à jour
                if ($operateur->nom !== $validatedData['nomoperateur']) {
                    DB::table('operateur')
                        ->where('id', $validatedData['id'])
                        ->update(['nom' => $validatedData['nomoperateur']]);
                }
                $operateurId = $operateur->idoperateur;
            } else {
                // Gestion d'erreur si l'opérateur n'est pas trouvé
                return response()->json(['error' => 'Opérateur non trouvé'], 404);
            }

            // Création des informations pour l'opérateur
            $operateurInformationId = OperateurInformation::create([
                'idoperateur' => $operateurId,
                'adresse' => $validatedData['adresseoperateur'],
                'idville' => $validatedData['idville'],
                'telephone' => $validatedData['telephone'] ?? null,
                'telecopie' => $validatedData['telecopie'] ?? null,
                'email' => $validatedData['email'] ?? null,
                'idstructurejuridique' => $validatedData['idstructurejuridique'] ?? null
            ])->idoperateurinformation;

            // Insertion de la nouvelle demande dans la table `demande`
            $demandeId = Demande::create([
                'idoperateurinformation' => $operateurInformationId,
                'idformulaire' => $validatedData['idformulaire'],
                'datedeclaration' => $validatedData['datedeclaration'],
                'dateexpiration' => $dateexpiration,
                'status' => 1 // Status initial à 0
            ])->iddemande;

            // Insertion des réponses associées dans la table `reponseFormulaire`
            foreach ($validatedData['reponses'] as $reponse) {
                $filePath = null;

                // Gestion du fichier, s'il y en a un
                if (isset($reponse['filereponse']) && $reponse['filereponse']->isValid()) {
                    $filePath = $reponse['filereponse']->store('reponses_fichiers');
                }

                DB::table('reponseformulaire')->insert([
                    'idquestion' => $reponse['idquestion'],
                    'iddemande' => $demandeId,
                    'textereponse' => $reponse['textereponse'] ?? null,
                    'nombrereponse' => $reponse['nombrereponse'] ?? null,
                    'filereponse' => $filePath
                ]);
            }
            DB::commit();
            return response()->json(['message' => 'Demande créée avec succès', 'iddemande' => $demandeId], 201);
        } catch (\Exception $e) {
            DB::rollBack(); // Annuler la transaction en cas d'erreur générale
            // Retourner les détails de l'erreur pour le débogage
            return response()->json([
                'error' => 'Une erreur est survenue lors de la création de la demande.',
                'details' => $e->getMessage(), // Message d'erreur
                'file' => $e->getFile(), // Fichier où l'erreur a eu lieu
                'line' => $e->getLine() // Ligne où l'erreur a eu lieu
            ], 500);
        }
    }

}
