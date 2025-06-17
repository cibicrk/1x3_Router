module router_sync (input clock,resetn,detect_add,full_0,full_1,full_2,empty_0,empty_1,empty_2,write_enb_reg,read_enb_0,read_enb_1,read_enb_2,
		    input [7:0]data_in,
		    output vld_out_0,vld_out_1,vld_out_2,
		    output reg [2:0] write_enb,
		    output reg soft_reset_0,soft_reset_1,soft_reset_2,fifo_full );
			
			reg [1:0]temp;
			reg [4:0]counter_0,counter_1,counter_2;

			assign vld_out_0=~empty_0;
			assign vld_out_1=~empty_1;
			assign vld_out_2=~empty_2;

			always @(posedge clock)
				begin
					if(~resetn)
						temp<=2'b00;
					else if(detect_add)
						temp<=data_in;
				end
			
			

			always@*
				begin
					case(temp)
					
						2'b00:fifo_full<=full_0;
						2'b01:fifo_full<=full_1;
						2'b10:fifo_full<=full_2;
						2'b11:fifo_full<=0;
					endcase
				end


			




			always@*
				begin
					if(write_enb_reg)
						begin
							case(temp)
						
							2'b00:write_enb<=3'b001;
							2'b01:write_enb<=3'b010;
							2'b10:write_enb<=3'b100;
							2'b11:write_enb<=3'b000;
							endcase
						end
						else
							write_enb<=3'b000;
				end
			always@(posedge clock)
				begin
					if(~resetn)
						begin
							counter_0<=0;
							soft_reset_0<=0;
						end
					else if(~read_enb_0)
						begin
							if(vld_out_0)
								begin
									if(counter_0==29)
										begin
											counter_0<=0;
											soft_reset_0<=1;
										end
									else
										begin
											counter_0<=counter_0+1'b1;
											soft_reset_0<=0;
										end
								end
							else	
								begin
						    		soft_reset_0<=0;
								counter_0<=0;
								end
						end

				end
		

			always@(posedge clock)
				begin
					if(~resetn)
						begin
							counter_1<=0;
							soft_reset_1<=0;
						end
					else if(~read_enb_1)
						begin
							if(vld_out_1)
								begin
									if(counter_1==29)
										begin
											counter_1<=0;
											soft_reset_1<=1;
										end
									else
										begin
											counter_1<=counter_1+1'b1;
											soft_reset_1<=0;
										end
								end
							else	
								begin
						     		soft_reset_1<=0;
									counter_1<=0;
								end
						end

				end
			
			always@(posedge clock)
				begin
					if(~resetn)
						begin
							counter_2<=0;
							soft_reset_2<=0;
						end
					else if(~read_enb_2)
						begin
							if(vld_out_2)
								begin
									if(counter_2==29)
										begin
											counter_2<=0;
											soft_reset_2<=1;
										end
									else
										begin
											counter_2<=counter_2+1'b1;
											soft_reset_2<=0;
										end
								end
							else	
								begin
									soft_reset_2<=0;
									counter_2<=0;
								end
						end

				end
endmodule
