<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\StructureJuridique;

class StructureJuridiqueController extends Controller
{
    public function index()
    {
        $structureJuridique = StructureJuridique::all();
        return response()->json($structureJuridique);
    }
}
