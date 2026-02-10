----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/21/2025 10:04:32 AM
-- Design Name: 
-- Module Name: TBdatagenEth2 - Behavioral
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

entity TBdatagenEth2 is
--  Port ( );
end TBdatagenEth2;

architecture Behavioral of TBdatagenEth2 is

--------------------------------------------------------------------------------------------
-- Constant Declaration
--------------------------------------------------------------------------------------------

	constant	tClk			: time := 10 ns;
	
-------------------------------------------------------------------------
-- Component Declaration
-------------------------------------------------------------------------
	
	Component datagenEth2 is
    Port ( 	clk 		: in  STD_LOGIC;
			rst 		: in  STD_LOGIC;
			sw_start 	: in  STD_LOGIC;
			o_data 		: out  STD_LOGIC);
	end Component datagenEth2;
	
-------------------------------------------------------------------------
-- Signal Declaration
-------------------------------------------------------------------------
	constant   Frame_Size  : integer := (26+100)*8;
	
	signal	clk			: std_logic   := '0';
	signal	rst			: std_logic   := '0';
	signal	sw_start	: std_logic   := '1';
	
	signal	o_data		: std_logic   ;
	
	signal	eth_data	: std_logic_vector( Frame_Size-1 downto 0 );
	
Begin

----------------------------------------------------------------------------------
-- Concurrent signal
----------------------------------------------------------------------------------
	
	uut : datagenEth2
	port map
	(
		clk			=>	clk			,
		rst			=>	rst			,
		sw_start	=>	sw_start	,
		o_data		=>	o_data
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
	    eth_data <=(OTHERS=>'1');
		wait for 30*tClk;
		sw_start <= '0';
		wait for tClk;
		eth_data(Frame_Size-1 downto 0)     <= o_data & eth_data (Frame_Size-1 downto 1);
		wait for tClk;
		sw_start <= '1';
		eth_data(Frame_Size-1 downto 0)     <= o_data & eth_data (Frame_Size-1 downto 1);
		for i in 0 to Frame_Size-2 loop
		  wait for tClk;
		  eth_data(Frame_Size-1 downto 0)     <= o_data & eth_data (Frame_Size-1 downto 1);
		end loop;
		wait for 30*tClk;
		wait;
	End Process;

end Behavioral;
