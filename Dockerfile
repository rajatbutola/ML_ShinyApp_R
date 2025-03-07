# Use rocker/shiny as base image for Shiny apps
FROM rocker/shiny:latest

# Install necessary system dependencies for R packages
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libopenblas-dev \
    gfortran

# Install remotes package to allow installing specific package versions
RUN R -e "install.packages('remotes')"

# Install specific versions of R packages using remotes
RUN R -e "remotes::install_version('dplyr', version = '1.1.4', repos = 'https://cloud.r-project.org/')"
RUN R -e "remotes::install_version('shiny', version = '1.10.0', repos = 'https://cloud.r-project.org/')"
RUN R -e "remotes::install_version('data.table', version = '1.16.2', repos = 'https://cloud.r-project.org/')"
RUN R -e "remotes::install_version('pROC', version = '1.18.5', repos = 'https://cloud.r-project.org/')"
RUN R -e "remotes::install_version('glmnet', version = '4.1-8', repos = 'https://cloud.r-project.org/')"
RUN R -e "remotes::install_version('matrixStats', version = '1.4.1', repos = 'https://cloud.r-project.org/')"
RUN R -e "remotes::install_version('Hmisc', version = '5.2-0', repos = 'https://cloud.r-project.org/')"
RUN R -e "remotes::install_version('WGCNA', version = '1.73', repos = 'https://cloud.r-project.org/')"
RUN R -e "remotes::install_version('e1071', version = '1.7-16', repos = 'https://cloud.r-project.org/')"
RUN R -e "remotes::install_version('fastcluster', version = '1.2.6', repos = 'https://cloud.r-project.org/')"
RUN R -e "remotes::install_version('Matrix', version = '1.6-5', repos = 'https://cloud.r-project.org/')"

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

