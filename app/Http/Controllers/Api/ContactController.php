<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\DB;
use App\Mail\ContactMessageMail;


class ContactController extends Controller
{
    public function sendContactMessage(Request $request)
    {
        try {
            $validatedData = $request->validate([
                'email' => 'required|email',
                'name' => 'required|string',
                'message' => 'required|string',
                'id' => 'required|integer|exists:users,id',
            ]);

            $operateur = DB::table('operateur')
                ->where('id', $validatedData['id'])
                ->first();

            if (!$operateur) {
                return response()->json(['message' => 'Opérateur introuvable'], 404);
            }

            $administrateurs = DB::table('users')
                ->where('status', 'admin')
                ->get();

            foreach ($administrateurs as $admin) {
                Mail::to($admin->email)->send(new ContactMessageMail(
                    $operateur->nom,
                    $validatedData['name'],
                    $validatedData['email'],
                    $validatedData['message']
                ));
            }

            return response()->json(['message' => 'Message envoyé avec succès, vous recevrez une reponse dans les plus brefs delés'], 200);

        } catch (\Exception $e) {
            return response()->json(['message' => 'Erreur lors de l\'envoi du message', 'error' => $e->getMessage()], 500);
        }
    }

    public function getAllAdminEmails()
    {
        try {
            // Sélectionner tous les utilisateurs ayant le statut 'admin'
            $emails = DB::table('users')
                ->where('status', 'admin')
                ->pluck('email');

            return response()->json(['emails' => $emails], 200);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Erreur lors de la récupération des emails', 'error' => $e->getMessage()], 500);
        }
    }

}
