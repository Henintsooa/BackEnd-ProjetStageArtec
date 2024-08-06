<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Formulaire extends Model
{
    use HasFactory;

    protected $table = 'formulaire';
    protected $primaryKey = 'idformulaire';
    public $timestamps = false;

    protected $fillable = [
        'idtypeformulaire',
        'nom',
        'datecreation',


    ];

}
