----------------------------------------------------------------------------------
-- Company:
-- Engineer: 何钦尧
--
-- Create Date:    16:09:26 11/23/2015
-- Design Name:
-- Module Name:    IOBridge - Behavioral
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
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IOBridge is
	port (
		Clock : in std_logic;
		Reset : in std_logic;
		CPUClock : out std_logic;

		ReadEN : in std_logic;
		WriteEN : in std_logic;

		Address1 : in std_logic_vector(15 downto 0);
		DataOutput1 : out std_logic_vector(15 downto 0);

		Address2 : in std_logic_vector(15 downto 0);
		DataInput2 : in std_logic_vector(15 downto 0);
		DataOutput2 : out std_logic_vector(15 downto 0);

		MemoryAddress : out std_logic_vector(17 downto 0);
		MemoryDataBus : inout std_logic_vector(15 downto 0);
		MemoryEN : out std_logic;
		MemoryOE : out std_logic;
		MemoryWE : out std_logic;

		RAM1EN : out std_logic;

		SerialWRN : out std_logic;
		SerialRDN : out std_logic;
		SerialDATA_READY : in std_logic;
		SerialTSRE : in std_logic;
		SerialTBRE : in std_logic;
		SerialDataBus : inout std_logic_vector(7 downto 0)
	);
end IOBridge;

architecture Behavioral of IOBridge is
	type STATE_TYPE is (INIT, DATA_WRITE, INS_READ, DATA_READ);
	signal state : STATE_TYPE;

	signal BufferData1, BufferData2 : std_logic_vector(15 downto 0);
	signal BF01 : std_logic_vector(15 downto 0);

	signal MemoryBusFlag, SerialBusFlag : std_logic;
begin

	MemoryEN <= '0';
	RAM1EN <= '1';

	DataOutput1 <= BufferData1;
	DataOutput2 <= BufferData2;

	MemoryWE <= '1' when (Address2=x"BF00" and state=DATA_WRITE) else
				not WriteEN when state=DATA_WRITE else
				'1';
	MemoryOE <= not ReadEN when state=DATA_READ else
				'0' when state=INS_READ else
				'1';

	MemoryBusFlag <= not WriteEN when (state=INIT or state=DATA_WRITE) else
					'1';
	SerialBusFlag <= not WriteEN when (state=INIT or state=DATA_WRITE) else
					'1';
	MemoryDataBus <= DataInput2 when MemoryBusFlag='0' else (others => 'Z');
	SerialDataBus <= DataInput2(7 downto 0) when SerialBusFlag='0' else (others => 'Z');

	MemoryAddress <= "00" & Address1 when state=INS_READ else
					"00" & Address2;

	SerialRDN <= not ReadEN when (Address2=x"BF00" and state=DATA_READ) else '1';
	SerialWRN <= not WriteEN when (Address2=x"BF00" and state=DATA_WRITE) else '1';

	BF01 <= "00000000000000" & SerialDATA_READY & SerialTSRE;

	process (Clock, Reset)
	begin
		if Reset = '1' then
			state <= INIT;
		elsif falling_edge(Clock) then
			case state is
				when INIT =>
					state <= DATA_WRITE;
				when DATA_WRITE =>
					state <= INS_READ;
				when INS_READ =>
					state <= DATA_READ;
					BufferData1 <= MemoryDataBus;
				when DATA_READ =>
					state <= INIT;
					case Address2 is
						when x"BF00" =>
							BufferData2 <= "00000000" & SerialDataBus;
						when x"BF01" =>
							BufferData2 <= BF01;
						when others =>
							BufferData2 <= MemoryDataBus;
					end case;
				when others =>
					state <= INIT;
			end case;
		end if;
	end process;

	process (Clock, Reset)
		variable cnt : std_logic_vector(1 downto 0) := "00";
	begin
		if Reset = '1' then
			cnt := "00";
			CPUClock <= '1';
		elsif rising_edge(Clock) then
			CPUClock <= not cnt(1);
			cnt := cnt + 1;
		end if;
	end process;

end Behavioral;
