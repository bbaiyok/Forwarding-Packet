----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2025 08:46:18 AM
-- Design Name: 
-- Module Name: topGHLM - Behavioral
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

entity topGHLM is
    port(   clk           : in  STD_LOGIC;
            rst           : in  STD_LOGIC;
            sw_start 	  : in  STD_LOGIC;
            o_data        : out STD_LOGIC;
            o_DMUXEn      : out STD_LOGIC;
		    o_slcport	  : out STD_LOGIC_VECTOR (1 downto 0));
end topGHLM;

architecture Behavioral of topGHLM is
----------------------------------------------------------------------------------
-- component
----------------------------------------------------------------------------------

    Component datagen is
	generic (
			PayloadBytes	: integer := 100;
			MACDest			: STD_LOGIC_VECTOR 	( 47 downto 0 ) 	:= x"11AA22bb33dd" ;
			MACSource		: STD_LOGIC_VECTOR 	( 47 downto 0 ) 	:= x"112233445566" 
	);
    Port ( 	clk         : in  STD_LOGIC;
			rst         : in  STD_LOGIC;
			sw_start    : in  STD_LOGIC;
			o_data      : out  STD_LOGIC);
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
    Port ( clk 				: in STD_LOGIC;
		   rst				: in STD_LOGIC;
		   i_EnRdLength	 	: in STD_LOGIC;
           i_lengthbytes 	: in STD_LOGIC_VECTOR (15 downto 0);
           RdEnEthFrLength 	: out STD_LOGIC);
    end Component Check_Length;
    
    Component MacTable is
	generic (
        MAC1        : std_logic_vector(47 downto 0) := X"11AA22BB33DD"; -- MAC 1
        MAC2        : std_logic_vector(47 downto 0) := X"AABBCCDDEEFF"; -- MAC 2
        MAC3        : std_logic_vector(47 downto 0) := X"112233445566"  -- MAC 3
		);
    port (
        clk         : in std_logic;
        rst         : in std_logic;
        mac_in      : in std_logic_vector   (47 downto 0);
        port_out    : out std_logic_vector  (1 downto 0));
    end Component MacTable;
    
----------------------------------------------------------------------------------
-- signal label
----------------------------------------------------------------------------------

    signal w_data       : std_logic;
    signal w_sendleng   : std_logic;
    signal w_DMUXEn     : std_logic;
    signal w_lengbytes  : std_logic_vector (15 downto 0);
    signal w_MAC        : std_logic_vector (47 downto 0);
    

begin
----------------------------------------------------------------------------------
-- output assignment
----------------------------------------------------------------------------------
    
    o_DMUXEn    <= w_DMUXEn;
    o_data      <= w_data;
    
----------------------------------------------------------------------------------
-- process block
----------------------------------------------------------------------------------

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
    		i_EndEthFr	   =>	w_DMUXEn	,
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
    		RdEnEthFrLength	=>	w_DMUXEn	
    	);
    
    u4 : MacTable
        port map
    	(
    		clk             =>	clk			,
            rst             =>	rst			,
            mac_in          =>  w_MAC       ,
            port_out        =>  o_slcport   
    	);
    

end Behavioral;
