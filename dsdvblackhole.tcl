#===================================
#     Simulation parameters setup
#===================================
set val(chan)   Channel/WirelessChannel    ;# channel type
set val(prop)   Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)  Phy/WirelessPhy            ;# network interface type
set val(mac)    Mac/802_11                 ;# MAC type
set val(ifq)    Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)     LL                         ;# link layer type
set val(ant)    Antenna/OmniAntenna        ;# antenna model
set val(ifqlen) 50                         ;# max packet in ifq
set val(nn)     50                         ;# number of mobilenodes
set val(seed)   0.0                        ;# number of seeds
set val(rp)     DSDV                       ;# routing protocol
set val(x)      1000                       ;# X dimension of topography
set val(y)      1000                       ;# Y dimension of topography
set val(stop)   100                        ;# time of simulation end
set val(cp)     "./cbr50.tcl"              ;# cbr file
set val(sc)     "./mob50.tcl"              ;# mob file



#===================================
#        Initialization        
#===================================
#Create a ns simulator
set ns_ [new Simulator]
#$ns_ use-newtrace

#Setup topography object
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

#Open the NS trace file
set tracefile [open DSDV50bl1.tr w]
$ns_ trace-all $tracefile

#Open the NAM trace file
set namfile [open DSDV50bl1.nam w]
$ns_ namtrace-all $namfile
$ns_ namtrace-all-wireless $namfile $val(x) $val(y)

#Create God
set god_ [create-god $val(nn)]
set chan [new $val(chan)];
#set chan_1 [new $val(chan)]



#===================================
#     Mobile node parameter setup
#===================================
$ns_ node-config -adhocRouting  $val(rp) \
                -llType        $val(ll) \
                -macType       $val(mac) \
                -ifqType       $val(ifq) \
                -ifqLen        $val(ifqlen) \
                -antType       $val(ant) \
                -propType      $val(prop) \
                -phyType       $val(netif) \
                -channel       $chan \
                -topoInstance  $topo \
                -agentTrace    ON \
                -routerTrace   ON \
                -macTrace      OFF \
                -movementTrace ON \
                

for {set i 0} {$i < $val(nn)} {incr i} {
	set node_($i) [$ns_ node]
	$node_($i) random-motion 0 ; #disable random motion }



#Define node movement model
puts "Loading random connection pattern..."
source $val(cp)

#Define traffic model
puts "Loading scenario file..."
source $val(sc)


for {set i 0} {$i < $val(nn) } { incr i } {
 $ns_ initial_node_pos $node_($i) 30
    }



#======================================
#        Malicious Node Blackhole   
#======================================

#50 node
$ns_ at 0.0 "[$node_(7) set ragent_] blackhole"
#$ns_ at 0.0 "[$node_(22) set ragent_] blackhole"
#$ns_ at 0.0 "[$node_(37) set ragent_] blackhole"

#75 node
#$ns_ at 0.0 "[$node_(12) set ragent_] blackhole"
#$ns_ at 0.0 "[$node_(36) set ragent_] blackhole"
#$ns_ at 0.0 "[$node_(60) set ragent_] blackhole"

#100 node
#$ns_ at 0.0 "[$node_(16) set ragent_] blackhole"
#$ns_ at 0.0 "[$node_(50) set ragent_] blackhole"
#$ns_ at 0.0 "[$node_(84) set ragent_] blackhole"

#125 node
#$ns_ at 0.0 "[$node_(20) set ragent_] blackhole"
#$ns_ at 0.0 "[$node_(40) set ragent_] blackhole"
#$ns_ at 0.0 "[$node_(60) set ragent_] blackhole"



#===================================
#        Termination        
#===================================
#Define a 'finish' procedure
proc finish {} {
    global ns_ tracefile namfile
    #$ns_ flush-trace
    close $tracefile
    close $namfile
    exec nam DSDV50bl1.nam &
    exit 0
}

#Tell nodes when the simulation ends
for {set i 0} {$i < $val(nn) } { incr i } {
    $ns_ at $val(stop).0 "$node_($i) reset";
}

$ns_ at $val(stop) "$ns_ nam-end-wireless $val(stop)"
$ns_ at $val(stop) "finish"
$ns_ at $val(stop) "puts \"done\" ; $ns_ halt"

puts "Starting Simulation..."
$ns_ run

