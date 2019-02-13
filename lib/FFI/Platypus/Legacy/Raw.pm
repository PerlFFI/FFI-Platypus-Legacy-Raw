package FFI::Platypus::Legacy::Raw;

use strict;
use warnings;
use FFI::Platypus;
use FFI::Platypus::Legacy::Raw::Platypus;
use FFI::Platypus::Legacy::Raw::Callback;
use FFI::Platypus::Legacy::Raw::Ptr;
use FFI::Platypus::Legacy::Raw::MemPtr;
use overload
  '&{}'  => \&coderef,
  'bool' => \&_bool;

# ABSTRACT: Perl bindings to the portable FFI library (libffi)
# VERSION

sub _bool {
  my $ffi = shift;
  return $ffi;
}

=head1 SYNOPSIS

 use FFI::Platypus::Legacy::Raw;
 
 my $cos = FFI::Platypus::Legacy::Raw->new(
   'libm.so', 'cos',
   FFI::Platypus::Legacy::Raw::double, # return value
   FFI::Platypus::Legacy::Raw::double  # arg #1
 );
 
 say $cos->call(2.0);

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

=cut

sub _new
{
  my($class, $ffi, $id, $ret_type, @types) = @_;
  my $f = $ffi->function($id => \@types => $ret_type);
  bless [$f], $class;
}

sub new
{
  my($class, $library, $function, @types) = @_;
  my $self = $class->_new(
    defined $library ? _ffi $library : _ffi_libc,
    $function,
    @types
  );
  $self->[1] = $function;
  $self;
}

=head2 new_from_ptr

 my $ffi = FFI::Platypus::Legacy::Raw->new_from_ptr( $function_ptr, $return_type, @arg_types )

Create a new C<FFI::Platypus::Legacy::Raw> object from the C<$function_ptr> function pointer.

This method also takes a variable number of types, representing the arguments
of the wanted function.

=cut

sub new_from_ptr
{
  my($class, $ptr, @types) = @_;
  $class->_new(
    _ffi_package,
    $ptr,
    @types,
  );
  
}

=head1 METHODS

=head2 call

 my $ret = $ffi->call( @args)

Execute the C<FFI::Platypus::Legacy::Raw> function. This method also takes a variable number of
arguments, which are passed to the called function. The argument types must
match the types passed to C<new> (or C<new_from_ptr>).

The C<FFI::Platypus::Legacy::Raw> object can be used as a CODE reference as well. Dereferencing
the object will work just like call():

 $cos->call(2.0); # normal call() call
 $cos->(2.0);     # dereference as CODE ref

This works because FFI::Platypus::Legacy::Raw overloads the C<&{}> operator.

=cut

sub call
{
  my $self = shift;
  $self->[0]->call(@_);
}

=head2 coderef

 my $code = FFI::Platypus::Legacy::Raw->coderef;

Return a code reference of a given C<FFI::Platypus::Legacy::Raw>.

=cut

sub coderef
{
  my $self = shift;
  return sub { $self->call(@_) };
}

=head1 SUBROUTINES

=head2 memptr

 my $memptr = FFI::Platypus::Legacy::Raw::memptr( $length );

Create a L<FFI::Platypus::Legacy::Raw::MemPtr>. This is a shortcut for C<FFI::Platypus::Legacy::Raw::MemPtr-E<gt>new(...)>.

=cut

sub memptr { FFI::Platypus::Legacy::Raw::MemPtr->new(@_) }

=head2 callback

 my $callback = FFI::Platypus::Legacy::Raw::callback( $coderef, $ret_type, \@arg_types );

Create a L<FFI::Platypus::Legacy::Raw::Callback>. This is a shortcut for C<FFI::Platypus::Legacy::Raw::Callback-E<gt>new(...)>.

=cut

sub callback { FFI::Platypus::Legacy::Raw::Callback->new(@_) }

=head1 TYPES

Caveats on the way types were defined by the original L<FFI::Raw>:

This module uses the common convention that C<char> is 8 bits, C<short> is 16 bits,
C<int> is 32 bits, C<long> is 32 bits on a 32bit arch and 64 bits on a 64 bit arch,
C<int64> is 64 bits.  While this is probably true on most modern platforms
(if not all), it isn't technically guaranteed by the standard.  L<FFI::Platypus>
itself, differs in that C<int>, C<long>, etc are the native sizes, even if they do not
follow this common convention and you need to use C<sint32>, C<sint64>, etc if you
want a specific sized type.

