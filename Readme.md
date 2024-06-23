## What? 

GOAL 1 <br> of this PoC is: to explore options of containerized applications to use container volumes to read/write files to/from common share (s3 ).
This can be useful when we want to scale out a service dealing with files (e.g. a CMS)

GOAL 2 <br> is to provide a working example of ECS with EC2 launch type setup, as it requires a bit more configuration than the launch type FARGATE, so to have a working and complete example comes handy     

Provided code:
- builds a hello world app's docker image and uploads to ECR
- defines ECS cluster with launch type EC2:
   - task definition using application image from step above
   - capacity provider configuring container instances (aka EC2s ) parameters
   - docker volume with driver = local (for local file system) bound to container's local directory 
 
## TL/DR;

We make our application "think" it accesses just a local directory, whereas it is actually bound to an s3 bucket behind the scenes 

Implementation details:
- given existing bucket (created outside current terraform stack) we provide access to it as follows: create IAM role, assign it to EC2 instances in the cluster,give this role permissions to access s3, and provide resource policy for s3 to allow access by the IAM role. 
- We use mount-s3 utility (https://aws.amazon.com/about-aws/whats-new/2023/03/mountpoint-amazon-s3/) to mount EC2's local folder to external s3 bucket using user_data.sh initializing script, mount-s3 utility uses policies attached to EC2s IAM role to access specified bucket 
- In task definition we use volume configuration to bind host's folder (with we mounted in step above) to container's local folder.




## How to build & run?

- provide .env file with valid AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY AWS_DEFAULT_REGION values ( for docker compose to pick it up)
- build application's image & push it to ECR:
    
    ```           
    ./build_push_to_ecr.sh
    ```  
- provide terraform.tfvars file with : IMAGE_URL (update this value based on step above), S3_BUCKET_NAME (see description in vars.tf file)

- generate ssh key pair (tf-key), these keys are used to ssh into EC2s via bastion host: tf-key.pub should be replaced in variable public_ec2_key, e.g. use ssh-keygen :
    ```
    ssh-keygen
    ```  
      
- use usual terraform commands to deploy ECS stack (albeit via docker compose to avoid cluttering local environment & making sure we use fixed tf version)
   
    ```
    docker compose run --rm tf init
    docker compose run --rm tf validate 
    docker compose run --rm tf plan 
    docker compose run --rm tf apply  --auto-approve 

    ```
- Finally, access deployed application via browser using ALBs DNS name (use output value from terraform [application_url], or login into AWS console) e.g.:
```
https://hello-world-app-alb-1233026957.eu-central-1.elb.amazonaws.com
``` 
- Alternatively (access via dns name) e.g.:
```
https://dev-ops.pro   
```

   

## 101 on using ssh agent 

- make sure to start ssh agent (on your local host)
```
eval $(ssh-agent -s) > /dev/null
```  
- register your private key in ssh agent:
```
ssh-add path_to/your_private_key
``` 
- you can now enjoy using ssh forwarding:

    ```
    ssh -A ec2@bastion_host_ip
    ```
    then, from bastion host (N.B. no need to provide -i/upload private key):
    ```
    ssh ec2-user@ec2_private_ip
    ```
 