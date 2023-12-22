----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/29/2023 04:55:43 PM
-- Design Name: 
-- Module Name: mult2 - Behavioral
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

entity mult2 is
    
    generic(
            first_factor_width_g: natural := 32;
            second_factor_width_g : natural := 32
          
            );
    
    Port ( factor_1_i : in STD_LOGIC_VECTOR (first_factor_width_g - 1 downto 0);
           factor_2_i : in STD_LOGIC_VECTOR (second_factor_width_g - 1  downto 0);
           product_o : out STD_LOGIC_VECTOR ((first_factor_width_g - 1) downto 0));
end mult2;

architecture Behavioral of mult2 is
ATTRIBUTE use_dsp : STRING;
ATTRIBUTE use_dsp OF Behavioral : ARCHITECTURE IS "yes";

signal factor_1_s: STD_LOGIC_VECTOR(first_factor_width_g - 1 downto 0);
signal factor_2_s: STD_LOGIC_VECTOR(second_factor_width_g - 1 downto 0);
signal product_s: STD_LOGIC_VECTOR (first_factor_width_g + second_factor_width_g  - 1 downto 0);

begin
factor_1_s <= factor_1_i;
factor_2_s <= factor_2_i;

product_s<= std_logic_vector(signed(factor_1_s) * signed(factor_2_s));


product_o <= product_s(first_factor_width_g -1 downto 0); 

end Behavioral;
