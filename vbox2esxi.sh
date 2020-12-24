#!/bin/bash
# file: vbox2esxi.sh

#FILENAME="$1"
FILENAME="$(zenity --file-selection --title="Select a file")"

RED='\033[0;31m'
GRN='\033[0;32m'
YEL='\033[0;33m'
BLU='\033[0;34m'
VLT='\033[0;35m'
NC='\033[0m' # No Color

OVF_FILENAME="$(basename ${FILENAME} .ova).ovf"
MF_FILENAME="$(basename ${FILENAME} .ova).mf"
BAK_FILENAME="${OVF_FILENAME}.bak"

#    +----------------+
#    |Extract the     |
#    |.ova file       |
#    +---+------------+
#        |
#        |
#    +---v------------+
#    |Changing VM     |
#    |description     |
#    +---+------------+
#        |
#        |
#    +---v------------+
#    |Replacing       |
#    |SATA-controller |
#    |description     |
#    +---+------------+
#        |
#        |
#    +---v------------+
#    |Generating Hash |
#    |for the new     |
#    |.ovf file       |
#    +----------------+


# STEP 1 (extract files & back-up .ovf)
tar -xvf $FILENAME
cp $OVF_FILENAME $BAK_FILENAME

# todo: remove TAGs that are NOT associated with VMware

# STEP 2 (change virtual-sys description to ESXi7.0)
sed -i '/<vssd:VirtualSystemType>virtualbox/c\        <vssd:VirtualSystemType>vmx-07</vssd:VirtualSystemType>' "$OVF_FILENAME"

# STEP 3 (replace SATA controlel description)
sed -i '/<rasd:Caption>sataController/c\        <rasd:Caption>SCSIController</rasd:Caption>' "$OVF_FILENAME"
sed -i '/<rasd:Description>SATA Controller/c\        <rasd:Description>SCSI Controller</rasd:Description>' "$OVF_FILENAME"
sed -i '/<rasd:ElementName>sataController/c\        <rasd:ElementName>SCSIController</rasd:ElementName>' "$OVF_FILENAME"
sed -i '/<rasd:ResourceSubType>AHCI/c\        <rasd:ResourceSubType>lsilogic</rasd:ResourceSubType>' "$OVF_FILENAME"
sed -i '/<rasd:ResourceType>20/c\        <rasd:ResourceType>6</rasd:ResourceType>' "$OVF_FILENAME"

diff -y $BAK_FILENAME $OVF_FILENAME 
printf "\n${YEL} List of Changes ###---------------------------------------------------------------------------------------\n"
diff -y --suppress-common-lines $BAK_FILENAME $OVF_FILENAME 
printf "\n-----------------------------------------------------------------------------------------------------------${NC}\n"

# STEP 4 (calculate SHA1 for the changes)
hash=($(sha1sum $OVF_FILENAME))
echo $hash
sed -i "/SHA1 ($OVF_FILENAME) = /c\SHA1 ($OVF_FILENAME) = ${hash}" "$MF_FILENAME"
