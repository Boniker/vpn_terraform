variable "region" {
  description = "There are a number of region dependent resources. This makes sure everything is in the same region."
  type        = string
  default     = "eu-central-1"
}

variable "availability_zones" {
  description = "VPC availability zones"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

variable "target_cidr_block" {
  description = "cidr for the target VPC that is created"
  type        = string
  default     = "10.0.0.0/16"
}

variable "client_cidr_block" {
  description = "Network CIDR to use for clients"
  type        = string
  default     = "10.1.0.0/22"
}

variable "logging_stream_name" {
  description = "Names of stream used for logging"
  type        = string
  default     = "client_vpn"
}

variable "logging_enabled" {
  description = "Enables or disables Client VPN Cloudwatch logging."
  type        = bool
  default     = false
}

variable "retention_in_days" {
  description = "Number of days you want to retain log events in the log group"
  type        = number
  default     = 0
}

variable "organization_name" {
  type        = string
  description = "Name of organization to use in private certificate"
  default     = "Cloud Posse"
}

variable "authorization_rules" {
  description = "List of objects describing the authorization rules for the client vpn"
  default = [
    {
      authorize_all_groups = true
      description          = "Auth Rule"
      name                 = "rule"
      target_network_cidr  = "10.0.0.0/16"
    }
  ]
}

variable "additional_routes" {
  default     = []
  description = "A list of additional routes that should be attached to the Client VPN endpoint"

  type = list(object({
    destination_cidr_block = string
    description            = string
  }))
}

variable "ca_common_name" {
  default     = "vpn.internal.cloudposse.com"
  type        = string
  description = "Unique Common Name for CA self-signed certificate"
}

variable "root_common_name" {
  type        = string
  description = "Unique Common Name for Root self-signed certificate"
  default     = "vpn-client.internal.cloudposse.com"
}

variable "server_common_name" {
  type        = string
  description = "Unique Common Name for Server self-signed certificate"
  default     = "vpn-server.internal.cloudposse.com"
}

variable "export_client_certificate" {
  default     = true
  sensitive   = true
  type        = bool
  description = "Flag to determine whether to export the client certificate with the VPN configuration"
}

variable "dns_servers" {
  default     = []
  type        = list(string)
  description = "(Optional) Information about the DNS servers to be used for DNS resolution. A Client VPN endpoint can have up to two DNS servers. If no DNS server is specified, the DNS address of the VPC that is to be associated with Client VPN endpoint is used as the DNS server."
}

variable "split_tunnel" {
  default     = true
  type        = bool
  description = "(Optional) Indicates whether split-tunnel is enabled on VPN endpoint. Default value is false."
}