# MIPS-CPU

This is repo for course project Computer Organization in Tsinghua University.

Here we implement a full-featured computer system using VHDL on the THINKPAD experimental board provided by course lab.

## Author
We are three Junior Student of Department of Computer Science and Technology, Tsinghua University. This project is finished within three weeks.

* **何钦尧** (He Qinyao), designer of the whole system architecture and do most of the coding and debuging work.
* **王凯** (Wang Kai), implement the whole VGA interface, with an easy-to-integrate Graphical Card solution.
* **黄科** (Huang Ke), implement keyboard interface and notepad program. Responsible for the integration work of each separate components.

## Features
This CPU support 30 instructions in THCO-MIPS instruction set (which is slightly modified on basis of MIPS16e). The whole set of instruction we support can be found in doc directory.

The whole system can run at a CPU frequency of 37.5MHz(not very stable, this limits may vary).

System can recieve input from serial port and PS/2 keyboard. And you can write program to write data into a specific memory address which is preserved for graphical memory, and those data will immediately be displayed on the VGA display.

## Hardware
* THINPAD experiment board
* VGA display
* PS/2 keyboard

## Software
* Xilinx ISE 14.3

## License
With MIT License.

But as it is a homework in Tsinghua University, plagiarize it as your homework is not encouraged. **Try work it out youself!**