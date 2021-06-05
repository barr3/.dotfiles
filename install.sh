emacs --daemon


#Removes all current files before running script
rm ~/.emacs.d/init.el
rm ~/.bashrc
rm ~/.profile

#Tangles all the org-files for the configurations.
emacsclient -e '(org-babel-tangle-file "~/.dotfiles/.emacs.d/Emacs.org")' 
emacsclient -e '(org-babel-tangle-file "~/.dotfiles/Bashrc.org")' 
emacsclient -e '(org-babel-tangle-file "~/.dotfiles/Profile.org")'

#Creates symlinks for all files to their respective places.

ln -s ~/.dotfiles/.emacs.d/init.el ~/.emacs.d/init.el
ln -s ~/.dotfiles/.bashrc ~/.bashrc
ln -s ~/.dotfiles/Profile.shell ~/.profile
