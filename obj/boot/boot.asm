
obj/boot/boot.out:     file format elf32-i386


Disassembly of section .text:

00007c00 <start>:
.set CR0_PE_ON,      0x1         # protected mode enable flag

.globl start
start:
  .code16                     # Assemble for 16-bit mode
  cli                         # Disable interrupts
    7c00:	fa                   	cli    
  cld                         # String operations increment
    7c01:	fc                   	cld    

  # Set up the important data segment registers (DS, ES, SS).
  xorw    %ax,%ax             # Segment number zero
    7c02:	31 c0                	xor    %eax,%eax
  movw    %ax,%ds             # -> Data Segment
    7c04:	8e d8                	mov    %eax,%ds
  movw    %ax,%es             # -> Extra Segment
    7c06:	8e c0                	mov    %eax,%es
  movw    %ax,%ss             # -> Stack Segment
    7c08:	8e d0                	mov    %eax,%ss

00007c0a <seta20.1>:
  # Enable A20:
  #   For backwards compatibility with the earliest PCs, physical
  #   address line 20 is tied low, so that addresses higher than
  #   1MB wrap around to zero by default.  This code undoes this.
seta20.1:
  inb     $0x64,%al               # Wait for not busy
    7c0a:	e4 64                	in     $0x64,%al
  testb   $0x2,%al
    7c0c:	a8 02                	test   $0x2,%al
  jnz     seta20.1
    7c0e:	75 fa                	jne    7c0a <seta20.1>

  movb    $0xd1,%al               # 0xd1 -> port 0x64
    7c10:	b0 d1                	mov    $0xd1,%al
  outb    %al,$0x64
    7c12:	e6 64                	out    %al,$0x64

00007c14 <seta20.2>:

seta20.2:
  inb     $0x64,%al               # Wait for not busy
    7c14:	e4 64                	in     $0x64,%al
  testb   $0x2,%al
    7c16:	a8 02                	test   $0x2,%al
  jnz     seta20.2
    7c18:	75 fa                	jne    7c14 <seta20.2>

  movb    $0xdf,%al               # 0xdf -> port 0x60
    7c1a:	b0 df                	mov    $0xdf,%al
  outb    %al,$0x60
    7c1c:	e6 60                	out    %al,$0x60

  # Switch from real to protected mode, using a bootstrap GDT
  # and segment translation that makes virtual addresses 
  # identical to their physical addresses, so that the 
  # effective memory map does not change during the switch.
  lgdt    gdtdesc
    7c1e:	0f 01 16             	lgdtl  (%esi)
    7c21:	64 7c 0f             	fs jl  7c33 <protcseg+0x1>
  movl    %cr0, %eax
    7c24:	20 c0                	and    %al,%al
  orl     $CR0_PE_ON, %eax
    7c26:	66 83 c8 01          	or     $0x1,%ax
  movl    %eax, %cr0
    7c2a:	0f 22 c0             	mov    %eax,%cr0
  
  # Jump to next instruction, but in 32-bit code segment.
  # Switches processor into 32-bit mode.
  ljmp    $PROT_MODE_CSEG, $protcseg
    7c2d:	ea                   	.byte 0xea
    7c2e:	32 7c 08 00          	xor    0x0(%eax,%ecx,1),%bh

00007c32 <protcseg>:

  .code32                     # Assemble for 32-bit mode
protcseg:
  # Set up the protected-mode data segment registers
  movw    $PROT_MODE_DSEG, %ax    # Our data segment selector
    7c32:	66 b8 10 00          	mov    $0x10,%ax
  movw    %ax, %ds                # -> DS: Data Segment
    7c36:	8e d8                	mov    %eax,%ds
  movw    %ax, %es                # -> ES: Extra Segment
    7c38:	8e c0                	mov    %eax,%es
  movw    %ax, %fs                # -> FS
    7c3a:	8e e0                	mov    %eax,%fs
  movw    %ax, %gs                # -> GS
    7c3c:	8e e8                	mov    %eax,%gs
  movw    %ax, %ss                # -> SS: Stack Segment
    7c3e:	8e d0                	mov    %eax,%ss
  
  # Set up the stack pointer and call into C.
  movl    $start, %esp
    7c40:	bc 00 7c 00 00       	mov    $0x7c00,%esp
  call bootmain
    7c45:	e8 ee 00 00 00       	call   7d38 <bootmain>

