----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:32:09 09/18/2024 
-- Design Name: 
-- Module Name:    datagen - Behavioral 
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

entity datagen is
	generic (
			PayloadBytes	: integer := 46;
			MACDest			: STD_LOGIC_VECTOR 	( 47 downto 0 ) 	:= x"AABBCCDDEEFF" ;
			MACSource		: STD_LOGIC_VECTOR 	( 47 downto 0 ) 	:= x"A82FD9B56C98" 
	);
    Port ( 	clk         : in  STD_LOGIC;
			rst         : in  STD_LOGIC;
			sw_start    : in  STD_LOGIC;
			o_data      : out STD_LOGIC);
end datagen;

architecture Behavioral of datagen is
----------------------------------------------------------------------------------
-- signal label
----------------------------------------------------------------------------------

constant	PL_Size			: integer 	:=	PayloadBytes*8;				
constant	Frame_Size		: integer	:=	(26*8)+PL_Size;

constant	preamble		: STD_LOGIC_VECTOR 	( 55 downto 0 ) 			:= x"55555555555555" ;
constant	SFD				: STD_LOGIC_VECTOR 	( 7 downto 0 ) 				:= x"D5" ;
constant	payload_length	: STD_LOGIC_VECTOR 	( 15 downto 0 ) 			:= conv_std_logic_vector(PayloadBytes, 16) ;
constant	payload			: STD_LOGIC_VECTOR 	( PL_Size-1 downto 0 )      := x"58ec28b0343668e8aabb687b29ef0252a3cb5ae3f8720048985716672624fe102658b7186d03929b70d3ceafdf91";	-- 100 bytes
constant	CRC				: STD_LOGIC_VECTOR 	( 31 downto 0 ) 			:= x"6BD11C40" ;

-- 46 bytes x"5cfb37afe8609d964920400d1358768231a869c3c0b2778724cbdb28b89e038dd1235d42ffdb8669af66f23f2fe3";
-- 100 bytes x"58ec28b0343668e8aabb687b29ef0252a3cb5ae3f8720048985716672624fe102658b7186d03929b70d3ceafdf91294bd017b8431eb70fbf63f4fcc41c1209b9fb6c10e6e997ab17aad10ef3c8de8d4ab01707d9a0935713dcfe6280d972a35853f64893";
-- 1500 bytes x"8c4b97de16680ea5d94352253d95cd023259c05c10a35cd4bf771a48264ad64350c95552532dfcccf8bcc18c173e9b005504f589e304012793cc424e994afdca30d4b7f1c2433fb469d1d7441f0a5afea2dd2c9ad1095729867b55688c72327a1db521b9060038bc6a2d527be9a995caaed54212b8045a9b1f79e3d68065ca47d1353f091a8a79aacfc16307d37999053550730e6111d3fa34121ec0b0288f52df2d297027feee41591b3b6e2d993ca26d201703d8f885a2a28a3cddae34f789d8f6338582a2b878e04c94f40661ac1ea86e2004b1f9c5276f23f3463822bc47079eb0221e7299d85c94615b89a346c48db7a48e18716dd9630816f2ffba01bea69d82bac574dd20f5957cf766187346ae1371d24afa78aa04b025cd01cbb04fd77da82987b2cfb609c3acfca4de32f22be10cdb6bbfdf69c627c0a84f7bf31130e5bea17fef3027091e4c5f71e1aed3316db4b9e903f368044214e24385d6669da7f75e8152aea03927381b23515a68419cf211deb8f7a6af1464c5dab6c49c9c4377260f2f9a8eedba714e5ba91bfa849deb5fc06dfa14256e67da13ca9c575d6aa369b59acd680c60c98944324916beb99d392b07f73cd94104ecb93a8635c2556536bff5bbf4d5077b55ad423453fc8c87d2aaed8f4f68ad68643142fe846826c8cf7c29e67adf4aeffa2abefa03e5cb92742d482dd832a73b82ceba8e9aa43381c8df04c33c88c7da57d5209390a490e71c7f73de1c6582455b5077c4f2c3c1b06cf7762276884c38c10fe4ff98e11d3ade7bbe54f4f67044b94c6754cc4aa723af87368da78ff9d757dbd2ce281af6eed35aceb6a069b23709d2138c3fdf0c26dbca25fd9999c3abf70e49bb2ad13d77c87d4b3b38bd798a15b04f245e8454449d316ae2b9859d1ec75d3c62d61e452e64e834da2d7c90068e0106a357840ee82f5795e130352a14aad625a13be466474e023874e2079aae24a46a708964ae6ce61cf5130027600170e240f63d413159d9ca5f19a272f849f894cf89593ffd98a025d26644a6c8e683dda8aae7d4d15a793227fa7e63f24a0df18e6aba12efd23ab90b3bfa015bc44f51f3da3692ce50d83f34a2edb9ff68e7b5ffa5279b4488a9d21ce01fd2c7848b6052dcfa90c6319cc24f399a446ee49070812343ceffd653d87a6aacd42ce768858ae22e4daf0b0c1b0fa09c26a432755ea1bcc4185a61762eecc0898d08ee4f3b2b9418fbe0bb050bd15963a82faf86e1544959aeb50797fc3be3e33f59dd98190618173f2f13e5363c0340cabb8ff133a5875de382d5d8fc44199922196ec2bb511e3b5321e64dff1afb4cf86bfdb1ed578aad745f988054b2ac3fd6d5f56200324287d5fd7b8e789a6c163ea62c8f67e6e11596595aadacc2846eee9e698841f107a9a38525442c01c09522043864a019fbffcfb085e1ac298a9c80c91fd3528d32b23bd662bda52d808c4600ce4a4b0cd97221bd8d2dea271c40befcf4b380a83873842a8f14da06af25d1694c91e1c59817ec869dbea35e2a874d3853880f1c97413881ab8de79cc5517267e966708caa6716e714c80dc04d53ee624280556063aa21e8d31361f6ed74c4e4e5b811b2f199286302148c92354865cad3b5f27ce5d0e4fd0fb7efa91bb94ca219dbbe01b341eb81a63c4b5baf07c24549f1ef1c6a74320fb77555a6bab6497875657f8a5fe67d64691c7ee33d6381615db5db41f84c87f2c17cd4f772ebda8dac04359ad21cbe05ce76acd8739fd1cf2fa46f03c14e7d986dfe0a33a9e1e5fb46636a603e54aeb83a0c94d24523dd933ab8f21794414e2c388b3d42bbf5c82a953a2d3af977d38c59c7ca0068e1e552f37752b355c33db84c65a91021ccdb28f5fa9669f89e99c893480529a9d4fab0d284c2fd1c7e7cb4a16e681a86e11745566914216862d77f0bdf1f9cf0b2edc85a1544b6adb6f49987bf71b1b4c2d7ca6476113e0ba9e70c60286d66c3be864498912c06072ff6bdc7fb5ba1fc895d6386c3af93a7be635da1fc787dbacd74e8a7ed31e6e08b9c2d7b7fb845f82501d85a6f162e36c4211c56fc844d2dc107446d73293e9996218e32c984c9e39dad7534f2";

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

