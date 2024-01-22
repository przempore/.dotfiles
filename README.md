# .dotfiles

To apply configs, git clone this repository to your $HOME directory and use [stow](https://www.gnu.org/software/stow/):
For example to apply `nvim` config run
```
cd ~/.dotfiles
stow nvim
```
In case there are already config files in your $HOME directory, run the following:
```
cd ~/.dotfiles
stow --adopt nvim
```
which will create symlinks to the config files but not change them, so to make the change there is need to restore changed files in `.ditfiles` repository.
```
cd ~/.dotfiles
git checkout -- .
```

-------------

Set [git origin](https://gist.github.com/m14t/3056747#gistcomment-1372842) to `ssh` from `https`:
```
git remote set-url origin git@github.com:username/repo-name-here.git
```

-------------
## git worktree

fetching data

[source](https://morgan.cugerone.com/blog/workarounds-to-git-worktree-using-bare-repository-and-cannot-fetch-remote-branches/)

```
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
```

[stacoverflow](https://stackoverflow.com/a/25941875)

```bash
$ git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
$ git config --get remote.origin.fetch
+refs/heads/*:refs/remotes/origin/*
```


## git rebase
```
git rebase -i HEAD~<n>
```
[source](https://medium.com/@slamflipstrom/a-beginners-guide-to-squashing-commits-with-git-rebase-8185cf6e62ec)


So I wouldn't use git pull it'll create these odd commit chains with merge commits etc. Instead try to do the following...

    Ensure you have a remote pointing to the upstream `git remote add upstream git@github.com:KDAB/cxx-qt.git`
    Fetch the latest code in the remote `git fetch upstream`
    Now start interactively rebasing your commits onto the latest upstream commit `git rebase -i upstream/main`
    This will open in your normal editor `eg nano/vim` a view that lists each commit on a single line, ones with pick will be selected, you can choose fixup or squash to combine commits with the one above them, or drop will remove the commit. Note that it will also remove your merge commits
    When you save and close the editor git will then try to replay each commit, if there are conflicts you may need to resolve them and then do what git status says, usually resolve the conflict, some git add's then a git rebase --continue `also if everything goes horribly wrong in the rebase you can do git rebase --abort`
    Then finally you need to push the changes back to your branch and overwrite the existing branch so `git push --force-with-lease`


-------------
## udisk - manually mount removable disks
```
udisksctl mount -b /dev/sda1
```
to unmount:
```
udisksctl unmount -b /dev/sda1
```
[source](https://wiki.archlinux.org/title/Udisks#Installation)

## detach/reattach laptops keyboard:

list input sources:</br>
`xinput list`

locate `AT Translated Set 2 keyboard` note `id` and `slave keyboard (*)` value</br>
disable keyboard:<vbr>
`xinput float 11`

reenable keyboard:</br>
`xinput reattach 11 3`

[source](https://askubuntu.com/a/178741)

