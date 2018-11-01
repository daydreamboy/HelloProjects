	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 13
	.p2align	4, 0x90         ## -- Begin function -[MyClass initWithName:number:]
"-[MyClass initWithName:number:]":      ## @"\01-[MyClass initWithName:number:]"
	.cfi_startproc
## BB#0:
	pushq	%rbp
Lcfi0:
	.cfi_def_cfa_offset 16
Lcfi1:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Lcfi2:
	.cfi_def_cfa_register %rbp
	subq	$80, %rsp
	leaq	-24(%rbp), %rax
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	$0, -24(%rbp)
	movq	%rax, %rdi
	movq	%rdx, %rsi
	movl	%ecx, -52(%rbp)         ## 4-byte Spill
	callq	_objc_storeStrong
	leaq	-48(%rbp), %rdi
	movl	-52(%rbp), %ecx         ## 4-byte Reload
	movl	%ecx, -28(%rbp)
	movq	-8(%rbp), %rax
	movq	$0, -8(%rbp)
	movq	%rax, -48(%rbp)
	movq	L_OBJC_CLASSLIST_SUP_REFS_$_(%rip), %rax
	movq	%rax, -40(%rbp)
	movq	L_OBJC_SELECTOR_REFERENCES_(%rip), %rsi
	callq	_objc_msgSendSuper2
	leaq	-8(%rbp), %rdx
	movq	%rax, %rsi
	movq	%rsi, -8(%rbp)
	movq	%rax, %rsi
	movq	%rdx, %rdi
	movq	%rax, -64(%rbp)         ## 8-byte Spill
	callq	_objc_storeStrong
	movq	-64(%rbp), %rax         ## 8-byte Reload
	cmpq	$0, %rax
	je	LBB0_2
## BB#1:
	movq	-24(%rbp), %rax
	movq	-8(%rbp), %rcx
	movq	_OBJC_IVAR_$_MyClass._name(%rip), %rdx
	addq	%rdx, %rcx
	movq	%rcx, %rdi
	movq	%rax, %rsi
	callq	_objc_storeStrong
	movl	-28(%rbp), %r8d
	movq	-8(%rbp), %rax
	movq	_OBJC_IVAR_$_MyClass._number(%rip), %rcx
	movl	%r8d, (%rax,%rcx)
LBB0_2:
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	callq	_objc_retain
	xorl	%ecx, %ecx
	movl	%ecx, %esi
	leaq	-24(%rbp), %rdi
	movq	%rax, -72(%rbp)         ## 8-byte Spill
	callq	_objc_storeStrong
	xorl	%ecx, %ecx
	movl	%ecx, %esi
	leaq	-8(%rbp), %rax
	movq	%rax, %rdi
	callq	_objc_storeStrong
	movq	-72(%rbp), %rax         ## 8-byte Reload
	addq	$80, %rsp
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90         ## -- Begin function -[MyClass name]
"-[MyClass name]":                      ## @"\01-[MyClass name]"
	.cfi_startproc
## BB#0:
	pushq	%rbp
Lcfi3:
	.cfi_def_cfa_offset 16
Lcfi4:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Lcfi5:
	.cfi_def_cfa_register %rbp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-16(%rbp), %rsi
	movq	-8(%rbp), %rdi
	movq	_OBJC_IVAR_$_MyClass._name(%rip), %rdx
	movl	$1, %ecx
	popq	%rbp
	jmp	_objc_getProperty       ## TAILCALL
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90         ## -- Begin function -[MyClass setName:]
"-[MyClass setName:]":                  ## @"\01-[MyClass setName:]"
	.cfi_startproc
## BB#0:
	pushq	%rbp
Lcfi6:
	.cfi_def_cfa_offset 16
Lcfi7:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Lcfi8:
	.cfi_def_cfa_register %rbp
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-16(%rbp), %rsi
	movq	-8(%rbp), %rdx
	movq	_OBJC_IVAR_$_MyClass._name(%rip), %rcx
	movq	-24(%rbp), %rdi
	movq	%rdi, -32(%rbp)         ## 8-byte Spill
	movq	%rdx, %rdi
	movq	-32(%rbp), %rdx         ## 8-byte Reload
	callq	_objc_setProperty_atomic
	addq	$32, %rsp
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90         ## -- Begin function -[MyClass number]
"-[MyClass number]":                    ## @"\01-[MyClass number]"
	.cfi_startproc
