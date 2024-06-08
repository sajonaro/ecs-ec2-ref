## What? 

GOAL 1 <br> of this PoC is: to explore options of containerized applications to use container volumes to read/write files to/from common share (s3 ).
This can be useful when we want to scale out a service dealing with files (e.g. a CMS)

GOAL 2 <br> is to provide a working example of ECS with EC2 launch type setup, as it requires a bit more configuration than the launch type FARGATE    

Provided code:
- builds a hello world app's docker image, defines ECS task definition using  either:
    - docker-s3-volume from (https://github.com/elementar/docker-s3-volume)
    - EFS mount
    - other options
- creates fully working ECS cluster (with EC2 launch type) using  task definition from above

 

## How to build & run?

- provide .env file with valid AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY AWS_DEFAULT_REGION values

- provide terraform.tfvars file with : IMAGE_URL,S3_ACCESS_KEY_ID,S3_ACCESS_KEY_ID,S3_BUCKET_NAME (see description in vars.tf file)
    
- build application's image & push it to ECR:
    
    ```           
    ./build_push_to_ecr.sh
    ```    
- use usual terraform commands to deploy ECS stack (albeit via docker compose to avoid cluttering local environment & making sure we use fixed tf version)
   
    ```
    docker compose run --rm tf init
    docker compose run --rm tf validate 
    docker compose run --rm tf plan 
    docker compose run --rm tf apply  --auto-approve 

    ```
- to be able to ssh into EC2 instances, tf-keys key pair (both private and public)  must be regenerated, tf-key.pub should be replaced in variable public_ec2_key, e.g. via ssh-keygen :
    ```
    ssh-keygen
    ```     

## 101 on using ssh agent and ssh agent forwarding

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