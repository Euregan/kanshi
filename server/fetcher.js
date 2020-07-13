module.exports = (sideEffects, providers) => {
    const partial = object => new Promise((resolve, reject) => {
        let promiseCount = 0
        let final = {}

        const testForReturn = () => promiseCount === 0 && resolve(final)

        for (const key in object) {
            if (object[key] instanceof Promise) {
                promiseCount++
                object[key].then(result => {
                    final[key] = result
                    promiseCount--
                    testForReturn()
                }).catch(error => {
                    final[key] = error
                    promiseCount--
                    testForReturn()
                })
            } else {
                final[key] = object[key]
            }
        }
        testForReturn()
    })

    const standalone = application => partial({
        id: application.id,
        name: application.name,
        builds: providers.get(application.builds).builds(),
        deployments: providers.get(application.deployments).deployments(),
        calendar: providers.get(application.deployments).deploymentCalendar(),
        packages: providers.get(application.source).packagesUsed()
    })

    const package = application => partial({
        id: application.id,
        name: application.name,
        publicationName: providers.get(application.package).publicationName(),
        versions: providers.get(application.versions).versions(),
        builds: providers.get(application.builds).builds(),
        deployments: providers.get(application.deployments).deployments()
    })

    return {
        package,
        standalone
    }
}
