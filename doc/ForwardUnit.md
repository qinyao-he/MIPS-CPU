# ForwardUnit 设计

## 输入

### EXMEMRegWrite

### MEMWBRegWrite

### EXMEMRegDest(3:0)

### MEMWBRegDest(3:0)

### IDEXRegSrcA(3:0)

### IDEXRegSrcB(3:0)

## 输出

### ForwardA(1:0)

```
if (EXMEMRegWrite = 1) and (EXMEMRegDest = IDEXRegSrcA)
	ForwardA = 01
else if (MEMWBRegWrite = 1) and (MEMWBRegDest = IDEXRegSrcA)
		and not((EXMEMRegWrite = 1) and (EXMEMRegDest = IDEXRegSrcA))
	ForwardA = 10
else
	ForwardA = 00
```

### ForwardB(1:0)

```
if (EXMEMRegWrite = 1) and (EXMEMRegDest = IDEXRegSrcB)
	ForwardB = 01
else if (MEMWBRegWrite = 1) and (MEMWBRegDest = IDEXRegSrcB)
		and not((EXMEMRegWrite = 1) and (EXMEMRegDest = IDEXRegSrcB))
	ForwardB = 10
else
	ForwardB = 00
```