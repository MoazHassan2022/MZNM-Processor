#this is a comment 
#all numbers are in hexadecimal
#the reset signal is raised before this code is executed and the flags and the registers are set to zeros.
.ORG 0 #this is the interrupt code
AND R3,R4
ADD R1,R4
OUT R4
RTI
.ORG 20 #this is the instructions code
IN R1
JMP R1
NOP
NOT R0