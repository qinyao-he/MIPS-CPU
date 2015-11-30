----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 黄科
-- 
-- Create Date:    03:26:37 11/22/2015 
-- Design Name: 
-- Module Name:    HazardUnit - Behavioral 
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

entity HazardUnit is
	port (
		IDEXMemRead : in std_logic;
		IDEXRegDest : in std_logic_vector (3 downto 0);
		RegSrcA : in std_logic_vector (3 downto 0);
		RegSrcB: in std_logic_vector (3 downto 0);
		
		HazardHappen : out std_logic
	);
end HazardUnit;

architecture Behavioral of HazardUnit is
begin

	HazardHappen <= '1' when IDEXMemRead = '1' and (IDEXRegDest = RegSrcA or IDEXRegDest = RegSrcB) else '0';

end Behavioral;

