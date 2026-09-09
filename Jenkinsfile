pipeline {

    agent {
        label 'docker-agent-custom'
    }

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

                            sh '''
                                chmod +x mvnw

                                ./mvnw \
                                  -Dmaven.wagon.http.retryHandler.count=5 \
                                  clean verify
                            '''

                        } else {

                            bat '''
                                mvnw.cmd ^
                                  -Dmaven.wagon.http.retryHandler.count=5 ^
                                  clean verify
                            '''
                        }
                    }
                }
            }
        }


        stage('SonarQube analysis') {

            when {
                expression {
                    params.RUN_SONAR
                }
            }

            steps {

                withSonarQubeEnv('SonarQube') {

                    script {

                        retry(2) {

                            if (isUnix()) {

                                sh '''
                                    test -n "$SONAR_AUTH_TOKEN" || {
                                        echo "ERROR: SonarQube installation token is missing"
                                        exit 1
                                    }

                                    ./mvnw \
                                      -Dmaven.wagon.http.retryHandler.count=5 \
                                      org.sonarsource.scanner.maven:sonar-maven-plugin:5.8.0.7211:sonar \
                                      -Dsonar.projectKey=empassign \
                                      -Dsonar.host.url="$SONAR_HOST_URL" \
                                      -Dsonar.token="$SONAR_AUTH_TOKEN"
                                '''

                            } else {

                                bat '''
                                    if "%SONAR_AUTH_TOKEN%"=="" (
                                        echo ERROR: SonarQube installation token is missing
                                        exit /b 1
                                    )

                                    mvnw.cmd ^
                                      -Dmaven.wagon.http.retryHandler.count=5 ^
                                      org.sonarsource.scanner.maven:sonar-maven-plugin:5.8.0.7211:sonar ^
                                      -Dsonar.projectKey=empassign ^
                                      -Dsonar.host.url="%SONAR_HOST_URL%" ^
                                      -Dsonar.token="%SONAR_AUTH_TOKEN%"
                                '''
                            }
                        }
                    }
                }
            }
        }


        stage('Quality gate') {

            when {
                expression {
                    params.RUN_SONAR
                }
            }

            steps {

                timeout(time: 10, unit: 'MINUTES') {

                    waitForQualityGate(
                        abortPipeline: true
                    )
                }
            }
        }


        stage('Archive WAR') {

            steps {

                archiveArtifacts(
                    artifacts: 'target/*.war',
                    fingerprint: true
                )

                junit(
                    testResults: '**/target/surefire-reports/TEST-*.xml',
                    allowEmptyResults: false
                )
            }
        }


        stage('Deploy to Nexus') {

            when {
                expression {
                    params.DEPLOY_NEXUS
                }
            }

            steps {

                script {

                    if (!params.NEXUS_RELEASE_URL?.trim()) {

                        error(
                            'NEXUS_RELEASE_URL is required when DEPLOY_NEXUS is enabled.'
                        )
                    }
                }


                withCredentials([

                    usernamePassword(
                        credentialsId: 'nexus-account',
                        usernameVariable: 'NEXUS_USERNAME',
                        passwordVariable: 'NEXUS_PASSWORD'
                    )

                ]) {

                    withMaven(
                        mavenSettingsConfig: 'maven-nexus-settings'
                    ) {

                        script {

                            def deployCommand =
                                "deploy:deploy-file " +
                                "-Dfile=target/empassign-1.0-SNAPSHOT.war " +
                                "-DgroupId=com.example " +
                                "-DartifactId=empassign " +
                                "-Dversion=1.0.${env.BUILD_NUMBER} " +
                                "-Dpackaging=war " +
                                "-DrepositoryId=nexus " +
                                "-Durl=${params.NEXUS_RELEASE_URL} " +
                                "-DgeneratePom=true"


                            if (isUnix()) {

                                sh """
                                    test -n "\$NEXUS_USERNAME" &&
                                    test -n "\$NEXUS_PASSWORD" || {
                                        echo 'ERROR: nexus-account is incomplete'
                                        exit 1
                                    }

                                    ./mvnw ${deployCommand}
                                """

                            } else {

                                bat """
                                    if "%NEXUS_USERNAME%"=="" exit /b 1
                                    if "%NEXUS_PASSWORD%"=="" exit /b 1

                                    mvnw.cmd ${deployCommand}
                                """
                            }
                        }
                    }
                }
            }
        }


        stage('Deploy with Docker Compose') {

            steps {

                script {

                    def compose

                    if (isUnix()) {

                        compose = sh(
                            returnStdout: true,
                            script: '''
                                if docker compose version >/dev/null 2>&1; then
                                    printf "docker compose"
                                elif command -v docker-compose >/dev/null 2>&1; then
                                    printf "docker-compose"
                                else
                                    echo "ERROR: Docker Compose is not available"
                                    exit 1
                                fi
                            '''
                        ).trim()

                    } else {

                        compose = bat(
                            returnStdout: true,
                            script: '''
                                @docker compose version >NUL 2>&1 && (
                                    echo docker compose
                                ) || (
                                    where docker-compose >NUL 2>&1 && (
                                        echo docker-compose
                                    ) || (
                                        echo ERROR: Docker Compose is not available
                                        exit /b 1
                                    )
                                )
                            '''
                        ).trim()
                    }


                    echo "Using Compose command: ${compose}"


                    if (isUnix()) {

                        sh """
                            ${compose} up -d --build --wait
                        """

                    } else {

                        bat """
                            ${compose} up -d --build --wait
                        """
                    }
                }
            }
        }


        stage('Smoke test') {

            steps {

                sh '''
                    echo "Waiting for Tomcat..."

                    for i in $(seq 1 30); do

                        if curl --fail \
                            http://tomcat:8080/empassign/ \
                            >/dev/null 2>&1; then

                            echo "Tomcat is ready."
                            echo "Smoke test PASSED."

                            exit 0
                        fi

                        echo "Tomcat not ready yet ($i/30)..."

                        sleep 2
                    done


                    echo "Smoke test FAILED."

                    echo "Tomcat status:"
                    docker compose ps


                    echo ""
                    echo "Tomcat logs:"

                    docker compose logs tomcat || true


                    exit 1
                '''
            }
        }
    }


    post {

        always {

            script {

                if (isUnix()) {

                    sh '''
                        if docker compose version >/dev/null 2>&1; then

                            docker compose logs \
                                --no-color \
                                > docker-compose.log

                        elif command -v docker-compose >/dev/null 2>&1; then

                            docker-compose logs \
                                --no-color \
                                > docker-compose.log

                        else

                            : > docker-compose.log
                        fi || true
                    '''

                } else {

                    bat '''
                        docker compose logs --no-color > docker-compose.log 2>NUL ||
                        docker-compose logs --no-color > docker-compose.log 2>NUL ||
                        type nul > docker-compose.log
                    '''
                }
            }


            archiveArtifacts(
                artifacts: 'docker-compose.log',
                allowEmptyArchive: true
            )
        }


        failure {

            script {

                if (isUnix()) {

                    sh '''
                        if docker compose version >/dev/null 2>&1; then

                            docker compose ps

                        elif command -v docker-compose >/dev/null 2>&1; then

                            docker-compose ps
                        fi || true
                    '''

                } else {

                    bat '''
                        docker compose ps ||
                        docker-compose ps ||
                        exit /b 0
                    '''
                }
            }
        }
    }
}