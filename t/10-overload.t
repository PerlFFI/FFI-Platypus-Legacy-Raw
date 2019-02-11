use strict;
use warnings;
use lib 't/lib';
use Test::More;
use FFI::Platypus::Legacy::Raw;
use CompileTest;

my $ffi;
eval {
    $ffi = FFI::Platypus::Legacy::Raw -> new('libfoo.X', 'foo', FFI::Platypus::Legacy::Raw::void);
};

ok !$ffi;

my $test   = '10-overload';
my $source = "./t/$test.c";
my $shared = CompileTest::compile($source);

$ffi = FFI::Platypus::Legacy::Raw -> new($shared, 'foo', FFI::Platypus::Legacy::Raw::void);

ok $ffi;

done_testing;
