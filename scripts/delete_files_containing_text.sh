#!/bin/bash
string=$1
self="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
find . ! -name $self -exec grep -q $string '{}' \; -delete
