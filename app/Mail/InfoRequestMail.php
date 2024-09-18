<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class InfoRequestMail extends Mailable
{
    use Queueable, SerializesModels;

    public $demande;
    public $infoMessage;

    public function __construct($demande, $infoMessage)
    {
        $this->demande = $demande;
        $this->infoMessage = $infoMessage;
    }

    public function envelope(): Envelope
    {
        return new Envelope(
            subject: 'Demande d\'information supplémentaire',
        );
    }

    public function content(): Content
    {
        return new Content(
            view: 'Email.informationRequest',
        );
    }

    public function attachments(): array
    {
        return [];
    }
}

