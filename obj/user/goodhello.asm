
obj/user/goodhello:     file format elf32-i386


Disassembly of section .text:

00800020 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800020:	55                   	push   %ebp
  800021:	89 e5                	mov    %esp,%ebp
  800023:	53                   	push   %ebx
  800024:	83 ec 10             	sub    $0x10,%esp
  800027:	e8 1f 00 00 00       	call   80004b <__x86.get_pc_thunk.bx>
  80002c:	81 c3 d4 1f 00 00    	add    $0x1fd4,%ebx
	cprintf("hello, world\n");
  800032:	8d 83 9c ed ff ff    	lea    -0x1264(%ebx),%eax
  800038:	50                   	push   %eax
  800039:	e8 e3 00 00 00       	call   800121 <cprintf>
	exit();
  80003e:	e8 0c 00 00 00       	call   80004f <exit>
}
  800043:	83 c4 10             	add    $0x10,%esp
  800046:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800049:	c9                   	leave  
  80004a:	c3                   	ret    

0080004b <__x86.get_pc_thunk.bx>:
  80004b:	8b 1c 24             	mov    (%esp),%ebx
  80004e:	c3                   	ret    

0080004f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80004f:	55                   	push   %ebp
  800050:	89 e5                	mov    %esp,%ebp
  800052:	53                   	push   %ebx
  800053:	83 ec 10             	sub    $0x10,%esp
  800056:	e8 f0 ff ff ff       	call   80004b <__x86.get_pc_thunk.bx>
  80005b:	81 c3 a5 1f 00 00    	add    $0x1fa5,%ebx
	sys_env_destroy(0);
  800061:	6a 00                	push   $0x0
  800063:	e8 5d 0a 00 00       	call   800ac5 <sys_env_destroy>
}
  800068:	83 c4 10             	add    $0x10,%esp
  80006b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80006e:	c9                   	leave  
  80006f:	c3                   	ret    

00800070 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800070:	55                   	push   %ebp
  800071:	89 e5                	mov    %esp,%ebp
  800073:	56                   	push   %esi
  800074:	53                   	push   %ebx
  800075:	e8 d1 ff ff ff       	call   80004b <__x86.get_pc_thunk.bx>
  80007a:	81 c3 86 1f 00 00    	add    $0x1f86,%ebx
  800080:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  800083:	8b 16                	mov    (%esi),%edx
  800085:	8d 42 01             	lea    0x1(%edx),%eax
  800088:	89 06                	mov    %eax,(%esi)
  80008a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80008d:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  800091:	3d ff 00 00 00       	cmp    $0xff,%eax
  800096:	74 0b                	je     8000a3 <putch+0x33>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800098:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  80009c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80009f:	5b                   	pop    %ebx
  8000a0:	5e                   	pop    %esi
  8000a1:	5d                   	pop    %ebp
  8000a2:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000a3:	83 ec 08             	sub    $0x8,%esp
  8000a6:	68 ff 00 00 00       	push   $0xff
  8000ab:	8d 46 08             	lea    0x8(%esi),%eax
  8000ae:	50                   	push   %eax
  8000af:	e8 d4 09 00 00       	call   800a88 <sys_cputs>
		b->idx = 0;
  8000b4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  8000ba:	83 c4 10             	add    $0x10,%esp
  8000bd:	eb d9                	jmp    800098 <putch+0x28>

008000bf <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8000bf:	55                   	push   %ebp
  8000c0:	89 e5                	mov    %esp,%ebp
  8000c2:	53                   	push   %ebx
  8000c3:	81 ec 14 01 00 00    	sub    $0x114,%esp
  8000c9:	e8 7d ff ff ff       	call   80004b <__x86.get_pc_thunk.bx>
  8000ce:	81 c3 32 1f 00 00    	add    $0x1f32,%ebx
	struct printbuf b;

	b.idx = 0;
  8000d4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8000db:	00 00 00 
	b.cnt = 0;
  8000de:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8000e5:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8000e8:	ff 75 0c             	pushl  0xc(%ebp)
  8000eb:	ff 75 08             	pushl  0x8(%ebp)
  8000ee:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8000f4:	50                   	push   %eax
  8000f5:	8d 83 70 e0 ff ff    	lea    -0x1f90(%ebx),%eax
  8000fb:	50                   	push   %eax
  8000fc:	e8 38 01 00 00       	call   800239 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800101:	83 c4 08             	add    $0x8,%esp
  800104:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80010a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800110:	50                   	push   %eax
  800111:	e8 72 09 00 00       	call   800a88 <sys_cputs>

	return b.cnt;
}
  800116:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80011c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80011f:	c9                   	leave  
  800120:	c3                   	ret    

00800121 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800121:	55                   	push   %ebp
  800122:	89 e5                	mov    %esp,%ebp
  800124:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800127:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80012a:	50                   	push   %eax
  80012b:	ff 75 08             	pushl  0x8(%ebp)
  80012e:	e8 8c ff ff ff       	call   8000bf <vcprintf>
	va_end(ap);

	return cnt;
}
  800133:	c9                   	leave  
  800134:	c3                   	ret    

00800135 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800135:	55                   	push   %ebp
  800136:	89 e5                	mov    %esp,%ebp
  800138:	57                   	push   %edi
  800139:	56                   	push   %esi
  80013a:	53                   	push   %ebx
  80013b:	83 ec 2c             	sub    $0x2c,%esp
  80013e:	e8 cd 05 00 00       	call   800710 <__x86.get_pc_thunk.cx>
  800143:	81 c1 bd 1e 00 00    	add    $0x1ebd,%ecx
  800149:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  80014c:	89 c7                	mov    %eax,%edi
  80014e:	89 d6                	mov    %edx,%esi
  800150:	8b 45 08             	mov    0x8(%ebp),%eax
  800153:	8b 55 0c             	mov    0xc(%ebp),%edx
  800156:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800159:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80015c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80015f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800164:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  800167:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  80016a:	39 d3                	cmp    %edx,%ebx
  80016c:	72 09                	jb     800177 <printnum+0x42>
  80016e:	39 45 10             	cmp    %eax,0x10(%ebp)
  800171:	0f 87 83 00 00 00    	ja     8001fa <printnum+0xc5>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800177:	83 ec 0c             	sub    $0xc,%esp
  80017a:	ff 75 18             	pushl  0x18(%ebp)
  80017d:	8b 45 14             	mov    0x14(%ebp),%eax
  800180:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800183:	53                   	push   %ebx
  800184:	ff 75 10             	pushl  0x10(%ebp)
  800187:	83 ec 08             	sub    $0x8,%esp
  80018a:	ff 75 dc             	pushl  -0x24(%ebp)
  80018d:	ff 75 d8             	pushl  -0x28(%ebp)
  800190:	ff 75 d4             	pushl  -0x2c(%ebp)
  800193:	ff 75 d0             	pushl  -0x30(%ebp)
  800196:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800199:	e8 c2 09 00 00       	call   800b60 <__udivdi3>
  80019e:	83 c4 18             	add    $0x18,%esp
  8001a1:	52                   	push   %edx
  8001a2:	50                   	push   %eax
  8001a3:	89 f2                	mov    %esi,%edx
  8001a5:	89 f8                	mov    %edi,%eax
  8001a7:	e8 89 ff ff ff       	call   800135 <printnum>
  8001ac:	83 c4 20             	add    $0x20,%esp
  8001af:	eb 13                	jmp    8001c4 <printnum+0x8f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001b1:	83 ec 08             	sub    $0x8,%esp
  8001b4:	56                   	push   %esi
  8001b5:	ff 75 18             	pushl  0x18(%ebp)
  8001b8:	ff d7                	call   *%edi
  8001ba:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001bd:	83 eb 01             	sub    $0x1,%ebx
  8001c0:	85 db                	test   %ebx,%ebx
  8001c2:	7f ed                	jg     8001b1 <printnum+0x7c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	56                   	push   %esi
  8001c8:	83 ec 04             	sub    $0x4,%esp
  8001cb:	ff 75 dc             	pushl  -0x24(%ebp)
  8001ce:	ff 75 d8             	pushl  -0x28(%ebp)
  8001d1:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001d4:	ff 75 d0             	pushl  -0x30(%ebp)
  8001d7:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8001da:	89 f3                	mov    %esi,%ebx
  8001dc:	e8 9f 0a 00 00       	call   800c80 <__umoddi3>
  8001e1:	83 c4 14             	add    $0x14,%esp
  8001e4:	0f be 84 06 aa ed ff 	movsbl -0x1256(%esi,%eax,1),%eax
  8001eb:	ff 
  8001ec:	50                   	push   %eax
  8001ed:	ff d7                	call   *%edi
}
  8001ef:	83 c4 10             	add    $0x10,%esp
  8001f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001f5:	5b                   	pop    %ebx
  8001f6:	5e                   	pop    %esi
  8001f7:	5f                   	pop    %edi
  8001f8:	5d                   	pop    %ebp
  8001f9:	c3                   	ret    
  8001fa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8001fd:	eb be                	jmp    8001bd <printnum+0x88>

