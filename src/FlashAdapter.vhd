----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    01:13:23 11/27/2015
-- Design Name:
-- Module Name:    FlashAdapter - Behavioral
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FlashAdapter is
	port (
		Clock : in std_logic;
		Reset : in std_logic;
		Address : in std_logic_vector(22 downto 1);
		OutputData : out std_logic_vector(15 downto 0);

		FlashByte : out std_logic;
		FlashVpen : out std_logic;
		FlashCE : out std_logic;
		FlashOE : out std_logic;
		FlashWE : out std_logic;
		FlashRP : out std_logic;

		FlashAddr : out std_logic_vector(22 downto 0);
		FlashData : inout std_logic_vector(15 downto 0)
	);
end FlashAdapter;

architecture Behavioral of FlashAdapter is
	type STATE_TYPE is (OPSET, DATA_READ);
	signal state : STATE_TYPE;
begin

	FlashByte <= '1';
	FlashVpen <= '1';
	FlashRP <= '1';

	FlashWE <= '0' when state=OPSET else '1';
	FlashOE <= '0' when state=DATA_READ else '1';
	FlashAddr <= "00000000000000000000000" when state=OPSET else
				Address & '0' when state=DATA_READ;
	FlashData <= x"00FF" when state=OPSET else (others => 'Z');

	process(Clock, Reset)
	begin
		if Reset = '1' then
			state <= OPSET;
		elsif rising_edge(Clock) then
			case state is
				when OPSET =>
					state <= DATA_READ;
				when DATA_READ =>
					state <= OPSET;
				when others =>
					state <= OPSET;
			end case;
		end if;
	end;

end Behavioral;

