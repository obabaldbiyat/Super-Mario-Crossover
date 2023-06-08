node{

    stage('Clone') {
        checkout scm
    }
    stage ('Build Image') {
       script{
                    sh 'sudo docker build -t obab/devops-integration .'
                }
    }
        stage('Push image to Hub'){
                script{
                   withCredentials([string(credentialsId: 'dockerhub-pwd', variable: 'dockerhubpwd')]) {
                   sh 'docker login -u obab -p ${dockerhubpwd}'

}
                sh 'sudo docker push obab/SuperMario'
                }
            }
        }
    }
