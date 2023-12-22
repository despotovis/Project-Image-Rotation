----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/30/2023 12:59:08 PM
-- Design Name: 
-- Module Name: sub2 - Behavioral
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

entity sub2 is
    generic(
            first_sub_width_g : natural := 32;
            second_sub_width_g : natural:= 32;
            sign_g : string := "signed"
            );
    Port ( 
           sub_1_i : in STD_LOGIC_VECTOR (first_sub_width_g - 1 downto 0);
           sub_2_i : in STD_LOGIC_VECTOR (second_sub_width_g - 1 downto 0);
           difference_o : out STD_LOGIC_VECTOR (second_sub_width_g - 1 downto 0)
           );
end sub2;

architecture Behavioral of sub2 is
ATTRIBUTE use_dsp : STRING;
ATTRIBUTE use_dsp OF Behavioral : ARCHITECTURE IS "yes";

signal sub_1_s: STD_LOGIC_VECTOR(first_sub_width_g - 1 downto 0);
signal sub_2_s: STD_LOGIC_VECTOR(second_sub_width_g - 1 downto 0);
signal difference_s: STD_LOGIC_VECTOR (second_sub_width_g - 1 downto 0);
begin
    sub_1_s <= sub_1_i;
    sub_2_s <= sub_2_i;
     
    difference_s <= std_logic_vector(signed(sub_1_s) - signed(sub_2_s)) when (sign_g = "signed") else 
                    std_logic_vector(unsigned(sub_1_s) - unsigned(sub_2_s)) when (sign_g = "unsigned");   
    
    difference_o <= difference_s;

end Behavioral;
