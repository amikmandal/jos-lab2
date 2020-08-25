
obj/user/badhello:     file format elf32-i386


Disassembly of section .text:

00800020 <umain>:

#define VIDEO_MEMORY    (void*) 0xB8000

void
umain()
{
  800020:	55                   	push   %ebp
  800021:	89 e5                	mov    %esp,%ebp
  800023:	56                   	push   %esi
  800024:	53                   	push   %ebx
  800025:	e8 2c 00 00 00       	call   800056 <__x86.get_pc_thunk.si>
  80002a:	81 c6 d6 0f 00 00    	add    $0xfd6,%esi
  800030:	b8 00 80 0b 00       	mov    $0xb8000,%eax
  800035:	8d 96 5a f0 ff ff    	lea    -0xfa6(%esi),%edx
  80003b:	8d 58 12             	lea    0x12(%eax),%ebx
	char* badhello = "badhello ";
	for(int i = 0; i < 80*24 - 9; i+=9) {
		for(int j = 0 ; j < 9; j++) {
			char* output_pos = (char*) VIDEO_MEMORY + 2*i + 2*j;
			*output_pos = badhello[j];
  80003e:	0f b6 0a             	movzbl (%edx),%ecx
  800041:	88 08                	mov    %cl,(%eax)
  800043:	83 c2 01             	add    $0x1,%edx
  800046:	83 c0 02             	add    $0x2,%eax
		for(int j = 0 ; j < 9; j++) {
  800049:	39 d8                	cmp    %ebx,%eax
  80004b:	75 f1                	jne    80003e <umain+0x1e>
	for(int i = 0; i < 80*24 - 9; i+=9) {
  80004d:	3d fa 8e 0b 00       	cmp    $0xb8efa,%eax
  800052:	75 e1                	jne    800035 <umain+0x15>
  800054:	eb fe                	jmp    800054 <umain+0x34>

00800056 <__x86.get_pc_thunk.si>:
  800056:	8b 34 24             	mov    (%esp),%esi
  800059:	c3                   	ret    
