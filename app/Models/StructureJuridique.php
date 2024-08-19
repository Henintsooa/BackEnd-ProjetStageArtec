<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class StructureJuridique extends Model
{
    use HasFactory;

    protected $table = 'structurejuridique';
    protected $primaryKey = 'idstructurejuridique';

    protected $fillable = [
        'nom',
    ];

}
