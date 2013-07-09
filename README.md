# These are my dotfiles.

To deploy in current directory run:

```
git clone https://github.com/PonderingGrower/dotfiles.git ./
```

then update vim plugins:

```
git submodule init
git submodule update
git submodule foreach git submodule init
git submodule foreach git submodule update
```
Or just use this script:
```
bin/vplugupdate
```
