. _env

aws iam delete-role-policy --role-name $role --policy-name px-eks-policy
eksctl delete cluster --region $REGION --name $EKS_CLUSTER_NAME
