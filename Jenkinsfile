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
            defaultValue: '',
            description: 'Full URL of the Nexus releases repository'
        )
    }

    environment {
        COMPOSE_PROJECT_NAME = 'empassign-ci'
        SONAR_TOKEN = credentials('sonar-token')
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
                    if (isUnix()) {
                        sh 'chmod +x mvnw && ./mvnw clean verify'
                    } else {
                        bat 'mvnw.cmd clean verify'
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
                        if (isUnix()) {
                            sh './mvnw sonar:sonar -Dsonar.projectKey=empassign -Dsonar.token="$SONAR_TOKEN"'
                        } else {
                            bat 'mvnw.cmd sonar:sonar -Dsonar.projectKey=empassign -Dsonar.token="%SONAR_TOKEN%"'
                        }
                    }
                }
            }
        }

        stage('Quality gate') {
            when {
                expression { params.RUN_SONAR }
            }
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Archive WAR') {
            steps {
                archiveArtifacts artifacts: 'target/*.war', fingerprint: true
                junit testResults: '**/target/surefire-reports/TEST-*.xml', allowEmptyResults: false
            }
        }

        stage('Deploy to Nexus') {
            when {
                expression { params.DEPLOY_NEXUS }
            }
            steps {
                script {
                    if (!params.NEXUS_RELEASE_URL?.trim()) {
                        error 'NEXUS_RELEASE_URL is required when DEPLOY_NEXUS is enabled.'
                    }
                }
                withCredentials([usernamePassword(
                    credentialsId: 'nexus-account',
                    usernameVariable: 'NEXUS_USERNAME',
                    passwordVariable: 'NEXUS_PASSWORD'
                )]) {
                    withMaven(mavenSettingsConfig: 'maven-nexus-settings') {
                        script {
                            def deployCommand = "deploy:deploy-file -Dfile=target/empassign-1.0-SNAPSHOT.war " +
                                "-DgroupId=com.example -DartifactId=empassign -Dversion=1.0.${env.BUILD_NUMBER} " +
                                "-Dpackaging=war -DrepositoryId=nexus " +
                                "-Durl=${params.NEXUS_RELEASE_URL} -DgeneratePom=true"
                            if (isUnix()) {
                                sh "./mvnw ${deployCommand}"
                            } else {
                                bat "mvnw.cmd ${deployCommand}"
                            }
                        }
                    }
                }
            }
        }

        stage('Deploy with Docker Compose') {
            steps {
                script {
                    if (isUnix()) {
                        sh 'docker compose up -d --wait'
                    } else {
                        bat 'docker compose up -d --wait'
                    }
                }
            }
        }

        stage('Smoke test') {
            steps {
                script {
                    if (isUnix()) {
                        sh 'curl --fail --retry 20 --retry-delay 3 http://localhost:8080/empassign/'
                    } else {
                        bat 'curl.exe --fail --retry 20 --retry-delay 3 http://localhost:8080/empassign/'
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                if (isUnix()) {
                    sh 'docker compose logs --no-color > docker-compose.log || true'
                } else {
                    bat 'docker compose logs --no-color > docker-compose.log'
                }
            }
            archiveArtifacts artifacts: 'docker-compose.log', allowEmptyArchive: true
        }
        failure {
            script {
                if (isUnix()) {
                    sh 'docker compose ps || true'
                } else {
                    bat 'docker compose ps'
                }
            }
        }
    }
}