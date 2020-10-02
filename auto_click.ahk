﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force



mine_bool := 0
dropWait := 200
mineWait := 2500
heightSquare := 180
widthSquare := 200
heightItem := 36
widthItem := 42
itemOffsetX := 45
itemOffsetY := 70
clickX := 0
clickY := 0


initializeGlobals_Desktop()


reloadScript(){
	BlockInput Off
		MsgBox, reloading auto_click.ahk
		Reload, auto_click.ahk
}

!o::Suspend

$!r::
  Send {shift up}
  reloadScript()
  return

RSClick(rsX, rsY, sleeperTime)
{
		; send click and input to RS
	Send {Click, %rsX%, %rsY%}
	sleep, %sleeperTime%
}

$+!^x::

  MouseGetPos, x, y
  send, {alt down} {tab} {alt up}
  sleep, 1000

  send, % "Send, {{}Click, " x ", " y "{}}"
  send, {enter}
  send, % "sleep, 1000"
  send, {enter}
  send, {enter}

  sleep, 1000

  send, {alt down} {tab} {alt up}
  return

initializeGlobals_Desktop(){
  global
  WinGetPos, posX, posY, width, height, A

  heightSquare := height / 4.5
  widthSquare := width / 8
  return
}



;------------------------------------------------------------------
;------------------------------------------------------------------
;     MAIN HOTKEYS
;------------------------------------------------------------------
;------------------------------------------------------------------

:*:ahk mine iron::
  mine_iron()
  return

:*:ahk mine coal::
  mine_coal()
  return

:*:ahk high alch::
  InputBox, numItems, "High Alchemy", "how many items?"
  sleep, 500

  numInventory := 25
  numLoops := numItems / numInventory
  numLoops := Floor(numLoops)
  remainder := Mod(numItems, numInventory)
  
  SELECT_FIRST_ITEM_FROM_BANK()

  Loop %numLoops% {
      ; high alchemy loop
    high_alch(numInventory)
    SELECT_FIRST_ITEM_FROM_BANK()
  }
  
    ; last loop
  high_alch(remainder)  
  return

:*:ahk smith::
  InputBox, numItems, "smith iron", "how many items?"
  sleep, 500

  numInventory := 27
  numLoops := numItems / numInventory
  numLoops := Floor(numLoops)
  remainder := Mod(numItems, numInventory)

  SMITH_MEDHELM()

  Loop %numLoops% {
      ; auto smithing loop
    GET_INGOTS_FROM_BANK()
    SMITH_MEDHELM()
  }


  return

:*:test::
    SMITH_MEDHELM()
    GET_INGOTS_FROM_BANK()
  return


;------------------------------------------------------------------
;------------------------------------------------------------------
;     MAIN FUNCTIONS
;------------------------------------------------------------------
;------------------------------------------------------------------

mine_iron() {
  Loop 12
  {
    click_UP(3800)
    click_RIGHT(3800)
  }
}
mine_coal() {
  Loop 20
  {
    click_DOWN_RIGHT(14000)
    click_UP_LEFT_LEFT(14000)
    click_DOWN_LEFT(14000)
  }
}

high_alch(numLoop) {
  global
  ha_iter := -1
  Loop %numLoop% {
    ha_iter := ha_iter + 1
    ha_item_row := Floor(ha_iter / 4) + 1
    ha_item_col := Mod(ha_iter, 4) + 1
    SELECT_HIGH_ALCH(ha_item_row, ha_item_col)
  }
}

varrock_smith_medhelms() {
  global
  
  loop {
    GET_INGOTS_FROM_BANK()
    SMITH_MEDHELM()
  }



}



;------------------------------------------------------------------
;------------------------------------------------------------------
;     mouse position adjustment functions
;------------------------------------------------------------------
;------------------------------------------------------------------
    getRSCenter() {
      global
      WinGetPos, posX, posY, width, height, A
      clickX := width / 2
      clickY := (height / 2) + (heightSquare / 2)
      return
    }
    UP(){
      global
      clickY := (clickY - heightSquare)
    }
    DOWN() {
      global
      clickY := (clickY + heightSquare - 25)
    }
    LEFT() {
      global
      clickX := (clickX - widthSquare)
    }
    RIGHT() {
      global
      clickX := (clickX + widthSquare)
    }



    getRSFirstItem() {
      global
      WinGetPos, posX, posY, width, height, A
      clickY := (height - itemOffsetY - (heightItem * 6))
      clickX := (width - itemOffsetX - (widthItem * 3))
      return
    }
    ITEM_DOWN() {
      global
      clickY := clickY + heightItem
      return
    }
    ITEM_RIGHT() {
      global
      clickX := clickX + widthItem
      return
    }




    
