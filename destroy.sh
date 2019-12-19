. _env

vpc=$(eksctl utils describe-stacks --region $REGION --cluster $EKS_CLUSTER_NAME | grep vpc- | cut -f 2 -d \")
profile=$(aws ec2 describe-instances --filters "Name=vpc-id,Values=$vpc" --region $REGION | jq -r .Reservations[0].Instances[0].IamInstanceProfile.Arn | cut -f 2 -d /)
role=$(aws iam get-instance-profile --instance-profile-name $profile | jq -r .InstanceProfile.Roles[0].RoleName)
aws iam delete-role-policy --role-name $role --policy-name px-eks-policy
eksctl delete cluster --region $REGION --name $EKS_CLUSTER_NAME
