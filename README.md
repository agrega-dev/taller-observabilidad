
# Description

Este repo contiene un ejemplo de instrumentacion Flask con OpenTelemetry, incluye injeccion de Trace ID en logs de JSON.

Using docker:
```
make build
make run

# Then send HTTP requests to localhost:8000/rolldice
# Examine the logs from both containers, and you should see the trace ID.
```
