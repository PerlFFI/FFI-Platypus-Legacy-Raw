use Test2::V0 -no_srand => 1;
use Test2::Tools::FFI;
use FFI::Platypus::Legacy::Raw;
use bigint;

my($shared) = lib->test;

subtest 'simple-args' => sub {

  # probably don't n eed Math::Int64 on 64 bit Perls
  # patches welcome to prove it.
  skip_all 'test requires Math::Int64' unless eval 'use Math::Int64; 1';

  my $min_int64  = -2**63;
  my $max_uint64 = 2**64-1;

  my $take_one_int64 = eval { FFI::Platypus::Legacy::Raw->new(
    $shared, 'take_one_int64',
    FFI::Platypus::Legacy::Raw::void, FFI::Platypus::Legacy::Raw::int64
  ) };

  skip_all 'test requires LLONG_MIN and ULLONG_MAX' if $@;

  $take_one_int64->call($min_int64);

  my $take_one_uint64 = FFI::Platypus::Legacy::Raw->new(
    $shared, 'take_one_uint64',
    FFI::Platypus::Legacy::Raw::void, FFI::Platypus::Legacy::Raw::uint64
  );

  $take_one_uint64->call($max_uint64);

};

done_testing;
