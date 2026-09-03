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

    <c:choose>
      <c:when test="${action eq 'edit'}">
        <h2>Modifier une affectation</h2>
      </c:when>
      <c:when test="${action eq 'read'}">
        <h2>Détails de l'affectation</h2>
      </c:when>
      <c:otherwise>
        <h2>Ajouter une affectation</h2>
      </c:otherwise>
    </c:choose>

    <form method="post" action="affectations">
      <c:choose>
        <c:when test="${action eq 'edit'}">
          <input type="hidden" name="formAction" value="update">
        </c:when>
        <c:otherwise>
          <input type="hidden" name="formAction" value="add">
        </c:otherwise>
      </c:choose>

      <div class="form-grid">
        <div>
          <label for="codeemp">Employé</label>
          <c:choose>
            <c:when test="${action eq 'read'}">
              <select id="codeemp" name="codeemp" required disabled>
                <option value="">-- Sélectionner un employé --</option>
                <c:forEach var="employee" items="${employees}">
                  <option value="${employee.codeemp}" ${not empty selectedAffectation and selectedAffectation.employee.codeemp eq employee.codeemp ? 'selected' : ''}>${employee.nom} ${employee.prenom}</option>
                </c:forEach>
              </select>
            </c:when>
            <c:otherwise>
              <select id="codeemp" name="codeemp" required>
                <option value="">-- Sélectionner un employé --</option>
                <c:forEach var="employee" items="${employees}">
                  <option value="${employee.codeemp}" ${not empty selectedAffectation and selectedAffectation.employee.codeemp eq employee.codeemp ? 'selected' : ''}>${employee.nom} ${employee.prenom}</option>
                </c:forEach>
              </select>
            </c:otherwise>
          </c:choose>
        </div>

        <div>
          <label for="codelieu">Lieu</label>
          <c:choose>
            <c:when test="${action eq 'read'}">
              <select id="codelieu" name="codelieu" required disabled>
                <option value="">-- Sélectionner un lieu --</option>
                <c:forEach var="lieu" items="${lieux}">
                  <option value="${lieu.codelieu}" ${not empty selectedAffectation and selectedAffectation.lieu.codelieu eq lieu.codelieu ? 'selected' : ''}>${lieu.designation}</option>
                </c:forEach>
              </select>
            </c:when>
            <c:otherwise>
              <select id="codelieu" name="codelieu" required>
                <option value="">-- Sélectionner un lieu --</option>
                <c:forEach var="lieu" items="${lieux}">
                  <option value="${lieu.codelieu}" ${not empty selectedAffectation and selectedAffectation.lieu.codelieu eq lieu.codelieu ? 'selected' : ''}>${lieu.designation}</option>
                </c:forEach>
              </select>
            </c:otherwise>
          </c:choose>
        </div>

        <div>
          <label for="date">Date</label>
          <c:choose>
            <c:when test="${action eq 'read'}">
              <input type="date" id="date" name="date" value="${not empty selectedAffectation ? selectedAffectation.date : ''}" required disabled>
            </c:when>
            <c:otherwise>
              <input type="date" id="date" name="date" value="${not empty selectedAffectation ? selectedAffectation.date : ''}" required>
            </c:otherwise>
          </c:choose>
        </div>
      </div>

      <div class="form-actions">
        <c:if test="${action ne 'read'}">
          <c:choose>
            <c:when test="${action eq 'edit'}">
              <button type="submit">Modifier</button>
            </c:when>
            <c:otherwise>
              <button type="submit">Ajouter</button>
            </c:otherwise>
          </c:choose>
        </c:if>

        <c:if test="${action eq 'read' or action eq 'edit'}">
          <a href="affectations" class="btn-cancel">Retour</a>
        </c:if>
      </div>
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
          <c:choose>
            <c:when test="${empty affectations}">
              <tr>
                <td colspan="4">Aucune affectation trouvée.</td>
              </tr>
            </c:when>
            <c:otherwise>
              <c:forEach var="affectation" items="${affectations}">
                <tr>
                  <td>${affectation.employee.nom} ${affectation.employee.prenom}</td>
                  <td>${affectation.lieu.designation}</td>
                  <td>${affectation.date}</td>
                  <td class="action-buttons">
                    <a href="affectations?action=read&codeemp=${affectation.employee.codeemp}&codelieu=${affectation.lieu.codelieu}" class="btn-read" title="Voir">👁️</a>
                    <a href="affectations?action=edit&codeemp=${affectation.employee.codeemp}&codelieu=${affectation.lieu.codelieu}" class="btn-edit" title="Modifier">✏️</a>
                    <a href="affectations?action=delete&codeemp=${affectation.employee.codeemp}&codelieu=${affectation.lieu.codelieu}" class="btn-remove" title="Supprimer" onclick="return confirm('Êtes-vous sûr de vouloir supprimer cette affectation ?')">🗑️</a>
                  </td>
                </tr>
              </c:forEach>
            </c:otherwise>
          </c:choose>
        </tbody>
      </table>
    </div>
  </div>
</div>
</body>
</html>
