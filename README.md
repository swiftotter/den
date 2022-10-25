# Den

_Forked from [Warden](https://github.com/davidalger/warden)_

Den is a CLI utility for orchestrating Docker based developer environments, and enables multiple local environments to run simultaneously without port conflicts via the use of a few centrally run services for proxying requests into the correct environment's containers.

<!-- include_open_stop -->

## Why the fork

Warden is our favorite tool for local environment orchestration!  Unfortunately, it is currently slow to update due to the lower availability of its maintenance team.  

So, we created _Den_ as a fork of Warden - so that we could bring it up to date with AMD64 support, smaller image sizes (thanks to Alpine linux), and a quicker update schedule.

### What changes will there be?

We at SwiftOtter are committed to maintaining Den in an open-source and accessible way.  That said, the areas we intent to prioritize will be more closely related to a Magento agency.  We intend to focus on ensuring that Den is in the best place first and foremost for Magento, and other environments may not be as quick to update.

## Features

* Traefik for SSL termination and routing/proxying requests into the correct containers.
* Dnsmasq to serve DNS responses for `.test` domains eliminating manual editing of `/etc/hosts`
* An SSH tunnel for connecting from Sequel Pro or TablePlus into any one of multiple running database containers.
* Den issued wildcard SSL certificates for running https on all local development domains.
* Full support for Magento 1 and Magento 2 on both macOS and Linux.
* Ability to override, extend, or setup completely custom environment definitions on a per-project basis.

## Available Services

|Service|Versions|
|:--|:--|
| Varnish | 6.0, 6.5, 6.6, 7.0, 7.1, 7.2 |
| Redis | 3.2, 4.0, 5.0, 6.0, 6.2, 7.0 |
| RabbitMQ | 3.7, 3.8, 3.9, 3.10, 3.11 |
| PHP | 7.2, 7.3, 7.4, 8.0, 8.1, 8.2-rc |
| Node JS | 10, 12, 13, 14, 15, 16, 17, 18, 19 |
| Elasticsearch | 5, 6, 7.6, 7.7, 7.9, 7.10, 7.12, 7.13, 7.14, 7.15, 7.16, 7.17, 8.0, 8.1, 8.2, 8.3, 8.4 |
| OpenSearch | 1.1, 1.2, 1.3, 2.0, 2.1, 2.2, 2.3 |
| Nginx | 1.16, 1.17, 1.18, 1.19, 1.20, 1.21, 1.22, 1.23 |
| MySQL | 5.5, 5.6, 5.7, 8.0.28, 8.0 |
| MariaDB | 10.0, 10.1, 10.2, 10.3, 10.4, 10.5, 10.6, 10.7, 10.8, 10.9, 10.10-rc |
| Magepack | 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9, 2.10, 2.11 |

## Contributing

All contributions to the Den welcome: use-cases, documentation, code, patches, bug reports, feature requests, etc. Any and all contributions may be made by submitting [Issues](https://github.com/swiftotter/den/issues) and [Pull Requests](https://github.com/swiftotter/den/pulls) here on Github.

Please note that by submitting a pull request or otherwise contributing to the Den project, you warrant that each of your contributions is an original work and that you have full authority to grant rights to said contribution and by so doing you grant the owners of the Den project, and those who receive the contribution directly or indirectly, a perpetual, worldwide, non-exclusive, royalty-free, irrevocable license to make, have made, use, offer to sell, sell and import or otherwise dispose of the contributions alone or with the Warden project in it's entirety.

## License

This work is licensed under the MIT license. See [LICENSE](https://github.com/swiftotter/den/blob/main/LICENSE) file for details.

## Author Information

Warden was started in 2019 by [David Alger](https://davidalger.com/).  
Den began as a fork of Warden in 2022 by [SwiftOtter](https://www.swiftotter.com/).
