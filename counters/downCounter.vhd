library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counterB is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        cnt_en : in STD_LOGIC;
        cnt : out STD_LOGIC_VECTOR(5 downto 0)
    );
end counterB;

architecture Behavioral of counterB is
    signal divClk : STD_LOGIC;
    signal cntBuff : STD_LOGIC_VECTOR(5 downto 0);
    signal counter : STD_LOGIC_VECTOR(27 downto 0) := (others => '0');
    constant megaNum : STD_LOGIC_VECTOR(27 downto 0) := "0101111101011110000100000000";

begin
    -- Clock divider process
    process (clk)
    begin
        if rising_edge(clk) then
            counter <= counter + 1;

            if counter = conv_integer(unsigned(megaNum)) then
                counter <= (others => '0');
                divClk <= not divClk;
            end if;
        end if;
    end process;

    -- Downcounter process
    process (divClk, reset)
    begin
        if reset = '0' then
            cntBuff <= "000110";
        elsif rising_edge(divClk) and cnt_en = '1' then
            if cntBuff = "000000" then
                cntBuff <= "111111";
            else
                cntBuff <= cntBuff - 1;
            end if;
        end if;
    end process;

    cnt <= cntBuff;

end Behavioral;