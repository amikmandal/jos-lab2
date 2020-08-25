
obj/user/test2:     file format elf32-i386


Disassembly of section .text:

00800020 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800020:	55                   	push   %ebp
  800021:	89 e5                	mov    %esp,%ebp
  800023:	53                   	push   %ebx
  800024:	83 ec 04             	sub    $0x4,%esp
  800027:	e8 16 00 00 00       	call   800042 <__x86.get_pc_thunk.bx>
  80002c:	81 c3 d4 1f 00 00    	add    $0x1fd4,%ebx
	sys_test();
  800032:	e8 e0 00 00 00       	call   800117 <sys_test>
	exit();
  800037:	e8 0a 00 00 00       	call   800046 <exit>
}
  80003c:	83 c4 04             	add    $0x4,%esp
  80003f:	5b                   	pop    %ebx
  800040:	5d                   	pop    %ebp
  800041:	c3                   	ret    

00800042 <__x86.get_pc_thunk.bx>:
  800042:	8b 1c 24             	mov    (%esp),%ebx
  800045:	c3                   	ret    

00800046 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800046:	55                   	push   %ebp
  800047:	89 e5                	mov    %esp,%ebp
  800049:	53                   	push   %ebx
  80004a:	83 ec 10             	sub    $0x10,%esp
  80004d:	e8 f0 ff ff ff       	call   800042 <__x86.get_pc_thunk.bx>
  800052:	81 c3 ae 1f 00 00    	add    $0x1fae,%ebx
	sys_env_destroy(0);
  800058:	6a 00                	push   $0x0
  80005a:	e8 45 00 00 00       	call   8000a4 <sys_env_destroy>
}
  80005f:	83 c4 10             	add    $0x10,%esp
  800062:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800065:	c9                   	leave  
  800066:	c3                   	ret    

00800067 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800067:	55                   	push   %ebp
  800068:	89 e5                	mov    %esp,%ebp
  80006a:	57                   	push   %edi
  80006b:	56                   	push   %esi
  80006c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80006d:	b8 00 00 00 00       	mov    $0x0,%eax
  800072:	8b 55 08             	mov    0x8(%ebp),%edx
  800075:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800078:	89 c3                	mov    %eax,%ebx
  80007a:	89 c7                	mov    %eax,%edi
  80007c:	89 c6                	mov    %eax,%esi
  80007e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800080:	5b                   	pop    %ebx
  800081:	5e                   	pop    %esi
  800082:	5f                   	pop    %edi
  800083:	5d                   	pop    %ebp
  800084:	c3                   	ret    

00800085 <sys_cgetc>:

int
sys_cgetc(void)
{
  800085:	55                   	push   %ebp
  800086:	89 e5                	mov    %esp,%ebp
  800088:	57                   	push   %edi
  800089:	56                   	push   %esi
  80008a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80008b:	ba 00 00 00 00       	mov    $0x0,%edx
  800090:	b8 01 00 00 00       	mov    $0x1,%eax
  800095:	89 d1                	mov    %edx,%ecx
  800097:	89 d3                	mov    %edx,%ebx
  800099:	89 d7                	mov    %edx,%edi
  80009b:	89 d6                	mov    %edx,%esi
  80009d:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80009f:	5b                   	pop    %ebx
  8000a0:	5e                   	pop    %esi
  8000a1:	5f                   	pop    %edi
  8000a2:	5d                   	pop    %ebp
  8000a3:	c3                   	ret    

008000a4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000a4:	55                   	push   %ebp
  8000a5:	89 e5                	mov    %esp,%ebp
  8000a7:	57                   	push   %edi
  8000a8:	56                   	push   %esi
  8000a9:	53                   	push   %ebx
  8000aa:	83 ec 1c             	sub    $0x1c,%esp
  8000ad:	e8 90 ff ff ff       	call   800042 <__x86.get_pc_thunk.bx>
  8000b2:	81 c3 4e 1f 00 00    	add    $0x1f4e,%ebx
  8000b8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
	asm volatile("int %1\n"
  8000bb:	be 00 00 00 00       	mov    $0x0,%esi
  8000c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8000c3:	b8 03 00 00 00       	mov    $0x3,%eax
  8000c8:	89 f1                	mov    %esi,%ecx
  8000ca:	89 f3                	mov    %esi,%ebx
  8000cc:	89 f7                	mov    %esi,%edi
  8000ce:	cd 30                	int    $0x30
  8000d0:	89 c6                	mov    %eax,%esi
	if(check && ret > 0) {
  8000d2:	85 c0                	test   %eax,%eax
  8000d4:	7e 18                	jle    8000ee <sys_env_destroy+0x4a>
		cprintf("syscall %d returned %d (> 0)", num, ret);
  8000d6:	83 ec 04             	sub    $0x4,%esp
  8000d9:	50                   	push   %eax
  8000da:	6a 03                	push   $0x3
  8000dc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8000df:	8d 83 8c ed ff ff    	lea    -0x1274(%ebx),%eax
  8000e5:	50                   	push   %eax
  8000e6:	e8 fc 00 00 00       	call   8001e7 <cprintf>
  8000eb:	83 c4 10             	add    $0x10,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000ee:	89 f0                	mov    %esi,%eax
  8000f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000f3:	5b                   	pop    %ebx
  8000f4:	5e                   	pop    %esi
  8000f5:	5f                   	pop    %edi
  8000f6:	5d                   	pop    %ebp
  8000f7:	c3                   	ret    

008000f8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8000f8:	55                   	push   %ebp
  8000f9:	89 e5                	mov    %esp,%ebp
  8000fb:	57                   	push   %edi
  8000fc:	56                   	push   %esi
  8000fd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800103:	b8 02 00 00 00       	mov    $0x2,%eax
  800108:	89 d1                	mov    %edx,%ecx
  80010a:	89 d3                	mov    %edx,%ebx
  80010c:	89 d7                	mov    %edx,%edi
  80010e:	89 d6                	mov    %edx,%esi
  800110:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800112:	5b                   	pop    %ebx
  800113:	5e                   	pop    %esi
  800114:	5f                   	pop    %edi
  800115:	5d                   	pop    %ebp
  800116:	c3                   	ret    

00800117 <sys_test>:

void
sys_test(void)
{
  800117:	55                   	push   %ebp
  800118:	89 e5                	mov    %esp,%ebp
  80011a:	57                   	push   %edi
  80011b:	56                   	push   %esi
  80011c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80011d:	ba 00 00 00 00       	mov    $0x0,%edx
  800122:	b8 04 00 00 00       	mov    $0x4,%eax
  800127:	89 d1                	mov    %edx,%ecx
  800129:	89 d3                	mov    %edx,%ebx
  80012b:	89 d7                	mov    %edx,%edi
  80012d:	89 d6                	mov    %edx,%esi
  80012f:	cd 30                	int    $0x30
		syscall(SYS_test, 0, 0, 0, 0, 0, 0);
}
  800131:	5b                   	pop    %ebx
  800132:	5e                   	pop    %esi
  800133:	5f                   	pop    %edi
  800134:	5d                   	pop    %ebp
  800135:	c3                   	ret    

00800136 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800136:	55                   	push   %ebp
  800137:	89 e5                	mov    %esp,%ebp
  800139:	56                   	push   %esi
  80013a:	53                   	push   %ebx
  80013b:	e8 02 ff ff ff       	call   800042 <__x86.get_pc_thunk.bx>
  800140:	81 c3 c0 1e 00 00    	add    $0x1ec0,%ebx
  800146:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  800149:	8b 16                	mov    (%esi),%edx
  80014b:	8d 42 01             	lea    0x1(%edx),%eax
  80014e:	89 06                	mov    %eax,(%esi)
  800150:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800153:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  800157:	3d ff 00 00 00       	cmp    $0xff,%eax
  80015c:	74 0b                	je     800169 <putch+0x33>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80015e:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  800162:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800165:	5b                   	pop    %ebx
  800166:	5e                   	pop    %esi
  800167:	5d                   	pop    %ebp
  800168:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800169:	83 ec 08             	sub    $0x8,%esp
  80016c:	68 ff 00 00 00       	push   $0xff
  800171:	8d 46 08             	lea    0x8(%esi),%eax
  800174:	50                   	push   %eax
  800175:	e8 ed fe ff ff       	call   800067 <sys_cputs>
		b->idx = 0;
  80017a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  800180:	83 c4 10             	add    $0x10,%esp
  800183:	eb d9                	jmp    80015e <putch+0x28>

00800185 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800185:	55                   	push   %ebp
  800186:	89 e5                	mov    %esp,%ebp
  800188:	53                   	push   %ebx
  800189:	81 ec 14 01 00 00    	sub    $0x114,%esp
  80018f:	e8 ae fe ff ff       	call   800042 <__x86.get_pc_thunk.bx>
  800194:	81 c3 6c 1e 00 00    	add    $0x1e6c,%ebx
	struct printbuf b;

	b.idx = 0;
  80019a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001a1:	00 00 00 
	b.cnt = 0;
  8001a4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001ab:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001ae:	ff 75 0c             	pushl  0xc(%ebp)
  8001b1:	ff 75 08             	pushl  0x8(%ebp)
  8001b4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001ba:	50                   	push   %eax
  8001bb:	8d 83 36 e1 ff ff    	lea    -0x1eca(%ebx),%eax
  8001c1:	50                   	push   %eax
  8001c2:	e8 38 01 00 00       	call   8002ff <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001c7:	83 c4 08             	add    $0x8,%esp
  8001ca:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001d0:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001d6:	50                   	push   %eax
  8001d7:	e8 8b fe ff ff       	call   800067 <sys_cputs>

	return b.cnt;
}
  8001dc:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001e5:	c9                   	leave  
  8001e6:	c3                   	ret    

008001e7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001e7:	55                   	push   %ebp
  8001e8:	89 e5                	mov    %esp,%ebp
  8001ea:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001ed:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001f0:	50                   	push   %eax
  8001f1:	ff 75 08             	pushl  0x8(%ebp)
  8001f4:	e8 8c ff ff ff       	call   800185 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001f9:	c9                   	leave  
  8001fa:	c3                   	ret    

008001fb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001fb:	55                   	push   %ebp
  8001fc:	89 e5                	mov    %esp,%ebp
  8001fe:	57                   	push   %edi
  8001ff:	56                   	push   %esi
  800200:	53                   	push   %ebx
  800201:	83 ec 2c             	sub    $0x2c,%esp
  800204:	e8 cd 05 00 00       	call   8007d6 <__x86.get_pc_thunk.cx>
  800209:	81 c1 f7 1d 00 00    	add    $0x1df7,%ecx
  80020f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  800212:	89 c7                	mov    %eax,%edi
  800214:	89 d6                	mov    %edx,%esi
  800216:	8b 45 08             	mov    0x8(%ebp),%eax
  800219:	8b 55 0c             	mov    0xc(%ebp),%edx
  80021c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80021f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800222:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800225:	bb 00 00 00 00       	mov    $0x0,%ebx
  80022a:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  80022d:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  800230:	39 d3                	cmp    %edx,%ebx
  800232:	72 09                	jb     80023d <printnum+0x42>
  800234:	39 45 10             	cmp    %eax,0x10(%ebp)
  800237:	0f 87 83 00 00 00    	ja     8002c0 <printnum+0xc5>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80023d:	83 ec 0c             	sub    $0xc,%esp
  800240:	ff 75 18             	pushl  0x18(%ebp)
  800243:	8b 45 14             	mov    0x14(%ebp),%eax
  800246:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800249:	53                   	push   %ebx
  80024a:	ff 75 10             	pushl  0x10(%ebp)
  80024d:	83 ec 08             	sub    $0x8,%esp
  800250:	ff 75 dc             	pushl  -0x24(%ebp)
  800253:	ff 75 d8             	pushl  -0x28(%ebp)
  800256:	ff 75 d4             	pushl  -0x2c(%ebp)
  800259:	ff 75 d0             	pushl  -0x30(%ebp)
  80025c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80025f:	e8 ec 08 00 00       	call   800b50 <__udivdi3>
  800264:	83 c4 18             	add    $0x18,%esp
  800267:	52                   	push   %edx
  800268:	50                   	push   %eax
  800269:	89 f2                	mov    %esi,%edx
  80026b:	89 f8                	mov    %edi,%eax
  80026d:	e8 89 ff ff ff       	call   8001fb <printnum>
  800272:	83 c4 20             	add    $0x20,%esp
  800275:	eb 13                	jmp    80028a <printnum+0x8f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800277:	83 ec 08             	sub    $0x8,%esp
  80027a:	56                   	push   %esi
  80027b:	ff 75 18             	pushl  0x18(%ebp)
  80027e:	ff d7                	call   *%edi
  800280:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800283:	83 eb 01             	sub    $0x1,%ebx
  800286:	85 db                	test   %ebx,%ebx
  800288:	7f ed                	jg     800277 <printnum+0x7c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	56                   	push   %esi
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	ff 75 dc             	pushl  -0x24(%ebp)
  800294:	ff 75 d8             	pushl  -0x28(%ebp)
  800297:	ff 75 d4             	pushl  -0x2c(%ebp)
  80029a:	ff 75 d0             	pushl  -0x30(%ebp)
  80029d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8002a0:	89 f3                	mov    %esi,%ebx
  8002a2:	e8 c9 09 00 00       	call   800c70 <__umoddi3>
  8002a7:	83 c4 14             	add    $0x14,%esp
  8002aa:	0f be 84 06 a9 ed ff 	movsbl -0x1257(%esi,%eax,1),%eax
  8002b1:	ff 
  8002b2:	50                   	push   %eax
  8002b3:	ff d7                	call   *%edi
}
  8002b5:	83 c4 10             	add    $0x10,%esp
  8002b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002bb:	5b                   	pop    %ebx
  8002bc:	5e                   	pop    %esi
  8002bd:	5f                   	pop    %edi
  8002be:	5d                   	pop    %ebp
  8002bf:	c3                   	ret    
  8002c0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002c3:	eb be                	jmp    800283 <printnum+0x88>

008002c5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002c5:	55                   	push   %ebp
  8002c6:	89 e5                	mov    %esp,%ebp
  8002c8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002cb:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002cf:	8b 10                	mov    (%eax),%edx
  8002d1:	3b 50 04             	cmp    0x4(%eax),%edx
  8002d4:	73 0a                	jae    8002e0 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002d6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002d9:	89 08                	mov    %ecx,(%eax)
  8002db:	8b 45 08             	mov    0x8(%ebp),%eax
  8002de:	88 02                	mov    %al,(%edx)
}
  8002e0:	5d                   	pop    %ebp
  8002e1:	c3                   	ret    

