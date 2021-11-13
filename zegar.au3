#include <GUIConstantsEx.au3>
#include <GUIConstants.au3>
#include <Date.au3>

; szerokość okna i labela zmienia się w zależności od dnia tygodnia, nazwy dni tygodnia mają różną długość
; wartości dobrane są poprzez eksperymentalne sprawdzenie odpowiedniej szerokości
; Długość okna dopasowana do dni tygodnia w języku polskim
;Global $DaysOfWeek_WinWidth[8] = ["None", "250", "187", "177", "212", "180", "190", "212"]
; Długość okna dopasowana do dni tygodnia w języku angielskim
Global $DaysOfWeek_WinWidth[8] = ["None", "210", "215", "253", "225", "190", "221", "207"]
;MsgBox(1, "", $DaysOfWeek[_DateToDayOfWeekISO(@YEAR,@MON,@MDAY)])

Global $Day_of_the_week_number = _DateToDayOfWeekISO(@YEAR,@MON,@MDAY); numer dnia tygodnia
Global $memoDay_of_the_week_number;
Global $Win_Width = $DaysOfWeek_WinWidth[$Day_of_the_week_number];
Global $Win_Height = 25;
Global $Scr_Width = 1920;1080;
Global $Scr_Height = 1080;1920;
Global $Scr_Orientation; = "Horizontal"; "Vertical"

$Scr_Orientation = InputBox("Screen orientation", "Enter the screen orientation: (Cancel or other than Horizontal means Vertical): ", _
							  "Horizontal","",  200, 155)

If $Scr_Orientation <> "Horizontal" Then
   $Scr_Orientation = "Vertical"
EndIf

If $Scr_Orientation ="Horizontal" Then
   $Scr_Width = 1920;1080;
   $Scr_Height = 1080;1920;
ElseIf $Scr_Orientation = "Vertical" Then
   $Scr_Width = 1080;
   $Scr_Height = 1920;
EndIf

; wyświetla nazwę dnia tygodnia po polsku
;Global $DaysOfWeek[8] = ["None", "poniedziałek", "wtorek", "środa", "czwartek", "piątek", "sobota", "niedziela"]
Global $DaysOfWeek[8] = ["None", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

Example()

Func Example()
    Global $hwndGUI
    $hwndGUI = GUICreate("",$Win_Width,$Win_Height,$Scr_Width/2-$Win_Width/2,$Scr_Height-$Win_Height,$WS_POPUP) ; will create a dialog box that when displayed is centered
    GUISetBkColor(0x000000)
    GUISetFont(18, 300)
	WinSetOnTop($hwndGUI, "", $WINDOWS_ONTOP)
	WinSetTrans($hwndGUI,"", 200)
    $Label = GUICtrlCreateLabel("Hello", 5, 0, $Win_Width-5, $Win_Height)
	GUICtrlSetBkColor(-1, 0x000000)
	GUICtrlSetColor(-1, 0xFFFFFF)

    GUISetState(@SW_SHOW)

    ; Loop until the user exits.
   Global $flaga=0
    While 1
        $idMsg = GUIGetMsg()
		; Get current system time
		$tCur = _Date_Time_GetLocalTime()

		; Jeśli zmienił się dzień tygodnia w trakcie działania programu to trzeba zmienić rozmiar okna i rozmiar etykiety
		$memoDay_of_the_week_number = $Day_of_the_week_number;
		$Day_of_the_week_number = _DateToDayOfWeekISO(@YEAR,@MON,@MDAY); numer dnia tygodnia
		If ($Day_of_the_week_number<>$memoDay_of_the_week_number) Then
		   ;Zmiana rozmiaru okna zmienia także pozycję jego środka
		   ;Sprawdzam czy okno znajduje się aktualnie przy krawędzi ekranu
		   $WinPos = WinGetPos($hwndGUI)
		   If ($WinPos[0]=$Scr_Width-$Win_Width) Then
			  ; Okno znajduje się przy krawędzi
			  $Win_Width = $DaysOfWeek_WinWidth[$Day_of_the_week_number];
			  WinMove($hwndGUI, "", $Scr_Width-$Win_Width, $Scr_Height-$Win_Height, $Win_Width, $Win_Height);
		   Else
			  ; Okno znajduje się na środku
			  $Win_Width = $DaysOfWeek_WinWidth[$Day_of_the_week_number];
			  WinMove($hwndGUI, "", $Scr_Width/2-$Win_Width/2, $Scr_Height-$Win_Height, $Win_Width, $Win_Height);
		   EndIf
		   GUICtrlSetPos($Label, 5, 0, $Win_Width-5, Default);
		EndIf

		$time = _Date_Time_SystemTimeToTimeStr($tCur)
		$tab = StringRegExp($time, "([0-9]{2}):([0-9]{2}):[0-9]{2}", 1)
	    $hour = $tab[0]
	    $mins = $tab[1]
		Local $time

	    If $hour = "00" Then
		   $hour = "12"
		   $time = $hour&":"&$mins&" AM"
	    ElseIf $hour > "00" And $hour < "12" Then
		   $time = $hour&":"&$mins&" AM"
	    ElseIf $hour = 12 Then
		   $time = $hour&":"&$mins&" PM"
	    ElseIf $hour >= 13 Then
		   $hour = $hour - 12
		   If $hour >= 1 And $hour < 10 Then
			  $hour = "0"&$hour
		   EndIf
		   $time = $hour&":"&$mins&" PM"
	    EndIf

	    GUICtrlSetData($Label, $DaysOfWeek[$Day_of_the_week_number]&", "&$time)
		$MousePos = MouseGetPos()
		$WinPos = WinGetPos($hwndGUI)
	    If ($MousePos[0]>=$WinPos[0] And $MousePos[0]<=($WinPos[0]+$Win_Width) And _ ; '_' kontynuuje linię kodu w nowym wierszu
		    $MousePos[1]>=$WinPos[1] And $MousePos[1]<=($WinPos[1]+$Win_Height)) Then
		   WinMove($hwndGUI,"", $Scr_Width-$Win_Width, $Scr_Height-$Win_Height)
		   ;$flaga = 1
	    EndIf
	    $MousePos = MouseGetPos()
		$WinPos = WinGetPos($hwndGUI)
	    If ($MousePos[0]>=$WinPos[0] And $MousePos[0]<=($WinPos[0]+$Win_Width) And _
		    $MousePos[1]>=$WinPos[1] And $MousePos[1]<=($WinPos[1]+$Win_Height)) Then
		   WinMove($hwndGUI,"", $Scr_Width/2-$Win_Width/2, $Scr_Height-$Win_Height)
		   ;$flaga = 0
	    EndIf
		Sleep(500)
        If $idMsg = $GUI_EVENT_CLOSE Then ExitLoop
		;Sleep(50)
    WEnd
EndFunc   ;==>Example
