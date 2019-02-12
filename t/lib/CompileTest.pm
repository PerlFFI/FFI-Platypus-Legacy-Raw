package CompileTest;

use strict;
use warnings;
use Capture::Tiny qw( capture_merged );
use FindBin ();
use File::Temp qw( tempdir );
use Test::More;
use FFI::Build;

sub compile {
  my ($src_file) = @_;

  my $src = do {
    my $fh;
    open $fh, '<', $src_file;
    local $/;
    <$fh>;
  };

  my $build = FFI::Build->new(
    'test',
    source  => [ [ C => \$src ] ],
    dir     => tempdir( CLEANUP => 1, TEMPLATE => 'ffi-test-XXXXXX', DIR => '.' ),
    cflags  => '-It/ffi',
    verbose => 2,
  );

  my($out, $lib, $err) = capture_merged {
    my $lib = eval { $build->build };
    ($lib, $@);
  };

  if($err)
  {
    diag '';
    diag '';
    diag '';
    diag $out;
    diag $err;
    diag '';
    diag '';
    die "build failed";
  }
  else
  {
    note $out;
    return $lib->path;
  }
}

1;
