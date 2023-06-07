node{

    stage('Clone') {
        checkout scm
    }
        stage('Build docker image'){
            steps{
                script{
                    sh 'sudo docker build -t obab/SuperMario .'
                }
            }
        }
        stage('Push image to Hub'){
            steps{
                script{
                   withCredentials([string(credentialsId: 'dockerhub-pwd', variable: 'dockerhubpwd')]) {
                   sh 'docker login -u obab -p ${dockerhubpwd}'

}
                   sh 'sudo docker push obab/SuperMario'
                }
            }
        }
    }
}