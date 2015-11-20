library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Adder16 is
	Port (
		InputA : in std_logic_vector (15 downto 0);
		InputB : in std_logic_vector (15 downto 0);
		Output : out std_logic_vector (15 downto 0) := "0000000000000000");
end Adder16;

architecture arch of Adder16 is
-- signal Output_tmp : std_logic_vector (15 downto 0);
begin
	-- Output <= Output_tmp;
	Output <= InputA + InputB;

end architecture; -- arch