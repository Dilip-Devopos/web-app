pipeline {
    agent any

    environment {
        EC2_IP = '65.2.175.87' 
        SSH_USER = 'ubuntu'
    }

    stages {
        stage('Checkout') {
            steps {
                // Cloning the latest code from your Git repository
                git branch: 'main', url: 'https://github.com/Dilip-Devopos/web-app.git'// Replace with your Git repository URL
            }
        }

        stage('Install/Verify NGINX') {
            steps {
                sshagent (credentials: ['ec2-ssh-credentials']) {
                    // Check if NGINX is installed; if not, install it
                    sh """
                    ssh -o StrictHostKeyChecking=no ${SSH_USER}@${EC2_IP} <<EOF
                    if ! [ -x \$(command -v nginx) ]; then
                        sudo apt-get update
                        sudo apt-get install nginx -y
                    fi
                    EOF
                    """
                }
            }
        }

        stage('Deploy Application') {
            steps {
                sshagent (credentials: ['ec2-ssh-credentials']) {
                    // Transfer the updated HTML file and restart NGINX
                    sh """
                    scp -o StrictHostKeyChecking=no index.html ${SSH_USER}@${EC2_IP}:/tmp/index.html
                    ssh ${SSH_USER}@${EC2_IP} <<EOF
                    sudo systemctl stop nginx
                    sudo mv web-app/index.html /var/www/html/index.html
                    sudo systemctl start nginx
                    EOF
                    """
                }
            }
        }
    }

    post {
        always {
            cleanWs() // Clean up workspace after job completion
        }
    }
}