008001ff <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8001ff:	55                   	push   %ebp
  800200:	89 e5                	mov    %esp,%ebp
  800202:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800205:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800209:	8b 10                	mov    (%eax),%edx
  80020b:	3b 50 04             	cmp    0x4(%eax),%edx
  80020e:	73 0a                	jae    80021a <sprintputch+0x1b>
		*b->buf++ = ch;
  800210:	8d 4a 01             	lea    0x1(%edx),%ecx
  800213:	89 08                	mov    %ecx,(%eax)
  800215:	8b 45 08             	mov    0x8(%ebp),%eax
  800218:	88 02                	mov    %al,(%edx)
}
  80021a:	5d                   	pop    %ebp
  80021b:	c3                   	ret    

0080021c <printfmt>:
{
  80021c:	55                   	push   %ebp
  80021d:	89 e5                	mov    %esp,%ebp
  80021f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800222:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800225:	50                   	push   %eax
  800226:	ff 75 10             	pushl  0x10(%ebp)
  800229:	ff 75 0c             	pushl  0xc(%ebp)
  80022c:	ff 75 08             	pushl  0x8(%ebp)
  80022f:	e8 05 00 00 00       	call   800239 <vprintfmt>
}
  800234:	83 c4 10             	add    $0x10,%esp
  800237:	c9                   	leave  
  800238:	c3                   	ret    

