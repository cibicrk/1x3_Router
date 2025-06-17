module router_top(input [7:0]data_in,
		  input pkt_valid,clock,resetn,read_enb_0,read_enb_1,read_enb_2,
		  output [7:0]data_out_0,data_out_1,data_out_2,
		  output vld_out_0,vld_out_1,vld_out_2,err,busy);


wire [2:0] write_enb;
wire [7:0]dout;
wire soft_reset_0,soft_reset_1,soft_reset_2;
wire full_0,full_1,full_2;
wire empty_0,empty_1,empty_2;
wire fifo_full,parity_done,low_packet_valid,write_enb_reg,detect_add,ld_state,lfd_state,full_state,rst_int_reg,laf_state;
reg lfd;

router_fifo FIFO_0(clock,resetn,soft_reset_0,write_enb[0],read_enb_0,lfd,dout,full_0,empty_0,data_out_0);
router_fifo FIFO_1(clock,resetn,soft_reset_1,write_enb[1],read_enb_1,lfd,dout,full_1,empty_1,data_out_1);	
router_fifo FIFO_2(clock,resetn,soft_reset_2,write_enb[2],read_enb_2,lfd,dout,full_2,empty_2,data_out_2);	

router_fsm FSM(clock,resetn,pkt_valid,data_in,fifo_full,empty_0,empty_1,empty_2,soft_reset_0,soft_reset_1,soft_reset_2,parity_done,low_packet_valid,
		 write_enb_reg,detect_add,ld_state,laf_state,lfd_state,full_state,rst_int_reg,busy);

router_sync SYNCHRONIZER(clock,resetn,detect_add,full_0,full_1,full_2,empty_0,empty_1,empty_2,write_enb_reg,read_enb_0,read_enb_1,read_enb_2,data_in,vld_out_0,vld_out_1,vld_out_2, write_enb,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full );
 
router_reg REGISTER(clock,resetn,pkt_valid,fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg,data_in,err,parity_done,low_packet_valid,  dout);

always@(posedge clock)

begin
if(resetn==0)
lfd<=0;
else
lfd<=lfd_state;
end

endmodule
