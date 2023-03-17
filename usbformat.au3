; *** Start added by AutoIt3Wrapper ***
#include <StringConstants.au3>
; *** End added by AutoIt3Wrapper ***
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Res_SaveSource=y
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_Add_Constants=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; *** Start added by AutoIt3Wrapper ***
#include <AutoItConstants.au3>
#include <FileConstants.au3>
; *** End added by AutoIt3Wrapper ***
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.15.0 (Beta)
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <Array.au3>
$volume = FileOpen ( @ScriptDir & "\volume.txt", $FO_OVERWRITE )
FileWriteLine ( $volume, "list volume" )
FileClose ( $volume )
$proc = Run ( 'diskpart /s "' & @ScriptDir & '\volume.txt"', @SystemDir, @SW_HIDE, $STDOUT_CHILD )
ProcessWaitClose ( $proc )
$output = StdoutRead ( $proc )
Do
	FileDelete ( @ScriptDir & "\volume.txt" )
Until Not FileExists ( @ScriptDir & "\volume.txt" )

$split = StringSplit ( $output, @CRLF )
$volnumber = ""
For $i = 1 To $split[0] Step 1
	$match = StringRegExp ( $split[$i], "\s{3,7}\w\s{2,5}", $STR_REGEXPARRAYFULLMATCH )
	If @error Then
		SetError ( 0 )
		ContinueLoop
	Else
		If StringStripWS ( $match[0], 3 ) = $CmdLine[1] Then
			$splitvol = StringSplit ( $split[$i], "" )
			$g = 1
			While Not StringIsDigit ( $splitvol[$g] )
				$g += 1
			WEnd
			If StringIsDigit ( $splitvol[$g + 1] ) Then
				$volnumber = "Volume " & $splitvol[$g] & $splitvol[$g + 1]
			Else
				$volnumber = "Volume " & $splitvol[$g]
			EndIf
		Else
			ContinueLoop
		EndIf
	EndIf
Next
If $volnumber = "" Then
	SetError ( 4 )
	ConsoleWriteError ( "The drive letter you provided was not found.  Please input a valid drive letter." & @CRLF )
	Exit
Else
	$vol = FileOpen ( @ScriptDir & "\diskscript.txt", $FO_OVERWRITE )
	FileWriteLine ( $vol, "select " & $volnumber )
	FileWriteLine ( $vol, "clean" )
	FileWriteLine ( $vol, "convert mbr" )
	FileWriteLine ( $vol, "create partition primary" )
	FileWriteLine ( $vol, 'format quick fs="fat32" label="WinPE"' )
	FileWriteLine ( $vol, 'assign letter="' & $CmdLine[1] & '"' )
	FileWriteLine ( $vol, "active" )
	FileClose ( $vol )
	RunWait ( 'diskpart /s "' & @ScriptDir & '\diskscript.txt"', @SystemDir, @SW_SHOW )
	Do
		FileDelete ( @ScriptDir & "\diskscript.txt" )
	Until Not FileExists ( @ScriptDir & "\diskscript.txt" )

	ConsoleWrite ( "The operation completed successfully" & @CRLF )
EndIf
