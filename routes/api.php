<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\MailController;
use App\Http\Controllers\Api\PasswordResetRequestController;
use App\Http\Controllers\Api\ChangePasswordController;
use App\Http\Controllers\Api\VilleController;
use App\Http\Controllers\Api\RegimeController;
use App\Http\Controllers\Api\StructureJuridiqueController;
use App\Http\Controllers\Api\FormulaireController;
use App\Http\Controllers\Api\SensibilisationController;
use App\Http\Controllers\Api\DemandeController;
use App\Http\Controllers\Api\DashboardController;
use App\Http\Controllers\Api\RenewalController;
use App\Http\Controllers\Api\ContactController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

// Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
//     return $request->user();
// });


Route::get('/villes', [VilleController::class, 'index']);
Route::get('/regimes', [RegimeController::class, 'index']);
Route::get('/structuresJuridiques', [StructureJuridiqueController::class, 'index']);

Route::post('/resetPassword', [ChangePasswordController::class, 'passwordResetProcess']);
Route::post('/sendPasswordResetLink', [PasswordResetRequestController::class, 'sendEmail']);
Route::post('/sendEmail', [MailController::class, 'sendEmail']);

Route::post('/login', [AuthController::class, 'login']);
Route::post('/register', [AuthController::class, 'register']);
Route::get('/formulaire/types', [FormulaireController::class, 'getTypeFormulaireDetails']);
Route::get('/formulaire/type/{idTypeFormulaire}', [FormulaireController::class, 'getFormulaireByType']);

Route::get('/type-questions', [FormulaireController::class, 'getTypeQuestions']);
Route::get('/categories-questions', [FormulaireController::class, 'getCategoriesQuestions']);
Route::post('/addCategory', [FormulaireController::class, 'addCategory']);
Route::post('/addFormulaire', [FormulaireController::class, 'addFormulaire']);
Route::delete('/formulaires/{id}', [FormulaireController::class, 'supprimerFormulaire']);
Route::get('/formulaires/{id}', [FormulaireController::class, 'getFormulaireById']);
Route::post('/editFormulaire/{idTypeFormulaire}', [FormulaireController::class, 'editFormulaire']);


Route::post('/addOperateurCible', [SensibilisationController::class, 'addOperateurCible']);
Route::get('/operateurCibles', [SensibilisationController::class, 'operateurCibles']);
Route::get('/getOperateursHistorique', [SensibilisationController::class, 'operateurCiblesHistorique']);
Route::delete('/operateurCible/{id}', [SensibilisationController::class, 'supprimerOperateurCible']);
Route::post('/editOperateurCible/{id}', [SensibilisationController::class, 'editOperateurCible']);
Route::get('/operateurCibleById/{id}', [SensibilisationController::class, 'operateurCibleById']);
Route::post('/sendEmailSensibilisation', [SensibilisationController::class, 'sendEmailSensibilisation']);
Route::post('/convertirOperateur', [SensibilisationController::class, 'updateOrInsertSensibilisation']);
Route::get('/getOperateurs', [SensibilisationController::class, 'getOperateurs']);
Route::get('/getOperateurCibles', [SensibilisationController::class, 'getOperateurCibles']);


Route::post('/demande', [DemandeController::class, 'store']);
Route::get('/getDemandes', [DemandeController::class, 'getDemandes']);
Route::get('/reponses/{id}', [DemandeController::class, 'getResponsesByDemande']);
Route::get('/exportPdf/{id}', [DemandeController::class, 'exportPdf']);
Route::get('/getDemandes/{id}', [DemandeController::class, 'getDemandesById']);
Route::get('/getReponsesIdRenouvellement/{id}', [DemandeController::class, 'getFormulaireByIdRenouvellement']);



Route::post('/accepterDemande/{id}', [DemandeController::class, 'accepterDemande']);
Route::post('/refuserDemande/{id}', [DemandeController::class, 'refuserDemande']);
Route::post('/demandes/{iddemande}/info-request', [DemandeController::class, 'sendInfoRequest']);
Route::post('/addDateDeclaration/{iddemande}', [DemandeController::class, 'addDateDeclaration']);
Route::get('/documents-complementaires/{idDemande}', [DemandeController::class, 'getDocumentsComplementaires']);
Route::post('/addDocumentSupplementaire/{iddemande}', [DemandeController::class, 'addDocumentSupplementaire']);
Route::post('/updateDocumentSupplementaire', [DemandeController::class, 'updateDocumentSupplementaire']);
Route::get('/documents/{idDemande}', [DemandeController::class, 'getDocumentsById']);



Route::get('/statistics', [DashboardController::class, 'getStatistics']);
Route::get('/demandesParRegion', [DashboardController::class, 'getDemandesValideesParRegion']);
Route::get('/demandesParRegime', [DashboardController::class, 'getDemandesValideesParRegime']);
Route::get('/demandesParTypeFormulaire', [DashboardController::class, 'getDemandesValideesParTypeFormulaire']);
Route::get('/KPIDeclarationSensibilisation', [DashboardController::class, 'getKPIDeclarationSensibilisation']);

Route::post('/check-renewals', [RenewalController::class, 'checkRenewals']);
Route::get('/renouvellements', [RenewalController::class, 'getRenouvellements']);
Route::post('/notifierOperateur', [RenewalController::class, 'notifierOperateurs']);
Route::get('/renouvellements/{id}', [RenewalController::class, 'getRenouvellementsById']);

Route::post('/contact', [ContactController::class, 'sendContactMessage']);

Route::get('/operateur/{id}', [DemandeController::class, 'getOperateur']);

Route::get('/emails', [ContactController::class, 'getAllAdminEmails']);


Route::middleware('auth:api')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout'])->name('logout');
    Route::get('/notifications', [DemandeController::class, 'getNotifications']);
    Route::post('/notifications/{id}/read', [DemandeController::class, 'markNotificationAsRead']);
});

