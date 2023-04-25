#!/bin/sh

# Copyright © 2022 Schubert Anselme <schubert@anselm.es>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

set -e

# NOTE: https://www.redhat.com/sysadmin/arguments-options-bash-scripts

: "${NAME:="world"}"

#
## Help
#

print_help() {
  # Display help
  cat <<EOF
Add description of the script functions here.

Syntax: $0 [option]

Options:
  -n   Pass a name.
  -h   Print this help.

EOF
}

#
## Main
#

# Process input options.
while getopts ":hn:" option; do
  case ${option} in
  h)
    # Display help
    print_help
    exit
    ;;
  n)
    # Enter a name
    NAME=${OPTARG}
    ;;
  \?)
    # Invalid option
    echo "Error: Invalid option"
    exit
    ;;
  esac
done

# Run
echo "Hello ${NAME}!"
