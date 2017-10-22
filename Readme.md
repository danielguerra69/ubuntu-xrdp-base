## Ubuntu 16.04 Xenial Multi User Remote Desktop Server Base

Base image for fully implemented Multi User xrdp with xorgxrdp and 
pulseaudio on Ubuntu 16.04.Copy/Paste and sound is working. 
Users can re-login in the same session.No window manager or 
X appications are installed.Intended for building different 
desktops with rdp.

## Entrypoint and Services

Docker can't work with the regular systemd for starting services.
For this supevisor was implemented. Supervisor reads seperate files
from /etc/supervisor/conf.d, the code inside the conf is supervisor.
The docker-entrypoint reads seperate files from /etc/entrypoint.d, 
the code inside the conf is "bash" and the filename sets the order.

## Building

You can use this base image to build any X application and
share it with RDP. The /etc map can be mounted as a volume.
When you mount an empty /etc at startup the docker-entrypoint.sh
script will copy the contents of the map /etc_entrypoint to /etc.
You can add services in supervisor by adding a .conf file to
/etc(_entrypoint)/supervisor/conf.d/
The entrypoint needed for your service can be added to
/etc(_entrypoint)/entrypoint.d/


## Xsession startup

For starting a desktop environment use the .Xclients file and
put it in /etc/skel/.Xlients
For XCFE4 use xfce4-session
For Mate use mate-ssesion 
After creating a new user all files from /etc/skel are copied
to the user map.

## Usage

Start the rdp server, the /etc and /home dir can be used as a volume 

```bash
docker run -d --name uxrdp --hostname terminalserver -v /tmp/etc:/etc \
 -v /tmp/home:/home -p 3389:3389 -p 2222:22 danielguerra/ubuntu-xrdp-base
```
*note if you allready use a rdp server on 3389 change -p <my-port>:3389
	  -p 2222:22 is for ssh access ( ssh -p 2222 ubuntu@<docker-ip> )
	  for firefox use --shm-size 1g


Connect with your remote desktop client to the docker server.
Use the Xorg session (leave as it is), user and pass.

## Add new users

No configuration is needed for new users just do

```bash
docker exec -ti uxrdp adduser mynewuser
```

After this the new user can login

## Add new services

To make sure all processes are working supervisor is installed.
The location for services to start is /etc/supervisor/conf.d

Example: Add mysql as a service

```bash
apt-get -yy install mysql-server
echo "[program:mysqld] \
command= /usr/sbin/mysqld \
user=mysql \
autorestart=true \
priority=100" > /etc/supervisor/conf.d/mysql.conf
supervisorctl update
```


## Add new entrypoint

To make sure your service will run because all conditions are fixed.
In the docker-entrypoint is a loop to run the entrypoint configuration 
files. The are sorted by name to determine the order and the language
used is "bash".

Example: Add mysql entrypoint

```bash
echo "mkdir -p /var/lib/mysql \
chown -R mysql:mysql /var/lib/mysql" > /etc/entrypoint.d/06-mysql.conf

```
