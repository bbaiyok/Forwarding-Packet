----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2025 09:13:14 AM
-- Design Name: 
-- Module Name: DelayEthFrame - Behavioral
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

entity DelayEthFrame is
    Port ( clk      : in STD_LOGIC;
           rst      : in STD_LOGIC;
           i_data   : in STD_LOGIC;
           o_sdata   : out STD_LOGIC);
end DelayEthFrame;

architecture Behavioral of DelayEthFrame is
    
    signal BffData  : std_logic_vector (178 downto 0); 
    -- can change to relate to timing to have enable from check length
    
begin
----------------------------------------------------------------------------------
-- output assignment
----------------------------------------------------------------------------------
	
    o_sdata  <=  BffData(0);
	
----------------------------------------------------------------------------------
-- process block
----------------------------------------------------------------------------------
    
    -- delay ethernet frame to send all 
	u_EthFrame_collect : process (clk) is
	begin
		if rst = '0' then
		    BffData <= (others => '0');
		elsif ( rising_edge(clk) ) then
			BffData <= i_data & BffData (178 downto 1);
		end if;
	end process u_EthFrame_collect;
    
end Behavioral;
