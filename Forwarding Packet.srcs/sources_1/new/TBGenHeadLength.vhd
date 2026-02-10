----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/12/2025 05:58:07 AM
-- Design Name: 
-- Module Name: TBGenHeadLength - Behavioral
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
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TBGenHeadLength is
end entity TBGenHeadLength;

architecture Behavioral of TBGenHeadLength is

--------------------------------------------------------------------------------------------
-- Constant Declaration
--------------------------------------------------------------------------------------------

	constant	tClk			: time := 10 ns;
	
-------------------------------------------------------------------------
-- Component Declaration
-------------------------------------------------------------------------

	Component topmodule is
    Port ( clk          : in  STD_LOGIC;
           rst          : in  STD_LOGIC;
           sw_start 	: in  STD_LOGIC;
           i_EndEthFr	: in  STD_LOGIC;
           o_EnDMuxBff  : out STD_LOGIC;
		   o_MACDest	: out STD_LOGIC_VECTOR (47 downto 0));
    end Component topmodule;
    
-------------------------------------------------------------------------
-- Signal Declaration
-------------------------------------------------------------------------
	
	signal	clk			: std_logic   := '0';
	signal	rst			: std_logic   := '0';
	signal	sw_start	: std_logic   := '1';
    signal  i_EndEthFr	: std_logic   := '0';
    signal	o_EnDMuxBff	: STD_LOGIC;
	signal	o_MACDest	: STD_LOGIC_VECTOR (47 downto 0);

	
Begin

----------------------------------------------------------------------------------
-- Concurrent signal
----------------------------------------------------------------------------------
	
	u2 : topmodule
    port map
    	(
    		clk			=>	clk			,
    		rst			=>	rst			,
    		sw_start 	=>	sw_start	,
    		i_EndEthFr	=>	i_EndEthFr	,
    		o_EnDMuxBff	=>	o_EnDMuxBff	,
			o_MACDest	=>	o_MACDest	
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
		wait for 1000*tClk;
		i_EndEthFr <= '1';
		wait for 2*tClk;
		i_EndEthFr <= '0';
		wait;
	End Process;



end Behavioral;
