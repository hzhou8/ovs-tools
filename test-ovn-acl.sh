ovs-vsctl add-port br-int p1 -- set interface p1 type=internal -- set interface p1 external-ids:iface-id=lsp1
ovs-vsctl add-port br-int p2 -- set interface p2 type=internal -- set interface p2 external-ids:iface-id=lsp2
ovn-nbctl ls-add ls1
ovn-nbctl lsp-add ls1 lsp1
ovn-nbctl lsp-set-addresses lsp1 "aa:aa:aa:aa:aa:01 10.0.0.11"
ovn-nbctl lsp-add ls1 lsp2
ovn-nbctl lsp-set-addresses lsp2 "aa:aa:aa:aa:aa:02 10.0.0.12"
ovn-nbctl --log acl-add ls1 to-lport 200 'outport=="lsp2" && ip4 && ip4.src == 10.0.0.11' allow-related

