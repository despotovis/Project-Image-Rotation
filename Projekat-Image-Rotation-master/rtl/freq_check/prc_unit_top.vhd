----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/30/2023 04:08:59 PM
-- Design Name: 
-- Module Name: prc_unit_top - Behavioral
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

entity prc_unit_top is
    generic (width_g : natural := 8);
    Port ( sinc_i : in STD_LOGIC_VECTOR (width_g - 1  downto 0);
           cosc_i : in STD_LOGIC_VECTOR (width_g - 1  downto 0);
           col_i : in STD_LOGIC_VECTOR (width_g - 1 downto 0);
           row_i : in STD_LOGIC_VECTOR (width_g - 1 downto 0);
           midx_i : in STD_LOGIC_VECTOR (width_g - 1 downto 0);
           midy_i : in STD_LOGIC_VECTOR (width_g - 1 downto 0);
           cx_i : in STD_LOGIC_VECTOR (width_g - 1 downto 0);
           cy_i : in STD_LOGIC_VECTOR (width_g - 1 downto 0);
           clk_i: in STD_LOGIC;
           x_o : out STD_LOGIC_VECTOR (width_g - 1 downto 0);
           y_o : out STD_LOGIC_VECTOR (width_g - 1 downto 0));
end prc_unit_top;

architecture Behavioral of prc_unit_top is
signal col_reg_out_s :  STD_LOGIC_VECTOR (width_g - 1 downto 0);
signal row_reg_out_s :  STD_LOGIC_VECTOR (width_g - 1 downto 0);
signal midx_reg_out_s : STD_LOGIC_VECTOR (width_g - 1 downto 0);
signal midy_reg_out_s : STD_LOGIC_VECTOR (width_g - 1 downto 0);
signal cx_reg_out_s :   STD_LOGIC_VECTOR (width_g - 1 downto 0);
signal cy_reg_out_s :   STD_LOGIC_VECTOR (width_g - 1 downto 0);
signal sinc_reg_out_s : STD_LOGIC_VECTOR (width_g - 1 downto 0);
signal cosc_reg_out_s : STD_LOGIC_VECTOR (width_g - 1 downto 0);
signal rowmidx_sub_out_s:STD_LOGIC_VECTOR (width_g - 1 downto 0);
signal colmidy_sub_out_s:STD_LOGIC_VECTOR (width_g - 1 downto 0);
signal colmidysinc_mult_out_s: std_logic_vector (width_g - 1 downto 0);
signal rowmidxsinc_mult_out_s: std_logic_vector (width_g - 1 downto 0);
signal colmidycosc_mult_out_s: std_logic_vector (width_g - 1 downto 0);
signal rowmidxcosc_mult_out_s: std_logic_vector (width_g - 1 downto 0);
signal rmc_cms_sub_out_s: std_logic_vector (width_g - 1 downto 0);
signal cmc_rms_add_out_s: std_logic_vector (width_g - 1 downto 0);
signal x_s: std_logic_vector (width_g - 1 downto 0);
signal y_s: std_logic_vector (width_g - 1 downto 0);
begin
col_reg : entity work.universal_reg(Behavioral)
            generic map(register_width_g => width_g)
            PORT MAP(clk_i => clk_i,
                     in_i => col_i,
                     out_o => col_reg_out_s);
                     
row_reg : entity work.universal_reg(Behavioral)
            generic map(register_width_g => width_g)
            PORT MAP(clk_i => clk_i,
                     in_i => row_i,
                     out_o => row_reg_out_s);
                     
midx_reg : entity work.universal_reg(Behavioral)
            generic map(register_width_g => width_g)
            PORT MAP(clk_i => clk_i,
                     in_i => midx_i,
                     out_o => midx_reg_out_s); 

midy_reg : entity work.universal_reg(Behavioral)
            generic map(register_width_g => width_g)
            PORT MAP(clk_i => clk_i,
                     in_i => midy_i,
                     out_o => midy_reg_out_s);

cx_reg : entity work.universal_reg(Behavioral)
            generic map(register_width_g => width_g)
            PORT MAP(clk_i => clk_i,
                     in_i => cx_i,
                     out_o => cx_reg_out_s);
cy_reg : entity work.universal_reg(Behavioral)
            generic map(register_width_g => width_g)
            PORT MAP(clk_i => clk_i,
                     in_i => cy_i,
                     out_o => cy_reg_out_s);

