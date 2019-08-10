Before Setting up Shepherd

You need to have the following things installed and setup locally before Setting up Shepherd;

Tomcat Server 8.5 (Recommended to configure SSL connections as well)
MySQL Server 5.5 (Create an admin shepherd user as well)

The Shepherd Setup:
1. Put the ROOT.war in your tomcat server's webapp directory
2. Ensure the tomcat user can write files to $CATALINA_HOME/conf (Used for DB Setup Wizard)
3. Restart Tomcat
4. Install MongoDB with defaults on the same machine as Tomcat*
5. Run the mongoSchema.js on MongoDB*
4. Open your Tomcat Server in your browser (Default Insecure Tomcat Running Locally: http://127.0.0.1:8080)
5. You will be brought to the Shepherd Setup Wizard. Enter your Database and Database User details here
6. Ensure you have selected the "Fresh Database" override option and click submit
7. Sign in with the default admin / password credentials and then update the password in the following prompt.

*Used for NoSQL Level. You can disable this level via the Admin controls if you want to skip these steps