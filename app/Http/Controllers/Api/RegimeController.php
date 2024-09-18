<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Regime;

class RegimeController extends Controller
{
    public function index()
    {
        $Regimes = Regime::all();
        return response()->json($Regimes);
    }
}
