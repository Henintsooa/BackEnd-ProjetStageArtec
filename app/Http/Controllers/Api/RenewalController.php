<?php
namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Notification;
use Carbon\Carbon;
use App\Notifications\OperateurRenewalNotification;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Mail;

class RenewalController extends Controller
{
    public function checkRenewals(Request $request)
    {
        // Valider les données entrantes
        $validated = $request->validate([
            'expiryDate' => 'required|date',
            'iddemande' => 'required|integer',
        ]);

        $expiryDate = $validated['expiryDate'];
        $iddemande = $validated['iddemande'];

        // Récupérer les détails associés à iddemande
        $details = DB::table('demandedetails')
            ->where('iddemande', $iddemande)
            ->first();

        if (!$details) {
            return response()->json([
                'message' => 'No details found for the provided iddemande.',
            ], 404);
        }

        // Insérer les détails du renouvellement dans la table `renouvellement`
        DB::table('renouvellement')->insert([
            'iddemande' => $iddemande,
            'idoperateur' => $details->idoperateur,
            'idtypeformulaire' => $details->idtypeformulaire,
            'dateenvoi' => $expiryDate,
            'created_at' => now(),
        ]);

        return response()->json([
            'message' => 'Date de notification de renouvellement insérée avec succès.',
        ], 200);
    }

    public function getRenouvellements(Request $request)
    {
        // Diviser les mots-clés par espaces et les préparer pour la recherche
        $keywords = explode(' ', $request->keyword);
        $isRenewedFilter = $request->isRenewed; // Filtre pour savoir si le renouvellement est fait ou non

        // Construire la requête
        $query = DB::table('renouvellementdetails');

        // Recherche par plusieurs mots-clés
        if (!empty($keywords)) {
            $query->where(function($q) use ($keywords) {
                foreach ($keywords as $keyword) {
                    $keyword = '%' . $keyword . '%'; // Préparation pour le LIKE
                    $q->where(function($subQuery) use ($keyword) {
                        $subQuery->where('nomoperateur', 'ILIKE', $keyword)
                                 ->orWhere('nomtypeformulaire', 'ILIKE', $keyword)
                                 ->orWhere(DB::raw('TO_CHAR(dateexpiration, \'YYYY-MM-DD\')'), 'LIKE', $keyword)
                                 ->orWhere(DB::raw('TO_CHAR(datenotification, \'YYYY-MM-DD\')'), 'LIKE', $keyword);
                    });
                }
            });
        }

        // Filtrer par renouvellement (fait ou pas encore)
        if ($isRenewedFilter !== null && $isRenewedFilter !== '') {
            if ($isRenewedFilter == 'fait') {
                $query->whereNotNull('datenotification');
            } elseif ($isRenewedFilter == 'pas_fait') {
                $query->whereNull('datenotification');
            }
        }

        // Récupérer les résultats
        $renouvellements = $query->get();

        return response()->json($renouvellements);
    }


    public function notifierOperateurs(Request $request)
    {
        $dateNow = now(); // Date actuelle

        // Accédez au tableau des renouvellements
        $renewals = $request->input('renewals', []);

        Log::info($request->all());

        // Démarrer une transaction
        DB::beginTransaction();

        try {
            foreach ($renewals as $renewalData) {
                // Assurez-vous que $renewalData est un tableau et contient 'idrenouvellement'
                if (is_array($renewalData) && isset($renewalData['renouvellement_id'])) {
                    // Récupérer le renouvellement
                    $renouvellement = DB::table('renouvellementdetails')->where('renouvellement_id', $renewalData['renouvellement_id'])->first();

                    if (!$renouvellement) {
                        throw new \Exception('Renouvellement introuvable pour l\'ID ' . $renewalData['renouvellement_id']);
                    }

                    // Récupérer la demande associée
                    $demande = DB::table('demandedetails')->where('iddemande', $renouvellement->iddemande)->first();

                    if (!$demande) {
                        throw new \Exception('Demande introuvable pour l\'ID ' . $renouvellement->iddemande);
                    }

                    // Mettre à jour la date de notification
                    DB::table('renouvellement')
                        ->where('idrenouvellement', $renouvellement->renouvellement_id)
                        ->update(['datenotification' => $dateNow]);

                    // Préparer les informations pour l'email
                    $operateur = (object) [
                        'email' => $demande->email,
                        'nomoperateur' => $demande->nomoperateur,
                        'iddemande' => $demande->iddemande,
                        'dateexpiration' => $renouvellement->dateexpiration,
                        'nomtypeformulaire' => $demande->nomtypeformulaire,
                        'datedeclaration' => $demande->datedeclaration,
                        'nomville' => $demande->nomville,
                    ];

                    Log::info($demande->email);

                    // Envoyer la notification par email
                    Notification::route('mail', $operateur->email)
                        ->notify(new OperateurRenewalNotification($operateur));
                } else {
                    throw new \Exception('ID de renouvellement manquant dans les données');
                }
            }

            // Commit des modifications si tout s'est bien passé
            DB::commit();
            return response()->json(['message' => 'Notifications envoyées et dates de notification mises à jour'], 200);
        } catch (\Exception $e) {
            // Rollback des modifications en cas d'erreur
            DB::rollBack();
            Log::error('Erreur lors de l\'envoi des notifications: ' . $e->getMessage());
            return response()->json(['message' => 'Erreur lors de l\'envoi des notifications', 'error' => $e->getMessage()], 400);
        }
    }

    public function getRenouvellementsById($id)
    {
        // Assurez-vous que l'ID est correctement passé
        \Log::info('Operator ID:', ['id' => $id]);

        // Obtenez l'opérateur associé à cet utilisateur
        $operateur = DB::table('operateur')->where('id', $id)->first();

        if (!$operateur) {
            return response()->json(['error' => 'Opérateur non trouvé pour l\'utilisateur'], 404);
        }

        // Obtenez les détails de renouvellement pour cet opérateur
        $renewals = DB::table('renouvellementdetails as r')
            ->leftJoin('demandedetails as d', 'r.renouvellement_id', '=', 'd.idrenouvellement')
            ->where('r.idoperateur', $operateur->idoperateur)
            ->where(function($query) {
                $query->whereNull('d.idrenouvellement') // Exclure les renouvellements déjà présents dans demandedetails
                    ->orWhere('d.status', '!=', 2);   // Exclure ceux avec status = 2
            })
            ->select('r.*') // Sélectionner toutes les colonnes de renouvellementdetails
            ->get();

        // Convertir la collection en tableau
        $renewalsArray = $renewals->toArray();

        // Logguez les résultats
        \Log::info('Renewals found:', ['renewals' => $renewalsArray]);

        return response()->json(['renewals' => $renewals], 200);
    }



}
