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
      padding-left: 0; /* Pour aligner à gauche */
      list-style-type: none; /* Supprimer les puces */
    }
    ul li {
      margin-bottom: 10px; /* Ajouter un espace entre les éléments de la liste */
    }
  </style>
</head>
<body>
  <div class="container my-5">
    <div class="row justify-content-center">
      <div class="col-lg-6">
        <div class="card shadow">
            <div class="card-body">
              <ul>
                <li><strong>Formulaire:</strong> {{ $demande->nomtypeformulaire }}</li>
                <li><strong>Date de Déclaration:</strong> {{ \Carbon\Carbon::parse($demande->datedeclaration)->format('d/m/Y') }}</li>
                <li><strong>Région:</strong> {{ $demande->nomville }}</li>
              </ul>
              <p class="card-text">Cher Opérateur,</p>
              <p class="card-text">
                Nous vous remercions d'avoir soumis votre déclaration. Après un examen attentif de votre demande, nous sommes au regret de vous informer que celle-ci a été refusée. Ce refus est dû à des éléments spécifiques qui ne répondent pas aux critères de conformité établis par l'ARTEC.
              </p>
              <p class="card-text">
                En effet, la décision a été prise en raison du motif suivant : <strong>{{ $motifRefus }}</strong>. Nous vous encourageons à prendre en compte cette information pour vos futures soumissions.
              </p>
              <p class="card-text">
                Si vous avez des questions concernant cette décision ou si vous souhaitez obtenir davantage d'informations, n'hésitez pas à nous contacter.
              </p>
              <p class="card-text">
                Nous restons à votre disposition pour toute assistance future et vous remercions de votre compréhension.
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
