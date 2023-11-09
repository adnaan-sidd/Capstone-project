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
                    env.CHANGESET = scmVars.GIT_COMMIT
                    echo "Git Branch: ${env.GIT_BRANCH}"
                    echo "Changeset: ${env.CHANGESET}"
                }
            }
        }

        stage('Build and Test for Dev Branch') {
            when {
                expression { env.GIT_BRANCH == 'origin/dev' && env.CHANGESET != null }
            }
            steps {
                echo "Building and Testing for Dev Branch"
                script {
                    withDockerRegistry(credentialsId: 'DOCKERHUB', toolName: 'docker') {
                        sh "docker build -t app ."
                        sh "docker tag app:latest adnaansidd/dev:latest"
                        sh "docker push adnaansidd/dev:latest"
                    }
                }
            }
        }

        stage('Build and Test for Master Branch') {
            when {
                expression { env.GIT_BRANCH == 'origin/master' && env.CHANGESET != null }
            }
            steps {
                echo "Building and Testing for Master Branch"
                script {
                    withDockerRegistry(credentialsId: 'DOCKERHUB', toolName: 'docker') {
                        sh "docker build -t app ."
                        sh "docker tag app:latest adnaansidd/prod:latest"
                        sh "docker push adnaansidd/prod:latest"
                    }
                }
            }
        }

        stage('Deploy') {
            when {
                allOf {
                    expression { env.GIT_BRANCH == 'origin/master' && env.CHANGESET != null }
                    expression { currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
                }
            }
            steps {
                echo "Deploying"
                script {
                    // SSH agent block for deploying with an SSH key
                    sshagent(['key']) {
                        // Execute the deploy.sh script from the GitHub master branch
                        sh 'ssh ec2-user@18.60.251.62 "bash -s" < deploy.sh'
                    }
                }
            }
        }
    }
}

