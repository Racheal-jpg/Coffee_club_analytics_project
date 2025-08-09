# Coffee Club Analytics Project

This project uses R to analyze customer data from the `coffee_club_db` database. The main goal is to group customers into similar preference groups to help Coffee Club send more personalized offers, making marketing smarter and improving the customer experience.

## Table of Contents

-   [Getting Started](#getting-started)
    -   [Requirements](#requirements)
    -   [Database Setup](#database-setup)
    -   [RStudio Connection](#rstudio-connection)
-   [Usage](#usage)
-   [Analysis](#analysis)
-   [Contributing](#contributing)
-   [License](#license)

## Getting Started {#getting-started}

This section explains how to set up the project and connect to the database.

### Requirements {#requirements}

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

### Database Setup {#database-setup}

1.  **Restore the database in pgAdmin:**
    -   Create a new, empty database named `coffee_club_db`.
    -   Right-click on `coffee_club_db` and select **Restore**.
    -   Find and select your `.sql` backup file.
    -   Click **Restore** to populate the tables with data.
2.  **Connect the Tables:**
    -   Ensure that the tables in the database are correctly linked using primary and foreign keys. A **primary key** is a unique ID for each record (e.g., a customer ID), and a **foreign key** links one table to a primary key in another table.

### RStudio Connection {#rstudio-connection}

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

## Usage {#usage}

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

## Analysis {#analysis}

The core of this project involves analyzing the customer data to identify preference groups. This can include:

-   **Exploratory Data Analysis (EDA):** Understanding the distributions and relationships in the data.
-   **Customer Segmentation:** Using clustering algorithms (e.g., K-means) to group customers based on their purchasing behavior and preferences.
-   **Offer Analysis:** Determining which offers are most effective for different customer segments.

The analysis scripts can be found in the project directory.

## Contributing {#contributing}

Contributions are welcome! If you have any suggestions or improvements, please open an issue or submit a pull request.

## License {#license}

This project is licensed under the MIT License. See the `LICENSE` file for more details.
