<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Sensibilisation extends Model
{
    use HasFactory;

    protected $table = 'sensibilisation'; // Spécifie la table associée
    public $timestamps = false;
    protected $primaryKey = 'idsensibilisation';

    protected $fillable = [
        'idoperateurcible',
        'status',
        'idoperateur',
        'datesensibilisation',
        'dateconversion',
    ];
}