00800239 <vprintfmt>:
{
  800239:	55                   	push   %ebp
  80023a:	89 e5                	mov    %esp,%ebp
  80023c:	57                   	push   %edi
  80023d:	56                   	push   %esi
  80023e:	53                   	push   %ebx
  80023f:	83 ec 2c             	sub    $0x2c,%esp
  800242:	e8 04 fe ff ff       	call   80004b <__x86.get_pc_thunk.bx>
  800247:	81 c3 b9 1d 00 00    	add    $0x1db9,%ebx
  80024d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800250:	8b 7d 10             	mov    0x10(%ebp),%edi
  800253:	e9 8e 03 00 00       	jmp    8005e6 <.L35+0x48>
		padc = ' ';
  800258:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80025c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800263:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80026a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800271:	b9 00 00 00 00       	mov    $0x0,%ecx
  800276:	89 4d cc             	mov    %ecx,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800279:	8d 47 01             	lea    0x1(%edi),%eax
  80027c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80027f:	0f b6 17             	movzbl (%edi),%edx
  800282:	8d 42 dd             	lea    -0x23(%edx),%eax
  800285:	3c 55                	cmp    $0x55,%al
  800287:	0f 87 e1 03 00 00    	ja     80066e <.L22>
  80028d:	0f b6 c0             	movzbl %al,%eax
  800290:	89 d9                	mov    %ebx,%ecx
  800292:	03 8c 83 38 ee ff ff 	add    -0x11c8(%ebx,%eax,4),%ecx
  800299:	ff e1                	jmp    *%ecx

0080029b <.L67>:
  80029b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80029e:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002a2:	eb d5                	jmp    800279 <vprintfmt+0x40>

008002a4 <.L28>:
		switch (ch = *(unsigned char *) fmt++) {
  8002a4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002a7:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002ab:	eb cc                	jmp    800279 <vprintfmt+0x40>

008002ad <.L29>:
		switch (ch = *(unsigned char *) fmt++) {
  8002ad:	0f b6 d2             	movzbl %dl,%edx
  8002b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002b3:	b8 00 00 00 00       	mov    $0x0,%eax
				precision = precision * 10 + ch - '0';
  8002b8:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002bb:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002bf:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002c2:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002c5:	83 f9 09             	cmp    $0x9,%ecx
  8002c8:	77 55                	ja     80031f <.L23+0xf>
			for (precision = 0; ; ++fmt) {
  8002ca:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002cd:	eb e9                	jmp    8002b8 <.L29+0xb>

008002cf <.L26>:
			precision = va_arg(ap, int);
  8002cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8002d2:	8b 00                	mov    (%eax),%eax
  8002d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8002da:	8d 40 04             	lea    0x4(%eax),%eax
  8002dd:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8002e3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8002e7:	79 90                	jns    800279 <vprintfmt+0x40>
				width = precision, precision = -1;
  8002e9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002ef:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8002f6:	eb 81                	jmp    800279 <vprintfmt+0x40>

008002f8 <.L27>:
  8002f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002fb:	85 c0                	test   %eax,%eax
  8002fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800302:	0f 49 d0             	cmovns %eax,%edx
  800305:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800308:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80030b:	e9 69 ff ff ff       	jmp    800279 <vprintfmt+0x40>

00800310 <.L23>:
  800310:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800313:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80031a:	e9 5a ff ff ff       	jmp    800279 <vprintfmt+0x40>
  80031f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800322:	eb bf                	jmp    8002e3 <.L26+0x14>

00800324 <.L33>:
			lflag++;
  800324:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800328:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80032b:	e9 49 ff ff ff       	jmp    800279 <vprintfmt+0x40>

00800330 <.L30>:
			putch(va_arg(ap, int), putdat);
  800330:	8b 45 14             	mov    0x14(%ebp),%eax
  800333:	8d 78 04             	lea    0x4(%eax),%edi
  800336:	83 ec 08             	sub    $0x8,%esp
  800339:	56                   	push   %esi
  80033a:	ff 30                	pushl  (%eax)
  80033c:	ff 55 08             	call   *0x8(%ebp)
			break;
  80033f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800342:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800345:	e9 99 02 00 00       	jmp    8005e3 <.L35+0x45>

0080034a <.L32>:
			err = va_arg(ap, int);
  80034a:	8b 45 14             	mov    0x14(%ebp),%eax
  80034d:	8d 78 04             	lea    0x4(%eax),%edi
  800350:	8b 00                	mov    (%eax),%eax
  800352:	99                   	cltd   
  800353:	31 d0                	xor    %edx,%eax
  800355:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800357:	83 f8 06             	cmp    $0x6,%eax
  80035a:	7f 27                	jg     800383 <.L32+0x39>
  80035c:	8b 94 83 0c 00 00 00 	mov    0xc(%ebx,%eax,4),%edx
  800363:	85 d2                	test   %edx,%edx
  800365:	74 1c                	je     800383 <.L32+0x39>
				printfmt(putch, putdat, "%s", p);
  800367:	52                   	push   %edx
  800368:	8d 83 cb ed ff ff    	lea    -0x1235(%ebx),%eax
  80036e:	50                   	push   %eax
  80036f:	56                   	push   %esi
  800370:	ff 75 08             	pushl  0x8(%ebp)
  800373:	e8 a4 fe ff ff       	call   80021c <printfmt>
  800378:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80037b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80037e:	e9 60 02 00 00       	jmp    8005e3 <.L35+0x45>
				printfmt(putch, putdat, "error %d", err);
  800383:	50                   	push   %eax
  800384:	8d 83 c2 ed ff ff    	lea    -0x123e(%ebx),%eax
  80038a:	50                   	push   %eax
  80038b:	56                   	push   %esi
  80038c:	ff 75 08             	pushl  0x8(%ebp)
  80038f:	e8 88 fe ff ff       	call   80021c <printfmt>
  800394:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800397:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80039a:	e9 44 02 00 00       	jmp    8005e3 <.L35+0x45>

0080039f <.L36>:
			if ((p = va_arg(ap, char *)) == NULL)
  80039f:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a2:	83 c0 04             	add    $0x4,%eax
  8003a5:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ab:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003ad:	85 ff                	test   %edi,%edi
  8003af:	8d 83 bb ed ff ff    	lea    -0x1245(%ebx),%eax
  8003b5:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003b8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003bc:	0f 8e b5 00 00 00    	jle    800477 <.L36+0xd8>
  8003c2:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8003c6:	75 08                	jne    8003d0 <.L36+0x31>
  8003c8:	89 75 0c             	mov    %esi,0xc(%ebp)
  8003cb:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8003ce:	eb 6d                	jmp    80043d <.L36+0x9e>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003d0:	83 ec 08             	sub    $0x8,%esp
  8003d3:	ff 75 d0             	pushl  -0x30(%ebp)
  8003d6:	57                   	push   %edi
  8003d7:	e8 50 03 00 00       	call   80072c <strnlen>
  8003dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003df:	29 c2                	sub    %eax,%edx
  8003e1:	89 55 c8             	mov    %edx,-0x38(%ebp)
  8003e4:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8003e7:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8003eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ee:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8003f1:	89 d7                	mov    %edx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8003f3:	eb 10                	jmp    800405 <.L36+0x66>
					putch(padc, putdat);
  8003f5:	83 ec 08             	sub    $0x8,%esp
  8003f8:	56                   	push   %esi
  8003f9:	ff 75 e0             	pushl  -0x20(%ebp)
  8003fc:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8003ff:	83 ef 01             	sub    $0x1,%edi
  800402:	83 c4 10             	add    $0x10,%esp
  800405:	85 ff                	test   %edi,%edi
  800407:	7f ec                	jg     8003f5 <.L36+0x56>
  800409:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80040c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80040f:	85 d2                	test   %edx,%edx
  800411:	b8 00 00 00 00       	mov    $0x0,%eax
  800416:	0f 49 c2             	cmovns %edx,%eax
  800419:	29 c2                	sub    %eax,%edx
  80041b:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80041e:	89 75 0c             	mov    %esi,0xc(%ebp)
  800421:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800424:	eb 17                	jmp    80043d <.L36+0x9e>
				if (altflag && (ch < ' ' || ch > '~'))
  800426:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80042a:	75 30                	jne    80045c <.L36+0xbd>
					putch(ch, putdat);
  80042c:	83 ec 08             	sub    $0x8,%esp
  80042f:	ff 75 0c             	pushl  0xc(%ebp)
  800432:	50                   	push   %eax
  800433:	ff 55 08             	call   *0x8(%ebp)
  800436:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800439:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  80043d:	83 c7 01             	add    $0x1,%edi
  800440:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800444:	0f be c2             	movsbl %dl,%eax
  800447:	85 c0                	test   %eax,%eax
  800449:	74 52                	je     80049d <.L36+0xfe>
  80044b:	85 f6                	test   %esi,%esi
  80044d:	78 d7                	js     800426 <.L36+0x87>
  80044f:	83 ee 01             	sub    $0x1,%esi
  800452:	79 d2                	jns    800426 <.L36+0x87>
  800454:	8b 75 0c             	mov    0xc(%ebp),%esi
  800457:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80045a:	eb 32                	jmp    80048e <.L36+0xef>
				if (altflag && (ch < ' ' || ch > '~'))
  80045c:	0f be d2             	movsbl %dl,%edx
  80045f:	83 ea 20             	sub    $0x20,%edx
  800462:	83 fa 5e             	cmp    $0x5e,%edx
  800465:	76 c5                	jbe    80042c <.L36+0x8d>
					putch('?', putdat);
  800467:	83 ec 08             	sub    $0x8,%esp
  80046a:	ff 75 0c             	pushl  0xc(%ebp)
  80046d:	6a 3f                	push   $0x3f
  80046f:	ff 55 08             	call   *0x8(%ebp)
  800472:	83 c4 10             	add    $0x10,%esp
  800475:	eb c2                	jmp    800439 <.L36+0x9a>
  800477:	89 75 0c             	mov    %esi,0xc(%ebp)
  80047a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80047d:	eb be                	jmp    80043d <.L36+0x9e>
				putch(' ', putdat);
  80047f:	83 ec 08             	sub    $0x8,%esp
  800482:	56                   	push   %esi
  800483:	6a 20                	push   $0x20
  800485:	ff 55 08             	call   *0x8(%ebp)
			for (; width > 0; width--)
  800488:	83 ef 01             	sub    $0x1,%edi
  80048b:	83 c4 10             	add    $0x10,%esp
  80048e:	85 ff                	test   %edi,%edi
  800490:	7f ed                	jg     80047f <.L36+0xe0>
			if ((p = va_arg(ap, char *)) == NULL)
  800492:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800495:	89 45 14             	mov    %eax,0x14(%ebp)
  800498:	e9 46 01 00 00       	jmp    8005e3 <.L35+0x45>
  80049d:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8004a0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004a3:	eb e9                	jmp    80048e <.L36+0xef>

008004a5 <.L31>:
  8004a5:	8b 4d cc             	mov    -0x34(%ebp),%ecx
	if (lflag >= 2)
  8004a8:	83 f9 01             	cmp    $0x1,%ecx
  8004ab:	7e 40                	jle    8004ed <.L31+0x48>
		return va_arg(*ap, long long);
  8004ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b0:	8b 50 04             	mov    0x4(%eax),%edx
  8004b3:	8b 00                	mov    (%eax),%eax
  8004b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004b8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004be:	8d 40 08             	lea    0x8(%eax),%eax
  8004c1:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004c4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004c8:	79 55                	jns    80051f <.L31+0x7a>
				putch('-', putdat);
  8004ca:	83 ec 08             	sub    $0x8,%esp
  8004cd:	56                   	push   %esi
  8004ce:	6a 2d                	push   $0x2d
  8004d0:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8004d3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004d6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004d9:	f7 da                	neg    %edx
  8004db:	83 d1 00             	adc    $0x0,%ecx
  8004de:	f7 d9                	neg    %ecx
  8004e0:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8004e3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8004e8:	e9 db 00 00 00       	jmp    8005c8 <.L35+0x2a>
	else if (lflag)
  8004ed:	85 c9                	test   %ecx,%ecx
  8004ef:	75 17                	jne    800508 <.L31+0x63>
		return va_arg(*ap, int);
  8004f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f4:	8b 00                	mov    (%eax),%eax
  8004f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004f9:	99                   	cltd   
  8004fa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800500:	8d 40 04             	lea    0x4(%eax),%eax
  800503:	89 45 14             	mov    %eax,0x14(%ebp)
  800506:	eb bc                	jmp    8004c4 <.L31+0x1f>
		return va_arg(*ap, long);
  800508:	8b 45 14             	mov    0x14(%ebp),%eax
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800510:	99                   	cltd   
  800511:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800514:	8b 45 14             	mov    0x14(%ebp),%eax
  800517:	8d 40 04             	lea    0x4(%eax),%eax
  80051a:	89 45 14             	mov    %eax,0x14(%ebp)
  80051d:	eb a5                	jmp    8004c4 <.L31+0x1f>
			num = getint(&ap, lflag);
  80051f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800522:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800525:	b8 0a 00 00 00       	mov    $0xa,%eax
  80052a:	e9 99 00 00 00       	jmp    8005c8 <.L35+0x2a>

0080052f <.L37>:
  80052f:	8b 4d cc             	mov    -0x34(%ebp),%ecx
	if (lflag >= 2)
  800532:	83 f9 01             	cmp    $0x1,%ecx
  800535:	7e 15                	jle    80054c <.L37+0x1d>
		return va_arg(*ap, unsigned long long);
  800537:	8b 45 14             	mov    0x14(%ebp),%eax
  80053a:	8b 10                	mov    (%eax),%edx
  80053c:	8b 48 04             	mov    0x4(%eax),%ecx
  80053f:	8d 40 08             	lea    0x8(%eax),%eax
  800542:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800545:	b8 0a 00 00 00       	mov    $0xa,%eax
  80054a:	eb 7c                	jmp    8005c8 <.L35+0x2a>
	else if (lflag)
  80054c:	85 c9                	test   %ecx,%ecx
  80054e:	75 17                	jne    800567 <.L37+0x38>
		return va_arg(*ap, unsigned int);
  800550:	8b 45 14             	mov    0x14(%ebp),%eax
  800553:	8b 10                	mov    (%eax),%edx
  800555:	b9 00 00 00 00       	mov    $0x0,%ecx
  80055a:	8d 40 04             	lea    0x4(%eax),%eax
  80055d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800560:	b8 0a 00 00 00       	mov    $0xa,%eax
  800565:	eb 61                	jmp    8005c8 <.L35+0x2a>
		return va_arg(*ap, unsigned long);
  800567:	8b 45 14             	mov    0x14(%ebp),%eax
  80056a:	8b 10                	mov    (%eax),%edx
  80056c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800571:	8d 40 04             	lea    0x4(%eax),%eax
  800574:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800577:	b8 0a 00 00 00       	mov    $0xa,%eax
  80057c:	eb 4a                	jmp    8005c8 <.L35+0x2a>

0080057e <.L34>:
			putch('X', putdat);
  80057e:	83 ec 08             	sub    $0x8,%esp
  800581:	56                   	push   %esi
  800582:	6a 58                	push   $0x58
  800584:	ff 55 08             	call   *0x8(%ebp)
			putch('X', putdat);
  800587:	83 c4 08             	add    $0x8,%esp
  80058a:	56                   	push   %esi
  80058b:	6a 58                	push   $0x58
  80058d:	ff 55 08             	call   *0x8(%ebp)
			putch('X', putdat);
  800590:	83 c4 08             	add    $0x8,%esp
  800593:	56                   	push   %esi
  800594:	6a 58                	push   $0x58
  800596:	ff 55 08             	call   *0x8(%ebp)
			break;
  800599:	83 c4 10             	add    $0x10,%esp
  80059c:	eb 45                	jmp    8005e3 <.L35+0x45>

0080059e <.L35>:
			putch('0', putdat);
  80059e:	83 ec 08             	sub    $0x8,%esp
  8005a1:	56                   	push   %esi
  8005a2:	6a 30                	push   $0x30
  8005a4:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8005a7:	83 c4 08             	add    $0x8,%esp
  8005aa:	56                   	push   %esi
  8005ab:	6a 78                	push   $0x78
  8005ad:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  8005b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b3:	8b 10                	mov    (%eax),%edx
  8005b5:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8005ba:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8005bd:	8d 40 04             	lea    0x4(%eax),%eax
  8005c0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8005c3:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8005c8:	83 ec 0c             	sub    $0xc,%esp
  8005cb:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8005cf:	57                   	push   %edi
  8005d0:	ff 75 e0             	pushl  -0x20(%ebp)
  8005d3:	50                   	push   %eax
  8005d4:	51                   	push   %ecx
  8005d5:	52                   	push   %edx
  8005d6:	89 f2                	mov    %esi,%edx
  8005d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005db:	e8 55 fb ff ff       	call   800135 <printnum>
			break;
  8005e0:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8005e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005e6:	83 c7 01             	add    $0x1,%edi
  8005e9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005ed:	83 f8 25             	cmp    $0x25,%eax
  8005f0:	0f 84 62 fc ff ff    	je     800258 <vprintfmt+0x1f>
			if (ch == '\0')
  8005f6:	85 c0                	test   %eax,%eax
  8005f8:	0f 84 91 00 00 00    	je     80068f <.L22+0x21>
			putch(ch, putdat);
  8005fe:	83 ec 08             	sub    $0x8,%esp
  800601:	56                   	push   %esi
  800602:	50                   	push   %eax
  800603:	ff 55 08             	call   *0x8(%ebp)
  800606:	83 c4 10             	add    $0x10,%esp
  800609:	eb db                	jmp    8005e6 <.L35+0x48>

0080060b <.L38>:
  80060b:	8b 4d cc             	mov    -0x34(%ebp),%ecx
	if (lflag >= 2)
  80060e:	83 f9 01             	cmp    $0x1,%ecx
  800611:	7e 15                	jle    800628 <.L38+0x1d>
		return va_arg(*ap, unsigned long long);
  800613:	8b 45 14             	mov    0x14(%ebp),%eax
  800616:	8b 10                	mov    (%eax),%edx
  800618:	8b 48 04             	mov    0x4(%eax),%ecx
  80061b:	8d 40 08             	lea    0x8(%eax),%eax
  80061e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800621:	b8 10 00 00 00       	mov    $0x10,%eax
  800626:	eb a0                	jmp    8005c8 <.L35+0x2a>
	else if (lflag)
  800628:	85 c9                	test   %ecx,%ecx
  80062a:	75 17                	jne    800643 <.L38+0x38>
		return va_arg(*ap, unsigned int);
  80062c:	8b 45 14             	mov    0x14(%ebp),%eax
  80062f:	8b 10                	mov    (%eax),%edx
  800631:	b9 00 00 00 00       	mov    $0x0,%ecx
  800636:	8d 40 04             	lea    0x4(%eax),%eax
  800639:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80063c:	b8 10 00 00 00       	mov    $0x10,%eax
  800641:	eb 85                	jmp    8005c8 <.L35+0x2a>
		return va_arg(*ap, unsigned long);
  800643:	8b 45 14             	mov    0x14(%ebp),%eax
  800646:	8b 10                	mov    (%eax),%edx
  800648:	b9 00 00 00 00       	mov    $0x0,%ecx
  80064d:	8d 40 04             	lea    0x4(%eax),%eax
  800650:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800653:	b8 10 00 00 00       	mov    $0x10,%eax
  800658:	e9 6b ff ff ff       	jmp    8005c8 <.L35+0x2a>

0080065d <.L25>:
			putch(ch, putdat);
  80065d:	83 ec 08             	sub    $0x8,%esp
  800660:	56                   	push   %esi
  800661:	6a 25                	push   $0x25
  800663:	ff 55 08             	call   *0x8(%ebp)
			break;
  800666:	83 c4 10             	add    $0x10,%esp
  800669:	e9 75 ff ff ff       	jmp    8005e3 <.L35+0x45>

0080066e <.L22>:
			putch('%', putdat);
  80066e:	83 ec 08             	sub    $0x8,%esp
  800671:	56                   	push   %esi
  800672:	6a 25                	push   $0x25
  800674:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800677:	83 c4 10             	add    $0x10,%esp
  80067a:	89 f8                	mov    %edi,%eax
  80067c:	eb 03                	jmp    800681 <.L22+0x13>
  80067e:	83 e8 01             	sub    $0x1,%eax
  800681:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800685:	75 f7                	jne    80067e <.L22+0x10>
  800687:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80068a:	e9 54 ff ff ff       	jmp    8005e3 <.L35+0x45>
}
  80068f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800692:	5b                   	pop    %ebx
  800693:	5e                   	pop    %esi
  800694:	5f                   	pop    %edi
  800695:	5d                   	pop    %ebp
  800696:	c3                   	ret    

00800697 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800697:	55                   	push   %ebp
  800698:	89 e5                	mov    %esp,%ebp
  80069a:	53                   	push   %ebx
  80069b:	83 ec 14             	sub    $0x14,%esp
  80069e:	e8 a8 f9 ff ff       	call   80004b <__x86.get_pc_thunk.bx>
  8006a3:	81 c3 5d 19 00 00    	add    $0x195d,%ebx
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006af:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006b2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006b6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006c0:	85 c0                	test   %eax,%eax
  8006c2:	74 2b                	je     8006ef <vsnprintf+0x58>
  8006c4:	85 d2                	test   %edx,%edx
  8006c6:	7e 27                	jle    8006ef <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006c8:	ff 75 14             	pushl  0x14(%ebp)
  8006cb:	ff 75 10             	pushl  0x10(%ebp)
  8006ce:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006d1:	50                   	push   %eax
  8006d2:	8d 83 ff e1 ff ff    	lea    -0x1e01(%ebx),%eax
  8006d8:	50                   	push   %eax
  8006d9:	e8 5b fb ff ff       	call   800239 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006e1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006e7:	83 c4 10             	add    $0x10,%esp
}
  8006ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006ed:	c9                   	leave  
  8006ee:	c3                   	ret    
		return -E_INVAL;
  8006ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006f4:	eb f4                	jmp    8006ea <vsnprintf+0x53>

008006f6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8006f6:	55                   	push   %ebp
  8006f7:	89 e5                	mov    %esp,%ebp
  8006f9:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8006fc:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8006ff:	50                   	push   %eax
  800700:	ff 75 10             	pushl  0x10(%ebp)
  800703:	ff 75 0c             	pushl  0xc(%ebp)
  800706:	ff 75 08             	pushl  0x8(%ebp)
  800709:	e8 89 ff ff ff       	call   800697 <vsnprintf>
	va_end(ap);

	return rc;
}
  80070e:	c9                   	leave  
  80070f:	c3                   	ret    

00800710 <__x86.get_pc_thunk.cx>:
  800710:	8b 0c 24             	mov    (%esp),%ecx
  800713:	c3                   	ret    

00800714 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800714:	55                   	push   %ebp
  800715:	89 e5                	mov    %esp,%ebp
  800717:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80071a:	b8 00 00 00 00       	mov    $0x0,%eax
  80071f:	eb 03                	jmp    800724 <strlen+0x10>
		n++;
  800721:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800724:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800728:	75 f7                	jne    800721 <strlen+0xd>
	return n;
}
  80072a:	5d                   	pop    %ebp
  80072b:	c3                   	ret    

