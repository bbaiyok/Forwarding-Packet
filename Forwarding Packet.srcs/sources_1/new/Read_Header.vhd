----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/11/2025 09:47:03 PM
-- Design Name: 
-- Module Name: Read Header - Behavioral
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
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Read_Header is
	Port (	clk 		: 	in  STD_LOGIC;
			rst 		: 	in  STD_LOGIC;
			i_data 		: 	in  STD_LOGIC;
			i_EndEthFr	:	in	STD_LOGIC;
			o_Endlength	:	out STD_LOGIC;
			o_length	:	out STD_LOGIC_VECTOR (15 downto 0);
			o_MACDest	:	out STD_LOGIC_VECTOR (47 downto 0));
end Read_Header;

----------------------------------------------------------------------------------
-- signal label
----------------------------------------------------------------------------------

architecture Behavioral of Read_Header is

type SHeadCheck is (idle		,
					PreCheck	,
					SFDCheck	,
					MACDestSend	,
					MACSrc      ,
					LengthSend	,
					delay       ,
					EndCheck	);
	
signal	state	 		: SHeadCheck;
signal 	wCasesw 		: STD_LOGIC_VECTOR 	( 1 downto 0 );
signal 	wDatareq 		: STD_LOGIC;
signal	wEndlength		: STD_LOGIC;
signal 	rEByte_cnt		: integer range 0 to 7;
signal 	rPre_cnt		: integer range 0 to 5;
signal 	rLength_cnt		: integer range 0 to 1;
signal 	rMAC_cnt		: integer range 0 to 5;
signal	EthByte			: STD_LOGIC_VECTOR (7 downto 0)	    := x"00";
signal	Bff_length		: STD_LOGIC_VECTOR (15 downto 0)	:= x"0000";
signal	Bff_MACDest		: STD_LOGIC_VECTOR (47 downto 0)	:= (others => '0');

begin
----------------------------------------------------------------------------------
-- output assignment
----------------------------------------------------------------------------------
	
	o_Endlength	<=		wEndlength;
	o_length	<=		Bff_length;
	o_MACDest	<=		Bff_MACDest;
	
