use strict;
use warnings;
use lib 't/lib';
use Test::More;
use FFI::Platypus::Legacy::Raw;
use CompileTest;

my $test   = '04-pointers';
my $source = "./t/$test.c";
my $shared = CompileTest::compile($source);

my $get_test_ptr_size = FFI::Platypus::Legacy::Raw -> new(
  $shared, 'get_test_ptr_size', FFI::Platypus::Legacy::Raw::int
);

my $ptr1 = FFI::Platypus::Legacy::Raw::memptr($get_test_ptr_size -> call);

my $take_one_pointer = FFI::Platypus::Legacy::Raw -> new(
  $shared, 'take_one_pointer',
  FFI::Platypus::Legacy::Raw::void, FFI::Platypus::Legacy::Raw::ptr
);

$take_one_pointer -> call($ptr1);

my $return_pointer = FFI::Platypus::Legacy::Raw -> new($shared, 'return_pointer', FFI::Platypus::Legacy::Raw::ptr);
my $ptr2 = $return_pointer -> call;

my $return_str_from_ptr = FFI::Platypus::Legacy::Raw -> new(
  $shared, 'return_str_from_ptr',
  FFI::Platypus::Legacy::Raw::str, FFI::Platypus::Legacy::Raw::ptr
);

my $return_int_from_ptr = FFI::Platypus::Legacy::Raw -> new(
  $shared, 'return_int_from_ptr',
  FFI::Platypus::Legacy::Raw::int, FFI::Platypus::Legacy::Raw::ptr
);

my $return_str_from_ptr_by_ref = FFI::Platypus::Legacy::Raw -> new(
  $shared, 'return_str_from_ptr_by_ref',
  FFI::Platypus::Legacy::Raw::str, FFI::Platypus::Legacy::Raw::ptr
);

my $return_int_from_ptr_by_ref = FFI::Platypus::Legacy::Raw -> new(
  $shared, 'return_int_from_ptr_by_ref',
  FFI::Platypus::Legacy::Raw::int, FFI::Platypus::Legacy::Raw::ptr
);

my $test_str = 'some string';
my $test_int = 42;

my $ptrptr1 = FFI::Platypus::Legacy::Raw::MemPtr -> new_from_ptr($ptr1);
my $ptrptr2 = FFI::Platypus::Legacy::Raw::MemPtr -> new_from_ptr($ptr2);

is $return_str_from_ptr -> call($ptr1), $test_str;
is $return_str_from_ptr -> ($ptr1), $test_str;

is $return_int_from_ptr -> call($ptr1), $test_int;
is $return_int_from_ptr -> ($ptr1), $test_int;

is $return_str_from_ptr_by_ref -> call($ptrptr1), $test_str;
is $return_str_from_ptr_by_ref -> ($ptrptr1), $test_str;

is $return_int_from_ptr_by_ref -> call($ptrptr1), $test_int;
is $return_int_from_ptr_by_ref -> ($ptrptr1), $test_int;

is $return_str_from_ptr -> call($ptr2), $test_str;
is $return_str_from_ptr -> ($ptr2), $test_str;

is $return_int_from_ptr -> call($ptr2), $test_int;
is $return_int_from_ptr -> ($ptr2), $test_int;

is $return_str_from_ptr_by_ref -> call($ptrptr2), $test_str;
is $return_str_from_ptr_by_ref -> ($ptrptr2), $test_str;

is $return_int_from_ptr_by_ref -> call($ptrptr2), $test_int;
is $return_int_from_ptr_by_ref -> ($ptrptr2), $test_int;

my $return_null = FFI::Platypus::Legacy::Raw -> new($shared, 'return_null', FFI::Platypus::Legacy::Raw::ptr);
is $return_null -> call, undef;

done_testing;
