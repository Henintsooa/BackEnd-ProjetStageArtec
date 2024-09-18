<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class OperateurCible extends Model
{
    use HasFactory;
    protected $table = 'operateurcible';
    public $timestamps = false;
    protected $primaryKey = 'idoperateurcible';


    protected $fillable = [
        'nom',
        'email',
        'idville',
        'status',
        'idregime',
        'adresse',
    ];
}
