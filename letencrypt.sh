#set -e
keyStoreFileName=shepherdKeystore.jks
keystorePassword=sdxroxxnosecret
FQDN="FIXME"
sudo apt install -y software-properties-common
sudo add-apt-repository  -y  ppa:certbot/certbot
sudo apt update  -y 
sudo apt install  -y  certbot
sudo service tomcat8 stop
cd /home/*/ # Replace by the location of the JKS file if it doesn't work
sudo certbot certonly  -d $FQDN --register-unsafely-without-email  --standalone --preferred-challenges http -n --agree-tos
sudo cp ${keyStoreFileName} ${keyStoreFileName}.bak
sudo keytool -delete -alias tomcat -keystore $keyStoreFileName -storepass $keystorePassword 
sudo openssl pkcs12 -export -in /etc/letsencrypt/live/$FQDN/fullchain.pem -inkey /etc/letsencrypt/live/$FQDN/privkey.pem -out ${keyStoreFileName}.pkcs12 -name tomcat -passout pass:$keystorePassword
sudo keytool -v -importkeystore -srckeystore ${keyStoreFileName}.pkcs12  -srcstorepass $keystorePassword -srcstoretype PKCS12 -destkeystore $keyStoreFileName -deststoretype JKS -storepass $keystorePassword -keypass $keystorePassword
service tomcat8 start
