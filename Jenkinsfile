pipeline {
    agent any
    tools { 
        git 'Default'  // Ensure this matches the configured Git installation name in Jenkins 
    }
    environment {
        EC2_USER = 'ubuntu'  // Adjust as needed
        EC2_HOST = '43.205.195.231'  // Adjust as needed
        EC2_KEY_PATH = '/home/ubuntu/vpc_test.pem'  // Adjust as needed
        BUILD_DIR = '/var/lib/jenkins/workspace/portfloio/build'  // Ensure the build output directory is correct
        DEPLOY_DIR = '/var/www/html'  // Adjust as needed
    }
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/jyotipatial17/portfolio-jenkins-pipeline-aws.git' , branch:'main'
            }
        }
        stage('Install Dependencies') {
            steps { 
                timeout(time: 30, unit: 'MINUTES') 
                { 
                    sh 'npm install --legacy-peer-deps' 
                } 
            }
        }
        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }
        stage('Test') {
            steps {
                sh 'npm test'
            }
        }
        stage('Deploy to EC2') {
            steps {
                script {
                    def buildDir = "${BUILD_DIR}"  // Use BUILD_DIR from environment variables
                    def deployDir = "${DEPLOY_DIR}"

                    sh """
                    scp -o StrictHostKeyChecking=no -i ${EC2_KEY_PATH} -r ${buildDir}/* ${EC2_USER}@${EC2_HOST}:${deployDir}
                    """

                    sh """
                    ssh -o StrictHostKeyChecking-no -i ${EC2_KEY_PATH} ${EC2_USER}@${EC2_HOST} 'sudo systemctl restart apache2'
                    """
                }
            }
        }
    }
    post {
        always {
            echo 'Pipeline completed!'
        }
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed. Please check the logs.'
        }
    }
}
