pipeline {
    agent any
    stages {
        stage('Clone Repository') {
            steps {
                // Clone the specified branch from the repository
                git branch: 'main', url: 'https://github.com/Dilip-Devopos/web-app.git'
            }
        }
        stage('Check and Install NGINX') {
            steps {
                script {
                    // Check if NGINX is running
                    def isNginxRunning = sh(script: 'pgrep -x nginx', returnStatus: true) == 0
                    if (!isNginxRunning) {
                        echo 'NGINX is not running. Installing and configuring NGINX...'
                        
                        // Install NGINX
                        sh '''
                        apt-get update
                        apt-get install -y nginx
                        '''
                        
                        // Backup existing NGINX configuration
                        sh '''
                        sudo mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
                        '''
                        
                        // Create a new NGINX configuration file
                        sh '''
                        echo "server {
                            listen 80;
                            root /var/www/html;
                            index index.html;
                            
                            server_name _;

                            location / {
                                try_files \$uri \$uri/ =404;
                            }
                        }" | sudo tee /etc/nginx/sites-available/default
                        '''
                        
                        // Start NGINX
                        sh '''
                        sudo systemctl start nginx
                        '''
                    } else {
                        echo 'NGINX is already running. Skipping installation.'
                    }
                }
            }
        }
        stage('Deploy HTML') {
            steps {
                script {
                    // Copy the HTML file to NGINX's web root directory
                    sh '''
                    sudo cp -r * /var/www/html/
                    '''
                    
                    // Restart NGINX to apply the changes
                    sh '''
                    sudo systemctl restart nginx
                    '''
                }
            }
        }
    }
}
