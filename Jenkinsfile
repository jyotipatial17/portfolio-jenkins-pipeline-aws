pipeline {
    agent any
    environment {
        // Jenkins workspace and deployment directories
        GIT_CREDENTIALS = credentials('git-hub-token') 
        BUILD_DIR = '/var/lib/jenkins/workspace/portfolio-jenkins-pipeline-aws'  // Ensure this is the correct path
        DEPLOY_DIR = '/var/www/html/'  // Apache's default document root
    }
    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from GitHub repository
                git credentialsId: 'git-hub-token', url: 'https://github.com/jyotipatial17/portfolio-jenkins-pipeline-aws.git'
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
        stage('Deploy') {
            steps {
                script {
                    // Ensure the build directory is correctly defined (build is the default output for create-react-app)
                    def buildDir = "${WORKSPACE}/build"  // Use WORKSPACE to get the actual Jenkins workspace directory
                    def deployDir = "${DEPLOY_DIR}"
                    
                    // Ensure the deploy directory exists (in case it's missing)
                    sh """
                    if [ ! -d $deployDir ]; then
                        sudo mkdir -p $deployDir
                    fi
                    """
                    
                    // Copy build output to the deployment directory on the server
                    sh "sudo cp -r $buildDir/* $deployDir"

                    // Optionally, restart Apache web server
                    sh '''
                    sudo systemctl restart apache2
                    '''
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
