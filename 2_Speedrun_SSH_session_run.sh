sudo apt-get update &&
sudo apt-get install git -y && sudo apt-get install -yq openjdk-8-jdk && sudo update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java && sudo apt-get install -yq maven && sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080 && export GCLOUD_PROJECT="$(curl -H Metadata-Flavor:Google http://metadata/computeMetadata/v1/project/project-id)" && java -version



git clone -b GSP166 https://github.com/chriskyfung/My-Qwiklabs-SpeedRun-Tank



cd ~/My-Qwiklabs-SpeedRun-Tank/courses/developingapps/java/devenv/

mvn clean install
mvn spring-boot:run
