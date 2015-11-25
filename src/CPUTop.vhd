----------------------------------------------------------------------------------
-- Company:
-- Engineer: 黄科 王凯
--
-- Create Date:    00:14:58 11/24/2015
-- Design Name:
-- Module Name:    CPUTop - Behavioral
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

entity CPUTop is
	port (
		Clock : in std_logic;
		Rst : in std_logic;

		Ram1EN : out std_logic;
		Ram1Data : inout std_logic_vector (7 downto 0);

		Ram2Addr : out std_logic_vector(17 downto 0);
		Ram2Data : inout std_logic_vector(15 downto 0);
		Ram2OE : out std_logic;
		Ram2WE : out std_logic;
		Ram2EN : out std_logic;

		SerialWRN : out std_logic;
		SerialRDN : out std_logic;
		SerialDATA_READY : in std_logic;
		SerialTSRE : in std_logic;
		SerialTBRE : in std_logic;

		SW : in std_logic_vector(15 downto 0);
		LED : out std_logic_vector (15 downto 0);
		DYP0 : out std_logic_vector (6 downto 0);
		DYP1 : out std_logic_vector (6 downto 0)
	);
end CPUTop;

architecture Behavioral of CPUTop is

-- components

component Seg7
	port (
		key : in std_logic_vector(3 downto 0);
		display : out std_logic_vector(6 downto 0)
	);
end component;

component Adder16
	port (
		InputA : in std_logic_vector (15 downto 0);
		InputB : in std_logic_vector (15 downto 0);
		Output : out std_logic_vector (15 downto 0) := "0000000000000000"
	);
end component; -- Adder16

component ALU
	port (
		InputA : in std_logic_vector (15 downto 0);
		InputB : in std_logic_vector (15 downto 0);
		ALUOp : in std_logic_vector (2 downto 0);
		Output : out std_logic_vector (15 downto 0) := "0000000000000000";
		ALUFlags : out std_logic_vector(1 downto 0)
	);
end component; -- ALU

component ALUController
	port (
		Instruction: in std_logic_vector(15 downto 0);
		ALUOp: out std_logic_vector(2 downto 0)
	);
end component; -- ALUController

component BranchSelector
	port (
		BranchType : in  std_logic_vector (1 downto 0);
		Jump : in  std_logic;
		Input : in  std_logic_vector (15 downto 0);
		BranchSelect : out  std_logic_vector (1 downto 0);
		IFIDClear : out std_logic
	);
end component; -- BranchSelector

component Controller
	port (
		Instruction : in std_logic_vector (15 downto 0);
		TType : out std_logic;
		EXResultSelect : out std_logic_vector (1 downto 0);
		RegWrite : out std_logic;
		MemRead : out std_logic;
		MemWrite : out std_logic;
		BranchType : out std_logic_vector (1 downto 0);
		Jump : out std_logic;
		RegSrcA : out std_logic_vector (3 downto 0);
		RegSrcB : out std_logic_vector (3 downto 0);
		RegDest : out std_logic_vector (3 downto 0);
		ALUSrc : out std_logic;
		MemToReg : out std_logic
	);
end component; -- Controller

component EXMEMReg
	port (
		Clock : in std_logic;
		Reset : in std_logic;
		Clear : in std_logic;
		WriteEN : in std_logic;
		RegWriteInput : in std_logic;
		MemReadInput : in std_logic;
		MemWriteInput : in std_logic;
		RegDestInput : in std_logic_vector(3 downto 0);
		MemToRegInput : in std_logic;
		EXResultInput : in std_logic_vector(15 downto 0);
		RegDataBInput : in std_logic_vector(15 downto 0);
		RegWriteOutput : out std_logic;
		MemReadOutput : out std_logic;
		MemWriteOutput : out std_logic;
		RegDestOutput : out std_logic_vector(3 downto 0);
		MemToRegOutput : out std_logic;
		EXResultOutput : out std_logic_vector(15 downto 0);
		RegDataBOutput : out std_logic_vector(15 downto 0)
	);
end component; -- EXMEMReg

component Extender
	port (
		Instruction : in std_logic_vector (15 downto 0);
		Output : out std_logic_vector (15 downto 0)
		 );
end component; -- Extender

