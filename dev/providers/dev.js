module.exports = (_, config) => {
  let provider = {}

  if (config.publicationName) {
    provider.publicationName = () => Promise.resolve(config.publicationName)
  }
  if (config.publicationName) {
    provider.publicationName = () => Promise.resolve(config.publicationName)
  }
  if (config.versions) {
    provider.versions = () => Promise.resolve(config.versions)
  }
  if (config.builds) {
    provider.builds = () => Promise.resolve(config.builds)
  }
  if (config.deployments) {
    provider.deployments = () => Promise.resolve(config.deployments)
  }
  if (config.calendar) {
    provider.deploymentCalendar = () => Promise.resolve(config.calendar)
  }
  if (config.packages) {
    provider.packagesUsed = () => Promise.resolve(config.packages)
  }

  return provider
}