## BB#0:
	pushq	%rbp
Lcfi9:
	.cfi_def_cfa_offset 16
Lcfi10:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Lcfi11:
	.cfi_def_cfa_register %rbp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rsi
	movq	_OBJC_IVAR_$_MyClass._number(%rip), %rdi
	movl	(%rsi,%rdi), %eax
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90         ## -- Begin function -[MyClass setNumber:]
"-[MyClass setNumber:]":                ## @"\01-[MyClass setNumber:]"
	.cfi_startproc
## BB#0:
	pushq	%rbp
Lcfi12:
	.cfi_def_cfa_offset 16
Lcfi13:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Lcfi14:
	.cfi_def_cfa_register %rbp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movl	%edx, -20(%rbp)
	movq	-8(%rbp), %rsi
	movq	_OBJC_IVAR_$_MyClass._number(%rip), %rdi
	movl	-20(%rbp), %edx
	movl	%edx, (%rsi,%rdi)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90         ## -- Begin function -[MyClass .cxx_destruct]
"-[MyClass .cxx_destruct]":             ## @"\01-[MyClass .cxx_destruct]"
	.cfi_startproc
## BB#0:
	pushq	%rbp
Lcfi15:
	.cfi_def_cfa_offset 16
Lcfi16:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Lcfi17:
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	xorl	%eax, %eax
	movl	%eax, %ecx
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rsi
	movq	_OBJC_IVAR_$_MyClass._name(%rip), %rdi
	addq	%rdi, %rsi
	movq	%rsi, %rdi
	movq	%rcx, %rsi
	callq	_objc_storeStrong
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_MyFunction             ## -- Begin function MyFunction
	.p2align	4, 0x90
_MyFunction:                            ## @MyFunction
	.cfi_startproc
## BB#0:
	pushq	%rbp
Lcfi18:
	.cfi_def_cfa_offset 16
Lcfi19:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Lcfi20:
	.cfi_def_cfa_register %rbp
	subq	$64, %rsp
	movq	$0, -8(%rbp)
	leaq	-8(%rbp), %rax
	movq	%rdi, -24(%rbp)         ## 8-byte Spill
	movq	%rax, %rdi
	movq	-24(%rbp), %rsi         ## 8-byte Reload
	movq	%rax, -32(%rbp)         ## 8-byte Spill
	callq	_objc_storeStrong
	movq	-8(%rbp), %rdx
	movq	L_OBJC_SELECTOR_REFERENCES_.21(%rip), %rsi
	leaq	L__unnamed_cfstring_(%rip), %rdi
	movq	_objc_msgSend@GOTPCREL(%rip), %rax
	callq	*%rax
	movq	%rax, %rdi
	callq	_objc_retainAutoreleasedReturnValue
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rsi
	leaq	L__unnamed_cfstring_.23(%rip), %rdi
	xorl	%ecx, %ecx
	movb	%cl, %r8b
	movb	%r8b, %al
	movl	%ecx, -36(%rbp)         ## 4-byte Spill
	callq	_NSLog
	movq	-16(%rbp), %rdi
	movq	_objc_retain@GOTPCREL(%rip), %rdx
	callq	*%rdx
	movl	-36(%rbp), %ecx         ## 4-byte Reload
	movl	%ecx, %edx
	leaq	-16(%rbp), %rdi
	movq	%rdx, %rsi
	movq	%rax, -48(%rbp)         ## 8-byte Spill
	movq	%rdx, -56(%rbp)         ## 8-byte Spill
	callq	_objc_storeStrong
	movq	-32(%rbp), %rdi         ## 8-byte Reload
	movq	-56(%rbp), %rsi         ## 8-byte Reload
	callq	_objc_storeStrong
	movq	-48(%rbp), %rax         ## 8-byte Reload
	movq	%rax, %rdi
	addq	$64, %rsp
	popq	%rbp
	jmp	_objc_autoreleaseReturnValue ## TAILCALL
	.cfi_endproc
                                        ## -- End function
	.globl	_main                   ## -- Begin function main
	.p2align	4, 0x90
