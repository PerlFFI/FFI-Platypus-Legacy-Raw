#!perl

use lib 't';

use FFI::Platypus::Legacy::Raw;
use CompileTest;

my $test   = '05-callbacks';
my $source = "./t/$test.c";
my $shared = CompileTest::compile($source);

my $take_one_int_callback = FFI::Platypus::Legacy::Raw -> new(
  $shared, 'take_one_int_callback',
  FFI::Platypus::Legacy::Raw::void, FFI::Platypus::Legacy::Raw::ptr
);

my $func1 = sub {
  my $num = shift;

  print ($num == 42 ? "ok\n" : "not ok\n");
};

my $cb1 = FFI::Platypus::Legacy::Raw::callback($func1, FFI::Platypus::Legacy::Raw::void, FFI::Platypus::Legacy::Raw::int);

$take_one_int_callback -> call($cb1);
$take_one_int_callback -> ($cb1);

print "ok - survived the call\n";

my $return_int_callback = FFI::Platypus::Legacy::Raw -> new(
  $shared, 'return_int_callback',
  FFI::Platypus::Legacy::Raw::int, FFI::Platypus::Legacy::Raw::ptr
);

my $func2 = sub {
  my $num = shift;

  return $num + 15;
};

my $cb2 = FFI::Platypus::Legacy::Raw::callback($func2, FFI::Platypus::Legacy::Raw::int, FFI::Platypus::Legacy::Raw::int);

my $check1 = $return_int_callback -> call($cb2);
my $check2 = $return_int_callback -> ($cb2);

print "ok - survived the call\n";

print ($check1 == (42 + 15) ? "ok\n" : "not ok - returned $check1\n");
print ($check2 == (42 + 15) ? "ok\n" : "not ok - returned $check2\n");

sub func3 {
  my $num = shift;

  return $num + 15;
};

my $cb3 = FFI::Platypus::Legacy::Raw::callback(\&func3, FFI::Platypus::Legacy::Raw::int, FFI::Platypus::Legacy::Raw::int);

$check1 = $return_int_callback -> call($cb3);
$check2 = $return_int_callback -> ($cb3);

print "ok - survived the call (anonymous subroutine)\n";

print ($check1 == (42 + 15) ? "ok\n" : "not ok - returned $check1\n");
print ($check2 == (42 + 15) ? "ok\n" : "not ok - returned $check2\n");

my $str_value = "foo";
my $cb4 = FFI::Platypus::Legacy::Raw::callback(sub { $str_value }, FFI::Platypus::Legacy::Raw::str);

print "ok - survived the call\n";

my $return_str_callback = FFI::Platypus::Legacy::Raw -> new(
  $shared, 'return_str_callback',
  FFI::Platypus::Legacy::Raw::void, FFI::Platypus::Legacy::Raw::ptr
);

$return_str_callback -> call($cb4);

my $get_str_value = FFI::Platypus::Legacy::Raw -> new(
  $shared, 'get_str_value',
  FFI::Platypus::Legacy::Raw::str,
);

my $value = $get_str_value -> call();

print ($value eq 'foo' ? "ok\n" : "not ok - returned $value\n");

$str_value = undef;
$return_str_callback->call($cb4);

my $value = $get_str_value -> call();

print ($value eq 'NULL' ? "ok\n" : "not ok - returned $value\n");

my $reset = FFI::Platypus::Legacy::Raw -> new(
  $shared, 'reset',
  FFI::Platypus::Legacy::Raw::void,
);

$reset -> call();
my $buffer = FFI::Platypus::Legacy::Raw::MemPtr -> new_from_buf("bar\0", length "bar\0");
my $cb5 = FFI::Platypus::Legacy::Raw::callback(sub { $buffer }, FFI::Platypus::Legacy::Raw::ptr);

print "ok - survived the call\n";

$return_str_callback -> call($cb5);

$value = $get_str_value -> call();

print ($value eq 'bar' ? "ok\n" : "not ok - returned $value\n");

$reset -> call();
$buffer = FFI::Platypus::Legacy::Raw::MemPtr -> new_from_buf("baz\0", length "baz\0");
my $cb6 = FFI::Platypus::Legacy::Raw::callback(sub { $$buffer }, FFI::Platypus::Legacy::Raw::ptr);

print "ok - survived the call\n";

$return_str_callback -> call($cb6);

$value = $get_str_value -> call();

print ($value eq 'baz' ? "ok\n" : "not ok - returned $value\n");

$reset -> call();
my $cb7 = FFI::Platypus::Legacy::Raw::callback(sub { undef }, FFI::Platypus::Legacy::Raw::ptr);

print "ok - survived the call\n";

$return_str_callback -> call($cb7);

$value = $get_str_value -> call();

print ($value eq 'NULL' ? "ok\n" : "not ok - returned $value\n");

print "1..18\n";
