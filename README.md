Price tracking app

This app is taken for Udemy course . In this first implementation I am going to deploy this app to an AWS environment using Terraform.
I'll use two different work spaces. 

Design:

![desing](./img/desing1.jpeg)

Components:

- VPC: 
    - Private and public subnets, IG, NAT Gateway, RT,...
    - NACL
- ALB
- Route53 domain (taken from data)
- ACM Certificate (taken from variable)
- CloudFront
- S3 
- Roles
- Auto Scaling Rules
- SGs
- CloudWatch alerts, logs groups and events.
    


