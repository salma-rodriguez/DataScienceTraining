makeCacheMatrix <- function(mat = matrix()) {
        sol <- NULL
        set <- function(x) {
                mat <<- x
                sol <<- NULL
        }
        get <- function() mat
        setsolve <- function(s) sol <<- s
        getsolve <- function( ) sol
        list(
                set = set,
                get = get, 
                setsolve = setsolve, 
                getsolve = getsolve
        )
}

cacheSolve <- function(x, ...) {
        sol <- x$getsolve()
        if (!is.null(sol)) {
                return(sol)
        }
        data <- x$get()
        sol <- solve(data, ...)
        x$setsolve(sol)
        sol
}
