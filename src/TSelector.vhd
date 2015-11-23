----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:27:05 11/24/2015 
-- Design Name: 
-- Module Name:    TSelector - Behavioral 
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

entity TSelector is
    Port ( TType : in  std_logic;
           ALUFlags : in  std_logic_vector (1 downto 0);
           TOutput : out  std_logic_vector (15 downto 0));
end TSelector;

architecture Behavioral of TSelector is

begin
	TOutput <= 	"0000000000000000" when (TType = '1' and ALUFlags(1) = '0') or (TType = '0' and ALUFlags(0) = '1') else
				"0000000000000001";

end Behavioral;

