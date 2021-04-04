#!/bin/bash

set -o errexit

if [ ! -e /tmp/vpn-ramdisk ]; then
  mkdir /tmp/vpn-ramdisk
  mount -t ramfs -o size=1M ramfs /tmp/vpn-ramdisk
  chmod 0700 /tmp/vpn-ramdisk
fi

if [ ! -e /tmp/vpn-ramdisk/usb-mounted ]; then
  read -r -p "Enter path to USB device (empty for /dev/xvdi1 or /dev/xvdi, in that order): " usbdevice
  if [ -z "$usbdevice" ]; then
    if [ -e /dev/xvdi1 ]; then
      usbdevice="/dev/xvdi1"
    elif [ -e /dev/xvdi ]; then
      usbdevice="/dev/xvdi"
    fi
  fi
  mount "$usbdevice" /rw/config/vpn/
  touch /rw/config/vpn/no-userpassword.txt
  if [ -L /rw/config/vpn/vpn-client.conf ]; then
    echo "Relinking /rw/config/vpn/vpn-client.conf to" /rw/config/vpn/*.ovpn
    rm /rw/config/vpn/vpn-client.conf
    ln -s /rw/config/vpn/*.ovpn /rw/config/vpn/vpn-client.conf
  elif [ ! -e /rw/config/vpn/vpn-client.conf ]; then
    echo "Creating link /rw/config/vpn/vpn-client.conf to" /rw/config/vpn/*.ovpn
    ln -s /rw/config/vpn/*.ovpn /rw/config/vpn/vpn-client.conf
  else
    echo "vpn-client is probably a regular file. Doing nothing."
  fi
  touch /tmp/vpn-ramdisk/usb-mounted
fi

if [ ! -e /tmp/vpn-ramdisk/key-pass.txt ]; then
  read -s -r -p "Key password: " keypassword
  echo
  touch /tmp/vpn-ramdisk/key-pass.txt
  chmod 0600 /tmp/vpn-ramdisk/key-pass.txt
  cat <<< "$keypassword" > /tmp/vpn-ramdisk/key-pass.txt
fi

if [ ! -e /tmp/vpn-ramdisk/userpassword.txt ]; then
  read -p "Username: " username
  read -s -r -p "Password: " upassword
  echo
  touch /tmp/vpn-ramdisk/userpassword.txt
  chmod 0600 /tmp/vpn-ramdisk/userpassword.txt
  cat <<< "$username" > /tmp/vpn-ramdisk/userpassword.txt
  cat <<< "$upassword" >> /tmp/vpn-ramdisk/userpassword.txt
fi
