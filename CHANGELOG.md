# Change Log

## UNRELEASED [x.y.z](https://github.com/swiftotter/den/tree/x.y.z) (yyyy-mm-dd)
[All Commits](https://github.com/swiftotter/den/compare/a829648..main)

First version is based on [Warden v0.12.0](https://github.com/davidalger/warden).

**Enhancements:**

* All images updated to be available in amd64 and arm64 varieties (excluding ElasticsearchHQ)
* Ability to set up OpenSearch via `WARDEN_OPENSEARCH=1` and `OPENSEARCH_VERSION=` directives
* Ability to switch between MariaDB and MySQL using `DB_DISTRIBUTION=(mariadb|mysql)` and `DB_DISTRIBUTION_VERSION` directives
* Updated environment default Node version from 10 to 12 (issue [davidalger/warden#250](https://github.com/davidalger/warden/issues/250))
* Default URL for ElasticsearchHQ is now configured in the docker-compose config ([davidalger/warden#428](https://github.com/davidalger/warden/pull/428) by @ihor-sviziev)