----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/21/2025 03:35:10 PM
-- Design Name: 
-- Module Name: TBGHMLDmux - Behavioral
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

entity TBGHMLDmux is
--  Port ( );
end TBGHMLDmux;

architecture Behavioral of TBGHMLDmux is
--------------------------------------------------------------------------------------------
-- Constant Declaration
--------------------------------------------------------------------------------------------

	constant	tClk			: time := 10 ns;
	
-------------------------------------------------------------------------
-- Component Declaration
-------------------------------------------------------------------------

	Component topgenHMLDMUX is
    Port ( 
           clk          : in  STD_LOGIC;
           rst          : in  STD_LOGIC;
           sw_start 	: in  STD_LOGIC;
           o_gendata    : out STD_LOGIC;
           o_data1      : out STD_LOGIC;
		   o_data2      : out STD_LOGIC
		 );
    end Component topgenHMLDMUX;
    
-------------------------------------------------------------------------
-- Signal Declaration
-------------------------------------------------------------------------
	
	signal	clk			: std_logic   := '0';
	signal	rst			: std_logic   := '0';
	signal	sw_start	: std_logic   := '1';
	signal  o_gendata   : STD_LOGIC;
    signal  o_data1     : STD_LOGIC;
	signal  o_data2     : STD_LOGIC;

	signal	eth_data	: std_logic_vector ( 7 downto 0 );
	signal	mem_data	: std_logic_vector ( 7 downto 0 );
	
	signal	EthFrByteCnt		: integer;
	
Begin

----------------------------------------------------------------------------------
-- Concurrent signal
----------------------------------------------------------------------------------
	
	u2 : topgenHMLDMUX
    port map
    	(
    		clk			=>	clk			,
    		rst			=>	rst			,
    		sw_start 	=>	sw_start	,
    		o_gendata   =>  o_gendata   ,
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
	
	u_sw_start : Process
	Begin
		sw_start <= '1';
		wait for 25*tClk;
		sw_start <= '0';
		wait for tClk;
		sw_start <= '1';
		wait;
	End Process;
	
-------------------------------------------------------------------------
-- Testbench
-------------------------------------------------------------------------

	stim_proc: process
	Begin
	    eth_data <=(OTHERS=>'0');
		wait for 26*tClk;
		for i in 0 to (72)-1 loop
		  for i in 0 to 7 loop
		      wait for tClk;
		      eth_data(7 downto 0)     <= o_gendata & eth_data (7 downto 1);
		  end loop;
		end loop;
		wait;
	End Process;
    
    u_Eth_data : process
	Begin
	    mem_data     <=(OTHERS=>'0');
	    EthFrByteCnt   <= 0;
		wait for 27*tClk;
		for i in 0 to (72)-1 loop
		  for i in 0 to 7 loop
		      wait for tClk;
		  end loop;
		  mem_data     <= eth_data;
		  EthFrByteCnt    <= EthFrByteCnt+1;
		end loop;
		wait for 8*tClk;
		mem_data     <=(OTHERS=>'0');
		wait;
	End Process;
	
end Behavioral;
