
obj/user/test1:     file format elf32-i386


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
  800027:	e8 11 00 00 00       	call   80003d <__x86.get_pc_thunk.bx>
  80002c:	81 c3 d4 1f 00 00    	add    $0x1fd4,%ebx
	exit();
  800032:	e8 0a 00 00 00       	call   800041 <exit>
}
  800037:	83 c4 04             	add    $0x4,%esp
  80003a:	5b                   	pop    %ebx
  80003b:	5d                   	pop    %ebp
  80003c:	c3                   	ret    

0080003d <__x86.get_pc_thunk.bx>:
  80003d:	8b 1c 24             	mov    (%esp),%ebx
  800040:	c3                   	ret    

00800041 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800041:	55                   	push   %ebp
  800042:	89 e5                	mov    %esp,%ebp
  800044:	53                   	push   %ebx
  800045:	83 ec 10             	sub    $0x10,%esp
  800048:	e8 f0 ff ff ff       	call   80003d <__x86.get_pc_thunk.bx>
  80004d:	81 c3 b3 1f 00 00    	add    $0x1fb3,%ebx
	sys_env_destroy(0);
  800053:	6a 00                	push   $0x0
  800055:	e8 45 00 00 00       	call   80009f <sys_env_destroy>
}
  80005a:	83 c4 10             	add    $0x10,%esp
  80005d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800060:	c9                   	leave  
  800061:	c3                   	ret    

