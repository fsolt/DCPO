## Test environments
* Local OS X install, R 3.6.1
* Ubuntu 14.04.5 LTS (on travis-ci), R 3.6.1
* win-builder (R Under development (unstable) (2019-12-29 r77627))

## R CMD check results
There were no ERRORs or WARNINGs.

There were NOTES:

❯ checking for GNU extensions in Makefiles ... NOTE
  GNU make is a SystemRequirements.
  
* checking CRAN incoming feasibility ... NOTE
Maintainer: ‘Frederick Solt <frederick-solt@uiowa.edu>’

New submission

## Copyright
The copyright held by the Trustees of Columbia University in make_cc.R, licensed under GPL >= 3, is indicated via the ‘cph’ role in the ‘Authors@R’ field of the DESCRIPTION file.

## First resubmission
Revised Description field of DESCRIPTION file to cite reference describing the methods in the package. Added 'cph' role in 'Authors@R' field.  Replaced \dontrun{} with \donttest{} in examples, as they do not require APIs, etc., but are not executable in < 5 sec.

## Second resubmission
Employed warning() rather than cat() and print() in lines 49 and 50 of get_xvt_results.R
In dcpo_xvt.R, dcpo_input_fold$T was renamed dcpo_input_fold$Time at line 99 to avoid any risk of confusion with TRUE
