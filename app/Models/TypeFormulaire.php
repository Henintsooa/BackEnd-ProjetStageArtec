<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TypeFormulaire extends Model
{
    use HasFactory;

    protected $table = 'typeformulaire';
    protected $primaryKey = 'idtypeformulaire';
    public $timestamps = false;

    protected $fillable = [
        'nom',
        'description',
        'status',
        'image',
    ];

}
