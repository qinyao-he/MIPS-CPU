----------------------------------------------------------------------------------
-- Company:
-- Engineer: 黄科 王凯
--
-- Create Date:    00:14:58 11/24/2015
-- Design Name:
-- Module Name:    CPUTop - Behavioral
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
library UNISIM;
use UNISIM.VComponents.all;

entity CPUTop is
	port (
		Clock_50 : in std_logic;
		Clock_11 : in std_logic;
		Clock_M : in std_logic;
		Rst : in std_logic;

		Ram1EN : out std_logic;
		Ram1Data : inout std_logic_vector (7 downto 0);

		Ram2Addr : out std_logic_vector(17 downto 0);
		Ram2Data : inout std_logic_vector(15 downto 0);
		Ram2OE : out std_logic;
		Ram2WE : out std_logic;
		Ram2EN : out std_logic;

		SerialWRN : out std_logic;
		SerialRDN : out std_logic;
		SerialDATA_READY : in std_logic;
		SerialTSRE : in std_logic;
		SerialTBRE : in std_logic;

		PS2KeybardClock : in std_logic;
		PS2KeybardData : in std_logic;

		VGA_R : out std_logic_vector(2 downto 0);
		VGA_G : out std_logic_vector(2 downto 0);
		VGA_B : out std_logic_vector(2 downto 0);
		VGA_HS : out std_logic;
		VGA_VS : out std_logic;

		FlashByte : out std_logic;
		FlashVpen : out std_logic;
		FlashCE : out std_logic;
		FlashOE : out std_logic;
		FlashWE : out std_logic;
		FlashRP : out std_logic;
		FlashAddr : out std_logic_vector(22 downto 0);
		FlashData : inout std_logic_vector(15 downto 0);

		SW : in std_logic_vector(15 downto 0);
		LED : out std_logic_vector (15 downto 0);
		DYP0 : out std_logic_vector (6 downto 0);
		DYP1 : out std_logic_vector (6 downto 0)
	);
end CPUTop;

architecture Behavioral of CPUTop is

-- components

component Seg7
	port (
		key : in std_logic_vector(3 downto 0);
		display : out std_logic_vector(6 downto 0)
	);
end component;

component CPU
	port (
		Clock : in std_logic;
		Reset : in std_logic;

		InstAddress : out std_logic_vector(15 downto 0);
		InstInput : in std_logic_vector(15 downto 0);

		DataAddress : out std_logic_vector(15 downto 0);
		DataInput : in std_logic_vector(15 downto 0);
		DataOutput : out std_logic_vector(15 downto 0);

		MemoryReadEN : out std_logic;
		MemoryWriteEN : out std_logic;

		SWIn : in std_logic_vector(15 downto 0);
		LEDOut : out std_logic_vector(15 downto 0);
		PCOut : out std_logic_vector(15 downto 0)
	);
end component;

component IOBridge
	port (
		Clock : in std_logic;
		Reset : in std_logic;
		CPUClock : out std_logic;
		SW : in std_logic_vector(15 downto 0);

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
		FlashData : inout std_logic_vector(15 downto 0);

		LEDOut : out std_logic_vector(15 downto 0)
	);
end component; -- IOBridge

component KeyboardAdapter
	port (
		PS2Data : in std_logic; -- PS2 data
		PS2Clock : in std_logic; -- PS2 clk
		Clock : in std_logic;
		Reset : in std_logic;
		DataReceive : in std_logic;
		DataReady : out std_logic ;  -- data output enable signal
		Output : out std_logic_vector(7 downto 0) -- scan code signal output
	);
end component; -- KeyboardAdapter

component VGAdapter
	port (
		CLKout : in std_logic;
		CLKin : in std_logic;
		Reset : in  std_logic;
		hs,vs : out std_logic;
		r,g,b : out std_logic_vector(2 downto 0);
		CharWea : in std_logic_vector( 0 downto 0);
		CharAddra : in std_logic_vector(10 downto 0);
		CharDina : in std_logic_vector(7 downto 0);
		CharDouta : out std_logic_vector(7 downto 0);
		UpdateType : in std_logic_vector(1 downto 0)
	);
end component;

COMPONENT ClockMultiplier
	PORT(
		CLKIN_IN : IN std_logic;
		RST_IN : IN std_logic;
		CLK0_OUT : OUT std_logic;
		CLK2X_OUT : OUT std_logic;
		CLKFX_OUT : OUT std_logic
	);
END COMPONENT;

--signal Clock_4x : std_logic;
signal Clock : std_logic;
signal Reset : std_logic;

-- CPU
signal CPUInstAddress : std_logic_vector(15 downto 0);
signal CPUDataAddress : std_logic_vector(15 downto 0);
signal CPUDataOutput : std_logic_vector(15 downto 0);
signal CPUMemoryReadEN : std_logic;
signal CPUMemoryWriteEN : std_logic;
signal CPULEDOut : std_logic_vector(15 downto 0);
signal CPUPCOut : std_logic_vector(15 downto 0);

