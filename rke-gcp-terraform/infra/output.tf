output "rancher_node_ip" {
  value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}

output "workload_node_ip" {
  value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}