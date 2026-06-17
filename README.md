# cloud-infrastructure-portfolio
AWS infrastructure portfolio — Terraform, ECS, RDS,  CI/CD pipelines. Built from scratch. Production patterns.









# Terraform state list
> terraform state list
aws_eip.nat
aws_internet_gateway.IG
aws_nat_gateway.main
aws_route.private
aws_route.public
aws_route_table.private
aws_route_table.public
aws_route_table_association.private[0]
aws_route_table_association.private[1]
aws_route_table_association.public[0]
aws_route_table_association.public[1]
aws_subnet.database[0]
aws_subnet.database[1]
aws_subnet.private[0]
aws_subnet.private[1]
aws_subnet.public[0]
aws_subnet.public[1]
aws_vpc.main


# 1: What is idempotency in Terraform?
Idempotency in Terraform is a principle where when running terraform apply for you terraform instance multiple times without changing anything in the code, will still produces the same result. It matters because it will hinder the infrastructure to break and to not implement unneccesary elements that could break it.

# 2:What is a Terraform state file? What happens if two people apply from the same repo simultaneously without state locking?

A state file functions as terraform's memory. What it does is that is what resources exist in Aws and then maps it to your code and without it, it wouldn't know what resources had already been created to your infrastructure. If two developers apply from the same repo simultaneously without state locking, they would only overwrite each other which would lead to corrupted infrastructure.

# 3.What is the difference between a resource block and a data block? When would you use each?
A resource block allows you to create something in aws and a data block allows you to read information about something that already exists in aws. For example you use a resource to create a vpc in aws via terraform and the data block allows you to read information for the existing vpc for example.

# 4. What is implicit dependency? Give one example from your VPC code.
It's when Terraform automatically figures out in what order it shall create resources based up the references of the different resources you have made in your code.

ex: resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id # this is the of reference where terrafrom understand that it must make sure to create a vpc first before creating a public subnet
}

# 5. When would you choose a VPC endpoint over a NAT gateway? Consider both cost and security.

I would consider VPC endpoint for specific task like accessing my S3 or my DynamoDB via a private subnet. It would save me money since vpc endpoints are free to use and more secure.

# 6: Why do we keep RDS subnets separate from private app subnets — what problem does it solve?
So private subnets are for ECS/EC2 instances while database subnets only belongs to RDS. We separate them for security purposes. If your network layer gets compromised, the intruders gets into your private subnet. If your RDS is in the same subnet, the intruders gets access to your database which could be a huge security risk. By separating them, we can put extra network isolation for the subnet and control what resources is allowed to toalk to the subnet. We will also be able to apply different security groups to our db subnets.

# What is a rolling upgrade and why does it avoid downtime?

Rolling upgrade means that instead of you stopping all containers and starting new one, you starts a new container with a new code and structure and waits for it to be healthy. Only then can you stop the old containers. The reason their is no downtime is because old containers are still serving the users and the new ones starts in the background. The ALB will gradually start to shift and direct traffic to the new container and by then will the old container be removed - only after the new one is healthy and secure enough to be runned on.

# Task 17

1. What are the four Google SRE golden signals?
- Latency: How long requests take
- Traffic: How many requests/second
- Errors: How many requests fail
- Saturation: How full your system is (CPU, Memory, Connections) 
For example in my nginx app, in image 1 you can see how traffic spiked around 12:55 and 13:00 as I was testing the application with curl

2. Why is measuring only container uptime and CPU/memory not enough?
Because when it comes to an application, user experience plays a huge role and not just infrastructure health. A container can be seen running and low cpu usage in the AWS console, but provides errors for every user or takes long time to respond. In this scenario, this matters more.

3. What does a spike in 5xx codes tell you that a green health check doesn't?
It tells you that users are receiving errors when proceeding in different requests. Just because the aws console tells you that your task/container is healthy doesnt mean that the UX is perfect. Therefore it is always important to verify your infrastructure deeper and not just on a surface level.


4. Where in AWS console can you find 5xx counts for your ALB?

EC2 - Load Balancers - your ALB - Monitoring - then scroll down