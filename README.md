# TCT
Tom's Copy Tool

## History
This is TCT which stands for Tom's Copy Tool.  For years I have had issues where  copy, paste and cut would not work from some tools to another.  One day I realized that AutoIT could make a tool to emulate keyboard typing.  This tool will send everything in the text window to the application selected.

There are two new features with this new version of TCT. The first feature will allow the speed at which the text is typed into the target to change by setting the millisecond delay between each key typed.  The second feature will allow the text to be switched from RAW to Extended text. 

If raw option is checked this tool will type text as seen.  If raw option is unchecked, then non alpha numeric characters are converted to keyboard functions.

## Details

'!'  
Adding an exclamation point before text tells TCT to send an ALT keystroke, therefore ("This is text!a") would send the keys "This is text" and then press "ALT + a".

Some programs are very choosy about capital letters and ALT keys, i.e., "!A" is different from "!a". The first says ALT+SHIFT+A, the second is ALT+a. If in doubt, use lowercase!

'+'  
Adding a plus symbol before text tells TCT to send a SHIFT keystroke; therefore, ("Hell+o") would send the text "HellO". ("!+a") would send "ALT + SHIFT + a".
 
'^'  
Adding a caret before text tells TCT to send a CONTROL keystroke; therefore, ("^!a") would send "CTRL+ALT+a".

Some programs are very choosy about capital letters and CTRL keys, i.e., "^A" is different from "^a". The first says CTRL+SHIFT+A, the second is CTRL+a. If in doubt, use lowercase!
 
'#'  
The hash sends a Windows keystroke; therefore, ("#r") would send Win+r which launches the Run() dialog box.

Other options are listed below if Raw uncheck.

|Send Command | Resulting Keypress|
|-------------|-----------------------|
{!} |        !  
{#} |        #
{+} |        +
{^} |        ^
{{} |        {
{}} |        }
{SPACE} |    SPACE
{ENTER} |    ENTER key on the main keyboard
{ALT} |        ALT
{BACKSPACE} or {BS} | BACKSPACE
{DELETE} or {DEL}   | DELETE
{UP} |        Up arrow
{DOWN} |    Down arrow
{LEFT} |    Left arrow
{RIGHT} |    Right arrow
{HOME} |HOME
{END} |END
{ESCAPE} or {ESC} |ESCAPE
{INSERT} or {INS} |INS
{PGUP} |PGUP
{PGDN} |PGDN
{F1} - {F12} |Function keys
{TAB} |TAB
{PRINTSCREEN} |PRINTSCR
{LWIN} |Left Windows key
{RWIN} |Right Windows key
{NUMLOCK} |NUMLOCK
{CAPSLOCK} |CAPSLOCK
{SCROLLLOCK} |SCROLLLOCK
{BREAK} |for Ctrl+Break processing
{PAUSE} |PAUSE
{NUMPAD0} - {NUMPAD9} |Numpad digits
{NUMPADMULT} |Numpad Multiply
{NUMPADADD} |Numpad Add
{NUMPADSUB} |Numpad Subtract
{NUMPADDIV} |Numpad Divide
{NUMPADDOT} |Numpad period
{NUMPADENTER} |Enter key on the numpad
{APPSKEY} |Windows App key
{LALT} |Left ALT key
{RALT} |Right ALT key
{LCTRL} |Left CTRL key
{RCTRL} |Right CTRL key
{LSHIFT} |Left Shift key
{RSHIFT} |Right Shift key
{SLEEP} |Computer SLEEP key
{ALTDOWN} |Holds the ALT key down until {ALTUP} is sent
{SHIFTDOWN} |Holds the SHIFT key down until {SHIFTUP} is sent
{CTRLDOWN} |Holds the CTRL key down until {CTRLUP} is sent
{LWINDOWN} |Holds the left Windows key down until {LWINUP} is sent
{RWINDOWN} |Holds the right Windows key down until {RWINUP} is sent
{ASC nnnn} |Send the ALT+nnnn key combination
