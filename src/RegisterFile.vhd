----------------------------------------------------------------------------------
-- Company:
-- Engineer: 何钦尧
--
-- Create Date:    23:26:23 11/18/2015
-- Design Name:
-- Module Name:    RegisterFile - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RegisterFile is
	port (
		Clock : in std_logic;
		Reset : in std_logic;
		WriteEN : in std_logic;
		ReadRegA : in std_logic_vector(3 downto 0);
		ReadRegB : in std_logic_vector(3 downto 0);
		WriteReg : in std_logic_vector(3 downto 0);
		WriteData : in std_logic_vector(15 downto 0);
		PCInput : in std_logic_vector(15 downto 0);
		RPCInput : in std_logic_vector(15 downto 0);
		ReadDataA : out std_logic_vector(15 downto 0);
		ReadDataB : out std_logic_vector(15 downto 0)
	);
end RegisterFile;

architecture RTL of RegisterFile is
	type RegFile is array(0 to 15) of std_logic_vector(15 downto 0);
	signal regs : RegFile;
begin

	--ReadDataA <= (others => '0') when ReadRegA = "0000" else
	--			PCInput when ReadRegA = "0001" else
	--			RPCInput when ReadRegA = "0110" else
	--			regs(to_integer(unsigned(ReadRegA)));

	--ReadDataB <= (others => '0') when ReadRegB = "0000" else
	--			PCInput when ReadRegB = "0001" else
	--			RPCInput when ReadRegB = "0110" else
	--			regs(to_integer(unsigned(ReadRegB)));

	with ReadRegA select
		ReadDataA <= (others => '0') when "0000",
					 PCInput when "0001",
					 RPCInput when "0110",
					 regs(to_integer(unsigned(ReadRegA))) when others;

	with ReadRegB select
		ReadDataB <= (others => '0') when "0000",
					 PCInput when "0001",
					 RPCInput when "0110",
					 regs(to_integer(unsigned(ReadRegB))) when others;

	--ReadDataA <= regs(to_integer(unsigned(ReadRegA)));
	--ReadDataB <= regs(to_integer(unsigned(ReadRegB)));

	process (Clock)
	begin
		if rising_edge(Clock) then
			if Reset = '1' then
				regs <= (others => (others => '0'));
			elsif WriteEN = '1' then
				regs(to_integer(unsigned(WriteReg))) <= WriteData;
			end if;
		end if;
	end process;

end RTL;
