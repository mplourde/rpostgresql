## escape test
##
## this tests for proper escaping of SQL special characters
##
## Assumes that
##  a) PostgreSQL is running, and
##  b) the current user can connect
## both of which are not viable for release but suitable while we test
##
## Dirk Eddelbuettel, 03 Oct 2009

## only run this if this env.var is set correctly
if (Sys.getenv("POSTGRES_USER") != "" & Sys.getenv("POSTGRES_HOST") != "" & Sys.getenv("POSTGRES_DATABASE") != "") {

    ## try to load our module and abort if this fails
    stopifnot(require(RPostgreSQL))
    stopifnot(require(datasets))

    ## load the PostgresSQL driver
    drv <- dbDriver("PostgreSQL")

    ## connect to the default db -- replacing any of these with NULL will lead to
    ## a stop() call and a return to the R prompt rather than a segfault
    con <- dbConnect(drv,
                     user=Sys.getenv("POSTGRES_USER"),
                     password=Sys.getenv("POSTGRES_PASSWD"),
                     host=Sys.getenv("POSTGRES_HOST"),
                     dbname=Sys.getenv("POSTGRES_DATABASE"),
                     port=ifelse((p<-Sys.getenv("POSTGRES_PORT"))!="", p, 5432))
    
    cat("Note the appropriate string may differ upon server setting and connection state.\n")
    st <- (postgresqlEscapeStrings(con,"aaa"))
    print(st)
    st2 <- (postgresqlEscapeStrings(con,"aa'a"))
    print(st2)
    dbGetQuery(con, "set standard_conforming_strings to 'on'")
    st3 <- (postgresqlEscapeStrings(con,"aa\\a"))
    print(st3)
    dbGetQuery(con, "set standard_conforming_strings to 'off'")
    st4 <- (postgresqlEscapeStrings(con,"aa\\a"))
    print(st4)

    ## and disconnect
    dbDisconnect(con)
}else{
    cat("Skip.\n")
}
