##load necessary libraries
library(dplyr)
library(RPostgres)
library(DBI)
library(keyring)

##storing the password
db_password_1 <- key_set("coffee_club_password", username = "postgres")

## Retrieving the password for use 
db_password <- key_get("coffee_club_password", username = "postgres") 


#Defining the connection parameters
##using db_connection() function
db_host <- "localhost"
db_port <- "5432"
db_name <- "coffee_club"
db_user <- "postgres"
password <- "db_password"

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


# data cleaning
# customers_table 
#Replacing or NUll and Na's in the gender column with the string "others"
customers_table <- customers_table %>%
  mutate(gender = replace(gender, is.na(gender), "Other"))


#calculating the median age and income from the non-NA values
median_age <- median(customers_table$age, na.rm = TRUE)
median_income <- median(customers_table$income, na.rm = TRUE)

#replace the missing 'age' and 'income' values with their respective medians
customers_table <- customers_table %>%
  mutate(
    age = replace(age, is.na(age), median_age),
    income = replace(income, is.na(income), median_income)
  )


#Events_table cleaning
#You can check the number of NA values in the offer_id column like this
 
 num_na_offers <- sum(is.na(event_table$offer_id))
 # The offer_id column in the events table contains NA values for transactions
 # that were not associated with an offer. This is a meaningful data,Therefore, we will not change these values.

#offer_table cleaning
#check for missing values in all columns of the offers table
   
 offers_missing_values <- colSums(is.na(offer_table))

#Data Joining
#join the events table with the customers table on the customer_id
 events_with_customers <- event_table %>%
   left_join(customers_table, by = "customer_id")
 
#Next join the  new events_with_customers data frame with the offers table
 coffee_club <- events_with_customers %>%
   left_join(offer_table, by = "offer_id")

#then view combined table
 View(coffee_club)
 
#saving as a CSV file
 write.csv(coffee_club,"coffee_club.csv", row.names = FALSE)
 
#compressing the csv file
 readr::write_csv(coffee_club, "coffee_club.csv.gz")

