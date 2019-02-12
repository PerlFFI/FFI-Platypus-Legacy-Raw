use Test2::V0 -no_srand => 1;
use Test2::Tools::FFI;
use FFI::Platypus::Legacy::Raw;
use Math::BigInt;
use POSIX;

my($shared) = lib->test;

subtest 'argless' => sub {

  my $argless = FFI::Platypus::Legacy::Raw->new($shared, 'argless', FFI::Platypus::Legacy::Raw::void);

  $argless->call;
  $argless->();

  ok 1, 'survived the call';

};

subtest 'simple-args' => sub {
  use bigint;

  my $min_int64  = -2**63;
  my $max_uint64 = 2**64-1;

  SKIP: {
    eval "use Math::Int64";

    if ($@) {
      note "Math::Int64 required for int64 tests\n";
      last SKIP;
    }

    my $take_one_int64 = eval { FFI::Platypus::Legacy::Raw->new(
      $shared, 'take_one_int64',
      FFI::Platypus::Legacy::Raw::void, FFI::Platypus::Legacy::Raw::int64
    ) };

    if ($@) {
      note "LLONG_MIN and ULLONG_MAX required for int64 tests\n";
      last SKIP;
    }

    $take_one_int64->call($min_int64);

    my $take_one_uint64 = FFI::Platypus::Legacy::Raw->new(
      $shared, 'take_one_uint64',
      FFI::Platypus::Legacy::Raw::void, FFI::Platypus::Legacy::Raw::uint64
    );

    $take_one_uint64->call($max_uint64);
  }

  no bigint;

  my $take_one_long = FFI::Platypus::Legacy::Raw->new(
    $shared, 'take_one_long',
    FFI::Platypus::Legacy::Raw::void, FFI::Platypus::Legacy::Raw::long
  );

  $take_one_long->call(LONG_MIN);

  my $take_one_ulong = FFI::Platypus::Legacy::Raw->new(
    $shared, 'take_one_ulong',
    FFI::Platypus::Legacy::Raw::void, FFI::Platypus::Legacy::Raw::ulong
  );

  $take_one_ulong->call(ULONG_MAX);

  my $take_one_int = FFI::Platypus::Legacy::Raw->new(
    $shared, 'take_one_int',
    FFI::Platypus::Legacy::Raw::void, FFI::Platypus::Legacy::Raw::int
  );

  $take_one_int->call(INT_MIN);

  my $take_one_uint = FFI::Platypus::Legacy::Raw->new(
    $shared, 'take_one_uint',
    FFI::Platypus::Legacy::Raw::void, FFI::Platypus::Legacy::Raw::uint
  );

  $take_one_uint->call(UINT_MAX);

  my $take_one_short = FFI::Platypus::Legacy::Raw->new(
    $shared, 'take_one_short',
    FFI::Platypus::Legacy::Raw::void, FFI::Platypus::Legacy::Raw::short
  );

  $take_one_short->call(SHRT_MIN);

  my $take_one_ushort = FFI::Platypus::Legacy::Raw->new(
    $shared, 'take_one_ushort',
    FFI::Platypus::Legacy::Raw::void, FFI::Platypus::Legacy::Raw::ushort
  );

  $take_one_ushort->call(USHRT_MAX);

  my $take_one_char = FFI::Platypus::Legacy::Raw->new(
    $shared, 'take_one_char',
    FFI::Platypus::Legacy::Raw::void, FFI::Platypus::Legacy::Raw::char
  );

  $take_one_char->call(CHAR_MIN);

  my $take_one_uchar = FFI::Platypus::Legacy::Raw->new(
    $shared, 'take_one_uchar',
    FFI::Platypus::Legacy::Raw::void, FFI::Platypus::Legacy::Raw::uchar
  );

  $take_one_uchar->call(UCHAR_MAX);

  my $take_two_shorts = FFI::Platypus::Legacy::Raw->new(
    $shared, 'take_two_shorts',
    FFI::Platypus::Legacy::Raw::void, FFI::Platypus::Legacy::Raw::short, FFI::Platypus::Legacy::Raw::short
  );

  $take_two_shorts->call(10, 20);

  my $take_misc_ints = FFI::Platypus::Legacy::Raw->new(
    $shared, 'take_misc_ints',
    FFI::Platypus::Legacy::Raw::void, FFI::Platypus::Legacy::Raw::int, FFI::Platypus::Legacy::Raw::short, FFI::Platypus::Legacy::Raw::char
  );

  $take_misc_ints->call(101, 102, 103);
  $take_misc_ints->(101, 102, 103);

  # floats
  my $take_one_double = FFI::Platypus::Legacy::Raw->new(
    $shared, 'take_one_double',
    FFI::Platypus::Legacy::Raw::void, FFI::Platypus::Legacy::Raw::double
  );

  $take_one_double->call(-6.9e0);
  $take_one_double->(-6.9e0);

  my $take_one_float = FFI::Platypus::Legacy::Raw->new(
    $shared, 'take_one_float',
    FFI::Platypus::Legacy::Raw::void, FFI::Platypus::Legacy::Raw::float
  );

  $take_one_float->call(4.2e0);
  $take_one_float->(4.2e0);

  # strings
  my $take_one_string = FFI::Platypus::Legacy::Raw->new(
    $shared, 'take_one_string',
    FFI::Platypus::Legacy::Raw::void, FFI::Platypus::Legacy::Raw::str
  );

  $take_one_string->call('ok - passed a string');
  $take_one_string->('ok - passed a string');

};

