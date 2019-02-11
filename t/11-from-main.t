use strict;
use warnings;
use Test::More;
use FFI::Platypus::Legacy::Raw;

my $isalpha = FFI::Platypus::Legacy::Raw -> new(undef, 'isalpha', FFI::Platypus::Legacy::Raw::int, FFI::Platypus::Legacy::Raw::int);

isa_ok $isalpha, 'FFI::Platypus::Legacy::Raw';

ok  $isalpha -> call(ord 'a');
ok !$isalpha -> call(ord '0');

done_testing;
