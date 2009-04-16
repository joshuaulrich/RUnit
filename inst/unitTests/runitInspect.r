##  RUnit : A unit test framework for the R programming language
##  Copyright (C) 2003-2009  Thomas Koenig, Matthias Burger, Klaus Juenemann
##
##  This program is free software; you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation; version 2 of the License.
##
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with this program; if not, write to the Free Software
##  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
##
##  $Id$


cat("\n\nRUnit test cases for 'RUnit:inspect' functions\n\n")

.tearDown <- function() {
  if (exists("track", envir=.GlobalEnv)) {
    rm(track, envir=.GlobalEnv)
  }
}


foo <- function(x) {
  y <- 0
  for(i in 1:100) {
    y <- y + i
  }
  return(y)
}
  

testRUnit.inspect <- function() {

 
  ## the name track is necessary
  track <<- tracker()
  
  ## initialize the tracker
  track$init()
  
  ## inspect the function
  ## res will collect the result of calling foo
  res <- inspect(foo(10), track=track)
  checkEquals( res, 5050)

}


bar <- function(x) {
  y <- 0
  for(i in 1:100) {
    y <- y + i
  }
  return(y)
}
  
foo <- function(x) {

  if (length(x))
    n <- length(x)

  len <- if(n==0)
    "zero"
  else if (n==1)
    "one"
  else if (n==2)
    "two"
  else if (n==3)
    "three"
  else
    "many"

  cat("object contains",len, "elements")
  
}

testRUnit.getTrackInfo <- function() {

  ## the name track is necessary
  track <<- tracker()
  
  ## initialize the tracker
  track$init()
  
  ## inspect the function
  checkTrue( exists("bar"))
  
  ## res will collect the result of calling foo
  res <- inspect(bar(10), track=track)
  checkEquals( res, 5050)

  ## get the tracked function call info
  resTrack <- track$getTrackInfo()
  checkTrue( is.list(resTrack))
  checkEquals( names(resTrack), c("R/bar"))

  checkEquals( names(resTrack$"R/bar"),
              c("src", "run", "time", "graph", "nrRuns", "funcCall"))
}




testRUnit.printHTML <- function() {
  
  ## the name track is necessary
  track <<- tracker()
  
  ## initialize the tracker
  track$init()
  
  ## inspect the function
  checkTrue( exists("bar"))
  
  ## res will collect the result of calling foo
  res <- inspect(bar(10), track=track)
  checkEquals( res, 5050)

  ## get the tracked function call info
  resTrack <- track$getTrackInfo()

  outDir <- tempdir()
  ##checkTrue( is.null(printHTML(resTrack, baseDir=outDir)))
  checkTrue( is.null(printHTML.trackInfo(resTrack, baseDir=outDir)))
  checkTrue( "index.html" %in% dir(file.path(outDir, "results")))
  
  inspect(foo(1:3), track=track)
  resTrack <- track$getTrackInfo()
  checkTrue( is.null(printHTML.trackInfo(resTrack, baseDir=outDir)))
  
  ##  error handling
  checkException(printHTML("notCorrectClass"))
  ##  baseDir
  checkException(printHTML(resTrack,  baseDir=logical(1)))
  checkException(printHTML(resTrack,  baseDir=character(0)))
  checkException(printHTML(resTrack,  baseDir=character(2)))
  checkException(printHTML(resTrack,  baseDir=as.character(NA)))
  
}
  
