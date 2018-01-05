#!/bin/bash

[ $# -eq 0 ] && { 
    echo "Usage: $0 <port name> <mac> <ip/mask>" 
    echo ""
    echo "After creating logical port using Neutron port-create or directly
create in SDN e.g. ovn-nbctl, use this command to simulate VM/pod
creation on host. To test, use:
$ ip netns exec <port name> <command>
<command> is any command supposed to test in VM/pod, such as ping"
    exit 1
}

vethname=`echo $1 | awk -F - '{ print $1 }'`
vethhost=veth-$vethname
vethns=vethns-$vethname
echo add veth pair $vethhost:$vethns and bind to logical port $1
ip link add $vethhost type veth peer name $vethns
ovs-vsctl --may-exist add-port br-int $vethhost -- set interface $vethhost external-ids:iface-id=$1
ip link set address $2 dev $vethns
ip netns add $1
ip link set $vethns netns $1
ip netns exec $1 ip link set dev $vethns up
ip link set dev $vethhost up
ip netns exec $1 ip addr a $3 dev $vethns
