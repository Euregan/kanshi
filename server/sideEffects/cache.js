const cache = {}

module.exports = (/* no side effects required*/) => ({
    has: url => !!cache[url],
    get: url => cache[url],
    set: (time, url, data) => {
        cache[url] = data
        setTimeout(() => { delete cache[url] }, time)
        return data
    }
})
