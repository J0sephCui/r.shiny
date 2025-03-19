FROM rocker/shiny:4.2.2

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libssl-dev \
    libcurl4-gnutls-dev \
    libxml2-dev \
    libgit2-dev \
    libfreetype6-dev \
    libpng-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libtiff5-dev \
    && rm -rf /var/lib/apt/lists/*

# Install R dependencies
RUN R -e "install.packages(c('devtools', 'shiny', 'shinydashboard', 'dplyr', 'DT', 'shinytest2', 'uuid'), repos='http://cran.rstudio.com/')"

# Install github dependencies
RUN R -e "devtools::install_github('FlippieCoetser/Validate')"
RUN R -e "devtools::install_github('FlippieCoetser/Environment')"
RUN R -e "devtools::install_github('FlippieCoetser/Query')"
RUN R -e "devtools::install_github('FlippieCoetser/Storage')"

# Copy shiny app into the directory /srv/shiny-server/
COPY . /srv/shiny-server/

RUN chown -R shiny:shiny /srv/shiny-server

# Open docker port 3838
EXPOSE 3838

USER shiny

# Start shiny-server
CMD ["/usr/bin/shiny-server"]