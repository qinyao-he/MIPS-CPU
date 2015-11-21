----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 何钦尧
-- 
-- Create Date:    19:09:48 11/19/2015 
-- Design Name: 
-- Module Name:    PCReg - RTL 
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

entity PCReg is
	port (
		Clock : in std_logic;
		Reset : in std_logic;
		WriteEN : in std_logic;
		Input : in std_logic_vector(15 downto 0);
		Output : out std_logic_vector(15 downto 0)
	);
end PCReg;

architecture RTL of PCReg is
	signal PCReg : std_logic_vector(15 downto 0);
begin
	
	Output <= PCReg;

	process(Clock)
	begin
		if rising_edge(Clock) then
			if Reset = '1' then
				PCReg <= (others => '0');
			elsif WriteEN = '1' then
				PCReg <= Input;
			end if;
		end if;
	end process;

end RTL;
