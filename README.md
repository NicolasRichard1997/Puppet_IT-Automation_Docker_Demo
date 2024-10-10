# Puppet IT & Automation Demo: Automating the Installation of Packages Using Puppet Server and Agents in Docker Containers

## Overview

This demo showcases the use of Puppet to automate the installation of the `cowsay` package on a Puppet agent. The Puppet server and agent are both running in Docker containers, allowing for easy deployment and management of configurations.

## Requirements

- Docker
- Puppet (server and agent)
- Access to the internet (for package installation)

## Setup Instructions

1. **Fetching Docker Images:**

  To generate the Docker images locally, go into each of the Agent and Server folders and build the images:

  ```bash
  cd Agent && docker build -t puppet-agent .
  ```
  ```bash
  cd Server && docker build -t puppet-server .
  ```

2. **Create a Custom Network:**

   Create a Docker network to allow communication between the Puppet server and agent:

   ```bash
   docker network create puppet-network
   ```
3. **Run the Puppet Server & Puppet Agent Containers:**

To start the server container, you can run the following command:
```bash
docker run -it --name puppet-server-container --network puppet-network -p 8140:8140 puppet-server
```

To start the agent container, you can run the following command in another terminal:
```bash
docker run -it --name puppet-agent-container --network puppet-network puppet-agent
```

To make sure the connection between the containers has been sucessfully established, you can run the following:
```bash
ping puppet-server-container
```

4.**Establish the Connection between Containers:**

In the Server container:
```bash
puppetserver start
```

In the Agent's container, run:
```bash
puppet agent --test --waitforcert=60
```
The output should look like this:
```bash
root@8b107e4cc8f3:/# puppet agent --test --waitforcert=60
Info: Refreshed CRL: 65:80:5C:C3:54:8C:08:29:67:67:5D:20:CC:22:3F:84:94:56:11:40:1F:7C:04:5D:15:77:58:AF:80:31:1B:A2
Info: Creating a new RSA SSL key for puppet-agent-container
Info: csr_attributes file loading from /etc/puppetlabs/puppet/csr_attributes.yaml
Info: Creating a new SSL certificate request for puppet-agent-container
Info: Certificate Request fingerprint (SHA256): 7D:5A:CA:34:76:4C:FE:B6:17:61:09:AC:0B:81:2A:31:60:81:5F:4B:F7:3F:73:49:AB:53:EC:CA:9F:31:A5:2E
Info: Certificate for puppet-agent-container has not been signed yet
Couldn't fetch certificate from CA server; you might still need to sign this agent's certificate (puppet-agent-container).
Info: Will try again in 60 seconds.
```
Transport to the Server container:
```bash
puppetserver ca list
```
The previous command should list all requested certificates. The follwoing command will sign all of them:

```bash
puppetserver ca sign --all
```

The connection between the containers should be succesfully established

5. **Creating & Apllying the Manifest:**

In the Server container, go into the directory `/etc/puppetlabs/code/environments/production/manifests/` and create a file named  `manifest.pp` (the program `GNU nano 6.2` has been pre-loaded in the Docker image) with the following content:

```puppet
exec { 'apt-update':
  command => '/usr/bin/apt-get update',
}

package { 'cowsay':
  ensure => present,
  require => Exec['apt-update'],
}
```

Back in the Agent container, the following command should request the updated catalog from the server container and apply the configuration:

```bash
puppet agent --test
```

If succesful, the package `cowsay` should be downloaded and available in the Agent container. To confirm this, you may use the following command:

```bash
/usr/games/cowsay 'Puppet is a software configuration management tool developed by Puppet Inc. Puppet is used to manage stages of the IT infrastructure lifecycle.'
```







