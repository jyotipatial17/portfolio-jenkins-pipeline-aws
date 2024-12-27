pipeline {
    agent any
    tools { 
        git 'Default' // Ensure this matches the configured Git installation name in Jenkins 
    }
    environment {
        // Jenkins workspace and deployment directories
        EC2_USER = 'ubuntu'  // EC2 user (adjust as needed)
        EC2_HOST = '10.0.1.19'  // Private IP or Public IP of the EC2 instance
        EC2_KEY_PATH = '/home/ubuntu/vpc_test.pem'  // Path to your private SSH key
        BUILD_DIR = 'build'  // The output folder from npm run build
        DEPLOY_DIR = '/var/www/html'  // Apache's default document root on EC2
    }
    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from GitHub repository
                git url: 'https://github.com/jyotipatial17/portfolio-jenkins-pipeline-aws.git'
            }
        }
        stage('Install Dependencies') {
            steps {
                // Install npm dependencies
                sh 'npm install'
            }
        }
        stage('Build') {
            steps {
                // Run the build command (ensure your package.json has the correct build script)
                sh 'npm run build'
            }
        }
        stage('Test') {
            steps {
                // Run tests to ensure that everything is working
                sh 'npm test'
            }
        }
        stage('Deploy to EC2') {
            steps {
                script {
                    // Ensure the build directory is correctly defined
                    def buildDir = "${WORKSPACE}/build"  // Use WORKSPACE to get the actual Jenkins workspace directory
                    def deployDir = "${DEPLOY_DIR}"

                    // Copy the build output to the EC2 instance's deploy directory
                    sh """
                    scp -o StrictHostKeyChecking=no -i ${EC2_KEY_PATH} -r ${buildDir}/* ${EC2_USER}@${EC2_HOST}:${deployDir}
                    """

                    // Optionally, restart Apache on the EC2 instance to serve the new build
                    sh """
                    ssh -o StrictHostKeyChecking=no -i ${EC2_KEY_PATH} ${EC2_USER}@${EC2_HOST} 'sudo systemctl restart apache2'
                    """
                }
            }
        }
    }
    post {
        always {
            // Final cleanup and messaging
            echo 'Pipeline completed!'
        }
        success {
            // You can add notifications or additional actions here
            echo 'Deployment successful!'
        }
        failure {
            // If the pipeline fails, this section will run
            echo 'Deployment failed. Please check the logs.'
        }
    }
}
