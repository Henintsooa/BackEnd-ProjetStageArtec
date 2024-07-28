<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use App\Models\User;
use App\Mail\SendMailreset;
use Illuminate\Support\Facades\Mail;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class PasswordResetRequestController extends Controller
{
    public function sendEmail(Request $request)
    {
        if(!$this->validateEmail($request->email))
        {
            return $this->failedResponse();
        }
        $this->send($request->email);
        return $this->successResponse();
    }

    public function send($email)
    {
        $token = $this->createToken($email);
        Mail::to($email)->send(new SendMailreset($token, $email));
    }

    public function createToken($email)
    {
        $oldtoken = DB::table('password_reset_tokens')->where('email', $email)->first();
        if ($oldtoken) {
            return $oldtoken->token;
        }
        $token = Str::random(60);
        $this->saveToken($token, $email);
        return $token;
    }

    public function saveToken($token,$email)
    {
        DB::table('password_reset_tokens')->insert([
            'email' => $email,
            'token' => $token,
            'created_at' => Carbon::now()
        ]);
    }

    public function validateEmail($email)
    {
        return !!User::where('email', $email)->first();
    }
    public function failedResponse()
    {
        return response()->json([
            'error' => 'Cet Email n\'existe pas'
        ],404);
    }
    public function successResponse()
    {
        return response()->json([
            'message' => 'Email envoyé'
        ],200);
    }
}
