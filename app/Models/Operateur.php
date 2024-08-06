<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Operateur extends Model
{
    use HasFactory;

    protected $table = 'operateur';
    protected $primaryKey = 'idoperateur';

    protected $fillable = [
        'id',
        'nom',
        'adresse',
        'idville',
        'telephone',
        'telecopie',
        'email',
        'idstructurejuridique',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'id', 'id');
    }
}
