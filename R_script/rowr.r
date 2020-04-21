
#' Row-Based Functions for R Objects
#'
#' Provides utilities which interact with all R objects as
#' if they were arranged in rows.  It allows more consistent and predictable
#' output to common functions, and generalizes a number of utility functions to
#' to be failsafe with any number and type of input objects.
#' @name rowr
#' @docType package
#' @importFrom methods as
NULL

#' Combine arbitrary data types, filling in missing rows.
#'
#' Robust alternative to \code{\link{cbind}} that fills missing values and works
#' on arbitrary data types.  Combines any number of R objects into a single matrix, with each input
#' corresponding to the greater of 1 or ncol.  \code{cbind} has counterintuitive
#' results when working with lists, cannot handle certain inputs of differing
#' length, and does not allow the fill to be specified.
#'
#' @param ... any number of R data objects
#' @param fill R object to fill empty rows in columns below the max size.  If unspecified, repeats input rows in the same way as \code{cbind}. Passed to \code{\link{buffer}}.
#' @export
#' @examples
#' cbind.fill(c(1,2,3),list(1,2,3),cbind(c(1,2,3)))
#' cbind.fill(rbind(1:2),rbind(3:4))
#'df<-data.frame(a=c(1,2,3),b=c(1,2,3))
#' cbind.fill(c(1,2,3),list(1,2,3),cbind(c('a','b')),'a',df)
#' cbind.fill(a=c(1,2,3),list(1,2,3),cbind(c('a','b')),'a',df,fill=NA)
cbind.fill<-function(...,fill=NULL)
  {
  inputs<-list(...)
  inputs<-lapply(inputs,vert)
  maxlength<-max(unlist(lapply(inputs,len)))
  bufferedInputs<-lapply(inputs,buffer,length.out=maxlength,fill,preserveClass=FALSE)
  return(Reduce(cbind.data.frame,bufferedInputs))
}

#'Allows row indexing without knowledge of dimensionality or class.
#'
#'@param data any \code{R} object
#'@param rownums indices of target rows
#'@export
#'@examples
#'rows(c('A','B','C'),c(1,3))
#'rows(list('A','B','C'),c(1,3))
#'df<-data.frame(a=c(1,2,3),b=c(1,2,3))
#'rows(df,3)
rows <- function(data,rownums)
  {
  #result<-data[rownums]
  if(is.null(dim(data)))
    {
    result<-data[rownums]
  }
  else
    {
    result<-data[rownums,]
  }
  #result<-ifelse(is.null(dim(data)),data[c(rownums)],data[c(rownums),])
  return((result))
}

#'Allows finding the 'length' without knowledge of dimensionality.
#'
#'@param data any \code{R} object
#'@export
#'@examples
#'len(list(1,2,3))
#'len(c(1,2,3,4))
#'df<-data.frame(a=c(1,2,3),b=c(1,2,3))
#'len(df)
len <- function(data)
  {
  result<-ifelse(is.null(nrow(data)),length(data),nrow(data))
  return(result)
}

#'A more versatile form of the T-SQL \code{count()} function.
#'
#'Implementation of T-SQL \code{count} and Excel \code{COUNTIF} functions.
#'Shows the total number of elements in any number of data objects altogether or
#'that match a condition.
#'
#'@param ... an arbitrary number of \code{R} objects
#'@param condition a 1 argument condition
#'@export
#'@examples
#'count(c(NA,1,2))
#'count(c(NA,1,2),is.na)
#'count(c(NA,1,2),list('A',4),cbind(1,2,3))
#'count(c(NA,1,2),list('A',4),cbind(1,2,3),condition=is.character)
count<-function(...,condition=(function (x) TRUE))
  {
  data<-c(...)
  result<-sum(sapply(data, function (x) if(condition(x)) 1 else 0))
  return(result)
}

#'Pads an object to a desired length, either with replicates of itself or another repeated object.
#'
#'@param x an R object
#'@param length.out the desired length of the final output
#'@param fill R object to fill empty rows in columns below the max size.  If unspecified, repeats input rows in the same way as \code{cbind}.
#'@param preserveClass determines whether to return an object of the same class as the original argument.  Otherwise, returns a matrix.
#'@export
#'@examples
#'buffer(c(1,2,3),20)
#'buffer(matrix(c(1,2,3,4),nrow=2),20)
#'buffer(list(1,2,3),20)
#'df<-data.frame(as.factor(c('Hello','Goodbye')),c(1,2))
#'buffer(df,5)
#'buffer((factor(x=c('Hello'))),5)
buffer<-function(x,length.out=len(x),fill=NULL,preserveClass=TRUE)
  {
  xclass<-class(x)
  input<-lapply(vert(x),unlist)
  results<-as.data.frame(lapply(input,rep,length.out=length.out))
  if(length.out>len(x) && !is.null(fill))
    {
    results<-t(results)
    results[(length(unlist(x))+1):length(unlist(results))]<-fill
    results<-t(results)
  }
  if(preserveClass)
    results<-as2(results,xclass)
  return(results)
}

vert<-function(object)
  {
  #result<-as.data.frame(cbind(as.matrix(object)))
  if(is.list(object))
    object<-cbind(object)
  object<-data.frame(object)

  return(object)
}
