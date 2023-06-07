node{

    stage('Clone') {
        checkout scm
    }
    stage('Build image') {
            steps{
                app = docker.build("obabaldbiyat/Super-Mario-Crossover")
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
