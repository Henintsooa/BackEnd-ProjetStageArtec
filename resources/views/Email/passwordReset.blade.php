<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Réinitialisation du Mot de Passe</title>
</head>
<body>
  <h3>Réinitialiser votre mot de passe</h3>
  <p>Bonjour,</p>
  <p>
    Nous avons reçu une demande pour réinitialiser votre mot de passe. Cliquez sur le lien ci-dessous pour réinitialiser votre mot de passe.
  </p>
  <p>
    <a href="{{ url('http://localhost:4200/resetPassword?token=' . $token . '&email=' . urlencode($email)) }}">Réinitialiser le mot de passe</a>
  </p>
  <p>Merci,<br>Artec</p>
</body>
</html>