008002e2 <printfmt>:
{
  8002e2:	55                   	push   %ebp
  8002e3:	89 e5                	mov    %esp,%ebp
  8002e5:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002e8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002eb:	50                   	push   %eax
  8002ec:	ff 75 10             	pushl  0x10(%ebp)
  8002ef:	ff 75 0c             	pushl  0xc(%ebp)
  8002f2:	ff 75 08             	pushl  0x8(%ebp)
  8002f5:	e8 05 00 00 00       	call   8002ff <vprintfmt>
}
  8002fa:	83 c4 10             	add    $0x10,%esp
  8002fd:	c9                   	leave  
  8002fe:	c3                   	ret    

008002ff <vprintfmt>:
{
  8002ff:	55                   	push   %ebp
  800300:	89 e5                	mov    %esp,%ebp
  800302:	57                   	push   %edi
  800303:	56                   	push   %esi
  800304:	53                   	push   %ebx
  800305:	83 ec 2c             	sub    $0x2c,%esp
  800308:	e8 35 fd ff ff       	call   800042 <__x86.get_pc_thunk.bx>
  80030d:	81 c3 f3 1c 00 00    	add    $0x1cf3,%ebx
  800313:	8b 75 0c             	mov    0xc(%ebp),%esi
  800316:	8b 7d 10             	mov    0x10(%ebp),%edi
  800319:	e9 8e 03 00 00       	jmp    8006ac <.L35+0x48>
		padc = ' ';
  80031e:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800322:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800329:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800330:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800337:	b9 00 00 00 00       	mov    $0x0,%ecx
  80033c:	89 4d cc             	mov    %ecx,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80033f:	8d 47 01             	lea    0x1(%edi),%eax
  800342:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800345:	0f b6 17             	movzbl (%edi),%edx
  800348:	8d 42 dd             	lea    -0x23(%edx),%eax
  80034b:	3c 55                	cmp    $0x55,%al
  80034d:	0f 87 e1 03 00 00    	ja     800734 <.L22>
  800353:	0f b6 c0             	movzbl %al,%eax
  800356:	89 d9                	mov    %ebx,%ecx
  800358:	03 8c 83 38 ee ff ff 	add    -0x11c8(%ebx,%eax,4),%ecx
  80035f:	ff e1                	jmp    *%ecx

00800361 <.L67>:
  800361:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800364:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800368:	eb d5                	jmp    80033f <vprintfmt+0x40>

0080036a <.L28>:
		switch (ch = *(unsigned char *) fmt++) {
  80036a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80036d:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800371:	eb cc                	jmp    80033f <vprintfmt+0x40>

00800373 <.L29>:
		switch (ch = *(unsigned char *) fmt++) {
  800373:	0f b6 d2             	movzbl %dl,%edx
  800376:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800379:	b8 00 00 00 00       	mov    $0x0,%eax
				precision = precision * 10 + ch - '0';
  80037e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800381:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800385:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800388:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80038b:	83 f9 09             	cmp    $0x9,%ecx
  80038e:	77 55                	ja     8003e5 <.L23+0xf>
			for (precision = 0; ; ++fmt) {
  800390:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800393:	eb e9                	jmp    80037e <.L29+0xb>

00800395 <.L26>:
			precision = va_arg(ap, int);
  800395:	8b 45 14             	mov    0x14(%ebp),%eax
  800398:	8b 00                	mov    (%eax),%eax
  80039a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80039d:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a0:	8d 40 04             	lea    0x4(%eax),%eax
  8003a3:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003a9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003ad:	79 90                	jns    80033f <vprintfmt+0x40>
				width = precision, precision = -1;
  8003af:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003b5:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003bc:	eb 81                	jmp    80033f <vprintfmt+0x40>

008003be <.L27>:
  8003be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003c1:	85 c0                	test   %eax,%eax
  8003c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c8:	0f 49 d0             	cmovns %eax,%edx
  8003cb:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003d1:	e9 69 ff ff ff       	jmp    80033f <vprintfmt+0x40>

008003d6 <.L23>:
  8003d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003d9:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003e0:	e9 5a ff ff ff       	jmp    80033f <vprintfmt+0x40>
  8003e5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003e8:	eb bf                	jmp    8003a9 <.L26+0x14>

008003ea <.L33>:
			lflag++;
  8003ea:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003f1:	e9 49 ff ff ff       	jmp    80033f <vprintfmt+0x40>

008003f6 <.L30>:
			putch(va_arg(ap, int), putdat);
  8003f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f9:	8d 78 04             	lea    0x4(%eax),%edi
  8003fc:	83 ec 08             	sub    $0x8,%esp
  8003ff:	56                   	push   %esi
  800400:	ff 30                	pushl  (%eax)
  800402:	ff 55 08             	call   *0x8(%ebp)
			break;
  800405:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800408:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80040b:	e9 99 02 00 00       	jmp    8006a9 <.L35+0x45>

00800410 <.L32>:
			err = va_arg(ap, int);
  800410:	8b 45 14             	mov    0x14(%ebp),%eax
  800413:	8d 78 04             	lea    0x4(%eax),%edi
  800416:	8b 00                	mov    (%eax),%eax
  800418:	99                   	cltd   
  800419:	31 d0                	xor    %edx,%eax
  80041b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80041d:	83 f8 06             	cmp    $0x6,%eax
  800420:	7f 27                	jg     800449 <.L32+0x39>
  800422:	8b 94 83 0c 00 00 00 	mov    0xc(%ebx,%eax,4),%edx
  800429:	85 d2                	test   %edx,%edx
  80042b:	74 1c                	je     800449 <.L32+0x39>
				printfmt(putch, putdat, "%s", p);
  80042d:	52                   	push   %edx
  80042e:	8d 83 ca ed ff ff    	lea    -0x1236(%ebx),%eax
  800434:	50                   	push   %eax
  800435:	56                   	push   %esi
  800436:	ff 75 08             	pushl  0x8(%ebp)
  800439:	e8 a4 fe ff ff       	call   8002e2 <printfmt>
  80043e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800441:	89 7d 14             	mov    %edi,0x14(%ebp)
  800444:	e9 60 02 00 00       	jmp    8006a9 <.L35+0x45>
				printfmt(putch, putdat, "error %d", err);
  800449:	50                   	push   %eax
  80044a:	8d 83 c1 ed ff ff    	lea    -0x123f(%ebx),%eax
  800450:	50                   	push   %eax
  800451:	56                   	push   %esi
  800452:	ff 75 08             	pushl  0x8(%ebp)
  800455:	e8 88 fe ff ff       	call   8002e2 <printfmt>
  80045a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80045d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800460:	e9 44 02 00 00       	jmp    8006a9 <.L35+0x45>

00800465 <.L36>:
			if ((p = va_arg(ap, char *)) == NULL)
  800465:	8b 45 14             	mov    0x14(%ebp),%eax
  800468:	83 c0 04             	add    $0x4,%eax
  80046b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80046e:	8b 45 14             	mov    0x14(%ebp),%eax
  800471:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800473:	85 ff                	test   %edi,%edi
  800475:	8d 83 ba ed ff ff    	lea    -0x1246(%ebx),%eax
  80047b:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80047e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800482:	0f 8e b5 00 00 00    	jle    80053d <.L36+0xd8>
  800488:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80048c:	75 08                	jne    800496 <.L36+0x31>
  80048e:	89 75 0c             	mov    %esi,0xc(%ebp)
  800491:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800494:	eb 6d                	jmp    800503 <.L36+0x9e>
				for (width -= strnlen(p, precision); width > 0; width--)
  800496:	83 ec 08             	sub    $0x8,%esp
  800499:	ff 75 d0             	pushl  -0x30(%ebp)
  80049c:	57                   	push   %edi
  80049d:	e8 50 03 00 00       	call   8007f2 <strnlen>
  8004a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004a5:	29 c2                	sub    %eax,%edx
  8004a7:	89 55 c8             	mov    %edx,-0x38(%ebp)
  8004aa:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004ad:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004b4:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004b7:	89 d7                	mov    %edx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b9:	eb 10                	jmp    8004cb <.L36+0x66>
					putch(padc, putdat);
  8004bb:	83 ec 08             	sub    $0x8,%esp
  8004be:	56                   	push   %esi
  8004bf:	ff 75 e0             	pushl  -0x20(%ebp)
  8004c2:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c5:	83 ef 01             	sub    $0x1,%edi
  8004c8:	83 c4 10             	add    $0x10,%esp
  8004cb:	85 ff                	test   %edi,%edi
  8004cd:	7f ec                	jg     8004bb <.L36+0x56>
  8004cf:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004d2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8004d5:	85 d2                	test   %edx,%edx
  8004d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8004dc:	0f 49 c2             	cmovns %edx,%eax
  8004df:	29 c2                	sub    %eax,%edx
  8004e1:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004e4:	89 75 0c             	mov    %esi,0xc(%ebp)
  8004e7:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004ea:	eb 17                	jmp    800503 <.L36+0x9e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004ec:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004f0:	75 30                	jne    800522 <.L36+0xbd>
					putch(ch, putdat);
  8004f2:	83 ec 08             	sub    $0x8,%esp
  8004f5:	ff 75 0c             	pushl  0xc(%ebp)
  8004f8:	50                   	push   %eax
  8004f9:	ff 55 08             	call   *0x8(%ebp)
  8004fc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004ff:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800503:	83 c7 01             	add    $0x1,%edi
  800506:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80050a:	0f be c2             	movsbl %dl,%eax
  80050d:	85 c0                	test   %eax,%eax
  80050f:	74 52                	je     800563 <.L36+0xfe>
  800511:	85 f6                	test   %esi,%esi
  800513:	78 d7                	js     8004ec <.L36+0x87>
  800515:	83 ee 01             	sub    $0x1,%esi
  800518:	79 d2                	jns    8004ec <.L36+0x87>
  80051a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80051d:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800520:	eb 32                	jmp    800554 <.L36+0xef>
				if (altflag && (ch < ' ' || ch > '~'))
  800522:	0f be d2             	movsbl %dl,%edx
  800525:	83 ea 20             	sub    $0x20,%edx
  800528:	83 fa 5e             	cmp    $0x5e,%edx
  80052b:	76 c5                	jbe    8004f2 <.L36+0x8d>
					putch('?', putdat);
  80052d:	83 ec 08             	sub    $0x8,%esp
  800530:	ff 75 0c             	pushl  0xc(%ebp)
  800533:	6a 3f                	push   $0x3f
  800535:	ff 55 08             	call   *0x8(%ebp)
  800538:	83 c4 10             	add    $0x10,%esp
  80053b:	eb c2                	jmp    8004ff <.L36+0x9a>
  80053d:	89 75 0c             	mov    %esi,0xc(%ebp)
  800540:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800543:	eb be                	jmp    800503 <.L36+0x9e>
				putch(' ', putdat);
  800545:	83 ec 08             	sub    $0x8,%esp
  800548:	56                   	push   %esi
  800549:	6a 20                	push   $0x20
  80054b:	ff 55 08             	call   *0x8(%ebp)
			for (; width > 0; width--)
  80054e:	83 ef 01             	sub    $0x1,%edi
  800551:	83 c4 10             	add    $0x10,%esp
  800554:	85 ff                	test   %edi,%edi
  800556:	7f ed                	jg     800545 <.L36+0xe0>
			if ((p = va_arg(ap, char *)) == NULL)
  800558:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80055b:	89 45 14             	mov    %eax,0x14(%ebp)
  80055e:	e9 46 01 00 00       	jmp    8006a9 <.L35+0x45>
  800563:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800566:	8b 75 0c             	mov    0xc(%ebp),%esi
  800569:	eb e9                	jmp    800554 <.L36+0xef>

0080056b <.L31>:
  80056b:	8b 4d cc             	mov    -0x34(%ebp),%ecx
	if (lflag >= 2)
  80056e:	83 f9 01             	cmp    $0x1,%ecx
  800571:	7e 40                	jle    8005b3 <.L31+0x48>
		return va_arg(*ap, long long);
  800573:	8b 45 14             	mov    0x14(%ebp),%eax
  800576:	8b 50 04             	mov    0x4(%eax),%edx
  800579:	8b 00                	mov    (%eax),%eax
  80057b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80057e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800581:	8b 45 14             	mov    0x14(%ebp),%eax
  800584:	8d 40 08             	lea    0x8(%eax),%eax
  800587:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80058a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80058e:	79 55                	jns    8005e5 <.L31+0x7a>
				putch('-', putdat);
  800590:	83 ec 08             	sub    $0x8,%esp
  800593:	56                   	push   %esi
  800594:	6a 2d                	push   $0x2d
  800596:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800599:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80059c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80059f:	f7 da                	neg    %edx
  8005a1:	83 d1 00             	adc    $0x0,%ecx
  8005a4:	f7 d9                	neg    %ecx
  8005a6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005a9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ae:	e9 db 00 00 00       	jmp    80068e <.L35+0x2a>
	else if (lflag)
  8005b3:	85 c9                	test   %ecx,%ecx
  8005b5:	75 17                	jne    8005ce <.L31+0x63>
		return va_arg(*ap, int);
  8005b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005bf:	99                   	cltd   
  8005c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c6:	8d 40 04             	lea    0x4(%eax),%eax
  8005c9:	89 45 14             	mov    %eax,0x14(%ebp)
  8005cc:	eb bc                	jmp    80058a <.L31+0x1f>
		return va_arg(*ap, long);
  8005ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d1:	8b 00                	mov    (%eax),%eax
  8005d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d6:	99                   	cltd   
  8005d7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005da:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dd:	8d 40 04             	lea    0x4(%eax),%eax
  8005e0:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e3:	eb a5                	jmp    80058a <.L31+0x1f>
			num = getint(&ap, lflag);
  8005e5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005e8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005eb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f0:	e9 99 00 00 00       	jmp    80068e <.L35+0x2a>

008005f5 <.L37>:
  8005f5:	8b 4d cc             	mov    -0x34(%ebp),%ecx
	if (lflag >= 2)
  8005f8:	83 f9 01             	cmp    $0x1,%ecx
  8005fb:	7e 15                	jle    800612 <.L37+0x1d>
		return va_arg(*ap, unsigned long long);
  8005fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800600:	8b 10                	mov    (%eax),%edx
  800602:	8b 48 04             	mov    0x4(%eax),%ecx
  800605:	8d 40 08             	lea    0x8(%eax),%eax
  800608:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80060b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800610:	eb 7c                	jmp    80068e <.L35+0x2a>
	else if (lflag)
  800612:	85 c9                	test   %ecx,%ecx
  800614:	75 17                	jne    80062d <.L37+0x38>
		return va_arg(*ap, unsigned int);
  800616:	8b 45 14             	mov    0x14(%ebp),%eax
  800619:	8b 10                	mov    (%eax),%edx
  80061b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800620:	8d 40 04             	lea    0x4(%eax),%eax
  800623:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800626:	b8 0a 00 00 00       	mov    $0xa,%eax
  80062b:	eb 61                	jmp    80068e <.L35+0x2a>
		return va_arg(*ap, unsigned long);
  80062d:	8b 45 14             	mov    0x14(%ebp),%eax
  800630:	8b 10                	mov    (%eax),%edx
  800632:	b9 00 00 00 00       	mov    $0x0,%ecx
  800637:	8d 40 04             	lea    0x4(%eax),%eax
  80063a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80063d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800642:	eb 4a                	jmp    80068e <.L35+0x2a>

00800644 <.L34>:
			putch('X', putdat);
  800644:	83 ec 08             	sub    $0x8,%esp
  800647:	56                   	push   %esi
  800648:	6a 58                	push   $0x58
  80064a:	ff 55 08             	call   *0x8(%ebp)
			putch('X', putdat);
  80064d:	83 c4 08             	add    $0x8,%esp
  800650:	56                   	push   %esi
  800651:	6a 58                	push   $0x58
  800653:	ff 55 08             	call   *0x8(%ebp)
			putch('X', putdat);
  800656:	83 c4 08             	add    $0x8,%esp
  800659:	56                   	push   %esi
  80065a:	6a 58                	push   $0x58
  80065c:	ff 55 08             	call   *0x8(%ebp)
			break;
  80065f:	83 c4 10             	add    $0x10,%esp
  800662:	eb 45                	jmp    8006a9 <.L35+0x45>

00800664 <.L35>:
			putch('0', putdat);
  800664:	83 ec 08             	sub    $0x8,%esp
  800667:	56                   	push   %esi
  800668:	6a 30                	push   $0x30
  80066a:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80066d:	83 c4 08             	add    $0x8,%esp
  800670:	56                   	push   %esi
  800671:	6a 78                	push   $0x78
  800673:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  800676:	8b 45 14             	mov    0x14(%ebp),%eax
  800679:	8b 10                	mov    (%eax),%edx
  80067b:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800680:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800683:	8d 40 04             	lea    0x4(%eax),%eax
  800686:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800689:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80068e:	83 ec 0c             	sub    $0xc,%esp
  800691:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800695:	57                   	push   %edi
  800696:	ff 75 e0             	pushl  -0x20(%ebp)
  800699:	50                   	push   %eax
  80069a:	51                   	push   %ecx
  80069b:	52                   	push   %edx
  80069c:	89 f2                	mov    %esi,%edx
  80069e:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a1:	e8 55 fb ff ff       	call   8001fb <printnum>
			break;
  8006a6:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006a9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006ac:	83 c7 01             	add    $0x1,%edi
  8006af:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006b3:	83 f8 25             	cmp    $0x25,%eax
  8006b6:	0f 84 62 fc ff ff    	je     80031e <vprintfmt+0x1f>
			if (ch == '\0')
  8006bc:	85 c0                	test   %eax,%eax
  8006be:	0f 84 91 00 00 00    	je     800755 <.L22+0x21>
			putch(ch, putdat);
  8006c4:	83 ec 08             	sub    $0x8,%esp
  8006c7:	56                   	push   %esi
  8006c8:	50                   	push   %eax
  8006c9:	ff 55 08             	call   *0x8(%ebp)
  8006cc:	83 c4 10             	add    $0x10,%esp
  8006cf:	eb db                	jmp    8006ac <.L35+0x48>

008006d1 <.L38>:
  8006d1:	8b 4d cc             	mov    -0x34(%ebp),%ecx
	if (lflag >= 2)
  8006d4:	83 f9 01             	cmp    $0x1,%ecx
  8006d7:	7e 15                	jle    8006ee <.L38+0x1d>
		return va_arg(*ap, unsigned long long);
  8006d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dc:	8b 10                	mov    (%eax),%edx
  8006de:	8b 48 04             	mov    0x4(%eax),%ecx
  8006e1:	8d 40 08             	lea    0x8(%eax),%eax
  8006e4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006e7:	b8 10 00 00 00       	mov    $0x10,%eax
  8006ec:	eb a0                	jmp    80068e <.L35+0x2a>
	else if (lflag)
  8006ee:	85 c9                	test   %ecx,%ecx
  8006f0:	75 17                	jne    800709 <.L38+0x38>
		return va_arg(*ap, unsigned int);
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	8b 10                	mov    (%eax),%edx
  8006f7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006fc:	8d 40 04             	lea    0x4(%eax),%eax
  8006ff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800702:	b8 10 00 00 00       	mov    $0x10,%eax
  800707:	eb 85                	jmp    80068e <.L35+0x2a>
		return va_arg(*ap, unsigned long);
  800709:	8b 45 14             	mov    0x14(%ebp),%eax
  80070c:	8b 10                	mov    (%eax),%edx
  80070e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800713:	8d 40 04             	lea    0x4(%eax),%eax
  800716:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800719:	b8 10 00 00 00       	mov    $0x10,%eax
  80071e:	e9 6b ff ff ff       	jmp    80068e <.L35+0x2a>

00800723 <.L25>:
			putch(ch, putdat);
  800723:	83 ec 08             	sub    $0x8,%esp
  800726:	56                   	push   %esi
  800727:	6a 25                	push   $0x25
  800729:	ff 55 08             	call   *0x8(%ebp)
			break;
  80072c:	83 c4 10             	add    $0x10,%esp
  80072f:	e9 75 ff ff ff       	jmp    8006a9 <.L35+0x45>

00800734 <.L22>:
			putch('%', putdat);
  800734:	83 ec 08             	sub    $0x8,%esp
  800737:	56                   	push   %esi
  800738:	6a 25                	push   $0x25
  80073a:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  80073d:	83 c4 10             	add    $0x10,%esp
  800740:	89 f8                	mov    %edi,%eax
  800742:	eb 03                	jmp    800747 <.L22+0x13>
  800744:	83 e8 01             	sub    $0x1,%eax
  800747:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80074b:	75 f7                	jne    800744 <.L22+0x10>
  80074d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800750:	e9 54 ff ff ff       	jmp    8006a9 <.L35+0x45>
}
  800755:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800758:	5b                   	pop    %ebx
  800759:	5e                   	pop    %esi
  80075a:	5f                   	pop    %edi
  80075b:	5d                   	pop    %ebp
  80075c:	c3                   	ret    

0080075d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80075d:	55                   	push   %ebp
  80075e:	89 e5                	mov    %esp,%ebp
  800760:	53                   	push   %ebx
  800761:	83 ec 14             	sub    $0x14,%esp
  800764:	e8 d9 f8 ff ff       	call   800042 <__x86.get_pc_thunk.bx>
  800769:	81 c3 97 18 00 00    	add    $0x1897,%ebx
  80076f:	8b 45 08             	mov    0x8(%ebp),%eax
  800772:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800775:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800778:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80077c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80077f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800786:	85 c0                	test   %eax,%eax
  800788:	74 2b                	je     8007b5 <vsnprintf+0x58>
  80078a:	85 d2                	test   %edx,%edx
  80078c:	7e 27                	jle    8007b5 <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80078e:	ff 75 14             	pushl  0x14(%ebp)
  800791:	ff 75 10             	pushl  0x10(%ebp)
  800794:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800797:	50                   	push   %eax
  800798:	8d 83 c5 e2 ff ff    	lea    -0x1d3b(%ebx),%eax
  80079e:	50                   	push   %eax
  80079f:	e8 5b fb ff ff       	call   8002ff <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007a7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007ad:	83 c4 10             	add    $0x10,%esp
}
  8007b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007b3:	c9                   	leave  
  8007b4:	c3                   	ret    
		return -E_INVAL;
  8007b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007ba:	eb f4                	jmp    8007b0 <vsnprintf+0x53>

008007bc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007bc:	55                   	push   %ebp
  8007bd:	89 e5                	mov    %esp,%ebp
  8007bf:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007c2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007c5:	50                   	push   %eax
  8007c6:	ff 75 10             	pushl  0x10(%ebp)
  8007c9:	ff 75 0c             	pushl  0xc(%ebp)
  8007cc:	ff 75 08             	pushl  0x8(%ebp)
  8007cf:	e8 89 ff ff ff       	call   80075d <vsnprintf>
	va_end(ap);

	return rc;
}
  8007d4:	c9                   	leave  
  8007d5:	c3                   	ret    

008007d6 <__x86.get_pc_thunk.cx>:
  8007d6:	8b 0c 24             	mov    (%esp),%ecx
  8007d9:	c3                   	ret    

008007da <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007da:	55                   	push   %ebp
  8007db:	89 e5                	mov    %esp,%ebp
  8007dd:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e5:	eb 03                	jmp    8007ea <strlen+0x10>
		n++;
  8007e7:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007ea:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007ee:	75 f7                	jne    8007e7 <strlen+0xd>
	return n;
}
  8007f0:	5d                   	pop    %ebp
  8007f1:	c3                   	ret    

