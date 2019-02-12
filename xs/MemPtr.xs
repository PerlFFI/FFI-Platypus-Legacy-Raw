MODULE = FFI::Platypus::Legacy::Raw				PACKAGE = FFI::Platypus::Legacy::Raw::MemPtr

FFI_Raw_MemPtr_t *
new_from_ptr(class, pointer)
	SV *class
	SV *pointer

	PREINIT:
		void *ptr;

	CODE:
		if (sv_isobject(pointer) &&
		    sv_derived_from(pointer, "FFI::Platypus::Legacy::Raw::Ptr"))
			ptr = INT2PTR(void *, SvIV((SV *) SvRV(pointer)));
		else
			ptr = SvRV(pointer);

		Newx(RETVAL, sizeof(ptr), char);
		Copy(&ptr, RETVAL, sizeof(ptr), char);

	OUTPUT: RETVAL

