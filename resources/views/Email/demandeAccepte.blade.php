<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Demande déclaration au près de l'ARTEC</title>
  <link href="{{ asset('css/bootstrap.min.css') }}" rel="stylesheet">
  <link href="{{ asset('soft-ui-dashboard.css?v=1.0.3') }}" rel="stylesheet">
  <style>
    ul {
      list-style-type: none;
      padding: 0;
    }
    ul li {
      background: #f8f9fa;
      border-radius: 5px;
      padding: 10px;
      margin-bottom: 10px;
      font-size: 16px;
      font-weight: 500;
      display: flex;
      align-items: center;
    }
    ul li::before {
      content: "\f058";
      font-family: "FontAwesome";
      color: #5cb85c;
      margin-right: 10px;
    }
  </style>
</head>
<body>
  <div class="container my-5">
    <div class="row justify-content-center">
      <div class="col-lg-6">
        <div class="card shadow">
          <div class="card-body">
            {{-- <h3 class="card-title text-center">Confirmation de déclaration auprès de l'ARTEC</h3> --}}
            <ul>
                <li><strong>Formulaire :</strong> {{ $demande->nomtypeformulaire }}</li>
                <li><strong>Date de déclaration :</strong> {{ \Carbon\Carbon::parse($demande->datedeclaration)->format('d/m/Y') }}</li>
                <li><strong>Région :</strong> {{ $demande->nomville }}</li>
            </ul>
            <p class="card-text">Cher Opérateur,</p>
            <p class="card-text">
              Nous avons le plaisir de vous informer que votre déclaration a été acceptée. Nous vous remercions d'avoir soumis votre demande et d'avoir respecté les procédures établies.
            </p>
            <p class="card-text">
              Si vous avez besoin de plus amples informations ou avez des questions, n'hésitez pas à nous contacter. Merci pour votre soumission et votre confiance.
            </p>
            <p>Cordialement,</p>
            {{-- <p class="text-center mt-4">L'équipe ARTEC</p> --}}
          </div>
        </div>
      </div>
    </div>
  </div>
  <script src="{{ asset('js/bootstrap.bundle.min.js') }}"></script>
</body>
</html>
