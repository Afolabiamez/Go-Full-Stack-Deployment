resource "aws_cloudfront_origin_access_control" "frontend" {

  name = "frontend-oac"

  origin_access_control_origin_type = "s3"

  signing_behavior = "always"

  signing_protocol = "sigv4"

}

resource "aws_cloudfront_distribution" "frontend" {
  origin {

    domain_name = var.bucket_domain_name

    origin_id = "S3-Frontend"

    origin_access_control_id = aws_cloudfront_origin_access_control.frontend.id

  }
  origin {

    domain_name = var.alb_dns_name

    origin_id = "ALB-Backend"

    custom_origin_config {

      http_port = 80

      https_port = 443

      origin_protocol_policy = "http-only"

      origin_ssl_protocols = ["TLSv1.2"]

    }

  }
  default_cache_behavior {

    target_origin_id = "S3-Frontend"

    viewer_protocol_policy = "redirect-to-https"

    compress = true

    allowed_methods = [
      "GET",
      "HEAD"
    ]

    cached_methods = [
      "GET",
      "HEAD"
    ]

    forwarded_values {

      query_string = false

      cookies {

        forward = "none"

      }

    }

  }

  ordered_cache_behavior {

    path_pattern = "/api/*"

    target_origin_id = "ALB-Backend"

    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = [

      "GET",

      "HEAD",

      "POST",

      "PUT",

      "PATCH",

      "DELETE",

      "OPTIONS"

    ]

    cached_methods = [

      "GET",

      "HEAD"

    ]

    min_ttl = 0

    default_ttl = 0

    max_ttl = 0

    forwarded_values {

      query_string = true

      headers = ["*"]

      cookies {

        forward = "all"

      }

    }

  }
  custom_error_response {

    error_code = 404

    response_code = 200

    response_page_path = "/index.html"

  }
  custom_error_response {

    error_code = 403

    response_code = 200

    response_page_path = "/index.html"

  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  enabled         = true
  is_ipv6_enabled = true

  default_root_object = "index.html"
}