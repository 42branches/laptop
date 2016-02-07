#!/bin/sh
source 'script/functions.sh'

fancy_echo "Please launch the Mac App Store app and ensure you are logged in ..."
fancy_echo "<enter to continue>"
read

fancy_echo "In order to script the App Store you need to add Terminal / iTerm to"
fancy_echo "System Preferences > Security & Privacy > Privacy > Accessibility"

osascript -e 'tell app "System Events" to windows of process "SystemUIServer"' 2>/dev/null
osascript -e 'tell app "System Preferences" to activate' 2>/dev/null
osascript -e 'tell app "System Preferences" to tell pane id "com.apple.preference.security"' 2>/dev/null

fancy_echo "<enter to continue>"
read

while IFS='' read -r line || [[ -n "$line" ]]; do
    IFS='|' read -r name location <<< "$line"
    app=$(fancy_echo $location | sed -e 's/^[ \t]*//')
    
    fancy_echo "Installing $name from Mac App Store ..."
    open "$app" 2>/dev/null
    
    sleep 5s
    
    osascript -e 'tell app "System Events" to click button 1 of group 1 of group 1 of UI element 1 of scroll area 1 of group 1 of group 1 of window "App Store" of application process "App Store"' 2>/dev/null
    
    sleep 10s
    
done < appstore/Apps | grep -v "#"

fancy_echo "All done!"
