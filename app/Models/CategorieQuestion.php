<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class CategorieQuestion extends Model
{
    use HasFactory;
    public $timestamps = false;
    protected $table = 'categoriequestion';
    protected $primaryKey = 'idcategoriequestion';

    protected $fillable = [
        'nom',
        'nombrereponses',
    ];

}
