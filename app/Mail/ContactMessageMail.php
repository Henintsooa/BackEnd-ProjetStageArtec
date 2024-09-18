<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class ContactMessageMail extends Mailable
{
    use Queueable, SerializesModels;

    public $nomoperateur;
    public $userName;
    public $userEmail;
    public $userMessage;

    public function __construct($nomoperateur, $userName, $userEmail, $userMessage)
    {
        $this->nomoperateur = $nomoperateur;
        $this->userName = $userName;
        $this->userEmail = $userEmail;
        $this->userMessage = $userMessage;
    }

    public function envelope(): Envelope
    {
        return new Envelope(
            subject: 'Demande d\'information de ' . $this->userName . ' venant de l\'opérateur ' . $this->nomoperateur,
            replyTo: $this->userEmail, // Définir l'adresse de réponse
        );
    }

    public function content(): Content
    {
        return new Content(
            view: 'Email.contactMessage',
        );
    }

    public function attachments(): array
    {
        return [];
    }
}
