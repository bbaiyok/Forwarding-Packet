library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

Entity TBdatagen Is
End Entity TBdatagen;

Architecture behavioral Of TBdatagen Is

--------------------------------------------------------------------------------------------
-- Constant Declaration
--------------------------------------------------------------------------------------------
    
    constant    Payloadsize     : integer   := 46;
    constant    EthFrame_Bytes  : integer   := 26+Payloadsize;
	constant    tClk			: time      := 10 ns;
	
-------------------------------------------------------------------------
-- Component Declaration
-------------------------------------------------------------------------
	
	component datagen is
	generic (
			PayloadBytes	: integer   := Payloadsize;
			MACDest			: STD_LOGIC_VECTOR 	( 47 downto 0 ) 	:= x"AABBCCDDEEFF" ;
			MACSource		: STD_LOGIC_VECTOR 	( 47 downto 0 ) 	:= x"000000AABBCC" 
	);
    Port ( 	clk         : in  STD_LOGIC;
			rst         : in  STD_LOGIC;
			sw_start    : in  STD_LOGIC;
			o_data      : out STD_LOGIC);
    end component datagen;
-------------------------------------------------------------------------
-- Signal Declaration
-------------------------------------------------------------------------
	
	signal	clk			: std_logic   := '0';
	signal	rst			: std_logic   := '0';
	signal	sw_start	: std_logic   := '1';
	
	signal	o_data		: std_logic;
	
	signal	eth_data	: std_logic_vector ( 7 downto 0 );
	signal	mem_data	: std_logic_vector ( 7 downto 0 );
	
	signal	EthFrByteCnt		: integer;
	
Begin

----------------------------------------------------------------------------------
-- Concurrent signal
----------------------------------------------------------------------------------
	
	uut : datagen
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
		for i in 0 to (EthFrame_Bytes)-1 loop
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
		for i in 0 to (EthFrame_Bytes)-1 loop
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
    
End Architecture behavioral;