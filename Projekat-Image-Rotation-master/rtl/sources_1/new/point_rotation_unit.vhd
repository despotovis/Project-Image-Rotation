----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/27/2023 06:22:52 PM
-- Design Name: 
-- Module Name: point_rotation_unit - Behavioral
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
use IEEE.MATH_REAL.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity point_rotation_unit is
 Generic (            
           FIXED_POINT_WIDTH : positive := 16;
           WIDTH : positive := 8
    );
    Port ( snoop_io : out STD_LOGIC_VECTOR (2*WIDTH - 1 downto 0);
           clk_i : in std_logic;
           rst_i : in std_logic;
           ready_o : out STD_LOGIC;
           start : in STD_LOGIC;
           finished_o : out std_logic;
           x_o : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           y_o : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           cx_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           cy_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           sinc_i : in STD_LOGIC_VECTOR (FIXED_POINT_WIDTH - 1 downto 0);
           cosc_i : in STD_LOGIC_VECTOR (FIXED_POINT_WIDTH - 1 downto 0);
           midx_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           midy_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           row_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           col_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           lr_i  : in STD_LOGIC);
end point_rotation_unit;

architecture Behavioral of point_rotation_unit is
    attribute use_dsp : string;
    attribute use_dsp of Behavioral : architecture is "yes";
 
