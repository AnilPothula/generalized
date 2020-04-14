output "elasticsearch_domain" {
  value = aws_elasticsearch_domain.es_domain.domain_name
}

output "domain_arn" {
  value = aws_elasticsearch_domain.es_domain.arn
}

output "domain_endpoint" {
  value = aws_elasticsearch_domain.es_domain.endpoint
}
