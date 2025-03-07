# Use rocker/shiny as base image for Shiny apps
FROM rocker/shiny:latest

# Install necessary system dependencies for R packages
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    # Install additional dependencies for glmnet if needed
    libopenblas-dev \
    gfortran

# Install R packages (shiny, glmnet, data.table)
RUN R -e "install.packages(c('shiny', 'glmnet', 'data.table'))"

# Copy the Shiny app code into the container
COPY . /srv/shiny-server/

# Copy the models directory into the container (ensure it's correctly placed)
COPY models /srv/shiny-server/models/

# Expose the port that Shiny uses
EXPOSE 3838

# Set permissions on the shiny-server directory to ensure proper access
RUN chown -R shiny:shiny /srv/shiny-server
RUN chmod -R 755 /srv/shiny-server

# Command to run Shiny server
CMD ["/usr/bin/shiny-server"]
