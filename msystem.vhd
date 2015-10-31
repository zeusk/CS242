library ieee;
use ieee.std_logic_1164.all;

entity msystem is
	port(
		CLK : in std_logic;
		RST : in std_logic;
		MOE : out std_logic;
		MWE : out std_logic;
		MCS : out std_logic_vector(1 downto 0);
		CPA : out std_logic_vector(5 downto 0);
		CPI : out std_logic_vector(7 downto 0);
		CPO : out std_logic_vector(7 downto 0)
	);
end;

architecture g9000 of msystem is
	component mcpu
		PORT (
			MOE : out   std_logic;
			MWE : out   std_logic;
			RST : in    std_logic;
			CLK : in    std_logic;
			ADR : out   std_logic_vector(5 downto 0);
			DIN : in    std_logic_vector(7 downto 0);
			DOU : out   std_logic_vector(7 downto 0)
		);
	end component;

	component srom16x8
		port (
			ENA : in  std_logic;
			ADR : in  std_logic_vector(3 downto 0);
			DOU : out std_logic_vector(7 downto 0)
		);
	end component;

	component sram16x8
		port (
			ENA : in  std_logic;
			WRE : in  std_logic;
			ADR : in  std_logic_vector(3 downto 0);
			DOU : out std_logic_vector(7 downto 0);
			DIN : in  std_logic_vector(7 downto 0)
		);
	end component;

	signal CS_M00 : std_logic;
	signal CS_M01 : std_logic;
	signal CS_M10 : std_logic;
	signal CS_M11 : std_logic;

	signal RD_ENA : std_logic;
	signal WR_ENA : std_logic;

	signal CS_NUM : std_logic_vector(1 downto 0);
	signal MM_ADR : std_logic_vector(3 downto 0);
	signal CP_ADR : std_logic_vector(5 downto 0);

	signal CP_DIN : std_logic_vector(7 downto 0);
	signal CP_DOU : std_logic_vector(7 downto 0);

	signal M0_DOU : std_logic_vector(7 downto 0);
	signal M1_DOU : std_logic_vector(7 downto 0);
	signal M2_DOU : std_logic_vector(7 downto 0);
	signal M3_DOU : std_logic_vector(7 downto 0);
begin
	cpu0: mcpu port map (
		MOE => RD_ENA, MWE => WR_ENA,
		RST => RST, CLK => CLK,
		ADR => CP_ADR, DIN => CP_DIN, DOU => CP_DOU
	);
	mem0: srom16x8 port map (
		ENA => CS_M00,
		ADR => MM_ADR, DOU => M0_DOU
	);
	M1_DOU <= "00000000";

	CP_DIN <= 	M0_DOU WHEN CS_NUM = "00" ELSE
				M1_DOU WHEN CS_NUM = "01" ELSE
				M2_DOU WHEN CS_NUM = "10" ELSE
				M3_DOU;

	CS_NUM <= CP_ADR(5 downto 4);
	MM_ADR <= CP_ADR(3 downto 0);

	CS_M10 <= '0' WHEN (CS_NUM = "10" AND (RD_ENA = '0' OR  WR_ENA = '0')) ELSE '1'; -- MEM2 RAM1 0x20 - 0x2F

	MOE <= RD_ENA;
	MWE <= WR_ENA;
	MCS <= CS_NUM;
	CPI <= CP_DIN;
	CPO <= CP_DOU;
	CPA <= CP_ADR;
end;

