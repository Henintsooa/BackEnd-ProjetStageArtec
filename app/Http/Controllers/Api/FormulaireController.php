<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Ville;
use App\Models\TypeFormulaire;
use App\Models\TypeFormulaireDetails;
use App\Models\FormulaireDetails;
use App\Models\Formulaire;
use Illuminate\Support\Facades\DB;
use App\Models\TypeQuestion;
use App\Models\Question;
use App\Models\CategorieQuestion;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Log;

class FormulaireController extends Controller
{
    public function getTypeFormulaireDetails()
    {
        $typeFormulaire = TypeFormulaireDetails::where('status', 0)->get();
        return response()->json($typeFormulaire);

    }

    public function getFormulaireByType($idTypeFormulaire)
    {
        $lastFormulaire = Formulaire::where('idtypeformulaire', $idTypeFormulaire)
        ->orderBy('idformulaire', 'desc')
        ->first();

    if ($lastFormulaire) {
        $formulaireDetails = FormulaireDetails::where('idformulaire', $lastFormulaire->idformulaire)
            ->get();

        return response()->json($formulaireDetails);
    } else {
        return response()->json(['message' => 'Aucun formulaire trouvé pour ce type'], 404);
    }
    }

    // Exemple de méthode dans un contrôleur Laravel
    public function getCategories() {
        $categories = DB::table('categoriequestion')->get();
        return response()->json($categories);
    }

    public function getTypeQuestions()
    {
        $types = TypeQuestion::all();
        return response()->json($types);
    }

    public function getCategoriesQuestions()
    {
        $categories = CategorieQuestion::all();
        return response()->json($categories);
    }

    public function addCategory(Request $request)
    {
        $request->validate([
            'nom' => 'required|string|max:255',
            'nombrereponses' => 'integer',
        ]);

        $category = CategorieQuestion::create([
            'nom' => $request->nom,
            'nombrereponses' => $request->nombreReponses ?? 1,
        ]);

        // Retourner la réponse en format JSON
        return response()->json($category, 201);
    }

