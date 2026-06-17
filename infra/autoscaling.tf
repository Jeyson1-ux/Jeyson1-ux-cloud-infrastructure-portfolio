resource "aws_appautoscaling_target" "ecs" { # defines how to scale (CPU based)
  min_capacity       = 1
  max_capacity       = 4
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.main.name}" //Which service to scale
  scalable_dimension = "ecs:service:DesiredCount"                                          // what to scale
  service_namespace  = "ecs"

  depends_on = [aws_ecs_service.main] #Wait for the service to exist first

}

resource "aws_appautoscaling_policy" "auto" { # defines what to scale and limtis
  name               = "${var.project_name}-cpu-autoscale"
  policy_type        = "TargetTrackingScaling" #Will scale based on target metric
  resource_id        = aws_appautoscaling_target.ecs.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 70.0 # It will automatically scale up when cpu reach 70%, add more containers

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization" #Watch CPU metric
    }
  }


  depends_on = [aws_appautoscaling_target.ecs]
}

