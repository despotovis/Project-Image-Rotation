----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.05.2023 04:12:39
-- Design Name: 
-- Module Name: memory_sub - Behavioral
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
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
--use work.utils_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity memory_sub is  
    generic (
        WIDTH : integer := 8;
        PIXEL_WIDTH : integer := 8;
        ADDRESS_WIDTH : integer := 16;
        SIZE : integer := 21168
    );

    Port (
    clk : in std_logic;
    reset : in std_logic;
    
    --axi io
    reg_data_i : in std_logic_vector(2*WIDTH - 1 downto 0);
    start_wr_i : in std_logic; 
    
    start_axi_o : out std_logic;
    end_axi_o: out std_logic;
    ready_axi_o : out std_logic;
    
    sinc_wr_i : in std_logic;
    cosc_wr_i : in std_logic;
    new_height_wr_i : in std_logic;
    new_width_wr_i : in std_logic;
    old_height_wr_i : in std_logic;
    old_width_wr_i : in std_logic;
    midx_wr_i : in std_logic;
    midy_wr_i : in std_logic;
    cx_wr_i : in std_logic;
    cy_wr_i : in std_logic;
    lr_wr_i : in std_logic;
    
    sinc_axi_o : out std_logic_vector (2*WIDTH - 1 downto 0);
    cosc_axi_o : out std_logic_vector (2*WIDTH - 1 downto 0);
    cx_axi_o : out std_logic_vector (WIDTH - 1 downto 0);
    cy_axi_o : out std_logic_vector (WIDTH - 1 downto 0);
    midx_axi_o : out std_logic_vector (WIDTH - 1 downto 0);
    midy_axi_o : out std_logic_vector (WIDTH - 1 downto 0);
    new_heigth_axi_o : out std_logic_vector (WIDTH - 1 downto 0);
    new_width_axi_o : out std_logic_vector (WIDTH - 1 downto 0);
    old_heigth_axi_o : out std_logic_vector (WIDTH - 1 downto 0);
    old_width_axi_o : out std_logic_vector (WIDTH - 1 downto 0); 
    lr_axi_o : out std_logic;
    
    --clk_bram : in std_logic;
    --rst_bram: in std_logic;
    mem_addr_i : in std_logic_vector(ADDRESS_WIDTH - 1 downto 0);
    mem_data_i : in std_logic_vector(31 downto 0);
    mem_data_o : out std_logic_vector(WIDTH - 1 downto 0);
    mem_wr_i : in std_logic;
    
    --IP INTERFACE
    start_out : out std_logic;
    end_in : in std_logic;
    ready_in : in std_logic;
    
    sinc_o : out std_logic_vector (2*WIDTH - 1 downto 0);
    cosc_o : out std_logic_vector (2*WIDTH - 1 downto 0);
    cx_o : out std_logic_vector (WIDTH - 1 downto 0);
    cy_o : out std_logic_vector (WIDTH - 1 downto 0);
    midx_o : out std_logic_vector (WIDTH - 1 downto 0);
    midy_o : out std_logic_vector (WIDTH - 1 downto 0);
    new_heigth_o : out std_logic_vector (WIDTH - 1 downto 0);
    new_width_o : out std_logic_vector (WIDTH - 1 downto 0);
    old_heigth_o : out std_logic_vector (WIDTH - 1 downto 0);
    old_width_o : out std_logic_vector (WIDTH - 1 downto 0);
    lr_o : out std_logic;

    pixel_data_r_i : in STD_LOGIC_VECTOR(PIXEL_WIDTH - 1 downto 0);
    pixel_data_g_i : in STD_LOGIC_VECTOR(PIXEL_WIDTH - 1 downto 0);
    pixel_data_b_i : in STD_LOGIC_VECTOR(PIXEL_WIDTH - 1 downto 0);  
           
    pixel_data_r_o : out STD_LOGIC_VECTOR(PIXEL_WIDTH - 1 downto 0);
    pixel_data_g_o : out STD_LOGIC_VECTOR(PIXEL_WIDTH - 1 downto 0);
    pixel_data_b_o : out STD_LOGIC_VECTOR(PIXEL_WIDTH - 1 downto 0);
    
    pixel_address_rotated1_in : in STD_LOGIC_VECTOR (ADDRESS_WIDTH - 1 downto 0);
    pixel_address_unrotated1_in : in STD_LOGIC_VECTOR (ADDRESS_WIDTH - 1 downto 0);
    
    bram_read_enable_in : in STD_LOGIC;
    bram_write_enable_in : in STD_LOGIC
       );
end memory_sub;

