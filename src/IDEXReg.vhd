----------------------------------------------------------------------------------
-- Company:
-- Engineer: 何钦尧
--
-- Create Date:    00:40:37 11/22/2015
-- Design Name:
-- Module Name:    IDEXReg - RTL
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

entity IDEXReg is
	port (
		Clock : in std_logic;
		Reset : in std_logic;
		Clear : in std_logic;
		WriteEN : in std_logic;

		PCInput : in std_logic_vector(15 downto 0);
		TTypeInput : in std_logic;
		EXResultSelectInput : in std_logic_vector(1 downto 0);
		RegWriteInput : in std_logic;
		MemReadInput : in std_logic;
		MemWriteInput : in std_logic;
		ALUOpInput : in std_logic_vector(2 downto 0);
		BranchTypeInput : in std_logic_vector(1 downto 0);
		JumpInput : in std_logic;
		RegSrcAInput : in std_logic_vector(3 downto 0);
		RegSrcBInput : in std_logic_vector(3 downto 0);
		RegDestInput : in std_logic_vector(3 downto 0);
		ALUSrcInput : in std_logic;
		MemToRegInput : in std_logic;
		RegDataAInput : in std_logic_vector(15 downto 0);
		RegDataBInput : in std_logic_vector(15 downto 0);
		ExtendedNumberInput : in std_logic_vector(15 downto 0);

		PCOutput : out std_logic_vector(15 downto 0);
		TTypeOutput : out std_logic;
		EXResultSelectOutput : out std_logic_vector(1 downto 0);
		RegWriteOutput : out std_logic;
		MemReadOutput : out std_logic;
		MemWriteOutput : out std_logic;
		ALUOpOutput : out std_logic_vector(2 downto 0);
		BranchTypeOutput : out std_logic_vector(1 downto 0);
		JumpOutput : out std_logic;
		RegSrcAOutput : out std_logic_vector(3 downto 0);
		RegSrcBOutput : out std_logic_vector(3 downto 0);
		RegDestOutput : out std_logic_vector(3 downto 0);
		ALUSrcOutput : out std_logic;
		MemToRegOutput : out std_logic;
		RegDataAOutput : out std_logic_vector(15 downto 0);
		RegDataBOutput : out std_logic_vector(15 downto 0);
		ExtendedNumberOutput : out std_logic_vector(15 downto 0)
	);
end IDEXReg;

architecture RTL of IDEXReg is
	signal PCReg : std_logic_vector(15 downto 0);
	signal TTypeReg : std_logic;
	signal EXResultSelectReg : std_logic_vector(1 downto 0);
	signal RegWriteReg : std_logic;
	signal MemReadReg : std_logic;
	signal MemWriteReg : std_logic;
	signal ALUOpReg : std_logic_vector(2 downto 0);
	signal BranchTypeReg : std_logic_vector(1 downto 0);
	signal JumpReg : std_logic;
	signal RegSrcAReg : std_logic_vector(3 downto 0);
	signal RegSrcBReg : std_logic_vector(3 downto 0);
	signal RegDestReg : std_logic_vector(3 downto 0);
	signal ALUSrcReg : std_logic;
	signal MemToRegReg : std_logic;
	signal RegDataAReg : std_logic_vector(15 downto 0);
	signal RegDataBReg : std_logic_vector(15 downto 0);
	signal ExtendedNumberReg : std_logic_vector(15 downto 0);
begin

	PCOutput <= PCReg;
	TTypeOutput <= TTypeReg;
	EXResultSelectOutput <= EXResultSelectReg;
	RegWriteOutput <= RegWriteReg;
	MemReadOutput <= MemReadReg;
	MemWriteOutput <= MemWriteReg;
	ALUOpOutput <= ALUOpReg;
	BranchTypeOutput <= BranchTypeReg;
	JumpOutput <= JumpReg;
	RegSrcAOutput <= RegSrcAReg;
	RegSrcBOutput <= RegSrcBReg;
	RegDestOutput <= RegDestReg;
	ALUSrcOutput <= ALUSrcReg;
	MemToRegOutput <= MemToRegReg;
	RegDataAOutput <= RegDataAReg;
	RegDataBOutput <= RegDataBReg;
	ExtendedNumberOutput <= ExtendedNumberReg;

	process(Clock, Reset)
	begin
		if Reset = '1' then
			PCReg <= (others => '0');
			TTypeReg <= '0';
			EXResultSelectReg <= (others => '0');
			RegWriteReg <= '0';
			MemReadReg <= '0';
			MemWriteReg <= '0';
			ALUOpReg <= (others => '0');
			BranchTypeReg <= (others => '0');
			JumpReg <= '0';
			RegSrcAReg <= (others => '0');
			RegSrcBReg <= (others => '0');
			RegDestReg <= (others => '0');
			ALUSrcReg <= '0';
			MemToRegReg <= '0';
			RegDataAReg <= (others => '0');
			RegDataBReg <= (others => '0');
			ExtendedNumberReg <= (others => '0');
		elsif rising_edge(Clock) then
			if Clear = '1' then
				PCReg <= (others => '0');
				TTypeReg <= '0';
				EXResultSelectReg <= (others => '0');
				RegWriteReg <= '0';
				MemReadReg <= '0';
				MemWriteReg <= '0';
				ALUOpReg <= (others => '0');
				BranchTypeReg <= (others => '0');
				JumpReg <= '0';
				RegSrcAReg <= (others => '0');
				RegSrcBReg <= (others => '0');
				RegDestReg <= (others => '0');
				ALUSrcReg <= '0';
				MemToRegReg <= '0';
				RegDataAReg <= (others => '0');
				RegDataBReg <= (others => '0');
				ExtendedNumberReg <= (others => '0');
			elsif WriteEN = '1' then
				PCReg <= PCInput;
				TTypeReg <= TTypeInput;
				EXResultSelectReg <= EXResultSelectInput;
				RegWriteReg <= RegWriteInput;
				MemReadReg <= MemReadInput;
				MemWriteReg <= MemWriteInput;
				ALUOpReg <= ALUOpInput;
				BranchTypeReg <= BranchTypeInput;
				JumpReg <= JumpInput;
				RegSrcAReg <= RegSrcAInput;
				RegSrcBReg <= RegSrcBInput;
				RegDestReg <= RegDestInput;
				ALUSrcReg <= ALUSrcInput;
				MemToRegReg <= MemToRegInput;
				RegDataAReg <= RegDataAInput;
				RegDataBReg <= RegDataBInput;
				ExtendedNumberReg <= ExtendedNumberInput;
			end if;
		end if;
	end process;

end RTL;

