pipeline {
    agent any

    environment {
        PROJECT_NAME = "ibaco-ci/cd-ansible-docker"
        DOCKERHUB_USERNAME = "thanushrii"
        DOCKERHUB_REPO = "ibaco"
        IMAGE_NAME = "${DOCKERHUB_USERNAME}/${DOCKERHUB_REPO}"
    }

    stages {

        stage("Build Application Container Image") {
            steps {
                sh """
                    set -e
                    docker build -t ${IMAGE_NAME}:latest .
                """
            }
        }

        stage("Version Docker Image with Build ID") {
            steps {
                script {
                    def buildNumber = env.BUILD_ID
                    sh "docker tag ${IMAGE_NAME}:latest ${IMAGE_NAME}:${buildNumber}"
                }
            }
        }

        stage("Authenticate with DockerHub Registry") {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                        set -e
                        echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin
                    """
                }
            }
        }

        stage("Push Images to DockerHub Registry") {
            steps {
                script {
                    def buildNumber = env.BUILD_ID
                    sh """
                        set -e
                        docker push ${IMAGE_NAME}:latest
                        docker push ${IMAGE_NAME}:${buildNumber}
                    """
                }
            }
        }

        stage("Remove Local Docker Images") {
            steps {
                script {
                    def buildNumber = env.BUILD_ID
                    sh """
                        docker rmi ${IMAGE_NAME}:latest || true
                        docker rmi ${IMAGE_NAME}:${buildNumber} || true
                        docker system prune -f || true
                    """
                }
            }
        }

        stage("Logout from DockerHub") {
            steps {
                sh "docker logout"
            }
        }

        stage("Transfer Deployment Playbook to Ansible User") {
            steps {
                sh '''
                    set -e
                    echo "Copying deploy playbook..."

                    sudo cp "$WORKSPACE/deploy-container.yml" /home/ansible/
                    sudo chown ansible:ansible /home/ansible/deploy-container.yml

                    echo "File copied successfully!"
                '''
            }
        }

        stage("Execute Ansible Deployment Playbook") {
            steps {
                sh '''
                    set -e
                    sudo -u ansible ansible-playbook /home/ansible/deploy-container.yml
                '''
            }
        }
    }

    post {
        success {
            echo "Ibaco CI/CD pipeline executed successfully!"
        }
        failure {
            echo "Ibaco CI/CD pipeline failed!"
        }
        always {
            echo "Pipeline execution completed."
        }
    }
}
