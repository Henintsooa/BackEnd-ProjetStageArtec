<?php

namespace App\Console\Commands;


use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Notification;
use App\Notifications\RenewalNotification;
use Carbon\Carbon;
use Illuminate\Support\Facades\Log;

class CheckRenewals extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'check-renewals';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Command description';

    /**
     * Execute the console command.
     */
    // public function handle()
    // {
    //     $today = Carbon::now()->format('Y-m-d');

    //     // Trouver les renouvellements dont dateenvoi est aujourd'hui
    //     $renewals = DB::table('renouvellement')
    //         ->whereDate('dateenvoi', $today)
    //         ->get();

    //     if ($renewals->isEmpty()) {
    //         $this->info('No renewals to process today.');
    //         return;
    //     }

    //     $this->info('Processing renewals for today.');

    //     // Obtenir tous les administrateurs
    //     $administrateurs = DB::table('users')
    //         ->where('status', 'admin')
    //         ->get();

    //     foreach ($renewals as $renewal) {
    //         $details = DB::table('demandedetails')
    //         ->where('iddemande', $renewal->iddemande)
    //         ->first();

    //         foreach ($administrateurs as $admin) {
    //             // Créer un enregistrement de notification pour chaque admin
    //             DB::table('notifications')->insertGetId([
    //                 'id' => $admin->id, // ID de l'administrateur
    //                 'message' => "L'opérateur {$details->nomoperateur} doit renouveler le formulaire '{$details->nomtypeformulaire}' avant le {$details->dateexpiration}.",
    //                 'type' => 'Renouvellement',
    //                 'lue' => false,
    //                 'iddemande' => $renewal->iddemande,
    //                 'renouvellement' => true,
    //                 'created_at' => now(),
    //                 'updated_at' => now(),
    //             ]);

    //             // Envoyer la notification par email à l'admin
    //             Notification::route('mail', $admin->email)
    //                         ->notify(new RenewalNotification($details));
    //         }
    //     }

    //     $this->info('Renewal notifications have been sent and records have been updated.');
    //     Log::info('check-renewals command executed successfully.');
    // }

    public function handle()
    {
        $today = Carbon::now();
        $twoYearsBeforeExpiry = $today->copy()->addYears(2)->format('Y-m-d');

        // Query to find records where the expiration date is 2 years away
        $renewals = DB::table('demandedetails')
            ->whereDate('dateexpiration', $twoYearsBeforeExpiry)
            ->get();
        $this->info('Two years before expiry: ' . $twoYearsBeforeExpiry);
        $this->info('Renewals found: ' . $renewals->count());

        // Get all admin users
        $administrateurs = DB::table('users')
            ->where('status', 'admin')
            ->get();

        foreach ($renewals as $renewal) {
            // Convert dateexpiration to a Carbon instance
            $dateExpiration = Carbon::parse($renewal->dateexpiration);

            // Create renewal records
            DB::table('renouvellement')->insert([
                'idoperateur' => $renewal->idoperateur,
                'iddemande' => $renewal->iddemande,
                'idtypeformulaire' => $renewal->idtypeformulaire,
                'created_at' => now(),
            ]);

            foreach ($administrateurs as $admin) {
                $notificationId = DB::table('notifications')->insertGetId([
                    'id' => $admin->id, // ID de l'administrateur
                    'message' => "L'opérateur {$renewal->nomoperateur} doit renouveler le formulaire '{$renewal->nomtypeformulaire}' avant le {$dateExpiration->format('d/m/Y')}.",
                    'type' => 'Renouvellement',
                    'lue' => false,
                    'iddemande' => $renewal->iddemande,
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);

                // Send the notification to the admin
                Notification::route('mail', $admin->email)
                            ->notify(new RenewalNotification($renewal));
            }
        }

        $this->info('Renewal notifications have been sent and records have been updated.');
        Log::info('check-renewals command executed successfully.');
    }
}
