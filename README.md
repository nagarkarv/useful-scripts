# useful-scripts

Quick useful scripts

- scan-repo: The script scans a specified branch of a repository and finds a keyword to check if it was ever checked-in into the repository (e.g. AWS-SECRET-KEY). It generates a log file with the line that includes the keyword alomg with sha & committer. 

example usage: 
```
scan-repo AWS-SECRET-KEY my-project main
```
