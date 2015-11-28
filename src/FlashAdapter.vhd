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
		Address : in std_logic_vector(22 downto 0);
		OutputData : out std_logic_vector(15 downto 0);
		ctl_read : in std_logic;

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
	type STATE_TYPE is (INIT, READ1, READ2, READ3, READ4);
	signal state : STATE_TYPE;
	signal ctl_read_last : std_logic;
begin

	FlashByte <= '1';
	FlashVpen <= '1';
	FlashRP <= '1';

	process(Clock, Reset)
	begin
		if Reset = '1' then
			state <= INIT;
			FlashWE <= '1';
			FlashOE <= '1';
			FlashData <= (others => 'Z');
			ctl_read_last <= ctl_read;
		elsif rising_edge(Clock) then
			case state is
				when INIT =>
					if ctl_read_last /= ctl_read then
						state <= READ1;
						FlashWE <= '0';
					else
						state <= INIT;
					end if;
				when READ1 =>
					state <= READ2;
					FlashData <= x"00FF";
				when READ2 =>
					state <= READ3;
					FlashWE <= '1';
				when READ3 =>
					state <= READ4;
					FlashOE <= '0';
					FlashAddr <= Address;
					FlashData <= (others => 'Z');
				when READ4 =>
					state <= INIT;
					OutputData <= FlashData;
				when others =>
					FlashWE <= '1';
					FlashOE <= '1';
					FlashData <= (others => 'Z');
					state <= INIT;
			end case;
		end if;
	end process;

end Behavioral;

