# Hotels Data Merge API

## Introduction
This is a web API that offers the ability to clean up data from multiple suppliers: it queries multiple suppliers to assimilate data from different sources, building the most comprehensive dataset possible, and sanitizes them to remove any dirty data.

## Prerequisites
To run the Hotels Data Merge API, you need the following software and tools installed:

- Ruby (version 3.2.0)
- Ruby on Rails (version 6.0.6)
- PostgreSQL (version 14)

## Installation & Configuration
1. Clone the repository: `git clone https://github.com/khaismile1997/hotets_data_merge.git`
2. Navigate to the project directory: `cd hotets_data_merge`
3. Install dependencies: `bundle install`
4. Configure database settings:
   - Open the `config/database.yml` file and update the database configuration according to your PostgreSQL setup.
5. Set up environment variables (if necessary):
   - Create a `.env` file in the project root directory and define any required environment variables.
   - Example: `DATABASE_USER=username`, `DATABASE_PASSWORD=password`

## Database Setup
1. Start pg server:
   - Homebrew on macOS: `brew services start postgresql@14`
   - Ubuntu: `sudo service postgresql start`
2. Run database migrations: `rails db:migrate`

## Running the Application
1. Start the development server: `rails s`
2. Run migration: `rails db:migrate`
3. Change .env file:
   - `DATABASE_HOST=localhost`
   - `DATABASE_USER=your_pg_user`
   - `DATABASE_PASSWORD=''`
4. Access the web api in your web browser at: `http://localhost:3001`
5. Run the test suite: `rspec`

## Usage
- Access to the API link: `/api/v1/hotels`, you'll see data from various suppliers that have been aggregated, standardized, and cleaned up in an optimal and rational manner.

## Troubleshooting
If you encounter any issues during the setup or usage of the application, you can try the following solutions:

- Ensure that all dependencies and prerequisites are installed correctly.
- Double-check the database configuration in the `config/database.yml` file.
- Verify that the necessary environment variables are properly set.
  - `SUPPLIER_API_URL`
  - Database info variables
- Make sure the database server is running and accessible.
  - Homebrew on macOS: run `brew services list`
  - Ubuntu: run `sudo service postgresql status`
- Check the application logs for any error messages or exceptions.

If the problem persists, please [open an issue](https://github.com/khaismile1997/hotets_data_merge/issues) on the project's GitHub repository for further assistance.
