module fsm3(clk,rst_n,req,done,dly,gnt);
input clk,rst_n,req,done,dly;
output reg gnt;
parameter [1:0] idle=2'b00,bbusy=2'b01,bwait=2'b10,bfree=2'b11;
reg[1:0] pr_st,nxt_st;
always@(posedge clk or negedge rst_n)
begin
if(!rst_n)
pr_st<=idle;
else
pr_st<=nxt_st;
end
always@(pr_st,req,done,dly)
begin
nxt_st=2'bxx;
case(pr_st)
idle:
	if(!req)
	begin
	nxt_st=idle;
	end
	else
	begin
	nxt_st=bbusy;
	end
bbusy:
	if(!done)
	begin
	nxt_st=bbusy;
	end
	else if(dly&&done)
	begin
	nxt_st=bwait;
	end
	else if(!idle&&done)
	begin
	nxt_st=bfree;
	end
bwait:
	if(dly)
	begin
	nxt_st=bwait;
	end
	else
	begin
	nxt_st=bfree;
	end
bfree:
	if(req)
	begin
	nxt_st=bbusy;
	end
	else 
	begin
	nxt_st=idle;
	end
endcase
end
always@(pr_st)
begin
gnt=1'b0;
case(pr_st)
bbusy,bwait:gnt=1;
endcase
end
endmodule
