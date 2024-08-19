<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class OperateurInformation extends Model
{
    use HasFactory;

    protected $table = 'operateurinformation';
    protected $primaryKey = 'idoperateurinformation';
    public $timestamps = false;

    protected $fillable = [
        'idoperateur',
        'adresse',
        'idville',
        'telephone',
        'telecopie',
        'email',
        'idstructurejuridique',
    ];

}
