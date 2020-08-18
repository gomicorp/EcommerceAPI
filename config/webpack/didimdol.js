process.env.NODE_ENV = process.env.NODE_ENV || 'didimdol'

const environment = require('./environment')

module.exports = environment.toWebpackConfig()