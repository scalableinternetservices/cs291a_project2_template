# Project 2 Template

## Initial Set up

The following steps should only need to be done once:

### Set Environment Variable

Add the following to your `.bash_profile` script, or similar for your shell:

```sh
# If your ucsb email is user@ucsb.edu, then YOUR_ACCOUNT_NAME is user
#
# Note: If you have an underscore in your account name, please replace with a hypen.
export CS291_ACCOUNT=YOUR_ACCOUNT_NAME
```

### Install `gcloud` tool

Follow the instructions here:
https://cloud.google.com/sdk/docs/#install_the_latest_cloud_tools_version_cloudsdk_current_version

### Authenticate with Google

Make sure you select your `@ucsb.edu` account when authenticating.

```sh
gcloud auth login
```

### Verify the above works

```sh
gcloud projects describe cs291a
```

The above should produce the following output:

```
createTime: '2020-12-29T18:55:55.506Z'
lifecycleState: ACTIVE
name: cs291a
parent:
  id: '254441457261'
  type: folder
projectId: cs291a
projectNumber: '318955983951'
```

### Create Application Default Credentials

Again, make sure you select your @ucsb.edu account when authenticating.

```sh
gcloud auth application-default login
```

### Install Docker

Follow the instructions here: https://www.docker.com/products/docker-desktop

### Link Docker and Gcloud

```sh
gcloud auth configure-docker us.gcr.io
```

## Develop Locally

The following commands are intended to be run from within the directory
containing your project (e.g., your copy of this repository).

Edit your `app.rb` file however you want then follow the next two steps to test your
application:

### Build Container

```sh
docker build -t us.gcr.io/cs291a/project2_${CS291_ACCOUNT} .
```

### Run Locally

```sh
docker run -it --rm \
  -p 3000:3000 \
  -v ~/.config/gcloud/application_default_credentials.json:/root/.config/gcloud/application_default_credentials.json \
  us.gcr.io/cs291a/project2_${CS291_ACCOUNT}
```

### Test Using CURL

```sh
curl -D- localhost:3000/
```

The default application should provide output that looks like the following:

```http
HTTP/1.1 200 OK
Content-Type: text/html;charset=utf-8
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
Content-Length: 12

Hello World
```

## Production Deployment

Each time you want to deploy your application to Google Cloud Run, perform the
following two steps:

### Push Container to Google Container Registry

```sh
docker push us.gcr.io/cs291a/project2_${CS291_ACCOUNT}
```

### Deploy to Google Cloud Run

```sh
gcloud beta run deploy \
  --allow-unauthenticated \
  --concurrency 80 \
  --image us.gcr.io/cs291a/project2_${CS291_ACCOUNT} \
  --memory 128Mi \
  --platform managed \
  --project cs291a \
  --region us-central1 \
  --service-account project2@cs291a.iam.gserviceaccount.com \
  --set-env-vars RACK_ENV=production \
  ${CS291_ACCOUNT}
```

The last line of output should look similar to the following:

```
Service [{ACCOUNT_NAME}] revision [{ACCOUNT_NAME}-00018] has been deployed and is serving 100 percent of traffic at https://{ACCOUNT_NAME}-66egyap56q-uc.a.run.app
```

### View Logs

1. Browse to: https://console.cloud.google.com/run?project=cs291a

2. Click on the service with your ACCOUNT_NAME

3. Click on "LOGS"

4. Browse logs, and consider changing the filter to "Warning" to find more pressing issues.

## Resources

- https://cloud.google.com/run/docs/quickstarts/build-and-deploy
- https://googleapis.dev/ruby/google-cloud-storage/latest/index.html

## Possible Errors

### invalid reference format

Re-run the `export` command.