This module also assumes that C<char> is signed.  Although this is commonly true
on many platforms it is not guaranteed by the standard.  On Windows, for example the
C<char> type is unsigned.  L<FFI::Platypus> by contrast follows to the standard
where C<char> uses the native behavior, and if you want an signed character type
you can use C<sint8> instead.

=head2 void

 my $type = FFI::Platypus::Legacy::Raw::void();

Return a C<FFI::Platypus::Legacy::Raw> void type.

=cut

sub void ()  { 'v' }

=head2 int

 my $type = FFI::Platypus::Legacy::Raw::int();

Return a C<FFI::Platypus::Legacy::Raw> integer type.

=cut

sub int ()   { 'i' }

=head2 uint

 my $type = FFI::Platypus::Legacy::Raw::uint();

Return a C<FFI::Platypus::Legacy::Raw> unsigned integer type.

=cut

sub uint ()   { 'I' }

=head2 short

 my $type = FFI::Platypus::Legacy::Raw::short();

Return a C<FFI::Platypus::Legacy::Raw> short integer type.

=cut

sub short ()   { 'z' }

=head2 ushort

 my $type = FFI::Platypus::Legacy::Raw::ushort();

Return a C<FFI::Platypus::Legacy::Raw> unsigned short integer type.

=cut

sub ushort ()   { 'Z' }

=head2 long

 my $type = FFI::Platypus::Legacy::Raw::long();

Return a C<FFI::Platypus::Legacy::Raw> long integer type.

=cut

sub long ()   { 'l' }

=head2 ulong

 my $type = FFI::Platypus::Legacy::Raw::ulong();

Return a C<FFI::Platypus::Legacy::Raw> unsigned long integer type.

=cut

sub ulong ()   { 'L' }

=head2 int64

 my $type = FFI::Platypus::Legacy::Raw::int64();

Return a C<FFI::Platypus::Legacy::Raw> 64 bit integer type. This requires L<Math::Int64> to work.

=cut

sub int64 ()   { 'x' }

=head2 uint64

 my $type = FFI::Platypus::Legacy::Raw::uint64();

Return a C<FFI::Platypus::Legacy::Raw> unsigned 64 bit integer type. This requires L<Math::Int64> 
to work.

=cut

sub uint64 ()   { 'X' }

=head2 char

 my $type = FFI::Platypus::Legacy::Raw::char();

Return a C<FFI::Platypus::Legacy::Raw> char type.

=cut

sub char ()  { 'c' }

=head2 uchar

 my $type = FFI::Platypus::Legacy::Raw::uchar();

Return a C<FFI::Platypus::Legacy::Raw> unsigned char type.

=cut

sub uchar ()  { 'C' }

=head2 float

 my $type = FFI::Platypus::Legacy::Raw::float();

Return a C<FFI::Platypus::Legacy::Raw> float type.

=cut

sub float () { 'f' }

=head2 double

 my $type = FFI::Platypus::Legacy::Raw::double();

Return a C<FFI::Platypus::Legacy::Raw> double type.

=cut

sub double () { 'd' }

=head2 str

 my $type = FFI::Platypus::Legacy::Raw::str();

Return a C<FFI::Platypus::Legacy::Raw> string type.

=cut

sub str ()   { 's' }

=head2 ptr

 my $type = FFI::Platypus::Legacy::Raw::ptr();

Return a C<FFI::Platypus::Legacy::Raw> pointer type.

=cut

sub ptr ()   { 'p' }

=head1 EXTENSIONS

Documented in this section are features that are available
when using L<FFI::Platypus::Legacy::Raw>, but are NOT
provided by L<FFI::Raw>.  Only use them if you do not intend
on switching back to L<FFI::Raw>.

=head2 attach

 $ffi->attach;  # allowed for functions specified by name
                # but not by address/pointer
 $ffi->attach($name);
 $ffi->attach($name, $prototype);

Attach the function as an xsub.  This is probably the most
important feature that L<FFI::Platypus> provides that L<FFI::Raw>
does not.  calling an attached xsub is much faster than 
calling an unattached function.

=cut

sub attach
{
  my($self, $perl_name, $proto) = @_;

  unless(defined $perl_name)
  {
    $perl_name = $self->[1];
    unless(defined $perl_name)
    {
      require Carp;
      Carp::croak("Cannot determine function name from a pointer");
    }
  }

  # some of this logic is unfortunately replicated
  # in FFI-Platypus :/
  if($perl_name !~ /::/)
  {
    my $caller = caller;
    $perl_name = join '::', $caller, $perl_name;
  }
  
  $self->[0]->attach($perl_name, $proto);
}

=head1 SEE ALSO

L<FFI::Platypus>, L<Alt::FFI::Raw::Platypus>

=cut

1;
