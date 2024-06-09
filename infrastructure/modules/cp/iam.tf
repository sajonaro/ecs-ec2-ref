# --- ECS Node Role ---

resource "aws_iam_role" "ecs_node_role" {
  name_prefix        = "${var.app_name}-ecs-node-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_node_doc.json
}

resource "aws_iam_role_policy_attachment" "ecs_node_role_policy" {
  role       = aws_iam_role.ecs_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_node" {
  name_prefix = "${var.app_name}-ecs-node-profile"
  path        = "/ecs/instance/"
  role        = aws_iam_role.ecs_node_role.name
}


#apply resource policy to bucket ( to allow acces from container instances)
resource "aws_s3_bucket_policy" "access_to_mounted_bucket_policy" {
  bucket = "${var.S3_BUCKET_NAME}"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.ecs_node_role.name}"
        },
        "Action": [
          "s3:*"
        ],
        "Resource": [
          "arn:aws:s3:::${var.S3_BUCKET_NAME}",
          "arn:aws:s3:::${var.S3_BUCKET_NAME}/*"
        ]
      }
    ]
  })
}

#attach policy to role
resource "aws_iam_role_policy_attachment" "ecs_node_role_s3_access_policy_attachment" {
  role       = aws_iam_role.ecs_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}