008007f2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007f2:	55                   	push   %ebp
  8007f3:	89 e5                	mov    %esp,%ebp
  8007f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007f8:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800800:	eb 03                	jmp    800805 <strnlen+0x13>
		n++;
  800802:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800805:	39 d0                	cmp    %edx,%eax
  800807:	74 06                	je     80080f <strnlen+0x1d>
  800809:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80080d:	75 f3                	jne    800802 <strnlen+0x10>
	return n;
}
  80080f:	5d                   	pop    %ebp
  800810:	c3                   	ret    

00800811 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800811:	55                   	push   %ebp
  800812:	89 e5                	mov    %esp,%ebp
  800814:	53                   	push   %ebx
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80081b:	89 c2                	mov    %eax,%edx
  80081d:	83 c1 01             	add    $0x1,%ecx
  800820:	83 c2 01             	add    $0x1,%edx
  800823:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800827:	88 5a ff             	mov    %bl,-0x1(%edx)
  80082a:	84 db                	test   %bl,%bl
  80082c:	75 ef                	jne    80081d <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80082e:	5b                   	pop    %ebx
  80082f:	5d                   	pop    %ebp
  800830:	c3                   	ret    

00800831 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800831:	55                   	push   %ebp
  800832:	89 e5                	mov    %esp,%ebp
  800834:	53                   	push   %ebx
  800835:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800838:	53                   	push   %ebx
  800839:	e8 9c ff ff ff       	call   8007da <strlen>
  80083e:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800841:	ff 75 0c             	pushl  0xc(%ebp)
  800844:	01 d8                	add    %ebx,%eax
  800846:	50                   	push   %eax
  800847:	e8 c5 ff ff ff       	call   800811 <strcpy>
	return dst;
}
  80084c:	89 d8                	mov    %ebx,%eax
  80084e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800851:	c9                   	leave  
  800852:	c3                   	ret    

