----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 何钦尧
-- 
-- Create Date:    22:32:35 11/19/2015 
-- Design Name: 
-- Module Name:    Mux16 - Behavioral 
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

entity Mux16 is
	port (
		Control : in std_logic;
		InputA : in std_logic_vector(15 downto 0);
		InputB : in std_logic_vector(15 downto 0);
		Output : out std_logic_vector(15 downto 0)
	);
end Mux16;

architecture RTL of Mux16 is

begin

	with Control select
		Output <= InputA when '0',
				  InputB when '1',
				  (others => '0') when others;

end RTL;
