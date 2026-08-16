# Projet 5 - Gestion des affectations des employés

## Base de données MySQL avec Docker

Lance le conteneur MySQL :

```bash
docker-compose up -d
```

Vérifie que le service est démarré :

```bash
docker ps
```

Connexion JDBC utilisée par l'application :

```text
jdbc:mysql://localhost:3307/empassign?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
```

Identifiants MySQL du conteneur :

```text
Utilisateur : empassign
Mot de passe : empassign
```

Pour arrêter le conteneur :

```bash
docker-compose down
```
