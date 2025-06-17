module router_fifo(clock,resetn,soft_reset,write_enb,read_enb,lfd_state,data_in,full,empty,data_out);
parameter WIDTH=9,
	  DEPTH=16,
	  ADDR=5;
input clock,resetn,soft_reset,write_enb,read_enb,lfd_state;
reg [ADDR-1:0]wr_ptr,rd_ptr;
input [WIDTH-2:0]data_in;
output full,empty;
output reg [WIDTH-2:0]data_out;
reg [5:0]counter;
reg [WIDTH-1:0]mem[DEPTH-1:0];
integer i;
always@(posedge clock)//output logic
	begin
		if(~resetn)
			data_out<=0;
		else if(soft_reset)
			data_out<=8'bz;
		else if(counter==0 && data_out!=0)
			data_out<=8'bz;
		else if(read_enb && ~empty)
			data_out<=mem[rd_ptr[3:0]][7:0];
	end
always@(posedge clock)//memory read and write logic
	begin
		if(~resetn)
		begin
			for(i=0;i<16;i=i+1)
				mem[i]<=0;
				end

		else if(write_enb && ~full)
			begin
				if(lfd_state)
				{mem[wr_ptr[3:0]][8],mem[wr_ptr[3:0]][7:0]}<={1'b1,data_in};
				else
				{mem[wr_ptr[3:0]][8],mem[wr_ptr[3:0]][7:0]}<={1'b0,data_in};
			end
	end
always@(posedge clock)//address logic
	begin
		if(~resetn)
			begin
				wr_ptr<=0;
				rd_ptr<=0;
			end
		else if(soft_reset)
			begin
				wr_ptr<=0;
				rd_ptr<=0;
			end
		
		 if(read_enb && ~empty)
			rd_ptr<=rd_ptr+1;
		 if(write_enb && ~full)
			wr_ptr<=wr_ptr+1;
	end
always@(posedge clock)//counter logic
	begin
		if(~resetn)
			counter<=0;
		else if(soft_reset)
			counter<=0;
		else if(read_enb && ~empty)
			begin
				if(mem[rd_ptr[3:0]][8]==1'b1)
					counter<=mem[rd_ptr[3:0]][7:2]+1'b1;
				else if(counter!=0)
					counter<=counter-1;
				else
					counter<=0;
			end
	else
		counter<=0;
	end
assign full=({wr_ptr[4]!=rd_ptr[4]}&&(wr_ptr[3:0]==rd_ptr[3:0]))?1'b1:1'b0;
assign empty=(wr_ptr==rd_ptr)?1'b1:1'b0;
endmodule
