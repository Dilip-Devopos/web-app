pipeline {
    agent any
    stages {
        stage('Clone Repository') {
            steps {
                // Clone the specified branch from the repository
                git branch: 'your-branch-name', url: 'https://github.com/your-username/your-repo.git'
            }
        }
        stage('Navigate and Run Python Script') {
            steps {
                script {
                    // Navigate to the specified directory
                    dir('your-directory') {
                        // Run the Python script
                        sh 'python3 your-script.py'
                    }
                }
            }
        }
    }
}
