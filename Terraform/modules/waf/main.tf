resource "aws_wafv2_web_acl" "web_acl" {
  name        = var.waf_name
  scope       = "REGIONAL"
  description = "WAF for ALB with Bot Control, SQL Injection, and DDoS rules"
  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "kcWebAcl"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "BotControlRule"
    priority = 0

    action {
      block {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesBotControlRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "BotControlRule"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "SQLInjectionRule"
    priority = 1

    action {
      block {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "SQLInjectionRule"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "DDoSProtectionRule"
    priority = 2

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit = 2000
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "DDoSProtectionRule"
      sampled_requests_enabled   = true
    }
  }
}


resource "aws_wafv2_web_acl_association" "alb_association" {
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.web_acl.arn
}