00800853 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800853:	55                   	push   %ebp
  800854:	89 e5                	mov    %esp,%ebp
  800856:	56                   	push   %esi
  800857:	53                   	push   %ebx
  800858:	8b 75 08             	mov    0x8(%ebp),%esi
  80085b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80085e:	89 f3                	mov    %esi,%ebx
  800860:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800863:	89 f2                	mov    %esi,%edx
  800865:	eb 0f                	jmp    800876 <strncpy+0x23>
		*dst++ = *src;
  800867:	83 c2 01             	add    $0x1,%edx
  80086a:	0f b6 01             	movzbl (%ecx),%eax
  80086d:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800870:	80 39 01             	cmpb   $0x1,(%ecx)
  800873:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800876:	39 da                	cmp    %ebx,%edx
  800878:	75 ed                	jne    800867 <strncpy+0x14>
	}
	return ret;
}
  80087a:	89 f0                	mov    %esi,%eax
  80087c:	5b                   	pop    %ebx
  80087d:	5e                   	pop    %esi
  80087e:	5d                   	pop    %ebp
  80087f:	c3                   	ret    

00800880 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800880:	55                   	push   %ebp
  800881:	89 e5                	mov    %esp,%ebp
  800883:	56                   	push   %esi
  800884:	53                   	push   %ebx
  800885:	8b 75 08             	mov    0x8(%ebp),%esi
  800888:	8b 55 0c             	mov    0xc(%ebp),%edx
  80088b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80088e:	89 f0                	mov    %esi,%eax
  800890:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800894:	85 c9                	test   %ecx,%ecx
  800896:	75 0b                	jne    8008a3 <strlcpy+0x23>
  800898:	eb 17                	jmp    8008b1 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80089a:	83 c2 01             	add    $0x1,%edx
  80089d:	83 c0 01             	add    $0x1,%eax
  8008a0:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008a3:	39 d8                	cmp    %ebx,%eax
  8008a5:	74 07                	je     8008ae <strlcpy+0x2e>
  8008a7:	0f b6 0a             	movzbl (%edx),%ecx
  8008aa:	84 c9                	test   %cl,%cl
  8008ac:	75 ec                	jne    80089a <strlcpy+0x1a>
		*dst = '\0';
  8008ae:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008b1:	29 f0                	sub    %esi,%eax
}
  8008b3:	5b                   	pop    %ebx
  8008b4:	5e                   	pop    %esi
  8008b5:	5d                   	pop    %ebp
  8008b6:	c3                   	ret    

