#this is a comment 
#all numbers are in hexadecimal
#the reset signal is raised before this code is executed and the flags and the registers are set to zeros.
.ORG 0 #this is the interrupt code
#AND R3,R4
NOT R8
ADD R1,R4
OUT R4
RTI
.ORG 20 #this is the instructions code
LDM R1,2D # 45 
SETC 
JC R1 
LDM R1,50 # 80 
INC R2 
STD R1,R2 
LDD R2,R5 
INC R5 
PUSH R5 
POP R7 
INC R7 
LDM R0,6 
ADD R0,R0 
LDM R7,24 # 36 
JMP R7