----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2025 09:19:30 AM
-- Design Name: 
-- Module Name: TopGHLMDmux_shift - Behavioral
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

entity TopGHLMDmux_shift is
    Port ( 
           clk          : in  STD_LOGIC;
           rst          : in  STD_LOGIC;
           sw_start 	: in  STD_LOGIC;
           o_gendata    : out STD_LOGIC;
           o_data1      : out STD_LOGIC;
		   o_data2      : out STD_LOGIC
		 );
end TopGHLMDmux_shift;

architecture Behavioral of TopGHLMDmux_shift is

    Component datagen is
	generic (
			PayloadBytes	: integer := 46;
			MACDest			: STD_LOGIC_VECTOR 	( 47 downto 0 ) 	:= x"00defc005869" ;
			MACSource		: STD_LOGIC_VECTOR 	( 47 downto 0 ) 	:= x"456878945489" );
    Port ( 	clk         : in  STD_LOGIC;
			rst         : in  STD_LOGIC;
			sw_start    : in  STD_LOGIC;
			o_data      : out STD_LOGIC);
    end Component datagen;
	
	Component Read_Header is
	Port (	clk 		: 	in  STD_LOGIC;
			rst 		: 	in  STD_LOGIC;
			i_data 		: 	in  STD_LOGIC;
			i_EndEthFr	:	in	STD_LOGIC;
			o_Endlength	:	out STD_LOGIC;
			o_length	:	out STD_LOGIC_VECTOR (15 downto 0);
			o_MACDest	:	out STD_LOGIC_VECTOR (47 downto 0));
    end Component Read_Header;
    
    Component Check_Length is
    Port ( clk 				: in  STD_LOGIC;
		   rst				: in  STD_LOGIC;
		   i_EndLength	 	: in  STD_LOGIC;
           i_length      	: in  STD_LOGIC_VECTOR (15 downto 0);
           EnDMUX        	: out STD_LOGIC);
    end Component Check_Length;
    
    Component MacTable is
	generic (
        MAC1        : STD_LOGIC_VECTOR(47 downto 0) := X"11AA22BB33DD"; -- MAC 1
        MAC2        : STD_LOGIC_VECTOR(47 downto 0) := X"AABBCCDDEEFF"; -- MAC 2
        MAC3        : STD_LOGIC_VECTOR(47 downto 0) := X"112233445566"  -- MAC 3 
        );
    port (
        clk         : in  STD_LOGIC;
        rst         : in  STD_LOGIC;
        mac_in      : in  STD_LOGIC_VECTOR  (47 downto 0);
        port_out    : out STD_LOGIC_VECTOR  (1 downto 0));
    end Component MacTable;
    
    Component DeMUX is
    Port ( clk      : in  STD_LOGIC;
           i_data   : in  STD_LOGIC;
           SendEn   : in  STD_LOGIC;
           SlcPort  : in  STD_LOGIC_VECTOR (1 downto 0);
           o_data1  : out STD_LOGIC;
           o_data2  : out STD_LOGIC);
    end Component DeMUX;
    
    Component DelayEthFrame is
    Port ( clk      : in STD_LOGIC;
           rst      : in STD_LOGIC;
           i_data   : in STD_LOGIC;
           o_sdata  : out STD_LOGIC);
    end Component DelayEthFrame;
    
----------------------------------------------------------------------------------
-- signal label
----------------------------------------------------------------------------------
    
    signal w_data       : std_logic;
    signal w_sdata      : std_logic;
    
    signal w_send_en    : std_logic;
    
    signal w_sendleng   : std_logic;
    signal w_lengbytes  : std_logic_vector (15 downto 0);
    signal w_MAC        : std_logic_vector (47 downto 0);
    signal w_slcport    : std_logic_vector (1 downto 0);
    
begin
    
    o_gendata   <= w_data;
    
    u1 : datagen
    	port map
    	(
    		clk			   =>	clk			,
    		rst			   =>	rst			,
    		sw_start	   =>	sw_start	,
    		o_data		   =>	w_data      
    	);
	
    u2 : Read_Header
    	port map
    	(
    		clk			   =>	clk			,
    		rst			   =>	rst			,
    		i_data 		   =>	w_data		,
    		i_EndEthFr	   =>	w_send_en  	,
    		o_Endlength    =>   w_sendleng  ,
    		o_length	   =>	w_lengbytes	,
			o_MACDest	   =>	w_MAC	    
    	);
    
    u3 : Check_Length
        port map
    	(
    		clk			    =>	clk			,
    		rst			    =>	rst			,
    		i_EndLength 	=>	w_sendleng	,
    		i_length      	=>	w_lengbytes	,
    		EnDMUX        	=>	w_send_en	
    	);
    
    u4 : MacTable
        port map
    	(
    		clk             =>	clk			,
            rst             =>	rst			,
            mac_in          =>  w_MAC       ,
            port_out        =>  w_slcport   
    	);
    
    u5 : DeMUX
        port map
    	(
    		clk			   =>	clk			,
    		i_data          =>  w_sdata     ,
            SendEn          =>  w_send_en   ,
            SlcPort         =>  w_slcport   ,
            o_data1         =>  o_data1     ,
            o_data2         =>  o_data2     
    	);
    
    u6 : DelayEthFrame
        port map
    	(
    		clk			    =>	clk			,
    		rst             =>	rst			,
    		i_data          =>  w_data      ,
            o_sdata         =>  w_sdata     
    	);
    
    
end Behavioral;
