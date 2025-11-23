# rdev Quick Start

Quick start guide to creating a new rdev or analysis package.

## Details

To quickly create and configure a new rdev or analysis package, use the
following commands:

1.  With no project open, run
    [`create_github_repo()`](https://jabenninghoff.github.io/rdev/reference/create_github_repo.md)
    to initialize the GitHub R repository

2.  Without committing to git, run
    [`init()`](https://jabenninghoff.github.io/rdev/reference/init.md)
    in the newly created project

3.  Manually update the Title and Description fields in the
    `DESCRIPTION` file without committing

4.  Run
    [`setup_analysis()`](https://jabenninghoff.github.io/rdev/reference/setup_analysis.md)
    or
    [`setup_rdev()`](https://jabenninghoff.github.io/rdev/reference/setup_rdev.md)
    to configure the package as an analysis package or rdev package
    respectively.

5.  Manually update `.gitignore`: remove the `docs/` exclusion and add
    line breaks

After this, the package configuration is complete and ready for
development.
