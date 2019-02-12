package FFI::Platypus::Legacy::Raw::Ptr;

use strict;
use warnings;

# ABSTRACT: Base FFI::Platypus::Legacy::Raw pointer type
# VERSION

=head1 SYNOPSIS

 package Foo;
 
 use FFI::Platypus::Legacy::Raw;
 
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
 
 *DESTROY = FFI::Platypus::Legacy::Raw -> new(
   $shared, 'foo_free',
   FFI::Platypus::Legacy::Raw::void,
   FFI::Platypus::Legacy::Raw::ptr
 ) -> coderef;
 
 1;
 
 package main;
 
 my $foo = Foo -> new;
 
 $foo -> set_bar(42);

=head1 DESCRIPTION

A B<FFI::Platypus::Legacy::Raw::Ptr> represents a pointer to memory which can be passed to
functions taking a C<FFI::Platypus::Legacy::Raw::ptr> argument.

Note that differently from L<FFI::Platypus::Legacy::Raw::MemPtr>, C<FFI::Platypus::Legacy::Raw::Ptr> pointers are
not automatically deallocated once not in use anymore.

=head1 CONSTRUCTOR

=head2 new

 my $ptr = FFI::Platypus::Legacy::Raw::Ptr->new( $ptr );

Create a new C<FFI::Platypus::Legacy::Raw::Ptr> pointing to C<$ptr>, which can be either a
C<FFI::Platypus::Legacy::Raw::MemPtr> or a pointer returned by a C function.

=cut

sub new {
  my($class, $ptr) = @_;
  bless \$ptr, $class;
}

1;
