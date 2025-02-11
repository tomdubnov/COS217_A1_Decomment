	.arch armv8-a
	.file	"decomment.c"
	.text
	.global	current_line
	.data
	.align	2
	.type	current_line, %object
	.size	current_line, 4
current_line:
	.word	1
	.global	currentchar
	.type	currentchar, %object
	.size	currentchar, 1
currentchar:
	.byte	97
	.global	state
	.bss
	.align	2
	.type	state, %object
	.size	state, 4
state:
	.zero	4
	.section	.rodata
	.align	3
.LC0:
	.string	"Error: line %d: unterminated comment\n"
	.text
	.align	2
	.global	print_error_message
	.type	print_error_message, %function
print_error_message:
.LFB0:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	str	w0, [sp, 28]
	adrp	x0, stderr
	add	x0, x0, :lo12:stderr
	ldr	x3, [x0]
	ldr	w2, [sp, 28]
	adrp	x0, .LC0
	add	x1, x0, :lo12:.LC0
	mov	x0, x3
	bl	fprintf
	nop
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE0:
	.size	print_error_message, .-print_error_message
	.align	2
	.global	process_chars
	.type	process_chars, %function
process_chars:
.LFB1:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	strb	w0, [sp, 31]
	str	x1, [sp, 16]
	b	.L3
.L15:
	adrp	x0, current_line
	add	x0, x0, :lo12:current_line
	bl	treat_line_end_8
.L4:
	ldr	x0, [sp, 16]
	ldr	w0, [x0]
	cmp	w0, 7
	beq	.L5
	cmp	w0, 7
	bgt	.L16
	cmp	w0, 6
	beq	.L7
	cmp	w0, 6
	bgt	.L16
	cmp	w0, 5
	beq	.L8
	cmp	w0, 5
	bgt	.L16
	cmp	w0, 4
	beq	.L9
	cmp	w0, 4
	bgt	.L16
	cmp	w0, 3
	beq	.L10
	cmp	w0, 3
	bgt	.L16
	cmp	w0, 2
	beq	.L11
	cmp	w0, 2
	bgt	.L16
	cmp	w0, 0
	beq	.L12
	cmp	w0, 1
	beq	.L13
	b	.L6
.L12:
	add	x0, sp, 16
	mov	x1, x0
	ldrb	w0, [sp, 31]
	bl	treat_normal_text_0
	b	.L3
.L13:
	add	x0, sp, 16
	mov	x1, x0
	ldrb	w0, [sp, 31]
	bl	treat_string_literal_1
	b	.L3
.L11:
	add	x0, sp, 16
	mov	x1, x0
	ldrb	w0, [sp, 31]
	bl	treat_esc_char_from_string_literal_2
	b	.L3
.L10:
	add	x0, sp, 16
	mov	x1, x0
	ldrb	w0, [sp, 31]
	bl	treat_char_literal_3
	b	.L3
.L9:
	add	x0, sp, 16
	mov	x1, x0
	ldrb	w0, [sp, 31]
	bl	treat_esc_char_from_char_literal_4
	b	.L3
.L8:
	add	x0, sp, 16
	mov	x1, x0
	ldrb	w0, [sp, 31]
	bl	treat_potential_comment_5
	b	.L3
.L7:
	add	x0, sp, 16
	mov	x1, x0
	ldrb	w0, [sp, 31]
	bl	treat_in_comment_6
	b	.L3
.L5:
	add	x0, sp, 16
	mov	x1, x0
	ldrb	w0, [sp, 31]
	bl	treat_potential_comment_end_7
.L6:
.L16:
	nop
.L3:
	bl	getchar
	strb	w0, [sp, 31]
	ldrb	w0, [sp, 31]
	cmp	w0, 10
	bne	.L4
	b	.L15
	.cfi_endproc
.LFE1:
	.size	process_chars, .-process_chars
	.align	2
	.global	treat_normal_text_0
	.type	treat_normal_text_0, %function
