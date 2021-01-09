#!/bin/bash

sleep 120

sudo apt-get update -y
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu
mkdir -p /home/ubuntu/jenkins_home
sudo chown -R 1000:1000 /home/ubuntu/jenkins_home
sudo docker run -d --restart=always -p 8080:8080 -p 50000:50000 -v /home/ubuntu/jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock --env JAVA_OPTS='-Djenkins.install.runSetupWizard=false' jenkins/jenkins

sleep 120

mkdir /home/ubuntu/kandula-prod
sudo chown -R 1000:1000 /home/ubuntu/kandula-prod

sudo cat <<EOF > /home/ubuntu/kandula-prod/checkstatus.sh
#!/bin/bash
url='http://website-to-test'
attempts=5
timeout=5
online=false

echo "Checking status of $url."

for (( i=1; i<=$attempts; i++ ))
do
  code=`curl -sL --connect-timeout 20 --max-time 30 -w "%{http_code}\\n" "$url" -o /dev/null`

  echo "Found code $code for $url."

  if [ "$code" = "200" ]; then
    echo "Website $url is online."
    online=true
    break
  else
    echo "Website $url seems to be offline. Waiting $timeout seconds."
    sleep $timeout
  fi
done
EOF

sudo apt install python-pip -y
sudo apt install python3-pip -y
sleep 60
cd /home/ubuntu/kandula-prod
git init
git clone https://github.com/RonnieTG/kandula_assignment.git
sleep 15
pip install -r requirements.txt
bin/run