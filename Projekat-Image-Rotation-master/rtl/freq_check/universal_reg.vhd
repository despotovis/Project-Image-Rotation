----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/30/2023 11:33:20 AM
-- Design Name: 
-- Module Name: universal_reg - Behavioral
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

entity universal_reg is
    generic(register_width_g : natural := 32);
    Port ( in_i : in std_logic_vector(register_width_g - 1 downto 0);
           clk_i : in std_logic;
           out_o : out std_logic_vector(register_width_g - 1 downto 0));
end universal_reg;

architecture Behavioral of universal_reg is
ATTRIBUTE use_dsp : STRING;
ATTRIBUTE use_dsp OF Behavioral : ARCHITECTURE IS "yes";
begin
    process(clk_i) is
        begin
            if(rising_edge(clk_i)) then
                
                out_o <= in_i;
                
            end if;
        
        end process;

end Behavioral;
