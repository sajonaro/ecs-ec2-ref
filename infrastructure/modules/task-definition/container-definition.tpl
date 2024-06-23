[{
    "name" :  "${name}",
    "image" : "${ecr_repo_url}",
    "essential" : true,
    "memory" : 256,
    "cpu" : 1,
    "healthcheck": {
        "command": ["CMD-SHELL", "curl --silent --fail http://127.0.0.1:8080 || exit 1"]
    },
    "privileged" :  true,
    "portMappings" : [
        {
            "containerPort" : 8080, 
            "hostPort" : 8080
     }],
     "mountPoints": [
        {
            "sourceVolume": "${volume_name}",
            "containerPath": "${container_path}",
            "readOnly": false
        }],
      "logConfiguration" : {
            "logDriver" : "awslogs",
            "options" : {
              "awslogs-group"         : "${log_group_name}",
              "awslogs-stream-prefix" : "ecs",
              "awslogs-region"        : "${region}" 
            }
          }   
  }]

