<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Demande extends Model
{
    use HasFactory;

    // Spécifiez le nom de la table
    protected $table = 'demande';

    // Spécifiez la clé primaire
    protected $primaryKey = 'iddemande';

    // Définir les attributs que vous pouvez remplir en masse
    protected $fillable = [
        'idoperateurinformation',
        'idformulaire',
        'datedeclaration',
        'dateexpiration',
        'status',
        'datedemande',
        'idrenouvellement'
    ];

    // Pour les timestamps si vous utilisez des colonnes de création/majeure modifiée
    public $timestamps = false;

}
