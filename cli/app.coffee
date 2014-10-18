_ = require('lodash')
inquirer = require('inquirer')
shortid = require('shortid')

shortid.seed(Math.random())
config = require('./config')
util = require('./lib/util')
User = require('./models/user')


actions =
  update: (user, callback) ->
    inquirer.prompt [
        name: 'first_name'
        message: 'First name'
        default: user.first_name
      ,
        name: 'last_name'
        message: 'Last name'
        default: user.last_name
      ,
        name: 'email'
        message: 'Email'
        default: user.email
        validate: (val) ->
          return true if /@/.test(val)
          'Please enter a valid email address.'
      ,
        name: 'phone'
        message: 'Phone'
        default: user.phone
    ] , (edit) ->
      _.extend(user, edit)
      callback(null, user, false)


  create: (user, callback) ->
    token = shortid.generate()
    user.print()
    util.print("Invitation Token: #{token}")
    callback(null, null, true)


  delete: (user, callback) ->
    console.log('Delete user')
    callback(null, null, true)


askUserAction = (user, callback) ->
  user.print()
  inquirer.prompt [
    name: 'action'
    message: 'Select an action'
    type: 'list'
    choices: [
      name: 'Edit the user'
      value: 'update'
    ,
      name: 'Generate an invite token'
      value: 'create'
    ,
      name: 'Delete the beta token request'
      value: 'delete'
    ]
  ] , ({action}) ->
    actions[action] user, (err, editedUser, close) ->
      return callback(err) if err
      return callback() if close
      askUserAction(user, callback)


module.exports = (callback) ->
  User.select config.madmimi.newUsersList, (err, user) ->
    return callback(err) if err
    return askUserAction(user, callback) if user

    console.log """

    --------------------------------------
      Hooray. You processed all request.
      Go acquiring some new customers!
    --------------------------------------

    """
    callback()


# Start the module unless it's required in a different file
unless module.parent.parent
  module.exports (err) ->
    console.log(err) if err
    process.exit(0)
