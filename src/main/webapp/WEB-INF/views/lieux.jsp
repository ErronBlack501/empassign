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

    <h2><c:if test="${'edit' eq action}">Modifier un lieu</c:if><c:if test="${'read' eq action}">Détails du lieu</c:if><c:if test="${'edit' ne action and 'read' ne action}">Ajouter un lieu</c:if></h2>
    <form method="post" action="lieux">
      <input type="hidden" name="formAction" value="${'edit' eq action ? 'update' : 'add'}">
      <c:if test="${'edit' eq action and selectedLieu != null}">
        <input type="hidden" name="codelieu" value="${selectedLieu.codelieu}">
      </c:if>
      <div class="form-grid">
        <div>
          <label>Désignation</label>
          <input type="text" name="designation" value="${selectedLieu.designation}" ${'read' eq action ? 'disabled="disabled"' : ''} required>
        </div>
        <div>
          <label>Province</label>
          <input type="text" name="province" value="${selectedLieu.province}" ${'read' eq action ? 'disabled="disabled"' : ''}>
        </div>
      </div>
      <div class="form-actions">
        <button type="submit" ${'read' eq action ? 'disabled="disabled"' : ''}><c:if test="${'edit' eq action}">Modifier</c:if><c:if test="${'edit' ne action}">Ajouter</c:if></button>
        <c:if test="${'read' eq action or 'edit' eq action}">
          <a href="lieux" class="btn-cancel">Annuler</a>
        </c:if>
      </div>
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
              <td class="action-buttons">
                <a href="lieux?action=read&code=${lieu.codelieu}" class="btn-read" title="Voir">👁️</a>
                <a href="lieux?action=edit&code=${lieu.codelieu}" class="btn-edit" title="Modifier">✏️</a>
                <a href="lieux?action=delete&code=${lieu.codelieu}" class="btn-remove" title="Supprimer" onclick="return confirm('Êtes-vous sûr?')">🗑️</a>
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