treat_normal_text_0:
.LFB2:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	strb	w0, [sp, 31]
	str	x1, [sp, 16]
	ldrb	w0, [sp, 31]
	cmp	w0, 34
	bne	.L18
	ldr	x0, [sp, 16]
	mov	w1, 1
	str	w1, [x0]
	ldrb	w0, [sp, 31]
	bl	putchar
	b	.L22
.L18:
	ldrb	w0, [sp, 31]
	cmp	w0, 39
	bne	.L20
	ldr	x0, [sp, 16]
	mov	w1, 3
	str	w1, [x0]
	ldrb	w0, [sp, 31]
	bl	putchar
	b	.L22
.L20:
	ldrb	w0, [sp, 31]
	cmp	w0, 47
	bne	.L21
	ldr	x0, [sp, 16]
	mov	w1, 5
	str	w1, [x0]
	b	.L22
.L21:
	ldrb	w0, [sp, 31]
	bl	putchar
.L22:
	nop
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE2:
	.size	treat_normal_text_0, .-treat_normal_text_0
	.align	2
	.global	treat_string_literal_1
	.type	treat_string_literal_1, %function
treat_string_literal_1:
.LFB3:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	strb	w0, [sp, 31]
	str	x1, [sp, 16]
	ldrb	w0, [sp, 31]
	cmp	w0, 34
	bne	.L24
	ldr	x0, [sp, 16]
	str	wzr, [x0]
	ldrb	w0, [sp, 31]
	bl	putchar
	b	.L27
.L24:
	ldrb	w0, [sp, 31]
	cmp	w0, 92
	bne	.L26
	ldr	x0, [sp, 16]
	mov	w1, 2
	str	w1, [x0]
	ldrb	w0, [sp, 31]
	bl	putchar
	b	.L27
.L26:
	ldrb	w0, [sp, 31]
	bl	putchar
.L27:
	nop
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE3:
	.size	treat_string_literal_1, .-treat_string_literal_1
	.align	2
	.global	treat_esc_char_from_string_literal_2
	.type	treat_esc_char_from_string_literal_2, %function
treat_esc_char_from_string_literal_2:
.LFB4:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	strb	w0, [sp, 31]
	str	x1, [sp, 16]
	ldr	x0, [sp, 16]
	mov	w1, 1
	str	w1, [x0]
	ldrb	w0, [sp, 31]
	bl	putchar
	nop
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE4:
	.size	treat_esc_char_from_string_literal_2, .-treat_esc_char_from_string_literal_2
	.align	2
	.global	treat_char_literal_3
	.type	treat_char_literal_3, %function
treat_char_literal_3:
.LFB5:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	strb	w0, [sp, 31]
	str	x1, [sp, 16]
	ldrb	w0, [sp, 31]
	cmp	w0, 39
	bne	.L30
	ldr	x0, [sp, 16]
	str	wzr, [x0]
	ldrb	w0, [sp, 31]
	bl	putchar
	b	.L33
.L30:
	ldrb	w0, [sp, 31]
	cmp	w0, 92
	bne	.L32
	ldr	x0, [sp, 16]
	mov	w1, 4
	str	w1, [x0]
	ldrb	w0, [sp, 31]
	bl	putchar
	b	.L33
.L32:
	ldrb	w0, [sp, 31]
	bl	putchar
.L33:
	nop
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE5:
	.size	treat_char_literal_3, .-treat_char_literal_3
	.align	2
	.global	treat_esc_char_from_char_literal_4
	.type	treat_esc_char_from_char_literal_4, %function
treat_esc_char_from_char_literal_4:
.LFB6:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	strb	w0, [sp, 31]
	str	x1, [sp, 16]
	ldr	x0, [sp, 16]
	mov	w1, 3
	str	w1, [x0]
	ldrb	w0, [sp, 31]
	bl	putchar
	nop
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE6:
	.size	treat_esc_char_from_char_literal_4, .-treat_esc_char_from_char_literal_4
	.align	2
	.global	treat_potential_comment_5
	.type	treat_potential_comment_5, %function
