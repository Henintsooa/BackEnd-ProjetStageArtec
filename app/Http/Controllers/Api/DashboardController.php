<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;


class DashboardController extends Controller
{
    public function getStatistics(Request $request)
    {
        $totalDemandes = DB::table('demande')->count();
        $validees = DB::table('demande')->where('status', 2)->count();
        $refusees = DB::table('demande')->where('status', 0)->count();
        $enattenteinfo = DB::table('demande')->whereNull('status')->count();
        $enattente = DB::table('demande')->where('status',1)->count();
        $sensibilises = DB::table('sensibilisation')->whereNotNull('datesensibilisation')->count();
        $convertis = DB::table('sensibilisation')->where('status', 1)->count();
        $operateurs = DB::table('operateur')->count();

        $sansSensibilisation = DB::table('demandedetails')
        ->where('status', 2)
        ->whereNotIn('idoperateur', function($query) {
            $query->select('idoperateur')
                ->from('sensibilisation')
                ->whereNotNull('idoperateur');
        })
        ->count();


        return response()->json([
            'totalDemandes' => $totalDemandes,
            'validees' => $validees,
            'refusees' => $refusees,
            'sensibilises' => $sensibilises,
            'convertis' => $convertis,
            'operateurs' => $operateurs,
            'enattenteinfo' => $enattenteinfo,
            'enattente' => $enattente,
            'sansSensibilisation' => $sansSensibilisation
        ]);
    }

    public function getDemandesValideesParRegion()
    {
        $result = DB::table('demandedetails')
            ->select('nomville', DB::raw('COUNT(*) as count'))
            ->where('status', 2)
            ->groupBy('nomville')
            ->get();

        return response()->json($result);
    }


    public function getDemandesValideesParRegime()
    {
        $result = DB::table('demandedetails')
            ->select('nomregime', DB::raw('COUNT(*) as count'))
            ->where('status', 2)
            ->groupBy('nomregime')
            ->get();

        return response()->json($result);
    }

    public function getDemandesValideesParTypeFormulaire()
    {
        $result = DB::table('demandedetails')
            ->select('nomtypeformulaire', DB::raw('COUNT(*) as count'))
            ->where('status', 2)
            ->groupBy('nomtypeformulaire')
            ->get();

        return response()->json($result);
    }

    public function getKPIDeclarationSensibilisation()
    {
        $result = DB::table('kpideclarationsensibilisation')
            ->get();

        return response()->json($result);
    }
}
