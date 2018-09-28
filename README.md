# Experiments on Forth system design

## Lexeme translator mechanism

The "lexeme translator" comprises the "lexem resolver" and the "token translator".

It is an alternative design for "recognizers".
See [lexeme-translator/](https://github.com/ruv/forth-design-exp/tree/master/lexeme-translator) directory.



## Nota bene

Due to occacinaly history rewriting in this repository,
to fetch the updates
and **discard the local changes** (if any)
the following
[command](https://stackoverflow.com/questions/1125968/how-do-i-force-git-pull-to-overwrite-local-files)
can be used:


```shell
git fetch --all && git symbolic-ref HEAD refs/heads/master && git reset --hard origin/master
```
