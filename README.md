# GitHub Actions for Firebase

This Action for [firebase-tools](https://github.com/firebase/firebase-tools) enables arbitrary actions with the `firebase` command-line client.

## Inputs

* `command` - **Required**. This is the arguments you want to use for the `firebase` cli


## Environment variables

* `FIREBASE_TOKEN` - **Required**. The token to use for authentication. This token can be aquired through the `firebase login:ci` command.

* `PROJECT_ID` - **Optional**. To specify a specific project to use for all commands, not required if you specify a project in your `.firebaserc` file.

## Example

To authenticate with Firebase, and deploy to Firebase Hosting:

```yaml
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
    - name: Deploy to Firebase
      uses: w9jds/firebase-action@master
      with:
        command: 'deploy --only hosting:prod'
      env:
        PROJECT_ID: new-eden-storage-a5c23
        FIREBASE_TOKEN: ${{ secrets.FIREBASE_TOKEN }}
```

## License

The Dockerfile and associated scripts and documentation in this project are released under the [MIT License](LICENSE).


# Hello world docker action

This action prints "Hello World" or "Hello" + the name of a person to greet to the log.

## Inputs

### `who-to-greet`

**Required** The name of the person to greet. Default `"World"`.

## Outputs

### `time`

The time we greeted you.

## Example usage

uses: actions/hello-world-docker-action@v1
with:
  who-to-greet: 'Mona the Octocat'