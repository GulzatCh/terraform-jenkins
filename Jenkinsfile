pipeline{ 
 
 agent any 
 stages { 
    stage('init') { 
    steps { 
        sh 'terraform init' 
    } 
    } 
    stage('plan') { 
    steps { 
        withCredentials([aws(accessKeyVariable:'AWS_ACCESS_KEY_ID', credentialsId: 'gulzat-aws-id', secretKeyVarible: 'AWS_SECRET_ACCESS_KEY')]) { 
        sh 'terraform plan ' 
        } 
    } 
    } 
    stage('terraform apply') { 
    steps { 
        withCredentials([aws(accessKeyVariable:'AWS_ACCESS_KEY_ID', credentialsId: 'gulzat-aws-id', secretKeyVarible: 'AWS_SECRET_ACCESS_KEY')]) { 
        sh 'terraform apply -auto-approve ' 
        } 
    } 
    } 
      } 
 } 
}
