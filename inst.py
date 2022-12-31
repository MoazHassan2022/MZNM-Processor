
# no operand
NoOperand={
    "nop":"00000",
    "ret":"10100",
    "rti":"10101",
    "setc":"11011",
    "clrc":"11100"
}

# the one operand instructions
OneOperand={
    "in":"11001",
    "out":"11000",
    "not":"11010",
    "inc":"00001",
    "dec":"00010",
    "push":"01010",
    "pop":"01011",
    "jn":"10000",
    "jc":"10001",
    "jmp":"10010",
    "jz":"01111",
    "call":"10011",
}
# two operand instructions
TwoOperands={
    "mov":"00011",
    "add":"00100",
    "sub":"00101",
    "and":"00110",
    "or":"00111",
    "shl":"01000",
    "shr":"01001",
    "ldd":"01101",
    "std":"01110",
    "ldm":"01100"
}

#32bit instruction
Instruction32={
    "ldm":"01100"
}
#registers
Registers={
    "r0":"000",
    "r1":"001",
    "r2":"010",
    "r3":"011",
    "r4":"100",
    "r5":"101",
    "r6":"110",
    "r7":"111"
}

# opent the input file 
ft=open("instructions.asm","r")

#opent the instructions memory file
InstructionMemory=open("instructionMemory.txt","w")
outArray=[]
ArrInstructions=[]
val = 0
size = 1048576
out = [val] * size
Ldm=""


for line in ft :
    ArrInstructions.append(line)

i=0
for line in ArrInstructions:
    instruction=""
    line=line.strip()
    if line == "" or line == " " or line[0]=="#":
        continue
    else:
        pos=line.find("#")
        if pos!=-1:
            line=line[:pos].strip()
        if line.find(" ")!=-1:
            pos=line.index(" ")
            instruc=line[:pos]
            operands=line[pos:].strip()
            if instruc.lower()==".org":
                skipped=int((operands.strip()),16)
                skipped-=i
                for k in range(skipped):
                    out[i]="0000000000000000"
                    i+=1
                continue
            if OneOperand.__contains__(instruc.lower()):
                instruction+=OneOperand[instruc.lower()]
                if Registers.__contains__(operands.lower()):# if true one operand 
                    if instruc.lower()=="push" or instruc.lower()=="out":
                        instruction+="000"
                        instruction+=Registers[operands.lower()]
                        instruction+="00000"
                    else:
                        instruction+=Registers[operands.lower()]
                        instruction+="00000000"
            elif TwoOperands.__contains__(instruc.lower()):
                instruction+=TwoOperands[instruc.lower()]
                if operands.find(",")!=-1:
                    pos=operands.index(",")
                    op1=operands[:pos].strip()
                    op2=operands[pos+1:].strip()
                    if Registers.__contains__(op2.lower()):
                        instruction+=Registers[op2.lower()]
                    else:
                        if Instruction32.__contains__(instruc.lower()):
                            Ldm=1
                        if instruc.lower()!="shl" and instruc.lower()!="shr" and instruc.lower()!="ldm":
                            op2=int(op2,16)
                            BinNum=(format(int(op2), "#07b")[2:])
                            instruction+=BinNum

                    if Registers.__contains__(op1.lower()): # if false the immediate value
                        instruction+=Registers[op1.lower()]

                    if instruc.lower()=="shl" or instruc.lower()=="shr":
                            instruction+="000"
                            op2=int(op2,16)
                            BinNum=(format(int(op2), "#07b")[2:])
                            instruction+=BinNum
                    if instruc.lower()!="shl" and instruc.lower()!="shr":
                        instruction+="00000"
                        if Instruction32.__contains__(instruc.lower()):
                            instruction+="000"

                    
        elif NoOperand.__contains__(line.lower()) :
            instruction+=NoOperand[line.lower()]
            instruction+="00000000000"
    if instruction!="":
        out[i]=instruction
        i+=1
        if Ldm==1:
            Ldm=0
            op2=int(op2,16)
            out[i]=format(int(op2), "#018b")[2:]
            i+=1
    #will check if the instruction two or one operand



for line in out:
    if line==0:
        if i>0:
            InstructionMemory.write('\n')
        i-=1
    else:
        InstructionMemory.write(line)
        InstructionMemory.write('\n')
        i-=1



ft.close()
InstructionMemory.close()