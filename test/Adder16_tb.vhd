--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:49:26 11/20/2015
-- Design Name:   
-- Module Name:   C:/Code/CPU/ALU/Adder16_tb.vhd
-- Project Name:  ALU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Adder16
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Adder16_tb IS
END Adder16_tb;
 
ARCHITECTURE behavior OF Adder16_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Adder16
    PORT(
         InputA : IN  std_logic_vector(15 downto 0);
         InputB : IN  std_logic_vector(15 downto 0);
         Output : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal InputA : std_logic_vector(15 downto 0) := (others => '0');
   signal InputB : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal Output : std_logic_vector(15 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
--   constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Adder16 PORT MAP (
          InputA => InputA,
          InputB => InputB,
          Output => Output
        );

   -- Clock process definitions
--   <clock>_process :process
--   begin
--		<clock> <= '0';
--		wait for <clock>_period/2;
--		<clock> <= '1';
--		wait for <clock>_period/2;
--   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		InputA <= "0000000000000001";
		InputB <= "0000000000000011";
		wait for 100 ns;
--      wait for <clock>_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
