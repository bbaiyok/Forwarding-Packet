----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:32:09 09/18/2024 
-- Design Name: 
-- Module Name:    datagenEth2 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity datagenEth2 is
    generic (
			PayloadBytes	: integer := 100;
			MACDest			: STD_LOGIC_VECTOR 	( 47 downto 0 ) 	:= x"AAAAAAAAAAAA" ;
			MACSource		: STD_LOGIC_VECTOR 	( 47 downto 0 ) 	:= x"158468945236" 
	);
	Port ( 	clk         : in  STD_LOGIC;
			rst         : in  STD_LOGIC;
			sw_start    : in  STD_LOGIC;
			o_data      : out  STD_LOGIC);
end datagenEth2;

architecture Behavioral of datagenEth2 is
----------------------------------------------------------------------------------
-- signal label
----------------------------------------------------------------------------------

constant	PL_Size			: integer 	:=	PayloadBytes*8;				
constant	Frame_Size		: integer	:=	(26*8)+PL_Size;		

constant	preamble		: STD_LOGIC_VECTOR 	( 55 downto 0 ) 			:= x"55555555555555" ;
constant	SFD				: STD_LOGIC_VECTOR 	( 7 downto 0 ) 				:= x"D5" ;
constant	payload_length	: STD_LOGIC_VECTOR 	( 15 downto 0 ) 			:= conv_std_logic_vector(PayloadBytes, 16) ;
constant	payload			: STD_LOGIC_VECTOR 	( PL_Size-1 downto 0 )      := ( others => '1' );	
constant	CRC				: STD_LOGIC_VECTOR 	( 31 downto 0 ) 			:= x"6BD11C40" ;

type eth_state_type is (	idle		,
							send_eth_fr	,
							stop	
						);
						
signal state 				: eth_state_type;

signal wDatareq 			: STD_LOGIC;

signal rStop_cnt			: integer range 0 to 95;
signal rEth_fr_cnt			: integer range 0 to Frame_Size-1;

signal wMem_eth_fr_1		: STD_LOGIC_VECTOR 	( Frame_Size-1 downto 0 );		
signal rData_eth_fr  		: STD_LOGIC_VECTOR 	( Frame_Size-1 downto 0 );

begin
----------------------------------------------------------------------------------
-- output assignment
----------------------------------------------------------------------------------

    wDatareq                <=  not sw_start;
	
	wMem_eth_fr_1			<=	CRC & payload 
								& payload_length(7 downto 0) & payload_length(15 downto 8) 
								& MACSource(7 downto 0) & MACSource(15 downto 8) & MACSource(23 downto 16) & MACSource(31 downto 24) & MACSource(39 downto 32) & MACSource(47 downto 40) 
								& MACDest(7 downto 0) & MACDest(15 downto 8) & MACDest(23 downto 16) & MACDest(31 downto 24) & MACDest(39 downto 32) & MACDest(47 downto 40) 
								& SFD & preamble;
	
	o_data      			<=  rData_eth_fr (0);

----------------------------------------------------------------------------------
-- process block
----------------------------------------------------------------------------------
	
	
	u_eth_fr : process (clk) Is
	Begin
		if ( rising_edge(clk) ) then
			if ( rst = '0' ) then
				rData_eth_fr <= ( others => '0' );
			else
				if ( state = idle and wDatareq = '1' ) then
					rData_eth_fr <= wMem_eth_fr_1;
				elsif ( state = send_eth_fr ) then
					rData_eth_fr 	<= '0' & rData_eth_fr (Frame_Size-1 downto 1);
				else
					rData_eth_fr 	<= rData_eth_fr;
				end if;
			end if;
		end if;
	end process u_eth_fr;
	
	
	
	u_eth_fr_cnt : process (clk) is
	begin
		if ( rising_edge(clk) ) then
			if ( rst = '0' ) then
				rEth_fr_cnt <= Frame_Size-1;
			else
				if ( state = send_eth_fr ) then
					rEth_fr_cnt <= rEth_fr_cnt - 1;
				else
					rEth_fr_cnt <= Frame_Size-1;
				end if;
			end if;
		end if;
	end process u_eth_fr_cnt;
	 
	
	
	u_stop_cnt : process (clk) is
	begin
		if ( rising_edge(clk) ) then
			if ( rst = '0' ) then
				rStop_cnt <= 95;
			else
				if ( state = stop ) then
					rStop_cnt <= rStop_cnt - 1;
				else
					rStop_cnt <= 95;
				end if;
			end if;
		end if;
	end process u_stop_cnt;
	
	
	
	u_eth_state : process (clk) is
	begin
		if rising_edge(clk) then
			if rst = '0' then
				state <= idle;
			else
				case ( state ) is
					when idle		=>
						if wDatareq = '1' then
							state <= send_eth_fr;
						else
							state <= idle;
						end if;
						
					when send_eth_fr	=>
						if rEth_fr_cnt = 0 then
							state <= stop;
						else
							state <= send_eth_fr;
						end if;
						
					when stop		=>
						if rStop_cnt = 0 then
							state <= idle;
						else
							state <= stop;
						end if;
						
				end case;
			end if;
		end if;
	end process u_eth_state;
	
	
end Behavioral;