component ForwardUnit
	port (
		EXMEMRegWrite : in std_logic;
		MEMWBRegWrite : in std_logic;
		EXMEMRegDest : in std_logic_vector (3 downto 0);
		MEMWBRegDest : in std_logic_vector (3 downto 0);
		IDEXRegSrcA: in std_logic_vector (3 downto 0);
		IDEXRegSrcB: in std_logic_vector (3 downto 0);
		ForwardA : out std_logic_vector (1 downto 0);
		ForwardB : out std_logic_vector (1 downto 0)
	);
end component; -- ForwardUnit

component HazardUnit
	port (
		IDEXMemRead : in std_logic;
		IDEXRegDest : in std_logic_vector (3 downto 0);
		RegSrcA : in std_logic_vector (3 downto 0);
		RegSrcB : in std_logic_vector (3 downto 0);
		PCWrite : out std_logic;
		IFIDWrite : out std_logic;
		IDEXClear : out std_logic
	);
end component; -- HazardUnit

component IDEXReg
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
		InstructionInput : in std_logic_vector(15 downto 0);
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
		InstructionOutput : out std_logic_vector(15 downto 0);
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
end component; -- IDEXReg

component IFIDReg
	port (
		Clock : in std_logic;
		Reset : in std_logic;
		Clear : in std_logic;
		WriteEN : in std_logic;
		InstructionInput : in std_logic_vector(15 downto 0);
		PCInput : in std_logic_vector(15 downto 0);
		RPCInput : in std_logic_vector(15 downto 0);
		InstructionOutput : out std_logic_vector(15 downto 0);
		PCOutput : out std_logic_vector(15 downto 0);
		RPCOutput : out std_logic_vector(15 downto 0)
	);
end component; -- IFIDReg

component IOBridge
	port (
		Clock : in std_logic;
		Reset : in std_logic;
		CPUClock : out std_logic;

		ReadEN : in std_logic;
		WriteEN : in std_logic;

		Address1 : in std_logic_vector(15 downto 0);
		DataOutput1 : out std_logic_vector(15 downto 0);

		Address2 : in std_logic_vector(15 downto 0);
		DataInput2 : in std_logic_vector(15 downto 0);
		DataOutput2 : out std_logic_vector(15 downto 0);

		MemoryAddress : out std_logic_vector(17 downto 0);
		MemoryDataBus : inout std_logic_vector(15 downto 0);
		MemoryEN : out std_logic;
		MemoryOE : out std_logic;
		MemoryWE : out std_logic;

		RAM1EN : out std_logic;

		SerialWRN : out std_logic;
		SerialRDN : out std_logic;
		SerialDATA_READY : in std_logic;
		SerialTSRE : in std_logic;
		SerialTBRE : in std_logic;
		SerialDataBus : inout std_logic_vector(7 downto 0)
	);
end component; -- IOBridge

component MEMWBReg
	port (
		Clock : in std_logic;
		Reset : in std_logic;
		Clear : in std_logic;
		WriteEN : in std_logic;

		RegWriteInput : in std_logic;
		MemToRegInput : in std_logic;
		RegDestInput : in std_logic_vector(3 downto 0);
		EXResultInput : in std_logic_vector(15 downto 0);
		MemDataInput : in std_logic_vector(15 downto 0);

		RegWriteOutput : out std_logic;
		MemToRegOutput : out std_logic;
		RegDestOutput : out std_logic_vector(3 downto 0);
		EXResultOutput : out std_logic_vector(15 downto 0);
		MemDataOutput : out std_logic_vector(15 downto 0)
	);
end component; -- MEMWBReg

component Mux16
	port (
		Control : in std_logic;
		InputA : in std_logic_vector(15 downto 0);
		InputB : in std_logic_vector(15 downto 0);
		Output : out std_logic_vector(15 downto 0)
	);
end component; -- Mux16

component MuxF16
	port (
		Control : in std_logic_vector(1 downto 0);
		InputA : in std_logic_vector(15 downto 0);
		InputB : in std_logic_vector(15 downto 0);
		InputC : in std_logic_vector(15 downto 0);
		InputD : in std_logic_vector(15 downto 0);
		Output : out std_logic_vector(15 downto 0)
	);
end component; -- MuxF16

component MuxT16
	port (
		Control : in std_logic_vector(1 downto 0);
		InputA : in std_logic_vector(15 downto 0);
		InputB : in std_logic_vector(15 downto 0);
		InputC : in std_logic_vector(15 downto 0);
		Output : out std_logic_vector(15 downto 0)
	);
