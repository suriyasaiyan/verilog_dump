----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.09.2023 22:36:54
-- Design Name: 
-- Module Name: leftrotatevhdlbychatgpt - Behavioral
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

entity leftrotatevhdlbychatgpt is
    Port (
        data_in : in STD_LOGIC_VECTOR(31 downto 0);
        shift_amount : in STD_LOGIC_VECTOR(4 downto 0);
        data_out : out STD_LOGIC_VECTOR(31 downto 0)
    );
end leftrotatevhdlbychatgpt;

architecture Behavioral of leftrotatevhdlbychatgpt is
    signal temp_data : STD_LOGIC_VECTOR(31 downto 0);
begin
    temp_data <= data_in(31 - conv_integer(unsigned(shift_amount)) downto 0) & data_in(31 downto 32 - conv_integer(unsigned(shift_amount)));
    data_out <= temp_data;
end Behavioral;
