##  RUnit : A unit test framework for the R programming language
##  Copyright (C) 2003, 2004  Thomas Koenig, Matthias Burger, Klaus Juenemann
##
##  This program is free software; you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation; either version 2 of the License, or
##  (at your option) any later version.
##
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with this program; if not, write to the Free Software
##  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA



printTextProtocol <- function(testData,
                              fileName = "",
                              separateFailureList = TRUE,
                              showDetails = TRUE,
                              traceBackCutOff=9) {

  ## just a convenience function
  pr <- function(..., sep=" ", nl=TRUE) {
    if(nl) {
      cat(... , "\n", file = fileName, append=TRUE, sep=sep)
    }
    else {
      cat(... , file = fileName, append=TRUE, sep=sep)
    }
  }

  ## get singular or plural right
  sop <- function(number, word, plext="s") ifelse(number == 1, paste(number, word),
                                  paste(number, paste(word, plext, sep="")))


  ## header part
  cat("RUNIT TEST PROTOCOL --", date(), "\n", file = fileName)
  pr("***********************************************")
  if(length(testData) == 0) {
    pr("no test cases :-(")
    return()
  }

  nTestFunc <- 0
  nErr <- 0
  nFail <- 0
  for(i in seq(length=length(testData))) {
    nTestFunc <- nTestFunc + testData[[i]]$nTestFunc
    nErr <- nErr + testData[[i]]$nErr
    nFail <- nFail + testData[[i]]$nFail
  }

  errInfo <- getErrors(testData)
  pr("Number of test functions:", errInfo$nTestFunc)
  pr("Number of errors:", errInfo$nErr)
  pr("Number of failures:", errInfo$nFail, "\n\n")


  ## summary of test suites
  pr(sop(length(testData), "Test Suite"), ":")
  for(tsName in names(testData)) {
    pr(tsName, " - ", sop(testData[[tsName]]$nTestFunc, "test function"), ", ",
       sop(testData[[tsName]]$nErr, "error"), ", ",
       sop(testData[[tsName]]$nFail, "failure"), sep="")
    if(separateFailureList && (testData[[tsName]]$nErr + testData[[tsName]]$nFail > 0)) {
      srcFileRes <- testData[[tsName]]$sourceFileResults
      for(i in seq(length=length(srcFileRes))) {
        testFuncNames <- names(srcFileRes[[i]])
        for(j in seq(length=length(testFuncNames))) {
          funcList <- srcFileRes[[i]][[testFuncNames[j]]]
          if(funcList$kind == "error") {
            pr("ERROR in ", testFuncNames[j], ": ", funcList$msg, nl=FALSE, sep="")
          }
          else if(funcList$kind == "failure") {
            pr("FAILURE in ", testFuncNames[j], ": ", funcList$msg,
               sep="", nl=FALSE)
          }
        }
      }
    }
  }


  ## if no details are required, we are done.
  if(!showDetails) return()

  pr("\n\n\nDetails")

  ## loop over all test suites
  for(tsName in names(testData)) {
    tsList <- testData[[tsName]]
    pr("***************************")
    pr("Test Suite:", tsName)
    pr("Test function regexp:", tsList$testFuncRegexp)
    pr("Test file regexp:", tsList$testFileRegexp)
    if(length(tsList$dirs) == 0) {
      pr("No directories !")
    }
    else {
      if(length(tsList$dirs) == 1) {
        pr("Involved directory:")
      }
      else {
        pr("Involved directories:")
      }
      for(dir in tsList$dirs) {
        pr(dir)
      }
      res <- tsList$sourceFileResults
      testFileNames <- names(res)
      if(length(res) == 0) {
        pr("no test files")
      }
      else {
        ## loop over all source files
        for(testFileName in testFileNames) {
          pr("---------------------------")
          pr("Test file:", testFileName)
          testFuncNames <- names(res[[testFileName]])
          if(length(testFuncNames) == 0) {
            pr("no test functions")
          }
          else {
            ## loop over all test functions in the test file
            for(testFuncName in testFuncNames) {
              testFuncInfo <- res[[testFileName]][[testFuncName]]
              if(testFuncInfo$kind == "success") {
                pr(testFuncName, ":", " ... OK (", testFuncInfo$time, " seconds)", sep="")
              }
              else {
                if(testFuncInfo$kind == "error") {
                  pr(testFuncName, ": ERROR !! ", sep="")
                }
                else if (testFuncInfo$kind == "failure") {
                  pr(testFuncName, ": FAILURE !! (check number ", testFuncInfo$checkNo, ")", sep="")
                }
                else {
                  pr(testFuncName, ": unknown error kind", sep="")
                }
                pr(testFuncInfo$msg, nl=FALSE)
                if(length(testFuncInfo$traceBack) > 0) {
                  pr("   Call Stack:")
                  for(i in traceBackCutOff:length(testFuncInfo$traceBack)) {
                    pr("   ", 1+i-traceBackCutOff, ": ", testFuncInfo$traceBack[i], sep="")
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}


print.RUnitTestData <- function(testData) {
  errInfo <- getErrors(testData)
  cat("Number of test functions:", errInfo$nTestFunc, "\n")
  cat("Number of errors:", errInfo$nErr, "\n")
  cat("Number of failures:", errInfo$nFail, "\n")
}

summary.RUnitTestData <- function(testData, ...) {
  printTextProtocol(testData, ...)
}
