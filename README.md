git-flow-hooks
==============

Some useful hooks for [git-flow (AVH Edition)][1].

What does it do?
================

- Prevent direct commits to the master branch (on repositories with `gitflow` initialized).
- Prevent merge marker commits.
- Automatically bump versions when starting a release or hotfix. Versions are generated, written to file and committed.
- Automatically specify tag messages.

Usage
=====

Install
-------

On Ubuntu 15.x

- `apt-get update && apt-get install -y git-flow`
- Clone this repository to git config dir: `git clone git@github.com:marcinant/git-flow-hooks.git ~/.config/git/git-flow-hooks/`

Use as global template
----------------------

- `$(cd ~/.config/git/git-flow-hooks && git config --global init.templatedir $(pwd))`.

Update
------

- Run `git init` in your repository.


Configuration
-------------

Copy the file `.git/hooks/modules/git-flow-hooks-config.sh.dist` to `.git/git-flow-hooks-config.sh` and change whatever you like. This is completely optional.

[git-flow (AVH Edition)][1] has some useful configuration options too. See its [wiki][5] for a complete list.
Or you can type `git flow <command> [<subcommand>] --help`.

Starting releases and hotfixes
------------------------------

If `git flow release start` and `git flow hotfix start` are run without a version, the version will be bumped automatically. Releases will be bumped at the minor level (`1.2.3` becomes `1.3.0`), hotfixes at the patch level (`1.2.3` becomes `1.2.4`). The hooks will look at the git tags to find the version to bump. If no tags are found, it looks for the version-file. If that isn't found, it assumes the current version is `0.0.0`.

Alternatively you may use `patch`, `minor` and `major` as version. A bump of that level will take place.

If the commands are run with version, that version will be used (no bumping).

Automatic tag messages
----------------------

If you want tag messages to be automated (you won't be bothered with your editor to specify it), use the following configuration options:

    $ git config gitflow.hotfix.finish.message "Hotfix %tag%"
    $ git config gitflow.release.finish.message "Release %tag%"

If you like, you can change the tag-placeholder (`%tag%` in the example above) in the git-flow-hooks configuration.

License
=======

git-flow-hooks is published under The MIT License, see the [LICENSE][2] file.

Note that these hooks are built for [git-flow (AVH Edition)][1] by Peter van der Does, which has its own [licenses][3].

The scripts for preventing master and merge marker commits are based on [git-hooks][4] by Sitebase.

[1]: https://github.com/petervanderdoes/gitflow
[2]: https://github.com/jaspernbrouwer/git-flow-hooks/blob/master/LICENSE
[3]: https://github.com/petervanderdoes/gitflow/blob/master/LICENSE
[4]: https://github.com/Sitebase/git-hooks
[5]: https://github.com/petervanderdoes/gitflow/wiki/Reference:-Configuration
[6]: http://www.gnu.org/software/coreutils
[7]: http://www.macports.org/
[8]: http://brew.sh/
