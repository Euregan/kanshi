module.exports = folders => {
    const path = require('path')

    const configuration = {
        providers: require(path.relative(
            path.resolve(__dirname),
            path.resolve(folders.configuration, 'providers')
        )),
        packages: require(path.relative(
            path.resolve(__dirname),
            path.resolve(folders.configuration, 'packages')
        )),
        standalones: require(path.relative(
            path.resolve(__dirname),
            path.resolve(folders.configuration, 'standalones')
        ))
    }


    const parseConfiguration = config => config.reduce(([providersAcc, packagesAcc], config) => {
        for (const key in config) {
            if (typeof config[key] === 'object' && 'provider' in config[key]) {
                const provider = config[key].provider

                if (provider in configuration.providers) {
                    providersAcc.push(configuration.providers[provider].provider)
                    config[key].provider = configuration.providers[provider].provider
                    config[key].configuration = {...configuration.providers[provider].configuration, ...config[key].configuration}
                } else {
                    providersAcc.push(provider)
                }
            }
        }

        packagesAcc.push(config)

        return [providersAcc, packagesAcc]
    }, [[], []])

    const [requiredPackageProviders, packages] = parseConfiguration(configuration.packages)
    const [requiredStandaloneProviders, standalones] = parseConfiguration(configuration.standalones)

    const requiredProviders = requiredPackageProviders.concat(requiredStandaloneProviders)
        .filter((value, index, array) => array.indexOf(value) === index)
    configuration.packages = packages
    configuration.standalones = standalones


    const rawProviders = require('fs').readdirSync(path.resolve(folders.providers))

    let providers = {}
    for (let i = 0; i < rawProviders.length; i++) {
        const provider = rawProviders[i]
        const providerName = provider.split('.')[0]
        if (requiredProviders.includes(providerName)) {
            providers[provider.split('.')[0]] = require(path.relative(
                path.resolve(__dirname),
                path.resolve(folders.providers, provider)
            ))
        }
    }


    return {
        configuration,
        providers
    }
}
