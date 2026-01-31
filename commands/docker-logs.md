# Docker Logs Tail

Check container logs only when needed. Start with `docker ps` to see what's running, then `docker logs -f <name>` for basic monitoring.

Ask user which container before running any commands.

## Essential Commands

```bash
# List containers
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Image}}"

# Tail logs
docker logs -f <container_name>

# Recent logs only
docker logs --tail 50 <container_name>

# With timestamps
docker logs -f --timestamps <container_name>
```

For complex needs, ask user what they're trying to debug first.
