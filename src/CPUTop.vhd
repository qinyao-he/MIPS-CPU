----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
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
		Clock_4x : out std_logic;
		Rst : in std_logic;
		RAM1_we : out std_logic;
		RAM1_oe : out std_logic;
		RAM1_en : out std_logic;
		RAM1_addr : out std_logic_vector (17 downto 0);
		RAM1_data : inout std_logic_vector (15 downto 0);
		RAM2_we : out std_logic;
		RAM2_oe : out std_logic;
		RAM2_en : out std_logic;
		RAM2_addr : out std_logic_vector (17 downto 0);
		RAM2_data : inout std_logic_vector (15 downto 0);
		--
		COM_rdn : out  STD_LOGIC;
		COM_wrn : out  STD_LOGIC;
		COM_tsre: in  STD_LOGIC;
		COM_tbre: in  STD_LOGIC;
		COM_data_ready: in  STD_LOGIC; 
		Flash_byte : out  STD_LOGIC;
		Flash_vpen : out  STD_LOGIC;
		Flash_ce : out  STD_LOGIC;
		Flash_oe : out  STD_LOGIC;
		Flash_we : out  STD_LOGIC;
		Flash_rp : out  STD_LOGIC;
		Flash_addr : out  STD_LOGIC_VECTOR (22 downto 0);
		Flash_data : inout  STD_LOGIC_VECTOR (15 downto 0);
		Reload : in  STD_LOGIC;
		LED : out  STD_LOGIC_VECTOR (15 downto 0);
		SSD_h : out  STD_LOGIC_VECTOR (6 downto 0);
		SSD_l : out  STD_LOGIC_VECTOR (6 downto 0)
	);
end CPUTop;

architecture Behavioral of CPUTop is

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
		ALUop : in std_logic_vector (2 downto 0);
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
		BranchSelector : out  std_logic_vector (1 downto 0);
		IFIDClear : out std_logic);
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
		MemToReg : out std_logic);
	);
end component; -- Controller

component EXMEMReg
	port ( 
		Clock : in std_logic;
		Reset : in std_logic;
		WriteEN : in std_logic;
		RegWriteInput : in std_logic;
		MemReadInput : in std_logic;
		MemWriteInput : in std_logic;
		RegDestInput : in std_logic_vector(3 downto 0);
		MemToRegInput : in std_logic;
		EXResultInput : in std_logic_vector(15 downto 0);
		RegDataAInput : in std_logic_vector(15 downto 0);
		RegDataBInput : in std_logic_vector(15 downto 0);
		RegWriteOutput : out std_logic;
		MemReadOutput : out std_logic;
		MemWriteOutput : out std_logic;
		RegDestOutput : out std_logic_vector(3 downto 0);
		MemToRegOutput : out std_logic;
		EXResultOutput : out std_logic_vector(15 downto 0);
		RegDataAOutput : out std_logic_vector(15 downto 0);
		RegDataBOutput : out std_logic_vector(15 downto 0)
	);
end component; -- EXMEMReg

component Extender
	port ( Instruction : in std_logic_vector (15 downto 0);
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
		RegSrcB: in std_logic_vector (3 downto 0);
		PCWrite: out std_logic;
		IFIDWrite : out std_logic;
		IDEXClear : out std_logic
	);
end component; -- HazardUnit

component IDEXReg
	port ( 
		Clock : in std_logic;
		Reset : in std_logic;
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

		Address1 : in std_logic_vector(15 downto 0);
		DataOutput1 : out std_logic_vector(15 downto 0);

		Address2 : in std_logic_vector(15 downto 0);
		DataInput1 : in std_logic_vector(15 downto 0);
		DataOutput2 : out std_logic_vector(15 downto 0);

		MemoryAddress : out std_logic_vector(17 downto 0);
		MemoryDatabus : inout std_logic_vector(15 downto 0);
		MemoryEN : out std_logic;
		MemoryOE : out std_logic;
		MemoryRE : out std_logic;

		RAM1EN : out std_logic;

		SerialWRN : out std_logic;
		SerialRDN : out std_logic;
		SerialDATA_READY : in std_logic;
		SerialTSRE : in std_logic;
		SerialTBRE : in std_logic;
		SerialDatabus : inout std_logic_vector(7 downto 0)
	);
end component; -- IOBridge

component MEMWBReg
	port ( 
		Clock : in std_logic;
		Reset : in std_logic;
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
		WriteEN : in std_logic;
		Input : in std_logic_vector(15 downto 0);
		Output : out std_logic_vector(15 downto 0)
	);
end component; -- PCReg

component RegisterFile
	port ( 
		Clock : in std_logic;
		Reset : in std_logic;
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

-- end components

-- signal SSD_data : STD_LOGIC_VECTOR (7 downto 0);
-- IF
signal IFMuxT16Output : std_logic_vector (15 downto 0);
signal IFPCRegOutput : std_logic_vector (15 downto 0);


-- ID

-- EXE

-- MEMORY

-- Readback

begin
	Adder16PortMap : Adder16 port map (
		
	);

end Behavioral;



