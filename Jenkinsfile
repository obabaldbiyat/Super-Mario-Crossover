node{

    stage('Clone') {
        checkout scm
    }
    stage ('Build Image') {
       script{
                    sh 'sudo docker build -t obab/super-mario .'
                }
    }
            stage ('Docker Tag') {
            steps {
                script {
                    sh 'docker tag obab/super-mario obab/super-mario'
                    
                }
            }
        }
         stage('Login') {
      steps {
        script{
            sh 'docker login -u obab -p dckr_pat_9jVuDM0t2Zv5Ilw5AdUGSsOJnSo'
        }}
      }
        
        stage('Push to Docker Hub') {
            steps {
                
                script {
                     
                        sh 'docker push obab/super-mario'
                    }
                }
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
                sshCommand remote: remote, command: "docker run -d -p 9999:80 obab/super-mario"
            }
          }
