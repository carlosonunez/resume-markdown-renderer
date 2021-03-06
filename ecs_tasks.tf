data "template_file" "container_definition" {
  template = "${file("ecs_container_definition.json.tmpl")}"
  vars {
    docker_hub_username = "${var.docker_hub_username}"
    s3_bucket_name  = "${var.s3_bucket_name}"
    app_version     = "${var.app_version}"
    resume_name     = "${var.resume_name}"
    container_name  = "${var.ecs_container_name}"
    container_port  = "${var.container_port}"
    logs_region     = "${data.aws_region.current.name}"
    logs_name       = "${var.logs_name}"
    aws_access_key_id = "${var.aws_access_key_id}"
    aws_secret_access_key = "${var.aws_secret_access_key}"
    aws_region = "${var.aws_region}"
    environment = "${var.environment}"
  }
}

resource "aws_ecs_task_definition" "task" {
  depends_on = ["aws_iam_role_policy.execution_role_policy"]
  family = "${var.task_family}"
  cpu = "${var.task_cpu_units}"
  memory = "${var.task_memory_units}"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions = "${data.template_file.container_definition.rendered}"
  task_role_arn = "${aws_iam_role.execution_and_task_role.arn}"
  execution_role_arn = "${aws_iam_role.execution_and_task_role.arn}"
}
