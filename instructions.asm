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

LDM R2,32 # 50  # 32, 33
SETC            # 34
JC R2           # 35

LDM R2,38 # 56  # 36, 37
INC R4          # 38
DEC R4          # 39
JZ R2           # 40

LDM R2, 3E # 62 # 41, 42
NOT R4          # 43
JN R2           # 44


# Try LDD then JMP


LDM R2,44 # 68  # 45, 46
CALL R2         # 47
INC R6          # 48

LDM R1,6        # 49, 50
ADD R1,R1       # 51
LDM R8,24 # 36  # 52, 53
JMP R8          # 54

LDM R1,7        # 55, 56
ADD R1,R1       # 57
LDM R8,29 # 41  # 58, 59
JMP R8          # 60

LDM R1,8        # 61, 62
ADD R1,R1       # 63
LDM R8,2D # 45  # 64, 65
JMP R8          # 66

LDM R1,9        # 67, 68
ADD R1,R1       # 69
RET             # 70