subtest 'simple-returns' => sub {

  my $min_int64  = Math::BigInt -> new('-9223372036854775808');
  my $max_uint64 = Math::BigInt -> new('18446744073709551615');

  SKIP: {
  eval "use Math::Int64";

  skip 'Math::Int64 required for int64 tests', 4 if $@;

  my $return_int64 = eval { FFI::Platypus::Legacy::Raw -> new($shared, 'return_int64', FFI::Platypus::Legacy::Raw::int64) };

  skip 'LLONG_MIN and ULLONG_MAX required for int64 tests', 4 if $@;

  is $return_int64 -> call, $min_int64->bstr();
  is $return_int64 -> (), $min_int64->bstr();

  my $return_uint64 = FFI::Platypus::Legacy::Raw -> new($shared, 'return_uint64', FFI::Platypus::Legacy::Raw::uint64);
  is $return_uint64 -> call, $max_uint64->bstr();
  is $return_uint64 -> (), $max_uint64->bstr();
  };

  my $return_long = FFI::Platypus::Legacy::Raw -> new($shared, 'return_long', FFI::Platypus::Legacy::Raw::long);
  is $return_long -> call, LONG_MIN;
  is $return_long -> (), LONG_MIN;

  my $return_ulong = FFI::Platypus::Legacy::Raw -> new($shared, 'return_ulong', FFI::Platypus::Legacy::Raw::ulong);
  is $return_ulong -> call, ULONG_MAX;
  is $return_ulong -> (), ULONG_MAX;

  my $return_int = FFI::Platypus::Legacy::Raw -> new($shared, 'return_int', FFI::Platypus::Legacy::Raw::int);
  is $return_int -> call, INT_MIN;
  is $return_int -> (), INT_MIN;

  my $return_uint = FFI::Platypus::Legacy::Raw -> new($shared, 'return_uint', FFI::Platypus::Legacy::Raw::uint);
  is $return_uint -> call, UINT_MAX;
  is $return_uint -> (), UINT_MAX;

  my $return_short = FFI::Platypus::Legacy::Raw -> new($shared, 'return_short', FFI::Platypus::Legacy::Raw::short);
  is $return_short -> call, SHRT_MIN;
  is $return_short -> (), SHRT_MIN;

  my $return_ushort = FFI::Platypus::Legacy::Raw -> new($shared, 'return_ushort', FFI::Platypus::Legacy::Raw::ushort);
  is $return_ushort -> call, USHRT_MAX;
  is $return_ushort -> (), USHRT_MAX;

  my $return_char = FFI::Platypus::Legacy::Raw -> new($shared, 'return_char', FFI::Platypus::Legacy::Raw::char);
  is $return_char -> call, CHAR_MIN;
  is $return_char -> (), CHAR_MIN;

  my $return_uchar = FFI::Platypus::Legacy::Raw -> new($shared, 'return_uchar', FFI::Platypus::Legacy::Raw::uchar);
  is $return_uchar -> call, UCHAR_MAX;
  is $return_uchar -> (), UCHAR_MAX;

  my $return_double = FFI::Platypus::Legacy::Raw -> new($shared, 'return_double', FFI::Platypus::Legacy::Raw::double);

  {
    my $todo = 'failing';
    is $return_double -> call, 9.9e0;
    is $return_double -> (), 9.9e0;
  };

  my $return_float = FFI::Platypus::Legacy::Raw -> new($shared, 'return_float', FFI::Platypus::Legacy::Raw::float);
  is $return_float -> call, -4.5e0;
  is $return_float -> (), -4.5e0;

  my $return_string = FFI::Platypus::Legacy::Raw -> new($shared, 'return_string', FFI::Platypus::Legacy::Raw::str);
  is $return_string -> call, 'epic cuteness';
  is $return_string -> (), 'epic cuteness';
};

done_testing;
