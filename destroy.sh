. _env

vpc=$(eksctl utils describe-stacks --region $REGION --cluster $EKS_CLUSTER_NAME | grep vpc- | cut -f 2 -d \")
profile=$(aws ec2 describe-instances --filters "Name=vpc-id,Values=$vpc" --region $REGION --query Reservations[0].Instances[0].IamInstanceProfile.Arn --output text | cut -f 2 -d /)
instances=$(aws ec2 describe-instances --filters "Name=vpc-id,Values=$vpc" --region $REGION --query Reservations[].Instances[].InstanceId --output text)
volumes=$(for i in $instances; do aws ec2 describe-volumes --region $REGION --filters "Name=attachment.instance-id,Values=$i" "Name=tag:PWX_CLUSTER_ID,Values=$PX_CLUSTER_NAME" --query Volumes[].Attachments[].VolumeId --output text; done)
role=$(aws iam get-instance-profile --instance-profile-name $profile --region $REGION --query InstanceProfile.Roles[0].RoleName --output text)
aws iam delete-role-policy --role-name $role --policy-name px-eks-policy --region $REGION
eksctl delete cluster --region $REGION --name $EKS_CLUSTER_NAME --wait
for j in $volumes; do
  aws ec2 delete-volume --region $REGION --volume-id $j
done
