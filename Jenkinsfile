pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        S3_BUCKET = 'dilip-bucket-14'
        DEPLOYMENT_PACKAGE = 'deployment-package.zip'
        S3_OBJECT = "s3://${S3_BUCKET}/${DEPLOYMENT_PACKAGE}"
        EC2_IP = '65.1.130.5'
        SSH_USER = 'ubuntu'
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
                    sh 'chmod 600 test.pem'
                    sh 'mkdir -p ~/.ssh'
                    sh "ssh-keyscan -H ${EC2_IP} >> ~/.ssh/known_hosts"

                    sh """
                    # Upload the deployment package to EC2 instance
                    scp -i test.pem ${DEPLOYMENT_PACKAGE} ${SSH_USER}@${EC2_IP}:~
                    scp -i test.pem install_nginx.sh ${SSH_USER}@${EC2_IP}:~

                    # Connect to the EC2 instance and run the install script
                    ssh -i test.pem ${SSH_USER}@${EC2_IP} 'bash ~/install_nginx.sh'
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
