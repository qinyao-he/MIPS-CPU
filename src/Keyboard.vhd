----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    01:06:04 11/27/2015
-- Design Name:
-- Module Name:    Keyboard - Behavioral
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
USE ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Keyboard is
port (
	PS2Data : in std_logic; -- PS2 data
	PS2Clock : in std_logic; -- PS2 clk
	Clock : in std_logic;
	Reset : in std_logic;
	DataReceive : in std_logic;
	DataReady : out std_logic ;  -- data output enable signal
	Output : out std_logic_vector(7 downto 0) -- scan code signal output
	);
end Keyboard;

architecture Behavioral of Keyboard is
type state_type is (delay, start, s0, s1, s2, s3, s4, s5, s6, s7, parity, stop, finish);
signal data, clk, clk1, clk2, odd, fokSignal : std_logic; -- 毛刺处理内部信号, odd为奇偶校验
signal code : std_logic_vector (7 downto 0);
signal OutputCode : std_logic_vector (7 downto 0);
signal st : std_logic_vector (3 downto 0) := "0000";
signal state : state_type;
begin
	clk1 <= PS2Clock when rising_edge(Clock);
	clk2 <= clk1 when rising_edge(Clock);
	clk <= (not clk1) and clk2;
	data <= PS2Data when rising_edge(Clock);
	odd <= code(0) xor code(1) xor code(2) xor code(3) xor code(4) xor code(5) xor code(6) xor code(7);
	OutputCode <= code when fokSignal = '1';
	-- DataReady <= fokSignal;

	process(Reset, Clock)
	begin
		if Reset = '1' then
			state <= delay ;
			code <= (others => '0') ;
			fokSignal <= '1';
			code <= "00000000";
			fokSignal <= '0';
			DataReady <= '0';
		elsif rising_edge(Clock) then
			fokSignal <= '0';
			case state is
				when delay =>
					state <= start;
				when start =>
					if clk = '1' then
						if data = '0' then
							state <= s0;
						else
							state <= delay;
						end if;
					end if;
				when s0 =>
					if clk = '1' then
						code(0) <= data;
						state <= s1;
					end if;
				when s1 =>
					if clk = '1' then
						code(1) <= data;
						state <= s2;
					end if;
				when s2 =>
					if clk = '1' then
						code(2) <= data;
						state <= s3;
					end if ;
				when s3 =>
					if clk = '1' then
						code(3) <= data;
						state <= s4;
					end if;
				when s4 =>
					if clk = '1' then
						code(4) <= data;
						state <= s5;
					end if;
				when s5 =>
					if clk = '1' then
						code(5) <= data;
						state <= s6;
					end if;
				when s6 =>
					if clk = '1' then
						code(6) <= data;
						state <= s7;
					end if;
				when s7 =>
					if clk = '1' then
						code(7) <= data;
						state <= parity;
					end if;
				WHEN parity =>
					IF clk = '1' then
						if (data xor odd) = '1' then
							state <= stop;
						else
							state <= delay;
						end if;
					END IF;

				WHEN stop =>
					IF clk = '1' then
						if data = '1' then
							state <= finish;
						else
							state <= delay;
						end if;
					END IF;

				WHEN finish =>
					state <= delay;
					fokSignal <= '1';
				when others =>
					state <= delay;
			end case;

			if OutputCode = "11110000" then
				st <= "0001";
			else
				case st is
					when "0001" =>
						DataReady <= '1';
						Output <= OutputCode;
						st <= "0000";
					when others =>
						st <= "0000";
				end case;
			end if;
			if DataReceive = '0' then
				DataReady <= '0';
			end if;

		end if;

	end process;
end Behavioral ;

