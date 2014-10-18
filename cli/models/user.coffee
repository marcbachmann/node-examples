_ = require('lodash')
inquirer = require('inquirer')
config = require('../config')
util = require('../lib/util')
data = require('../lib/data')


class User
  constructor: (obj) ->
    @id = obj.id
    @email = obj.email
    @first_name = obj.first_name
    @last_name = obj.last_name
    @phone = obj.phone


  toString: ->
    _.compact([@first_name, @last_name, @email]).join(', ')


  print: ->
    util.print """
      Email: #{@email || ''}
      First name: #{@first_name || ''}
      Last name: #{@last_name || ''}
      Phone: #{@phone || ''}
    """


  @select: (list, callback) ->
    data.get (err, body) ->
      return callback(err) if err || !body?.users?.length

      users = []
      for user in body.users
        users.push new User(user)

      util.print("The list contains #{users.length} #{ if users.length == 1 then 'user' else 'users'}")
      inquirer.prompt [
        name: 'user'
        message: 'Select a user to process'
        type: 'list'
        choices: ->
          _.map users, (user, index)->
            name: user.toString()
            value: user
      ] , ({user}) ->
        callback(null, user)



module.exports = User
