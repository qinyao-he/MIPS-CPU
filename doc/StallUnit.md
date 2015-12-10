# StallUnit 设计

## 输入

### Branch

### Hazard

### Stall

## 输出

### PCWriteEN

### IFIDWriteEN

### IDEXWriteEN

### EXMEMWriteEN

### MEMWBWriteEN

### PCClear

### IFIDClear

### IDEXClear

### EXMEMClear

### MEMWBClear

当发生Hazard的时候，PCWriteEN和IFIDWriteEN置0，IDEXClear置1。

当发生Branch的时候IFIDClear置1。

当Stall输入信号为1的时候，所有WriteEN置0。