if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then echo "Pull request"; exit 0; fi
if [ "$TRAVIS_BRANCH" != "source" ]; then echo "Not in source branch."; exit 0; fi

REPO="johanneswuerbach/johanneswuerbach.github.io"
TARGET_BRANCH="master"

echo -e "Starting to updating master.\n"
#copy data we're interested in to other place
cp -R dist $HOME/dist
#go to home and setup git
cd $HOME
git config --global user.email "travis@travis-ci.org"
git config --global user.name "Travis"
#using token clone target branch
git clone --quiet --branch=${TARGET_BRANCH} https://${GH_TOKEN}@github.com/${REPO}.git ${TARGET_BRANCH} > /dev/null
#go into diractory and copy data we're interested in to that directory
cd $TARGET_BRANCH
cp -Rf $HOME/dist/* .
#add, commit and push files
git add -f .
git commit -m "[ci skip] Travis build $TRAVIS_BUILD_NUMBER pushed to $TARGET_BRANCH"
git push -fq origin ${TARGET_BRANCH} > /dev/null
echo -e "Done magic with dist\n"