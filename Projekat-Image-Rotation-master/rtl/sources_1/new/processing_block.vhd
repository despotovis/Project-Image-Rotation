----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2023 06:31:24 PM
-- Design Name: 
-- Module Name: processing_block - Behavioral
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

entity processing_block is
      Generic (            
           FIXED_POINT_WIDTH : positive := 8;
           WIDTH : positive := 16
    );
    Port ( snoop_io : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           clk_i : in std_logic;
           rst_i : in std_logic;
           ready_i : out STD_LOGIC_VECTOR (2 downto 0);
           start : in STD_LOGIC;
           x1_o : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           y1_o : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           x2_o : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           y2_o : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           x3_o : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           y3_o : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           
           cx_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           cy_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           sinc_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           cosc_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           midx_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           midy_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           row_1_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           col_1_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           row_2_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           col_2_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           row_3_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           col_3_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           lr_i  : in STD_LOGIC); 
end processing_block;

architecture Behavioral of processing_block is

begin
first_point:
 entity work.point_rotation_unit 
    generic map (FIXED_POINT_WIDTH => FIXED_POINT_WIDTH,
                 WIDTH => WIDTH)
    port map (clk_i =>clk_i,
              rst_i => rst_i,
              ready_o => ready_i(0),
              start => start,
              snoop_io => snoop_io,
              x_o => x1_o,
              y_o => y1_o,
              cx_i => cx_i,
              cy_i => cy_i,
              sinc_i => sinc_i,
              cosc_i => cosc_i,
              midx_i => midx_i,
              midy_i => midy_i,
              row_i => row_1_i,
              col_i => col_1_i,
              lr_i =>  lr_i
              );
second_point:
    entity work.point_rotation_unit 
    generic map (FIXED_POINT_WIDTH => FIXED_POINT_WIDTH,
                 WIDTH => WIDTH)
    port map (clk_i =>clk_i,
              rst_i => rst_i,
              ready_o => ready_i(1),
              start => start,
              snoop_io => snoop_io,
              x_o => x2_o,
              y_o => y2_o,
              cx_i => cx_i,
              cy_i => cy_i,
              sinc_i => sinc_i,
              cosc_i => cosc_i,
              midx_i => midx_i,
              midy_i => midy_i,
              row_i => row_2_i,
              col_i => col_2_i,
              lr_i =>  lr_i
              ); 
third_point:
entity work.point_rotation_unit 
    generic map (FIXED_POINT_WIDTH => FIXED_POINT_WIDTH,
                 WIDTH => WIDTH)
    port map (clk_i =>clk_i,
              rst_i => rst_i,
              ready_o => ready_i(2),
              start => start,
              snoop_io => snoop_io,
              x_o => x3_o,
              y_o => y3_o,
              cx_i => cx_i,
              cy_i => cy_i,
              sinc_i => sinc_i,
              cosc_i => cosc_i,
              midx_i => midx_i,
              midy_i => midy_i,
              row_i => row_3_i,
              col_i => col_3_i,
              lr_i =>  lr_i
              );




end Behavioral;
