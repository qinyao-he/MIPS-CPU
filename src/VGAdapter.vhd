----------------------------------------------------------------------------------
-- Company: 
-- Engineer: wangkai
-- 
-- Create Date:    23:55:45 11/25/2015 
-- Design Name: 
-- Module Name:    VGAdapter - Behavioral 
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

entity VGAdapter is
	port(
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
		--LED : out std_logic_vector(15 downto 0);
		--SW : in std_logic_vector(15 downto 0)
	  );
end VGAdapter;

architecture Behavioral of VGAdapter is
	component CharAdapter is
		port(
			CLKout : in std_logic;
			CLKin : in std_logic;
			Reset : in  std_logic;
			EN : in std_logic;
			-- CharBufferA
			CharAddra : in std_logic_vector(10 downto 0);
			CharDina : in std_logic_vector(7 downto 0);
			-- GRam
			GRamAddra : out std_logic_vector(14 downto 0);
			GRamDina : out std_logic_vector(15 downto 0);
			CharWea : in std_logic_vector( 0 downto 0);
			CharDouta : out std_logic_vector(7 downto 0)
			--LED : out std_logic_vector(15 downto 0);
			--SW : in std_logic_vector(15 downto 0)
			);
	end component;
	component VGACore is
	 port(
			reset       :         in  STD_LOGIC;
			clk_0       :         in  STD_LOGIC;
			hs,vs       :         out STD_LOGIC;
			r,g,b       :         out STD_LOGIC_vector(2 downto 0);
			GRamAddra   :         in std_logic_vector(14 downto 0);
			GRamDina    :         in std_logic_vector(15 downto 0)
	  );
	end component;
	signal GRamAddra_in : std_logic_vector(14 downto 0);
	signal GRamDina_in : std_logic_vector(15 downto 0);
	signal CharAdapterEN : std_logic;
begin
	CharAdapter_c : CharAdapter port map(
		CLKout => CLKout,
		CLKin => CLKin,
		Reset => Reset,
		CharAddra => CharAddra,
		CharDina => CharDina,
		CharWea => CharWea,
		CharDouta => CharDouta,
		GRamAddra => GRamAddra_in,
		GRamDina => GRamDina_in,
		EN => CharAdapterEN
		--LED => LED,
		--SW => SW
		);
	VGACore_c: VGACore port map(
		reset => Reset,
		clk_0 => CLKin,
		hs => hs,
		vs => vs,
		r => r,
		g => g,
		b => b,
		GRamAddra => GRamAddra_in,
		GRamDina => GRamDina_in
		);
	CharAdapterEN <='1' when UpdateType = "00" else
					'0'; 

end Behavioral;