_main:                                  ## @main
	.cfi_startproc
## BB#0:
	pushq	%rbp
Lcfi21:
	.cfi_def_cfa_offset 16
Lcfi22:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Lcfi23:
	.cfi_def_cfa_register %rbp
	subq	$64, %rsp
	movl	$0, -4(%rbp)
	movl	%edi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	callq	_objc_autoreleasePoolPush
	movq	L_OBJC_CLASSLIST_REFERENCES_$_(%rip), %rsi
	movq	L_OBJC_SELECTOR_REFERENCES_.25(%rip), %rcx
	movq	%rsi, %rdi
	movq	%rcx, %rsi
	movq	%rax, -40(%rbp)         ## 8-byte Spill
	callq	_objc_msgSend
	leaq	L__unnamed_cfstring_.27(%rip), %rcx
	movl	$42, %edx
	movq	L_OBJC_SELECTOR_REFERENCES_.28(%rip), %rsi
	movq	%rax, %rdi
	movl	%edx, -44(%rbp)         ## 4-byte Spill
	movq	%rcx, %rdx
	movl	-44(%rbp), %ecx         ## 4-byte Reload
	callq	_objc_msgSend
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	L_OBJC_SELECTOR_REFERENCES_.29(%rip), %rsi
	movq	%rax, %rdi
	callq	_objc_msgSend
	movq	%rax, %rdi
	callq	_objc_retainAutoreleasedReturnValue
	movq	%rax, %rdi
	movq	%rax, -56(%rbp)         ## 8-byte Spill
	callq	_MyFunction
	movq	%rax, %rdi
	callq	_objc_retainAutoreleasedReturnValue
	movq	%rax, -32(%rbp)
	movq	-56(%rbp), %rax         ## 8-byte Reload
	movq	%rax, %rdi
	callq	_objc_release
	leaq	L__unnamed_cfstring_.23(%rip), %rax
	movq	-32(%rbp), %rsi
	movq	%rax, %rdi
	movb	$0, %al
	callq	_NSLog
	xorl	%ecx, %ecx
	movl	%ecx, %esi
	leaq	-32(%rbp), %rdx
	movl	$0, -4(%rbp)
	movq	%rdx, %rdi
	callq	_objc_storeStrong
	xorl	%ecx, %ecx
	movl	%ecx, %esi
	leaq	-24(%rbp), %rdx
	movq	%rdx, %rdi
	callq	_objc_storeStrong
	movq	-40(%rbp), %rdi         ## 8-byte Reload
	callq	_objc_autoreleasePoolPop
	movl	-4(%rbp), %eax
	addq	$64, %rsp
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.section	__DATA,__objc_data
	.globl	_OBJC_CLASS_$_MyClass   ## @"OBJC_CLASS_$_MyClass"
	.p2align	3
_OBJC_CLASS_$_MyClass:
	.quad	_OBJC_METACLASS_$_MyClass
	.quad	_OBJC_CLASS_$_NSObject
	.quad	__objc_empty_cache
	.quad	0
	.quad	l_OBJC_CLASS_RO_$_MyClass

	.section	__DATA,__objc_superrefs,regular,no_dead_strip
	.p2align	3               ## @"OBJC_CLASSLIST_SUP_REFS_$_"
L_OBJC_CLASSLIST_SUP_REFS_$_:
	.quad	_OBJC_CLASS_$_MyClass

	.section	__TEXT,__objc_methname,cstring_literals
L_OBJC_METH_VAR_NAME_:                  ## @OBJC_METH_VAR_NAME_
	.asciz	"init"

	.section	__DATA,__objc_selrefs,literal_pointers,no_dead_strip
	.p2align	3               ## @OBJC_SELECTOR_REFERENCES_
L_OBJC_SELECTOR_REFERENCES_:
	.quad	L_OBJC_METH_VAR_NAME_

	.section	__DATA,__objc_ivar
	.globl	_OBJC_IVAR_$_MyClass._name ## @"OBJC_IVAR_$_MyClass._name"
	.p2align	3
