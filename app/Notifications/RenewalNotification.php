<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;
use Carbon\Carbon;
class RenewalNotification extends Notification
{
    use Queueable;
    protected $renewal;
    /**
     * Create a new notification instance.
     */
    public function __construct($renewal)
    {
        $this->renewal = $renewal;
    }

    /**
     * Get the notification's delivery channels.
     *
     * @return array<int, string>
     */
    public function via(object $notifiable): array
    {
        return ['mail'];
    }

    /**
     * Get the mail representation of the notification.
     */
    public function toMail(object $notifiable): MailMessage
    {
        // Convertir dateexpiration en instance de Carbon
        $dateExpiration = Carbon::parse($this->renewal->dateexpiration);

        // Utiliser une vue Blade pour personnaliser l'email
        return (new MailMessage)
            ->subject('Renouvellement de Formulaire - Action requise')
            ->view('Email.renewalNotification', ['renewal' => $this->renewal]);
    }


    /**
     * Get the array representation of the notification.
     *
     * @return array<string, mixed>
     */
    public function toArray(object $notifiable): array
    {
        return [
            //
        ];
    }
}
