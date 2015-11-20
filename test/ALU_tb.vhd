--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:	23:33:20 11/20/2015
-- Design Name:	
-- Module Name:	C:/Code/CPU/ALU/ALU_tb.vhd
-- Project Name:  ALU
-- Target Device:  
-- Tool versions:  
-- Description:	
-- 
-- VHDL Test Bench Created by ISE for module: ALU
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
 
ENTITY ALU_tb IS
END ALU_tb;
 
ARCHITECTURE behavior OF ALU_tb IS 
 
	 -- Component Declaration for the Unit Under Test (UUT)
 
	 COMPONENT ALU
	 PORT(
			InputA : IN  std_logic_vector(15 downto 0);
			InputB : IN  std_logic_vector(15 downto 0);
			ALUop : IN  std_logic_vector(2 downto 0);
			Output : OUT  std_logic_vector(15 downto 0)
		  );
	 END COMPONENT;
	 

	--Inputs
	signal InputA : std_logic_vector(15 downto 0) := (others => '0');
	signal InputB : std_logic_vector(15 downto 0) := (others => '0');
	signal ALUop : std_logic_vector(2 downto 0) := (others => '0');

 	--Outputs
	signal Output : std_logic_vector(15 downto 0);
	-- No clocks detected in port list. Replace <clock> below with 
	-- appropriate port name 
 
--	constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
	uut: ALU PORT MAP (
			 InputA => InputA,
			 InputB => InputB,
			 ALUop => ALUop,
			 Output => Output
		  );

	-- Clock process definitions
--	<clock>_process :process
--	begin
--		<clock> <= '0';
--		wait for <clock>_period/2;
--		<clock> <= '1';
--		wait for <clock>_period/2;
--	end process;
 

	-- Stimulus process
	stim_proc: process
	begin		
		-- hold reset state for 100 ns.
		InputA <= "0000000000000001";
		InputB <= "0000000000000010";
		ALUop <= "000";
		wait for 100 ns;	
		InputA <= "0000000000000101";
		InputB <= "0000000000000010";
		ALUop <= "001";
		wait for 100 ns;  
		InputA <= "0000000000001100";
		InputB <= "0000000000001010";
		ALUop <= "010";
		wait for 100 ns;  
		InputA <= "0000000000001100";
		InputB <= "0000000000001010";
		ALUop <= "101";
		wait for 100 ns;  
		InputA <= "0000000000001100";
		InputB <= "0000000000000001";
		ALUop <= "011";
		wait for 100 ns;  
		InputA <= "0000000000001100";
		InputB <= "0000000000000001";
		ALUop <= "100";
		-- insert stimulus here 

		wait;
	end process;

END;
