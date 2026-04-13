#!/bin/sh

echo "My .config files install script!"

if [ $WAYLAND_DISPLAY != "" ]; then
  echo "wayland"
  DISPLAY_TYPE="wayland"
elif [ $DISPLAY != "" ]; then 
  echo "not wayland"
  DISPLAY_TYPE="x11"

fi


# unset variables after finishing
unset $YES_OR_NO_INSTALL
