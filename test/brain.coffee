Helper = require('hubot-test-helper')
chai = require 'chai'

expect = chai.expect

helper = new Helper('../scripts/brain.coffee')

describe 'example script', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'should display help', ->
    @room.user.say('alice', 'help').then =>
      expect(@room.messages).to.eql [
        ['alice', 'help']
        ['hubot', 'Commands I know:\n* *help*\n* *deploy*\n@slack-ansible-bot deploy [product] [environment] [stack] [version] [engineVersion]\n* *versions*']
      ]

  it 'product1 deployment test message', ->
    @room.user.say('bob', '@hubot deploy product1 qa qa-1 0.0.0-0 0.0.0-0').then =>
      expect(@room.messages).to.eql [
        ['bob', '@hubot deploy product1 qa-1 0.0.0-0 0.0.0-0']
        ['hubot', 'Deploying product: product1, environment: qa, stack: qa-1, version: 0.0.0-0, engine version: 0.0.0-0']
      ]

  it 'product2 deployment test message', ->
    @room.user.say('fizzgig', '@hubot deploy product2 qa qa-1 0.0.0-0').then =>
      expect(@room.messages).to.eql [
        ['fizzgig', '@hubot deploy product2 qa qa 0.0.0-0']
        ['hubot', 'Deploying product: product2, environment: qa, stack: qa-1, version: 0.0.0-0']
      ]
