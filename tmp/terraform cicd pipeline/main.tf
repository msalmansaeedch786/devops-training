# Input variables
variable "aws_region" {
  type    = "string"
  default = "us-east-1"
}

variable "pipeline_name" {
  type    = "string"
  default = "terraform-cicd"
}

variable "github_username" {
  type    = "string"
  default = "msalmansaeedch786"
}

variable "github_token" {
  type = "string"
  default = "560d6027feb2f5479300c90dcdad929c80b7fb5f"
}

variable "github_repo" {
  type = "string"
  default = "NodeToDo"
}

provider "aws" {
  region     = "${var.aws_region}"
}

# CodePipeline resources
resource "aws_s3_bucket" "build_artifact_bucket" {
  bucket = "${var.pipeline_name}-artifact-bucket"
  acl    = "private"
}

data "aws_iam_policy_document" "codepipeline_assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codepipeline_role" {
  name               = "${var.pipeline_name}-codepipeline-role"
  assume_role_policy = "${data.aws_iam_policy_document.codepipeline_assume_policy.json}"
}

# CodePipeline policy needed to use CodeCommit and CodeBuild
resource "aws_iam_role_policy" "attach_codepipeline_policy" {
  name = "${var.pipeline_name}-codepipeline-policy"
  role = "${aws_iam_role.codepipeline_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:GetBucketVersioning",
                "s3:PutObject"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "cloudwatch:*",
                "sns:*",
                "sqs:*",
                "codedeploy:*",
                "iam:PassRole"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "codebuild:BatchGetBuilds",
                "codebuild:StartBuild"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
EOF
}

# CodeBuild IAM Permissions
resource "aws_iam_role" "codebuild_assume_role" {
  name = "${var.pipeline_name}-codebuild-role"
  description = "Role for codebuild."
  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
    {
    "Sid": "",
    "Effect": "Allow",
    "Principal": {
        "Service": "codebuild.amazonaws.com"
    },
    "Action": "sts:AssumeRole"
    }
]
}
EOF
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name = "${var.pipeline_name}-codebuild-policy"
  role = "${aws_iam_role.codebuild_assume_role.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
       "s3:PutObject",
       "s3:GetObject"
      ],
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_role" "codedeploy_assume_role" {
  name = "${var.pipeline_name}-codedeploy-role"
  description = "Role for codedeploy."

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = "${aws_iam_role.codedeploy_assume_role.name}"
}


# CodeBuild Section for the Package stage
resource "aws_codebuild_project" "build_project" {
  name          = "${var.pipeline_name}-build"
  description   = "The CodeBuild project for ${var.pipeline_name}"
  service_role  = "${aws_iam_role.codebuild_assume_role.arn}"
  build_timeout = "10"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:1.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "GITHUB"
    location = "https://github.com/msalmansaeedch786/NodeToDo.git"
  }
}

resource "aws_codedeploy_app" "deploy_app" {
  compute_platform = "Server"
  name             = "${var.pipeline_name}-deploy"
}

resource "aws_codedeploy_deployment_group" "deploy_group" {
  app_name              = "${aws_codedeploy_app.deploy_app.name}"
  deployment_group_name = "${var.pipeline_name}-deploy"
  service_role_arn      = "${aws_iam_role.codedeploy_assume_role.arn}"
  deployment_config_name = "CodeDeployDefault.AllAtOnce"
  
  deployment_style {
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }
  
  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = "terraform-cicd-nodejs-server"
    }
  }
}

# Full CodePipeline
resource "aws_codepipeline" "codepipeline" {
  name     = "${var.pipeline_name}-codepipeline"
  role_arn = "${aws_iam_role.codepipeline_role.arn}"

  artifact_store {
    location = "${aws_s3_bucket.build_artifact_bucket.bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner                = "${var.github_username}"
        OAuthToken           = "${var.github_token}"
        Repo                 = "${var.github_repo}"
        Branch               = "master"
        PollForSourceChanges = "true"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "${aws_codebuild_project.build_project.name}"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ApplicationName     = "${aws_codedeploy_app.deploy_app.name}"
        DeploymentGroupName   = "${aws_codedeploy_deployment_group.deploy_group.deployment_group_name}"
    }
  }
}
}