----------------------------------------------------------------------------------
-- process block
----------------------------------------------------------------------------------
	
	-- collect input 1 bit to 1 byte 
	u_EByte_collect : process (clk) is
	begin
		if ( rising_edge(clk) ) then
			if ( rst = '0' ) then
				EthByte <= EthByte;
			else
				EthByte (7 downto 0) <= i_data & EthByte (7 downto 1);
			end if;
		end if;
	end process u_EByte_collect;
	
	
	-- if buffer detect first preamble byte, start byte counter
	u_WakePre : process (clk) is
	begin
		if ( rising_edge(clk) ) then
			if ( rst = '0' ) then
				rEByte_cnt <= 7;
			else
				if state /= idle then
					if rEByte_cnt = 0 then
						rEByte_cnt <= 7;
					else
						rEByte_cnt <= rEByte_cnt - 1;
					end if;
				else
					rEByte_cnt <= rEByte_cnt;
				end if;
			end if;
		end if;
	end process u_WakePre;
	
	
	-- count for preamble byte 2 to 7
	u_Pre_cnt : process (clk) is
	begin
		if ( rising_edge(clk) ) then
			if ( rst = '0' ) then
				rPre_cnt <= 5;
			else
				if state = PreCheck then
					if rEByte_cnt = 0 then
						if EthByte = x"55" then
							rPre_cnt <= rPre_cnt - 1;
						else
							rPre_cnt <= 0;
						end if;
					else
						rPre_cnt <= rPre_cnt;
					end if;
				else
					rPre_cnt <= 5;
				end if;
			end if;
		end if;
	end process u_Pre_cnt;
	
	
	-- count for MAC Address Frame
	u_MAC_cnt : process (clk) is
	begin
		if ( rising_edge(clk) ) then
			if ( rst = '0' ) then
				rMAC_cnt <= 5;
			elsif ( state = MACDestSend or state = MACSrc ) then
				if ( rEByte_cnt = 0 ) then
					if rMAC_cnt = 0 then 
						rMAC_cnt <= 5;
					else
						rMAC_cnt <= rMAC_cnt - 1;
					end if;
				else
					rMAC_cnt <= rMAC_cnt;
				end if;
			end if;
		end if;
	end process u_MAC_cnt;
	
	
	-- collect MAC Address Destination bytes
	u_MACD_collect : process (clk) is
	begin
		if ( rising_edge(clk) ) then
			if ( rst = '0' ) then
				Bff_MACDest <= ( others => '0' );
			elsif state = MACDestSend then
				if rEByte_cnt = 0 then
					Bff_MACDest (47 downto 0) <= Bff_MACDest (39 downto 0) & EthByte;
				else
					Bff_MACDest <= Bff_MACDest;
				end if;
			end if;
		end if;
	end process u_MACD_collect;
	
	
	-- count for Length/Ethertype Frame
	u_Length_cnt : process (clk) is
	begin
		if ( rising_edge(clk) ) then
			if ( rst = '0' ) then
				rLength_cnt <= 1;
			elsif ( state = LengthSend ) then
				if ( rEByte_cnt = 0 ) then
					rLength_cnt <= rLength_cnt - 1;
				else
					rLength_cnt <= rLength_cnt;
				end if;
			end if;
		end if;
	end process u_Length_cnt;
	
	
	-- collect Length/Ethertype bytes
	u_Length_collect : process (clk) is
	begin
		if ( rising_edge(clk) ) then
			if ( rst = '0' ) then
				Bff_length <= ( others => '0' );
			elsif state = LengthSend then
				if rEByte_cnt = 0 then
					Bff_length (15 downto 0) <= Bff_length (7 downto 0) & EthByte;
				else
					Bff_length <= Bff_length;
				end if;
			end if;
		end if;
	end process u_Length_collect;
	
	
	-- send signal when collected all length 
	u_EndLength : process (clk) is
	begin
		if ( rising_edge(clk) ) then
			if ( rst = '0' ) then
				wEndlength <= '0';
			elsif rLength_cnt = 0 and rEByte_cnt = 0 then
				wEndlength <= '1';
			else
				wEndlength <= '0';
			end if;
		end if;
	end process u_EndLength;
	
	
	-- state
	u_HeadCheck : process (clk) is
	begin
		if rising_edge(clk) then
			if rst = '0' then
				state <= idle;
			else
				case ( state ) is
					when idle			=>
						if EthByte = x"55" then
							state <= PreCheck;
						else
							state <= idle;
						end if;
					when PreCheck		=>
						if rPre_cnt = 0 and rEByte_cnt = 0 then
							if EthByte = x"55" then
								state <= SFDCheck;
							else
								state <= idle;
							end if;
						else
							state <= PreCheck;
						end if;
					when SFDCheck		=>
						if rEByte_cnt = 0 then
							if EthByte = x"D5" then
								state <= MACDestSend;
							else
								state <= idle;
							end if;
						else
							state <= SFDCheck;
						end if;
					when MACDestSend	=>
						if rMAC_cnt = 0 and rEByte_cnt = 0 then
							state <= MACSrc;
						else
							state <= MACDestSend;
						end if;
					when MACSrc		=>
						if rMAC_cnt = 0 and rEByte_cnt = 0 then
							state <= LengthSend;
						else
							state <= MACSrc;
						end if;
					when LengthSend		=>
						if rLength_cnt = 0 and rEByte_cnt = 0 then
							state <= delay;
						else
							state <= LengthSend;
						end if;
					when delay          =>
					    if i_EndEthFr = '1' then
					        state <= EndCheck;
						else
						    state <= delay;
						end if;
					when EndCheck		=>
						if i_EndEthFr = '0' then
					        state <= idle;
						else
						    state <= EndCheck;
						end if;
					when others	=>
						state <= idle;
				end case;
			end if;
		end if;
	end process u_HeadCheck;
	
end Behavioral;
