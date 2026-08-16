<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Employés</title>
  <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>
<div class="container">
  <div class="card">
    <div class="topbar">
      <h1>Gestion des employés</h1>
      <nav class="nav">
        <a href="index.jsp">Accueil</a>
        <a href="lieux">Lieux</a>
        <a href="affectations">Affectations</a>
      </nav>
    </div>

    <form method="get" action="employees" class="search-form">
      <input type="text" name="keyword" value="${keyword}" placeholder="Rechercher par code ou nom" />
      <button type="submit">Rechercher</button>
    </form>

    <h2>Ajouter un employé</h2>
    <form method="post" action="employees">
      <div class="form-grid">
        <div>
          <label>Code</label>
          <input type="number" name="codeemp" required>
        </div>
        <div>
          <label>Nom</label>
          <input type="text" name="nom" required>
        </div>
        <div>
          <label>Prénom</label>
          <input type="text" name="prenom">
        </div>
        <div>
          <label>Poste</label>
          <input type="text" name="poste">
        </div>
      </div>
      <button type="submit">Ajouter</button>
    </form>
  </div>

  <div class="card">
    <h2>Liste des employés</h2>
    <div class="table-wrap">
      <table>
        <thead>
          <tr>
            <th>Code</th>
            <th>Nom</th>
            <th>Prénom</th>
            <th>Poste</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="employee" items="${employees}">
            <tr>
              <td>${employee.codeemp}</td>
              <td>${employee.nom}</td>
              <td>${employee.prenom}</td>
              <td>${employee.poste}</td>
              <td><a href="employees?action=delete&code=${employee.codeemp}" class="action-link">Supprimer</a></td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
  </div>
</div>
</body>
</html>
