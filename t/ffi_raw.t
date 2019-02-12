use Test2::V0 -no_srand => 1;
use Test2::Tools::FFI;
use FFI::Platypus::Legacy::Raw;
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

done_testing;
