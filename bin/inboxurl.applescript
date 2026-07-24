-- InboxURL: save the frontmost browser's current tab to Reminders > Inbox
-- Used two ways:
--   1. `inboxurl` from the terminal
--   2. pasted into a Shortcuts "Run AppleScript" action bound to a global hotkey
on run
	set theURL to ""
	set theTitle to ""

	tell application "System Events" to set frontApp to name of first process whose frontmost is true

	if frontApp is "Google Chrome" then
		tell application "Google Chrome"
			set theURL to URL of active tab of front window
			set theTitle to title of active tab of front window
		end tell
	else if frontApp is "Safari" then
		tell application "Safari"
			set theURL to URL of front document
			set theTitle to name of front document
		end tell
	else
		-- not in a browser: fall back to whichever browser has an open window
		try
			tell application "Safari"
				set theURL to URL of front document
				set theTitle to name of front document
			end tell
		on error
			tell application "Google Chrome"
				set theURL to URL of active tab of front window
				set theTitle to title of active tab of front window
			end tell
		end try
	end if

	if theURL is "" or theURL is missing value then error "No URL found"
	if theTitle is "" or theTitle is missing value then set theTitle to theURL

	tell application "Reminders"
		tell list "Inbox"
			make new reminder with properties {name:theTitle, body:theURL}
		end tell
	end tell

	return theTitle
end run
