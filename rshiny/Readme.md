# Deploying a Shiny App with Docker on an EC2 Instance
This guide provides step-by-step instructions for deploying a Shiny app using Docker on an EC2 instance.

## 1. The Shiny App
The Shiny app is designed to take a CSV file as input and generate multiple regression analyses. It provides an interactive interface for visualizing results and exploring data relationships.

## 2. Prerequisites
- An AWS EC2 instance (Ubuntu 20.04 or later recommended).
- Docker installed on the EC2 instance.


## 3. Steps to Deploy

**Step 1: SSH into the EC2 Instance**
```
ssh -i "your-key.pem" ubuntu@your-ec2-ip
```

**Step 2: Install Docker (if not already installed)**
```
sudo apt update
sudo apt install -y docker.io
```
**Step 3: Write a Dockerfile**

Create a Dockerfile in the same directory as your Shiny app (app.R). 
```
FROM rocker/shiny:latest

# Install R packages
RUN R -e "install.packages(c('shiny', 'ggplot2', 'DT', 'corrplot', 'broom', 'data.table'), repos='http://cran.rstudio.com/')"
RUN R -e "if (!requireNamespace('remotes')) install.packages('remotes'); remotes::install_github('ropensci/plotly')"

# Copy your Shiny app into the container
COPY ./ /srv/shiny-server/myapp/

# Set permissions
RUN chown -R shiny:shiny /srv/shiny-server

# Run Shiny Server
CMD ["/usr/bin/shiny-server"]
```

**Step 4: Build and Run the Docker Container**
```
sudo docker build -t shiny-app .
sudo docker run -d -p 3838:3838 shiny-app
```

**Step 5: Open Security Group for Port 3838**

Go to your AWS EC2 Dashboard.

Select the instance and click on "Security Groups."

Add an inbound rule to allow traffic on port 3838.

**Step 6: Access the App**

Visit http://your-ec2-ip:3838/myapp in your browser.