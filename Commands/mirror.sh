#!/bin/bash

Mirror () {
  sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
  sudo reflector --sort rate --verbose -n 5 --save /etc/pacman.d/mirrorlist

}
