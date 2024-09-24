<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class DemandeRejectedMail extends Mailable
{
    use Queueable, SerializesModels;

    public $demande;
    public $motifRefus;

    /**
     * Create a new message instance.
     *
     * @param $demande
     * @return void
     */
    public function __construct($demande, $motifRefus)
    {
        $this->demande = $demande;
        $this->motifRefus = $motifRefus;
    }

    /**
     * Get the message envelope.
     */
    public function envelope(): Envelope
    {
        return new Envelope(
            subject: 'Demande de déclaration au près de l\'ARTEC',
        );
    }

    /**
     * Get the message content definition.
     */
    public function content(): Content
    {
        return new Content(
            view: 'Email.demandeRefuse',
        );
    }

    /**
     * Get the attachments for the message.
     *
     * @return array<int, \Illuminate\Mail\Mailables\Attachment>
     */
    public function attachments(): array
    {
        return [];
    }
}
