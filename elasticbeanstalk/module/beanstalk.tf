resource "aws_elastic_beanstalk_application" "beanstalk-app" {
  name        = var.app_name
  description = "beanstalk application"
}

resource "aws_elastic_beanstalk_environment" "beanstalk-env" {
  name                = "${var.app_name}-env"
  application         = aws_elastic_beanstalk_application.beanstalk-app.name
  tier                = "WebServer"
  solution_stack_name = "64bit Amazon Linux 2023 v6.1.1 running Node.js 20"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.ec2_iam_instance_profile.name
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.service_role.id
    resource  = ""
  }

  setting {
    namespace = "aws:ec2:instances"
    name      = "InstanceTypes"
    value     = var.instance_type
  }

  dynamic "setting" {
    for_each = var.env_vars
    content {
      namespace = "aws:elasticbeanstalk:application:environment"
      name      = setting.key
      value     = setting.value
      resource  = ""
    }
  }
}
