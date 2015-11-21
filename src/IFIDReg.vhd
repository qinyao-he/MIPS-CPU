----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:30:22 11/22/2015 
-- Design Name: 
-- Module Name:    IFIDReg - RTL 
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

entity IFIDReg is
	port (
		Clock : in std_logic;
		Reset : in std_logic;
		WriteEN : in std_logic;

		InstructionInput : in std_logic_vector(15 downto 0);
		PCInput : in std_logic_vector(15 downto 0);
		RPCInput : in std_logic_vector(15 downto 0);

		InstructionOutput : out std_logic_vector(15 downto 0);
		PCOutput : out std_logic_vector(15 downto 0);
		RPCOutput : out std_logic_vector(15 downto 0)
	);
end IFIDReg;

architecture RTL of IFIDReg is
	signal InstructionReg : std_logic_vector(15 downto 0);
	signal PCReg : std_logic_vector(15 downto 0);
	signal RPCReg : std_logic_vector(15 downto 0);
begin

	InstructionOutput <= InstructionReg;
	PCOutput <= PCReg;
	RPCOutput <= RPCReg;

	process(Clock)
	begin
		if rising_edge(Clock) then
			if Reset = '1' then
				InstructionReg <= (others => '0');
				PCReg <= (others => '0');
				RPCReg <= (others => '0');
			elsif WriteEN = '1' then
				InstructionReg <= InstructionInput;
				PCReg <= PCInput;
				RPCReg <= RPCInput;
			end if;
		end if;
	end process;

end RTL;
