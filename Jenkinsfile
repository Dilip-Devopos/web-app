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
                withAWS(region: 'ap-south-1', credentials: '38767c2c-c68b-47ac-a6f1-5aa4630f8352') {
                    s3Upload(bucket: 'dilip-bucket-14', file: 'deployment-package.zip')
                    awsCodeDeploy applicationName: 'WebAppDeployment', 
                                  deploymentGroupName: 'WebAppDeploymentGroup', 
                                  deploymentConfigName: 'CodeDeployDefault.AllAtOnce', 
                                  s3Location: [
                                      bucket: 'Asia Pacific (Mumbai) ap-south-1', 
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
