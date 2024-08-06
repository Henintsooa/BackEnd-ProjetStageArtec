<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Question extends Model
{
    use HasFactory;

    protected $table = 'question';
    protected $primaryKey = 'idquestion';
    public $timestamps = false;

    protected $fillable = [
        'idformulaire',
        'textquestion',
        'idtypequestion',
        'idcategoriequestion',
        'questionobligatoire',
    ];

}
