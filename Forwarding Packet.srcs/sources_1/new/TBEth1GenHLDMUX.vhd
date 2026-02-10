----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/21/2025 11:23:49 AM
-- Design Name: 
-- Module Name: TBEth1GenHLDMUX - Behavioral
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

entity TBEth1GenHLDMUX is
--  Port ( );
end TBEth1GenHLDMUX;

architecture Behavioral of TBEth1GenHLDMUX is
--------------------------------------------------------------------------------------------
-- Constant Declaration
--------------------------------------------------------------------------------------------

	constant	tClk			: time := 10 ns;
	
-------------------------------------------------------------------------
-- Component Declaration
-------------------------------------------------------------------------

	Component topEth1GHLDMUX is
    Port ( 
           clk          : in  STD_LOGIC;
           rst          : in  STD_LOGIC;
           sw_start 	: in  STD_LOGIC;
           i_EndEthFr	: in  STD_LOGIC;
           SlcPort      : in  STD_LOGIC_VECTOR (1 downto 0);
           o_data1      : out STD_LOGIC;
		   o_data2      : out STD_LOGIC
		 );
    end Component topEth1GHLDMUX;
    
-------------------------------------------------------------------------
-- Signal Declaration
-------------------------------------------------------------------------
	
	signal	clk			: std_logic   := '0';
	signal	rst			: std_logic   := '0';
	signal	sw_start	: std_logic   := '1';
    signal  i_EndEthFr	: std_logic   := '0';
    signal  SlcPort     : STD_LOGIC_VECTOR (1 downto 0)    := "00";
    signal  o_data1     : STD_LOGIC;
	signal  o_data2     : STD_LOGIC;

	
Begin

----------------------------------------------------------------------------------
-- Concurrent signal
----------------------------------------------------------------------------------
	
	u2 : topEth1GHLDMUX
    port map
    	(
    		clk			=>	clk			,
    		rst			=>	rst			,
    		sw_start 	=>	sw_start	,
    		i_EndEthFr	=>	i_EndEthFr	,
    		SlcPort     =>  SlcPort     ,
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
		wait for 176*tClk;
		SlcPort  <= "10";
		wait for 11824*tClk;
		i_EndEthFr <= '1';
		wait for 2*tClk;
		i_EndEthFr <= '0';
		wait;
	End Process;
end Behavioral;

