--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:	03:05:06 11/22/2015
-- Design Name:	
-- Module Name:	C:/Code/CPU/ForwardUnit/ForwardUnit_tb.vhd
-- Project Name:  ForwardUnit
-- Target Device:  
-- Tool versions:  
-- Description:	
-- 
-- VHDL Test Bench Created by ISE for module: ForwardUnit
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
library ieee;
use ieee.std_logic_1164.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
entity ForwardUnit_tb is
end ForwardUnit_tb;
 
architecture behavior of ForwardUnit_tb is 
 
	 -- Component Declaration for the Unit Under Test (UUT)
 
	component ForwardUnit
	port(
			EXMEMRegWrite : in  std_logic;
			MEMWBRegWrite : in  std_logic;
			EXMEMRegDest : in  std_logic_vector(3 downto 0);
			MEMWBRegDest : in  std_logic_vector(3 downto 0);
			IDEXRegSrcA : in  std_logic_vector(3 downto 0);
			IDEXRegSrcB : in  std_logic_vector(3 downto 0);
			ForwardA : out  std_logic_vector(1 downto 0);
			ForwardB : out  std_logic_vector(1 downto 0));
	end component;
	 

	--Inputs
	signal EXMEMRegWrite : std_logic := '0';
	signal MEMWBRegWrite : std_logic := '0';
	signal EXMEMRegDest : std_logic_vector(3 downto 0) := (others => '0');
	signal MEMWBRegDest : std_logic_vector(3 downto 0) := (others => '0');
	signal IDEXRegSrcA : std_logic_vector(3 downto 0) := (others => '0');
	signal IDEXRegSrcB : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
	signal ForwardA : std_logic_vector(1 downto 0);
	signal ForwardB : std_logic_vector(1 downto 0);
	-- No clocks detected in port list. Replace <clock> below with 
	-- appropriate port name 
 
--	constant <clock>_period : time := 10 ns;
 
begin
 
	-- Instantiate the Unit Under Test (UUT)
	uut: ForwardUnit port map (
			 EXMEMRegWrite => EXMEMRegWrite,
			 MEMWBRegWrite => MEMWBRegWrite,
			 EXMEMRegDest => EXMEMRegDest,
			 MEMWBRegDest => MEMWBRegDest,
			 IDEXRegSrcA => IDEXRegSrcA,
			 IDEXRegSrcB => IDEXRegSrcB,
			 ForwardA => ForwardA,
			 ForwardB => ForwardB
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
		EXMEMRegWrite <= '1';
		MEMWBRegWrite <= '1';
		EXMEMRegDest <= "1111";
		MEMWBRegDest <= "1111";
		IDEXRegSrcA <= "1111";
		IDEXRegSrcB <= "1111";
		wait for 100 ns;
		EXMEMRegWrite <= '0';
		MEMWBRegWrite <= '1';
		EXMEMRegDest <= "1111";
		MEMWBRegDest <= "1111";
		IDEXRegSrcA <= "1111";
		IDEXRegSrcB <= "1111";
		wait for 100 ns;
		EXMEMRegWrite <= '0';
		MEMWBRegWrite <= '0';
		EXMEMRegDest <= "1111";
		MEMWBRegDest <= "1111";
		IDEXRegSrcA <= "1111";
		IDEXRegSrcB <= "1111";
		wait for 100 ns;

--		wait for <clock>_period*10;

		-- insert stimulus here 

		wait;
	end process;

END;
