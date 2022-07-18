server = true
bootstrap_expect = 0
bind_addr = "127.0.0.1"

datacenter = "dc1"
data_dir = "./data"
encrypt = "U21GIY38n6aPRw/XB22I/J3HUUXpUVraqdv2F60YJ5c="
verify_incoming = true
verify_outgoing = true
verify_server_hostname = true

ca_file = "./certs/d7561985-agent-ca.pem"
cert_file = "./certs/dc1-server-d7561985-0.pem"
key_file = "./certs/dc1-server-d7561985-0-key.pem"

ui_config {
  enabled=true
}

acl {
  enabled = false
  default_policy = "allow"
  enable_token_persistence = true
}

auto_encrypt {
  allow_tls = false
}
performance {
  raft_multiplier = 1
}