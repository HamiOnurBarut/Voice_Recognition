----------------------------------------------------------------------------------
-- Company: BRT Corp.
-- Engineer: Hami Onur BARUT 
-- 
-- Create Date: 12.02.2016 15:12:36
-- Design Name: 
-- Module Name: TopModule - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TopModule is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           --data_in : in STD_LOGIC_VECTOR (7 downto 0);
           start_sampling : in STD_LOGIC;
           ----
           window_ack : out STD_LOGIC:='0'; 
           fft_ack : out STD_LOGIC:='0';
           --data_out : out STD_LOGIC_VECTOR (7 downto 0);
           --data_enable : out STD_LOGIC:='0';
           ------
           sdata : in STD_LOGIC;
           sclk : out STD_LOGIC;
           cs : out STD_LOGIC;
           --------
           test_mode: in STD_LOGIC; ----- for rs232 test mode
           tx_done : out STD_LOGIC;
           --rx : in STD_LOGIC;
           tx : out STD_LOGIC;
           uart_enable : in STD_LOGIC
         );
end TopModule;

architecture Behavioral of TopModule is

COMPONENT blk_mem_gen_0
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;

COMPONENT UARTcontroller
  Port ( clk          : in  STD_LOGIC; -- 100 MHz clock
          din          : in  STD_LOGIC_VECTOR (7 downto 0); -- used in tx
          tx_select    : in  std_logic;  -- tx_start='1', tx operation
          uart_enable  : in  std_logic;  -- Enable UART MODE
          rx           : in  STD_LOGIC;  -- rx (not used)
          tx           : out STD_LOGIC;  -- tx
          uartTick     : out STD_LOGIC); -- uartTick
END COMPONENT;

COMPONENT xfft_0
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_config_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    s_axis_config_tvalid : IN STD_LOGIC;
    s_axis_config_tready : OUT STD_LOGIC;
    s_axis_data_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    s_axis_data_tvalid : IN STD_LOGIC;
    s_axis_data_tready : OUT STD_LOGIC;
    s_axis_data_tlast : IN STD_LOGIC;
    m_axis_data_tdata : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
    m_axis_data_tvalid : OUT STD_LOGIC;
    m_axis_data_tready : IN STD_LOGIC;
    m_axis_data_tlast : OUT STD_LOGIC;
    event_frame_started : OUT STD_LOGIC;
    event_tlast_unexpected : OUT STD_LOGIC;
    event_tlast_missing : OUT STD_LOGIC;
    event_status_channel_halt : OUT STD_LOGIC;
    event_data_in_channel_halt : OUT STD_LOGIC;
    event_data_out_channel_halt : OUT STD_LOGIC
  );
END COMPONENT;

COMPONENT adc
  PORT (
    clock: in std_logic;
      sdata: in std_logic;
      cs: out std_logic;
      sclk200Khz: out std_logic;
      sample: out std_logic_vector(7 downto 0)
  );
END COMPONENT;

--fft signals
signal s_axis_config_tdata :  STD_LOGIC_VECTOR(7 DOWNTO 0):= (others=>'0');
signal s_axis_config_tvalid :  STD_LOGIC:= '0';
signal s_axis_config_tready :  STD_LOGIC;
signal s_axis_data_tdata :  STD_LOGIC_VECTOR(15 DOWNTO 0):= (others=>'0');
signal s_axis_data_tvalid :  STD_LOGIC:= '0';
signal s_axis_data_tready :  STD_LOGIC;
signal s_axis_data_tlast :  STD_LOGIC:= '0';
signal m_axis_data_tdata :  STD_LOGIC_VECTOR(47 DOWNTO 0);
signal m_axis_data_tvalid :  STD_LOGIC;
signal m_axis_data_tready :  STD_LOGIC:= '0';
signal m_axis_data_tlast :  STD_LOGIC;

--adc
signal adcData : std_logic_vector(7 downto 0):=(others=>'0');

--ram
signal addressall : std_logic_vector(11 downto 0):=(others=>'0');
signal addra1 : std_logic_vector(11 downto 0):=(others=>'0');
signal addra2 : std_logic_vector(11 downto 0):=(others=>'0');
signal addra3 : std_logic_vector(11 downto 0):=(others=>'0');
signal addra4 : std_logic_vector(11 downto 0):=(others=>'0');
signal wea_all, wea, wea2: std_logic_vector(0 downto 0):="0";
signal dina_all, dina, dina2:std_logic_vector(7 downto 0):=(others=>'0');
signal douta : std_logic_vector(7 downto 0);