_OBJC_IVAR_$_MyClass._name:
	.quad	8                       ## 0x8

	.globl	_OBJC_IVAR_$_MyClass._number ## @"OBJC_IVAR_$_MyClass._number"
	.p2align	3
_OBJC_IVAR_$_MyClass._number:
	.quad	16                      ## 0x10

	.section	__TEXT,__objc_classname,cstring_literals
L_OBJC_CLASS_NAME_:                     ## @OBJC_CLASS_NAME_
	.asciz	"MyClass"

	.section	__DATA,__objc_const
	.p2align	3               ## @"\01l_OBJC_METACLASS_RO_$_MyClass"
l_OBJC_METACLASS_RO_$_MyClass:
	.long	389                     ## 0x185
	.long	40                      ## 0x28
	.long	40                      ## 0x28
	.space	4
	.quad	0
	.quad	L_OBJC_CLASS_NAME_
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0

	.section	__DATA,__objc_data
	.globl	_OBJC_METACLASS_$_MyClass ## @"OBJC_METACLASS_$_MyClass"
	.p2align	3
_OBJC_METACLASS_$_MyClass:
	.quad	_OBJC_METACLASS_$_NSObject
	.quad	_OBJC_METACLASS_$_NSObject
	.quad	__objc_empty_cache
	.quad	0
	.quad	l_OBJC_METACLASS_RO_$_MyClass

	.section	__TEXT,__objc_classname,cstring_literals
L_OBJC_CLASS_NAME_.1:                   ## @OBJC_CLASS_NAME_.1
	.asciz	"\001"

	.section	__TEXT,__objc_methname,cstring_literals
L_OBJC_METH_VAR_NAME_.2:                ## @OBJC_METH_VAR_NAME_.2
	.asciz	"initWithName:number:"

	.section	__TEXT,__objc_methtype,cstring_literals
L_OBJC_METH_VAR_TYPE_:                  ## @OBJC_METH_VAR_TYPE_
	.asciz	"@28@0:8@16i24"

	.section	__TEXT,__objc_methname,cstring_literals
L_OBJC_METH_VAR_NAME_.3:                ## @OBJC_METH_VAR_NAME_.3
	.asciz	".cxx_destruct"

	.section	__TEXT,__objc_methtype,cstring_literals
L_OBJC_METH_VAR_TYPE_.4:                ## @OBJC_METH_VAR_TYPE_.4
	.asciz	"v16@0:8"

	.section	__TEXT,__objc_methname,cstring_literals
L_OBJC_METH_VAR_NAME_.5:                ## @OBJC_METH_VAR_NAME_.5
	.asciz	"name"

	.section	__TEXT,__objc_methtype,cstring_literals
L_OBJC_METH_VAR_TYPE_.6:                ## @OBJC_METH_VAR_TYPE_.6
	.asciz	"@16@0:8"

	.section	__TEXT,__objc_methname,cstring_literals
L_OBJC_METH_VAR_NAME_.7:                ## @OBJC_METH_VAR_NAME_.7
	.asciz	"setName:"

	.section	__TEXT,__objc_methtype,cstring_literals
L_OBJC_METH_VAR_TYPE_.8:                ## @OBJC_METH_VAR_TYPE_.8
	.asciz	"v24@0:8@16"

	.section	__TEXT,__objc_methname,cstring_literals
L_OBJC_METH_VAR_NAME_.9:                ## @OBJC_METH_VAR_NAME_.9
	.asciz	"number"

	.section	__TEXT,__objc_methtype,cstring_literals
L_OBJC_METH_VAR_TYPE_.10:               ## @OBJC_METH_VAR_TYPE_.10
	.asciz	"i16@0:8"

	.section	__TEXT,__objc_methname,cstring_literals
L_OBJC_METH_VAR_NAME_.11:               ## @OBJC_METH_VAR_NAME_.11
	.asciz	"setNumber:"

	.section	__TEXT,__objc_methtype,cstring_literals
L_OBJC_METH_VAR_TYPE_.12:               ## @OBJC_METH_VAR_TYPE_.12
	.asciz	"v20@0:8i16"

	.section	__DATA,__objc_const
	.p2align	3               ## @"\01l_OBJC_$_INSTANCE_METHODS_MyClass"
