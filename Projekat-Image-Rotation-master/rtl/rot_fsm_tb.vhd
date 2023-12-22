----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/06/2023 01:02:19 AM
-- Design Name: 
-- Module Name: rot_fsm_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rot_fsm_tb is
 Generic (            
        PIXEL_WIDTH : integer := 8;
        FIXED_POINT_WIDTH : positive := 8;
        WIDTH : positive := 8
    );
end rot_fsm_tb;

architecture Behavioral of rot_fsm_tb is
  signal clk_i :  STD_LOGIC;
  signal rst_i :  STD_LOGIC;
  signal ready_o :  std_logic;
  signal start_i :  std_logic;      
  signal new_heigth_i :  STD_LOGIC_VECTOR(WIDTH - 1 downto 0 );
  signal new_width_i :  STD_LOGIC_VECTOR(WIDTH - 1 downto 0 );
  signal old_width_i :  STD_LOGIC_VECTOR(WIDTH - 1 downto 0 ); 
  signal old_heigth_i :  STD_LOGIC_VECTOR(WIDTH - 1 downto 0 );
  signal row_o :  STD_LOGIC_VECTOR(WIDTH - 1 downto 0 );
  signal col_o :   STD_LOGIC_VECTOR(WIDTH - 1 downto 0 );
  signal x_i:  STD_LOGIC_VECTOR(WIDTH - 1 downto 0 );
  signal y_i :   STD_LOGIC_VECTOR(WIDTH - 1 downto 0 );
  signal calc_req_o :  STD_LOGIC; 
  signal calc_end_i :  STD_LOGIC;
  signal pixel_data_r_in :  STD_LOGIC_VECTOR(PIXEL_WIDTH - 1 downto 0);
  signal pixel_data_g_in :  STD_LOGIC_VECTOR(PIXEL_WIDTH - 1 downto 0);
  signal pixel_data_b_in :  STD_LOGIC_VECTOR(PIXEL_WIDTH - 1 downto 0);
  signal pixel_address_unrotated_o :  STD_LOGIC_VECTOR (2*WIDTH - 1 downto 0);
  signal pixel_data_r_o :  STD_LOGIC_VECTOR(PIXEL_WIDTH - 1 downto 0);
  signal pixel_data_g_o :  STD_LOGIC_VECTOR(PIXEL_WIDTH - 1 downto 0);
  signal pixel_data_b_o :  STD_LOGIC_VECTOR(PIXEL_WIDTH - 1 downto 0);
  signal pixel_address_rotated_o :  STD_LOGIC_VECTOR (2*WIDTH - 1 downto 0);
begin
unit: entity work.rot_fsm
    generic map (PIXEL_WIDTH => PIXEL_WIDTH,
                 FIXED_POINT_WIDTH => FIXED_POINT_WIDTH,
                 WIDTH => WIDTH)
    port map (clk_i =>clk_i,
              rst_i => rst_i,
              ready_o => ready_o,
              start_i => start_i,
              new_heigth_i => new_heigth_i,
              new_width_i => new_width_i,
              old_width_i => old_width_i,
              old_heigth_i => old_heigth_i,
              row_o => row_o,
              col_o => col_o,
              x_i => x_i,
              y_i => y_i,
              calc_req_o => calc_req_o,
              calc_end_i => calc_end_i,
              pixel_data_r_in => pixel_data_r_in,
              pixel_data_g_in =>  pixel_data_g_in,
              pixel_data_b_in =>  pixel_data_b_in,
              pixel_address_unrotated1_o => pixel_address_unrotated_o,
              pixel_data_r_o => pixel_data_r_o,
              pixel_data_g_o =>  pixel_data_g_o,
              pixel_data_b_o =>  pixel_data_b_o,
              pixel_address_rotated1_o => pixel_address_rotated_o
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
        new_heigth_i <=std_logic_vector(to_signed(integer( real(60)),WIDTH));
        new_width_i <= std_logic_vector(to_signed(integer( real(60)),WIDTH));
        old_heigth_i <=std_logic_vector(to_signed(integer( real(45)),WIDTH));
        old_width_i <= std_logic_vector(to_signed(integer( real(45)),WIDTH));
        x_i <=std_logic_vector(to_signed(integer( real(22)),WIDTH));
        y_i <= std_logic_vector(to_signed(integer( real(22)),WIDTH));
        
        --midx_i <= std_logic_vector(to_signed(integer( real(120)*real(2**FIXED_POINT_WIDTH)),WIDTH));
       -- midy_i <= std_logic_vector(to_signed(integer( real(120)*real(2**FIXED_POINT_WIDTH)),WIDTH));
       -- row_i <= std_logic_vector(to_signed(integer( real(54)*real(2**FIXED_POINT_WIDTH)),WIDTH));
       -- col_i <= std_logic_vector(to_signed(integer( real(22)*real(2**FIXED_POINT_WIDTH)),WIDTH));
        start_i <= '1';
        calc_end_i <= '1';
        if ready_o /= '0' then
            wait until ready_o = '0';
        end if;
        wait for 200ns;
        start_i <= '0';
        if ready_o /= '1' then
            wait until ready_o = '1';
        end if;
        wait for 100ns;
end process;
        
end Behavioral;
