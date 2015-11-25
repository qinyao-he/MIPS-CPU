----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 王凯
-- 
-- Create Date:    23:31:22 11/20/2015 
-- Design Name: 
-- Module Name:    Extender - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Extender is
	port (Instruction : in  std_logic_vector (15 downto 0);
		Output : out  std_logic_vector (15 downto 0));
end Extender;

architecture Behavioral of Extender is
	signal from7to0: std_logic_vector(7 downto 0);
	signal from3to0: std_logic_vector(3 downto 0);
	signal from10to0: std_logic_vector(10 downto 0);
	signal from4to0: std_logic_vector(4 downto 0);
	signal from4to2: std_logic_vector(2 downto 0);
	signal first5 : std_logic_vector(4 downto 0);
	signal first8 : std_logic_vector(7 downto 0);
begin
	first5   <= Instruction(15 downto 11);
	first8	 <= Instruction(15 downto  8);
	from7to0 <= Instruction(7  downto  0);
	from3to0 <= Instruction(3  downto  0);
	from10to0<= Instruction(10 downto  0);
	from4to0 <= Instruction(4  downto  0);
	from4to2 <= Instruction(4  downto  2);
	Output	<=	EXT(from7to0, Output'length)when first5 = "01101" -- LI
											else
				EXT(from4to2, Output'length)when first5 = "00110" -- SLL+SRA
											else
				SXT(from7to0, Output'length)when first5 = "01001" -- ADDIU
											or first8 = "01100011" --ADDSP
											or first8 = "01100000" -- BTEQZ
											or first8 = "01100001" -- BTNEZ
											or first5 = "10010" -- LW_SP
											or first5 = "11010" -- SW_SP
											or first5 = "00100" -- BEQZ
											else
				SXT(from3to0, Output'length)when first5 = "01000" -- ADDIU3
											else
				SXT(from10to0, Output'length)when first5 = "00010" -- B
											or first5 = "00101" -- BNEZ
											else
				SXT(from4to0, Output'length)when first5 = "10011" -- LW
											or first5 = "11011" -- SW
											else
				(others=>'0');
end Behavioral;

