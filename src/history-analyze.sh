# script based on https://gist.github.com/aslakknutsen/2422117

GIT_REPO=/gitrepo
START_DATE=$1

MVN_COMMAND="mvn clean install"
SONAR_COMMAND="mvn org.codehaus.sonar:sonar-maven3-plugin:3.3.0.603:sonar"

if [ -z "$START_DATE" ]; then
    echo "Missing program argument: start-date"
    echo "Analyze wil start from first commit of branch"
fi

if git rev-parse --git-dir > /dev/null 2>&1; then
  echo "starting checkout history of git repo"
else
  echo "you didnot provide correct git repo"
  exit 42 # "why 42 ? please googl it as an answer"
fi

pushd $GIT_REPO
for hash in `git --no-pager log --reverse --pretty=format:%s`
do
    HASH_DATE=`git show $hash --date=iso | grep Date: -m1 | cut -d' ' -f 4`
    
    echo "Checking out source from $HASH_DATE with as $hash"
    git checkout $hash  > /dev/null 2>&1
    git clean -df > /dev/null 2>&1

    SONAR_PROJECT_COMMAND="$SONAR_COMMAND -Dsonar.projectDate=$HASH_DATE"

    echo "Executing Maven: $MVN_COMMAND"
    $MVN_COMMAND > /dev/null 2>&1
    echo "Executing Sonar: $SONAR_PROJECT_COMMAND"
    $SONAR_PROJECT_COMMAND > /dev/null 2>&1
done
popd
