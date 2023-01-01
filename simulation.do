python inst.py
vlog ALU.v
vlog controller.v
vlog controllerTB.v
vlog controlUnit.v
vlog dataMemory.v
vlog DEBuffer.v
vlog defines.v
vlog EMBuffer.v
vlog FDBuffer.v
vlog forwarding-unit.v
vlog hazardDetectionUnit.v
vlog instructionMemory.v
vlog MWBuffer.v
vlog pc.v
vlog regfile.v
vlog processor.v
vlog stackPointer.v
vlog writeBack.v
vsim -gui work.controllerTB
add wave -color #00eaff sim:/controllerTB/controller/processor/clk
add wave sim:/controllerTB/controller/processor/pc
add wave sim:/controllerTB/controller/processor/sp
add wave sim:/controllerTB/controller/processor/CCR
add wave sim:/controllerTB/controller/processor/reset
add wave sim:/controllerTB/controller/processor/interruptSignal
add wave sim:/controllerTB/controller/processor/inPortData
add wave sim:/controllerTB/controller/processor/outPortData
add wave sim:/controllerTB/controller/processor/outSignalEn
add wave sim:/controllerTB/controller/processor/memData
add wave sim:/controllerTB/controller/processor/writeMemData


