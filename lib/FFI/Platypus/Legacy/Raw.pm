package FFI::Platypus::Legacy::Raw;

use strict;
use warnings;
use FFI::Platypus::Legacy::Raw::Callback;
use FFI::Platypus::Legacy::Raw::Ptr;
use FFI::Platypus::Legacy::Raw::MemPtr;

require XSLoader;
XSLoader::load('FFI::Platypus::Legacy::Raw', $FFI::Platypus::Legacy::Raw::VERSION);

require FFI::Platypus::Legacy::Raw::Ptr;
require FFI::Platypus::Legacy::Raw::MemPtr;

use overload
  '&{}'  => \&coderef,
  'bool' => \&_bool;

sub _bool {
  my $ffi = shift;
  return $ffi;
}

=head1 NAME

FFI::Platypus::Legacy::Raw - Perl bindings to the portable FFI library (libffi)

=head1 SYNOPSIS

    use FFI::Platypus::Legacy::Raw;

    my $cos = FFI::Platypus::Legacy::Raw -> new(
      'libm.so', 'cos',
      FFI::Platypus::Legacy::Raw::double, # return value
      FFI::Platypus::Legacy::Raw::double  # arg #1
    );

    say $cos -> call(2.0);

=head1 DESCRIPTION

B<FFI::Platypus::Legacy::Raw> provides a low-level foreign function interface (FFI) for Perl based
on L<libffi|http://sourceware.org/libffi/>. In essence, it can access and call
functions exported by shared libraries without the need to write C/XS code.

Dynamic symbols can be automatically resolved at runtime so that the only
information needed to use B<FFI::Platypus::Legacy::Raw> is the name (or path) of the target
library, the name of the function to call and its signature (though it is also
possible to pass a function pointer obtained, for example, using L<DynaLoader>).

Note that this module has nothing to do with L<FFI>.

=head1 METHODS

=head2 new( $library, $function, $return_type [, $arg_type ...] )

Create a new C<FFI::Platypus::Legacy::Raw> object. It loads C<$library>, finds the function
C<$function> with return type C<$return_type> and creates a calling interface.

If C<$library> is C<undef> then the function is searched in the main program.

This method also takes a variable number of types, representing the arguments
of the wanted function.

=head2 new_from_ptr( $function_ptr, $return_type [, $arg_type ...] )

Create a new C<FFI::Platypus::Legacy::Raw> object from the C<$function_ptr> function pointer.

This method also takes a variable number of types, representing the arguments
of the wanted function.

=head2 call( [$arg ...] )

Execute the C<FFI::Platypus::Legacy::Raw> function. This method also takes a variable number of
arguments, which are passed to the called function. The argument types must
match the types passed to C<new> (or C<new_from_ptr>).

The C<FFI::Platypus::Legacy::Raw> object can be used as a CODE reference as well. Dereferencing
the object will work just like call():

    $cos -> call(2.0); # normal call() call
    $cos -> (2.0);     # dereference as CODE ref

This works because FFI::Platypus::Legacy::Raw overloads the C<&{}> operator.

=head2 coderef( )

Return a code reference of a given C<FFI::Platypus::Legacy::Raw>.

=cut

sub coderef {
  my $ffi = shift;
  return sub { $ffi -> call(@_) };
}

=head1 SUBROUTINES

=head2 memptr( $length )

Create a L<FFI::Platypus::Legacy::Raw::MemPtr>. This is a shortcut for C<FFI::Platypus::Legacy::Raw::MemPtr-E<gt>new(...)>.

=cut

sub memptr { FFI::Platypus::Legacy::Raw::MemPtr -> new(@_) }

=head2 callback( $coderef, $ret_type [, $arg_type ...] )

Create a L<FFI::Platypus::Legacy::Raw::Callback>. This is a shortcut for C<FFI::Platypus::Legacy::Raw::Callback-E<gt>new(...)>.

=cut

sub callback { FFI::Platypus::Legacy::Raw::Callback -> new(@_) }

=head1 TYPES

=head2 FFI::Platypus::Legacy::Raw::void

Return a C<FFI::Platypus::Legacy::Raw> void type.

=cut

sub void ()  { ord 'v' }

=head2 FFI::Platypus::Legacy::Raw::int

Return a C<FFI::Platypus::Legacy::Raw> integer type.

=cut

sub int ()   { ord 'i' }

=head2 FFI::Platypus::Legacy::Raw::uint

Return a C<FFI::Platypus::Legacy::Raw> unsigned integer type.

=cut

sub uint ()   { ord 'I' }

=head2 FFI::Platypus::Legacy::Raw::short

Return a C<FFI::Platypus::Legacy::Raw> short integer type.

=cut

sub short ()   { ord 'z' }

=head2 FFI::Platypus::Legacy::Raw::ushort

Return a C<FFI::Platypus::Legacy::Raw> unsigned short integer type.

=cut

sub ushort ()   { ord 'Z' }

=head2 FFI::Platypus::Legacy::Raw::long

Return a C<FFI::Platypus::Legacy::Raw> long integer type.

=cut

sub long ()   { ord 'l' }

=head2 FFI::Platypus::Legacy::Raw::ulong

Return a C<FFI::Platypus::Legacy::Raw> unsigned long integer type.

=cut

sub ulong ()   { ord 'L' }

=head2 FFI::Platypus::Legacy::Raw::int64

Return a C<FFI::Platypus::Legacy::Raw> 64 bit integer type. This requires L<Math::Int64> to work.

=cut

sub int64 ()   { ord 'x' }

=head2 FFI::Platypus::Legacy::Raw::uint64

Return a C<FFI::Platypus::Legacy::Raw> unsigned 64 bit integer type. This requires L<Math::Int64> 
to work.

=cut

sub uint64 ()   { ord 'X' }

=head2 FFI::Platypus::Legacy::Raw::char

Return a C<FFI::Platypus::Legacy::Raw> char type.

=cut

sub char ()  { ord 'c' }

=head2 FFI::Platypus::Legacy::Raw::uchar

Return a C<FFI::Platypus::Legacy::Raw> unsigned char type.

=cut

sub uchar ()  { ord 'C' }

=head2 FFI::Platypus::Legacy::Raw::float

Return a C<FFI::Platypus::Legacy::Raw> float type.

=cut

sub float () { ord 'f' }

=head2 FFI::Platypus::Legacy::Raw::double

Return a C<FFI::Platypus::Legacy::Raw> double type.

=cut

sub double () { ord 'd' }

=head2 FFI::Platypus::Legacy::Raw::str

Return a C<FFI::Platypus::Legacy::Raw> string type.

=cut

sub str ()   { ord 's' }

=head2 FFI::Platypus::Legacy::Raw::ptr

Return a C<FFI::Platypus::Legacy::Raw> pointer type.

=cut

sub ptr ()   { ord 'p' }

=head1 AUTHOR

Alessandro Ghedini <alexbio@cpan.org>

=head1 SEE ALSO

L<FFI>, L<Ctypes|http://gitorious.org/perl-ctypes>

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Alessandro Ghedini.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of FFI::Platypus::Legacy::Raw
