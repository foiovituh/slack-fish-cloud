# 🐠 SlackFishCloud
![GitHub License](https://img.shields.io/github/license/foiovituh/slackfishcloud)
![GitHub Release](https://img.shields.io/github/v/release/foiovituh/slackfishcloud)

> A Bash script that sends Slack alerts for running AWS resources to help avoid unnecessary cloud costs.

## 📦 Installation

Clone the repository:

```bash
git clone https://github.com/foiovituh/slackfishcloud.git
cd slackfishcloud

chmod +x install.sh sfc.sh
./install.sh
```

The installation script configures the default AWS CLI profile and your Slack Incoming Webhook URL.

For more information about Slack Webhooks, see:
https://api.slack.com/messaging/webhooks

## 🔗 Requirements

Supported operating systems:

- GNU/Linux
- WSL

The following dependencies are installed automatically by `install.sh` if needed:

- `jq`
- `curl`
- `figlet`
- AWS CLI v2+ (requires prior configuration)

## 🚀 Usage

Scan a single AWS region:

```bash
./sfc.sh --regions us-east-1
```

Scan multiple AWS regions:

```bash
./sfc.sh --regions us-east-1 us-east-2 af-south-1 eu-west-3
```

## 📷 Examples

![example_aws_ec2_asg_resources](https://user-images.githubusercontent.com/68431603/220462527-a7312139-2f48-4890-873c-f47da05fa834.jpg)
![example_aws_ec2_instance_resources](https://user-images.githubusercontent.com/68431603/220462534-136893ba-09cf-4f5b-b0ed-4a09666b3536.jpg)
![example_aws_ec2_snapshot_resources](https://user-images.githubusercontent.com/68431603/220462536-c87fbe30-262d-4660-9253-0405f3c96395.jpg)
![example_aws_ec2_volume_resources](https://user-images.githubusercontent.com/68431603/220462537-1f2094e7-cfb2-424a-a978-cf28ff604054.jpg)

Only EC2 instances, EBS volumes, and snapshots created on the same day the script is executed are included in the report.

## 🗺️ Roadmap

- [ ] Additional resource filters
- [ ] Automatic scheduling with cron
- [ ] More EC2 resource metadata in notifications
- [ ] Multi-cloud support (Azure and GCP)
- [ ] Support for additional AWS services (S3, Lambda, etc.)

## ⭐ Support the Project

If you like this project or find it useful, please give it a star! It helps increase its visibility and supports future development.

## 📄 License

Distributed under the MIT License. See [`LICENSE`](LICENSE) for more information.
