<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Renouvellement de déclaration - Notification pour l'Administrateur</title>
  <link href="{{ asset('css/bootstrap.min.css') }}" rel="stylesheet">
  <link href="{{ asset('soft-ui-dashboard.css?v=1.0.3') }}" rel="stylesheet">
</head>
<body>
  <div class="container my-5">
    <div class="row justify-content-center">
      <div class="col-lg-6">
        <div class="card">
          <div class="card-body">
            <h3 class="card-title">Renouvellement de déclaration - Action requise</h3>
            <ul>
                <li><strong>Opérateur :</strong> {{ $renewal->nomoperateur }}</li>
                <li><strong>Formulaire :</strong> {{ $renewal->nomtypeformulaire }}</li>
                <li><strong>Date de Déclaration :</strong> {{ \Carbon\Carbon::parse($renewal->datedeclaration)->format('d/m/Y') }}</li>
                <li><strong>Région :</strong> {{ $renewal->nomville }}</li>
            </ul>
            <p class="card-text">Cher Administrateur,</p>
            <p>L'opérateur <strong>{{ $renewal->nomoperateur }}</strong> doit renouveler son formulaire de <strong>{{ $renewal->nomtypeformulaire }}</strong>.</p>
            <p><strong>Date d'expiration :</strong> {{ \Carbon\Carbon::parse($renewal->dateexpiration)->format('d-m-Y') }}</p>
            <p>Veuillez prendre les mesures nécessaires pour notifier l'opérateur et assurer le bon renouvellement de la déclaration.</p>
            <a href="{{ url('http://localhost:4200/login') }}" class="button">Connectez-vous et envoyer la notification</a>
            <p class="mt-4">Cordialement,</p>
            <p>L'équipe ARTEC</p>
          </div>
        </div>
      </div>
    </div>
  </div>
  <script src="{{ asset('js/bootstrap.bundle.min.js') }}"></script>
</body>
</html>
