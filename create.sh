. _env

eksctl create cluster --region $REGION --nodes $NODES --node-type $TYPE --name $EKS_CLUSTER_NAME --ssh-access
k8s_version=$(kubectl version --short | awk -F[v-] '/Server Version: / {print $3}')
vpc=$(eksctl utils describe-stacks --region $REGION --cluster $EKS_CLUSTER_NAME | grep vpc- | cut -f 2 -d \")
profile=$(aws ec2 describe-instances --filters "Name=vpc-id,Values=$vpc" --region $REGION --query Reservations[0].Instances[0].IamInstanceProfile.Arn --output text | cut -f 2 -d /)
role=$(aws iam get-instance-profile --instance-profile-name $profile --region $REGION --query InstanceProfile.Roles[0].RoleName --output text)
aws iam put-role-policy --role-name $role --policy-name px-eks-policy --policy-document file://role.json --region $REGION
kubectl apply -f "https://install.portworx.com/$PX_VERSION?mc=false&kbver=$k8s_version&b=true&s=%22type=gp2%2Csize=$DISK_SIZE%22&c=$PX_CLUSTER_NAME&eks=true&stork=true&lh=true&st=k8s"
