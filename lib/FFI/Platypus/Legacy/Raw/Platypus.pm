package FFI::Platypus::Legacy::Raw::Platypus;

use strict;
use warnings;
use FFI::Platypus::Legacy::Raw;
use FFI::Platypus;
use base qw( Exporter );

# ABSTRACT: Private class for FFI::Platypus::Legacy::Raw
# VERSION

our @EXPORT = qw( _ffi _ffi_libc _ffi_package );

my %ffi;
sub _ffi ($)
{
  my $lib = shift;
  die "lib is not defined" unless defined $lib;
  $ffi{$lib} ||= do {
    my $ffi = FFI::Platypus->new;
    $ffi->lang('Raw');
    $ffi->lib($lib);
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
    $package->package('FFI::Platypus::Legacy::Raw', $INC{'FFI/Platypus/Legacy/Raw.pm'});
  }

  $package;
}

1;
