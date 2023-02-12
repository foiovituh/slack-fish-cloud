# SlackFishCloud 🐠
Never forget to delete your AWS daily tests. SlackFishCloud sends messages to Slack channels alerting you to running AWS resources.

## Dependencies 🔗
<b>OS</b>:
- GNU/Linux or WSL

<b>Will be installed via `install.sh` if necessary:</b>
- jq
- figlet
- AWS CLI v.2+ (<b>requires configuration</b>)

## Install ⚙️
<b>Steps:</b>
1. `chmod +x install.sh slack_fish_cloud.sh`
2. Run `./install.sh` to set the default AWS CLI profile and a Slack Webhook URL for your workspace

For more information about Slack Webhooks, see <a href="https://api.slack.com/messaging/webhooks" target="_blank">Sending messages using Incoming Webhooks</a>

## Quick usage guide 📚
Get EC2 running resources (ASGs, volumes and instances) in `us-east-1`:
```bash
./sfc.sh --regions us-east-1
```

You can also pass other regions separated by spaces:
```bash
./sfc.sh --regions us-east-1 us-east-2 af-south-1 eu-west-3
```

Example in Slack:

![example_aws_ec2_instances_and_asgs_slack](https://user-images.githubusercontent.com/68431603/217516776-37da8d49-14c7-4398-aa41-d7c665d8f685.png)
![example_aws_ec2_volumes_slack](https://user-images.githubusercontent.com/68431603/218195248-b26899d1-cd2c-4471-a9b5-d972ae6f7b6a.png)

<b>NOTE:</b> only instances and volumes created on the same day of the script execution will be considered

## Open plans 📌
- New filters
- Set up schedulers with crontab
- Project more EC2 attributes in messages
- Implement a multi-cloud version (Azure + GCP)
- Add support in other AWS services/resources, e.g. Snapshots and S3 buckets

## Do you want help me? 👥
If you have any ideas or wish to contribute to the project, contact me on Twitter @vituohto or send me a pull request! :)

## License 🏳️
```
MIT License

Copyright (c) 2023 Vitu Ohto

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
