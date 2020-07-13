const server = require('./index.js')

server({
  configuration: 'dev/configuration',
  providers: 'dev/providers',
  resources: 'public'
})
