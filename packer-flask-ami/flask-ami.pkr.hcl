packer {
    required_plugins {
        amazon = {
          source  = "github.com/hashicorp/amazon"
          version = ">= 1.0.0"
        }
    }
}
source "amazon-ebs" "flask" {
  region        = "ap-south-2"
  instance_type = "t3.micro"
  ssh_username  = "ubuntu"   # Ubuntu default user

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      virtualization-type = "hvm"
      root-device-type    = "ebs"
    }
    owners      = ["099720109477"] # Canonical (Ubuntu)
    most_recent = true
  }

  ami_name = "flask-ubuntu-ami-{{timestamp}}"
}

build {
  sources = ["source.amazon-ebs.flask"]

  provisioner "file" {
    source      = "app.py"
    destination = "/home/ubuntu/app.py"
  }

  provisioner "shell" {
    inline = [
    "sudo apt update -y",
    "sudo apt install -y python3 python3-pip",

    # Install Flask safely
    "python3 -m pip install --upgrade pip",
    "python3 -m pip install flask",

    # Move app
    "sudo mv /home/ubuntu/app.py /opt/app.py",
    "sudo chown ubuntu:ubuntu /opt/app.py",

    # Create systemd service file
    "sudo bash -c 'cat > /etc/systemd/system/flaskapp.service <<EOF\n[Unit]\nDescription=Flask App\nAfter=network.target\n\n[Service]\nUser=ubuntu\nWorkingDirectory=/opt\nExecStart=/usr/bin/python3 /opt/app.py\nRestart=always\n\n[Install]\nWantedBy=multi-user.target\nEOF'",

    # Enable service
    "sudo systemctl daemon-reload",
    "sudo systemctl enable flaskapp"
  ]
 } 
}