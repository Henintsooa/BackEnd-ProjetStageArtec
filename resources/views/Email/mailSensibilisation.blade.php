<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Sensibilisation - ARTEC</title>
  <link href="{{ asset('css/bootstrap.min.css') }}" rel="stylesheet">
  <link href="{{ asset('soft-ui-dashboard.css?v=1.0.3') }}" rel="stylesheet">
  <style>
    /* .btn-primary {
      background-color: #017B38;
      border-color: #017B38;
      padding: 10px 20px;
      font-size: 10px;
    } */
    ul {
      list-style-type: none;
    }

  </style>
</head>
<body>
  <div class="container my-5">
    <div class="row justify-content-center">
      <div class="col-lg-6">
        <div class="card shadow">
          <div class="card-body">
            <h3 class="card-title text-center">Déclaration à l'ARTEC</h3>
            <p class="card-text">Bonjour,</p>
            <p class="card-text">
              Nous avons le plaisir de vous inviter à vous déclarer auprès de l'ARTEC. Afin de régulariser votre activité, nous vous encourageons à créer un compte et à compléter le formulaire de déclaration en fonction de vos activités.
            </p>
            <div class="text-center my-4">
              <a href="{{ url('http://localhost:4200/inscription') }}">S'Inscrire</a>
            </div>
            <p class="card-text">
              En cliquant sur le lien ci-dessus, vous accéderez à notre plateforme de déclaration. Si vous avez des questions ou avez besoin d'assistance, n'hésitez pas à nous contacter.
            </p>
            <p class="mt-4">Cordialement,</p>
          </div>
        </div>
      </div>
    </div>
  </div>
  <script src="{{ asset('js/bootstrap.bundle.min.js') }}"></script>
</body>
</html>
