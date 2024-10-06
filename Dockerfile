# Base image: Python 3.10
FROM python:3.10-slim

# Install Chrome dependencies
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    unzip \
    curl \
    && rm -rf /var/lib/apt/lists/*

# # Install Chrome (Stable version)
# RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
#     sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
#     apt-get update && \
#     apt-get install -y google-chrome-stable

# # Install ChromeDriver
# RUN CHROME_DRIVER_VERSION=$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE) && \
#     wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip && \
#     unzip /tmp/chromedriver.zip -d /usr/local/bin/ && \
#     rm /tmp/chromedriver.zip


# install google chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
    RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
    RUN apt-get -y update
    RUN apt-get install -y google-chrome-stable
    
# install chromedriver
RUN apt-get install -yqq unzip
RUN wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`/chromedriver_linux64.zip
RUN unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/    

# Set environment variable to use Chrome headlessly
ENV DISPLAY=:99

# Set the working directory
WORKDIR /app

# Copy the requirements file
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the Selenium script to the container
COPY app.py .

# Run the Selenium script
CMD ["python", "app.py"]
