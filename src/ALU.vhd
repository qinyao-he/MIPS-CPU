library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ALU is
	Port (
		dataA : in std_logic_vector (15 downto 0);
		dataB : in std_logic_vector (15 downto 0);
		operation : in std_logic_vector (2 downto 0);
		result : out std_logic_vector (15 downto 0) := "0000000000000000");
end ALU;

architecture arch of ALU is
signal result_tmp : std_logic_vector (15 downto 0);
begin
	result <= result_tmp;
	with operation select result_tmp <=
		dataA + dataB when "000",
		dataA - dataB when "001",
		dataA and dataB when "010",
		to_stdlogicvector(to_bitvector(dataA) sll conv_integer(dataB(3 downto 0))) when "011",
		to_stdlogicvector(to_bitvector(dataA) sra conv_integer(dataB(3 downto 0))) when "100",
		dataA or dataB when "101",
		"0000000000000000" when others;

end architecture ; -- arch