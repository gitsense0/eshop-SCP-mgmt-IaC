data "scp_standard_image" "ubuntu_image_k8s" {
    service_group      = "CONTAINER"
    service            = "Kubernetes Engine VM"
    region             = var.region

    filter {
        name           = "image_name"
        values         = ["Ubuntu 18.04 (Kubernetes)-v1.24.8"]
        use_regex      = false
    }
}

resource "scp_file_storage" "mgmt_nfs" {
    product_names      =  ["HDD","MultiAZ"]
    file_storage_name  = var.file_storage_name != "" ? var.file_storage_name : "eshop_mgmt_nfs"
    file_storage_protocol = "NFS"
    disk_type          = "HDD"
    service_zone_id    = var.service_zone_id
    multi_availability_zone  = true
}

resource "scp_load_balancer" "mgmt_lb" {
    vpc_id             = scp_vpc.mgmt_vpc.id
    name               = "eshop_mgmt_lb"
    size               = "SMALL"
    cidr_ipv4          = "192.168.102.0/24"
    description        = "LoadBalancer generated from Terraform"
}

resource "scp_kubernetes_engine" "mgmt_cluster" {
    name               = "eshop-mgmt-cluster"
    kubernetes_version = "v1.24.8"

    vpc_id             = scp_vpc.mgmt_vpc.id
    subnet_id          = scp_subnet.private.id
    security_group_id  = scp_security_group.mgmt_cluster_sg.id
    volume_id          = scp_file_storage.mgmt_nfs.id

    cloud_logging_enabled = false
    load_balancer_id   = scp_load_balancer.mgmt_lb.id
    // depends_on         = [scp_file_storage.mgmt_nfs]
}

resource "scp_kubernetes_node_pool" "pool" {
    name               = "eshop-mgmt-node"
    engine_id          = scp_kubernetes_engine.mgmt_cluster.id
    image_id           = data.scp_standard_image.ubuntu_image_k8s.id
    
    cpu_count          = 2
    memory_size_gb     = 4

    auto_recovery      = true
    auto_scale         = false
    desired_node_count = 2
    min_node_count     = 2
    max_node_count     = 2

    availability_zone_name = "AZ1"  // for HA in MAZ KR-WEST
}