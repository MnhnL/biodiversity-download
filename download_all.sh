#!/usr/bin/bash

# This script downloads and extracts iNaturalist observations and
# Checklistbank checklists for Catalogue of Life, GBIF and
# iNaturalist. It also downloads ID-mapping from GBIF to CoL and from
# iNaturalist to CoL.

source download_clb.sh
source download_inat.sh

read -p "iNaturalist User: " inat_user
read -s -p "Password: " inat_password

# download_inat_observations "${inat_user}" "${inat_password}" 2017

# download_clb_checklist 267522 downloads/col.zip checklistbank/col &
# download_clb_checklist 53147 downloads/gbif.zip checklistbank/gbif &
# download_clb_checklist 139831 downloads/inat.zip checklistbank/inat &
# download_clb_match 267522 53147 downloads/gbif-match.zip checklistbank/gbif &
download_clb_match 267522 139831 downloads/inat-match.zip checklistbank/inat &


wait
