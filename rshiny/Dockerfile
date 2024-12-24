# Use the official R image with Shiny
FROM --platform=linux/arm64 rocker/shiny:latest

# Install required R packages (make sure to include the ones needed by your app)
RUN R -e "install.packages(c('shiny', 'ggplot2', 'DT', 'corrplot', 'broom', 'plotly', 'data.table'), repos='http://cran.rstudio.com/')"

# Copy your Shiny app into the Docker container
COPY ./ /srv/shiny-server/myapp/

# Expose port 3838 for Shiny Server
EXPOSE 3838

# Set environment variable to allow shiny-server to run
ENV PORT=3838

# Run the Shiny Server
CMD ["/usr/bin/shiny-server"]

