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
                   withCredentials([string(credentialsId: '6e47d430-60eb-4211-b49c-b63b06118ef3', variable: 'dockerhubpwd')]) {
                   sh 'docker login -u obab -p ${dockerhubpwd}'

    }
                   sh 'sudo docker push obab/super-mario'
                }

    }
}
