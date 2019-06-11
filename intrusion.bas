
; components - Pin
; Red LED - c.1
; Green LED - b.3
; lever switch - c.6
; Normally closed push button switch - c.2
; push button switch (actvating alarm) - b.4
; push button switch to disable alarm - b.6
; speaker - c.4
; password switch - c.0
; potentiometer - b.0,b.1,b.2
; servo - b.5

main:

	; pass variable 
	;if pass is 0 => password is wrong
	;if pass is 1=> password is correct

	symbol pass = b9

	; swi variable
	; if swi is 0 => box is open or box is lifted from the surface
	; if swi is 1 => door is closed and box is on surface

	symbol swi = b8

	let pass = 0 ; password is wrong
	let swi = 1 ; closed push button and lever switch
	low c.1, B.3


	init:	servo b.5,235                         	; initialise servo
	; wait until alarm is armed
	do while pinb.4 = 0
	loop
	wait 1
	; turn on green LED
	high b.3
	servo b.5, 80
	goto check

check:

	; read potentiometer
	readadc b.0, b1
	readadc b.1, b2
	readadc b.2, b3

	let pass = 0 
	if pinc.0 = 1 then
		{
			if   b1 < 5 then ;2
			{
			let pass = 1
			}
			endif
			if b2 >253 then;2
			{
			let pass = 1
			}
			endif
		
			if b3 <7 then;4
			{
			let pass = 1
			}
			else
			{
			let pass = 0
			}
		
			ENDIF
		}
	ENDIF
	if pinc.6 = 0 or pinc.2 = 1 then
		{
		let swi = 0
		}
	else
		{
		let swi = 1
		}
	ENDIF
	
	;if pinc.6 = 0 or pinc.2 = 1 then alarm
	;only turn on the alram if password is wrong 
	;and box is lifted or opened


	if pass = 0 and pinc.0 = 1 then 
		{
			high c.1 ; Red LED
		}
	endif
	
	
	if pass = 1 then 
		{
		sound c.4, (80,70)
		servo b.5 ,130
		goto main
		}
		endif
	
	if pass = 0 and swi =0  then alarm
	goto check
	
alarm:	
	low b.3
	do while pinb.6 = 0
		
		; read potentiometer
		readadc b.0, b1
		readadc b.1, b2
		readadc b.2, b3

		let pass = 0
		high c.1
		pause 200
		low c.1
		sound c.4, (125,100)
		
	
		if pinc.0 = 1 then
		{
			if   b1 < 5 then ;2
			{
			let pass = 1
			}
			endif
			if b2 >253 then;2
			{
			let pass = 1
			}
			endif
		
			if b3 <7 then;4
			{
			let pass = 1
			}
			else
			{
			let pass = 0
			}
		
			ENDIF
		}
		ENDIF


		if pass = 1 and pinc.0 = 1 then 
		{
		sound c.4, (80,70)
		servo b.5,235                           
		}
		endif
	loop
	goto main
	



