#/bin/bash

set -eu

dest="${1:-/etc/munin/plugins/}"
mydir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

ln -s "${mydir}/passenger_queue" "$dest"
ln -s "${mydir}/passenger_ram" "$dest"
ln -s "${mydir}/passenger_cpu" "$dest"
ln -s "${mydir}/passenger_processed" "$dest"
ln -s "${mydir}/passenger_uptime" "$dest"
ln -s "${mydir}/passenger_last_used" "$dest"
