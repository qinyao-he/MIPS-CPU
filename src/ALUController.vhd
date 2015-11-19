----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:33:06 11/19/2015 
-- Design Name: 
-- Module Name:    ALUController - Behavioral 
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
use ieee.std_logic_signed.all;

entity ALUController is
	port ( 
		Instruction: in std_logic_vector(15 downto 0);
		ALUOp: out std_logic_vector(2 downto 0)
	);
end entity ; -- ALUController

architecture Behavioral of ALUController is
	signal first5 : std_logic_vector(4 downto 0);
	signal first8 : std_logic_vector(7 downto 0);
	signal last2  : std_logic_vector(1 downto 0);
	signal last5  : std_logic_vector(4 downto 0);
begin
	first5	<=	Instruction(15 downto 11);
	first8	<=	Instruction(15 downto  8);
	last2	<=	Instruction(1  downto  0);
	last5	<=	Instruction(4  downto  0);
	ALUOp	<=	"000"	when first5 = "01001" 
						or first5 = "01000" 
						or first5 = "11100" 
						or first5 = "01001" 
						or first5 = "10011" 
						or first5 = "10010"
						or first5 = "10011"
						or first5 = "11010"
						or first8 = "01100011" else
				"001"	when (first5 = "11101" and last5 = "01010") or (first5 = "11100" and last2 = "11") else
				"010"	when first5 = "11101" and last5 = "01100" else
				"011"	when first5 = "00110" and last2 = "00" else
				"100"	when first5 = "00110" and last2 = "11" else
				"101"	when first5 = "11101" and last5 = "01101";
end architecture;

