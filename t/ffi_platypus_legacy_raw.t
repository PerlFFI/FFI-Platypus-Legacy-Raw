use Test2::V0 -no_srand => 1;
use Test2::Tools::FFI;
use FFI::Platypus::Legacy::Raw;

my($shared) = lib->test;

subtest 'argless' => sub {

  my $argless = FFI::Platypus::Legacy::Raw->new($shared, 'argless', FFI::Platypus::Legacy::Raw::void);
  $argless->attach;

  argless();

  ok 1, 'survived the call (same name)';

  $argless->attach('argless1');

  argless1();

  ok 1, 'survived the call (different name)';

};

subtest 'simple-args' => sub {

  my $take_misc_ints = FFI::Platypus::Legacy::Raw->new(
    $shared, 'take_misc_ints',
    FFI::Platypus::Legacy::Raw::void, FFI::Platypus::Legacy::Raw::int, FFI::Platypus::Legacy::Raw::short, FFI::Platypus::Legacy::Raw::char
  );

  $take_misc_ints->attach;

  take_misc_ints(101, 102, 103);
};

done_testing;