end component; -- MuxT16

component PCReg
	port (
		Clock : in std_logic;
		Reset : in std_logic;
		Clear : in std_logic;
		WriteEN : in std_logic;
		Input : in std_logic_vector(15 downto 0);
		Output : out std_logic_vector(15 downto 0)
	);
end component; -- PCReg

component RegisterFile
	port (
		Clock : in std_logic;
		Reset : in std_logic;
		Clear : in std_logic;
		WriteEN : in std_logic;
		ReadRegA : in std_logic_vector(3 downto 0);
		ReadRegB : in std_logic_vector(3 downto 0);
		WriteReg : in std_logic_vector(3 downto 0);
		WriteData : in std_logic_vector(15 downto 0);
		PCInput : in std_logic_vector(15 downto 0);
		RPCInput : in std_logic_vector(15 downto 0);
		ReadDataA : out std_logic_vector(15 downto 0);
		ReadDataB : out std_logic_vector(15 downto 0)
	);
end component; -- RegisterFile

component TSelector
	port (
		TType : in std_logic;
		ALUFlags : in std_logic_vector (1 downto 0);
		TOutput : out std_logic_vector (15 downto 0)
	);
end component; -- TSelector

--component Memory
--	port (
--		ReadEN : in std_logic;
--		WriteEN : in std_logic;
--		Address : in std_logic_vector (15 downto 0);
--		DataInput : in std_logic_vector (15 downto 0);
--		DataOutput : out std_logic_vector (15 downto 0)
--	);
--end component; -- Memory

-- end components

--signal Clock_4x : std_logic;
signal Reset : std_logic;
-- IF
signal IFMuxT16Output : std_logic_vector (15 downto 0);
signal IFPCRegOutput : std_logic_vector (15 downto 0);
-- signal IFMemoryDataOutput : std_logic_vector (15 downto 0);
signal IFAdder16Output_1 : std_logic_vector (15 downto 0);
signal IFAdder16Output_2 : std_logic_vector (15 downto 0);
-- IFID
signal IFIDInstructionOutput : std_logic_vector (15 downto 0);
signal IFIDPCOutput : std_logic_vector (15 downto 0);
signal IFIDRPCOutput : std_logic_vector (15 downto 0);
-- EXE
signal EXMEMRegWriteOutput : std_logic;
signal EXMEMMemReadOutput : std_logic;
signal EXMEMMemWriteOutput : std_logic;
signal EXMEMMemToRegOutput : std_logic;
signal EXMEMRegDestOutput : std_logic_vector(3 downto 0);
signal EXMEMEXResultOutput : std_logic_vector(15 downto 0);
--signal EXMEMRegDataAOutput : std_logic_vector(15 downto 0);
signal EXMEMRegDataBOutput : std_logic_vector(15 downto 0);
signal EXMuxF16Output : std_logic_vector(15 downto 0);
signal ALUOutput : std_logic_vector(15 downto 0);
signal ALUALUFlags : std_logic_vector(1 downto 0);
signal TSelectorTOutput : std_logic_vector(15 downto 0);
signal ALUControllerALUOp : std_logic_vector(2 downto 0);
signal EXAddr16Output : std_logic_vector(15 downto 0);
signal EXMux16Output : std_logic_vector(15 downto 0);
signal EXMuxT16_1Output : std_logic_vector(15 downto 0);
signal EXMuxT16_2Output : std_logic_vector(15 downto 0);
signal BranchSelectorBranchSelect : std_logic_vector(1 downto 0);
signal BranchSelectorIFIDClear : std_logic;
signal ForwardUnitForwardA : std_logic_vector(1 downto 0);
signal ForwardUnitForwardB : std_logic_vector(1 downto 0);
signal MEMWBRegWriteOutput : std_logic;
signal MEMWBMemToRegOutput : std_logic;
signal MEMWBRegDestOutput : std_logic_vector(3 downto 0);
signal MEMWBEXResultOutput : std_logic_vector(15 downto 0);
signal MEMWBMemDataOutput : std_logic_vector(15 downto 0);
signal WBMux16Output : std_logic_vector(15 downto 0);
-- ID
signal IDControllerTType : std_logic;
signal IDControllerEXResultSelect : std_logic_vector (1 downto 0);
signal IDControllerRegWrite : std_logic;
signal IDControllerMemRead : std_logic;
signal IDControllerMemWrite : std_logic;
signal IDControllerBranchType : std_logic_vector (1 downto 0);
signal IDControllerJump : std_logic;
signal IDControllerRegSrcA : std_logic_vector (3 downto 0);
signal IDControllerRegSrcB : std_logic_vector (3 downto 0);
signal IDControllerRegDest : std_logic_vector (3 downto 0);
signal IDControllerALUSrc : std_logic;
signal IDControllerMemToReg : std_logic;

