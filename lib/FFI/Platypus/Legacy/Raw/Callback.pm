package FFI::Platypus::Legacy::Raw::Callback;

use strict;
use warnings;

# ABSTRACT: FFI::Platypus::Legacy::Raw function pointer type
# VERSION

=head1 DESCRIPTION

B<FFI::Platypus::Legacy::Raw> and friends are a fork of L<FFI::Raw> that uses L<FFI::Platypus>
instead of L<FFI::Raw>'s own libffi implementation.  It is intended for use when migrating from
L<FFI::Raw> to L<FFI::Platypus>.  The main reason one might have for switching from Raw to Platypus
is because Platypus is actively maintained, provides a more powerful interface, can be much faster
when functions are "attached", and works on more platforms than Raw.  This module should be a drop
in replacement for L<FFI::Raw>, simply replace all instances of C<FFI::Raw> to
C<FFI::Platypus::Legacy::Raw>.  See also L<Alt::FFI::Raw::Platypus> for a way to use this module
without making any source code changes.

A B<FFI::Platypus::Legacy::Raw::Callback> represents a function pointer to a Perl routine. It can
be passed to functions taking a C<FFI::Platypus::Legacy::Raw::ptr> type.

=head1 CONSTRUCTOR

=head2 new

 my $callback = FFI::Platypus::Legacy::Raw::Callback->new( $coderef, $ret_type, @arg_types );

Create a C<FFI::Platypus::Legacy::Raw::Callback> using the code reference C<$coderef> as body. The
signature (return and arguments types) must also be passed.

=head1 CAVEATS

For callbacks with a C<FFI::Platypus::Legacy::Raw::str> return type, the string value will be copied
to a private field on the callback object.  The memory for this value will be
freed the next time the callback is called, or when the callback itself is freed.
For more exact control over when the return value is freed, you can instead
use C<FFI::Platypus::Legacy::Raw::ptr> type and return a L<FFI::Platypus::Legacy::Raw::MemPtr> object.

=cut

1;
