[![Build status](https://ci.appveyor.com/api/projects/status/hm2a822s7vd933u7?svg=true)](https://ci.appveyor.com/project/ch4413/ihstechtools)

IHSTechTools
================
Christopher Hughes
18 November 2016

<!-- README.md is generated from README.Rmd. Please edit that file -->
## Installing IHS Tech Tools

To install IHS Tech Tools you'll need ghit's help. Run the script below install IHSTechTools and see all of the functions inside it:

```
check_pkg_ghit <- function() {
  if(!require(ghit)) {
    message("installing the 'ghit' package")
    install.packages("ghit")
    require(ghit)
  }
}

check_pkg_ghit()

ghit::install_github("ch4413/IHSTechTools")
library(IHSTechTools)
ls("package:IHSTechTools")

```

### Getting Started with IHS Tech Tools

The first thing we want to do is check that we've got all of the dependent packages available. The check\_pkgs function will do this all for you. Run it and you'll have laid the foundations for working:
```
check_pkgs()

```
Once we've got all of the right packages installed and up to date, we'll need to decide where we're working. Use changeDir to move to the directory you wish to create your files in, where path is your directory path:

```
# Use changeDir(path) if your files are not in the default directory, where
# path is the location of your directory

changeDir()

```

Now we're ready to go! Use the other functions as described in the vignette or just try out the command below if you're working from the default directory:

```
convertTraxFile("TV Programming Intelligence Trax.csv")
```

