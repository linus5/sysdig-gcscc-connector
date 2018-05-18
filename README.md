# Sysdig integration with Google Security Command Center

Read more on http://sysdig.com/blog/kubernetes-security-for-google-cloud-security-command-center/.

## Configuration

Configuration is done using environment variables.

Check the following list for environment variables used:

* SYSDIG_TOKEN: Sysdig access token
* ORG_ID: Organization ID
* PROJECT_ID: New findings are created under this project
* SECURITY_SERVICE_ACCOUNT_INFO: Raw credentials for accessing to security command center
* COMPUTE_PROJECT_ID: Kubernetes cluster instances are expected in this project
* COMPUTE_ZONE: Kubernetes cluster instances are expected in this compute zone
* COMPUTE_SERVICE_ACCOUNT_INFO: Raw credentials for accessing to compute API

## Runners

### Polling runner

Console runner is a long time process which queries policy events in Sysdig Secure
every minute and creates new findings in Security Command Center.

### Webhook server

The webhook runner is a Flask application which receives an HTTP POST request
when a new event is created. This webhook should be configured in Sysdig Secure
notification settings.

### Falco integration

We can also configure the connector for receiving events from Falco. This
runner is also a Flask application which receives an HTTP POST request when an
alarm is raised.

#### Falco configuration

Make sure that your falco configuration (/etc/falco/falco.yaml) has those values:

```
json_include_output_property: true

program_output:
  enabled: true
  keep_alive: false
  program: "curl -d @- -X POST --header 'Content-Type: application/json' http://127.0.0.1:5000/"
```

And make sure you are running Falco with the --unbuffered flag.

## Docker support

We have deployed this integration in Google App Engine, using Docker support in flex plan.

### Build image

```
docker build -t sysdig/sysdig-cscc .
```

### Running WebHook

```
docker run -p 8080:8080 sysdig/sysdig-cscc
```

### Console

```
docker run sysdig/sysdig-cscc python main.py
```

## Google App Engine Deployment

Configure gcloud client with:

```
gcloud init
```

Create project:

```
gcloud app create
```

And deploy!

```
gcloud app deploy
```

### Logs

You can see logs with:

```
gcloud app logs tail -s default
```
