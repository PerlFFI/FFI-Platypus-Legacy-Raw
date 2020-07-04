# FFI::Platypus::Legacy::Raw [![Build Status](https://travis-ci.org/PerlFFI/FFI-Platypus-Legacy-Raw.svg)](http://travis-ci.org/PerlFFI/FFI-Platypus-Legacy-Raw)

Perl bindings to the portable FFI library (libffi)

# SYNOPSIS

```perl
use FFI::Platypus::Legacy::Raw;

my $cos = FFI::Platypus::Legacy::Raw->new(
  'libm.so', 'cos',
  FFI::Platypus::Legacy::Raw::double, # return value
  FFI::Platypus::Legacy::Raw::double  # arg #1
);

say $cos->call(2.0);
```

# DESCRIPTION

**FFI::Platypus::Legacy::Raw** and friends are a fork of [FFI::Raw](https://metacpan.org/pod/FFI::Raw) that uses [FFI::Platypus](https://metacpan.org/pod/FFI::Platypus)
instead of [FFI::Raw](https://metacpan.org/pod/FFI::Raw)'s own libffi implementation.  It is intended for use when migrating from
[FFI::Raw](https://metacpan.org/pod/FFI::Raw) to [FFI::Platypus](https://metacpan.org/pod/FFI::Platypus).  The main reason one might have for switching from Raw to Platypus
is because Platypus is actively maintained, provides a more powerful interface, can be much faster
when functions are "attached", and works on more platforms than Raw.  This module should be a drop
in replacement for [FFI::Raw](https://metacpan.org/pod/FFI::Raw), simply replace all instances of `FFI::Raw` to
`FFI::Platypus::Legacy::Raw`.  See also [Alt::FFI::Raw::Platypus](https://metacpan.org/pod/Alt::FFI::Raw::Platypus) for a way to use this module
without making any source code changes.

**FFI::Platypus::Legacy::Raw** provides a low-level foreign function interface (FFI) for Perl based
on [libffi](http://sourceware.org/libffi/). In essence, it can access and call
functions exported by shared libraries without the need to write C/XS code.

Dynamic symbols can be automatically resolved at runtime so that the only
information needed to use **FFI::Platypus::Legacy::Raw** is the name (or path) of the target
library, the name of the function to call and its signature (though it is also
possible to pass a function pointer obtained, for example, using [DynaLoader](https://metacpan.org/pod/DynaLoader)).

Note that this module has nothing to do with [FFI](https://metacpan.org/pod/FFI).

# CONSTRUCTORS

## new

```perl
my $ffi = FFI::Platypus::Legacy::Raw->new( $library, $function, $return_type, @arg_types )
```

Create a new `FFI::Platypus::Legacy::Raw` object. It loads `$library`, finds the function
`$function` with return type `$return_type` and creates a calling interface.

If `$library` is `undef` then the function is searched in the main program.

This method also takes a variable number of types, representing the arguments
of the wanted function.

## new\_from\_ptr

```perl
my $ffi = FFI::Platypus::Legacy::Raw->new_from_ptr( $function_ptr, $return_type, @arg_types )
```

Create a new `FFI::Platypus::Legacy::Raw` object from the `$function_ptr` function pointer.

This method also takes a variable number of types, representing the arguments
of the wanted function.

# METHODS

## call

```perl
my $ret = $ffi->call( @args)
```

Execute the `FFI::Platypus::Legacy::Raw` function. This method also takes a variable number of
arguments, which are passed to the called function. The argument types must
match the types passed to `new` (or `new_from_ptr`).

The `FFI::Platypus::Legacy::Raw` object can be used as a CODE reference as well. Dereferencing
the object will work just like call():

```
$cos->call(2.0); # normal call() call
$cos->(2.0);     # dereference as CODE ref
```

This works because FFI::Platypus::Legacy::Raw overloads the `&{}` operator.

## coderef

```perl
my $code = FFI::Platypus::Legacy::Raw->coderef;
```

Return a code reference of a given `FFI::Platypus::Legacy::Raw`.

# SUBROUTINES

## memptr

```perl
my $memptr = FFI::Platypus::Legacy::Raw::memptr( $length );
```

Create a [FFI::Platypus::Legacy::Raw::MemPtr](https://metacpan.org/pod/FFI::Platypus::Legacy::Raw::MemPtr). This is a shortcut for `FFI::Platypus::Legacy::Raw::MemPtr->new(...)`.

## callback

```perl
my $callback = FFI::Platypus::Legacy::Raw::callback( $coderef, $ret_type, \@arg_types );
```

Create a [FFI::Platypus::Legacy::Raw::Callback](https://metacpan.org/pod/FFI::Platypus::Legacy::Raw::Callback). This is a shortcut for `FFI::Platypus::Legacy::Raw::Callback->new(...)`.

# TYPES

Caveats on the way types were defined by the original [FFI::Raw](https://metacpan.org/pod/FFI::Raw):

This module uses the common convention that `char` is 8 bits, `short` is 16 bits,
`int` is 32 bits, `long` is 32 bits on a 32bit arch and 64 bits on a 64 bit arch,
`int64` is 64 bits.  While this is probably true on most modern platforms
(if not all), it isn't technically guaranteed by the standard.  [FFI::Platypus](https://metacpan.org/pod/FFI::Platypus)
itself, differs in that `int`, `long`, etc are the native sizes, even if they do not
follow this common convention and you need to use `sint32`, `sint64`, etc if you
want a specific sized type.

This module also assumes that `char` is signed.  Although this is commonly true
on many platforms it is not guaranteed by the standard.  On Windows, for example the
`char` type is unsigned.  [FFI::Platypus](https://metacpan.org/pod/FFI::Platypus) by contrast follows to the standard
where `char` uses the native behavior, and if you want an signed character type
you can use `sint8` instead.

## void

```perl
my $type = FFI::Platypus::Legacy::Raw::void();
```

Return a `FFI::Platypus::Legacy::Raw` void type.

## int

```perl
my $type = FFI::Platypus::Legacy::Raw::int();
```

Return a `FFI::Platypus::Legacy::Raw` integer type.

## uint

```perl
my $type = FFI::Platypus::Legacy::Raw::uint();
```

Return a `FFI::Platypus::Legacy::Raw` unsigned integer type.

## short

```perl
my $type = FFI::Platypus::Legacy::Raw::short();
```

Return a `FFI::Platypus::Legacy::Raw` short integer type.

## ushort

```perl
my $type = FFI::Platypus::Legacy::Raw::ushort();
```

Return a `FFI::Platypus::Legacy::Raw` unsigned short integer type.

## long

```perl
my $type = FFI::Platypus::Legacy::Raw::long();
```

Return a `FFI::Platypus::Legacy::Raw` long integer type.

## ulong

```perl
my $type = FFI::Platypus::Legacy::Raw::ulong();
```

Return a `FFI::Platypus::Legacy::Raw` unsigned long integer type.

## int64

```perl
my $type = FFI::Platypus::Legacy::Raw::int64();
```

Return a `FFI::Platypus::Legacy::Raw` 64 bit integer type. This requires [Math::Int64](https://metacpan.org/pod/Math::Int64) to work.

## uint64

```perl
my $type = FFI::Platypus::Legacy::Raw::uint64();
```

Return a `FFI::Platypus::Legacy::Raw` unsigned 64 bit integer type. This requires [Math::Int64](https://metacpan.org/pod/Math::Int64) 
to work.

## char

```perl
my $type = FFI::Platypus::Legacy::Raw::char();
```

Return a `FFI::Platypus::Legacy::Raw` char type.

## uchar

```perl
my $type = FFI::Platypus::Legacy::Raw::uchar();
```

Return a `FFI::Platypus::Legacy::Raw` unsigned char type.

## float

```perl
my $type = FFI::Platypus::Legacy::Raw::float();
```

Return a `FFI::Platypus::Legacy::Raw` float type.

## double

```perl
my $type = FFI::Platypus::Legacy::Raw::double();
```

Return a `FFI::Platypus::Legacy::Raw` double type.

## str

```perl
my $type = FFI::Platypus::Legacy::Raw::str();
```

Return a `FFI::Platypus::Legacy::Raw` string type.

## ptr

```perl
my $type = FFI::Platypus::Legacy::Raw::ptr();
```

Return a `FFI::Platypus::Legacy::Raw` pointer type.

# EXTENSIONS

Documented in this section are features that are available
when using [FFI::Platypus::Legacy::Raw](https://metacpan.org/pod/FFI::Platypus::Legacy::Raw), but are NOT
provided by [FFI::Raw](https://metacpan.org/pod/FFI::Raw).  Only use them if you do not intend
on switching back to [FFI::Raw](https://metacpan.org/pod/FFI::Raw).

## attach

```
$ffi->attach;  # allowed for functions specified by name
               # but not by address/pointer
$ffi->attach($name);
$ffi->attach($name, $prototype);
```

Attach the function as an xsub.  This is probably the most
important feature that [FFI::Platypus](https://metacpan.org/pod/FFI::Platypus) provides that [FFI::Raw](https://metacpan.org/pod/FFI::Raw)
does not.  calling an attached xsub is much faster than 
calling an unattached function.

## platypus

```perl
my $ffi = FFI::Platypus::Legacy::Raw->platypus($library);
```

Returns the [FFI::Platypus](https://metacpan.org/pod/FFI::Platypus) instance used internally by this
module.  This can be useful to customize for your particular
library.  Adding types can be useful.

```perl
my $lib = 'libfoo.so';
my $ffi = FFI::Platypus::Legacy::Raw->platypus($lib);
$ffi->type('int[42]' => 'my_int_42');
my $f = FFI::Platypus::Legacy::Raw->new(
  $lib, 'my_array_sum',
  'int', 'my_int_64',
);
my $sum = $f->call([1..42]);
```

You CANNOT get the platypus instance for `undef` (libc and
other codes already linked into the currently running Perl)
using this interface, as that is somewhat "global" and adding
types or other customizations there could break other modules.

## mix and match types

You can mix and match [FFI::Raw](https://metacpan.org/pod/FFI::Raw) and [FFI::Platypus](https://metacpan.org/pod/FFI::Platypus) types.
The main benefit is that you get the more rigorous type system
as described above in the TYPES caveat.

There is an overhead to the `FFI::Platypus::Legacy:Raw::ptr`
type in order to handle the various pointer types (
[FFI::Platypus::Legacy::Raw::Ptr](https://metacpan.org/pod/FFI::Platypus::Legacy::Raw::Ptr),
[FFI::Platypus::Legacy::Raw::MemPtr](https://metacpan.org/pod/FFI::Platypus::Legacy::Raw::MemPtr),
[FFI::Platypus::Legacy::Raw::Callback](https://metacpan.org/pod/FFI::Platypus::Legacy::Raw::Callback)).  If you aren't using
those classes, then you can save a few cycles by instead using
the Platypus `opaque` type.

# SEE ALSO

[FFI::Platypus](https://metacpan.org/pod/FFI::Platypus), [Alt::FFI::Raw::Platypus](https://metacpan.org/pod/Alt::FFI::Raw::Platypus)

# AUTHOR

Original author: Alessandro Ghedini (ghedo, ALEXBIO)

Current maintainer: Graham Ollis <plicease@cpan.org>

Contributors:

Bakkiaraj Murugesan (bakkiaraj)

Dylan Cali (CALID)

Brian Wightman (MidLifeXis, MLX)

David Steinbrunner (dsteinbrunner)

Olivier Mengué (DOLMEN)

# COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Alessandro Ghedini.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
