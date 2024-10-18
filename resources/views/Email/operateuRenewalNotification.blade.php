<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Renouvellement de déclaration au près de l'ARTEC</title>
  <link href="{{ asset('css/bootstrap.min.css') }}" rel="stylesheet">
  <link href="{{ asset('soft-ui-dashboard.css?v=1.0.3') }}" rel="stylesheet">
</head>
<body>
  <div class="container my-5">
    <div class="row justify-content-center">
      <div class="col-lg-6">
        <div class="card">
          <div class="card-body">
            <h3 class="card-title">Renouvellement de déclaration au près de l'ARTEC</h3>
            <ul>
                <li><strong>Formulaire:</strong> {{ $operateur->nomtypeformulaire }}</li>
                <li><strong>Date de Déclaration:</strong> {{ \Carbon\Carbon::parse($operateur->datedeclaration)->format('d/m/Y') }}</li>
                <li><strong>Région:</strong> {{ $operateur->nomville }}</li>
            </ul>
            <p class="card-text">Cher Opérateur,</p>
            <p>Votre formulaire de {{ $operateur->nomtypeformulaire }} arrive bientôt à expiration.</p>
            <p>Date d'expiration : {{ \Carbon\Carbon::parse($operateur->dateexpiration)->format('d-m-Y') }}</p>
            <p>Veuillez renouveler votre formulaire s'il vous plait si vous envisagez de continuer votre activité.</p>
            <a href="{{ url('http://localhost:4200/login') }}" class="button">Connectez-vous et renouvelez maintenant</a>

            <p>Cordialement,</p>
          </div>
        </div>
      </div>
    </div>
  </div>
  <script src="{{ asset('js/bootstrap.bundle.min.js') }}"></script>
</body>
</html>