00007c4a <spin>:

  # If bootmain returns (it shouldn't), loop.
spin:
  jmp spin
    7c4a:	eb fe                	jmp    7c4a <spin>

00007c4c <gdt>:
	...
    7c54:	ff                   	(bad)  
    7c55:	ff 00                	incl   (%eax)
    7c57:	00 00                	add    %al,(%eax)
    7c59:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7c60:	00                   	.byte 0x0
    7c61:	92                   	xchg   %eax,%edx
    7c62:	cf                   	iret   
	...

00007c64 <gdtdesc>:
    7c64:	17                   	pop    %ss
    7c65:	00 4c 7c 00          	add    %cl,0x0(%esp,%edi,2)
	...

00007c6a <putchar>:
	// note: does not return!
	((void (*)(void)) (ELFHDR->e_entry))();
	
}

void putchar(char val, int row, int col) {
    7c6a:	55                   	push   %ebp
    7c6b:	89 e5                	mov    %esp,%ebp
	// TODO: YOUR CODE HERE	
	char* output_pos = VIDEO_MEMORY + row*80*2 + col*2;
    7c6d:	69 45 0c a0 00 00 00 	imul   $0xa0,0xc(%ebp),%eax
void putchar(char val, int row, int col) {
    7c74:	8b 55 10             	mov    0x10(%ebp),%edx
	char* output_pos = VIDEO_MEMORY + row*80*2 + col*2;
    7c77:	01 d2                	add    %edx,%edx
    7c79:	01 d0                	add    %edx,%eax
	*output_pos = val;
    7c7b:	8b 55 08             	mov    0x8(%ebp),%edx
	*(output_pos + 1) = 0x7;
    7c7e:	c6 80 01 80 0b 00 07 	movb   $0x7,0xb8001(%eax)
	*output_pos = val;
    7c85:	88 90 00 80 0b 00    	mov    %dl,0xb8000(%eax)
}
    7c8b:	5d                   	pop    %ebp
    7c8c:	c3                   	ret    

00007c8d <waitdisk>:
	}
}

void
waitdisk(void)
{
    7c8d:	55                   	push   %ebp

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
    7c8e:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7c93:	89 e5                	mov    %esp,%ebp
    7c95:	ec                   	in     (%dx),%al
	// wait for disk reaady
	while ((inb(0x1F7) & 0xC0) != 0x40)
    7c96:	83 e0 c0             	and    $0xffffffc0,%eax
    7c99:	3c 40                	cmp    $0x40,%al
    7c9b:	75 f8                	jne    7c95 <waitdisk+0x8>
		/* do nothing */;
}
    7c9d:	5d                   	pop    %ebp
    7c9e:	c3                   	ret    

00007c9f <readsect>:

