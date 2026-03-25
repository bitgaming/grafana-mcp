FROM grafana/mcp-grafana:latest

ENTRYPOINT ["/bin/sh", "-c", \
  "exec /app/mcp-grafana --transport sse --address 0.0.0.0:8000 --enabled-tools=${ENABLED_TOOLS:-loki,datasource,sift}"]
