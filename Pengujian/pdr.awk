#Packet Delivery Ratio
BEGIN {
	sendPkt =0
	recvPkt=0
	forwardPkt=0
	dropPkt=0
}

{
packet=$4
event =$1
label = $5

if(event =="s" && packet == "AGT" ) {
	sendPkt++;
}

if(event =="r" && packet == "AGT" ) {
	recvPkt++;
}

if(event =="f" && packet == "RTR") {
	forwardPkt++;
}

if(event =="D" && label == "LOOP" ) {
	dropPkt++;
}
}
END {
	print "\n";
	printf ("the sent packets = %d \n", sendPkt);
	printf ("the received packets = %d \n", recvPkt);
	printf ("the forwarded packets = %d \n", forwardPkt);
	printf ("the dropped packets = %d \n", dropPkt);
	print "**Packet Delivery Ratio= " (recvPkt/sendPkt) * 100 "%";
	print "\n";
	}

	 


