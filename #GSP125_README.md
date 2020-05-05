#  GSP125 Speaking with a Webpage - Streaming Speech Transcripts

Last update: 2020-05-05

1. Create a virtual machine (zone: us-central1-f)
2. Install necessary software on VM instance
3. Create a firewall rule to allow TCP traffic on 8443 port in the default network
4. Run the sample solution (hello-https)
5. Run the sample solution to capture audio on webpage


## Create a virtual machine

1. click the **Navigation menu** > **Compute Engine** > **VM instances**.

2. Create

| Parameter |     Value           |
|------|--------------------------|
| Name | speaking-with-a-webpage  |
| Zone | **us-central1-f**            |
| Boot | **Ubuntu 16.04 LTS**         |
| Identity and API access | Allow **full access** to all Cloud APIs |
| Firewall| **HTTP** & **HTTP**S traffic |

Click **Create**

3. Click **SSH**

> **Test Completed Task**
> Create a virtual machine (zone: us-central1-f)

## Download and set up a working example

In the SSH window,

```bash
git clone https://github.com/googlecodelabs/speaking-with-a-webpage.git

sudo apt-get update

sudo apt-get install -y maven openjdk-8-jdk
```

> **Test Completed Task**
> Install necessary software on VM instance

```bash
gcloud compute firewall-rules create dev-ports \
    --allow=tcp:8443 \
    --source-ranges=0.0.0.0/0
```

> **Test Completed Task**
> Create a firewall rule to allow TCP traffic on 8443 port in the default network

## Start the HTTPS Java Servlet

```bash
cd ~/speaking-with-a-webpage/01-hello-https

mvn clean jetty:run
```

Then point your web browser to:

https://<your-external-ip>:8443

> **Test Completed Task**
> Run the sample solution (hello-https)

## Capturing audio on a webpage

Press Ctrl+C to stop the server

```bash
cd ~/speaking-with-a-webpage/02-webaudio

mvn clean jetty:run
```


> **Test Completed Task**
> Run the sample solution to capture audio on webpage

> **Test your Understanding**
> (At the end of the page)
> 
> **tcp:80**



## Streaming audio from client to server

Press Ctrl+C to stop the server

```bash
cd ~/speaking-with-a-webpage/03-websockets

mvn clean jetty:run
```

## Transcribing voice to text

Press Ctrl+C to stop the server

```bash
cd ~/speaking-with-a-webpage/04-speech

mvn clean jetty:run
```

