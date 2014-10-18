exports.get = (callback) ->
  all = require('./users')
  users = []

  for user in all
    name = user.name.split(' ')
    users.push
      id: user.id
      email: user.email
      first_name: name[0]
      last_name: name[1]
      phone: user.phone


  callback(null, users: users)
