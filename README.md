My Ocean
========

A couple very simple scripts for managing Digital Ocean droplets.

Right now, the scripts are focused on making it easy to create and destroy droplets using a particular image. I use this to only run a droplet when I actually need it. The size/location of the droplet is kind of hard-coded right now. Sorry.

### Install

Clone repo!

### Setup

Put your [API keys](https://www.digitalocean.com/api_access) in `config/keys.rb`.

### Usage

To initialize the setup, first manually create a droplet, then shut it down using the `my_ocean` script.

#### Shutdown

`./bin/do_shutdown droplet_name`

This will power off the droplet, save a new snapshot, and destroy the droplet.

(You still get charged for droplets that are "off", but not for ones "destroyed".)

#### Restore

`./bin/do_restore droplet_name`

This will create a new droplet from the latest snapshot. It will also remove all but the latest two automatically-created snapshots.

### Problems

Very much alpha status and hard-coded to my use case.
