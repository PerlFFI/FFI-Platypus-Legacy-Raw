package FFI::Platypus::Legacy::Raw;

use strict;
use warnings;
use FFI::Platypus;
use FFI::Platypus::Legacy::Raw::Callback;
use FFI::Platypus::Legacy::Raw::Ptr;
use FFI::Platypus::Legacy::Raw::MemPtr;

# ABSTRACT: Perl bindings to the portable FFI library (libffi)
# VERSION

require XSLoader;
XSLoader::load('FFI::Platypus::Legacy::Raw', $FFI::Platypus::Legacy::Raw::VERSION);

use overload
  '&{}'  => \&coderef,
  'bool' => \&_bool;

sub _bool {
  my $ffi = shift;
  return $ffi;
}

my $ffi = FFI::Platypus->new;
$ffi->lib(undef);
$ffi->package;
$ffi->type('void'               => 'raw_' . ord 'v');
$ffi->type('long'               => 'raw_' . ord 'l');
$ffi->type('unsigned long'      => 'raw_' . ord 'L');
$ffi->type('long long'          => 'raw_' . ord 'x');
$ffi->type('unsigned long long' => 'raw_' . ord 'X');
$ffi->type('int'                => 'raw_' . ord 'i');
$ffi->type('unsigned int'       => 'raw_' . ord 'I');
$ffi->type('signed char'        => 'raw_' . ord 'c');
$ffi->type('unsigned char'      => 'raw_' . ord 'C');
$ffi->type('float'              => 'raw_' . ord 'f');
$ffi->type('double'             => 'raw_' . ord 'd');
$ffi->type('string',            => 'raw_' . ord 's');
$ffi->type('opaque',            => 'raw_' . ord 'p');
sub _ffi { $ffi }

=head1 SYNOPSIS

 use FFI::Platypus::Legacy::Raw;
 
 my $cos = FFI::Platypus::Legacy::Raw -> new(
   'libm.so', 'cos',
   FFI::Platypus::Legacy::Raw::double, # return value
   FFI::Platypus::Legacy::Raw::double  # arg #1
 );
 
 say $cos -> call(2.0);

=head1 DESCRIPTION

B<FFI::Platypus::Legacy::Raw> and friends are a fork of L<FFI::Raw> that uses L<FFI::Platypus>
instead of L<FFI::Raw>'s own libffi implementation.  It is intended for use when migrating from
L<FFI::Raw> to L<FFI::Platypus>.  The main reason one might have for switching from Raw to Platypus
is because Platypus is actively maintained, provides a more powerful interface, can be much faster
when functions are "attached", and works on more platforms than Raw.  This module should be a drop
in replacement for L<FFI::Raw>, simply replace all instances of C<FFI::Raw> to
C<FFI::Platypus::Legacy::Raw>.  See also L<Alt::FFI::Raw::Platypus> for a way to use this module
without making any source code changes.

B<FFI::Platypus::Legacy::Raw> provides a low-level foreign function interface (FFI) for Perl based
on L<libffi|http://sourceware.org/libffi/>. In essence, it can access and call
functions exported by shared libraries without the need to write C/XS code.

Dynamic symbols can be automatically resolved at runtime so that the only
information needed to use B<FFI::Platypus::Legacy::Raw> is the name (or path) of the target
library, the name of the function to call and its signature (though it is also
possible to pass a function pointer obtained, for example, using L<DynaLoader>).

Note that this module has nothing to do with L<FFI>.

=head1 CONSTRUCTORS

=head2 new

 my $ffi = FFI::Platypus::Legacy::Raw->new( $library, $function, $return_type, @arg_types )

Create a new C<FFI::Platypus::Legacy::Raw> object. It loads C<$library>, finds the function
C<$function> with return type C<$return_type> and creates a calling interface.

If C<$library> is C<undef> then the function is searched in the main program.

This method also takes a variable number of types, representing the arguments
of the wanted function.

=head2 new_from_ptr

 my $ffi = FFI::Platypus::Legacy::Raw->new_from_ptr( $function_ptr, $return_type, @arg_types )

Create a new C<FFI::Platypus::Legacy::Raw> object from the C<$function_ptr> function pointer.

This method also takes a variable number of types, representing the arguments
of the wanted function.

=head1 METHODS

=head2 call

 my $ret = $ffi->call( @args)

Execute the C<FFI::Platypus::Legacy::Raw> function. This method also takes a variable number of
arguments, which are passed to the called function. The argument types must
match the types passed to C<new> (or C<new_from_ptr>).

The C<FFI::Platypus::Legacy::Raw> object can be used as a CODE reference as well. Dereferencing
the object will work just like call():

 $cos -> call(2.0); # normal call() call
 $cos -> (2.0);     # dereference as CODE ref

