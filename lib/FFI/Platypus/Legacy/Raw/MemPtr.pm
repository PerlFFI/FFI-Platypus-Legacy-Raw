package FFI::Platypus::Legacy::Raw::MemPtr;

use strict;
use warnings;
use Carp qw( croak );
use FFI::Platypus::Memory qw( malloc free memcpy );
use FFI::Platypus::Buffer qw( scalar_to_buffer );

our @ISA = qw( FFI::Platypus::Legacy::Raw::Ptr );

=head1 NAME

FFI::Platypus::Legacy::Raw::MemPtr - FFI::Platypus::Legacy::Raw memory pointer type

=head1 DESCRIPTION

A B<FFI::Platypus::Legacy::Raw::MemPtr> represents a memory pointer which can be passed to
functions taking a C<FFI::Platypus::Legacy::Raw::ptr> argument.

The allocated memory is automatically deallocated once the object is not in use
anymore.

=head1 CONSTRUCTORS

=head2 new

 FFI::Platypus::Legacy::Raw::MemPtr->new( $length );

Allocate a new C<FFI::Platypus::Legacy::Raw::MemPtr> of size C<$length> bytes.

=cut

sub new
{
  my($class, $size) = @_;
  my $ptr = malloc $size;
  bless \$ptr, $class;
}

sub DESTROY
{
  my($self) = @_;
  free $$self;
}

=head2 new_from_buf

 my $memptr = FFI::Platypus::Legacy::Raw::MemPtr->new_from_buf( $buffer, $length );

Allocate a new C<FFI::Platypus::Legacy::Raw::MemPtr> of size C<$length> bytes and copy C<$buffer>
into it. This can be used, for example, to pass a pointer to a function that
takes a C struct pointer, by using C<pack()> or the L<Convert::Binary::C> module
to create the actual struct content.

For example, consider the following C code

    struct some_struct {
      int some_int;
      char some_str[];
    };

    extern void take_one_struct(struct some_struct *arg) {
      if (arg -> some_int == 42)
        puts(arg -> some_str);
    }

It can be called using FFI::Platypus::Legacy::Raw as follows:

    use FFI::Platypus::Legacy::Raw;

    my $packed = pack('ix![p]p', 42, 'hello');
    my $arg = FFI::Platypus::Legacy::Raw::MemPtr -> new_from_buf($packed, length $packed);

    my $take_one_struct = FFI::Platypus::Legacy::Raw -> new(
      $shared, 'take_one_struct',
      FFI::Platypus::Legacy::Raw::void, FFI::Platypus::Legacy::Raw::ptr
    );

    $take_one_struct -> ($arg);

Which would print C<hello>.

=cut

sub new_from_buf
{
  my($class, undef, $size) = @_;
  my $dst = malloc $size;
  my($src, undef) = scalar_to_buffer $_[1];
  memcpy $dst, $src, $size;
  bless \$dst, $class;
}

=head2 new_from_ptr

 my $memptr = FFI::Platypus::Legacy::Raw::MemPtr->new_from_ptr( $ptr );

Allocate a new C<FFI::Platypus::Legacy::Raw::MemPtr> pointing to the C<$ptr>, which can be either
a C<FFI::Platypus::Legacy::Raw::MemPtr> or a pointer returned by another function.

This is the C<FFI::Platypus::Legacy::Raw> equivalent of a pointer to a pointer.

=cut

#sub new_from_ptr
#{
#  my($class, $ptr) = @_;
#  if(ref $ptr)
#  {
#    if(eval { $ptr->isa('FFI::Platypus::Legacy::Raw::Ptr') })
#    {
#      $ptr = $$ptr;
#    }
#  }
#}

=head1 METHODS

=head2 to_perl_str

 my $memptr = FFI::Platypus::Legacy::Raw::MemPtr->to_perl_str;
 my $memptr = FFI::Platypus::Legacy::Raw::MemPtr->to_perl_str( $length );

Convert a C<FFI::Platypus::Legacy::Raw::MemPtr> to a Perl string. If C<$length> is not provided,
the length of the string will be computed using C<strlen()>.

=cut

## NOTE: prototype for a method is kind of dumb but we are including it for
## compatability with FFI::Raw
#sub to_perl_str ($;$)
#{
#  my($self, $size) = @_;
#  if(@_ == 1)
#  {
#    
#  }
#  elsif(@_ == 2)
#  {
#  }
#  else
#  {
#    croak "Wrong number of arguments";
#  }
#}

=for Pod::Coverage tostr

=cut

sub tostr {
  my $self = shift;
  return $self -> to_perl_str(@_)
}

=head1 AUTHOR

Alessandro Ghedini <alexbio@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright 2013 Alessandro Ghedini.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of FFI::Platypus::Legacy::Raw::MemPtr
