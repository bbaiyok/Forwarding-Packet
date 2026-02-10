----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2025 07:58:07 AM
-- Design Name: 
-- Module Name: TBGenRead - Behavioral
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

entity TBGenRead is
end entity TBGenRead;

architecture Behavioral of TBGenRead is

--------------------------------------------------------------------------------------------
-- Constant Declaration
--------------------------------------------------------------------------------------------

	constant	tClk			: time := 10 ns;
	
-------------------------------------------------------------------------
-- Component Declaration
-------------------------------------------------------------------------

	Component topGenHead is
        Port (  clk          : in  STD_LOGIC;
                rst          : in  STD_LOGIC;
                sw_start 	: in  STD_LOGIC;
                i_EndEthFr	: in  STD_LOGIC;
                o_Endlength	: out STD_LOGIC;
		          o_length	    : out STD_LOGIC_VECTOR (15 downto 0);
		          o_MACDest	: out STD_LOGIC_VECTOR (47 downto 0));
    end Component topGenHead;
    
-------------------------------------------------------------------------
-- Signal Declaration
-------------------------------------------------------------------------
	
	signal	clk			: std_logic   := '0';
	signal	rst			: std_logic   := '0';
	signal	sw_start	: std_logic   := '1';
    signal  i_EndEthFr	: std_logic   := '0';
    signal	o_Endlength	: STD_LOGIC;
    signal	o_length	: STD_LOGIC_VECTOR (15 downto 0);
	signal	o_MACDest	: STD_LOGIC_VECTOR (47 downto 0);

	
Begin

----------------------------------------------------------------------------------
-- Concurrent signal
----------------------------------------------------------------------------------
	
	u2 : topGenHead
    port map
    	(
    		clk			=>	clk			,
    		rst			=>	rst			,
    		sw_start 	=>	sw_start	,
    		i_EndEthFr	=>	i_EndEthFr	,
    		o_Endlength =>  o_Endlength ,
    		o_length	=>	o_length	,
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
		wait for 180*tClk;
		i_EndEthFr <= '1';
		wait for 580*tClk;
		i_EndEthFr <= '0';
		wait;
	End Process;



end Behavioral;
