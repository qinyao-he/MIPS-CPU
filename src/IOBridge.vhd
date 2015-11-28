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
		SerialDataBus : inout std_logic_vector(7 downto 0);

		KeyboardDATA_READY : in std_logic;
		KeyboardRDN : out std_logic;
		KeyboardData : in std_logic_vector(7 downto 0);

		VGAAddress : out std_logic_vector(10 downto 0);
		VGAData : out std_logic_vector(7 downto 0);
		VGAWE : out std_logic_vector(0 downto 0);
		VGAUpdate : out std_logic_vector(1 downto 0);

		FlashByte : out std_logic;
		FlashVpen : out std_logic;
		FlashCE : out std_logic;
		FlashOE : out std_logic;
		FlashWE : out std_logic;
		FlashRP : out std_logic;
		FlashAddr : out std_logic_vector(22 downto 0);
		FlashData : inout std_logic_vector(15 downto 0)
	);
end IOBridge;

architecture Behavioral of IOBridge is

	component FlashAdapter
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
	end component;

	type STATE_TYPE is (INS_READ, DATA_READ, DATA_WRITE, HOLD);
	signal state : STATE_TYPE;

	signal BufferData1, BufferData2 : std_logic_vector(15 downto 0);
	signal BF01 : std_logic_vector(15 downto 0);
	signal BF03 : std_logic_vector(15 downto 0);

	signal MemoryBusFlag, SerialBusFlag : std_logic;
begin

	MemoryEN <= '0';
	RAM1EN <= '1';

	DataOutput1 <= BufferData1;
	DataOutput2 <= BufferData2;

	CPUClock <= '0' when (state=DATA_WRITE or state=HOLD) else
				'1';

	MemoryWE <= '1' when (Address2=x"BF00" and state=DATA_WRITE) else
				'1' when (Address2=x"BF01" and state=DATA_WRITE) else
				'1' when (Address2=x"BF02" and state=DATA_WRITE) else
				'1' when (Address2=x"BF03" and state=DATA_WRITE) else
				not WriteEN when state=DATA_WRITE else
				'1';
	MemoryOE <= not ReadEN when state=DATA_READ else
				'0' when state=INS_READ else
				'1';

	MemoryBusFlag <= not WriteEN when (state=DATA_READ or state=DATA_WRITE) else
					'1';
	SerialBusFlag <= not WriteEN when (state=DATA_READ or state=DATA_WRITE) else
					'1';
	MemoryDataBus <= DataInput2 when MemoryBusFlag='0' else (others => 'Z');
	SerialDataBus <= DataInput2(7 downto 0) when SerialBusFlag='0' else (others => 'Z');
	VGAData <= DataInput2(7 downto 0);

	MemoryAddress <= "00" & Address1 when state=INS_READ else
					"00" & Address2;
	VGAAddress <= Address2(10 downto 0);

	SerialRDN <= not ReadEN when (Address2=x"BF00" and state=DATA_READ) else '1';
	SerialWRN <= not WriteEN when (Address2=x"BF00" and state=DATA_WRITE) else '1';

	KeyboardRDN <= '0' when (Address2=x"BF02" and state=DATA_READ) else '1';

	VGAWE <= "1" when (WriteEN='1' and (state=DATA_WRITE or state=DATA_READ) and (Address2(15 downto 11)="11111"))
		else "0";
	VGAUpdate <= "00";

	BF01 <= "00000000000000" & SerialDATA_READY & (SerialTSRE and SerialTBRE);
	BF03 <= "000000000000000" & KeyboardDATA_READY;

	process (Clock, Reset)
	begin
		if Reset = '1' then
			state <= INS_READ;
		elsif falling_edge(Clock) then
			case state is
				when INS_READ =>
					state <= DATA_READ;
					BufferData1 <= MemoryDataBus;
				when DATA_READ =>
					state <= DATA_WRITE;
					case Address2 is
						when x"BF00" =>
							BufferData2 <= "00000000" & SerialDataBus;
						when x"BF01" =>
							BufferData2 <= BF01;
						when x"BF02" =>
							BufferData2 <= "00000000" & KeyboardData;
						when x"BF03" =>
							BufferData2 <= BF03;
						when others =>
							BufferData2 <= MemoryDataBus;
					end case;
				when DATA_WRITE =>
					state <= HOLD;
				when HOLD =>
					state <= INS_READ;
				when others =>
					state <= INS_READ;
			end case;
		end if;
	end process;

end Behavioral;