    public function addFormulaire(Request $request)
    {
        try {

            $request->validate([
                'type_formulaire_nom' => 'required|string|max:255',
                'description' => 'string|max:255',
                'nom_formulaire' => 'required|string|max:255',
                'date_creation' => 'date',
                'questions' => 'required|array',
                'questions.*.text' => 'required|string|max:255',
                'questions.*.type' => 'required|integer|exists:typequestion,idtypequestion',
                'questions.*.obligatoire' => 'boolean',
                'questions.*.categorie_id' => 'required|integer|exists:categoriequestion,idcategoriequestion',
                'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            ], [
                'type_formulaire_nom.required' => 'Le nom du type de formulaire est obligatoire.',
                'type_formulaire_nom.string' => 'Le nom du type de formulaire doit être une chaîne de caractères.',
                'description.string' => 'La description doit être une chaîne de caractères.',
                'nom_formulaire.required' => 'Le nom du formulaire est obligatoire.',
                'nom_formulaire.string' => 'Le nom du formulaire doit être une chaîne de caractères.',
                'date_creation.date' => 'La date de création doit être une date valide.',
                'questions.required' => 'Vous devez fournir au moins une question.',
                'questions.array' => 'Les questions doivent être fournies sous forme de tableau.',
                'questions.*.text.required' => 'Le texte de la question est obligatoire.',
                'questions.*.text.string' => 'Le texte de la question doit être une chaîne de caractères.',
                'questions.*.text.max' => 'Le texte de la question ne peut pas dépasser 255 caractères.',
                'questions.*.type.required' => 'Le type de question est obligatoire.',
                'questions.*.type.integer' => 'Le type de question doit être un entier.',
                'questions.*.type.exists' => 'Le type de question sélectionné est invalide.',
                'questions.*.categorie_id.required' => 'La catégorie de la question est obligatoire.',
                'questions.*.categorie_id.integer' => 'La catégorie de la question doit être un entier.',
                'questions.*.categorie_id.exists' => 'La catégorie de la question sélectionnée est invalide.',
            ]);

            $imagePath = null;
            if ($request->hasFile('image')) {
                $image = $request->file('image');
                $imageName = $image->getClientOriginalName();
                $imagePath = $image->storeAs('public/img', $imageName);
                $imagePath = str_replace('public/', 'storage/', $imagePath);
                \Log::info('Fichier reçu:', ['name' => $image->getClientOriginalName(), 'size' => $image->getSize()]);
            }else{
                \Log::info('Aucun fichier reçu');
            }

            // Vérifiez si le type de formulaire existe déjà
            $typeFormulaire = TypeFormulaire::where('nom', $request->type_formulaire_nom)->first();

            // Créez un nouveau type de formulaire si nécessaire
            if ($typeFormulaire) {
                if ($typeFormulaire->status == 1) {
                    $typeFormulaire->status = 0;
                    $typeFormulaire->save();
                }
            } else {
                // Créez un nouveau type de formulaire si nécessaire
                $typeFormulaire = TypeFormulaire::create([
                    'nom' => $request->type_formulaire_nom,
                    'description' => $request->description,
                    'status' =>  0,
                    'image' => $imagePath
                ]);
            }

            // Créer un nouveau formulaire
            $formulaire = Formulaire::create([
                'idtypeformulaire' => $typeFormulaire->idtypeformulaire,
                'nom' => $request->nom_formulaire,
                'datecreation' => now(),
            ]);

            // Insérer les questions associées
            foreach ($request->questions as $question) {
                Question::create([
                    'idformulaire' => $formulaire->idformulaire,
                    'textquestion' => $question['text'],
                    'idtypequestion' => $question['type'],
                    'questionobligatoire' => $question['obligatoire'] ?? false,
                    'idcategoriequestion' => $question['categorie_id'],
                ]);
            }

            return response()->json([
                'message' => 'Formulaire créé avec succès !',
                'image_url' => $imagePath ? Storage::url($imagePath) : null
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'status' => 500,
                'error' => 'Erreur lors de la création du formulaire',
                'message' => $e->getMessage()
            ], 500);
        }
    }

    public function supprimerFormulaire($id)
    {
        try {
            $formulaire = TypeFormulaire::find($id);

            if ($formulaire) {
                $formulaire->status = 1;
                $formulaire->save();

                return response()->json(['message' => 'Formulaire supprimé avec succès.']);
            } else {
                return response()->json(['message' => 'Formulaire non trouvé.'], 404);
            }
        } catch (\Exception $e) {
            return response()->json(['error' => 'Erreur lors de la suppression du formulaire.', 'details' => $e->getMessage()], 500);
        }
    }