void
readsect(void *dst, uint32_t offset)
{
    7c9f:	55                   	push   %ebp
    7ca0:	89 e5                	mov    %esp,%ebp
    7ca2:	57                   	push   %edi
    7ca3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	// wait for disk to be ready
	waitdisk();
    7ca6:	e8 e2 ff ff ff       	call   7c8d <waitdisk>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
    7cab:	b0 01                	mov    $0x1,%al
    7cad:	ba f2 01 00 00       	mov    $0x1f2,%edx
    7cb2:	ee                   	out    %al,(%dx)
    7cb3:	ba f3 01 00 00       	mov    $0x1f3,%edx
    7cb8:	88 c8                	mov    %cl,%al
    7cba:	ee                   	out    %al,(%dx)

	outb(0x1F2, 1);		// count = 1
	outb(0x1F3, offset);
	outb(0x1F4, offset >> 8);
    7cbb:	89 c8                	mov    %ecx,%eax
    7cbd:	ba f4 01 00 00       	mov    $0x1f4,%edx
    7cc2:	c1 e8 08             	shr    $0x8,%eax
    7cc5:	ee                   	out    %al,(%dx)
	outb(0x1F5, offset >> 16);
    7cc6:	89 c8                	mov    %ecx,%eax
    7cc8:	ba f5 01 00 00       	mov    $0x1f5,%edx
    7ccd:	c1 e8 10             	shr    $0x10,%eax
    7cd0:	ee                   	out    %al,(%dx)
	outb(0x1F6, (offset >> 24) | 0xE0);
    7cd1:	89 c8                	mov    %ecx,%eax
    7cd3:	ba f6 01 00 00       	mov    $0x1f6,%edx
    7cd8:	c1 e8 18             	shr    $0x18,%eax
    7cdb:	83 c8 e0             	or     $0xffffffe0,%eax
    7cde:	ee                   	out    %al,(%dx)
    7cdf:	b0 20                	mov    $0x20,%al
    7ce1:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7ce6:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x20);	// cmd 0x20 - read sectors

	// wait for disk to be ready
	waitdisk();
    7ce7:	e8 a1 ff ff ff       	call   7c8d <waitdisk>
	asm volatile("cld\n\trepne\n\tinsl"
    7cec:	8b 7d 08             	mov    0x8(%ebp),%edi
    7cef:	b9 80 00 00 00       	mov    $0x80,%ecx
    7cf4:	ba f0 01 00 00       	mov    $0x1f0,%edx
    7cf9:	fc                   	cld    
    7cfa:	f2 6d                	repnz insl (%dx),%es:(%edi)

	// read a sector
	insl(0x1F0, dst, SECTSIZE/4);
}
    7cfc:	5f                   	pop    %edi
    7cfd:	5d                   	pop    %ebp
    7cfe:	c3                   	ret    

