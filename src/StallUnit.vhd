----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 何钦尧
-- 
-- Create Date:    16:34:57 11/29/2015 
-- Design Name: 
-- Module Name:    StallUnit - RTL 
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

entity StallUnit is
	port (
		Branch : in std_logic;
		Hazard : in std_logic;
		Stall : in std_logic;

		PCWriteEN : out std_logic;
		IFIDWriteEN : out std_logic;
		IDEXWriteEN : out std_logic;
		EXMEMWriteEN : out std_logic;
		MEMWBWriteEN : out std_logic;

		PCClear : out std_logic;
		IFIDClear : out std_logic;
		IDEXClear : out std_logic;
		EXMEMClear : out std_logic;
		MEMWBClear : out std_logic
	);
end StallUnit;

architecture RTL of StallUnit is

begin

	PCWriteEN 	<=	'0' when Stall='1' else
					'0' when Hazard='1' else
					'1';
	IFIDWriteEN <=	'0' when Stall='1' else
					'0' when Hazard='1' else
					'1';
	IDEXWriteEN <=	'0' when Stall='1' else
					'1';
	EXMEMWriteEN <=	'0' when Stall='1' else
					'1';
	MEMWBWriteEN <=	'0' when Stall='1' else
					'1';

	PCClear <= '0';
	IFIDClear <= '1' when Branch='1' else '0';
	IDEXClear <= '1' when Hazard='1' else '0';
	EXMEMClear <= '0';
	MEMWBClear <= '0';

end RTL;

