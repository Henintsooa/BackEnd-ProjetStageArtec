<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Demande déclaration au près de l'ARTEC</title>
  <link href="{{ asset('css/bootstrap.min.css') }}" rel="stylesheet">
  <link href="{{ asset('soft-ui-dashboard.css?v=1.0.3') }}" rel="stylesheet">
</head>
<body>
  <div class="container my-5">
    <div class="row justify-content-center">
      <div class="col-lg-6">
        <div class="card">
          <div class="card-body">
            <h3 class="card-title">Demande déclaration au près de l'ARTEC</h3>
            <ul>
                <li>Formulaire : {{ $demande->nomtypeformulaire }}</li>
                <li>Date de Déclaration : {{ \Carbon\Carbon::parse($demande->datedeclaration)->format('d/m/Y') }}</li>
                <li>Région : {{ $demande->nomville }}</li>
            </ul>
            <p class="card-text">Cher Opérateur,</p>
            <p class="card-text">
                Nous vous remercions d'avoir soumis votre déclaration.
                Après avoir examiné attentivement votre demande, nous aurions besoin plus d'informations pour pouvoir continuer le processus de déclaration.
                Nous vous prions de bien vouloir remplir une seconde fois le formulaire et fournir les informations suivantes :
                <p>{{ $infoMessage }}</p>

                Si vous avez des questions ou si vous souhaitez obtenir plus d'informations sur les raisons de notre décision, n'hésitez pas à nous contacter.
            </p>
            <p>Cordialement,</p>
          </div>
        </div>
      </div>
    </div>
  </div>
  <script src="{{ asset('js/bootstrap.bundle.min.js') }}"></script>
</body>
</html>