00800062 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800062:	55                   	push   %ebp
  800063:	89 e5                	mov    %esp,%ebp
  800065:	57                   	push   %edi
  800066:	56                   	push   %esi
  800067:	53                   	push   %ebx
	asm volatile("int %1\n"
  800068:	b8 00 00 00 00       	mov    $0x0,%eax
  80006d:	8b 55 08             	mov    0x8(%ebp),%edx
  800070:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800073:	89 c3                	mov    %eax,%ebx
  800075:	89 c7                	mov    %eax,%edi
  800077:	89 c6                	mov    %eax,%esi
  800079:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80007b:	5b                   	pop    %ebx
  80007c:	5e                   	pop    %esi
  80007d:	5f                   	pop    %edi
  80007e:	5d                   	pop    %ebp
  80007f:	c3                   	ret    

00800080 <sys_cgetc>:

int
sys_cgetc(void)
{
  800080:	55                   	push   %ebp
  800081:	89 e5                	mov    %esp,%ebp
  800083:	57                   	push   %edi
  800084:	56                   	push   %esi
  800085:	53                   	push   %ebx
	asm volatile("int %1\n"
  800086:	ba 00 00 00 00       	mov    $0x0,%edx
  80008b:	b8 01 00 00 00       	mov    $0x1,%eax
  800090:	89 d1                	mov    %edx,%ecx
  800092:	89 d3                	mov    %edx,%ebx
  800094:	89 d7                	mov    %edx,%edi
  800096:	89 d6                	mov    %edx,%esi
  800098:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80009a:	5b                   	pop    %ebx
  80009b:	5e                   	pop    %esi
  80009c:	5f                   	pop    %edi
  80009d:	5d                   	pop    %ebp
  80009e:	c3                   	ret    

0080009f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80009f:	55                   	push   %ebp
  8000a0:	89 e5                	mov    %esp,%ebp
  8000a2:	57                   	push   %edi
  8000a3:	56                   	push   %esi
  8000a4:	53                   	push   %ebx
  8000a5:	83 ec 1c             	sub    $0x1c,%esp
  8000a8:	e8 90 ff ff ff       	call   80003d <__x86.get_pc_thunk.bx>
  8000ad:	81 c3 53 1f 00 00    	add    $0x1f53,%ebx
  8000b3:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
	asm volatile("int %1\n"
  8000b6:	be 00 00 00 00       	mov    $0x0,%esi
  8000bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8000be:	b8 03 00 00 00       	mov    $0x3,%eax
  8000c3:	89 f1                	mov    %esi,%ecx
  8000c5:	89 f3                	mov    %esi,%ebx
  8000c7:	89 f7                	mov    %esi,%edi
  8000c9:	cd 30                	int    $0x30
  8000cb:	89 c6                	mov    %eax,%esi
	if(check && ret > 0) {
  8000cd:	85 c0                	test   %eax,%eax
  8000cf:	7e 18                	jle    8000e9 <sys_env_destroy+0x4a>
		cprintf("syscall %d returned %d (> 0)", num, ret);
  8000d1:	83 ec 04             	sub    $0x4,%esp
  8000d4:	50                   	push   %eax
  8000d5:	6a 03                	push   $0x3
  8000d7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8000da:	8d 83 8c ed ff ff    	lea    -0x1274(%ebx),%eax
  8000e0:	50                   	push   %eax
  8000e1:	e8 fc 00 00 00       	call   8001e2 <cprintf>
  8000e6:	83 c4 10             	add    $0x10,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000e9:	89 f0                	mov    %esi,%eax
  8000eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000ee:	5b                   	pop    %ebx
  8000ef:	5e                   	pop    %esi
  8000f0:	5f                   	pop    %edi
  8000f1:	5d                   	pop    %ebp
  8000f2:	c3                   	ret    

008000f3 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8000f3:	55                   	push   %ebp
  8000f4:	89 e5                	mov    %esp,%ebp
  8000f6:	57                   	push   %edi
  8000f7:	56                   	push   %esi
  8000f8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8000fe:	b8 02 00 00 00       	mov    $0x2,%eax
  800103:	89 d1                	mov    %edx,%ecx
  800105:	89 d3                	mov    %edx,%ebx
  800107:	89 d7                	mov    %edx,%edi
  800109:	89 d6                	mov    %edx,%esi
  80010b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80010d:	5b                   	pop    %ebx
  80010e:	5e                   	pop    %esi
  80010f:	5f                   	pop    %edi
  800110:	5d                   	pop    %ebp
  800111:	c3                   	ret    

00800112 <sys_test>:

void
sys_test(void)
{
  800112:	55                   	push   %ebp
  800113:	89 e5                	mov    %esp,%ebp
  800115:	57                   	push   %edi
  800116:	56                   	push   %esi
  800117:	53                   	push   %ebx
	asm volatile("int %1\n"
  800118:	ba 00 00 00 00       	mov    $0x0,%edx
  80011d:	b8 04 00 00 00       	mov    $0x4,%eax
  800122:	89 d1                	mov    %edx,%ecx
  800124:	89 d3                	mov    %edx,%ebx
  800126:	89 d7                	mov    %edx,%edi
  800128:	89 d6                	mov    %edx,%esi
  80012a:	cd 30                	int    $0x30
		syscall(SYS_test, 0, 0, 0, 0, 0, 0);
}
  80012c:	5b                   	pop    %ebx
  80012d:	5e                   	pop    %esi
  80012e:	5f                   	pop    %edi
  80012f:	5d                   	pop    %ebp
  800130:	c3                   	ret    

00800131 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800131:	55                   	push   %ebp
  800132:	89 e5                	mov    %esp,%ebp
  800134:	56                   	push   %esi
  800135:	53                   	push   %ebx
  800136:	e8 02 ff ff ff       	call   80003d <__x86.get_pc_thunk.bx>
  80013b:	81 c3 c5 1e 00 00    	add    $0x1ec5,%ebx
  800141:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  800144:	8b 16                	mov    (%esi),%edx
  800146:	8d 42 01             	lea    0x1(%edx),%eax
  800149:	89 06                	mov    %eax,(%esi)
  80014b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80014e:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  800152:	3d ff 00 00 00       	cmp    $0xff,%eax
  800157:	74 0b                	je     800164 <putch+0x33>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800159:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  80015d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800160:	5b                   	pop    %ebx
  800161:	5e                   	pop    %esi
  800162:	5d                   	pop    %ebp
  800163:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800164:	83 ec 08             	sub    $0x8,%esp
  800167:	68 ff 00 00 00       	push   $0xff
  80016c:	8d 46 08             	lea    0x8(%esi),%eax
  80016f:	50                   	push   %eax
  800170:	e8 ed fe ff ff       	call   800062 <sys_cputs>
		b->idx = 0;
  800175:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  80017b:	83 c4 10             	add    $0x10,%esp
  80017e:	eb d9                	jmp    800159 <putch+0x28>

00800180 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800180:	55                   	push   %ebp
  800181:	89 e5                	mov    %esp,%ebp
  800183:	53                   	push   %ebx
  800184:	81 ec 14 01 00 00    	sub    $0x114,%esp
  80018a:	e8 ae fe ff ff       	call   80003d <__x86.get_pc_thunk.bx>
  80018f:	81 c3 71 1e 00 00    	add    $0x1e71,%ebx
	struct printbuf b;

	b.idx = 0;
  800195:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80019c:	00 00 00 
	b.cnt = 0;
  80019f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001a6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001a9:	ff 75 0c             	pushl  0xc(%ebp)
  8001ac:	ff 75 08             	pushl  0x8(%ebp)
  8001af:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001b5:	50                   	push   %eax
  8001b6:	8d 83 31 e1 ff ff    	lea    -0x1ecf(%ebx),%eax
  8001bc:	50                   	push   %eax
  8001bd:	e8 38 01 00 00       	call   8002fa <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001c2:	83 c4 08             	add    $0x8,%esp
  8001c5:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001cb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001d1:	50                   	push   %eax
  8001d2:	e8 8b fe ff ff       	call   800062 <sys_cputs>

	return b.cnt;
}
  8001d7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001e0:	c9                   	leave  
  8001e1:	c3                   	ret    

008001e2 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001e2:	55                   	push   %ebp
  8001e3:	89 e5                	mov    %esp,%ebp
  8001e5:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001e8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001eb:	50                   	push   %eax
  8001ec:	ff 75 08             	pushl  0x8(%ebp)
  8001ef:	e8 8c ff ff ff       	call   800180 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001f4:	c9                   	leave  
  8001f5:	c3                   	ret    

008001f6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001f6:	55                   	push   %ebp
  8001f7:	89 e5                	mov    %esp,%ebp
  8001f9:	57                   	push   %edi
  8001fa:	56                   	push   %esi
  8001fb:	53                   	push   %ebx
  8001fc:	83 ec 2c             	sub    $0x2c,%esp
  8001ff:	e8 cd 05 00 00       	call   8007d1 <__x86.get_pc_thunk.cx>
  800204:	81 c1 fc 1d 00 00    	add    $0x1dfc,%ecx
  80020a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  80020d:	89 c7                	mov    %eax,%edi
  80020f:	89 d6                	mov    %edx,%esi
  800211:	8b 45 08             	mov    0x8(%ebp),%eax
  800214:	8b 55 0c             	mov    0xc(%ebp),%edx
  800217:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80021a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80021d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800220:	bb 00 00 00 00       	mov    $0x0,%ebx
  800225:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  800228:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  80022b:	39 d3                	cmp    %edx,%ebx
  80022d:	72 09                	jb     800238 <printnum+0x42>
  80022f:	39 45 10             	cmp    %eax,0x10(%ebp)
  800232:	0f 87 83 00 00 00    	ja     8002bb <printnum+0xc5>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800238:	83 ec 0c             	sub    $0xc,%esp
  80023b:	ff 75 18             	pushl  0x18(%ebp)
  80023e:	8b 45 14             	mov    0x14(%ebp),%eax
  800241:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800244:	53                   	push   %ebx
  800245:	ff 75 10             	pushl  0x10(%ebp)
  800248:	83 ec 08             	sub    $0x8,%esp
  80024b:	ff 75 dc             	pushl  -0x24(%ebp)
  80024e:	ff 75 d8             	pushl  -0x28(%ebp)
  800251:	ff 75 d4             	pushl  -0x2c(%ebp)
  800254:	ff 75 d0             	pushl  -0x30(%ebp)
  800257:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80025a:	e8 f1 08 00 00       	call   800b50 <__udivdi3>
  80025f:	83 c4 18             	add    $0x18,%esp
  800262:	52                   	push   %edx
  800263:	50                   	push   %eax
  800264:	89 f2                	mov    %esi,%edx
  800266:	89 f8                	mov    %edi,%eax
  800268:	e8 89 ff ff ff       	call   8001f6 <printnum>
  80026d:	83 c4 20             	add    $0x20,%esp
  800270:	eb 13                	jmp    800285 <printnum+0x8f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	56                   	push   %esi
  800276:	ff 75 18             	pushl  0x18(%ebp)
  800279:	ff d7                	call   *%edi
  80027b:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80027e:	83 eb 01             	sub    $0x1,%ebx
  800281:	85 db                	test   %ebx,%ebx
  800283:	7f ed                	jg     800272 <printnum+0x7c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800285:	83 ec 08             	sub    $0x8,%esp
  800288:	56                   	push   %esi
  800289:	83 ec 04             	sub    $0x4,%esp
  80028c:	ff 75 dc             	pushl  -0x24(%ebp)
  80028f:	ff 75 d8             	pushl  -0x28(%ebp)
  800292:	ff 75 d4             	pushl  -0x2c(%ebp)
  800295:	ff 75 d0             	pushl  -0x30(%ebp)
  800298:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  80029b:	89 f3                	mov    %esi,%ebx
  80029d:	e8 ce 09 00 00       	call   800c70 <__umoddi3>
  8002a2:	83 c4 14             	add    $0x14,%esp
  8002a5:	0f be 84 06 a9 ed ff 	movsbl -0x1257(%esi,%eax,1),%eax
  8002ac:	ff 
  8002ad:	50                   	push   %eax
  8002ae:	ff d7                	call   *%edi
}
  8002b0:	83 c4 10             	add    $0x10,%esp
  8002b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b6:	5b                   	pop    %ebx
  8002b7:	5e                   	pop    %esi
  8002b8:	5f                   	pop    %edi
  8002b9:	5d                   	pop    %ebp
  8002ba:	c3                   	ret    
  8002bb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002be:	eb be                	jmp    80027e <printnum+0x88>

008002c0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002c6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002ca:	8b 10                	mov    (%eax),%edx
  8002cc:	3b 50 04             	cmp    0x4(%eax),%edx
  8002cf:	73 0a                	jae    8002db <sprintputch+0x1b>
		*b->buf++ = ch;
  8002d1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002d4:	89 08                	mov    %ecx,(%eax)
  8002d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d9:	88 02                	mov    %al,(%edx)
}
  8002db:	5d                   	pop    %ebp
  8002dc:	c3                   	ret    

008002dd <printfmt>:
{
  8002dd:	55                   	push   %ebp
  8002de:	89 e5                	mov    %esp,%ebp
  8002e0:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002e3:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002e6:	50                   	push   %eax
  8002e7:	ff 75 10             	pushl  0x10(%ebp)
  8002ea:	ff 75 0c             	pushl  0xc(%ebp)
  8002ed:	ff 75 08             	pushl  0x8(%ebp)
  8002f0:	e8 05 00 00 00       	call   8002fa <vprintfmt>
}
  8002f5:	83 c4 10             	add    $0x10,%esp
  8002f8:	c9                   	leave  
  8002f9:	c3                   	ret    

008002fa <vprintfmt>:
{
  8002fa:	55                   	push   %ebp
  8002fb:	89 e5                	mov    %esp,%ebp
  8002fd:	57                   	push   %edi
  8002fe:	56                   	push   %esi
  8002ff:	53                   	push   %ebx
  800300:	83 ec 2c             	sub    $0x2c,%esp
  800303:	e8 35 fd ff ff       	call   80003d <__x86.get_pc_thunk.bx>
  800308:	81 c3 f8 1c 00 00    	add    $0x1cf8,%ebx
  80030e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800311:	8b 7d 10             	mov    0x10(%ebp),%edi
  800314:	e9 8e 03 00 00       	jmp    8006a7 <.L35+0x48>
		padc = ' ';
  800319:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80031d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800324:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80032b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800332:	b9 00 00 00 00       	mov    $0x0,%ecx
  800337:	89 4d cc             	mov    %ecx,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80033a:	8d 47 01             	lea    0x1(%edi),%eax
  80033d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800340:	0f b6 17             	movzbl (%edi),%edx
  800343:	8d 42 dd             	lea    -0x23(%edx),%eax
  800346:	3c 55                	cmp    $0x55,%al
  800348:	0f 87 e1 03 00 00    	ja     80072f <.L22>
  80034e:	0f b6 c0             	movzbl %al,%eax
  800351:	89 d9                	mov    %ebx,%ecx
  800353:	03 8c 83 38 ee ff ff 	add    -0x11c8(%ebx,%eax,4),%ecx
  80035a:	ff e1                	jmp    *%ecx

0080035c <.L67>:
  80035c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80035f:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800363:	eb d5                	jmp    80033a <vprintfmt+0x40>

00800365 <.L28>:
		switch (ch = *(unsigned char *) fmt++) {
  800365:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800368:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80036c:	eb cc                	jmp    80033a <vprintfmt+0x40>

0080036e <.L29>:
		switch (ch = *(unsigned char *) fmt++) {
  80036e:	0f b6 d2             	movzbl %dl,%edx
  800371:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800374:	b8 00 00 00 00       	mov    $0x0,%eax
				precision = precision * 10 + ch - '0';
  800379:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80037c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800380:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800383:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800386:	83 f9 09             	cmp    $0x9,%ecx
  800389:	77 55                	ja     8003e0 <.L23+0xf>
			for (precision = 0; ; ++fmt) {
  80038b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80038e:	eb e9                	jmp    800379 <.L29+0xb>

00800390 <.L26>:
			precision = va_arg(ap, int);
  800390:	8b 45 14             	mov    0x14(%ebp),%eax
  800393:	8b 00                	mov    (%eax),%eax
  800395:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800398:	8b 45 14             	mov    0x14(%ebp),%eax
  80039b:	8d 40 04             	lea    0x4(%eax),%eax
  80039e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003a1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003a4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003a8:	79 90                	jns    80033a <vprintfmt+0x40>
				width = precision, precision = -1;
  8003aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003b0:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003b7:	eb 81                	jmp    80033a <vprintfmt+0x40>

008003b9 <.L27>:
  8003b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003bc:	85 c0                	test   %eax,%eax
  8003be:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c3:	0f 49 d0             	cmovns %eax,%edx
  8003c6:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003cc:	e9 69 ff ff ff       	jmp    80033a <vprintfmt+0x40>

008003d1 <.L23>:
  8003d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003d4:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003db:	e9 5a ff ff ff       	jmp    80033a <vprintfmt+0x40>
  8003e0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003e3:	eb bf                	jmp    8003a4 <.L26+0x14>

008003e5 <.L33>:
			lflag++;
  8003e5:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003ec:	e9 49 ff ff ff       	jmp    80033a <vprintfmt+0x40>

008003f1 <.L30>:
			putch(va_arg(ap, int), putdat);
  8003f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f4:	8d 78 04             	lea    0x4(%eax),%edi
  8003f7:	83 ec 08             	sub    $0x8,%esp
  8003fa:	56                   	push   %esi
  8003fb:	ff 30                	pushl  (%eax)
  8003fd:	ff 55 08             	call   *0x8(%ebp)
			break;
  800400:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800403:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800406:	e9 99 02 00 00       	jmp    8006a4 <.L35+0x45>

0080040b <.L32>:
			err = va_arg(ap, int);
  80040b:	8b 45 14             	mov    0x14(%ebp),%eax
  80040e:	8d 78 04             	lea    0x4(%eax),%edi
  800411:	8b 00                	mov    (%eax),%eax
  800413:	99                   	cltd   
  800414:	31 d0                	xor    %edx,%eax
  800416:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800418:	83 f8 06             	cmp    $0x6,%eax
  80041b:	7f 27                	jg     800444 <.L32+0x39>
  80041d:	8b 94 83 0c 00 00 00 	mov    0xc(%ebx,%eax,4),%edx
  800424:	85 d2                	test   %edx,%edx
  800426:	74 1c                	je     800444 <.L32+0x39>
				printfmt(putch, putdat, "%s", p);
  800428:	52                   	push   %edx
  800429:	8d 83 ca ed ff ff    	lea    -0x1236(%ebx),%eax
  80042f:	50                   	push   %eax
  800430:	56                   	push   %esi
  800431:	ff 75 08             	pushl  0x8(%ebp)
  800434:	e8 a4 fe ff ff       	call   8002dd <printfmt>
  800439:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80043c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80043f:	e9 60 02 00 00       	jmp    8006a4 <.L35+0x45>
				printfmt(putch, putdat, "error %d", err);
  800444:	50                   	push   %eax
  800445:	8d 83 c1 ed ff ff    	lea    -0x123f(%ebx),%eax
  80044b:	50                   	push   %eax
  80044c:	56                   	push   %esi
  80044d:	ff 75 08             	pushl  0x8(%ebp)
  800450:	e8 88 fe ff ff       	call   8002dd <printfmt>
  800455:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800458:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80045b:	e9 44 02 00 00       	jmp    8006a4 <.L35+0x45>

00800460 <.L36>:
			if ((p = va_arg(ap, char *)) == NULL)
  800460:	8b 45 14             	mov    0x14(%ebp),%eax
  800463:	83 c0 04             	add    $0x4,%eax
  800466:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800469:	8b 45 14             	mov    0x14(%ebp),%eax
  80046c:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80046e:	85 ff                	test   %edi,%edi
  800470:	8d 83 ba ed ff ff    	lea    -0x1246(%ebx),%eax
  800476:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800479:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80047d:	0f 8e b5 00 00 00    	jle    800538 <.L36+0xd8>
  800483:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800487:	75 08                	jne    800491 <.L36+0x31>
  800489:	89 75 0c             	mov    %esi,0xc(%ebp)
  80048c:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80048f:	eb 6d                	jmp    8004fe <.L36+0x9e>
				for (width -= strnlen(p, precision); width > 0; width--)
  800491:	83 ec 08             	sub    $0x8,%esp
  800494:	ff 75 d0             	pushl  -0x30(%ebp)
  800497:	57                   	push   %edi
  800498:	e8 50 03 00 00       	call   8007ed <strnlen>
  80049d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004a0:	29 c2                	sub    %eax,%edx
  8004a2:	89 55 c8             	mov    %edx,-0x38(%ebp)
  8004a5:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004a8:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004af:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004b2:	89 d7                	mov    %edx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b4:	eb 10                	jmp    8004c6 <.L36+0x66>
					putch(padc, putdat);
  8004b6:	83 ec 08             	sub    $0x8,%esp
  8004b9:	56                   	push   %esi
  8004ba:	ff 75 e0             	pushl  -0x20(%ebp)
  8004bd:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c0:	83 ef 01             	sub    $0x1,%edi
  8004c3:	83 c4 10             	add    $0x10,%esp
  8004c6:	85 ff                	test   %edi,%edi
  8004c8:	7f ec                	jg     8004b6 <.L36+0x56>
  8004ca:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004cd:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8004d0:	85 d2                	test   %edx,%edx
  8004d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d7:	0f 49 c2             	cmovns %edx,%eax
  8004da:	29 c2                	sub    %eax,%edx
  8004dc:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004df:	89 75 0c             	mov    %esi,0xc(%ebp)
  8004e2:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004e5:	eb 17                	jmp    8004fe <.L36+0x9e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004e7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004eb:	75 30                	jne    80051d <.L36+0xbd>
					putch(ch, putdat);
  8004ed:	83 ec 08             	sub    $0x8,%esp
  8004f0:	ff 75 0c             	pushl  0xc(%ebp)
  8004f3:	50                   	push   %eax
  8004f4:	ff 55 08             	call   *0x8(%ebp)
  8004f7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004fa:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  8004fe:	83 c7 01             	add    $0x1,%edi
  800501:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800505:	0f be c2             	movsbl %dl,%eax
  800508:	85 c0                	test   %eax,%eax
  80050a:	74 52                	je     80055e <.L36+0xfe>
  80050c:	85 f6                	test   %esi,%esi
  80050e:	78 d7                	js     8004e7 <.L36+0x87>
  800510:	83 ee 01             	sub    $0x1,%esi
  800513:	79 d2                	jns    8004e7 <.L36+0x87>
  800515:	8b 75 0c             	mov    0xc(%ebp),%esi
  800518:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80051b:	eb 32                	jmp    80054f <.L36+0xef>
				if (altflag && (ch < ' ' || ch > '~'))
  80051d:	0f be d2             	movsbl %dl,%edx
  800520:	83 ea 20             	sub    $0x20,%edx
  800523:	83 fa 5e             	cmp    $0x5e,%edx
  800526:	76 c5                	jbe    8004ed <.L36+0x8d>
					putch('?', putdat);
  800528:	83 ec 08             	sub    $0x8,%esp
  80052b:	ff 75 0c             	pushl  0xc(%ebp)
  80052e:	6a 3f                	push   $0x3f
  800530:	ff 55 08             	call   *0x8(%ebp)
  800533:	83 c4 10             	add    $0x10,%esp
  800536:	eb c2                	jmp    8004fa <.L36+0x9a>
  800538:	89 75 0c             	mov    %esi,0xc(%ebp)
  80053b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80053e:	eb be                	jmp    8004fe <.L36+0x9e>
				putch(' ', putdat);
  800540:	83 ec 08             	sub    $0x8,%esp
  800543:	56                   	push   %esi
  800544:	6a 20                	push   $0x20
  800546:	ff 55 08             	call   *0x8(%ebp)
			for (; width > 0; width--)
  800549:	83 ef 01             	sub    $0x1,%edi
  80054c:	83 c4 10             	add    $0x10,%esp
  80054f:	85 ff                	test   %edi,%edi
  800551:	7f ed                	jg     800540 <.L36+0xe0>
			if ((p = va_arg(ap, char *)) == NULL)
  800553:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800556:	89 45 14             	mov    %eax,0x14(%ebp)
  800559:	e9 46 01 00 00       	jmp    8006a4 <.L35+0x45>
  80055e:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800561:	8b 75 0c             	mov    0xc(%ebp),%esi
  800564:	eb e9                	jmp    80054f <.L36+0xef>

00800566 <.L31>:
  800566:	8b 4d cc             	mov    -0x34(%ebp),%ecx
	if (lflag >= 2)
  800569:	83 f9 01             	cmp    $0x1,%ecx
  80056c:	7e 40                	jle    8005ae <.L31+0x48>
		return va_arg(*ap, long long);
  80056e:	8b 45 14             	mov    0x14(%ebp),%eax
  800571:	8b 50 04             	mov    0x4(%eax),%edx
  800574:	8b 00                	mov    (%eax),%eax
  800576:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800579:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8d 40 08             	lea    0x8(%eax),%eax
  800582:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800585:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800589:	79 55                	jns    8005e0 <.L31+0x7a>
				putch('-', putdat);
  80058b:	83 ec 08             	sub    $0x8,%esp
  80058e:	56                   	push   %esi
  80058f:	6a 2d                	push   $0x2d
  800591:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800594:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800597:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80059a:	f7 da                	neg    %edx
  80059c:	83 d1 00             	adc    $0x0,%ecx
  80059f:	f7 d9                	neg    %ecx
  8005a1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005a4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a9:	e9 db 00 00 00       	jmp    800689 <.L35+0x2a>
	else if (lflag)
  8005ae:	85 c9                	test   %ecx,%ecx
  8005b0:	75 17                	jne    8005c9 <.L31+0x63>
		return va_arg(*ap, int);
  8005b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b5:	8b 00                	mov    (%eax),%eax
  8005b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ba:	99                   	cltd   
  8005bb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005be:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c1:	8d 40 04             	lea    0x4(%eax),%eax
  8005c4:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c7:	eb bc                	jmp    800585 <.L31+0x1f>
		return va_arg(*ap, long);
  8005c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d1:	99                   	cltd   
  8005d2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d8:	8d 40 04             	lea    0x4(%eax),%eax
  8005db:	89 45 14             	mov    %eax,0x14(%ebp)
  8005de:	eb a5                	jmp    800585 <.L31+0x1f>
			num = getint(&ap, lflag);
  8005e0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005e3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005e6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005eb:	e9 99 00 00 00       	jmp    800689 <.L35+0x2a>

008005f0 <.L37>:
  8005f0:	8b 4d cc             	mov    -0x34(%ebp),%ecx
	if (lflag >= 2)
  8005f3:	83 f9 01             	cmp    $0x1,%ecx
  8005f6:	7e 15                	jle    80060d <.L37+0x1d>
		return va_arg(*ap, unsigned long long);
  8005f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fb:	8b 10                	mov    (%eax),%edx
  8005fd:	8b 48 04             	mov    0x4(%eax),%ecx
  800600:	8d 40 08             	lea    0x8(%eax),%eax
  800603:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800606:	b8 0a 00 00 00       	mov    $0xa,%eax
  80060b:	eb 7c                	jmp    800689 <.L35+0x2a>
	else if (lflag)
  80060d:	85 c9                	test   %ecx,%ecx
  80060f:	75 17                	jne    800628 <.L37+0x38>
		return va_arg(*ap, unsigned int);
  800611:	8b 45 14             	mov    0x14(%ebp),%eax
  800614:	8b 10                	mov    (%eax),%edx
  800616:	b9 00 00 00 00       	mov    $0x0,%ecx
  80061b:	8d 40 04             	lea    0x4(%eax),%eax
  80061e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800621:	b8 0a 00 00 00       	mov    $0xa,%eax
  800626:	eb 61                	jmp    800689 <.L35+0x2a>
		return va_arg(*ap, unsigned long);
  800628:	8b 45 14             	mov    0x14(%ebp),%eax
  80062b:	8b 10                	mov    (%eax),%edx
  80062d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800632:	8d 40 04             	lea    0x4(%eax),%eax
  800635:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800638:	b8 0a 00 00 00       	mov    $0xa,%eax
  80063d:	eb 4a                	jmp    800689 <.L35+0x2a>

0080063f <.L34>:
			putch('X', putdat);
  80063f:	83 ec 08             	sub    $0x8,%esp
  800642:	56                   	push   %esi
  800643:	6a 58                	push   $0x58
  800645:	ff 55 08             	call   *0x8(%ebp)
			putch('X', putdat);
  800648:	83 c4 08             	add    $0x8,%esp
  80064b:	56                   	push   %esi
  80064c:	6a 58                	push   $0x58
  80064e:	ff 55 08             	call   *0x8(%ebp)
			putch('X', putdat);
  800651:	83 c4 08             	add    $0x8,%esp
  800654:	56                   	push   %esi
  800655:	6a 58                	push   $0x58
  800657:	ff 55 08             	call   *0x8(%ebp)
			break;
  80065a:	83 c4 10             	add    $0x10,%esp
  80065d:	eb 45                	jmp    8006a4 <.L35+0x45>

0080065f <.L35>:
			putch('0', putdat);
  80065f:	83 ec 08             	sub    $0x8,%esp
  800662:	56                   	push   %esi
  800663:	6a 30                	push   $0x30
  800665:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800668:	83 c4 08             	add    $0x8,%esp
  80066b:	56                   	push   %esi
  80066c:	6a 78                	push   $0x78
  80066e:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	8b 10                	mov    (%eax),%edx
  800676:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80067b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80067e:	8d 40 04             	lea    0x4(%eax),%eax
  800681:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800684:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800689:	83 ec 0c             	sub    $0xc,%esp
  80068c:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800690:	57                   	push   %edi
  800691:	ff 75 e0             	pushl  -0x20(%ebp)
  800694:	50                   	push   %eax
  800695:	51                   	push   %ecx
  800696:	52                   	push   %edx
  800697:	89 f2                	mov    %esi,%edx
  800699:	8b 45 08             	mov    0x8(%ebp),%eax
  80069c:	e8 55 fb ff ff       	call   8001f6 <printnum>
			break;
  8006a1:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006a4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006a7:	83 c7 01             	add    $0x1,%edi
  8006aa:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006ae:	83 f8 25             	cmp    $0x25,%eax
  8006b1:	0f 84 62 fc ff ff    	je     800319 <vprintfmt+0x1f>
			if (ch == '\0')
  8006b7:	85 c0                	test   %eax,%eax
  8006b9:	0f 84 91 00 00 00    	je     800750 <.L22+0x21>
			putch(ch, putdat);
  8006bf:	83 ec 08             	sub    $0x8,%esp
  8006c2:	56                   	push   %esi
  8006c3:	50                   	push   %eax
  8006c4:	ff 55 08             	call   *0x8(%ebp)
  8006c7:	83 c4 10             	add    $0x10,%esp
  8006ca:	eb db                	jmp    8006a7 <.L35+0x48>

008006cc <.L38>:
  8006cc:	8b 4d cc             	mov    -0x34(%ebp),%ecx
	if (lflag >= 2)
  8006cf:	83 f9 01             	cmp    $0x1,%ecx
  8006d2:	7e 15                	jle    8006e9 <.L38+0x1d>
		return va_arg(*ap, unsigned long long);
  8006d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d7:	8b 10                	mov    (%eax),%edx
  8006d9:	8b 48 04             	mov    0x4(%eax),%ecx
  8006dc:	8d 40 08             	lea    0x8(%eax),%eax
  8006df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006e2:	b8 10 00 00 00       	mov    $0x10,%eax
  8006e7:	eb a0                	jmp    800689 <.L35+0x2a>
	else if (lflag)
  8006e9:	85 c9                	test   %ecx,%ecx
  8006eb:	75 17                	jne    800704 <.L38+0x38>
		return va_arg(*ap, unsigned int);
  8006ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f0:	8b 10                	mov    (%eax),%edx
  8006f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006f7:	8d 40 04             	lea    0x4(%eax),%eax
  8006fa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006fd:	b8 10 00 00 00       	mov    $0x10,%eax
  800702:	eb 85                	jmp    800689 <.L35+0x2a>
		return va_arg(*ap, unsigned long);
  800704:	8b 45 14             	mov    0x14(%ebp),%eax
  800707:	8b 10                	mov    (%eax),%edx
  800709:	b9 00 00 00 00       	mov    $0x0,%ecx
  80070e:	8d 40 04             	lea    0x4(%eax),%eax
  800711:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800714:	b8 10 00 00 00       	mov    $0x10,%eax
  800719:	e9 6b ff ff ff       	jmp    800689 <.L35+0x2a>

0080071e <.L25>:
			putch(ch, putdat);
  80071e:	83 ec 08             	sub    $0x8,%esp
  800721:	56                   	push   %esi
  800722:	6a 25                	push   $0x25
  800724:	ff 55 08             	call   *0x8(%ebp)
			break;
  800727:	83 c4 10             	add    $0x10,%esp
  80072a:	e9 75 ff ff ff       	jmp    8006a4 <.L35+0x45>

0080072f <.L22>:
			putch('%', putdat);
  80072f:	83 ec 08             	sub    $0x8,%esp
  800732:	56                   	push   %esi
  800733:	6a 25                	push   $0x25
  800735:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800738:	83 c4 10             	add    $0x10,%esp
  80073b:	89 f8                	mov    %edi,%eax
  80073d:	eb 03                	jmp    800742 <.L22+0x13>
  80073f:	83 e8 01             	sub    $0x1,%eax
  800742:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800746:	75 f7                	jne    80073f <.L22+0x10>
  800748:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80074b:	e9 54 ff ff ff       	jmp    8006a4 <.L35+0x45>
}
  800750:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800753:	5b                   	pop    %ebx
  800754:	5e                   	pop    %esi
  800755:	5f                   	pop    %edi
  800756:	5d                   	pop    %ebp
  800757:	c3                   	ret    

00800758 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800758:	55                   	push   %ebp
  800759:	89 e5                	mov    %esp,%ebp
  80075b:	53                   	push   %ebx
  80075c:	83 ec 14             	sub    $0x14,%esp
  80075f:	e8 d9 f8 ff ff       	call   80003d <__x86.get_pc_thunk.bx>
  800764:	81 c3 9c 18 00 00    	add    $0x189c,%ebx
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800770:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800773:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800777:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80077a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800781:	85 c0                	test   %eax,%eax
  800783:	74 2b                	je     8007b0 <vsnprintf+0x58>
  800785:	85 d2                	test   %edx,%edx
  800787:	7e 27                	jle    8007b0 <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800789:	ff 75 14             	pushl  0x14(%ebp)
  80078c:	ff 75 10             	pushl  0x10(%ebp)
  80078f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800792:	50                   	push   %eax
  800793:	8d 83 c0 e2 ff ff    	lea    -0x1d40(%ebx),%eax
  800799:	50                   	push   %eax
  80079a:	e8 5b fb ff ff       	call   8002fa <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80079f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007a2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007a8:	83 c4 10             	add    $0x10,%esp
}
  8007ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007ae:	c9                   	leave  
  8007af:	c3                   	ret    
		return -E_INVAL;
  8007b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007b5:	eb f4                	jmp    8007ab <vsnprintf+0x53>

008007b7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007b7:	55                   	push   %ebp
  8007b8:	89 e5                	mov    %esp,%ebp
  8007ba:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007bd:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007c0:	50                   	push   %eax
  8007c1:	ff 75 10             	pushl  0x10(%ebp)
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	ff 75 08             	pushl  0x8(%ebp)
  8007ca:	e8 89 ff ff ff       	call   800758 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007cf:	c9                   	leave  
  8007d0:	c3                   	ret    

008007d1 <__x86.get_pc_thunk.cx>:
  8007d1:	8b 0c 24             	mov    (%esp),%ecx
  8007d4:	c3                   	ret    

008007d5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007d5:	55                   	push   %ebp
  8007d6:	89 e5                	mov    %esp,%ebp
  8007d8:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007db:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e0:	eb 03                	jmp    8007e5 <strlen+0x10>
		n++;
  8007e2:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007e5:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007e9:	75 f7                	jne    8007e2 <strlen+0xd>
	return n;
}
  8007eb:	5d                   	pop    %ebp
  8007ec:	c3                   	ret    

008007ed <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007ed:	55                   	push   %ebp
  8007ee:	89 e5                	mov    %esp,%ebp
  8007f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007f3:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007fb:	eb 03                	jmp    800800 <strnlen+0x13>
		n++;
  8007fd:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800800:	39 d0                	cmp    %edx,%eax
  800802:	74 06                	je     80080a <strnlen+0x1d>
  800804:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800808:	75 f3                	jne    8007fd <strnlen+0x10>
	return n;
}
  80080a:	5d                   	pop    %ebp
  80080b:	c3                   	ret    

0080080c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80080c:	55                   	push   %ebp
  80080d:	89 e5                	mov    %esp,%ebp
  80080f:	53                   	push   %ebx
  800810:	8b 45 08             	mov    0x8(%ebp),%eax
  800813:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800816:	89 c2                	mov    %eax,%edx
  800818:	83 c1 01             	add    $0x1,%ecx
  80081b:	83 c2 01             	add    $0x1,%edx
  80081e:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800822:	88 5a ff             	mov    %bl,-0x1(%edx)
  800825:	84 db                	test   %bl,%bl
  800827:	75 ef                	jne    800818 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800829:	5b                   	pop    %ebx
  80082a:	5d                   	pop    %ebp
  80082b:	c3                   	ret    

0080082c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80082c:	55                   	push   %ebp
  80082d:	89 e5                	mov    %esp,%ebp
  80082f:	53                   	push   %ebx
  800830:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800833:	53                   	push   %ebx
  800834:	e8 9c ff ff ff       	call   8007d5 <strlen>
  800839:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80083c:	ff 75 0c             	pushl  0xc(%ebp)
  80083f:	01 d8                	add    %ebx,%eax
  800841:	50                   	push   %eax
  800842:	e8 c5 ff ff ff       	call   80080c <strcpy>
	return dst;
}
  800847:	89 d8                	mov    %ebx,%eax
  800849:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80084c:	c9                   	leave  
  80084d:	c3                   	ret    

0080084e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80084e:	55                   	push   %ebp
  80084f:	89 e5                	mov    %esp,%ebp
  800851:	56                   	push   %esi
  800852:	53                   	push   %ebx
  800853:	8b 75 08             	mov    0x8(%ebp),%esi
  800856:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800859:	89 f3                	mov    %esi,%ebx
  80085b:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80085e:	89 f2                	mov    %esi,%edx
  800860:	eb 0f                	jmp    800871 <strncpy+0x23>
		*dst++ = *src;
  800862:	83 c2 01             	add    $0x1,%edx
  800865:	0f b6 01             	movzbl (%ecx),%eax
  800868:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80086b:	80 39 01             	cmpb   $0x1,(%ecx)
  80086e:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800871:	39 da                	cmp    %ebx,%edx
  800873:	75 ed                	jne    800862 <strncpy+0x14>
	}
	return ret;
}
  800875:	89 f0                	mov    %esi,%eax
  800877:	5b                   	pop    %ebx
  800878:	5e                   	pop    %esi
  800879:	5d                   	pop    %ebp
  80087a:	c3                   	ret    

