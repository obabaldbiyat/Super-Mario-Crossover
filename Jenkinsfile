node{

    stage('Clone') {
        checkout scm
    }
    stage ('Build Image') {
       script{
                    sh 'sudo docker build -t obab/super-mario .'
                }
    }
        stage('Push image to Hub'){
                script{
                   withCredentials([string(credentialsId: 'dockerhub-pwd', variable: 'mariopwd')]) {
                   sh 'docker login -u obab -p ${mariopwd}'

    }
                   sh 'sudo docker push obab/super-mario'
                }

    }
}
