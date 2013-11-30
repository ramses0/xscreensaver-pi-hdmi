#!/usr/bin/perl
 
#check_screen_state.pl - perl script to monitor screen state, and turn HDMI on or off
use strict;
use warnings;
use threads;
use Thread::Queue;
$|=1;

my $counter=-1;
#time in seconds
#my $time_to_power_off_screen_s = 1200; #20 minutes
my $time_to_power_off_screen_s = 30; #20 minutes
my $hdmi_off_command = "/usr/lib/xscreensaver-pi-hdmi/hdmi-off";
my $hdmi_on_command  = "/usr/lib/xscreensaver-pi-hdmi/hdmi-on";

#code to run a shell command in a thread, and get output from it
sub pipeCommand {
    my $cmd = shift;
    my $Q = new Thread::Queue;
    async{
        my $pid = open my $pipe, $cmd or die $!;
        $Q->enqueue( $_ ) while <$pipe>;
        $Q->enqueue( undef );
    }->detach;
    return $Q;
}

my $pipe = pipeCommand(
    'xscreensaver-command -watch |'
) or die;

print_("Starting, waiting on input.\n");
while( 1 ) {
    if( $pipe->pending ) {
        my $line = $pipe->dequeue or last;
        print_("$line");
      if ($line =~ m/^(BLANK|LOCK)/) {
         $counter = $time_to_power_off_screen_s;
      } elsif ($line =~ m/^UNBLANK/) {
         if($counter <= 0){
            print_( "turn on\n");
            print_( `$hdmi_on_command `);
         }else{
            print_("screen already on\n");
         }
         $counter=-1;
       }
    }
    else {
        sleep 1;
      if($counter >0){
         $counter--;
      }
       
      if($counter == 0){
         $counter=-1;
         print_( "turn off acter $time_to_power_off_screen_s seconds\n");
         print_(`$hdmi_off_command`);         
      }
    }
}

sub print_{
   print "[".localtime(time) .  "] @_";
}
