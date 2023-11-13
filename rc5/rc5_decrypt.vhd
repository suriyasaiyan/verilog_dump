library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rc5_decryption is
    Port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        d_in : in STD_LOGIC_VECTOR(63 downto 0);
        d_out : out STD_LOGIC_VECTOR(63 downto 0)
    );
end rc5_decryption;

architecture Behavioral of rc5_decryption is
    constant WORD_SIZE : integer := 32;
    constant NUM_ROUNDS : integer := 12;

    type key_rom_type is array (0 to 2*NUM_ROUNDS+1) of STD_LOGIC_VECTOR(WORD_SIZE-1 downto 0);
    signal key_rom : key_rom_type := (
        "00000000000000000000000000000000", "00000000000000000000000000000000", -- 0, 1
        X"46F8E8C5", X"460C6085", X"70F83B8A", X"284B8303", X"513E1454", X"F621ED22",
        X"3125065D", X"11A83A5D", X"D427686B", X"713AD82D", X"4B792F99", X"2799A4DD",
        X"A7901C49", X"DEDE871A", X"36C03196", X"A7EFC249", X"61A78BB8", X"3B0A1D2B",
        X"4DBFCA76", X"AE162167", X"30D76B0A", X"43192304", X"F6CC1431", X"65046380"
    );

    type state_type is (IDLE, INIT, DECRYPT, DONE);
    signal state : state_type := IDLE;
    signal A, B, tempA, tempB : STD_LOGIC_VECTOR(31 downto 0);
    signal round_counter : integer range 0 to NUM_ROUNDS;

    function rotate_right(value : STD_LOGIC_VECTOR; shift : integer) return STD_LOGIC_VECTOR is
    begin
        return value(shift-1 downto 0) & value(31 downto shift);
    end function;

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state <= IDLE;
            else
                case state is
                    when IDLE =>
                        if rst = '0' then
                            state <= INIT;
                        end if;

                    when INIT =>
                        A <= d_in(63 downto 32);
                        B <= d_in(31 downto 0);
                        round_counter <= NUM_ROUNDS;
                        state <= DECRYPT;

                    when DECRYPT =>
                        if round_counter > 0 then
                            tempB <= std_logic_vector(unsigned(B) - unsigned(key_rom(2 * round_counter + 1)));
                            B <= rotate_right(tempB, to_integer(unsigned(A(4 downto 0)))) xor A;

                            tempA <= std_logic_vector(unsigned(A) - unsigned(key_rom(2 * round_counter)));
                            A <= rotate_right(tempA, to_integer(unsigned(B(4 downto 0)))) xor B;

                            round_counter <= round_counter - 1;
                        else
                            state <= DONE;
                        end if;

                    when DONE =>
                        d_out <= A & B;
                        state <= IDLE;

                    when others =>
                        state <= IDLE;
                end case;
            end if;
        end if;
    end process;
end Behavioral;
