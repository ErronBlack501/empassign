<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Affectations</title>
  <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>
<div class="container">
  <div class="card">
    <div class="topbar">
      <h1>Gestion des affectations</h1>
      <nav class="nav">
        <a href="index.jsp">Accueil</a>
        <a href="employees">Employés</a>
        <a href="lieux">Lieux</a>
      </nav>
    </div>

    <h2>Ajouter une affectation</h2>
    <form method="post" action="affectations">
      <div class="form-grid">
        <div>
          <label>Employé</label>
          <select name="codeemp" required>
            <c:forEach var="employee" items="${employees}">
              <option value="${employee.codeemp}">${employee.nom} ${employee.prenom}</option>
            </c:forEach>
          </select>
        </div>
        <div>
          <label>Lieu</label>
          <select name="codelieu" required>
            <c:forEach var="lieu" items="${lieux}">
              <option value="${lieu.codelieu}">${lieu.designation}</option>
            </c:forEach>
          </select>
        </div>
        <div>
          <label>Date</label>
          <input type="date" name="date" required>
        </div>
      </div>
      <button type="submit">Ajouter</button>
    </form>
  </div>

  <div class="card">
    <h2>Liste des affectations</h2>
    <div class="table-wrap">
      <table>
        <thead>
          <tr>
            <th>Employé</th>
            <th>Lieu</th>
            <th>Date</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="affectation" items="${affectations}">
            <tr>
              <td>${affectation.employee.nom} ${affectation.employee.prenom}</td>
              <td>${affectation.lieu.designation}</td>
              <td>${affectation.date}</td>
              <td>
                <a href="affectations?action=delete&codeemp=${affectation.employee.codeemp}&codelieu=${affectation.lieu.codelieu}" class="action-link">Supprimer</a>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
  </div>
</div>
</body>
</html>