0080072c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80072c:	55                   	push   %ebp
  80072d:	89 e5                	mov    %esp,%ebp
  80072f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800732:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800735:	b8 00 00 00 00       	mov    $0x0,%eax
  80073a:	eb 03                	jmp    80073f <strnlen+0x13>
		n++;
  80073c:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80073f:	39 d0                	cmp    %edx,%eax
  800741:	74 06                	je     800749 <strnlen+0x1d>
  800743:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800747:	75 f3                	jne    80073c <strnlen+0x10>
	return n;
}
  800749:	5d                   	pop    %ebp
  80074a:	c3                   	ret    

0080074b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80074b:	55                   	push   %ebp
  80074c:	89 e5                	mov    %esp,%ebp
  80074e:	53                   	push   %ebx
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800755:	89 c2                	mov    %eax,%edx
  800757:	83 c1 01             	add    $0x1,%ecx
  80075a:	83 c2 01             	add    $0x1,%edx
  80075d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800761:	88 5a ff             	mov    %bl,-0x1(%edx)
  800764:	84 db                	test   %bl,%bl
  800766:	75 ef                	jne    800757 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800768:	5b                   	pop    %ebx
  800769:	5d                   	pop    %ebp
  80076a:	c3                   	ret    

0080076b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80076b:	55                   	push   %ebp
  80076c:	89 e5                	mov    %esp,%ebp
  80076e:	53                   	push   %ebx
  80076f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800772:	53                   	push   %ebx
  800773:	e8 9c ff ff ff       	call   800714 <strlen>
  800778:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80077b:	ff 75 0c             	pushl  0xc(%ebp)
  80077e:	01 d8                	add    %ebx,%eax
  800780:	50                   	push   %eax
  800781:	e8 c5 ff ff ff       	call   80074b <strcpy>
	return dst;
}
  800786:	89 d8                	mov    %ebx,%eax
  800788:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80078b:	c9                   	leave  
  80078c:	c3                   	ret    

