# Alternative Shells

:::{warning}
Currently the only images that support the alternative shells described here
are those based off of the php-fpm image. This includes:

 - den-php-fpm
 - den-php-fpm-magento2
 - den-php-debug
:::

Some Den containers now come with some alternative shells to BaSH. By default
BaSH is the shell used when running `den shell`, and if no shell is specified
Den will default to using BaSH.

## Specifying an alternative shell

You can specify the shell to use when running `den shell` in three different
ways. As Den parses your command it will evaluate which shell to use based on
the following order of preference:

 1. One-Time Specification
 2. Project Specific
 3. User Specific

### User Specific

Edit your `~/.den/.env` file to specify the setting of
`WARDEN_ENV_SHELL_COMMAND` with your choice of shell from below:

```
WARDEN_ENV_SHELL_COMMAND=fish
```

### Project Specific

Within your project environment, edit the `.env` file and specify the
`WARDEN_ENV_SHELL_COMMAND` variable with your choise of shell from below:

```
WARDEN_ENV_SHELL_COMMAND=fish
```

### One-Time Specification

Using an environment variable you can specify the shell to use on a
per-execution basis (or for an single session) using the variable: `USE_SHELL`.

```bash
USE_SHELL=fish den shell
```

## Available Shells

The following shells are currently available for use:

 - ash
 - bash
 - fish
 - zsh (including oh my zsh)