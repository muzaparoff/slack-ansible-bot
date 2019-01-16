# slack-ansible-bot

slack-ansible-bot is a chat bot built on the [Hubot][hubot] framework. It is used as a gateway for devops operations like deployment.

[hubot]: http://hubot.github.com

### Running slack-ansible-bot via pm2

    pm2 start --name slack-ansible-bot npm -- start

### Running slack-ansible-bot Locally

You can start slack-ansible-bot locally by running:

    bin/hubot

You'll see some start up output and a prompt:

    [Sat Feb 28 2015 12:38:27 GMT+0000 (GMT)] INFO Using default redis on localhost:6379
    slack-ansible-bot>

Then you can interact with slack-ansible-bot by typing `slack-ansible-bot help`.

    slack-ansible-bot> help

### Running slack-ansible-bot for slack

You can start slack-ansible-bot attached to a Slack #devops room by running:

    npm start

or

    HUBOT_SLACK_TOKEN=xoxb ./bin/hubot  --adapter slack

* To change or remove this token go to 

### Running tests

    npm test
