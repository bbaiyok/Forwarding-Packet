----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:03:15 02/24/2025 
-- Design Name: 
-- Module Name:    MacTable - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MacTable is
	generic (
        MAC1        : std_logic_vector(47 downto 0) := X"11AA22BB33DD"; -- MAC 1
        MAC2        : std_logic_vector(47 downto 0) := X"AABBCCDDEEFF"; -- MAC 2
        MAC3        : std_logic_vector(47 downto 0) := X"112233445566"  -- MAC 3
		);
    port (
        clk         : in std_logic;
        rst         : in std_logic;
        mac_in      : in std_logic_vector(47 downto 0);
        port_out    : out std_logic_vector(1 downto 0) 
    );
end MacTable;

architecture Behavioral of MacTable is

begin
	
	u_maccompare : process(clk)is
    begin
        if rising_edge(clk) then
            if rst = '0' then
                port_out <= "00";
            else
				if mac_in = MAC1 then
				    port_out <= "01";
			    elsif mac_in = MAC2 then 
			        port_out <= "10";
			    elsif mac_in = MAC3 then 
			        port_out <= "11";
			    else
			        port_out <= "00";
				end if;
            end if;
        end if;
    end process;
    
end Behavioral;

