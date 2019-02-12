use Test2::V0 -no_srand => 1;
use Test2::Tools::FFI;
use FFI::Platypus::Legacy::Raw;

my($shared) = lib->test;

subtest 'argless' => sub {

  my $argless = FFI::Platypus::Legacy::Raw->new($shared, 'argless', FFI::Platypus::Legacy::Raw::void);

  $argless->call;
  $argless->();

  ok 1, 'survived the call';

};

done_testing;
