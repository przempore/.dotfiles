#!/usr/bin/env bash

old=$1
new=$2

keepassxc-cli merge $old $new