treat_potential_comment_5:
.LFB7:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	strb	w0, [sp, 31]
	str	x1, [sp, 16]
	ldrb	w0, [sp, 31]
	cmp	w0, 34
	bne	.L36
	ldr	x0, [sp, 16]
	mov	w1, 1
	str	w1, [x0]
	ldrb	w0, [sp, 31]
	bl	putchar
	b	.L41
.L36:
	ldrb	w0, [sp, 31]
	cmp	w0, 39
	bne	.L38
	ldr	x0, [sp, 16]
	mov	w1, 3
	str	w1, [x0]
	ldrb	w0, [sp, 31]
	bl	putchar
	b	.L41
.L38:
	ldrb	w0, [sp, 31]
	cmp	w0, 42
	bne	.L39
	ldr	x0, [sp, 16]
	mov	w1, 6
	str	w1, [x0]
	b	.L41
.L39:
	ldrb	w0, [sp, 31]
	cmp	w0, 47
	bne	.L40
	ldr	x0, [sp, 16]
	mov	w1, 5
	str	w1, [x0]
	ldrb	w0, [sp, 31]
	bl	putchar
	b	.L41
.L40:
	ldr	x0, [sp, 16]
	str	wzr, [x0]
	ldrb	w0, [sp, 31]
	bl	putchar
.L41:
	nop
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE7:
	.size	treat_potential_comment_5, .-treat_potential_comment_5
	.align	2
	.global	treat_in_comment_6
	.type	treat_in_comment_6, %function
treat_in_comment_6:
.LFB8:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	strb	w0, [sp, 31]
	str	x1, [sp, 16]
	ldrb	w0, [sp, 31]
	cmp	w0, 42
	bne	.L43
	ldr	x0, [sp, 16]
	mov	w1, 7
	str	w1, [x0]
	b	.L46
.L43:
	ldrb	w0, [sp, 31]
	cmp	w0, 32
	bne	.L45
	ldr	x0, [sp, 16]
	mov	w1, 6
	str	w1, [x0]
	ldrb	w0, [sp, 31]
	bl	putchar
	b	.L46
.L45:
	ldr	x0, [sp, 16]
	mov	w1, 6
	str	w1, [x0]
.L46:
	nop
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE8:
	.size	treat_in_comment_6, .-treat_in_comment_6
	.align	2
	.global	treat_potential_comment_end_7
	.type	treat_potential_comment_end_7, %function
treat_potential_comment_end_7:
.LFB9:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	strb	w0, [sp, 31]
	str	x1, [sp, 16]
	ldrb	w0, [sp, 31]
	cmp	w0, 42
	bne	.L48
	ldr	x0, [sp, 16]
	mov	w1, 7
	str	w1, [x0]
	b	.L52
.L48:
	ldrb	w0, [sp, 31]
	cmp	w0, 47
	bne	.L50
	ldr	x0, [sp, 16]
	str	wzr, [x0]
	b	.L52
.L50:
	ldrb	w0, [sp, 31]
	cmp	w0, 32
	bne	.L51
	ldr	x0, [sp, 16]
	mov	w1, 7
	str	w1, [x0]
	ldrb	w0, [sp, 31]
	bl	putchar
	b	.L52
.L51:
	ldr	x0, [sp, 16]
	mov	w1, 6
	str	w1, [x0]
.L52:
	nop
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE9:
	.size	treat_potential_comment_end_7, .-treat_potential_comment_end_7
	.align	2
	.global	treat_line_end_8
	.type	treat_line_end_8, %function
treat_line_end_8:
.LFB10:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	w0, [sp, 12]
	ldr	w0, [sp, 12]
	add	w0, w0, 1
	str	w0, [sp, 12]
	nop
	add	sp, sp, 16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE10:
	.size	treat_line_end_8, .-treat_line_end_8
	.ident	"GCC: (GNU) 11.4.1 20231218 (Red Hat 11.4.1-3)"
	.section	.note.GNU-stack,"",@progbits
