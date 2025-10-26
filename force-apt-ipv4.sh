set -euo pipefail

IMG_DIR="${1}"

if [ ! -d "${IMG_DIR}" ]; then
  echo "First parameter should be an software image directory"
  exit 1
fi


echo 'Acquire::ForceIPv4 "true";' | sudo tee "${IMG_DIR}/etc/apt/apt.conf.d/99force-ipv4"