0080087b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80087b:	55                   	push   %ebp
  80087c:	89 e5                	mov    %esp,%ebp
  80087e:	56                   	push   %esi
  80087f:	53                   	push   %ebx
  800880:	8b 75 08             	mov    0x8(%ebp),%esi
  800883:	8b 55 0c             	mov    0xc(%ebp),%edx
  800886:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800889:	89 f0                	mov    %esi,%eax
  80088b:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80088f:	85 c9                	test   %ecx,%ecx
  800891:	75 0b                	jne    80089e <strlcpy+0x23>
  800893:	eb 17                	jmp    8008ac <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800895:	83 c2 01             	add    $0x1,%edx
  800898:	83 c0 01             	add    $0x1,%eax
  80089b:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80089e:	39 d8                	cmp    %ebx,%eax
  8008a0:	74 07                	je     8008a9 <strlcpy+0x2e>
  8008a2:	0f b6 0a             	movzbl (%edx),%ecx
  8008a5:	84 c9                	test   %cl,%cl
  8008a7:	75 ec                	jne    800895 <strlcpy+0x1a>
		*dst = '\0';
  8008a9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008ac:	29 f0                	sub    %esi,%eax
}
  8008ae:	5b                   	pop    %ebx
  8008af:	5e                   	pop    %esi
  8008b0:	5d                   	pop    %ebp
  8008b1:	c3                   	ret    

