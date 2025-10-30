// target group

resource "aws_lb_target_group" "tg1" {
  name = "ntc-tg"
  port = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id = aws_vpc.my-vpc.id

  health_check {
    enabled = true
    healthy_threshold = 3
    interval = 10
    matcher = 200
    path = "/"
    port = "traffic-port"
    protocol = "HTTP"
    timeout = 6
    unhealthy_threshold = 3

  }

  depends_on = [ aws_vpc.my-vpc ]
}

#attach ec2 to target group

resource "aws_lb_target_group_attachment" "name" {
  target_group_arn = aws_lb_target_group.tg1.arn
  target_id = aws_instance.server1.id
  port = 80
}

resource "aws_lb_target_group_attachment" "name1" {
  target_group_arn = aws_lb_target_group.tg1.arn
  target_id = aws_instance.server2.id
  port = 80
}

#ALB
resource "aws_lb" "name" {
    name = "ntc-alb"
    load_balancer_type = "application"
    security_groups = [aws_security_group.alb_sg.id]
    subnets = [aws_subnet.private1.id, aws_subnet.private2.id]
    enable_deletion_protection = false
}

# create listener

resource "aws_lb_listener" "name" {
  load_balancer_arn = aws_lb.name.arn
  port=80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg1.arn
  }

}