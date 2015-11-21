library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ALU is
	Port (
		InputA : in std_logic_vector (15 downto 0);
		InputB : in std_logic_vector (15 downto 0);
		ALUop : in std_logic_vector (2 downto 0);
		Output : out std_logic_vector (15 downto 0) := "0000000000000000");
end ALU;

architecture arch of ALU is
signal OutputTmp : std_logic_vector (15 downto 0);
begin
	Output <= OutputTmp;
	with ALUop select OutputTmp <=
		InputA + InputB when "000",
		InputA - InputB when "001",
		InputA and InputB when "010",
		to_stdlogicvector(to_bitvector(InputA) sll conv_integer(InputB(3 downto 0))) when "011",
		to_stdlogicvector(to_bitvector(InputA) sra conv_integer(InputB(3 downto 0))) when "100",
		InputA or InputB when "101",
		"0000000000000000" when others;

end architecture; -- arch