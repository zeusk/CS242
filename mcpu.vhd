library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY mcpu IS
	PORT (
		RST : IN    std_logic;
		CLK : IN    std_logic;
		MOE : OUT   std_logic;
		MWE : OUT   std_logic;
		ADR : OUT   std_logic_vector(5 downto 0);
		DIN : IN    std_logic_vector(7 downto 0);
		DOU : OUT   std_logic_vector(7 downto 0)
	);
END;

ARCHITECTURE rickybridge OF mcpu IS
	signal pipe : std_logic_vector(2 downto 0);
	signal iptr : std_logic_vector(5 downto 0);
	signal addr : std_logic_vector(5 downto 0);
	signal accr : std_logic_vector(8 downto 0);
BEGIN
	PROCESS(CLK, RST)
	BEGIN
		IF (RST = '1') THEN
			addr <= (others => '0');
			accr <= (others => '0');
			iptr <= (others => '0');
			pipe <= "000";
		ELSIF (CLK'EVENT AND CLK = '1') THEN
			IF (pipe = "000") THEN
				iptr <= addr + 1;
				addr <= DIN(5 downto 0);
			ELSE
				addr <= iptr;
			END IF;

			IF (pipe = "010") THEN
				accr <= ("0" & accr(7 downto 0)) + ("0" & DIN);
			ELSIF (pipe = "011") THEN
				accr(7 downto 0) <= accr(7 downto 0) NOR DIN;
			ELSIF (pipe = "101") THEN
				accr(8) <= '0';
			END IF;

			IF (pipe /= "000") THEN
				pipe <= "000";
			ELSIF (DIN(7 downto 6) = "11" AND accr(8) = '1') THEN
				pipe <= "101";
			ELSE
				pipe <= "0" & NOT DIN(7 downto 6);
			END IF;
		END IF;
	END PROCESS;

	ADR <= addr;
	DOU <= accr(7 downto 0);
	MOE <= '1' WHEN (CLK = '1' OR RST = '1' OR pipe = "001" OR pipe = "101") ELSE '0';
	MWE <= '1' WHEN (CLK = '1' OR RST = '1' OR pipe /= "001") ELSE '0';
END rickybridge;

