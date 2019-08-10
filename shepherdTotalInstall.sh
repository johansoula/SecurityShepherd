#set -e

shepherdServerXmlLocation=https://raw.githubusercontent.com/owasp/SecurityShepherd/master/src/setupFiles/tomcatShepherdSampleServer.xml
shepherdWebXmlLocation=https://raw.githubusercontent.com/owasp/SecurityShepherd/master/src/setupFiles/tomcatShepherdSampleWeb.xml
shepherdManualPackLocation=https://github.com/OWASP/SecurityShepherd/releases/download/v3.1/owaspSecurityShepherd_v3.1_ManualPack.zip
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
else
  # Stop Ubuntu Bionic from complaining about no internet connection on boot
  systemctl disable systemd-networkd-wait-online.service
  systemctl mask systemd-networkd-wait-online.service
	# Install Pre-Requisite Stuff
	sudo add-apt-repository universe -y #Tomcat8 is here
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
	echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list #mongodb is here
	sudo apt update -y
	sudo apt install -y debconf-utils software-properties-common
	echo "oracle-java12-installer shared/accepted-oracle-license-v1-2 select true" | sudo debconf-set-selections
	echo "oracle-java12-installer shared/accepted-oracle-license-v1-2 seen true" | sudo debconf-set-selections
	sudo apt upgrade -y
	sudo add-apt-repository ppa:linuxuprising/java -y
	sudo apt update -y
	sudo apt install -y oracle-java12-installer
	sudo ln -s /usr/lib/jvm/java-12-oracle /usr/lib/jvm/default-java
	sudo apt install -y  tomcat8 tomcat8-admin mysql-server-5.7 mongodb-org unzip

	#Configuring Tomcat to Run the way we want (Oracle Java, HTTPs, Port 80 redirect to 443
	echo "Configuring Tomcat"
	sudo echo "JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> /etc/default/tomcat8
	sudo echo "AUTHBIND=yes" >> /etc/default/tomcat8
  #Have to CHOWN conf / etc/tomcat8 so Tomcat can create DB Auth / DB Prop files there.
  sudo chown tomcat8 /etc/tomcat8
  sudo chown -R tomcat8 /usr/share/tomcat8/
	cd /home/*
	homeDirectory="$(pwd)/"
	keyStoreFileName="shepherdKeystore.jks"
	keystorePassword="sdxroxxnosecret"
	echo "Please enter the password you would like to use for your Keystore (Used for HTTPs on Tomcat)"
	keytool -genkey -alias tomcat -keyalg RSA -destkeystore $keyStoreFileName -deststoretype JKS -storepass $keystorePassword -keypass $keystorePassword  -dname "CN=owasp, OU=Security, O=Sdx, L=France, S=France, C=FR" 
	touch web.xml
	touch server.xml
	rm web.xml
	rm server.xml
	wget --quiet $shepherdWebXmlLocation -O web.xml
	wget --quiet $shepherdServerXmlLocation -O server.xml
	escapedFileName=$(echo "$homeDirectory$keyStoreFileName" | sed 's/\//\\\//g')
	echo $escapedFileName
	sed -i "s/____.*____/$escapedFileName/g" server.xml
	echo ""
	sed -i "s/___.*___/$keystorePassword/g" server.xml
	echo "Overwriting default tomcat Config with new config... (Do Not Ignore Any Errors From this point)"
	cat server.xml > /var/lib/tomcat8/conf/server.xml
	cat web.xml > /var/lib/tomcat8/conf/web.xml
	rm server.xml
	rm web.xml
	touch /etc/authbind/byport/80
	touch /etc/authbind/byport/443
	chmod 500 /etc/authbind/byport/80
	chmod 500 /etc/authbind/byport/443
	chown tomcat8 /etc/authbind/byport/80
	chown tomcat8 /etc/authbind/byport/443

  echo "Configuring MySQL (Blank Pass, just hit return after these two commands)"
	mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'CowSaysMoo'; FLUSH PRIVILEGES;" --force 

	#Download and Deploy Shepherd
  echo "Setting Up Shepherd"
  	sudo apt install dos2unix
	sudo wget --quiet $shepherdManualPackLocation -O manualPack.zip
	sudo mkdir manualPack
	sudo unzip manualPack.zip -d manualPack
	sudo dos2unix manualPack/*.js
	sudo chmod 775 manualPack/*.war
	mv manualPack/ROOT.war /var/lib/tomcat8/webapps/
	rmdir --ignore-fail-on-non-empty /usr/share/tomcat8/webapps
	ln -s /var/lib/tomcat8/webapps  /usr/share/tomcat8/webapps
	sudo rm -rf /var/lib/tomcat8/webapps/ROOT
	sudo ln -s /etc/tomcat8 /usr/share/tomcat8/conf
	sudo chown -R tomcat8:tomcat8  /usr/share/tomcat8/ /var/lib/tomcat8/webapps
	#Restart Tomcat
	sudo service tomcat8 restart
	echo "Shepherd is Ready to Rock!"


        echo "Configuring MongoDB"
  	sudo service mongod start
  	systemctl enable mongod.service
	sleep 15
        mongo manualPack/mongoSchema.js
fi

echo "MySQL pass: CowSaysMoo"
echo "Installation token: "
cat /var/lib/tomcat8//conf/SecurityShepherd.auth
echo
