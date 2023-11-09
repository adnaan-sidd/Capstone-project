pipeline {
    agent any

    tools {
        nodejs 'nodejs'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    def scmVars = checkout scm
                    env.GIT_BRANCH = scmVars.GIT_BRANCH
                    echo "Git Branch: ${env.GIT_BRANCH}"
                }
            }
        }

        stage('Build and Test') {
            steps {
                script {
                    echo "Building and Testing"
                    withDockerRegistry(credentialsId: 'DOCKERHUB', toolName: 'docker') {
                        sh "docker build -t app ."
                        sh "docker tag app:latest adnaansidd/dev:latest"
                        sh "docker push adnaansidd/dev:latest"
                    }
                }
            }
        }

        stage('Deploy') {
            when {
                allOf {
                    expression { env.GIT_BRANCH ==~ /master/ }
                    expression { currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
                }
            }
            steps {
                echo "Deploying"
                sh "docker run -d -p 80:80 --name web-server adnaansidd/prod:latest"
            }
        }
    }
}
