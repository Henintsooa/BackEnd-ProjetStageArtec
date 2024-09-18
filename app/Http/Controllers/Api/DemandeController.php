<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Log;
use App\Models\OperateurInformation;
use App\Models\Operateur;
use App\Models\Demande;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Auth;
use App\Mail\DemandeAcceptedMail;
use App\Mail\DemandeRejectedMail;
use App\Mail\InfoRequestMail;
use App\Mail\ConfirmationMail;
use Illuminate\Support\Facades\Mail;
use Dompdf\Dompdf;
use Dompdf\Options;
use Illuminate\Support\Facades\View;

class DemandeController extends Controller
{
    public function getOperateur($id)
    {
        $operateur = DB::table('operateur')
            ->where('id', $id)
            ->first();

        if (!$operateur) {
            return response()->json(['error' => 'Opérateur non trouvé.'], 404);
        }

        return response()->json($operateur);
    }

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
                'reponses' => 'required|array',
                'reponses.*.idquestion' => 'required|integer|exists:question,idquestion',
                'reponses.*.textereponse' => 'nullable|string|max:300',
                'reponses.*.nombrereponse' => 'nullable|numeric',
                'reponses.*.filereponse' => 'nullable|file|mimes:pdf|max:4096',
                'idrenouvellement' => 'nullable|exists:renouvellement,idrenouvellement',
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
                'reponses.required' => 'Les réponses sont requises.',
                'reponses.array' => 'Les réponses doivent être un tableau.',
                'reponses.*.idquestion.required' => 'L\'ID de la question est requis.',
                'reponses.*.idquestion.integer' => 'L\'ID de la question doit être un entier.',
                'reponses.*.idquestion.exists' => 'L\'ID de la question n\'existe pas dans la base de données.',
                'reponses.*.texteReponse.string' => 'La réponse textuelle doit être une chaîne de caractères.',
                'reponses.*.texteReponse.max' => 'La réponse textuelle ne peut pas dépasser 300 caractères.',
                'reponses.*.nombreReponse.numeric' => 'La réponse numérique doit être un nombre.',
                'reponses.*.fileReponse.file' => 'Le fichier de réponse doit être un fichier.',
                'reponses.*.fileReponse.mimes' => 'Le fichier de réponse doit être au format PDF.'
                // 'reponses.*.fileReponse.max' => 'Le fichier de réponse ne peut pas dépasser 2 Mo.'
            ]);


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
                // Création d'un nouvel opérateur si non trouvé
                $operateur = new Operateur();
                $operateur->id = $validatedData['id'];
                $operateur->nom = $validatedData['nomoperateur'];
                $operateur->save();

                $operateurId = $operateur->idoperateur;
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
            // Préparer les données pour l'insertion dans la table demande
            $demandeData = [
                'idoperateurinformation' => $operateurInformationId,
                'idformulaire' => $validatedData['idformulaire'],
                'status' => 1 // Statut initial
            ];

            // Vérification si l'idrenouvellement est présent et ajout à la demande
            if (isset($validatedData['idrenouvellement'])) {
                $demandeData['idrenouvellement'] = $validatedData['idrenouvellement'];
            }

            // Insérer la nouvelle demande dans la base et récupérer l'ID avec Eloquent
            $demande = Demande::create($demandeData);

            // Récupérer l'ID de la nouvelle demande
            $demandeId = $demande->iddemande;

            // $demandeId contient maintenant l'ID de la nouvelle demande



            // Insertion des réponses associées dans la table `reponseFormulaire`
            foreach ($validatedData['reponses'] as $reponse) {
                $fileUrl = null;

                // Gestion du fichier, s'il y en a un
                if (isset($reponse['filereponse']) && $reponse['filereponse']->isValid()) {
                    $file = $reponse['filereponse'];
                    $fileExtension = $file->getClientOriginalExtension(); // Obtenir l'extension du fichier
                    $fileName = Str::uuid() . '.' . $fileExtension; // Générer un nom unique avec l'extension originale
                    $filePath = 'public/reponses_fichiers/' . $fileName; // Définir le chemin complet du fichier
                    $file->move(storage_path('app/public/reponses_fichiers'), $fileName); // Déplacer le fichier dans le bon répertoire
                    $fileUrl = 'storage/reponses_fichiers/' . $fileName; // Construire l'URL à stocker dans la base de données
                }

                DB::table('reponseformulaire')->insert([
                    'idquestion' => $reponse['idquestion'],
                    'iddemande' => $demandeId,
                    'textereponse' => $reponse['textereponse'] ?? null,
                    'nombrereponse' => $reponse['nombrereponse'] ?? null,
                    'filereponse' => $fileUrl
                ]);
            }
            $typeformulaire = DB::table('formulaire')
            ->join('typeformulaire', 'formulaire.idtypeformulaire', '=', 'typeformulaire.idtypeformulaire')
            ->where('formulaire.idformulaire', $validatedData['idformulaire'])
            ->value('typeformulaire.nom');

            $administrateurs = DB::table('users')
                ->where('status', 'admin')
                ->get();

            foreach ($administrateurs as $admin) {
                DB::table('notifications')->insert([
                    'id' => $admin->id,
                    'message' => 'demande de déclaration',
                    'iddemande' => $demandeId,
                    'type' => $typeformulaire,
                    'created_at' => now(),
                    'updated_at' => now()
                ]);
            }

            DB::commit();

            $demande = DB::table('demandedetails')
                ->where('iddemande', $demandeId)
                ->first();
            // Envoyer un email de confirmation
            $email = $validatedData['email'];
            Mail::to($email)->send(new ConfirmationMail($demande));

            return response()->json(['message' => 'Demande envoyée, Vous recevrez une réponse par email. Merci!', 'iddemande' => $demandeId], 201);
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

    public function getNotifications()
    {
        $user = Auth::user();

        if (!$user) {
            return response()->json(['error' => 'Utilisateur non authentifié.'], 401);
        }
        if ($user->status !== 'admin') {
            return response()->json(['error' => 'Accès refusé.'], 403);
        }

        $notifications = DB::table('notifications')
            ->where('id', $user->id)
            ->orderBy('created_at', 'desc')
            ->get();

        $unreadCount = $notifications->where('lue', false)->count();

        return response()->json([
            'notifications' => $notifications,
            'unreadCount' => $unreadCount
        ]);
    }


    public function markNotificationAsRead($idnotification)
    {
        $user = Auth::user();

        if (!$user) {
            return response()->json(['error' => 'Utilisateur non authentifié.'], 401);
        }

        DB::table('notifications')
            ->where('idnotification', $idnotification)
            ->where('id', $user->id)
            ->update(['lue' => true]);

        return response()->json(['success' => 'Notification marquée comme lue.']);
    }


    public function getDemandes(Request $request)
    {
        $keywords = explode(' ', $request->query('searchKeyword', ''));
        $statusFilter = $request->query('selectedStatus', '');
        $startDate = $request->query('startDate', '');
        $endDate = $request->query('endDate', '');
        $formType = $request->query('selectedFormType', '');
        $city = $request->query('selectedCity', '');

        \Log::info('Keywords:', ['keywords' => $keywords]);
        \Log::info('Filters:', [
            'statusFilter' => $statusFilter,
            'startDate' => $startDate,
            'endDate' => $endDate,
            'formType' => $formType,
            'city' => $city
        ]);

        $query = DB::table('demandedetails');

        // Filtrer par mots-clés
        if (!empty($keywords)) {
            $query->where(function($q) use ($keywords) {
                foreach ($keywords as $keyword) {
                    $keyword = '%' . $keyword . '%'; // Préparation pour le LIKE
                    $q->where(function($subQuery) use ($keyword) {
                        $subQuery->where('nomoperateur', 'ILIKE', $keyword)
                                 ->orWhere('email', 'ILIKE', $keyword)
                                 ->orWhere('typedemande', 'ILIKE', $keyword)
                                 ->orWhere('nomville', 'ILIKE', $keyword)
                                 ->orWhere('nomtypeformulaire', 'ILIKE', $keyword)
                                 ->orWhere('nomregime', 'ILIKE', $keyword)
                                 ->orWhere(DB::raw('TO_CHAR(datedemande, \'YYYY-MM-DD\')'), 'LIKE', $keyword)
                                 ->orWhere(DB::raw('TO_CHAR(dateexpiration, \'YYYY-MM-DD\')'), 'LIKE', $keyword)
                                 ->orWhere(DB::raw('TO_CHAR(datedeclaration, \'YYYY-MM-DD\')'), 'LIKE', $keyword);
                    });
                }
            });
        }

        // Filtrer par statut
        if ($statusFilter !== '') {
            $query->where('status', $statusFilter);
        }

        // Filtrer par date de demande
        if (!empty($startDate)) {
            $query->where('datedemande', '>=', $startDate);
        }
        if (!empty($endDate)) {
            $query->where('datedemande', '<=', $endDate);
        }

        // Filtrer par type de formulaire
        if (!empty($formType)) {
            $query->where('typedemande', 'ILIKE', '%' . $formType . '%');
        }

        // Filtrer par ville
        if (!empty($city)) {
            $query->where('nomville', 'ILIKE', '%' . $city . '%');
        }

        $query->orderBy('datedemande', 'desc');
        $demandes = $query->get();

        \Log::info('Demandes:', ['demandes' => $demandes->toArray()]);

        return response()->json($demandes);
    }





    public function getDemandesById($id, Request $request)
    {
        // Diviser les mots-clés par espaces et les préparer pour la recherche
        $keywords = explode(' ', $request->keyword);
        $statusFilter = $request->statusFilter;

        // Récupérer l'opérateur par id
        $operateur = DB::table('operateur')->where('id', $id)->first();

        if (!$operateur) {
            return response()->json(['message' => 'Opérateur non trouvé'], 404);
        }

        $idoperateur = $operateur->idoperateur;

        // Construire la requête pour récupérer les demandes par idoperateur
        $query = DB::table('demandedetails')->where('idoperateur', $idoperateur);

        // Si des mots-clés sont fournis, les appliquer
        if (!empty($keywords)) {
            $query->where(function($q) use ($keywords) {
                foreach ($keywords as $keyword) {
                    $keyword = '%' . $keyword . '%'; // Préparation pour le LIKE
                    $q->where(function($subQuery) use ($keyword) {
                        $subQuery->where('nomoperateur', 'ILIKE', $keyword)
                                ->orWhere('typedemande', 'ILIKE', $keyword)
                                ->orWhere('anneevalidite', 'ILIKE', $keyword)
                                ->orWhere('nomregime', 'ILIKE', $keyword)
                                ->orWhere('nomtypeformulaire', 'ILIKE', $keyword)
                                ->orWhere(DB::raw('TO_CHAR(datedemande, \'YYYY-MM-DD\')'), 'LIKE', $keyword);
                    });
                }
            });
        }

        // Filtrer par statut si fourni
        if ($statusFilter !== null && $statusFilter !== '' && $statusFilter !== 'all') {
            $query->where('status', $statusFilter);
        }

        // Ordonner par `datedemande` en descendant
        $query->orderBy('datedemande', 'desc');

        // Obtenir les résultats
        $demandes = $query->get();

        return response()->json($demandes);
    }



    public function getResponsesByDemande($idDemande)
    {

        $responses = DB::table('reponsedetails')
            ->where('iddemande', $idDemande)
            ->get();

        return response()->json($responses);
    }

    public function exportPdf($idDemande)
    {
        // Récupérer les réponses liées à la demande
        $responses = DB::table('reponsedetails')
            ->where('iddemande', $idDemande)
            ->get();

        if ($responses->isEmpty()) {
            return response()->json(['message' => 'Aucune donnée trouvée pour cette demande'], 404);
        }

        // Regrouper les réponses par catégorie
        $groupedResponses = $responses->groupBy('nomcategoriequestion');

        // Utiliser le nom de l'opérateur à partir de la première réponse
        $nomOperateur = $responses[0]->nomoperateur ?? 'Opérateur';

        // Nettoyer le nom de l'opérateur pour le rendre sûr pour un nom de fichier
        $nomOperateur = $this->sanitizeFileName($nomOperateur);

        // Générez le contenu HTML de la vue avec les données
        $html = View::make('pdf.reponsedetails')->with('groupedResponses', $groupedResponses)->render();

        // Créez un nouvel objet Dompdf
        $dompdf = new Dompdf();

        // Chargez le contenu HTML dans Dompdf
        $dompdf->loadHtml($html);

        // (Optionnel) Définir la taille du papier et l'orientation
        $dompdf->setPaper('A4', 'portrait');
        $dompdf->set_option('isHtml5ParserEnabled', true);

        // Rendez le document PDF
        $dompdf->render();

        // Générer un fichier temporaire pour stocker le PDF
        $filename = 'declaration_'.$nomOperateur.'.pdf';
        $pdfPath = storage_path('app/public/'.$filename);
        file_put_contents($pdfPath, $dompdf->output());

        // Retourner l'URL du PDF stocké
        return response()->json(url('storage/'.$filename));
    }

    private function sanitizeFileName($fileName)
    {
        // Remplace les accents et autres caractères spéciaux par leur équivalent non accentué
        $fileName = iconv('UTF-8', 'ASCII//TRANSLIT', $fileName);

        // Supprime tous les caractères non alphanumériques (y compris les espaces)
        return preg_replace('/[^A-Za-z0-9]/', '', $fileName);
    }



    public function accepterDemande($idDemande)
    {
        DB::beginTransaction();

        try {
            $demande = DB::table('demandedetails')
                ->where('iddemande', $idDemande)
                ->first();

            if (!$demande) {
                return response()->json(['error' => 'Demande non trouvée.'], 404);
            }

            // Mettre à jour le statut de la demande
            DB::table('demande')
                ->where('iddemande', $idDemande)
                ->update(['status' => 2]); // Statut 2 pour accepté

            // Envoyer un email de confirmation
            $email = $demande->email;
            Mail::to($email)->send(new DemandeAcceptedMail($demande));

            DB::commit();

            return response()->json(['message' => 'Demande acceptée et email envoyé avec succès.'], 200);

        } catch (\Exception $e) {
            DB::rollBack(); // Annuler la transaction en cas d'erreur
            return response()->json([
                'error' => 'Une erreur est survenue lors de l\'acceptation de la demande.',
                'details' => $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine()
            ], 500);
        }
    }

    public function refuserDemande($idDemande)
    {
        DB::beginTransaction();

        try {
            $demande = DB::table('demandedetails')
                ->where('iddemande', $idDemande)
                ->first();

            if (!$demande) {
                return response()->json(['error' => 'Demande non trouvée.'], 404);
            }

            // Mettre à jour le statut de la demande
            DB::table('demande')
                ->where('iddemande', $idDemande)
                ->update(['status' => 0]); // Statut 0 pour refuser

            // Envoyer un email de confirmation
            $email = $demande->email;
            Mail::to($email)->send(new DemandeRejectedMail($demande));

            DB::commit();

            return response()->json(['message' => 'Demande d\'information envoyée avec succès'], 200);

        } catch (\Exception $e) {
            DB::rollBack(); // Annuler la transaction en cas d'erreur
            return response()->json([
                'error' => 'Une erreur est survenue lors de la demande d\'information.',
                'details' => $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine()
            ], 500);
        }
    }

    public function sendInfoRequest(Request $request, $idDemande)
    {
        DB::beginTransaction();

        try {
            $validated = $request->validate([
                'message' => 'required|string',
            ]);

            $demande = DB::table('demandedetails')
                ->where('iddemande', $idDemande)
                ->first();

            if (!$demande) {
                return response()->json(['error' => 'Demande non trouvée.'], 404);
            }

            // Mettre à jour le statut de la demande
            DB::table('demande')
                ->where('iddemande', $idDemande)
                ->update(['status' => null]); // Statut null pour plus d'informations

            $email = $demande->email;
            $message = is_string($validated['message']) ? $validated['message'] : '';
            Mail::to($email)->send(new InfoRequestMail($demande, $message));


            DB::commit();

            return response()->json(['message' => 'Demande rejetée et email envoyé avec succès.'], 200);

        } catch (\Exception $e) {
            DB::rollBack(); // Annuler la transaction en cas d'erreur
            return response()->json([
                'error' => 'Une erreur est survenue lors de l\'acceptation de la demande.',
                'details' => $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine()
            ], 500);
        }
    }

    public function addDateDeclaration(Request $request, $id)
    {
        try {
            // Validation des données
            $data = $request->validate([
                'dateDeclaration' => 'required|date',
            ]);

            // Récupérer les détails de la demande depuis la vue 'demandedetails'
            $demandeDetails = DB::table('demandedetails')
                ->where('iddemande', $id)
                ->select('iddemande', 'anneevalidite')
                ->first();

            // Vérifier si la demande a été trouvée
            if (!$demandeDetails) {
                return response()->json([
                    'status' => 404,
                    'error' => 'Demande non trouvée dans la vue demandedetails.',
                ], 404);
            }

            // Récupérer l'année de validité depuis la vue 'demandedetails'
            $anneeValidite = $demandeDetails->anneevalidite;

            // Initialiser la variable 'dateexpiration'
            $dateexpiration = null;

            // Si 'anneevalidite' n'est pas null, calculer la date d'expiration
            if (!is_null($anneeValidite)) {
                $dateexpiration = date('Y-m-d', strtotime($data['dateDeclaration'] . " + $anneeValidite years"));
            }

            // Mise à jour de la demande dans la table 'demande'
            DB::table('demande')
                ->where('iddemande', $id)
                ->update([
                    'datedeclaration' => $data['dateDeclaration'],
                    'dateexpiration' => $dateexpiration,  // Peut être null si 'anneevalidite' est null
                ]);

            return response()->json([
                'message' => 'Demande mise à jour avec succès.',
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'status' => 500,
                'error' => 'Erreur lors de la mise à jour de la demande.',
                'message' => $e->getMessage()
            ], 500);
        }
    }

    public function addDocumentSupplementaire(Request $request, $idDemande)
    {
        try {
            // Validation des données
            $request->validate([
                'nomfichier' => 'required|string|max:200',
                'fichier' => 'required|file|mimes:pdf|max:4096', // fichier PDF max 2MB
            ]);

            // Récupérer le fichier depuis la requête
            $file = $request->file('fichier');
            $fileExtension = $file->getClientOriginalExtension(); // Obtenir l'extension du fichier
            $fileName = Str::uuid() . '.' . $fileExtension; // Générer un nom unique avec l'extension originale
            $filePath = 'public/documents_supplementaires/' . $fileName; // Définir le chemin complet du fichier

            // Déplacer le fichier dans le bon répertoire
            $file->move(storage_path('app/public/documents_supplementaires'), $fileName);

            // Créer l'URL pour accéder au fichier
            $fileUrl = 'storage/documents_supplementaires/' . $fileName;

            // Insertion dans la table documentSupplementaire
            DB::table('documentsupplementaire')->insert([
                'nom' => $request->input('nomfichier'),
                'iddemande' => $idDemande,
                'filereponse' => $fileUrl,
            ]);

            return response()->json([
                'message' => 'Document supplémentaire ajouté avec succès.',
                'fileUrl' => $fileUrl,
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'status' => 500,
                'error' => 'Erreur lors de l\'ajout du document supplémentaire.',
                'message' => $e->getMessage(),
            ], 500);
        }
    }

}
