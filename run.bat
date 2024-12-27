@echo off

REM Set environment variables
set EC2_USER=ubuntu
set EC2_HOST=10.0.1.19
set EC2_KEY_PATH=C:\path\to\your\key\file.pem
set REPO_URL=https://github.com/jyotipatial17/portfolio-jenkins-pipeline-aws.git
set BUILD_DIR=build
set DEPLOY_DIR=/var/www/html

REM Clone the repository
git clone %REPO_URL%
cd portfolio-jenkins-pipeline-aws

REM Install npm dependencies (Ensure npm is in your PATH)
npm install

REM Run the build command
npm run build

REM Run tests
npm test

REM Deploy the build to EC2
pscp -i %EC2_KEY_PATH% -r %BUILD_DIR%\* %EC2_USER%@%EC2_HOST%:%DEPLOY_DIR%

REM Restart Apache on EC2 instance
plink -i %EC2_KEY_PATH% %EC2_USER%@%EC2_HOST% "sudo systemctl restart apache2"

REM Final cleanup and messaging
echo Pipeline completed successfully!
pause