signal IDRegisterFileReadDataA : std_logic_vector (15 downto 0);
signal IDRegisterFileReadDataB : std_logic_vector (15 downto 0);

signal IDExtenderOutput : std_logic_vector (15 downto 0);
-- Unit
signal HazardUnitPCWrite : std_logic;
signal HazardUnitIFIDWrite : std_logic;
signal HazardUnitIDEXClear : std_logic;
-- IDEX
signal IDEXPCOutput : std_logic_vector (15 downto 0);
signal IDEXTTypeOutput : std_logic;
signal IDEXEXResultSelectOutput : std_logic_vector (1 downto 0);
signal IDEXRegWriteOutput : std_logic;
signal IDEXMemReadOutput : std_logic;
signal IDEXMemWriteOutput : std_logic;
signal IDEXInstructionOutput : std_logic_vector (15 downto 0);
signal IDEXBranchTypeOutput : std_logic_vector (1 downto 0);
signal IDEXJumpOutput : std_logic;
signal IDEXRegSrcAOutput : std_logic_vector (3 downto 0);
signal IDEXRegSrcBOutput : std_logic_vector (3 downto 0);
signal IDEXRegDestOutput : std_logic_vector (3 downto 0);
signal IDEXALUSrcOutput : std_logic;
signal IDEXMemToRegOutput : std_logic;
signal IDEXRegDataAOutput : std_logic_vector (15 downto 0);
signal IDEXRegDataBOutput : std_logic_vector (15 downto 0);
signal IDEXExtenedNumberOutput : std_logic_vector (15 downto 0);

-- IOBridge
signal CPUClock : std_logic;
signal IOBridgeDataOutput1 : std_logic_vector (15 downto 0);
signal IOBridgeDataOutput2 : std_logic_vector (15 downto 0);
signal IOBridgeRAM1EN : std_logic;

signal key_0, key_1 : std_logic_vector(3 downto 0);