008008b2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008b2:	55                   	push   %ebp
  8008b3:	89 e5                	mov    %esp,%ebp
  8008b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008b8:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008bb:	eb 06                	jmp    8008c3 <strcmp+0x11>
		p++, q++;
  8008bd:	83 c1 01             	add    $0x1,%ecx
  8008c0:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008c3:	0f b6 01             	movzbl (%ecx),%eax
  8008c6:	84 c0                	test   %al,%al
  8008c8:	74 04                	je     8008ce <strcmp+0x1c>
  8008ca:	3a 02                	cmp    (%edx),%al
  8008cc:	74 ef                	je     8008bd <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008ce:	0f b6 c0             	movzbl %al,%eax
  8008d1:	0f b6 12             	movzbl (%edx),%edx
  8008d4:	29 d0                	sub    %edx,%eax
}
  8008d6:	5d                   	pop    %ebp
  8008d7:	c3                   	ret    

008008d8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008d8:	55                   	push   %ebp
  8008d9:	89 e5                	mov    %esp,%ebp
  8008db:	53                   	push   %ebx
  8008dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e2:	89 c3                	mov    %eax,%ebx
  8008e4:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008e7:	eb 06                	jmp    8008ef <strncmp+0x17>
		n--, p++, q++;
  8008e9:	83 c0 01             	add    $0x1,%eax
  8008ec:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008ef:	39 d8                	cmp    %ebx,%eax
  8008f1:	74 16                	je     800909 <strncmp+0x31>
  8008f3:	0f b6 08             	movzbl (%eax),%ecx
  8008f6:	84 c9                	test   %cl,%cl
  8008f8:	74 04                	je     8008fe <strncmp+0x26>
  8008fa:	3a 0a                	cmp    (%edx),%cl
  8008fc:	74 eb                	je     8008e9 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008fe:	0f b6 00             	movzbl (%eax),%eax
  800901:	0f b6 12             	movzbl (%edx),%edx
  800904:	29 d0                	sub    %edx,%eax
}
  800906:	5b                   	pop    %ebx
  800907:	5d                   	pop    %ebp
  800908:	c3                   	ret    
		return 0;
  800909:	b8 00 00 00 00       	mov    $0x0,%eax
  80090e:	eb f6                	jmp    800906 <strncmp+0x2e>

