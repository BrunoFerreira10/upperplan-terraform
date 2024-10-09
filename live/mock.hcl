locals {

  acm = {
    certificate = {
      "arn"         = "arn:aws:acm:us-east-1:123456789012:certificate/abcd1234-efgh-5678-ijkl-910mnopqrst"
      "domain_name" = "dev-example.mydomain.com"
      "id"          = "arn:aws:acm:us-east-1:123456789012:certificate/abcd1234-efgh-5678-ijkl-910mnopqrst"
    }
  }

  ecr = {
    repository = {
      "arn" = "arn:aws:ecr:us-east-1:123456789012:repository/dev-example_project/container"
      "encryption_configuration" = tolist([
        {
          "encryption_type" = "AES256"
          "kms_key" = ""
        },
      ])
      "force_delete" = true
      "id" = "dev-example_project/container"
      "image_scanning_configuration" = tolist([
        {
          "scan_on_push" = true
        },
      ])
      "image_tag_mutability" = "MUTABLE"
      "name" = "dev-example_project/container"
      "registry_id" = "123456789012"
      "repository_url" = "123456789012.dkr.ecr.us-east-1.amazonaws.com/dev-example_project/container"
      "tags" = tomap({
        "Name" = "dev-example_project"
      })
      "tags_all" = tomap({
        "Name" = "dev-example_project"
        "author" = "JohnDoe"
        "customer" = "ExampleCorp"
        "environment" = "dev"
        "managed-by" = "terraform"
        "project" = "example_project"
      })
      "timeouts" = null /* object */
    }
  }

  ecs = {
    ecs = {
      "cluster" = {
        "arn" = "arn:aws:ecs:us-east-1:123456789012:cluster/dev_cluster_example_project"
        "configuration" = tolist([])
        "id" = "arn:aws:ecs:us-east-1:123456789012:cluster/dev_cluster_example_project"
        "name" = "dev_cluster_example_project"
        "service_connect_defaults" = tolist([])
        "setting" = toset([
          {
            "name" = "containerInsights"
            "value" = "disabled"
          },
        ])
        "tags" = tomap({})
        "tags_all" = tomap({
          "author" = "JohnDoe"
          "customer" = "ExampleCorp"
          "environment" = "dev"
          "managed-by" = "terraform"
          "project" = "example_project"
        })
      }
      "service" = {
        "alarms" = tolist([])
        "capacity_provider_strategy" = toset([
          {
            "base" = 0
            "capacity_provider" = "FARGATE_SPOT"
            "weight" = 2
          },
          {
            "base" = 1
            "capacity_provider" = "FARGATE"
            "weight" = 1
          },
        ])
        "cluster" = "arn:aws:ecs:us-east-1:123456789012:cluster/dev_cluster_example_project"
        "deployment_circuit_breaker" = tolist([])
        "deployment_controller" = tolist([
          {
            "type" = "CODE_DEPLOY"
          },
        ])
        "deployment_maximum_percent" = 200
        "deployment_minimum_healthy_percent" = 100
        "desired_count" = 0
        "enable_ecs_managed_tags" = false
        "enable_execute_command" = false
        "force_delete" = tobool(null)
        "force_new_deployment" = tobool(null)
        "health_check_grace_period_seconds" = 30
        "iam_role" = "/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
        "id" = "arn:aws:ecs:us-east-1:123456789012:service/dev_cluster_example_project/dev_service_example_project"
        "launch_type" = ""
        "load_balancer" = toset([
          {
            "container_name" = "dev_container_example_project"
            "container_port" = 80
            "elb_name" = ""
            "target_group_arn" = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/dev-tg-blue-example-project/abcd1234abcd1234"
          },
        ])
        "name" = "dev_service_example_project"
        "network_configuration" = tolist([
          {
            "assign_public_ip" = false
            "security_groups" = toset([
              "sg-0123456789abcdef0",
            ])
            "subnets" = toset([
              "subnet-0123456789abcdef0",
              "subnet-0fedcba9876543210",
            ])
          },
        ])
        "ordered_placement_strategy" = tolist([])
        "placement_constraints" = toset([])
        "platform_version" = "1.4.0"
        "propagate_tags" = "NONE"
        "scheduling_strategy" = "REPLICA"
        "service_connect_configuration" = tolist([])
        "service_registries" = tolist([])
        "tags" = tomap({
          "Name" = "dev_service_example_project"
        })
        "tags_all" = tomap({
          "Name" = "dev_service_example_project"
          "author" = "JohnDoe"
          "customer" = "ExampleCorp"
          "environment" = "dev"
          "managed-by" = "terraform"
          "project" = "example_project"
        })
        "task_definition" = "arn:aws:ecs:us-east-1:123456789012:task-definition/dev_task_example_project:1"
        "timeouts" = null /* object */
        "triggers" = tomap({})
        "volume_configuration" = tolist([])
        "wait_for_steady_state" = false
      }
    }

  }

  efs = {
    efs = {
      "arn" = "arn:aws:elasticfilesystem:us-east-1:01234789965464:file-system/fs-fffffffffffff"
      "dns_name" = "fs-fffffffffffff.efs.us-east-1.amazonaws.com"
      "id" = "fs-fffffffffffff"
    }
  }

  elb = {
    elb = {
      "access_logs" = tolist([
        {
          "bucket" = ""
          "enabled" = false
          "prefix" = ""
        },
      ])
      "arn" = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/dev-elb-example-project/abcd1234abcd1234"
      "arn_suffix" = "app/dev-elb-example-project/abcd1234abcd1234"
      "client_keep_alive" = 3600
      "connection_logs" = tolist([
        {
          "bucket" = ""
          "enabled" = false
          "prefix" = ""
        },
      ])
      "customer_owned_ipv4_pool" = ""
      "desync_mitigation_mode" = "defensive"
      "dns_name" = "dev-elb-example-project-1234567890.us-east-1.elb.amazonaws.com"
      "dns_record_client_routing_policy" = tostring(null)
      "drop_invalid_header_fields" = false
      "enable_cross_zone_load_balancing" = true
      "enable_deletion_protection" = false
      "enable_http2" = true
      "enable_tls_version_and_cipher_suite_headers" = false
      "enable_waf_fail_open" = false
      "enable_xff_client_port" = false
      "enforce_security_group_inbound_rules_on_private_link_traffic" = ""
      "id" = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/dev-elb-example-project/abcd1234abcd1234"
      "idle_timeout" = 3600
      "internal" = false
      "ip_address_type" = "ipv4"
      "load_balancer_type" = "application"
      "name" = "dev-elb-example-project"
      "name_prefix" = ""
      "preserve_host_header" = false
      "security_groups" = toset([
        "sg-0abcdef1234567890",
      ])
      "subnet_mapping" = toset([
        {
          "allocation_id" = ""
          "ipv6_address" = ""
          "outpost_id" = ""
          "private_ipv4_address" = ""
          "subnet_id" = "subnet-0123456789abcdef0"
        },
        {
          "allocation_id" = ""
          "ipv6_address" = ""
          "outpost_id" = ""
          "private_ipv4_address" = ""
          "subnet_id" = "subnet-0fedcba9876543210"
        },
      ])
      "subnets" = toset([
        "subnet-0123456789abcdef0",
        "subnet-0fedcba9876543210",
      ])
      "tags" = tomap({
        "Name" = "dev_elb_example_project"
      })
      "tags_all" = tomap({
        "Name" = "dev_elb_example_project"
        "author" = "JohnDoe"
        "customer" = "ExampleCorp"
        "environment" = "dev"
        "managed-by" = "terraform"
        "project" = "example_project"
      })
      "timeouts" = null /* object */
      "vpc_id" = "vpc-0abc123456789def0"
      "xff_header_processing_mode" = "append"
      "zone_id" = "Z35SXDOTRQ7X7K"
    }

    lb_listeners = {
      "http" = {
        "alpn_policy" = tostring(null)
        "arn" = "arn:aws:elasticloadbalancing:us-east-1:123456789012:listener/app/dev-elb-example-project/abcd1234abcd1234/efgh5678efgh5678"
        "certificate_arn" = tostring(null)
        "default_action" = tolist([
          {
            "authenticate_cognito" = tolist([])
            "authenticate_oidc" = tolist([])
            "fixed_response" = tolist([])
            "forward" = tolist([])
            "order" = 1
            "redirect" = tolist([
              {
                "host" = "#{host}"
                "path" = "/#{path}"
                "port" = "443"
                "protocol" = "HTTPS"
                "query" = "#{query}"
                "status_code" = "HTTP_301"
              },
            ])
            "target_group_arn" = ""
            "type" = "redirect"
          },
        ])
        "id" = "arn:aws:elasticloadbalancing:us-east-1:123456789012:listener/app/dev-elb-example-project/abcd1234abcd1234/efgh5678efgh5678"
        "load_balancer_arn" = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/dev-elb-example-project/abcd1234abcd1234"
        "mutual_authentication" = tolist([])
        "port" = 80
        "protocol" = "HTTP"
        "ssl_policy" = ""
        "tags" = tomap({
          "Name" = "dev_listener_http_example_project"
        })
        "tags_all" = tomap({
          "Name" = "dev_listener_http_example_project"
          "author" = "JohnDoe"
          "customer" = "ExampleCorp"
          "environment" = "dev"
          "managed-by" = "terraform"
          "project" = "example_project"
        })
        "timeouts" = null /* object */
      }
      "https_blue" = {
        "alpn_policy" = tostring(null)
        "arn" = "arn:aws:elasticloadbalancing:us-east-1:123456789012:listener/app/dev-elb-example-project/abcd1234abcd1234/ijkl9012ijkl9012"
        "certificate_arn" = "arn:aws:acm:us-east-1:123456789012:certificate/abcd1234-abcd-1234-abcd-abcdef123456"
        "default_action" = tolist([
          {
            "authenticate_cognito" = tolist([])
            "authenticate_oidc" = tolist([])
            "fixed_response" = tolist([])
            "forward" = tolist([])
            "order" = 1
            "redirect" = tolist([])
            "target_group_arn" = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/dev-tg-blue-example-project/abcd1234abcd1234"
            "type" = "forward"
          },
        ])
        "id" = "arn:aws:elasticloadbalancing:us-east-1:123456789012:listener/app/dev-elb-example-project/abcd1234abcd1234/ijkl9012ijkl9012"
        "load_balancer_arn" = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/dev-elb-example-project/abcd1234abcd1234"
        "mutual_authentication" = tolist([
          {
            "ignore_client_certificate_expiry" = false
            "mode" = "off"
            "trust_store_arn" = ""
          },
        ])
        "port" = 443
        "protocol" = "HTTPS"
        "ssl_policy" = "ELBSecurityPolicy-TLS13-1-2-2021-06"
        "tags" = tomap({
          "Name" = "dev_listener_https_blue_example_project"
        })
        "tags_all" = tomap({
          "Name" = "dev_listener_https_blue_example_project"
          "author" = "JohnDoe"
          "customer" = "ExampleCorp"
          "environment" = "dev"
          "managed-by" = "terraform"
          "project" = "example_project"
        })
        "timeouts" = null /* object */
      }
      "https_green" = {
        "alpn_policy" = tostring(null)
        "arn" = "arn:aws:elasticloadbalancing:us-east-1:123456789012:listener/app/dev-elb-example-project/abcd1234abcd1234/mnop3456mnop3456"
        "certificate_arn" = "arn:aws:acm:us-east-1:123456789012:certificate/abcd1234-abcd-1234-abcd-abcdef123456"
        "default_action" = tolist([
          {
            "authenticate_cognito" = tolist([])
            "authenticate_oidc" = tolist([])
            "fixed_response" = tolist([])
            "forward" = tolist([])
            "order" = 1
            "redirect" = tolist([])
            "target_group_arn" = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/dev-tg-green-example-project/efgh5678efgh5678"
            "type" = "forward"
          },
        ])
        "id" = "arn:aws:elasticloadbalancing:us-east-1:123456789012:listener/app/dev-elb-example-project/abcd1234abcd1234/mnop3456mnop3456"
        "load_balancer_arn" = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/dev-elb-example-project/abcd1234abcd1234"
        "mutual_authentication" = tolist([
          {
            "ignore_client_certificate_expiry" = false
            "mode" = "off"
            "trust_store_arn" = ""
          },
        ])
        "port" = 8443
        "protocol" = "HTTPS"
        "ssl_policy" = "ELBSecurityPolicy-TLS13-1-2-2021-06"
        "tags" = tomap({
          "Name" = "dev_listener_https_green_example_project"
        })
        "tags_all" = tomap({
          "Name" = "dev_listener_https_green_example_project"
          "author" = "JohnDoe"
          "customer" = "ExampleCorp"
          "environment" = "dev"
          "managed-by" = "terraform"
          "project" = "example_project"
        })
        "timeouts" = null /* object */
      }
    }

    target_groups = {
      "blue" = {
        "arn" = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/dev-tg-blue-example-project/abcd1234abcd1234"
        "arn_suffix" = "targetgroup/dev-tg-blue-example-project/abcd1234abcd1234"
        "connection_termination" = tobool(null)
        "deregistration_delay" = "300"
        "health_check" = tolist([
          {
            "enabled" = true
            "healthy_threshold" = 2
            "interval" = 7
            "matcher" = "200-302"
            "path" = "/"
            "port" = "traffic-port"
            "protocol" = "HTTP"
            "timeout" = 5
            "unhealthy_threshold" = 3
          },
        ])
        "id" = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/dev-tg-blue-example-project/abcd1234abcd1234"
        "ip_address_type" = "ipv4"
        "lambda_multi_value_headers_enabled" = false
        "load_balancer_arns" = toset([])
        "load_balancing_algorithm_type" = "round_robin"
        "load_balancing_anomaly_mitigation" = "off"
        "load_balancing_cross_zone_enabled" = "use_load_balancer_configuration"
        "name" = "dev-tg-blue-example-project"
        "name_prefix" = ""
        "port" = 80
        "preserve_client_ip" = tostring(null)
        "protocol" = "HTTP"
        "protocol_version" = "HTTP1"
        "proxy_protocol_v2" = false
        "slow_start" = 0
        "stickiness" = tolist([
          {
            "cookie_duration" = 86400
            "cookie_name" = ""
            "enabled" = false
            "type" = "lb_cookie"
          },
        ])
        "tags" = tomap({
          "Name" = "dev-tg-blue-example_project"
        })
        "tags_all" = tomap({
          "Name" = "dev-tg-blue-example_project"
          "author" = "JohnDoe"
          "customer" = "ExampleCorp"
          "environment" = "dev"
          "managed-by" = "terraform"
          "project" = "example_project"
        })
        "target_failover" = tolist([
          {
            "on_deregistration" = tostring(null)
            "on_unhealthy" = tostring(null)
          },
        ])
        "target_group_health" = tolist([
          {
            "dns_failover" = tolist([
              {
                "minimum_healthy_targets_count" = "1"
                "minimum_healthy_targets_percentage" = "off"
              },
            ])
            "unhealthy_state_routing" = tolist([
              {
                "minimum_healthy_targets_count" = 1
                "minimum_healthy_targets_percentage" = "off"
              },
            ])
          },
        ])
        "target_health_state" = tolist([
          {
            "enable_unhealthy_connection_termination" = tobool(null)
            "unhealthy_draining_interval" = tonumber(null)
          },
        ])
        "target_type" = "ip"
        "vpc_id" = "vpc-0abc123456789def0"
      }
      "green" = {
        "arn" = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/dev-tg-green-example-project/efgh5678efgh5678"
        "arn_suffix" = "targetgroup/dev-tg-green-example-project/efgh5678efgh5678"
        "connection_termination" = tobool(null)
        "deregistration_delay" = "300"
        "health_check" = tolist([
          {
            "enabled" = true
            "healthy_threshold" = 2
            "interval" = 7
            "matcher" = "200-302"
            "path" = "/"
            "port" = "traffic-port"
            "protocol" = "HTTP"
            "timeout" = 5
            "unhealthy_threshold" = 3
          },
        ])
        "id" = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/dev-tg-green-example-project/efgh5678efgh5678"
        "ip_address_type" = "ipv4"
        "lambda_multi_value_headers_enabled" = false
        "load_balancer_arns" = toset([])
        "load_balancing_algorithm_type" = "round_robin"
        "load_balancing_anomaly_mitigation" = "off"
        "load_balancing_cross_zone_enabled" = "use_load_balancer_configuration"
        "name" = "dev-tg-green-example-project"
        "name_prefix" = ""
        "port" = 80
        "preserve_client_ip" = tostring(null)
        "protocol" = "HTTP"
        "protocol_version" = "HTTP1"
        "proxy_protocol_v2" = false
        "slow_start" = 0
        "stickiness" = tolist([
          {
            "cookie_duration" = 86400
            "cookie_name" = ""
            "enabled" = false
            "type" = "lb_cookie"
          },
        ])
        "tags" = tomap({
          "Name" = "dev-tg-green-example_project"
        })
        "tags_all" = tomap({
          "Name" = "dev-tg-green-example_project"
          "author" = "JohnDoe"
          "customer" = "ExampleCorp"
          "environment" = "dev"
          "managed-by" = "terraform"
          "project" = "example_project"
        })
        "target_failover" = tolist([
          {
            "on_deregistration" = tostring(null)
            "on_unhealthy" = tostring(null)
          },
        ])
        "target_group_health" = tolist([
          {
            "dns_failover" = tolist([
              {
                "minimum_healthy_targets_count" = "1"
                "minimum_healthy_targets_percentage" = "off"
              },
            ])
            "unhealthy_state_routing" = tolist([
              {
                "minimum_healthy_targets_count" = 1
                "minimum_healthy_targets_percentage" = "off"
              },
            ])
          },
        ])
        "target_health_state" = tolist([
          {
            "enable_unhealthy_connection_termination" = tobool(null)
            "unhealthy_draining_interval" = tonumber(null)
          },
        ])
        "target_type" = "ip"
        "vpc_id" = "vpc-0abc123456789def0"
      }
    }

  }

  rds = {
    rds = {
      id                        = "rds-mysql-instance-01",
      arn                       = "arn:aws:rds:us-east-1:123456789012:db:mysql-instance-01",
      endpoint                  = "mysql-instance-01.abcd1234.us-east-1.rds.amazonaws.com",
      private_ip                = "10.0.1.25",
      port                      = 3306,
      db_name                   = "mydatabase",
      db_username               = "admin",
      ssm_parameter_db_password = "/aws/ssm/rds/mysql/password"
    }
  }
  
  s3 = {
    bucket = {
      "acceleration_status" = ""
      "acl" = tostring(null)
      "arn" = "arn:aws:s3:::dev-example-bucket"
      "bucket" = "dev-example-bucket"
      "bucket_domain_name" = "dev-example-bucket.s3.amazonaws.com"
      "bucket_prefix" = ""
      "bucket_regional_domain_name" = "dev-example-bucket.s3.us-east-1.amazonaws.com"
      "cors_rule" = tolist([])
      "force_destroy" = true
      "grant" = toset([
        {
          "id" = "393sfffffffffffffffffffffffffffffffffffffffffff2fa45c3"
          "permissions" = toset([
            "FULL_CONTROL",
          ])
          "type" = "CanonicalUser"
          "uri" = ""
        },
      ])
      "hosted_zone_id" = "Z3AQBSTGFYJSTF"
      "id" = "dev-example-bucket"
      "lifecycle_rule" = tolist([])
      "logging" = tolist([])
      "object_lock_configuration" = tolist([])
      "object_lock_enabled" = false
      "policy" = ""
      "region" = "us-east-1"
      "replication_configuration" = tolist([])
      "request_payer" = "BucketOwner"
      "server_side_encryption_configuration" = tolist([
        {
          "rule" = tolist([
            {
              "apply_server_side_encryption_by_default" = tolist([
                {
                  "kms_master_key_id" = ""
                  "sse_algorithm" = "AES256"
                },
              ])
              "bucket_key_enabled" = false
            },
          ])
        },
      ])
      "tags" = tomap(null) /* of string */
      "tags_all" = tomap({
        "author" = "BrunoFerreira"
        "customer" = "UpperPlan"
        "environment" = "dev"
        "managed-by" = "terraform"
        "project" = "glpi"
      })
      "timeouts" = null /* object */
      "versioning" = tolist([
        {
          "enabled" = false
          "mfa_delete" = false
        },
      ])
      "website" = tolist([])
      "website_domain" = tostring(null)
      "website_endpoint" = tostring(null)
    }
  }

  ses = {
    ses_user_access_key_id = "AKIAU6G99999999999"
    ses_user_secret_access_key = "5WVfffffffffffffffffffffffffX1e"
    ses_user_smtp_password_v4 = "BHamLffffffffffffffffffffffffffffffT6dkdQz8e"
  }

  vpc = {
    vpc = {
      "cidr_block" = "10.2.0.0/16"
      "id" = "vpc-0123456789abcdef0"
      "name" = "dev_vpc_example"
      "network_acls" = {
        "private" = {
          "arn" = "arn:aws:ec2:us-east-1:123456789012:network-acl/acl-0123456789abcdef0"
          "egress" = toset([
            {
              "action" = "allow"
              "cidr_block" = "0.0.0.0/0"
              "from_port" = 443
              "icmp_code" = 0
              "icmp_type" = 0
              "ipv6_cidr_block" = ""
              "protocol" = "6"
              "rule_no" = 250
              "to_port" = 443
            },
            {
              "action" = "allow"
              "cidr_block" = "0.0.0.0/0"
              "from_port" = 587
              "icmp_code" = 0
              "icmp_type" = 0
              "ipv6_cidr_block" = ""
              "protocol" = "6"
              "rule_no" = 450
              "to_port" = 587
            },
            {
              "action" = "allow"
              "cidr_block" = "0.0.0.0/0"
              "from_port" = 80
              "icmp_code" = 0
              "icmp_type" = 0
              "ipv6_cidr_block" = ""
              "protocol" = "6"
              "rule_no" = 350
              "to_port" = 80
            },
            {
              "action" = "allow"
              "cidr_block" = "10.2.0.0/16"
              "from_port" = 1024
              "icmp_code" = 0
              "icmp_type" = 0
              "ipv6_cidr_block" = ""
              "protocol" = "6"
              "rule_no" = 9999
              "to_port" = 65535
            },
          ])
          "id" = "acl-0123456789abcdef0"
          "ingress" = toset([
            {
              "action" = "allow"
              "cidr_block" = "0.0.0.0/0"
              "from_port" = 1024
              "icmp_code" = 0
              "icmp_type" = 0
              "ipv6_cidr_block" = ""
              "protocol" = "6"
              "rule_no" = 9999
              "to_port" = 65535
            },
            {
              "action" = "allow"
              "cidr_block" = "10.2.0.0/16"
              "from_port" = 80
              "icmp_code" = 0
              "icmp_type" = 0
              "ipv6_cidr_block" = ""
              "protocol" = "6"
              "rule_no" = 250
              "to_port" = 80
            },
          ])
          "owner_id" = "123456789012"
          "subnet_ids" = toset([
            "subnet-0123456789abcdef0",
            "subnet-0123456789abcdef1",
          ])
          "tags" = tomap({
            "Name" = "dev_nacl_private_example"
          })
          "tags_all" = tomap({
            "Name" = "dev_nacl_private_example"
            "author" = "BrunoFerreira"
            "customer" = "UpperPlan"
            "environment" = "dev"
            "managed-by" = "terraform"
            "project" = "glpi"
          })
          "vpc_id" = "vpc-0123456789abcdef0"
        }
        "public" = {
          "arn" = "arn:aws:ec2:us-east-1:123456789012:network-acl/acl-0123456789abcdef1"
          "egress" = toset([
            {
              "action" = "allow"
              "cidr_block" = "0.0.0.0/0"
              "from_port" = 1024
              "icmp_code" = 0
              "icmp_type" = 0
              "ipv6_cidr_block" = ""
              "protocol" = "6"
              "rule_no" = 9999
              "to_port" = 65535
            },
            {
              "action" = "allow"
              "cidr_block" = "0.0.0.0/0"
              "from_port" = 443
              "icmp_code" = 0
              "icmp_type" = 0
              "ipv6_cidr_block" = ""
              "protocol" = "6"
              "rule_no" = 350
              "to_port" = 443
            },
            {
              "action" = "allow"
              "cidr_block" = "0.0.0.0/0"
              "from_port" = 587
              "icmp_code" = 0
              "icmp_type" = 0
              "ipv6_cidr_block" = ""
              "protocol" = "6"
              "rule_no" = 450
              "to_port" = 587
            },
            {
              "action" = "allow"
              "cidr_block" = "10.2.0.0/16"
              "from_port" = 80
              "icmp_code" = 0
              "icmp_type" = 0
              "ipv6_cidr_block" = ""
              "protocol" = "6"
              "rule_no" = 250
              "to_port" = 80
            },
          ])
          "id" = "acl-0123456789abcdef1"
          "ingress" = toset([
            {
              "action" = "allow"
              "cidr_block" = "0.0.0.0/0"
              "from_port" = 1024
              "icmp_code" = 0
              "icmp_type" = 0
              "ipv6_cidr_block" = ""
              "protocol" = "6"
              "rule_no" = 9999
              "to_port" = 65535
            },
            {
              "action" = "allow"
              "cidr_block" = "0.0.0.0/0"
              "from_port" = 443
              "icmp_code" = 0
              "icmp_type" = 0
              "ipv6_cidr_block" = ""
              "protocol" = "6"
              "rule_no" = 350
              "to_port" = 443
            },
            {
              "action" = "allow"
              "cidr_block" = "0.0.0.0/0"
              "from_port" = 587
              "icmp_code" = 0
              "icmp_type" = 0
              "ipv6_cidr_block" = ""
              "protocol" = "6"
              "rule_no" = 450
              "to_port" = 587
            },
            {
              "action" = "allow"
              "cidr_block" = "0.0.0.0/0"
              "from_port" = 80
              "icmp_code" = 0
              "icmp_type" = 0
              "ipv6_cidr_block" = ""
              "protocol" = "6"
              "rule_no" = 250
              "to_port" = 80
            },
          ])
          "owner_id" = "123456789012"
          "subnet_ids" = toset([
            "subnet-0123456789abcdef2",
            "subnet-0123456789abcdef3",
          ])
          "tags" = tomap({
            "Name" = "dev_nacl_public_example"
          })
          "tags_all" = tomap({
            "Name" = "dev_nacl_public_example"
            "author" = "BrunoFerreira"
            "customer" = "UpperPlan"
            "environment" = "dev"
            "managed-by" = "terraform"
            "project" = "glpi"
          })
          "vpc_id" = "vpc-0123456789abcdef0"
        }
      }
      "router_tables" = {
        "private" = {
          "arn" = "arn:aws:ec2:us-east-1:123456789012:route-table/rtb-0123456789abcdef0"
          "id" = "rtb-0123456789abcdef0"
          "owner_id" = "123456789012"
          "propagating_vgws" = toset([])
          "route" = toset([])
          "tags" = tomap({
            "Name" = "dev_rt_private_example"
          })
          "tags_all" = tomap({
            "Name" = "dev_rt_private_example"
            "author" = "BrunoFerreira"
            "customer" = "UpperPlan"
            "environment" = "dev"
            "managed-by" = "terraform"
            "project" = "glpi"
          })
          "timeouts" = null /* object */
          "vpc_id" = "vpc-0123456789abcdef0"
        }
        "public" = {
          "arn" = "arn:aws:ec2:us-east-1:123456789012:route-table/rtb-0123456789abcdef1"
          "id" = "rtb-0123456789abcdef1"
          "owner_id" = "123456789012"
          "propagating_vgws" = toset([])
          "route" = toset([
            {
              "carrier_gateway_id" = ""
              "cidr_block" = "0.0.0.0/0"
              "core_network_arn" = ""
              "destination_prefix_list_id" = ""
              "egress_only_gateway_id" = ""
              "gateway_id" = "igw-0123456789abcdef0"
              "ipv6_cidr_block" = ""
              "local_gateway_id" = ""
              "nat_gateway_id" = ""
              "network_interface_id" = ""
              "transit_gateway_id" = ""
              "vpc_endpoint_id" = ""
              "vpc_peering_connection_id" = ""
            },
          ])
          "tags" = tomap({
            "Name" = "dev_rt_public_example"
          })
          "tags_all" = tomap({
            "Name" = "dev_rt_public_example"
            "author" = "BrunoFerreira"
            "customer" = "UpperPlan"
            "environment" = "dev"
            "managed-by" = "terraform"
            "project" = "glpi"
          })
          "timeouts" = null /* object */
          "vpc_id" = "vpc-0123456789abcdef0"
        }
      }
      "subnets" = {
        "private" = {
          "az_a" = {
            "az" = "us-east-1a"
            "cidr_block" = "10.2.2.0/24"
            "id" = "subnet-0123456789abcdef0"
          }
          "az_b" = {
            "az" = "us-east-1b"
            "cidr_block" = "10.2.4.0/24"
            "id" = "subnet-0123456789abcdef1"
          }
        }
        "public" = {
          "az_a" = {
            "az" = "us-east-1a"
            "cidr_block" = "10.2.1.0/24"
            "id" = "subnet-0123456789abcdef2"
          }
          "az_b" = {
            "az" = "us-east-1b"
            "cidr_block" = "10.2.3.0/24"
            "id" = "subnet-0123456789abcdef3"
          }
        }
      }
    }
  }
}
