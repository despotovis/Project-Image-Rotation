----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/12/2023 03:07:37 PM
-- Design Name: 
-- Module Name: rot_fsm - Behavioral
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

entity rot_fsm is
 generic (
        PIXEL_WIDTH : integer := 8;
        ADDRESS_WIDTH : integer := 16;
        FIXED_POINT_WIDTH : positive := 8;
        WIDTH : positive := 8
    );
    
    Port ( 
            --single bit ports
          clk_i : in STD_LOGIC;
          rst_i : in STD_LOGIC;
 
          bram_read_enable_o : out STD_LOGIC;
          bram_write_enable_o : out STD_LOGIC;
          
          ready_o : out std_logic;
          end_o : out std_logic;
          start_i : in std_logic;      
            -- all critical inputs for calculation 
            -- output matrix dims  
          new_heigth_i : in STD_LOGIC_VECTOR(WIDTH - 1 downto 0 );
          new_width_i : in STD_LOGIC_VECTOR(WIDTH - 1 downto 0 );
            --input matrix dims
          old_width_i : in STD_LOGIC_VECTOR(WIDTH - 1 downto 0 ); 
          old_heigth_i : in STD_LOGIC_VECTOR(WIDTH - 1 downto 0 );
           
          row_o : out STD_LOGIC_VECTOR(WIDTH - 1 downto 0 );
          col_o : out  STD_LOGIC_VECTOR(WIDTH - 1 downto 0 );
          
          x_i: in STD_LOGIC_VECTOR(WIDTH - 1 downto 0 );
          y_i : in  STD_LOGIC_VECTOR(WIDTH - 1 downto 0 );
             
          calc_req_o : out STD_LOGIC; 
          calc_ready_i : in STD_LOGIC;
          calc_finished_i : in STD_LOGIC;
            -- used for input memory comunication
           pixel_data_r_in : in STD_LOGIC_VECTOR(PIXEL_WIDTH - 1 downto 0);
           pixel_data_g_in : in STD_LOGIC_VECTOR(PIXEL_WIDTH - 1 downto 0);
           pixel_data_b_in : in STD_LOGIC_VECTOR(PIXEL_WIDTH - 1 downto 0);
           pixel_address_unrotated1_o : out STD_LOGIC_VECTOR (ADDRESS_WIDTH - 1 downto 0);
           --pixel_address_unrotated2_o : out STD_LOGIC_VECTOR (2*WIDTH - 1 downto 0);
           --pixel_address_unrotated3_o : out STD_LOGIC_VECTOR (2*WIDTH - 1 downto 0);
            -- used for output memory comunication
           pixel_data_r_o : out STD_LOGIC_VECTOR(PIXEL_WIDTH - 1 downto 0);
           pixel_data_g_o : out STD_LOGIC_VECTOR(PIXEL_WIDTH - 1 downto 0);
           pixel_data_b_o : out STD_LOGIC_VECTOR(PIXEL_WIDTH - 1 downto 0);
           pixel_address_rotated1_o : out STD_LOGIC_VECTOR (ADDRESS_WIDTH - 1 downto 0)
           --pixel_address_rotated2_o : out STD_LOGIC_VECTOR (2*WIDTH - 1 downto 0);
          -- pixel_address_rotated3_o : out STD_LOGIC_VECTOR (2*WIDTH - 1 downto 0)
           );
end rot_fsm;

