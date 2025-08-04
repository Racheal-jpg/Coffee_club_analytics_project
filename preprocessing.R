##load necessary libraries
library(dplyr)
library(RPostgres)
library(DBI)
library(keyring)

##storing the password

db_password_1 <- key_set("coffee_club_password", username = "postgres")


#Defining the connection parameters
##using db_connection() function
db_host <- "localhost"
db_port <- "5432"
db_name <- "coffee_club"
db_user <- "postgres"
password <- "db_password_1"

## Establishing connection

con <- dbConnect(
  RPostgres::Postgres(),
  host = db_host,
  port = db_port,
  dbname = db_name,              
  user = db_user,
  password = db_password
)


#check if the connection was a success
##using the if-else conditional statement##

if(dbIsValid(con)){
  message("sucessful")
} else{
  stop("Failed")
}

# Listing all tables in coffee_club database
dbListTables(con)

# Importing the three tables for merging
# Importing the customer Table

customers_table <- dbReadTable(con, "customers")
event_table <- dbReadTable(con , "events")
offer_table <- dbReadTable(con, "offers")


#check structure of each table
str(customers_table)
str(offer_table)
str(event_table)

#check dimension of each table
dim(customers_table)
dim(event_table)
dim(offer_table)


# Used view to get tables of each data #
View(customers_table)
View(offer_table)
View(event_table)

## then close connection
dbDisconnect(con)


## data cleaning ##




##load necessary libraries
library(dplyr)
library(RPostgres)
library(DBI)
library(keyring)

##storing the password

db_password_1 <- key_set("coffee_club_password", username = "postgres")


#Defining the connection parameters
##using db_connection() function
db_host <- "localhost"
db_port <- "5432"
db_name <- "coffee_club"
db_user <- "postgres"
password <- "db_password_1"

## Establishing connection

con <- dbConnect(
  RPostgres::Postgres(),
  host = db_host,
  port = db_port,
  dbname = db_name,              
  user = db_user,
  password = db_password
)


#check if the connection was a success
##using the if-else conditional statement##

if(dbIsValid(con)){
  message("sucessful")
} else{
  stop("Failed")
}

# Listing all tables in coffee_club database
dbListTables(con)

# Importing the three tables for merging
# Importing the customer Table

customers_table <- dbReadTable(con, "customers")
event_table <- dbReadTable(con , "events")
offer_table <- dbReadTable(con, "offers")


#check structure of each table
str(customers_table)
str(offer_table)
str(event_table)

#check dimension of each table
dim(customers_table)
dim(event_table)
dim(offer_table)


# Used view to get tables of each data #
View(customers_table)
View(offer_table)
View(event_table)

## then close connection
dbDisconnect(con)


## data cleaning ##