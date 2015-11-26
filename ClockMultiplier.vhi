
-- VHDL Instantiation Created from source file ClockMultiplier.vhd -- 10:46:39 11/26/2015
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT ClockMultiplier
	PORT(
		CLKIN_IN : IN std_logic;
		RST_IN : IN std_logic;          
		CLKIN_IBUFG_OUT : OUT std_logic;
		CLK0_OUT : OUT std_logic;
		CLK2X_OUT : OUT std_logic
		);
	END COMPONENT;

	Inst_ClockMultiplier: ClockMultiplier PORT MAP(
		CLKIN_IN => ,
		RST_IN => ,
		CLKIN_IBUFG_OUT => ,
		CLK0_OUT => ,
		CLK2X_OUT => 
	);


