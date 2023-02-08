# SlackFishCloud 🐠

Never forget to delete your AWS daily tests. SlackFishCloud sends messages to Slack channels alerting you to running AWS resources. 💬

## Dependencies 🔗
<b>OS</b>:
- GNU/Linux or WSL

<b>Will be installed via `install.sh` if necessary:</b>
- jq
- figlet
- AWS CLI v.2+ (requires configuration)

## Install ⚙️
<b>Steps:</b>
1. ```sudo apt install dos2unix```
2. In SlackFishCloud directory: ```dos2unix sh/* && dos2unix dependencies.txt install.sh slack_fish_cloud.sh```
3. `chmod +x install.sh slack_fish_cloud.sh`
4. Run `./install.sh` and set default AWS CLI profile and a Slack Webhook URL for your workspaces
  
For more information about Slack Webhooks, see <a href="https://api.slack.com/messaging/webhooks" target="_blank">Sending messages using Incoming Webhooks</a>

## Quick usage guide 📚
Get EC2 running instances (not launched via ASGs) and running ASGs:

![example_aws_ec2_instances_and_asgs_console](https://user-images.githubusercontent.com/68431603/217516534-ec076fb0-ccaa-4996-93b6-359757281d54.png)

In Slack:

![example_aws_ec2_instances_and_asgs_slack](https://user-images.githubusercontent.com/68431603/217516776-37da8d49-14c7-4398-aa41-d7c665d8f685.png)

## Open plans 📌
- New filters
- Set up schedulers with crontab
- Project more EC2 attributes in messages
- Implement a multi-cloud version (Azure + GCP)
- Add support in other AWS services/resources, e.g. ASGs, Snapshots, EBS disks, S3 buckets

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
