----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/08/2023 01:24:24 PM
-- Design Name: 
-- Module Name: ip_tb - Behavioral
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

entity ip_tb is
generic (
        PIXEL_WIDTH : integer := 8;
        FIXED_POINT_WIDTH : positive := 16;
        WIDTH : positive := 8
    );
end ip_tb;

architecture Behavioral of ip_tb is
  signal clk_i :  STD_LOGIC;
  signal rst_i :  STD_LOGIC;
  signal ready_o :  std_logic;
  signal start_i :  std_logic;      
  signal new_heigth_i :  STD_LOGIC_VECTOR(WIDTH - 1 downto 0 );
  signal new_width_i :  STD_LOGIC_VECTOR(WIDTH - 1 downto 0 );
  signal old_width_i :  STD_LOGIC_VECTOR(WIDTH - 1 downto 0 ); 
  signal old_heigth_i :  STD_LOGIC_VECTOR(WIDTH - 1 downto 0 );
  signal cy_i :  STD_LOGIC_VECTOR(WIDTH - 1 downto 0 );
  signal cx_i :   STD_LOGIC_VECTOR(WIDTH - 1 downto 0 );
  signal sinc_i :  STD_LOGIC_VECTOR(2*WIDTH - 1 downto 0 );
  signal cosc_i :   STD_LOGIC_VECTOR(2*WIDTH - 1 downto 0 );
  signal midx_i:  STD_LOGIC_VECTOR(WIDTH - 1 downto 0 );
  signal midy_i :   STD_LOGIC_VECTOR(WIDTH - 1 downto 0 ); 
  signal lr_i :  STD_LOGIC;
  signal pixel_data_r_in :  STD_LOGIC_VECTOR(PIXEL_WIDTH - 1 downto 0);
  signal pixel_data_g_in :  STD_LOGIC_VECTOR(PIXEL_WIDTH - 1 downto 0);
  signal pixel_data_b_in :  STD_LOGIC_VECTOR(PIXEL_WIDTH - 1 downto 0);
  signal pixel_address_unrotated_o :  STD_LOGIC_VECTOR (2*WIDTH - 1 downto 0);
  signal pixel_data_r_o :  STD_LOGIC_VECTOR(PIXEL_WIDTH - 1 downto 0);
  signal pixel_data_g_o :  STD_LOGIC_VECTOR(PIXEL_WIDTH - 1 downto 0);
  signal pixel_data_b_o :  STD_LOGIC_VECTOR(PIXEL_WIDTH - 1 downto 0);
  signal pixel_address_rotated_o :  STD_LOGIC_VECTOR (2*WIDTH - 1 downto 0);
begin
unit: entity work.point_rotation_ip
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
              cx_i => cx_i,
              cy_i => cy_i,
              midx_i => midx_i,
              midy_i => midy_i,
              cosc_i => cosc_i,
              sinc_i => sinc_i,
              lr_i => lr_i ,
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
        new_heigth_i <=std_logic_vector(to_signed(integer( real(84)),WIDTH));
        new_width_i <= std_logic_vector(to_signed(integer( real(84)),WIDTH));
        old_heigth_i <=std_logic_vector(to_signed(integer( real(60)),WIDTH));
        old_width_i <= std_logic_vector(to_signed(integer( real(60)),WIDTH));
        sinc_i <= std_logic_vector(to_signed(integer( real(0.70710678118)*real(2**WIDTH)),FIXED_POINT_WIDTH));
        cosc_i <= std_logic_vector(to_signed(integer( real(0.70710678118)*real(2**WIDTH)),FIXED_POINT_WIDTH));
        cx_i <= std_logic_vector(to_signed(integer( real(30)),WIDTH));
        cy_i <= std_logic_vector(to_signed(integer( real(30)),WIDTH));
        midx_i <= std_logic_vector(to_signed(integer( real(42)),WIDTH));
        midy_i <= std_logic_vector(to_signed(integer( real(42)),WIDTH));
        lr_i <= '0';
        --midx_i <= std_logic_vector(to_signed(integer( real(120)*real(2**FIXED_POINT_WIDTH)),WIDTH));
       -- midy_i <= std_logic_vector(to_signed(integer( real(120)*real(2**FIXED_POINT_WIDTH)),WIDTH));
       -- row_i <= std_logic_vector(to_signed(integer( real(54)*real(2**FIXED_POINT_WIDTH)),WIDTH));
       -- col_i <= std_logic_vector(to_signed(integer( real(22)*real(2**FIXED_POINT_WIDTH)),WIDTH));
        start_i <= '1';
       
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
