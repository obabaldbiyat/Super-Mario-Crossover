node{

    stage('Clone') {
        checkout scm
    }
    stage ('Build Image') {
       script{
                    sh 'sudo docker build -t obab/SuperMario .'
                }
    }
        stage('Push image to Hub'){
                script{
                   withCredentials([string(credentialsId: 'dockerhub-pwd', variable: 'mariopwd')]) {
                   sh 'docker login -u obab -p ${mariopwd}'

    }
                   sh 'sudo docker push obab/SuperMario'
                }

    }
}
