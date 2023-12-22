----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2023 06:35:24 PM
-- Design Name: 
-- Module Name: pass_check - Behavioral
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
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
 
entity pass_check is
generic (width_xy_g : natural := 8;
         width_hw_g : natural := 8);
    Port ( x_i : in  std_logic_vector(width_xy_g - 1 downto 0);
           y_i : in  std_logic_vector(width_xy_g - 1 downto 0);
           x_o : out std_logic_vector(width_xy_g - 1 downto 0);
           y_o : out  std_logic_vector(width_xy_g - 1 downto 0);
           OldHeight_i : in std_logic_vector(width_hw_g - 1 downto 0);
           OldWidth_I : in std_logic_vector(width_hw_g - 1 downto 0);
           clk_i : in std_logic);
end pass_check;

architecture Behavioral of pass_check is
ATTRIBUTE use_dsp : STRING;
ATTRIBUTE use_dsp OF Behavioral : ARCHITECTURE IS "yes";
 signal    x_s :  std_logic_vector(width_xy_g - 1 downto 0);
 signal    y_s :   std_logic_vector(width_xy_g - 1 downto 0);
 signal    OldHeight_s :  std_logic_vector(width_hw_g - 1 downto 0);
 signal    OldWidth_s :   std_logic_vector(width_hw_g - 1 downto 0);
begin
 process (clk_i) is
    begin
        if(rising_edge(clk_i)) then
            x_s <= x_i;
            y_s <= y_s;
            OldHeight_s <= OldHeight_i;
            OldWidth_s  <=  OldWidth_i;
            if x_s >= "00000000" and y_s >= "00000000" and y_s < OldHeight_s and x_s < OldWidth_s  then
              x_o <= x_s;
              y_o <= y_s;
            
               
            end if;
        end if;
       
    end process;


end Behavioral;