-- IOBridge
signal CPUClock : std_logic;
signal DoubleClock : std_logic;
signal MultiClock : std_logic;
signal OriginClock : std_logic;
signal StdClock : std_logic;
signal IOBridgeDataOutput1 : std_logic_vector (15 downto 0);
signal IOBridgeDataOutput2 : std_logic_vector (15 downto 0);
signal IOBridgeRAM1EN : std_logic;

signal KeyboardDataReady : std_logic;
signal KeyboardDataReceive : std_logic;
signal KeyboardOutput : std_logic_vector(7 downto 0);

signal VGAAddress : std_logic_vector(10 downto 0);
signal VGAData : std_logic_vector(7 downto 0);
signal VGAUpdate : std_logic_vector(1 downto 0);
signal VGAWE : std_logic_vector(0 downto 0);

signal key_0, key_1 : std_logic_vector(3 downto 0);

begin

	Inst_ClockMultiplier: ClockMultiplier PORT MAP(
		CLKIN_IN => Clock_11,
		RST_IN => Reset,
		CLK0_OUT => OriginClock,
		CLK2X_OUT => DoubleClock,
		CLKFX_OUT => MultiClock
	);

	StdClock <= DoubleClock when SW(14) = '1' else Clock_50;
	Clock <= StdClock when SW(15) = '1' else Clock_M;
	Reset <= not Rst;

	--LED <= CPULEDOut;

	Seg7_0 : Seg7 port map(key_0, DYP0);
	Seg7_1 : Seg7 port map(key_1, DYP1);
	key_1 <= CPUPCOut(3 downto 0);
	key_0 <= CPUPCOut(7 downto 4);

	CPU_c : CPU port map (
		Clock => CPUClock,
		Reset => Reset,

		InstAddress => CPUInstAddress,
		InstInput => IOBridgeDataOutput1,

		DataAddress => CPUDataAddress,
		DataInput => IOBridgeDataOutput2,
		DataOutput => CPUDataOutput,

		MemoryReadEN => CPUMemoryReadEN,
		MemoryWriteEN => CPUMemoryWriteEN,

		SWIn => SW,
		LEDOut => CPULEDOut,
		PCOut => CPUPCOut
	);

	-- IOBridge
	IOBridge_c : IOBridge port map (
		Clock => Clock,
		Reset => Reset,
		CPUClock => CPUClock,
		SW => SW,

		ReadEN => CPUMemoryReadEN,
		WriteEN => CPUMemoryWriteEN,

		Address1 => CPUInstAddress,
		DataOutput1 => IOBridgeDataOutput1,

		Address2 => CPUDataAddress,
		DataInput2 => CPUDataOutput,
		DataOutput2 => IOBridgeDataOutput2,

		MemoryAddress => Ram2Addr,
		MemoryDataBus => Ram2Data,
		MemoryEN => Ram2EN,
		MemoryOE => Ram2OE,
		MemoryWE => Ram2WE,

		RAM1EN => Ram1EN,

		SerialWRN => SerialWRN,
		SerialRDN => SerialRDN,
		SerialDATA_READY => SerialDATA_READY,
		SerialTSRE => SerialTSRE,
		SerialTBRE => SerialTBRE,
		SerialDataBus => Ram1Data,

		KeyboardDATA_READY => KeyboardDataReady,
		KeyboardRDN => KeyboardDataReceive,
		KeyboardData => KeyboardOutput,

		VGAAddress => VGAAddress,
		VGAData => VGAData,
		VGAWE => VGAWE,
		VGAUpdate => VGAUpdate,

		FlashByte => FlashByte,
		FlashVpen => FlashVpen,
		FlashCE => FlashCE,
		FlashOE => FlashOE,
		FlashWE => FlashWE,
		FlashRP => FlashRP,
		FlashAddr => FlashAddr,
		FlashData => FlashData,

		LEDOut => LED
	);

	KeyboardAdapter_c : KeyboardAdapter port map (
		PS2Data => PS2KeybardData,
		PS2Clock => PS2KeybardClock,
		Clock => Clock,
		Reset => Reset,
		DataReceive => KeyboardDataReceive,
		DataReady => KeyboardDataReady,
		Output => KeyboardOutput
	);

	VGAdapter_c : VGAdapter port map (
		CLKin => Clock_50,
		CLKout => Clock,
		Reset => Rst,
		hs => VGA_HS,
		vs => VGA_VS,
		r => VGA_R,
		g => VGA_G,
		b => VGA_B,
		CharWea => VGAWE,
		CharAddra => VGAAddress,
		CharDina => VGAData,
		CharDouta => open,
		UpdateType => VGAUpdate
	);

end Behavioral;