00800910 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
  800913:	8b 45 08             	mov    0x8(%ebp),%eax
  800916:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80091a:	0f b6 10             	movzbl (%eax),%edx
  80091d:	84 d2                	test   %dl,%dl
  80091f:	74 09                	je     80092a <strchr+0x1a>
		if (*s == c)
  800921:	38 ca                	cmp    %cl,%dl
  800923:	74 0a                	je     80092f <strchr+0x1f>
	for (; *s; s++)
  800925:	83 c0 01             	add    $0x1,%eax
  800928:	eb f0                	jmp    80091a <strchr+0xa>
			return (char *) s;
	return 0;
  80092a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80092f:	5d                   	pop    %ebp
  800930:	c3                   	ret    

00800931 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800931:	55                   	push   %ebp
  800932:	89 e5                	mov    %esp,%ebp
  800934:	8b 45 08             	mov    0x8(%ebp),%eax
  800937:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80093b:	eb 03                	jmp    800940 <strfind+0xf>
  80093d:	83 c0 01             	add    $0x1,%eax
  800940:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800943:	38 ca                	cmp    %cl,%dl
  800945:	74 04                	je     80094b <strfind+0x1a>
  800947:	84 d2                	test   %dl,%dl
  800949:	75 f2                	jne    80093d <strfind+0xc>
			break;
	return (char *) s;
}
  80094b:	5d                   	pop    %ebp
  80094c:	c3                   	ret    

