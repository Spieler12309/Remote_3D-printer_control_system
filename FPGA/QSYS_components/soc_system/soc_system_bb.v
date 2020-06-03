
module soc_system (
	clk_clk,
	command_dt_external_connection_export,
	command_e0_external_connection_export,
	command_e1_external_connection_export,
	command_f_e0_external_connection_export,
	command_f_e1_external_connection_export,
	command_f_x_external_connection_export,
	command_f_y_external_connection_export,
	command_f_z_external_connection_export,
	command_t_external_connection_export,
	command_type_external_connection_export,
	command_x_external_connection_export,
	command_y_external_connection_export,
	command_z_external_connection_export,
	flags_in_external_connection_export,
	flags_out_external_connection_export,
	hps_0_f2h_cold_reset_req_reset_n,
	hps_0_f2h_debug_reset_req_reset_n,
	hps_0_f2h_stm_hw_events_stm_hwevents,
	hps_0_f2h_warm_reset_req_reset_n,
	hps_0_h2f_reset_reset_n,
	hps_0_hps_io_hps_io_emac1_inst_TX_CLK,
	hps_0_hps_io_hps_io_emac1_inst_TXD0,
	hps_0_hps_io_hps_io_emac1_inst_TXD1,
	hps_0_hps_io_hps_io_emac1_inst_TXD2,
	hps_0_hps_io_hps_io_emac1_inst_TXD3,
	hps_0_hps_io_hps_io_emac1_inst_RXD0,
	hps_0_hps_io_hps_io_emac1_inst_MDIO,
	hps_0_hps_io_hps_io_emac1_inst_MDC,
	hps_0_hps_io_hps_io_emac1_inst_RX_CTL,
	hps_0_hps_io_hps_io_emac1_inst_TX_CTL,
	hps_0_hps_io_hps_io_emac1_inst_RX_CLK,
	hps_0_hps_io_hps_io_emac1_inst_RXD1,
	hps_0_hps_io_hps_io_emac1_inst_RXD2,
	hps_0_hps_io_hps_io_emac1_inst_RXD3,
	hps_0_hps_io_hps_io_sdio_inst_CMD,
	hps_0_hps_io_hps_io_sdio_inst_D0,
	hps_0_hps_io_hps_io_sdio_inst_D1,
	hps_0_hps_io_hps_io_sdio_inst_CLK,
	hps_0_hps_io_hps_io_sdio_inst_D2,
	hps_0_hps_io_hps_io_sdio_inst_D3,
	hps_0_hps_io_hps_io_usb1_inst_D0,
	hps_0_hps_io_hps_io_usb1_inst_D1,
	hps_0_hps_io_hps_io_usb1_inst_D2,
	hps_0_hps_io_hps_io_usb1_inst_D3,
	hps_0_hps_io_hps_io_usb1_inst_D4,
	hps_0_hps_io_hps_io_usb1_inst_D5,
	hps_0_hps_io_hps_io_usb1_inst_D6,
	hps_0_hps_io_hps_io_usb1_inst_D7,
	hps_0_hps_io_hps_io_usb1_inst_CLK,
	hps_0_hps_io_hps_io_usb1_inst_STP,
	hps_0_hps_io_hps_io_usb1_inst_DIR,
	hps_0_hps_io_hps_io_usb1_inst_NXT,
	hps_0_hps_io_hps_io_spim1_inst_CLK,
	hps_0_hps_io_hps_io_spim1_inst_MOSI,
	hps_0_hps_io_hps_io_spim1_inst_MISO,
	hps_0_hps_io_hps_io_spim1_inst_SS0,
	hps_0_hps_io_hps_io_uart0_inst_RX,
	hps_0_hps_io_hps_io_uart0_inst_TX,
	hps_0_hps_io_hps_io_i2c0_inst_SDA,
	hps_0_hps_io_hps_io_i2c0_inst_SCL,
	hps_0_hps_io_hps_io_i2c1_inst_SDA,
	hps_0_hps_io_hps_io_i2c1_inst_SCL,
	hps_0_hps_io_hps_io_gpio_inst_GPIO09,
	hps_0_hps_io_hps_io_gpio_inst_GPIO35,
	hps_0_hps_io_hps_io_gpio_inst_GPIO40,
	hps_0_hps_io_hps_io_gpio_inst_GPIO53,
	hps_0_hps_io_hps_io_gpio_inst_GPIO54,
	hps_0_hps_io_hps_io_gpio_inst_GPIO61,
	hps_0_uart1_cts,
	hps_0_uart1_dsr,
	hps_0_uart1_dcd,
	hps_0_uart1_ri,
	hps_0_uart1_dtr,
	hps_0_uart1_rts,
	hps_0_uart1_out1_n,
	hps_0_uart1_out2_n,
	hps_0_uart1_rxd,
	hps_0_uart1_txd,
	max_params_0_external_connection_export,
	max_params_1_external_connection_export,
	max_params_2_external_connection_export,
	max_params_3_external_connection_export,
	max_params_4_external_connection_export,
	max_timing_0_external_connection_export,
	max_timing_1_external_connection_export,
	max_timing_2_external_connection_export,
	max_timing_3_external_connection_export,
	memory_mem_a,
	memory_mem_ba,
	memory_mem_ck,
	memory_mem_ck_n,
	memory_mem_cke,
	memory_mem_cs_n,
	memory_mem_ras_n,
	memory_mem_cas_n,
	memory_mem_we_n,
	memory_mem_reset_n,
	memory_mem_dq,
	memory_mem_dqs,
	memory_mem_dqs_n,
	memory_mem_odt,
	memory_mem_dm,
	memory_oct_rzqin,
	new_rparams_e0_0_external_connection_export,
	new_rparams_e0_1_external_connection_export,
	new_rparams_e0_2_external_connection_export,
	new_rparams_e0_3_external_connection_export,
	new_rparams_e0_4_external_connection_export,
	new_rparams_e1_0_external_connection_export,
	new_rparams_e1_1_external_connection_export,
	new_rparams_e1_2_external_connection_export,
	new_rparams_e1_3_external_connection_export,
	new_rparams_e1_4_external_connection_export,
	new_rparams_x_0_external_connection_export,
	new_rparams_x_1_external_connection_export,
	new_rparams_x_2_external_connection_export,
	new_rparams_x_3_external_connection_export,
	new_rparams_x_4_external_connection_export,
	new_rparams_y_0_external_connection_export,
	new_rparams_y_1_external_connection_export,
	new_rparams_y_2_external_connection_export,
	new_rparams_y_3_external_connection_export,
	new_rparams_y_4_external_connection_export,
	new_rparams_z_0_external_connection_export,
	new_rparams_z_1_external_connection_export,
	new_rparams_z_2_external_connection_export,
	new_rparams_z_3_external_connection_export,
	new_rparams_z_4_external_connection_export,
	params_e0_0_external_connection_export,
	params_e0_1_external_connection_export,
	params_e0_2_external_connection_export,
	params_e0_3_external_connection_export,
	params_e0_4_external_connection_export,
	params_e1_0_external_connection_export,
	params_e1_1_external_connection_export,
	params_e1_2_external_connection_export,
	params_e1_3_external_connection_export,
	params_e1_4_external_connection_export,
	params_x_0_external_connection_export,
	params_x_1_external_connection_export,
	params_x_2_external_connection_export,
	params_x_3_external_connection_export,
	params_x_4_external_connection_export,
	params_y_0_external_connection_export,
	params_y_1_external_connection_export,
	params_y_2_external_connection_export,
	params_y_3_external_connection_export,
	params_y_4_external_connection_export,
	params_z_0_external_connection_export,
	params_z_1_external_connection_export,
	params_z_2_external_connection_export,
	params_z_3_external_connection_export,
	params_z_4_external_connection_export,
	pll_sys_outclk100mhz_clk,
	pll_sys_outclk10mhz_clk,
	pll_sys_outclk1mhz_clk,
	pll_sys_outclk5mhz_clk,
	position_e0_external_connection_export,
	position_e1_external_connection_export,
	position_x_external_connection_export,
	position_y_external_connection_export,
	position_z_external_connection_export,
	reset_reset_n,
	settings_acceleration_e0_external_connection_export,
	settings_acceleration_e1_external_connection_export,
	settings_acceleration_x_external_connection_export,
	settings_acceleration_y_external_connection_export,
	settings_acceleration_z_external_connection_export,
	settings_jerk_e0_external_connection_export,
	settings_jerk_e1_external_connection_export,
	settings_jerk_x_external_connection_export,
	settings_jerk_y_external_connection_export,
	settings_jerk_z_external_connection_export,
	settings_max_speed_e0_external_connection_export,
	settings_max_speed_e1_external_connection_export,
	settings_max_speed_x_external_connection_export,
	settings_max_speed_y_external_connection_export,
	settings_max_speed_z_external_connection_export,
	settings_max_temp_bed_external_connection_export,
	settings_max_temp_e0_external_connection_export,
	settings_max_temp_e1_external_connection_export,
	step_e0_now_external_connection_export,
	step_e1_now_external_connection_export,
	step_x_now_external_connection_export,
	step_y_now_external_connection_export,
	step_z_now_external_connection_export,
	temp_0_external_connection_export,
	temp_1_external_connection_export,
	temp_2_external_connection_export,
	timing_e0_0_external_connection_export,
	timing_e0_1_external_connection_export,
	timing_e0_2_external_connection_export,
	timing_e0_3_external_connection_export,
	timing_e1_0_external_connection_export,
	timing_e1_1_external_connection_export,
	timing_e1_2_external_connection_export,
	timing_e1_3_external_connection_export,
	timing_x_0_external_connection_export,
	timing_x_1_external_connection_export,
	timing_x_2_external_connection_export,
	timing_x_3_external_connection_export,
	timing_y_0_external_connection_export,
	timing_y_1_external_connection_export,
	timing_y_2_external_connection_export,
	timing_y_3_external_connection_export,
	timing_z_0_external_connection_export,
	timing_z_1_external_connection_export,
	timing_z_2_external_connection_export,
	timing_z_3_external_connection_export);	

	input		clk_clk;
	output	[11:0]	command_dt_external_connection_export;
	output	[31:0]	command_e0_external_connection_export;
	output	[31:0]	command_e1_external_connection_export;
	output	[31:0]	command_f_e0_external_connection_export;
	output	[31:0]	command_f_e1_external_connection_export;
	output	[31:0]	command_f_x_external_connection_export;
	output	[31:0]	command_f_y_external_connection_export;
	output	[31:0]	command_f_z_external_connection_export;
	output	[11:0]	command_t_external_connection_export;
	output	[31:0]	command_type_external_connection_export;
	output	[31:0]	command_x_external_connection_export;
	output	[31:0]	command_y_external_connection_export;
	output	[31:0]	command_z_external_connection_export;
	input	[31:0]	flags_in_external_connection_export;
	output	[31:0]	flags_out_external_connection_export;
	input		hps_0_f2h_cold_reset_req_reset_n;
	input		hps_0_f2h_debug_reset_req_reset_n;
	input	[27:0]	hps_0_f2h_stm_hw_events_stm_hwevents;
	input		hps_0_f2h_warm_reset_req_reset_n;
	output		hps_0_h2f_reset_reset_n;
	output		hps_0_hps_io_hps_io_emac1_inst_TX_CLK;
	output		hps_0_hps_io_hps_io_emac1_inst_TXD0;
	output		hps_0_hps_io_hps_io_emac1_inst_TXD1;
	output		hps_0_hps_io_hps_io_emac1_inst_TXD2;
	output		hps_0_hps_io_hps_io_emac1_inst_TXD3;
	input		hps_0_hps_io_hps_io_emac1_inst_RXD0;
	inout		hps_0_hps_io_hps_io_emac1_inst_MDIO;
	output		hps_0_hps_io_hps_io_emac1_inst_MDC;
	input		hps_0_hps_io_hps_io_emac1_inst_RX_CTL;
	output		hps_0_hps_io_hps_io_emac1_inst_TX_CTL;
	input		hps_0_hps_io_hps_io_emac1_inst_RX_CLK;
	input		hps_0_hps_io_hps_io_emac1_inst_RXD1;
	input		hps_0_hps_io_hps_io_emac1_inst_RXD2;
	input		hps_0_hps_io_hps_io_emac1_inst_RXD3;
	inout		hps_0_hps_io_hps_io_sdio_inst_CMD;
	inout		hps_0_hps_io_hps_io_sdio_inst_D0;
	inout		hps_0_hps_io_hps_io_sdio_inst_D1;
	output		hps_0_hps_io_hps_io_sdio_inst_CLK;
	inout		hps_0_hps_io_hps_io_sdio_inst_D2;
	inout		hps_0_hps_io_hps_io_sdio_inst_D3;
	inout		hps_0_hps_io_hps_io_usb1_inst_D0;
	inout		hps_0_hps_io_hps_io_usb1_inst_D1;
	inout		hps_0_hps_io_hps_io_usb1_inst_D2;
	inout		hps_0_hps_io_hps_io_usb1_inst_D3;
	inout		hps_0_hps_io_hps_io_usb1_inst_D4;
	inout		hps_0_hps_io_hps_io_usb1_inst_D5;
	inout		hps_0_hps_io_hps_io_usb1_inst_D6;
	inout		hps_0_hps_io_hps_io_usb1_inst_D7;
	input		hps_0_hps_io_hps_io_usb1_inst_CLK;
	output		hps_0_hps_io_hps_io_usb1_inst_STP;
	input		hps_0_hps_io_hps_io_usb1_inst_DIR;
	input		hps_0_hps_io_hps_io_usb1_inst_NXT;
	output		hps_0_hps_io_hps_io_spim1_inst_CLK;
	output		hps_0_hps_io_hps_io_spim1_inst_MOSI;
	input		hps_0_hps_io_hps_io_spim1_inst_MISO;
	output		hps_0_hps_io_hps_io_spim1_inst_SS0;
	input		hps_0_hps_io_hps_io_uart0_inst_RX;
	output		hps_0_hps_io_hps_io_uart0_inst_TX;
	inout		hps_0_hps_io_hps_io_i2c0_inst_SDA;
	inout		hps_0_hps_io_hps_io_i2c0_inst_SCL;
	inout		hps_0_hps_io_hps_io_i2c1_inst_SDA;
	inout		hps_0_hps_io_hps_io_i2c1_inst_SCL;
	inout		hps_0_hps_io_hps_io_gpio_inst_GPIO09;
	inout		hps_0_hps_io_hps_io_gpio_inst_GPIO35;
	inout		hps_0_hps_io_hps_io_gpio_inst_GPIO40;
	inout		hps_0_hps_io_hps_io_gpio_inst_GPIO53;
	inout		hps_0_hps_io_hps_io_gpio_inst_GPIO54;
	inout		hps_0_hps_io_hps_io_gpio_inst_GPIO61;
	input		hps_0_uart1_cts;
	input		hps_0_uart1_dsr;
	input		hps_0_uart1_dcd;
	input		hps_0_uart1_ri;
	output		hps_0_uart1_dtr;
	output		hps_0_uart1_rts;
	output		hps_0_uart1_out1_n;
	output		hps_0_uart1_out2_n;
	input		hps_0_uart1_rxd;
	output		hps_0_uart1_txd;
	input	[31:0]	max_params_0_external_connection_export;
	input	[31:0]	max_params_1_external_connection_export;
	input	[31:0]	max_params_2_external_connection_export;
	input	[31:0]	max_params_3_external_connection_export;
	input	[31:0]	max_params_4_external_connection_export;
	input	[31:0]	max_timing_0_external_connection_export;
	input	[31:0]	max_timing_1_external_connection_export;
	input	[31:0]	max_timing_2_external_connection_export;
	input	[31:0]	max_timing_3_external_connection_export;
	output	[14:0]	memory_mem_a;
	output	[2:0]	memory_mem_ba;
	output		memory_mem_ck;
	output		memory_mem_ck_n;
	output		memory_mem_cke;
	output		memory_mem_cs_n;
	output		memory_mem_ras_n;
	output		memory_mem_cas_n;
	output		memory_mem_we_n;
	output		memory_mem_reset_n;
	inout	[31:0]	memory_mem_dq;
	inout	[3:0]	memory_mem_dqs;
	inout	[3:0]	memory_mem_dqs_n;
	output		memory_mem_odt;
	output	[3:0]	memory_mem_dm;
	input		memory_oct_rzqin;
	input	[31:0]	new_rparams_e0_0_external_connection_export;
	input	[31:0]	new_rparams_e0_1_external_connection_export;
	input	[31:0]	new_rparams_e0_2_external_connection_export;
	input	[31:0]	new_rparams_e0_3_external_connection_export;
	input	[31:0]	new_rparams_e0_4_external_connection_export;
	input	[31:0]	new_rparams_e1_0_external_connection_export;
	input	[31:0]	new_rparams_e1_1_external_connection_export;
	input	[31:0]	new_rparams_e1_2_external_connection_export;
	input	[31:0]	new_rparams_e1_3_external_connection_export;
	input	[31:0]	new_rparams_e1_4_external_connection_export;
	input	[31:0]	new_rparams_x_0_external_connection_export;
	input	[31:0]	new_rparams_x_1_external_connection_export;
	input	[31:0]	new_rparams_x_2_external_connection_export;
	input	[31:0]	new_rparams_x_3_external_connection_export;
	input	[31:0]	new_rparams_x_4_external_connection_export;
	input	[31:0]	new_rparams_y_0_external_connection_export;
	input	[31:0]	new_rparams_y_1_external_connection_export;
	input	[31:0]	new_rparams_y_2_external_connection_export;
	input	[31:0]	new_rparams_y_3_external_connection_export;
	input	[31:0]	new_rparams_y_4_external_connection_export;
	input	[31:0]	new_rparams_z_0_external_connection_export;
	input	[31:0]	new_rparams_z_1_external_connection_export;
	input	[31:0]	new_rparams_z_2_external_connection_export;
	input	[31:0]	new_rparams_z_3_external_connection_export;
	input	[31:0]	new_rparams_z_4_external_connection_export;
	input	[31:0]	params_e0_0_external_connection_export;
	input	[31:0]	params_e0_1_external_connection_export;
	input	[31:0]	params_e0_2_external_connection_export;
	input	[31:0]	params_e0_3_external_connection_export;
	input	[31:0]	params_e0_4_external_connection_export;
	input	[31:0]	params_e1_0_external_connection_export;
	input	[31:0]	params_e1_1_external_connection_export;
	input	[31:0]	params_e1_2_external_connection_export;
	input	[31:0]	params_e1_3_external_connection_export;
	input	[31:0]	params_e1_4_external_connection_export;
	input	[31:0]	params_x_0_external_connection_export;
	input	[31:0]	params_x_1_external_connection_export;
	input	[31:0]	params_x_2_external_connection_export;
	input	[31:0]	params_x_3_external_connection_export;
	input	[31:0]	params_x_4_external_connection_export;
	input	[31:0]	params_y_0_external_connection_export;
	input	[31:0]	params_y_1_external_connection_export;
	input	[31:0]	params_y_2_external_connection_export;
	input	[31:0]	params_y_3_external_connection_export;
	input	[31:0]	params_y_4_external_connection_export;
	input	[31:0]	params_z_0_external_connection_export;
	input	[31:0]	params_z_1_external_connection_export;
	input	[31:0]	params_z_2_external_connection_export;
	input	[31:0]	params_z_3_external_connection_export;
	input	[31:0]	params_z_4_external_connection_export;
	output		pll_sys_outclk100mhz_clk;
	output		pll_sys_outclk10mhz_clk;
	output		pll_sys_outclk1mhz_clk;
	output		pll_sys_outclk5mhz_clk;
	input	[11:0]	position_e0_external_connection_export;
	input	[11:0]	position_e1_external_connection_export;
	input	[11:0]	position_x_external_connection_export;
	input	[11:0]	position_y_external_connection_export;
	input	[11:0]	position_z_external_connection_export;
	input		reset_reset_n;
	output	[31:0]	settings_acceleration_e0_external_connection_export;
	output	[31:0]	settings_acceleration_e1_external_connection_export;
	output	[31:0]	settings_acceleration_x_external_connection_export;
	output	[31:0]	settings_acceleration_y_external_connection_export;
	output	[31:0]	settings_acceleration_z_external_connection_export;
	output	[31:0]	settings_jerk_e0_external_connection_export;
	output	[31:0]	settings_jerk_e1_external_connection_export;
	output	[31:0]	settings_jerk_x_external_connection_export;
	output	[31:0]	settings_jerk_y_external_connection_export;
	output	[31:0]	settings_jerk_z_external_connection_export;
	output	[31:0]	settings_max_speed_e0_external_connection_export;
	output	[31:0]	settings_max_speed_e1_external_connection_export;
	output	[31:0]	settings_max_speed_x_external_connection_export;
	output	[31:0]	settings_max_speed_y_external_connection_export;
	output	[31:0]	settings_max_speed_z_external_connection_export;
	output	[11:0]	settings_max_temp_bed_external_connection_export;
	output	[11:0]	settings_max_temp_e0_external_connection_export;
	output	[11:0]	settings_max_temp_e1_external_connection_export;
	input	[31:0]	step_e0_now_external_connection_export;
	input	[31:0]	step_e1_now_external_connection_export;
	input	[31:0]	step_x_now_external_connection_export;
	input	[31:0]	step_y_now_external_connection_export;
	input	[31:0]	step_z_now_external_connection_export;
	input	[11:0]	temp_0_external_connection_export;
	input	[11:0]	temp_1_external_connection_export;
	input	[11:0]	temp_2_external_connection_export;
	input	[31:0]	timing_e0_0_external_connection_export;
	input	[31:0]	timing_e0_1_external_connection_export;
	input	[31:0]	timing_e0_2_external_connection_export;
	input	[31:0]	timing_e0_3_external_connection_export;
	input	[31:0]	timing_e1_0_external_connection_export;
	input	[31:0]	timing_e1_1_external_connection_export;
	input	[31:0]	timing_e1_2_external_connection_export;
	input	[31:0]	timing_e1_3_external_connection_export;
	input	[31:0]	timing_x_0_external_connection_export;
	input	[31:0]	timing_x_1_external_connection_export;
	input	[31:0]	timing_x_2_external_connection_export;
	input	[31:0]	timing_x_3_external_connection_export;
	input	[31:0]	timing_y_0_external_connection_export;
	input	[31:0]	timing_y_1_external_connection_export;
	input	[31:0]	timing_y_2_external_connection_export;
	input	[31:0]	timing_y_3_external_connection_export;
	input	[31:0]	timing_z_0_external_connection_export;
	input	[31:0]	timing_z_1_external_connection_export;
	input	[31:0]	timing_z_2_external_connection_export;
	input	[31:0]	timing_z_3_external_connection_export;
endmodule
