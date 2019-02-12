# FFI::Platypus::Legacy::Raw [![Build Status](https://secure.travis-ci.org/plicease/FFI-Platypus-Legacy-Raw.png)](http://travis-ci.org/plicease/FFI-Platypus-Legacy-Raw)

Perl bindings to the portable FFI library (libffi)

# SYNOPSIS

    use FFI::Platypus::Legacy::Raw;
    
    my $cos = FFI::Platypus::Legacy::Raw -> new(
      'libm.so', 'cos',
      FFI::Platypus::Legacy::Raw::double, # return value
      FFI::Platypus::Legacy::Raw::double  # arg #1
    );
    
    say $cos -> call(2.0);

# DESCRIPTION

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

    my $ffi = FFI::Platypus::Legacy::Raw->new( $library, $function, $return_type, @arg_types )

Create a new `FFI::Platypus::Legacy::Raw` object. It loads `$library`, finds the function
`$function` with return type `$return_type` and creates a calling interface.

If `$library` is `undef` then the function is searched in the main program.

This method also takes a variable number of types, representing the arguments
of the wanted function.

## new\_from\_ptr

    my $ffi = FFI::Platypus::Legacy::Raw->new_from_ptr( $function_ptr, $return_type, @arg_types )

Create a new `FFI::Platypus::Legacy::Raw` object from the `$function_ptr` function pointer.

This method also takes a variable number of types, representing the arguments
of the wanted function.

# METHODS

## call

    my $ret = $ffi->call( @args)

Execute the `FFI::Platypus::Legacy::Raw` function. This method also takes a variable number of
arguments, which are passed to the called function. The argument types must
match the types passed to `new` (or `new_from_ptr`).

The `FFI::Platypus::Legacy::Raw` object can be used as a CODE reference as well. Dereferencing
the object will work just like call():

    $cos -> call(2.0); # normal call() call
    $cos -> (2.0);     # dereference as CODE ref

This works because FFI::Platypus::Legacy::Raw overloads the `&{}` operator.

## coderef

    my $code = FFI::Platypus::Legacy::Raw->coderef;

Return a code reference of a given `FFI::Platypus::Legacy::Raw`.

# SUBROUTINES

## memptr

    my $memptr = FFI::Platypus::Legacy::Raw::memptr( $length );

Create a [FFI::Platypus::Legacy::Raw::MemPtr](https://metacpan.org/pod/FFI::Platypus::Legacy::Raw::MemPtr). This is a shortcut for `FFI::Platypus::Legacy::Raw::MemPtr->new(...)`.

## callback

    my $callback = FFI::Platypus::Legacy::Raw::callback( $coderef, $ret_type, \@arg_types );

Create a [FFI::Platypus::Legacy::Raw::Callback](https://metacpan.org/pod/FFI::Platypus::Legacy::Raw::Callback). This is a shortcut for `FFI::Platypus::Legacy::Raw::Callback->new(...)`.

# TYPES

## void

    my $type = FFI::Platypus::Legacy::Raw::void();

Return a `FFI::Platypus::Legacy::Raw` void type.

## int

    my $type = FFI::Platypus::Legacy::Raw::int();

Return a `FFI::Platypus::Legacy::Raw` integer type.

## uint

    my $type = FFI::Platypus::Legacy::Raw::uint();

Return a `FFI::Platypus::Legacy::Raw` unsigned integer type.

## short

    my $type = FFI::Platypus::Legacy::Raw::short();

Return a `FFI::Platypus::Legacy::Raw` short integer type.

## ushort

    my $type = FFI::Platypus::Legacy::Raw::ushort();

Return a `FFI::Platypus::Legacy::Raw` unsigned short integer type.

## long

    my $type = FFI::Platypus::Legacy::Raw::long();

Return a `FFI::Platypus::Legacy::Raw` long integer type.

## ulong

    my $type = FFI::Platypus::Legacy::Raw::ulong();

Return a `FFI::Platypus::Legacy::Raw` unsigned long integer type.

## int64

    my $type = FFI::Platypus::Legacy::Raw::int64();

Return a `FFI::Platypus::Legacy::Raw` 64 bit integer type. This requires [Math::Int64](https://metacpan.org/pod/Math::Int64) to work.

## uint64

    my $type = FFI::Platypus::Legacy::Raw::uint64();

Return a `FFI::Platypus::Legacy::Raw` unsigned 64 bit integer type. This requires [Math::Int64](https://metacpan.org/pod/Math::Int64) 
to work.

## char

    my $type = FFI::Platypus::Legacy::Raw::char();

Return a `FFI::Platypus::Legacy::Raw` char type.

## uchar

    my $type = FFI::Platypus::Legacy::Raw::uchar();

Return a `FFI::Platypus::Legacy::Raw` unsigned char type.

## float

    my $type = FFI::Platypus::Legacy::Raw::float();

Return a `FFI::Platypus::Legacy::Raw` float type.

## double

    my $type = FFI::Platypus::Legacy::Raw::double();

Return a `FFI::Platypus::Legacy::Raw` double type.

## str

    my $type = FFI::Platypus::Legacy::Raw::str();

Return a `FFI::Platypus::Legacy::Raw` string type.

## ptr

    my $type = FFI::Platypus::Legacy::Raw::ptr();

Return a `FFI::Platypus::Legacy::Raw` pointer type.

# SEE ALSO

[FFI](https://metacpan.org/pod/FFI), [Ctypes](http://gitorious.org/perl-ctypes)

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
