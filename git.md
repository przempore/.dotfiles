So I wouldn't use git pull it'll create these odd commit chains with merge commits etc. Instead try to do the following...

    Ensure you have a remote pointing to the upstream `git remote add upstream git@github.com:KDAB/cxx-qt.git`
    Fetch the latest code in the remote `git fetch upstream`
    Now start interactively rebasing your commits onto the latest upstream commit `git rebase -i upstream/main`
    This will open in your normal editor `eg nano/vim` a view that lists each commit on a single line, ones with pick will be selected, you can choose fixup or squash to combine commits with the one above them, or drop will remove the commit. Note that it will also remove your merge commits
    When you save and close the editor git will then try to replay each commit, if there are conflicts you may need to resolve them and then do what git status says, usually resolve the conflict, some git add's then a git rebase --continue `also if everything goes horribly wrong in the rebase you can do git rebase --abort`
    Then finally you need to push the changes back to your branch and overwrite the existing branch so `git push --force-with-lease`

