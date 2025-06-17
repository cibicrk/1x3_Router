module router_reg(input clock,resetn,pkt_valid,fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg,
		  input [7:0]data_in,
                  output reg err,parity_done,low_packet_valid,
		  output reg [7:0]dout);
	       
			reg [7:0] header_reg,full_state_reg,internal_parity,temp_parity;


always@(posedge clock)
	begin
		if(~resetn)
			begin
				dout<=0;
				
				header_reg<=0;
				full_state_reg<=0;
			end
		else if(detect_add&&pkt_valid && data_in[1:0] != 2'b11)
			header_reg<=data_in;
		else if(lfd_state)
			dout<=header_reg;
		else if  (ld_state&&fifo_full==1'b0)
			dout<=data_in;
		else if(ld_state&&fifo_full)
			full_state_reg<=data_in;
		else if(laf_state)
			dout<=full_state_reg;	
	
		
	end

always@(posedge clock) // parity done
	begin
		if(~resetn||detect_add)
		parity_done<=0;
		else if((ld_state&&~fifo_full&&~pkt_valid)||(laf_state&&low_packet_valid&&parity_done==1'b0))
		parity_done<=1;
		//else
		//parity_done<=0;
	end		
always@(posedge clock) //loddw_packet_valid
	begin
		if(~resetn)
		low_packet_valid=1'b0;
		else if(ld_state&&pkt_valid)
		low_packet_valid=1'b1;
		else if(rst_int_reg) 
		low_packet_valid=1'b0;
	end
always@(posedge clock) //internal_parity
	begin
		if(~resetn||detect_add)
		internal_parity<=0;
		else if(lfd_state&&pkt_valid)
		internal_parity<=internal_parity^header_reg;
		else if(ld_state&&pkt_valid&&~full_state)
		internal_parity<=internal_parity^data_in;
	
	end

always@(posedge clock) // temp_parity
	begin
		if(~resetn)
	temp_parity<=0;
		else if(ld_state&&~pkt_valid)
	temp_parity<=data_in;
	end

always@(posedge clock)// error
	begin
		if(~resetn)
		err=1'b0;
		else if(parity_done)
			begin
				if(temp_parity==internal_parity)
					err=1'b0;
				else
					err=1'b1;
			end
	end
endmodule
