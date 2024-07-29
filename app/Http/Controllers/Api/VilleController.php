<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Ville;

class VilleController extends Controller
{
    public function index()
    {
        $villes = Ville::all();
        return response()->json($villes);
    }
}
