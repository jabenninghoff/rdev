# Introduction to rdev

## Overview

rdev supports my personal workflow, including creation of both
traditional R packages and R Analysis Packages
([`vignette("analysis-package-layout")`](https://jabenninghoff.github.io/rdev/articles/analysis-package-layout.md)),
enforcing consistency across packages, and providing Continuous
Integration/Continuous Delivery (CI/CD) automation. I use the tools in
rdev to improve code quality, speed up development of R code, and
publish results of analyses in R and Quarto Notebooks as HTML to make
them accessible to non-R users.

## Installation

My current R development environment uses [Homebrew](https://brew.sh),
[rig](https://github.com/r-lib/rig/),
[RStudio](https://posit.co/download/rstudio-desktop/),
[GitHub](https://github.com), a collection of R packages including rdev,
[Visual Studio Code](https://code.visualstudio.com), and
[Vim](https://www.vim.org).

### Homebrew

I use [Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle) to
install all software on my systems; my basic macOS working environment
is published on GitHub in
[macos-env](https://github.com/jabenninghoff/macos-env/tree/master).

### Installing R

rig supports installation of multiple versions of official R binaries,
which I use for reproducibility. To install R using rig, first install
rig:

``` sh
brew tap r-lib/rig
brew install --cask rig
```

Then install desired versions of R. The following installs R 3.6 through
4.5 on ARM based macs (as of 2025-10-08):

``` sh
rig install oldrel/6 --without-pak --arch x86_64
rig install oldrel/5 --without-pak --arch x86_64
rig install oldrel/4 --without-pak
rig install oldrel/3 --without-pak
rig install oldrel/2 --without-pak
rig install oldrel/1 --without-pak
rig install oldrel --without-pak
rig install release --without-pak
rig default release
```

Note that:

1.  I don’t use [pak](https://pak.r-lib.org), which rig installs by
    default, as it is not yet fully
    [supported](https://github.com/rstudio/renv/issues/1210) by renv.
2.  The oldest version of R I install is 3.6, since RStudio now requires
    R 3.6 or newer (as of version
    [2024.04.00](https://docs.posit.co/ide/news/#rstudio-2024.04.0))
3.  Since there was no ARM binary release for R 3.6 (`oldrel/6`) or R
    4.0 (`oldrel/5`), I install the Intel binaries and run them with
    [Rosetta 2](https://support.apple.com/en-us/102527).

### Development Tools

Well, obviously, I use
[RStudio](https://posit.co/download/rstudio-desktop/). RStudio is the
leading IDE for R development and integrates with many R packages,
although it sometimes falls short; I use GitHub and the command line for
Git, and occasionally Visual Studio Code (which has better support for
markdown) and Vim (which is faster for some types of edits).

Posit is developing a next-generation R and Python IDE based on Visual
Studio Code, [Positron](https://github.com/posit-dev/positron). While
I’ve tried using Positron, I’ve found that it has too many [missing
features](https://positron.posit.co/migrate-rstudio-compare.html) to
replace RStudio for my development, including:

- Lack of a notebook-style interface for RMarkdown or Quarto documents
- No support for lintr
- No command History or package Build panes

Of these, the first two are showstoppers and the missing panes are
nearly so.

RStudio, the GitHub desktop client, and Visual Studio Code are easily
installed using Homebrew:

``` sh
brew install --cask rstudio
brew install --cask github
brew install --cask visual-studio-code
```

It is recommended to change the default settings for `.RData` in RStudio
(in Options \> General \> Basic \> Workspace):

- Uncheck “Restore .Data into workspace at startup”
- Set “Save workspace to .Data on exit” to “Never”

Vim is installed by default on macOS and most Unix-like systems.

### Packages

Managing packages and environments are a challenge for most modern
languages. Thankfully R doesn’t have the same level of challenge as
python, or even ruby, managing packages available within a project is a
best practice. I use [renv](https://github.com/rstudio/renv) for this
purpose, and use renv to install and manage all packages in all of my
projects.

The `setup-r` script from rdev installs a base set of packages needed to
run rdev in the R User Library. A streamlined version of that script is
included below.

``` sh
# fix rig permissions
sudo chown -R "$(whoami)":admin /Library/Frameworks/R.framework/Versions/*/Resources/library

RVERSION="$(Rscript -e 'cat(as.character(getRversion()[1,1:2]))')"
USERLIB="$HOME/Library/R/$(uname -m)/${RVERSION}/library"
DEVPKG='c("renv", "styler", "lintr", "miniUI", "languageserver", "rmarkdown", "devtools", "available")'
GITPKG='c("jabenninghoff/rdev")'

if [ ! -d "${USERLIB}" ]
then
    mkdir -p "${USERLIB}"
fi

echo "install.packages(${DEVPKG}, repos=\"https://cloud.r-project.org\", lib=\"${USERLIB}\")" | R --no-save
echo "remotes::install_github(${GITPKG}, lib=\"${USERLIB}\")" | R --no-save
```

The `chown` command is needed to allow updating the base packages using
the RStudio Packages “Update” function. I generally update packages in
RStudio with no projects open before starting development, then update
packages in projects using
[`renv::update()`](https://rstudio.github.io/renv/reference/update.html).

If you’re installing (development) versions of packages from GitHub, it
is
[recommended](https://usethis.r-lib.org/articles/git-credentials.html)
to set up a personal access token using
[`usethis::create_github_token()`](https://usethis.r-lib.org/reference/github-token.html)
and adding it to your Git credential store using
[`gitcreds::gitcreds_set()`](https://gitcreds.r-lib.org/reference/gitcreds_get.html).
You can verify GitHub is set up following usethis recommendations with
[`usethis::git_sitrep()`](https://usethis.r-lib.org/reference/git_sitrep.html).

### Further Reading

My workflow has been heavily influenced by the DevOps movement and the
research of the [DevOps Research and Assessment
(DORA)](https://www.devops-research.com/research.html) team at Google
started by Dr. Nicole Forsgren. Their
[research](https://dora.dev/research/) shows how technical and
non-technical [capabilities](https://dora.dev/devops-capabilities/)
improve outcomes.

The functions included in rdev support many of the technical
capabilities, including:

- Code maintainability
- Continuous delivery
- Continuous integration
- Deployment automation
- Shifting left on security
- Test automation
- Trunk-based development
- Version control

An outline of my [SIRAcon
2022](https://web.archive.org/web/20221205210229/https://societyinforisk.org/SiRAcon)
talk, “Making R Work for You (With Automation)” is available on GitHub
in [siracon2022](https://jabenninghoff.github.io/siracon2022/).
