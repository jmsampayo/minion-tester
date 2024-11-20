# minion-tester

Docker image to deploy and run Jenkins agents intended to execute Playwright tests.

---

## Software and Packages

- Java JRE 11
- Jenkins agent (agent.jar)
- curl git openssh unzip wget zip

---

## Usage

### **NOTE**

***Do NOT pull the image from this repo. It's built with the agent downloaded from our Jenkins server; so if the version of your Jenkins server is different, the run container may not work properly.***

### Docker build

```shell
docker build --build-arg AGENT_JAR_URL=<your Jenkins agent jar URL> -t minion-tester .
```

### Docker run

```shell
docker run -d --name minion-tester-01 --restart always minion-tester:latest -url <your Jenkins URL> -secret <your Jenkins agent secret> -name <your Jenkins agent name> -workDir /home/jenkins
```
