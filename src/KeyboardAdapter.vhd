library ieee;
use ieee.std_logic_1164.all;

entity KeyboardAdapter is
port (
	PS2Data : in std_logic; -- PS2 data
	PS2Clock : in std_logic; -- PS2 clk
	Clock : in std_logic;
	Reset : in std_logic;
	DataReceive : in std_logic;
	DataReady : out std_logic ;  -- data output enable signal
	Output : out std_logic_vector(7 downto 0) -- scan code signal output
	);
end KeyboardAdapter;

architecture Behavioral of KeyboardAdapter is

-- components

component Keyboard
	port (
		PS2Data : in std_logic; -- PS2 data
		PS2Clock : in std_logic; -- PS2 clk
		Clock : in std_logic;
		Reset : in std_logic;
		DataReceive : in std_logic;
		DataReady : out std_logic ;  -- data output enable signal
		Output : out std_logic_vector (7 downto 0) -- scan code signal output
	);
end component;

component KeyboardToAscii
	port (
		Data : in std_logic_vector (7 downto 0);
		Output : out std_logic_vector (7 downto 0)
	);
end component;

-- end components

-- signal

signal PS2DataSignal : std_logic_vector (7 downto 0);

-- end signal

begin

	Keyboard_c : Keyboard port map (
		PS2Data => PS2Data,
		PS2Clock => PS2Clock,
		Clock => Clock,
		Reset => Reset,
		DataReceive => DataReceive,
		DataReady => DataReady,
		Output => PS2DataSignal
	);

	KeyboardToAscii_c : KeyboardToAscii port map (
		Data => PS2DataSignal,
		Output => Output
	);

end architecture ; -- Behavioral
