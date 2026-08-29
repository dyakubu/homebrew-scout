# homebrew-scout

Homebrew tap for [scout](https://github.com/dyakubu/scout), a local
semantic search CLI.

## Install

```
brew install dyakubu/scout/scout
```

## Updating the formula

After a new scout release is tagged and published on
[dyakubu/scout](https://github.com/dyakubu/scout/releases):

```
scripts/bump.py v0.1.0
git commit -am "scout v0.1.0"
git push
```