0080094d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80094d:	55                   	push   %ebp
  80094e:	89 e5                	mov    %esp,%ebp
  800950:	57                   	push   %edi
  800951:	56                   	push   %esi
  800952:	53                   	push   %ebx
  800953:	8b 7d 08             	mov    0x8(%ebp),%edi
  800956:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800959:	85 c9                	test   %ecx,%ecx
  80095b:	74 13                	je     800970 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80095d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800963:	75 05                	jne    80096a <memset+0x1d>
  800965:	f6 c1 03             	test   $0x3,%cl
  800968:	74 0d                	je     800977 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80096a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096d:	fc                   	cld    
  80096e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800970:	89 f8                	mov    %edi,%eax
  800972:	5b                   	pop    %ebx
  800973:	5e                   	pop    %esi
  800974:	5f                   	pop    %edi
  800975:	5d                   	pop    %ebp
  800976:	c3                   	ret    
		c &= 0xFF;
  800977:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80097b:	89 d3                	mov    %edx,%ebx
  80097d:	c1 e3 08             	shl    $0x8,%ebx
  800980:	89 d0                	mov    %edx,%eax
  800982:	c1 e0 18             	shl    $0x18,%eax
  800985:	89 d6                	mov    %edx,%esi
  800987:	c1 e6 10             	shl    $0x10,%esi
  80098a:	09 f0                	or     %esi,%eax
  80098c:	09 c2                	or     %eax,%edx
  80098e:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800990:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800993:	89 d0                	mov    %edx,%eax
  800995:	fc                   	cld    
  800996:	f3 ab                	rep stos %eax,%es:(%edi)
  800998:	eb d6                	jmp    800970 <memset+0x23>

