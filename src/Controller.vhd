----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    00:47:43 11/22/2015
-- Design Name:
-- Module Name:    Controller - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Controller is
    Port ( Instruction : in  std_logic_vector (15 downto 0);
           TType : out  std_logic;
           EXResultSelect : out  std_logic_vector (1 downto 0);
           RegWrite : out  std_logic;
           MemRead : out  std_logic;
           MemWrite : out  std_logic;
           BranchType : out  std_logic_vector (1 downto 0);
           Jump : out  std_logic;
           RegSrcA : out  std_logic_vector (3 downto 0);
           RegSrcB : out  std_logic_vector (3 downto 0);
           RegDest : out  std_logic_vector (3 downto 0);
           ALUSrc : out  std_logic;
           MemToReg : out  std_logic);
end Controller;

architecture Behavioral of Controller is
	signal first5 : std_logic_vector(4 downto 0);
	signal first8 : std_logic_vector(7 downto 0);
	signal last2  : std_logic_vector(1 downto 0);
	signal last5  : std_logic_vector(4 downto 0);
	signal last8  : std_logic_vector(7 downto 0);
	signal Raddr10to8:std_logic_vector(3 downto 0);
	signal Raddr7to5:std_logic_vector(3 downto 0);
	signal Raddr4to2:std_logic_vector(3 downto 0);