signal state_hamming : integer range 0 to 7:=0;
signal state_fft : integer range 0 to 7:=0;
signal index : integer range 0 to 255 :=0;

signal clk8khz : std_logic :='0';

type arr is array(0 to 255) of integer range -128 to 127;
signal hamming_window:arr:=(10,10,10,10,10,11,11,11,11,12,12,12,13,13,14,14,15,15,16,16,17,18,19,19,20,21,22,23,24,24,25,26,27,28,29,31,32,33,34,35,36,38,39,40,41,43,44,45,46,48,49,51,52,53,55,56,57,59,60,62,63,65
,66,68,69,70,72,73,75,76,78,79,80,82,83,85,86,87,89,90,91,93,94,95,97,98,99,100,101,103,104,105,106,107,108,109,110,111,112,113
,114,115,116,117,117,118,119,120,120,121,122,122,123,123,124,124,125,125,125,126,126,126,126,127,127,127,127,127,127,127,127,127,127,126,126,126,126,125,125,125,124,124,123,123,122,122
,121,120,120,119,118,117,117,116,115,114,113,112,111,110,109,108,107,106,105,104,103,101,100,99,98,97,95,94,93,91,90,89,87,86,85,83,82,80,79,78,76,75,73,72,70,69,68,66,65,63,62,60,59,57,56,55,53
,52,51,49,48,46,45,44,43,41,40,39,38,36,35,34,33,32,31,29,28,27,26,25,24,24,23,22,21,20,19,19,18,17,16,16,15,15,14,14,13,13,12,12,12,11,11,11,11,10,10,10,10,10);

--rs232
signal tx_select    :std_logic := '1';  
signal rx    :std_logic;  
signal uartTick:std_logic;
signal din : std_logic_vector(7 downto 0):=(others=>'0');

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
begin

wea_all <= wea or wea2;
addressall <= addra1 or addra2 or addra3;
dina_all <= dina or dina2;

ram_instance : blk_mem_gen_0
  PORT MAP 
  (
    clka => clk,
    wea => wea_all,
    addra => addressall,
    dina => dina_all,
    douta => douta
  );
  ----------------------------------------
  --------------------------------------------
 uart_instance : UARTcontroller
    PORT MAP 
    (
       clk          =>  clk        ,
       din          =>  din        ,
       tx_select    =>  tx_select  ,
       uart_enable  =>  uart_enable,
       rx           =>  rx         ,
       tx           =>  tx         ,
       uartTick     =>  uartTick   
    );
    
fft_instance : xfft_0
    PORT MAP (
      aclk => clk,
      s_axis_config_tdata => s_axis_config_tdata,
      s_axis_config_tvalid => s_axis_config_tvalid,
      s_axis_config_tready => s_axis_config_tready,
      s_axis_data_tdata => s_axis_data_tdata,
      s_axis_data_tvalid => s_axis_data_tvalid,
      s_axis_data_tready => s_axis_data_tready,
      s_axis_data_tlast => s_axis_data_tlast,
      m_axis_data_tdata => m_axis_data_tdata,
      m_axis_data_tvalid => m_axis_data_tvalid,
      m_axis_data_tready => m_axis_data_tready,
      m_axis_data_tlast => m_axis_data_tlast,
      event_frame_started => open,
      event_tlast_unexpected => open,
      event_tlast_missing => open,
      event_status_channel_halt => open,
      event_data_in_channel_halt => open,
      event_data_out_channel_halt => open
    );
    
 adc_instance : adc
      PORT MAP 
      (
      clock => clk,
      sdata => sdata,
      cs => cs,
      sclk200Khz =>  sclk,
      sample => adcData
      );



process(clk8khz)
variable temp : std_logic_vector(15 downto 0);
begin
if rising_edge(clk8khz) then
    if state_hamming = 0 then
        if start_sampling = '1' then
            state_hamming <= 1;
        else
            state_hamming <= 0;
        end if;
   elsif state_hamming = 1 then 
        if to_integer(signed(adcData))>32 then
            state_hamming <= 2;
        else
            state_hamming <= 1;
        end if;
   elsif state_hamming = 2 then     
        temp := std_logic_vector(signed(adcData)*to_signed(hamming_window(index),8));
        dina <= temp(15 downto 8);
