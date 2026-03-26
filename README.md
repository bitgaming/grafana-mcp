# grafana-mcp

Runs the [Grafana MCP server](https://github.com/grafana/mcp-grafana) on the `kubershmuber-prod-eu` cluster in the `monitoring` namespace, alongside the Grafana instance.

The server is configured to expose the following tool categories via `ENABLED_TOOLS`, backed by Grafana's Loki datasource. See the [mcp-grafana tool reference](https://github.com/grafana/mcp-grafana#tools) for full details on each tool.

| Category | Tools |
|---|---|
| `loki` | `query_loki_logs`, `list_loki_label_names`, `list_loki_label_values`, `query_loki_stats`, `query_loki_patterns` |
| `datasource` | `list_datasources`, `get_datasource` |
| `sift` | `list_sift_investigations`, `get_sift_investigation`, `get_sift_analysis`, `find_error_pattern_logs`, `find_slow_requests` |

## Connecting

The MCP server is available via SSE at:

```
https://grafana-mcp.prod-eu.kubershmuber.com/sse
```

> **Access is IP-restricted via Cloud Armor.** You must be connecting from one of the following to use this MCP:
> - HK office (`223.197.203.82`)
> - NordLayer Austria gateway (`149.40.52.138`) — connect via NordLayer VPN if remote
> - Prod cluster CloudNAT IPs (internal services only)

Example Claude Desktop config (`~/Library/Application Support/Claude/claude_desktop_config.json`):

```json
{
  "mcpServers": {
    "grafana": {
      "url": "https://grafana-mcp.prod-eu.kubershmuber.com/sse"
    }
  }
}
```

## Deployment

Deployed to prod EU via Cloud Build using the `deployment-chart` helm chart:

```
cd-assets/prod/cloudbuild_release_eu.yaml
```

The upstream `mcp/grafana` image is mirrored to the internal Artifact Registry before deploying:

```
europe-docker.pkg.dev/sports-dev-experiments/eu/mcp/grafana
```

## Configuration

| Variable | Value |
|---|---|
| `GRAFANA_URL` | `http://grafana.monitoring.svc.cluster.local` |
| `ENABLED_TOOLS` | `loki,datasource,sift` |
| `GRAFANA_SERVICE_ACCOUNT_TOKEN` | KMS-encrypted, injected at deploy time |
