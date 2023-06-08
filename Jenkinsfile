node{

    stage('Clone') {
        checkout scm
    }
    stage ('Build Image') {
       script{
                    sh 'sudo docker build -t supermario .'
                }
    }
     stage ('Docker Tag') {
        script {
                    sh 'docker tag supermario obab/supermario'             
                }
    }
     stage('Login') {
        script{
                    sh 'sudo docker login -u obab -p dckr_pat_9jVuDM0t2Zv5Ilw5AdUGSsOJnSo'
                }
    }      
     stage('Push to Docker Hub') {    
        script {
                    sh 'sudo docker push obab/supermario'
                }
    }
    
          node {
            def remote = [:]
            remote.name = 'obabjenkins'
            remote.host = '20.111.55.133'
            remote.user = 'oaldbiyat'
            remote.password = 'Azertyuiop1234'
            remote.allowAnyHosts = true
            stage('Remote SSH') {
                sshCommand remote: remote, command: "docker run -d -p 9999:80 obab/supermario"
            }
          }
}
