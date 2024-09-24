<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Demande d'information - Opérateur</title>
  <link href="{{ asset('css/bootstrap.min.css') }}" rel="stylesheet">
  <link href="{{ asset('soft-ui-dashboard.css?v=1.0.3') }}" rel="stylesheet">
  <style>

  </style>
</head>
<body>
  <div class="container my-5">
    <div class="row justify-content-center">
      <div class="col-lg-6">
        <div class="card shadow">
          <div class="card-body">
            <h3 class="card-title">Demande d'information - {{ $nomoperateur }}</h3>
            <p class="card-text">
              Bonjour,
            </p>
            <p>
              Je suis {{ $userName }}, représentant de {{ $nomoperateur }}. Je souhaiterais obtenir des informations complémentaires concernant les procédures de déclaration, notamment sur les points suivants :
            </p>
            <p class="card-text">
              {{ $userMessage }}
            </p>
            <p>
              Je vous remercie par avance pour votre réponse et reste disponible pour toute information supplémentaire.
            </p>
            <p>Cordialement,</p>
            <p class="signature">{{ $userName }}<br>{{ $userEmail }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
  <script src="{{ asset('js/bootstrap.bundle.min.js') }}"></script>
</body>
</html>
