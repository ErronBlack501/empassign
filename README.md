# Projet 5 - Gestion des affectations des employés

## Java 21

Le projet se compile avec JDK 21. Avant d'utiliser Maven depuis PowerShell, vérifiez que `JAVA_HOME` pointe vers votre installation JDK 21 :

```powershell
$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-21.0.12.101-hotspot"
$env:Path = "$env:JAVA_HOME\bin;" + $env:Path
java -version
```

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

## Demarrage automatise de l'application

Avec PowerShell, indiquez le dossier d'installation de Tomcat :

```powershell
.\start-app.ps1 -TomcatPath "C:\chemin\vers\apache-tomcat-11"
```

Le script demarre MySQL, compile le projet, copie le WAR dans Tomcat et demarre Tomcat. Vous pouvez aussi definir `TOMCAT_HOME` pour ne pas repeter le chemin :

```powershell
$env:TOMCAT_HOME = "C:\chemin\vers\apache-tomcat-11"
.\start-app.ps1
```

L'application sera accessible a `http://localhost:8080/empassign-1.0-SNAPSHOT/`.

Pour arrêter le conteneur :

```bash
docker-compose down
```
