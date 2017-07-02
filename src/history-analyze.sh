#!/bin/bash

# script based on https://gist.github.com/aslakknutsen/2422117

GIT_REPO=/gitrepo
#START_DATE=$1 //TODO i want all history, but some reason it seem to useful

ls -al /gitrepo
git --version

#MVN_COMMAND="mvn clean install"
#SONAR_COMMAND="mvn org.codehaus.sonar:sonar-maven3-plugin:3.3.0.603:sonar"
SONAR_COMMAND="sonar-scanner"

if [ -z "$START_DATE" ]; then
    echo "Missing program argument: start-date"
    echo "Analyze wil start from first commit of branch"
fi

if [ -z "$SONAR_TOKEN" ]; then
    echo "You need to provide auth for your instanse"
else
   AUTH="-Dsonar.login=$SONAR_TOKEN"
fi 

if git rev-parse --git-dir > /dev/null 2>&1; then
  echo "starting checkout history of git repo"
else
  echo "you didnot provide correct git repo"
  exit 42 # "why 42 ? please googl it as an answer"
fi

cp -ar /gitrepo /tmp/gitrepo
cp /gitrepo/sonar-project.properties /tmp/sonar-project.properties || \
  { echo "You need to create sonar-projects.properties file"; exit 42;}

dos2unix /tmp/sonar-project.properties

pushd /tmp/gitrepo

git clean -df

for hash in `git --no-pager log --reverse --pretty=format:%h`
do
    #T03:00:00+0300
    HASH_DATE=`git show $hash --date=iso | grep Date: -m1 | cut -d' ' -f 4`
    HASH_TIME=`git show $hash --date=iso | grep Date: -m1 | cut -d' ' -f 5`

    TIMESTAM=`grep sonar.projectVersion /tmp/sonar-project.properties | cut -d'=' -f 2`

    echo "Checking out source $HASH_DATE with as $hash on $TIMESTAM-$HASH_TIME"

    git reset --hard $hash > /dev/null 2>&1

    # finaly copy last sonar-project.properties
    cp /tmp/sonar-project.properties ./sonar-project.properties

    # this will not working on latest git
    # see https://stackoverflow.com/questions/4114095/how-to-revert-git-repository-to-a-previous-commit
    #git checkout $hash  > /dev/null 2>&1
    #git clean -df > /dev/null 2>&1

    STATUS=`git show --oneline -s`
    echo $STATUS

    SONAR_PROJECT_COMMAND="$SONAR_COMMAND -Dsonar.projectDate=$HASH_DATE -Dsonar.host.url=$SONAR_SERVER_URL $AUTH -Dsonar.projectVersion=$TIMESTAM-$HASH_TIME"

    #echo "Executing Maven: $MVN_COMMAND"
    #$MVN_COMMAND > /dev/null 2>&1
    echo "Executing Sonar: $SONAR_PROJECT_COMMAND"
    #$SONAR_PROJECT_COMMAND || exit 42 #> /dev/null 2>&1
    $SONAR_PROJECT_COMMAND > /dev/null 2>&1
done
popd
