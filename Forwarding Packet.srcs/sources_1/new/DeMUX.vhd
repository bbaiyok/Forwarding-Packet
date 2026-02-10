----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/12/2025 06:42:55 AM
-- Design Name: 
-- Module Name: DeMUX - Behavioral
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

entity DeMUX is
    Port ( clk      : in std_logic;
           i_data   : in STD_LOGIC;
           SendEn   : in STD_LOGIC;
           SlcPort  : in STD_LOGIC_VECTOR (1 downto 0);
           o_data1  : out STD_LOGIC;
           o_data2  : out STD_LOGIC);
end DeMUX;

architecture Behavioral of DeMUX is
    
    signal p1   : std_logic;
    signal p2   : std_logic;
    
begin
    
    o_data1 <=  p1;
    o_data2 <=  p2;
    
    u_collect : process (clk) is
	begin
	    if rising_edge(clk) then
    		if SendEn = '1' then
    			case SlcPort is
    			    when "00"    => -- send all port except port_in
    			        p1  <= i_data;
    			        p2  <= i_data;
    			    when "01"    => -- in this case is port_in
    			        p1  <= p1;
    			        p2  <= p2;
    			    when "10"    => -- port 01
    			        p1  <= i_data;
    			        p2  <= p2;
    			    when "11"    => -- port 02
    			        p1  <= p1;
    			        p2  <= i_data;
    			    when others =>
    			        p1  <= p1;
    			        p2  <= p2;
    	   		    end case;
    		else
    		    p1   <= 'U';
		        p2   <= 'U';
		    end if;
		end if;
	end process u_collect;
    
end Behavioral;
