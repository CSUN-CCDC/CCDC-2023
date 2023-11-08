# Greenbone Container Docs

### By default, a user admin with the password admin is created. This is insecure and it is highly recommended to set a new password.
## Updating password of administrator user
``` shell
docker compose -f docker-compose.yml -p greenbone-community-edition \
    exec -u gvmd gvmd gvmd --user=admin --new-password=<password>
```
