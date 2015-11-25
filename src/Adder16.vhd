----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 黄科
-- 
-- Create Date:    03:26:37 11/22/2015 
-- Design Name: 
-- Module Name:    Adder16 - arch 
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