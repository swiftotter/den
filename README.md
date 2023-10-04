# Den is no longer actively maintained

[Warden](https://github.com/wardenenv) is now the preferred software for local environments.

When Migrating from Den to Warden, follow these steps for best results:

1. Stop any currently running environments
2. Run `den svc down -v` to stop and remove the Den service images
3. Uninstall Den
5. If on a Mac or Linux machine update `/etc/ssh/ssh_config` and remove everything between the `WARDEN START` and `WARDEN END` headers
4. Upgrade/Install Warden
7. Run `warden install`
8. Run `warden sign-certificate` for in each environment before the first time you start it
