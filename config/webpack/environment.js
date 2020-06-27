const { environment } = require('@rails/webpacker')
const jqueryProvider = require('./plugins/jquery')

environment.plugins.append('Provide', jqueryProvider);
module.exports = environment;
