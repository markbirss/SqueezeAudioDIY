Please take note that development has moved to Gitlab, this repository will be removed on 2018-12-01.

https://bitbucket.org/coenraadhuman/squeezeaudiodiy

SqueezeAudioDIY 1.5
===================
These are terminal based utilities to install and manage Squeezelite, Logitech Media Server.
![screenshot from 2016-10-24 15-59-22](https://cloud.githubusercontent.com/assets/20205514/19648725/609367ce-9a03-11e6-9442-bb0582cbd21c.png)

Requirements:
-------------
- Debian Jessie or higher
- Ubuntu 16.04 or higher

Supported Architecture:
-----------------------
- i386
- x86_64
- ARM

To Install:
-----------
```shell
git clone https://github.com/coenraadhuman/SqueezeAudioDIY.git
cd SqueezeAudioDIY
./setup.sh
```

To Access Setup After Installation:
-----------------------------------
```shell
sadiy_setup
```

Features:
---------
- Installers:
  - Squeezelite v1.8.5-802
  - Latest version of Squeezelite
  - Stable Logitech Media Server v7.7.5
  - Stable Logitech Media Server v7.8.0
  - Latest nightly Logitech Media Server v7.8.x
  - Latest nightly Logitech Media Server v7.9.x

- Squeezelite options:
  - View Squeezelite settings
  - View audio devices in detail
  - Change the default audio device
  - Set name of the Squeezelite player
  - Set extra arguments to Squeezelite
  - Deactivate extra arguments in configuration file
  - Point Squeezelite to your Server via IPv4
  - Deactivate custom server IPv4 address in configuration file

- Update utility for tools

- Uninstall utility for all software

- View logs
  - Squeezelite dynamic log
  - Squeezelite static log

Notes:
------
- Logitech Media Server v7.7.5 does not work on Ubuntu 16.04+
- Logitech Media Server v7.8.0 does not work on Ubuntu 16.04+
- Logitech Media Server v7.8.x does not work on Ubuntu 16.04+
- We include all our research in the info folder on I2S and boards, we hope you find it useful

Resources:
----------
- Squeezelite is based on the project of Ralph Irving here at github https://github.com/ralph-irving/squeezelite.git
- All Squeezebox installations are based on install files available on http://downloads.slimdevices.com/
