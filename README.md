## Analyze git repo with SonarQube 

simply run:

* install docker
* clone the your repo
* checkout branch from `origin/some-branch`
* run  `sonar-history.sh <git-branch> <start-date>`

notes: 

* if you are on windows - please install msgit with `unix` tools and run `sonar-history.bat`
* dont forget fill sonar-project.proper in your project

### For what

* if you start use SonarQube for your git repo yo may want to load your tech debt from first commit to current date

### How to

for that we need to do some steps

* get the git history
* checkout each revision
* analyze it with sonar-runner with changed project date
* push analyze to sonar server

### Tech info

* we use an docker image with jdk8, maven and sonar - see official maven image https://hub.docker.com/_/maven/
* we use additional parameter `-Dsonar.projectDate=` to bring you in history


## Useful link

* simple example by tags https://gist.github.com/aslakknutsen/2422117
* official docs for scanner https://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner
* advanced usage of sonar scaner https://docs.sonarqube.org/display/SCAN/Advanced+SonarQube+Scanner+Usages
