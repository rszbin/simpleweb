# Simpleweb

This is a simple dotnetcore web api application used for testing new relic agent on docker.

The app logs output when a request is received, and returns a result.

The dockerfile includes the new relic agent installation

the build.sh file removes any existing images and containers matching the simpleweb name, and then proceeds to build and run the latest version.

If you want to see the application output run "docker logs <containername>" to see when a request is received.