library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity delay_increment is
    generic ( delay_ports : natural := 3;
              width_ports : natural := 3);
    port ( clk,reset: in STD_LOGIC;
              update : in STD_LOGIC;
              in_data : in  STD_LOGIC_VECTOR (7 downto 0);
              led : out STD_LOGIC_VECTOR (2 downto 0);
              out_data : out  STD_LOGIC_VECTOR (7 downto 0);
              d_big,d_mini,d_opo : out STD_LOGIC_VECTOR (25 downto 0);
              w_big,w_mini,w_opo : out STD_LOGIC_VECTOR (25 downto 0));
end delay_increment;

architecture fsm_arch of delay_increment is
    type state_type is (idle,channel,d_or_w,delay_channel,delay_channel_inc,width_channel,width_channel_inc);
    type delay_file_type is array (delay_ports-1 downto 0) of unsigned (25 downto 0);
    type width_file_type is array(width_ports-1 downto 0) of unsigned (25 downto 0);
    signal d_reg, d_succ: delay_file_type;
    signal w_reg, w_succ: width_file_type;
    signal state_reg : state_type;
    signal which_channel : natural;
	 
    function to_slv(C : Character) return STD_LOGIC_VECTOR is
    begin
       return STD_LOGIC_VECTOR(to_unsigned(Character'pos(c),8));
    end to_slv;
	 
    function "=" (A : STD_LOGIC_VECTOR(7 downto 0); B : Character) 
       return boolean is
    begin
       return (A = to_slv(B));
    end function "=";

begin

--------------------------------------
--State Machine
--------------------------------------
process(clk,reset)
begin
if reset='1' then
    state_reg <= idle;
    d_reg <= (others => (others => '0'));
    w_reg <= (others => (others => '0'));
    which_channel <= 0;
elsif rising_edge(clk) then
    -- default actions ... update if asked
    if update ='1' then
       d_reg <= d_succ;
       w_reg <= w_succ;
    end if;
    case state_reg is
        when idle =>
            if in_data = 'c' then 
                state_reg <= channel;
                which_channel <= 0;
            end if;
        when channel =>
            if (Character'pos('0') <= unsigned(in_data)) and (unsigned(in_data)<= Character'pos('9')) then
                which_channel <= (to_integer(unsigned(in_data)) - Character'pos('0'));
                state_reg <= d_or_w;
            elsif in_data = '#' then 
                state_reg <= idle;
                which_channel <= which_channel;
            end if;
        when d_or_w =>
            if in_data = 'd' then 
                state_reg <= delay_channel;
            elsif in_data = 'w' then 
                state_reg <= width_channel;
            elsif in_data = '#' then 
                state_reg <= idle;
            end if;
        when delay_channel =>
            if in_data = 'i' then 
                state_reg <= delay_channel_inc;
            elsif in_data = '#' then 
                state_reg <= idle;
            end if;
        when delay_channel_inc =>
            if in_data = 'u' then 
                d_succ(which_channel) <= d_reg(which_channel) + 250;
                state_reg <= idle;
            elsif in_data = 'd' then 
                d_succ(which_channel) <= d_reg(which_channel) - 250;
                state_reg <= idle;
            else
                d_succ(which_channel) <= d_reg(which_channel); -- wait for any of 'u', 'd', '#'
            end if;
            if in_data = '#' then 
                state_reg <= idle;
            end if;
        when width_channel =>
            if in_data = 'i' then 
                state_reg <= width_channel_inc;
            elsif in_data = '#' then 
                state_reg <= idle;
            end if;
        when width_channel_inc =>
            if in_data = 'u' then 
                w_succ(which_channel) <= w_reg(which_channel) + 250;
                state_reg <= idle;
            elsif in_data = 'd' then 
                w_succ(which_channel) <= w_reg(which_channel) - 250;
                state_reg <= idle;
            else
                w_succ(which_channel) <= w_reg(which_channel); -- wait for any of 'u', 'd', '#'
            end if;
            if in_data = '#' then 
                state_reg <= idle;
            end if;
    end case;
end if;
end process;

--------------------------------------
--Output Logic
--------------------------------------
d_big  <= std_logic_vector(d_reg(0));
d_mini <= std_logic_vector(d_reg(1));
d_opo  <= std_logic_vector(d_reg(2));
w_big  <= std_logic_vector(w_reg(0));
w_mini <= std_logic_vector(w_reg(1));
w_opo  <= std_logic_vector(w_reg(2));
end fsm_arch;