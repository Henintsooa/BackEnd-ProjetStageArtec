<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\MailController;
use App\Http\Controllers\Api\PasswordResetRequestController;
use App\Http\Controllers\Api\ChangePasswordController;
use App\Http\Controllers\Api\VilleController;
use App\Http\Controllers\Api\FormulaireController;
use App\Http\Controllers\Api\SensibilisationController;
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
Route::delete('/operateurCible/{id}', [SensibilisationController::class, 'supprimerOperateurCible']);
Route::post('/editOperateurCible/{id}', [SensibilisationController::class, 'editOperateurCible']);
Route::get('/operateurCibleById/{id}', [SensibilisationController::class, 'operateurCibleById']);
Route::post('/sendEmailSensibilisation', [SensibilisationController::class, 'sendEmailSensibilisation']);
Route::post('/convertirOperateur', [SensibilisationController::class, 'updateOrInsertSensibilisation']);
Route::get('/getOperateurs', [SensibilisationController::class, 'getOperateurs']);
Route::get('/getOperateurCibles', [SensibilisationController::class, 'getOperateurCibles']);

Route::middleware('auth:api')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout'])->name('logout');


});
