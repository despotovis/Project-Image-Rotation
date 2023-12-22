
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xialinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pru_tb is
     Generic (            
           FIXED_POINT_WIDTH : positive := 16;
           WIDTH : positive := 8
    );
end pru_tb;

architecture Behavioral of pru_tb is
signal clk_i : std_logic;
signal rst_i : std_logic;
signal ready_o : STD_LOGIC;
signal start : STD_LOGIC;
signal finished_o : STD_LOGIC;
signal snoop_io : STD_LOGIC_VECTOR (FIXED_POINT_WIDTH - 1 downto 0);
signal x_o : STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
signal y_o : STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
signal cx_i : STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
signal cy_i : STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
signal sinc_i : STD_LOGIC_VECTOR (FIXED_POINT_WIDTH - 1 downto 0);
signal cosc_i : STD_LOGIC_VECTOR (FIXED_POINT_WIDTH - 1 downto 0);
signal midx_i : STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
signal midy_i : STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
signal row_i : STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
signal col_i : STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
signal lr_i  : STD_LOGIC;
begin
unit: entity work.point_rotation_unit 
    generic map (FIXED_POINT_WIDTH => FIXED_POINT_WIDTH,
                 WIDTH => WIDTH)
    port map (clk_i =>clk_i,
              rst_i => rst_i,
              ready_o => ready_o,
              finished_o => finished_o,
              start => start,
              snoop_io => snoop_io,
              x_o => x_o,
              y_o => y_o,
              cx_i => cx_i,
              cy_i => cy_i,
              sinc_i => sinc_i,
              cosc_i => cosc_i,
              midx_i => midx_i,
              midy_i => midy_i,
              row_i => row_i,
              col_i => col_i,
              lr_i =>  lr_i
              );
clk: 
    process begin
        clk_i <= '1';
        wait for 50ns;
        clk_i <= '0';
        wait for 50ns;
    end process;
init: process begin
        rst_i <= '1';
        wait for 100ns;
        rst_i <= '0';
        if ready_o /= '1' then
            wait until ready_o = '1';
        end if;
        wait for 100ns;    
        lr_i <= '0';
        sinc_i <= std_logic_vector(to_signed(integer( real(0.70710678118)*real(2**WIDTH)),FIXED_POINT_WIDTH));
        cosc_i <= std_logic_vector(to_signed(integer( real(-0.70710678118)*real(2**WIDTH)),FIXED_POINT_WIDTH));
        cx_i <= std_logic_vector(to_signed(integer( real(60)),WIDTH));
        cy_i <= std_logic_vector(to_signed(integer( real(60)),WIDTH));
        midx_i <= std_logic_vector(to_signed(integer( real(45)),WIDTH));
        midy_i <= std_logic_vector(to_signed(integer( real(45)),WIDTH));
        row_i <= std_logic_vector(to_signed(integer( real(22)),WIDTH));
        col_i <= std_logic_vector(to_signed(integer( real(22)),WIDTH));
        start <= '1';
        if ready_o /= '0' then
            wait until ready_o = '0';
        end if;
        wait for 200ns;
        start <= '0';
        if ready_o /= '1' then
            wait until ready_o = '1';
        end if;
        wait for 1000ns;
        
    end process;
end Behavioral;