--        dina <= adcData;
        wea <= "1";
        state_hamming <= 3;
        index <= index + 1;
   elsif state_hamming = 3 then   
        temp :=  std_logic_vector(signed(adcData)*to_signed(hamming_window(index),8));
        dina <= temp(15 downto 8);
--        dina <= adcData;
        wea <= "1";
        
        if index = 255 then
            index <= 0;
        else
            index <= index + 1;
        end if;
        if to_integer(unsigned(addra1)) = 4095 then
            state_hamming <=4;
            wea <= "0";
            addra1 <= (others=>'0');
        else
            state_hamming <= 3;
            addra1 <= std_logic_vector(unsigned(addra1)+1);
        end if;
      elsif state_hamming = 4 then
        addra1 <= (others=>'0');
        window_ack <= '1';
        fft_ack <= '1';
      end if;
   end if;
end process;
     
process(clk)
variable count : integer range 0 to 6249 :=0;
begin
if rising_edge(clk) then
    if count= 6249 then
        clk8khz<= not clk8khz;
        count:=0;
    else
        count:=count+1;
    end if;
end if;
end process;   
            
process(clk)
variable temp : std_logic_vector(15 downto 0);
variable temp_mult : signed(33 downto 0);

begin
if rising_edge(clk) then
    if state_fft = 0 then
        if fft_enable = '1' then
            state_fft <= 1;
        else
            state_fft <= 0;
        end if;
   elsif state_fft = 1 then 
        s_axis_data_tvalid <= '1';
        s_axis_data_tdata <= "00000000"&douta;
        addra2 <= std_logic_vector(unsigned(addra2)+1);
        if (to_integer(unsigned(addra2)) = 255) then
            state_fft <= 2;
        else
            state_fft <= 1;
        end if;
    elsif state_fft = 2 then
        s_axis_data_tvalid <= '0';
        addra2 <= (others=>'0');
        if m_axis_data_tvalid = '1' then
            state_fft <= 3;
            m_axis_data_tready <= '1';
        else
            state_fft <= 2;
        end if;
    elsif state_fft = 3 then
        temp_mult := signed(m_axis_data_tdata(40 downto 24))*signed(m_axis_data_tdata(40 downto 24))
                 + signed(m_axis_data_tdata(16 downto 0))*signed(m_axis_data_tdata(16 downto 0));
        --data_out <= std_logic_vector(temp_mult(26 downto 19));
        wea21 <= "1";------------------
        dina3 <= std_logic_vector(temp_mult(26 downto 19));----------------
        --data_enable <= '1';
        wea21 <= "1";
        addra4  <= std_logic_vector(unsigned(address4)+1);
        
        if m_axis_data_tvalid = '0' then
            state_fft <= 4;
            wea21 <= "0";--------------------
            m_axis_data_tready <= '0';
            data_enable <= '0';
        end if;
    elsif state_fft = 4 then
           
   end if;
end if;
end process;



process (uartTick, uart_enable)
    variable count: integer range 0 to 255:=0;
    variable state: integer range 0 to 1:=0;
 begin
    if uart_enable='0' then
        tx_done<='0';
        state:=0;
        count:=0;
        addra3<=(others=>'0');
    else
        if rising_edge(uartTick) then
            if  tx_select='1' then 
                if test_mode ='1' then ----------------- TEST MODE
                    if state=0 then
                        din<=std_logic_vector(to_unsigned(count,8));
                        count:=count+1;                         
                        if (count=255) then
                            count:=0;
                            state:=1;
                        end if; 
                     else --wait state
                         tx_done<='1';
                     end if;
                 else  --------------------------- REAL MODE
                    if state=0 then
                        din<=douta; ----
                        addra3<=std_logic_vector(unsigned(addra3)+1);
                        if to_integer(unsigned(addra3)) = 4095 then
                            addra3<=(others=>'0');
                            state:=1;
                        end if;
                     else --wait state
                        tx_done<='1';
                     end if;  
                  end if;    
             else -- tx_select
                 tx_done<='0';
                 state:=0;
                 count:=0;
                 addra3<=(others=>'0');
             end if;
         end if;
      end if;       
 end process;
 
 
 end Behavioral;