#cs ----------------------------------------------------------------------------

    AutoIt Version: 3.3.14.5
    Author:         Tom Margrave   Jumphopper@gmail.com

    Script Function:  This is use to replace copy and paste when app will not let
		user to paste into it.  For example RDP and VNC.

#ce ----------------------------------------------------------------------------

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
	#AutoIt3Wrapper_Outfile=..\Exe\TCT.exe
	#AutoIt3Wrapper_Outfile_x64=..\Exe\TCT-64.exe
	#AutoIt3Wrapper_Compression=4
	#AutoIt3Wrapper_Compile_Both=y
	#AutoIt3Wrapper_UseX64=y
	#AutoIt3Wrapper_Res_Comment=This is to replace copy and paste when app will not let user to paste into it.  For example RDP and VNC.
	#AutoIt3Wrapper_Res_Description=Tom's Copy Tool
	#AutoIt3Wrapper_Res_Fileversion=2.96.0.12
	#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
	#AutoIt3Wrapper_Res_ProductName=Tom's Copy Tool
	#AutoIt3Wrapper_Res_ProductVersion=2.96
	#AutoIt3Wrapper_Res_CompanyName=Tom Margrave
	#AutoIt3Wrapper_Run_After=copy "%out%"       "C:\Users\Tom Margrave\Google Drive\TCT\Exe"
	#AutoIt3Wrapper_Run_After=copy "%outx64%"  "C:\Users\Tom Margrave\Google Drive\TCT\Exe"
	#AutoIt3Wrapper_Run_Tidy=y
	#Tidy_Parameters=/rel /reel /ri /sfc
	#AutoIt3Wrapper_Run_Au3Stripper=y
	#Au3Stripper_Parameters=/TraceLog
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#Region ; Includes

	; *** Start added by AutoIt3Wrapper ***
	#include <StructureConstants.au3>
	; *** End added by AutoIt3Wrapper ***

	#include <MsgBoxConstants.au3>
	#include <AutoItConstants.au3>
	;GUI
	#include <ButtonConstants.au3>
	#include <ComboConstants.au3>
	#include <EditConstants.au3>
	#include <GUIConstantsEx.au3>
	#include <WindowsConstants.au3>

	; For list of windows.
	#include <Array.au3>

	;Find app
	#include <WinAPI.au3>
	#include <Misc.au3>
#EndRegion ; Includes

#Region ; Autoit options
	Opt("SendKeyDelay", 50)
	Opt("GUIResizeMode", $GUI_DOCKAUTO + $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM)
#EndRegion ; Autoit options

;turn off
Global $EnableESC = 0

;Set up hot key cancel
HotKeySet("{ESC}", "QuitApp") ;Press ESC key to quit

