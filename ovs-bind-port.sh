#!/bin/bash
# usage: ./ovs-bind-port.sh <uuid> <mac> <ip/mask>
tapname=tap`echo $1 | awk -F - '{ print $1 }'`
echo add internal port $tapname and bind to logical port $1
ovs-vsctl --may-exist add-port br-int $tapname -- set interface $tapname type=internal -- set interface $tapname external-ids:iface-id=$1
ip link set address $2 dev $tapname
ip netns add $1
ip link set $tapname netns $1
ip netns exec $1 ip link set dev $tapname up
ip netns exec $1 ip addr a $3 dev $tapname
