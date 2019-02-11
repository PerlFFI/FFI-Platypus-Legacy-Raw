#!perl

use lib 't';

use Test::More;

use FFI::Platypus::Legacy::Raw;
use CompileTest;

my $test   = '09-opaque';
my $source = "./t/$test.c";
my $shared = CompileTest::compile($source);

package Foo;

no warnings 'once';

use base qw(FFI::Platypus::Legacy::Raw::Ptr);

*_foo_new = FFI::Platypus::Legacy::Raw -> new(
	$shared, 'foo_new',
	FFI::Platypus::Legacy::Raw::ptr
) -> coderef;

sub new {
	bless shift -> SUPER::new(_foo_new());
}

*get_bar = FFI::Platypus::Legacy::Raw -> new(
	$shared, 'foo_get_bar',
	FFI::Platypus::Legacy::Raw::int,
	FFI::Platypus::Legacy::Raw::ptr
) -> coderef;

*set_bar = FFI::Platypus::Legacy::Raw -> new(
	$shared, 'foo_set_bar',
	FFI::Platypus::Legacy::Raw::void,
	FFI::Platypus::Legacy::Raw::ptr,
	FFI::Platypus::Legacy::Raw::int
) -> coderef;

*get_free_count = FFI::Platypus::Legacy::Raw -> new(
	$shared, 'get_free_count',
	FFI::Platypus::Legacy::Raw::int,
	FFI::Platypus::Legacy::Raw::str
) -> coderef;

*DESTROY = FFI::Platypus::Legacy::Raw -> new(
	$shared, 'foo_free',
	FFI::Platypus::Legacy::Raw::void,
	FFI::Platypus::Legacy::Raw::ptr
) -> coderef;

1;

package main;

my $foo = Foo -> new;
isa_ok $foo, 'FFI::Platypus::Legacy::Raw::Ptr';

$foo -> set_bar(42);

is $foo -> get_bar(), 42, '$foo->get_bar == 42';

is(Foo -> get_free_count(), 0, 'Foo->get_free_count = 0');
undef $foo;
is(Foo -> get_free_count(), 1, 'Foo->get_free_count = 1');

my $bar = FFI::Platypus::Legacy::Raw::MemPtr -> new(20);
isa_ok $bar, 'FFI::Platypus::Legacy::Raw::MemPtr';
isa_ok $bar, 'FFI::Platypus::Legacy::Raw::Ptr';

done_testing;
