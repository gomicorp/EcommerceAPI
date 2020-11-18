process.env.NODE_ENV = process.env.NODE_ENV || 'partner'

const environment = require('./environment')

module.exports = environment.toWebpackConfig()