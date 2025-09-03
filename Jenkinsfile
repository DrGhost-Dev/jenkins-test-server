pipeline {
	agent any
  environment {
    DOCKER_IMAGE = "mainnet-node"
    BUILD_NUMBER = "v1"
	}

  stages {
    stage('Checkout') {
      steps {
        echo 'Checking connection to GitHub...'
        git url: 'https://github.com/DrGhost-Dev/jenkins-test-server.git', branch: 'main'
      }
    }
    stage('Docker Image Build') {
      steps {
        sh '''
          docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} .
          docker build -t ${DOCKER_IMAGE}:latest .
        '''
      }
    }
    stage('Harbor Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'Harbor', usernameVariable: 'HARBOR_USER', passwordVariable: 'HARBOR_PASS')]){
          sh '''
            docker tag ${DOCKER_IMAGE}:${BUILD_NUMBER} harbor.blockgateway.net:8081/library/cicd:${BUILD_NUMBER} .
            docker login harbor.blockgateway.net:8081 -u ${HARBOR_USER} -p ${HARBOR_PASS}
            docker push harbor.blockgateway.net:8081/library/cicdtest:${BUILD_NUMBER}
          '''
        }
      }
    }
//     stage('Deploy to EC2') {
//       steps {
//         sshagent([env.EC2_SSH_CRED]) {
//           sh '''
//             ssh -o StrictHostKeyChecking=no ${EC2_HOST} "
//               set -e
//               if command -v docker >/dev/null 2>&1; then
//                 echo 'Docker-based deploy'
//                 if sudo docker ps -a | grep -q 'myapp'; then
//                   sudo docker stop myapp || true
//                   sudo docker rm myapp || true
//                 fi
//                 sudo docker pull ${DOCKER_IMAGE}:latest
//                 sudo docker run -d --name myapp -p 80:8080 ${DOCKER_IMAGE}:latest
//               else
//                 echo 'Package-based deploy (example)'
//                 sudo systemctl stop myapp || true
//                 sudo mkdir -p /opt/myapp
//                 # rsync/scp artifacts if needed
//                 sudo systemctl start myapp
//               fi
//             "
//           '''
//         }
//       }
//     }
//   }
//   post {
//     success { echo 'Deployment success' }
//     failure { echo 'Deployment failed' }
  }
}
