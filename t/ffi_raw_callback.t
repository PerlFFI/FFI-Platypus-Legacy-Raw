use Test2::V0 -no_srand => 1;
use Test2::Tools::FFI;
use FFI::Platypus::Legacy::Raw;

my($shared) = lib->test;

subtest 'callbacks' => sub {

  my $take_one_int_callback = FFI::Platypus::Legacy::Raw->new(
    $shared, 'take_one_int_callback',
    FFI::Platypus::Legacy::Raw::void, FFI::Platypus::Legacy::Raw::ptr
  );

  my $func1 = sub {
    my $num = shift;
    is($num, 42);
  };

  my $cb1 = FFI::Platypus::Legacy::Raw::callback($func1, FFI::Platypus::Legacy::Raw::void, FFI::Platypus::Legacy::Raw::int);

  $take_one_int_callback->call($cb1);
  $take_one_int_callback->($cb1);

  ok(1, "survived the call");

  my $return_int_callback = FFI::Platypus::Legacy::Raw->new(
    $shared, 'return_int_callback',
    FFI::Platypus::Legacy::Raw::int, FFI::Platypus::Legacy::Raw::ptr
  );

  my $func2 = sub {
    my $num = shift;

    return $num + 15;
  };

  my $cb2 = FFI::Platypus::Legacy::Raw::callback($func2, FFI::Platypus::Legacy::Raw::int, FFI::Platypus::Legacy::Raw::int);

  my $check1 = $return_int_callback->call($cb2);
  my $check2 = $return_int_callback->($cb2);

  ok(1, "survived the call");

  is($check1, (42 + 15), "returned @{[ (42+15) ]}");
  is($check2, (42 + 15), "returned @{[ (42+15) ]}");

  sub func3 {
    my $num = shift;

    return $num + 15;
  };

  my $cb3 = FFI::Platypus::Legacy::Raw::callback(\&func3, FFI::Platypus::Legacy::Raw::int, FFI::Platypus::Legacy::Raw::int);

  $check1 = $return_int_callback->call($cb3);
  $check2 = $return_int_callback->($cb3);

  ok(1, "survived the call (anonymous subroutine)");

  is($check1, (42 + 15), "returned @{[ (42+15) ]}");
  is($check2, (42 + 15), "returned @{[ (42+15) ]}");

  my $str_value = "foo";
  my $cb4 = FFI::Platypus::Legacy::Raw::callback(sub { $str_value }, FFI::Platypus::Legacy::Raw::str);

  ok(1, "survived the call");

  my $return_str_callback = FFI::Platypus::Legacy::Raw->new(
    $shared, 'return_str_callback',
    FFI::Platypus::Legacy::Raw::void, FFI::Platypus::Legacy::Raw::ptr
  );

  $return_str_callback->call($cb4);

  my $get_str_value = FFI::Platypus::Legacy::Raw->new(
    $shared, 'get_str_value',
    FFI::Platypus::Legacy::Raw::str,
  );

  my $value = $get_str_value->call();

  is($value, 'foo', 'returned foo');

  $str_value = undef;
  $return_str_callback->call($cb4);

  $value = $get_str_value->call();

  is($value, 'NULL', "returned 'NULL'");

  my $reset = FFI::Platypus::Legacy::Raw->new(
    $shared, 'reset',
    FFI::Platypus::Legacy::Raw::void,
  );

  $reset->call();
  my $buffer = FFI::Platypus::Legacy::Raw::MemPtr->new_from_buf("bar\0", length "bar\0");
  my $cb5 = FFI::Platypus::Legacy::Raw::callback(sub { $buffer }, FFI::Platypus::Legacy::Raw::ptr);

  ok(1, "survived the call");

  $return_str_callback->call($cb5);

  $value = $get_str_value->call();

  is($value, "bar", "returned bar");

  $reset->call();
  $buffer = FFI::Platypus::Legacy::Raw::MemPtr->new_from_buf("baz\0", length "baz\0");
  my $cb6 = FFI::Platypus::Legacy::Raw::callback(sub { $$buffer }, FFI::Platypus::Legacy::Raw::ptr);

  ok(1, "survived the call");

  $return_str_callback->call($cb6);

  $value = $get_str_value->call();

  is($value, 'baz', "returned baz");

  $reset->call();
  my $cb7 = FFI::Platypus::Legacy::Raw::callback(sub { undef }, FFI::Platypus::Legacy::Raw::ptr);

  ok(1, "survived the call");

  $return_str_callback->call($cb7);

  $value = $get_str_value->call();

  is($value, "NULL", "returned 'NULL'");
};

done_testing;
