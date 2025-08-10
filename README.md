# Coffee Club Analytics Project

This project uses R to analyze customer data from the `coffee_club_db` database. The main goal is to group customers into similar preference groups to help Coffee Club send more personalized offers, making marketing smarter and improving the customer experience.

## Getting Started

This section explains how to set up the project and connect to the database.

### Requirements

You'll need the following installed to run this project:

-   **PostgreSQL** and **pgAdmin**
-   **RStudio**
-   **R packages**:
    -   `DBI`
    -   `RPostgres`
    -   `keyring`
    -   `dplyr`

You can install the required R packages using the following command in the RStudio console:

``` r
install.packages(c("DBI", "RPostgres", "keyring", "dplyr"))
```

### Database Setup

1.  **Restore the database in pgAdmin:**
    -   Create a new, empty database named `coffee_club_db`.
    -   Right-click on `coffee_club_db` and select **Restore**.
    -   Find and select your `.sql` backup file.
    -   Click **Restore** to populate the tables with data.
2.  **Connect the Tables:**
    -   Ensure that the tables in the database are correctly linked using primary and foreign keys. A **primary key** is a unique ID for each record (e.g., a customer ID), and a **foreign key** links one table to a primary key in another table.

### RStudio Connection

Once the database is set up, you can connect to it from RStudio.

1.  **Store your database password securely using the `keyring` package:**

    ``` r
    # Store the password (you will be prompted to enter it)
    keyring::key_set("coffee_club_password", username = "postgres")
    ```

2.  **Connect to the database using the following R code:**

    ``` r
    # Load the necessary libraries
    library(DBI)
    library(RPostgres)
    library(keyring)
    library(dplyr)

    # Retrieve the password
    db_password <- key_get("coffee_club_password", username = "postgres")

    # Define the connection parameters
    db_host <- "localhost"
    db_port <- "5432"
    db_name <- "coffee_club_db" # Corrected database name
    db_user <- "postgres"

    # Establish the connection
    con <- dbConnect(
      RPostgres::Postgres(),
      host = db_host,
      port = db_port,
      dbname = db_name,
      user = db_user,
      password = db_password
    )

    # Check if the connection was successful
    if (dbIsValid(con)) {
      message("Connection successful!")
    } else {
      stop("Connection failed.")
    }
    ```

## Data Preprocessing

The following R code is used to clean and preprocess the data after it has been loaded from the database. This includes handling missing values, calculating medians, and joining tables to create a final dataset for analysis.

``` r
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
```

## Usage

After connecting to the database, you can import the tables into R data frames:

``` r
# List all tables in the database
dbListTables(con)

# Import the tables
customers_table <- dbReadTable(con, "customers")
events_table <- dbReadTable(con, "events")
offers_table <- dbReadTable(con, "offers")

# Check the structure and dimensions of each table
str(customers_table)
dim(customers_table)

str(events_table)
dim(events_table)

str(offers_table)
dim(offers_table)

# View the tables
View(customers_table)
View(events_table)
View(offer_table)

# Remember to close the connection when you're done
dbDisconnect(con)
```

## Analysis

The core of this project involves analyzing the customer data to identify preference groups. This can include:

-   **Exploratory Data Analysis (EDA):** Understanding the distributions and relationships in the data.
-   **Customer Segmentation:** Using clustering algorithms (e.g., K-means) to group customers based on their purchasing behavior and preferences.
-   **Offer Analysis:** Determining which offers are most effective for different customer segments.

The analysis scripts can be found in the project directory.

## Contributing

Contributions are welcome! If you have any suggestions or improvements, please open an issue or submit a pull request.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.
