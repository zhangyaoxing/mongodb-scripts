## Create self-signed root certificate - it is to be used for signing all of the other certificates
- Generate the private root key file - this file should be kept secure
```bash
openssl genrsa -out rootCA.key 4096 
```

- Generate the public root certificate - it is our CAFile that has to be distributed among the servers and clients so they could validate each others certificates
```bash
openssl req -x509 -new -nodes -key rootCA.key -days 365 -out rootCA.crt
```

## Generate a certificate to be used for a MongoDB server:
- Generate the private key file
```bash
openssl genrsa -out server.key 4096 
```

- Generate a CSR. At this step there will be prompt for a number of things including the Common Name (CN). It is very important to ensure that the CN you specified matches the FQDN of the host the certificate should be used on (in this case, the host that will be running the mongod process). Otherwise the certificate validation may fail.
```bash
openssl req -new -key server.key -out server.csr -config x509.config
```

- Use the CSR to create a certificate signed with our root certificate
```bash
openssl x509 -req -in server.csr \
  -CA rootCA.crt \
  -CAkey rootCA.key \
  -CAcreateserial \
  -out server.crt \
  -days 365 \
  -extensions req_ext \
  -extfile x509.config
```

- Concatenate them into a single .pem file - that is the PEMKeyFile that should be used to start the monogd process
```bash
cat server.key server.crt > server.pem
```

- Verify that the .pem file can be validated with the root certificate that was used to sign it
```bash
openssl verify -CAfile rootCA.crt server.pem 
```

That should return

> server.pem: OK

## Use the same procedure to create a client certificate:
    openssl genrsa -out client.key 2048
    openssl req -new -key client.key -out client.csr
    openssl x509 -req -in client.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out client.crt -days 365
    cat client.key client.crt > client.pem
    openssl verify -CAfile rootCA.crt client.pem

## Start the server - we need to use the certificates produced in the steps 1.2 and 2.4
    mongod --port 9088 --smallfiles --sslMode requireSSL --sslPEMKeyFile server.pem --sslCAFile rootCA.crt
## Connect with a client - we need to use the certificates produced in the steps 1.2 and 3.4
    mongo --port 9088 --ssl --sslCAFile rootCA.crt --sslPEMKeyFile client.pem 
