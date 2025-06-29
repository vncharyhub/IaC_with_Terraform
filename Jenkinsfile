pipeline {
    agent any

    parameters {
        choice(name: 'ENVIRONMENT', choices: ['dev', 'test', 'preprod', 'prod'], description: 'Select the environment to deploy')
    }

    environment {
        TF_VERSION     = "1.5.0"
        AWS_REGION     = "us-east-1"
        GIT_REPO       = "https://github.com/vncharyhub/IaC_with_Terraform.git"
        DOCKER_REPO    = "your-dockerhub-username/nginx-app"
        CREDENTIALS_ID = 'aws-jenkins-creds'              // AWS IAM creds in Jenkins
        SONARQUBE_ENV  = 'SonarQubeServer'                // SonarQube config in Jenkins
    }

    stages {
        stage('Checkout Branch') {
            steps {
                git url: 'https://github.com/vncharyhub/IaC_with_Terraform.git', branch: 'master'
            }
        }

        stage('Quality Gates with SonarQube Scanner') {
            parallel {
                stage('Static Code Analysis') {
                    steps {
                        echo "Running Static Code Analysis..."
                        // example: flake8 src/
                    }
                }

                stage('Unit Tests') {
                    steps {
                        echo "Running Unit Tests..."
                        // example: pytest tests/
                    }
                }

                stage('SonarQube Code Coverage') {
                    steps {
                        withSonarQubeEnv("${SONARQUBE_ENV}") {
                            sh """
                                sonar-scanner \\
                                  -Dsonar.projectKey=nginx-webapp \\
                                  -Dsonar.sources=. \\
                                  -Dsonar.host.url=$SONAR_HOST_URL \\
                                  -Dsonar.login=$SONAR_AUTH_TOKEN
                            """
                        }
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_REPO}:${params.ENVIRONMENT}-${env.BUILD_NUMBER}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${DOCKER_REPO}:${params.ENVIRONMENT}-${env.BUILD_NUMBER}
                    """
                }
            }
        }

        stage('Provision Infra with Terraform') {
            steps {
                script {
                    echo "Provisioning AWS Infra with Terraform for ${params.ENVIRONMENT}"
                }

                dir('infrastructure') {
                    git branch: 'master', url: "${env.GIT_REPO}"

                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: "${env.CREDENTIALS_ID}"
                    ]]) {
                        sh """
                            terraform workspace select ${params.ENVIRONMENT} || terraform workspace new ${params.ENVIRONMENT}
                            terraform init -backend-config="bucket=my-terraform-state-${params.ENVIRONMENT}" \\
                                           -backend-config="key=${params.ENVIRONMENT}/terraform.tfstate" \\
                                           -backend-config="region=${env.AWS_REGION}" \\
                                           -backend-config="dynamodb_table=terraform-locks"

                            terraform apply -auto-approve -var="environment=${params.ENVIRONMENT}"
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline for ${params.ENVIRONMENT} completed."
        }
    }
}
