
# Description

This repo contains an example of OpenTelemetry instrumentation of Flask, including Trace ID injection into JSON logs.

Using docker:
```
make build
make run

# Then send HTTP requests to localhost:8000/rolldice
# Examine the logs from both containers, and you should see the trace ID.
```
