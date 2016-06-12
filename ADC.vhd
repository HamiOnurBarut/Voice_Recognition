library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity ADC is
port (	clock: in std_logic;
				sdata: in std_logic;
				cs: out std_logic:='1';
				sclk200Khz: out std_logic;
				sample: out std_logic_vector(7 downto 0));
end ADC;

architecture Behavioral of ADC is
component clkdivider
	port( clock: in std_logic;
			clkout: out std_logic);
end component;

signal sclk : std_logic;
signal countstate: integer range 0 to 20:=0;
signal copysamp: std_logic_vector(11 downto 0);
signal cosample: std_logic_vector(7 downto 0);
signal a: integer range 0 to 255;

begin
clkdiv: clkdivider port map(clock => clock, clkout => sclk);
 
sclk200Khz <= sclk;
process(sclk)
begin
	if(falling_edge(sclk)) then
		if (countstate = 0) then
			cs <= '0';
			sample <= cosample;
			countstate <= 1;
		elsif (countstate < 17) then
			if(countstate > 4) then
				copysamp(16 - countstate) <= sdata;
			end if;
			countstate <= countstate + 1;
		elsif ( countstate > 16  and countstate < 20) then
			countstate <= countstate + 1;
			cs <= '1';
			cosample <= copysamp(11 downto 4);
		elsif (countstate = 20) then
			countstate <= 0;
			cosample(7) <= not(cosample(7));
		end if;
	end if;
end process;
end Behavioral;