<!-- provision a highly available web cluster in any region Default VPC
 Create:
     - Security Group for web server and ELB
     - Launch configuration with auto AMI lookup
     - Auto Scaling group using 2 Availability zones
     - Application load balancer in 2 Aavailability zones

 Update to web servers will be via Green/Blue deployment strategy
 Developed by Denis Astahov
 -->
