<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

use App\Http\Requests\UpdatePasswordRequest;
use Symfony\Component\HttpFoundation\Response;
use Illuminate\Support\Facades\DB;
use App\Models\User;
use Illuminate\Support\Facades\Log;


class ChangePasswordController extends Controller
{
    public function passwordResetProcess(Request $request)
{
    try {
        // Validation des entrées
        $validated = $request->validate([
            'email' => 'required|email',
            'resetToken' => 'required|string',
            'password' => [
                'required',
                'string',
                'min:8',
                'confirmed',
                'regex:/[a-z]/',
                'regex:/[A-Z]/',
                'regex:/[0-9]/',
                'regex:/[@$!%*?&.,;:]/'
            ],
            'password_confirmation' => 'required|string|min:8'
        ],[
            'password.min' => 'Le mot de passe doit comporter au moins 8 caractères.',
            'password.regex' => 'Le mot de passe doit contenir au moins une lettre majuscule, une lettre minuscule, un chiffre et un caractère spécial.',
            'password_confirmation.required' => 'La confirmation du mot de passe est requise.',
        ]);

        Log::info('Validation passed.');
        Log::info('Validated Data:', $validated);

        if ($this->updatePasswordRow($request)) {
            Log::info('Password updated successfully.');
            return $this->resetPassword($request);
        } else {
            Log::warning('Token not found or password update failed.');
            return $this->tokenNotFoundError();
        }
    } catch (\Illuminate\Validation\ValidationException $e) {
        Log::error('Validation failed:', $e->errors());
        return response()->json(['message' => 'Validation failed', 'errors' => $e->errors()], 422);
    }
}

    //verifie si token est valide
    private function updatePasswordRow($request)
    {
        $exists = DB::table('password_reset_tokens')->where([
            'email' => $request->email,
            'token' => $request->resetToken
        ])->exists();

        // Log pour debugging
        \Log::info('Token existe: ' . ($exists ? 'oui' : 'non'));

        return $exists;
    }


    //renvoie un token invalide
    private function tokenNotFoundError()
    {
        return response()->json([
            'message' => 'Token invalide'
        ], Response::HTTP_UNPROCESSABLE_ENTITY);
    }

    //reset mot de passe
    private function resetPassword($request)
    {
        $userData = User::whereEmail($request->email)->first();

        if ($userData) {
            $userData->update(['password' => bcrypt($request->password)]);
            DB::table('password_reset_tokens')->where(['email' => $request->email])->delete();

            return response()->json([
                'message' => 'Mot de passe réinitialisé avec succès'
            ], Response::HTTP_CREATED);
        } else {
            return response()->json([
                'message' => 'Utilisateur non trouvé'
            ], Response::HTTP_NOT_FOUND);
        }
    }
}