0080078d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80078d:	55                   	push   %ebp
  80078e:	89 e5                	mov    %esp,%ebp
  800790:	56                   	push   %esi
  800791:	53                   	push   %ebx
  800792:	8b 75 08             	mov    0x8(%ebp),%esi
  800795:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800798:	89 f3                	mov    %esi,%ebx
  80079a:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80079d:	89 f2                	mov    %esi,%edx
  80079f:	eb 0f                	jmp    8007b0 <strncpy+0x23>
		*dst++ = *src;
  8007a1:	83 c2 01             	add    $0x1,%edx
  8007a4:	0f b6 01             	movzbl (%ecx),%eax
  8007a7:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007aa:	80 39 01             	cmpb   $0x1,(%ecx)
  8007ad:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8007b0:	39 da                	cmp    %ebx,%edx
  8007b2:	75 ed                	jne    8007a1 <strncpy+0x14>
	}
	return ret;
}
  8007b4:	89 f0                	mov    %esi,%eax
  8007b6:	5b                   	pop    %ebx
  8007b7:	5e                   	pop    %esi
  8007b8:	5d                   	pop    %ebp
  8007b9:	c3                   	ret    

008007ba <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007ba:	55                   	push   %ebp
  8007bb:	89 e5                	mov    %esp,%ebp
  8007bd:	56                   	push   %esi
  8007be:	53                   	push   %ebx
  8007bf:	8b 75 08             	mov    0x8(%ebp),%esi
  8007c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8007c8:	89 f0                	mov    %esi,%eax
  8007ca:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007ce:	85 c9                	test   %ecx,%ecx
  8007d0:	75 0b                	jne    8007dd <strlcpy+0x23>
  8007d2:	eb 17                	jmp    8007eb <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8007d4:	83 c2 01             	add    $0x1,%edx
  8007d7:	83 c0 01             	add    $0x1,%eax
  8007da:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8007dd:	39 d8                	cmp    %ebx,%eax
  8007df:	74 07                	je     8007e8 <strlcpy+0x2e>
  8007e1:	0f b6 0a             	movzbl (%edx),%ecx
  8007e4:	84 c9                	test   %cl,%cl
  8007e6:	75 ec                	jne    8007d4 <strlcpy+0x1a>
		*dst = '\0';
  8007e8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8007eb:	29 f0                	sub    %esi,%eax
}
  8007ed:	5b                   	pop    %ebx
  8007ee:	5e                   	pop    %esi
  8007ef:	5d                   	pop    %ebp
  8007f0:	c3                   	ret    

008007f1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8007f1:	55                   	push   %ebp
  8007f2:	89 e5                	mov    %esp,%ebp
  8007f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007f7:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8007fa:	eb 06                	jmp    800802 <strcmp+0x11>
		p++, q++;
  8007fc:	83 c1 01             	add    $0x1,%ecx
  8007ff:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800802:	0f b6 01             	movzbl (%ecx),%eax
  800805:	84 c0                	test   %al,%al
  800807:	74 04                	je     80080d <strcmp+0x1c>
  800809:	3a 02                	cmp    (%edx),%al
  80080b:	74 ef                	je     8007fc <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80080d:	0f b6 c0             	movzbl %al,%eax
  800810:	0f b6 12             	movzbl (%edx),%edx
  800813:	29 d0                	sub    %edx,%eax
}
  800815:	5d                   	pop    %ebp
  800816:	c3                   	ret    

00800817 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800817:	55                   	push   %ebp
  800818:	89 e5                	mov    %esp,%ebp
  80081a:	53                   	push   %ebx
  80081b:	8b 45 08             	mov    0x8(%ebp),%eax
  80081e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800821:	89 c3                	mov    %eax,%ebx
  800823:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800826:	eb 06                	jmp    80082e <strncmp+0x17>
		n--, p++, q++;
  800828:	83 c0 01             	add    $0x1,%eax
  80082b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80082e:	39 d8                	cmp    %ebx,%eax
  800830:	74 16                	je     800848 <strncmp+0x31>
  800832:	0f b6 08             	movzbl (%eax),%ecx
  800835:	84 c9                	test   %cl,%cl
  800837:	74 04                	je     80083d <strncmp+0x26>
  800839:	3a 0a                	cmp    (%edx),%cl
  80083b:	74 eb                	je     800828 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80083d:	0f b6 00             	movzbl (%eax),%eax
  800840:	0f b6 12             	movzbl (%edx),%edx
  800843:	29 d0                	sub    %edx,%eax
}
  800845:	5b                   	pop    %ebx
  800846:	5d                   	pop    %ebp
  800847:	c3                   	ret    
		return 0;
  800848:	b8 00 00 00 00       	mov    $0x0,%eax
  80084d:	eb f6                	jmp    800845 <strncmp+0x2e>

0080084f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80084f:	55                   	push   %ebp
  800850:	89 e5                	mov    %esp,%ebp
  800852:	8b 45 08             	mov    0x8(%ebp),%eax
  800855:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800859:	0f b6 10             	movzbl (%eax),%edx
  80085c:	84 d2                	test   %dl,%dl
  80085e:	74 09                	je     800869 <strchr+0x1a>
		if (*s == c)
  800860:	38 ca                	cmp    %cl,%dl
  800862:	74 0a                	je     80086e <strchr+0x1f>
	for (; *s; s++)
  800864:	83 c0 01             	add    $0x1,%eax
  800867:	eb f0                	jmp    800859 <strchr+0xa>
			return (char *) s;
	return 0;
  800869:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80086e:	5d                   	pop    %ebp
  80086f:	c3                   	ret    

00800870 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800870:	55                   	push   %ebp
  800871:	89 e5                	mov    %esp,%ebp
  800873:	8b 45 08             	mov    0x8(%ebp),%eax
  800876:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80087a:	eb 03                	jmp    80087f <strfind+0xf>
  80087c:	83 c0 01             	add    $0x1,%eax
  80087f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800882:	38 ca                	cmp    %cl,%dl
  800884:	74 04                	je     80088a <strfind+0x1a>
  800886:	84 d2                	test   %dl,%dl
  800888:	75 f2                	jne    80087c <strfind+0xc>
			break;
	return (char *) s;
}
  80088a:	5d                   	pop    %ebp
  80088b:	c3                   	ret    

0080088c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80088c:	55                   	push   %ebp
  80088d:	89 e5                	mov    %esp,%ebp
  80088f:	57                   	push   %edi
  800890:	56                   	push   %esi
  800891:	53                   	push   %ebx
  800892:	8b 7d 08             	mov    0x8(%ebp),%edi
  800895:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800898:	85 c9                	test   %ecx,%ecx
  80089a:	74 13                	je     8008af <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80089c:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8008a2:	75 05                	jne    8008a9 <memset+0x1d>
  8008a4:	f6 c1 03             	test   $0x3,%cl
  8008a7:	74 0d                	je     8008b6 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ac:	fc                   	cld    
  8008ad:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8008af:	89 f8                	mov    %edi,%eax
  8008b1:	5b                   	pop    %ebx
  8008b2:	5e                   	pop    %esi
  8008b3:	5f                   	pop    %edi
  8008b4:	5d                   	pop    %ebp
  8008b5:	c3                   	ret    
		c &= 0xFF;
  8008b6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008ba:	89 d3                	mov    %edx,%ebx
  8008bc:	c1 e3 08             	shl    $0x8,%ebx
  8008bf:	89 d0                	mov    %edx,%eax
  8008c1:	c1 e0 18             	shl    $0x18,%eax
  8008c4:	89 d6                	mov    %edx,%esi
  8008c6:	c1 e6 10             	shl    $0x10,%esi
  8008c9:	09 f0                	or     %esi,%eax
  8008cb:	09 c2                	or     %eax,%edx
  8008cd:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8008cf:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8008d2:	89 d0                	mov    %edx,%eax
  8008d4:	fc                   	cld    
  8008d5:	f3 ab                	rep stos %eax,%es:(%edi)
  8008d7:	eb d6                	jmp    8008af <memset+0x23>

