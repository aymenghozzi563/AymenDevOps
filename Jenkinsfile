pipeline {
    agent any

    tools {
        maven 'M2_HOME'
    }

    environment {
        DOCKER_IMAGE = "aymenghozzi/devops-project:latest"
    }

    stages {
        stage('Code Checkout') {
            steps {
                echo "Checking out code from GitHub..."
                git branch: 'main',
                    url: 'https://github.com/aymenghozzi563/AymenDevOps.git'
            }
        }

        stage('Code Build') {
            steps {
                echo "Building project with Maven..."
                sh 'mvn install -Dmaven.test.skip=true'
            }
        }

        stage('Maven Package') {
            steps {
                echo "Packaging project..."
                sh 'mvn package -Dmaven.test.skip=true'
            }
        }


        stage('SonarQube Analysis') {
            steps {
                echo "Running SonarQube analysis..."
                withCredentials([string(credentialsId: 'sonar-access', variable: 'SONAR_TOKEN')]) {
                    sh """
                        mvn sonar:sonar \
                        -Dsonar.projectKey=DEVOPS_PROJECT \
                        -Dsonar.host.url=http://192.168.33.10:9000 \
                        -Dsonar.login=$SONAR_TOKEN
                    """
                }
            }
        }

        stage('Docker Login') {
            steps {
                echo "Logging into Docker Hub..."
                withCredentials([usernamePassword(credentialsId: 'docker-token', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh "docker build -t $DOCKER_IMAGE ."
            }
        }

        stage('Push Docker Image') {
            steps {
                echo "Pushing Docker image to Docker Hub..."
                sh "docker push $DOCKER_IMAGE"
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo "Deploying MySQL and Spring Boot app to Kubernetes..."
                sh "kubectl apply -f k8s/mysql-deployment.yaml"
                sh "kubectl apply -f k8s/app-deployment.yaml"
            }
        }


    }

    post {
        always {
            echo "====== Pipeline finished ======"
        }
        success {
            echo "===== Pipeline executed successfully ====="
        }
        failure {
            echo "====== Pipeline execution failed ======"
        }
    }
}