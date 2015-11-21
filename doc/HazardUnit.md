# HazardUnit 设计

## 输入

### IDEXMemRead

### IDEXRegDest(3:0)

### RegSrcA(3:0)

### RegSrcB(3:0)

## 输出

### PCWrite

### IFIDWrite

### IDEXClear

## 工作原理
当IDEXMemRead=1且IDEXRegDest等于RegSrcA或者RegSrcB的任何一个的时候，在IDEX段（即当前正在执行EXE段）的指令是一条load指令，且load到的寄存器需要在ID阶段执行的指令被使用到。这个时候由于冲突无法通过旁路解决，需要暂停流水线，这里将PC和IFID禁止写入，同时在IDEX清空（这样就把当前ID阶段的指令的各种控制信号清零了），这样等待一个周期之后，下一次这条指令再次执行的时候，就可以正常旁路了。

```
if (IDEXMemRead = 1)
	and ((IDEXRegDest = RegSrcA) or (IDEXRegDest = RegSrcB))
	PCWrite = 0
    IFIDWrite = 0
    IDEXClear = 1
else
	PCWrite = 1
    IFIDWrite = 1
    IDEXClear = 0
```