architecture Behavioral of memory_sub is
    signal start_s, ready_s, end_s : std_logic;
    signal sinc_s, cosc_s : std_logic_vector(2*WIDTH - 1 downto 0);
    signal cx_s, cy_s, midx_s, midy_s : std_logic_vector(WIDTH - 1 downto 0);
    signal new_height_s, new_width_s, old_height_s, old_width_s : std_logic_vector(WIDTH - 1 downto 0);
    signal lr_s : std_logic;
    signal en_pixel_rotated_r_s, en_pixel_rotated_g_s, en_pixel_rotated_b_s : std_logic;
    signal en_pixel_unrotated_r_s, en_pixel_unrotated_g_s, en_pixel_unrotated_b_s : std_logic;
    
    signal rotated_r_axi_data_s : std_logic_vector(PIXEL_WIDTH - 1 downto 0);
    signal rotated_g_axi_data_s : std_logic_vector(PIXEL_WIDTH - 1 downto 0);
    signal rotated_b_axi_data_s : std_logic_vector(PIXEL_WIDTH - 1 downto 0);
    
    signal unrotated_r_axi_data_s : std_logic_vector(PIXEL_WIDTH - 1 downto 0);
    signal unrotated_g_axi_data_s : std_logic_vector(PIXEL_WIDTH - 1 downto 0);
    signal unrotated_b_axi_data_s : std_logic_vector(PIXEL_WIDTH - 1 downto 0);