begin
	first5	<= Instruction(15 downto 11);
	first8	<= Instruction(15 downto  8);
	last2	<= Instruction(1  downto  0);
	last5	<= Instruction(4  downto  0);
	last8 <= Instruction(7  downto  0);
	Raddr10to8 <= '1' & Instruction(10 downto 8);
	Raddr7to5  <= '1' & Instruction(7 downto 5);
	Raddr4to2  <= '1' & Instruction(4 downto 2);
	TType 	<= 	'1' when (first5 = "11101" and last5 = "00010") -- SLT
				else
				'0';
	EXResultSelect <= 	"01"when (first5 = "11101" and last5 = "01010") -- CMP
							or (first5 = "11101" and last5 = "00010") -- SLT
							else
						"11"when (first5 = "11101" and last8 = "11000000") -- JALR
							or first5 = "01101" -- LI
							or (first5 = "11110" and last8 = "00000000") -- MFIH
							or (first5 = "11101" and last8 = "01000000") -- MFPC
							or (first5 = "01111" and last5 = "00000") -- MOVE
							or (first5 = "11110" and last8 = "00000001") -- MTIH
							or (first8 = "01100100" and last5 = "00000") -- MTSP
							else
						"00";
	RegWrite <= '1' when first5 = "01001" -- ADDIU
					or first5 = "01000" -- ADDIU3
					or first8 = "01100011" -- ADDSP
					or (first5 = "11100" and last2 = "01") -- ADDU
					or (first5 = "11101" and last5 = "01100") -- AND
					or (first5 = "11101" and last5 = "01010") --CMP
					or (first5 = "11101" and last8 = "11000000") -- JALR
					or first5 = "01101" -- LI
					or first5 = "10011" --LW
					or first5 = "10010" -- LW_SP
					or (first5 = "11110" and last8 = "00000000") -- MFIH
					or (first5 = "11101" and last8 = "01000000") -- MFPC
					or (first5 = "01111" and last5 = "00000") -- MOVE
					or (first5 = "11110" and last8 = "00000001") -- MTIH
					or (first8 = "01100100" and last5 = "00000") -- MTSP
					or (first5 = "11101" and last5 = "01101") -- OR
					or (first5 = "00110" and last2 = "00") -- SLL
					or (first5 = "11101" and last5 = "00010") -- SLT
					or (first5 = "00110" and last2 = "11") -- SRA
					or (first5 = "11100" and last2 = "11") -- SUBU
					else
				'0';
	MemWrite<=	'1' when first5 = "11011" -- SW
					or first5 = "11010" -- SW_SP
					else
				'0';
	MemRead	<=	'1' when first5 = "10011" -- LW
					or first5 = "10010" -- LW_SP
					else
				'0';
	Jump<=	'1' when (first5 = "11101" and last8 = "00000000") -- JR
				or (first5 = "11101" and last8 = "11000000") -- JALR
				or Instruction = "1110100000100000" -- JRRA
				else
			'0';
	BranchType	<= 	"01"	when first5 = "00010" -- B
							else
					"10"	when first5 = "00100" -- BEQZ
							or first8 = "01100000" -- BTEQZ
							else
					"11"	when first5 = "00101" -- BNEZ
							or first8 = "01100001" -- BTNEZ
							else
					"00";
	RegSrcA <= 	Raddr10to8 	when first5 = "01001" -- ADDIU
							or first5 = "01000" -- ADDIU3
							or (first5 = "11100" and last2 = "01") -- ADDU
							or (first5 = "11101" and last5 = "01100") -- AND
							or (first5 = "11101" and last5 = "01010") -- CMP
							or (first5 = "11101" and last8 = "00000000") -- JR
							or (first5 = "11101" and last8 = "11000000") -- JALR
							or first5 = "10011" -- LW
							or (first5 = "11101" and last5 = "01101") -- OR
							or (first5 = "11101" and last5 = "00010") -- SLT
							or (first5 = "11100" and last2 = "11") -- SUBU
							or first5 = "11011" -- SW
							else
				Raddr7to5 	when (first5 = "00110" and last2 = "00") -- SLL
							or (first5 = "00110" and last2 = "11") -- SRA
							else
				"0010"		when first8 = "01100011" -- ADDSP
							or first5 = "10010" -- LW_SP
							or first5 = "11010" -- SW_SP
							else
				"0101"		when first8 = "01100000" -- BTEQZ
							or first8 = "01100001" -- BTNEZ
							else
				"0100"		when Instruction = "1110100000100000" -- JRRA
							else
				"0000";
	RegSrcB	<=	Raddr7to5 	when (first5 = "11100" and last2 = "01") -- ADDU
							or (first5 = "11101" and last5 = "01100") -- AND
							or (first5 = "11101" and last5 = "01010") -- CMP
							or (first5 = "01111" and last5 = "00000") -- MOVE
							or (first8 = "01100100" and last5 = "00000") -- MTSP
							or (first5 = "11101" and last5 = "01101") -- OR
							or (first5 = "11101" and last5 = "00010") -- SLT
							or (first5 = "11100" and last2 = "11") -- SUBU
							or first5 = "11011" -- SW
							else
				Raddr10to8	when (first5 = "11110" and last8 = "00000001") -- MTIH
							or first5 = "11010" -- SW_SP
							else
				"0110" 		when (first5 = "11101" and last8 = "11000000") -- JALR
							else
				"0011"		when (first5 = "11110" and last8 = "00000000") -- MFIH
							else
				"0001"		when (first5 = "11101" and last8 = "01000000") -- MFPC
							else
				"0000";
	RegDest	<=	Raddr10to8	when first5 = "01001" -- ADDIU
							or (first5 = "11101" and last5 = "01100") -- AND
							or first5 = "01101" -- LI
							or first5 = "10010" -- LW_SP
							or (first5 = "11110" and last8 = "00000000") -- MFIH
							or (first5 = "11101" and last8 = "01000000") -- MFPC
							or (first5 = "01111" and last5 = "00000") -- MOVE
							or (first5 = "11101" and last5 = "01101") -- OR
							or (first5 = "00110" and last2 = "00") -- SLL
							or (first5 = "00110" and last2 = "11") -- SRA
							else
				Raddr7to5	when first5 = "01000" -- ADDIU3
							or first5 = "10011" -- LW
							else
				Raddr4to2	when (first5 = "11100" and last2 = "01") -- ADDU
							or (first5 = "11100" and last2 = "11") -- SUBU
							else
				"0010"		when first8 = "01100011" -- ADDSP
							or (first8 = "01100100" and last5 = "00000") -- MTSP
							else
				"0101"		when (first5 = "11101" and last5 = "01010") -- CMP
							or (first5 = "11101" and last5 = "00010") -- SLT
							else
				"0100" 		when (first5 = "11101" and last8 = "11000000") -- JALR
							else
				"0011"		when (first5 = "11110" and last8 = "00000001") -- MTIH
							else
				"0000";
	ALUSrc	<=	'1'	when first5 = "01001" -- ADDIU
					or first5 = "01000" -- ADDIU3
					or first8 = "01100011" -- ADDSP
					or first5 = "01101" -- LI
					or first5 = "10011" -- LW
					or first5 = "10010" -- LW_SP
					or (first5 = "00110" and last2 = "00") -- SLL
					or (first5 = "00110" and last2 = "11") -- SRA
					or first5 = "11011" -- SW
					or first5 = "11010" -- SW_SP
					else
				'0';
	MemToReg<=	'1' when first5 = "10011" -- LW
					or first5 = "10010" -- LW_SP
					else
				'0';
end Behavioral;

