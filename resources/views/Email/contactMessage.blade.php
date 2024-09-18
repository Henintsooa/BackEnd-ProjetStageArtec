<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Demande d'information d'opérateur</title>
  <link href="{{ asset('css/bootstrap.min.css') }}" rel="stylesheet">
  <link href="{{ asset('soft-ui-dashboard.css?v=1.0.3') }}" rel="stylesheet">
</head>
<body>
  <div class="container my-5">
    <div class="row justify-content-center">
      <div class="col-lg-6">
        <div class="card">
          <div class="card-body">
            <h3 class="card-title">Demande d'information de l'opérateur {{ $nomoperateur }}</h3>
            <p class="card-text">
              Bonjour,
            </p>
            <p>
              Je suis {{ $userName }}, {{ $nomoperateur }}. J'aimerais avoir plus d'informations concernant les procédures ou les règles de déclaration, notamment sur :
            </p>
            <p>
              {{ $userMessage }}
            </p>
            <p>
              Je vous remercie par avance pour votre retour et suis à votre disposition pour toute question complémentaire.
            </p>
            <p>Cordialement,</p>
            <p>{{ $userName }}<br>{{ $userEmail }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
  <script src="{{ asset('js/bootstrap.bundle.min.js') }}"></script>
</body>
</html>
