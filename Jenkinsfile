pipeline {
    agent any

    parameters {
        booleanParam(
            name: 'RUN_SONAR',
            defaultValue: true,
            description: 'Run SonarQube analysis'
        )
        booleanParam(
            name: 'DEPLOY_NEXUS',
            defaultValue: false,
            description: 'Publish the WAR file to Nexus'
        )
        string(
            name: 'NEXUS_RELEASE_URL',
            defaultValue: 'http://nexus:8081/repository/maven-releases/',
            description: 'Full URL of the Nexus releases repository'
        )
    }

    environment {
        COMPOSE_PROJECT_NAME = 'empassign-ci'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build and test') {
            steps {
                script {
                    retry(3) {
                        if (isUnix()) {
                            sh 'chmod +x mvnw && ./mvnw -Dmaven.wagon.http.retryHandler.count=5 clean verify'
                        } else {
                            bat 'mvnw.cmd -Dmaven.wagon.http.retryHandler.count=5 clean verify'
                        }
                    }
                }
            }
        }

        stage('SonarQube analysis') {
            when {
                expression { params.RUN_SONAR }
            }
            steps {
                withSonarQubeEnv('SonarQube') {
                    script {
                        // Pas de retry(3) le temps du diagnostic : on veut voir
                        // l'erreur exacte de la PREMIÈRE tentative, sans qu'elle
                        // soit noyée par 2 autres tentatives identiques derrière.
                        if (isUnix()) {
                            sh '''
                                test -n "$SONAR_AUTH_TOKEN" || { echo "ERROR: SonarQube installation token is missing"; exit 1; }
                                ./mvnw -e -X -Dmaven.wagon.http.retryHandler.count=5 \
                                  org.sonarsource.scanner.maven:sonar-maven-plugin:5.8.0.7211:sonar \
                                  -Dsonar.projectKey=empassign \
                                  -Dsonar.host.url="$SONAR_HOST_URL" \
                                  -Dsonar.token="$SONAR_AUTH_TOKEN"
                            '''
                        } else {
                            bat '''
                                if "%SONAR_AUTH_TOKEN%"=="" exit /b 1
                                mvnw.cmd -e -X -Dmaven.wagon.http.retryHandler.count=5 ^
                                  org.sonarsource.scanner.maven:sonar-maven-pl