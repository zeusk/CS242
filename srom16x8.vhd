library ieee;
use ieee.std_logic_1164.all;

entity srom16x8 is
	port (
		ENA : in  std_logic;
		ADR : in  std_logic_vector(3 downto 0);
		DOU : out std_logic_vector(7 downto 0)
	);
end srom16x8;

architecture hollowridge of srom16x8 is
begin
	process(ENA, ADR)
	begin
		IF (ENA = '1') THEN 
			DOU <= "00000000";
		ELSE
			CASE ADR IS
				-- Start:
				WHEN "0000" => DOU <= "01000101"; -- ADD Mem[5] (Count = 224)
				-- Loop:
				WHEN "0001" => DOU <= "01000110"; -- ADD Mem[6] (1)
				WHEN "0010" => DOU <= "11000001"; -- JCC Loop
				-- Halt:
				WHEN "0011" => DOU <= "11000011"; -- JCC Halt
				WHEN "0100" => DOU <= "11000011"; -- JCC Halt

				-- 	Variables
				WHEN "0101" => DOU <= "11111101"; -- Count = 253
				-- 	Constants
				WHEN "0110" => DOU <= "00000001"; -- 1
				WHEN OTHERS => DOU <= "00000000";
			END CASE;
		END IF;
	END PROCESS;
END hollowridge;

