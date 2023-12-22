----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/29/2023 10:26:40 AM
-- Design Name: 
-- Module Name: adder - Behavioral
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

entity add2 is
    
    generic(
            first_addend_width_g: natural := 32;
            second_addend_width_g:natural := 32;
            sign_g: string := "signed"
            );
            
    Port ( first_addend_i : in STD_LOGIC_VECTOR (first_addend_width_g - 1 downto 0);
           second_addend_i : in STD_LOGIC_VECTOR (second_addend_width_g - 1 downto 0);
           sum_o : out STD_LOGIC_VECTOR (second_addend_width_g - 1 downto 0));
end add2;

architecture Behavioral of add2 is
ATTRIBUTE use_dsp : STRING;
ATTRIBUTE use_dsp OF Behavioral : ARCHITECTURE IS "yes";

signal add_1_s: STD_LOGIC_VECTOR(first_addend_width_g - 1 downto 0);
signal add_2_s: STD_LOGIC_VECTOR(second_addend_width_g - 1 downto 0);
signal sum_s: STD_LOGIC_VECTOR (second_addend_width_g - 1 downto 0);
    
begin
    add_1_s <= first_addend_i;
    add_2_s <= second_addend_i;
     
    sum_s <= std_logic_vector(signed(add_1_s) + signed(add_2_s)) when (sign_g = "signed") else 
             std_logic_vector(unsigned(add_1_s) + unsigned(add_2_s)) when (sign_g = "unsigned");   
    
    sum_o <= sum_s;
end Behavioral;