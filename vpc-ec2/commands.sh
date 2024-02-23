# ssh into ec2
ssh-keygen -t ed25519
ls ~/.ssh
ssh -i ~/.ssh/[keypair_name] # example: aws_keypair
ssh -i ~/.ssh/keypair_name ubuntu@[public_ip]
