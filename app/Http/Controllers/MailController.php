<?php

namespace App\Http\Controllers;
use App\Mail\SendMail;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;

class MailController extends Controller
{
    public function sendEmail(Request $request)
    {
        $title = 'Merci pour votre commande';
        $user = [
            'name' => $request->name,
            'email' => $request->email
        ];

        try {
            // Envoi de l'email
            Mail::to($user['email'])->send(new SendMail($title, $user));
            return response()->json(['message' => 'Email envoyé'], 200);
        } catch (\Exception $e) {
            // Gestion des exceptions
            return response()->json(['message' => 'Email non envoyé', 'error' => $e->getMessage()], 400);
        }
    }
}
