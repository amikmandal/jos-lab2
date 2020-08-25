
obj/kern/kernel:     file format elf32-i386


Disassembly of section .text:

00400000 <_start-0xc>:
.globl		_start
_start = entry

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
  400000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
  400006:	00 00                	add    %al,(%eax)
  400008:	fe 4f 52             	decb   0x52(%edi)
  40000b:	e4                   	.byte 0xe4

0040000c <_start>:
  40000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
  400013:	34 12 
	# sufficient until we set up our real page table in mem_init
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(entry_pgdir), %eax
  400015:	b8 00 60 41 00       	mov    $0x416000,%eax
	movl	%eax, %cr3
  40001a:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl	%cr0, %eax
  40001d:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
  400020:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
  400025:	0f 22 c0             	mov    %eax,%cr0

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
  400028:	b8 2f 00 40 00       	mov    $0x40002f,%eax
	jmp	*%eax
  40002d:	ff e0                	jmp    *%eax

0040002f <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
  40002f:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
  400034:	bc 00 20 41 00       	mov    $0x412000,%esp

	# now to C code
	call	i386_init
  400039:	e8 31 01 00 00       	call   40016f <i386_init>

0040003e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
  40003e:	eb fe                	jmp    40003e <spin>

00400040 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  400040:	55                   	push   %ebp
  400041:	89 e5                	mov    %esp,%ebp
  400043:	57                   	push   %edi
  400044:	56                   	push   %esi
  400045:	53                   	push   %ebx
  400046:	83 ec 0c             	sub    $0xc,%esp
  400049:	e8 0f 02 00 00       	call   40025d <__x86.get_pc_thunk.bx>
  40004e:	81 c3 e6 52 01 00    	add    $0x152e6,%ebx
  400054:	8b 7d 10             	mov    0x10(%ebp),%edi
	va_list ap;

	if (panicstr)
  400057:	c7 c0 c0 7f 41 00    	mov    $0x417fc0,%eax
  40005d:	83 38 00             	cmpl   $0x0,(%eax)
  400060:	74 0e                	je     400070 <_panic+0x30>
}