sinc_reg : entity work.universal_reg(Behavioral)
          generic map(register_width_g => width_g)
          PORT MAP(clk_i => clk_i,
                   in_i => sinc_i,
                   out_o => sinc_reg_out_s);  

cosc_reg : entity work.universal_reg(Behavioral)
           generic map(register_width_g => width_g)
           PORT MAP(clk_i => clk_i,
                    in_i => cosc_i,
                    out_o => cosc_reg_out_s);  
                    

rowmidx_sub:entity work.sub2(Behavioral)
           generic map ( first_sub_width_g => width_g ,
                         second_sub_width_g => width_g )
                         
           port map (
                     sub_1_i => row_reg_out_s,
                     sub_2_i =>midx_reg_out_s,
                     difference_o => rowmidx_sub_out_s
                     );  

colmidy_sub:entity work.sub2(Behavioral)
           generic map ( first_sub_width_g => width_g ,
                         second_sub_width_g => width_g )
                         
           port map (
                     sub_1_i => col_reg_out_s,
                     sub_2_i => midy_reg_out_s,
                     difference_o => colmidy_sub_out_s
                     );

colmidysinc_mult:entity work.mult2(Behavioral)
           generic map ( first_factor_width_g => width_g ,
                         second_factor_width_g => width_g )
                         
           port map (
                     factor_1_i => colmidy_sub_out_s,
                     factor_2_i => sinc_reg_out_s,
                     product_o => colmidysinc_mult_out_s
                     );

colmidycosc_mult:entity work.mult2(Behavioral)
           generic map (  first_factor_width_g => width_g ,
                         second_factor_width_g => width_g )
                         
           port map (
                     factor_1_i => colmidy_sub_out_s,
                     factor_2_i => cosc_reg_out_s,
                     product_o => colmidycosc_mult_out_s
                     );

rowmidxsinc_mult:entity work.mult2(Behavioral)
           generic map (  first_factor_width_g => width_g ,
                         second_factor_width_g => width_g )
                         
           port map (
                     factor_1_i => rowmidx_sub_out_s,
                     factor_2_i => sinc_reg_out_s,
                     product_o => rowmidxsinc_mult_out_s
                     );

rowmidxcosc_mult:entity work.mult2(Behavioral)
           generic map (  first_factor_width_g => width_g ,
                         second_factor_width_g => width_g )
                         
           port map (
                     factor_1_i => rowmidx_sub_out_s,
                     factor_2_i => cosc_reg_out_s,
                     product_o => rowmidxcosc_mult_out_s
                     );
rmc_cms_sub:entity work.sub2(Behavioral)
           generic map ( first_sub_width_g => width_g ,
                         second_sub_width_g =>width_g )
                         
           port map (
                     sub_1_i => rowmidxcosc_mult_out_s,
                     sub_2_i => colmidysinc_mult_out_s,
                     difference_o => rmc_cms_sub_out_s
                     );
cmc_rms_add:entity work.add2(Behavioral)
           generic map ( first_addend_width_g =>  width_g ,
                         second_addend_width_g => width_g )
                         
           port map (
                     first_addend_i => colmidycosc_mult_out_s,
                     second_addend_i => rowmidxsinc_mult_out_s,
                     sum_o => cmc_rms_add_out_s
                     );
cx_add:entity work.add2(Behavioral)
           generic map ( first_addend_width_g => width_g ,
                         second_addend_width_g => width_g )
                         
           port map (
                     first_addend_i => cx_reg_out_s,
                     second_addend_i => rmc_cms_sub_out_s,
                     sum_o => x_s
                     );
cy_add:entity work.add2(Behavioral)
           generic map ( first_addend_width_g =>  width_g ,
                         second_addend_width_g => width_g )
                         
           port map (
                     first_addend_i => cy_reg_out_s,
                     second_addend_i => cmc_rms_add_out_s,
                     sum_o => y_s
                     );
pass_check:entity work.pass_check(Behavioral)
           generic map ( width_xy_g => width_g ,
                         width_hw_g => width_g )
                         
           port map (
                     x_i => x_s,
                     y_i => y_s,
                     x_o => x_o,
                     y_o => y_o,
                     OldHeight_i =>cy_reg_out_s,
                     OldWidth_I  => cx_reg_out_s,
                     clk_i => clk_i
                     ); 
end Behavioral;
