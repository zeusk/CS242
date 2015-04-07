library ieee;
use ieee.std_logic_1164.all;

entity sram16x8 is
	port (
		ENA : in  std_logic;
		WRE : in  std_logic;
		ADR : in  std_logic_vector(3 downto 0);
		DOU : out std_logic_vector(7 downto 0);
		DIN : in  std_logic_vector(7 downto 0)
	);
end sram16x8;

architecture hollowridge of sram16x8 is
	signal LAD : std_logic_vector(3 downto 0) := "0000";
	signal LIN : std_logic_vector(7 downto 0) := "00000000";
begin
	process(ENA, WRE, ADR)
	begin
		IF (ENA = '1') THEN 
			LAD <= LAD;
			LIN <= LIN;
		ELSE
			IF (WRE = '1') THEN
				case ADR is
					WHEN "1110" => DOU <= LIN;
					WHEN "1111" => DOU <= "0000" & LAD;
					WHEN OTHERS => DOU <= "00000000";
				end case;
			ELSE
				LIN <= DIN;
			END IF;
			LAD <= ADR;
		END IF;
	END PROCESS;
END hollowridge;

