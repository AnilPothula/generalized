output "hostname" {
  value = "${aws_elasticache_cluster.default.cache_nodes.0.address}"
}

output "port" {
  description="The port number of the configuration endpoint for the cache cluster."
  value = "${aws_elasticache_cluster.default.cache_nodes.0.port}"
}
output "endpoint" {
  value = "${join(":", list(aws_elasticache_cluster.default.cache_nodes.0.address, aws_elasticache_cluster.default.cache_nodes.0.port))}"
}
