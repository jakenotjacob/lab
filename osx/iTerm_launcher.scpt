-- Create an Automator Quick Action
-- And add this as the "Run Applescript" content
-- Then in Keyboard Shortcuts under Services>General
-- There should be the action you saved
-- Set a keybind and now you can launch iTerm anywhere

-- Note: The amount of steps to make this happen is
-- stupid. wtf osx.

if application "iTerm" is not running then
  activate application "iTerm"
else
  tell application "iTerm"
    create window with default profile
    activate
  end tell
end if