architecture Behavioral of rot_fsm is
attribute use_dsp : string;
attribute use_dsp of Behavioral : architecture is "yes";
type state_type is (idle,baundary_check,calculation_request,calculate_data_address, increment_regs,store_output_data,load_input_data,calculation_finished);
signal state_reg,state_next : state_type;
signal new_heigth_reg,new_width_reg,new_heigth_next,new_width_next : STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
signal old_heigth_reg,old_width_reg,old_heigth_next,old_width_next : STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
signal x_reg ,y_reg ,x_next ,y_next : STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
signal row_reg : STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
signal col_reg : STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
signal row_next : STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
signal col_next : STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
signal calc_req_next,calc_req_reg : std_logic ;
signal pixel_address_unrotated1_next,pixel_address_rotated1_next,pixel_address_unrotated1_reg,pixel_address_rotated1_reg : STD_LOGIC_VECTOR (ADDRESS_WIDTH - 1 downto 0);
signal pixel_address_unrotated2_next,pixel_address_rotated2_next,pixel_address_unrotated2_reg,pixel_address_rotated2_reg : STD_LOGIC_VECTOR (ADDRESS_WIDTH - 1 downto 0); 
signal pixel_address_unrotated3_next,pixel_address_rotated3_next,pixel_address_unrotated3_reg,pixel_address_rotated3_reg : STD_LOGIC_VECTOR (ADDRESS_WIDTH - 1 downto 0);                       
signal pixel_data_r_next,pixel_data_r_reg : STD_LOGIC_VECTOR(PIXEL_WIDTH - 1 downto 0);
signal pixel_data_g_next,pixel_data_g_reg : STD_LOGIC_VECTOR(PIXEL_WIDTH - 1 downto 0);
signal pixel_data_b_next,pixel_data_b_reg : STD_LOGIC_VECTOR(PIXEL_WIDTH - 1 downto 0);
begin
-- State reg ctrl
process (clk_i,rst_i)
begin
    if (clk_i'event and clk_i = '1') then
        if (rst_i = '1') then 
            state_reg <= idle;
            row_reg <= (others => '0');
            col_reg <= (others => '0');
            new_heigth_reg <= (others => '0');
            new_width_reg <= (others => '0');
            new_heigth_reg <= (others => '0');
            old_width_reg <= (others => '0');
            x_reg <= (others => '0');
            y_reg <= (others => '0');
            pixel_address_unrotated1_reg <= (others => '0');
            pixel_address_rotated1_reg <= (others => '0');
            pixel_data_r_reg <= (others => '0');
            pixel_data_g_reg <= (others => '0');
            pixel_data_b_reg <= (others => '0');
            --pixel_address_unrotated2_reg <= (others => '0');
            --pixel_address_rotated2_reg <= (others => '0');
            --pixel_address_unrotated3_reg <= (others => '0');
            --pixel_address_rotated3_reg <= (others => '0');
        else
            state_reg <= state_next;
            calc_req_reg <=  calc_req_next;
            col_reg <= col_next;
            row_reg <= row_next;
            new_heigth_reg <= new_heigth_next;
            new_width_reg <= new_width_next;
            old_heigth_reg <= old_heigth_next;
            old_width_reg <= old_width_next;
            x_reg <= x_next;
            y_reg <= y_next;
            pixel_address_unrotated1_reg <= pixel_address_unrotated1_next;
            pixel_address_rotated1_reg <= pixel_address_rotated1_next;
            pixel_data_r_reg <= pixel_data_r_next; 
            pixel_data_g_reg <= pixel_data_g_next;
            pixel_data_b_reg <= pixel_data_b_next; 
            --pixel_address_unrotated2_reg <= pixel_address_unrotated2_next; 
            --pixel_address_rotated2_reg <= pixel_address_rotated2_next;  
            --pixel_address_unrotated3_reg <= pixel_address_unrotated3_next; 
            --pixel_address_rotated3_reg <= pixel_address_rotated3_next;        
            
         end if;
     end if;
end process;     

process(state_reg,start_i,new_heigth_i,new_width_i,old_heigth_i,old_width_i,
row_reg,col_reg,calc_finished_i,calc_ready_i,x_i,y_i,y_reg,x_reg,new_heigth_reg,old_heigth_reg,old_width_reg,new_width_reg,
pixel_address_unrotated1_reg,pixel_address_rotated1_reg,
pixel_address_unrotated2_reg,pixel_address_rotated2_reg,
pixel_address_unrotated3_reg,pixel_address_rotated3_reg,
pixel_data_r_reg,pixel_data_g_reg,pixel_data_b_reg,
pixel_data_r_in,pixel_data_g_in,pixel_data_b_in)
begin 
    --Default
        state_next <= idle;
        ready_o <= '0';
        end_o <= '0';
        calc_req_o <= '0';
        col_next <= col_reg;
        row_next <= row_reg;
        new_heigth_next <= new_heigth_reg;
        new_width_next <= new_width_reg;
        old_heigth_next <= old_heigth_reg;
        old_width_next <= old_width_reg;
        x_next <= x_reg;
        y_next <= y_reg;
        pixel_address_unrotated1_next <= pixel_address_unrotated1_reg;
        pixel_address_rotated1_next <= pixel_address_rotated1_reg;
        pixel_data_r_next <= pixel_data_r_reg;
        pixel_data_g_next <= pixel_data_g_reg;
        pixel_data_b_next <= pixel_data_b_reg;
        bram_read_enable_o <= '0';
        bram_write_enable_o <= '0';
        --pixel_address_unrotated2_next <= pixel_address_unrotated2_reg;   
        --pixel_address_rotated2_next <= pixel_address_rotated2_reg;  
        --pixel_address_unrotated3_next <= pixel_address_unrotated3_reg;        
        --pixel_address_rotated3_next <= pixel_address_rotated3_reg;       
        
    case state_reg is
    
    when idle =>

         new_heigth_next <= new_heigth_i;
         new_width_next <= new_width_i;
         old_heigth_next <= old_heigth_i;
         old_width_next <= old_width_i;
         
         end_o <= '1';
         ready_o <= '1';
         calc_req_o <= '0';
        if (start_i = '1') then
            ready_o <= '0';
            end_o <= '0'; 
            state_next <= calculation_request;
            
            
        end if;
   
    when calculation_request =>
        
        bram_read_enable_o <= '0';
        bram_write_enable_o <= '0';
        
        if (calc_ready_i = '1') then
            calc_req_o <= '1';
        
        end if;
        if (calc_finished_i = '1') then
            state_next<= calculation_finished;
            x_next <= x_i;
            y_next <= y_i;
         
        else
            state_next<= calculation_request;
        end if;
        
    when calculation_finished => 
        state_next <= baundary_check;
        calc_req_o <= '0';
        --x_next <= x_i;
        --y_next <= y_i; 
            
    when baundary_check =>
         
         if (signed(x_reg) >= 0 and x_reg < old_heigth_i and signed(y_reg) >= 0 and y_reg < old_width_i) then

         state_next <= calculate_data_address;
         else 
         state_next <= increment_regs;  
          
         end if;
    when calculate_data_address =>
         --FIRST PIXEL SET ADRESSES
         pixel_address_unrotated1_next <= std_logic_vector(unsigned(old_heigth_reg) * unsigned(x_reg) + unsigned(y_reg));
         pixel_address_rotated1_next <= std_logic_vector(unsigned(new_heigth_reg) * unsigned(row_reg) + unsigned(col_reg));
         
         --if(pixel_address_unrotated1_next = "0000111000001111") then
            --end_o <= '1';
         --end if;
          --SECOND PIXEL SET ADRESSES   
         --pixel_address_unrotated2_next <= std_logic_vector(unsigned(old_heigth_reg) * unsigned(x2_reg) + unsigned(y2_reg));  
         --pixel_address_rotated2_next <= std_logic_vector(unsigned(new_heigth_reg) * unsigned(row_reg) + unsigned(col_reg));
         --THIRD PIXEL SET ADRESSES  
         --pixel_address_unrotated3_next <= std_logic_vector(unsigned(old_heigth_reg) * unsigned(x3_reg) + unsigned(y3_reg));  
         --pixel_address_rotated3_next <= std_logic_vector(unsigned(new_heigth_reg) * unsigned(row_reg) + unsigned(col_reg));
         state_next <= increment_regs;
     when increment_regs =>    
         
         
         if (col_reg = new_width_i ) then
            
            row_next <= std_logic_vector(unsigned(row_reg) + 1);
            col_next <= (others => '0');
            state_next <=  load_input_data;
            if (row_reg = new_heigth_i) then
                end_o <= '1';
                state_next <= idle;
            end if;
          else
            col_next <= std_logic_vector(unsigned(col_reg) + 1);
            state_next <=  load_input_data;
        end if;
        
    when load_input_data =>
       
        bram_read_enable_o <= '1';
        pixel_data_r_next <= pixel_data_r_in;
        pixel_data_g_next <= pixel_data_g_in;
        pixel_data_b_next <= pixel_data_b_in;
        state_next <= store_output_data;
        
    when store_output_data =>
    
        state_next <= calculation_request;
	    bram_write_enable_o <= '1';
        --pixel_data_r_o <= pixel_data_r_reg;
        --pixel_data_g_o <= pixel_data_g_reg;
        --pixel_data_b_o <= pixel_data_b_reg;
 
    end case;    
end process;
pixel_data_r_o <= pixel_data_r_reg;
pixel_data_g_o <= pixel_data_g_reg;
pixel_data_b_o <= pixel_data_b_reg;

pixel_address_unrotated1_o <= pixel_address_unrotated1_reg;
pixel_address_rotated1_o <= pixel_address_rotated1_reg;
row_o <= row_reg;
col_o <= col_reg;
--end_o <= '1';
end Behavioral;
