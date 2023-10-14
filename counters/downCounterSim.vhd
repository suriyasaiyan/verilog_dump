library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counterBsim is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        cnt_en : in STD_LOGIC;
        cnt : out STD_LOGIC_VECTOR(5 downto 0)
    );
end counterBsim;

architecture Behavioral of counterBsim is

    signal cntBuff : STD_LOGIC_VECTOR(5 downto 0);
    
    begin 
 
    process (clk, reset)
    begin
        if reset = '0' then
            cntBuff <= "000110";
        elsif rising_edge(clk) and cnt_en = '1' then
            if cntBuff = "000000" then
                cntBuff <= "111111";
            else
                cntBuff <= cntBuff - 1;
            end if;
        end if;
    end process;

    cnt <= cntBuff;

end Behavioral;