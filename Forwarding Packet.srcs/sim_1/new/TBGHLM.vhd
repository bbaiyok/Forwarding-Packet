----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2025 08:50:41 AM
-- Design Name: 
-- Module Name: TBGHLM - Behavioral
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

entity TBGHLM is
--  Port ( );
end TBGHLM;

architecture Behavioral of TBGHLM is

--------------------------------------------------------------------------------------------
-- Constant Declaration
--------------------------------------------------------------------------------------------

constant	tClk			: time := 10 ns;
	
-------------------------------------------------------------------------
-- Component Declaration
-------------------------------------------------------------------------

	Component topGHLM is
    Port ( clk          : in  STD_LOGIC;
           rst          : in  STD_LOGIC;
           sw_start 	: in  STD_LOGIC;
           o_data       : out STD_LOGIC;
           o_DMUXEn     : out STD_LOGIC;
		   o_slcport	: out STD_LOGIC_VECTOR (1 downto 0));
    end Component topGHLM;
    
-------------------------------------------------------------------------
-- Signal Declaration
-------------------------------------------------------------------------
	
	signal	clk			: std_logic   := '0';
	signal	rst			: std_logic   := '0';
	signal	sw_start	: std_logic   := '1';
	signal	o_data	    : STD_LOGIC;
    signal	o_DMUXEn	: STD_LOGIC;
	signal	o_slcport	: STD_LOGIC_VECTOR (1 downto 0);

	signal	eth_data	: std_logic_vector ( 7 downto 0 );
	signal	mem_data	: std_logic_vector ( 7 downto 0 );
	
	signal	EthFrByteCnt		: integer;
	
Begin

----------------------------------------------------------------------------------
-- Concurrent signal
----------------------------------------------------------------------------------
	
	u2 : topGHLM
    port map
    	(
    		clk			=>	clk			,
    		rst			=>	rst			,
    		sw_start 	=>	sw_start	,
    		o_data      =>  o_data      ,
    		o_DMUXEn    =>  o_DMUXEn    ,
			o_slcport	=>	o_slcport	
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
		      eth_data(7 downto 0)     <= o_data & eth_data (7 downto 1);
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
