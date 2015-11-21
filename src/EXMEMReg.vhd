----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 何钦尧
-- 
-- Create Date:    01:06:00 11/22/2015 
-- Design Name: 
-- Module Name:    EXMEMReg - RTL 
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

entity EXMEMReg is
	port (
		Clock : in std_logic;
		Reset : in std_logic;
		WriteEN : in std_logic;

		RegWriteInput : in std_logic;
		MemReadInput : in std_logic;
		MemWriteInput : in std_logic;
		RegDestInput : in std_logic_vector(3 downto 0);
		MemToRegInput : in std_logic;
		EXResultInput : in std_logic_vector(15 downto 0);
		RegDataAInput : in std_logic_vector(15 downto 0);
		RegDataBInput : in std_logic_vector(15 downto 0);

		RegWriteOutput : out std_logic;
		MemReadOutput : out std_logic;
		MemWriteOutput : out std_logic;
		RegDestOutput : out std_logic_vector(3 downto 0);
		MemToRegOutput : out std_logic;
		EXResultOutput : out std_logic_vector(15 downto 0);
		RegDataAOutput : out std_logic_vector(15 downto 0);
		RegDataBOutput : out std_logic_vector(15 downto 0)
	);
end EXMEMReg;

architecture RTL of EXMEMReg is
	signal RegWriteReg : std_logic;
	signal MemReadReg : std_logic;
	signal MemWriteReg : std_logic;
	signal RegDestReg : std_logic_vector(3 downto 0);
	signal MemToRegReg : std_logic;
	signal EXResultReg : std_logic_vector(15 downto 0);
	signal RegDataAReg : std_logic_vector(15 downto 0);
	signal RegDataBReg : std_logic_vector(15 downto 0);
begin

	RegWriteOutput <= RegWriteReg;
	MemReadOutput <= MemReadReg;
	MemWriteOutput <= MemWriteReg;
	RegDestOutput <= RegDestReg;
	MemToRegOutput <= MemToRegReg;
	EXResultOutput <= EXResultReg;
	RegDataAOutput <= RegDataAReg;
	RegDataBOutput <= RegDataBReg;

	process(Clock)
	begin
		if rising_edge(Clock) then
			if Reset = '1' then
				RegWriteReg <= '0';
				MemReadReg <= '0';
				MemWriteReg <= '0';
				RegDestReg <= (others => '0');
				MemToRegReg <= '0';
				EXResultReg <= (others => '0');
				RegDataAReg <= (others => '0');
				RegDataBReg <= (others => '0');
			elsif WriteEN = '1' then
				RegWriteReg <= RegWriteInput;
				MemReadReg <= MemReadInput;
				MemWriteReg <= MemWriteInput;
				RegDestReg <= RegDestInput;
				MemToRegReg <= MemToRegInput;
				EXResultReg <= EXResultInput;
				RegDataAReg <= RegDataAInput;
				RegDataBReg <= RegDataBInput;
			end if;
		end if;
	end process;

end RTL;

