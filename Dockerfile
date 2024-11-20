# Official LTS Debian-based Node.js image
FROM node:lts-bullseye-slim
LABEL maintainer="Jose Manuel Sampayo <j.m.sampayo@live.com>"
# Label to make the package linked to the GitHub repository (remove if not needed)
LABEL org.opencontainers.image.source=https://github.com/jmsampayo/minion-tester

# Setting environment variables for Playwright
ENV PLAYWRIGHT_BROWSERS_PATH=0

# Installing additional dependencies and tools packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    fonts-liberation \
    git \
    gnupg \
    libasound2 \
    libatk1.0-0 \
    libcups2 \
    libfontconfig1 \
    libfreetype6 \
    libgbm-dev \
    libgtk-3-0 \
    libnss3 \
    libpango1.0-0 \
    libpangocairo-1.0-0 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libxshmfence1 \
    openssh-client \
    unzip \
    wget \
    zip \
# Cleaning up apt-get cache
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* \
# Installing Playwright
&& npm install -g playwright \
 && npx playwright install --with-deps \
# Installing Jenkins agent
&& mkdir -p /usr/share/jenkins \
&& chmod -R 755 /usr/share/jenkins
ARG AGENT_JAR_URL=https://default-url.com/jnlpJars/agent.jar
ENV AGENT_JAR_URL=$AGENT_JAR_URL
ADD $AGENT_JAR_URL /usr/share/jenkins/agent.jar
RUN chown -R root:root /usr/share/jenkins \
    && chmod 644 /usr/share/jenkins/agent.jar \
    && useradd -m -d /home/jenkins -s /bin/bash jenkins

# Setting Jenkins workspace as environment variable
ENV JENKINS_AGENT_WORKDIR=/home/jenkins

# Creating Jenkins workspace directory and setting ownership
RUN mkdir -p "$JENKINS_AGENT_WORKDIR" && chown -R jenkins:jenkins "$JENKINS_AGENT_WORKDIR" \
# Installing openJDK
    && wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.deb \
    && dpkg -i jdk-21_linux-x64_bin.deb
# Switching to the Jenkins user
USER jenkins

# Setting Jenkins workspace as the working directory
WORKDIR $JENKINS_AGENT_WORKDIR

# Entry point to run the Jenkins agent
ENTRYPOINT ["java", "-jar", "/usr/share/jenkins/agent.jar"]