008008b7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008b7:	55                   	push   %ebp
  8008b8:	89 e5                	mov    %esp,%ebp
  8008ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008bd:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008c0:	eb 06                	jmp    8008c8 <strcmp+0x11>
		p++, q++;
  8008c2:	83 c1 01             	add    $0x1,%ecx
  8008c5:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008c8:	0f b6 01             	movzbl (%ecx),%eax
  8008cb:	84 c0                	test   %al,%al
  8008cd:	74 04                	je     8008d3 <strcmp+0x1c>
  8008cf:	3a 02                	cmp    (%edx),%al
  8008d1:	74 ef                	je     8008c2 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008d3:	0f b6 c0             	movzbl %al,%eax
  8008d6:	0f b6 12             	movzbl (%edx),%edx
  8008d9:	29 d0                	sub    %edx,%eax
}
  8008db:	5d                   	pop    %ebp
  8008dc:	c3                   	ret    

008008dd <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	53                   	push   %ebx
  8008e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e7:	89 c3                	mov    %eax,%ebx
  8008e9:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008ec:	eb 06                	jmp    8008f4 <strncmp+0x17>
		n--, p++, q++;
  8008ee:	83 c0 01             	add    $0x1,%eax
  8008f1:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008f4:	39 d8                	cmp    %ebx,%eax
  8008f6:	74 16                	je     80090e <strncmp+0x31>
  8008f8:	0f b6 08             	movzbl (%eax),%ecx
  8008fb:	84 c9                	test   %cl,%cl
  8008fd:	74 04                	je     800903 <strncmp+0x26>
  8008ff:	3a 0a                	cmp    (%edx),%cl
  800901:	74 eb                	je     8008ee <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800903:	0f b6 00             	movzbl (%eax),%eax
  800906:	0f b6 12             	movzbl (%edx),%edx
  800909:	29 d0                	sub    %edx,%eax
}
  80090b:	5b                   	pop    %ebx
  80090c:	5d                   	pop    %ebp
  80090d:	c3                   	ret    
		return 0;
  80090e:	b8 00 00 00 00       	mov    $0x0,%eax
  800913:	eb f6                	jmp    80090b <strncmp+0x2e>