008008d9 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8008d9:	55                   	push   %ebp
  8008da:	89 e5                	mov    %esp,%ebp
  8008dc:	57                   	push   %edi
  8008dd:	56                   	push   %esi
  8008de:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8008e7:	39 c6                	cmp    %eax,%esi
  8008e9:	73 35                	jae    800920 <memmove+0x47>
  8008eb:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8008ee:	39 c2                	cmp    %eax,%edx
  8008f0:	76 2e                	jbe    800920 <memmove+0x47>
		s += n;
		d += n;
  8008f2:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008f5:	89 d6                	mov    %edx,%esi
  8008f7:	09 fe                	or     %edi,%esi
  8008f9:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8008ff:	74 0c                	je     80090d <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800901:	83 ef 01             	sub    $0x1,%edi
  800904:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800907:	fd                   	std    
  800908:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80090a:	fc                   	cld    
  80090b:	eb 21                	jmp    80092e <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80090d:	f6 c1 03             	test   $0x3,%cl
  800910:	75 ef                	jne    800901 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800912:	83 ef 04             	sub    $0x4,%edi
  800915:	8d 72 fc             	lea    -0x4(%edx),%esi
  800918:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80091b:	fd                   	std    
  80091c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80091e:	eb ea                	jmp    80090a <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800920:	89 f2                	mov    %esi,%edx
  800922:	09 c2                	or     %eax,%edx
  800924:	f6 c2 03             	test   $0x3,%dl
  800927:	74 09                	je     800932 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800929:	89 c7                	mov    %eax,%edi
  80092b:	fc                   	cld    
  80092c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80092e:	5e                   	pop    %esi
  80092f:	5f                   	pop    %edi
  800930:	5d                   	pop    %ebp
  800931:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800932:	f6 c1 03             	test   $0x3,%cl
  800935:	75 f2                	jne    800929 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800937:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80093a:	89 c7                	mov    %eax,%edi
  80093c:	fc                   	cld    
  80093d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80093f:	eb ed                	jmp    80092e <memmove+0x55>

00800941 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800941:	55                   	push   %ebp
  800942:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800944:	ff 75 10             	pushl  0x10(%ebp)
  800947:	ff 75 0c             	pushl  0xc(%ebp)
  80094a:	ff 75 08             	pushl  0x8(%ebp)
  80094d:	e8 87 ff ff ff       	call   8008d9 <memmove>
}
  800952:	c9                   	leave  
  800953:	c3                   	ret    

00800954 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800954:	55                   	push   %ebp
  800955:	89 e5                	mov    %esp,%ebp
  800957:	56                   	push   %esi
  800958:	53                   	push   %ebx
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80095f:	89 c6                	mov    %eax,%esi
  800961:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800964:	39 f0                	cmp    %esi,%eax
  800966:	74 1c                	je     800984 <memcmp+0x30>
		if (*s1 != *s2)
  800968:	0f b6 08             	movzbl (%eax),%ecx
  80096b:	0f b6 1a             	movzbl (%edx),%ebx
  80096e:	38 d9                	cmp    %bl,%cl
  800970:	75 08                	jne    80097a <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800972:	83 c0 01             	add    $0x1,%eax
  800975:	83 c2 01             	add    $0x1,%edx
  800978:	eb ea                	jmp    800964 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  80097a:	0f b6 c1             	movzbl %cl,%eax
  80097d:	0f b6 db             	movzbl %bl,%ebx
  800980:	29 d8                	sub    %ebx,%eax
  800982:	eb 05                	jmp    800989 <memcmp+0x35>
	}

	return 0;
  800984:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800989:	5b                   	pop    %ebx
  80098a:	5e                   	pop    %esi
  80098b:	5d                   	pop    %ebp
  80098c:	c3                   	ret    

0080098d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80098d:	55                   	push   %ebp
  80098e:	89 e5                	mov    %esp,%ebp
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800996:	89 c2                	mov    %eax,%edx
  800998:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80099b:	39 d0                	cmp    %edx,%eax
  80099d:	73 09                	jae    8009a8 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  80099f:	38 08                	cmp    %cl,(%eax)
  8009a1:	74 05                	je     8009a8 <memfind+0x1b>
	for (; s < ends; s++)
  8009a3:	83 c0 01             	add    $0x1,%eax
  8009a6:	eb f3                	jmp    80099b <memfind+0xe>
			break;
	return (void *) s;
}
  8009a8:	5d                   	pop    %ebp
  8009a9:	c3                   	ret    

008009aa <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009aa:	55                   	push   %ebp
  8009ab:	89 e5                	mov    %esp,%ebp
  8009ad:	57                   	push   %edi
  8009ae:	56                   	push   %esi
  8009af:	53                   	push   %ebx
  8009b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009b3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009b6:	eb 03                	jmp    8009bb <strtol+0x11>
		s++;
  8009b8:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8009bb:	0f b6 01             	movzbl (%ecx),%eax
  8009be:	3c 20                	cmp    $0x20,%al
  8009c0:	74 f6                	je     8009b8 <strtol+0xe>
  8009c2:	3c 09                	cmp    $0x9,%al
  8009c4:	74 f2                	je     8009b8 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8009c6:	3c 2b                	cmp    $0x2b,%al
  8009c8:	74 2e                	je     8009f8 <strtol+0x4e>
	int neg = 0;
  8009ca:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8009cf:	3c 2d                	cmp    $0x2d,%al
  8009d1:	74 2f                	je     800a02 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009d3:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8009d9:	75 05                	jne    8009e0 <strtol+0x36>
  8009db:	80 39 30             	cmpb   $0x30,(%ecx)
  8009de:	74 2c                	je     800a0c <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8009e0:	85 db                	test   %ebx,%ebx
  8009e2:	75 0a                	jne    8009ee <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8009e4:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  8009e9:	80 39 30             	cmpb   $0x30,(%ecx)
  8009ec:	74 28                	je     800a16 <strtol+0x6c>
		base = 10;
  8009ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f3:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8009f6:	eb 50                	jmp    800a48 <strtol+0x9e>
		s++;
  8009f8:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8009fb:	bf 00 00 00 00       	mov    $0x0,%edi
  800a00:	eb d1                	jmp    8009d3 <strtol+0x29>
		s++, neg = 1;
  800a02:	83 c1 01             	add    $0x1,%ecx
  800a05:	bf 01 00 00 00       	mov    $0x1,%edi
  800a0a:	eb c7                	jmp    8009d3 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a0c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a10:	74 0e                	je     800a20 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a12:	85 db                	test   %ebx,%ebx
  800a14:	75 d8                	jne    8009ee <strtol+0x44>
		s++, base = 8;
  800a16:	83 c1 01             	add    $0x1,%ecx
  800a19:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a1e:	eb ce                	jmp    8009ee <strtol+0x44>
		s += 2, base = 16;
  800a20:	83 c1 02             	add    $0x2,%ecx
  800a23:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a28:	eb c4                	jmp    8009ee <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a2a:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a2d:	89 f3                	mov    %esi,%ebx
  800a2f:	80 fb 19             	cmp    $0x19,%bl
  800a32:	77 29                	ja     800a5d <strtol+0xb3>
			dig = *s - 'a' + 10;
  800a34:	0f be d2             	movsbl %dl,%edx
  800a37:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a3a:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a3d:	7d 30                	jge    800a6f <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a3f:	83 c1 01             	add    $0x1,%ecx
  800a42:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a46:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a48:	0f b6 11             	movzbl (%ecx),%edx
  800a4b:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a4e:	89 f3                	mov    %esi,%ebx
  800a50:	80 fb 09             	cmp    $0x9,%bl
  800a53:	77 d5                	ja     800a2a <strtol+0x80>
			dig = *s - '0';
  800a55:	0f be d2             	movsbl %dl,%edx
  800a58:	83 ea 30             	sub    $0x30,%edx
  800a5b:	eb dd                	jmp    800a3a <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800a5d:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a60:	89 f3                	mov    %esi,%ebx
  800a62:	80 fb 19             	cmp    $0x19,%bl
  800a65:	77 08                	ja     800a6f <strtol+0xc5>
			dig = *s - 'A' + 10;
  800a67:	0f be d2             	movsbl %dl,%edx
  800a6a:	83 ea 37             	sub    $0x37,%edx
  800a6d:	eb cb                	jmp    800a3a <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a73:	74 05                	je     800a7a <strtol+0xd0>
		*endptr = (char *) s;
  800a75:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a78:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800a7a:	89 c2                	mov    %eax,%edx
  800a7c:	f7 da                	neg    %edx
  800a7e:	85 ff                	test   %edi,%edi
  800a80:	0f 45 c2             	cmovne %edx,%eax
}
  800a83:	5b                   	pop    %ebx
  800a84:	5e                   	pop    %esi
  800a85:	5f                   	pop    %edi
  800a86:	5d                   	pop    %ebp
  800a87:	c3                   	ret    

00800a88 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
  800a8b:	57                   	push   %edi
  800a8c:	56                   	push   %esi
  800a8d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800a8e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a93:	8b 55 08             	mov    0x8(%ebp),%edx
  800a96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a99:	89 c3                	mov    %eax,%ebx
  800a9b:	89 c7                	mov    %eax,%edi
  800a9d:	89 c6                	mov    %eax,%esi
  800a9f:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800aa1:	5b                   	pop    %ebx
  800aa2:	5e                   	pop    %esi
  800aa3:	5f                   	pop    %edi
  800aa4:	5d                   	pop    %ebp
  800aa5:	c3                   	ret    

00800aa6 <sys_cgetc>:

