CURDIR=$1

# in Windows there sh.exe does not provide correct path for docker
if [ -z "$1" ]; then
    CURDIR=$PWD
fi

docker run -it --env-file=.env --rm -v "$CURDIR":/gitrepo \
    silverbulleters/sonar-history-runner 
