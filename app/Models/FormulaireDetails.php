<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class FormulaireDetails extends Model
{
    use HasFactory;

    protected $table = 'formulairedetails';

    protected $fillable = [
        'idformulaire',
        'nomformulaire',
        'idtypeformulaire',
        'nomtypeformulaire',
        'descriptiontypeformulaire',
        'idquestion',
        'textquestion',
        'typequestion',
        'designationtypequestion',
        'questionobligatoire',
        'categoriequestion',
        'image'
    ];
}