0080099a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80099a:	55                   	push   %ebp
  80099b:	89 e5                	mov    %esp,%ebp
  80099d:	57                   	push   %edi
  80099e:	56                   	push   %esi
  80099f:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009a8:	39 c6                	cmp    %eax,%esi
  8009aa:	73 35                	jae    8009e1 <memmove+0x47>
  8009ac:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009af:	39 c2                	cmp    %eax,%edx
  8009b1:	76 2e                	jbe    8009e1 <memmove+0x47>
		s += n;
		d += n;
  8009b3:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009b6:	89 d6                	mov    %edx,%esi
  8009b8:	09 fe                	or     %edi,%esi
  8009ba:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009c0:	74 0c                	je     8009ce <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009c2:	83 ef 01             	sub    $0x1,%edi
  8009c5:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009c8:	fd                   	std    
  8009c9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009cb:	fc                   	cld    
  8009cc:	eb 21                	jmp    8009ef <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009ce:	f6 c1 03             	test   $0x3,%cl
  8009d1:	75 ef                	jne    8009c2 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009d3:	83 ef 04             	sub    $0x4,%edi
  8009d6:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009d9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009dc:	fd                   	std    
  8009dd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009df:	eb ea                	jmp    8009cb <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009e1:	89 f2                	mov    %esi,%edx
  8009e3:	09 c2                	or     %eax,%edx
  8009e5:	f6 c2 03             	test   $0x3,%dl
  8009e8:	74 09                	je     8009f3 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009ea:	89 c7                	mov    %eax,%edi
  8009ec:	fc                   	cld    
  8009ed:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009ef:	5e                   	pop    %esi
  8009f0:	5f                   	pop    %edi
  8009f1:	5d                   	pop    %ebp
  8009f2:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009f3:	f6 c1 03             	test   $0x3,%cl
  8009f6:	75 f2                	jne    8009ea <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009f8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009fb:	89 c7                	mov    %eax,%edi
  8009fd:	fc                   	cld    
  8009fe:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a00:	eb ed                	jmp    8009ef <memmove+0x55>