signal tmpRMXsub_reg ,tmpCMYsub_reg : STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
signal tmpRMXsub_next ,tmpCMYsub_next,tmp3_next : STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
signal tmpRMXCmult_reg ,tmpCMYCmult_reg,tmpRMXSmult_reg ,tmpCMYSmult_reg : STD_LOGIC_VECTOR (FIXED_POINT_WIDTH - 1 downto 0);
signal tmpRMXCmult_next ,tmpCMYCmult_next,tmpRMXSmult_next ,tmpCMYSmult_next : STD_LOGIC_VECTOR (2*FIXED_POINT_WIDTH - 1 downto 0);
signal tmpXWOC_next ,tmpYWOC_next : STD_LOGIC_VECTOR (FIXED_POINT_WIDTH - 1 downto 0);
signal tmpXWOC_reg ,tmpYWOC_reg : STD_LOGIC_VECTOR (FIXED_POINT_WIDTH - 1 downto 0);
signal x_o_reg ,y_o_reg  : STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
signal x_o_next ,y_o_next  : STD_LOGIC_VECTOR (FIXED_POINT_WIDTH - 1 downto 0);
signal row_reg , col_reg : STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
signal row_next , col_next : STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
signal cx_reg , cy_reg : STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
signal cx_next , cy_next : STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
signal midx_reg , midy_reg : STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
signal midx_next , midy_next : STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
signal sinc_reg , cosc_reg : STD_LOGIC_VECTOR (FIXED_POINT_WIDTH - 1 downto 0);
signal sinc_next , cosc_next: STD_LOGIC_VECTOR (FIXED_POINT_WIDTH - 1 downto 0);
signal lr_reg , lr_next  : STD_LOGIC;
--state levels
type state_t is (idle, state1, state2, state3, state4, state5,finished);
signal state_reg,state_next : state_t;
begin
process (rst_i, clk_i) begin
     if (clk_i'event and clk_i = '1') then
        if ( rst_i = '1') then
        state_reg <= idle;
        tmpRMXsub_reg <= (others => '0');
        tmpCMYsub_reg <= (others => '0');
        -- multiplication registers 
        tmpRMXCmult_reg <= (others => '0');
        tmpCMYCmult_reg <= (others => '0');
        
        tmpRMXSmult_reg <= (others => '0');
        tmpCMYSmult_reg <= (others => '0');
        
       
        tmpXWOC_reg <= (others => '0') ;
        tmpYWOC_reg <= (others => '0') ;
        
        row_reg <= (others => '0');
        col_reg <= (others => '0');
        cx_reg <= (others => '0');
        cy_reg <= (others => '0');
        midx_reg <= (others => '0');
        midy_reg <= (others => '0');
        sinc_reg <= (others => '0');
        cosc_reg <= (others => '0');
        x_o_reg <= (others => '0');
        y_o_reg <= (others => '0');
        lr_reg  <= '0';
        else
        row_reg <= row_next;
        col_reg <= col_next;
        
        state_reg <= state_next;
        tmpRMXsub_reg <= tmpRMXsub_next;
        tmpCMYsub_reg <= tmpCMYsub_next;
        --multiplication registers 
        tmpRMXCmult_reg <= tmpRMXCmult_next(WIDTH + FIXED_POINT_WIDTH - 1 downto FIXED_POINT_WIDTH - WIDTH);
        tmpCMYCmult_reg <= tmpCMYCmult_next(WIDTH + FIXED_POINT_WIDTH - 1 downto FIXED_POINT_WIDTH - WIDTH);
        
        tmpRMXSmult_reg <= tmpRMXSmult_next (WIDTH + FIXED_POINT_WIDTH - 1 downto FIXED_POINT_WIDTH - WIDTH);
        tmpCMYSmult_reg <= tmpCMYSmult_next (WIDTH + FIXED_POINT_WIDTH - 1 downto FIXED_POINT_WIDTH - WIDTH);
        
        tmpXWOC_reg <= tmpXWOC_next ;
        tmpYWOC_reg <= tmpYWOC_next ;
        cx_reg <= cx_next;
        cy_reg <= cy_next;
        midx_reg <= midx_next;
        midy_reg <= midy_next;
        sinc_reg <= sinc_next;
        cosc_reg <= cosc_next;
        lr_reg  <= lr_next;
        x_o_reg <= x_o_next(FIXED_POINT_WIDTH -1 downto WIDTH );
        y_o_reg <= y_o_next(FIXED_POINT_WIDTH -1 downto WIDTH );
        end if;
    end if;
    
end process;

process (cx_i , cy_i , midx_i , midy_i , col_i , row_i , sinc_i ,cosc_i,
         row_i , lr_i,cx_reg , cy_reg , midx_reg , midy_reg , col_reg , row_reg , sinc_reg ,cosc_reg,
         row_reg , col_reg, x_o_reg, y_o_reg, state_reg, start ,lr_reg,
         tmpRMXsub_reg ,tmpCMYsub_reg,tmpRMXCmult_reg ,tmpCMYCmult_reg,tmpRMXSmult_reg ,tmpCMYSmult_reg,tmpXWOC_reg,tmpYWOC_reg) begin
            --Default
            tmpRMXsub_next <= (others => '0');
            tmpCMYsub_next <= (others => '0');
       
            tmpRMXCmult_next <= (others => '0');
            tmpCMYCmult_next <= (others => '0');
        
            tmpRMXSmult_next <=(others => '0');
            tmpCMYSmult_next<= (others => '0');
           
            tmpXWOC_next <= (others => '0') ;
            tmpYWOC_next <= (others => '0') ;
            
            row_next <= col_reg;
            col_next <= row_reg;
            cx_next <= cx_reg;
            cy_next <= cy_reg;
            midx_next <= midx_reg;
            midy_next <= midy_reg;
            sinc_next <= sinc_reg;
            cosc_next <= cosc_reg;
            lr_next <= lr_reg;
            x_o_next <= (others => '0');
            y_o_next <= (others => '0');
            state_next <= idle;
            ready_o <= '0';
            finished_o <= '0';
                    
            
                  
            case state_reg is
                when idle =>
                    ready_o <= '1';
                    row_next <= col_i;
                    col_next <= row_i;
                    cx_next <= cx_i;
                    cy_next <= cy_i;
                    midx_next <= midx_i;
                    midy_next <= midy_i;
                    sinc_next <= sinc_i;
                    cosc_next <= cosc_i;
                    lr_next <= lr_i;
                    finished_o <= '0';
                                        
                        if (start = '1') then
                            state_next <= state1;
                        end if;
                when state1 =>
                    
                    ready_o <= '0';
                    tmpRMXsub_next <= std_logic_vector(signed(row_reg) - signed(midx_reg));
                    tmpCMYsub_next <= std_logic_vector(signed(col_reg) - signed(midy_reg));
                    state_next <= state2;
                when state2 => 
                        --x
                    tmpRMXCmult_next <=  std_logic_vector(signed(tmpRMXsub_reg&"00000000")* signed(cosc_reg));
                    tmpCMYSmult_next<=  std_logic_vector(signed(tmpCMYsub_reg&"00000000")* signed(sinc_reg));
                        --y
                    tmpCMYCmult_next <=  std_logic_vector(signed(tmpCMYsub_reg&"00000000")* signed(cosc_reg)); 
                    tmpRMXSmult_next <=  std_logic_vector(signed(tmpRMXsub_reg&"00000000")* signed(sinc_reg));
                    
                    if (lr_reg = '1') then
                        state_next <= state3;
                    else
                        state_next <= state4;
                    end if;
                    
                       
                when state3 =>
                     --if (lr_reg = '1') then
                        tmpXWOC_next <= std_logic_vector(signed(tmpRMXCmult_reg) - signed(tmpCMYSmult_reg));
                        tmpYWOC_next <= std_logic_vector(signed(tmpCMYCmult_reg) + signed(tmpRMXSmult_reg));
                     --else
                        state_next <= state5;
                        
                when state4 =>
                        tmpXWOC_next <= std_logic_vector(signed(tmpRMXCmult_reg) + signed(tmpCMYSmult_reg));
                        tmpYWOC_next <= std_logic_vector(signed(tmpCMYCmult_reg) - signed(tmpRMXSmult_reg));
                     --end if;
                        state_next <= state5;
                        
                when state5 =>   
                        x_o_next <= std_logic_vector(signed(tmpXWOC_reg) + signed(cx_reg&"00000000"));
                        y_o_next <= std_logic_vector(signed(tmpYWOC_reg) + signed(cy_reg&"00000000"));
                        state_next <= finished;
                when finished =>
                        finished_o <= '1';
                        state_next <= idle;
                        
           end case;
end process;
x_o <= x_o_reg;
y_o <= y_o_reg;
snoop_io <= cosc_reg;
end Behavioral;
