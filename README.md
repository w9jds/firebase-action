# GitHub Actions for Firebase

This Action for [firebase-tools](https://github.com/firebase/firebase-tools) enables arbitrary actions with the `firebase` command-line client.

If you want a more flexible implementation, an early version of a rewrite is available here: [setup-firebase](https://github.com/w9jds/setup-firebase) that allows you to choose node and java version and run more than one command.

## Inputs

* `args` - **Required**. These are the arguments you want to use for the
  `firebase` cli. Arguments will be treated sequentially.

## Outputs

~~* `response` - The full response from the firebase command current run (Will most likely require a grep to get what you want, like URLS)~~

_**Response has been removed for now as it caused loads of issues in the bash script**_


## Environment variables

* `GCP_SA_KEY` - **Required if FIREBASE_TOKEN is not set**. A **normal** service account key (json format) or a **base64 encoded** service account key with the needed permissions for what you are trying to deploy/update.
  * Since the service account is using the App Engine default service account in the deploy process, it also needs the `Service Account User` role.
  * If deploying functions, you would also need the `Cloud Functions Developer` role.
    * If the deploy has scheduled functions, include the `Cloud Scheduler Admin` role.
    * If the deploy requires access to secrets, include the `Secret Manager Viewer` role.
    * If updating Firestore Rules, include the `Firebase Rules Admin` role.
    * If the project is using Blocking functions (beforeCreate or beforeSignin) , include the `Firebase Functions Admin` role.
  * If updating Firestore Indexes, include the `Cloud Datastore Index Admin` role.
  * If deploying Hosting files, include the `Firebase Hosting Admin` role.
  * If updating Remote Config, include the `Firebase Remote Config Admin` role.
  * For more details: https://firebase.google.com/docs/hosting/github-integration

* `FIREBASE_TOKEN` - **Required if GCP_SA_KEY is not set**. _**This method will soon be deprecated, use `GCP_SA_KEY` instead**_. The token to use for authentication. This token can be aquired through the `firebase login:ci` command.

* `GOOGLE_APPLICATION_CREDENTIALS` - **Required if GCP_SA_KEY or FIREBASE_TOKEN is not set**. the location of a credential JSON file. For more details: https://cloud.google.com/docs/authentication/application-default-credentials#GAC

* `PROJECT_ID` - **Optional**. To specify a specific project to use for all commands. Not required if you specify a project in your `.firebaserc` file. If you use this, you need to give `Viewer` permission roles to your service account otherwise the action will fail with authentication errors.

* `PROJECT_PATH` - **Optional**. The path to the folder containing `firebase.json` if it doesn't exist at the root of your repository. e.g. `./my-app`.

* `CONFIG_VALUES` - **Optional**. The configuration values for Firebase function that would normally be set with `firebase functions:config:set [value]`. Example: `CONFIG_VALUES: stripe.secret_key=SECRET_KEY zapier.secret_key=SECRET_KEY`.

## Example

To authenticate with Firebase, and deploy to Firebase Hosting:

```yaml
name: Build and Deploy
on:
  push:
    branches:
      - master

jobs:
  build:
    name: Build
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repo
        uses: actions/checkout@master
      - name: Install Dependencies
        run: npm install
      - name: Build
        run: npm run build-prod
      - name: Archive Production Artifact
        uses: actions/upload-artifact@master
        with:
          name: dist
          path: dist
  deploy:
    name: Deploy
    needs: build
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repo
        uses: actions/checkout@master
      - name: Download Artifact
        uses: actions/download-artifact@master
        with:
          name: dist
          path: dist
      - name: Deploy to Firebase
        uses: w9jds/firebase-action@master
        with:
          args: ["deploy --only hosting"]
        env:
          FIREBASE_TOKEN: ${{ secrets.FIREBASE_TOKEN }}
```
Alternatively:

```yaml
        env:
          GCP_SA_KEY: ${{ secrets.GCP_SA_KEY }}
```


If you have multiple hosting environments you can specify which one in the args line.
e.g. `args: ["deploy --only hosting:<environment name>"]`

If you want to add a message to a deployment (e.g. the Git commit message) you need to take extra care and escape the quotes or the YAML breaks.

```yaml
        with:
          args: ["deploy --message \"${{ github.event.head_commit.message }}\""]
```

## Alternate versions

Starting with version v2.1.2 each version release will point to a versioned docker image allowing for hardening our pipeline (so things don't break when I do something dump). On top of this, you can also point to a `master` version if you would like to test out what might not be deployed into a release yet by using something like this:

```yaml
  name: Deploy to Firebase
  uses: docker://w9jds/firebase-action:master
  with:
    args: ["deploy --only hosting"]
  env:
    FIREBASE_TOKEN: ${{ secrets.FIREBASE_TOKEN }}

```

## License

The Dockerfile and associated scripts and documentation in this project are released under the [MIT License](LICENSE).


### Recommendation

If you decide to do seperate jobs for build and deployment (which is probably advisable), then make sure to clone your repo as the Firebase-cli requires the firebase repo to deploy (specifically the `firebase.json`)
