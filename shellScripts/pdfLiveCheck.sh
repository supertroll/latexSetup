#!/bin/bash

basename="$1"
pid=$(cat $HOME/.config/pdflive/pid)


if [ -e /proc/${pid} -a /proc/${pid}/exe ] ; then
    exit 0
else
    pdfLiveUpdate.sh "$basename"
    echo -n "$!" > $HOME/.config/pdflive/pid
