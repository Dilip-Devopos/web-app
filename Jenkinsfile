pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Dilip-Devopos/web-app.git'
            }
        }

        stage('Prepare Deployment Package') {
            steps {
                sh 'zip -r deployment-package.zip *'
                archiveArtifacts artifacts: 'deployment-package.zip', fingerprint: true
            }
        }
        
        stage('Deploy to AWS') {
            steps {
                withAWS(region: 'ap-south-1', credentials: 'f2d27d6f-39e8-4f7c-b43c-7178ab11d6a2') {
                    s3Upload(bucket: 'dilip-bucket-14', file: 'deployment-package.zip')
                    awsCodeDeploy applicationName: 'WebAppDeployment', 
                                  deploymentGroupName: 'WebAppDeploymentGroup', 
                                  deploymentConfigName: 'CodeDeployDefault.AllAtOnce', 
                                  s3Location: [
                                      bucket: 'dilip-bucket-14', 
                                      key: 'deployment-package.zip', 
                                      bundleType: 'zip'
                                  ]
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment Successful!'
        }
        failure {
            echo 'Deployment Failed!'
        }
    }
}
