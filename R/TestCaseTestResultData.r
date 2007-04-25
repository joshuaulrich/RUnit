##  RUnit : A unit test framework for the R programming language
##  Copyright (C) 2006-2007 Matthias Burger, Thomas Koenig, Klaus Juenemann
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

##  $Id$


.defineTestCaseTestResultDataClass <- function(where=environment()) {
  ##@bdescr
  ##
  ##  Initialisation function
  ##  Not to be called by the user(s).
  ##  Initialization for class 'TestCaseTestResultData'.
  ##  
  ##@edescr
  ##
  ##@class : [TestCaseTestResultData]
  ##
  ##@slot  functionName   : [character] test suite name 
  ##@slot  sourceFileName : [character]
  ##@slot  checkNum       : [integer] check function counter
  ##@slot  deactivated    : [logical] flag
  ##@slot  failure        : [logical] flag
  ##@slot  error          : [logical] flag
  ##@slot  setUpError     : [logical] flag
  ##@slot  tearDownError  : [logical] flag
  ##@slot  errorMsg       : [character] string
  ##@slot  execTime       : [numeric] ?sys.time
  ##@slot  warnMessageStack : [list] list of strings, one per warning incurred

  
  if (.GLOBAL$getDebug()) {
    
    cat(".defineTestCaseTestResultDataClass ... ")
  }
  
  setClass("TestCaseTestResultData",
           representation(functionName     = "character",
                          sourceFileName   = "character",
                          checkNum         = "integer",
                          deactivated      = "logical",
                          failure          = "logical",
                          error            = "logical",
                          setUpError       = "logical",
                          tearDownError    = "logical",
                          errorMsg         = "character",
                          traceBack        = "character",
                          execTime         = "numeric",
                          warnMessageStack = "list"),
           prototype(checkNum      = as.integer(0),
                     deactivated   = FALSE,
                     failure       = FALSE,
                     error         = FALSE,
                     setUpError    = FALSE,
                     tearDownError = FALSE,
                     execTime      = as.numeric(NA)),
           validity = NULL,
           sealed   = .GLOBAL$getSealed(),
           where    = where)

  if (.GLOBAL$getDebug()) {
    
    cat("o.k.\n")
  }
}
