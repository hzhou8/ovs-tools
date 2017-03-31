#!/bin/bash
# usage: ./ovs-bind-port.sh <uuid> <mac> <ip/mask>
#
# After creating logical port using Neutron port-create or directly
# create in SDN e.g. ovn-nbctl, use this command to simulate VM/pod
# creation on host. To test, use:
# $ ip netns exec <uuid> <command>
# <command> is any command supposed to test in VM/pod, such as ping

tapname=tap`echo $1 | awk -F - '{ print $1 }'`
echo add internal port $tapname and bind to logical port $1
ovs-vsctl --may-exist add-port br-int $tapname -- set interface $tapname type=internal -- set interface $tapname external-ids:iface-id=$1
ip link set address $2 dev $tapname
ip netns add $1
ip link set $tapname netns $1
ip netns exec $1 ip link set dev $tapname up
ip netns exec $1 ip addr a $3 dev $tapname
