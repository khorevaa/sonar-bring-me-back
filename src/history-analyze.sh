# script based on https://gist.github.com/aslakknutsen/2422117

GIT_REPO=/gitrepo
START_DATE=$1

MVN_COMMAND="mvn clean install"
SONAR_COMMAND="mvn org.codehaus.sonar:sonar-maven3-plugin:3.3.0.603:sonar"

if [ -z "$START_DATE" ]; then
    echo "Missing program argument: start-date"
    echo "Analyze wil start from first commit of branch"
fi

pushd $GIT_REPO



popd
