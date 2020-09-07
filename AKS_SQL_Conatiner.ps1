<#
******************************************************************************
******************************************************************************
********************Deploy AKS Cluster****************************************
******************************************************************************
******************************************************************************
#>
$myResourceGroup="k8rg"
$namespace= "k8-org"
$myAKSCluster="demo-k8cluster"
az login

New-AzAks -ResourceGroupName $myResourceGroup -Name myAKSCluster -NodeCount 1
#*********************************************
#******Download credentials in local config***
#*********************************************
az aks get-credentials --resource-group  k8rg --name $myAKSCluster

#*******************************************
#******Generate secrets for SQL container***
#*******************************************
kubectl create secret generic mssql --from-literal=SA_PASSWORD="Redhat0!" -n $namespace
kubectl get secrets -n $namespace
#kubectl delete secret access-tokensecret "mssql"

#*******************************************
#******Mount Persistant volume claim***
#*******************************************
kubectl apply -f yaml/staff-sql-vol.yaml
kubectl describe pvc mssql-data -n $namespace
#kubectl delete pvc mssql-data

#*******************************************
#******Deploy SQL Container***
#*******************************************
kubectl apply -f yaml/staff-sql.yaml