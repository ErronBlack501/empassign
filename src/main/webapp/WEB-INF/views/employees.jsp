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

    <h2><c:if test="${'edit' eq action}">Modifier un employé</c:if><c:if test="${'read' eq action}">Détails de l'employé</c:if><c:if test="${'edit' ne action and 'read' ne action}">Ajouter un employé</c:if></h2>
    <form method="post" action="employees">
      <input type="hidden" name="formAction" value="${'edit' eq action ? 'update' : 'add'}">
      <c:if test="${'edit' eq action and selectedEmployee != null}">
        <input type="hidden" name="codeemp" value="${selectedEmployee.codeemp}">
      </c:if>
      <div class="form-grid">
        <div>
          <label>Nom</label>
          <input type="text" name="nom" value="${selectedEmployee.nom}" ${'read' eq action ? 'disabled="disabled"' : ''} required>
        </div>
        <div>
          <label>Prénom</label>
          <input type="text" name="prenom" value="${selectedEmployee.prenom}" ${'read' eq action ? 'disabled="disabled"' : ''}>
        </div>
        <div>
          <label>Poste</label>
          <input type="text" name="poste" value="${selectedEmployee.poste}" ${'read' eq action ? 'disabled="disabled"' : ''}>
        </div>
      </div>
      <div class="form-actions">
        <button type="submit" ${'read' eq action ? 'disabled="disabled"' : ''}><c:if test="${'edit' eq action}">Modifier</c:if><c:if test="${'edit' ne action}">Ajouter</c:if></button>
        <c:if test="${'read' eq action or 'edit' eq action}">
          <a href="employees" class="btn-cancel">Annuler</a>
        </c:if>
      </div>
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
              <td class="action-buttons">
                <a href="employees?action=read&code=${employee.codeemp}" class="btn-read" title="Voir">👁️</a>
                <a href="employees?action=edit&code=${employee.codeemp}" class="btn-edit" title="Modifier">✏️</a>
                <a href="employees?action=delete&code=${employee.codeemp}" class="btn-remove" title="Supprimer" onclick="return confirm('Êtes-vous sûr?')">🗑️</a>
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
