-- Create an Automator Quick Action
-- And add this as the "Run Applescript" content
-- Then in Keyboard Shortcuts under Services>General
-- There should be the action you saved
-- Set a keybind and now you can launch iTerm anywhere

-- Note: The amount of steps to make this happen is
-- stupid. wtf osx.

--De-select currently focused application first, otherwise
--it assumes the focused (activated) app needs access to iTerm...
--...also avoided by 'Secure Keyboard Entry' setting

--If not running, open iTerm, if running, select it
activate application "iTerm"
  tell application "iTerm"
    create window with default profile
    activate
  end tell
end if

