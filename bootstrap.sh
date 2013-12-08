#!/bin/bash

# Check if zotonic is checked out.
if [ ! -d /vagrant/zotonic ]; then
    echo Run ./start.sh before running vagrant up
    exit 1
fi

# Link your sites and modules here.

# if [ ! -L /vagrant/zotonic/priv/sites/tutorial ]; then
#    ln -s /vagrant/tutorial /vagrant/zotonic/priv/sites/tutorial
# fi 

# Check if Erlang solutions public key is available.
res=`apt-key export A14F4FCA | head -n 1`
if [ "$res" != "-----BEGIN PGP PUBLIC KEY BLOCK-----" ]; then
    apt-key adv --recv-keys --keyserver keyserver.ubuntu.com A14F4FCA
fi

# Add erlang solutions debian package to sources.list
res=`grep "erlang-solutions" /etc/apt/sources.list | wc -l`
if [ "$res" != "1" ]; then
    echo "deb http://packages.erlang-solutions.com/debian precise contrib" | sudo tee -a /etc/apt/sources.list
fi

# install packages
apt-get -y update
apt-get -y install \
    ack-grep build-essential git curl \
    imagemagick postgresql-9.1 postgresql-client-9.1 inotify-tools \
    erlang-base erlang-tools erlang-parsetools erlang-inets erlang-ssl erlang-eunit erlang-dev erlang-xmerl erlang-src
echo

# setup database
echo Check for zotonic database user
echo \\dg | sudo -u postgres psql | grep zotonic
if [ 0 -ne $? ]; then
    cat | sudo -u postgres psql <<EOF
CREATE USER zotonic with password 'secret';
EOF
fi

echo

echo Check for zotonic database
echo \\l | sudo -u postgres psql | grep zotonic
if [ 0 -ne $? ]; then
    cat | sudo -u postgres psql <<EOF
CREATE DATABASE zotonic WITH
OWNER zotonic
ENCODING 'UTF-8'
LC_CTYPE 'en_US.utf8'
LC_COLLATE 'en_US.utf8'
TEMPLATE template0;
-- Create the schema for the tutorial site
\c zotonic
CREATE SCHEMA tutorial;
ALTER SCHEMA tutorial OWNER TO zotonic;
EOF
fi

