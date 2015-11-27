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
signal SllTmp : std_logic_vector (15 downto 0);
signal SraTmp0 : std_logic_vector (15 downto 0);
signal SraTmp1 : std_logic_vector (15 downto 0);
begin
	Output <= OutputTmp;
	SllTmp <= InputA(14 downto 0) & '0' when InputB (2 downto 0) = "001" else
			InputA(13 downto 0) & "00" when InputB (2 downto 0) = "010" else
			InputA(12 downto 0) & "000" when InputB (2 downto 0) = "011" else
			InputA(11 downto 0) & "0000" when InputB (2 downto 0) = "100" else
			InputA(10 downto 0) & "00000" when InputB (2 downto 0) = "101" else
			InputA(9 downto 0) & "000000" when InputB (2 downto 0) = "110" else
			InputA(8 downto 0) & "0000000" when InputB (2 downto 0) = "111" else
			InputA(7 downto 0) & "00000000" when InputB (2 downto 0) = "000";
	SraTmp0 <= '0' & InputA(15 downto 1) when InputB (2 downto 0) = "001" else
			"00" & InputA(15 downto 2) when InputB (2 downto 0) = "010" else
			"000" & InputA(15 downto 3) when InputB (2 downto 0) = "011" else
			"0000" & InputA(15 downto 4) when InputB (2 downto 0) = "100" else
			"00000" & InputA(15 downto 5) when InputB (2 downto 0) = "101" else
			"000000" & InputA(15 downto 6) when InputB (2 downto 0) = "110" else
			"0000000" & InputA(15 downto 7) when InputB (2 downto 0) = "111" else
			"00000000" & InputA(15 downto 8) when InputB (2 downto 0) = "000";
	SraTmp1 <= '1' & InputA(15 downto 1) when InputB (2 downto 0) = "001" else
			"11" & InputA(15 downto 2) when InputB (2 downto 0) = "010" else
			"111" & InputA(15 downto 3) when InputB (2 downto 0) = "011" else
			"1111" & InputA(15 downto 4) when InputB (2 downto 0) = "100" else
			"11111" & InputA(15 downto 5) when InputB (2 downto 0) = "101" else
			"111111" & InputA(15 downto 6) when InputB (2 downto 0) = "110" else
			"1111111" & InputA(15 downto 7) when InputB (2 downto 0) = "111" else
			"11111111" & InputA(15 downto 8) when InputB (2 downto 0) = "000";

	OutputTmp <=InputA + InputB when ALUop = "000" else
			InputA - InputB when ALUop = "001" else
			InputA and InputB when ALUop = "010" else
			SllTmp when ALUop = "011" else
			SraTmp0 when ALUop = "100" and InputA(15) = '0' else
			SraTmp1 when ALUop = "100" and InputA(15) = '1' else
			InputA or InputB when ALUop = "101" else
			"0000000000000000";
	ALUFlags(1) <= 	'1' when OutputTmp < 0 else
				'0';
	ALUFlags(0) <= 	'1' when OutputTmp = 0 else
				'0';
end architecture; -- arch