# Cara API
[![Build Status](https://travis-ci.org/itchef/cara-api.svg?branch=master)](https://travis-ci.org/itchef/cara-api)

Cara is a simple face cheat sheet for various organisations like school, college and any other organisation. 

Cara is not a data storage for people's profile, it just a simple visualisation having minimum contact details in it.

This project represents the API of cara app.

## System Requirements
* Ruby = **2.3.1**
* Rails = **5.1.5**
* PostgreSQL = **10.0** 

# Setup Application

### Setup Environment Variables
Setup the **ENVIRONMENT VARIABLES** in your .bashrc / .zshrc or any other preferable configuration file.

| Variable | Description |
| -------- | ----------- |
| RAILS_ENV | Type of environment of your rails application. i.e. development, test, production |
| CARA_API_DATABASE_USERNAME | Username or Role of your postgres database |
| CARA_API_DATABASE_PASSWORD | Password of your postgres database |

### Setup database
Run this to setup ROLE for postgres database,
```
createuser -P -s -e $CARA_API_DATABASE_USERNAME
```
After you are done with the USER creation, run this following command from the project root directory
```
bin/rails db:create db:migrate
```
This command will create the database(s) for the application to use.

# License
![GNU GPL V3](https://www.gnu.org/graphics/gplv3-127x51.png)
