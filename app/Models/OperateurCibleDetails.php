<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class OperateurCibleDetails extends Model
{
    protected $table = 'operateurcibledetails';

    public $timestamps = false;

    protected $fillable = [
        'idoperateurcible',
        'nom',
        'email',
        'ville',
        'status',
        'idsensibilisation',
        'datesensibilisation',
        'dateconversion',
        'sensibilisationstatus',
    ];

}
