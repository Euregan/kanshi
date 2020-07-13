module.exports = ({config}) => {
    const levels = {
        off: 0,
        fatal: 100,
        error: 200,
        warn: 300,
        info: 400,
        debug: 500,
        trace: 600,
        all: Infinity
    }
    const level = levels[config.logLevel] || levels.info
    const format = data => {
      if (config.environment === 'production') {
        const objectData = typeof data !== 'object' || Array.isArray(data)
          ? { data: data }
          : data
        return JSON.stringify(objectData, null, 0)
      }
      return data
    }

    return {
        debug: data => level >= levels.debug ? (console.log(format(data)) || data) : data,
        info: data => console.log(format(data)) || data,
        error: data => console.error(format(data)) || data
    }
}
