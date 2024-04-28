# Docker_NoWhere2Hide

This repo contains docker files to spin up an instance of NoWhere2Hide by C2Links.

## Starting Up

First create a `.env` file containing the following entries:

```
POSTGRES_USER: nowhere2hide
POSTGRES_PWD: nowhere2hide
CENSYS_API_ID: 
CENSYS_SECRET: 
SHODAN: 
HUNTIO: 
```
Make sure to add your censys, shodan, and huntio keys to gain the full benefit of NoWhere2Hide.

To run execute:

```
sudo docker compose up -d
```

Open a browser and go to `localhost:6332`

## Auth Token

The auth key gets printed to a special log.  To read that log, do the following:

- `sudo docker volume ls`

Pick the volume that ends with `log` should look something like: `dockernowhere2hide_logs`

Get the location of the log file

- `sudo docker volume inspect dockernowhere2hide_logs`

The mount point should be listed out.  Use the mount and run the following:

- `sudo cat $MOUNTPOINT/auth.log`

Make sure to replace $MOUNTPOINT with the mount point shown via the docker volume inspect command

## Signature Directory

The signature directory is also exposed via a volume.  To get the mount point, do the following:

- `sudo docker volume ls`

Pick the volume that ends with `sigs` should look something like: `dockernowhere2hide_sigs`

