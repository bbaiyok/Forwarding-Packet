----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/09/2025 01:54:43 AM
-- Design Name: 
-- Module Name: Check_Length - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity Check_Length is
    Port ( clk 				: in  STD_LOGIC;
		   rst				: in  STD_LOGIC;
		   i_EndLength	 	: in  STD_LOGIC;
           i_length      	: in  STD_LOGIC_VECTOR (15 downto 0);
           EnDMUX        	: out STD_LOGIC);
end Check_Length;

architecture Behavioral of Check_Length is
	
	signal	SndEthFrCnt     : integer range 0 to 12500;
	signal	PayloadBytCnt   : integer range 0 to 65535;
	signal  RdEn            : std_logic;
	
begin
	
	PayloadBytCnt 	<= to_integer(unsigned(i_length));
	EnDMUX	<= RdEn;
	
	
	-- collect length data to set counter for send enable signal to demux
	u_CntEthFr : process (clk) is
	begin
		if rising_edge(clk) then
			if i_EndLength = '1' then
			    SndEthFrCnt <= ((26 + PayloadBytCnt)*8) - 1;
			else
			    if SndEthFrCnt /= 0 then
			        SndEthFrCnt <= SndEthFrCnt - 1;
			    else
				    SndEthFrCnt <= 0;
				end if;
			end if;
		end if;
	end process u_CntEthFr;
	
	-- check counter for send enable signal to demux
	u_EnSendEthFr : process (clk) is
	begin
		if rising_edge(clk) then
			if SndEthFrCnt /= 0 then
			    RdEn <= '1';
			else
				RdEn <= '0';
			end if;
		end if;
	end process u_EnSendEthFr;
	
end Behavioral;
