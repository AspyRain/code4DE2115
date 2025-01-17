	component demo1_helloworld is
		port (
			clk_clk       : in  std_logic := 'X'; -- clk
			reset_reset_n : in  std_logic := 'X'; -- reset_n
			uart_rxd      : in  std_logic := 'X'; -- rxd
			uart_txd      : out std_logic         -- txd
		);
	end component demo1_helloworld;

	u0 : component demo1_helloworld
		port map (
			clk_clk       => CONNECTED_TO_clk_clk,       --   clk.clk
			reset_reset_n => CONNECTED_TO_reset_reset_n, -- reset.reset_n
			uart_rxd      => CONNECTED_TO_uart_rxd,      --  uart.rxd
			uart_txd      => CONNECTED_TO_uart_txd       --      .txd
		);