00800915 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800915:	55                   	push   %ebp
  800916:	89 e5                	mov    %esp,%ebp
  800918:	8b 45 08             	mov    0x8(%ebp),%eax
  80091b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80091f:	0f b6 10             	movzbl (%eax),%edx
  800922:	84 d2                	test   %dl,%dl
  800924:	74 09                	je     80092f <strchr+0x1a>
		if (*s == c)
  800926:	38 ca                	cmp    %cl,%dl
  800928:	74 0a                	je     800934 <strchr+0x1f>
	for (; *s; s++)
  80092a:	83 c0 01             	add    $0x1,%eax
  80092d:	eb f0                	jmp    80091f <strchr+0xa>
			return (char *) s;
	return 0;
  80092f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800934:	5d                   	pop    %ebp
  800935:	c3                   	ret    

00800936 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800936:	55                   	push   %ebp
  800937:	89 e5                	mov    %esp,%ebp
  800939:	8b 45 08             	mov    0x8(%ebp),%eax
  80093c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800940:	eb 03                	jmp    800945 <strfind+0xf>
  800942:	83 c0 01             	add    $0x1,%eax
  800945:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800948:	38 ca                	cmp    %cl,%dl
  80094a:	74 04                	je     800950 <strfind+0x1a>
  80094c:	84 d2                	test   %dl,%dl
  80094e:	75 f2                	jne    800942 <strfind+0xc>
			break;
	return (char *) s;
}
  800950:	5d                   	pop    %ebp
  800951:	c3                   	ret    

00800952 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800952:	55                   	push   %ebp
  800953:	89 e5                	mov    %esp,%ebp
  800955:	57                   	push   %edi
  800956:	56                   	push   %esi
  800957:	53                   	push   %ebx
  800958:	8b 7d 08             	mov    0x8(%ebp),%edi
  80095b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80095e:	85 c9                	test   %ecx,%ecx
  800960:	74 13                	je     800975 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800962:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800968:	75 05                	jne    80096f <memset+0x1d>
  80096a:	f6 c1 03             	test   $0x3,%cl
  80096d:	74 0d                	je     80097c <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80096f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800972:	fc                   	cld    
  800973:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800975:	89 f8                	mov    %edi,%eax
  800977:	5b                   	pop    %ebx
  800978:	5e                   	pop    %esi
  800979:	5f                   	pop    %edi
  80097a:	5d                   	pop    %ebp
  80097b:	c3                   	ret    
		c &= 0xFF;
  80097c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800980:	89 d3                	mov    %edx,%ebx
  800982:	c1 e3 08             	shl    $0x8,%ebx
  800985:	89 d0                	mov    %edx,%eax
  800987:	c1 e0 18             	shl    $0x18,%eax
  80098a:	89 d6                	mov    %edx,%esi
  80098c:	c1 e6 10             	shl    $0x10,%esi
  80098f:	09 f0                	or     %esi,%eax
  800991:	09 c2                	or     %eax,%edx
  800993:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800995:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800998:	89 d0                	mov    %edx,%eax
  80099a:	fc                   	cld    
  80099b:	f3 ab                	rep stos %eax,%es:(%edi)
  80099d:	eb d6                	jmp    800975 <memset+0x23>

0080099f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80099f:	55                   	push   %ebp
  8009a0:	89 e5                	mov    %esp,%ebp
  8009a2:	57                   	push   %edi
  8009a3:	56                   	push   %esi
  8009a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009ad:	39 c6                	cmp    %eax,%esi
  8009af:	73 35                	jae    8009e6 <memmove+0x47>
  8009b1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009b4:	39 c2                	cmp    %eax,%edx
  8009b6:	76 2e                	jbe    8009e6 <memmove+0x47>
		s += n;
		d += n;
  8009b8:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009bb:	89 d6                	mov    %edx,%esi
  8009bd:	09 fe                	or     %edi,%esi
  8009bf:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009c5:	74 0c                	je     8009d3 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009c7:	83 ef 01             	sub    $0x1,%edi
  8009ca:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009cd:	fd                   	std    
  8009ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009d0:	fc                   	cld    
  8009d1:	eb 21                	jmp    8009f4 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d3:	f6 c1 03             	test   $0x3,%cl
  8009d6:	75 ef                	jne    8009c7 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009d8:	83 ef 04             	sub    $0x4,%edi
  8009db:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009de:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009e1:	fd                   	std    
  8009e2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009e4:	eb ea                	jmp    8009d0 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009e6:	89 f2                	mov    %esi,%edx
  8009e8:	09 c2                	or     %eax,%edx
  8009ea:	f6 c2 03             	test   $0x3,%dl
  8009ed:	74 09                	je     8009f8 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009ef:	89 c7                	mov    %eax,%edi
  8009f1:	fc                   	cld    
  8009f2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009f4:	5e                   	pop    %esi
  8009f5:	5f                   	pop    %edi
  8009f6:	5d                   	pop    %ebp
  8009f7:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009f8:	f6 c1 03             	test   $0x3,%cl
  8009fb:	75 f2                	jne    8009ef <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009fd:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a00:	89 c7                	mov    %eax,%edi
  800a02:	fc                   	cld    
  800a03:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a05:	eb ed                	jmp    8009f4 <memmove+0x55>

00800a07 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a07:	55                   	push   %ebp
  800a08:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a0a:	ff 75 10             	pushl  0x10(%ebp)
  800a0d:	ff 75 0c             	pushl  0xc(%ebp)
  800a10:	ff 75 08             	pushl  0x8(%ebp)
  800a13:	e8 87 ff ff ff       	call   80099f <memmove>
}
  800a18:	c9                   	leave  
  800a19:	c3                   	ret    

00800a1a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
  800a1d:	56                   	push   %esi
  800a1e:	53                   	push   %ebx
  800a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a22:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a25:	89 c6                	mov    %eax,%esi
  800a27:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a2a:	39 f0                	cmp    %esi,%eax
  800a2c:	74 1c                	je     800a4a <memcmp+0x30>
		if (*s1 != *s2)
  800a2e:	0f b6 08             	movzbl (%eax),%ecx
  800a31:	0f b6 1a             	movzbl (%edx),%ebx
  800a34:	38 d9                	cmp    %bl,%cl
  800a36:	75 08                	jne    800a40 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a38:	83 c0 01             	add    $0x1,%eax
  800a3b:	83 c2 01             	add    $0x1,%edx
  800a3e:	eb ea                	jmp    800a2a <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a40:	0f b6 c1             	movzbl %cl,%eax
  800a43:	0f b6 db             	movzbl %bl,%ebx
  800a46:	29 d8                	sub    %ebx,%eax
  800a48:	eb 05                	jmp    800a4f <memcmp+0x35>
	}

	return 0;
  800a4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a4f:	5b                   	pop    %ebx
  800a50:	5e                   	pop    %esi
  800a51:	5d                   	pop    %ebp
  800a52:	c3                   	ret    

00800a53 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a53:	55                   	push   %ebp
  800a54:	89 e5                	mov    %esp,%ebp
  800a56:	8b 45 08             	mov    0x8(%ebp),%eax
  800a59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a5c:	89 c2                	mov    %eax,%edx
  800a5e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a61:	39 d0                	cmp    %edx,%eax
  800a63:	73 09                	jae    800a6e <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a65:	38 08                	cmp    %cl,(%eax)
  800a67:	74 05                	je     800a6e <memfind+0x1b>
	for (; s < ends; s++)
  800a69:	83 c0 01             	add    $0x1,%eax
  800a6c:	eb f3                	jmp    800a61 <memfind+0xe>
			break;
	return (void *) s;
}
  800a6e:	5d                   	pop    %ebp
  800a6f:	c3                   	ret    