00007cff <readseg>:
{
    7cff:	55                   	push   %ebp
    7d00:	89 e5                	mov    %esp,%ebp
    7d02:	57                   	push   %edi
    7d03:	56                   	push   %esi
	offset = (offset / SECTSIZE) + 1;
    7d04:	8b 7d 10             	mov    0x10(%ebp),%edi
{
    7d07:	53                   	push   %ebx
	end_pa = pa + count;
    7d08:	8b 75 0c             	mov    0xc(%ebp),%esi
{
    7d0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	offset = (offset / SECTSIZE) + 1;
    7d0e:	c1 ef 09             	shr    $0x9,%edi
	end_pa = pa + count;
    7d11:	01 de                	add    %ebx,%esi
	offset = (offset / SECTSIZE) + 1;
    7d13:	47                   	inc    %edi
	pa &= ~(SECTSIZE - 1);
    7d14:	81 e3 00 fe ff ff    	and    $0xfffffe00,%ebx
	while (pa < end_pa) {
    7d1a:	39 f3                	cmp    %esi,%ebx
    7d1c:	73 12                	jae    7d30 <readseg+0x31>
		readsect((uint8_t*) pa, offset);
    7d1e:	57                   	push   %edi
    7d1f:	53                   	push   %ebx
		offset++;
    7d20:	47                   	inc    %edi
		pa += SECTSIZE;
    7d21:	81 c3 00 02 00 00    	add    $0x200,%ebx
		readsect((uint8_t*) pa, offset);
    7d27:	e8 73 ff ff ff       	call   7c9f <readsect>
		offset++;
    7d2c:	58                   	pop    %eax
    7d2d:	5a                   	pop    %edx
    7d2e:	eb ea                	jmp    7d1a <readseg+0x1b>
}
    7d30:	8d 65 f4             	lea    -0xc(%ebp),%esp
    7d33:	5b                   	pop    %ebx
    7d34:	5e                   	pop    %esi
    7d35:	5f                   	pop    %edi
    7d36:	5d                   	pop    %ebp
    7d37:	c3                   	ret    

00007d38 <bootmain>:
{
    7d38:	55                   	push   %ebp
    7d39:	89 e5                	mov    %esp,%ebp
    7d3b:	56                   	push   %esi
    7d3c:	53                   	push   %ebx
	*output_pos = val;
    7d3d:	66 c7 05 60 8e 0b 00 	movw   $0x731,0xb8e60
    7d44:	31 07 
	readseg((uint32_t) ELFHDR, SECTSIZE*8, 0);
    7d46:	6a 00                	push   $0x0
    7d48:	68 00 10 00 00       	push   $0x1000
    7d4d:	68 00 00 01 00       	push   $0x10000
    7d52:	e8 a8 ff ff ff       	call   7cff <readseg>
	if (ELFHDR->e_magic != ELF_MAGIC)
    7d57:	83 c4 0c             	add    $0xc,%esp
    7d5a:	81 3d 00 00 01 00 7f 	cmpl   $0x464c457f,0x10000
    7d61:	45 4c 46 
	*output_pos = val;
    7d64:	66 c7 05 62 8e 0b 00 	movw   $0x732,0xb8e62
    7d6b:	32 07 
	if (ELFHDR->e_magic != ELF_MAGIC)
    7d6d:	75 4f                	jne    7dbe <bootmain+0x86>
	ph = (struct Proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
    7d6f:	a1 1c 00 01 00       	mov    0x1001c,%eax
	eph = ph + ELFHDR->e_phnum;
    7d74:	0f b7 35 2c 00 01 00 	movzwl 0x1002c,%esi
	*output_pos = val;
    7d7b:	66 c7 05 64 8e 0b 00 	movw   $0x733,0xb8e64
    7d82:	33 07 
	ph = (struct Proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
    7d84:	8d 98 00 00 01 00    	lea    0x10000(%eax),%ebx
	eph = ph + ELFHDR->e_phnum;
    7d8a:	c1 e6 05             	shl    $0x5,%esi
    7d8d:	01 de                	add    %ebx,%esi
	for (; ph < eph; ph++)
    7d8f:	39 f3                	cmp    %esi,%ebx
    7d91:	73 16                	jae    7da9 <bootmain+0x71>
		readseg(ph->p_pa, ph->p_memsz, ph->p_offset);
    7d93:	ff 73 04             	pushl  0x4(%ebx)
    7d96:	ff 73 14             	pushl  0x14(%ebx)
	for (; ph < eph; ph++)
    7d99:	83 c3 20             	add    $0x20,%ebx
		readseg(ph->p_pa, ph->p_memsz, ph->p_offset);
    7d9c:	ff 73 ec             	pushl  -0x14(%ebx)
    7d9f:	e8 5b ff ff ff       	call   7cff <readseg>
	for (; ph < eph; ph++)
    7da4:	83 c4 0c             	add    $0xc,%esp
    7da7:	eb e6                	jmp    7d8f <bootmain+0x57>
	*output_pos = val;
    7da9:	66 c7 05 66 8e 0b 00 	movw   $0x734,0xb8e66
    7db0:	34 07 
}
    7db2:	8d 65 f8             	lea    -0x8(%ebp),%esp
    7db5:	5b                   	pop    %ebx
    7db6:	5e                   	pop    %esi
    7db7:	5d                   	pop    %ebp
	((void (*)(void)) (ELFHDR->e_entry))();
    7db8:	ff 25 18 00 01 00    	jmp    *0x10018
}
    7dbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
    7dc1:	5b                   	pop    %ebx
    7dc2:	5e                   	pop    %esi
    7dc3:	5d                   	pop    %ebp
    7dc4:	c3                   	ret    
