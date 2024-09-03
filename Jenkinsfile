pipeline {
    agent any
    stages {
        stage('Clone Repository') {
            steps {
                // Clone the specified branch from the repository
                git branch: 'main', url: 'https://github.com/Dilip-Devopos/web-app.git'
            }
        }
        stage('Stop and Start Service') {
            steps {
                script {
                    // Navigate to the web-app directory and stop any existing HTTP server
                    sh '''
                    if pgrep -f "python3 -m http.server 9000" > /dev/null; then
                        echo "Stopping existing HTTP server..."
                        pkill -f "python3 -m http.server 9000"
                    fi
                    '''

                    // Start the HTTP server in the background
                    sh '''
                    cd web-app
                    echo "Starting new HTTP server..."
                    python3 -m http.server 9000 &
                    '''
                }
            }
        }
    }
}
