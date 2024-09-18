<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Formulaire de Déclaration</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <style>

        @page {
            margin: 150px 50px; /* Marge augmentée pour laisser plus de place au header et au footer */
        }

        body {
            font-family: 'Montserrat', sans-serif;
            margin: 0;
            padding: 0;
            position: relative;
        }

        .header, .footer {
            position: fixed;
            width: 100%;
            text-align: center;
        }

        .header {
            top: -125px; /* Placer le header en haut avec plus de marge */
        }

        .footer {
            bottom: -125px; /* Placer le footer en bas avec plus de marge */
        }

        .header img, .footer img {
            width: 100%;
            height: auto;
        }

        .content {
            margin-top: 20px; /* Ajoutez un espacement en haut du contenu */
            margin-bottom: 50px; /* S'assurer que le contenu ne chevauche pas le footer */
            padding: 0 20px;
        }

        .title-box {
            display: block;
            padding: 10px 20px;
            border: 2px solid #000;
            background-color: transparent;
            text-transform: uppercase;
            font-weight: bold;
            font-size: 11px;
            text-align: center; /* Centrer le texte à l'intérieur de la box */
            margin: 0 auto 20px auto; /* Centrer la box elle-même */
            width: fit-content; /* Ajuste la largeur de la box en fonction du contenu */
        }

        .content p, .content ul {
            margin: 10px 0;
            text-align: left; /* Aligne le texte à gauche */
            font-size: 12px; /* Ajustez la taille de la police si nécessaire */
        }

        .boxed-text {
            display: block;
            font-weight: bold;
            font-size: 11px;
            text-align: center; /* Centrer le texte */
            margin: 10px auto; /* Centrer le bloc */
            width: fit-content; /* Ajuste la largeur en fonction du contenu */
        }

        .horizontal-line {
            border-top: 4px solid #000;
            margin: 20px 0;
            width: 100%;
        }

        .section-title {
            text-transform: uppercase;
            font-weight: bold;
            font-size: 12px;
            margin: 20px 0 10px 0;
            text-decoration: underline;
        }

        .section-content {
            text-align: left;
            margin-bottom: 20px;
            font-size: 12px;
        }

        .section-content ul {
            list-style-type: decimal;
            padding-left: 20px;
            margin: 0;
        }

        .section-content li {
            margin-bottom: 10px;
            font-size: 12px;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <img src="data:image/png;base64,{{ base64_encode(file_get_contents(public_path('images/pdf/header.png'))) }}" alt="header">
    </div>

    <!-- Contenu principal -->
    <div class="content">
        @if ($groupedResponses->isNotEmpty())
            @php
                $firstResponse = $groupedResponses->first()->first();
            @endphp
            <div class="title-box">
                {{ $firstResponse->nomtypeformulaire }}
            </div>
        @endif

        <p>Le présent formulaire est à compléter et à retourner dûment signé à:</p>
            <div class="boxed-text">
                AUTORITÉ DE RÉGULATION <br> DES TECHNOLOGIES DE COMMUNICATION
                <br>Immeuble ARTEC Andohatapenaka (près du Village Voara)<br>101 - ANTANANARIVO
            </div>
        <p>Liste des pièces administratives à annexer au présent formulaire :</p>
        <ul>
            @foreach($groupedResponses as $categoryName => $responses)
                @if($categoryName === 'Documents PDF')
                    @foreach($responses as $response)
                        <li>
                            @if($response->typequestion == 'file')
                                {{-- <a href="{{ url($response->filereponse) }}" target="_blank">{{ $response->textquestion }}</a> --}}
                                {{ $response->textquestion }}
                            @else
                                {{ $response->textquestion }}: {{ $response->textereponse ?? 'Non disponible' }}
                            @endif
                        </li>
                    @endforeach
                @endif
            @endforeach
        </ul>

        <div class="horizontal-line"></div>

        <div class="section">
            <div class="section-title">A. Renseignements sur l’opérateur</div>
            <div class="section-content">
                <ul>
                    <li>Nom ou Raison sociale: {{ $firstResponse->nomoperateur }}</li>
                    <li>Structure juridique: {{ $firstResponse->nomstructurejuridique }}</li>
                    <li>Adresse du Siège social: {{ $firstResponse->adresse }}</li>
                    <li>Téléphone: {{ $firstResponse->telephone }}</li>
                    <li>Télécopie: {{ $firstResponse->telecopie }}</li>
                    <li>Email: {{ $firstResponse->email }}</li>
                </ul>
            </div>

            @php
                // Initialiser la lettre à "B" (ASCII pour 'B' est 66)
                $letter = 'B';
            @endphp

            @foreach($groupedResponses as $categoryName => $responses)
                @if($categoryName !== 'Documents PDF') <!-- Exclure la catégorie "Documents PDF" -->
                    <div class="section">
                        <!-- Afficher la lettre suivie du nom de la catégorie -->
                        <div class="section-title">{{ $letter }}. {{ $categoryName }}</div>
                        <div class="section-content">
                            <ul>
                                @foreach($responses as $response)
                                    <li>{{ $response->textquestion }}:
                                        @if($response->typequestion == 'text')
                                            {{ $response->textereponse }}
                                        @elseif($response->typequestion == 'number')
                                            {{ $response->nombrereponse }}
                                        @elseif($response->typequestion == 'file')
                                            <a href="{{ url($response->filereponse) }}" target="_blank">{{ $response->filereponse }}</a>
                                        @else
                                            Aucune réponse disponible
                                        @endif
                                    </li>
                                @endforeach
                            </ul>
                        </div>
                    </div>
                    @php
                        // Passer à la lettre suivante dans l'alphabet
                        $letter = chr(ord($letter) + 1);
                    @endphp
                @endif
            @endforeach


        </div>

        <!-- Nouveau texte ajouté -->
        <div class="section" style="margin-top: 20px;">
            <div class="section-content">
                <p>Le déclarant atteste que:</p>
                <ul>
                    <li>ni la société ni aucune des personnes qui y occupant des postes de responsabilités n’est en état de liquidation des biens ou de faillite personnelle (ou de procédure équivalente).</li>
                    <li>aucun des dirigeants de la société n’a fait l’objet de condamnations ou déchéances ou sanctions relatives à l’assainissement des professions commerciales et industrielles ou par la réglementation sur les prix et la concurrence du pays où il est établi.</li>
                    <li>avoir lu et pris connaissance des textes réglementaires régissant le secteur des télécommunications.</li>
                </ul>
                <p>Je déclare que les renseignements fournis ci-dessus sont exacts.</p>
                <p>Fait à ………………………, le ……………….</p>
                <p>Signature:</p>
                <br>
                <br>
                <p>Nom, prénom et qualité du signataire :</p>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <div class="footer">
        <img src="data:image/png;base64,{{ base64_encode(file_get_contents(public_path('images/pdf/footer.png'))) }}" alt="footer">
    </div>

</body>
</html>
