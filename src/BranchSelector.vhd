----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:23:14 11/21/2015 
-- Design Name: 
-- Module Name:    BranchSelector - Behavioral 
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

entity BranchSelector is
    Port (BranchType : in  std_logic_vector (1 downto 0);
			Jump : in  std_logic;
			Input : in  std_logic_vector (15 downto 0);
			BranchSelector : out  std_logic_vector (1 downto 0));
end BranchSelector;

architecture Behavioral of BranchSelector is
begin
	BranchSelector	<= "00" when BranchType = "00" and Jump = '0' else
						"01" when (BranchType = "01" and Jump = '0') or (Input = "0000000000000000" and BranchType = "10" and Jump = '0') or (Input /= "0000000000000000" and BranchType = "11" and Jump = '0')else
						"10" when Jump = '1'; 
end Behavioral;