    public function getFormulaireById($idTypeFormulaire)
    {
        try {
            // Récupération du dernier formulaire pour le type spécifié
            $lastFormulaire = FormulaireDetails::where('idtypeformulaire', $idTypeFormulaire)
                ->orderBy('idformulaire', 'desc')
                ->first();


            if ($lastFormulaire) {
                // Récupération des détails du formulaire
                $formulaireDetails = FormulaireDetails::where('idformulaire', $lastFormulaire->idformulaire)
                    ->get();

                if ($formulaireDetails->isEmpty()) {
                    return response()->json(['message' => 'Aucun détail trouvé pour ce formulaire'], 404);
                }

                // Construction de la réponse
                $response = [
                    'idformulaire' => $lastFormulaire->idformulaire,
                    'nomformulaire' => $lastFormulaire->nomformulaire,
                    'datecreation' => $lastFormulaire->datecreation,
                    'idtypeformulaire' => $lastFormulaire->idtypeformulaire,
                    'nomtypeformulaire' => $lastFormulaire->nomtypeformulaire,
                    'descriptiontypeformulaire' => $lastFormulaire->descriptiontypeformulaire,
                    'image' => $lastFormulaire->image,
                    'questions' => $formulaireDetails->map(function ($detail) {
                        return [
                            'idquestion' => $detail->idquestion,
                            'textquestion' => $detail->textquestion,
                            'idtypequestion' => $detail->idtypequestion,
                            'typequestion' => $detail->typequestion,
                            'designationtypequestion' => $detail->designationtypequestion,
                            'questionobligatoire' => $detail->questionobligatoire,
                            'categoriequestion' => $detail->categoriequestion,
                            'idcategoriequestion' => $detail->idcategoriequestion,
                            'nombrereponses' => $detail->nombrereponses
                        ];
                    })
                ];

                return response()->json($response, 200);
            } else {
                return response()->json(['message' => 'Aucun formulaire trouvé pour ce type'], 404);
            }

        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Erreur lors de la récupération des détails du formulaire',
                'details' => $e->getMessage()
            ], 500);
        }
    }


    public function editFormulaire(Request $request, $idTypeFormulaire)
    {
        $this->validate($request, [
            'type_formulaire_nom' => 'required|string|max:255',
            'description' => 'string|max:255',
            'nom_formulaire' => 'required|string|max:255',
            'questions' => 'required|array',
            'questions.*.text' => 'required|string|max:255',
            'questions.*.type' => 'required|integer|exists:typequestion,idtypequestion',
            'questions.*.obligatoire' => 'boolean',
            'questions.*.categorie_id' => 'required|integer|exists:categoriequestion,idcategoriequestion',
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        try {
            DB::beginTransaction();

            // Mise à jour du type de formulaire
            $typeFormulaire = TypeFormulaire::findOrFail($idTypeFormulaire);
            $typeFormulaire->update([
                'nom' => $request->type_formulaire_nom,
                'description' => $request->description,
            ]);

            // Gestion de l'image si fournie
            $imagePath = $typeFormulaire->image; // Chemin actuel de l'image
            if ($request->hasFile('image')) {
                // Supprimer l'ancienne image si elle existe
                if ($imagePath && Storage::exists('public/' . $imagePath)) {
                    Storage::delete('public/' . $imagePath);
                }

                $image = $request->file('image');
                $imageName = $image->getClientOriginalName();
                $imagePath = $image->storeAs('public/img', $imageName);
                $imagePath = str_replace('public/', 'storage/', $imagePath);

                \Log::info('Image uploadée:', ['name' => $imageName, 'path' => $imagePath]);

            } else {
                \Log::info('Aucune image reçue pour le formulaire');
            }

            $typeFormulaire->image = $imagePath; // Mettre à jour le chemin de l'image
            $typeFormulaire->save();

            // Création ou mise à jour du formulaire
            $formulaire = Formulaire::updateOrCreate(
                ['idformulaire' => $request->idformulaire],
                [
                    'idtypeformulaire' => $idTypeFormulaire,
                    'nom' => $request->nom_formulaire,
                    'datecreation' => now(),
                    'status' => 0,
                ]
            );

            // Suppression des anciennes questions associées si nécessaire
            Question::where('idformulaire', $formulaire->idformulaire)->delete();

            // Ajout des nouvelles questions
            foreach ($request->questions as $question) {
                Question::create([
                    'idformulaire' => $formulaire->idformulaire,
                    'textquestion' => $question['text'],
                    'idtypequestion' => $question['type'],
                    'questionobligatoire' => $question['obligatoire'] ?? false,
                    'idcategoriequestion' => $question['categorie_id'],
                ]);
            }

            DB::commit();

            return response()->json(['message' => 'Formulaire modifié avec succès !'], 200);

        } catch (ValidationException $e) {
            DB::rollBack();
            return response()->json([
                'error' => 'Erreur de validation',
                'details' => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'error' => 'Erreur lors de la modification du formulaire',
                'details' => $e->getMessage()
            ], 500);
        }
    }


}
