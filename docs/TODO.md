# TODO

## Content

Add README.Rmd

Update `DESCRIPTION` and use description data in `README.Rmd`

Add ORCID

Update my ORCID details

## Package

Write a utility function to sort `.Rbuildignore`

Implement [pkgdown](https://pkgdown.r-lib.org)

Add links / update [Rd
formatting](https://roxygen2.r-lib.org/articles/rd-formatting.html) for
all function documentation.

Add dummy imports to silence R CMD check note per
[tidyverse](https://github.com/tidyverse/tidyverse/blob/main/R/tidyverse-package.R)

Migrate
[`build_analysis_site()`](https://jabenninghoff.github.io/rdev/reference/build_analysis_site.md)
to rdev

Switch from development version of `styler` (1.3.2.9000) when a new
release becomes available

~~Validate that `lint_all` works as expected within `ci`~~

Add ‘create package’ workflow example to README, remove TODO section
“Analysis package creation process”

Move `_pkgdown.yml` to repository root to make projects discoverable by
the [pgkdown](https://pkgdown.r-lib.org) GitHub
[query](https://github.com/search?q=filename%3Apkgdown.yml+path%3A%2F&type=Code)

Update `README.Rmd` template to dynamically generate list of notebooks
in `analysis`

Automate release process

Automate creation of feature branches, including ‘Bump version’ using
`desc::desc_bump_version("dev")`

Add check to
[`stage_release()`](https://jabenninghoff.github.io/rdev/reference/stage_release.md)
to look for missing topics in `_pkgdown.yml` reference section

Update
[`use_rdev_package()`](https://jabenninghoff.github.io/rdev/reference/use_rdev_package.md)

Handle `.Rmd` files that already have an `html_document` section

Move
[`rmd_metadata()`](https://jabenninghoff.github.io/rdev/reference/rmd_metadata.md)
from README-analysis.Rmd to rdev package

Add tests per comments in `R/` after reading package book, documentation

Update Roxygen comments after reading package book, documentation,
review and merge duplicate Roxygen docs

Write a manual regression test script (notes with R commands) ~~as a
vignette~~ to validate ‘Creating Packages’ ~~and ‘GitHub Releases’~~

Add messages, warnings to
[`build_analysis_site()`](https://jabenninghoff.github.io/rdev/reference/build_analysis_site.md)
to report on progress

Add function to spell check notebooks

Automate branch protection

Address issue <https://github.com/r-lib/usethis/issues/1568>, which has
been closed

Add dplyr when running
[`use_analysis_package()`](https://jabenninghoff.github.io/rdev/reference/use_analysis_package.md)

~~Consider switching `getOption("pkgType")` from `source` to `both` per
R
[options](https://stat.ethz.ch/R-manual/R-devel/library/base/html/options.html)~~
per the [R macOS
FAQ](https://cran.r-project.org/bin/macosx/RMacOSX-FAQ.html#What-is-the-difference-between-the-CRAN-build-and-a-vanilla-build_003f),
“Only the CRAN build is guaranteed to be compatible with the package
binaries on CRAN (or Bioconductor).”

Support creating repos in organizations

~~Consider incorporating the GitHub description into `DESCRIPTION`~~

Create a wrapper for `spelling` that includes notebooks in package spell
checking, WORDLIST

Add a `spell_check_test_notebooks()` function for CI spellchecks on
notebooks

Convert manual tests (`Setup.Rmd`) into an R Script that can be run from
within the package created with
[`create_github_repo()`](https://jabenninghoff.github.io/rdev/reference/create_github_repo.md)

Add a function to add missing (notebook) dependencies to DESCRIPTION,
see
[`renv::dependencies()`](https://rstudio.github.io/renv/reference/dependencies.html)
and
[`desc::desc_get_deps()`](https://desc.r-lib.org/reference/desc_get_deps.html)

Add
[`check_renv()`](https://jabenninghoff.github.io/rdev/reference/check_renv.md)
to [`ci()`](https://jabenninghoff.github.io/rdev/reference/ci.md) and
stop if
[`renv::status()`](https://rstudio.github.io/renv/reference/status.html)
is not up to date

Replace proof-docs with [urlchecker](https://urlchecker.r-lib.org),
support checking GitHub Pages `docs` directory using
`url_db_from_HTML_files` ~~(ask if a PR for this would be accepted)~~

Move scripts from `tools` to `inst/bin` or similar, per [Stack
Overflow](https://stackoverflow.com/questions/26104709/is-there-any-special-functionality-in-r-package-exec-or-tools-directories)
and [R Packages](https://r-pkgs.org/inst.html#inst-other-langs)

Switch from development versions of `styler` (1.3.2.9000) and `lintr`
(2.0.1.9000) when a new release becomes available - both were needed to
address bugs in the current release versions, 1.3.2 and 2.0.1.

Add trailing slash to GitHub Pages URL

Update
[`lint_all()`](https://jabenninghoff.github.io/rdev/reference/lint_all.md)
to lint all types, including `.Rpres`

~~Add custom CSS files to
[`_site.yml`](https://rmarkdown.rstudio.com/docs/reference/render_site.html)
and analysis notebook templates to control font size, as described in
this
[article](https://medium.com/@HadrienD/how-to-customize-font-size-in-r-markdown-documents-f5adff36e2cc),
or possibly using
[`bs_theme()`](https://rstudio.github.io/bslib/articles/theming.html),
since pkgdown customizes the default using
[`build_bslib()`](https://github.com/r-lib/pkgdown/blob/main/R/theme.R)~~
(issue exists in unsupported Safari 14 but not Safari 15)

~~Remove `pkgdown/extra.css` if
<https://github.com/r-lib/pkgdown/issues/2377> is accepted~~

~~Establish default [knitr options](https://yihui.org/knitr/options/),
including `knitr::opts_chunk$set(fig.align = "center")`, add to analysis
template, also review
[settings](https://github.com/hadley/adv-r/blob/master/common.R) for
*Advanced R*~~

~~Consider using RStudio
[Extensions](https://rstudio.github.io/rstudio-extensions/index.html):~~

~~Use Project
[Templates](https://rstudio.github.io/rstudio-extensions/rstudio_project_templates.html)
like [vertical](https://www.crumplab.com/vertical/)?~~

~~Add CSS to R Markdown
[Template](https://rstudio.github.io/rstudio-extensions/rmarkdown_templates.html)
instead of `assets/extra.css`?~~

Move `shift-heading-level-by: 1` from `_quarto.yml` to
`analysis/_metadata.yml`, so `TODO.md` renders properly

Remove `preset: bootstrap` workaround when pkgdown 2.0.8+ is released
(per <https://github.com/r-lib/pkgdown/issues/2376>)

Replace `GITHUB_PAT` in `.Renviron` with
[gitcreds](https://usethis.r-lib.org/articles/git-credentials.html)

Review use of [usethis
functions](https://usethis.r-lib.org/reference/index.html), including
[pull request
helpers](https://usethis.r-lib.org/articles/pr-functions.html)

Update tests with new testthat features
([`testthat::auto_test_package()`](https://testthat.r-lib.org/reference/auto_test.html),
[`testthat::describe()`](https://testthat.r-lib.org/reference/describe.html),
Reporters,
[`testthat::local_mocked_bindings()`](https://testthat.r-lib.org/reference/local_mocked_bindings.html))

Replace `dev = TRUE` logic after renv 1.1.6+ is released; see renv
[\#1695](https://github.com/rstudio/renv/issues/1695),
[\#2190](https://github.com/rstudio/renv/pull/2190)

Update errors and messages after reading Advanced R
[Conditions](https://adv-r.hadley.nz/conditions.html) and re-reading the
Tidyverse [Style Guide](https://style.tidyverse.org/index.html)

Reduce the number of Imports, per R CMD check:

    > devtools::check()

    ...

    > checking package dependencies ... NOTE
      Imports includes 30 non-default packages.
      Importing from so many packages makes the package vulnerable to any of
      them becoming unavailable.  Move as many as possible to Suggests and
      use conditionally.

## GitHub

Set up [GitHub
Actions](https://usethis.r-lib.org/reference/github_actions.html)

Use
[standard](https://github.com/r-lib/actions/blob/master/examples/check-standard.yaml)
`R CMD check`

Use
[lintr](https://github.com/r-lib/actions/blob/master/examples/lint.yaml)

Faster CI checks

~~Switch to
[full](https://github.com/r-lib/actions/blob/master/examples/check-full.yaml)
`R CMD check` ?~~

Update GitHub Actions from r-lib
[examples](https://github.com/r-lib/actions/tree/master/examples)

Run [test
coverage](https://github.com/r-lib/actions/blob/master/examples/test-coverage.yaml)

~~Skip CI checks for changes in only the `docs/` directory~~

~~Add GitHub Action for html/link checking using something like
[htmlproofer](https://github.com/gjtorikian/html-proofer)~~

~~Autobuild `docs/` like
[pkgdown](https://github.com/r-lib/actions/blob/master/examples/pkgdown.yaml)
?~~
