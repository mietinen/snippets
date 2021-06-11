# Snippets

Sample of some random small scripts made over time for
* Doing small tasks on other computers
* Testing purposes
* General random stuff

Seems like a waste to keep deleting these. Could could come in handy later, either for me or other people.

### Usefull oneliners
```sh
# Unrar all files, one directory down
find . -maxdepth 2 -iname *.rar -execdir unrar x -o- {} \;

# Delete all files that exists in rar archives
for f in $(find . -type f -iname *.rar); do unrar vb "$f" | sed "s%^%$(dirname "$f")/%g"; done | sort -u | xargs rm

# Delete directories whose contents are less than 10KB
du -kd 1 | awk '$1 <= 10 {print $2}' | xargs rm -rf
```