begin

	Reset <= not Rst;
	-- CPUClock <= Clock;
	--LED <= IFIDInstructionOutput;
	--LED <= EXMuxF16Output;
	--LED <= SerialTSRE & SerialTBRE & SerialDATA_READY & "00000" & Ram1Data(7 downto 0);
	--LED <= "000000000000" & MEMWBMemToRegOutput & MEMWBMemDataOutput(0) & MEMWBEXResultOutput(0) & WBMux16Output(0);
	--LED <= "00000000000000" & MEMWBMemToRegOutput & MEMWBMemDataOutput(0);
	--LED <=	EXMuxF16Output when SW = "0000000000000000" else
	--		MEMWBMemDataOutput when SW = "0000000000000001" else
	--		MEMWBEXResultOutput when SW = "0000000000000010" else
	--		WBMux16Output when SW = "0000000000000011" else
	--		IOBridgeDataOutput2 when SW = "0000000000000100" else
	--		"000000000000000" & IDControllerMemToReg when SW = "0000000000000101" else
	--		"000000000000000" & IDEXMemToRegOutput when SW = "0000000000000110" else
	--		"000000000000000" & EXMEMMemToRegOutput when SW = "0000000000000111" else
	--		"000000000000000" & HazardUnitIDEXClear when SW = "0000000000001000" else
	--		"000000000000000" & IDControllerRegWrite when SW = "0000000000001001" else
	--		"000000000000000" & EXMEMRegWriteOutput when SW = "0000000000001010" else
	--		"00000000000000" & ForwardUnitForwardA when SW = "0000000000001011" else
	--		"00000000000000" & ForwardUnitForwardB when SW = "0000000000001100" else
	--		EXMuxT16_1Output when SW = "0000000000001101" else
	--		EXMuxT16_2Output when SW = "0000000000001110" else
	--		"0000000000000000";

	LED <=	EXMuxF16Output when SW = "0000000000000000" else
			"000000000000000" & IDControllerTType when SW = "0000000000000001" else
			"00000000000000" & IDControllerEXResultSelect when SW = "0000000000000010" else
			"000000000000000" & IDControllerRegWrite when SW = "0000000000000011" else
			"000000000000000" & IDControllerMemRead when SW = "0000000000000100" else
			"000000000000000" & IDControllerMemWrite when SW = "0000000000000101" else
			"00000000000000" & IDControllerBranchType when SW = "0000000000000110" else
			"000000000000000" & IDControllerJump when SW = "0000000000000111" else
			"000000000000" & IDControllerRegSrcA when SW = "0000000000001000" else
			"000000000000" & IDControllerRegSrcB when SW = "0000000000001001" else
			"000000000000" & IDControllerRegDest when SW = "0000000000001010" else
			"000000000000000" & IDControllerALUSrc when SW = "0000000000001011" else
			"000000000000000" & IDControllerMemToReg when SW = "0000000000001100" else
			IDRegisterFileReadDataA when SW = "0000000000001101" else
			IDRegisterFileReadDataB when SW = "0000000000001110" else
			IDExtenderOutput when SW = "0000000000001111" else
			"00000000000000" & ForwardUnitForwardA when SW = "0000000000010000" else
			"00000000000000" & ForwardUnitForwardB when SW = "0000000000010001" else
			EXMuxT16_1Output when SW = "0000000000010010" else
			EXMuxT16_2Output when SW = "0000000000010011" else
			"000000000000" & EXMEMRegDestOutput when SW = "0000000000100000" else
			"000000000000" & MEMWBRegDestOutput when SW = "0000000000100001" else
			"0000000000000000";

	Seg7_0 : Seg7 port map(key_0, DYP0);
	Seg7_1 : Seg7 port map(key_1, DYP1);
	key_1 <= IFPCRegOutput(3 downto 0);
	key_0 <= IFPCRegOutput(7 downto 4);

	-- IF
	IFMuxT16_c : MuxT16 port map (
		Control => BranchSelectorBranchSelect,
		InputA => IFAdder16Output_1,
		InputB => EXAddr16Output,
		InputC => EXMux16Output,
		Output => IFMuxT16Output
	);
	IFPCReg_c : PCReg port map (
		Clock => CPUClock,
		Reset => Reset,
		Clear => '0',
		WriteEN => HazardUnitPCWrite,
		Input => IFMuxT16Output,
		Output => IFPCRegOutput
	);
	IFAdder16_c_1 : Adder16 port map (
		InputA => IFPCRegOutput,
		InputB => "0000000000000001",
		Output => IFAdder16Output_1
	);
	IFAdder16_c_2 : Adder16 port map (
		InputA => IFPCRegOutput,
		InputB => "0000000000000010",
		Output => IFAdder16Output_2
	);

	-- IFID
	IFIDReg_c : IFIDReg port map (
		Clock => CPUClock,
		Reset => Reset,
		Clear => BranchSelectorIFIDClear,
		WriteEN => HazardUnitIFIDWrite,
		InstructionInput => IOBridgeDataOutput1,
		--InstructionInput => SW,
		PCInput => IFAdder16Output_1,
		RPCInput => IFAdder16Output_2,
		InstructionOutput => IFIDInstructionOutput,
		PCOutput => IFIDPCOutput,
		RPCOutput => IFIDRPCOutput
	);

	-- ID
	Controller_c : Controller port map (
		Instruction => IFIDInstructionOutput,
		TType => IDControllerTType ,
		EXResultSelect => IDControllerEXResultSelect,
		RegWrite => IDControllerRegWrite,
		MemRead => IDControllerMemRead,
		MemWrite => IDControllerMemWrite,
		BranchType => IDControllerBranchType,
		Jump => IDControllerJump,
		RegSrcA => IDControllerRegSrcA,
		RegSrcB => IDControllerRegSrcB,
		RegDest => IDControllerRegDest,
		ALUSrc => IDControllerALUSrc,
		MemToReg => IDControllerMemToReg
	);
	RegisterFile_c : RegisterFile port map (
		Clock => CPUClock,
		Reset => Reset,
		Clear => '0',
		WriteEN => MEMWBRegWriteOutput,
		ReadRegA => IDControllerRegSrcA,
		ReadRegB => IDControllerRegSrcB,
		WriteReg => MEMWBRegDestOutput,
		WriteData => WBMux16Output,
		PCInput => IFIDPCOutput,
		RPCInput => IFIDRPCOutput,
		ReadDataA => IDRegisterFileReadDataA,
		ReadDataB => IDRegisterFileReadDataB
	);
	Extender_c : Extender port map (
		Instruction => IFIDInstructionOutput,
		Output => IDExtenderOutput
	);
	-- Unit
	HazardUnit_c : HazardUnit port map (
		IDEXMemRead => IDEXMemReadOutput,
		IDEXRegDest => IDEXRegDestOutput,
		RegSrcA => IDControllerRegSrcA,
		RegSrcB => IDControllerRegSrcB,
		PCWrite => HazardUnitPCWrite,
		IFIDWrite => HazardUnitIFIDWrite,
		IDEXClear => HazardUnitIDEXClear
	);
	-- IDEX
	IDEXReg_c : IDEXReg port map (
		Clock => CPUClock,
		Reset => Reset,
		Clear => HazardUnitIDEXClear,
		WriteEN => '1',

		PCInput => IFIDPCOutput,
		TTypeInput => IDControllerTType,
		EXResultSelectInput => IDControllerEXResultSelect,
		RegWriteInput => IDControllerRegWrite,
		MemReadInput => IDControllerMemRead,
		MemWriteInput => IDControllerMemWrite,
		InstructionInput => IFIDInstructionOutput,
		BranchTypeInput => IDControllerBranchType,
		JumpInput => IDControllerJump,
		RegSrcAInput => IDControllerRegSrcA,
		RegSrcBInput => IDControllerRegSrcB,
		RegDestInput => IDControllerRegDest,
		ALUSrcInput => IDControllerALUSrc,
		MemToRegInput => IDControllerMemToReg,
		RegDataAInput => IDRegisterFileReadDataA,
		RegDataBInput => IDRegisterFileReadDataB,
		ExtendedNumberInput => IDExtenderOutput,

		PCOutput => IDEXPCOutput,
		TTypeOutput => IDEXTTypeOutput,
		EXResultSelectOutput => IDEXEXResultSelectOutput,
		RegWriteOutput => IDEXRegWriteOutput,
		MemReadOutput => IDEXMemReadOutput,
		MemWriteOutput => IDEXMemWriteOutput,
		InstructionOutput => IDEXInstructionOutput,
		BranchTypeOutput => IDEXBranchTypeOutput,
		JumpOutput => IDEXJumpOutput,
		RegSrcAOutput => IDEXRegSrcAOutput,
		RegSrcBOutput => IDEXRegSrcBOutput,
		RegDestOutput => IDEXRegDestOutput,
		ALUSrcOutput => IDEXALUSrcOutput,
		MemToRegOutput => IDEXMemToRegOutput,
		RegDataAOutput => IDEXRegDataAOutput,
		RegDataBOutput => IDEXRegDataBOutput,
		ExtendedNumberOutput => IDEXExtenedNumberOutput
	);
	-- EXE
	EXMEMReg_c : EXMEMReg port map (
		Clock => CPUClock,
		Reset => Reset,
		Clear => '0',
		WriteEN => '1',
		RegWriteInput => IDEXRegWriteOutput,
		MemReadInput => IDEXMemReadOutput,
		MemWriteInput => IDEXMemWriteOutput,
		RegDestInput => IDEXRegDestOutput,
		MemToRegInput => IDEXMemToRegOutput,
		EXResultInput => EXMuxF16Output,
		RegDataBInput => EXMuxT16_2Output,
		RegWriteOutput => EXMEMRegWriteOutput,
		MemReadOutput => EXMEMMemReadOutput,
		MemWriteOutput => EXMEMMemWriteOutput,
		RegDestOutput => EXMEMRegDestOutput,
		MemToRegOutput => EXMEMMemToRegOutput,
		EXResultOutput => EXMEMEXResultOutput,
		RegDataBOutput => EXMEMRegDataBOutput
	);
	EXMuxF16_c : MuxF16 port map (
		Control => IDEXEXResultSelectOutput,
		InputA => ALUOutput,
		InputB => TSelectorTOutput,
		InputC => EXMuxT16_1Output,
		InputD => EXMux16Output,
		Output => EXMuxF16Output
	);
	ALU_c : ALU port map (
		ALUOp => ALUControllerALUOp,
		InputA => EXMuxT16_1Output,
		InputB => EXMux16Output,
		Output => ALUOutput,
		ALUFlags => ALUALUFlags
	);
	TSelector_c : TSelector port map (
		TType => IDEXTTypeOutput,
		ALUFlags => ALUALUFlags,
		TOutput => TSelectorTOutput
	);
	ALUController_c : ALUController port map(
		Instruction => IDEXInstructionOutput,
		ALUOp => ALUControllerALUOp
	);
	EXAddr16 : Adder16 port map (
		InputA => IDEXPCOutput,
		InputB => IDEXExtenedNumberOutput,
		Output => EXAddr16Output
	);
	EXMuxT16_1 : MuxT16 port map (
		Control => ForwardUnitForwardA,
		InputA => IDEXRegDataAOutput,
		InputB => EXMEMEXResultOutput,
		InputC => WBMux16Output,
		Output => EXMuxT16_1Output
	);
	EXMuxT16_2 : MuxT16 port map (
		Control => ForwardUnitForwardB,
		InputA => IDEXRegDataBOutput,
		InputB => EXMEMEXResultOutput,
		InputC => WBMux16Output,
		Output => EXMuxT16_2Output
	);
	EXMux16_c : Mux16 port map (
		Control => IDEXALUSrcOutput,
		InputA => EXMuxT16_2Output,
		InputB => IDEXExtenedNumberOutput,
		Output => EXMux16Output
	);
	BranchSelector_c : BranchSelector port map (
		BranchType => IDEXBranchTypeOutput,
		Jump => IDEXJumpOutput,
		Input => EXMuxT16_1Output,
		BranchSelect => BranchSelectorBranchSelect,
		IFIDClear => BranchSelectorIFIDClear
	);
	ForwardUnit_c : ForwardUnit port map (
		EXMEMRegWrite => EXMEMRegWriteOutput,
		MEMWBRegWrite => MEMWBRegWriteOutput,
		EXMEMRegDest => EXMEMRegDestOutput,
		MEMWBRegDest => MEMWBRegDestOutput,
		IDEXRegSrcA=> IDEXRegSrcAOutput,
		IDEXRegSrcB=> IDEXRegSrcBOutput,
		ForwardA => ForwardUnitForwardA,
		ForwardB => ForwardUnitForwardB
	);
	MEMWBReg_c : MEMWBReg port map (
		Clock => CPUClock,
		Reset => Reset,
		Clear => '0',
		WriteEN => '1',

		RegWriteInput => EXMEMRegWriteOutput,
		MemToRegInput => EXMEMMemToRegOutput,
		RegDestInput => EXMEMRegDestOutput,
		EXResultInput => EXMEMEXResultOutput,
		MemDataInput => IOBridgeDataOutput2,

		RegWriteOutput => MEMWBRegWriteOutput,
		MemToRegOutput => MEMWBMemToRegOutput,
		RegDestOutput => MEMWBRegDestOutput,
		EXResultOutput => MEMWBEXResultOutput,
		MemDataOutput => MEMWBMemDataOutput
	);
	WBMux16 : Mux16 port map (
		Control => MEMWBMemToRegOutput,
		InputA => MEMWBEXResultOutput,
		InputB => MEMWBMemDataOutput,
		Output => WBMux16Output
	);
	-- IOBridge
	IOBridge_c : IOBridge port map (
		Clock => Clock,
		Reset => Reset,
		CPUClock => CPUClock,

		ReadEN => EXMEMMemReadOutput,
		WriteEN => EXMEMMemWriteOutput,

		Address1 => IFPCRegOutput,
		DataOutput1 => IOBridgeDataOutput1,

		Address2 => EXMEMEXResultOutput,
		DataInput2 => EXMEMRegDataBOutput,
		DataOutput2 => IOBridgeDataOutput2,

		MemoryAddress => Ram2Addr,
		MemoryDataBus => Ram2Data,
		MemoryEN => Ram2EN,
		MemoryOE => Ram2OE,
		MemoryWE => Ram2WE,

		RAM1EN => Ram1EN,

		SerialWRN => SerialWRN,
		SerialRDN => SerialRDN,
		SerialDATA_READY => SerialDATA_READY,
		SerialTSRE => SerialTSRE,
		SerialTBRE => SerialTBRE,
		SerialDataBus => Ram1Data
	);
end Behavioral;

