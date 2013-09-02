# These are my dotfiles.

To deploy in directory `dotfiles` run:

```
git clone https://github.com/PonderingGrower/dotfiles.git ./dotfiles
```

Then you can link folders and files you want to use.

It's necessary to update vim plugins with:

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
