pipeline {
    agent any

    environment {
        DOCKER_REPO = 'k1cornelsenp/projeto-ecommerce'
        DOCKER_IMAGE_APP = "${DOCKER_REPO}:latest"
        DOCKER_IMAGE_DB = "${DOCKER_REPO}-db:latest"
        K8S_DIR = 'k8s/'
        SQL_DIR = 'sql/'
        SNYK_TOKEN = credentials('SNYK_AUTH')
        DOCKER_HUB = credentials('DOCKER_HUB')
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/k1cornelsen/projeto-ecommerce.git'
            }
        }

        stage('Docker Hub Login') {
            steps {
                script {
                    sh "echo $DOCKER_HUB_PSW | docker login -u $DOCKER_HUB_USR --password-stdin"
                }
            }
        }

        stage('Snyk Docker Image Scan - App') {
            steps {
                script {
                    sh """
                        snyk auth --auth-type=token $SNYK_TOKEN
                        snyk container test ${DOCKER_IMAGE_APP} --severity-threshold=medium
                    """
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
                        docker.build(DOCKER_IMAGE_DB, '--no-cache .')
                    }
                }
            }
        }

        stage('Push Docker Image - Database') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        docker.image(DOCKER_IMAGE_DB).push()
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

        stage('Snyk Security Scan - Project Directory') {
            steps {
                script {
                    sh 'snyk code test . --severity-threshold=medium'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                    sh """
                        microk8s kubectl apply -f ${K8S_DIR}/banco-pv.yaml
                        microk8s kubectl apply -f ${K8S_DIR}/create-db.yaml
                        microk8s kubectl apply -f ${K8S_DIR}/deploy-banco.yaml
                        microk8s kubectl apply -f ${K8S_DIR}/deploy-svc-banco.yaml
                        microk8s kubectl apply -f ${K8S_DIR}/deploy.yaml
                        microk8s kubectl apply -f ${K8S_DIR}/deploy-svc.yaml
                    """
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