int
sys_cgetc(void)
{
  800aa6:	55                   	push   %ebp
  800aa7:	89 e5                	mov    %esp,%ebp
  800aa9:	57                   	push   %edi
  800aaa:	56                   	push   %esi
  800aab:	53                   	push   %ebx
	asm volatile("int %1\n"
  800aac:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab1:	b8 01 00 00 00       	mov    $0x1,%eax
  800ab6:	89 d1                	mov    %edx,%ecx
  800ab8:	89 d3                	mov    %edx,%ebx
  800aba:	89 d7                	mov    %edx,%edi
  800abc:	89 d6                	mov    %edx,%esi
  800abe:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ac0:	5b                   	pop    %ebx
  800ac1:	5e                   	pop    %esi
  800ac2:	5f                   	pop    %edi
  800ac3:	5d                   	pop    %ebp
  800ac4:	c3                   	ret    

00800ac5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ac5:	55                   	push   %ebp
  800ac6:	89 e5                	mov    %esp,%ebp
  800ac8:	57                   	push   %edi
  800ac9:	56                   	push   %esi
  800aca:	53                   	push   %ebx
  800acb:	83 ec 1c             	sub    $0x1c,%esp
  800ace:	e8 78 f5 ff ff       	call   80004b <__x86.get_pc_thunk.bx>
  800ad3:	81 c3 2d 15 00 00    	add    $0x152d,%ebx
  800ad9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
	asm volatile("int %1\n"
  800adc:	be 00 00 00 00       	mov    $0x0,%esi
  800ae1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ae4:	b8 03 00 00 00       	mov    $0x3,%eax
  800ae9:	89 f1                	mov    %esi,%ecx
  800aeb:	89 f3                	mov    %esi,%ebx
  800aed:	89 f7                	mov    %esi,%edi
  800aef:	cd 30                	int    $0x30
  800af1:	89 c6                	mov    %eax,%esi
	if(check && ret > 0) {
  800af3:	85 c0                	test   %eax,%eax
  800af5:	7e 18                	jle    800b0f <sys_env_destroy+0x4a>
		cprintf("syscall %d returned %d (> 0)", num, ret);
  800af7:	83 ec 04             	sub    $0x4,%esp
  800afa:	50                   	push   %eax
  800afb:	6a 03                	push   $0x3
  800afd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800b00:	8d 83 90 ef ff ff    	lea    -0x1070(%ebx),%eax
  800b06:	50                   	push   %eax
  800b07:	e8 15 f6 ff ff       	call   800121 <cprintf>
  800b0c:	83 c4 10             	add    $0x10,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b0f:	89 f0                	mov    %esi,%eax
  800b11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b14:	5b                   	pop    %ebx
  800b15:	5e                   	pop    %esi
  800b16:	5f                   	pop    %edi
  800b17:	5d                   	pop    %ebp
  800b18:	c3                   	ret    

00800b19 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b19:	55                   	push   %ebp
  800b1a:	89 e5                	mov    %esp,%ebp
  800b1c:	57                   	push   %edi
  800b1d:	56                   	push   %esi
  800b1e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b1f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b24:	b8 02 00 00 00       	mov    $0x2,%eax
  800b29:	89 d1                	mov    %edx,%ecx
  800b2b:	89 d3                	mov    %edx,%ebx
  800b2d:	89 d7                	mov    %edx,%edi
  800b2f:	89 d6                	mov    %edx,%esi
  800b31:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b33:	5b                   	pop    %ebx
  800b34:	5e                   	pop    %esi
  800b35:	5f                   	pop    %edi
  800b36:	5d                   	pop    %ebp
  800b37:	c3                   	ret    

00800b38 <sys_test>:

void
sys_test(void)
{
  800b38:	55                   	push   %ebp
  800b39:	89 e5                	mov    %esp,%ebp
  800b3b:	57                   	push   %edi
  800b3c:	56                   	push   %esi
  800b3d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b3e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b43:	b8 04 00 00 00       	mov    $0x4,%eax
  800b48:	89 d1                	mov    %edx,%ecx
  800b4a:	89 d3                	mov    %edx,%ebx
  800b4c:	89 d7                	mov    %edx,%edi
  800b4e:	89 d6                	mov    %edx,%esi
  800b50:	cd 30                	int    $0x30
		syscall(SYS_test, 0, 0, 0, 0, 0, 0);
}
  800b52:	5b                   	pop    %ebx
  800b53:	5e                   	pop    %esi
  800b54:	5f                   	pop    %edi
  800b55:	5d                   	pop    %ebp
  800b56:	c3                   	ret    
  800b57:	66 90                	xchg   %ax,%ax
  800b59:	66 90                	xchg   %ax,%ax
  800b5b:	66 90                	xchg   %ax,%ax
  800b5d:	66 90                	xchg   %ax,%ax
  800b5f:	90                   	nop

00800b60 <__udivdi3>:
  800b60:	55                   	push   %ebp
  800b61:	57                   	push   %edi
  800b62:	56                   	push   %esi
  800b63:	53                   	push   %ebx
  800b64:	83 ec 1c             	sub    $0x1c,%esp
  800b67:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800b6b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800b6f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800b73:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800b77:	85 d2                	test   %edx,%edx
  800b79:	75 35                	jne    800bb0 <__udivdi3+0x50>
  800b7b:	39 f3                	cmp    %esi,%ebx
  800b7d:	0f 87 bd 00 00 00    	ja     800c40 <__udivdi3+0xe0>
  800b83:	85 db                	test   %ebx,%ebx
  800b85:	89 d9                	mov    %ebx,%ecx
  800b87:	75 0b                	jne    800b94 <__udivdi3+0x34>
  800b89:	b8 01 00 00 00       	mov    $0x1,%eax
  800b8e:	31 d2                	xor    %edx,%edx
  800b90:	f7 f3                	div    %ebx
  800b92:	89 c1                	mov    %eax,%ecx
  800b94:	31 d2                	xor    %edx,%edx
  800b96:	89 f0                	mov    %esi,%eax
  800b98:	f7 f1                	div    %ecx
  800b9a:	89 c6                	mov    %eax,%esi
  800b9c:	89 e8                	mov    %ebp,%eax
  800b9e:	89 f7                	mov    %esi,%edi
  800ba0:	f7 f1                	div    %ecx
  800ba2:	89 fa                	mov    %edi,%edx
  800ba4:	83 c4 1c             	add    $0x1c,%esp
  800ba7:	5b                   	pop    %ebx
  800ba8:	5e                   	pop    %esi
  800ba9:	5f                   	pop    %edi
  800baa:	5d                   	pop    %ebp
  800bab:	c3                   	ret    
  800bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800bb0:	39 f2                	cmp    %esi,%edx
  800bb2:	77 7c                	ja     800c30 <__udivdi3+0xd0>
  800bb4:	0f bd fa             	bsr    %edx,%edi
  800bb7:	83 f7 1f             	xor    $0x1f,%edi
  800bba:	0f 84 98 00 00 00    	je     800c58 <__udivdi3+0xf8>
  800bc0:	89 f9                	mov    %edi,%ecx
  800bc2:	b8 20 00 00 00       	mov    $0x20,%eax
  800bc7:	29 f8                	sub    %edi,%eax
  800bc9:	d3 e2                	shl    %cl,%edx
  800bcb:	89 54 24 08          	mov    %edx,0x8(%esp)
  800bcf:	89 c1                	mov    %eax,%ecx
  800bd1:	89 da                	mov    %ebx,%edx
  800bd3:	d3 ea                	shr    %cl,%edx
  800bd5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800bd9:	09 d1                	or     %edx,%ecx
  800bdb:	89 f2                	mov    %esi,%edx
  800bdd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800be1:	89 f9                	mov    %edi,%ecx
  800be3:	d3 e3                	shl    %cl,%ebx
  800be5:	89 c1                	mov    %eax,%ecx
  800be7:	d3 ea                	shr    %cl,%edx
  800be9:	89 f9                	mov    %edi,%ecx
  800beb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800bef:	d3 e6                	shl    %cl,%esi
  800bf1:	89 eb                	mov    %ebp,%ebx
  800bf3:	89 c1                	mov    %eax,%ecx
  800bf5:	d3 eb                	shr    %cl,%ebx
  800bf7:	09 de                	or     %ebx,%esi
  800bf9:	89 f0                	mov    %esi,%eax
  800bfb:	f7 74 24 08          	divl   0x8(%esp)
  800bff:	89 d6                	mov    %edx,%esi
  800c01:	89 c3                	mov    %eax,%ebx
  800c03:	f7 64 24 0c          	mull   0xc(%esp)
  800c07:	39 d6                	cmp    %edx,%esi
  800c09:	72 0c                	jb     800c17 <__udivdi3+0xb7>
  800c0b:	89 f9                	mov    %edi,%ecx
  800c0d:	d3 e5                	shl    %cl,%ebp
  800c0f:	39 c5                	cmp    %eax,%ebp
  800c11:	73 5d                	jae    800c70 <__udivdi3+0x110>
  800c13:	39 d6                	cmp    %edx,%esi
  800c15:	75 59                	jne    800c70 <__udivdi3+0x110>
  800c17:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800c1a:	31 ff                	xor    %edi,%edi
  800c1c:	89 fa                	mov    %edi,%edx
  800c1e:	83 c4 1c             	add    $0x1c,%esp
  800c21:	5b                   	pop    %ebx
  800c22:	5e                   	pop    %esi
  800c23:	5f                   	pop    %edi
  800c24:	5d                   	pop    %ebp
  800c25:	c3                   	ret    
  800c26:	8d 76 00             	lea    0x0(%esi),%esi
  800c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800c30:	31 ff                	xor    %edi,%edi
  800c32:	31 c0                	xor    %eax,%eax
  800c34:	89 fa                	mov    %edi,%edx
  800c36:	83 c4 1c             	add    $0x1c,%esp
  800c39:	5b                   	pop    %ebx
  800c3a:	5e                   	pop    %esi
  800c3b:	5f                   	pop    %edi
  800c3c:	5d                   	pop    %ebp
  800c3d:	c3                   	ret    
  800c3e:	66 90                	xchg   %ax,%ax
  800c40:	31 ff                	xor    %edi,%edi
  800c42:	89 e8                	mov    %ebp,%eax
  800c44:	89 f2                	mov    %esi,%edx
  800c46:	f7 f3                	div    %ebx
  800c48:	89 fa                	mov    %edi,%edx
  800c4a:	83 c4 1c             	add    $0x1c,%esp
  800c4d:	5b                   	pop    %ebx
  800c4e:	5e                   	pop    %esi
  800c4f:	5f                   	pop    %edi
  800c50:	5d                   	pop    %ebp
  800c51:	c3                   	ret    
  800c52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800c58:	39 f2                	cmp    %esi,%edx
  800c5a:	72 06                	jb     800c62 <__udivdi3+0x102>
  800c5c:	31 c0                	xor    %eax,%eax
  800c5e:	39 eb                	cmp    %ebp,%ebx
  800c60:	77 d2                	ja     800c34 <__udivdi3+0xd4>
  800c62:	b8 01 00 00 00       	mov    $0x1,%eax
  800c67:	eb cb                	jmp    800c34 <__udivdi3+0xd4>
  800c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800c70:	89 d8                	mov    %ebx,%eax
  800c72:	31 ff                	xor    %edi,%edi
  800c74:	eb be                	jmp    800c34 <__udivdi3+0xd4>
  800c76:	66 90                	xchg   %ax,%ax
  800c78:	66 90                	xchg   %ax,%ax
  800c7a:	66 90                	xchg   %ax,%ax
  800c7c:	66 90                	xchg   %ax,%ax
  800c7e:	66 90                	xchg   %ax,%ax

00800c80 <__umoddi3>:
  800c80:	55                   	push   %ebp
  800c81:	57                   	push   %edi
  800c82:	56                   	push   %esi
  800c83:	53                   	push   %ebx
  800c84:	83 ec 1c             	sub    $0x1c,%esp
  800c87:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800c8b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800c8f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800c93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800c97:	85 ed                	test   %ebp,%ebp
  800c99:	89 f0                	mov    %esi,%eax
  800c9b:	89 da                	mov    %ebx,%edx
  800c9d:	75 19                	jne    800cb8 <__umoddi3+0x38>
  800c9f:	39 df                	cmp    %ebx,%edi
  800ca1:	0f 86 b1 00 00 00    	jbe    800d58 <__umoddi3+0xd8>
  800ca7:	f7 f7                	div    %edi
  800ca9:	89 d0                	mov    %edx,%eax
  800cab:	31 d2                	xor    %edx,%edx
  800cad:	83 c4 1c             	add    $0x1c,%esp
  800cb0:	5b                   	pop    %ebx
  800cb1:	5e                   	pop    %esi
  800cb2:	5f                   	pop    %edi
  800cb3:	5d                   	pop    %ebp
  800cb4:	c3                   	ret    
  800cb5:	8d 76 00             	lea    0x0(%esi),%esi
  800cb8:	39 dd                	cmp    %ebx,%ebp
  800cba:	77 f1                	ja     800cad <__umoddi3+0x2d>
  800cbc:	0f bd cd             	bsr    %ebp,%ecx
  800cbf:	83 f1 1f             	xor    $0x1f,%ecx
  800cc2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800cc6:	0f 84 b4 00 00 00    	je     800d80 <__umoddi3+0x100>
  800ccc:	b8 20 00 00 00       	mov    $0x20,%eax
  800cd1:	89 c2                	mov    %eax,%edx
  800cd3:	8b 44 24 04          	mov    0x4(%esp),%eax
  800cd7:	29 c2                	sub    %eax,%edx
  800cd9:	89 c1                	mov    %eax,%ecx
  800cdb:	89 f8                	mov    %edi,%eax
  800cdd:	d3 e5                	shl    %cl,%ebp
  800cdf:	89 d1                	mov    %edx,%ecx
  800ce1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800ce5:	d3 e8                	shr    %cl,%eax
  800ce7:	09 c5                	or     %eax,%ebp
  800ce9:	8b 44 24 04          	mov    0x4(%esp),%eax
  800ced:	89 c1                	mov    %eax,%ecx
  800cef:	d3 e7                	shl    %cl,%edi
  800cf1:	89 d1                	mov    %edx,%ecx
  800cf3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800cf7:	89 df                	mov    %ebx,%edi
  800cf9:	d3 ef                	shr    %cl,%edi
  800cfb:	89 c1                	mov    %eax,%ecx
  800cfd:	89 f0                	mov    %esi,%eax
  800cff:	d3 e3                	shl    %cl,%ebx
  800d01:	89 d1                	mov    %edx,%ecx
  800d03:	89 fa                	mov    %edi,%edx
  800d05:	d3 e8                	shr    %cl,%eax
  800d07:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800d0c:	09 d8                	or     %ebx,%eax
  800d0e:	f7 f5                	div    %ebp
  800d10:	d3 e6                	shl    %cl,%esi
  800d12:	89 d1                	mov    %edx,%ecx
  800d14:	f7 64 24 08          	mull   0x8(%esp)
  800d18:	39 d1                	cmp    %edx,%ecx
  800d1a:	89 c3                	mov    %eax,%ebx
  800d1c:	89 d7                	mov    %edx,%edi
  800d1e:	72 06                	jb     800d26 <__umoddi3+0xa6>
  800d20:	75 0e                	jne    800d30 <__umoddi3+0xb0>
  800d22:	39 c6                	cmp    %eax,%esi
  800d24:	73 0a                	jae    800d30 <__umoddi3+0xb0>
  800d26:	2b 44 24 08          	sub    0x8(%esp),%eax
  800d2a:	19 ea                	sbb    %ebp,%edx
  800d2c:	89 d7                	mov    %edx,%edi
  800d2e:	89 c3                	mov    %eax,%ebx
  800d30:	89 ca                	mov    %ecx,%edx
  800d32:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800d37:	29 de                	sub    %ebx,%esi
  800d39:	19 fa                	sbb    %edi,%edx
  800d3b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  800d3f:	89 d0                	mov    %edx,%eax
  800d41:	d3 e0                	shl    %cl,%eax
  800d43:	89 d9                	mov    %ebx,%ecx
  800d45:	d3 ee                	shr    %cl,%esi
  800d47:	d3 ea                	shr    %cl,%edx
  800d49:	09 f0                	or     %esi,%eax
  800d4b:	83 c4 1c             	add    $0x1c,%esp
  800d4e:	5b                   	pop    %ebx
  800d4f:	5e                   	pop    %esi
  800d50:	5f                   	pop    %edi
  800d51:	5d                   	pop    %ebp
  800d52:	c3                   	ret    
  800d53:	90                   	nop
  800d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800d58:	85 ff                	test   %edi,%edi
  800d5a:	89 f9                	mov    %edi,%ecx
  800d5c:	75 0b                	jne    800d69 <__umoddi3+0xe9>
  800d5e:	b8 01 00 00 00       	mov    $0x1,%eax
  800d63:	31 d2                	xor    %edx,%edx
  800d65:	f7 f7                	div    %edi
  800d67:	89 c1                	mov    %eax,%ecx
  800d69:	89 d8                	mov    %ebx,%eax
  800d6b:	31 d2                	xor    %edx,%edx
  800d6d:	f7 f1                	div    %ecx
  800d6f:	89 f0                	mov    %esi,%eax
  800d71:	f7 f1                	div    %ecx
  800d73:	e9 31 ff ff ff       	jmp    800ca9 <__umoddi3+0x29>
  800d78:	90                   	nop
  800d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800d80:	39 dd                	cmp    %ebx,%ebp
  800d82:	72 08                	jb     800d8c <__umoddi3+0x10c>
  800d84:	39 f7                	cmp    %esi,%edi
  800d86:	0f 87 21 ff ff ff    	ja     800cad <__umoddi3+0x2d>
  800d8c:	89 da                	mov    %ebx,%edx
  800d8e:	89 f0                	mov    %esi,%eax
  800d90:	29 f8                	sub    %edi,%eax
  800d92:	19 ea                	sbb    %ebp,%edx
  800d94:	e9 14 ff ff ff       	jmp    800cad <__umoddi3+0x2d>
