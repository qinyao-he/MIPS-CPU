----------------------------------------------------------------------------------
-- Company:
-- Engineer: 何钦尧
--
-- Create Date:    01:21:49 11/22/2015
-- Design Name:
-- Module Name:    MEMWBReg - RTL
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

entity MEMWBReg is
	port (
		Clock : in std_logic;
		Reset : in std_logic;
		WriteEN : in std_logic;

		RegWriteInput : in std_logic;
		MemToRegInput : in std_logic;
		RegDestInput : in std_logic_vector(3 downto 0);
		EXResultInput : in std_logic_vector(15 downto 0);
		MemDataInput : in std_logic_vector(15 downto 0);

		RegWriteOutput : out std_logic;
		MemToRegOutput : out std_logic;
		RegDestOutput : out std_logic_vector(3 downto 0);
		EXResultOutput : out std_logic_vector(15 downto 0);
		MemDataOutput : out std_logic_vector(15 downto 0)
	);
end MEMWBReg;

architecture RTL of MEMWBReg is
	signal RegWriteReg : std_logic;
	signal MemToRegReg : std_logic;
	signal RegDestReg : std_logic_vector(3 downto 0);
	signal EXResultReg : std_logic_vector(15 downto 0);
	signal MemDataReg : std_logic_vector(15 downto 0);
begin

	RegWriteOutput <= RegWriteReg;
	MemToRegOutput <= MemToRegReg;
	RegDestOutput <= RegDestReg;
	EXResultOutput <= EXResultReg;
	MemDataOutput <= MemDataReg;

	process(Clock, Reset)
	begin
		if Reset = '1' then
			RegWriteReg <= '0';
			MemToRegReg <= '0';
			RegDestReg <= (others => '0');
			EXResultReg <= (others => '0');
			MemDataReg <= (others => '0');
		elsif rising_edge(Clock) then
			if WriteEN = '1' then
				RegWriteReg <= RegWriteInput;
				MemToRegReg <= MemToRegInput;
				RegDestReg <= RegDestInput;
				EXResultReg <= EXResultInput;
				MemDataReg <= MemDataInput;
			end if;
		end if;
	end process;

end RTL;

