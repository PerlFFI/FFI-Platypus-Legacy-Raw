package FFI::Platypus::Legacy::Raw::Platypus;

use strict;
use warnings;
use Ref::Util qw( is_ref );
use FFI::Platypus;
use base qw( Exporter );

# ABSTRACT: Private class for FFI::Platypus::Legacy::Raw
# VERSION

our @EXPORT = qw( _ffi _ffi_libc _ffi_package );

sub _add_p_type
{
  my $ffi = shift;
  $ffi->custom_type(
    'p' => {
      native_type => 'opaque',
      native_to_perl => sub { $_[0] },
      perl_to_native => sub {
        if(is_ref $_[0])
        {
          if(eval { $_[0]->isa('FFI::Platypus::Legacy::Raw::Ptr') })
          { return ${$_[0]} }
          elsif(eval { $_[0]->isa('FFI::Platypus::Legacy::Raw::Callback') })
          { return $_[0]->{ptr} }
        }
        $_[0];
      },
    },
  );
}

my %ffi;
sub _ffi ($)
{
  my $lib = shift;
  die "lib is not defined" unless defined $lib;
  $ffi{$lib} ||= do {
    my $ffi = FFI::Platypus->new;
    $ffi->lang('Raw');
    $ffi->lib($lib);
    _add_p_type($ffi);
    $ffi;
  };
}

my $libc;
sub _ffi_libc ()
{
  unless($libc)
  {
    $libc = FFI::Platypus->new;
    $libc->lang('Raw');
    $libc->lib(undef);
    _add_p_type($libc);
  }

  $libc;
}

my $package;
sub _ffi_package ()
{
  unless($package)
  {
    $package = FFI::Platypus->new;
    $package->lang('Raw');
    my $file = __FILE__;
    # assumes of course that both this and ../Raw.pm
    # are installed together and in the same place.
    $file =~ s{Raw/Platypus\.pm$}{Raw.pm};
    $package->package('FFI::Platypus::Legacy::Raw', $file);
    _add_p_type($package);
  }

  $package;
}

1;
