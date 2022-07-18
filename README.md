# Consul
* Deployment Guide - https://learn.hashicorp.com/tutorials/consul/deployment-guide
* Consul Service Mesh in Production - https://learn.hashicorp.com/tutorials/consul/service-mesh-production-checklist


## Manual
## first

generate encryption key, `encrypt` value from config or `gossip_encryption_key` encription

```bash
consul keygen
```

according https://learn.hashicorp.com/tutorials/consul/deployment-guide:

```bash 
consul tls ca create -domain d7561985                  
consul tls cert create -server -dc dc1 -domain d7561985
consul tls cert create -client -dc dc1 -domain d7561985
```

run:
```bash
consul agent -domain d7561985 -config-dir ./cfg
```

next gen acl in other console:

```bash
consul acl bootstrap -datacenter=dc1 
```

select SecretID and puth it =>
```bash
export CONSUL_HTTP_TOKEN="<Token SecretID from previous step>"
export CONSUL_MGMT_TOKEN="<Token SecretID from previous step>"

consul acl policy create -token=${CONSUL_MGMT_TOKEN} -name node-policy -rules @node-policy.hcl
consul acl token create -token=${CONSUL_MGMT_TOKEN} -description "node token" -policy-name node-policy
```

select secretID from `token create`
```bash
export CONSUL_AGT_TOKEN="<Token SecretID from previous step>"
consul acl set-agent-token -token=${CONSUL_MGMT_TOKEN} agent ${CONSUL_AGT_TOKEN}
```

# Terraform
Based on https://github.com/hashicorp/terraform-aws-consul following example `example-with-encryption`

NOTE: example use private/public subnets approach, that's why we use vpc creation.

1. Create certificate from first step. Name them as you with, but edit `./terraform/packer/consul-with-certs.json`
2. Call packer build, example:  `$ packer build -var ca_public_key_path=./certs/d7561985-agent-ca.pem -var tls_public_key_path=./certs/dc1-server-d7561985-0.pem -var tls_private_key_path=./certs/dc1-server-d7561985-0-key.pem ./terraform/packer/consul-with-certs.json` note we use `eu-central-1` region, tou can change it via variable 
3. Get AMI and use it as variable 
4. change `gossip_encryption_key` which you genereted in local step 


# Connect local to terraform

NOTE: local bind should be NAT IP address (or public) + for now terraform module bind private IP. But if you change ../modules.run_consul/run-consul::get_instance_ip_address "local-ipv4" => "public-ipv4"  for server it would be enough, or just do it manually (as clients would be located in private subnet and  whey don't have any public ip)

```bash
consul members -wan
consul join -wan <PUBLIC IP SERVER NODE A> <PUBLIC IP SERVER NODE B> <PUBLIC IP SERVER NODE C>
consul members -wan
```