----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2023 06:27:40 PM
-- Design Name: 
-- Module Name: point_rotation_ip - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity point_rotation_ip is
 generic (
        PIXEL_WIDTH : integer := 8;
        ADDRESS_WIDTH : integer := 16;
        FIXED_POINT_WIDTH : positive := 16;
        WIDTH : positive := 8
    );
    port(      
          ready_o : out std_logic;
          end_o : out std_logic;
          start_i : in std_logic;
          
           clk_i : in std_logic;
           rst_i : in std_logic;    
           
           snoop_io : out STD_LOGIC_VECTOR (2*WIDTH - 1 downto 0);
           
           pixel_data_r_in : in STD_LOGIC_VECTOR(PIXEL_WIDTH - 1 downto 0);
           pixel_data_g_in : in STD_LOGIC_VECTOR(PIXEL_WIDTH - 1 downto 0);
           pixel_data_b_in : in STD_LOGIC_VECTOR(PIXEL_WIDTH - 1 downto 0);  
           
           pixel_data_r_o : out STD_LOGIC_VECTOR(PIXEL_WIDTH - 1 downto 0);
           pixel_data_g_o : out STD_LOGIC_VECTOR(PIXEL_WIDTH - 1 downto 0);
           pixel_data_b_o : out STD_LOGIC_VECTOR(PIXEL_WIDTH - 1 downto 0);
           
           pixel_address_rotated1_o : out STD_LOGIC_VECTOR (ADDRESS_WIDTH - 1 downto 0);
           pixel_address_unrotated1_o : out STD_LOGIC_VECTOR (ADDRESS_WIDTH - 1 downto 0);
            -- all critical inputs for calculation 
            -- output matrix dims  
          new_heigth_i : in STD_LOGIC_VECTOR(WIDTH - 1 downto 0 );--
          new_width_i : in STD_LOGIC_VECTOR(WIDTH - 1 downto 0 );--
            --input matrix dims
          old_width_i : in STD_LOGIC_VECTOR(WIDTH - 1 downto 0 ); --
          old_heigth_i : in STD_LOGIC_VECTOR(WIDTH - 1 downto 0 );--
          
          cx_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
          cy_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
          
          sinc_i : in STD_LOGIC_VECTOR (2*WIDTH - 1 downto 0);
          cosc_i : in STD_LOGIC_VECTOR (2*WIDTH - 1 downto 0);
          
          midx_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
          midy_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
          
          bram_read_enable_o : out STD_LOGIC;
          bram_write_enable_o : out STD_LOGIC;
          
          --row_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
         -- col_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
          lr_i  : in STD_LOGIC 
    );

end point_rotation_ip;

architecture Behavioral of point_rotation_ip is
signal row_s , col_s : STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
signal x_s ,y_s : STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
signal calc_req_s : STD_LOGIC;
signal calc_finished_s : STD_LOGIC;
signal calc_ready_s : STD_LOGIC;


begin
fsm: entity work.rot_fsm
    generic map (PIXEL_WIDTH => PIXEL_WIDTH,
                 ADDRESS_WIDTH => ADDRESS_WIDTH,
                 FIXED_POINT_WIDTH => FIXED_POINT_WIDTH,
                 WIDTH => WIDTH)
    port map (clk_i =>clk_i,
              rst_i => rst_i,
              ready_o => ready_o,
              end_o => end_o,
              start_i => start_i,
              new_heigth_i => new_heigth_i,
              new_width_i => new_width_i,
              old_width_i => old_width_i,
              old_heigth_i => old_heigth_i,
              row_o => row_s,
              col_o => col_s,
              x_i => x_s,
              y_i => y_s,
              calc_req_o => calc_req_s,
              calc_finished_i => calc_finished_s,
              calc_ready_i => calc_ready_s,
              pixel_data_r_in => pixel_data_r_in,
              pixel_data_g_in =>  pixel_data_g_in,
              pixel_data_b_in =>  pixel_data_b_in,
              pixel_address_unrotated1_o => pixel_address_unrotated1_o,
              pixel_data_r_o => pixel_data_r_o,
              pixel_data_g_o =>  pixel_data_g_o,
              pixel_data_b_o =>  pixel_data_b_o,
              pixel_address_rotated1_o => pixel_address_rotated1_o,
              bram_read_enable_o => bram_read_enable_o,
              bram_write_enable_o => bram_write_enable_o  
              );
pru: entity work.point_rotation_unit 
    generic map (FIXED_POINT_WIDTH => FIXED_POINT_WIDTH,
                 WIDTH => WIDTH)
    port map (clk_i =>clk_i,
              rst_i => rst_i,
              ready_o => calc_ready_s,
              start => calc_req_s,
              finished_o => calc_finished_s,
              snoop_io => snoop_io,
              x_o => x_s,
              y_o => y_s,
              cx_i => cx_i,
              cy_i => cy_i,
              sinc_i => sinc_i,
              cosc_i => cosc_i,
              midx_i => midx_i,
              midy_i => midy_i,
              row_i => row_s,
              col_i => col_s,
              lr_i =>  lr_i
              );             


end Behavioral;
