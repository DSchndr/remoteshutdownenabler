#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=Beta
#AutoIt3Wrapper_Outfile=runme_x86.Exe
#AutoIt3Wrapper_Outfile_x64=runme_x64.Exe
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_requestedExecutionLevel=highestAvailable
#AutoIt3Wrapper_Tidy_Stop_OnError=n
#AutoIt3Wrapper_Run_Au3Stripper=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.14.5
	Author:         DSchndr

	Script Function:
	Activate remote shutdown on windows 8.0+ by setting regkey (weakens security by little bit :P )

#ce ----------------------------------------------------------------------------

;#include <MsgBoxConstants.au3>
#include <SendMessage.au3>
#include <ColorConstants.au3>

#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>


Global Const $SC_DRAGMOVE = 0xF012

HotKeySet("{ESC}", "On_Exit")
Func On_Exit()
	Exit
EndFunc   ;==>On_Exit

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Hi :)", 210, 194, -1, -1, BitOR($WS_POPUP, $WS_BORDER), $WS_EX_TOPMOST)
$Group1 = GUICtrlCreateGroup("I have no name for this.", 8, 4, 193, 185, BitOR($GUI_SS_DEFAULT_GROUP, $WS_BORDER))
$Group2 = GUICtrlCreateGroup("Information", 16, 16, 177, 89)
$Label1 = GUICtrlCreateLabel("Status:", 24, 32, 37, 17)
$Status = GUICtrlCreateLabel("Unknown", 88, 32, 100, 17, $SS_SUNKEN)
$Label3 = GUICtrlCreateLabel("Username:", 24, 48, 55, 17)
$Username = GUICtrlCreateLabel("Unknown", 88, 48, 100, 17, $SS_SUNKEN)
$Label5 = GUICtrlCreateLabel("IP-Address:", 24, 64, 58, 17)
$ip = GUICtrlCreateLabel("Unknown", 88, 64, 100, 17, $SS_SUNKEN)
$Label2 = GUICtrlCreateLabel("Comp.Name:", 23, 79, 65, 17)
$Label4 = GUICtrlCreateInput("Unknown", 87, 79, 98, 17, $SS_SUNKEN)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group3 = GUICtrlCreateGroup("Control", 16, 104, 89, 81)
$Button1 = GUICtrlCreateButton("Enable", 24, 120, 75, 25)
$Button2 = GUICtrlCreateButton("Disable", 24, 152, 75, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Button3 = GUICtrlCreateButton("RSh", 126, 136, 45, 25)
$Button4 = GUICtrlCreateButton("NRShE", 126, 160, 60, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

GUICtrlSetData($Username, @UserName)
GUICtrlSetData($ip, @IPAddress1)
GUICtrlSetData($Label4, @ComputerName)
updateval()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Label1
			On_Exit()
		Case $GUI_EVENT_PRIMARYDOWN
			_SendMessage($Form1, $WM_SYSCOMMAND, $SC_DRAGMOVE, 0)
		Case $Button1
			Writekeys(0x1)
			updateval()
		Case $Button2
			Writekeys(0x0)
			updateval()
		Case $Label5
			Openlink("https://www.youtube.com/watch?v=hi6NFQ54Pl8")
		Case $Button3
			ShellExecute("shutdown.exe", "/i")
		Case $Button4
			$input = InputBox("Remote-Remoteshutdownenabler", "Enter the name of the PC (eg. \\1337PC)", "\\")
			$user = InputBox("Remote-Remoteshutdownenabler", "Enter the name of the User", "")
			$pass = InputBox("Remote-Remoteshutdownenabler", "Enter the Password", "")
			ShellExecute("PsExec.exe", " " & $input & " -u " & $user & " -p " & $pass & ' -d -e -h -accepteula -nobanner C:\Windows\System32\cmd.exe "/c REG ADD HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System /v LocalAccountTokenFilterPolicy /t REG_DWORD /f /d 1"')
			ConsoleWrite("PsExec.exe" & $input & " -u " & $user & " -p " & $pass & ' -d -e -h -accepteula -nobanner C:\Windows\System32\cmd.exe "/c REG ADD HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System /v LocalAccountTokenFilterPolicy /t REG_DWORD /f /d 1"')
			updateval()
	EndSwitch
WEnd

Func updateval()
	Local $ret = Checkkeys()
	If ($ret == 1) Then
		GUICtrlSetData($Status, "Enabled :)")
		GUICtrlSetColor($Status, $COLOR_GREEN)
	ElseIf ($ret == 0) Then
		GUICtrlSetData($Status, "Disabled")
		GUICtrlSetColor($Status, $COLOR_RED)
	Else
		GUICtrlSetData($Status, "No Key")
		GUICtrlSetColor($Status, $COLOR_BLUE)
	EndIf
EndFunc   ;==>updateval

Func Checkkeys()
	ConsoleWrite("--> Checkkeys()" & @CRLF)
	Local $1 = RegRead("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System", "LocalAccountTokenFilterPolicy")
	Local $2 = RegRead("HKEY_LOCAL_MACHINE64\Software\Microsoft\Windows\CurrentVersion\Policies\System", "LocalAccountTokenFilterPolicy")
	If ($1 == 0x1 Or $2 == 0x1) Then
		Return 1
	ElseIf ($1 == 0x0 Or $2 == 0x0) Then
		Return 0
	Else
		Return -1
	EndIf
EndFunc   ;==>Checkkeys

Func Writekeys($val)
	ConsoleWrite("--> Writekeys() | Returnvalues should be 0 ..." & @CRLF & "Deleting keys" & @CRLF)
	RegDelete("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System", "LocalAccountTokenFilterPolicy")
	ConsoleWrite(@error)
	RegDelete("HKEY_LOCAL_MACHINE64\Software\Microsoft\Windows\CurrentVersion\Policies\System", "LocalAccountTokenFilterPolicy")
	ConsoleWrite(@error & @CRLF)
	ConsoleWrite("Writing keys" & @CRLF)
	RegWrite("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System", "LocalAccountTokenFilterPolicy", "REG_DWORD", $val)
	ConsoleWrite(@error)
	RegWrite("HKEY_LOCAL_MACHINE64\Software\Microsoft\Windows\CurrentVersion\Policies\System", "LocalAccountTokenFilterPolicy", "REG_DWORD", $val)
	ConsoleWrite(@error & @CRLF)
EndFunc   ;==>Writekeys

Func Openlink($link)
	ConsoleWrite(@CRLF & "--> Openlink(" & $link & ")")
	If FileExists("C:\Program Files (x86)\Google\Application\chrome.exe") Then
		ConsoleWrite(@CRLF & "Detected Chrome")
		ShellExecute("C:\Program Files (x86)\Google\Application\chrome.exe", $link)
	ElseIf FileExists("C:\Program Files\Mozilla Firefox\firefox.exe") Then
		ConsoleWrite(@CRLF & "Detected Firefox")
		ShellExecute("C:\Program Files\Mozilla Firefox\firefox.exe", "--new-tab " & $link)
	Else
		ShellExecute($link)
	EndIf
EndFunc   ;==>Openlink



