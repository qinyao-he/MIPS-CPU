library ieee;
use ieee.std_logic_1164.all;

entity KeyboardToAscii is
  port (
	Data : in std_logic_vector (7 downto 0);
	Output : out std_logic_vector (7 downto 0)
  ) ;
end entity ; -- KeyboardToAscii

architecture Behavioral of KeyboardToAscii is
begin
	Output <=
		X"41" when Data = X"1C" else  -- A
		X"42" when Data = X"32" else  -- B
		X"43" when Data = X"21" else  -- C
		X"44" when Data = X"23" else  -- D
		X"45" when Data = X"24" else  -- E
		X"46" when Data = X"2B" else  -- F
		X"47" when Data = X"34" else  -- G
		X"48" when Data = X"33" else  -- H
		X"49" when Data = X"43" else  -- I
		X"4A" when Data = X"3B" else  -- J
		X"4B" when Data = X"42" else  -- K
		X"4C" when Data = X"4B" else  -- L
		X"4D" when Data = X"3A" else  -- M
		X"4E" when Data = X"31" else  -- N
		X"4F" when Data = X"44" else  -- O
		X"50" when Data = X"4D" else  -- P
		X"51" when Data = X"15" else  -- Q
		X"52" when Data = X"2D" else  -- R
		X"53" when Data = X"1B" else  -- S
		X"54" when Data = X"2C" else  -- T
		X"55" when Data = X"3C" else  -- U
		X"56" when Data = X"2A" else  -- V
		X"57" when Data = X"1D" else  -- W
		X"58" when Data = X"22" else  -- X
		X"59" when Data = X"35" else  -- Y
		X"5A" when Data = X"1A" else  -- Z
		X"30" when Data = X"45" else  -- 0
		X"31" when Data = X"16" else  -- 1
		X"32" when Data = X"1E" else  -- 2
		X"33" when Data = X"26" else  -- 3
		X"34" when Data = X"25" else  -- 4
		X"35" when Data = X"2E" else  -- 5
		X"36" when Data = X"36" else  -- 6
		X"37" when Data = X"3D" else  -- 7
		X"38" when Data = X"3E" else  -- 8
		X"39" when Data = X"46" else  -- 9
	--<= "50" when Data = X"0E" else  --
		X"2D" when Data = X"4E" else  -- -
		X"3D" when Data = X"55" else  -- =
		X"5C" when Data = X"5D" else  -- \
		X"08" when Data = X"66" else  -- BKSP
		X"20" when Data = X"29" else  -- SPACE
		X"09" when Data = X"0D" else  -- TAB
		X"25" when Data = X"58" else  -- CAPS
		X"00" when Data = X"12" else  -- L SHFT
		X"01" when Data = X"14" else  -- L CTRL
	--<= "" when Data = "" else  -- L GUI
		X"02" when Data = X"11" else  -- L ALT
	--<= "" when Data = X"59" else  -- R SHFT
	--<= "" when Data = "" else  -- R CTRL
	--<= "" when Data = "" else  -- R GUI
	--<= "" when Data = "" else  -- R ALT
	--<= "" when Data = "" else  -- APPS
		X"12" when Data = X"5A" else  -- ENTER
		X"1B" when Data = X"76" else  -- ESC
	--<= "50" when Data = X"05" else  -- F1
	--<= "50" when Data = X"06" else  -- F2
	--<= "50" when Data = X"04" else  -- F3
	--<= "50" when Data = X"0C" else  -- F4
	--<= "50" when Data = X"03" else  -- F5
	--<= "50" when Data = X"0B" else  -- F6
	--<= "50" when Data = X"83" else  -- F7
	--<= "50" when Data = X"0A" else  -- F8
	--<= "50" when Data = X"01" else  -- F9
	--<= "50" when Data = X"09" else  -- F10
	--<= "50" when Data = X"78" else  -- F11
	--<= "50" when Data = X"07" else  -- F12
	--<= "" when Data = "" else  -- PRNT SCRN
	--<= "" when Data = X"7E" else  -- SCROLL
	--<= "" when Data = "" else  -- PAUSE
		X"5B" when Data = X"54" else  -- [
	--<= "" when Data = "" else  -- INSERT
	--<= "" when Data = "" else  -- HOME
	--<= "" when Data = "" else  -- PG UP
	--<= "" when Data = "" else  -- DELETE
	--<= "" when Data = "" else  -- END
	--<= "" when Data = "" else  -- PG DN
		X"21" when Data = X"75" else  -- U ARROW
		X"22" when Data = X"6B" else  -- L ARROW
		X"23" when Data = X"72" else  -- D ARROW
		X"24" when Data = X"74" else  -- R ARROW
	--<= "50" when Data = X"77" else  -- NUM
	--<= "50" when Data = X"4A" else  -- KP/
	--<= "50" when Data = X"7C" else  -- KP*
	--<= "50" when Data = X"7B" else  -- KP-
	--<= "50" when Data = X"79" else  -- KP+
	--<= "50" when Data = X"5A" else  -- KP EN
	--<= "50" when Data = X"71" else  -- KP
	--<= "50" when Data = X"70" else  -- KP 0
	--<= "50" when Data = X"69" else  -- KP 1
	--<= "50" when Data = X"72" else  -- KP 2
	--<= "50" when Data = X"7A" else  -- KP 3
	--<= "50" when Data = X"6B" else  -- KP 4
	--<= "50" when Data = X"73" else  -- KP 5
	--<= "50" when Data = X"74" else  -- KP 6
	--<= "50" when Data = X"6C" else  -- KP 7
	--<= "50" when Data = X"75" else  -- KP 8
	--<= "50" when Data = X"7D" else  -- KP 9
		X"5D" when Data = X"5B" else  -- ]
		X"3B" when Data = X"4C" else  -- ;
		X"27" when Data = X"52" else  -- '
		X"2C" when Data = X"41" else  -- ,
		X"2E" when Data = X"49" else  -- .
		X"2F" when Data = X"4A";      -- /

end architecture ; -- Behavioral
