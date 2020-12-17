#!/bin/bash
# file: vbox2esxi.sh

# extract subfiles
tar -xvf test-agent-1.ova


# todo: remove TAGs that are NOT associated with VMware

# STEP 1
# <vssd:VirtualSystemType>virtualbox-2.2</vssd:VirtualSystemType>  
# 2->
# <vssd:VirtualSystemType>vmx-07</vssd:VirtualSystemType>

# STEP 2
# <Item>
#   <rasd:Address>0</rasd:Address>
#   <rasd:Caption>sataController0</rasd:Caption>
#   <rasd:Description>SATA Controller</rasd:Description>
#   <rasd:ElementName>sataController0</rasd:ElementName>
#   <rasd:InstanceID>5</rasd:InstanceID>
#   <rasd:ResourceSubType>AHCI</rasd:ResourceSubType>
#   <rasd:ResourceType>20</rasd:ResourceType>
# </Item>
# 2-> 
# <Item>
#   <rasd:Address>0</rasd:Address>
#   <rasd:Caption>SCSIController</rasd:Caption>
#   <rasd:Description>SCSI Controller</rasd:Description>
#   <rasd:ElementName>SCSIController</rasd:ElementName>
#   <rasd:InstanceID>5</rasd:InstanceID>
#   <rasd:ResourceSubType>lsilogic</rasd:ResourceSubType>
#   <rasd:ResourceType>6</rasd:ResourceType>
# </Item>

# calculate SHA1
sha1sum test-agent-1.ovf 


# need to be update the value for sha1 "test-agent-1.mf"
# SHA1 (test-agent-1.ovf) = 07e491ae10e360429bd10ca4cf8ff2c2f96a0ac7
