----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    16:32:28 11/28/2015
-- Design Name:
-- Module Name:    CPU - RTL
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

entity CPU is
	port (
		Clock : in std_logic;
		Reset : in std_logic;

		InstAddress : out std_logic_vector(15 downto 0);
		InstInput : in std_logic_vector(15 downto 0);

		DataAddress : out std_logic_vector(15 downto 0);
		DataInput : in std_logic_vector(15 downto 0);
		DataOutput : out std_logic_vector(15 downto 0);

		MemoryReadEN : out std_logic;
		MemoryWriteEN : out std_logic;

		SWIn : in std_logic_vector(15 downto 0);
		LEDOut : out std_logic_vector(15 downto 0);
		PCOut : out std_logic_vector(15 downto 0)
	);
end CPU;

architecture RTL of CPU is

-- components

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
		BranchHappen : out std_logic
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
		HazardHappen : out std_logic
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
		TType : in  std_logic;
		ALUFlags : in  std_logic_vector (1 downto 0);
		TOutput : out  std_logic_vector (15 downto 0)
	);
end component;

component StallUnit
	port (
		Branch : in std_logic;
		Hazard : in std_logic;
		Stall : in std_logic;

		PCWriteEN : out std_logic;
		IFIDWriteEN : out std_logic;
		IDEXWriteEN : out std_logic;
		EXMEMWriteEN : out std_logic;
		MEMWBWriteEN : out std_logic;

		PCClear : out std_logic;
		IFIDClear : out std_logic;
		IDEXClear : out std_logic;
		EXMEMClear : out std_logic;
		MEMWBClear : out std_logic
	);
end component;

-- signal

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

signal ALUControllerALUOp : std_logic_vector(2 downto 0);
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
signal IDEXALUOpOutput : std_logic_vector (2 downto 0);
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

-- Stall
signal PCWriteEN : std_logic;
signal IFIDWriteEN : std_logic;
signal IDEXWriteEN : std_logic;
signal EXMEMWriteEN : std_logic;
signal MEMWBWriteEN : std_logic;

signal PCClear : std_logic;
signal IFIDClear : std_logic;
signal IDEXClear : std_logic;
signal EXMEMClear : std_logic;
signal MEMWBClear : std_logic;

signal BranchHappen : std_logic;
signal HazardHappen : std_logic;

begin

	InstAddress <= IFPCRegOutput;
	DataAddress <= EXMEMEXResultOutput;
	DataOutput <= EXMEMRegDataBOutput;
	MemoryReadEN <= EXMEMMemReadOutput;
	MemoryWriteEN <= EXMEMMemWriteOutput;

	LEDOut <=	EXMuxF16Output when SWIn = "0000000000000000" else
			"000000000000000" & IDControllerTType when SWIn = "0000000000000001" else
			"00000000000000" & IDControllerEXResultSelect when SWIn = "0000000000000010" else
			"000000000000000" & IDControllerRegWrite when SWIn = "0000000000000011" else
			"000000000000000" & IDControllerMemRead when SWIn = "0000000000000100" else
			"000000000000000" & IDControllerMemWrite when SWIn = "0000000000000101" else
			"00000000000000" & IDControllerBranchType when SWIn = "0000000000000110" else
			"000000000000000" & IDControllerJump when SWIn = "0000000000000111" else
			"000000000000" & IDControllerRegSrcA when SWIn = "0000000000001000" else
			"000000000000" & IDControllerRegSrcB when SWIn = "0000000000001001" else
			"000000000000" & IDControllerRegDest when SWIn = "0000000000001010" else
			"000000000000000" & IDControllerALUSrc when SWIn = "0000000000001011" else
			"000000000000000" & IDControllerMemToReg when SWIn = "0000000000001100" else
			IDRegisterFileReadDataA when SWIn = "0000000000001101" else
			IDRegisterFileReadDataB when SWIn = "0000000000001110" else
			IDExtenderOutput when SWIn = "0000000000001111" else
			"00000000000000" & ForwardUnitForwardA when SWIn = "0000000000010000" else
			"00000000000000" & ForwardUnitForwardB when SWIn = "0000000000010001" else
			EXMuxT16_1Output when SWIn = "0000000000010010" else
			EXMuxT16_2Output when SWIn = "0000000000010011" else
			"000000000000" & EXMEMRegDestOutput when SWIn = "0000000000100000" else
			"000000000000" & MEMWBRegDestOutput when SWIn = "0000000000100001" else
			EXAddr16Output when SWIn = "0000000000100010" else
			"0000000000000000";
	PCOut <= IFPCRegOutput;

	-- IF
	IFMuxT16_c : MuxT16 port map (
		Control => BranchSelectorBranchSelect,
		InputA => IFAdder16Output_1,
		InputB => EXAddr16Output,
		InputC => EXMuxT16_1Output,
		Output => IFMuxT16Output
	);
	IFPCReg_c : PCReg port map (
		Clock => Clock,
		Reset => Reset,
		Clear => PCClear,
		WriteEN => PCWriteEN,
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
		Clock => Clock,
		Reset => Reset,
		Clear => IFIDClear,
		WriteEN => IFIDWriteEN,
		InstructionInput => InstInput,
		--InstructionInput => SWIn,
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
		Clock => Clock,
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
	ALUController_c : ALUController port map(
		Instruction => IFIDInstructionOutput,
		ALUOp => ALUControllerALUOp
	);
	-- Unit
	HazardUnit_c : HazardUnit port map (
		IDEXMemRead => IDEXMemReadOutput,
		IDEXRegDest => IDEXRegDestOutput,
		RegSrcA => IDControllerRegSrcA,
		RegSrcB => IDControllerRegSrcB,
		HazardHappen => HazardHappen
	);
	-- IDEX
	IDEXReg_c : IDEXReg port map (
		Clock => Clock,
		Reset => Reset,
		Clear => IDEXClear,
		WriteEN => IDEXWriteEN,

		PCInput => IFIDPCOutput,
		TTypeInput => IDControllerTType,
		EXResultSelectInput => IDControllerEXResultSelect,
		RegWriteInput => IDControllerRegWrite,
		MemReadInput => IDControllerMemRead,
		MemWriteInput => IDControllerMemWrite,
		ALUOpInput => ALUControllerALUOp,
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
		ALUOpOutput => IDEXALUOpOutput,
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
		Clock => Clock,
		Reset => Reset,
		Clear => EXMEMClear,
		WriteEN => EXMEMWriteEN,
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
		ALUOp => IDEXALUOpOutput,
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
		BranchHappen => BranchHappen
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
		Clock => Clock,
		Reset => Reset,
		Clear => MEMWBClear,
		WriteEN => MEMWBWriteEN,

		RegWriteInput => EXMEMRegWriteOutput,
		MemToRegInput => EXMEMMemToRegOutput,
		RegDestInput => EXMEMRegDestOutput,
		EXResultInput => EXMEMEXResultOutput,
		MemDataInput => DataInput,

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

	StallUnit_c : StallUnit port map (
		Branch => BranchHappen,
		Hazard => HazardHappen,
		Stall => '0',

		PCWriteEN => PCWriteEN,
		IFIDWriteEN => IFIDWriteEN, 
		IDEXWriteEN => IDEXWriteEN,
		EXMEMWriteEN => EXMEMWriteEN,
		MEMWBWriteEN => MEMWBWriteEN,

		PCClear => PCClear,
		IFIDClear => IFIDClear,
		IDEXClear => IDEXClear,
		EXMEMClear => EXMEMClear,
		MEMWBClear => MEMWBClear
	);

end RTL;