This works because FFI::Platypus::Legacy::Raw overloads the C<&{}> operator.

=head2 coderef

 my $code = FFI::Platypus::Legacy::Raw->coderef;

Return a code reference of a given C<FFI::Platypus::Legacy::Raw>.

=cut

sub coderef {
  my $ffi = shift;
  return sub { $ffi -> call(@_) };
}

=head1 SUBROUTINES

=head2 memptr

 my $memptr = FFI::Platypus::Legacy::Raw::memptr( $length );

Create a L<FFI::Platypus::Legacy::Raw::MemPtr>. This is a shortcut for C<FFI::Platypus::Legacy::Raw::MemPtr-E<gt>new(...)>.

=cut

sub memptr { FFI::Platypus::Legacy::Raw::MemPtr -> new(@_) }

=head2 callback

 my $callback = FFI::Platypus::Legacy::Raw::callback( $coderef, $ret_type, \@arg_types );

Create a L<FFI::Platypus::Legacy::Raw::Callback>. This is a shortcut for C<FFI::Platypus::Legacy::Raw::Callback-E<gt>new(...)>.

=cut

sub callback { FFI::Platypus::Legacy::Raw::Callback -> new(@_) }

=head1 TYPES

=head2 void

 my $type = FFI::Platypus::Legacy::Raw::void();

Return a C<FFI::Platypus::Legacy::Raw> void type.

=cut

sub void ()  { ord 'v' }

=head2 int

 my $type = FFI::Platypus::Legacy::Raw::int();

Return a C<FFI::Platypus::Legacy::Raw> integer type.

=cut

sub int ()   { ord 'i' }

=head2 uint

 my $type = FFI::Platypus::Legacy::Raw::uint();

Return a C<FFI::Platypus::Legacy::Raw> unsigned integer type.

=cut

sub uint ()   { ord 'I' }

=head2 short

 my $type = FFI::Platypus::Legacy::Raw::short();

Return a C<FFI::Platypus::Legacy::Raw> short integer type.

=cut

sub short ()   { ord 'z' }

=head2 ushort

 my $type = FFI::Platypus::Legacy::Raw::ushort();

Return a C<FFI::Platypus::Legacy::Raw> unsigned short integer type.

=cut

sub ushort ()   { ord 'Z' }

=head2 long

 my $type = FFI::Platypus::Legacy::Raw::long();

Return a C<FFI::Platypus::Legacy::Raw> long integer type.

=cut

sub long ()   { ord 'l' }

=head2 ulong

 my $type = FFI::Platypus::Legacy::Raw::ulong();

Return a C<FFI::Platypus::Legacy::Raw> unsigned long integer type.

=cut

sub ulong ()   { ord 'L' }

=head2 int64

 my $type = FFI::Platypus::Legacy::Raw::int64();

Return a C<FFI::Platypus::Legacy::Raw> 64 bit integer type. This requires L<Math::Int64> to work.

=cut

sub int64 ()   { ord 'x' }

=head2 uint64

 my $type = FFI::Platypus::Legacy::Raw::uint64();

Return a C<FFI::Platypus::Legacy::Raw> unsigned 64 bit integer type. This requires L<Math::Int64> 
to work.

=cut

sub uint64 ()   { ord 'X' }

=head2 char

 my $type = FFI::Platypus::Legacy::Raw::char();

Return a C<FFI::Platypus::Legacy::Raw> char type.

=cut

sub char ()  { ord 'c' }

=head2 uchar

 my $type = FFI::Platypus::Legacy::Raw::uchar();

Return a C<FFI::Platypus::Legacy::Raw> unsigned char type.

=cut

sub uchar ()  { ord 'C' }

=head2 float

 my $type = FFI::Platypus::Legacy::Raw::float();

Return a C<FFI::Platypus::Legacy::Raw> float type.

=cut

sub float () { ord 'f' }

=head2 double

 my $type = FFI::Platypus::Legacy::Raw::double();

Return a C<FFI::Platypus::Legacy::Raw> double type.

=cut

sub double () { ord 'd' }

=head2 str

 my $type = FFI::Platypus::Legacy::Raw::str();

Return a C<FFI::Platypus::Legacy::Raw> string type.

=cut

sub str ()   { ord 's' }

=head2 ptr

 my $type = FFI::Platypus::Legacy::Raw::ptr();

Return a C<FFI::Platypus::Legacy::Raw> pointer type.

=cut

sub ptr ()   { ord 'p' }

=head1 SEE ALSO

L<FFI::Platypus>, L<Alt::FFI::Raw::Platypus>

=cut

1;
