----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2025 03:35:48 AM
-- Design Name: 
-- Module Name: topmodule - Behavioral
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

entity topmodule is
    Port ( clk          : in  STD_LOGIC;
           rst          : in  STD_LOGIC;
           sw_start 	: in  STD_LOGIC;
           i_EndEthFr	: in  STD_LOGIC;
           o_EnDMuxBff  : out STD_LOGIC;
		   o_MACDest	: out STD_LOGIC_VECTOR (47 downto 0));
end topmodule;

architecture Behavioral of topmodule is
----------------------------------------------------------------------------------
-- component
----------------------------------------------------------------------------------
    
    component datagen is
	generic (
			PayloadBytes	: integer := 46;
			MACDest			: STD_LOGIC_VECTOR 	( 47 downto 0 ) 	:= x"AABBCCDDEEFF" ;
			MACSource		: STD_LOGIC_VECTOR 	( 47 downto 0 ) 	:= x"A82FD9B56C98" 
	);
    Port ( 	clk         : in  STD_LOGIC;
			rst         : in  STD_LOGIC;
			sw_start    : in  STD_LOGIC;
			o_data      : out STD_LOGIC);
    end component datagen;
	
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
    
----------------------------------------------------------------------------------
-- signal label
----------------------------------------------------------------------------------

    signal w_data       : std_logic;
    signal w_sendleng   : std_logic;
    signal w_lengbytes  : std_logic_vector (15 downto 0);
    
begin
----------------------------------------------------------------------------------
-- output assignment
----------------------------------------------------------------------------------



----------------------------------------------------------------------------------
-- process block
----------------------------------------------------------------------------------

    u1 : datagen
    	port map
    	(
    		clk			=>	clk			,
    		rst			=>	rst			,
    		sw_start	=>	sw_start	,
    		o_data		=>	w_data
    	);
	
    u2 : Read_Header
    	port map
    	(
    		clk			=>	clk			,
    		rst			=>	rst			,
    		i_data 		=>	w_data		,
    		i_EndEthFr	=>	i_EndEthFr	,
    		o_Endlength =>  w_sendleng  ,
    		o_length	=>	w_lengbytes	,
			o_MACDest	=>	o_MACDest	
    	);
    
    u3 : Check_Length
        port map
    	(
    		clk			    =>	clk			,
    		rst			    =>	rst			,
    		i_EnRdLength 	=>	w_sendleng	,
    		i_lengthbytes	=>	w_lengbytes	,
    		RdEnEthFrLength	=>	o_EnDMuxBff	
    	);
    
end Behavioral;
