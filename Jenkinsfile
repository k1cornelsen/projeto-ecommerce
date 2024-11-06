pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'k1cornelsenp/projeto-ecommerce:latest'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/k1cornelsen/projeto-ecommerce.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE)
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        docker.image(DOCKER_IMAGE).push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f k8s/'
            }
        }

        stage('Snyk Security Scan - Full Project') {
            steps {
                script {
                    // Executa a análise Snyk em todo o diretório do projeto
                    sh 'snyk test --all-projects --severity-threshold=medium'
                }
            }
        }

        stage('Snyk Docker Image Scan') {
            steps {
                script {
                    // Executa a análise Snyk na imagem Docker
                    sh "snyk container test ${DOCKER_IMAGE} --severity-threshold=medium"
                }
            }
        }
    }

    post {
        success {
            echo 'Deploy realizado com sucesso!'
        }
        failure {
            echo 'A pipeline falhou!'
        }
    }
}
