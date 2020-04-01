## Test environments
* Local OS X install, R 3.6.1
* Ubuntu 14.04.5 LTS (on travis-ci), R 3.6.2
* win-builder (R version 4.0.0 alpha (2020-03-26 r78078))

## R CMD check results
There were no ERRORs or WARNINGs.

There were NOTES:

* checking for GNU extensions in Makefiles ... NOTE
  GNU make is a SystemRequirements.

* checking data for non-ASCII characters ... NOTE
  Note: found 38 marked UTF-8 strings
  
## Resubmission

Revised all examples to spawn just two processes.
