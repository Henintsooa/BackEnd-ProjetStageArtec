<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Sensibilisation</title>
  <link href="{{ asset('css/bootstrap.min.css') }}" rel="stylesheet">
  <link href="{{ asset('soft-ui-dashboard.css?v=1.0.3') }}" rel="stylesheet">
</head>
<body>
  <div class="container my-5">
    <div class="row justify-content-center">
      <div class="col-lg-6">
        <div class="card">
          <div class="card-body">
            <h3 class="card-title">Se déclarer à l'ARTEC</h3>
            <p class="card-text">Bonjour,</p>
            <p class="card-text">
                Nous vous invitons à vous déclarer en tant que Opérateur auprès de l'ARTEC. Cliquez sur le lien ci-dessous pour créer un compte et remplir un formulaire selon vos activités.
            </p>
            <a href="{{ url('http://localhost:4200/inscription') }}" class="btn btn-primary">S'Inscrire</a>
            <p class="mt-4">Merci,<br>Artec</p>
          </div>
        </div>
      </div>
    </div>
  </div>
  <script src="{{ asset('js/bootstrap.bundle.min.js') }}"></script>
</body>
</html>