00800a70 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
  800a73:	57                   	push   %edi
  800a74:	56                   	push   %esi
  800a75:	53                   	push   %ebx
  800a76:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a79:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a7c:	eb 03                	jmp    800a81 <strtol+0x11>
		s++;
  800a7e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a81:	0f b6 01             	movzbl (%ecx),%eax
  800a84:	3c 20                	cmp    $0x20,%al
  800a86:	74 f6                	je     800a7e <strtol+0xe>
  800a88:	3c 09                	cmp    $0x9,%al
  800a8a:	74 f2                	je     800a7e <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a8c:	3c 2b                	cmp    $0x2b,%al
  800a8e:	74 2e                	je     800abe <strtol+0x4e>
	int neg = 0;
  800a90:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a95:	3c 2d                	cmp    $0x2d,%al
  800a97:	74 2f                	je     800ac8 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a99:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a9f:	75 05                	jne    800aa6 <strtol+0x36>
  800aa1:	80 39 30             	cmpb   $0x30,(%ecx)
  800aa4:	74 2c                	je     800ad2 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800aa6:	85 db                	test   %ebx,%ebx
  800aa8:	75 0a                	jne    800ab4 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aaa:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800aaf:	80 39 30             	cmpb   $0x30,(%ecx)
  800ab2:	74 28                	je     800adc <strtol+0x6c>
		base = 10;
  800ab4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800abc:	eb 50                	jmp    800b0e <strtol+0x9e>
		s++;
  800abe:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ac1:	bf 00 00 00 00       	mov    $0x0,%edi
  800ac6:	eb d1                	jmp    800a99 <strtol+0x29>
		s++, neg = 1;
  800ac8:	83 c1 01             	add    $0x1,%ecx
  800acb:	bf 01 00 00 00       	mov    $0x1,%edi
  800ad0:	eb c7                	jmp    800a99 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ad2:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ad6:	74 0e                	je     800ae6 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ad8:	85 db                	test   %ebx,%ebx
  800ada:	75 d8                	jne    800ab4 <strtol+0x44>
		s++, base = 8;
  800adc:	83 c1 01             	add    $0x1,%ecx
  800adf:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ae4:	eb ce                	jmp    800ab4 <strtol+0x44>
		s += 2, base = 16;
  800ae6:	83 c1 02             	add    $0x2,%ecx
  800ae9:	bb 10 00 00 00       	mov    $0x10,%ebx
  800aee:	eb c4                	jmp    800ab4 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800af0:	8d 72 9f             	lea    -0x61(%edx),%esi
  800af3:	89 f3                	mov    %esi,%ebx
  800af5:	80 fb 19             	cmp    $0x19,%bl
  800af8:	77 29                	ja     800b23 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800afa:	0f be d2             	movsbl %dl,%edx
  800afd:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b00:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b03:	7d 30                	jge    800b35 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b05:	83 c1 01             	add    $0x1,%ecx
  800b08:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b0c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b0e:	0f b6 11             	movzbl (%ecx),%edx
  800b11:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b14:	89 f3                	mov    %esi,%ebx
  800b16:	80 fb 09             	cmp    $0x9,%bl
  800b19:	77 d5                	ja     800af0 <strtol+0x80>
			dig = *s - '0';
  800b1b:	0f be d2             	movsbl %dl,%edx
  800b1e:	83 ea 30             	sub    $0x30,%edx
  800b21:	eb dd                	jmp    800b00 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b23:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b26:	89 f3                	mov    %esi,%ebx
  800b28:	80 fb 19             	cmp    $0x19,%bl
  800b2b:	77 08                	ja     800b35 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b2d:	0f be d2             	movsbl %dl,%edx
  800b30:	83 ea 37             	sub    $0x37,%edx
  800b33:	eb cb                	jmp    800b00 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b35:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b39:	74 05                	je     800b40 <strtol+0xd0>
		*endptr = (char *) s;
  800b3b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b3e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b40:	89 c2                	mov    %eax,%edx
  800b42:	f7 da                	neg    %edx
  800b44:	85 ff                	test   %edi,%edi
  800b46:	0f 45 c2             	cmovne %edx,%eax
}
  800b49:	5b                   	pop    %ebx
  800b4a:	5e                   	pop    %esi
  800b4b:	5f                   	pop    %edi
  800b4c:	5d                   	pop    %ebp
  800b4d:	c3                   	ret    
  800b4e:	66 90                	xchg   %ax,%ax

00800b50 <__udivdi3>:
  800b50:	55                   	push   %ebp
  800b51:	57                   	push   %edi
  800b52:	56                   	push   %esi
  800b53:	53                   	push   %ebx
  800b54:	83 ec 1c             	sub    $0x1c,%esp
  800b57:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800b5b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800b5f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800b63:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800b67:	85 d2                	test   %edx,%edx
  800b69:	75 35                	jne    800ba0 <__udivdi3+0x50>
  800b6b:	39 f3                	cmp    %esi,%ebx
  800b6d:	0f 87 bd 00 00 00    	ja     800c30 <__udivdi3+0xe0>
  800b73:	85 db                	test   %ebx,%ebx
  800b75:	89 d9                	mov    %ebx,%ecx
  800b77:	75 0b                	jne    800b84 <__udivdi3+0x34>
  800b79:	b8 01 00 00 00       	mov    $0x1,%eax
  800b7e:	31 d2                	xor    %edx,%edx
  800b80:	f7 f3                	div    %ebx
  800b82:	89 c1                	mov    %eax,%ecx
  800b84:	31 d2                	xor    %edx,%edx
  800b86:	89 f0                	mov    %esi,%eax
  800b88:	f7 f1                	div    %ecx
  800b8a:	89 c6                	mov    %eax,%esi
  800b8c:	89 e8                	mov    %ebp,%eax
  800b8e:	89 f7                	mov    %esi,%edi
  800b90:	f7 f1                	div    %ecx
  800b92:	89 fa                	mov    %edi,%edx
  800b94:	83 c4 1c             	add    $0x1c,%esp
  800b97:	5b                   	pop    %ebx
  800b98:	5e                   	pop    %esi
  800b99:	5f                   	pop    %edi
  800b9a:	5d                   	pop    %ebp
  800b9b:	c3                   	ret    
  800b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800ba0:	39 f2                	cmp    %esi,%edx
  800ba2:	77 7c                	ja     800c20 <__udivdi3+0xd0>
  800ba4:	0f bd fa             	bsr    %edx,%edi
  800ba7:	83 f7 1f             	xor    $0x1f,%edi
  800baa:	0f 84 98 00 00 00    	je     800c48 <__udivdi3+0xf8>
  800bb0:	89 f9                	mov    %edi,%ecx
  800bb2:	b8 20 00 00 00       	mov    $0x20,%eax
  800bb7:	29 f8                	sub    %edi,%eax
  800bb9:	d3 e2                	shl    %cl,%edx
  800bbb:	89 54 24 08          	mov    %edx,0x8(%esp)
  800bbf:	89 c1                	mov    %eax,%ecx
  800bc1:	89 da                	mov    %ebx,%edx
  800bc3:	d3 ea                	shr    %cl,%edx
  800bc5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800bc9:	09 d1                	or     %edx,%ecx
  800bcb:	89 f2                	mov    %esi,%edx
  800bcd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800bd1:	89 f9                	mov    %edi,%ecx
  800bd3:	d3 e3                	shl    %cl,%ebx
  800bd5:	89 c1                	mov    %eax,%ecx
  800bd7:	d3 ea                	shr    %cl,%edx
  800bd9:	89 f9                	mov    %edi,%ecx
  800bdb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800bdf:	d3 e6                	shl    %cl,%esi
  800be1:	89 eb                	mov    %ebp,%ebx
  800be3:	89 c1                	mov    %eax,%ecx
  800be5:	d3 eb                	shr    %cl,%ebx
  800be7:	09 de                	or     %ebx,%esi
  800be9:	89 f0                	mov    %esi,%eax
  800beb:	f7 74 24 08          	divl   0x8(%esp)
  800bef:	89 d6                	mov    %edx,%esi
  800bf1:	89 c3                	mov    %eax,%ebx
  800bf3:	f7 64 24 0c          	mull   0xc(%esp)
  800bf7:	39 d6                	cmp    %edx,%esi
  800bf9:	72 0c                	jb     800c07 <__udivdi3+0xb7>
  800bfb:	89 f9                	mov    %edi,%ecx
  800bfd:	d3 e5                	shl    %cl,%ebp
  800bff:	39 c5                	cmp    %eax,%ebp
  800c01:	73 5d                	jae    800c60 <__udivdi3+0x110>
  800c03:	39 d6                	cmp    %edx,%esi
  800c05:	75 59                	jne    800c60 <__udivdi3+0x110>
  800c07:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800c0a:	31 ff                	xor    %edi,%edi
  800c0c:	89 fa                	mov    %edi,%edx
  800c0e:	83 c4 1c             	add    $0x1c,%esp
  800c11:	5b                   	pop    %ebx
  800c12:	5e                   	pop    %esi
  800c13:	5f                   	pop    %edi
  800c14:	5d                   	pop    %ebp
  800c15:	c3                   	ret    
  800c16:	8d 76 00             	lea    0x0(%esi),%esi
  800c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800c20:	31 ff                	xor    %edi,%edi
  800c22:	31 c0                	xor    %eax,%eax
  800c24:	89 fa                	mov    %edi,%edx
  800c26:	83 c4 1c             	add    $0x1c,%esp
  800c29:	5b                   	pop    %ebx
  800c2a:	5e                   	pop    %esi
  800c2b:	5f                   	pop    %edi
  800c2c:	5d                   	pop    %ebp
  800c2d:	c3                   	ret    
  800c2e:	66 90                	xchg   %ax,%ax
  800c30:	31 ff                	xor    %edi,%edi
  800c32:	89 e8                	mov    %ebp,%eax
  800c34:	89 f2                	mov    %esi,%edx
  800c36:	f7 f3                	div    %ebx
  800c38:	89 fa                	mov    %edi,%edx
  800c3a:	83 c4 1c             	add    $0x1c,%esp
  800c3d:	5b                   	pop    %ebx
  800c3e:	5e                   	pop    %esi
  800c3f:	5f                   	pop    %edi
  800c40:	5d                   	pop    %ebp
  800c41:	c3                   	ret    
  800c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800c48:	39 f2                	cmp    %esi,%edx
  800c4a:	72 06                	jb     800c52 <__udivdi3+0x102>
  800c4c:	31 c0                	xor    %eax,%eax
  800c4e:	39 eb                	cmp    %ebp,%ebx
  800c50:	77 d2                	ja     800c24 <__udivdi3+0xd4>
  800c52:	b8 01 00 00 00       	mov    $0x1,%eax
  800c57:	eb cb                	jmp    800c24 <__udivdi3+0xd4>
  800c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800c60:	89 d8                	mov    %ebx,%eax
  800c62:	31 ff                	xor    %edi,%edi
  800c64:	eb be                	jmp    800c24 <__udivdi3+0xd4>
  800c66:	66 90                	xchg   %ax,%ax
  800c68:	66 90                	xchg   %ax,%ax
  800c6a:	66 90                	xchg   %ax,%ax
  800c6c:	66 90                	xchg   %ax,%ax
  800c6e:	66 90                	xchg   %ax,%ax

