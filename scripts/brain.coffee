#
#  Description:
#    Slack Deployment Bot
Ansible = require 'node-ansible'
exec = require 'child_process'

module.exports = (robot) ->
  robot.hear /help/i, (msg) ->
    msg.send "Commands I know:\n* *help*\n* *deploy*\n@slack-ansible-bot deploy [product] [environment] [stack] [version] [playbook] [engineVersion]\n* *versions*"

  robot.respond /deploy (.*)/i, (msg) ->
    product1Regex = /(.*) (.*) (.*) (.*) (.*) (.*)/i
    product2Regex = /(.*) (.*) (.*) (.*) (.*)/i

    msgArgs = []
    if (product1Regex.test(msg.match[1]))
      msgArgs = product1Regex.exec(msg.match[1])
      engineVersion = msgArgs[6]

    else
      msgArgs = product2Regex.exec(msg.match[1])

    product = msgArgs[1]
    environment = msgArgs[2]
    stack = msgArgs[3]
    version = msgArgs[4]
    simulate = false
    pb = msgArgs[5]

    #validation
    if (!/(product1|product2)/.test(product))
      msg.send "invalid product: #{product}"
      return

    if (product == "product1" && !product1Regex.test(msg.match[1]))
      msg.send "product1 should have 6 arguments : [product] [environment] [stack] [version] [playbook] [engineVersion]"
      return

    if (product == "product2" && !product2Regex.test(msg.match[1]))
      msg.send "product2 should have 5 arguments : [product] [environment] [stack] [version] [playbook]"
      return

    if (!/(qa|dev|demo)/.test(environment))
      msg.send "invalid environment: #{environment}"
      return

    if (product== "product1" && !/(qa|dev|demo)\d{1,3}/.test(stack))
      msg.send "invalid stack: #{stack}"
      return

    if (!/\d{1,3}\.\d{1,3}\.\d{1,3}-\d{1,3}/.test(version))
      msg.send "invalid version: #{version}"
      return

    if (product == "product1" && !/\d{1,3}\.\d{1,3}\.\d{1,3}-\d{1,3}/.test(engineVersion))
      msg.send "invalid engineVersion: #{engineVersion}"
      return

    msg.send "Running playbook #{pb} product: #{product}, environment: #{environment}, stack: #{stack}, version: #{version}, engine version: #{engineVersion}"
    execute_ansible(msg, product, environment, stack, version, pb, engineVersion, simulate)

  robot.catchAll (msg) ->
    msg.send "I don't know how to react to: #{msg.message.text}"

  execute_ansible =(msg, product, environment, stack, version, pb, engineVersion, simulate) ->
    playbookPath = "/opt/ansible"

    console.log(playbookPath);
    if(simulate)
      console.log product, environment, stack, version, engineVersion
    else
      # command = new Ansible.Playbook
      # command.playbook '/opt/ansible/install-pb'
      # command.inventory '/opt/ansible/hosts' #  #{environment}#{stack}hosts
      # .privateKey('/home/user/.ssh/id_rsa')
      # command.variables {
      #   version: "#{version}",
      #   engineVersion: "#{engineVersion}",
      #   configPrefix:"#{product}/#{environment}#{stack}",
      #   nodeEnv: "#{environment}",
      #   stackName: "#{environment}#{stack}"
      # }
      # command.variables {version: "#{version}", nodeEnv: "#{environment}", stackName: "#{stack}"};

      # command.on 'stdout', (data) ->
      #   msg.send "```#{data.toString()}```"
      #   console.log data.toString()
      # command.on 'stderr', (data) ->
      #   console.log data.toString()
      #   msg.send "oops: ```#{data.toString()}```"
      # command.exec {cwd: playbookPath}
      child = exec.spawn 'node', ['run-ansible.js', "#{product}", "#{environment}", "#{stack}", "#{version}", "#{pb}-#{product}", "#{engineVersion}"]
      child.stdout.on 'data', (data) ->
        console.log data.toString();
        msg.send "```#{data.toString()}```"


      child.stderr.on 'data', (data) ->
        console.error data.toString();
        msg.send "```#{data.toString()}```"




    # ansible = spawn command, args
    #   ansible.stderr.on 'data', (data) ->
    #     process.stderr.write data.toString() if data
    #   ansible.stdout.on 'data', (data) ->
    #     process.stdout.write data.toString() if data
    #   ansible.on 'exit', (code) ->
    #     process.stdout.write code.toString() if code
