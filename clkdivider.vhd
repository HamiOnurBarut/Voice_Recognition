library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clkdivider is
port(clock: in std_logic;
		clkout: out std_logic);
end clkdivider;

architecture Behavioral of clkdivider is
signal count: integer range 0 to 3:=0;
signal ct: std_logic:='0';
begin
clkout <= ct;

process(clock)
begin
	if (rising_edge(clock)) then
		if(count = 3) then
			ct <= not(ct);
			count <= 0;
		else
			count <= count + 1;		
		end if;
	end if;
end process;
end Behavioral;