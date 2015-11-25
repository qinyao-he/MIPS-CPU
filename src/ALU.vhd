----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 黄科
-- 
-- Create Date:    03:26:37 11/22/2015 
-- Design Name: 
-- Module Name:    ALU - arch 
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ALU is
	Port (
		InputA : in std_logic_vector (15 downto 0);
		InputB : in std_logic_vector (15 downto 0);
		ALUop : in std_logic_vector (2 downto 0);
		Output : out std_logic_vector (15 downto 0) := "0000000000000000";
		ALUFlags : out std_logic_vector(1 downto 0));
end ALU;

architecture arch of ALU is
signal OutputTmp : std_logic_vector (15 downto 0);
begin
	Output <= OutputTmp;
	OutputTmp <=InputA + InputB when ALUop = "000" else
			InputA - InputB when ALUop = "001" else
			InputA and InputB when ALUop = "010" else
			to_stdlogicvector(to_bitvector(InputA) sll conv_integer(InputB(3 downto 0))) when ALUop = "011" and InputB /= "0000000000000000" else
			to_stdlogicvector(to_bitvector(InputA) sll 8) when ALUop = "011" and InputB = "0000000000000000" else
			to_stdlogicvector(to_bitvector(InputA) sra conv_integer(InputB(3 downto 0))) when ALUop = "100" and InputB /= "0000000000000000" else
			to_stdlogicvector(to_bitvector(InputA) sra 8) when ALUop = "100" and InputB = "0000000000000000" else
			InputA or InputB when ALUop = "101" else
			"0000000000000000";
	ALUFlags(1) <= 	'1' when OutputTmp < 0 else
				'0';
	ALUFlags(0) <= 	'1' when OutputTmp = 0 else
				'0';
end architecture; -- arch