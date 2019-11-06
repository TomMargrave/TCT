#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
	#AutoIt3Wrapper_Outfile=..\Exe\TCT.exe
	#AutoIt3Wrapper_Outfile_x64=..\Exe\TCT-64.exe
	#AutoIt3Wrapper_Compression=4
	#AutoIt3Wrapper_Compile_Both=y
	#AutoIt3Wrapper_UseX64=y
	#AutoIt3Wrapper_Res_Comment=This is to replace copy and paste when app will not let user to paste into it.  For example RDP and VNC.
	#AutoIt3Wrapper_Res_Description=Tom's Copy Tool
	#AutoIt3Wrapper_Res_Fileversion=2.97.1.1
	#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
	#AutoIt3Wrapper_Res_ProductName=Tom's Copy Tool
	#AutoIt3Wrapper_Res_ProductVersion=2.97
	#AutoIt3Wrapper_Res_CompanyName=Tom Margrave
	#AutoIt3Wrapper_Run_Stop_OnError=y
	#AutoIt3Wrapper_Run_After=copy "%out%"       "C:\Users\Tom Margrave\Google Drive\TCT\Exe"
	#AutoIt3Wrapper_Run_After=copy "%outx64%"  "C:\Users\Tom Margrave\Google Drive\TCT\Exe"
	#AutoIt3Wrapper_Run_After=""C:\Program Files\7-Zip\7z.exe"  u "C:\Users\Tom Margrave\Documents\Github\TCT\Exe\TCT.zip" "C:\Users\Tom Margrave\Documents\Github\TCT\Exe\*.exe""
	#AutoIt3Wrapper_Run_After=copy  "C:\Users\Tom Margrave\Documents\Github\TCT\Exe\TCT.zip"   "C:\Users\Tom Margrave\Google Drive\TCT\Exe"
	#AutoIt3Wrapper_Run_Tidy=y
	#Tidy_Parameters=/sf /pr=1 /kv=10  /ri /reel
	#AutoIt3Wrapper_Run_Au3Stripper=y
	#Au3Stripper_Parameters=/TraceLog
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

      AutoIt Version: 3.3.14.5
      Author:         Tom Margrave   Jumphopper@gmail.com

      Script Function:  This is use to replace copy and paste when app will not let
      user to paste into it.  For example RDP and VNC.

#ce ----------------------------------------------------------------------------

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

#Region ;Global var
	Global $product
	Global $ver

	;turn off
	Global $EnableESC = 0
	Global $mySpeed = 20

	;  $SEND_DEFAULT (0) = Text contains special characters like + and ! to indicate SHIFT and ALT key-presses (default).
	;  $SEND_RAW (1) = keys are sent raw.
	Global $Raw_flag = 1

	Global $myINI = @ScriptDir & "TCT.ini"
	Global $Suppress_CRLF = 0 ; 0 unchecked  1 checked
	Global $myHWND

	;Gui
	Global $fMAIN  ;Main form
	Global $fMAIN_Left = 203
	Global $fMAIN_Top = 152

	Global $Edit1, $Button_GO, $Button_ClearPaste, $Button_Clear, $Button_Close
	Global $Send2App  ;
	Global $hWin ;handle for main form
	Global $mi_ConvertCRLF
	Global $mi_Raw

#EndRegion ;Global var

;Set up hot key cancel
HotKeySet("{ESC}", "QuitApp") ;Press ESC key to quit

INI_Load()

_Main()

Func _Main()
	$ver = FileGetVersion(@ScriptFullPath)
	$product = "Tom's Copy Tool " & $ver

	#Region ### START Koda GUI section ### Form=C:\Users\Tom Margrave\Desktop\autoit\Forms\TCT.kxf

		;Menu
		$fMAIN = GUICreate($product, 352, 206, $fMAIN_Left, $fMAIN_Top, BitOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX, $WS_THICKFRAME, $DS_MODALFRAME))
		$Menu_File = GUICtrlCreateMenu("&File")
		$mi_Exit = GUICtrlCreateMenuItem("&Exit", $Menu_File)
		$mi_Options = GUICtrlCreateMenu("&Options")
		$mi_AdjustSpeed = GUICtrlCreateMenuItem("Adjust &speed type", $mi_Options)
		$mi_Raw = GUICtrlCreateMenuItem("Raw Type", $mi_Options)
		If $Raw_flag == 1 Then
			GUICtrlSetState(-1, $GUI_CHECKED)

		Else
			GUICtrlSetState(-1, $GUI_UNCHECKED)
		EndIf
		$mi_ConvertCRLF = GUICtrlCreateMenuItem("Suppress CRLF", $mi_Options)
		If $Suppress_CRLF == 1 Then
			GUICtrlSetState(-1, $GUI_CHECKED)
		Else
			GUICtrlSetState(-1, $GUI_UNCHECKED)
		EndIf
		If $Raw_flag == 1 Then
			GUICtrlSetState($mi_ConvertCRLF, $GUI_DISABLE)
		EndIf

		$mi_Save = GUICtrlCreateMenuItem("Save Settings", $mi_Options)

		$mi_Help = GUICtrlCreateMenu("&Help")
		$mi_Help = GUICtrlCreateMenuItem("Help", $mi_Help)
		$mi_About = GUICtrlCreateMenuItem("About", $mi_Help)

		;GUI
		$Edit1 = GUICtrlCreateEdit("Text", 8, 34, 329, 113, $ES_WANTRETURN)
		GUICtrlSetData(-1, "This tool will type whatever you put here.")
		GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM)
		$Button_GO = GUICtrlCreateButton("Go", 8, 152, 81, 25)
		GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$Button_ClearPaste = GUICtrlCreateButton("Clear - Paste", 96, 152, 75, 25)
		GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$Button_Clear = GUICtrlCreateButton("Clear", 176, 152, 75, 25)
		GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$Button_Close = GUICtrlCreateButton("Close", 256, 152, 75, 25)
		GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$Send2App = GUICtrlCreateInput("Select App      ----->>>>", 8, 8, 300, 25, $ES_READONLY)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
		$SelectApp = GUICtrlCreateButton("...", 308, 8, 30, 25)
		GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH + $GUI_DOCKTOP)

		GUISetState(@SW_SHOW)

	#EndRegion ### END Koda GUI section ###

	disableControls(0)

	$myHWND = WinGetHandle($product, "")

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg

			Case $GUI_EVENT_CLOSE
				Global $EnableESC = 1
				$nothing = QuitApp()

			Case $Button_GO ;GO
				$myText = GUICtrlRead($Edit1)
				doType($myText)

			Case $Button_ClearPaste ;Clear and Paste
				$myText = ClipGet()
				GUICtrlSetData($Edit1, $myText)

			Case $Button_Clear ;Clear
				GUICtrlSetData($Edit1, "")

			Case $Button_Close ;Cloase
				Global $EnableESC = 1
				$nothing = QuitApp()

			Case $mi_Exit ; menu Exit
				$nothing = QuitApp()

			Case $mi_AdjustSpeed ; Addjust speed
				AdjustSpeed()

			Case $mi_Raw ; RAW Mode
				toggleRaw()

			Case $mi_ConvertCRLF
				toggleCRLF()

			Case $SelectApp
				$hWin = GetAPP()

			Case $mi_About ;
				showAbout()

			Case $mi_Save
				INI_Write()

			Case $mi_Help
				myHelp()
		EndSwitch
	WEnd
