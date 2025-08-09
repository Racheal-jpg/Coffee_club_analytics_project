> # Coffee club_Analytics_Project

This project uses R to analyze customer data from the `coffee_club_database` .The main goal is to group people into similar Preferences.This will help coffee_club send more personalized offers, making marketing smarter and improving the customer experience. The work starts with setting up the database in pgAdmin and then connecting to RStudio for the analysis.

#### Getting Started

This section explains how to set up the project and connect to the database.

#### Requirements

You'll need the following installed to run this project:

-   **`PostgreSQL`** and **`pgAdmin`**

-   **RStudio**

-   R packages: `DBI`, `RPostgres`, `Keyring`, `Dplyr`

#### Database setup

1.  **Restore database on pgadmin .**

-   Create an empty database named `coffee_club_db`.

-   Right-click on `coffee_club_db` and select Restore.

-   Find and select your `.sql` backup file.

-   Click **Restore** to fill the tables with data.

2.  **Connect the Tables:**

-   You will need to link the database tables together. A **primary key** is a unique ID for each item (like a customer ID). A **foreign key** is a link from one table to a primary key in another table, connecting them .

R-studio connection

Once the database is set up, you can connect to it from RStudio.

1.  First make sure you have the necessary R packages installed:

    install.packages (DBI), Install.packages (RPostgres)

2.  Use the following code to connect.

    \## storing the password

    `db_password_1 <- key_set("coffee_club_password", username = "postgres")`

    \## Retrieving the password for use

    `db_password <- key_get("coffee_club_password", username = "postgres")`

    #Defining the connection parameters

    ##using db_connection() function

    `db_host <- "localhost"`

    `db_port <- "5432"`

    `db_name <- "coffee_club"`

    `db_user <- "postgres"`

    `password <- "db_password"`

    \## Establishing connection

    `con <- dbConnect(`

    `RPostgres::Postgres(),`

    `host = db_host,`

    `port = db_port,`

    `dbname = db_name,`

    `user = db_user,`

    `password = db_password`

    `)`

    #check if the connection was a success

    ##using the if-else conditional statement##

    `if(dbIsValid(con)){`

    `message("sucessful")`

    `} else{`

    `stop("Failed")`

    `}`

    \# Listing all tables in coffee_club database

    `dbListTables(con)`

    \# Importing the three tables for merging

    \# Importing the customer Table

    `customers_table <- dbReadTable(con, "customers")`

    `event_table <- dbReadTable(con , "events")`

    `offer_table <- dbReadTable(con, "offers")`

    #check structure of each table

    `str(customers_table)`

    `str(offer_table)`

    `str(event_table)`

    #check dimension of each table

    `dim(customers_table)`

    `dim(event_table)`

    `dim(offer_table)`

    \# Used view to get tables of each data \#

    `View(customers_table)`

    `View(offer_table)`

    `View(event_table)`

    \## then close connection

    `dbDisconnect(con)`
