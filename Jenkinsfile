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

        stage('Docker Hub Login Test') {
            steps {
                // Imprime a senha completa para verificação em ambiente de desenvolvimento
                echo "Senha Docker Hub: ${DOCKER_HUB_PSW}"

                // Tenta fazer login e verifica sucesso/falha
                sh "echo \$DOCKER_HUB_PSW | docker login -u \$DOCKER_HUB_USR --password-stdin || exit 1"
            }
        }

        stage('Snyk Docker Image Scan - App') {
            steps {
                sh """
                    snyk auth --auth-type=token $SNYK_TOKEN
                    snyk container test ${DOCKER_IMAGE_APP} --severity-threshold=medium
                """
            }
        }

        stage('Snyk Docker Image Scan - Database') {
            steps {
                sh "snyk container test ${DOCKER_IMAGE_DB} --severity-threshold=medium"
            }
        }

        stage('Build Docker Image - Database') {
            steps {
                dir(SQL_DIR) {
                    sh "docker build --no-cache -t ${DOCKER_IMAGE_DB} ."
                }
            }
        }

        stage('Push Docker Image - Database') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_HUB_USR', passwordVariable: 'DOCKER_HUB_PSW')]) {
                    sh """
                        echo \$DOCKER_HUB_PSW | docker login -u \$DOCKER_HUB_USR --password-stdin
                        docker push ${DOCKER_IMAGE_DB}
                    """
                }
            }
        }

        stage('Build Docker Image - App') {
            steps {
                sh "docker build --no-cache -t ${DOCKER_IMAGE_APP} -f Dockerfile ."
            }
        }

        stage('Push Docker Image - App') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_HUB_USR', passwordVariable: 'DOCKER_HUB_PSW')]) {
                    sh """
                        echo \$DOCKER_HUB_PSW | docker login -u \$DOCKER_HUB_USR --password-stdin
                        docker push ${DOCKER_IMAGE_APP}
                    """
                }
            }
        }

        stage('Snyk Security Scan - Project Directory') {
            steps {
                sh 'snyk code test . --severity-threshold=medium'
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

