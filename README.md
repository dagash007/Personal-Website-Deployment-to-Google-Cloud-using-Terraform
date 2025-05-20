# Personal Website Deployment to Google Cloud using Terraform

## Overview

This guide explains how **I deployed my personal static website** to Google Cloud Platform (GCP) using Terraform and served it through a global HTTP(S) Load Balancer connected to a custom domain: [http://website.balogunsresume.com/index.html](http://website.balogunsresume.com/index.html).

My project folder is named `PERSONAL_WEBSITE` and includes the following structure:

```
PERSONAL_WEBSITE/
├── Screenshots/
├── Service Acct Access Key/
├── terraform-with-gcp/
│   └── infra/
│       ├── main.tf
│       ├── provider.tf
│       ├── terraform.tfvars
│       └── variables.tf
└── website/
    ├── index.html
    └── profile.jpg
```

---

## Table of Contents

1. Prerequisites
2. Deployment Steps

   * Enable Required APIs
   * Set Up Service Account
   * Install and Initialize Terraform
   * Write and Apply Terraform Code
   * Upload Website Files
   * Set Up Custom Domain with Namecheap
   * Create and Configure Load Balancer
   * Connect Load Balancer to Domain
3. Final Checks
4. GitHub Repository Checklist
5. Security Note

---

## 1. Prerequisites

* Active GCP account with billing enabled
* A registered domain on Namecheap
* Terraform installed
* GitHub repository for version control and documentation

---

## 2. Deployment Steps

### Step 1: Enable Required APIs

In GCP Console, I enabled the following APIs:

* Cloud DNS API
* Compute Engine API
* IAM API

### Step 2: Set Up Service Account

* Created a service account named `terraform-deployer` under IAM & Admin > Service Accounts.
* Granted roles: `Editor`, `Storage Admin`, `DNS Administrator`, and `Compute Admin`.
* Downloaded the JSON key and stored it securely in the `Service Acct Access Key` folder.

### Step 3: Install and Initialize Terraform

* Installed Terraform CLI
* Verified with `terraform -version`
* Navigated to `terraform-with-gcp/infra` and ran:

  ```bash
  terraform init
  ```

### Step 4: Terraform Plan

* Reviewed the execution plan:

  ```bash
  terraform plan
  ```

### Step 5: Terraform Apply

* Applied the configuration to deploy resources:

  ```bash
  terraform apply
  ```
* Confirmed the prompt with `yes`

### Step 6: Upload Website Files

* After bucket creation, I uploaded my `index.html` and `profile.jpg` from the `website/` folder using:

  ```bash
  gsutil cp -r ./website/* gs://<your-bucket-name>
  ```

### Step 7: Domain Setup via Namecheap

* Bought and verified my domain: `balogunsresume.com`
* Got the 4 nameservers from Cloud DNS zone and set them under **Custom DNS** in Namecheap:

  * Login to Namecheap > Domain List > Manage > Nameservers > Custom DNS

### Step 8: Create Load Balancer

* Created an HTTP(S) Load Balancer in GCP with:

  * Backend: the Cloud Storage bucket
  * Frontend: Global IP and Google-managed SSL certificate

### Step 9: Connect Load Balancer to Domain

* Created A/AAAA records for `website.balogunsresume.com` pointing to the Load Balancer’s external IP
* After propagation, accessed the live site at: [http://website.balogunsresume.com/index.html](http://website.balogunsresume.com/index.html)

---

## 3. Final Checks

* Site loads successfully via custom domain
* Domain resolves using Load Balancer IP
* Screenshots taken for each step

---

## 4. GitHub Repository Checklist

In my GitHub repository:

* `terraform-with-gcp/infra/`: contains all `.tf` files
* `website/`: contains the site’s HTML and assets
* `Screenshots/`: step-by-step proof of actions
* `README.md`: includes this documented guide

> ⚠️ **Service Account key file is NOT uploaded to GitHub**

---

## 5. Security Note

* Bucket access is public only for reading via website
* `allUsers` permission restricted only to necessary objects
* Consider disabling public access if the site is decommissioned
* Monitor IAM roles and Cloud Audit Logs regularly

---

## ✅ Assignment Completed

I have successfully deployed my personal static website to GCP using Terraform, served it using a Load Balancer, and configured a working custom domain.

Live Website: [http://website.balogunsresume.com/index.html](http://website.balogunsresume.com/index.html)
