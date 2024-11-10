pipeline {
    agent any

    environment {
        DOCKER_REPO = 'k1cornelsenp/projeto-ecommerce'
        DOCKER_IMAGE_APP = "${DOCKER_REPO}:latest"
        DOCKER_IMAGE_DB = "${DOCKER_REPO}-db:latest"
        K8S_DIR = 'k8s/'
        SQL_DIR = 'sql/'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/k1cornelsen/projeto-ecommerce.git'
            }
        }

        stage('Snyk Docker Image Scan - App') {
            steps {
                script {
                    sh "snyk container test ${DOCKER_IMAGE_APP} --severity-threshold=medium"
                }
            }
        }

        stage('Snyk Docker Image Scan - Database') {
            steps {
                script {
                    sh "snyk container test ${DOCKER_IMAGE_DB} --severity-threshold=medium"
                }
            }
        }

        stage('Build Docker Image - Database') {
            steps {
                dir(SQL_DIR) {
                    script {
                        docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                            docker.build(DOCKER_IMAGE_DB, '--no-cache .').push()
                        }
                    }
                }
            }
        }

        stage('Build Docker Image - App') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE_APP, '--no-cache -t ${DOCKER_IMAGE_APP} -f Dockerfile .')
                }
            }
        }

        stage('Push Docker Image - App') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        docker.image(DOCKER_IMAGE_APP).push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                dir(K8S_DIR) {
                    sh "microk8s kubectl apply -f banco-pv.yaml"
                    sh "microk8s kubectl apply -f deploy-banco.yaml"
                    sh "microk8s kubectl apply -f deploy-svc-banco.yaml"
                    sh "microk8s kubectl apply -f deploy.yaml"
                    sh "microk8s kubectl apply -f deploy-svc.yaml"
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