l_OBJC_$_INSTANCE_METHODS_MyClass:
	.long	24                      ## 0x18
	.long	6                       ## 0x6
	.quad	L_OBJC_METH_VAR_NAME_.2
	.quad	L_OBJC_METH_VAR_TYPE_
	.quad	"-[MyClass initWithName:number:]"
	.quad	L_OBJC_METH_VAR_NAME_.3
	.quad	L_OBJC_METH_VAR_TYPE_.4
	.quad	"-[MyClass .cxx_destruct]"
	.quad	L_OBJC_METH_VAR_NAME_.5
	.quad	L_OBJC_METH_VAR_TYPE_.6
	.quad	"-[MyClass name]"
	.quad	L_OBJC_METH_VAR_NAME_.7
	.quad	L_OBJC_METH_VAR_TYPE_.8
	.quad	"-[MyClass setName:]"
	.quad	L_OBJC_METH_VAR_NAME_.9
	.quad	L_OBJC_METH_VAR_TYPE_.10
	.quad	"-[MyClass number]"
	.quad	L_OBJC_METH_VAR_NAME_.11
	.quad	L_OBJC_METH_VAR_TYPE_.12
	.quad	"-[MyClass setNumber:]"

	.section	__TEXT,__objc_methname,cstring_literals
L_OBJC_METH_VAR_NAME_.13:               ## @OBJC_METH_VAR_NAME_.13
	.asciz	"_name"

	.section	__TEXT,__objc_methtype,cstring_literals
L_OBJC_METH_VAR_TYPE_.14:               ## @OBJC_METH_VAR_TYPE_.14
	.asciz	"@\"NSString\""

	.section	__TEXT,__objc_methname,cstring_literals
L_OBJC_METH_VAR_NAME_.15:               ## @OBJC_METH_VAR_NAME_.15
	.asciz	"_number"

	.section	__TEXT,__objc_methtype,cstring_literals
L_OBJC_METH_VAR_TYPE_.16:               ## @OBJC_METH_VAR_TYPE_.16
	.asciz	"i"

	.section	__DATA,__objc_const
	.p2align	3               ## @"\01l_OBJC_$_INSTANCE_VARIABLES_MyClass"
l_OBJC_$_INSTANCE_VARIABLES_MyClass:
	.long	32                      ## 0x20
	.long	2                       ## 0x2
	.quad	_OBJC_IVAR_$_MyClass._name
	.quad	L_OBJC_METH_VAR_NAME_.13
	.quad	L_OBJC_METH_VAR_TYPE_.14
	.long	3                       ## 0x3
	.long	8                       ## 0x8
	.quad	_OBJC_IVAR_$_MyClass._number
	.quad	L_OBJC_METH_VAR_NAME_.15
	.quad	L_OBJC_METH_VAR_TYPE_.16
	.long	2                       ## 0x2
	.long	4                       ## 0x4

	.section	__TEXT,__cstring,cstring_literals
L_OBJC_PROP_NAME_ATTR_:                 ## @OBJC_PROP_NAME_ATTR_
	.asciz	"name"

L_OBJC_PROP_NAME_ATTR_.17:              ## @OBJC_PROP_NAME_ATTR_.17
	.asciz	"T@\"NSString\",&,V_name"

L_OBJC_PROP_NAME_ATTR_.18:              ## @OBJC_PROP_NAME_ATTR_.18
	.asciz	"number"

L_OBJC_PROP_NAME_ATTR_.19:              ## @OBJC_PROP_NAME_ATTR_.19
	.asciz	"Ti,V_number"

	.section	__DATA,__objc_const
	.p2align	3               ## @"\01l_OBJC_$_PROP_LIST_MyClass"
l_OBJC_$_PROP_LIST_MyClass:
	.long	16                      ## 0x10
	.long	2                       ## 0x2
	.quad	L_OBJC_PROP_NAME_ATTR_
	.quad	L_OBJC_PROP_NAME_ATTR_.17
	.quad	L_OBJC_PROP_NAME_ATTR_.18
	.quad	L_OBJC_PROP_NAME_ATTR_.19

	.p2align	3               ## @"\01l_OBJC_CLASS_RO_$_MyClass"
