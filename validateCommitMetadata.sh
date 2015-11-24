#!/bin/bash

echo "starting \'build\'"

git status > status.txt
statusGrep=$(grep "HEAD detached" status.txt)
echo "statusGrep = $statusGrep"

commitHash=${statusGrep:17}
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

echo "Checking approval"
if [ "$authorName" == "$approvedByName" ]
then
  echo "Can't have author be the approver!"
  exit 1;
else
    echo "approver is not author"
fi

if [ "$approvedByName" == "NONE" ]
then
  echo "Commit needs to be approved!"
  exit 1;
else
  echo "all meta checks passed!"
  exit 0;
fi
