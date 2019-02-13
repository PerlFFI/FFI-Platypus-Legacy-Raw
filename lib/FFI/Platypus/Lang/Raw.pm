package FFI::Platypus::Lang::Raw;

use strict;
use warnings;
use base qw( FFI::Platypus::Lang::C );

# ABSTRACT: Types for use with FFI::Platypus::Legacy::Raw
# VERSION

=head1 SYNOPSIS

 use FFI::Platypus;

 my $ffi = FFI::Platypus->new;
 $ffi->lang('Raw');

=head1 DESCRIPTION

This is a "language" plugin for L<FFI::Platypus::Legacy::Raw> integration.
Included are the same types provided by L<FFI::Platypus::Lang::C>, plus
the types understood by Raw such as C<FFI::Platypus::Legacy::Raw::int()>.

=head1 METHODS

=head2 native_type_map

 my $hashref = FFI::Platypus::Lang::Raw->native_type_map;

Returns a hashref for the type map for L<FFI::Platypus::Legacy::Raw>.

=cut

my %types;
sub native_type_map
{
  my $class = shift;
  unless(%types)
  {
    %types = (
      %{ $class->SUPER::native_type_map },
      'v' => 'void',
      'l' => 'long',
      'L' => 'unsigned long',
      'x' => 'sint64',
      'X' => 'uint64',
      'i' => 'sint32',
      'I' => 'sint64',
      'z' => 'sint16',
      'Z' => 'uint16',
      'c' => 'sint8',
      'C' => 'uint8',
      'f' => 'float',
      'd' => 'double',
      's' => 'string',
      'p' => 'opaque',
    );
  }
  \%types;
}

1;

=head1 SEE ALSO

=over 4

=item L<FFI::Platypus::Legacy::Raw>

=back

=cut
