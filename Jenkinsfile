pipeline {
  agent any
  triggers {
    // GitHub Webhook이 활성화되어 있으면 별도 cron 없이 푸시 시 자동 트리거됨
  }
  environment {
    DOCKER_IMAGE = "registry.example.com/myapp" // 또는 ECR/Hub 경로
    GIT_CREDENTIALS = "github_access_token"    // GitHub 토큰/자격증명 ID
    EC2_SSH_CRED = "aws-dev-deploy-ec2-instance" // EC2 SSH key 자격증명 ID
    EC2_HOST = "ec2-user@EC2_PUBLIC_DNS_OR_IP"   // 예: ec2-user@ec2-1-2-3-4.ap-northeast-2.compute.amazonaws.com
  }
  stages {
    stage('Checkout') {
      steps {
        git url: 'https://github.com/org/repo.git', branch: 'main', credentialsId: env.GIT_CREDENTIALS
      }
    }
    stage('Build') {
      steps {
        sh 'echo "Build... run build tool here (e.g., mvn package or npm ci && npm run build)"'
      }
    }
    stage('Test') {
      steps {
        sh 'echo "Test... run unit/integration tests here"'
      }
    }
    stage('Docker Build & Push') {
      when { expression { return true } } // 필요 시 조건부
      steps {
        sh '''
          docker build -t ${DOCKER_IMAGE}:latest .
          docker push ${DOCKER_IMAGE}:latest
        '''
      }
    }
    stage('Deploy to EC2') {
      steps {
        sshagent([env.EC2_SSH_CRED]) {
          sh '''
            ssh -o StrictHostKeyChecking=no ${EC2_HOST} "
              set -e
              if command -v docker >/dev/null 2>&1; then
                echo 'Docker-based deploy'
                if sudo docker ps -a | grep -q 'myapp'; then
                  sudo docker stop myapp || true
                  sudo docker rm myapp || true
                fi
                sudo docker pull ${DOCKER_IMAGE}:latest
                sudo docker run -d --name myapp -p 80:8080 ${DOCKER_IMAGE}:latest
              else
                echo 'Package-based deploy (example)'
                sudo systemctl stop myapp || true
                sudo mkdir -p /opt/myapp
                # rsync/scp artifacts if needed
                sudo systemctl start myapp
              fi
            "
          '''
        }
      }
    }
  }
  post {
    success { echo 'Deployment success' }
    failure { echo 'Deployment failed' }
  }
}
