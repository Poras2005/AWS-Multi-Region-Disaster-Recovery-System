variable "app_name" { type = string }
variable "region" { type = string }

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.app_name}-dashboard-${var.region}"
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", "dr-asg-${var.region == "ap-south-1" ? "mumbai" : "singapore"}"]
          ]
          period = 300
          stat   = "Average"
          region = var.region
          title  = "${var.region} CPU Utilization"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "UnHealthyHostCount", "LoadBalancer", "${var.app_name}-alb-${var.region}"]
          ]
          period = 300
          stat   = "Average"
          region = var.region
          title  = "${var.region} Unhealthy Hosts"
        }
      }
    ]
  })
}
