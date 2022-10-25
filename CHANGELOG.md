# Change Log

## UNRELEASED [x.y.z](https://github.com/swiftotter/den/tree/x.y.z) (yyyy-mm-dd)
[All Commits](https://github.com/swiftotter/den/compare/a829648..main)

First version is based on [Warden v0.12.0](https://github.com/davidalger/warden).

**Migration from Warden**:
* Certificates and other service-related data will now be located in `~/.den`.  You should **not** rename `~/.warden` to `~/.den`.
* You should `warden svc down` and then run `den install;den svc up`. Den Install will change the path of the `tunnel.warden.test` certificate, and Warden will not know to replace it if you switch back.
* When running `den install` Den will automatically regenerate SSL certificates for all existing Warden projects ([swiftotter/den#44](https://github.com/swiftotter/den/pull/44) by @ihor-sviziev) 

**Migration from DrPaynne**:
* The UID and GID for www-data was different on the DrPaynne fork.  You will need to `chown` any files on a volume mount (includes but is not limited to application files and the bash history file)

**Breaking Changes**:
* Den utilizes `docker compose` instead of `docker-compose`, requiring Docker Compose v2+ built into Docker

**Enhancements:**

* Dashboard of global services available at https://den.test/ ([swiftotter/den#58](https://github.com/swiftotter/den/pull/58) by @navarr)
* All images updated to be available in amd64 and arm64 varieties (excluding ElasticsearchHQ)
* Magento images come with bash autocompletion for Magerun pre-configured
* Database images have a MySQL history mount, which makes history of queries run in the `mysql` command persistent
* Ability to set up OpenSearch via `WARDEN_OPENSEARCH=1` and `OPENSEARCH_VERSION=` directives
* Ability to switch between MariaDB and MySQL using `DB_DISTRIBUTION=(mariadb|mysql)` and `DB_DISTRIBUTION_VERSION` directives
* Updated environment default Node version from 10 to 12 ([davidalger/warden#250](https://github.com/davidalger/warden/issues/250))
* Default URL for ElasticsearchHQ is now configured in the docker-compose config ([davidalger/warden#428](https://github.com/davidalger/warden/pull/428) by @ihor-sviziev)
* ElasticHQ is disabled by default ([davidalger/warden#434](https://github.com/davidalger/warden/pull/434) by @drpayyne)
* `.git` directories existing in subdirectories of the project root are now synced by Mutagen ([swiftotter/den#53](https://github.com/swiftotter/den/pull/53) by @ihor-sviziev)
* Addition of user and project-level customizations to the Warden development environment through scoped environment config loading ([davidalger/warden#451](https://github.com/davidalger/warden/pull/451) by @tdgroot)
* Portainer is now optional and disabled by default ([swiftotter/den#69](https://github.com/swiftotter/den/pull/69) by @bap14)
* Added a Drupal environment type ([swiftotter/den#70](https://github.com/swiftotter/den/pull/70) by @bap14)
* `den help` and `den list` will alo list any custom commands in the environment it is ran in ([swiftotter/den#78](https://github.com/swiftotter/den/pull/78) by @bap14)
* A new `magento-cloud` environment type has been added that, during env-init, automatically detects and configures Den to use the same service versions as Adobe Commerce Cloud in ([swiftotter/den#93](https://github.com/swiftotter/den/pull/93) by @henriquekieckbusch)
* mage2tv/magento-cache-clean has been added to all Magento 2 images.  It is available on the command line the command `cache-clean.js` or simply `cache-clean` ([swiftotter/den#105](https://github.com/swiftotter/den/pull/105) by @navarr)

**Available Services Versions:**

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