EndFunc   ;==>_Main

Func AdjustSpeed()
	Local $aPos = WinGetPos($myHWND)
	Local $answer = InputBox("Question", "What speed do you want to use?", $mySpeed, "", 0, 0, $aPos[0] + 40, $aPos[1] + 20, 0, $myHWND)
	$mySpeed = $answer
	Opt("SendKeyDelay", $mySpeed)
	setMainFocus()
EndFunc   ;==>AdjustSpeed

Func disableControls($myBool)
	If $myBool <> 1 Then
		$myState = $GUI_DISABLE
	Else
		$myState = @SW_DISABLE
	EndIf

	GUICtrlSetState($Edit1, $myState)
	GUICtrlSetState($Button_GO, $myState)
	GUICtrlSetState($Button_ClearPaste, $myState)
	GUICtrlSetState($Button_Clear, $myState)
	setMainFocus()
EndFunc   ;==>disableControls

Func doType($myText)
	;find active Window
	$title = WinGetTitle($hWin)

	;set send to active window
	SendKeepActive($title)
	; send keys
	If $Raw_flag == $SEND_DEFAULT Then
		If $Suppress_CRLF == 0 Then
			$myType = StringReplace($myText, @CRLF, "{ENTER}")
		Else
			$myType = StringReplace($myText, @CRLF, "")
		EndIf
	Else
		$myType = StringReplace($myText, @CRLF, @CR)
	EndIf
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

Func INI_Load()
	;Detect if ini exist
	If FileExists($myINI) Then
		$mySpeed = IniRead($myINI, "Features", "Speed", 50)
		$Raw_flag = IniRead($myINI, "Features", "RAW", 1)
		$Suppress_CRLF = IniRead($myINI, "Features", "CRLF", 0)
	EndIf

EndFunc   ;==>INI_Load

Func INI_Write()
	IniWrite($myINI, "Features", "Speed", $mySpeed)
	IniWrite($myINI, "Features", "RAW", $Raw_flag)
	IniWrite($myINI, "Features", "CRLF", $Suppress_CRLF)
EndFunc   ;==>INI_Write

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
	MsgBox(0, "About", "Toms Copy Tool (TCT)" & @CRLF & "Version:" & $ver & @CRLF & " by Tom Margrave" & @CRLF & " jumphopper@gmail.com" & @CRLF & @CRLF & "https://github.com/TomMargrave/TCT")
	ControlSetText("title", "text", 1, "new text")
	setMainFocus()
EndFunc   ;==>showAbout

Func toggleCRLF()
	If $Suppress_CRLF == 1 Then
		GUICtrlSetState($mi_ConvertCRLF, $GUI_CHECKED)
		$Suppress_CRLF = 0
		GUICtrlSetState($mi_ConvertCRLF, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($mi_ConvertCRLF, $GUI_UNCHECKED)
		$Suppress_CRLF = 1
		GUICtrlSetState($mi_ConvertCRLF, $GUI_CHECKED)
	EndIf
EndFunc   ;==>toggleCRLF

Func toggleRaw()
	If $Raw_flag == 1 Then
		;Uncheck Raw
		GUICtrlSetState($mi_Raw, $GUI_UNCHECKED)
		$Raw_flag = 0
		GUICtrlSetState($mi_ConvertCRLF, $GUI_ENABLE)
	Else
		;Check Raw
		GUICtrlSetState($mi_Raw, $GUI_CHECKED)
		$Raw_flag = 1
		GUICtrlSetState($mi_ConvertCRLF, $GUI_DISABLE)
	EndIf

	;Uncheck Suppress CRLF
	$Suppress_CRLF = 0
	GUICtrlSetState($mi_ConvertCRLF, $GUI_UNCHECKED)

EndFunc   ;==>toggleRaw
