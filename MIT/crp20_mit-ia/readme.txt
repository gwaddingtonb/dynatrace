CRP 2.0 Shared Cluster EKS (FCP) - MIT Incident Analyst
=======================================================


Remarks
-------

Currently there are just read-only permissions available for analysis purposes.
EC1 refers to Frankfurt (europe central 1 region).
EW3 refers to Paris (europe western 3 region).


Configuration / Setup
---------------------

1) Get AD-Groups in GIAM (https://giam.web.allianz)
- CRP-SC-D-CPI-VIEWER
- CRP-SC-P-CPI-VIEWER

2) Copy included files
- "kubectl.exe"
- "kubectl-oidc_login.exe"
to a destination which is included in the "Path" envorionment variable so that it can be executed independently of the current working directory.

3) Copy included file
- "config"
to "C:\Users\<bensl>\.kube" which is the default location for the Kubernetes config file. This equals "%USERPROFILE%\.kube" in the Windows Command Prompt or "$env:USERPROFILE" in Powershell.
Alternatively set the environment variable "KUBECONFIG" to any other desired path.

4) Set http proxy environment variables
- HTTPS_PROXY=de001-surf.zone2.proxy.allianz:8080
- HTTP_PROXY=de001-surf.zone2.proxy.allianz:8080
- NO_PROXY=*.allianz


Powershell environment variables (optional)
-------------------------------------------

[System.Environment]::SetEnvironmentVariable("HTTP_PROXY", "de001-surf.zone2.proxy.allianz:8080")
[System.Environment]::SetEnvironmentVariable("HTTPS_PROXY", $env:HTTP_PROXY)
[System.Environment]::SetEnvironmentVariable("NO_PROXY", "*.allianz")
[System.Environment]::SetEnvironmentVariable("KUBECONFIG", $env:USERPROFILE + "\Development\MIT\.kube\config-crp20-mit-ia.yml")


Windows Command Prompt environment variables (optional)
-------------------------------------------------------

set HTTPS_PROXY=de001-surf.zone2.proxy.allianz:8080
set HTTP_PROXY=de001-surf.zone2.proxy.allianz:8080
set NO_PROXY=*.allianz
set KUBECONFIG=%USERPROFILE%\.kube\config-crp20-mit-ia.yml


Example commands
----------------

Display available contexts
    kubectl config get-contexts

Switch context i.e. dev-scc-s-tra
    kubectl config use-context dev-scc-s-tra

Display all namespaces in current context
    kubectl get namespace

Display all resources in namespace i.e. c-azkompakt-dev-transitional
    kubectl get all -n c-azkompakt-dev-transitional

Display logs in namespace i.e. c-healthapp-prod-interaction-fra in deployment i.e. deployment/healthapp-api-prod-blue-deployment
    kubectl logs -n c-healthapp-prod-interaction-fra deployment/healthapp-api-prod-blue-deployment

Display all Pods
kubectl get all -n c-healthapp-prod-interaction-fra

kubectl logs -n c-healthapp-prod-interaction-fra deployment/healthapp-api-prod-blue-deployment

kubectl config use-context prod-s-int-ec1