l_OBJC_CLASS_RO_$_MyClass:
	.long	388                     ## 0x184
	.long	8                       ## 0x8
	.long	20                      ## 0x14
	.space	4
	.quad	L_OBJC_CLASS_NAME_.1
	.quad	L_OBJC_CLASS_NAME_
	.quad	l_OBJC_$_INSTANCE_METHODS_MyClass
	.quad	0
	.quad	l_OBJC_$_INSTANCE_VARIABLES_MyClass
	.quad	0
	.quad	l_OBJC_$_PROP_LIST_MyClass

	.section	__TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
	.asciz	"Prefix"

	.section	__DATA,__cfstring
	.p2align	3               ## @_unnamed_cfstring_
L__unnamed_cfstring_:
	.quad	___CFConstantStringClassReference
	.long	1992                    ## 0x7c8
	.space	4
	.quad	L_.str
	.quad	6                       ## 0x6

	.section	__TEXT,__objc_methname,cstring_literals
L_OBJC_METH_VAR_NAME_.20:               ## @OBJC_METH_VAR_NAME_.20
	.asciz	"stringByAppendingString:"

	.section	__DATA,__objc_selrefs,literal_pointers,no_dead_strip
	.p2align	3               ## @OBJC_SELECTOR_REFERENCES_.21
L_OBJC_SELECTOR_REFERENCES_.21:
	.quad	L_OBJC_METH_VAR_NAME_.20

	.section	__TEXT,__cstring,cstring_literals
L_.str.22:                              ## @.str.22
	.asciz	"%@"

	.section	__DATA,__cfstring
	.p2align	3               ## @_unnamed_cfstring_.23
L__unnamed_cfstring_.23:
	.quad	___CFConstantStringClassReference
	.long	1992                    ## 0x7c8
	.space	4
	.quad	L_.str.22
	.quad	2                       ## 0x2

	.section	__DATA,__objc_classrefs,regular,no_dead_strip
	.p2align	3               ## @"OBJC_CLASSLIST_REFERENCES_$_"
L_OBJC_CLASSLIST_REFERENCES_$_:
	.quad	_OBJC_CLASS_$_MyClass

	.section	__TEXT,__objc_methname,cstring_literals
L_OBJC_METH_VAR_NAME_.24:               ## @OBJC_METH_VAR_NAME_.24
	.asciz	"alloc"

	.section	__DATA,__objc_selrefs,literal_pointers,no_dead_strip
	.p2align	3               ## @OBJC_SELECTOR_REFERENCES_.25
L_OBJC_SELECTOR_REFERENCES_.25:
	.quad	L_OBJC_METH_VAR_NAME_.24

	.section	__TEXT,__cstring,cstring_literals
L_.str.26:                              ## @.str.26
	.asciz	"name"

	.section	__DATA,__cfstring
	.p2align	3               ## @_unnamed_cfstring_.27
L__unnamed_cfstring_.27:
	.quad	___CFConstantStringClassReference
	.long	1992                    ## 0x7c8
	.space	4
	.quad	L_.str.26
	.quad	4                       ## 0x4

	.section	__DATA,__objc_selrefs,literal_pointers,no_dead_strip
	.p2align	3               ## @OBJC_SELECTOR_REFERENCES_.28
L_OBJC_SELECTOR_REFERENCES_.28:
	.quad	L_OBJC_METH_VAR_NAME_.2

	.p2align	3               ## @OBJC_SELECTOR_REFERENCES_.29
L_OBJC_SELECTOR_REFERENCES_.29:
	.quad	L_OBJC_METH_VAR_NAME_.5

	.section	__DATA,__objc_classlist,regular,no_dead_strip
	.p2align	3               ## @"OBJC_LABEL_CLASS_$"
L_OBJC_LABEL_CLASS_$:
	.quad	_OBJC_CLASS_$_MyClass

	.section	__DATA,__objc_imageinfo,regular,no_dead_strip
L_OBJC_IMAGE_INFO:
	.long	0
	.long	64


.subsections_via_symbols
