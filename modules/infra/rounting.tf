resource "aws_cloudfront_cache_policy" "demo-cloudfront_cache_policy" {
  name        = "demo_cloudfront_cache_policy"
  min_ttl     = 10
  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "whitelist"
      cookies {
        items = ["example"]
      }
    }
    headers_config {
      header_behavior = "whitelist"
      headers {
        items = ["example"]
      }
    }
    query_strings_config {
      query_string_behavior = "whitelist"
      query_strings {
        items = ["example"]
      }
    }
  }
}

# resource "aws_cloudfront_distribution" "demo_cloudfront" {
#   origin {
#     domain_name              = aws_lb.demo-alb.dns_name
#     # origin_access_control_id = aws_cloudfront_origin_access_control.default.id
#     origin_id                = aws_lb.demo-alb.name
#     custom_origin_config {
#         http_port= "80"
#         https_port="443"
#         origin_protocol_policy = "match-viewer"
#         origin_ssl_protocols = ["TLSv1.2"]
#     }

#   }

#   enabled             = true
# #   default_root_object = "index.html"

#   aliases = ["numerix-md.com"]

#   default_cache_behavior {
#     allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
#     cached_methods   = ["GET", "HEAD"]
#     target_origin_id = aws_lb.demo-alb.name
#     cache_policy_id = aws_cloudfront_cache_policy.demo-cloudfront_cache_policy.id
#     viewer_protocol_policy = "allow-all"
#     min_ttl                = 0
#     default_ttl            = 3600
#     max_ttl                = 86400
#   }

#   price_class = "PriceClass_100"

#   tags = {
#     Environment = "demo-distribution"
#   }

#   restrictions {
#     geo_restriction{
#         locations = []
#         restriction_type = "none"
#     }
#   }

#   viewer_certificate {
#     cloudfront_default_certificate = true
#     acm_certificate_arn = aws_acm_certificate.demo-tls-cert.id 
#   }
# }

resource "aws_acm_certificate" "demo-tls-cert" {
  domain_name       = "numerix-md.com"
  validation_method = "DNS"

  tags = {
    Environment = "demo-test"
  }

  lifecycle {
    create_before_destroy = true
  }
}