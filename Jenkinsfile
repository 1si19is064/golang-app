// Jenkinsfile
pipeline {
    agent any

    environment {
        // --- CHANGE 1: Update IMAGE_NAME with your Docker Hub username ---
        IMAGE_NAME = "tejas20012001/golang-app"
        IMAGE_TAG = "latest"
    }

    stages {
        stage('Clone Repository') {
            steps {
                echo 'Cloning Git repository...'
                git branch: 'main',
                    credentialsId: 'github-creds', // Ensure 'github-creds' is set up in Jenkins
                    url: 'https://github.com/1si19is064/golang-app.git'
                echo 'Repository cloned successfully.'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image: ${IMAGE_NAME}:${IMAGE_TAG}"
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                echo 'Docker image built successfully.'
            }
        }

        stage('Push Docker Image') {
            steps {
                echo "Pushing Docker image to Docker Hub..."
                withCredentials([string(credentialsId: 'dockerhub-password', variable: 'DOCKERHUB_PASS')]) {
                    sh """
                        echo "Logging into Docker Hub as tejas20012001..." // --- CHANGE 2: Update username here ---
                        echo "${DOCKERHUB_PASS}" | docker login -u tejas20012001 --password-stdin
                        echo "Login successful. Pushing image..."
                        docker push ${IMAGE_NAME}:${IMAGE_TAG}
                        echo "Docker image pushed successfully."
                        docker logout
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo 'Deploying application to Kubernetes...'
                sh 'kubectl apply -f k8s/deployment.yaml'
                sh 'kubectl apply -f k8s/service.yaml'
                echo 'Application deployed to Kubernetes.'

                script {
                    echo 'Waiting for deployment to become ready...'
                    sleep 10
                    sh "kubectl rollout status deployment/${IMAGE_NAME.split('/')[-1]}"
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
        success {
            echo 'Pipeline executed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
        cleanup {
            echo 'Cleaning up workspace...'
            cleanWs()
        }
    }
}