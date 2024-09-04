pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        S3_BUCKET = 'dilip-bucket-14'
        DEPLOYMENT_PACKAGE = 'deployment-package.zip'
        S3_OBJECT = "s3://${S3_BUCKET}/${DEPLOYMENT_PACKAGE}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/Dilip-Devopos/web-app.git', branch: 'main'
            }
        }

        stage('Prepare Deployment Package') {
            steps {
                script {
                    sh 'zip -r ${DEPLOYMENT_PACKAGE} Jenkinsfile README.md app.js appspec.yml index.html install_nginx.sh styles.css'
                }
                archiveArtifacts artifacts: "${DEPLOYMENT_PACKAGE}", allowEmptyArchive: true
            }
        }

        stage('Upload to S3') {
            steps {
                withCredentials([aws(credentialsId: 'f2d27d6f-39e8-4f7c-b43c-7178ab11d6a2', region: "${AWS_REGION}")]) {
                    sh "aws s3 cp ${DEPLOYMENT_PACKAGE} ${S3_OBJECT}"
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    sh """
                    # Example commands to deploy using AWS CLI
                    # Assuming you have the necessary scripts to handle deployment
                    aws ec2 describe-instances --region ${AWS_REGION} # Replace with actual deployment commands
                    """
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        failure {
            echo 'Deployment Failed!'
        }
    }
}
