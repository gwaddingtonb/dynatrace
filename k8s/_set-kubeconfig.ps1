################################################################################
# (c) Allianz Technology 2022. All rights reserved.
#
# @Name:       @set-kubeconfig.ps1
# @Purpose:    @This script is used to set your kubeconfig in order to be able to connect to your Future Cloud Platform IaC Platform Kubernetes Cluster.
# @Version:    @0.1.0
# @Date:       @2022-06-24
# @Author:     @Barunavo Pal <barunavo.pal@allianz.de> - Infrastructure as Code Platform Team
# ....
################################################################################

   
if (([string]::IsNullOrEmpty($env:AAD_APP_ID)) -or ([string]::IsNullOrEmpty($env:AAD_TENANT_ID)) -or ([string]::IsNullOrEmpty($env:CLUSTER_NAME)) -or ([string]::IsNullOrEmpty($env:CERTIFICATE_AUTHORITY_DATA)))
{
    Write-Output "Please set the environment variables AAD_APP_ID, AAD_TENANT_ID, CLUSTER_NAME and CERTIFICATE_AUTHORITY_DATA"
    exit 1
}
else 
{
    Write-Output "All required variables are set"
}


echo " Checking if KUBECTL is installed "

try {
    kubectl version --client --output=yaml
    echo "**** KUBECTL is already installed ****"
} catch {
    echo "kubectl could not be found, please install kubectl -> https://docs.platform.cloud.allianz/end-user/onboarding/configure_kube/"
    exit 1
}


echo " Checking if KUBELOGIN is installed "

try {
    kubelogin --version 
    echo "**** KUBELOGIN is already installed ****"
} catch {
    echo "kubelogin could not be found, please install kubelogin -> https://docs.platform.cloud.allianz/end-user/onboarding/configure_kube/"
    exit 1
}


echo "Setting up cluster"
kubectl config set-cluster $env:CLUSTER_NAME --server=https://$env:CLUSTER_NAME

echo "Configuring certificate authority for cluster"
kubectl config set clusters.$env:CLUSTER_NAME.certificate-authority-data $env:CERTIFICATE_AUTHORITY_DATA

echo "Configuring user credentials for cluster"
kubectl config set-credentials "allianz-user" --exec-api-version=client.authentication.k8s.io/v1beta1 --exec-command=kubelogin --exec-arg=get-token --exec-arg=--environment --exec-arg=AzurePublicCloud --exec-arg=--server-id --exec-arg="$env:AAD_APP_ID" --exec-arg=--client-id --exec-arg="$env:AAD_APP_ID" --exec-arg=--tenant-id --exec-arg="$env:AAD_TENANT_ID"

echo "Connecting user credentials to cluster"

kubectl config set-context "$env:CLUSTER_NAME" --cluster="$env:CLUSTER_NAME" --user=allianz-user

echo " Setting created context as current context "

kubectl config use-context "$env:CLUSTER_NAME"

