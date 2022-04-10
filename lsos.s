
ee.elf:     file format elf64-littleaarch64


Disassembly of section .__symbols__:

0000000000000000 <.__symbols__>:
   0:	00000010 	udf	#16
   4:	00000010 	udf	#16
   8:	00000020 	udf	#32
   c:	00000020 	udf	#32

Disassembly of section .rodata:

0000000000000010 <allsyms_addresses>:
	...

Disassembly of section .comment:

0000000000000000 <.comment>:
   0:	3a434347 	ccmn	w26, w3, #0x7, mi  // mi = first
   4:	62552820 	.inst	0x62552820 ; undefined
   8:	75746e75 	.inst	0x75746e75 ; undefined
   c:	2e313120 	usubw	v0.8h, v9.8h, v17.8b
  10:	2d302e32 	stp	s18, s11, [x17, #-128]
  14:	75627537 	.inst	0x75627537 ; undefined
  18:	3275746e 	.inst	0x3275746e ; undefined
  1c:	31312029 	adds	w9, w1, #0xc48
  20:	302e322e 	adr	x14, 5c665 <allsyms_names+0x5c645>
	...

Disassembly of section .debug_str:

0000000000000000 <.debug_str>:
   0:	20554e47 	.inst	0x20554e47 ; undefined
   4:	20313143 	.inst	0x20313143 ; undefined
   8:	322e3131 	orr	w17, w9, #0x7ffc0000
   c:	2d20302e 	stp	s14, s12, [x1, #-256]
  10:	74696c6d 	.inst	0x74696c6d ; undefined
  14:	2d656c74 	ldp	s20, s27, [x3, #-216]
  18:	69646e65 	ldpsw	x5, x27, [x19, #-224]
  1c:	2d206e61 	stp	s1, s27, [x19, #-256]
  20:	6962616d 	ldpsw	x13, x24, [x11, #-240]
  24:	36706c3d 	tbz	w29, #14, da8 <allsyms_names+0xd88>
  28:	672d2034 	.inst	0x672d2034 ; undefined
  2c:	324f2d20 	.inst	0x324f2d20 ; undefined
  30:	74732d20 	.inst	0x74732d20 ; undefined
  34:	6e673d64 	cmhs	v4.8h, v11.8h, v7.8h
  38:	20313175 	.inst	0x20313175 ; undefined
  3c:	6f6e662d 	sqshlu	v13.2d, v17.2d, #46
  40:	7274732d 	.inst	0x7274732d ; undefined
  44:	2d746369 	ldp	s9, s24, [x27, #-96]
  48:	61696c61 	.inst	0x61696c61 ; undefined
  4c:	676e6973 	.inst	0x676e6973 ; undefined
  50:	6e662d20 	uqsub	v0.8h, v9.8h, v6.8h
  54:	6f632d6f 	.inst	0x6f632d6f ; undefined
  58:	6e6f6d6d 	umin	v13.8h, v11.8h, v15.8h
  5c:	73662d20 	.inst	0x73662d20 ; undefined
  60:	74726f68 	.inst	0x74726f68 ; undefined
  64:	6863772d 	.inst	0x6863772d ; undefined
  68:	2d207261 	stp	s1, s28, [x19, #-256]
  6c:	2d6f6e66 	ldp	s6, s27, [x19, #-136]
  70:	6c697562 	ldnp	d2, d29, [x11, #-368]
  74:	206e6974 	.inst	0x206e6974 ; undefined
  78:	7361662d 	.inst	0x7361662d ; undefined
  7c:	68636e79 	.inst	0x68636e79 ; undefined
  80:	6f6e6f72 	.inst	0x6f6e6f72 ; undefined
  84:	752d7375 	.inst	0x752d7375 ; undefined
  88:	6e69776e 	uabd	v14.8h, v27.8h, v9.8h
  8c:	61742d64 	.inst	0x61742d64 ; undefined
  90:	73656c62 	.inst	0x73656c62 ; undefined
  94:	73662d20 	.inst	0x73662d20 ; undefined
  98:	6b636174 	.inst	0x6b636174 ; undefined
  9c:	616c632d 	.inst	0x616c632d ; undefined
  a0:	702d6873 	adr	x19, 5adaf <allsyms_names+0x5ad8f>
  a4:	65746f72 	fnmls	z18.h, p3/m, z27.h, z20.h
  a8:	6f697463 	uqshl	v3.2d, v3.2d, #41
  ac:	Address 0x00000000000000ac is out of bounds.


Disassembly of section .debug_line_str:

0000000000000000 <.debug_line_str>:
   0:	6f6f722f 	fcmla	v15.8h, v17.8h, v15.h[1], #270
   4:	616d2f74 	.inst	0x616d2f74 ; undefined
   8:	745f656b 	.inst	0x745f656b ; undefined
   c:	00747365 	.inst	0x00747365 ; undefined
  10:	7665642f 	.inst	0x7665642f ; undefined
  14:	6c756e2f 	ldnp	d15, d27, [x17, #-176]
  18:	Address 0x0000000000000018 is out of bounds.

