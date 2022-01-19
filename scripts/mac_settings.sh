#!/bin/bash

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'
# Ask for the administrator password upfront
sudo -v
# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# Trackpad, mouse, and keyboard                                               #
###############################################################################
echo "Changing Trackpad, mouse, and keyboard settings"
# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1.5
defaults write NSGlobalDomain InitialKeyRepeat -int 20
# Disable “natural” (Lion-style) scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

###############################################################################
# Finder                                                                      #
###############################################################################
echo "Changing Finder settings"
# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true
# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

###############################################################################
# Dock                                                                      #
###############################################################################
echo "Changing dock settings"
# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

###############################################################################
# Display                                                                     #
###############################################################################
echo "Setting dark mode"
# Set dark mode
osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to not dark mode'

echo "Done. Note that some of these changes require a logout/restart to take effect."
