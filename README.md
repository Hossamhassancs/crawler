# to lunch the project all you need :
 - Docker version 24.0.7 or later
 - Docker Compose version v2.23.3
# after clone
 - cd /crawler
 - docker-compose up --build

# Project Overview
This project involves setting up a multi-service application using Docker and Docker Compose. The application includes Ruby, Node.js, and .NET components working together to process data and generate a CSV file. Here's a simple explanation of the different parts:

# Ruby Script (app.rb):
This script handles the main data processing. It reads URLs and keywords from input files, scrapes the web pages, processes the data, and generates a CSV file (example-output-dev-test.csv).
It also creates a done.txt file to signal the completion of its processing.

# Node.js Script (app.js):
This script waits for the Ruby script to complete by checking for the existence of the done.txt file.
Once the done.txt file is detected, it reads the generated CSV file, processes the data, and saves the processed data to a JSON file (processed-data.json).

# .NET Script (ValidateCsv.cs):
This script also waits for the done.txt file.
After the Ruby script completes, it reads the CSV file to validate its contents and ensure that it meets the expected structure.


# Files and Configuration
# Dockerfile.ruby:

Sets up a Docker container for the Ruby script.
Copies the Ruby scripts and necessary files into the container.
Runs the Ruby script to generate the CSV file.

# Dockerfile.node:
Sets up a Docker container for the Node.js script.
Copies the Node.js script into the container.
Runs the Node.js script to process the CSV file.

# Dockerfile.dotnet:
Sets up a Docker container for the .NET script.
Copies the .NET script into the container.
Runs the .NET script to validate the CSV file.

# docker-compose.yml:
Defines the multi-service setup, specifying how the Ruby, Node.js, and .NET containers interact with each other.
Ensures that the containers start in the correct order and have the necessary dependencies.

# file_manager.rb and scrapper.rb:
These files likely contain helper functions and classes used by the main Ruby script (app.rb) to manage files and perform web scraping.
Example Workflow
Start Services:

# Use Docker Compose to start all services. The Ruby service starts first, followed by Node.js and .NET services.
Ruby Service:

# Reads input files, scrapes web pages, processes data, and generates a CSV file.
Creates a done.txt file upon completion.

# Node.js Service:
Waits for the done.txt file.
Reads and processes the CSV file, then saves the processed data to a JSON file.

# .NET Service:
Waits for the done.txt file.
Reads and validates the CSV file, ensuring it meets the expected structure.
Running the Project
To run the project, follow these steps:

# Ensure all necessary files are in place:

app.rb, file_manager.rb, scrapper.rb for Ruby.
app.js for Node.js.
ValidateCsv.cs for .NET.
Dockerfiles (Dockerfile.ruby, Dockerfile.node, Dockerfile.dotnet).
docker-compose.yml.


# Build and run the Docker containers:
docker-compose up --build
