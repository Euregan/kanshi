const profile = require('./webpack-profile.json')

const objectToArray = (object) => Object.values(object)

const childrenToArray = (folder) => ({
  ...folder,
  children: objectToArray(folder.children).map(childrenToArray)
})

const profileToFormattedModules = (profile) => {
  const simplifiedModules = (profile.children ? profile.children[0] : profile).modules
    .map((module) => ({
      id: module.id,
      size: module.size,
      path: module.name
    }))
    .filter(({ path }) => path[0] === '.')

  let fileTree = { name: 'root', value: 0, children: {} }
  simplifiedModules.forEach((module) => {
    const path = module.path.split('/').slice(1)

    fileTree.size += module.size

    let localTree = fileTree
    path.forEach((file, index) => {
      localTree.children[file] = localTree.children[file] || { name: file, size: 0, children: {} }
      localTree.children[file].size += module.size
      localTree = localTree.children[file]
    })
  })

  return childrenToArray(fileTree).children
}

const profileToFormattedAssets = (profile) =>
  (profile.children ? profile.children[0] : profile).assets.map((asset) => ({
    name: asset.name,
    type: asset.type,
    chunks: asset.chunks,
    size: asset.size
  }))

const profileToTime = (profile) => (profile.children ? profile.children[0] : profile).time

module.exports = [
  {
    id: 'blog',
    name: 'Blog',
    builds: {
      provider: 'dev',
      configuration: {
        builds: [
          {
            id: '25',
            state: 'Successful',
            number: 25,
            url: null
          },
          {
            id: '24',
            state: 'Successful',
            number: 24,
            url: null
          },
          {
            id: '23',
            state: 'Successful',
            number: 23,
            url: null
          },
          {
            id: '22',
            state: 'Successful',
            number: 22,
            url: null
          },
          {
            id: '21',
            state: 'Successful',
            number: 21,
            url: null
          },
          {
            id: '20',
            state: 'Failed',
            number: 20,
            url: null
          }
        ]
      }
    },
    deployments: {
      provider: 'dev',
      configuration: {
        deployments: [
          {
            id: '2019/07/10/16h10m58s',
            state: 'SUCCESS',
            date: 1562767858000,
            url: null
          },
          {
            id: '2019/07/05/11h41m14s',
            state: 'SUCCESS',
            date: 1562319674000,
            url: null
          },
          {
            id: '2019/07/04/16h01m15s',
            state: 'SUCCESS',
            date: 1562248875000,
            url: null
          },
          {
            id: '2019/07/03/15h19m25s',
            state: 'SUCCESS',
            date: 1562159965000,
            url: null
          },
          {
            id: '2019/06/26/17h30m10s',
            state: 'SUCCESS',
            date: 1561563010000,
            url: null
          },
          {
            id: '2019/06/26/15h29m09s',
            state: 'SUCCESS',
            date: 1561555749000,
            url: null
          }
        ]
      }
    },
    source: {
      provider: 'dev',
      configuration: { packages: { '@swag/login-form': ['1.3.8', '^1.3.9'] } }
    }
  },
  {
    id: 'website',
    name: 'Website',
    builds: {
      provider: 'dev',
      configuration: {
        builds: [
          {
            id: '25',
            state: 'Canceled',
            number: 25,
            url: null
          },
          {
            id: '24',
            state: 'Successful',
            number: 24,
            url: null
          },
          {
            id: '23',
            state: 'Successful',
            number: 23,
            url: null
          },
          {
            id: '22',
            state: 'Successful',
            number: 22,
            url: null
          },
          {
            id: '21',
            state: 'Successful',
            number: 21,
            url: null
          },
          {
            id: '20',
            state: 'Failed',
            number: 20,
            url: null
          }
        ]
      }
    },
    deployments: {
      provider: 'dev',
      configuration: {
        deployments: [
          {
            id: '2019/07/10/16h10m58s',
            state: 'SUCCESS',
            date: 1562767858000,
            url: null
          },
          {
            id: '2019/07/05/11h41m14s',
            state: 'SUCCESS',
            date: 1562319674000,
            url: null
          },
          {
            id: '2019/07/04/16h01m15s',
            state: 'SUCCESS',
            date: 1562248875000,
            url: null
          },
          {
            id: '2019/07/03/15h19m25s',
            state: 'SUCCESS',
            date: 1562159965000,
            url: null
          },
          {
            id: '2019/06/26/17h30m10s',
            state: 'SUCCESS',
            date: 1561563010000,
            url: null
          },
          {
            id: '2019/06/26/15h29m09s',
            state: 'SUCCESS',
            date: 1561555749000,
            url: null
          },
          {
            id: '2019/06/24/18h52m49s',
            state: 'SUCCESS',
            date: 1561395169000,
            url: null
          },
          {
            id: '2019/06/20/18h04m51s',
            state: 'SUCCESS',
            date: 1561046691000,
            url: null
          },
          {
            id: '2019/06/19/16h11m26s',
            state: 'SUCCESS',
            date: 1560953486000,
            url: null
          }
        ]
      }
    },
    source: {
      provider: 'dev',
      configuration: {
        packages: {
          '@swag/login-form': ['1.3.9', '^1.0.0'],
          '@swag/api-caller': ['2.1.0', '^2.0.0']
        }
      }
    }
  },
  {
    id: 'customer-service',
    name: 'Customer service',
    builds: {
      provider: 'dev',
      configuration: {
        builds: [
          {
            id: '25',
            state: 'Successful',
            number: 25,
            url: null,
            profiles: {
              webpack: {
                time: profileToTime(profile),
                assets: profileToFormattedAssets(profile),
                modules: profileToFormattedModules(profile)
              }
            }
          },
          {
            id: '24',
            state: 'Successful',
            number: 24,
            url: null
          },
          {
            id: '23',
            state: 'Successful',
            number: 23,
            url: null
          },
          {
            id: '22',
            state: 'Successful',
            number: 22,
            url: null
          },
          {
            id: '21',
            state: 'Successful',
            number: 21,
            url: null
          }
        ]
      }
    },
    deployments: {
      provider: 'dev',
      configuration: {
        deployments: [
          {
            id: '2019/07/10/16h10m58s',
            state: 'SUCCESS',
            date: 1562767858000,
            url: null
          },
          {
            id: '2019/07/05/11h41m14s',
            state: 'SUCCESS',
            date: 1562319674000,
            url: null
          },
          {
            id: '2019/07/04/16h01m15s',
            state: 'SUCCESS',
            date: 1562248875000,
            url: null
          }
        ]
      }
    },
    source: {
      provider: 'dev',
      configuration: {
        packages: {
          '@swag/login-form': ['1.2.9', '1.2.9'],
          '@swag/api-caller': ['2.1.0', '^2.0.0']
        }
      }
    }
  }
]
