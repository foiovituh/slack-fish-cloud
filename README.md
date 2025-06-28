# SlackFishCloud 🐠
Never forget to delete your AWS daily tests. SlackFishCloud sends messages to Slack channels alerting you to running AWS resources.

## Requirements 🔗
<b>OS</b>:
- GNU/Linux or WSL

<b>Will be installed via `install.sh` if necessary:</b>
- jq
- curl
- figlet
- AWS CLI v.2+ (<b>requires configuration</b>)

## Install ⚙️
<b>Steps:</b>
1. `chmod +x install.sh sfc.sh`
2. Run `./install.sh` to set the default AWS CLI profile and a Slack Webhook URL for your workspace

For more information about Slack Webhooks, see <a href="https://api.slack.com/messaging/webhooks" target="_blank">Sending messages using Incoming Webhooks</a>

## Quick usage guide 📚
Get EC2 running resources (ASGs, instances, snapshots and volumes) in `us-east-1`:
```bash
./sfc.sh --regions us-east-1
```

You can also pass other regions separated by spaces:
```bash
./sfc.sh --regions us-east-1 us-east-2 af-south-1 eu-west-3
```

Examples in Slack:

![example_aws_ec2_asg_resources](https://user-images.githubusercontent.com/68431603/220462527-a7312139-2f48-4890-873c-f47da05fa834.jpg)
![example_aws_ec2_instance_resources](https://user-images.githubusercontent.com/68431603/220462534-136893ba-09cf-4f5b-b0ed-4a09666b3536.jpg)
![example_aws_ec2_snapshot_resources](https://user-images.githubusercontent.com/68431603/220462536-c87fbe30-262d-4660-9253-0405f3c96395.jpg)
![example_aws_ec2_volume_resources](https://user-images.githubusercontent.com/68431603/220462537-1f2094e7-cfb2-424a-a978-cf28ff604054.jpg)

<b>NOTE:</b> only instances volumes and snapshots created on the same day of the script execution will be considered

## Open plans 📌
- New filters
- Set up schedulers with crontab
- Project more EC2 attributes in messages
- Implement a multi-cloud version (Azure + GCP)
- Add support in other AWS services/resources, e.g. S3 buckets and Lambda functions

## Do you want help me? 👥
If you have any ideas or wish to contribute to the project, contact me on X (<a href="https://x.com/ohtoaki" target="_blank">@ohtoaki</a>) or send me a pull request :)

## License 📄
Distributed under the MIT License. See [`LICENSE`](LICENSE) for more information.
