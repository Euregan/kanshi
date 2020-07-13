module.exports = (sideEffects, configuration, providers) => express => {
    const { log, config } = sideEffects
    const fetcher = require('./fetcher')(sideEffects, require('./providers')(sideEffects, providers))


    express.get('/api/standalone/:id', (request, response) => {
        const application = configuration.standalones.find(package => package.id === request.params.id)
        if (!application) {
            return response.status(404).send(JSON.stringify({error: `No standalone with id ${request.params.id}`}))
        }
        return fetcher.standalone(application)
            .then(application => response.send(application))
            .catch(error => {
                response.status(500)
                return response.send(JSON.stringify(log.error(error)))
            })
    })

    express.get('/api/package/:id', (request, response) => {
        const application = configuration.packages.find(package => package.id === request.params.id)
        if (!application) {
            return response.status(404).send(JSON.stringify({error: `No package with id ${request.params.id}`}))
        }
        return fetcher.package(application)
            .then(application => response.send(application))
            .catch(error => {
                response.status(500)
                return response.send(JSON.stringify(log.error(error)))
            })
    })

    express.get('*', (request, response, next) =>
        response.render('index', {
            configuration: JSON.stringify({
                standalones: configuration.standalones,
                packages: configuration.packages
            })
        })
    )

    express.listen(config.port, () => log.info(`App listening on ${config.port}`))
}