begin

    --IF for IP
    
    start_out <= start_s;
    
    sinc_o <= sinc_s;
    cosc_o <= cosc_s;
    cx_o <= cx_s;
    cy_o <= cy_s;
    midx_o <= midx_s;
    midy_o <= midy_s;
    new_heigth_o <= new_height_s;
    new_width_o <= new_width_s;
    old_heigth_o <= old_height_s;
    old_width_o <= old_width_s;
    lr_o <= lr_s; 
    
    --IF for AXI
    
    start_axi_o <= start_s;
    end_axi_o <= end_s;
    ready_axi_o <= ready_s;
    
    sinc_axi_o <= sinc_s;
    cosc_axi_o <= cosc_s;
    cx_axi_o <= cx_s;
    cy_axi_o <= cy_s;
    midx_axi_o <= midx_s;
    midy_axi_o <= midy_s;
    new_heigth_axi_o <= new_height_s;
    new_width_axi_o <= new_width_s;
    old_heigth_axi_o <= old_height_s;
    old_width_axi_o <= old_width_s;
    lr_axi_o <= lr_s; 
    
    -- READY register
    process(clk)
    begin
        if clk'event and clk = '1' then
            if reset = '1' then
                ready_s <= '0';
            else
                ready_s <= ready_in;
            end if;
        end if;
    end process;

    -- END register
    process(clk)
    begin
        if clk'event and clk = '1' then
            if reset = '1' then
                end_s <= '0';
            else
                end_s <= end_in;
            end if;
        end if;
    end process;
    
    -- START register
    process(clk)
    begin
        if clk'event and clk = '1' then
            if reset = '1' then
                start_s <= '0';
            elsif start_wr_i = '1' then 
                start_s <= reg_data_i(0);
            end if;
        end if;
    end process;
    
    -- SINC register
    process(clk)
    begin
        if clk'event and clk = '1' then
            if reset = '1' then
                sinc_s <= (others => '0');
            elsif sinc_wr_i = '1' then 
                sinc_s <= reg_data_i(15 downto 0);
            end if;
        end if;
    end process;
    
    -- COSC register
    process(clk)
    begin
        if clk'event and clk = '1' then
            if reset = '1' then
                cosc_s <= (others => '0');
            elsif cosc_wr_i = '1' then 
                cosc_s <= reg_data_i(15 downto 0);
            end if;
        end if;
    end process;
    
    -- CX register
    process(clk)
    begin
        if clk'event and clk = '1' then
            if reset = '1' then
                cx_s <= (others => '0');
                elsif cx_wr_i = '1' then 
                cx_s <= reg_data_i(7 downto 0);
            end if;
        end if;
    end process;
    
    -- CY register
    process(clk)
    begin
        if clk'event and clk = '1' then
            if reset = '1' then
                cy_s <= (others => '0');
            elsif cy_wr_i = '1' then 
                cy_s <= reg_data_i(7 downto 0);
            end if;
        end if;
    end process;
    
    -- MIDX register
    process(clk)
    begin
        if clk'event and clk = '1' then
            if reset = '1' then
                midx_s <= (others => '0');
            elsif midx_wr_i = '1' then 
                midx_s <= reg_data_i(7 downto 0);
            end if;
        end if;
    end process;
    
    -- MIDY register
    process(clk)
    begin
        if clk'event and clk = '1' then
            if reset = '1' then
                midy_s <= (others => '0');
            elsif midy_wr_i = '1' then 
                midy_s <= reg_data_i(7 downto 0);
            end if;
        end if;
    end process;

    -- NEW_HEIGHT register
    process(clk)
    begin
        if clk'event and clk = '1' then
            if reset = '1' then
                new_height_s <= (others => '0');
            elsif new_height_wr_i = '1' then 
                new_height_s <= reg_data_i(7 downto 0);
            end if;
        end if;
    end process;
    
    -- NEW_WIDTH register
    process(clk)
    begin
        if clk'event and clk = '1' then
            if reset = '1' then
                new_width_s <= (others => '0');
            elsif new_width_wr_i = '1' then 
                new_width_s <= reg_data_i(7 downto 0);
            end if;
        end if;
    end process;
    
    -- OLD_HEIGHT register
    process(clk)
    begin
        if clk'event and clk = '1' then
            if reset = '1' then
                old_height_s <= (others => '0');
            elsif old_height_wr_i = '1' then 
                old_height_s <= reg_data_i(7 downto 0);
            end if;
        end if;
    end process;
    
    -- OLD_WIDTH register
    process(clk)
    begin
        if clk'event and clk = '1' then
            if reset = '1' then
                old_width_s <= (others => '0');
            elsif old_width_wr_i = '1' then 
                old_width_s <= reg_data_i(7 downto 0);
            end if;
        end if;
    end process;
    
    --LR register
    process(clk)
    begin
        if clk'event and clk = '1' then
            if reset = '1' then
                lr_s <= '0';
            elsif lr_wr_i = '1' then 
                lr_s <= reg_data_i(0);
            end if;
        end if;
    end process;
    
    ---------------------- MEMORIES ----------------------
    
    -- Address decoder
    addr_dec: process (mem_addr_i)
    begin
    -- Default assignments
    en_pixel_unrotated_r_s <= '0';
    en_pixel_unrotated_g_s <= '0';
    en_pixel_unrotated_b_s <= '0';
    en_pixel_rotated_r_s <= '0';
    en_pixel_rotated_g_s <= '0';
    en_pixel_rotated_b_s <= '0';
    
    case mem_addr_i(15 downto 13) is
        when "000" =>
            en_pixel_unrotated_r_s <= '1';
        when "001" =>
            en_pixel_unrotated_b_s <= '1';
        when "010" =>
            en_pixel_unrotated_g_s <= '1';
        when "011" =>
            en_pixel_rotated_r_s <= '1';
        when "100" =>
            en_pixel_rotated_g_s <= '1';
        when others =>
            en_pixel_rotated_b_s <= '1';
    end case;
 end process;

    --Out Signal Mux 
    out_dec: process (en_pixel_unrotated_r_s, 
                      en_pixel_unrotated_g_s, 
                      en_pixel_unrotated_b_s, 
                      en_pixel_rotated_r_s, 
                      en_pixel_rotated_g_s, 
                      en_pixel_rotated_b_s,
                      unrotated_r_axi_data_s,
                      unrotated_g_axi_data_s,
                      unrotated_b_axi_data_s,
                      rotated_r_axi_data_s,
                      rotated_g_axi_data_s,
                      rotated_b_axi_data_s
                     )
    begin
    -- Default assignments
    mem_data_o <= (others => '0');
    
    if en_pixel_unrotated_r_s = '1' then
        mem_data_o <= unrotated_r_axi_data_s;
    elsif en_pixel_unrotated_b_s = '1' then
        mem_data_o <= unrotated_b_axi_data_s;
    elsif en_pixel_unrotated_g_s = '1' then
        mem_data_o <= unrotated_g_axi_data_s;
    elsif en_pixel_rotated_r_s = '1' then
        mem_data_o <= rotated_r_axi_data_s;
    elsif en_pixel_rotated_b_s = '1' then
        mem_data_o <= rotated_b_axi_data_s;
    elsif en_pixel_rotated_g_s = '1' then
        mem_data_o <= rotated_g_axi_data_s;
    end if;   
    end process;
 
    ---------MEMORY TO READ UNROTATED PIXEL---------
    
    --UNROTATED_R_MEMORY
    unrotated_r_memory: entity work.bram(beh)
    generic map (
        WIDTH => WIDTH,
        ADDRESS_WIDTH => ADDRESS_WIDTH,
        SIZE => SIZE
    )
    port map (
        --A block is for AXI INTERFACE
        ckla => clk,
        ena => en_pixel_unrotated_r_s,
        wea => mem_wr_i,
        addra => mem_addr_i(13-1 downto 0),
        dia => mem_data_i(WIDTH-1 downto 0),
        doa => unrotated_r_axi_data_s,
        
        --B block is for IP INTERFACE
        clkb => clk,
        enb => bram_read_enable_in,
        web => '0',
        addrb => pixel_address_unrotated1_in(13-1 downto 0),
        dib => (others => '0'),
        dob => pixel_data_r_o
    );
    
    --UNROTATED_G_MEMORY
    unrotated_g_memory: entity work.bram(beh)
    generic map (
        WIDTH => WIDTH,
        ADDRESS_WIDTH => ADDRESS_WIDTH,
        SIZE => SIZE
    )
    port map (
        --A block is for AXI INTERFACE
        ckla => clk,
        ena => en_pixel_unrotated_g_s,
        wea => mem_wr_i,
        addra => mem_addr_i(13-1 downto 0),
        dia => mem_data_i(WIDTH-1 downto 0),
        doa => unrotated_g_axi_data_s,
        
        --B block is for IP INTERFACE
        clkb => clk,
        enb => bram_read_enable_in,
        web => '0',
        addrb => pixel_address_unrotated1_in(13-1 downto 0),
        dib => (others => '0'),
        dob => pixel_data_g_o
    );
    
    --UNROTATED_B_MEMORY
    unrotated_b_memory: entity work.bram(beh)
    generic map (
        WIDTH => WIDTH,
        ADDRESS_WIDTH => ADDRESS_WIDTH,
        SIZE => SIZE
    )
    port map (
        --A block is for AXI INTERFACE
        ckla => clk,
        ena => en_pixel_unrotated_b_s,
        wea => mem_wr_i,
        addra => mem_addr_i(13-1 downto 0),
        dia => mem_data_i(WIDTH-1 downto 0),
        doa => unrotated_b_axi_data_s,
        
        --B block is for IP INTERFACE
        clkb => clk,
        enb => bram_read_enable_in,
        web => '0',
        addrb => pixel_address_unrotated1_in(13-1 downto 0),
        dib => (others => '0'),
        dob => pixel_data_b_o
    );
    
    ---------MEMORY TO WRITE ROTATED PIXEL---------
    
    --ROTATED_R_MEMORY
    rotated_r_memory: entity work.bram(beh)
    generic map (
        WIDTH => WIDTH,
        ADDRESS_WIDTH => ADDRESS_WIDTH,
        SIZE => SIZE
    )
    port map (
        --A block is for AXI INTERFACE
        ckla => clk,
        ena => en_pixel_rotated_r_s,
        wea => mem_wr_i,
        addra => mem_addr_i(13-1 downto 0),
        dia => mem_data_i(WIDTH-1 downto 0),
        doa => rotated_r_axi_data_s,
        
        --B block is for IP INTERFACE
        clkb => clk,
        enb => bram_write_enable_in,
        web => '1',
        addrb => pixel_address_rotated1_in(13-1 downto 0),
        dib => pixel_data_r_i,
        dob => open
    );
    
    --ROTATED_G_MEMORY
    rotated_g_memory: entity work.bram(beh)
    generic map (
        WIDTH => WIDTH,
        ADDRESS_WIDTH => ADDRESS_WIDTH,
        SIZE => SIZE
    )
    port map (
        --A block is for AXI INTERFACE
        ckla => clk,
        ena => en_pixel_rotated_g_s,
        wea => mem_wr_i,
        addra => mem_addr_i(13-1 downto 0),
        dia => mem_data_i(WIDTH-1 downto 0),
        doa => rotated_g_axi_data_s,
        
        --B block is for IP INTERFACE
        clkb => clk,
        enb => bram_write_enable_in,
        web => '1',
        addrb => pixel_address_rotated1_in(13-1 downto 0),
        dib => pixel_data_g_i,
        dob => open
    );
    
    --ROTATED_B_MEMORY
    rotated_b_memory: entity work.bram(beh)
    generic map (
        WIDTH => WIDTH,
        ADDRESS_WIDTH => ADDRESS_WIDTH,
        SIZE => SIZE
    )
    port map (
        --A block is for AXI INTERFACE
        ckla => clk,
        ena => en_pixel_rotated_b_s,
        wea => mem_wr_i,
        addra => mem_addr_i(13-1 downto 0),
        dia => mem_data_i(WIDTH-1 downto 0),
        doa => rotated_b_axi_data_s,
        
        --B block is for IP INTERFACE
        clkb => clk,
        enb => bram_write_enable_in,
        web => '1',
        addrb => pixel_address_rotated1_in(13-1 downto 0),
        dib => pixel_data_b_i,
        dob => open
    );
    
end Behavioral;