static inline void
outw(int port, uint16_t data)
{
	asm volatile("outw %0,%w1" : : "a" (data), "d" (port));
  400062:	b8 00 20 00 00       	mov    $0x2000,%eax
  400067:	ba 04 06 00 00       	mov    $0x604,%edx
  40006c:	66 ef                	out    %ax,(%dx)
  40006e:	eb fe                	jmp    40006e <_panic+0x2e>
		goto dead;
	panicstr = fmt;
  400070:	89 38                	mov    %edi,(%eax)

	// Be extra sure that the machine is in as reasonable state
	asm volatile("cli; cld");
  400072:	fa                   	cli    
  400073:	fc                   	cld    

	va_start(ap, fmt);
  400074:	8d 75 14             	lea    0x14(%ebp),%esi
	cprintf("kernel panic at %s:%d: ", file, line);
  400077:	83 ec 04             	sub    $0x4,%esp
  40007a:	ff 75 0c             	pushl  0xc(%ebp)
  40007d:	ff 75 08             	pushl  0x8(%ebp)
  400080:	8d 83 6c cd fe ff    	lea    -0x13294(%ebx),%eax
  400086:	50                   	push   %eax
  400087:	e8 69 08 00 00       	call   4008f5 <cprintf>
	vcprintf(fmt, ap);
  40008c:	83 c4 08             	add    $0x8,%esp
  40008f:	56                   	push   %esi
  400090:	57                   	push   %edi
  400091:	e8 28 08 00 00       	call   4008be <vcprintf>
	cprintf("\n");
  400096:	8d 83 af cd fe ff    	lea    -0x13251(%ebx),%eax
  40009c:	89 04 24             	mov    %eax,(%esp)
  40009f:	e8 51 08 00 00       	call   4008f5 <cprintf>
  4000a4:	83 c4 10             	add    $0x10,%esp
  4000a7:	eb b9                	jmp    400062 <_panic+0x22>

004000a9 <load_code>:
{
  4000a9:	55                   	push   %ebp
  4000aa:	89 e5                	mov    %esp,%ebp
  4000ac:	57                   	push   %edi
  4000ad:	56                   	push   %esi
  4000ae:	53                   	push   %ebx
  4000af:	83 ec 1c             	sub    $0x1c,%esp
  4000b2:	e8 a6 01 00 00       	call   40025d <__x86.get_pc_thunk.bx>
  4000b7:	81 c3 7d 52 01 00    	add    $0x1527d,%ebx
	if(header->e_magic != ELF_MAGIC) {
  4000bd:	8b 45 08             	mov    0x8(%ebp),%eax
  4000c0:	81 38 7f 45 4c 46    	cmpl   $0x464c457f,(%eax)
  4000c6:	75 11                	jne    4000d9 <load_code+0x30>
  4000c8:	8b 45 08             	mov    0x8(%ebp),%eax
  4000cb:	89 c6                	mov    %eax,%esi
  4000cd:	03 70 1c             	add    0x1c(%eax),%esi
	for(int i = 0; i < header->e_phnum; i++) {
  4000d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  4000d7:	eb 37                	jmp    400110 <load_code+0x67>
		panic("not a an elf header");
  4000d9:	83 ec 04             	sub    $0x4,%esp
  4000dc:	8d 83 84 cd fe ff    	lea    -0x1327c(%ebx),%eax
  4000e2:	50                   	push   %eax
  4000e3:	6a 49                	push   $0x49
  4000e5:	8d 83 98 cd fe ff    	lea    -0x13268(%ebx),%eax
  4000eb:	50                   	push   %eax
  4000ec:	e8 4f ff ff ff       	call   400040 <_panic>
			panic("trying to load memory region outside correct region!\n");
  4000f1:	83 ec 04             	sub    $0x4,%esp
  4000f4:	8d 83 e4 cd fe ff    	lea    -0x1321c(%ebx),%eax
  4000fa:	50                   	push   %eax
  4000fb:	6a 50                	push   $0x50
  4000fd:	8d 83 98 cd fe ff    	lea    -0x13268(%ebx),%eax
  400103:	50                   	push   %eax
  400104:	e8 37 ff ff ff       	call   400040 <_panic>
	for(int i = 0; i < header->e_phnum; i++) {
  400109:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  40010d:	83 c6 20             	add    $0x20,%esi
  400110:	8b 45 08             	mov    0x8(%ebp),%eax
  400113:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  400117:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  40011a:	7e 45                	jle    400161 <load_code+0xb8>
		if(ph[i].p_type != ELF_PROG_LOAD) continue;
  40011c:	83 3e 01             	cmpl   $0x1,(%esi)
  40011f:	75 e8                	jne    400109 <load_code+0x60>
		if(ph[i].p_va < 0x800000  ||  ph[i].p_va > USTACKTOP) {
  400121:	8b 46 08             	mov    0x8(%esi),%eax
  400124:	8d 90 00 00 80 ff    	lea    -0x800000(%eax),%edx
  40012a:	81 fa 00 e0 2f 00    	cmp    $0x2fe000,%edx
  400130:	77 bf                	ja     4000f1 <load_code+0x48>
		memcpy((void*) ph[i].p_va, (void*) (ph[i].p_offset + binary), ph[i].p_filesz);
  400132:	83 ec 04             	sub    $0x4,%esp
  400135:	ff 76 10             	pushl  0x10(%esi)
  400138:	8b 55 08             	mov    0x8(%ebp),%edx
  40013b:	03 56 04             	add    0x4(%esi),%edx
  40013e:	52                   	push   %edx
  40013f:	50                   	push   %eax
  400140:	e8 bc 1b 00 00       	call   401d01 <memcpy>
		memset((void*) ph[i].p_va + ph[i].p_filesz, 0, ph[i].p_memsz - ph[i].p_filesz);
  400145:	8b 46 10             	mov    0x10(%esi),%eax
  400148:	83 c4 0c             	add    $0xc,%esp
  40014b:	8b 56 14             	mov    0x14(%esi),%edx
  40014e:	29 c2                	sub    %eax,%edx
  400150:	52                   	push   %edx
  400151:	6a 00                	push   $0x0
  400153:	03 46 08             	add    0x8(%esi),%eax
  400156:	50                   	push   %eax
  400157:	e8 f0 1a 00 00       	call   401c4c <memset>
  40015c:	83 c4 10             	add    $0x10,%esp
  40015f:	eb a8                	jmp    400109 <load_code+0x60>
	return (void (*)()) header->e_entry;
  400161:	8b 45 08             	mov    0x8(%ebp),%eax
  400164:	8b 40 18             	mov    0x18(%eax),%eax
}
  400167:	8d 65 f4             	lea    -0xc(%ebp),%esp
  40016a:	5b                   	pop    %ebx
  40016b:	5e                   	pop    %esi
  40016c:	5f                   	pop    %edi
  40016d:	5d                   	pop    %ebp
  40016e:	c3                   	ret    

0040016f <i386_init>:
{
  40016f:	55                   	push   %ebp
  400170:	89 e5                	mov    %esp,%ebp
  400172:	56                   	push   %esi
  400173:	53                   	push   %ebx
  400174:	83 ec 54             	sub    $0x54,%esp
  400177:	e8 e1 00 00 00       	call   40025d <__x86.get_pc_thunk.bx>
  40017c:	81 c3 b8 51 01 00    	add    $0x151b8,%ebx
	memset(edata, 0, end - edata);
  400182:	c7 c2 c0 70 41 00    	mov    $0x4170c0,%edx
  400188:	c7 c0 a0 7f 41 00    	mov    $0x417fa0,%eax
  40018e:	29 d0                	sub    %edx,%eax
  400190:	50                   	push   %eax
  400191:	6a 00                	push   $0x0
  400193:	52                   	push   %edx
  400194:	e8 b3 1a 00 00       	call   401c4c <memset>
	cons_init();
  400199:	e8 14 05 00 00       	call   4006b2 <cons_init>
	cprintf(OS_START);
  40019e:	8d 83 a4 cd fe ff    	lea    -0x1325c(%ebx),%eax
  4001a4:	89 04 24             	mov    %eax,(%esp)
  4001a7:	e8 49 07 00 00       	call   4008f5 <cprintf>
	env_init();
  4001ac:	e8 52 06 00 00       	call   400803 <env_init>
	trap_init();
  4001b1:	e8 f2 07 00 00       	call   4009a8 <trap_init>
	ide_read(2000, binary_to_load, MAX_RW);
  4001b6:	83 c4 0c             	add    $0xc,%esp
  4001b9:	68 ff 00 00 00       	push   $0xff
  4001be:	c7 c6 e0 7f 41 00    	mov    $0x417fe0,%esi
  4001c4:	56                   	push   %esi
  4001c5:	68 d0 07 00 00       	push   $0x7d0
  4001ca:	e8 97 10 00 00       	call   401266 <ide_read>
	if(header->e_magic == ELF_MAGIC) {
  4001cf:	83 c4 10             	add    $0x10,%esp
  4001d2:	81 3e 7f 45 4c 46    	cmpl   $0x464c457f,(%esi)
  4001d8:	74 23                	je     4001fd <i386_init+0x8e>
	void (*loaded_start_func)()  = load_code(binary_to_load);
  4001da:	83 ec 0c             	sub    $0xc,%esp
  4001dd:	ff b3 fc ff ff ff    	pushl  -0x4(%ebx)
  4001e3:	e8 c1 fe ff ff       	call   4000a9 <load_code>
	initialize_new_trapframe(&trapframe, loaded_start_func);
  4001e8:	83 c4 08             	add    $0x8,%esp
  4001eb:	50                   	push   %eax
  4001ec:	8d 75 b4             	lea    -0x4c(%ebp),%esi
  4001ef:	56                   	push   %esi
  4001f0:	e8 49 06 00 00       	call   40083e <initialize_new_trapframe>
	run_trapframe(&trapframe);
  4001f5:	89 34 24             	mov    %esi,(%esp)
  4001f8:	e8 6e 06 00 00       	call   40086b <run_trapframe>
		cprintf("I found the ELF header!");
  4001fd:	83 ec 0c             	sub    $0xc,%esp
  400200:	8d 83 b1 cd fe ff    	lea    -0x1324f(%ebx),%eax
  400206:	50                   	push   %eax
  400207:	e8 e9 06 00 00       	call   4008f5 <cprintf>
  40020c:	83 c4 10             	add    $0x10,%esp
  40020f:	eb c9                	jmp    4001da <i386_init+0x6b>

00400211 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
  400211:	55                   	push   %ebp
  400212:	89 e5                	mov    %esp,%ebp
  400214:	56                   	push   %esi
  400215:	53                   	push   %ebx
  400216:	e8 42 00 00 00       	call   40025d <__x86.get_pc_thunk.bx>
  40021b:	81 c3 19 51 01 00    	add    $0x15119,%ebx
	va_list ap;

	va_start(ap, fmt);
  400221:	8d 75 14             	lea    0x14(%ebp),%esi
	cprintf("kernel warning at %s:%d: ", file, line);
  400224:	83 ec 04             	sub    $0x4,%esp
  400227:	ff 75 0c             	pushl  0xc(%ebp)
  40022a:	ff 75 08             	pushl  0x8(%ebp)
  40022d:	8d 83 c9 cd fe ff    	lea    -0x13237(%ebx),%eax
  400233:	50                   	push   %eax
  400234:	e8 bc 06 00 00       	call   4008f5 <cprintf>
	vcprintf(fmt, ap);
  400239:	83 c4 08             	add    $0x8,%esp
  40023c:	56                   	push   %esi
  40023d:	ff 75 10             	pushl  0x10(%ebp)
  400240:	e8 79 06 00 00       	call   4008be <vcprintf>
	cprintf("\n");
  400245:	8d 83 af cd fe ff    	lea    -0x13251(%ebx),%eax
  40024b:	89 04 24             	mov    %eax,(%esp)
  40024e:	e8 a2 06 00 00       	call   4008f5 <cprintf>
	va_end(ap);
}
  400253:	83 c4 10             	add    $0x10,%esp
  400256:	8d 65 f8             	lea    -0x8(%ebp),%esp
  400259:	5b                   	pop    %ebx
  40025a:	5e                   	pop    %esi
  40025b:	5d                   	pop    %ebp
  40025c:	c3                   	ret    

0040025d <__x86.get_pc_thunk.bx>:
  40025d:	8b 1c 24             	mov    (%esp),%ebx
  400260:	c3                   	ret    

00400261 <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
  400261:	55                   	push   %ebp
  400262:	89 e5                	mov    %esp,%ebp
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  400264:	ba fd 03 00 00       	mov    $0x3fd,%edx
  400269:	ec                   	in     (%dx),%al
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
  40026a:	a8 01                	test   $0x1,%al
  40026c:	74 0b                	je     400279 <serial_proc_data+0x18>
  40026e:	ba f8 03 00 00       	mov    $0x3f8,%edx
  400273:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
  400274:	0f b6 c0             	movzbl %al,%eax
}
  400277:	5d                   	pop    %ebp
  400278:	c3                   	ret    
		return -1;
  400279:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  40027e:	eb f7                	jmp    400277 <serial_proc_data+0x16>

00400280 <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
  400280:	55                   	push   %ebp
  400281:	89 e5                	mov    %esp,%ebp
  400283:	56                   	push   %esi
  400284:	53                   	push   %ebx
  400285:	e8 d3 ff ff ff       	call   40025d <__x86.get_pc_thunk.bx>
  40028a:	81 c3 aa 50 01 00    	add    $0x150aa,%ebx
  400290:	89 c6                	mov    %eax,%esi
	int c;

	while ((c = (*proc)()) != -1) {
  400292:	ff d6                	call   *%esi
  400294:	83 f8 ff             	cmp    $0xffffffff,%eax
  400297:	74 2e                	je     4002c7 <cons_intr+0x47>
		if (c == 0)
  400299:	85 c0                	test   %eax,%eax
  40029b:	74 f5                	je     400292 <cons_intr+0x12>
			continue;
		cons.buf[cons.wpos++] = c;
  40029d:	8b 8b b0 1f 00 00    	mov    0x1fb0(%ebx),%ecx
  4002a3:	8d 51 01             	lea    0x1(%ecx),%edx
  4002a6:	89 93 b0 1f 00 00    	mov    %edx,0x1fb0(%ebx)
  4002ac:	88 84 0b ac 1d 00 00 	mov    %al,0x1dac(%ebx,%ecx,1)
		if (cons.wpos == CONSBUFSIZE)
  4002b3:	81 fa 00 02 00 00    	cmp    $0x200,%edx
  4002b9:	75 d7                	jne    400292 <cons_intr+0x12>
			cons.wpos = 0;
  4002bb:	c7 83 b0 1f 00 00 00 	movl   $0x0,0x1fb0(%ebx)
  4002c2:	00 00 00 
  4002c5:	eb cb                	jmp    400292 <cons_intr+0x12>
	}
}
  4002c7:	5b                   	pop    %ebx
  4002c8:	5e                   	pop    %esi
  4002c9:	5d                   	pop    %ebp
  4002ca:	c3                   	ret    

004002cb <kbd_proc_data>:
{
  4002cb:	55                   	push   %ebp
  4002cc:	89 e5                	mov    %esp,%ebp
  4002ce:	56                   	push   %esi
  4002cf:	53                   	push   %ebx
  4002d0:	e8 88 ff ff ff       	call   40025d <__x86.get_pc_thunk.bx>
  4002d5:	81 c3 5f 50 01 00    	add    $0x1505f,%ebx
  4002db:	ba 64 00 00 00       	mov    $0x64,%edx
  4002e0:	ec                   	in     (%dx),%al
	if ((stat & KBS_DIB) == 0)
  4002e1:	a8 01                	test   $0x1,%al
  4002e3:	0f 84 06 01 00 00    	je     4003ef <kbd_proc_data+0x124>
	if (stat & KBS_TERR)
  4002e9:	a8 20                	test   $0x20,%al
  4002eb:	0f 85 05 01 00 00    	jne    4003f6 <kbd_proc_data+0x12b>
  4002f1:	ba 60 00 00 00       	mov    $0x60,%edx
  4002f6:	ec                   	in     (%dx),%al
  4002f7:	89 c2                	mov    %eax,%edx
	if (data == 0xE0) {
  4002f9:	3c e0                	cmp    $0xe0,%al
  4002fb:	0f 84 93 00 00 00    	je     400394 <kbd_proc_data+0xc9>
	} else if (data & 0x80) {
  400301:	84 c0                	test   %al,%al
  400303:	0f 88 a0 00 00 00    	js     4003a9 <kbd_proc_data+0xde>
	} else if (shift & E0ESC) {
  400309:	8b 8b 8c 1d 00 00    	mov    0x1d8c(%ebx),%ecx
  40030f:	f6 c1 40             	test   $0x40,%cl
  400312:	74 0e                	je     400322 <kbd_proc_data+0x57>
		data |= 0x80;
  400314:	83 c8 80             	or     $0xffffff80,%eax
  400317:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
  400319:	83 e1 bf             	and    $0xffffffbf,%ecx
  40031c:	89 8b 8c 1d 00 00    	mov    %ecx,0x1d8c(%ebx)
	shift |= shiftcode[data];
  400322:	0f b6 d2             	movzbl %dl,%edx
  400325:	0f b6 84 13 4c cf fe 	movzbl -0x130b4(%ebx,%edx,1),%eax
  40032c:	ff 
  40032d:	0b 83 8c 1d 00 00    	or     0x1d8c(%ebx),%eax
	shift ^= togglecode[data];
  400333:	0f b6 8c 13 4c ce fe 	movzbl -0x131b4(%ebx,%edx,1),%ecx
  40033a:	ff 
  40033b:	31 c8                	xor    %ecx,%eax
  40033d:	89 83 8c 1d 00 00    	mov    %eax,0x1d8c(%ebx)
	c = charcode[shift & (CTL | SHIFT)][data];
  400343:	89 c1                	mov    %eax,%ecx
  400345:	83 e1 03             	and    $0x3,%ecx
  400348:	8b 8c 8b ec 1c 00 00 	mov    0x1cec(%ebx,%ecx,4),%ecx
  40034f:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
  400353:	0f b6 f2             	movzbl %dl,%esi
	if (shift & CAPSLOCK) {
  400356:	a8 08                	test   $0x8,%al
  400358:	74 0d                	je     400367 <kbd_proc_data+0x9c>
		if ('a' <= c && c <= 'z')
  40035a:	89 f2                	mov    %esi,%edx
  40035c:	8d 4e 9f             	lea    -0x61(%esi),%ecx
  40035f:	83 f9 19             	cmp    $0x19,%ecx
  400362:	77 7a                	ja     4003de <kbd_proc_data+0x113>
			c += 'A' - 'a';
  400364:	83 ee 20             	sub    $0x20,%esi
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  400367:	f7 d0                	not    %eax
  400369:	a8 06                	test   $0x6,%al
  40036b:	75 33                	jne    4003a0 <kbd_proc_data+0xd5>
  40036d:	81 fe e9 00 00 00    	cmp    $0xe9,%esi
  400373:	75 2b                	jne    4003a0 <kbd_proc_data+0xd5>
		cprintf("Rebooting!\n");
  400375:	83 ec 0c             	sub    $0xc,%esp
  400378:	8d 83 1a ce fe ff    	lea    -0x131e6(%ebx),%eax
  40037e:	50                   	push   %eax
  40037f:	e8 71 05 00 00       	call   4008f5 <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  400384:	b8 03 00 00 00       	mov    $0x3,%eax
  400389:	ba 92 00 00 00       	mov    $0x92,%edx
  40038e:	ee                   	out    %al,(%dx)
  40038f:	83 c4 10             	add    $0x10,%esp
  400392:	eb 0c                	jmp    4003a0 <kbd_proc_data+0xd5>
		shift |= E0ESC;
  400394:	83 8b 8c 1d 00 00 40 	orl    $0x40,0x1d8c(%ebx)
		return 0;
  40039b:	be 00 00 00 00       	mov    $0x0,%esi
}
  4003a0:	89 f0                	mov    %esi,%eax
  4003a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  4003a5:	5b                   	pop    %ebx
  4003a6:	5e                   	pop    %esi
  4003a7:	5d                   	pop    %ebp
  4003a8:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
  4003a9:	8b 8b 8c 1d 00 00    	mov    0x1d8c(%ebx),%ecx
  4003af:	89 ce                	mov    %ecx,%esi
  4003b1:	83 e6 40             	and    $0x40,%esi
  4003b4:	83 e0 7f             	and    $0x7f,%eax
  4003b7:	85 f6                	test   %esi,%esi
  4003b9:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
  4003bc:	0f b6 d2             	movzbl %dl,%edx
  4003bf:	0f b6 84 13 4c cf fe 	movzbl -0x130b4(%ebx,%edx,1),%eax
  4003c6:	ff 
  4003c7:	83 c8 40             	or     $0x40,%eax
  4003ca:	0f b6 c0             	movzbl %al,%eax
  4003cd:	f7 d0                	not    %eax
  4003cf:	21 c8                	and    %ecx,%eax
  4003d1:	89 83 8c 1d 00 00    	mov    %eax,0x1d8c(%ebx)
		return 0;
  4003d7:	be 00 00 00 00       	mov    $0x0,%esi
  4003dc:	eb c2                	jmp    4003a0 <kbd_proc_data+0xd5>
		else if ('A' <= c && c <= 'Z')
  4003de:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
  4003e1:	8d 4e 20             	lea    0x20(%esi),%ecx
  4003e4:	83 fa 1a             	cmp    $0x1a,%edx
  4003e7:	0f 42 f1             	cmovb  %ecx,%esi
  4003ea:	e9 78 ff ff ff       	jmp    400367 <kbd_proc_data+0x9c>
		return -1;
  4003ef:	be ff ff ff ff       	mov    $0xffffffff,%esi
  4003f4:	eb aa                	jmp    4003a0 <kbd_proc_data+0xd5>
		return -1;
  4003f6:	be ff ff ff ff       	mov    $0xffffffff,%esi
  4003fb:	eb a3                	jmp    4003a0 <kbd_proc_data+0xd5>

004003fd <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
  4003fd:	55                   	push   %ebp
  4003fe:	89 e5                	mov    %esp,%ebp
  400400:	57                   	push   %edi
  400401:	56                   	push   %esi
  400402:	53                   	push   %ebx
  400403:	83 ec 1c             	sub    $0x1c,%esp
  400406:	e8 52 fe ff ff       	call   40025d <__x86.get_pc_thunk.bx>
  40040b:	81 c3 29 4f 01 00    	add    $0x14f29,%ebx
  400411:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	for (i = 0;
  400414:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  400419:	bf fd 03 00 00       	mov    $0x3fd,%edi
  40041e:	b9 84 00 00 00       	mov    $0x84,%ecx
  400423:	eb 09                	jmp    40042e <cons_putc+0x31>
  400425:	89 ca                	mov    %ecx,%edx
  400427:	ec                   	in     (%dx),%al
  400428:	ec                   	in     (%dx),%al
  400429:	ec                   	in     (%dx),%al
  40042a:	ec                   	in     (%dx),%al
	     i++)
  40042b:	83 c6 01             	add    $0x1,%esi
  40042e:	89 fa                	mov    %edi,%edx
  400430:	ec                   	in     (%dx),%al
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
  400431:	a8 20                	test   $0x20,%al
  400433:	75 08                	jne    40043d <cons_putc+0x40>
  400435:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
  40043b:	7e e8                	jle    400425 <cons_putc+0x28>
	outb(COM1 + COM_TX, c);
  40043d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  400440:	89 f8                	mov    %edi,%eax
  400442:	88 45 e3             	mov    %al,-0x1d(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  400445:	ba f8 03 00 00       	mov    $0x3f8,%edx
  40044a:	ee                   	out    %al,(%dx)
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
  40044b:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  400450:	bf 79 03 00 00       	mov    $0x379,%edi
  400455:	b9 84 00 00 00       	mov    $0x84,%ecx
  40045a:	eb 09                	jmp    400465 <cons_putc+0x68>
  40045c:	89 ca                	mov    %ecx,%edx
  40045e:	ec                   	in     (%dx),%al
  40045f:	ec                   	in     (%dx),%al
  400460:	ec                   	in     (%dx),%al
  400461:	ec                   	in     (%dx),%al
  400462:	83 c6 01             	add    $0x1,%esi
  400465:	89 fa                	mov    %edi,%edx
  400467:	ec                   	in     (%dx),%al
  400468:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
  40046e:	7f 04                	jg     400474 <cons_putc+0x77>
  400470:	84 c0                	test   %al,%al
  400472:	79 e8                	jns    40045c <cons_putc+0x5f>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  400474:	ba 78 03 00 00       	mov    $0x378,%edx
  400479:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  40047d:	ee                   	out    %al,(%dx)
  40047e:	ba 7a 03 00 00       	mov    $0x37a,%edx
  400483:	b8 0d 00 00 00       	mov    $0xd,%eax
  400488:	ee                   	out    %al,(%dx)
  400489:	b8 08 00 00 00       	mov    $0x8,%eax
  40048e:	ee                   	out    %al,(%dx)
	if (!(c & ~0xFF))
  40048f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  400492:	89 fa                	mov    %edi,%edx
  400494:	81 e2 00 ff ff ff    	and    $0xffffff00,%edx
		c |= 0x0700;
  40049a:	89 f8                	mov    %edi,%eax
  40049c:	80 cc 07             	or     $0x7,%ah
  40049f:	85 d2                	test   %edx,%edx
  4004a1:	0f 45 c7             	cmovne %edi,%eax
  4004a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	switch (c & 0xff) {
  4004a7:	0f b6 c0             	movzbl %al,%eax
  4004aa:	83 f8 09             	cmp    $0x9,%eax
  4004ad:	0f 84 b9 00 00 00    	je     40056c <cons_putc+0x16f>
  4004b3:	83 f8 09             	cmp    $0x9,%eax
  4004b6:	7e 74                	jle    40052c <cons_putc+0x12f>
  4004b8:	83 f8 0a             	cmp    $0xa,%eax
  4004bb:	0f 84 9e 00 00 00    	je     40055f <cons_putc+0x162>
  4004c1:	83 f8 0d             	cmp    $0xd,%eax
  4004c4:	0f 85 d9 00 00 00    	jne    4005a3 <cons_putc+0x1a6>
		crt_pos -= (crt_pos % CRT_COLS);
  4004ca:	0f b7 83 b4 1f 00 00 	movzwl 0x1fb4(%ebx),%eax
  4004d1:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  4004d7:	c1 e8 16             	shr    $0x16,%eax
  4004da:	8d 04 80             	lea    (%eax,%eax,4),%eax
  4004dd:	c1 e0 04             	shl    $0x4,%eax
  4004e0:	66 89 83 b4 1f 00 00 	mov    %ax,0x1fb4(%ebx)
	if (crt_pos >= CRT_SIZE) {
  4004e7:	66 81 bb b4 1f 00 00 	cmpw   $0x7cf,0x1fb4(%ebx)
  4004ee:	cf 07 
  4004f0:	0f 87 d4 00 00 00    	ja     4005ca <cons_putc+0x1cd>
	outb(addr_6845, 14);
  4004f6:	8b 8b bc 1f 00 00    	mov    0x1fbc(%ebx),%ecx
  4004fc:	b8 0e 00 00 00       	mov    $0xe,%eax
  400501:	89 ca                	mov    %ecx,%edx
  400503:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
  400504:	0f b7 9b b4 1f 00 00 	movzwl 0x1fb4(%ebx),%ebx
  40050b:	8d 71 01             	lea    0x1(%ecx),%esi
  40050e:	89 d8                	mov    %ebx,%eax
  400510:	66 c1 e8 08          	shr    $0x8,%ax
  400514:	89 f2                	mov    %esi,%edx
  400516:	ee                   	out    %al,(%dx)
  400517:	b8 0f 00 00 00       	mov    $0xf,%eax
  40051c:	89 ca                	mov    %ecx,%edx
  40051e:	ee                   	out    %al,(%dx)
  40051f:	89 d8                	mov    %ebx,%eax
  400521:	89 f2                	mov    %esi,%edx
  400523:	ee                   	out    %al,(%dx)
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
  400524:	8d 65 f4             	lea    -0xc(%ebp),%esp
  400527:	5b                   	pop    %ebx
  400528:	5e                   	pop    %esi
  400529:	5f                   	pop    %edi
  40052a:	5d                   	pop    %ebp
  40052b:	c3                   	ret    
	switch (c & 0xff) {
  40052c:	83 f8 08             	cmp    $0x8,%eax
  40052f:	75 72                	jne    4005a3 <cons_putc+0x1a6>
		if (crt_pos > 0) {
  400531:	0f b7 83 b4 1f 00 00 	movzwl 0x1fb4(%ebx),%eax
  400538:	66 85 c0             	test   %ax,%ax
  40053b:	74 b9                	je     4004f6 <cons_putc+0xf9>
			crt_pos--;
  40053d:	83 e8 01             	sub    $0x1,%eax
  400540:	66 89 83 b4 1f 00 00 	mov    %ax,0x1fb4(%ebx)
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
  400547:	0f b7 c0             	movzwl %ax,%eax
  40054a:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
  40054e:	b2 00                	mov    $0x0,%dl
  400550:	83 ca 20             	or     $0x20,%edx
  400553:	8b 8b b8 1f 00 00    	mov    0x1fb8(%ebx),%ecx
  400559:	66 89 14 41          	mov    %dx,(%ecx,%eax,2)
  40055d:	eb 88                	jmp    4004e7 <cons_putc+0xea>
		crt_pos += CRT_COLS;
  40055f:	66 83 83 b4 1f 00 00 	addw   $0x50,0x1fb4(%ebx)
  400566:	50 
  400567:	e9 5e ff ff ff       	jmp    4004ca <cons_putc+0xcd>
		cons_putc(' ');
  40056c:	b8 20 00 00 00       	mov    $0x20,%eax
  400571:	e8 87 fe ff ff       	call   4003fd <cons_putc>
		cons_putc(' ');
  400576:	b8 20 00 00 00       	mov    $0x20,%eax
  40057b:	e8 7d fe ff ff       	call   4003fd <cons_putc>
		cons_putc(' ');
  400580:	b8 20 00 00 00       	mov    $0x20,%eax
  400585:	e8 73 fe ff ff       	call   4003fd <cons_putc>
		cons_putc(' ');
  40058a:	b8 20 00 00 00       	mov    $0x20,%eax
  40058f:	e8 69 fe ff ff       	call   4003fd <cons_putc>
		cons_putc(' ');
  400594:	b8 20 00 00 00       	mov    $0x20,%eax
  400599:	e8 5f fe ff ff       	call   4003fd <cons_putc>
  40059e:	e9 44 ff ff ff       	jmp    4004e7 <cons_putc+0xea>
		crt_buf[crt_pos++] = c;		/* write the character */
  4005a3:	0f b7 83 b4 1f 00 00 	movzwl 0x1fb4(%ebx),%eax
  4005aa:	8d 50 01             	lea    0x1(%eax),%edx
  4005ad:	66 89 93 b4 1f 00 00 	mov    %dx,0x1fb4(%ebx)
  4005b4:	0f b7 c0             	movzwl %ax,%eax
  4005b7:	8b 93 b8 1f 00 00    	mov    0x1fb8(%ebx),%edx
  4005bd:	0f b7 7d e4          	movzwl -0x1c(%ebp),%edi
  4005c1:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
  4005c5:	e9 1d ff ff ff       	jmp    4004e7 <cons_putc+0xea>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  4005ca:	8b 83 b8 1f 00 00    	mov    0x1fb8(%ebx),%eax
  4005d0:	83 ec 04             	sub    $0x4,%esp
  4005d3:	68 00 0f 00 00       	push   $0xf00
  4005d8:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  4005de:	52                   	push   %edx
  4005df:	50                   	push   %eax
  4005e0:	e8 b4 16 00 00       	call   401c99 <memmove>
			crt_buf[i] = 0x0700 | ' ';
  4005e5:	8b 93 b8 1f 00 00    	mov    0x1fb8(%ebx),%edx
  4005eb:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
  4005f1:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
  4005f7:	83 c4 10             	add    $0x10,%esp
  4005fa:	66 c7 00 20 07       	movw   $0x720,(%eax)
  4005ff:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
  400602:	39 d0                	cmp    %edx,%eax
  400604:	75 f4                	jne    4005fa <cons_putc+0x1fd>
		crt_pos -= CRT_COLS;
  400606:	66 83 ab b4 1f 00 00 	subw   $0x50,0x1fb4(%ebx)
  40060d:	50 
  40060e:	e9 e3 fe ff ff       	jmp    4004f6 <cons_putc+0xf9>

00400613 <serial_intr>:
{
  400613:	e8 e7 01 00 00       	call   4007ff <__x86.get_pc_thunk.ax>
  400618:	05 1c 4d 01 00       	add    $0x14d1c,%eax
	if (serial_exists)
  40061d:	80 b8 c0 1f 00 00 00 	cmpb   $0x0,0x1fc0(%eax)
  400624:	75 02                	jne    400628 <serial_intr+0x15>
  400626:	f3 c3                	repz ret 
{
  400628:	55                   	push   %ebp
  400629:	89 e5                	mov    %esp,%ebp
  40062b:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
  40062e:	8d 80 2d af fe ff    	lea    -0x150d3(%eax),%eax
  400634:	e8 47 fc ff ff       	call   400280 <cons_intr>
}
  400639:	c9                   	leave  
  40063a:	c3                   	ret    

0040063b <kbd_intr>:
{
  40063b:	55                   	push   %ebp
  40063c:	89 e5                	mov    %esp,%ebp
  40063e:	83 ec 08             	sub    $0x8,%esp
  400641:	e8 b9 01 00 00       	call   4007ff <__x86.get_pc_thunk.ax>
  400646:	05 ee 4c 01 00       	add    $0x14cee,%eax
	cons_intr(kbd_proc_data);
  40064b:	8d 80 97 af fe ff    	lea    -0x15069(%eax),%eax
  400651:	e8 2a fc ff ff       	call   400280 <cons_intr>
}
  400656:	c9                   	leave  
  400657:	c3                   	ret    

00400658 <cons_getc>:
{
  400658:	55                   	push   %ebp
  400659:	89 e5                	mov    %esp,%ebp
  40065b:	53                   	push   %ebx
  40065c:	83 ec 04             	sub    $0x4,%esp
  40065f:	e8 f9 fb ff ff       	call   40025d <__x86.get_pc_thunk.bx>
  400664:	81 c3 d0 4c 01 00    	add    $0x14cd0,%ebx
	serial_intr();
  40066a:	e8 a4 ff ff ff       	call   400613 <serial_intr>
	kbd_intr();
  40066f:	e8 c7 ff ff ff       	call   40063b <kbd_intr>
	if (cons.rpos != cons.wpos) {
  400674:	8b 93 ac 1f 00 00    	mov    0x1fac(%ebx),%edx
	return 0;
  40067a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (cons.rpos != cons.wpos) {
  40067f:	3b 93 b0 1f 00 00    	cmp    0x1fb0(%ebx),%edx
  400685:	74 19                	je     4006a0 <cons_getc+0x48>
		c = cons.buf[cons.rpos++];
  400687:	8d 4a 01             	lea    0x1(%edx),%ecx
  40068a:	89 8b ac 1f 00 00    	mov    %ecx,0x1fac(%ebx)
  400690:	0f b6 84 13 ac 1d 00 	movzbl 0x1dac(%ebx,%edx,1),%eax
  400697:	00 
		if (cons.rpos == CONSBUFSIZE)
  400698:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
  40069e:	74 06                	je     4006a6 <cons_getc+0x4e>
}
  4006a0:	83 c4 04             	add    $0x4,%esp
  4006a3:	5b                   	pop    %ebx
  4006a4:	5d                   	pop    %ebp
  4006a5:	c3                   	ret    
			cons.rpos = 0;
  4006a6:	c7 83 ac 1f 00 00 00 	movl   $0x0,0x1fac(%ebx)
  4006ad:	00 00 00 
  4006b0:	eb ee                	jmp    4006a0 <cons_getc+0x48>

004006b2 <cons_init>:

// initialize the console devices
void
cons_init(void)
{
  4006b2:	55                   	push   %ebp
  4006b3:	89 e5                	mov    %esp,%ebp
  4006b5:	57                   	push   %edi
  4006b6:	56                   	push   %esi
  4006b7:	53                   	push   %ebx
  4006b8:	83 ec 1c             	sub    $0x1c,%esp
  4006bb:	e8 9d fb ff ff       	call   40025d <__x86.get_pc_thunk.bx>
  4006c0:	81 c3 74 4c 01 00    	add    $0x14c74,%ebx
	was = *cp;
  4006c6:	0f b7 15 00 80 0b 00 	movzwl 0xb8000,%edx
	*cp = (uint16_t) 0xA55A;
  4006cd:	66 c7 05 00 80 0b 00 	movw   $0xa55a,0xb8000
  4006d4:	5a a5 
	if (*cp != 0xA55A) {
  4006d6:	0f b7 05 00 80 0b 00 	movzwl 0xb8000,%eax
  4006dd:	66 3d 5a a5          	cmp    $0xa55a,%ax
  4006e1:	0f 84 bc 00 00 00    	je     4007a3 <cons_init+0xf1>
		addr_6845 = MONO_BASE;
  4006e7:	c7 83 bc 1f 00 00 b4 	movl   $0x3b4,0x1fbc(%ebx)
  4006ee:	03 00 00 
		cp = (uint16_t*) MONO_BUF;
  4006f1:	c7 45 e4 00 00 0b 00 	movl   $0xb0000,-0x1c(%ebp)
	outb(addr_6845, 14);
  4006f8:	8b bb bc 1f 00 00    	mov    0x1fbc(%ebx),%edi
  4006fe:	b8 0e 00 00 00       	mov    $0xe,%eax
  400703:	89 fa                	mov    %edi,%edx
  400705:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
  400706:	8d 4f 01             	lea    0x1(%edi),%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  400709:	89 ca                	mov    %ecx,%edx
  40070b:	ec                   	in     (%dx),%al
  40070c:	0f b6 f0             	movzbl %al,%esi
  40070f:	c1 e6 08             	shl    $0x8,%esi
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  400712:	b8 0f 00 00 00       	mov    $0xf,%eax
  400717:	89 fa                	mov    %edi,%edx
  400719:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  40071a:	89 ca                	mov    %ecx,%edx
  40071c:	ec                   	in     (%dx),%al
	crt_buf = (uint16_t*) cp;
  40071d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  400720:	89 bb b8 1f 00 00    	mov    %edi,0x1fb8(%ebx)
	pos |= inb(addr_6845 + 1);
  400726:	0f b6 c0             	movzbl %al,%eax
  400729:	09 c6                	or     %eax,%esi
	crt_pos = pos;
  40072b:	66 89 b3 b4 1f 00 00 	mov    %si,0x1fb4(%ebx)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  400732:	b9 00 00 00 00       	mov    $0x0,%ecx
  400737:	89 c8                	mov    %ecx,%eax
  400739:	ba fa 03 00 00       	mov    $0x3fa,%edx
  40073e:	ee                   	out    %al,(%dx)
  40073f:	bf fb 03 00 00       	mov    $0x3fb,%edi
  400744:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
  400749:	89 fa                	mov    %edi,%edx
  40074b:	ee                   	out    %al,(%dx)
  40074c:	b8 0c 00 00 00       	mov    $0xc,%eax
  400751:	ba f8 03 00 00       	mov    $0x3f8,%edx
  400756:	ee                   	out    %al,(%dx)
  400757:	be f9 03 00 00       	mov    $0x3f9,%esi
  40075c:	89 c8                	mov    %ecx,%eax
  40075e:	89 f2                	mov    %esi,%edx
  400760:	ee                   	out    %al,(%dx)
  400761:	b8 03 00 00 00       	mov    $0x3,%eax
  400766:	89 fa                	mov    %edi,%edx
  400768:	ee                   	out    %al,(%dx)
  400769:	ba fc 03 00 00       	mov    $0x3fc,%edx
  40076e:	89 c8                	mov    %ecx,%eax
  400770:	ee                   	out    %al,(%dx)
  400771:	b8 01 00 00 00       	mov    $0x1,%eax
  400776:	89 f2                	mov    %esi,%edx
  400778:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  400779:	ba fd 03 00 00       	mov    $0x3fd,%edx
  40077e:	ec                   	in     (%dx),%al
  40077f:	89 c1                	mov    %eax,%ecx
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
  400781:	3c ff                	cmp    $0xff,%al
  400783:	0f 95 83 c0 1f 00 00 	setne  0x1fc0(%ebx)
  40078a:	ba fa 03 00 00       	mov    $0x3fa,%edx
  40078f:	ec                   	in     (%dx),%al
  400790:	ba f8 03 00 00       	mov    $0x3f8,%edx
  400795:	ec                   	in     (%dx),%al
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
  400796:	80 f9 ff             	cmp    $0xff,%cl
  400799:	74 25                	je     4007c0 <cons_init+0x10e>
		cprintf("Serial port does not exist!\n");
}
  40079b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  40079e:	5b                   	pop    %ebx
  40079f:	5e                   	pop    %esi
  4007a0:	5f                   	pop    %edi
  4007a1:	5d                   	pop    %ebp
  4007a2:	c3                   	ret    
		*cp = was;
  4007a3:	66 89 15 00 80 0b 00 	mov    %dx,0xb8000
		addr_6845 = CGA_BASE;
  4007aa:	c7 83 bc 1f 00 00 d4 	movl   $0x3d4,0x1fbc(%ebx)
  4007b1:	03 00 00 
	cp = (uint16_t*) CGA_BUF;
  4007b4:	c7 45 e4 00 80 0b 00 	movl   $0xb8000,-0x1c(%ebp)
  4007bb:	e9 38 ff ff ff       	jmp    4006f8 <cons_init+0x46>
		cprintf("Serial port does not exist!\n");
  4007c0:	83 ec 0c             	sub    $0xc,%esp
  4007c3:	8d 83 26 ce fe ff    	lea    -0x131da(%ebx),%eax
  4007c9:	50                   	push   %eax
  4007ca:	e8 26 01 00 00       	call   4008f5 <cprintf>
  4007cf:	83 c4 10             	add    $0x10,%esp
}
  4007d2:	eb c7                	jmp    40079b <cons_init+0xe9>

004007d4 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
  4007d4:	55                   	push   %ebp
  4007d5:	89 e5                	mov    %esp,%ebp
  4007d7:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
  4007da:	8b 45 08             	mov    0x8(%ebp),%eax
  4007dd:	e8 1b fc ff ff       	call   4003fd <cons_putc>
}
  4007e2:	c9                   	leave  
  4007e3:	c3                   	ret    

004007e4 <getchar>:

int
getchar(void)
{
  4007e4:	55                   	push   %ebp
  4007e5:	89 e5                	mov    %esp,%ebp
  4007e7:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
  4007ea:	e8 69 fe ff ff       	call   400658 <cons_getc>
  4007ef:	85 c0                	test   %eax,%eax
  4007f1:	74 f7                	je     4007ea <getchar+0x6>
		/* do nothing */;
	return c;
}
  4007f3:	c9                   	leave  
  4007f4:	c3                   	ret    

004007f5 <iscons>:

int
iscons(int fdnum)
{
  4007f5:	55                   	push   %ebp
  4007f6:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
}
  4007f8:	b8 01 00 00 00       	mov    $0x1,%eax
  4007fd:	5d                   	pop    %ebp
  4007fe:	c3                   	ret    

004007ff <__x86.get_pc_thunk.ax>:
  4007ff:	8b 04 24             	mov    (%esp),%eax
  400802:	c3                   	ret    

00400803 <env_init>:
};


void
env_init(void)
{
  400803:	55                   	push   %ebp
  400804:	89 e5                	mov    %esp,%ebp
  400806:	e8 f4 ff ff ff       	call   4007ff <__x86.get_pc_thunk.ax>
  40080b:	05 29 4b 01 00       	add    $0x14b29,%eax
}

static inline void
lgdt(void *p)
{
	asm volatile("lgdt (%0)" : : "r" (p));
  400810:	8d 80 cc 1c 00 00    	lea    0x1ccc(%eax),%eax
  400816:	0f 01 10             	lgdtl  (%eax)
	
	lgdt(&gdt_pd);
	// The kernel never uses GS or FS, so we leave those set to
	// the user data segment.
	asm volatile("movw %%ax,%%gs" : : "a" (GD_UD|3));
  400819:	b8 23 00 00 00       	mov    $0x23,%eax
  40081e:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" : : "a" (GD_UD|3));
  400820:	8e e0                	mov    %eax,%fs
	// The kernel does use ES, DS, and SS.  We'll change between
	// the kernel and user data segments as needed.
	asm volatile("movw %%ax,%%es" : : "a" (GD_KD));
  400822:	b8 10 00 00 00       	mov    $0x10,%eax
  400827:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" : : "a" (GD_KD));
  400829:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" : : "a" (GD_KD));
  40082b:	8e d0                	mov    %eax,%ss
	// Load the kernel text segment into CS.
	asm volatile("ljmp %0,$1f\n 1:\n" : : "i" (GD_KT));
  40082d:	ea 34 08 40 00 08 00 	ljmp   $0x8,$0x400834
}

static inline void
lldt(uint16_t sel)
{
	asm volatile("lldt %0" : : "r" (sel));
  400834:	b8 00 00 00 00       	mov    $0x0,%eax
  400839:	0f 00 d0             	lldt   %ax
	// For good measure, clear the local descriptor table (LDT),
	// since we don't use it.
	lldt(0);
}
  40083c:	5d                   	pop    %ebp
  40083d:	c3                   	ret    

0040083e <initialize_new_trapframe>:


void initialize_new_trapframe(struct Trapframe *tf, void (*entry_point)()) {
  40083e:	55                   	push   %ebp
  40083f:	89 e5                	mov    %esp,%ebp
  400841:	8b 45 08             	mov    0x8(%ebp),%eax

	// set the stack to the universal stack top
	tf->tf_esp = USTACKTOP;
  400844:	c7 40 3c 00 e0 af 00 	movl   $0xafe000,0x3c(%eax)
	
	// Set all the segment registers so that this code runs in
	// user rather than kernel mode
	tf->tf_ds = GD_UD | 3;
  40084b:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
	tf->tf_es = GD_UD | 3;
  400851:	66 c7 40 20 23 00    	movw   $0x23,0x20(%eax)
	tf->tf_ss = GD_UD | 3;
  400857:	66 c7 40 40 23 00    	movw   $0x23,0x40(%eax)
	tf->tf_cs = GD_UT | 3;
  40085d:	66 c7 40 34 1b 00    	movw   $0x1b,0x34(%eax)

	// Set the instruction pointer to the entry point
	tf->tf_eip = (uintptr_t) entry_point;
  400863:	8b 55 0c             	mov    0xc(%ebp),%edx
  400866:	89 50 30             	mov    %edx,0x30(%eax)
}
  400869:	5d                   	pop    %ebp
  40086a:	c3                   	ret    

0040086b <run_trapframe>:
//
// This function does not return.
//
void
run_trapframe(struct Trapframe *tf)
{
  40086b:	55                   	push   %ebp
  40086c:	89 e5                	mov    %esp,%ebp
  40086e:	53                   	push   %ebx
  40086f:	83 ec 08             	sub    $0x8,%esp
  400872:	e8 e6 f9 ff ff       	call   40025d <__x86.get_pc_thunk.bx>
  400877:	81 c3 bd 4a 01 00    	add    $0x14abd,%ebx
	asm volatile(
  40087d:	8b 65 08             	mov    0x8(%ebp),%esp
  400880:	61                   	popa   
  400881:	07                   	pop    %es
  400882:	1f                   	pop    %ds
  400883:	83 c4 08             	add    $0x8,%esp
  400886:	cf                   	iret   
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret\n"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
  400887:	8d 83 4c d0 fe ff    	lea    -0x12fb4(%ebx),%eax
  40088d:	50                   	push   %eax
  40088e:	6a 71                	push   $0x71
  400890:	8d 83 58 d0 fe ff    	lea    -0x12fa8(%ebx),%eax
  400896:	50                   	push   %eax
  400897:	e8 a4 f7 ff ff       	call   400040 <_panic>

0040089c <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
  40089c:	55                   	push   %ebp
  40089d:	89 e5                	mov    %esp,%ebp
  40089f:	53                   	push   %ebx
  4008a0:	83 ec 10             	sub    $0x10,%esp
  4008a3:	e8 b5 f9 ff ff       	call   40025d <__x86.get_pc_thunk.bx>
  4008a8:	81 c3 8c 4a 01 00    	add    $0x14a8c,%ebx
	cputchar(ch);
  4008ae:	ff 75 08             	pushl  0x8(%ebp)
  4008b1:	e8 1e ff ff ff       	call   4007d4 <cputchar>
	*cnt++;
}
  4008b6:	83 c4 10             	add    $0x10,%esp
  4008b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  4008bc:	c9                   	leave  
  4008bd:	c3                   	ret    

004008be <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  4008be:	55                   	push   %ebp
  4008bf:	89 e5                	mov    %esp,%ebp
  4008c1:	53                   	push   %ebx
  4008c2:	83 ec 14             	sub    $0x14,%esp
  4008c5:	e8 93 f9 ff ff       	call   40025d <__x86.get_pc_thunk.bx>
  4008ca:	81 c3 6a 4a 01 00    	add    $0x14a6a,%ebx
	int cnt = 0;
  4008d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
  4008d7:	ff 75 0c             	pushl  0xc(%ebp)
  4008da:	ff 75 08             	pushl  0x8(%ebp)
  4008dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  4008e0:	50                   	push   %eax
  4008e1:	8d 83 68 b5 fe ff    	lea    -0x14a98(%ebx),%eax
  4008e7:	50                   	push   %eax
  4008e8:	e8 0f 0c 00 00       	call   4014fc <vprintfmt>
	return cnt;
}
  4008ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  4008f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  4008f3:	c9                   	leave  
  4008f4:	c3                   	ret    

004008f5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  4008f5:	55                   	push   %ebp
  4008f6:	89 e5                	mov    %esp,%ebp
  4008f8:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  4008fb:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  4008fe:	50                   	push   %eax
  4008ff:	ff 75 08             	pushl  0x8(%ebp)
  400902:	e8 b7 ff ff ff       	call   4008be <vcprintf>
	va_end(ap);

	return cnt;
}
  400907:	c9                   	leave  
  400908:	c3                   	ret    

00400909 <trap_init_percpu>:
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
  400909:	55                   	push   %ebp
  40090a:	89 e5                	mov    %esp,%ebp
  40090c:	57                   	push   %edi
  40090d:	56                   	push   %esi
  40090e:	53                   	push   %ebx
  40090f:	83 ec 04             	sub    $0x4,%esp
  400912:	e8 46 f9 ff ff       	call   40025d <__x86.get_pc_thunk.bx>
  400917:	81 c3 1d 4a 01 00    	add    $0x14a1d,%ebx
	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	ts.ts_esp0 = KSTACKTOP;
  40091d:	c7 83 f0 27 00 00 00 	movl   $0x400000,0x27f0(%ebx)
  400924:	00 40 00 
	ts.ts_ss0 = GD_KD;
  400927:	66 c7 83 f4 27 00 00 	movw   $0x10,0x27f4(%ebx)
  40092e:	10 00 
	ts.ts_iomb = sizeof(struct Taskstate);
  400930:	66 c7 83 52 28 00 00 	movw   $0x68,0x2852(%ebx)
  400937:	68 00 

	// Initialize the TSS slot of the gdt.
	gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t) (&ts),
  400939:	c7 c0 00 53 41 00    	mov    $0x415300,%eax
  40093f:	66 c7 40 28 67 00    	movw   $0x67,0x28(%eax)
  400945:	8d b3 ec 27 00 00    	lea    0x27ec(%ebx),%esi
  40094b:	66 89 70 2a          	mov    %si,0x2a(%eax)
  40094f:	89 f2                	mov    %esi,%edx
  400951:	c1 ea 10             	shr    $0x10,%edx
  400954:	88 50 2c             	mov    %dl,0x2c(%eax)
  400957:	0f b6 50 2d          	movzbl 0x2d(%eax),%edx
  40095b:	83 e2 f0             	and    $0xfffffff0,%edx
  40095e:	83 ca 09             	or     $0x9,%edx
  400961:	83 e2 9f             	and    $0xffffff9f,%edx
  400964:	83 ca 80             	or     $0xffffff80,%edx
  400967:	88 55 f3             	mov    %dl,-0xd(%ebp)
  40096a:	88 50 2d             	mov    %dl,0x2d(%eax)
  40096d:	0f b6 48 2e          	movzbl 0x2e(%eax),%ecx
  400971:	83 e1 c0             	and    $0xffffffc0,%ecx
  400974:	83 c9 40             	or     $0x40,%ecx
  400977:	83 e1 7f             	and    $0x7f,%ecx
  40097a:	88 48 2e             	mov    %cl,0x2e(%eax)
  40097d:	c1 ee 18             	shr    $0x18,%esi
  400980:	89 f1                	mov    %esi,%ecx
  400982:	88 48 2f             	mov    %cl,0x2f(%eax)
					sizeof(struct Taskstate) - 1, 0);
	gdt[GD_TSS0 >> 3].sd_s = 0;
  400985:	0f b6 55 f3          	movzbl -0xd(%ebp),%edx
  400989:	83 e2 ef             	and    $0xffffffef,%edx
  40098c:	88 50 2d             	mov    %dl,0x2d(%eax)
}

static inline void
ltr(uint16_t sel)
{
	asm volatile("ltr %0" : : "r" (sel));
  40098f:	b8 28 00 00 00       	mov    $0x28,%eax
  400994:	0f 00 d8             	ltr    %ax
	asm volatile("lidt (%0)" : : "r" (p));
  400997:	8d 83 d4 1c 00 00    	lea    0x1cd4(%ebx),%eax
  40099d:	0f 01 18             	lidtl  (%eax)
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSS0);

	// Load the IDT
	lidt(&idt_pd);
}
  4009a0:	83 c4 04             	add    $0x4,%esp
  4009a3:	5b                   	pop    %ebx
  4009a4:	5e                   	pop    %esi
  4009a5:	5f                   	pop    %edi
  4009a6:	5d                   	pop    %ebp
  4009a7:	c3                   	ret    

004009a8 <trap_init>:
{
  4009a8:	55                   	push   %ebp
  4009a9:	89 e5                	mov    %esp,%ebp
  4009ab:	56                   	push   %esi
  4009ac:	53                   	push   %ebx
  4009ad:	e8 88 07 00 00       	call   40113a <__x86.get_pc_thunk.dx>
  4009b2:	81 c2 82 49 01 00    	add    $0x14982,%edx
		SETGATE(idt[i], 0, GD_KT, unktraphandler, 0);
  4009b8:	c7 c3 3e 11 40 00    	mov    $0x40113e,%ebx
  4009be:	c1 eb 10             	shr    $0x10,%ebx
	for(int i = 0; i <= 255; i++) {
  4009c1:	b8 00 00 00 00       	mov    $0x0,%eax
		SETGATE(idt[i], 0, GD_KT, unktraphandler, 0);
  4009c6:	c7 c6 3e 11 40 00    	mov    $0x40113e,%esi
  4009cc:	66 89 b4 c2 cc 1f 00 	mov    %si,0x1fcc(%edx,%eax,8)
  4009d3:	00 
  4009d4:	8d 8c c2 cc 1f 00 00 	lea    0x1fcc(%edx,%eax,8),%ecx
  4009db:	66 c7 41 02 08 00    	movw   $0x8,0x2(%ecx)
  4009e1:	c6 84 c2 d0 1f 00 00 	movb   $0x0,0x1fd0(%edx,%eax,8)
  4009e8:	00 
  4009e9:	c6 84 c2 d1 1f 00 00 	movb   $0x8e,0x1fd1(%edx,%eax,8)
  4009f0:	8e 
  4009f1:	66 89 59 06          	mov    %bx,0x6(%ecx)
	for(int i = 0; i <= 255; i++) {
  4009f5:	83 c0 01             	add    $0x1,%eax
  4009f8:	3d 00 01 00 00       	cmp    $0x100,%eax
  4009fd:	75 cd                	jne    4009cc <trap_init+0x24>
	SETGATE(idt[0], 0, GD_KT, th0, 0);
  4009ff:	c7 c0 44 11 40 00    	mov    $0x401144,%eax
  400a05:	66 89 82 cc 1f 00 00 	mov    %ax,0x1fcc(%edx)
  400a0c:	66 c7 82 ce 1f 00 00 	movw   $0x8,0x1fce(%edx)
  400a13:	08 00 
  400a15:	c6 82 d0 1f 00 00 00 	movb   $0x0,0x1fd0(%edx)
  400a1c:	c6 82 d1 1f 00 00 8e 	movb   $0x8e,0x1fd1(%edx)
  400a23:	c1 e8 10             	shr    $0x10,%eax
  400a26:	66 89 82 d2 1f 00 00 	mov    %ax,0x1fd2(%edx)
	SETGATE(idt[1], 0, GD_KT, th1, 0);
  400a2d:	c7 c0 4a 11 40 00    	mov    $0x40114a,%eax
  400a33:	66 89 82 d4 1f 00 00 	mov    %ax,0x1fd4(%edx)
  400a3a:	66 c7 82 d6 1f 00 00 	movw   $0x8,0x1fd6(%edx)
  400a41:	08 00 
  400a43:	c6 82 d8 1f 00 00 00 	movb   $0x0,0x1fd8(%edx)
  400a4a:	c6 82 d9 1f 00 00 8e 	movb   $0x8e,0x1fd9(%edx)
  400a51:	c1 e8 10             	shr    $0x10,%eax
  400a54:	66 89 82 da 1f 00 00 	mov    %ax,0x1fda(%edx)
	SETGATE(idt[2], 0, GD_KT, th2, 0);
  400a5b:	c7 c0 50 11 40 00    	mov    $0x401150,%eax
  400a61:	66 89 82 dc 1f 00 00 	mov    %ax,0x1fdc(%edx)
  400a68:	66 c7 82 de 1f 00 00 	movw   $0x8,0x1fde(%edx)
  400a6f:	08 00 
  400a71:	c6 82 e0 1f 00 00 00 	movb   $0x0,0x1fe0(%edx)
  400a78:	c6 82 e1 1f 00 00 8e 	movb   $0x8e,0x1fe1(%edx)
  400a7f:	c1 e8 10             	shr    $0x10,%eax
  400a82:	66 89 82 e2 1f 00 00 	mov    %ax,0x1fe2(%edx)
	SETGATE(idt[3], 1, GD_KT, th3, 3);
  400a89:	c7 c0 54 11 40 00    	mov    $0x401154,%eax
  400a8f:	66 89 82 e4 1f 00 00 	mov    %ax,0x1fe4(%edx)
  400a96:	66 c7 82 e6 1f 00 00 	movw   $0x8,0x1fe6(%edx)
  400a9d:	08 00 
  400a9f:	c6 82 e8 1f 00 00 00 	movb   $0x0,0x1fe8(%edx)
  400aa6:	c6 82 e9 1f 00 00 ef 	movb   $0xef,0x1fe9(%edx)
  400aad:	c1 e8 10             	shr    $0x10,%eax
  400ab0:	66 89 82 ea 1f 00 00 	mov    %ax,0x1fea(%edx)
	SETGATE(idt[4], 0, GD_KT, th4, 0);
  400ab7:	c7 c0 5a 11 40 00    	mov    $0x40115a,%eax
  400abd:	66 89 82 ec 1f 00 00 	mov    %ax,0x1fec(%edx)
  400ac4:	66 c7 82 ee 1f 00 00 	movw   $0x8,0x1fee(%edx)
  400acb:	08 00 
  400acd:	c6 82 f0 1f 00 00 00 	movb   $0x0,0x1ff0(%edx)
  400ad4:	c6 82 f1 1f 00 00 8e 	movb   $0x8e,0x1ff1(%edx)
  400adb:	c1 e8 10             	shr    $0x10,%eax
  400ade:	66 89 82 f2 1f 00 00 	mov    %ax,0x1ff2(%edx)
	SETGATE(idt[5], 0, GD_KT, th5, 0);
  400ae5:	c7 c0 5e 11 40 00    	mov    $0x40115e,%eax
  400aeb:	66 89 82 f4 1f 00 00 	mov    %ax,0x1ff4(%edx)
  400af2:	66 c7 82 f6 1f 00 00 	movw   $0x8,0x1ff6(%edx)
  400af9:	08 00 
  400afb:	c6 82 f8 1f 00 00 00 	movb   $0x0,0x1ff8(%edx)
  400b02:	c6 82 f9 1f 00 00 8e 	movb   $0x8e,0x1ff9(%edx)
  400b09:	c1 e8 10             	shr    $0x10,%eax
  400b0c:	66 89 82 fa 1f 00 00 	mov    %ax,0x1ffa(%edx)
	SETGATE(idt[6], 0, GD_KT, th6, 0);
  400b13:	c7 c0 62 11 40 00    	mov    $0x401162,%eax
  400b19:	66 89 82 fc 1f 00 00 	mov    %ax,0x1ffc(%edx)
  400b20:	66 c7 82 fe 1f 00 00 	movw   $0x8,0x1ffe(%edx)
  400b27:	08 00 
  400b29:	c6 82 00 20 00 00 00 	movb   $0x0,0x2000(%edx)
  400b30:	c6 82 01 20 00 00 8e 	movb   $0x8e,0x2001(%edx)
  400b37:	c1 e8 10             	shr    $0x10,%eax
  400b3a:	66 89 82 02 20 00 00 	mov    %ax,0x2002(%edx)
	SETGATE(idt[7], 0, GD_KT, th7, 0);
  400b41:	c7 c0 66 11 40 00    	mov    $0x401166,%eax
  400b47:	66 89 82 04 20 00 00 	mov    %ax,0x2004(%edx)
  400b4e:	66 c7 82 06 20 00 00 	movw   $0x8,0x2006(%edx)
  400b55:	08 00 
  400b57:	c6 82 08 20 00 00 00 	movb   $0x0,0x2008(%edx)
  400b5e:	c6 82 09 20 00 00 8e 	movb   $0x8e,0x2009(%edx)
  400b65:	c1 e8 10             	shr    $0x10,%eax
  400b68:	66 89 82 0a 20 00 00 	mov    %ax,0x200a(%edx)
	SETGATE(idt[8], 0, GD_KT, th8, 0);
  400b6f:	c7 c0 6a 11 40 00    	mov    $0x40116a,%eax
  400b75:	66 89 82 0c 20 00 00 	mov    %ax,0x200c(%edx)
  400b7c:	66 c7 82 0e 20 00 00 	movw   $0x8,0x200e(%edx)
  400b83:	08 00 
  400b85:	c6 82 10 20 00 00 00 	movb   $0x0,0x2010(%edx)
  400b8c:	c6 82 11 20 00 00 8e 	movb   $0x8e,0x2011(%edx)
  400b93:	c1 e8 10             	shr    $0x10,%eax
  400b96:	66 89 82 12 20 00 00 	mov    %ax,0x2012(%edx)
	SETGATE(idt[10], 0, GD_KT, th10, 0);
  400b9d:	c7 c0 6e 11 40 00    	mov    $0x40116e,%eax
  400ba3:	66 89 82 1c 20 00 00 	mov    %ax,0x201c(%edx)
  400baa:	66 c7 82 1e 20 00 00 	movw   $0x8,0x201e(%edx)
  400bb1:	08 00 
  400bb3:	c6 82 20 20 00 00 00 	movb   $0x0,0x2020(%edx)
  400bba:	c6 82 21 20 00 00 8e 	movb   $0x8e,0x2021(%edx)
  400bc1:	c1 e8 10             	shr    $0x10,%eax
  400bc4:	66 89 82 22 20 00 00 	mov    %ax,0x2022(%edx)
	SETGATE(idt[11], 0, GD_KT, th11, 0);
  400bcb:	c7 c0 72 11 40 00    	mov    $0x401172,%eax
  400bd1:	66 89 82 24 20 00 00 	mov    %ax,0x2024(%edx)
  400bd8:	66 c7 82 26 20 00 00 	movw   $0x8,0x2026(%edx)
  400bdf:	08 00 
  400be1:	c6 82 28 20 00 00 00 	movb   $0x0,0x2028(%edx)
  400be8:	c6 82 29 20 00 00 8e 	movb   $0x8e,0x2029(%edx)
  400bef:	c1 e8 10             	shr    $0x10,%eax
  400bf2:	66 89 82 2a 20 00 00 	mov    %ax,0x202a(%edx)
	SETGATE(idt[12], 0, GD_KT, th12, 0);
  400bf9:	c7 c0 76 11 40 00    	mov    $0x401176,%eax
  400bff:	66 89 82 2c 20 00 00 	mov    %ax,0x202c(%edx)
  400c06:	66 c7 82 2e 20 00 00 	movw   $0x8,0x202e(%edx)
  400c0d:	08 00 
  400c0f:	c6 82 30 20 00 00 00 	movb   $0x0,0x2030(%edx)
  400c16:	c6 82 31 20 00 00 8e 	movb   $0x8e,0x2031(%edx)
  400c1d:	c1 e8 10             	shr    $0x10,%eax
  400c20:	66 89 82 32 20 00 00 	mov    %ax,0x2032(%edx)
	SETGATE(idt[13], 0, GD_KT, th13, 0);
  400c27:	c7 c0 7a 11 40 00    	mov    $0x40117a,%eax
  400c2d:	66 89 82 34 20 00 00 	mov    %ax,0x2034(%edx)
  400c34:	66 c7 82 36 20 00 00 	movw   $0x8,0x2036(%edx)
  400c3b:	08 00 
  400c3d:	c6 82 38 20 00 00 00 	movb   $0x0,0x2038(%edx)
  400c44:	c6 82 39 20 00 00 8e 	movb   $0x8e,0x2039(%edx)
  400c4b:	c1 e8 10             	shr    $0x10,%eax
  400c4e:	66 89 82 3a 20 00 00 	mov    %ax,0x203a(%edx)
	SETGATE(idt[14], 0, GD_KT, th14, 0);
  400c55:	c7 c0 7e 11 40 00    	mov    $0x40117e,%eax
  400c5b:	66 89 82 3c 20 00 00 	mov    %ax,0x203c(%edx)
  400c62:	66 c7 82 3e 20 00 00 	movw   $0x8,0x203e(%edx)
  400c69:	08 00 
  400c6b:	c6 82 40 20 00 00 00 	movb   $0x0,0x2040(%edx)
  400c72:	c6 82 41 20 00 00 8e 	movb   $0x8e,0x2041(%edx)
  400c79:	c1 e8 10             	shr    $0x10,%eax
  400c7c:	66 89 82 42 20 00 00 	mov    %ax,0x2042(%edx)
	SETGATE(idt[16], 0, GD_KT, th16, 0);
  400c83:	c7 c0 82 11 40 00    	mov    $0x401182,%eax
  400c89:	66 89 82 4c 20 00 00 	mov    %ax,0x204c(%edx)
  400c90:	66 c7 82 4e 20 00 00 	movw   $0x8,0x204e(%edx)
  400c97:	08 00 
  400c99:	c6 82 50 20 00 00 00 	movb   $0x0,0x2050(%edx)
  400ca0:	c6 82 51 20 00 00 8e 	movb   $0x8e,0x2051(%edx)
  400ca7:	c1 e8 10             	shr    $0x10,%eax
  400caa:	66 89 82 52 20 00 00 	mov    %ax,0x2052(%edx)
	SETGATE(idt[17], 0, GD_KT, th17, 0);
  400cb1:	c7 c0 86 11 40 00    	mov    $0x401186,%eax
  400cb7:	66 89 82 54 20 00 00 	mov    %ax,0x2054(%edx)
  400cbe:	66 c7 82 56 20 00 00 	movw   $0x8,0x2056(%edx)
  400cc5:	08 00 
  400cc7:	c6 82 58 20 00 00 00 	movb   $0x0,0x2058(%edx)
  400cce:	c6 82 59 20 00 00 8e 	movb   $0x8e,0x2059(%edx)
  400cd5:	c1 e8 10             	shr    $0x10,%eax
  400cd8:	66 89 82 5a 20 00 00 	mov    %ax,0x205a(%edx)
	SETGATE(idt[18], 0, GD_KT, th18, 0);
  400cdf:	c7 c0 8a 11 40 00    	mov    $0x40118a,%eax
  400ce5:	66 89 82 5c 20 00 00 	mov    %ax,0x205c(%edx)
  400cec:	66 c7 82 5e 20 00 00 	movw   $0x8,0x205e(%edx)
  400cf3:	08 00 
  400cf5:	c6 82 60 20 00 00 00 	movb   $0x0,0x2060(%edx)
  400cfc:	c6 82 61 20 00 00 8e 	movb   $0x8e,0x2061(%edx)
  400d03:	c1 e8 10             	shr    $0x10,%eax
  400d06:	66 89 82 62 20 00 00 	mov    %ax,0x2062(%edx)
	SETGATE(idt[19], 0, GD_KT, th19, 0);
  400d0d:	c7 c0 8e 11 40 00    	mov    $0x40118e,%eax
  400d13:	66 89 82 64 20 00 00 	mov    %ax,0x2064(%edx)
  400d1a:	66 c7 82 66 20 00 00 	movw   $0x8,0x2066(%edx)
  400d21:	08 00 
  400d23:	c6 82 68 20 00 00 00 	movb   $0x0,0x2068(%edx)
  400d2a:	c6 82 69 20 00 00 8e 	movb   $0x8e,0x2069(%edx)
  400d31:	c1 e8 10             	shr    $0x10,%eax
  400d34:	66 89 82 6a 20 00 00 	mov    %ax,0x206a(%edx)
	SETGATE(idt[48], 0, GD_KT, th48, 3);
  400d3b:	c7 c0 92 11 40 00    	mov    $0x401192,%eax
  400d41:	66 89 82 4c 21 00 00 	mov    %ax,0x214c(%edx)
  400d48:	66 c7 82 4e 21 00 00 	movw   $0x8,0x214e(%edx)
  400d4f:	08 00 
  400d51:	c6 82 50 21 00 00 00 	movb   $0x0,0x2150(%edx)
  400d58:	c6 82 51 21 00 00 ee 	movb   $0xee,0x2151(%edx)
  400d5f:	c1 e8 10             	shr    $0x10,%eax
  400d62:	66 89 82 52 21 00 00 	mov    %ax,0x2152(%edx)
	trap_init_percpu();
  400d69:	e8 9b fb ff ff       	call   400909 <trap_init_percpu>
}
  400d6e:	5b                   	pop    %ebx
  400d6f:	5e                   	pop    %esi
  400d70:	5d                   	pop    %ebp
  400d71:	c3                   	ret    

00400d72 <print_regs>:
	}
}

void
print_regs(struct PushRegs *regs)
{
  400d72:	55                   	push   %ebp
  400d73:	89 e5                	mov    %esp,%ebp
  400d75:	56                   	push   %esi
  400d76:	53                   	push   %ebx
  400d77:	e8 e1 f4 ff ff       	call   40025d <__x86.get_pc_thunk.bx>
  400d7c:	81 c3 b8 45 01 00    	add    $0x145b8,%ebx
  400d82:	8b 75 08             	mov    0x8(%ebp),%esi
	cprintf("  edi  0x%08x\n", regs->reg_edi);
  400d85:	83 ec 08             	sub    $0x8,%esp
  400d88:	ff 36                	pushl  (%esi)
  400d8a:	8d 83 63 d0 fe ff    	lea    -0x12f9d(%ebx),%eax
  400d90:	50                   	push   %eax
  400d91:	e8 5f fb ff ff       	call   4008f5 <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
  400d96:	83 c4 08             	add    $0x8,%esp
  400d99:	ff 76 04             	pushl  0x4(%esi)
  400d9c:	8d 83 72 d0 fe ff    	lea    -0x12f8e(%ebx),%eax
  400da2:	50                   	push   %eax
  400da3:	e8 4d fb ff ff       	call   4008f5 <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  400da8:	83 c4 08             	add    $0x8,%esp
  400dab:	ff 76 08             	pushl  0x8(%esi)
  400dae:	8d 83 81 d0 fe ff    	lea    -0x12f7f(%ebx),%eax
  400db4:	50                   	push   %eax
  400db5:	e8 3b fb ff ff       	call   4008f5 <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  400dba:	83 c4 08             	add    $0x8,%esp
  400dbd:	ff 76 0c             	pushl  0xc(%esi)
  400dc0:	8d 83 90 d0 fe ff    	lea    -0x12f70(%ebx),%eax
  400dc6:	50                   	push   %eax
  400dc7:	e8 29 fb ff ff       	call   4008f5 <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  400dcc:	83 c4 08             	add    $0x8,%esp
  400dcf:	ff 76 10             	pushl  0x10(%esi)
  400dd2:	8d 83 9f d0 fe ff    	lea    -0x12f61(%ebx),%eax
  400dd8:	50                   	push   %eax
  400dd9:	e8 17 fb ff ff       	call   4008f5 <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
  400dde:	83 c4 08             	add    $0x8,%esp
  400de1:	ff 76 14             	pushl  0x14(%esi)
  400de4:	8d 83 ae d0 fe ff    	lea    -0x12f52(%ebx),%eax
  400dea:	50                   	push   %eax
  400deb:	e8 05 fb ff ff       	call   4008f5 <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  400df0:	83 c4 08             	add    $0x8,%esp
  400df3:	ff 76 18             	pushl  0x18(%esi)
  400df6:	8d 83 bd d0 fe ff    	lea    -0x12f43(%ebx),%eax
  400dfc:	50                   	push   %eax
  400dfd:	e8 f3 fa ff ff       	call   4008f5 <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
  400e02:	83 c4 08             	add    $0x8,%esp
  400e05:	ff 76 1c             	pushl  0x1c(%esi)
  400e08:	8d 83 cc d0 fe ff    	lea    -0x12f34(%ebx),%eax
  400e0e:	50                   	push   %eax
  400e0f:	e8 e1 fa ff ff       	call   4008f5 <cprintf>
}
  400e14:	83 c4 10             	add    $0x10,%esp
  400e17:	8d 65 f8             	lea    -0x8(%ebp),%esp
  400e1a:	5b                   	pop    %ebx
  400e1b:	5e                   	pop    %esi
  400e1c:	5d                   	pop    %ebp
  400e1d:	c3                   	ret    

00400e1e <print_trapframe>:
{
  400e1e:	55                   	push   %ebp
  400e1f:	89 e5                	mov    %esp,%ebp
  400e21:	57                   	push   %edi
  400e22:	56                   	push   %esi
  400e23:	53                   	push   %ebx
  400e24:	83 ec 14             	sub    $0x14,%esp
  400e27:	e8 31 f4 ff ff       	call   40025d <__x86.get_pc_thunk.bx>
  400e2c:	81 c3 08 45 01 00    	add    $0x14508,%ebx
  400e32:	8b 75 08             	mov    0x8(%ebp),%esi
	cprintf("TRAP frame at %p\n", tf);
  400e35:	56                   	push   %esi
  400e36:	8d 83 54 d2 fe ff    	lea    -0x12dac(%ebx),%eax
  400e3c:	50                   	push   %eax
  400e3d:	e8 b3 fa ff ff       	call   4008f5 <cprintf>
	print_regs(&tf->tf_regs);
  400e42:	89 34 24             	mov    %esi,(%esp)
  400e45:	e8 28 ff ff ff       	call   400d72 <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
  400e4a:	83 c4 08             	add    $0x8,%esp
  400e4d:	0f b7 46 20          	movzwl 0x20(%esi),%eax
  400e51:	50                   	push   %eax
  400e52:	8d 83 1d d1 fe ff    	lea    -0x12ee3(%ebx),%eax
  400e58:	50                   	push   %eax
  400e59:	e8 97 fa ff ff       	call   4008f5 <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
  400e5e:	83 c4 08             	add    $0x8,%esp
  400e61:	0f b7 46 24          	movzwl 0x24(%esi),%eax
  400e65:	50                   	push   %eax
  400e66:	8d 83 30 d1 fe ff    	lea    -0x12ed0(%ebx),%eax
  400e6c:	50                   	push   %eax
  400e6d:	e8 83 fa ff ff       	call   4008f5 <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  400e72:	8b 56 28             	mov    0x28(%esi),%edx
	if (trapno < ARRAY_SIZE(excnames))
  400e75:	83 c4 10             	add    $0x10,%esp
  400e78:	83 fa 13             	cmp    $0x13,%edx
  400e7b:	0f 86 e9 00 00 00    	jbe    400f6a <print_trapframe+0x14c>
	return "(unknown trap)";
  400e81:	83 fa 30             	cmp    $0x30,%edx
  400e84:	8d 83 db d0 fe ff    	lea    -0x12f25(%ebx),%eax
  400e8a:	8d 8b e7 d0 fe ff    	lea    -0x12f19(%ebx),%ecx
  400e90:	0f 45 c1             	cmovne %ecx,%eax
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  400e93:	83 ec 04             	sub    $0x4,%esp
  400e96:	50                   	push   %eax
  400e97:	52                   	push   %edx
  400e98:	8d 83 43 d1 fe ff    	lea    -0x12ebd(%ebx),%eax
  400e9e:	50                   	push   %eax
  400e9f:	e8 51 fa ff ff       	call   4008f5 <cprintf>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
  400ea4:	83 c4 10             	add    $0x10,%esp
  400ea7:	39 b3 cc 27 00 00    	cmp    %esi,0x27cc(%ebx)
  400ead:	0f 84 c3 00 00 00    	je     400f76 <print_trapframe+0x158>
	cprintf("  err  0x%08x", tf->tf_err);
  400eb3:	83 ec 08             	sub    $0x8,%esp
  400eb6:	ff 76 2c             	pushl  0x2c(%esi)
  400eb9:	8d 83 64 d1 fe ff    	lea    -0x12e9c(%ebx),%eax
  400ebf:	50                   	push   %eax
  400ec0:	e8 30 fa ff ff       	call   4008f5 <cprintf>
	if (tf->tf_trapno == T_PGFLT)
  400ec5:	83 c4 10             	add    $0x10,%esp
  400ec8:	83 7e 28 0e          	cmpl   $0xe,0x28(%esi)
  400ecc:	0f 85 c9 00 00 00    	jne    400f9b <print_trapframe+0x17d>
			tf->tf_err & 1 ? "protection" : "not-present");
  400ed2:	8b 46 2c             	mov    0x2c(%esi),%eax
		cprintf(" [%s, %s, %s]\n",
  400ed5:	89 c2                	mov    %eax,%edx
  400ed7:	83 e2 01             	and    $0x1,%edx
  400eda:	8d 8b f6 d0 fe ff    	lea    -0x12f0a(%ebx),%ecx
  400ee0:	8d 93 01 d1 fe ff    	lea    -0x12eff(%ebx),%edx
  400ee6:	0f 44 ca             	cmove  %edx,%ecx
  400ee9:	89 c2                	mov    %eax,%edx
  400eeb:	83 e2 02             	and    $0x2,%edx
  400eee:	8d 93 0d d1 fe ff    	lea    -0x12ef3(%ebx),%edx
  400ef4:	8d bb 13 d1 fe ff    	lea    -0x12eed(%ebx),%edi
  400efa:	0f 44 d7             	cmove  %edi,%edx
  400efd:	83 e0 04             	and    $0x4,%eax
  400f00:	8d 83 18 d1 fe ff    	lea    -0x12ee8(%ebx),%eax
  400f06:	8d bb 78 d2 fe ff    	lea    -0x12d88(%ebx),%edi
  400f0c:	0f 44 c7             	cmove  %edi,%eax
  400f0f:	51                   	push   %ecx
  400f10:	52                   	push   %edx
  400f11:	50                   	push   %eax
  400f12:	8d 83 72 d1 fe ff    	lea    -0x12e8e(%ebx),%eax
  400f18:	50                   	push   %eax
  400f19:	e8 d7 f9 ff ff       	call   4008f5 <cprintf>
  400f1e:	83 c4 10             	add    $0x10,%esp
	cprintf("  eip  0x%08x\n", tf->tf_eip);
  400f21:	83 ec 08             	sub    $0x8,%esp
  400f24:	ff 76 30             	pushl  0x30(%esi)
  400f27:	8d 83 81 d1 fe ff    	lea    -0x12e7f(%ebx),%eax
  400f2d:	50                   	push   %eax
  400f2e:	e8 c2 f9 ff ff       	call   4008f5 <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
  400f33:	83 c4 08             	add    $0x8,%esp
  400f36:	0f b7 46 34          	movzwl 0x34(%esi),%eax
  400f3a:	50                   	push   %eax
  400f3b:	8d 83 90 d1 fe ff    	lea    -0x12e70(%ebx),%eax
  400f41:	50                   	push   %eax
  400f42:	e8 ae f9 ff ff       	call   4008f5 <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
  400f47:	83 c4 08             	add    $0x8,%esp
  400f4a:	ff 76 38             	pushl  0x38(%esi)
  400f4d:	8d 83 a3 d1 fe ff    	lea    -0x12e5d(%ebx),%eax
  400f53:	50                   	push   %eax
  400f54:	e8 9c f9 ff ff       	call   4008f5 <cprintf>
	if ((tf->tf_cs & 3) != 0) {
  400f59:	83 c4 10             	add    $0x10,%esp
  400f5c:	f6 46 34 03          	testb  $0x3,0x34(%esi)
  400f60:	75 50                	jne    400fb2 <print_trapframe+0x194>
}
  400f62:	8d 65 f4             	lea    -0xc(%ebp),%esp
  400f65:	5b                   	pop    %ebx
  400f66:	5e                   	pop    %esi
  400f67:	5f                   	pop    %edi
  400f68:	5d                   	pop    %ebp
  400f69:	c3                   	ret    
		return excnames[trapno];
  400f6a:	8b 84 93 0c 1d 00 00 	mov    0x1d0c(%ebx,%edx,4),%eax
  400f71:	e9 1d ff ff ff       	jmp    400e93 <print_trapframe+0x75>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
  400f76:	83 7e 28 0e          	cmpl   $0xe,0x28(%esi)
  400f7a:	0f 85 33 ff ff ff    	jne    400eb3 <print_trapframe+0x95>

static inline uint32_t
rcr2(void)
{
	uint32_t val;
	asm volatile("movl %%cr2,%0" : "=r" (val));
  400f80:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
  400f83:	83 ec 08             	sub    $0x8,%esp
  400f86:	50                   	push   %eax
  400f87:	8d 83 55 d1 fe ff    	lea    -0x12eab(%ebx),%eax
  400f8d:	50                   	push   %eax
  400f8e:	e8 62 f9 ff ff       	call   4008f5 <cprintf>
  400f93:	83 c4 10             	add    $0x10,%esp
  400f96:	e9 18 ff ff ff       	jmp    400eb3 <print_trapframe+0x95>
		cprintf("\n");
  400f9b:	83 ec 0c             	sub    $0xc,%esp
  400f9e:	8d 83 af cd fe ff    	lea    -0x13251(%ebx),%eax
  400fa4:	50                   	push   %eax
  400fa5:	e8 4b f9 ff ff       	call   4008f5 <cprintf>
  400faa:	83 c4 10             	add    $0x10,%esp
  400fad:	e9 6f ff ff ff       	jmp    400f21 <print_trapframe+0x103>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
  400fb2:	83 ec 08             	sub    $0x8,%esp
  400fb5:	ff 76 3c             	pushl  0x3c(%esi)
  400fb8:	8d 83 b2 d1 fe ff    	lea    -0x12e4e(%ebx),%eax
  400fbe:	50                   	push   %eax
  400fbf:	e8 31 f9 ff ff       	call   4008f5 <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
  400fc4:	83 c4 08             	add    $0x8,%esp
  400fc7:	0f b7 46 40          	movzwl 0x40(%esi),%eax
  400fcb:	50                   	push   %eax
  400fcc:	8d 83 c1 d1 fe ff    	lea    -0x12e3f(%ebx),%eax
  400fd2:	50                   	push   %eax
  400fd3:	e8 1d f9 ff ff       	call   4008f5 <cprintf>
  400fd8:	83 c4 10             	add    $0x10,%esp
}
  400fdb:	eb 85                	jmp    400f62 <print_trapframe+0x144>

00400fdd <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
  400fdd:	55                   	push   %ebp
  400fde:	89 e5                	mov    %esp,%ebp
  400fe0:	56                   	push   %esi
  400fe1:	53                   	push   %ebx
  400fe2:	e8 76 f2 ff ff       	call   40025d <__x86.get_pc_thunk.bx>
  400fe7:	81 c3 4d 43 01 00    	add    $0x1434d,%ebx
  400fed:	8b 75 08             	mov    0x8(%ebp),%esi
  400ff0:	0f 20 d0             	mov    %cr2,%eax

	// We've already handled kernel-mode exceptions, so if we get here,
	// the page fault happened in user mode.

	// Destroy the environment that caused the fault.
	cprintf("user fault va %08x ip %08x\n",
  400ff3:	83 ec 04             	sub    $0x4,%esp
  400ff6:	ff 76 30             	pushl  0x30(%esi)
  400ff9:	50                   	push   %eax
  400ffa:	8d 83 d4 d1 fe ff    	lea    -0x12e2c(%ebx),%eax
  401000:	50                   	push   %eax
  401001:	e8 ef f8 ff ff       	call   4008f5 <cprintf>
		fault_va, tf->tf_eip);
	print_trapframe(tf);
  401006:	89 34 24             	mov    %esi,(%esp)
  401009:	e8 10 fe ff ff       	call   400e1e <print_trapframe>
	cprintf(PAGE_FAULT);
  40100e:	8d 83 f0 d1 fe ff    	lea    -0x12e10(%ebx),%eax
  401014:	89 04 24             	mov    %eax,(%esp)
  401017:	e8 d9 f8 ff ff       	call   4008f5 <cprintf>
	panic("unhanlded page fault");
  40101c:	83 c4 0c             	add    $0xc,%esp
  40101f:	8d 83 fc d1 fe ff    	lea    -0x12e04(%ebx),%eax
  401025:	50                   	push   %eax
  401026:	68 1e 01 00 00       	push   $0x11e
  40102b:	8d 83 11 d2 fe ff    	lea    -0x12def(%ebx),%eax
  401031:	50                   	push   %eax
  401032:	e8 09 f0 ff ff       	call   400040 <_panic>

00401037 <trap>:
{
  401037:	55                   	push   %ebp
  401038:	89 e5                	mov    %esp,%ebp
  40103a:	57                   	push   %edi
  40103b:	56                   	push   %esi
  40103c:	53                   	push   %ebx
  40103d:	83 ec 0c             	sub    $0xc,%esp
  401040:	e8 18 f2 ff ff       	call   40025d <__x86.get_pc_thunk.bx>
  401045:	81 c3 ef 42 01 00    	add    $0x142ef,%ebx
  40104b:	8b 75 08             	mov    0x8(%ebp),%esi
	asm volatile("cld" ::: "cc");
  40104e:	fc                   	cld    

static inline uint32_t
read_eflags(void)
{
	uint32_t eflags;
	asm volatile("pushfl; popl %0" : "=r" (eflags));
  40104f:	9c                   	pushf  
  401050:	58                   	pop    %eax
	assert(!(read_eflags() & FL_IF));
  401051:	f6 c4 02             	test   $0x2,%ah
  401054:	74 1f                	je     401075 <trap+0x3e>
  401056:	8d 83 1d d2 fe ff    	lea    -0x12de3(%ebx),%eax
  40105c:	50                   	push   %eax
  40105d:	8d 83 36 d2 fe ff    	lea    -0x12dca(%ebx),%eax
  401063:	50                   	push   %eax
  401064:	68 f1 00 00 00       	push   $0xf1
  401069:	8d 83 11 d2 fe ff    	lea    -0x12def(%ebx),%eax
  40106f:	50                   	push   %eax
  401070:	e8 cb ef ff ff       	call   400040 <_panic>
	cprintf("Incoming TRAP frame at %p\n", tf);
  401075:	83 ec 08             	sub    $0x8,%esp
  401078:	56                   	push   %esi
  401079:	8d 83 4b d2 fe ff    	lea    -0x12db5(%ebx),%eax
  40107f:	50                   	push   %eax
  401080:	e8 70 f8 ff ff       	call   4008f5 <cprintf>
	if ((tf->tf_cs & 3) == 3) {
  401085:	0f b7 46 34          	movzwl 0x34(%esi),%eax
  401089:	83 e0 03             	and    $0x3,%eax
  40108c:	83 c4 10             	add    $0x10,%esp
  40108f:	66 83 f8 03          	cmp    $0x3,%ax
  401093:	74 41                	je     4010d6 <trap+0x9f>
	last_tf = tf;
  401095:	89 b3 cc 27 00 00    	mov    %esi,0x27cc(%ebx)
	switch(tf->tf_trapno) {
  40109b:	8b 46 28             	mov    0x28(%esi),%eax
  40109e:	83 f8 0e             	cmp    $0xe,%eax
  4010a1:	74 46                	je     4010e9 <trap+0xb2>
  4010a3:	83 f8 30             	cmp    $0x30,%eax
  4010a6:	74 4a                	je     4010f2 <trap+0xbb>
	print_trapframe(tf);
  4010a8:	83 ec 0c             	sub    $0xc,%esp
  4010ab:	56                   	push   %esi
  4010ac:	e8 6d fd ff ff       	call   400e1e <print_trapframe>
	if (tf->tf_cs == GD_KT)
  4010b1:	83 c4 10             	add    $0x10,%esp
  4010b4:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
  4010b9:	74 64                	je     40111f <trap+0xe8>
		panic("unhandled trap in user code");
  4010bb:	83 ec 04             	sub    $0x4,%esp
  4010be:	8d 83 7f d2 fe ff    	lea    -0x12d81(%ebx),%eax
  4010c4:	50                   	push   %eax
  4010c5:	68 e3 00 00 00       	push   $0xe3
  4010ca:	8d 83 11 d2 fe ff    	lea    -0x12def(%ebx),%eax
  4010d0:	50                   	push   %eax
  4010d1:	e8 6a ef ff ff       	call   400040 <_panic>
		env_tf = *tf;
  4010d6:	c7 c0 e0 7d 43 00    	mov    $0x437de0,%eax
  4010dc:	b9 11 00 00 00       	mov    $0x11,%ecx
  4010e1:	89 c7                	mov    %eax,%edi
  4010e3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		tf = &env_tf;
  4010e5:	89 c6                	mov    %eax,%esi
  4010e7:	eb ac                	jmp    401095 <trap+0x5e>
		page_fault_handler(tf);
  4010e9:	83 ec 0c             	sub    $0xc,%esp
  4010ec:	56                   	push   %esi
  4010ed:	e8 eb fe ff ff       	call   400fdd <page_fault_handler>
		tf->tf_regs.reg_eax = syscall(tf->tf_regs.reg_eax,
  4010f2:	83 ec 08             	sub    $0x8,%esp
  4010f5:	ff 76 04             	pushl  0x4(%esi)
  4010f8:	ff 36                	pushl  (%esi)
  4010fa:	ff 76 10             	pushl  0x10(%esi)
  4010fd:	ff 76 18             	pushl  0x18(%esi)
  401100:	ff 76 14             	pushl  0x14(%esi)
  401103:	ff 76 1c             	pushl  0x1c(%esi)
  401106:	e8 9c 00 00 00       	call   4011a7 <syscall>
  40110b:	89 46 1c             	mov    %eax,0x1c(%esi)
		if(tf->tf_regs.reg_eax != -E_INVAL) {
  40110e:	83 c4 20             	add    $0x20,%esp
  401111:	83 f8 fd             	cmp    $0xfffffffd,%eax
  401114:	74 92                	je     4010a8 <trap+0x71>
	run_trapframe(tf);
  401116:	83 ec 0c             	sub    $0xc,%esp
  401119:	56                   	push   %esi
  40111a:	e8 4c f7 ff ff       	call   40086b <run_trapframe>
		panic("unhandled trap in kernel");
  40111f:	83 ec 04             	sub    $0x4,%esp
  401122:	8d 83 66 d2 fe ff    	lea    -0x12d9a(%ebx),%eax
  401128:	50                   	push   %eax
  401129:	68 e1 00 00 00       	push   $0xe1
  40112e:	8d 83 11 d2 fe ff    	lea    -0x12def(%ebx),%eax
  401134:	50                   	push   %eax
  401135:	e8 06 ef ff ff       	call   400040 <_panic>

0040113a <__x86.get_pc_thunk.dx>:
  40113a:	8b 14 24             	mov    (%esp),%edx
  40113d:	c3                   	ret    

0040113e <unktraphandler>:

.globl unktraphandler;
.type unktraphandler, @function;
	.align 2;		
unktraphandler:			
	pushl $0;
  40113e:	6a 00                	push   $0x0
	pushl $9;
  401140:	6a 09                	push   $0x9
	jmp _alltraps;
  401142:	eb 54                	jmp    401198 <_alltraps>

00401144 <th0>:
	TRAPHANDLER(div0handler, T_DEBUG)	
	TRAPHANDLER(nmihandler, T_NMI)
	TRAPHANDLER(nmihandler, T_NMI)
	TRAPHANDLER(syscallhandler, T_SYSCALL) */

	TRAPHANDLER_NOEC(th0, 0)
  401144:	6a 00                	push   $0x0
  401146:	6a 00                	push   $0x0
  401148:	eb 4e                	jmp    401198 <_alltraps>

0040114a <th1>:
	TRAPHANDLER_NOEC(th1, 1)
  40114a:	6a 00                	push   $0x0
  40114c:	6a 01                	push   $0x1
  40114e:	eb 48                	jmp    401198 <_alltraps>

00401150 <th2>:
	TRAPHANDLER(th2, 2)
  401150:	6a 02                	push   $0x2
  401152:	eb 44                	jmp    401198 <_alltraps>

00401154 <th3>:
	TRAPHANDLER_NOEC(th3, 3)
  401154:	6a 00                	push   $0x0
  401156:	6a 03                	push   $0x3
  401158:	eb 3e                	jmp    401198 <_alltraps>

0040115a <th4>:
	TRAPHANDLER(th4, 4)
  40115a:	6a 04                	push   $0x4
  40115c:	eb 3a                	jmp    401198 <_alltraps>

0040115e <th5>:
	TRAPHANDLER(th5, 5)
  40115e:	6a 05                	push   $0x5
  401160:	eb 36                	jmp    401198 <_alltraps>

00401162 <th6>:
	TRAPHANDLER(th6, 6)
  401162:	6a 06                	push   $0x6
  401164:	eb 32                	jmp    401198 <_alltraps>

00401166 <th7>:
	TRAPHANDLER(th7, 7)
  401166:	6a 07                	push   $0x7
  401168:	eb 2e                	jmp    401198 <_alltraps>

0040116a <th8>:
	TRAPHANDLER(th8, 8)
  40116a:	6a 08                	push   $0x8
  40116c:	eb 2a                	jmp    401198 <_alltraps>

0040116e <th10>:
	//TRAPHANDLER(th9, 9)
	TRAPHANDLER(th10, 10)
  40116e:	6a 0a                	push   $0xa
  401170:	eb 26                	jmp    401198 <_alltraps>

00401172 <th11>:
	TRAPHANDLER(th11, 11)
  401172:	6a 0b                	push   $0xb
  401174:	eb 22                	jmp    401198 <_alltraps>

00401176 <th12>:
	TRAPHANDLER(th12, 12)
  401176:	6a 0c                	push   $0xc
  401178:	eb 1e                	jmp    401198 <_alltraps>

0040117a <th13>:
	TRAPHANDLER(th13, 13)
  40117a:	6a 0d                	push   $0xd
  40117c:	eb 1a                	jmp    401198 <_alltraps>

0040117e <th14>:
	TRAPHANDLER(th14, 14)
  40117e:	6a 0e                	push   $0xe
  401180:	eb 16                	jmp    401198 <_alltraps>

00401182 <th16>:
	//TRAPHANDLER(th15, 15)
	TRAPHANDLER(th16, 16)
  401182:	6a 10                	push   $0x10
  401184:	eb 12                	jmp    401198 <_alltraps>

00401186 <th17>:
	TRAPHANDLER(th17, 17)
  401186:	6a 11                	push   $0x11
  401188:	eb 0e                	jmp    401198 <_alltraps>

0040118a <th18>:
	TRAPHANDLER(th18, 18)
  40118a:	6a 12                	push   $0x12
  40118c:	eb 0a                	jmp    401198 <_alltraps>

0040118e <th19>:
	TRAPHANDLER(th19, 19)
  40118e:	6a 13                	push   $0x13
  401190:	eb 06                	jmp    401198 <_alltraps>

00401192 <th48>:
	TRAPHANDLER_NOEC(th48, 48)
  401192:	6a 00                	push   $0x0
  401194:	6a 30                	push   $0x30
  401196:	eb 00                	jmp    401198 <_alltraps>

00401198 <_alltraps>:
 * Lab 3: Your code here for _alltraps
 */


_alltraps:
	pushl %ds;
  401198:	1e                   	push   %ds
	pushl %es;
  401199:	06                   	push   %es
	pushal;
  40119a:	60                   	pusha  
	pushl $GD_KD;
  40119b:	6a 10                	push   $0x10
	popl %ds;
  40119d:	1f                   	pop    %ds
	pushl $GD_KD;
  40119e:	6a 10                	push   $0x10
	popl %es;
  4011a0:	07                   	pop    %es
	pushl %esp;
  4011a1:	54                   	push   %esp
	call trap;
  4011a2:	e8 90 fe ff ff       	call   401037 <trap>

004011a7 <syscall>:
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  4011a7:	55                   	push   %ebp
  4011a8:	89 e5                	mov    %esp,%ebp
  4011aa:	53                   	push   %ebx
  4011ab:	83 ec 04             	sub    $0x4,%esp
  4011ae:	e8 aa f0 ff ff       	call   40025d <__x86.get_pc_thunk.bx>
  4011b3:	81 c3 81 41 01 00    	add    $0x14181,%ebx
  4011b9:	8b 45 08             	mov    0x8(%ebp),%eax
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.
	
	switch (syscallno) {
  4011bc:	83 f8 03             	cmp    $0x3,%eax
  4011bf:	74 3b                	je     4011fc <syscall+0x55>
  4011c1:	83 f8 04             	cmp    $0x4,%eax
  4011c4:	74 58                	je     40121e <syscall+0x77>
  4011c6:	85 c0                	test   %eax,%eax
  4011c8:	74 1a                	je     4011e4 <syscall+0x3d>
	case SYS_test:
		sys_test();
		return 0;

	}
	cprintf("Kernel got unexpected system call %d\n", syscallno);
  4011ca:	83 ec 08             	sub    $0x8,%esp
  4011cd:	50                   	push   %eax
  4011ce:	8d 83 8c d4 fe ff    	lea    -0x12b74(%ebx),%eax
  4011d4:	50                   	push   %eax
  4011d5:	e8 1b f7 ff ff       	call   4008f5 <cprintf>
	return -E_INVAL;
  4011da:	83 c4 10             	add    $0x10,%esp
  4011dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  4011e2:	eb 51                	jmp    401235 <syscall+0x8e>
		panic("Should not access this memory");
  4011e4:	83 ec 04             	sub    $0x4,%esp
  4011e7:	8d 83 de d3 fe ff    	lea    -0x12c22(%ebx),%eax
  4011ed:	50                   	push   %eax
  4011ee:	6a 22                	push   $0x22
  4011f0:	8d 83 fc d3 fe ff    	lea    -0x12c04(%ebx),%eax
  4011f6:	50                   	push   %eax
  4011f7:	e8 44 ee ff ff       	call   400040 <_panic>
	cprintf("program quit.  OS gracefully infinite looping...\n");
  4011fc:	83 ec 0c             	sub    $0xc,%esp
  4011ff:	8d 83 20 d4 fe ff    	lea    -0x12be0(%ebx),%eax
  401205:	50                   	push   %eax
  401206:	e8 ea f6 ff ff       	call   4008f5 <cprintf>
	cprintf("If you prefer, you could call shutdown to quit qemu...\n");
  40120b:	8d 83 54 d4 fe ff    	lea    -0x12bac(%ebx),%eax
  401211:	89 04 24             	mov    %eax,(%esp)
  401214:	e8 dc f6 ff ff       	call   4008f5 <cprintf>
  401219:	83 c4 10             	add    $0x10,%esp
  40121c:	eb fe                	jmp    40121c <syscall+0x75>
	cprintf(SYS_TEST);
  40121e:	83 ec 0c             	sub    $0xc,%esp
  401221:	8d 83 0b d4 fe ff    	lea    -0x12bf5(%ebx),%eax
  401227:	50                   	push   %eax
  401228:	e8 c8 f6 ff ff       	call   4008f5 <cprintf>
  40122d:	83 c4 10             	add    $0x10,%esp
		return 0;
  401230:	b8 00 00 00 00       	mov    $0x0,%eax
}
  401235:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  401238:	c9                   	leave  
  401239:	c3                   	ret    

0040123a <ide_wait_ready>:

static int diskno = 0; // we only use one disk

static int
ide_wait_ready(bool check_error)
{
  40123a:	55                   	push   %ebp
  40123b:	89 e5                	mov    %esp,%ebp
  40123d:	53                   	push   %ebx
  40123e:	89 c1                	mov    %eax,%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  401240:	ba f7 01 00 00       	mov    $0x1f7,%edx
  401245:	ec                   	in     (%dx),%al
  401246:	89 c3                	mov    %eax,%ebx
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  401248:	83 e0 c0             	and    $0xffffffc0,%eax
  40124b:	3c 40                	cmp    $0x40,%al
  40124d:	75 f6                	jne    401245 <ide_wait_ready+0xb>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
		return -1;
	return 0;
  40124f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  401254:	84 c9                	test   %cl,%cl
  401256:	74 0b                	je     401263 <ide_wait_ready+0x29>
  401258:	f6 c3 21             	test   $0x21,%bl
  40125b:	0f 95 c0             	setne  %al
  40125e:	0f b6 c0             	movzbl %al,%eax
  401261:	f7 d8                	neg    %eax
}
  401263:	5b                   	pop    %ebx
  401264:	5d                   	pop    %ebp
  401265:	c3                   	ret    

00401266 <ide_read>:

int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  401266:	55                   	push   %ebp
  401267:	89 e5                	mov    %esp,%ebp
  401269:	57                   	push   %edi
  40126a:	56                   	push   %esi
  40126b:	53                   	push   %ebx
  40126c:	83 ec 0c             	sub    $0xc,%esp
  40126f:	e8 8b f5 ff ff       	call   4007ff <__x86.get_pc_thunk.ax>
  401274:	05 c0 40 01 00       	add    $0x140c0,%eax
  401279:	8b 7d 08             	mov    0x8(%ebp),%edi
  40127c:	8b 75 0c             	mov    0xc(%ebp),%esi
  40127f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int r;

	assert(nsecs <= 256);
  401282:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
  401288:	77 7a                	ja     401304 <ide_read+0x9e>

	ide_wait_ready(0);
  40128a:	b8 00 00 00 00       	mov    $0x0,%eax
  40128f:	e8 a6 ff ff ff       	call   40123a <ide_wait_ready>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  401294:	ba f2 01 00 00       	mov    $0x1f2,%edx
  401299:	89 d8                	mov    %ebx,%eax
  40129b:	ee                   	out    %al,(%dx)
  40129c:	ba f3 01 00 00       	mov    $0x1f3,%edx
  4012a1:	89 f8                	mov    %edi,%eax
  4012a3:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
  4012a4:	89 f8                	mov    %edi,%eax
  4012a6:	c1 e8 08             	shr    $0x8,%eax
  4012a9:	ba f4 01 00 00       	mov    $0x1f4,%edx
  4012ae:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  4012af:	89 f8                	mov    %edi,%eax
  4012b1:	c1 e8 10             	shr    $0x10,%eax
  4012b4:	ba f5 01 00 00       	mov    $0x1f5,%edx
  4012b9:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  4012ba:	89 f8                	mov    %edi,%eax
  4012bc:	c1 e8 18             	shr    $0x18,%eax
  4012bf:	83 e0 0f             	and    $0xf,%eax
  4012c2:	83 c8 e0             	or     $0xffffffe0,%eax
  4012c5:	ba f6 01 00 00       	mov    $0x1f6,%edx
  4012ca:	ee                   	out    %al,(%dx)
  4012cb:	b8 20 00 00 00       	mov    $0x20,%eax
  4012d0:	ba f7 01 00 00       	mov    $0x1f7,%edx
  4012d5:	ee                   	out    %al,(%dx)
  4012d6:	c1 e3 09             	shl    $0x9,%ebx
  4012d9:	01 f3                	add    %esi,%ebx
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  4012db:	39 f3                	cmp    %esi,%ebx
  4012dd:	74 43                	je     401322 <ide_read+0xbc>
		if ((r = ide_wait_ready(1)) < 0)
  4012df:	b8 01 00 00 00       	mov    $0x1,%eax
  4012e4:	e8 51 ff ff ff       	call   40123a <ide_wait_ready>
  4012e9:	85 c0                	test   %eax,%eax
  4012eb:	78 3a                	js     401327 <ide_read+0xc1>
	asm volatile("cld\n\trepne\n\tinsl"
  4012ed:	89 f7                	mov    %esi,%edi
  4012ef:	b9 80 00 00 00       	mov    $0x80,%ecx
  4012f4:	ba f0 01 00 00       	mov    $0x1f0,%edx
  4012f9:	fc                   	cld    
  4012fa:	f2 6d                	repnz insl (%dx),%es:(%edi)
	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  4012fc:	81 c6 00 02 00 00    	add    $0x200,%esi
  401302:	eb d7                	jmp    4012db <ide_read+0x75>
	assert(nsecs <= 256);
  401304:	8d 90 b4 d4 fe ff    	lea    -0x12b4c(%eax),%edx
  40130a:	52                   	push   %edx
  40130b:	8d 90 36 d2 fe ff    	lea    -0x12dca(%eax),%edx
  401311:	52                   	push   %edx
  401312:	6a 23                	push   $0x23
  401314:	8d 90 c1 d4 fe ff    	lea    -0x12b3f(%eax),%edx
  40131a:	52                   	push   %edx
  40131b:	89 c3                	mov    %eax,%ebx
  40131d:	e8 1e ed ff ff       	call   400040 <_panic>
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
	}

	return 0;
  401322:	b8 00 00 00 00       	mov    $0x0,%eax
}
  401327:	8d 65 f4             	lea    -0xc(%ebp),%esp
  40132a:	5b                   	pop    %ebx
  40132b:	5e                   	pop    %esi
  40132c:	5f                   	pop    %edi
  40132d:	5d                   	pop    %ebp
  40132e:	c3                   	ret    

0040132f <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  40132f:	55                   	push   %ebp
  401330:	89 e5                	mov    %esp,%ebp
  401332:	57                   	push   %edi
  401333:	56                   	push   %esi
  401334:	53                   	push   %ebx
  401335:	83 ec 0c             	sub    $0xc,%esp
  401338:	e8 c2 f4 ff ff       	call   4007ff <__x86.get_pc_thunk.ax>
  40133d:	05 f7 3f 01 00       	add    $0x13ff7,%eax
  401342:	8b 75 08             	mov    0x8(%ebp),%esi
  401345:	8b 7d 0c             	mov    0xc(%ebp),%edi
  401348:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int r;

	assert(nsecs <= 256);
  40134b:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
  401351:	77 7a                	ja     4013cd <ide_write+0x9e>

	ide_wait_ready(0);
  401353:	b8 00 00 00 00       	mov    $0x0,%eax
  401358:	e8 dd fe ff ff       	call   40123a <ide_wait_ready>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  40135d:	ba f2 01 00 00       	mov    $0x1f2,%edx
  401362:	89 d8                	mov    %ebx,%eax
  401364:	ee                   	out    %al,(%dx)
  401365:	ba f3 01 00 00       	mov    $0x1f3,%edx
  40136a:	89 f0                	mov    %esi,%eax
  40136c:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
  40136d:	89 f0                	mov    %esi,%eax
  40136f:	c1 e8 08             	shr    $0x8,%eax
  401372:	ba f4 01 00 00       	mov    $0x1f4,%edx
  401377:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  401378:	89 f0                	mov    %esi,%eax
  40137a:	c1 e8 10             	shr    $0x10,%eax
  40137d:	ba f5 01 00 00       	mov    $0x1f5,%edx
  401382:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  401383:	89 f0                	mov    %esi,%eax
  401385:	c1 e8 18             	shr    $0x18,%eax
  401388:	83 e0 0f             	and    $0xf,%eax
  40138b:	83 c8 e0             	or     $0xffffffe0,%eax
  40138e:	ba f6 01 00 00       	mov    $0x1f6,%edx
  401393:	ee                   	out    %al,(%dx)
  401394:	b8 30 00 00 00       	mov    $0x30,%eax
  401399:	ba f7 01 00 00       	mov    $0x1f7,%edx
  40139e:	ee                   	out    %al,(%dx)
  40139f:	c1 e3 09             	shl    $0x9,%ebx
  4013a2:	01 fb                	add    %edi,%ebx
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  4013a4:	39 fb                	cmp    %edi,%ebx
  4013a6:	74 43                	je     4013eb <ide_write+0xbc>
		if ((r = ide_wait_ready(1)) < 0)
  4013a8:	b8 01 00 00 00       	mov    $0x1,%eax
  4013ad:	e8 88 fe ff ff       	call   40123a <ide_wait_ready>
  4013b2:	85 c0                	test   %eax,%eax
  4013b4:	78 3a                	js     4013f0 <ide_write+0xc1>
	asm volatile("cld\n\trepne\n\toutsl"
  4013b6:	89 fe                	mov    %edi,%esi
  4013b8:	b9 80 00 00 00       	mov    $0x80,%ecx
  4013bd:	ba f0 01 00 00       	mov    $0x1f0,%edx
  4013c2:	fc                   	cld    
  4013c3:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  4013c5:	81 c7 00 02 00 00    	add    $0x200,%edi
  4013cb:	eb d7                	jmp    4013a4 <ide_write+0x75>
	assert(nsecs <= 256);
  4013cd:	8d 90 b4 d4 fe ff    	lea    -0x12b4c(%eax),%edx
  4013d3:	52                   	push   %edx
  4013d4:	8d 90 36 d2 fe ff    	lea    -0x12dca(%eax),%edx
  4013da:	52                   	push   %edx
  4013db:	6a 3c                	push   $0x3c
  4013dd:	8d 90 c1 d4 fe ff    	lea    -0x12b3f(%eax),%edx
  4013e3:	52                   	push   %edx
  4013e4:	89 c3                	mov    %eax,%ebx
  4013e6:	e8 55 ec ff ff       	call   400040 <_panic>
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
	}

	return 0;
  4013eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  4013f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  4013f3:	5b                   	pop    %ebx
  4013f4:	5e                   	pop    %esi
  4013f5:	5f                   	pop    %edi
  4013f6:	5d                   	pop    %ebp
  4013f7:	c3                   	ret    

004013f8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  4013f8:	55                   	push   %ebp
  4013f9:	89 e5                	mov    %esp,%ebp
  4013fb:	57                   	push   %edi
  4013fc:	56                   	push   %esi
  4013fd:	53                   	push   %ebx
  4013fe:	83 ec 2c             	sub    $0x2c,%esp
  401401:	e8 cd 05 00 00       	call   4019d3 <__x86.get_pc_thunk.cx>
  401406:	81 c1 2e 3f 01 00    	add    $0x13f2e,%ecx
  40140c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  40140f:	89 c7                	mov    %eax,%edi
  401411:	89 d6                	mov    %edx,%esi
  401413:	8b 45 08             	mov    0x8(%ebp),%eax
  401416:	8b 55 0c             	mov    0xc(%ebp),%edx
  401419:	89 45 d0             	mov    %eax,-0x30(%ebp)
  40141c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  40141f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  401422:	bb 00 00 00 00       	mov    $0x0,%ebx
  401427:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  40142a:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  40142d:	39 d3                	cmp    %edx,%ebx
  40142f:	72 09                	jb     40143a <printnum+0x42>
  401431:	39 45 10             	cmp    %eax,0x10(%ebp)
  401434:	0f 87 83 00 00 00    	ja     4014bd <printnum+0xc5>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  40143a:	83 ec 0c             	sub    $0xc,%esp
  40143d:	ff 75 18             	pushl  0x18(%ebp)
  401440:	8b 45 14             	mov    0x14(%ebp),%eax
  401443:	8d 58 ff             	lea    -0x1(%eax),%ebx
  401446:	53                   	push   %ebx
  401447:	ff 75 10             	pushl  0x10(%ebp)
  40144a:	83 ec 08             	sub    $0x8,%esp
  40144d:	ff 75 dc             	pushl  -0x24(%ebp)
  401450:	ff 75 d8             	pushl  -0x28(%ebp)
  401453:	ff 75 d4             	pushl  -0x2c(%ebp)
  401456:	ff 75 d0             	pushl  -0x30(%ebp)
  401459:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  40145c:	e8 ef 09 00 00       	call   401e50 <__udivdi3>
  401461:	83 c4 18             	add    $0x18,%esp
  401464:	52                   	push   %edx
  401465:	50                   	push   %eax
  401466:	89 f2                	mov    %esi,%edx
  401468:	89 f8                	mov    %edi,%eax
  40146a:	e8 89 ff ff ff       	call   4013f8 <printnum>
  40146f:	83 c4 20             	add    $0x20,%esp
  401472:	eb 13                	jmp    401487 <printnum+0x8f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  401474:	83 ec 08             	sub    $0x8,%esp
  401477:	56                   	push   %esi
  401478:	ff 75 18             	pushl  0x18(%ebp)
  40147b:	ff d7                	call   *%edi
  40147d:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  401480:	83 eb 01             	sub    $0x1,%ebx
  401483:	85 db                	test   %ebx,%ebx
  401485:	7f ed                	jg     401474 <printnum+0x7c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  401487:	83 ec 08             	sub    $0x8,%esp
  40148a:	56                   	push   %esi
  40148b:	83 ec 04             	sub    $0x4,%esp
  40148e:	ff 75 dc             	pushl  -0x24(%ebp)
  401491:	ff 75 d8             	pushl  -0x28(%ebp)
  401494:	ff 75 d4             	pushl  -0x2c(%ebp)
  401497:	ff 75 d0             	pushl  -0x30(%ebp)
  40149a:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  40149d:	89 f3                	mov    %esi,%ebx
  40149f:	e8 cc 0a 00 00       	call   401f70 <__umoddi3>
  4014a4:	83 c4 14             	add    $0x14,%esp
  4014a7:	0f be 84 06 cc d4 fe 	movsbl -0x12b34(%esi,%eax,1),%eax
  4014ae:	ff 
  4014af:	50                   	push   %eax
  4014b0:	ff d7                	call   *%edi
}
  4014b2:	83 c4 10             	add    $0x10,%esp
  4014b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  4014b8:	5b                   	pop    %ebx
  4014b9:	5e                   	pop    %esi
  4014ba:	5f                   	pop    %edi
  4014bb:	5d                   	pop    %ebp
  4014bc:	c3                   	ret    
  4014bd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  4014c0:	eb be                	jmp    401480 <printnum+0x88>

004014c2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  4014c2:	55                   	push   %ebp
  4014c3:	89 e5                	mov    %esp,%ebp
  4014c5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  4014c8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  4014cc:	8b 10                	mov    (%eax),%edx
  4014ce:	3b 50 04             	cmp    0x4(%eax),%edx
  4014d1:	73 0a                	jae    4014dd <sprintputch+0x1b>
		*b->buf++ = ch;
  4014d3:	8d 4a 01             	lea    0x1(%edx),%ecx
  4014d6:	89 08                	mov    %ecx,(%eax)
  4014d8:	8b 45 08             	mov    0x8(%ebp),%eax
  4014db:	88 02                	mov    %al,(%edx)
}
  4014dd:	5d                   	pop    %ebp
  4014de:	c3                   	ret    

004014df <printfmt>:
{
  4014df:	55                   	push   %ebp
  4014e0:	89 e5                	mov    %esp,%ebp
  4014e2:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  4014e5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  4014e8:	50                   	push   %eax
  4014e9:	ff 75 10             	pushl  0x10(%ebp)
  4014ec:	ff 75 0c             	pushl  0xc(%ebp)
  4014ef:	ff 75 08             	pushl  0x8(%ebp)
  4014f2:	e8 05 00 00 00       	call   4014fc <vprintfmt>
}
  4014f7:	83 c4 10             	add    $0x10,%esp
  4014fa:	c9                   	leave  
  4014fb:	c3                   	ret    

004014fc <vprintfmt>:
{
  4014fc:	55                   	push   %ebp
  4014fd:	89 e5                	mov    %esp,%ebp
  4014ff:	57                   	push   %edi
  401500:	56                   	push   %esi
  401501:	53                   	push   %ebx
  401502:	83 ec 2c             	sub    $0x2c,%esp
  401505:	e8 53 ed ff ff       	call   40025d <__x86.get_pc_thunk.bx>
  40150a:	81 c3 2a 3e 01 00    	add    $0x13e2a,%ebx
  401510:	8b 75 0c             	mov    0xc(%ebp),%esi
  401513:	8b 7d 10             	mov    0x10(%ebp),%edi
  401516:	e9 8e 03 00 00       	jmp    4018a9 <.L35+0x48>
		padc = ' ';
  40151b:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  40151f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  401526:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  40152d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  401534:	b9 00 00 00 00       	mov    $0x0,%ecx
  401539:	89 4d cc             	mov    %ecx,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  40153c:	8d 47 01             	lea    0x1(%edi),%eax
  40153f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  401542:	0f b6 17             	movzbl (%edi),%edx
  401545:	8d 42 dd             	lea    -0x23(%edx),%eax
  401548:	3c 55                	cmp    $0x55,%al
  40154a:	0f 87 e1 03 00 00    	ja     401931 <.L22>
  401550:	0f b6 c0             	movzbl %al,%eax
  401553:	89 d9                	mov    %ebx,%ecx
  401555:	03 8c 83 58 d5 fe ff 	add    -0x12aa8(%ebx,%eax,4),%ecx
  40155c:	ff e1                	jmp    *%ecx

0040155e <.L67>:
  40155e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  401561:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  401565:	eb d5                	jmp    40153c <vprintfmt+0x40>

00401567 <.L28>:
		switch (ch = *(unsigned char *) fmt++) {
  401567:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  40156a:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  40156e:	eb cc                	jmp    40153c <vprintfmt+0x40>

00401570 <.L29>:
		switch (ch = *(unsigned char *) fmt++) {
  401570:	0f b6 d2             	movzbl %dl,%edx
  401573:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  401576:	b8 00 00 00 00       	mov    $0x0,%eax
				precision = precision * 10 + ch - '0';
  40157b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  40157e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  401582:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  401585:	8d 4a d0             	lea    -0x30(%edx),%ecx
  401588:	83 f9 09             	cmp    $0x9,%ecx
  40158b:	77 55                	ja     4015e2 <.L23+0xf>
			for (precision = 0; ; ++fmt) {
  40158d:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  401590:	eb e9                	jmp    40157b <.L29+0xb>

00401592 <.L26>:
			precision = va_arg(ap, int);
  401592:	8b 45 14             	mov    0x14(%ebp),%eax
  401595:	8b 00                	mov    (%eax),%eax
  401597:	89 45 d0             	mov    %eax,-0x30(%ebp)
  40159a:	8b 45 14             	mov    0x14(%ebp),%eax
  40159d:	8d 40 04             	lea    0x4(%eax),%eax
  4015a0:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  4015a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  4015a6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  4015aa:	79 90                	jns    40153c <vprintfmt+0x40>
				width = precision, precision = -1;
  4015ac:	8b 45 d0             	mov    -0x30(%ebp),%eax
  4015af:	89 45 e0             	mov    %eax,-0x20(%ebp)
  4015b2:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  4015b9:	eb 81                	jmp    40153c <vprintfmt+0x40>

004015bb <.L27>:
  4015bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  4015be:	85 c0                	test   %eax,%eax
  4015c0:	ba 00 00 00 00       	mov    $0x0,%edx
  4015c5:	0f 49 d0             	cmovns %eax,%edx
  4015c8:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  4015cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  4015ce:	e9 69 ff ff ff       	jmp    40153c <vprintfmt+0x40>

004015d3 <.L23>:
  4015d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  4015d6:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  4015dd:	e9 5a ff ff ff       	jmp    40153c <vprintfmt+0x40>
  4015e2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  4015e5:	eb bf                	jmp    4015a6 <.L26+0x14>

004015e7 <.L33>:
			lflag++;
  4015e7:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  4015eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  4015ee:	e9 49 ff ff ff       	jmp    40153c <vprintfmt+0x40>

004015f3 <.L30>:
			putch(va_arg(ap, int), putdat);
  4015f3:	8b 45 14             	mov    0x14(%ebp),%eax
  4015f6:	8d 78 04             	lea    0x4(%eax),%edi
  4015f9:	83 ec 08             	sub    $0x8,%esp
  4015fc:	56                   	push   %esi
  4015fd:	ff 30                	pushl  (%eax)
  4015ff:	ff 55 08             	call   *0x8(%ebp)
			break;
  401602:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  401605:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  401608:	e9 99 02 00 00       	jmp    4018a6 <.L35+0x45>

0040160d <.L32>:
			err = va_arg(ap, int);
  40160d:	8b 45 14             	mov    0x14(%ebp),%eax
  401610:	8d 78 04             	lea    0x4(%eax),%edi
  401613:	8b 00                	mov    (%eax),%eax
  401615:	99                   	cltd   
  401616:	31 d0                	xor    %edx,%eax
  401618:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  40161a:	83 f8 06             	cmp    $0x6,%eax
  40161d:	7f 27                	jg     401646 <.L32+0x39>
  40161f:	8b 94 83 5c 1d 00 00 	mov    0x1d5c(%ebx,%eax,4),%edx
  401626:	85 d2                	test   %edx,%edx
  401628:	74 1c                	je     401646 <.L32+0x39>
				printfmt(putch, putdat, "%s", p);
  40162a:	52                   	push   %edx
  40162b:	8d 83 48 d2 fe ff    	lea    -0x12db8(%ebx),%eax
  401631:	50                   	push   %eax
  401632:	56                   	push   %esi
  401633:	ff 75 08             	pushl  0x8(%ebp)
  401636:	e8 a4 fe ff ff       	call   4014df <printfmt>
  40163b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  40163e:	89 7d 14             	mov    %edi,0x14(%ebp)
  401641:	e9 60 02 00 00       	jmp    4018a6 <.L35+0x45>
				printfmt(putch, putdat, "error %d", err);
  401646:	50                   	push   %eax
  401647:	8d 83 e4 d4 fe ff    	lea    -0x12b1c(%ebx),%eax
  40164d:	50                   	push   %eax
  40164e:	56                   	push   %esi
  40164f:	ff 75 08             	pushl  0x8(%ebp)
  401652:	e8 88 fe ff ff       	call   4014df <printfmt>
  401657:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  40165a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  40165d:	e9 44 02 00 00       	jmp    4018a6 <.L35+0x45>

00401662 <.L36>:
			if ((p = va_arg(ap, char *)) == NULL)
  401662:	8b 45 14             	mov    0x14(%ebp),%eax
  401665:	83 c0 04             	add    $0x4,%eax
  401668:	89 45 cc             	mov    %eax,-0x34(%ebp)
  40166b:	8b 45 14             	mov    0x14(%ebp),%eax
  40166e:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  401670:	85 ff                	test   %edi,%edi
  401672:	8d 83 dd d4 fe ff    	lea    -0x12b23(%ebx),%eax
  401678:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  40167b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  40167f:	0f 8e b5 00 00 00    	jle    40173a <.L36+0xd8>
  401685:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  401689:	75 08                	jne    401693 <.L36+0x31>
  40168b:	89 75 0c             	mov    %esi,0xc(%ebp)
  40168e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  401691:	eb 6d                	jmp    401700 <.L36+0x9e>
				for (width -= strnlen(p, precision); width > 0; width--)
  401693:	83 ec 08             	sub    $0x8,%esp
  401696:	ff 75 d0             	pushl  -0x30(%ebp)
  401699:	57                   	push   %edi
  40169a:	e8 4d 04 00 00       	call   401aec <strnlen>
  40169f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  4016a2:	29 c2                	sub    %eax,%edx
  4016a4:	89 55 c8             	mov    %edx,-0x38(%ebp)
  4016a7:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  4016aa:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  4016ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
  4016b1:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  4016b4:	89 d7                	mov    %edx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  4016b6:	eb 10                	jmp    4016c8 <.L36+0x66>
					putch(padc, putdat);
  4016b8:	83 ec 08             	sub    $0x8,%esp
  4016bb:	56                   	push   %esi
  4016bc:	ff 75 e0             	pushl  -0x20(%ebp)
  4016bf:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  4016c2:	83 ef 01             	sub    $0x1,%edi
  4016c5:	83 c4 10             	add    $0x10,%esp
  4016c8:	85 ff                	test   %edi,%edi
  4016ca:	7f ec                	jg     4016b8 <.L36+0x56>
  4016cc:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  4016cf:	8b 55 c8             	mov    -0x38(%ebp),%edx
  4016d2:	85 d2                	test   %edx,%edx
  4016d4:	b8 00 00 00 00       	mov    $0x0,%eax
  4016d9:	0f 49 c2             	cmovns %edx,%eax
  4016dc:	29 c2                	sub    %eax,%edx
  4016de:	89 55 e0             	mov    %edx,-0x20(%ebp)
  4016e1:	89 75 0c             	mov    %esi,0xc(%ebp)
  4016e4:	8b 75 d0             	mov    -0x30(%ebp),%esi
  4016e7:	eb 17                	jmp    401700 <.L36+0x9e>
				if (altflag && (ch < ' ' || ch > '~'))
  4016e9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  4016ed:	75 30                	jne    40171f <.L36+0xbd>
					putch(ch, putdat);
  4016ef:	83 ec 08             	sub    $0x8,%esp
  4016f2:	ff 75 0c             	pushl  0xc(%ebp)
  4016f5:	50                   	push   %eax
  4016f6:	ff 55 08             	call   *0x8(%ebp)
  4016f9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  4016fc:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  401700:	83 c7 01             	add    $0x1,%edi
  401703:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  401707:	0f be c2             	movsbl %dl,%eax
  40170a:	85 c0                	test   %eax,%eax
  40170c:	74 52                	je     401760 <.L36+0xfe>
  40170e:	85 f6                	test   %esi,%esi
  401710:	78 d7                	js     4016e9 <.L36+0x87>
  401712:	83 ee 01             	sub    $0x1,%esi
  401715:	79 d2                	jns    4016e9 <.L36+0x87>
  401717:	8b 75 0c             	mov    0xc(%ebp),%esi
  40171a:	8b 7d e0             	mov    -0x20(%ebp),%edi
  40171d:	eb 32                	jmp    401751 <.L36+0xef>
				if (altflag && (ch < ' ' || ch > '~'))
  40171f:	0f be d2             	movsbl %dl,%edx
  401722:	83 ea 20             	sub    $0x20,%edx
  401725:	83 fa 5e             	cmp    $0x5e,%edx
  401728:	76 c5                	jbe    4016ef <.L36+0x8d>
					putch('?', putdat);
  40172a:	83 ec 08             	sub    $0x8,%esp
  40172d:	ff 75 0c             	pushl  0xc(%ebp)
  401730:	6a 3f                	push   $0x3f
  401732:	ff 55 08             	call   *0x8(%ebp)
  401735:	83 c4 10             	add    $0x10,%esp
  401738:	eb c2                	jmp    4016fc <.L36+0x9a>
  40173a:	89 75 0c             	mov    %esi,0xc(%ebp)
  40173d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  401740:	eb be                	jmp    401700 <.L36+0x9e>
				putch(' ', putdat);
  401742:	83 ec 08             	sub    $0x8,%esp
  401745:	56                   	push   %esi
  401746:	6a 20                	push   $0x20
  401748:	ff 55 08             	call   *0x8(%ebp)
			for (; width > 0; width--)
  40174b:	83 ef 01             	sub    $0x1,%edi
  40174e:	83 c4 10             	add    $0x10,%esp
  401751:	85 ff                	test   %edi,%edi
  401753:	7f ed                	jg     401742 <.L36+0xe0>
			if ((p = va_arg(ap, char *)) == NULL)
  401755:	8b 45 cc             	mov    -0x34(%ebp),%eax
  401758:	89 45 14             	mov    %eax,0x14(%ebp)
  40175b:	e9 46 01 00 00       	jmp    4018a6 <.L35+0x45>
  401760:	8b 7d e0             	mov    -0x20(%ebp),%edi
  401763:	8b 75 0c             	mov    0xc(%ebp),%esi
  401766:	eb e9                	jmp    401751 <.L36+0xef>

00401768 <.L31>:
  401768:	8b 4d cc             	mov    -0x34(%ebp),%ecx
	if (lflag >= 2)
  40176b:	83 f9 01             	cmp    $0x1,%ecx
  40176e:	7e 40                	jle    4017b0 <.L31+0x48>
		return va_arg(*ap, long long);
  401770:	8b 45 14             	mov    0x14(%ebp),%eax
  401773:	8b 50 04             	mov    0x4(%eax),%edx
  401776:	8b 00                	mov    (%eax),%eax
  401778:	89 45 d8             	mov    %eax,-0x28(%ebp)
  40177b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  40177e:	8b 45 14             	mov    0x14(%ebp),%eax
  401781:	8d 40 08             	lea    0x8(%eax),%eax
  401784:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  401787:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  40178b:	79 55                	jns    4017e2 <.L31+0x7a>
				putch('-', putdat);
  40178d:	83 ec 08             	sub    $0x8,%esp
  401790:	56                   	push   %esi
  401791:	6a 2d                	push   $0x2d
  401793:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  401796:	8b 55 d8             	mov    -0x28(%ebp),%edx
  401799:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  40179c:	f7 da                	neg    %edx
  40179e:	83 d1 00             	adc    $0x0,%ecx
  4017a1:	f7 d9                	neg    %ecx
  4017a3:	83 c4 10             	add    $0x10,%esp
			base = 10;
  4017a6:	b8 0a 00 00 00       	mov    $0xa,%eax
  4017ab:	e9 db 00 00 00       	jmp    40188b <.L35+0x2a>
	else if (lflag)
  4017b0:	85 c9                	test   %ecx,%ecx
  4017b2:	75 17                	jne    4017cb <.L31+0x63>
		return va_arg(*ap, int);
  4017b4:	8b 45 14             	mov    0x14(%ebp),%eax
  4017b7:	8b 00                	mov    (%eax),%eax
  4017b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  4017bc:	99                   	cltd   
  4017bd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  4017c0:	8b 45 14             	mov    0x14(%ebp),%eax
  4017c3:	8d 40 04             	lea    0x4(%eax),%eax
  4017c6:	89 45 14             	mov    %eax,0x14(%ebp)
  4017c9:	eb bc                	jmp    401787 <.L31+0x1f>
		return va_arg(*ap, long);
  4017cb:	8b 45 14             	mov    0x14(%ebp),%eax
  4017ce:	8b 00                	mov    (%eax),%eax
  4017d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  4017d3:	99                   	cltd   
  4017d4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  4017d7:	8b 45 14             	mov    0x14(%ebp),%eax
  4017da:	8d 40 04             	lea    0x4(%eax),%eax
  4017dd:	89 45 14             	mov    %eax,0x14(%ebp)
  4017e0:	eb a5                	jmp    401787 <.L31+0x1f>
			num = getint(&ap, lflag);
  4017e2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  4017e5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  4017e8:	b8 0a 00 00 00       	mov    $0xa,%eax
  4017ed:	e9 99 00 00 00       	jmp    40188b <.L35+0x2a>

004017f2 <.L37>:
  4017f2:	8b 4d cc             	mov    -0x34(%ebp),%ecx
	if (lflag >= 2)
  4017f5:	83 f9 01             	cmp    $0x1,%ecx
  4017f8:	7e 15                	jle    40180f <.L37+0x1d>
		return va_arg(*ap, unsigned long long);
  4017fa:	8b 45 14             	mov    0x14(%ebp),%eax
  4017fd:	8b 10                	mov    (%eax),%edx
  4017ff:	8b 48 04             	mov    0x4(%eax),%ecx
  401802:	8d 40 08             	lea    0x8(%eax),%eax
  401805:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  401808:	b8 0a 00 00 00       	mov    $0xa,%eax
  40180d:	eb 7c                	jmp    40188b <.L35+0x2a>
	else if (lflag)
  40180f:	85 c9                	test   %ecx,%ecx
  401811:	75 17                	jne    40182a <.L37+0x38>
		return va_arg(*ap, unsigned int);
  401813:	8b 45 14             	mov    0x14(%ebp),%eax
  401816:	8b 10                	mov    (%eax),%edx
  401818:	b9 00 00 00 00       	mov    $0x0,%ecx
  40181d:	8d 40 04             	lea    0x4(%eax),%eax
  401820:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  401823:	b8 0a 00 00 00       	mov    $0xa,%eax
  401828:	eb 61                	jmp    40188b <.L35+0x2a>
		return va_arg(*ap, unsigned long);
  40182a:	8b 45 14             	mov    0x14(%ebp),%eax
  40182d:	8b 10                	mov    (%eax),%edx
  40182f:	b9 00 00 00 00       	mov    $0x0,%ecx
  401834:	8d 40 04             	lea    0x4(%eax),%eax
  401837:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  40183a:	b8 0a 00 00 00       	mov    $0xa,%eax
  40183f:	eb 4a                	jmp    40188b <.L35+0x2a>

00401841 <.L34>:
			putch('X', putdat);
  401841:	83 ec 08             	sub    $0x8,%esp
  401844:	56                   	push   %esi
  401845:	6a 58                	push   $0x58
  401847:	ff 55 08             	call   *0x8(%ebp)
			putch('X', putdat);
  40184a:	83 c4 08             	add    $0x8,%esp
  40184d:	56                   	push   %esi
  40184e:	6a 58                	push   $0x58
  401850:	ff 55 08             	call   *0x8(%ebp)
			putch('X', putdat);
  401853:	83 c4 08             	add    $0x8,%esp
  401856:	56                   	push   %esi
  401857:	6a 58                	push   $0x58
  401859:	ff 55 08             	call   *0x8(%ebp)
			break;
  40185c:	83 c4 10             	add    $0x10,%esp
  40185f:	eb 45                	jmp    4018a6 <.L35+0x45>

00401861 <.L35>:
			putch('0', putdat);
  401861:	83 ec 08             	sub    $0x8,%esp
  401864:	56                   	push   %esi
  401865:	6a 30                	push   $0x30
  401867:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  40186a:	83 c4 08             	add    $0x8,%esp
  40186d:	56                   	push   %esi
  40186e:	6a 78                	push   $0x78
  401870:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  401873:	8b 45 14             	mov    0x14(%ebp),%eax
  401876:	8b 10                	mov    (%eax),%edx
  401878:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  40187d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  401880:	8d 40 04             	lea    0x4(%eax),%eax
  401883:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  401886:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  40188b:	83 ec 0c             	sub    $0xc,%esp
  40188e:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  401892:	57                   	push   %edi
  401893:	ff 75 e0             	pushl  -0x20(%ebp)
  401896:	50                   	push   %eax
  401897:	51                   	push   %ecx
  401898:	52                   	push   %edx
  401899:	89 f2                	mov    %esi,%edx
  40189b:	8b 45 08             	mov    0x8(%ebp),%eax
  40189e:	e8 55 fb ff ff       	call   4013f8 <printnum>
			break;
  4018a3:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  4018a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  4018a9:	83 c7 01             	add    $0x1,%edi
  4018ac:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  4018b0:	83 f8 25             	cmp    $0x25,%eax
  4018b3:	0f 84 62 fc ff ff    	je     40151b <vprintfmt+0x1f>
			if (ch == '\0')
  4018b9:	85 c0                	test   %eax,%eax
  4018bb:	0f 84 91 00 00 00    	je     401952 <.L22+0x21>
			putch(ch, putdat);
  4018c1:	83 ec 08             	sub    $0x8,%esp
  4018c4:	56                   	push   %esi
  4018c5:	50                   	push   %eax
  4018c6:	ff 55 08             	call   *0x8(%ebp)
  4018c9:	83 c4 10             	add    $0x10,%esp
  4018cc:	eb db                	jmp    4018a9 <.L35+0x48>

004018ce <.L38>:
  4018ce:	8b 4d cc             	mov    -0x34(%ebp),%ecx
	if (lflag >= 2)
  4018d1:	83 f9 01             	cmp    $0x1,%ecx
  4018d4:	7e 15                	jle    4018eb <.L38+0x1d>
		return va_arg(*ap, unsigned long long);
  4018d6:	8b 45 14             	mov    0x14(%ebp),%eax
  4018d9:	8b 10                	mov    (%eax),%edx
  4018db:	8b 48 04             	mov    0x4(%eax),%ecx
  4018de:	8d 40 08             	lea    0x8(%eax),%eax
  4018e1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  4018e4:	b8 10 00 00 00       	mov    $0x10,%eax
  4018e9:	eb a0                	jmp    40188b <.L35+0x2a>
	else if (lflag)
  4018eb:	85 c9                	test   %ecx,%ecx
  4018ed:	75 17                	jne    401906 <.L38+0x38>
		return va_arg(*ap, unsigned int);
  4018ef:	8b 45 14             	mov    0x14(%ebp),%eax
  4018f2:	8b 10                	mov    (%eax),%edx
  4018f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  4018f9:	8d 40 04             	lea    0x4(%eax),%eax
  4018fc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  4018ff:	b8 10 00 00 00       	mov    $0x10,%eax
  401904:	eb 85                	jmp    40188b <.L35+0x2a>
		return va_arg(*ap, unsigned long);
  401906:	8b 45 14             	mov    0x14(%ebp),%eax
  401909:	8b 10                	mov    (%eax),%edx
  40190b:	b9 00 00 00 00       	mov    $0x0,%ecx
  401910:	8d 40 04             	lea    0x4(%eax),%eax
  401913:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  401916:	b8 10 00 00 00       	mov    $0x10,%eax
  40191b:	e9 6b ff ff ff       	jmp    40188b <.L35+0x2a>

00401920 <.L25>:
			putch(ch, putdat);
  401920:	83 ec 08             	sub    $0x8,%esp
  401923:	56                   	push   %esi
  401924:	6a 25                	push   $0x25
  401926:	ff 55 08             	call   *0x8(%ebp)
			break;
  401929:	83 c4 10             	add    $0x10,%esp
  40192c:	e9 75 ff ff ff       	jmp    4018a6 <.L35+0x45>

00401931 <.L22>:
			putch('%', putdat);
  401931:	83 ec 08             	sub    $0x8,%esp
  401934:	56                   	push   %esi
  401935:	6a 25                	push   $0x25
  401937:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  40193a:	83 c4 10             	add    $0x10,%esp
  40193d:	89 f8                	mov    %edi,%eax
  40193f:	eb 03                	jmp    401944 <.L22+0x13>
  401941:	83 e8 01             	sub    $0x1,%eax
  401944:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  401948:	75 f7                	jne    401941 <.L22+0x10>
  40194a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  40194d:	e9 54 ff ff ff       	jmp    4018a6 <.L35+0x45>
}
  401952:	8d 65 f4             	lea    -0xc(%ebp),%esp
  401955:	5b                   	pop    %ebx
  401956:	5e                   	pop    %esi
  401957:	5f                   	pop    %edi
  401958:	5d                   	pop    %ebp
  401959:	c3                   	ret    

0040195a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  40195a:	55                   	push   %ebp
  40195b:	89 e5                	mov    %esp,%ebp
  40195d:	53                   	push   %ebx
  40195e:	83 ec 14             	sub    $0x14,%esp
  401961:	e8 f7 e8 ff ff       	call   40025d <__x86.get_pc_thunk.bx>
  401966:	81 c3 ce 39 01 00    	add    $0x139ce,%ebx
  40196c:	8b 45 08             	mov    0x8(%ebp),%eax
  40196f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  401972:	89 45 ec             	mov    %eax,-0x14(%ebp)
  401975:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  401979:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  40197c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  401983:	85 c0                	test   %eax,%eax
  401985:	74 2b                	je     4019b2 <vsnprintf+0x58>
  401987:	85 d2                	test   %edx,%edx
  401989:	7e 27                	jle    4019b2 <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  40198b:	ff 75 14             	pushl  0x14(%ebp)
  40198e:	ff 75 10             	pushl  0x10(%ebp)
  401991:	8d 45 ec             	lea    -0x14(%ebp),%eax
  401994:	50                   	push   %eax
  401995:	8d 83 8e c1 fe ff    	lea    -0x13e72(%ebx),%eax
  40199b:	50                   	push   %eax
  40199c:	e8 5b fb ff ff       	call   4014fc <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  4019a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  4019a4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  4019a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  4019aa:	83 c4 10             	add    $0x10,%esp
}
  4019ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  4019b0:	c9                   	leave  
  4019b1:	c3                   	ret    
		return -E_INVAL;
  4019b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  4019b7:	eb f4                	jmp    4019ad <vsnprintf+0x53>

004019b9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  4019b9:	55                   	push   %ebp
  4019ba:	89 e5                	mov    %esp,%ebp
  4019bc:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  4019bf:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  4019c2:	50                   	push   %eax
  4019c3:	ff 75 10             	pushl  0x10(%ebp)
  4019c6:	ff 75 0c             	pushl  0xc(%ebp)
  4019c9:	ff 75 08             	pushl  0x8(%ebp)
  4019cc:	e8 89 ff ff ff       	call   40195a <vsnprintf>
	va_end(ap);

	return rc;
}
  4019d1:	c9                   	leave  
  4019d2:	c3                   	ret    

004019d3 <__x86.get_pc_thunk.cx>:
  4019d3:	8b 0c 24             	mov    (%esp),%ecx
  4019d6:	c3                   	ret    

004019d7 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  4019d7:	55                   	push   %ebp
  4019d8:	89 e5                	mov    %esp,%ebp
  4019da:	57                   	push   %edi
  4019db:	56                   	push   %esi
  4019dc:	53                   	push   %ebx
  4019dd:	83 ec 1c             	sub    $0x1c,%esp
  4019e0:	e8 78 e8 ff ff       	call   40025d <__x86.get_pc_thunk.bx>
  4019e5:	81 c3 4f 39 01 00    	add    $0x1394f,%ebx
  4019eb:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

	if (prompt != NULL)
  4019ee:	85 c0                	test   %eax,%eax
  4019f0:	74 13                	je     401a05 <readline+0x2e>
		cprintf("%s", prompt);
  4019f2:	83 ec 08             	sub    $0x8,%esp
  4019f5:	50                   	push   %eax
  4019f6:	8d 83 48 d2 fe ff    	lea    -0x12db8(%ebx),%eax
  4019fc:	50                   	push   %eax
  4019fd:	e8 f3 ee ff ff       	call   4008f5 <cprintf>
  401a02:	83 c4 10             	add    $0x10,%esp

	i = 0;
	echoing = iscons(0);
  401a05:	83 ec 0c             	sub    $0xc,%esp
  401a08:	6a 00                	push   $0x0
  401a0a:	e8 e6 ed ff ff       	call   4007f5 <iscons>
  401a0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  401a12:	83 c4 10             	add    $0x10,%esp
	i = 0;
  401a15:	bf 00 00 00 00       	mov    $0x0,%edi
  401a1a:	eb 46                	jmp    401a62 <readline+0x8b>
	while (1) {
		c = getchar();
		if (c < 0) {
			cprintf("read error: %e\n", c);
  401a1c:	83 ec 08             	sub    $0x8,%esp
  401a1f:	50                   	push   %eax
  401a20:	8d 83 b0 d6 fe ff    	lea    -0x12950(%ebx),%eax
  401a26:	50                   	push   %eax
  401a27:	e8 c9 ee ff ff       	call   4008f5 <cprintf>
			return NULL;
  401a2c:	83 c4 10             	add    $0x10,%esp
  401a2f:	b8 00 00 00 00       	mov    $0x0,%eax
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
  401a34:	8d 65 f4             	lea    -0xc(%ebp),%esp
  401a37:	5b                   	pop    %ebx
  401a38:	5e                   	pop    %esi
  401a39:	5f                   	pop    %edi
  401a3a:	5d                   	pop    %ebp
  401a3b:	c3                   	ret    
			if (echoing)
  401a3c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  401a40:	75 05                	jne    401a47 <readline+0x70>
			i--;
  401a42:	83 ef 01             	sub    $0x1,%edi
  401a45:	eb 1b                	jmp    401a62 <readline+0x8b>
				cputchar('\b');
  401a47:	83 ec 0c             	sub    $0xc,%esp
  401a4a:	6a 08                	push   $0x8
  401a4c:	e8 83 ed ff ff       	call   4007d4 <cputchar>
  401a51:	83 c4 10             	add    $0x10,%esp
  401a54:	eb ec                	jmp    401a42 <readline+0x6b>
			buf[i++] = c;
  401a56:	89 f0                	mov    %esi,%eax
  401a58:	88 84 3b 6c 28 00 00 	mov    %al,0x286c(%ebx,%edi,1)
  401a5f:	8d 7f 01             	lea    0x1(%edi),%edi
		c = getchar();
  401a62:	e8 7d ed ff ff       	call   4007e4 <getchar>
  401a67:	89 c6                	mov    %eax,%esi
		if (c < 0) {
  401a69:	85 c0                	test   %eax,%eax
  401a6b:	78 af                	js     401a1c <readline+0x45>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  401a6d:	83 f8 08             	cmp    $0x8,%eax
  401a70:	0f 94 c2             	sete   %dl
  401a73:	83 f8 7f             	cmp    $0x7f,%eax
  401a76:	0f 94 c0             	sete   %al
  401a79:	08 c2                	or     %al,%dl
  401a7b:	74 04                	je     401a81 <readline+0xaa>
  401a7d:	85 ff                	test   %edi,%edi
  401a7f:	7f bb                	jg     401a3c <readline+0x65>
		} else if (c >= ' ' && i < BUFLEN-1) {
  401a81:	83 fe 1f             	cmp    $0x1f,%esi
  401a84:	7e 1c                	jle    401aa2 <readline+0xcb>
  401a86:	81 ff fe 03 00 00    	cmp    $0x3fe,%edi
  401a8c:	7f 14                	jg     401aa2 <readline+0xcb>
			if (echoing)
  401a8e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  401a92:	74 c2                	je     401a56 <readline+0x7f>
				cputchar(c);
  401a94:	83 ec 0c             	sub    $0xc,%esp
  401a97:	56                   	push   %esi
  401a98:	e8 37 ed ff ff       	call   4007d4 <cputchar>
  401a9d:	83 c4 10             	add    $0x10,%esp
  401aa0:	eb b4                	jmp    401a56 <readline+0x7f>
		} else if (c == '\n' || c == '\r') {
  401aa2:	83 fe 0a             	cmp    $0xa,%esi
  401aa5:	74 05                	je     401aac <readline+0xd5>
  401aa7:	83 fe 0d             	cmp    $0xd,%esi
  401aaa:	75 b6                	jne    401a62 <readline+0x8b>
			if (echoing)
  401aac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  401ab0:	75 13                	jne    401ac5 <readline+0xee>
			buf[i] = 0;
  401ab2:	c6 84 3b 6c 28 00 00 	movb   $0x0,0x286c(%ebx,%edi,1)
  401ab9:	00 
			return buf;
  401aba:	8d 83 6c 28 00 00    	lea    0x286c(%ebx),%eax
  401ac0:	e9 6f ff ff ff       	jmp    401a34 <readline+0x5d>
				cputchar('\n');
  401ac5:	83 ec 0c             	sub    $0xc,%esp
  401ac8:	6a 0a                	push   $0xa
  401aca:	e8 05 ed ff ff       	call   4007d4 <cputchar>
  401acf:	83 c4 10             	add    $0x10,%esp
  401ad2:	eb de                	jmp    401ab2 <readline+0xdb>

00401ad4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  401ad4:	55                   	push   %ebp
  401ad5:	89 e5                	mov    %esp,%ebp
  401ad7:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  401ada:	b8 00 00 00 00       	mov    $0x0,%eax
  401adf:	eb 03                	jmp    401ae4 <strlen+0x10>
		n++;
  401ae1:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  401ae4:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  401ae8:	75 f7                	jne    401ae1 <strlen+0xd>
	return n;
}
  401aea:	5d                   	pop    %ebp
  401aeb:	c3                   	ret    

00401aec <strnlen>:

int
strnlen(const char *s, size_t size)
{
  401aec:	55                   	push   %ebp
  401aed:	89 e5                	mov    %esp,%ebp
  401aef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  401af2:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  401af5:	b8 00 00 00 00       	mov    $0x0,%eax
  401afa:	eb 03                	jmp    401aff <strnlen+0x13>
		n++;
  401afc:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  401aff:	39 d0                	cmp    %edx,%eax
  401b01:	74 06                	je     401b09 <strnlen+0x1d>
  401b03:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  401b07:	75 f3                	jne    401afc <strnlen+0x10>
	return n;
}
  401b09:	5d                   	pop    %ebp
  401b0a:	c3                   	ret    

00401b0b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  401b0b:	55                   	push   %ebp
  401b0c:	89 e5                	mov    %esp,%ebp
  401b0e:	53                   	push   %ebx
  401b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  401b12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  401b15:	89 c2                	mov    %eax,%edx
  401b17:	83 c1 01             	add    $0x1,%ecx
  401b1a:	83 c2 01             	add    $0x1,%edx
  401b1d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  401b21:	88 5a ff             	mov    %bl,-0x1(%edx)
  401b24:	84 db                	test   %bl,%bl
  401b26:	75 ef                	jne    401b17 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  401b28:	5b                   	pop    %ebx
  401b29:	5d                   	pop    %ebp
  401b2a:	c3                   	ret    

00401b2b <strcat>:

char *
strcat(char *dst, const char *src)
{
  401b2b:	55                   	push   %ebp
  401b2c:	89 e5                	mov    %esp,%ebp
  401b2e:	53                   	push   %ebx
  401b2f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  401b32:	53                   	push   %ebx
  401b33:	e8 9c ff ff ff       	call   401ad4 <strlen>
  401b38:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  401b3b:	ff 75 0c             	pushl  0xc(%ebp)
  401b3e:	01 d8                	add    %ebx,%eax
  401b40:	50                   	push   %eax
  401b41:	e8 c5 ff ff ff       	call   401b0b <strcpy>
	return dst;
}
  401b46:	89 d8                	mov    %ebx,%eax
  401b48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  401b4b:	c9                   	leave  
  401b4c:	c3                   	ret    

00401b4d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  401b4d:	55                   	push   %ebp
  401b4e:	89 e5                	mov    %esp,%ebp
  401b50:	56                   	push   %esi
  401b51:	53                   	push   %ebx
  401b52:	8b 75 08             	mov    0x8(%ebp),%esi
  401b55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  401b58:	89 f3                	mov    %esi,%ebx
  401b5a:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  401b5d:	89 f2                	mov    %esi,%edx
  401b5f:	eb 0f                	jmp    401b70 <strncpy+0x23>
		*dst++ = *src;
  401b61:	83 c2 01             	add    $0x1,%edx
  401b64:	0f b6 01             	movzbl (%ecx),%eax
  401b67:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  401b6a:	80 39 01             	cmpb   $0x1,(%ecx)
  401b6d:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  401b70:	39 da                	cmp    %ebx,%edx
  401b72:	75 ed                	jne    401b61 <strncpy+0x14>
	}
	return ret;
}
  401b74:	89 f0                	mov    %esi,%eax
  401b76:	5b                   	pop    %ebx
  401b77:	5e                   	pop    %esi
  401b78:	5d                   	pop    %ebp
  401b79:	c3                   	ret    

00401b7a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  401b7a:	55                   	push   %ebp
  401b7b:	89 e5                	mov    %esp,%ebp
  401b7d:	56                   	push   %esi
  401b7e:	53                   	push   %ebx
  401b7f:	8b 75 08             	mov    0x8(%ebp),%esi
  401b82:	8b 55 0c             	mov    0xc(%ebp),%edx
  401b85:	8b 4d 10             	mov    0x10(%ebp),%ecx
  401b88:	89 f0                	mov    %esi,%eax
  401b8a:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  401b8e:	85 c9                	test   %ecx,%ecx
  401b90:	75 0b                	jne    401b9d <strlcpy+0x23>
  401b92:	eb 17                	jmp    401bab <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  401b94:	83 c2 01             	add    $0x1,%edx
  401b97:	83 c0 01             	add    $0x1,%eax
  401b9a:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  401b9d:	39 d8                	cmp    %ebx,%eax
  401b9f:	74 07                	je     401ba8 <strlcpy+0x2e>
  401ba1:	0f b6 0a             	movzbl (%edx),%ecx
  401ba4:	84 c9                	test   %cl,%cl
  401ba6:	75 ec                	jne    401b94 <strlcpy+0x1a>
		*dst = '\0';
  401ba8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  401bab:	29 f0                	sub    %esi,%eax
}
  401bad:	5b                   	pop    %ebx
  401bae:	5e                   	pop    %esi
  401baf:	5d                   	pop    %ebp
  401bb0:	c3                   	ret    

00401bb1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  401bb1:	55                   	push   %ebp
  401bb2:	89 e5                	mov    %esp,%ebp
  401bb4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  401bb7:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  401bba:	eb 06                	jmp    401bc2 <strcmp+0x11>
		p++, q++;
  401bbc:	83 c1 01             	add    $0x1,%ecx
  401bbf:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  401bc2:	0f b6 01             	movzbl (%ecx),%eax
  401bc5:	84 c0                	test   %al,%al
  401bc7:	74 04                	je     401bcd <strcmp+0x1c>
  401bc9:	3a 02                	cmp    (%edx),%al
  401bcb:	74 ef                	je     401bbc <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  401bcd:	0f b6 c0             	movzbl %al,%eax
  401bd0:	0f b6 12             	movzbl (%edx),%edx
  401bd3:	29 d0                	sub    %edx,%eax
}
  401bd5:	5d                   	pop    %ebp
  401bd6:	c3                   	ret    

00401bd7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  401bd7:	55                   	push   %ebp
  401bd8:	89 e5                	mov    %esp,%ebp
  401bda:	53                   	push   %ebx
  401bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  401bde:	8b 55 0c             	mov    0xc(%ebp),%edx
  401be1:	89 c3                	mov    %eax,%ebx
  401be3:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  401be6:	eb 06                	jmp    401bee <strncmp+0x17>
		n--, p++, q++;
  401be8:	83 c0 01             	add    $0x1,%eax
  401beb:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  401bee:	39 d8                	cmp    %ebx,%eax
  401bf0:	74 16                	je     401c08 <strncmp+0x31>
  401bf2:	0f b6 08             	movzbl (%eax),%ecx
  401bf5:	84 c9                	test   %cl,%cl
  401bf7:	74 04                	je     401bfd <strncmp+0x26>
  401bf9:	3a 0a                	cmp    (%edx),%cl
  401bfb:	74 eb                	je     401be8 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  401bfd:	0f b6 00             	movzbl (%eax),%eax
  401c00:	0f b6 12             	movzbl (%edx),%edx
  401c03:	29 d0                	sub    %edx,%eax
}
  401c05:	5b                   	pop    %ebx
  401c06:	5d                   	pop    %ebp
  401c07:	c3                   	ret    
		return 0;
  401c08:	b8 00 00 00 00       	mov    $0x0,%eax
  401c0d:	eb f6                	jmp    401c05 <strncmp+0x2e>

00401c0f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  401c0f:	55                   	push   %ebp
  401c10:	89 e5                	mov    %esp,%ebp
  401c12:	8b 45 08             	mov    0x8(%ebp),%eax
  401c15:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  401c19:	0f b6 10             	movzbl (%eax),%edx
  401c1c:	84 d2                	test   %dl,%dl
  401c1e:	74 09                	je     401c29 <strchr+0x1a>
		if (*s == c)
  401c20:	38 ca                	cmp    %cl,%dl
  401c22:	74 0a                	je     401c2e <strchr+0x1f>
	for (; *s; s++)
  401c24:	83 c0 01             	add    $0x1,%eax
  401c27:	eb f0                	jmp    401c19 <strchr+0xa>
			return (char *) s;
	return 0;
  401c29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  401c2e:	5d                   	pop    %ebp
  401c2f:	c3                   	ret    

00401c30 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  401c30:	55                   	push   %ebp
  401c31:	89 e5                	mov    %esp,%ebp
  401c33:	8b 45 08             	mov    0x8(%ebp),%eax
  401c36:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  401c3a:	eb 03                	jmp    401c3f <strfind+0xf>
  401c3c:	83 c0 01             	add    $0x1,%eax
  401c3f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  401c42:	38 ca                	cmp    %cl,%dl
  401c44:	74 04                	je     401c4a <strfind+0x1a>
  401c46:	84 d2                	test   %dl,%dl
  401c48:	75 f2                	jne    401c3c <strfind+0xc>
			break;
	return (char *) s;
}
  401c4a:	5d                   	pop    %ebp
  401c4b:	c3                   	ret    

00401c4c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  401c4c:	55                   	push   %ebp
  401c4d:	89 e5                	mov    %esp,%ebp
  401c4f:	57                   	push   %edi
  401c50:	56                   	push   %esi
  401c51:	53                   	push   %ebx
  401c52:	8b 7d 08             	mov    0x8(%ebp),%edi
  401c55:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  401c58:	85 c9                	test   %ecx,%ecx
  401c5a:	74 13                	je     401c6f <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  401c5c:	f7 c7 03 00 00 00    	test   $0x3,%edi
  401c62:	75 05                	jne    401c69 <memset+0x1d>
  401c64:	f6 c1 03             	test   $0x3,%cl
  401c67:	74 0d                	je     401c76 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  401c69:	8b 45 0c             	mov    0xc(%ebp),%eax
  401c6c:	fc                   	cld    
  401c6d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  401c6f:	89 f8                	mov    %edi,%eax
  401c71:	5b                   	pop    %ebx
  401c72:	5e                   	pop    %esi
  401c73:	5f                   	pop    %edi
  401c74:	5d                   	pop    %ebp
  401c75:	c3                   	ret    
		c &= 0xFF;
  401c76:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  401c7a:	89 d3                	mov    %edx,%ebx
  401c7c:	c1 e3 08             	shl    $0x8,%ebx
  401c7f:	89 d0                	mov    %edx,%eax
  401c81:	c1 e0 18             	shl    $0x18,%eax
  401c84:	89 d6                	mov    %edx,%esi
  401c86:	c1 e6 10             	shl    $0x10,%esi
  401c89:	09 f0                	or     %esi,%eax
  401c8b:	09 c2                	or     %eax,%edx
  401c8d:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  401c8f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  401c92:	89 d0                	mov    %edx,%eax
  401c94:	fc                   	cld    
  401c95:	f3 ab                	rep stos %eax,%es:(%edi)
  401c97:	eb d6                	jmp    401c6f <memset+0x23>

00401c99 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  401c99:	55                   	push   %ebp
  401c9a:	89 e5                	mov    %esp,%ebp
  401c9c:	57                   	push   %edi
  401c9d:	56                   	push   %esi
  401c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  401ca1:	8b 75 0c             	mov    0xc(%ebp),%esi
  401ca4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  401ca7:	39 c6                	cmp    %eax,%esi
  401ca9:	73 35                	jae    401ce0 <memmove+0x47>
  401cab:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  401cae:	39 c2                	cmp    %eax,%edx
  401cb0:	76 2e                	jbe    401ce0 <memmove+0x47>
		s += n;
		d += n;
  401cb2:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  401cb5:	89 d6                	mov    %edx,%esi
  401cb7:	09 fe                	or     %edi,%esi
  401cb9:	f7 c6 03 00 00 00    	test   $0x3,%esi
  401cbf:	74 0c                	je     401ccd <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  401cc1:	83 ef 01             	sub    $0x1,%edi
  401cc4:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  401cc7:	fd                   	std    
  401cc8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  401cca:	fc                   	cld    
  401ccb:	eb 21                	jmp    401cee <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  401ccd:	f6 c1 03             	test   $0x3,%cl
  401cd0:	75 ef                	jne    401cc1 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  401cd2:	83 ef 04             	sub    $0x4,%edi
  401cd5:	8d 72 fc             	lea    -0x4(%edx),%esi
  401cd8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  401cdb:	fd                   	std    
  401cdc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  401cde:	eb ea                	jmp    401cca <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  401ce0:	89 f2                	mov    %esi,%edx
  401ce2:	09 c2                	or     %eax,%edx
  401ce4:	f6 c2 03             	test   $0x3,%dl
  401ce7:	74 09                	je     401cf2 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  401ce9:	89 c7                	mov    %eax,%edi
  401ceb:	fc                   	cld    
  401cec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  401cee:	5e                   	pop    %esi
  401cef:	5f                   	pop    %edi
  401cf0:	5d                   	pop    %ebp
  401cf1:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  401cf2:	f6 c1 03             	test   $0x3,%cl
  401cf5:	75 f2                	jne    401ce9 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  401cf7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  401cfa:	89 c7                	mov    %eax,%edi
  401cfc:	fc                   	cld    
  401cfd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  401cff:	eb ed                	jmp    401cee <memmove+0x55>

00401d01 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  401d01:	55                   	push   %ebp
  401d02:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  401d04:	ff 75 10             	pushl  0x10(%ebp)
  401d07:	ff 75 0c             	pushl  0xc(%ebp)
  401d0a:	ff 75 08             	pushl  0x8(%ebp)
  401d0d:	e8 87 ff ff ff       	call   401c99 <memmove>
}
  401d12:	c9                   	leave  
  401d13:	c3                   	ret    

00401d14 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  401d14:	55                   	push   %ebp
  401d15:	89 e5                	mov    %esp,%ebp
  401d17:	56                   	push   %esi
  401d18:	53                   	push   %ebx
  401d19:	8b 45 08             	mov    0x8(%ebp),%eax
  401d1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  401d1f:	89 c6                	mov    %eax,%esi
  401d21:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  401d24:	39 f0                	cmp    %esi,%eax
  401d26:	74 1c                	je     401d44 <memcmp+0x30>
		if (*s1 != *s2)
  401d28:	0f b6 08             	movzbl (%eax),%ecx
  401d2b:	0f b6 1a             	movzbl (%edx),%ebx
  401d2e:	38 d9                	cmp    %bl,%cl
  401d30:	75 08                	jne    401d3a <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  401d32:	83 c0 01             	add    $0x1,%eax
  401d35:	83 c2 01             	add    $0x1,%edx
  401d38:	eb ea                	jmp    401d24 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  401d3a:	0f b6 c1             	movzbl %cl,%eax
  401d3d:	0f b6 db             	movzbl %bl,%ebx
  401d40:	29 d8                	sub    %ebx,%eax
  401d42:	eb 05                	jmp    401d49 <memcmp+0x35>
	}

	return 0;
  401d44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  401d49:	5b                   	pop    %ebx
  401d4a:	5e                   	pop    %esi
  401d4b:	5d                   	pop    %ebp
  401d4c:	c3                   	ret    

00401d4d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  401d4d:	55                   	push   %ebp
  401d4e:	89 e5                	mov    %esp,%ebp
  401d50:	8b 45 08             	mov    0x8(%ebp),%eax
  401d53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  401d56:	89 c2                	mov    %eax,%edx
  401d58:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  401d5b:	39 d0                	cmp    %edx,%eax
  401d5d:	73 09                	jae    401d68 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  401d5f:	38 08                	cmp    %cl,(%eax)
  401d61:	74 05                	je     401d68 <memfind+0x1b>
	for (; s < ends; s++)
  401d63:	83 c0 01             	add    $0x1,%eax
  401d66:	eb f3                	jmp    401d5b <memfind+0xe>
			break;
	return (void *) s;
}
  401d68:	5d                   	pop    %ebp
  401d69:	c3                   	ret    

00401d6a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  401d6a:	55                   	push   %ebp
  401d6b:	89 e5                	mov    %esp,%ebp
  401d6d:	57                   	push   %edi
  401d6e:	56                   	push   %esi
  401d6f:	53                   	push   %ebx
  401d70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  401d73:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  401d76:	eb 03                	jmp    401d7b <strtol+0x11>
		s++;
  401d78:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  401d7b:	0f b6 01             	movzbl (%ecx),%eax
  401d7e:	3c 20                	cmp    $0x20,%al
  401d80:	74 f6                	je     401d78 <strtol+0xe>
  401d82:	3c 09                	cmp    $0x9,%al
  401d84:	74 f2                	je     401d78 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  401d86:	3c 2b                	cmp    $0x2b,%al
  401d88:	74 2e                	je     401db8 <strtol+0x4e>
	int neg = 0;
  401d8a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  401d8f:	3c 2d                	cmp    $0x2d,%al
  401d91:	74 2f                	je     401dc2 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  401d93:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  401d99:	75 05                	jne    401da0 <strtol+0x36>
  401d9b:	80 39 30             	cmpb   $0x30,(%ecx)
  401d9e:	74 2c                	je     401dcc <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  401da0:	85 db                	test   %ebx,%ebx
  401da2:	75 0a                	jne    401dae <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  401da4:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  401da9:	80 39 30             	cmpb   $0x30,(%ecx)
  401dac:	74 28                	je     401dd6 <strtol+0x6c>
		base = 10;
  401dae:	b8 00 00 00 00       	mov    $0x0,%eax
  401db3:	89 5d 10             	mov    %ebx,0x10(%ebp)
  401db6:	eb 50                	jmp    401e08 <strtol+0x9e>
		s++;
  401db8:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  401dbb:	bf 00 00 00 00       	mov    $0x0,%edi
  401dc0:	eb d1                	jmp    401d93 <strtol+0x29>
		s++, neg = 1;
  401dc2:	83 c1 01             	add    $0x1,%ecx
  401dc5:	bf 01 00 00 00       	mov    $0x1,%edi
  401dca:	eb c7                	jmp    401d93 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  401dcc:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  401dd0:	74 0e                	je     401de0 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  401dd2:	85 db                	test   %ebx,%ebx
  401dd4:	75 d8                	jne    401dae <strtol+0x44>
		s++, base = 8;
  401dd6:	83 c1 01             	add    $0x1,%ecx
  401dd9:	bb 08 00 00 00       	mov    $0x8,%ebx
  401dde:	eb ce                	jmp    401dae <strtol+0x44>
		s += 2, base = 16;
  401de0:	83 c1 02             	add    $0x2,%ecx
  401de3:	bb 10 00 00 00       	mov    $0x10,%ebx
  401de8:	eb c4                	jmp    401dae <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  401dea:	8d 72 9f             	lea    -0x61(%edx),%esi
  401ded:	89 f3                	mov    %esi,%ebx
  401def:	80 fb 19             	cmp    $0x19,%bl
  401df2:	77 29                	ja     401e1d <strtol+0xb3>
			dig = *s - 'a' + 10;
  401df4:	0f be d2             	movsbl %dl,%edx
  401df7:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  401dfa:	3b 55 10             	cmp    0x10(%ebp),%edx
  401dfd:	7d 30                	jge    401e2f <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  401dff:	83 c1 01             	add    $0x1,%ecx
  401e02:	0f af 45 10          	imul   0x10(%ebp),%eax
  401e06:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  401e08:	0f b6 11             	movzbl (%ecx),%edx
  401e0b:	8d 72 d0             	lea    -0x30(%edx),%esi
  401e0e:	89 f3                	mov    %esi,%ebx
  401e10:	80 fb 09             	cmp    $0x9,%bl
  401e13:	77 d5                	ja     401dea <strtol+0x80>
			dig = *s - '0';
  401e15:	0f be d2             	movsbl %dl,%edx
  401e18:	83 ea 30             	sub    $0x30,%edx
  401e1b:	eb dd                	jmp    401dfa <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  401e1d:	8d 72 bf             	lea    -0x41(%edx),%esi
  401e20:	89 f3                	mov    %esi,%ebx
  401e22:	80 fb 19             	cmp    $0x19,%bl
  401e25:	77 08                	ja     401e2f <strtol+0xc5>
			dig = *s - 'A' + 10;
  401e27:	0f be d2             	movsbl %dl,%edx
  401e2a:	83 ea 37             	sub    $0x37,%edx
  401e2d:	eb cb                	jmp    401dfa <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  401e2f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  401e33:	74 05                	je     401e3a <strtol+0xd0>
		*endptr = (char *) s;
  401e35:	8b 75 0c             	mov    0xc(%ebp),%esi
  401e38:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  401e3a:	89 c2                	mov    %eax,%edx
  401e3c:	f7 da                	neg    %edx
  401e3e:	85 ff                	test   %edi,%edi
  401e40:	0f 45 c2             	cmovne %edx,%eax
}
  401e43:	5b                   	pop    %ebx
  401e44:	5e                   	pop    %esi
  401e45:	5f                   	pop    %edi
  401e46:	5d                   	pop    %ebp
  401e47:	c3                   	ret    
  401e48:	66 90                	xchg   %ax,%ax
  401e4a:	66 90                	xchg   %ax,%ax
  401e4c:	66 90                	xchg   %ax,%ax
  401e4e:	66 90                	xchg   %ax,%ax

00401e50 <__udivdi3>:
  401e50:	55                   	push   %ebp
  401e51:	57                   	push   %edi
  401e52:	56                   	push   %esi
  401e53:	53                   	push   %ebx
  401e54:	83 ec 1c             	sub    $0x1c,%esp
  401e57:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  401e5b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  401e5f:	8b 74 24 34          	mov    0x34(%esp),%esi
  401e63:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  401e67:	85 d2                	test   %edx,%edx
  401e69:	75 35                	jne    401ea0 <__udivdi3+0x50>
  401e6b:	39 f3                	cmp    %esi,%ebx
  401e6d:	0f 87 bd 00 00 00    	ja     401f30 <__udivdi3+0xe0>
  401e73:	85 db                	test   %ebx,%ebx
  401e75:	89 d9                	mov    %ebx,%ecx
  401e77:	75 0b                	jne    401e84 <__udivdi3+0x34>
  401e79:	b8 01 00 00 00       	mov    $0x1,%eax
  401e7e:	31 d2                	xor    %edx,%edx
  401e80:	f7 f3                	div    %ebx
  401e82:	89 c1                	mov    %eax,%ecx
  401e84:	31 d2                	xor    %edx,%edx
  401e86:	89 f0                	mov    %esi,%eax
  401e88:	f7 f1                	div    %ecx
  401e8a:	89 c6                	mov    %eax,%esi
  401e8c:	89 e8                	mov    %ebp,%eax
  401e8e:	89 f7                	mov    %esi,%edi
  401e90:	f7 f1                	div    %ecx
  401e92:	89 fa                	mov    %edi,%edx
  401e94:	83 c4 1c             	add    $0x1c,%esp
  401e97:	5b                   	pop    %ebx
  401e98:	5e                   	pop    %esi
  401e99:	5f                   	pop    %edi
  401e9a:	5d                   	pop    %ebp
  401e9b:	c3                   	ret    
  401e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  401ea0:	39 f2                	cmp    %esi,%edx
  401ea2:	77 7c                	ja     401f20 <__udivdi3+0xd0>
  401ea4:	0f bd fa             	bsr    %edx,%edi
  401ea7:	83 f7 1f             	xor    $0x1f,%edi
  401eaa:	0f 84 98 00 00 00    	je     401f48 <__udivdi3+0xf8>
  401eb0:	89 f9                	mov    %edi,%ecx
  401eb2:	b8 20 00 00 00       	mov    $0x20,%eax
  401eb7:	29 f8                	sub    %edi,%eax
  401eb9:	d3 e2                	shl    %cl,%edx
  401ebb:	89 54 24 08          	mov    %edx,0x8(%esp)
  401ebf:	89 c1                	mov    %eax,%ecx
  401ec1:	89 da                	mov    %ebx,%edx
  401ec3:	d3 ea                	shr    %cl,%edx
  401ec5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  401ec9:	09 d1                	or     %edx,%ecx
  401ecb:	89 f2                	mov    %esi,%edx
  401ecd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  401ed1:	89 f9                	mov    %edi,%ecx
  401ed3:	d3 e3                	shl    %cl,%ebx
  401ed5:	89 c1                	mov    %eax,%ecx
  401ed7:	d3 ea                	shr    %cl,%edx
  401ed9:	89 f9                	mov    %edi,%ecx
  401edb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  401edf:	d3 e6                	shl    %cl,%esi
  401ee1:	89 eb                	mov    %ebp,%ebx
  401ee3:	89 c1                	mov    %eax,%ecx
  401ee5:	d3 eb                	shr    %cl,%ebx
  401ee7:	09 de                	or     %ebx,%esi
  401ee9:	89 f0                	mov    %esi,%eax
  401eeb:	f7 74 24 08          	divl   0x8(%esp)
  401eef:	89 d6                	mov    %edx,%esi
  401ef1:	89 c3                	mov    %eax,%ebx
  401ef3:	f7 64 24 0c          	mull   0xc(%esp)
  401ef7:	39 d6                	cmp    %edx,%esi
  401ef9:	72 0c                	jb     401f07 <__udivdi3+0xb7>
  401efb:	89 f9                	mov    %edi,%ecx
  401efd:	d3 e5                	shl    %cl,%ebp
  401eff:	39 c5                	cmp    %eax,%ebp
  401f01:	73 5d                	jae    401f60 <__udivdi3+0x110>
  401f03:	39 d6                	cmp    %edx,%esi
  401f05:	75 59                	jne    401f60 <__udivdi3+0x110>
  401f07:	8d 43 ff             	lea    -0x1(%ebx),%eax
  401f0a:	31 ff                	xor    %edi,%edi
  401f0c:	89 fa                	mov    %edi,%edx
  401f0e:	83 c4 1c             	add    $0x1c,%esp
  401f11:	5b                   	pop    %ebx
  401f12:	5e                   	pop    %esi
  401f13:	5f                   	pop    %edi
  401f14:	5d                   	pop    %ebp
  401f15:	c3                   	ret    
  401f16:	8d 76 00             	lea    0x0(%esi),%esi
  401f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  401f20:	31 ff                	xor    %edi,%edi
  401f22:	31 c0                	xor    %eax,%eax
  401f24:	89 fa                	mov    %edi,%edx
  401f26:	83 c4 1c             	add    $0x1c,%esp
  401f29:	5b                   	pop    %ebx
  401f2a:	5e                   	pop    %esi
  401f2b:	5f                   	pop    %edi
  401f2c:	5d                   	pop    %ebp
  401f2d:	c3                   	ret    
  401f2e:	66 90                	xchg   %ax,%ax
  401f30:	31 ff                	xor    %edi,%edi
  401f32:	89 e8                	mov    %ebp,%eax
  401f34:	89 f2                	mov    %esi,%edx
  401f36:	f7 f3                	div    %ebx
  401f38:	89 fa                	mov    %edi,%edx
  401f3a:	83 c4 1c             	add    $0x1c,%esp
  401f3d:	5b                   	pop    %ebx
  401f3e:	5e                   	pop    %esi
  401f3f:	5f                   	pop    %edi
  401f40:	5d                   	pop    %ebp
  401f41:	c3                   	ret    
  401f42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  401f48:	39 f2                	cmp    %esi,%edx
  401f4a:	72 06                	jb     401f52 <__udivdi3+0x102>
  401f4c:	31 c0                	xor    %eax,%eax
  401f4e:	39 eb                	cmp    %ebp,%ebx
  401f50:	77 d2                	ja     401f24 <__udivdi3+0xd4>
  401f52:	b8 01 00 00 00       	mov    $0x1,%eax
  401f57:	eb cb                	jmp    401f24 <__udivdi3+0xd4>
  401f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  401f60:	89 d8                	mov    %ebx,%eax
  401f62:	31 ff                	xor    %edi,%edi
  401f64:	eb be                	jmp    401f24 <__udivdi3+0xd4>
  401f66:	66 90                	xchg   %ax,%ax
  401f68:	66 90                	xchg   %ax,%ax
  401f6a:	66 90                	xchg   %ax,%ax
  401f6c:	66 90                	xchg   %ax,%ax
  401f6e:	66 90                	xchg   %ax,%ax

00401f70 <__umoddi3>:
  401f70:	55                   	push   %ebp
  401f71:	57                   	push   %edi
  401f72:	56                   	push   %esi
  401f73:	53                   	push   %ebx
  401f74:	83 ec 1c             	sub    $0x1c,%esp
  401f77:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  401f7b:	8b 74 24 30          	mov    0x30(%esp),%esi
  401f7f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  401f83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  401f87:	85 ed                	test   %ebp,%ebp
  401f89:	89 f0                	mov    %esi,%eax
  401f8b:	89 da                	mov    %ebx,%edx
  401f8d:	75 19                	jne    401fa8 <__umoddi3+0x38>
  401f8f:	39 df                	cmp    %ebx,%edi
  401f91:	0f 86 b1 00 00 00    	jbe    402048 <__umoddi3+0xd8>
  401f97:	f7 f7                	div    %edi
  401f99:	89 d0                	mov    %edx,%eax
  401f9b:	31 d2                	xor    %edx,%edx
  401f9d:	83 c4 1c             	add    $0x1c,%esp
  401fa0:	5b                   	pop    %ebx
  401fa1:	5e                   	pop    %esi
  401fa2:	5f                   	pop    %edi
  401fa3:	5d                   	pop    %ebp
  401fa4:	c3                   	ret    
  401fa5:	8d 76 00             	lea    0x0(%esi),%esi
  401fa8:	39 dd                	cmp    %ebx,%ebp
  401faa:	77 f1                	ja     401f9d <__umoddi3+0x2d>
  401fac:	0f bd cd             	bsr    %ebp,%ecx
  401faf:	83 f1 1f             	xor    $0x1f,%ecx
  401fb2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  401fb6:	0f 84 b4 00 00 00    	je     402070 <__umoddi3+0x100>
  401fbc:	b8 20 00 00 00       	mov    $0x20,%eax
  401fc1:	89 c2                	mov    %eax,%edx
  401fc3:	8b 44 24 04          	mov    0x4(%esp),%eax
  401fc7:	29 c2                	sub    %eax,%edx
  401fc9:	89 c1                	mov    %eax,%ecx
  401fcb:	89 f8                	mov    %edi,%eax
  401fcd:	d3 e5                	shl    %cl,%ebp
  401fcf:	89 d1                	mov    %edx,%ecx
  401fd1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  401fd5:	d3 e8                	shr    %cl,%eax
  401fd7:	09 c5                	or     %eax,%ebp
  401fd9:	8b 44 24 04          	mov    0x4(%esp),%eax
  401fdd:	89 c1                	mov    %eax,%ecx
  401fdf:	d3 e7                	shl    %cl,%edi
  401fe1:	89 d1                	mov    %edx,%ecx
  401fe3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  401fe7:	89 df                	mov    %ebx,%edi
  401fe9:	d3 ef                	shr    %cl,%edi
  401feb:	89 c1                	mov    %eax,%ecx
  401fed:	89 f0                	mov    %esi,%eax
  401fef:	d3 e3                	shl    %cl,%ebx
  401ff1:	89 d1                	mov    %edx,%ecx
  401ff3:	89 fa                	mov    %edi,%edx
  401ff5:	d3 e8                	shr    %cl,%eax
  401ff7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  401ffc:	09 d8                	or     %ebx,%eax
  401ffe:	f7 f5                	div    %ebp
  402000:	d3 e6                	shl    %cl,%esi
  402002:	89 d1                	mov    %edx,%ecx
  402004:	f7 64 24 08          	mull   0x8(%esp)
  402008:	39 d1                	cmp    %edx,%ecx
  40200a:	89 c3                	mov    %eax,%ebx
  40200c:	89 d7                	mov    %edx,%edi
  40200e:	72 06                	jb     402016 <__umoddi3+0xa6>
  402010:	75 0e                	jne    402020 <__umoddi3+0xb0>
  402012:	39 c6                	cmp    %eax,%esi
  402014:	73 0a                	jae    402020 <__umoddi3+0xb0>
  402016:	2b 44 24 08          	sub    0x8(%esp),%eax
  40201a:	19 ea                	sbb    %ebp,%edx
  40201c:	89 d7                	mov    %edx,%edi
  40201e:	89 c3                	mov    %eax,%ebx
  402020:	89 ca                	mov    %ecx,%edx
  402022:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  402027:	29 de                	sub    %ebx,%esi
  402029:	19 fa                	sbb    %edi,%edx
  40202b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  40202f:	89 d0                	mov    %edx,%eax
  402031:	d3 e0                	shl    %cl,%eax
  402033:	89 d9                	mov    %ebx,%ecx
  402035:	d3 ee                	shr    %cl,%esi
  402037:	d3 ea                	shr    %cl,%edx
  402039:	09 f0                	or     %esi,%eax
  40203b:	83 c4 1c             	add    $0x1c,%esp
  40203e:	5b                   	pop    %ebx
  40203f:	5e                   	pop    %esi
  402040:	5f                   	pop    %edi
  402041:	5d                   	pop    %ebp
  402042:	c3                   	ret    
  402043:	90                   	nop
  402044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  402048:	85 ff                	test   %edi,%edi
  40204a:	89 f9                	mov    %edi,%ecx
  40204c:	75 0b                	jne    402059 <__umoddi3+0xe9>
  40204e:	b8 01 00 00 00       	mov    $0x1,%eax
  402053:	31 d2                	xor    %edx,%edx
  402055:	f7 f7                	div    %edi
  402057:	89 c1                	mov    %eax,%ecx
  402059:	89 d8                	mov    %ebx,%eax
  40205b:	31 d2                	xor    %edx,%edx
  40205d:	f7 f1                	div    %ecx
  40205f:	89 f0                	mov    %esi,%eax
  402061:	f7 f1                	div    %ecx
  402063:	e9 31 ff ff ff       	jmp    401f99 <__umoddi3+0x29>
  402068:	90                   	nop
  402069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  402070:	39 dd                	cmp    %ebx,%ebp
  402072:	72 08                	jb     40207c <__umoddi3+0x10c>
  402074:	39 f7                	cmp    %esi,%edi
  402076:	0f 87 21 ff ff ff    	ja     401f9d <__umoddi3+0x2d>
  40207c:	89 da                	mov    %ebx,%edx
  40207e:	89 f0                	mov    %esi,%eax
  402080:	29 f8                	sub    %edi,%eax
  402082:	19 ea                	sbb    %ebp,%edx
  402084:	e9 14 ff ff ff       	jmp    401f9d <__umoddi3+0x2d>
