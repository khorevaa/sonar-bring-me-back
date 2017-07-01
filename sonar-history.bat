set CURPWD=%cd%
set CURPWD=%CURPWD:\=/%

sh -c "./sonar-history.sh %CURPWD%"
