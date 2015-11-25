----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 黄科
-- 
-- Create Date:    02:51:30 11/22/2015 
-- Design Name: 
-- Module Name:    ForwardUnit - Behavioral 
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

entity ForwardUnit is
	port (
		EXMEMRegWrite : in std_logic;
		MEMWBRegWrite : in std_logic;
		EXMEMRegDest : in std_logic_vector (3 downto 0);
		MEMWBRegDest : in std_logic_vector (3 downto 0);
		IDEXRegSrcA: in std_logic_vector (3 downto 0);
		IDEXRegSrcB: in std_logic_vector (3 downto 0);
		ForwardA : out std_logic_vector (1 downto 0);
		ForwardB : out std_logic_vector (1 downto 0));
end ForwardUnit;

architecture Behavioral of ForwardUnit is
	signal ForwardATemp : std_logic_vector (1 downto 0);
	signal ForwardBTemp : std_logic_vector (1 downto 0);
begin
	ForwardA <= ForwardATemp;
	ForwardB <= ForwardBTemp;
	ForwardATemp <= "01" when EXMEMRegWrite = '1' and EXMEMRegDest = IDEXRegSrcA else
					"10" when MEMWBRegWrite = '1' and MEMWBRegDest = IDEXRegSrcA and not((EXMEMRegWrite = '1') and EXMEMRegDest = IDEXRegSrcA) else
					"00";
	ForwardBTemp <= "01" when EXMEMRegWrite = '1' and EXMEMRegDest = IDEXRegSrcB else
					"10" when MEMWBRegWrite = '1' and MEMWBRegDest = IDEXRegSrcB and not((EXMEMRegWrite = '1') and EXMEMRegDest = IDEXRegSrcB) else
					"00";
end Behavioral;

