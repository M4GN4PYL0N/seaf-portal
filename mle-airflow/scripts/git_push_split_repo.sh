#!/bin/bash

NOW=$( date '+%F_%H:%M:%S' )

SOURCE_DIR=$1
GIT_PROJECT=$2
GIT_BRANCH=$3
GIT_USER=$4
GIT_TOKEN=$5
GIT_CLONE=$6
GIT_USER_EMAIL=$7
GIT_USER_NAME=$8

echo "[DEBUG] - Folder is $SOURCE_DIR Project is $GIT_PROJECT Branch is $GIT_BRANCH Output dir $SOURCE_DIR/$GIT_PROJECT"
echo "[DEBUG] - User $GIT_USER with $GIT_TOKEN will do clone $GIT_CLONE"
pwd
ls -la $SOURCE_DIR

rm -r --force --interactive=never $GIT_PROJECT


echo "[DEBUG] - Git -c http.sslVerify=false clone https://$GIT_USER:$GIT_TOKEN@$GIT_CLONE -b $GIT_BRANCH ./$GIT_PROJECT"
git -c http.sslVerify=false clone https://$GIT_USER:$GIT_TOKEN@$GIT_CLONE -b $GIT_BRANCH ./$GIT_PROJECT

echo "[DEBUG] - cp -v -r -f $SOURCE_DIR/*.yaml ./$GIT_PROJECT"
cp -v -r -f $SOURCE_DIR/*.yaml ./$GIT_PROJECT

cd ./$GIT_BRANCH
echo "[DEBUG] - git config settings"
git config http.sslVerify "false"
git config user.email $GIT_USER_EMAIL
git config user.name $GIT_USER_NAME
git branch
ls -la
echo "[DEBUG] - git add --all"
git add --all
echo "[DEBUG] - git commit -m"
git commit -m "airflow commit "$NOW
echo "[DEBUG] - git push"
git -c http.sslVerify=false push origin

#echo "# Проверяем статус ветки"
#echo "git_status=$(git status --branch)"
#git_status=$(git status --branch)
#echo "# Ищем строку с информацией о ветке"
#if grep -q "Your branch is up to date" <<< "$git_status"; then
#    echo "Your branch is up to date with $GIT_BRANCH"
#else
#    echo "Your branch $GIT_BRANCH is not up to date or there was an error."
#fi
#echo "# Получаем разницу между двумя последними коммитами"
#
#echo "git diff HEAD~2 HEAD~ | python3 /scripts/format_diff.py"
#git diff HEAD~2 HEAD~ | python3 /scripts/format_diff.py

cd ..
echo "[DEBUG] - cleanup rm -r --force --interactive=never $GIT_PROJECT"
rm -r --force --interactive=never $GIT_PROJECT

#echo "[DEBUG] - python3 /scripts/do_mail.py"
#python3 /scripts/do_mail.py
#echo "[DEBUG] - *** EOF ***"
