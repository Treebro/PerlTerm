#!/usr/bin/perl
use strict;
#use warnings;
use Device::SerialPort;
#my $maxOutput = 14 ;

my $port = Device::SerialPort->new("/dev/ttyACM0");
#$port->databits(8);
$port->baudrate(9600);
$port->parity("none");
$port->handshake("none");
$port->databits(8);
$port->stopbits(1);
$port->read_char_time(0);
$port->read_const_time(20);

sub scmd {
  my($cmd,$sleepTime,$timeout_tries,$obj) = @_;
  $timeout_tries = 250 unless $timeout_tries;
  my $response;
  $obj = $port unless $obj;
  $obj->write("$cmd\r");
  if ($sleepTime) {
    sleep $sleepTime;
  }
  while ($timeout_tries > 0) {
      my ($count, $data) = $port->read(255);
      if ($count > 0) {
          $response .= $data;
          last if ($data =~ /\n/);
      }
      $timeout_tries--;
  }
  return $response;
}

my $string;
$string = &scmd("");
$string = &scmd("1 2 8 2");
print $string;

$string = &scmd("1 1 8 1");
print $string;
sleep 2;
$string = &scmd("1 1 8 0");
print $string;
sleep 5;
for(my $x = 0; $x < 3; $x = $x + 1){
$string = &scmd("1 1 8 0");
print $string;
select(undef,undef,undef,0.25);
$string = &scmd("1 1 8 1");
print $string;
select(undef,undef,undef,0.25);
}

#$port->write("bogus\r");
#
#my $response = "";
#my $timeout_tries = 50;
#
#while ($timeout_tries > 0) {
#    my ($count, $data) = $port->read(255);
#    if ($count > 0) {
#        $response .= $data;
#        last if ($data =~ /\n/);
#    }
#    $timeout_tries--;
#}
#if ($timeout_tries) {
#    print "$response\n";
#} else {
#    print "Arduino is not responding\n";
#}
#$port->write("reset board\r");
#sleep 1;
#$response = "";
#$timeout_tries = 250;
#
#while ($timeout_tries > 0) {
#    my ($count, $data) = $port->read(255);
#    if ($count > 0) {
#        $response .= $data;
#        last if ($data =~ /\n/);
#    }
#    $timeout_tries--;
#}
#if ($timeout_tries) {
#    print "$response\n";
#} else {
#    print "Arduino is not responding\n";
#}
#$port->write("set pin 4 high\r");
#$response = "";
#$timeout_tries = 250;
#
#while ($timeout_tries > 0) {
#    my ($count, $data) = $port->read(255);
#    if ($count > 0) {
#        $response .= $data;
#        last if ($data =~ /\n/);
#    }
#    $timeout_tries--;
#}
#if ($timeout_tries) {
#    print "$response\n";
#} else {
#    print "Arduino is not responding\n";
#}
#$port->write("set pin 2 high\r");
#$response = "";
#$timeout_tries = 250;
#
#while ($timeout_tries > 0) {
#    my ($count, $data) = $port->read(255);
#    if ($count > 0) {
#        $response .= $data;
#        last if ($data =~ /\n/);
#    }
#    $timeout_tries--;
#}
#if ($timeout_tries) {
#    print "$response\n";
#} else {
#    print "Arduino is not responding\n";
#}
#sleep 5;
#my $string = &scmd("set pin 2 low");
#print $string;
#$string = &scmd("set pin 4 low");
#print $string;
#
#$port->parity("none");
#$port->stopbits(1);
#$port->dtr_active(0);
#sleep (20);
#$port->write("set pin 2 high\n");
#my $answer = $port->lookfor($maxOutput);
#print "first";
#print $answer ;
#$port->write("set pin 4 high\n");
#$answer = $port->lookfor;
#print "second";
#print $answer;
#print "end";
#sleep(1);

