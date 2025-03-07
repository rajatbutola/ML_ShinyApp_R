# Use rocker/shiny as base image for Shiny apps
FROM rocker/shiny:latest

# Install necessary system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev

# Copy the Shiny app code into the container
COPY . /srv/shiny-server/

# Expose the port that Shiny uses
EXPOSE 3838

# Command to run Shiny server
CMD ["/usr/bin/shiny-server"]