const https = require('https')

module.exports = ({log, cache}) => {
    const query = method => options => (url, data, cacheTime = 0) => new Promise((resolve, reject) => {
        if (method === 'GET' && cache.has(url)) {
            log.info(`[CACHE] https://${url}`)
            resolve(cache.get(url))
        } else {
            const parameters = {
                hostname: url.split('/')[0],
                path: '/' + url.split('/').slice(1).join('/'),
                method: method,
                headers: {
                    'Content-Type': 'application/json'
                }
            }

            if (options && options.auth) {
                parameters.headers.Authorization = options.auth
            }
            if (options && options.headers) {
                parameters.headers = {...parameters.headers, ...options.headers}
            }

            const request = https.request(parameters, response => {
                log.info(`[${method}:${response.statusCode}] https://${parameters.hostname}${parameters.path}`)
                let data = ''

                response.on('data', chunk => data += chunk)
                response.on('end', () => {
                    if (response.statusCode > 399) {
                        reject(data)
                    } else {
                        if (method === 'GET') {
                            cache.set(cacheTime, url, data)
                        }
                        resolve(data)
                    }
                })
            })

            request.on('error', err => reject(err))
            if (data) {
                request.write(JSON.stringify(data))
            }
            request.end()
        }
    })

    return {
        GET: query('GET'),
        PUT: query('PUT'),
        POST: query('POST'),
        DELETE: query('DELETE')
    }
}
