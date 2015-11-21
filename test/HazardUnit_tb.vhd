--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:	03:33:29 11/22/2015
-- Design Name:	
-- Module Name:	C:/Code/CPU/HazardUnit/HazardUnit_tb.vhd
-- Project Name:  HazardUnit
-- Target Device:  
-- Tool versions:  
-- Description:	
-- 
-- VHDL Test Bench Created by ISE for module: HazardUnit
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
 
ENTITY HazardUnit_tb IS
END HazardUnit_tb;
 
ARCHITECTURE behavior OF HazardUnit_tb IS 
 
	 -- Component Declaration for the Unit Under Test (UUT)
 
	 COMPONENT HazardUnit
	 PORT(
			IDEXMemRead : IN  std_logic;
			IDEXRegDest : IN  std_logic_vector(3 downto 0);
			RegSrcA : IN  std_logic_vector(3 downto 0);
			RegSrcB : IN  std_logic_vector(3 downto 0);
			PCWrite : OUT  std_logic;
			IFIDWrite : OUT  std_logic;
			IDEXClear : OUT  std_logic
		  );
	 END COMPONENT;
	 

	--Inputs
	signal IDEXMemRead : std_logic := '0';
	signal IDEXRegDest : std_logic_vector(3 downto 0) := (others => '0');
	signal RegSrcA : std_logic_vector(3 downto 0) := (others => '0');
	signal RegSrcB : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
	signal PCWrite : std_logic;
	signal IFIDWrite : std_logic;
	signal IDEXClear : std_logic;
	-- No clocks detected in port list. Replace <clock> below with 
	-- appropriate port name 
 
	--constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
	uut: HazardUnit PORT MAP (
			 IDEXMemRead => IDEXMemRead,
			 IDEXRegDest => IDEXRegDest,
			 RegSrcA => RegSrcA,
			 RegSrcB => RegSrcB,
			 PCWrite => PCWrite,
			 IFIDWrite => IFIDWrite,
			 IDEXClear => IDEXClear
		  );

	-- Clock process definitions
  -- <clock>_process :process
  -- begin
		--<clock> <= '0';
		--wait for <clock>_period/2;
		--<clock> <= '1';
		--wait for <clock>_period/2;
  -- end process;
 

	-- Stimulus process
	stim_proc: process
	begin		
		-- hold reset state for 100 ns.
		IDEXMemRead <= '1';
		IDEXRegDest <= "1111";
		RegSrcA <= "1111";
		RegSrcB <= "1111";
		wait for 100 ns;
		IDEXMemRead <= '1';
		IDEXRegDest <= "1111";
		RegSrcA <= "0000";
		RegSrcB <= "1111";
		wait for 100 ns;
		IDEXMemRead <= '1';
		IDEXRegDest <= "1111";
		RegSrcA <= "1111";
		RegSrcB <= "0000";
		wait for 100 ns;
		IDEXMemRead <= '1';
		IDEXRegDest <= "1111";
		RegSrcA <= "0000";
		RegSrcB <= "0000";
		wait for 100 ns;
		IDEXMemRead <= '0';
		IDEXRegDest <= "1111";
		RegSrcA <= "1111";
		RegSrcB <= "1111";
		wait for 100 ns;

		--wait for <clock>_period*10;

		-- insert stimulus here 

		wait;
	end process;

END;
