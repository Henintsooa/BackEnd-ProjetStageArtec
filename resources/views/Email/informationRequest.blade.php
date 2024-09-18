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
      background: #ffeeba;
      border-radius: 5px;
      padding: 10px;
      margin-bottom: 10px;
      font-size: 16px;
      font-weight: 500;
      display: flex;
      align-items: center;
    }
    ul li::before {
      content: "\f129";
      font-family: "FontAwesome";
      color: #ffc107;
      margin-right: 10px;
    }
    p {
      font-size: 16px;
      line-height: 1.5;
    }
  </style>
</head>
<body>
  <div class="container my-5">
    <div class="row justify-content-center">
      <div class="col-lg-6">
        <div class="card shadow">
          <div class="card-body">
            {{-- <h3 class="card-title text-center">Demande d'informations supplémentaires - ARTEC</h3> --}}
            <ul>
                <li><strong>Formulaire :</strong> {{ $demande->nomtypeformulaire }}</li>
                <li><strong>Date de Déclaration :</strong> {{ \Carbon\Carbon::parse($demande->datedeclaration)->format('d/m/Y') }}</li>
                <li><strong>Région :</strong> {{ $demande->nomville }}</li>
            </ul>
            <p class="card-text">Cher Opérateur,</p>
            <p class="card-text">
              Nous vous remercions d'avoir soumis votre déclaration. Après un examen approfondi, nous avons besoin d'informations complémentaires pour poursuivre le traitement de votre demande.
            </p>
            <p class="card-text">
              Nous vous prions de bien vouloir joindre les documents suivants en format PDF en réponse à ce courriel :
            </p>
            <div class="alert alert-warning">
              <p>{{ $infoMessage }}</p>
            </div>
            <p class="card-text">
              Si vous avez des questions ou souhaitez obtenir plus de détails concernant notre demande d'informations, n'hésitez pas à nous contacter. Nous restons à votre disposition pour tout complément d'information.
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