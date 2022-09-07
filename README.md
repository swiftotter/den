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

## Contributing

All contributions to the Den welcome: use-cases, documentation, code, patches, bug reports, feature requests, etc. Any and all contributions may be made by submitting [Issues](https://github.com/davidalger/warden/issues) and [Pull Requests](https://github.com/davidalger/warden/pulls) here on Github.

Please note that by submitting a pull request or otherwise contributing to the Den project, you warrant that each of your contributions is an original work and that you have full authority to grant rights to said contribution and by so doing you grant the owners of the Den project, and those who receive the contribution directly or indirectly, a perpetual, worldwide, non-exclusive, royalty-free, irrevocable license to make, have made, use, offer to sell, sell and import or otherwise dispose of the contributions alone or with the Warden project in it's entirety.

## License

This work is licensed under the MIT license. See [LICENSE](https://github.com/swiftotter/den/blob/main/LICENSE) file for details.

## Author Information

Warden was started in 2019 by [David Alger](https://davidalger.com/).  
Den began as a fork of Warden in 2022 by [SwiftOtter](https://www.swiftotter.com/).
