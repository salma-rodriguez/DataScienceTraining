## General Description

## These functions compute and cache the inverse
## of a matrix, allowing re-entrant access to the value.

## @makeCacheMatrix: define x, it's setters, and getters

## x is the R object we want to work with.
## x is coerced to a "matrix" class by default. The value
## can be set and retrieved from the defining environment
## and will remain allocated in the cache after returning
## from makeCacheMatrix, or one of the list functions
## defined therein.

## @return: Here's a summary of the functions returned in
## the list created by makeCacheMatrix:

## @set: sets the value of x
## @get: gets the value of x
## @setsolve: sets the solution 'sol' for the  inverse of
##            x
## @getsolve: gets the solution 'sol' for the  inverse of
##            x

makeCacheMatrix <- function(x = matrix()) {
        sol <- NULL
        set <- function(y) {
                x <<- y
                sol <<- NULL
        }
        get <- function() x
        setsolve <- function(s) sol <<- s
        getsolve <- function( ) sol
        list(
                set = set,
                get = get, 
                setsolve = setsolve, 
                getsolve = getsolve
        )
}

## @cacheSolve: cache the value of a matrix inverse

## x is the  list of matrix  functions that are  accessed
## while computing and caching the inverse of a matrix

## @return: the cached solution 'sol' for the  inverse of
##          the cached matrix, or the computed inverse if 
##          the solution is not cached already

cacheSolve <- function(x, ...) {
        sol <- x$getsolve()
        if (!is.null(sol)) {
                return(sol)
        }
        y <- x$get()
        sol <- solve(y, ...)
        x$setsolve(sol)
        ## Return a matrix that is the inverse of 'y'
        sol
}
