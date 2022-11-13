ALTASMI_inst : ALTASMI PORT MAP (
		addr	 => addr_sig,
		clkin	 => clkin_sig,
		datain	 => datain_sig,
		rden	 => rden_sig,
		read	 => read_sig,
		reset	 => reset_sig,
		wren	 => wren_sig,
		write	 => write_sig,
		busy	 => busy_sig,
		data_valid	 => data_valid_sig,
		dataout	 => dataout_sig,
		illegal_write	 => illegal_write_sig
	);
