#!/bin/bash

echo "starting commit validation"
echo "the build passed, checking whether it's safe to merge"

git status > status.txt
statusGrep=$(grep "HEAD detached" status.txt)
echo "statusGrep = $statusGrep"

commitHash=${statusGrep:19}
echo $commitHash

git show $commitHash > commitShow.txt

tested=$(grep "Tested?" commitShow.txt);
author=$(grep "Author" commitShow.txt);
approvedBy=$(grep "Approved" commitShow.txt);

testedStatus=${tested:14}

author=${author:8}
authorName=${author%<*>}
approvedByName=${approvedBy:18}

echo "Checking status of test"
if [ "$testedStatus" != YES ]
then
  echo "UNTESTED!"
  exit 1
else
  echo "Has been tested!"
fi

echo "Checking approval existence"
if [ "$approvedByName" == "NONE" ]
then
  echo "Commit needs to be approved!"
  exit 1;
fi

echo "Checking approval"
if [ "$authorName" == "$approvedByName" ]
then
  echo "Can't have author be the approver!"
  exit 1;
else
    echo "Good, approver is not author"
fi

echo "All validation checks passed!"
echo "This commit is now allowed to be merged into master!"

