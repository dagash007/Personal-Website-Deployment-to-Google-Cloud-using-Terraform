# Bucket to store website

resource "google_storage_bucket" "website" {
    name = "example-website-by-balogun"
    location = "US"
}

# Make new object public
resource "google_storage_object_access_control" "public_rule" {
    object = google_storage_bucket_object.static_site_src.name
    bucket = google_storage_bucket.website.name
    role = "READER"
    entity = "allUsers"
}

# upload the html file to the bucket
resource "google_storage_bucket_object" "static_site_src" {
    name = "index.html"
    source = "../website/index.html"
    bucket = google_storage_bucket.website.name
}

# Reserve a static external IP address
resource "google_compute_global_address" "website_ip" {
    name = "website-lb-ip"
}

#Get the managed DNS zone
data "google_dns_managed_zone" "dns_zone" {
    name = "terraform-gcp"
}

# Add the IP to the DNS
resource "google_dns_record_set" "website"{
    name = "website.${data.google_dns_managed_zone.dns_zone.dns_name}"
    type = "A"
    ttl = 300
    managed_zone = data.google_dns_managed_zone.dns_zone.name
    rrdatas = [google_compute_global_address.website_ip.address]
}

# Add the bucket as a CDN backend
resource "google_compute_backend_bucket" "website-backend" {
    name = "website-bucket"
    bucket_name = google_storage_bucket.website.name
    description = "contains files needed for the website"
    enable_cdn = true
}

# GCP url map
resource "google_compute_url_map" "website" {
    name = "website-url-map"
    default_service = google_compute_backend_bucket.website-backend.self_link
    host_rule{
        hosts = ["*"]
        path_matcher = "allpaths"
    }
    path_matcher {
        name = "allpaths"
        default_service = google_compute_backend_bucket.website-backend.self_link
    }
}

# GCP HTTP proxy
resource "google_compute_target_http_proxy" "website" {
    name = "website-target-proxy"
    url_map = google_compute_url_map.website.self_link
}

# GCP forwarding rule 
resource "google_compute_global_forwarding_rule" "default" {
    name = "website-forwarding-rule"
    load_balancing_scheme = "EXTERNAL"
    ip_address = google_compute_global_address.website_ip.address
    ip_protocol = "TCP"
    port_range = "80"
    target = google_compute_target_http_proxy.website.self_link
}

# Upload profile picture to the bucket
resource "google_storage_bucket_object" "profile_pic" {
  name   = "profile.jpg"
  source = "../website/profile.jpg" # Adjust path if different
  bucket = google_storage_bucket.website.name
}

# Make the profile picture public
resource "google_storage_object_access_control" "profile_pic_public" {
  object = google_storage_bucket_object.profile_pic.name
  bucket = google_storage_bucket.website.name
  role   = "READER"
  entity = "allUsers"
}

resource "google_storage_bucket_iam_member" "public_access" {
  bucket = google_storage_bucket.website.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}
