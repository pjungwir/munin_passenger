#/bin/bash

set -eu

dest="${1:-/etc/munin/plugins/}"
mydir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

ln -fs "${mydir}/passenger_queue" "$dest"
ln -fs "${mydir}/passenger_ram" "$dest"
ln -fs "${mydir}/passenger_cpu" "$dest"
ln -fs "${mydir}/passenger_processed" "$dest"
ln -fs "${mydir}/passenger_uptime" "$dest"
ln -fs "${mydir}/passenger_last_used" "$dest"
