#!/bin/bash

#A simple script for wordpress migration : update the wordpress database with a new url

#Prompt for database informations
read -p "Enter mysql server (localhost, ip...): " SQL_SERVER
read -p "Enter mysql database: " SQL_BDD
read -p "Enter mysql database prefix: " SQL_BDD_PREFIX
read -p "Enter mysql user: " SQL_USER
read -sp "Enter mysql user pwd (coachCD1): " SQL_USER_PWD

#Find current wordpress url
TABLE=$SQL_BDD_PREFIX
OPTIONS="_options"
CURRENT_URL=$(mysql -h $SQL_SERVER -u $SQL_USER -p$SQL_USER_PWD $SQL_BDD -e "SELECT option_value from $TABLE$OPTIONS where option_id = 1;" | grep http)
printf "Database conection succesfull ;-)"
printf "\nCurrent url: "$CURRENT_URL"\n"

#Get new wordpress url
read -p "Enter new url (http://myurl.com): " NEW_URL

#Launch sql requests
POSTS="_posts"
REQ1=$(mysql -h $SQL_SERVER -u $SQL_USER -p$SQL_USER_PWD $SQL_BDD -e "UPDATE $TABLE$OPTIONS SET option_value = replace(option_value, '$CURRENT_URL', '$NEW_URL') WHERE option_name = 'home' OR option_name = 'siteurl';")
REQ2=$(mysql -h $SQL_SERVER -u $SQL_USER -p$SQL_USER_PWD $SQL_BDD -e "UPDATE $TABLE$POSTS SET guid = replace(guid, '$CURRENT_URL','$NEW_URL');")
REQ1=$(mysql -h $SQL_SERVER -u $SQL_USER -p$SQL_USER_PWD $SQL_BDD -e "UPDATE $TABLE$POSTS SET post_content = replace(post_content, '$CURRENT_URL', '$NEW_URL');")

printf "\n Migration succesfull ;-)\n"