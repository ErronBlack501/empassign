<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Lieux</title>
  <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>
<div class="container">
  <div class="card">
    <div class="topbar">
      <h1>Gestion des lieux</h1>
      <nav class="nav">
        <a href="index.jsp">Accueil</a>
        <a href="employees">Employés</a>
        <a href="affectations">Affectations</a>
      </nav>
    </div>

    <h2>Ajouter un lieu</h2>
    <form method="post" action="lieux">
      <div class="form-grid">
        <div>
          <label>Code</label>
          <input type="number" name="codelieu" required>
        </div>
        <div>
          <label>Désignation</label>
          <input type="text" name="designation" required>
        </div>
        <div>
          <label>Province</label>
          <input type="text" name="province">
        </div>
      </div>
      <button type="submit">Ajouter</button>
    </form>
  </div>

  <div class="card">
    <h2>Liste des lieux</h2>
    <div class="table-wrap">
      <table>
        <thead>
          <tr>
            <th>Code</th>
            <th>Désignation</th>
            <th>Province</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="lieu" items="${lieux}">
            <tr>
              <td>${lieu.codelieu}</td>
              <td>${lieu.designation}</td>
              <td>${lieu.province}</td>
              <td><a href="lieux?action=delete&code=${lieu.codelieu}" class="action-link">Supprimer</a></td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
  </div>
</div>
</body>
</html>
