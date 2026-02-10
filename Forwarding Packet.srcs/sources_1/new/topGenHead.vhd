----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2025 07:08:41 AM
-- Design Name: 
-- Module Name: topGenHead - Behavioral
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

entity topGenHead is
    Port ( clk          : in  STD_LOGIC;
           rst          : in  STD_LOGIC;
           sw_start 	: in  STD_LOGIC;
           i_EndEthFr	: in  STD_LOGIC;
           o_Endlength	: out STD_LOGIC;
		   o_length	    : out STD_LOGIC_VECTOR (15 downto 0);
		   o_MACDest	: out STD_LOGIC_VECTOR (47 downto 0));
end topGenHead;

architecture Behavioral of topGenHead is
----------------------------------------------------------------------------------
-- component
----------------------------------------------------------------------------------
    
    Component datagen is
	generic (
			PayloadBytes	: integer := 46;
			MACDest			: STD_LOGIC_VECTOR 	( 47 downto 0 ) 	:= x"AABBCCDDEEFF" ;
			MACSource		: STD_LOGIC_VECTOR 	( 47 downto 0 ) 	:= x"A82FD9B56C98" 
	);
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
    
----------------------------------------------------------------------------------
-- signal label
----------------------------------------------------------------------------------
    
    signal w_data       : std_logic;
    
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
    		o_Endlength =>  o_Endlength ,
    		o_length	=>	o_length	,
			o_MACDest	=>	o_MACDest	
    	);
    	
end Behavioral;
