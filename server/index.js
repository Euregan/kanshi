module.exports = setup => {
    require('dotenv').config()

    const express = require('express')
    const bodyparser = require('body-parser')
    const mustache = require('mustache-express')
    const path = require('path')

    const config = require('./sideEffects/config')
    const log = require('./sideEffects/log')({config})
    const cache = require('./sideEffects/cache')({config, log})
    const http = require('./sideEffects/http')({log, cache})

    const api = require('./api')

    const {configuration, providers} = require('./sideEffects/providers')(setup)


    api({
        config: config,
        log: log,
        http: http
    }, configuration, providers)(express()
        .engine('mst', mustache())
        .set('view engine', 'mst')
        .set('views', __dirname + '/templates')
        .use(bodyparser.json())
        .use(express.static(path.resolve(setup.resources)))
        .use((request, response, next) =>
            log.info(`${(new Date()).toLocaleTimeString()} ${request.protocol}://${request.get('host')}${request.path}`) && next()
        )
    )
}
