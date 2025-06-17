module router_fsm(input clock,resetn,pkt_valid,
		  input [7:0]data_in,
		  input fifo_full,empty_0,empty_1,empty_2,soft_reset_0,soft_reset_1,soft_reset_2,parity_done,low_packet_valid,
		  output write_enb_reg,detect_add,ld_state,laf_state,lfd_state,full_state,rst_int_reg,busy);

		parameter
		DECODE_ADDRESS=8'b00000001,
		LOAD_FIRST_DATA=8'b00000010,
		LOAD_DATA=8'b00000100,
		LOAD_PARITY=8'b00001000,
		FIFO_FULL_STATE=8'b00010000,
		LOAD_AFTER_FULL=8'b00100000,
		WAIT_TILL_EMPTY=8'b01000000,
		CHECK_PARITY_ERROR=8'b10000000;

		reg [7:0] state,next_state;

always@(posedge clock)
begin
	if(~resetn)
	
		begin
			state<=DECODE_ADDRESS;	
		end
	
	else if((soft_reset_0)||(soft_reset_1)||(soft_reset_2))
		begin
			state<=DECODE_ADDRESS;
		end
	else
	
		begin
			state<=next_state;
		end
	end

always@*
	begin
		next_state=DECODE_ADDRESS;
			case(state)
				
					DECODE_ADDRESS:
								if((pkt_valid&&(data_in[1:0]==2'b00)&&empty_0)||(pkt_valid&&(data_in[1:0]==2'b01)&&empty_1)||(pkt_valid&&(data_in[1:0]==2'b10)&&empty_2))
									next_state=LOAD_FIRST_DATA;
							    	else if((pkt_valid&&(data_in[1:0]==2'b00)&&~empty_0)||(pkt_valid&&(data_in[1:0]==2'b01)&&~empty_1)||(pkt_valid&&(data_in[1:0]==2'b10)&&~empty_2))
									next_state=WAIT_TILL_EMPTY;
	

						       else
									next_state=DECODE_ADDRESS;
										

					LOAD_FIRST_DATA:next_state=LOAD_DATA;
					LOAD_DATA:
							if(fifo_full==1)
								next_state=FIFO_FULL_STATE;
							else if(fifo_full==0&&pkt_valid==0)
								next_state=LOAD_PARITY;
							else
								next_state=LOAD_DATA;
						  
					LOAD_PARITY:next_state=CHECK_PARITY_ERROR;
					FIFO_FULL_STATE:
								if(fifo_full==0)
									next_state=LOAD_AFTER_FULL;
								else
									next_state=FIFO_FULL_STATE;
								
							
					LOAD_AFTER_FULL:
					
								if(parity_done==1)
									next_state=DECODE_ADDRESS;
								else if(parity_done==0&&low_packet_valid==1)
									next_state=LOAD_PARITY;
								else if(parity_done==0&&low_packet_valid==0)
									next_state=LOAD_DATA;

							
					WAIT_TILL_EMPTY:
								if(empty_0||empty_1||empty_2)
									next_state=LOAD_FIRST_DATA;
								else if((~empty_0)||(~empty_1)||(~empty_2))
									next_state=WAIT_TILL_EMPTY;

							
					CHECK_PARITY_ERROR:
								if(fifo_full==1)
									next_state=FIFO_FULL_STATE;
							  	else if(fifo_full==0)
									next_state=DECODE_ADDRESS;
					endcase					
				
	end
		

	assign write_enb_reg=((state==LOAD_DATA)||(state==LOAD_PARITY)||(state==LOAD_AFTER_FULL))?1'b1:1'b0;
	assign detect_add=(state==(DECODE_ADDRESS))?1'b1:1'b0;
	assign ld_state=(state==(LOAD_DATA))?1'b1:1'b0;
	assign laf_state=(state==(LOAD_AFTER_FULL))?1'b1:1'b0;
	assign lfd_state=(state==(LOAD_FIRST_DATA))?1'b1:1'b0;
	assign full_state=(state==(FIFO_FULL_STATE))?1'b1:1'b0;
	assign rst_int_reg=(state==(CHECK_PARITY_ERROR))?1'b1:1'b0;
	assign busy=((state==LOAD_FIRST_DATA)||(state==LOAD_PARITY)||(state==CHECK_PARITY_ERROR)||(state==FIFO_FULL_STATE)||(state==LOAD_AFTER_FULL)||(state==WAIT_TILL_EMPTY))?1'b1:1'b0;
endmodule
