use strict;
use warnings;
use lib 't/lib';
use FFI::Platypus::Legacy::Raw;
use CompileTest;

my $test   = '01-argless';
my $source = "./t/$test.c";
my $shared = CompileTest::compile($source);

my $argless = FFI::Platypus::Legacy::Raw -> new($shared, 'argless', FFI::Platypus::Legacy::Raw::void);

$argless -> call;
$argless -> ();

print "ok - survived the call\n";

print "1..3\n";
