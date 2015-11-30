----------------------------------------------------------------------------------
-- Company: 
-- Engineer: wangkai
-- 
-- Create Date:    11:46:41 11/26/2015 
-- Design Name: 
-- Module Name:    CharAdapter - Behavioral 
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
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CharAdapter is
	port(
		CLKout : in std_logic;
		CLKin : in std_logic;
		Reset : in  std_logic;
		EN : in std_logic;
		-- CharBufferA
		CharWea : in std_logic_vector(0 downto 0);
		CharAddra : in std_logic_vector(10 downto 0);
		CharDina : in std_logic_vector(7 downto 0);
		CharDouta : out std_logic_vector(7 downto 0);
		-- GRam
		GRamAddra : out std_logic_vector(14 downto 0);
		GRamDina : out std_logic_vector(15 downto 0)
		--LED : out std_logic_vector(15 downto 0);
		--SW : in std_logic_vector(15 downto 0)
	  );
end CharAdapter;

architecture Behavioral of CharAdapter is
	component Letters is
		port (
			clka : in std_logic;
			addra : in std_logic_vector(11 downto 0);
			douta : out std_logic_vector(15 downto 0)
		);
	end component;
	component CharBuffer is
		port (
			clka : in std_logic;
			wea : in std_logic_vector(0 downto 0);
			addra : in std_logic_vector(10 downto 0);
			dina : in std_logic_vector(7 downto 0);
			douta : out std_logic_vector(7 downto 0);
			clkb : in std_logic;
			web : in std_logic_vector(0 downto 0);
			addrb : in std_logic_vector(10 downto 0);
			dinb : in std_logic_vector(7 downto 0);
			doutb : out std_logic_vector(7 downto 0)
		);
	end component;
	-- CharBufferB
	signal CharAddrb_in : std_logic_vector(10 downto 0);
	signal CharDoutb_in : std_logic_vector(7 downto 0);
	signal LettersAddr : std_logic_vector(11 downto 0);
	signal LettersDout : std_logic_vector(15 downto 0);
	signal LetterDoutReverse : std_logic_vector(15 downto 0);
	signal LettersResult : std_logic_vector(15 downto 0);
	signal LineNumOfChar : std_logic_vector(3 downto 0);
	signal Char : std_logic_vector(7 downto 0);
	signal TempChar : std_logic_vector(7 downto 0);
	signal Second : std_logic;
	--signal CharDouta : std_logic_vector(7 downto 0);
	--state
	type STATE_TYPE is (INIT, CHARA, GRAMAD, FINISH);
	signal state : STATE_TYPE;
	--signal debugGramAddr:std_logic_vector(14 downto 0);
	--signal debugGramDina:std_logic_vector(15 downto 0);
begin
	LetterDoutReverse(0) <= LettersDout(15);
	LetterDoutReverse(1) <= LettersDout(14);
	LetterDoutReverse(2) <= LettersDout(13);
	LetterDoutReverse(3) <= LettersDout(12);
	LetterDoutReverse(4) <= LettersDout(11);
	LetterDoutReverse(5) <= LettersDout(10);
	LetterDoutReverse(6) <= LettersDout(9);
	LetterDoutReverse(7) <= LettersDout(8);
	LetterDoutReverse(8) <= LettersDout(7);
	LetterDoutReverse(9) <= LettersDout(6);
	LetterDoutReverse(10) <= LettersDout(5);
	LetterDoutReverse(11) <= LettersDout(4);
	LetterDoutReverse(12) <= LettersDout(3);
	LetterDoutReverse(13) <= LettersDout(2);
	LetterDoutReverse(14) <= LettersDout(1);
	LetterDoutReverse(15) <= LettersDout(0);
	CharBuffer_c : CharBuffer port map(
		clka => CLKout,
		clkb => CLKin,
		wea => CharWea,
		addra => CharAddra,
		dina => CharDina,
		douta => CharDouta,
		web => "0",
		addrb => CharAddrb_in,
		dinb => (others => 'Z'),
		doutb => CharDoutb_in
	);
	Letters_c : Letters port map(
		clka => CLKin,
		addra => LettersAddr,
		douta => LettersDout
	);
	Char <= TempChar when TempChar(7) = '0' else
			not TempChar;
	LettersResult <=not LetterDoutReverse when Second = '1' and TempChar(7) = '1'else
						LetterDoutReverse;

	LettersAddr <= Char(7 downto 0) & LineNumOfChar;
	--LED <=	EXT(LettersDout,LED'length) when SW = "0000000000000000" else
	--		EXT(LettersAddr,LED'length) when SW = "0000000000000001" else
	--		EXT(Char,LED'length) when SW = "0000000000000010" else
	--		EXT(CharAddrb_in,LED'length) when SW = "0000000000000011" else
	--		EXT(CharDoutb_in,LED'length) when SW = "0000000000000100" else
	--		EXT(debugGramAddr,LED'length) when SW = "0000000000000101" else
	--		EXT(debugGramDina,LED'length) when SW = "0000000000000110";
	-- read CharBuffer and exchange it to GRam
	--process( CLK, Reset, EN )
	process( CLKin, Reset, EN )
	variable RowNum : integer range 0 to 39 := 0;
	variable LineNum : integer range 0 to 29 := 0;
	variable num : integer range 0 to 15 := 0;
	variable result : integer range 0 to 19200;
	begin
		if EN = '1' then
			if Reset = '0' then
				LineNumOfChar <= (others => '0');
				CharAddrb_in <= (others => '0');
				state <= INIT;
			elsif rising_edge(CLKin) then
				case state is
					when INIT =>
						TempChar <= CharDoutb_in;
						state <= CHARA;
					when CHARA =>
						GRamDina <= LettersResult;
						result := (LineNum*16+num)*40+RowNum;
						GRamAddra <= CONV_STD_LOGIC_VECTOR(result, 15);
						--debugGramAddr <= CONV_STD_LOGIC_VECTOR(result, 15);
						if LineNumOfChar = "1111" then
							LineNumOfChar <= "0000";
							num := 0;
							state <= GRAMAD;
						else
							LineNumOfChar <= LineNumOfChar + 1;
							num := num + 1;
							state <= CHARA;
						end if ;
					when GRAMAD =>
						if RowNum = 39 then
							RowNum := 0;
							if LineNum = 29 then
								LineNum := 0;
								state <= FINISH;
							else
								LineNum := LineNum + 1;
								state <= INIT;
							end if ;
						else
							RowNum := RowNum + 1;
							state <= INIT;
						end if ;
						CharAddrb_in <= CharAddrb_in + 1;
					when FINISH =>
						LineNumOfChar <= (others => '0');
						CharAddrb_in <= (others => '0');
						state <= INIT;
					when others =>
						state <= INIT;
				end case ;
			end if ;
		end if ;
	end process ;

	process( CLKin )
	variable counter : integer range 0 to 25000002 := 0;
	begin
		if rising_edge(CLKin) then
			counter := counter + 1;
			if counter = 25000000 then
				counter := 0;
				Second <= not Second;
			end if ;
		end if ;
	end process ;
end Behavioral;

