<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class TypeFormulaireDetails extends Model
{
    protected $table = 'typeformulairedetails';

    protected $fillable = [
        'idformulaire',
        'nomformulaire',
        'datecreationformulaire',
        'idtypeformulaire',
        'nomtypeformulaire',
        'descriptiontypeformulaire',
        'status',
        'image',
    ];


}

