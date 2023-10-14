----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.09.2023 22:58:13
-- Design Name: 
-- Module Name: rightrotatevhdlbychatgpt - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity rightrotatevhdlbychatgpt is
   Port (
       data_in : in STD_LOGIC_VECTOR(31 downto 0);
       shift_amount : in STD_LOGIC_VECTOR(4 downto 0);
       data_out : out STD_LOGIC_VECTOR(31 downto 0)
   );
end rightrotatevhdlbychatgpt;

architecture Behavioral of rightrotatevhdlbychatgpt is
begin
   process(data_in, shift_amount)
   variable temp_data : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
   begin
       for i in 0 to 31 loop
           temp_data(i) := data_in((i + conv_integer(unsigned(shift_amount))) mod 32);
       end loop;
       data_out <= temp_data;
   end process;
end Behavioral;





