# What

This will provision an EKS cluster, along with Portworx.

# Prerequisites

 * AWS CLI (https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html), already configured
 * eksctl (https://eksctl.io/introduction/installation/)
 * jq:
```
# brew install jq
# yum install jq
# apt install jq
```

# How

1. Edit the environment variables in `_env`.
2. Execute `create.sh`:
```
$ sh create.sh
```
3. To destroy the cluster, execute `destroy.sh`:
```
$ sh destroy.sh
```
