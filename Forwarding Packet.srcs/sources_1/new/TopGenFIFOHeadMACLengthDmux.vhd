----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/21/2025 04:44:10 PM
-- Design Name: 
-- Module Name: TopGenFIFOHeadMACLengthDmux - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TopGenFIFOHeadMACLengthDmux is
    Port ( 
           clk          : in  STD_LOGIC;
           rst          : in  STD_LOGIC;
           sw_start 	: in  STD_LOGIC;
           o_data1      : out STD_LOGIC;
		   o_data2      : out STD_LOGIC
		 );
end TopGenFIFOHeadMACLengthDmux;

architecture Behavioral of TopGenFIFOHeadMACLengthDmux is

    Component datagen is
	generic (
			PayloadBytes	: integer := 46;
			MACDest			: STD_LOGIC_VECTOR 	( 47 downto 0 ) 	:= x"AABBCCDDEEFF" ;
			MACSource		: STD_LOGIC_VECTOR 	( 47 downto 0 ) 	:= x"A82FD9B56C98" );
    Port ( 	clk         : in  STD_LOGIC;
			rst         : in  STD_LOGIC;
			sw_start    : in  STD_LOGIC;
			o_wr_en     : out STD_LOGIC;
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
		   i_EnRdLength	 	: in  STD_LOGIC;
           i_lengthbytes 	: in  STD_LOGIC_VECTOR (15 downto 0);
           RdEnEthFrLength 	: out STD_LOGIC);
    end Component Check_Length;
    
    Component MacTable is
	generic (
        MAC1        : std_logic_vector(47 downto 0) := X"11AA22BB33DD"; -- MAC 1
        MAC2        : std_logic_vector(47 downto 0) := X"AABBCCDDEEFF"; -- MAC 2
        MAC3        : std_logic_vector(47 downto 0) := X"112233445566"  -- MAC 3 
        );
    port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        mac_in      : in  std_logic_vector   (47 downto 0);
        port_out    : out std_logic_vector  (1 downto 0));
    end Component MacTable;
    
    Component DeMUX is
    Port ( clk      : in  STD_LOGIC;
           i_data   : in  STD_LOGIC;
           SendEn   : in  STD_LOGIC;
           SlcPort  : in  STD_LOGIC_VECTOR (1 downto 0);
           o_data1  : out STD_LOGIC;
           o_data2  : out STD_LOGIC);
    end Component DeMUX;
    
    COMPONENT EthFrame_FIFO
    PORT (
        clk : IN STD_LOGIC;
        din : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        wr_en : IN STD_LOGIC;
        rd_en : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        full : OUT STD_LOGIC;
        empty : OUT STD_LOGIC 
    );
    END COMPONENT;
    
----------------------------------------------------------------------------------
-- signal label
----------------------------------------------------------------------------------
    
    signal w_invrst     : std_logic;
    
    signal w_data       : std_logic;
    signal w_sdata      : std_logic;
    signal w_data_vec   : std_logic_vector (0 downto 0);
    signal w_sdata_vec  : std_logic_vector (0 downto 0);
    
    signal w_wr_en      : std_logic;
    signal w_rd_en      : std_logic;
    signal w_empty      : std_logic;
    
    signal w_sendleng   : std_logic;
    signal w_lengbytes  : std_logic_vector (15 downto 0);
    signal w_MAC        : std_logic_vector (47 downto 0);
    signal w_slcport    : std_logic_vector (1 downto 0);
    
begin
----------------------------------------------------------------------------------
-- output assignment
----------------------------------------------------------------------------------
    
    w_sdata     <=  w_sdata_vec(0);
    w_data_vec  <=  (0 => w_data);
    
----------------------------------------------------------------------------------
-- process block
----------------------------------------------------------------------------------

    u1 : datagen
    	port map
    	(
    		clk			   =>	clk			,
    		rst			   =>	rst			,
    		sw_start	   =>	sw_start	,
    		o_wr_en        =>   w_wr_en     ,
    		o_data		   =>	w_data
    	);
	
    u2 : Read_Header
    	port map
    	(
    		clk			   =>	clk			,
    		rst			   =>	rst			,
    		i_data 		   =>	w_data		,
    		i_EndEthFr	   =>	w_empty  	,
    		o_Endlength    =>   w_sendleng  ,
    		o_length	   =>	w_lengbytes	,
			o_MACDest	   =>	w_MAC	
    	);
    
    u3 : Check_Length
        port map
    	(
    		clk			    =>	clk			,
    		rst			    =>	rst			,
    		i_EnRdLength 	=>	w_sendleng	,
    		i_lengthbytes	=>	w_lengbytes	,
    		RdEnEthFrLength	=>	w_rd_en	
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
    		clk			    =>	clk			,
    		i_data          =>  w_sdata     ,
            SendEn          =>  w_rd_en     ,
            SlcPort         =>  w_slcport   ,
            o_data1         =>  o_data1     ,
            o_data2         =>  o_data2     
    	);
    	
    u6 : EthFrame_FIFO
    PORT MAP (
        clk     => clk,
        din     => w_data_vec   ,
        wr_en   => w_wr_en      ,
        rd_en   => w_rd_en      ,
        dout    => w_sdata_vec  ,
        full    => open         ,
        empty   => w_empty
    );
    
end Behavioral;
