# docproxy
![doctor](http://www.free-icons-download.net/images/doctor-icon-61857.png)
A simple proxy for Docker for exposing services dynamically with Let's Encrypt
support.


The purpose is to provide a simple reverse proxy to expose docker services by
subdomain, supporting creation of Let's Encrypt certificates.  This works much
like the more in-depth 'Traefik' project, but supports proxying services
behind SNI hosts without requiring DNS manipulation.

Basically:
```
{Internet} ----> https://myapp.mydomain.com -----               --> myapp 
             |                                  |--> docproxy --|
             --> https://otherapp.mydomain.com --               --> otherapp
```

# General Usage

* Firstly, create a shared network for both docproxy, and you shared services
  to use:  
  ```docker network create docproxy_reverseproxy```

* Label your container with the following:
  ```
    labels:
      - "api"
      - "subdomain=myapp"
      - "port=80"
  ```
  Where 'api' tells docproxy to expose this api.  'subdomain' indicates the
subdomain that the service will be present at 'myapp.mydomain.com' for
instance.  And 'port' is the EXPOSEd port for the container to route traffic
to.

* Add the external network to your docker compose: 
  ```
  networks:
    docproxy:
      external:
        name: docproxy_reverseproxy 
   ```

* Expose the following ENV vars to docproxy:
  - SERVER : This is the main server URL for let's encrypt.
  - SANS : All SANS to send to let's encrypt (I will try to automate this in
    the future) 
