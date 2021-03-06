# Kubernetes Cluster on Azure with Terraform

This repository contains the configuration required to create a Kubernetes Cluster on Microsoft Azure using HashiCorp Terraform and to deploy a simple application in it (Wordpress).

The tutorial is based on Microsoft and Hashicorp official documentation.

see:

* [Create a Kubernetes cluster with Azure Kubernetes Service using Terraform](https://docs.microsoft.com/en-us/azure/developer/terraform/create-k8s-cluster-with-tf-and-aks)
* [Provisioning Kubernetes clusters on AKS using HashiCorp Terraform](https://azure.microsoft.com/pt-br/resources/videos/azure-friday-provisioning-kubernetes-clusters-on-aks-using-hashicorp-terraform/)
* [Provision an AKS Cluster (Azure)](https://learn.hashicorp.com/tutorials/terraform/aks)

## Prerequisites

* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) installed.
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed.
* HashiCorp [Terraform](https://terraform.io/downloads.html) installed.
* [Azure](https://azure.microsoft.com/) subscription.


## Tutorial

### 1. Environment configuration ([https://docs.microsoft.com/en-us/azure/developer/terraform/create-k8s-cluster-with-tf-and-aks#1-configure-your-environment](https://docs.microsoft.com/en-us/azure/developer/terraform/create-k8s-cluster-with-tf-and-aks#1-configure-your-environment)).

* Subscribe to Azure.
* Configure Terraform. 
* Create an Active Directory service principal account. 

After this steps, export these environment variables:

```bash
export ARM_SUBSCRIPTION_ID="<azure_subscription_id>"
export ARM_TENANT_ID="<azure_subscription_tenant_id>"
export ARM_CLIENT_ID="<service_principal_appid>"
export ARM_CLIENT_SECRET="<service_principal_password>"
```

and these ones:

```bash
export TF_VAR_client_id=<service-principal-appid>
export TF_VAR_client_secret=<service-principal-password>
```


### 2. Create an SSH key pair ([https://docs.microsoft.com/en-us/azure/developer/terraform/create-k8s-cluster-with-tf-and-aks#2-create-an-ssh-key-pair](https://docs.microsoft.com/en-us/azure/developer/terraform/create-k8s-cluster-with-tf-and-aks#2-create-an-ssh-key-pair))

### 3. Clone the repository

```bash
git clone https://github.com/simple-primo/k8s-az-terraform.git
```

cd to k8s-az-terraform. 

```bash
cd k8s-az-terraform
```
This directory contains the cluster definition (k8s.tf), the variables definition (variables.tf) and the output definition (output.tf).

### 4. Set up Azure storage to store Terraform state ([https://docs.microsoft.com/en-us/azure/developer/terraform/create-k8s-cluster-with-tf-and-aks#8-set-up-azure-storage-to-store-terraform-state](https://docs.microsoft.com/en-us/azure/developer/terraform/create-k8s-cluster-with-tf-and-aks#8-set-up-azure-storage-to-store-terraform-state))

After create the container, export this environment variable:

```bash
export ARM_ACCESS_KEY=<YourStorageAccountAccessKey>
```
And replace the tag  <YourAzureStorageAccountName> with the corresponding value in k8s.tf

```bash
storage_account_name     = "<YourAzureStorageAccountName>"
```

### 5. Initilize terraform

```bash
terraform init
```

### 6. Create an execution plan

```bash
terraform plan -out out.plan
```

### 7. Execute the actions proposed in the plan

```bash
terraform apply "out.plan"
```

### 8. Test the Kubernetes cluster 

Save kubernetes config file to `~/.kube/aksconfig`

```bash
terraform output kube_config > ~/.kube/aksconfig
```

Modify ~/.kube/aksconfig to get a valid YAML file

```bash
sed -i '1d;$d' ~/.kube/aksconfig
```

Set `KUBECONFIG` environment variable to the kubernetes config file

```bash
export KUBECONFIG=~/.kube/aksconfig
```

Test configuration

```bash
kubectl get nodes
```