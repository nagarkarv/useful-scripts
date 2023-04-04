# Usage: scan-repo.sh <search keyword> <git repo folder> <branch to scan>
# $1 Keyword to search
# $2 Folder
# $3 Branch to verify
keyword=$1
projectFolder=$2
branch=$3  
#get all commits on branch
cd ./$projectFolder
echo "Checking for Key: $keyword for project: $projectFolder in branch: $branch" >> ../$projectFolder-$branch-results.log
git checkout $branch
git log --reverse --pretty=format:"%h,%an,%ae,%cd" > ../$projectFolder-$branch-branch.csv
while IFS= read -r shaLine; do
    commitSha=$(echo $shaLine | cut -d, -f1)
    authorEmail=$(echo $shaLine | cut -d, -f3)
    commitDate=$(echo $shaLine | cut -d, -f4)
    echo "Checking Commit = $commitSha"
    git checkout $commitSha
    #get changed file list    
    git diff-tree --no-commit-id --name-only -r $commitSha > ../$projectFolder-$branch-changedFiles.txt
    while IFS= read -r fileName; do
        result=$(cat $fileName | grep $keyword)
        if [[ -n "$result" ]]; then
            echo "FOUND: Date:$commitDate:$fileName:$commitSha:$result:$authorEmail" >> ../$projectFolder-$branch-results.log
        fi
    done < ../$projectFolder-$branch-changedFiles.txt
done < ../$projectFolder-$branch-branch.csv
git checkout $branch
cd ..
echo "Results avaliable in file: $projectFolder-$branch-results.log"