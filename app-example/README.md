# Pod and a Service (Wordpress) Example

This repository contains the configuration required to deploy a containerized application (WordPress) on a Kubernetes Cluster on Microsoft Azure using HashiCorp Terraform.

The tutorial is based on Microsoft and Hashicorp official documentation.

see:

* [Create a Kubernetes cluster with Azure Kubernetes Service using Terraform](https://docs.microsoft.com/en-us/azure/developer/terraform/create-k8s-cluster-with-tf-and-aks)
* [Provisioning Kubernetes clusters on AKS using HashiCorp Terraform](https://azure.microsoft.com/pt-br/resources/videos/azure-friday-provisioning-kubernetes-clusters-on-aks-using-hashicorp-terraform/)
* [Provision an AKS Cluster (Azure)](https://learn.hashicorp.com/tutorials/terraform/aks)

## Prerequisites

Complete the steps detailed in [https://github.com/simple-primo/k8s-az-terraform/blob/main/README.md](https://github.com/simple-primo/k8s-az-terraform/blob/main/README.md)


## Tutorial

### 1. Set up Azure storage to store Terraform state ([https://docs.microsoft.com/en-us/azure/developer/terraform/create-k8s-cluster-with-tf-and-aks#8-set-up-azure-storage-to-store-terraform-state](https://docs.microsoft.com/en-us/azure/developer/terraform/create-k8s-cluster-with-tf-and-aks#8-set-up-azure-storage-to-store-terraform-state))

Use this command, to store the state in a separate container:

```bash
az storage container create -n tfstate-app --account-name <YourAzureStorageAccountName> --account-key <YourAzureStorageAccountKey>
```

And replace the tag  <YourAzureStorageAccountName> with the corresponding value in main.tf

```bash
storage_account_name     = "<YourAzureStorageAccountName>"
```

### 2. Initilize terraform

```bash
terraform init
```

### 3. Create an execution plan

```bash
terraform plan -out out.plan
```

### 4. Execute the actions proposed in the plan

```bash
terraform apply "out.plan"
```

### 5. Check whether pod, service, and namespace is created successfully

kubectl get pods,services,namespace

### 6. Access to WordPress 

Execute:

```bash
kubectl get all -n wordpress
```
Copy the EXTERNAL-IP value and paste it on a browser.