. _env

vpc=$(eksctl utils describe-stacks --region $REGION --cluster $EKS_CLUSTER_NAME | grep vpc- | cut -f 2 -d \")
profile=$(aws ec2 describe-instances --filters "Name=vpc-id,Values=$vpc" --region $REGION --query Reservations[0].Instances[0].IamInstanceProfile.Arn --output text | cut -f 2 -d /)
role=$(aws iam get-instance-profile --instance-profile-name $profile --region $REGION --query InstanceProfile.Roles[0].RoleName --output text)
aws iam delete-role-policy --role-name $role --policy-name px-eks-policy --region $REGION
eksctl delete cluster --region $REGION --name $EKS_CLUSTER_NAME
