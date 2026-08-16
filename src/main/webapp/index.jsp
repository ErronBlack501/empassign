<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
  <head>
    <meta charset="UTF-8" />
    <title>Dashboard - Gestion des affectations</title>
    <link rel="stylesheet" href="assets/css/style.css" />
  </head>
  <body>
    <div class="container">
      <div class="dashboard-shell">
        <aside class="sidebar">
          <div class="brand">EMPASSIGN</div>
          <nav class="side-nav">
            <a href="index.jsp">Accueil</a>
            <a href="employees">Employés</a>
            <a href="lieux">Lieux</a>
            <a href="affectations">Affectations</a>
          </nav>
        </aside>

        <main class="main-panel">
          <div class="card">
            <div class="topbar">
              <h1>Dashboard RH</h1>
              <nav class="nav">
                <a href="employees">Employés</a>
                <a href="lieux">Lieux</a>
                <a href="affectations">Affectations</a>
              </nav>
            </div>
          </div>

          <div class="grid">
            <div class="module-card">
              <div>
                <h3>Employés</h3>
                <p>
                  Gérer les salariés, leur poste et leur recherche par code ou
                  nom.
                </p>
              </div>
              <a class="button-link" href="employees">Ouvrir</a>
            </div>

            <div class="module-card">
              <div>
                <h3>Lieux</h3>
                <p>Ajouter et organiser les différents lieux d'affectation.</p>
              </div>
              <a class="button-link" href="lieux">Ouvrir</a>
            </div>

            <div class="module-card">
              <div>
                <h3>Affectations</h3>
                <p>
                  Associer un employé à un lieu et enregistrer la date
                  d'affectation.
                </p>
              </div>
              <a class="button-link" href="affectations">Ouvrir</a>
            </div>
          </div>
        </main>
      </div>
    </div>
  </body>
</html>
