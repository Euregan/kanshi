module.exports = (sideEffects, providers) => {
    return {
        get: config => {
            const providerFactory = config && config.provider && providers[config.provider] || (() => ({}))
            const provider = providerFactory(sideEffects, config && config.configuration)
            return {
                publicationName: provider.publicationName ? provider.publicationName : () => null,
                versions: provider.versions ? provider.versions : () => [],
                builds: provider.builds ? provider.builds : () => [],
                deployments: provider.deployments ? provider.deployments : () => [],
                deploymentCalendar: provider.deploymentCalendar ? provider.deploymentCalendar : () => null,
                packagesUsed: provider.packagesUsed ? provider.packagesUsed : () => []
            }
        }
    }
}