00800c70 <__umoddi3>:
  800c70:	55                   	push   %ebp
  800c71:	57                   	push   %edi
  800c72:	56                   	push   %esi
  800c73:	53                   	push   %ebx
  800c74:	83 ec 1c             	sub    $0x1c,%esp
  800c77:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800c7b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800c7f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800c83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800c87:	85 ed                	test   %ebp,%ebp
  800c89:	89 f0                	mov    %esi,%eax
  800c8b:	89 da                	mov    %ebx,%edx
  800c8d:	75 19                	jne    800ca8 <__umoddi3+0x38>
  800c8f:	39 df                	cmp    %ebx,%edi
  800c91:	0f 86 b1 00 00 00    	jbe    800d48 <__umoddi3+0xd8>
  800c97:	f7 f7                	div    %edi
  800c99:	89 d0                	mov    %edx,%eax
  800c9b:	31 d2                	xor    %edx,%edx
  800c9d:	83 c4 1c             	add    $0x1c,%esp
  800ca0:	5b                   	pop    %ebx
  800ca1:	5e                   	pop    %esi
  800ca2:	5f                   	pop    %edi
  800ca3:	5d                   	pop    %ebp
  800ca4:	c3                   	ret    
  800ca5:	8d 76 00             	lea    0x0(%esi),%esi
  800ca8:	39 dd                	cmp    %ebx,%ebp
  800caa:	77 f1                	ja     800c9d <__umoddi3+0x2d>
  800cac:	0f bd cd             	bsr    %ebp,%ecx
  800caf:	83 f1 1f             	xor    $0x1f,%ecx
  800cb2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800cb6:	0f 84 b4 00 00 00    	je     800d70 <__umoddi3+0x100>
  800cbc:	b8 20 00 00 00       	mov    $0x20,%eax
  800cc1:	89 c2                	mov    %eax,%edx
  800cc3:	8b 44 24 04          	mov    0x4(%esp),%eax
  800cc7:	29 c2                	sub    %eax,%edx
  800cc9:	89 c1                	mov    %eax,%ecx
  800ccb:	89 f8                	mov    %edi,%eax
  800ccd:	d3 e5                	shl    %cl,%ebp
  800ccf:	89 d1                	mov    %edx,%ecx
  800cd1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800cd5:	d3 e8                	shr    %cl,%eax
  800cd7:	09 c5                	or     %eax,%ebp
  800cd9:	8b 44 24 04          	mov    0x4(%esp),%eax
  800cdd:	89 c1                	mov    %eax,%ecx
  800cdf:	d3 e7                	shl    %cl,%edi
  800ce1:	89 d1                	mov    %edx,%ecx
  800ce3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800ce7:	89 df                	mov    %ebx,%edi
  800ce9:	d3 ef                	shr    %cl,%edi
  800ceb:	89 c1                	mov    %eax,%ecx
  800ced:	89 f0                	mov    %esi,%eax
  800cef:	d3 e3                	shl    %cl,%ebx
  800cf1:	89 d1                	mov    %edx,%ecx
  800cf3:	89 fa                	mov    %edi,%edx
  800cf5:	d3 e8                	shr    %cl,%eax
  800cf7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800cfc:	09 d8                	or     %ebx,%eax
  800cfe:	f7 f5                	div    %ebp
  800d00:	d3 e6                	shl    %cl,%esi
  800d02:	89 d1                	mov    %edx,%ecx
  800d04:	f7 64 24 08          	mull   0x8(%esp)
  800d08:	39 d1                	cmp    %edx,%ecx
  800d0a:	89 c3                	mov    %eax,%ebx
  800d0c:	89 d7                	mov    %edx,%edi
  800d0e:	72 06                	jb     800d16 <__umoddi3+0xa6>
  800d10:	75 0e                	jne    800d20 <__umoddi3+0xb0>
  800d12:	39 c6                	cmp    %eax,%esi
  800d14:	73 0a                	jae    800d20 <__umoddi3+0xb0>
  800d16:	2b 44 24 08          	sub    0x8(%esp),%eax
  800d1a:	19 ea                	sbb    %ebp,%edx
  800d1c:	89 d7                	mov    %edx,%edi
  800d1e:	89 c3                	mov    %eax,%ebx
  800d20:	89 ca                	mov    %ecx,%edx
  800d22:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800d27:	29 de                	sub    %ebx,%esi
  800d29:	19 fa                	sbb    %edi,%edx
  800d2b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  800d2f:	89 d0                	mov    %edx,%eax
  800d31:	d3 e0                	shl    %cl,%eax
  800d33:	89 d9                	mov    %ebx,%ecx
  800d35:	d3 ee                	shr    %cl,%esi
  800d37:	d3 ea                	shr    %cl,%edx
  800d39:	09 f0                	or     %esi,%eax
  800d3b:	83 c4 1c             	add    $0x1c,%esp
  800d3e:	5b                   	pop    %ebx
  800d3f:	5e                   	pop    %esi
  800d40:	5f                   	pop    %edi
  800d41:	5d                   	pop    %ebp
  800d42:	c3                   	ret    
  800d43:	90                   	nop
  800d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800d48:	85 ff                	test   %edi,%edi
  800d4a:	89 f9                	mov    %edi,%ecx
  800d4c:	75 0b                	jne    800d59 <__umoddi3+0xe9>
  800d4e:	b8 01 00 00 00       	mov    $0x1,%eax
  800d53:	31 d2                	xor    %edx,%edx
  800d55:	f7 f7                	div    %edi
  800d57:	89 c1                	mov    %eax,%ecx
  800d59:	89 d8                	mov    %ebx,%eax
  800d5b:	31 d2                	xor    %edx,%edx
  800d5d:	f7 f1                	div    %ecx
  800d5f:	89 f0                	mov    %esi,%eax
  800d61:	f7 f1                	div    %ecx
  800d63:	e9 31 ff ff ff       	jmp    800c99 <__umoddi3+0x29>
  800d68:	90                   	nop
  800d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800d70:	39 dd                	cmp    %ebx,%ebp
  800d72:	72 08                	jb     800d7c <__umoddi3+0x10c>
  800d74:	39 f7                	cmp    %esi,%edi
  800d76:	0f 87 21 ff ff ff    	ja     800c9d <__umoddi3+0x2d>
  800d7c:	89 da                	mov    %ebx,%edx
  800d7e:	89 f0                	mov    %esi,%eax
  800d80:	29 f8                	sub    %edi,%eax
  800d82:	19 ea                	sbb    %ebp,%edx
  800d84:	e9 14 ff ff ff       	jmp    800c9d <__umoddi3+0x2d>
