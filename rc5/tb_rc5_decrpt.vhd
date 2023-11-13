library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rc5_decryption_tb is

end rc5_decryption_tb;

architecture behavior of rc5_decryption_tb is 

    component rc5_decryption
        Port (
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            d_in : in STD_LOGIC_VECTOR(63 downto 0);
            d_out : out STD_LOGIC_VECTOR(63 downto 0)
        );
    end component;

    -- Inputs
    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '1';
    signal d_in : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');

    -- Outputs
    signal d_out : STD_LOGIC_VECTOR(63 downto 0);

    -- Clock period definition
    constant clk_period : time := 10 ns;

begin
 
    uut: rc5_decryption 
        port map (
            clk => clk,
            rst => rst,
            d_in => d_in,
            d_out => d_out
        );

  
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;


    stim_proc: process
    begin

        rst <= '1'; -- reset
        d_in <= (others => '0');
        wait for clk_period * 2;

        rst <= '0'; 
        d_in <= x"186778e155e06292"; -- set input data
        wait for clk_period * 10;

        assert d_out = x"1111111111111111"
        report "Test failed: Output does not match expected value."
        severity error;

        wait;
    end process;

end behavior;