;------------------------------------------------------------------
;------------------------------------------------------------------
;     RS item click functions
;------------------------------------------------------------------
;------------------------------------------------------------------

    GET_INGOTS_FROM_BANK(){
        ;open bank
      Send, {Click, 756, 222}
      sleep, 5000

      SELECT_ITEM(1, 2, 1000)

        ;select tab
      Send, {Click, 759, 87}
      sleep, 500
        ;select ingot
      Send, {Click, 526, 126}
      sleep, 1000
        ;exit bank
      Send, {Click, 926, 49}
      sleep, 1000
    }

    SMITH_MEDHELM() {
        ; anvil
      Send, {Click, 921, 815}
      sleep, 5000
        ; smith all
      Send, {Click, 919, 443}
      sleep, 1000
        ; select med helm
      Send, {Click, 718, 267}
      sleep, 85000
    }

    SELECT_FIRST_ITEM_FROM_BANK() {
        ; open bank
      Send, {Click, 742, 420}
      sleep, 1000

      Loop 2 {
          ; select item
        Send, {Click, 527, 125}
        sleep, 1000
      }

        ; exit bank
      Send, {Click, 926, 52}
      sleep, 1000
    }

    SELECT_HIGH_ALCH(i_row, i_col) {
      global
      ha_row := 3
      ha_col := 3

      getRSFirstItem()
      Loop %ha_row% {
        ITEM_DOWN()
      }
      Loop %ha_col% {
        ITEM_RIGHT()
      }

      clickX := clickX + 15
      clickY := clickY - 15

      Send {Click, %clickX%, %clickY%}
      sleep, 300

      SELECT_ITEM(i_row, i_col, 3000)
      return
    }

    SELECT_ITEM(row, col, sleeperTime) {
      global
      row := row - 1
      col := col - 1

      getRSFirstItem()
      Loop %row% {
        ITEM_DOWN()
      }
      Loop %col% {
        ITEM_RIGHT()
      }

      Send {Click, %clickX%, %clickY%}
      sleep, %sleeperTime%
      return
    }

    DROP_ITEM(row, col, sleeperTime) {
      global
      Send {shift down}
        SELECT_ITEM(row, col, 0)
      Send {shift up}
      sleep, %sleeperTime%
      return
    }


;------------------------------------------------------------------
;------------------------------------------------------------------
;     RS map click functions
;------------------------------------------------------------------
;------------------------------------------------------------------

  ;------------------------------------------------------------------
  ;     1 square
  ;------------------------------------------------------------------

    click_UP(sleeperTime) {
      global
      getRSCenter()
      UP()
      Send {Click, %clickX%, %clickY%}
      sleep, %sleeperTime%
      return
    }
    click_DOWN(sleeperTime){
      global
      getRSCenter()
      DOWN()
      Send {Click, %clickX%, %clickY%}
      sleep, %sleeperTime%
      return
    }
    click_LEFT(sleeperTime){
      global
      getRSCenter()
      LEFT()
      Send {Click, %clickX%, %clickY%}
      sleep, %sleeperTime%
      return
    }
    click_RIGHT(sleeperTime){
      global
      getRSCenter()
      RIGHT()
      Send {Click, %clickX%, %clickY%}
      sleep, %sleeperTime%
      return
    }


    click_UP_RIGHT(sleeperTime){
      global
      getRSCenter()
      UP()
      RIGHT()
      Send {Click, %clickX%, %clickY%}
      sleep, %sleeperTime%
      return
    }
    click_UP_LEFT(sleeperTime){
      global
      getRSCenter()
      UP()
      LEFT()
      Send {Click, %clickX%, %clickY%}
      sleep, %sleeperTime%
      return
    }
    click_DOWN_RIGHT(sleeperTime){
      global
      getRSCenter()
      DOWN()
      RIGHT()
      Send {Click, %clickX%, %clickY%}
      sleep, %sleeperTime%
      return
    }
    click_DOWN_LEFT(sleeperTime){
      global
      getRSCenter()
      DOWN()
      LEFT()
      Send {Click, %clickX%, %clickY%}
      sleep, %sleeperTime%
      return
    }

  ;------------------------------------------------------------------
  ;   2 square
  ;------------------------------------------------------------------

    click_UP_UP(sleeperTime){
      global
      getRSCenter()
      UP()
      UP()
      Send {Click, %clickX%, %clickY%}
      sleep, %sleeperTime%
      return
    }
    click_LEFT_LEFT(sleeperTime){
      global
      getRSCenter()
      LEFT()
      LEFT()
      Send {Click, %clickX%, %clickY%}
      sleep, %sleeperTime%
      return
    }
    click_RIGHT_RIGHT(sleeperTime){
      global
      getRSCenter()
      RIGHT()
      RIGHT()
      Send {Click, %clickX%, %clickY%}
      sleep, %sleeperTime%
      return
    }

    click_UP_RIGHT_RIGHT(sleeperTime){
      global
      getRSCenter()
      UP()
      RIGHT()
      RIGHT()
      Send {Click, %clickX%, %clickY%}
      sleep, %sleeperTime%
      return
    }
    click_UP_LEFT_LEFT(sleeperTime){
      global
      getRSCenter()
      UP()
      LEFT()
      LEFT()
      Send {Click, %clickX%, %clickY%}
      sleep, %sleeperTime%
      return
    }

    click_UP_UP_RIGHT_RIGHT(sleeperTime){
      global
      getRSCenter()
      UP()
      UP()
      RIGHT()
      RIGHT()
      Send {Click, %clickX%, %clickY%}
      sleep, %sleeperTime%
      return
    }
    click_UP_UP_LEFT_LEFT(sleeperTime){
      global
      getRSCenter()
      UP()
      UP()
      LEFT()
      LEFT()
      Send {Click, %clickX%, %clickY%}
      sleep, %sleeperTime%
      return
    }

    click_UP_UP_RIGHT(sleeperTime){
      global
      getRSCenter()
      UP()
      UP()
      RIGHT()
      Send {Click, %clickX%, %clickY%}
      sleep, %sleeperTime%
      return
    }
    click_UP_UP_LEFT(sleeperTime){
      global
      getRSCenter()
      UP()
      UP()
      LEFT()
      Send {Click, %clickX%, %clickY%}
      sleep, %sleeperTime%
      return
    }



