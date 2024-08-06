<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Réinitialisation du Mot de Passe</title>
  <link href="{{ asset('css/bootstrap.min.css') }}" rel="stylesheet">
  <link href="{{ asset('soft-ui-dashboard.css?v=1.0.3') }}" rel="stylesheet">
</head>
<body>
  <div class="container my-5">
    <div class="row justify-content-center">
      <div class="col-lg-6">
        <div class="card">
          <div class="card-body">
            <h3 class="card-title">Réinitialiser votre mot de passe</h3>
            <p class="card-text">Bonjour,</p>
            <p class="card-text">
              Nous avons reçu une demande pour réinitialiser votre mot de passe. Cliquez sur le lien ci-dessous pour réinitialiser votre mot de passe.
            </p>
            <a href="{{ url('http://localhost:4200/resetPassword?token=' . $token . '&email=' . urlencode($email)) }}" class="btn btn-primary">Réinitialiser le mot de passe</a>
            <p class="mt-4">Merci,<br>Artec</p>
          </div>
        </div>
      </div>
    </div>
  </div>
  <script src="{{ asset('js/bootstrap.bundle.min.js') }}"></script>
</body>
</html>
