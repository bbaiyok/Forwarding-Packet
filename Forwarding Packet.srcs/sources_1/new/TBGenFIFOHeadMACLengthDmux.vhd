----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/21/2025 04:44:10 PM
-- Design Name: 
-- Module Name: TBGenFIFOHeadMACLengthDmux - Behavioral
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

entity TBGenFIFOHeadMACLengthDmux is
--  Port ( );
end TBGenFIFOHeadMACLengthDmux;

architecture Behavioral of TBGenFIFOHeadMACLengthDmux is
--------------------------------------------------------------------------------------------
-- Constant Declaration
--------------------------------------------------------------------------------------------

	constant	tClk			: time := 10 ns;
	
-------------------------------------------------------------------------
-- Component Declaration
-------------------------------------------------------------------------

	Component TopGenFIFOHeadMACLengthDmux is
    Port ( 
           clk          : in  STD_LOGIC;
           rst          : in  STD_LOGIC;
           sw_start 	: in  STD_LOGIC;
           o_data1      : out STD_LOGIC;
		   o_data2      : out STD_LOGIC
		 );
    end Component TopGenFIFOHeadMACLengthDmux;
    
-------------------------------------------------------------------------
-- Signal Declaration
-------------------------------------------------------------------------
	
	signal	clk			: std_logic   := '0';
	signal	rst			: std_logic   := '0';
	signal	sw_start	: std_logic   := '1';
    signal  o_data1     : STD_LOGIC;
	signal  o_data2     : STD_LOGIC;

	
Begin

----------------------------------------------------------------------------------
-- Concurrent signal
----------------------------------------------------------------------------------
	
	u2 : TopGenFIFOHeadMACLengthDmux
    port map
    	(
    		clk			=>	clk			,
    		rst			=>	rst			,
    		sw_start 	=>	sw_start	,
    		o_data1     =>  o_data1     ,
    		o_data2     =>  o_data2     
    	);
	
	u_rst : Process
	Begin
		rst	<= '0';
		wait for 20*tClk;
		rst	<= '1';
		wait;
	End Process;

	u_clk : Process
	Begin
		clk		<= '1';
		wait for tClk/2;
		clk		<= '0';
		wait for tClk/2;
	End Process;
	
-------------------------------------------------------------------------
-- Testbench
-------------------------------------------------------------------------

	stim_proc: process
	Begin
        wait for 30*tClk;
		sw_start <= '0';
		wait for 2*tClk;
		sw_start <= '1';
		wait for 580*tClk;
		wait;
	End Process;
end Behavioral;