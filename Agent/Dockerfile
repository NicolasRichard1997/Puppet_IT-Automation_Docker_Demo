FROM ubuntu:22.04

# Install necessary packages, add Puppet repository, and install ping
RUN apt-get update && \
    apt-get install -y wget curl gnupg2 lsb-release software-properties-common nano iputils-ping && \
    wget https://apt.puppet.com/DEB-GPG-KEY-puppet -O /tmp/DEB-GPG-KEY-puppet && \
    apt-key add /tmp/DEB-GPG-KEY-puppet && \
    wget -qO /tmp/puppet8-release-jammy.deb https://apt.puppet.com/puppet8-release-jammy.deb && \
    dpkg -i /tmp/puppet8-release-jammy.deb && \
    apt-get update && \
    apt-get install -y puppet-agent && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables for Puppet
ENV PATH="/opt/puppetlabs/bin:${PATH}"

# Copy the local puppet.conf file to the image
COPY puppet.conf /etc/puppetlabs/puppet/puppet.conf


CMD ["/bin/bash"]