#Region ### START Koda GUI section ### Form=C:\Users\Tom Margrave\Desktop\autoit\Forms\TCT.kxf
	$ver = FileGetVersion(@ScriptFullPath)
	$product = "Tom's Copy Tool " & $ver

	;Menu
	$fMAIN = GUICreate($product, 352, 206, 203, 152, BitOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX, $WS_THICKFRAME, $DS_MODALFRAME))
	$Menu_File = GUICtrlCreateMenu("&File")
	$mi_Exit = GUICtrlCreateMenuItem("&Exit", $Menu_File)
	$MenuItem1 = GUICtrlCreateMenu("&Options")
	$mi_AdjustSpeed = GUICtrlCreateMenuItem("Adjust &speed type", $MenuItem1)
	$mi_Raw = GUICtrlCreateMenuItem("Raw Type", $MenuItem1)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$miConvertCRLF = GUICtrlCreateMenuItem("Suppress CRLF", $MenuItem1)
	GUICtrlSetState($miConvertCRLF, $GUI_DISABLE)

	$MenuItem4 = GUICtrlCreateMenu("&Help")
	$mi_Help = GUICtrlCreateMenuItem("Help", $MenuItem4)
	$mi_About = GUICtrlCreateMenuItem("About", $MenuItem4)

	;GUI
	$Edit1 = GUICtrlCreateEdit("Text", 8, 34, 329, 113, $ES_WANTRETURN)
	GUICtrlSetData(-1, "This tool will type whatever you put here.")
	GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM)
	$Button1 = GUICtrlCreateButton("Go", 8, 152, 81, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	$Button2 = GUICtrlCreateButton("Clear - Paste", 96, 152, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	$Button4 = GUICtrlCreateButton("Clear", 176, 152, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	$Button5 = GUICtrlCreateButton("Close", 256, 152, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	$Send2App = GUICtrlCreateInput("Select App      ----->>>>", 8, 8, 300, 25, $ES_READONLY)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
	$SelectApp = GUICtrlCreateButton("...", 308, 8, 30, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH + $GUI_DOCKTOP)

	GUISetState(@SW_SHOW)

#EndRegion ### END Koda GUI section ###

disableControls(0)

$myHWND = WinGetHandle($product, "")
$Raw_flag = 0

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg

		Case $GUI_EVENT_CLOSE
			Global $EnableESC = 1
			$nothing = QuitApp

		Case $Button1  ;GO
			$myText = GUICtrlRead($Edit1)
			;GUISetState(@SW_HIDE)
			;doWait()
			doType($myText)
			;GUISetState(@SW_SHOW)

		Case $Button2 ;Clear and Paste
			$myText = ClipGet()
			GUICtrlSetData($Edit1, $myText)

		Case $Button4   ;Clear
			GUICtrlSetData($Edit1, "")

		Case $Button5 ;Cancel
			Global $EnableESC = 1
			$nothing = QuitApp()

		Case $mi_Exit ; menu Exit
			$nothing = QuitApp

		Case $mi_AdjustSpeed ; Addjust speed
			;todo
			AdjustSpeed()

		Case $mi_Raw     ; RAW Mode
			ProcessRaw()

		Case $miConvertCRLF
			ProcessCRLF()

		Case $SelectApp
			$hWin = GetAPP()

		Case $mi_About ;
			showAbout()

		Case $mi_Help
			myHelp()
	EndSwitch
WEnd

Func AdjustSpeed()
	Local $sAnswer = InputBox("Question", "What speed do you want to use?", 5, "", -1, -1, 0, 0)
	Opt("SendKeyDelay", $sAnswer)
	setMainFocus()

EndFunc   ;==>AdjustSpeed

Func disableControls($myBool)
	If $myBool <> 1 Then
		$myState = $GUI_DISABLE
	Else
		$myState = @SW_DISABLE
	EndIf

	GUICtrlSetState($Edit1, $myState)
	GUICtrlSetState($Button1, $myState)
	GUICtrlSetState($Button2, $myState)
	GUICtrlSetState($Button4, $myState)
	setMainFocus()
EndFunc   ;==>disableControls

Func doType($myText)
	;find active Window
	$title = WinGetTitle($hWin)

	;set send to active window
	SendKeepActive($title)
	; send keys
	If BitAND(GUICtrlRead($mi_Raw), $GUI_UNCHECKED) Then
		$Raw_flag = $SEND_DEFAULT
		$myType = StringReplace($myText, @CRLF, "{ENTER}")
	Else
		$Raw_flag = $SEND_RAW
		$myType = StringReplace($myText, @CRLF, @CR)
	EndIf
	;$myText = StringStripWS($myText, 3)
	Send($myType, $Raw_flag)
	setMainFocus()
EndFunc   ;==>doType

Func doWait()
	MsgBox($MB_APPLMODAL, "TCT Notice", "Position Cursor in " & @CRLF & "area to send text", 0, $myHWND)
EndFunc   ;==>doWait

Func GetAPP()
	SplashTextOn("TCT Select App", " " & _
			"Hover the pointer over the application you want to send text to. " & _
			"If you need the text in a specific location, click the application " & _
			"to position the cursor." & @CRLF & @CRLF & _
			"Then press escape to select the application.", 300, 200, -1, -1, -1, "", 14, 500)

	$EnableESC = 0
	Local $stPoint = DllStructCreate($tagPOINT), $aPos, $hControl, $hWin, $aLastPos[2] = [-1, -1], $sLastStr = '', $sStr

	While Not _IsPressed('1B')
		$aPos = MouseGetPos()
		If $aPos[0] <> $aLastPos[0] Or $aPos[1] <> $aLastPos[1] Then
			DllStructSetData($stPoint, 1, $aPos[0])
			DllStructSetData($stPoint, 2, $aPos[1])
			$hControl = _WinAPI_WindowFromPoint($stPoint)
			$hWin = _WinAPI_GetAncestor($hControl, 2)
			$sStr = 'Select Window : ' & WinGetTitle($hWin)
			If $sLastStr <> $sStr Then
				ToolTip($sStr, 0, @DesktopHeight - 20)
				$sLastStr = $sStr
				GUICtrlSetData($Send2App, WinGetTitle($hWin))
			EndIf
			$aLastPos = $aPos
		EndIf
		Sleep(15)
	WEnd

	ToolTip("", 0, @DesktopHeight - 20)
	$EnableESC = 1
	SplashOff()

	disableControls(1)
	setMainFocus()
	Return $hWin
EndFunc   ;==>GetAPP

Func myHelp()

	$myHelp = _
			"This is TCT which stands for Tom’s Copy Tool.  For years I have had issues " & @CRLF & _
			"where  copy, paste and cut would not work from some tools to another.  One day " & @CRLF & _
			"I realized that AutoIT could make a tool to emulate keyboard typing.  This " & @CRLF & _
			"tool will send everything in the text window to the application selected." & @CRLF & _
			"" & @CRLF & _
			"There are two new features with this new version of TCT. The first feature will " & @CRLF & _
			"allow the speed at which the text is typed into the target to change by setting " & @CRLF & _
			"the millisecond delay between each key typed.  The second feature will allow " & @CRLF & _
			"the text to be switched from RAW to Extended text. " & @CRLF & _
			"" & @CRLF & _
			"If raw option is checked this tool will type text as seen.  If raw option is " & @CRLF & _
			"unchecked, then non alpha numeric characters are converted to keyboard functions." & @CRLF & _
			" " & @CRLF & _
			"'!'" & @CRLF & _
			"Adding an exclamation point before text tells TCT to send an ALT keystroke, " & @CRLF & _
			"therefore (""This is text!a"") would send the keys ""This is text"" and then " & @CRLF & _
			"press ""ALT + a""." & @CRLF & _
			"" & @CRLF & _
			"Some programs are very choosy about capital letters and ALT keys, i.e., ""!A"" " & @CRLF & _
			"is different from ""!a"". The first says ALT+SHIFT+A, the second is ALT+a. If " & @CRLF & _
			"in doubt, use lowercase!" & @CRLF & _
			"" & @CRLF & _
			"'+'" & @CRLF & _
			"Adding a plus symbol before text tells TCT to send a SHIFT keystroke; therefore, " & @CRLF & _
			"(""Hell+o"") would send the text ""HellO"". (""!+a"") would send ""ALT + " & @CRLF & _
			"SHIFT + a""." & @CRLF & _
			" " & @CRLF & _
			"'^'" & @CRLF & _
			"Adding a caret before text tells TCT to send a CONTROL keystroke; therefore, " & @CRLF & _
			"(""^!a"") would send ""CTRL+ALT+a""." & @CRLF & _
			"" & @CRLF & _
			"Some programs are very choosy about capital letters and CTRL keys, i.e., ""^A"" " & @CRLF & _
			"is different from ""^a"". The first says CTRL+SHIFT+A, the second is CTRL+a. " & @CRLF & _
			"If in doubt, use lowercase!" & @CRLF & _
			" " & @CRLF & _
			"'#'" & @CRLF & _
			"The hash sends a Windows keystroke; therefore, (""#r"") would send Win+r which " & @CRLF & _
			"launches the Run() dialog box." & @CRLF & _
			"" & @CRLF & _
			"Other options are listed below if Raw uncheck." & @CRLF & _
			"Send Command  	Resulting Keypress" & @CRLF & _
			"{!} 	        !" & @CRLF & _
			"{#}            #" & @CRLF & _
			"{+} 	        +" & @CRLF & _
			"{^} 	        ^" & @CRLF & _
			"{{} 	        {" & @CRLF & _
			"{}} 	        }" & @CRLF & _
			"{SPACE} 	    SPACE" & @CRLF & _
			"{ENTER} 	    ENTER key on the main keyboard" & @CRLF & _
			"{ALT} 	        ALT" & @CRLF & _
			"{BACKSPACE} or {BS}  BACKSPACE" & @CRLF & _
			"{DELETE} or {DEL}    DELETE" & @CRLF & _
			"{UP} 	        Up arrow" & @CRLF & _
			"{DOWN} 	    Down arrow" & @CRLF & _
			"{LEFT} 	    Left arrow" & @CRLF & _
			"{RIGHT} 	    Right arrow" & @CRLF & _
			"{HOME} 	HOME" & @CRLF & _
			"{END} 	END" & @CRLF & _
			"{ESCAPE} or {ESC} 	ESCAPE" & @CRLF & _
			"{INSERT} or {INS} 	INS" & @CRLF & _
			"{PGUP} 	PGUP" & @CRLF & _
			"{PGDN} 	PGDN" & @CRLF & _
			"{F1} - {F12} 	Function keys" & @CRLF & _
			"{TAB} 	TAB" & @CRLF & _
			"{PRINTSCREEN} 	PRINTSCR" & @CRLF & _
			"{LWIN} 	Left Windows key" & @CRLF & _
			"{RWIN} 	Right Windows key" & @CRLF & _
			"{NUMLOCK} 	NUMLOCK" & @CRLF & _
			"{CAPSLOCK} 	CAPSLOCK" & @CRLF & _
			"{SCROLLLOCK} 	SCROLLLOCK" & @CRLF & _
			"{BREAK} 	for Ctrl+Break processing" & @CRLF & _
			"{PAUSE} 	PAUSE" & @CRLF & _
			"{NUMPAD0} - {NUMPAD9} 	Numpad digits" & @CRLF & _
			"{NUMPADMULT} 	Numpad Multiply" & @CRLF & _
			"{NUMPADADD} 	Numpad Add" & @CRLF & _
			"{NUMPADSUB} 	Numpad Subtract" & @CRLF & _
			"{NUMPADDIV} 	Numpad Divide" & @CRLF & _
			"{NUMPADDOT} 	Numpad period" & @CRLF & _
			"{NUMPADENTER} 	Enter key on the numpad" & @CRLF & _
			"{APPSKEY} 	Windows App key" & @CRLF & _
			"{LALT} 	Left ALT key" & @CRLF & _
			"{RALT} 	Right ALT key" & @CRLF & _
			"{LCTRL} 	Left CTRL key" & @CRLF & _
			"{RCTRL} 	Right CTRL key" & @CRLF & _
			"{LSHIFT} 	Left Shift key" & @CRLF & _
			"{RSHIFT} 	Right Shift key" & @CRLF & _
			"{SLEEP} 	Computer SLEEP key" & @CRLF & _
			"{ALTDOWN} 	Holds the ALT key down until {ALTUP} is sent" & @CRLF & _
			"{SHIFTDOWN} 	Holds the SHIFT key down until {SHIFTUP} is sent" & @CRLF & _
			"{CTRLDOWN} 	Holds the CTRL key down until {CTRLUP} is sent" & @CRLF & _
			"{LWINDOWN} 	Holds the left Windows key down until {LWINUP} is sent" & @CRLF & _
			"{RWINDOWN} 	Holds the right Windows key down until {RWINUP} is sent" & @CRLF & _
			"{ASC nnnn} 	Send the ALT+nnnn key combination"

	GUISetState(@SW_DISABLE, $fMAIN)
	#Region ### START Koda GUI section ### Form=
		$myTitle = "TCT Help"
		$FormHelp = GUICreate($myTitle, 610, 432, 203, 126)
		$Edit1 = GUICtrlCreateEdit("", 8, 8, 593, 385, $ES_READONLY + $WS_VSCROLL)
		GUICtrlSetData(-1, $myHelp)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM)
		$ButtonCloseHelp = GUICtrlCreateButton("Close", 520, 400, 75, 25)
		GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($FormHelp)
				ExitLoop
			Case $ButtonCloseHelp
				GUIDelete($FormHelp)
				ExitLoop

		EndSwitch
	WEnd
	GUISetState(@SW_ENABLE, $fMAIN)
	setMainFocus()
EndFunc   ;==>myHelp

Func ProcessCRLF()
	$myResults = GUICtrlRead($mi_Raw)

	If BitAND(GUICtrlRead($miConvertCRLF), $GUI_UNCHECKED) Then
		GUICtrlSetState($miConvertCRLF, $GUI_CHECKED)
		$Suppress_CRLF = 0
		GUICtrlSetState($miConvertCRLF, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($miConvertCRLF, $GUI_UNCHECKED)
		$Suppress_CRLF = 1
		GUICtrlSetState($miConvertCRLF, $GUI_CHECKED)
	EndIf
EndFunc   ;==>ProcessCRLF

Func ProcessRaw()
	$myResults = GUICtrlRead($mi_Raw)

	If BitAND(GUICtrlRead($mi_Raw), $GUI_UNCHECKED) Then
		GUICtrlSetState($mi_Raw, $GUI_CHECKED)
		$Raw_flag = 1
		$Suppress_CRLF = 0
		GUICtrlSetState($miConvertCRLF, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($mi_Raw, $GUI_UNCHECKED)
		$Raw_flag = 0
		$Suppress_CRLF = 1
		GUICtrlSetState($miConvertCRLF, $GUI_CHECKED)
	EndIf

EndFunc   ;==>ProcessRaw

Func QuitApp()
	If $EnableESC <> 0 Then
		Exit 1
	EndIf
EndFunc   ;==>QuitApp

Func setMainFocus()
	WinActive($product, "")
	WinActivate($product, "")

EndFunc   ;==>setMainFocus

Func showAbout()
	MsgBox(1, "About", "Toms Copy Tool (TCT)" & @CRLF & "Version:" & $ver & @CRLF & " by Tom Margrave" & @CRLF & " jumphopper@gmail.com")
	ControlSetText("title", "text", 1, "new text")
	setMainFocus()
EndFunc   ;==>showAbout
