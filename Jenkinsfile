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
                   sh 'docker login -u obab -p dckr_pat_9jVuDM0t2Zv5Ilw5AdUGSsOJnSo'
                   sh 'sudo docker push obab/super-mario'
                }

    }
