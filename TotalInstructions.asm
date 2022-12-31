# ALU => DONE
INC R0 
ADD R0,R0 
SHL R0,2 
MOV R0,R5 
SHR R0,2 
INC R1 
ADD R1,R0 
MOV R1,R3 
SUB R3,R0 
OR R0,R5 
AND R0,R5 
DEC R5 
OUT R5 
IN R6 
NOT R7

# FULL => DONE
LDM R1,45 
CALL R1 
LDM R1,35 
INC R2 
STD R1,R2 
LDD R2,R5 
INC R5 
PUSH R5 
POP R7 
INC R7 
LDM R0,6 
ADD R0,R0 
RET

# JUMPS => DONE
LDM R1,45 
SETC 
JC R1 
LDM R1,80 
INC R2 
STD R1,R2 
LDD R2,R5 
INC R5 
PUSH R5 
POP R7 
INC R7 
LDM R0,6 
ADD R0,R0 
LDM R7,36 
JMP R7

# OTHER JUMPS
LDM R1,50 
SETC 
JC R1 

LDM R1,56 
INC R3 
DEC R3 
JZ R1 

LDM R1,62 
NOT R3 
JN R1 

LDM R1,68 
CALL R1 
INC R6 

LDM R0,6 
ADD R0,R0 
LDM R7,36 
JMP R7 

LDM R0,7 
ADD R0,R0 
LDM R7,41 
JMP R7 

LDM R0,8 
ADD R0,R0 
LDM R7,45 
JMP R7 

LDM R0,9 
ADD R0,R0 
RET

# SAMPLE => DONE

#this is a comment 
#all numbers are in hexadecimal
#the reset signal is raised before this code is executed and the flags and the registers are set to zeros.
.ORG 0 #this is the interrupt code
AND R3,R4
ADD R1,R4
OUT R4
RTI
.ORG 20 #this is the instructions code
IN R1                   #add 00000005 in R1
IN R2                   #add 00000019 in R2
IN R3                   #FFFFFFFF
IN R4                   #FFFFF320
MOV R3,R5               #R5= FFFFFFFF , flags no change
ADD R1,R4               #R4= FFFFF325 , C-->0, N-->1, Z-->0
SUB R5,R4               #R4= 00000CDA , C-->0, N-->0,Z-->0 
AND R7,R4               #R4= 00000000 , C-->no change, N-->0, Z-->1
OR R2, R1               #R1= 0000001D , C-->0, N-->0,Z-->0
SHL R1,4                #R1= 000001D0 , C-->0, N-->0,Z-->0
SHR R1,4                #R1= 0000001D , C-->0, N-->0,Z-->0


# MEMORY => DONE

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
LDM R1,35 
INC R2 
STD R1,R2 
LDD R2,R5 
INC R5 
PUSH R5 
POP R7 
INC R7

