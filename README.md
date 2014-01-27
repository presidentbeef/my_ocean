My Ocean
========

A couple very simple scripts for managing Digital Ocean droplets.

Right now, the scripts are focused on making it easy to create and destroy droplets using a particular image. I use this to only run a droplet when I actually need it (sorry).

### Install

Clone repo!

`git clone git@github.com:presidentbeef/my_ocean.git`

### Setup

Put your [API keys](https://www.digitalocean.com/api_access) in `config/keys.rb`.

### Usage

To initialize the setup, first manually create a droplet through Digital Ocean's web interface, then shut it down using the `my_ocean` script.

#### Shutdown

`./bin/do_shutdown droplet_name`

This will power off the droplet, save a new snapshot, and destroy the droplet.

(You still get charged for droplets that are "off", but not for ones "destroyed".)


#### Restore

`./bin/do_restore droplet_name`

This will create a new droplet from the latest snapshot. It will also remove all but the latest two automatically-created snapshots.


*Options*

`--region [REGION ID]` - Restore in the given region

Currently this is by ID:

1 - New York 1
2 - ?
3 - San Francisco 1
4 - New York 2
5 - Amsterdam 2

Default is 3.s

`--size [SIZE]` - Restore at the given size

The sizes are by RAM size, e.g., "512MB", "1GB", "2GB", "4GB", etc.

Default is 2GB.

### Problems

Very much alpha status and hard-coded to my use case.

### License

MIT
