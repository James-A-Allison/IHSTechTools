[![Build status](https://ci.appveyor.com/api/projects/status/hm2a822s7vd933u7?svg=true)](https://ci.appveyor.com/project/ch4413/ihstechtools)

IHSTechTools
================
Christopher Hughes
18 November 2016

<!-- README.md is generated from README.Rmd. Please edit that file -->
### Getting Started with IHS Tech Tools

The first thing we want to do is check that we've got all of the dependent packages available. The check\_pkgs function will do this all for you. Run it and you'll have laid the foundations for working:

check\_pkgs()

Once we've got all of the right packages installed and up to date, we'll need to decide where we're working. Use changeDir to move to the directory you wish to create your files in, where path is your directory path:

changeDir(path)

Now we're ready to go! Use the other functions as described in the vignette...

system.file("extdata", "response.json", package = "IHSTechTools")
