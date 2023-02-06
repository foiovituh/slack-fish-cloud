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
1. `chmod +x install.sh slack_fish_cloud.sh`
2. Run `./install.sh`
3. Set default AWS CLI profile and a Slack Webhook URL for your workspaces
4. If there are no error messages, all dependencies were installed successfully
5. (Only for WSL): ```sudo apt install dos2unix``` and them ```dos2unix dependencies.txt install.sh utils.sh credentials.sh slack_fish_cloud.sh```
  
For more information about Slack Webhooks, see <a href="https://api.slack.com/messaging/webhooks" target="_blank">Sending messages using Incoming Webhooks</a>

## Quick usage guide 📚
Get EC2 running instances (not launched via ASGs) using custom regions:

![example_aws_ec2_custom_regions](https://user-images.githubusercontent.com/68431603/216840855-5ffde476-40d6-4f33-be98-fce423d75a8f.png)

In Slack:

![example_aws_ec2_custom_regions_slack](https://user-images.githubusercontent.com/68431603/216840788-ba201464-4322-4218-aa5e-5a1d53bb0aba.png)

<b>OBS*</b>: if you don't specify any region, the default region set during `install.sh` will be used.

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