00800a02 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a02:	55                   	push   %ebp
  800a03:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a05:	ff 75 10             	pushl  0x10(%ebp)
  800a08:	ff 75 0c             	pushl  0xc(%ebp)
  800a0b:	ff 75 08             	pushl  0x8(%ebp)
  800a0e:	e8 87 ff ff ff       	call   80099a <memmove>
}
  800a13:	c9                   	leave  
  800a14:	c3                   	ret    

00800a15 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a15:	55                   	push   %ebp
  800a16:	89 e5                	mov    %esp,%ebp
  800a18:	56                   	push   %esi
  800a19:	53                   	push   %ebx
  800a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a20:	89 c6                	mov    %eax,%esi
  800a22:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a25:	39 f0                	cmp    %esi,%eax
  800a27:	74 1c                	je     800a45 <memcmp+0x30>
		if (*s1 != *s2)
  800a29:	0f b6 08             	movzbl (%eax),%ecx
  800a2c:	0f b6 1a             	movzbl (%edx),%ebx
  800a2f:	38 d9                	cmp    %bl,%cl
  800a31:	75 08                	jne    800a3b <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a33:	83 c0 01             	add    $0x1,%eax
  800a36:	83 c2 01             	add    $0x1,%edx
  800a39:	eb ea                	jmp    800a25 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a3b:	0f b6 c1             	movzbl %cl,%eax
  800a3e:	0f b6 db             	movzbl %bl,%ebx
  800a41:	29 d8                	sub    %ebx,%eax
  800a43:	eb 05                	jmp    800a4a <memcmp+0x35>
	}

	return 0;
  800a45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a4a:	5b                   	pop    %ebx
  800a4b:	5e                   	pop    %esi
  800a4c:	5d                   	pop    %ebp
  800a4d:	c3                   	ret    

00800a4e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a4e:	55                   	push   %ebp
  800a4f:	89 e5                	mov    %esp,%ebp
  800a51:	8b 45 08             	mov    0x8(%ebp),%eax
  800a54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a57:	89 c2                	mov    %eax,%edx
  800a59:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a5c:	39 d0                	cmp    %edx,%eax
  800a5e:	73 09                	jae    800a69 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a60:	38 08                	cmp    %cl,(%eax)
  800a62:	74 05                	je     800a69 <memfind+0x1b>
	for (; s < ends; s++)
  800a64:	83 c0 01             	add    $0x1,%eax
  800a67:	eb f3                	jmp    800a5c <memfind+0xe>
			break;
	return (void *) s;
}
  800a69:	5d                   	pop    %ebp
  800a6a:	c3                   	ret    

00800a6b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a6b:	55                   	push   %ebp
  800a6c:	89 e5                	mov    %esp,%ebp
  800a6e:	57                   	push   %edi
  800a6f:	56                   	push   %esi
  800a70:	53                   	push   %ebx
  800a71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a74:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a77:	eb 03                	jmp    800a7c <strtol+0x11>
		s++;
  800a79:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a7c:	0f b6 01             	movzbl (%ecx),%eax
  800a7f:	3c 20                	cmp    $0x20,%al
  800a81:	74 f6                	je     800a79 <strtol+0xe>
  800a83:	3c 09                	cmp    $0x9,%al
  800a85:	74 f2                	je     800a79 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a87:	3c 2b                	cmp    $0x2b,%al
  800a89:	74 2e                	je     800ab9 <strtol+0x4e>
	int neg = 0;
  800a8b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a90:	3c 2d                	cmp    $0x2d,%al
  800a92:	74 2f                	je     800ac3 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a94:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a9a:	75 05                	jne    800aa1 <strtol+0x36>
  800a9c:	80 39 30             	cmpb   $0x30,(%ecx)
  800a9f:	74 2c                	je     800acd <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800aa1:	85 db                	test   %ebx,%ebx
  800aa3:	75 0a                	jne    800aaf <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aa5:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800aaa:	80 39 30             	cmpb   $0x30,(%ecx)
  800aad:	74 28                	je     800ad7 <strtol+0x6c>
		base = 10;
  800aaf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ab7:	eb 50                	jmp    800b09 <strtol+0x9e>
		s++;
  800ab9:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800abc:	bf 00 00 00 00       	mov    $0x0,%edi
  800ac1:	eb d1                	jmp    800a94 <strtol+0x29>
		s++, neg = 1;
  800ac3:	83 c1 01             	add    $0x1,%ecx
  800ac6:	bf 01 00 00 00       	mov    $0x1,%edi
  800acb:	eb c7                	jmp    800a94 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800acd:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ad1:	74 0e                	je     800ae1 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ad3:	85 db                	test   %ebx,%ebx
  800ad5:	75 d8                	jne    800aaf <strtol+0x44>
		s++, base = 8;
  800ad7:	83 c1 01             	add    $0x1,%ecx
  800ada:	bb 08 00 00 00       	mov    $0x8,%ebx
  800adf:	eb ce                	jmp    800aaf <strtol+0x44>
		s += 2, base = 16;
  800ae1:	83 c1 02             	add    $0x2,%ecx
  800ae4:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ae9:	eb c4                	jmp    800aaf <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800aeb:	8d 72 9f             	lea    -0x61(%edx),%esi
  800aee:	89 f3                	mov    %esi,%ebx
  800af0:	80 fb 19             	cmp    $0x19,%bl
  800af3:	77 29                	ja     800b1e <strtol+0xb3>
			dig = *s - 'a' + 10;
  800af5:	0f be d2             	movsbl %dl,%edx
  800af8:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800afb:	3b 55 10             	cmp    0x10(%ebp),%edx
  800afe:	7d 30                	jge    800b30 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b00:	83 c1 01             	add    $0x1,%ecx
  800b03:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b07:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b09:	0f b6 11             	movzbl (%ecx),%edx
  800b0c:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b0f:	89 f3                	mov    %esi,%ebx
  800b11:	80 fb 09             	cmp    $0x9,%bl
  800b14:	77 d5                	ja     800aeb <strtol+0x80>
			dig = *s - '0';
  800b16:	0f be d2             	movsbl %dl,%edx
  800b19:	83 ea 30             	sub    $0x30,%edx
  800b1c:	eb dd                	jmp    800afb <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b1e:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b21:	89 f3                	mov    %esi,%ebx
  800b23:	80 fb 19             	cmp    $0x19,%bl
  800b26:	77 08                	ja     800b30 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b28:	0f be d2             	movsbl %dl,%edx
  800b2b:	83 ea 37             	sub    $0x37,%edx
  800b2e:	eb cb                	jmp    800afb <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b30:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b34:	74 05                	je     800b3b <strtol+0xd0>
		*endptr = (char *) s;
  800b36:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b39:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b3b:	89 c2                	mov    %eax,%edx
  800b3d:	f7 da                	neg    %edx
  800b3f:	85 ff                	test   %edi,%edi
  800b41:	0f 45 c2             	cmovne %edx,%eax
}
  800b44:	5b                   	pop    %ebx
  800b45:	5e                   	pop    %esi
  800b46:	5f                   	pop    %edi
  800b47:	5d                   	pop    %ebp
  800b48:	c3                   	ret    
  800b49:	66 90                	xchg   %ax,%ax
  800b4b:	66 90                	xchg   %ax,%ax
  800b4d:	66 90                	xchg   %ax,%ax
  800b4f:	90                   	nop

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
