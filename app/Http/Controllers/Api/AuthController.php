<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\DB;
use App\Models\User;
use App\Models\Operateur;
use JWTAuth;
use Auth;
use Tymon\JWTAuth\Exceptions\JWTException;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $data = $request->validate([
            'name' => 'required|string',
            'email' => 'required|email|unique:users,email',
            'password' => [
            'required',
            'confirmed',
            'string',
            'min:8',
            'regex:/[a-z]/',
            'regex:/[A-Z]/',
            'regex:/[0-9]/',
            'regex:/[@$!%*?&.,;:]/'
            ],
            'password_confirmation' => 'required|string|min:8|same:password'
        ], [
            'name.required' => 'Le nom est requis.',
            'name.string' => 'Le nom doit être une chaîne de caractères.',
            'name.max' => 'Le nom ne peut pas dépasser 255 caractères.',

            'email.required' => 'L\'email est requis.',
            'email.email' => 'L\'email doit être une adresse email valide.',
            'email.unique' => 'Cet email est déjà utilisé.',

            'password.required' => 'Le mot de passe est requis.',
            'password.confirmed' => 'Les mots de passe ne correspondent pas.',
            'password.string' => 'Le mot de passe doit être une chaîne de caractères.',
            'password.min' => 'Le mot de passe doit comporter au moins 8 caractères.',
            'password.regex' => 'Le mot de passe doit contenir au moins une lettre majuscule, une lettre minuscule, un chiffre et un caractère spécial.',

            'password_confirmation.required' => 'La confirmation du mot de passe est requise.',
            'password_confirmation.string' => 'La confirmation du mot de passe doit être une chaîne de caractères.',
            'password_confirmation.min' => 'La confirmation du mot de passe doit comporter au moins 8 caractères.',
        ]);

        DB::beginTransaction();

        try {
            $data['password'] = Hash::make($request->password);
            $user = User::create($data);

            $this->createOperateur($request, $user);

            DB::commit();

            return response()->json([
                'status' => 201,
                'data' => $data
            ]);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'status' => 500,
                'error' => 'Erreur lors de la création de l\'utilisateur ou de l\'opérateur.',
                'message' => $e->getMessage()
            ], 500);
        }
    }

    private function createOperateur(Request $request, User $user)
    {
        $data = $request->validate([
            'nom' => 'required|string',
            'adresse' => 'required|string',
            'idville' => 'required|integer|exists:ville,idville',
            'telephone' => 'required|string',
            'telecopie' => 'nullable|string'
        ], [
            'nom.required' => 'Le nom de l\'opérateur est requis.',

            'adresse.required' => 'L\'adresse de l\'opérateur est requise.',

            'idville.required' => 'La ville de l\'opérateur est requise.',

            'telephone.required' => 'Le numéro de téléphone de l\'opérateur est requis.',
        ]);

        DB::table('operateur')->insert([
            'id' => $user->id,
            'nom' => $data['nom'],
            'adresse' => $data['adresse'],
            'idville' => $data['idville'],
            'telephone' => $data['telephone'],
            'telecopie' => $data['telecopie'],
            'email' => $user->email,
        ]);
    }

    public function login(Request $request)
    {
        // Valider les données de la requête
        $data = $request->validate([
            'email' => 'required|email',
            'password' => 'required'
        ]);

        try {
            // authentifier l'utilisateur et générer le token
            if (!$token = JWTAuth::attempt($data)) {
                // Vérifier si l'email existe
                $user = \App\Models\User::where('email', $data['email'])->first();
                if ($user) {
                    // Si l'utilisateur existe, l'erreur est probablement due au mot de passe
                    return response()->json([
                        'status' => false,
                        'message' => 'Mot de passe incorrect',
                        'token' => null
                    ], 401);
                } else {
                    // Si l'utilisateur n'existe pas, l'erreur est probablement due à l'email
                    return response()->json([
                        'status' => false,
                        'message' => 'Email non trouvé',
                        'token' => null
                    ], 401);
                }
            }

            // Récupérer les informations de l'utilisateur connecté
            $user = JWTAuth::setToken($token)->authenticate();

            // Déterminer le rôle de l'utilisateur
            $role = $user->status;

            // Retourner les informations de l'utilisateur et son rôle
            return response()->json([
                'status' => 200,
                'token' => $token,
                'user' => $user,
                'role' => $role // Inclure le rôle dans la réponse
            ]);
        } catch (JWTException $e) {
            // les erreurs liées au token
            return response()->json([
                'status' => false,
                'message' => 'Could not create token',
                'token' => null
            ], 500);
        }
    }



    public function logout()
    {
        Auth::logout();
        return response()->json([
            'status' => true,
            "message" => "profil déconnecté",
        ]);
    }

    public function refresh()
    {
        $newToken = Auth::refresh();
        return response()->json([
            'status' => true,
            "token" => $newToken
        ]);
    }
}
