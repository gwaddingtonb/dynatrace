<!--- begin dynatrace golbal monitoring config readme -->
kubectl get configmap dynatrace-settings -n customer -o=jsonpath='{.binaryData.dynatrace_settings\.zip}' | base64 --decode > dynatrace_settings.zip
<!--- end dynatrace golbal monitoring config readme -->