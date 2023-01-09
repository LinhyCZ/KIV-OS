
./semestral_task:     file format elf32-littlearm


Disassembly of section .text:

00008000 <_start>:
_start():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/crt0.s:10
;@ startovaci symbol - vstupni bod z jadra OS do uzivatelskeho programu
;@ v podstate jen ihned zavola nejakou C funkci, nepotrebujeme nic tak kritickeho, abychom to vsechno museli psal v ASM
;@ jen _start vlastne ani neni funkce, takze by tento vstupni bod mel byt psany takto; rovnez je treba se ujistit, ze
;@ je tento symbol relokovany spravne na 0x8000 (tam OS ocekava, ze se nachazi vstupni bod)
_start:
    bl __crt0_run
    8000:	eb000017 	bl	8064 <__crt0_run>

00008004 <_hang>:
_hang():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/crt0.s:13
    ;@ z funkce __crt0_run by se nemel proces uz vratit, ale kdyby neco, tak se zacyklime
_hang:
    b _hang
    8004:	eafffffe 	b	8004 <_hang>

00008008 <__crt0_init_bss>:
__crt0_init_bss():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/crt0.c:10

extern unsigned int __bss_start;
extern unsigned int __bss_end;

void __crt0_init_bss()
{
    8008:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    800c:	e28db000 	add	fp, sp, #0
    8010:	e24dd00c 	sub	sp, sp, #12
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/crt0.c:11
    for (unsigned int* cur = &__bss_start; cur < &__bss_end; cur++)
    8014:	e59f3040 	ldr	r3, [pc, #64]	; 805c <__crt0_init_bss+0x54>
    8018:	e50b3008 	str	r3, [fp, #-8]
    801c:	ea000005 	b	8038 <__crt0_init_bss+0x30>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/crt0.c:12 (discriminator 3)
        *cur = 0;
    8020:	e51b3008 	ldr	r3, [fp, #-8]
    8024:	e3a02000 	mov	r2, #0
    8028:	e5832000 	str	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/crt0.c:11 (discriminator 3)
    for (unsigned int* cur = &__bss_start; cur < &__bss_end; cur++)
    802c:	e51b3008 	ldr	r3, [fp, #-8]
    8030:	e2833004 	add	r3, r3, #4
    8034:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/crt0.c:11 (discriminator 1)
    8038:	e51b3008 	ldr	r3, [fp, #-8]
    803c:	e59f201c 	ldr	r2, [pc, #28]	; 8060 <__crt0_init_bss+0x58>
    8040:	e1530002 	cmp	r3, r2
    8044:	3afffff5 	bcc	8020 <__crt0_init_bss+0x18>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/crt0.c:13
}
    8048:	e320f000 	nop	{0}
    804c:	e320f000 	nop	{0}
    8050:	e28bd000 	add	sp, fp, #0
    8054:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8058:	e12fff1e 	bx	lr
    805c:	0000b6e4 	andeq	fp, r0, r4, ror #13
    8060:	0000b714 	andeq	fp, r0, r4, lsl r7

00008064 <__crt0_run>:
__crt0_run():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/crt0.c:16

void __crt0_run()
{
    8064:	e92d4800 	push	{fp, lr}
    8068:	e28db004 	add	fp, sp, #4
    806c:	e24dd008 	sub	sp, sp, #8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/crt0.c:18
    // inicializace .bss sekce (vynulovani)
    __crt0_init_bss();
    8070:	ebffffe4 	bl	8008 <__crt0_init_bss>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/crt0.c:21

    // volani konstruktoru globalnich trid (C++)
    _cpp_startup();
    8074:	eb000040 	bl	817c <_cpp_startup>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/crt0.c:26

    // volani funkce main
    // nebudeme se zde zabyvat predavanim parametru do funkce main
    // jinak by se mohly predavat napr. namapovane do virtualniho adr. prostoru a odkazem pres zasobnik (kam nam muze OS pushnout co chce)
    int result = main(0, 0);
    8078:	e3a01000 	mov	r1, #0
    807c:	e3a00000 	mov	r0, #0
    8080:	eb00029a 	bl	8af0 <main>
    8084:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/crt0.c:29

    // volani destruktoru globalnich trid (C++)
    _cpp_shutdown();
    8088:	eb000051 	bl	81d4 <_cpp_shutdown>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/crt0.c:32

    // volani terminate() syscallu s navratovym kodem funkce main
    asm volatile("mov r0, %0" : : "r" (result));
    808c:	e51b3008 	ldr	r3, [fp, #-8]
    8090:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/crt0.c:33
    asm volatile("svc #1");
    8094:	ef000001 	svc	0x00000001
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/crt0.c:34
}
    8098:	e320f000 	nop	{0}
    809c:	e24bd004 	sub	sp, fp, #4
    80a0:	e8bd8800 	pop	{fp, pc}

000080a4 <__cxa_guard_acquire>:
__cxa_guard_acquire():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/cxxabi.cpp:11
	extern "C" int __cxa_guard_acquire (__guard *);
	extern "C" void __cxa_guard_release (__guard *);
	extern "C" void __cxa_guard_abort (__guard *);

	extern "C" int __cxa_guard_acquire (__guard *g)
	{
    80a4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80a8:	e28db000 	add	fp, sp, #0
    80ac:	e24dd00c 	sub	sp, sp, #12
    80b0:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/cxxabi.cpp:12
		return !*(char *)(g);
    80b4:	e51b3008 	ldr	r3, [fp, #-8]
    80b8:	e5d33000 	ldrb	r3, [r3]
    80bc:	e3530000 	cmp	r3, #0
    80c0:	03a03001 	moveq	r3, #1
    80c4:	13a03000 	movne	r3, #0
    80c8:	e6ef3073 	uxtb	r3, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/cxxabi.cpp:13
	}
    80cc:	e1a00003 	mov	r0, r3
    80d0:	e28bd000 	add	sp, fp, #0
    80d4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80d8:	e12fff1e 	bx	lr

000080dc <__cxa_guard_release>:
__cxa_guard_release():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/cxxabi.cpp:16

	extern "C" void __cxa_guard_release (__guard *g)
	{
    80dc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80e0:	e28db000 	add	fp, sp, #0
    80e4:	e24dd00c 	sub	sp, sp, #12
    80e8:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/cxxabi.cpp:17
		*(char *)g = 1;
    80ec:	e51b3008 	ldr	r3, [fp, #-8]
    80f0:	e3a02001 	mov	r2, #1
    80f4:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/cxxabi.cpp:18
	}
    80f8:	e320f000 	nop	{0}
    80fc:	e28bd000 	add	sp, fp, #0
    8100:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8104:	e12fff1e 	bx	lr

00008108 <__cxa_guard_abort>:
__cxa_guard_abort():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/cxxabi.cpp:21

	extern "C" void __cxa_guard_abort (__guard *)
	{
    8108:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    810c:	e28db000 	add	fp, sp, #0
    8110:	e24dd00c 	sub	sp, sp, #12
    8114:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/cxxabi.cpp:23

	}
    8118:	e320f000 	nop	{0}
    811c:	e28bd000 	add	sp, fp, #0
    8120:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8124:	e12fff1e 	bx	lr

00008128 <__dso_handle>:
__dso_handle():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/cxxabi.cpp:27
}

extern "C" void __dso_handle()
{
    8128:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    812c:	e28db000 	add	fp, sp, #0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/cxxabi.cpp:29
    // ignore dtors for now
}
    8130:	e320f000 	nop	{0}
    8134:	e28bd000 	add	sp, fp, #0
    8138:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    813c:	e12fff1e 	bx	lr

00008140 <__cxa_atexit>:
__cxa_atexit():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/cxxabi.cpp:32

extern "C" void __cxa_atexit()
{
    8140:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8144:	e28db000 	add	fp, sp, #0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/cxxabi.cpp:34
    // ignore dtors for now
}
    8148:	e320f000 	nop	{0}
    814c:	e28bd000 	add	sp, fp, #0
    8150:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8154:	e12fff1e 	bx	lr

00008158 <__cxa_pure_virtual>:
__cxa_pure_virtual():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/cxxabi.cpp:37

extern "C" void __cxa_pure_virtual()
{
    8158:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    815c:	e28db000 	add	fp, sp, #0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/cxxabi.cpp:39
    // pure virtual method called
}
    8160:	e320f000 	nop	{0}
    8164:	e28bd000 	add	sp, fp, #0
    8168:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    816c:	e12fff1e 	bx	lr

00008170 <__aeabi_unwind_cpp_pr1>:
__aeabi_unwind_cpp_pr1():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/cxxabi.cpp:42

extern "C" void __aeabi_unwind_cpp_pr1()
{
    8170:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8174:	e28db000 	add	fp, sp, #0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/cxxabi.cpp:43 (discriminator 1)
	while (true)
    8178:	eafffffe 	b	8178 <__aeabi_unwind_cpp_pr1+0x8>

0000817c <_cpp_startup>:
_cpp_startup():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/cxxabi.cpp:61
extern "C" dtor_ptr __DTOR_LIST__[0];
// konec pole destruktoru
extern "C" dtor_ptr __DTOR_END__[0];

extern "C" int _cpp_startup(void)
{
    817c:	e92d4800 	push	{fp, lr}
    8180:	e28db004 	add	fp, sp, #4
    8184:	e24dd008 	sub	sp, sp, #8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/cxxabi.cpp:66
	ctor_ptr* fnptr;
	
	// zavolame konstruktory globalnich C++ trid
	// v poli __CTOR_LIST__ jsou ukazatele na vygenerovane stuby volani konstruktoru
	for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    8188:	e59f303c 	ldr	r3, [pc, #60]	; 81cc <_cpp_startup+0x50>
    818c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/cxxabi.cpp:66 (discriminator 3)
    8190:	e51b3008 	ldr	r3, [fp, #-8]
    8194:	e59f2034 	ldr	r2, [pc, #52]	; 81d0 <_cpp_startup+0x54>
    8198:	e1530002 	cmp	r3, r2
    819c:	2a000006 	bcs	81bc <_cpp_startup+0x40>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/cxxabi.cpp:67 (discriminator 2)
		(*fnptr)();
    81a0:	e51b3008 	ldr	r3, [fp, #-8]
    81a4:	e5933000 	ldr	r3, [r3]
    81a8:	e12fff33 	blx	r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/cxxabi.cpp:66 (discriminator 2)
	for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    81ac:	e51b3008 	ldr	r3, [fp, #-8]
    81b0:	e2833004 	add	r3, r3, #4
    81b4:	e50b3008 	str	r3, [fp, #-8]
    81b8:	eafffff4 	b	8190 <_cpp_startup+0x14>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/cxxabi.cpp:69
	
	return 0;
    81bc:	e3a03000 	mov	r3, #0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/cxxabi.cpp:70
}
    81c0:	e1a00003 	mov	r0, r3
    81c4:	e24bd004 	sub	sp, fp, #4
    81c8:	e8bd8800 	pop	{fp, pc}
    81cc:	0000b6e0 	andeq	fp, r0, r0, ror #13
    81d0:	0000b6e0 	andeq	fp, r0, r0, ror #13

000081d4 <_cpp_shutdown>:
_cpp_shutdown():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/cxxabi.cpp:73

extern "C" int _cpp_shutdown(void)
{
    81d4:	e92d4800 	push	{fp, lr}
    81d8:	e28db004 	add	fp, sp, #4
    81dc:	e24dd008 	sub	sp, sp, #8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/cxxabi.cpp:77
	dtor_ptr* fnptr;
	
	// zavolame destruktory globalnich C++ trid
	for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    81e0:	e59f303c 	ldr	r3, [pc, #60]	; 8224 <_cpp_shutdown+0x50>
    81e4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/cxxabi.cpp:77 (discriminator 3)
    81e8:	e51b3008 	ldr	r3, [fp, #-8]
    81ec:	e59f2034 	ldr	r2, [pc, #52]	; 8228 <_cpp_shutdown+0x54>
    81f0:	e1530002 	cmp	r3, r2
    81f4:	2a000006 	bcs	8214 <_cpp_shutdown+0x40>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/cxxabi.cpp:78 (discriminator 2)
		(*fnptr)();
    81f8:	e51b3008 	ldr	r3, [fp, #-8]
    81fc:	e5933000 	ldr	r3, [r3]
    8200:	e12fff33 	blx	r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/cxxabi.cpp:77 (discriminator 2)
	for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    8204:	e51b3008 	ldr	r3, [fp, #-8]
    8208:	e2833004 	add	r3, r3, #4
    820c:	e50b3008 	str	r3, [fp, #-8]
    8210:	eafffff4 	b	81e8 <_cpp_shutdown+0x14>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/cxxabi.cpp:80
	
	return 0;
    8214:	e3a03000 	mov	r3, #0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/cxxabi.cpp:81
}
    8218:	e1a00003 	mov	r0, r3
    821c:	e24bd004 	sub	sp, fp, #4
    8220:	e8bd8800 	pop	{fp, pc}
    8224:	0000b6e0 	andeq	fp, r0, r0, ror #13
    8228:	0000b6e0 	andeq	fp, r0, r0, ror #13
    822c:	00000000 	andeq	r0, r0, r0

00008230 <_Z9init_uartv>:
_Z9init_uartv():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:44
 * Logger task
 * 
 * Prijima vsechny udalosti od ostatnich tasku a oznamuje je skrz UART hostiteli
 **/

uint32_t init_uart() {
    8230:	e92d4800 	push	{fp, lr}
    8234:	e28db004 	add	fp, sp, #4
    8238:	e24dd010 	sub	sp, sp, #16
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:45
	uint32_t uart_file = open("DEV:uart/0", NFile_Open_Mode::Read_Write);
    823c:	e3a01002 	mov	r1, #2
    8240:	e59f0054 	ldr	r0, [pc, #84]	; 829c <_Z9init_uartv+0x6c>
    8244:	eb00060f 	bl	9a88 <_Z4openPKc15NFile_Open_Mode>
    8248:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:48

	TUART_IOCtl_Params params;
	params.baud_rate = NUART_Baud_Rate::BR_115200;
    824c:	e59f304c 	ldr	r3, [pc, #76]	; 82a0 <_Z9init_uartv+0x70>
    8250:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:49
	params.char_length = NUART_Char_Length::Char_8;
    8254:	e3a03001 	mov	r3, #1
    8258:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:50
	ioctl(uart_file, NIOCtl_Operation::Set_Params, &params);
    825c:	e24b3014 	sub	r3, fp, #20
    8260:	e1a02003 	mov	r2, r3
    8264:	e3a01001 	mov	r1, #1
    8268:	e51b0008 	ldr	r0, [fp, #-8]
    826c:	eb000649 	bl	9b98 <_Z5ioctlj16NIOCtl_OperationPv>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:53

	//We don't care about other values like baud rate and char length when enabling interrupt.
	params.interrupt_type = NUART_Interrupt_Type::RX;
    8270:	e3a03000 	mov	r3, #0
    8274:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:54
	ioctl(uart_file, NIOCtl_Operation::Enable_Event_Detection, &params);
    8278:	e24b3014 	sub	r3, fp, #20
    827c:	e1a02003 	mov	r2, r3
    8280:	e3a01002 	mov	r1, #2
    8284:	e51b0008 	ldr	r0, [fp, #-8]
    8288:	eb000642 	bl	9b98 <_Z5ioctlj16NIOCtl_OperationPv>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:56

	return uart_file;
    828c:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:57
};
    8290:	e1a00003 	mov	r0, r3
    8294:	e24bd004 	sub	sp, fp, #4
    8298:	e8bd8800 	pop	{fp, pc}
    829c:	0000b420 	andeq	fp, r0, r0, lsr #8
    82a0:	0001c200 	andeq	ip, r1, r0, lsl #4

000082a4 <_Z12read_num_valPcjP10Read_UtilsPKc>:
_Z12read_num_valPcjP10Read_UtilsPKc():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:59

int read_num_val(char* buffer, uint32_t uart_file, Read_Utils* read_utils, const char* value) {
    82a4:	e92d4800 	push	{fp, lr}
    82a8:	e28db004 	add	fp, sp, #4
    82ac:	e24dd0a8 	sub	sp, sp, #168	; 0xa8
    82b0:	e50b00a0 	str	r0, [fp, #-160]	; 0xffffff60
    82b4:	e50b10a4 	str	r1, [fp, #-164]	; 0xffffff5c
    82b8:	e50b20a8 	str	r2, [fp, #-168]	; 0xffffff58
    82bc:	e50b30ac 	str	r3, [fp, #-172]	; 0xffffff54
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:60
	int retValue = 0;
    82c0:	e3a03000 	mov	r3, #0
    82c4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:64
	char message_buffer[MESSAGE_BUFFER_SIZE];
	char tmp_buffer[TMP_BUFFER_SIZE];

	while (retValue == 0) {
    82c8:	e51b3008 	ldr	r3, [fp, #-8]
    82cc:	e3530000 	cmp	r3, #0
    82d0:	1a00003a 	bne	83c0 <_Z12read_num_valPcjP10Read_UtilsPKc+0x11c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:65
		fputs(uart_file, WRITE_SYMBOL);
    82d4:	e59f10f4 	ldr	r1, [pc, #244]	; 83d0 <_Z12read_num_valPcjP10Read_UtilsPKc+0x12c>
    82d8:	e51b00a4 	ldr	r0, [fp, #-164]	; 0xffffff5c
    82dc:	eb000586 	bl	98fc <_Z5fputsjPKc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:67
		
		uint32_t read_chars = read_utils->read_line(buffer, uart_file, true);
    82e0:	e3a03001 	mov	r3, #1
    82e4:	e51b20a4 	ldr	r2, [fp, #-164]	; 0xffffff5c
    82e8:	e51b10a0 	ldr	r1, [fp, #-160]	; 0xffffff60
    82ec:	e51b00a8 	ldr	r0, [fp, #-168]	; 0xffffff58
    82f0:	eb000a05 	bl	ab0c <_ZN10Read_Utils9read_lineEPcjb>
    82f4:	e50b000c 	str	r0, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:68
		bzero(message_buffer, MESSAGE_BUFFER_SIZE);
    82f8:	e24b308c 	sub	r3, fp, #140	; 0x8c
    82fc:	e3a01080 	mov	r1, #128	; 0x80
    8300:	e1a00003 	mov	r0, r3
    8304:	eb0009bb 	bl	a9f8 <_Z5bzeroPvi>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:69
		bzero(tmp_buffer, TMP_BUFFER_SIZE);
    8308:	e24b3098 	sub	r3, fp, #152	; 0x98
    830c:	e3a0100a 	mov	r1, #10
    8310:	e1a00003 	mov	r0, r3
    8314:	eb0009b7 	bl	a9f8 <_Z5bzeroPvi>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:71

		retValue = atoi(buffer);
    8318:	e51b00a0 	ldr	r0, [fp, #-160]	; 0xffffff60
    831c:	eb00073e 	bl	a01c <_Z4atoiPKc>
    8320:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:73

		if (retValue > 0) {
    8324:	e51b3008 	ldr	r3, [fp, #-8]
    8328:	e3530000 	cmp	r3, #0
    832c:	da00001a 	ble	839c <_Z12read_num_valPcjP10Read_UtilsPKc+0xf8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:74
			itoa(retValue, tmp_buffer, TMP_BUFFER_SIZE);
    8330:	e51b3008 	ldr	r3, [fp, #-8]
    8334:	e24b1098 	sub	r1, fp, #152	; 0x98
    8338:	e3a0200a 	mov	r2, #10
    833c:	e1a00003 	mov	r0, r3
    8340:	eb0006d8 	bl	9ea8 <_Z4itoajPcj>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:76

			strcat(message_buffer, "OK, ");
    8344:	e24b308c 	sub	r3, fp, #140	; 0x8c
    8348:	e59f1084 	ldr	r1, [pc, #132]	; 83d4 <_Z12read_num_valPcjP10Read_UtilsPKc+0x130>
    834c:	e1a00003 	mov	r0, r3
    8350:	eb000933 	bl	a824 <_Z6strcatPcPKc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:77
			strcat(message_buffer, value);
    8354:	e24b308c 	sub	r3, fp, #140	; 0x8c
    8358:	e51b10ac 	ldr	r1, [fp, #-172]	; 0xffffff54
    835c:	e1a00003 	mov	r0, r3
    8360:	eb00092f 	bl	a824 <_Z6strcatPcPKc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:78
			strcat(message_buffer, " ");
    8364:	e24b308c 	sub	r3, fp, #140	; 0x8c
    8368:	e59f1068 	ldr	r1, [pc, #104]	; 83d8 <_Z12read_num_valPcjP10Read_UtilsPKc+0x134>
    836c:	e1a00003 	mov	r0, r3
    8370:	eb00092b 	bl	a824 <_Z6strcatPcPKc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:79
			strcat(message_buffer, tmp_buffer);
    8374:	e24b2098 	sub	r2, fp, #152	; 0x98
    8378:	e24b308c 	sub	r3, fp, #140	; 0x8c
    837c:	e1a01002 	mov	r1, r2
    8380:	e1a00003 	mov	r0, r3
    8384:	eb000926 	bl	a824 <_Z6strcatPcPKc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:80
			strcat(message_buffer, " minut");	
    8388:	e24b308c 	sub	r3, fp, #140	; 0x8c
    838c:	e59f1048 	ldr	r1, [pc, #72]	; 83dc <_Z12read_num_valPcjP10Read_UtilsPKc+0x138>
    8390:	e1a00003 	mov	r0, r3
    8394:	eb000922 	bl	a824 <_Z6strcatPcPKc>
    8398:	ea000003 	b	83ac <_Z12read_num_valPcjP10Read_UtilsPKc+0x108>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:82
		} else {
			strcat(message_buffer, INCORRECT_VALUE);
    839c:	e24b308c 	sub	r3, fp, #140	; 0x8c
    83a0:	e59f1038 	ldr	r1, [pc, #56]	; 83e0 <_Z12read_num_valPcjP10Read_UtilsPKc+0x13c>
    83a4:	e1a00003 	mov	r0, r3
    83a8:	eb00091d 	bl	a824 <_Z6strcatPcPKc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:85
		}

		println(uart_file, message_buffer);
    83ac:	e24b308c 	sub	r3, fp, #140	; 0x8c
    83b0:	e1a01003 	mov	r1, r3
    83b4:	e51b00a4 	ldr	r0, [fp, #-164]	; 0xffffff5c
    83b8:	eb00055e 	bl	9938 <_Z7printlnjPKc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:64
	while (retValue == 0) {
    83bc:	eaffffc1 	b	82c8 <_Z12read_num_valPcjP10Read_UtilsPKc+0x24>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:88
	}

	return retValue;
    83c0:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:89
}
    83c4:	e1a00003 	mov	r0, r3
    83c8:	e24bd004 	sub	sp, fp, #4
    83cc:	e8bd8800 	pop	{fp, pc}
    83d0:	0000b42c 	andeq	fp, r0, ip, lsr #8
    83d4:	0000b430 	andeq	fp, r0, r0, lsr r4
    83d8:	0000b438 	andeq	fp, r0, r8, lsr r4
    83dc:	0000b43c 	andeq	fp, r0, ip, lsr r4
    83e0:	0000b444 	andeq	fp, r0, r4, asr #8

000083e4 <_Z14read_float_valPcj>:
_Z14read_float_valPcj():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:91

float read_float_val(char* buffer, uint32_t uart_file) {
    83e4:	e92d4800 	push	{fp, lr}
    83e8:	e28db004 	add	fp, sp, #4
    83ec:	e24dd008 	sub	sp, sp, #8
    83f0:	e50b0008 	str	r0, [fp, #-8]
    83f4:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:92
	if (isnan(buffer, true)) {
    83f8:	e3a01001 	mov	r1, #1
    83fc:	e51b0008 	ldr	r0, [fp, #-8]
    8400:	eb000764 	bl	a198 <_Z5isnanPKcb>
    8404:	e1a03000 	mov	r3, r0
    8408:	e3530000 	cmp	r3, #0
    840c:	0a000004 	beq	8424 <_Z14read_float_valPcj+0x40>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:93
		println(uart_file, INCORRECT_NUMBER_FORMAT);
    8410:	e59f102c 	ldr	r1, [pc, #44]	; 8444 <_Z14read_float_valPcj+0x60>
    8414:	e51b000c 	ldr	r0, [fp, #-12]
    8418:	eb000546 	bl	9938 <_Z7printlnjPKc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:94
		return NAN_FLOAT;
    841c:	eddf7a07 	vldr	s15, [pc, #28]	; 8440 <_Z14read_float_valPcj+0x5c>
    8420:	ea000003 	b	8434 <_Z14read_float_valPcj+0x50>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:97
	} 

	return atof(buffer);
    8424:	e51b0008 	ldr	r0, [fp, #-8]
    8428:	eb000791 	bl	a274 <_Z4atofPKc>
    842c:	eef07a40 	vmov.f32	s15, s0
    8430:	e320f000 	nop	{0}
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:98
}
    8434:	eeb00a67 	vmov.f32	s0, s15
    8438:	e24bd004 	sub	sp, fp, #4
    843c:	e8bd8800 	pop	{fp, pc}
    8440:	bf800000 	svclt	0x00800000
    8444:	0000b458 	andeq	fp, r0, r8, asr r4

00008448 <_Z14read_step_timePcjP10Read_Utils>:
_Z14read_step_timePcjP10Read_Utils():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:100

int read_step_time(char* buffer, uint32_t uart_file, Read_Utils* read_utils) {
    8448:	e92d4800 	push	{fp, lr}
    844c:	e28db004 	add	fp, sp, #4
    8450:	e24dd010 	sub	sp, sp, #16
    8454:	e50b0008 	str	r0, [fp, #-8]
    8458:	e50b100c 	str	r1, [fp, #-12]
    845c:	e50b2010 	str	r2, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:101
	return read_num_val(buffer, uart_file, read_utils, "krokovani");
    8460:	e59f301c 	ldr	r3, [pc, #28]	; 8484 <_Z14read_step_timePcjP10Read_Utils+0x3c>
    8464:	e51b2010 	ldr	r2, [fp, #-16]
    8468:	e51b100c 	ldr	r1, [fp, #-12]
    846c:	e51b0008 	ldr	r0, [fp, #-8]
    8470:	ebffff8b 	bl	82a4 <_Z12read_num_valPcjP10Read_UtilsPKc>
    8474:	e1a03000 	mov	r3, r0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:102
}
    8478:	e1a00003 	mov	r0, r3
    847c:	e24bd004 	sub	sp, fp, #4
    8480:	e8bd8800 	pop	{fp, pc}
    8484:	0000b478 	andeq	fp, r0, r8, ror r4

00008488 <_Z20read_prediction_timePcjP10Read_Utils>:
_Z20read_prediction_timePcjP10Read_Utils():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:104

int read_prediction_time(char* buffer, uint32_t uart_file, Read_Utils* read_utils) {
    8488:	e92d4800 	push	{fp, lr}
    848c:	e28db004 	add	fp, sp, #4
    8490:	e24dd010 	sub	sp, sp, #16
    8494:	e50b0008 	str	r0, [fp, #-8]
    8498:	e50b100c 	str	r1, [fp, #-12]
    849c:	e50b2010 	str	r2, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:105
	return read_num_val(buffer, uart_file, read_utils, "predpoved");
    84a0:	e59f301c 	ldr	r3, [pc, #28]	; 84c4 <_Z20read_prediction_timePcjP10Read_Utils+0x3c>
    84a4:	e51b2010 	ldr	r2, [fp, #-16]
    84a8:	e51b100c 	ldr	r1, [fp, #-12]
    84ac:	e51b0008 	ldr	r0, [fp, #-8]
    84b0:	ebffff7b 	bl	82a4 <_Z12read_num_valPcjP10Read_UtilsPKc>
    84b4:	e1a03000 	mov	r3, r0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:106
}
    84b8:	e1a00003 	mov	r0, r3
    84bc:	e24bd004 	sub	sp, fp, #4
    84c0:	e8bd8800 	pop	{fp, pc}
    84c4:	0000b484 	andeq	fp, r0, r4, lsl #9

000084c8 <_Z13process_paramPcj>:
_Z13process_paramPcj():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:113
/**
 *	0 = not processed (probably float value or unknown command) 
 *	1 = Generic command received flag (and might have been somehow processed)
 *  2 = Stop command was received.
 */
int process_param(char* buffer, uint32_t file) {
    84c8:	e92d4800 	push	{fp, lr}
    84cc:	e28db004 	add	fp, sp, #4
    84d0:	e24dd0a8 	sub	sp, sp, #168	; 0xa8
    84d4:	e50b00a8 	str	r0, [fp, #-168]	; 0xffffff58
    84d8:	e50b10ac 	str	r1, [fp, #-172]	; 0xffffff54
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:115
	//Print the parameters. It is not particularly nice writing it this way, but.. :)
	if (strncmp(buffer, PARAMS_COMMAND, strlen(PARAMS_COMMAND)) == 0) {
    84dc:	e59f0210 	ldr	r0, [pc, #528]	; 86f4 <_Z13process_paramPcj+0x22c>
    84e0:	eb00092f 	bl	a9a4 <_Z6strlenPKc>
    84e4:	e1a03000 	mov	r3, r0
    84e8:	e1a02003 	mov	r2, r3
    84ec:	e59f1200 	ldr	r1, [pc, #512]	; 86f4 <_Z13process_paramPcj+0x22c>
    84f0:	e51b00a8 	ldr	r0, [fp, #-168]	; 0xffffff58
    84f4:	eb0008ff 	bl	a8f8 <_Z7strncmpPKcS0_i>
    84f8:	e1a03000 	mov	r3, r0
    84fc:	e3530000 	cmp	r3, #0
    8500:	03a03001 	moveq	r3, #1
    8504:	13a03000 	movne	r3, #0
    8508:	e6ef3073 	uxtb	r3, r3
    850c:	e3530000 	cmp	r3, #0
    8510:	0a000063 	beq	86a4 <_Z13process_paramPcj+0x1dc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:119
		char message_buffer[MESSAGE_BUFFER_SIZE];
		char tmp_buffer[TMP_BUFFER_SIZE];

		Model model = gens[2].gen[0].get_model();
    8514:	e59f31dc 	ldr	r3, [pc, #476]	; 86f8 <_Z13process_paramPcj+0x230>
    8518:	e5933000 	ldr	r3, [r3]
    851c:	e2833d4b 	add	r3, r3, #4800	; 0x12c0
    8520:	e1a02003 	mov	r2, r3
    8524:	e24b3024 	sub	r3, fp, #36	; 0x24
    8528:	e1a01002 	mov	r1, r2
    852c:	e1a00003 	mov	r0, r3
    8530:	eb00032b 	bl	91e4 <_ZN10Chromosome9get_modelEv>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:121

		strcat(message_buffer, "A = ");
    8534:	e24b30a4 	sub	r3, fp, #164	; 0xa4
    8538:	e59f11bc 	ldr	r1, [pc, #444]	; 86fc <_Z13process_paramPcj+0x234>
    853c:	e1a00003 	mov	r0, r3
    8540:	eb0008b7 	bl	a824 <_Z6strcatPcPKc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:122
		ftoa(tmp_buffer, model.A);
    8544:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    8548:	e24b3010 	sub	r3, fp, #16
    854c:	eeb00a67 	vmov.f32	s0, s15
    8550:	e1a00003 	mov	r0, r3
    8554:	eb0007f4 	bl	a52c <_Z4ftoaPcf>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:123
		strcat(message_buffer, tmp_buffer);
    8558:	e24b2010 	sub	r2, fp, #16
    855c:	e24b30a4 	sub	r3, fp, #164	; 0xa4
    8560:	e1a01002 	mov	r1, r2
    8564:	e1a00003 	mov	r0, r3
    8568:	eb0008ad 	bl	a824 <_Z6strcatPcPKc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:124
		bzero(tmp_buffer, TMP_BUFFER_SIZE);
    856c:	e24b3010 	sub	r3, fp, #16
    8570:	e3a0100a 	mov	r1, #10
    8574:	e1a00003 	mov	r0, r3
    8578:	eb00091e 	bl	a9f8 <_Z5bzeroPvi>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:126

		strcat(message_buffer, ", B = ");
    857c:	e24b30a4 	sub	r3, fp, #164	; 0xa4
    8580:	e59f1178 	ldr	r1, [pc, #376]	; 8700 <_Z13process_paramPcj+0x238>
    8584:	e1a00003 	mov	r0, r3
    8588:	eb0008a5 	bl	a824 <_Z6strcatPcPKc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:127
		ftoa(tmp_buffer, model.B);
    858c:	ed5b7a08 	vldr	s15, [fp, #-32]	; 0xffffffe0
    8590:	e24b3010 	sub	r3, fp, #16
    8594:	eeb00a67 	vmov.f32	s0, s15
    8598:	e1a00003 	mov	r0, r3
    859c:	eb0007e2 	bl	a52c <_Z4ftoaPcf>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:128
		strcat(message_buffer, tmp_buffer);
    85a0:	e24b2010 	sub	r2, fp, #16
    85a4:	e24b30a4 	sub	r3, fp, #164	; 0xa4
    85a8:	e1a01002 	mov	r1, r2
    85ac:	e1a00003 	mov	r0, r3
    85b0:	eb00089b 	bl	a824 <_Z6strcatPcPKc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:129
		bzero(tmp_buffer, TMP_BUFFER_SIZE);
    85b4:	e24b3010 	sub	r3, fp, #16
    85b8:	e3a0100a 	mov	r1, #10
    85bc:	e1a00003 	mov	r0, r3
    85c0:	eb00090c 	bl	a9f8 <_Z5bzeroPvi>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:131

		strcat(message_buffer, ", C = ");
    85c4:	e24b30a4 	sub	r3, fp, #164	; 0xa4
    85c8:	e59f1134 	ldr	r1, [pc, #308]	; 8704 <_Z13process_paramPcj+0x23c>
    85cc:	e1a00003 	mov	r0, r3
    85d0:	eb000893 	bl	a824 <_Z6strcatPcPKc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:132
		ftoa(tmp_buffer, model.C);
    85d4:	ed5b7a07 	vldr	s15, [fp, #-28]	; 0xffffffe4
    85d8:	e24b3010 	sub	r3, fp, #16
    85dc:	eeb00a67 	vmov.f32	s0, s15
    85e0:	e1a00003 	mov	r0, r3
    85e4:	eb0007d0 	bl	a52c <_Z4ftoaPcf>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:133
		strcat(message_buffer, tmp_buffer);
    85e8:	e24b2010 	sub	r2, fp, #16
    85ec:	e24b30a4 	sub	r3, fp, #164	; 0xa4
    85f0:	e1a01002 	mov	r1, r2
    85f4:	e1a00003 	mov	r0, r3
    85f8:	eb000889 	bl	a824 <_Z6strcatPcPKc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:134
		bzero(tmp_buffer, TMP_BUFFER_SIZE);
    85fc:	e24b3010 	sub	r3, fp, #16
    8600:	e3a0100a 	mov	r1, #10
    8604:	e1a00003 	mov	r0, r3
    8608:	eb0008fa 	bl	a9f8 <_Z5bzeroPvi>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:136

		strcat(message_buffer, ", D = ");
    860c:	e24b30a4 	sub	r3, fp, #164	; 0xa4
    8610:	e59f10f0 	ldr	r1, [pc, #240]	; 8708 <_Z13process_paramPcj+0x240>
    8614:	e1a00003 	mov	r0, r3
    8618:	eb000881 	bl	a824 <_Z6strcatPcPKc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:137
		ftoa(tmp_buffer, model.D);
    861c:	ed5b7a06 	vldr	s15, [fp, #-24]	; 0xffffffe8
    8620:	e24b3010 	sub	r3, fp, #16
    8624:	eeb00a67 	vmov.f32	s0, s15
    8628:	e1a00003 	mov	r0, r3
    862c:	eb0007be 	bl	a52c <_Z4ftoaPcf>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:138
		strcat(message_buffer, tmp_buffer);
    8630:	e24b2010 	sub	r2, fp, #16
    8634:	e24b30a4 	sub	r3, fp, #164	; 0xa4
    8638:	e1a01002 	mov	r1, r2
    863c:	e1a00003 	mov	r0, r3
    8640:	eb000877 	bl	a824 <_Z6strcatPcPKc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:139
		bzero(tmp_buffer, TMP_BUFFER_SIZE);
    8644:	e24b3010 	sub	r3, fp, #16
    8648:	e3a0100a 	mov	r1, #10
    864c:	e1a00003 	mov	r0, r3
    8650:	eb0008e8 	bl	a9f8 <_Z5bzeroPvi>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:141

		strcat(message_buffer, ", E = ");
    8654:	e24b30a4 	sub	r3, fp, #164	; 0xa4
    8658:	e59f10ac 	ldr	r1, [pc, #172]	; 870c <_Z13process_paramPcj+0x244>
    865c:	e1a00003 	mov	r0, r3
    8660:	eb00086f 	bl	a824 <_Z6strcatPcPKc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:142
		ftoa(tmp_buffer, model.E);
    8664:	ed5b7a05 	vldr	s15, [fp, #-20]	; 0xffffffec
    8668:	e24b3010 	sub	r3, fp, #16
    866c:	eeb00a67 	vmov.f32	s0, s15
    8670:	e1a00003 	mov	r0, r3
    8674:	eb0007ac 	bl	a52c <_Z4ftoaPcf>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:143
		strcat(message_buffer, tmp_buffer);
    8678:	e24b2010 	sub	r2, fp, #16
    867c:	e24b30a4 	sub	r3, fp, #164	; 0xa4
    8680:	e1a01002 	mov	r1, r2
    8684:	e1a00003 	mov	r0, r3
    8688:	eb000865 	bl	a824 <_Z6strcatPcPKc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:145

		println(file, message_buffer);
    868c:	e24b30a4 	sub	r3, fp, #164	; 0xa4
    8690:	e1a01003 	mov	r1, r3
    8694:	e51b00ac 	ldr	r0, [fp, #-172]	; 0xffffff54
    8698:	eb0004a6 	bl	9938 <_Z7printlnjPKc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:146
		return 1;
    869c:	e3a03001 	mov	r3, #1
    86a0:	ea000010 	b	86e8 <_Z13process_paramPcj+0x220>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:150
	} 
	
	//Stop the counting!
	if (strncmp(buffer, STOP_COMMAND, strlen(STOP_COMMAND)) == 0) {
    86a4:	e59f0064 	ldr	r0, [pc, #100]	; 8710 <_Z13process_paramPcj+0x248>
    86a8:	eb0008bd 	bl	a9a4 <_Z6strlenPKc>
    86ac:	e1a03000 	mov	r3, r0
    86b0:	e1a02003 	mov	r2, r3
    86b4:	e59f1054 	ldr	r1, [pc, #84]	; 8710 <_Z13process_paramPcj+0x248>
    86b8:	e51b00a8 	ldr	r0, [fp, #-168]	; 0xffffff58
    86bc:	eb00088d 	bl	a8f8 <_Z7strncmpPKcS0_i>
    86c0:	e1a03000 	mov	r3, r0
    86c4:	e3530000 	cmp	r3, #0
    86c8:	03a03001 	moveq	r3, #1
    86cc:	13a03000 	movne	r3, #0
    86d0:	e6ef3073 	uxtb	r3, r3
    86d4:	e3530000 	cmp	r3, #0
    86d8:	0a000001 	beq	86e4 <_Z13process_paramPcj+0x21c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:151
		return 2;
    86dc:	e3a03002 	mov	r3, #2
    86e0:	ea000000 	b	86e8 <_Z13process_paramPcj+0x220>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:155
	}

	
	return 0;
    86e4:	e3a03000 	mov	r3, #0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:156 (discriminator 1)
}
    86e8:	e1a00003 	mov	r0, r3
    86ec:	e24bd004 	sub	sp, fp, #4
    86f0:	e8bd8800 	pop	{fp, pc}
    86f4:	0000b490 	muleq	r0, r0, r4
    86f8:	0000b6f4 	strdeq	fp, [r0], -r4
    86fc:	0000b49c 	muleq	r0, ip, r4
    8700:	0000b4a4 	andeq	fp, r0, r4, lsr #9
    8704:	0000b4ac 	andeq	fp, r0, ip, lsr #9
    8708:	0000b4b4 			; <UNDEFINED> instruction: 0x0000b4b4
    870c:	0000b4bc 			; <UNDEFINED> instruction: 0x0000b4bc
    8710:	0000b4c4 	andeq	fp, r0, r4, asr #9

00008714 <_Z12count_valuesPcjfP10Read_Utils>:
_Z12count_valuesPcjfP10Read_Utils():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:159

//Process input number and count the values
void count_values(char* buffer, uint32_t file, float input, Read_Utils* read_utils) {
    8714:	e92d4810 	push	{r4, fp, lr}
    8718:	e28db008 	add	fp, sp, #8
    871c:	e24dd034 	sub	sp, sp, #52	; 0x34
    8720:	e50b0030 	str	r0, [fp, #-48]	; 0xffffffd0
    8724:	e50b1034 	str	r1, [fp, #-52]	; 0xffffffcc
    8728:	ed0b0a0e 	vstr	s0, [fp, #-56]	; 0xffffffc8
    872c:	e50b203c 	str	r2, [fp, #-60]	; 0xffffffc4
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:160
	bool stopped_counting = false;
    8730:	e3a03000 	mov	r3, #0
    8734:	e54b300d 	strb	r3, [fp, #-13]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:161
	bool found_optimal = false;
    8738:	e3a03000 	mov	r3, #0
    873c:	e54b300e 	strb	r3, [fp, #-14]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:163
	
	if (values_counter < gens_needed) {
    8740:	e59f3378 	ldr	r3, [pc, #888]	; 8ac0 <_Z12count_valuesPcjfP10Read_Utils+0x3ac>
    8744:	e5932000 	ldr	r2, [r3]
    8748:	e59f3374 	ldr	r3, [pc, #884]	; 8ac4 <_Z12count_valuesPcjfP10Read_Utils+0x3b0>
    874c:	e5933000 	ldr	r3, [r3]
    8750:	e1520003 	cmp	r2, r3
    8754:	2a000003 	bcs	8768 <_Z12count_valuesPcjfP10Read_Utils+0x54>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:164
		println(file, NAN);
    8758:	e59f1368 	ldr	r1, [pc, #872]	; 8ac8 <_Z12count_valuesPcjfP10Read_Utils+0x3b4>
    875c:	e51b0034 	ldr	r0, [fp, #-52]	; 0xffffffcc
    8760:	eb000474 	bl	9938 <_Z7printlnjPKc>
    8764:	ea0000ba 	b	8a54 <_Z12count_valuesPcjfP10Read_Utils+0x340>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:166
	} else {
		println(file, COUNTING);
    8768:	e59f135c 	ldr	r1, [pc, #860]	; 8acc <_Z12count_valuesPcjfP10Read_Utils+0x3b8>
    876c:	e51b0034 	ldr	r0, [fp, #-52]	; 0xffffffcc
    8770:	eb000470 	bl	9938 <_Z7printlnjPKc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:169

		//Prepare the previous input
		float yt = values_buffer[(values_counter - gens_needed) % gens_needed];
    8774:	e59f3354 	ldr	r3, [pc, #852]	; 8ad0 <_Z12count_valuesPcjfP10Read_Utils+0x3bc>
    8778:	e5934000 	ldr	r4, [r3]
    877c:	e59f333c 	ldr	r3, [pc, #828]	; 8ac0 <_Z12count_valuesPcjfP10Read_Utils+0x3ac>
    8780:	e5932000 	ldr	r2, [r3]
    8784:	e59f3338 	ldr	r3, [pc, #824]	; 8ac4 <_Z12count_valuesPcjfP10Read_Utils+0x3b0>
    8788:	e5933000 	ldr	r3, [r3]
    878c:	e0423003 	sub	r3, r2, r3
    8790:	e59f232c 	ldr	r2, [pc, #812]	; 8ac4 <_Z12count_valuesPcjfP10Read_Utils+0x3b0>
    8794:	e5922000 	ldr	r2, [r2]
    8798:	e1a01002 	mov	r1, r2
    879c:	e1a00003 	mov	r0, r3
    87a0:	eb000a84 	bl	b1b8 <__aeabi_uidivmod>
    87a4:	e1a03001 	mov	r3, r1
    87a8:	e1a03103 	lsl	r3, r3, #2
    87ac:	e0843003 	add	r3, r4, r3
    87b0:	e5933000 	ldr	r3, [r3]
    87b4:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:172

		//Restore the generation from backup
		gens[0] = gens[2];
    87b8:	e59f3314 	ldr	r3, [pc, #788]	; 8ad4 <_Z12count_valuesPcjfP10Read_Utils+0x3c0>
    87bc:	e5933000 	ldr	r3, [r3]
    87c0:	e59f230c 	ldr	r2, [pc, #780]	; 8ad4 <_Z12count_valuesPcjfP10Read_Utils+0x3c0>
    87c4:	e5922000 	ldr	r2, [r2]
    87c8:	e2833a01 	add	r3, r3, #4096	; 0x1000
    87cc:	e1a00002 	mov	r0, r2
    87d0:	e2833d0b 	add	r3, r3, #704	; 0x2c0
    87d4:	e3a02e96 	mov	r2, #2400	; 0x960
    87d8:	e1a01003 	mov	r1, r3
    87dc:	eb000abd 	bl	b2d8 <memcpy>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:174

		for (int i = 0; i < GENERATIONS_COUNT; i++) {
    87e0:	e3a03000 	mov	r3, #0
    87e4:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:174 (discriminator 1)
    87e8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    87ec:	e35300c7 	cmp	r3, #199	; 0xc7
    87f0:	ca000070 	bgt	89b8 <_Z12count_valuesPcjfP10Read_Utils+0x2a4>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:177
			//It would be best to stop the finding of the generations if we find the optimal value, but it might be too fast.
			//We just skip creating new generation but still add wait using the for cycle below this if statement.
			if (!found_optimal) {
    87f4:	e55b300e 	ldrb	r3, [fp, #-14]
    87f8:	e2233001 	eor	r3, r3, #1
    87fc:	e6ef3073 	uxtb	r3, r3
    8800:	e3530000 	cmp	r3, #0
    8804:	0a000030 	beq	88cc <_Z12count_valuesPcjfP10Read_Utils+0x1b8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:178
				gens[0].evaluate_gen(input, file, yt, step_time); //Evaluate the previous generation with current data
    8808:	e59f32c4 	ldr	r3, [pc, #708]	; 8ad4 <_Z12count_valuesPcjfP10Read_Utils+0x3c0>
    880c:	e5933000 	ldr	r3, [r3]
    8810:	e59f22c0 	ldr	r2, [pc, #704]	; 8ad8 <_Z12count_valuesPcjfP10Read_Utils+0x3c4>
    8814:	e5922000 	ldr	r2, [r2]
    8818:	ed5b0a06 	vldr	s1, [fp, #-24]	; 0xffffffe8
    881c:	e51b1034 	ldr	r1, [fp, #-52]	; 0xffffffcc
    8820:	ed1b0a0e 	vldr	s0, [fp, #-56]	; 0xffffffc8
    8824:	e1a00003 	mov	r0, r3
    8828:	eb00028b 	bl	925c <_ZN10Generation12evaluate_genEfjfi>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:181

				//Validate if we have the best solution already. It will be the first chromosome, evaluate sorts them.
				float bestFitness = gens[0].gen[0].get_fitness();
    882c:	e59f32a0 	ldr	r3, [pc, #672]	; 8ad4 <_Z12count_valuesPcjfP10Read_Utils+0x3c0>
    8830:	e5933000 	ldr	r3, [r3]
    8834:	e1a00003 	mov	r0, r3
    8838:	eb00025e 	bl	91b8 <_ZN10Chromosome11get_fitnessEv>
    883c:	ed0b0a07 	vstr	s0, [fp, #-28]	; 0xffffffe4
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:182
				if (bestFitness > -FITNESS_THRESHOLD && bestFitness < FITNESS_THRESHOLD) {
    8840:	ed5b7a07 	vldr	s15, [fp, #-28]	; 0xffffffe4
    8844:	eeb77ae7 	vcvt.f64.f32	d7, s15
    8848:	ed9f6b98 	vldr	d6, [pc, #608]	; 8ab0 <_Z12count_valuesPcjfP10Read_Utils+0x39c>
    884c:	eeb47bc6 	vcmpe.f64	d7, d6
    8850:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8854:	da00000b 	ble	8888 <_Z12count_valuesPcjfP10Read_Utils+0x174>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:182 (discriminator 1)
    8858:	ed5b7a07 	vldr	s15, [fp, #-28]	; 0xffffffe4
    885c:	eeb77ae7 	vcvt.f64.f32	d7, s15
    8860:	ed9f6b94 	vldr	d6, [pc, #592]	; 8ab8 <_Z12count_valuesPcjfP10Read_Utils+0x3a4>
    8864:	eeb47bc6 	vcmpe.f64	d7, d6
    8868:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    886c:	5a000005 	bpl	8888 <_Z12count_valuesPcjfP10Read_Utils+0x174>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:183
					println(file, FOUND_OPTIMAL);
    8870:	e59f1264 	ldr	r1, [pc, #612]	; 8adc <_Z12count_valuesPcjfP10Read_Utils+0x3c8>
    8874:	e51b0034 	ldr	r0, [fp, #-52]	; 0xffffffcc
    8878:	eb00042e 	bl	9938 <_Z7printlnjPKc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:184
					found_optimal = true;
    887c:	e3a03001 	mov	r3, #1
    8880:	e54b300e 	strb	r3, [fp, #-14]
    8884:	ea000010 	b	88cc <_Z12count_valuesPcjfP10Read_Utils+0x1b8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:186
				} else {
					gens[0].next_gen(&gens[1]); //Create new generation
    8888:	e59f3244 	ldr	r3, [pc, #580]	; 8ad4 <_Z12count_valuesPcjfP10Read_Utils+0x3c0>
    888c:	e5932000 	ldr	r2, [r3]
    8890:	e59f323c 	ldr	r3, [pc, #572]	; 8ad4 <_Z12count_valuesPcjfP10Read_Utils+0x3c0>
    8894:	e5933000 	ldr	r3, [r3]
    8898:	e2833e96 	add	r3, r3, #2400	; 0x960
    889c:	e1a01003 	mov	r1, r3
    88a0:	e1a00002 	mov	r0, r2
    88a4:	eb0002fe 	bl	94a4 <_ZN10Generation8next_genEPS_>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:187
					gens[0] = gens[1]; //Replace old with the new. :)
    88a8:	e59f3224 	ldr	r3, [pc, #548]	; 8ad4 <_Z12count_valuesPcjfP10Read_Utils+0x3c0>
    88ac:	e5933000 	ldr	r3, [r3]
    88b0:	e59f221c 	ldr	r2, [pc, #540]	; 8ad4 <_Z12count_valuesPcjfP10Read_Utils+0x3c0>
    88b4:	e5922000 	ldr	r2, [r2]
    88b8:	e1a00002 	mov	r0, r2
    88bc:	e2833e96 	add	r3, r3, #2400	; 0x960
    88c0:	e3a02e96 	mov	r2, #2400	; 0x960
    88c4:	e1a01003 	mov	r1, r3
    88c8:	eb000a82 	bl	b2d8 <memcpy>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:191
				}
			}
			
			for (volatile int j = 0; j < 1000000; j++) {
    88cc:	e3a03000 	mov	r3, #0
    88d0:	e50b302c 	str	r3, [fp, #-44]	; 0xffffffd4
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:191 (discriminator 3)
    88d4:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    88d8:	e59f2200 	ldr	r2, [pc, #512]	; 8ae0 <_Z12count_valuesPcjfP10Read_Utils+0x3cc>
    88dc:	e1530002 	cmp	r3, r2
    88e0:	b3a03001 	movlt	r3, #1
    88e4:	a3a03000 	movge	r3, #0
    88e8:	e6ef3073 	uxtb	r3, r3
    88ec:	e3530000 	cmp	r3, #0
    88f0:	0a000003 	beq	8904 <_Z12count_valuesPcjfP10Read_Utils+0x1f0>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:191 (discriminator 2)
    88f4:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    88f8:	e2833001 	add	r3, r3, #1
    88fc:	e50b302c 	str	r3, [fp, #-44]	; 0xffffffd4
    8900:	eafffff3 	b	88d4 <_Z12count_valuesPcjfP10Read_Utils+0x1c0>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:196
				//Added fake work :)
			}

			//Process commands that might come during counting - UART should be at least a bit responsive.
			uint32_t read_chars = read_utils->read_line(buffer, file, false);
    8904:	e3a03000 	mov	r3, #0
    8908:	e51b2034 	ldr	r2, [fp, #-52]	; 0xffffffcc
    890c:	e51b1030 	ldr	r1, [fp, #-48]	; 0xffffffd0
    8910:	e51b003c 	ldr	r0, [fp, #-60]	; 0xffffffc4
    8914:	eb00087c 	bl	ab0c <_ZN10Read_Utils9read_lineEPcjb>
    8918:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:197
			if (read_chars != 0) {
    891c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8920:	e3530000 	cmp	r3, #0
    8924:	0a00001f 	beq	89a8 <_Z12count_valuesPcjfP10Read_Utils+0x294>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:198
				int processFlag = process_param(buffer, file);
    8928:	e51b1034 	ldr	r1, [fp, #-52]	; 0xffffffcc
    892c:	e51b0030 	ldr	r0, [fp, #-48]	; 0xffffffd0
    8930:	ebfffee4 	bl	84c8 <_Z13process_paramPcj>
    8934:	e50b0024 	str	r0, [fp, #-36]	; 0xffffffdc
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:199
				if (processFlag == 0) {
    8938:	e51b3024 	ldr	r3, [fp, #-36]	; 0xffffffdc
    893c:	e3530000 	cmp	r3, #0
    8940:	1a000005 	bne	895c <_Z12count_valuesPcjfP10Read_Utils+0x248>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:200
					input_value_received_while_counting = read_float_val(buffer, file);
    8944:	e51b1034 	ldr	r1, [fp, #-52]	; 0xffffffcc
    8948:	e51b0030 	ldr	r0, [fp, #-48]	; 0xffffffd0
    894c:	ebfffea4 	bl	83e4 <_Z14read_float_valPcj>
    8950:	eef07a40 	vmov.f32	s15, s0
    8954:	e59f3188 	ldr	r3, [pc, #392]	; 8ae4 <_Z12count_valuesPcjfP10Read_Utils+0x3d0>
    8958:	edc37a00 	vstr	s15, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:204
				}
				
				//Processing stop flag
				if (processFlag == 2) {
    895c:	e51b3024 	ldr	r3, [fp, #-36]	; 0xffffffdc
    8960:	e3530002 	cmp	r3, #2
    8964:	1a00000f 	bne	89a8 <_Z12count_valuesPcjfP10Read_Utils+0x294>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:206
					//Restore the generation from backup
					println(file, CANCELED);
    8968:	e59f1178 	ldr	r1, [pc, #376]	; 8ae8 <_Z12count_valuesPcjfP10Read_Utils+0x3d4>
    896c:	e51b0034 	ldr	r0, [fp, #-52]	; 0xffffffcc
    8970:	eb0003f0 	bl	9938 <_Z7printlnjPKc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:207
					gens[0] = gens[2];
    8974:	e59f3158 	ldr	r3, [pc, #344]	; 8ad4 <_Z12count_valuesPcjfP10Read_Utils+0x3c0>
    8978:	e5933000 	ldr	r3, [r3]
    897c:	e59f2150 	ldr	r2, [pc, #336]	; 8ad4 <_Z12count_valuesPcjfP10Read_Utils+0x3c0>
    8980:	e5922000 	ldr	r2, [r2]
    8984:	e2833a01 	add	r3, r3, #4096	; 0x1000
    8988:	e1a00002 	mov	r0, r2
    898c:	e2833d0b 	add	r3, r3, #704	; 0x2c0
    8990:	e3a02e96 	mov	r2, #2400	; 0x960
    8994:	e1a01003 	mov	r1, r3
    8998:	eb000a4e 	bl	b2d8 <memcpy>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:208
					stopped_counting = true;
    899c:	e3a03001 	mov	r3, #1
    89a0:	e54b300d 	strb	r3, [fp, #-13]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:209
					break;
    89a4:	ea000003 	b	89b8 <_Z12count_valuesPcjfP10Read_Utils+0x2a4>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:174 (discriminator 2)
		for (int i = 0; i < GENERATIONS_COUNT; i++) {
    89a8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    89ac:	e2833001 	add	r3, r3, #1
    89b0:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
    89b4:	eaffff8b 	b	87e8 <_Z12count_valuesPcjfP10Read_Utils+0xd4>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:215
				}
			}
		}

		//Prepare the new generation only if we didn't stop counting using the command - the generation is already prepared in the correct index.
		if (!stopped_counting) {
    89b8:	e55b300d 	ldrb	r3, [fp, #-13]
    89bc:	e2233001 	eor	r3, r3, #1
    89c0:	e6ef3073 	uxtb	r3, r3
    89c4:	e3530000 	cmp	r3, #0
    89c8:	0a000013 	beq	8a1c <_Z12count_valuesPcjfP10Read_Utils+0x308>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:217
			//Store the computed new generation to the backup slot
			gens[2] = gens[0];
    89cc:	e59f3100 	ldr	r3, [pc, #256]	; 8ad4 <_Z12count_valuesPcjfP10Read_Utils+0x3c0>
    89d0:	e5932000 	ldr	r2, [r3]
    89d4:	e59f30f8 	ldr	r3, [pc, #248]	; 8ad4 <_Z12count_valuesPcjfP10Read_Utils+0x3c0>
    89d8:	e5933000 	ldr	r3, [r3]
    89dc:	e2833d4b 	add	r3, r3, #4800	; 0x12c0
    89e0:	e1a00003 	mov	r0, r3
    89e4:	e1a01002 	mov	r1, r2
    89e8:	e3a03e96 	mov	r3, #2400	; 0x960
    89ec:	e1a02003 	mov	r2, r3
    89f0:	eb000a38 	bl	b2d8 <memcpy>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:220
			
			//Evaluate the stored generation so we can use it
			gens[2].evaluate_gen(input, file, yt, step_time); 
    89f4:	e59f30d8 	ldr	r3, [pc, #216]	; 8ad4 <_Z12count_valuesPcjfP10Read_Utils+0x3c0>
    89f8:	e5933000 	ldr	r3, [r3]
    89fc:	e2833d4b 	add	r3, r3, #4800	; 0x12c0
    8a00:	e59f20d0 	ldr	r2, [pc, #208]	; 8ad8 <_Z12count_valuesPcjfP10Read_Utils+0x3c4>
    8a04:	e5922000 	ldr	r2, [r2]
    8a08:	ed5b0a06 	vldr	s1, [fp, #-24]	; 0xffffffe8
    8a0c:	e51b1034 	ldr	r1, [fp, #-52]	; 0xffffffcc
    8a10:	ed1b0a0e 	vldr	s0, [fp, #-56]	; 0xffffffc8
    8a14:	e1a00003 	mov	r0, r3
    8a18:	eb00020f 	bl	925c <_ZN10Generation12evaluate_genEfjfi>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:224
		}

		// Get the new prediction from the latest model.
		float prediction = gens[2].predict(input, step_time);
    8a1c:	e59f30b0 	ldr	r3, [pc, #176]	; 8ad4 <_Z12count_valuesPcjfP10Read_Utils+0x3c0>
    8a20:	e5933000 	ldr	r3, [r3]
    8a24:	e2833d4b 	add	r3, r3, #4800	; 0x12c0
    8a28:	e59f20a8 	ldr	r2, [pc, #168]	; 8ad8 <_Z12count_valuesPcjfP10Read_Utils+0x3c4>
    8a2c:	e5922000 	ldr	r2, [r2]
    8a30:	e1a01002 	mov	r1, r2
    8a34:	ed1b0a0e 	vldr	s0, [fp, #-56]	; 0xffffffc8
    8a38:	e1a00003 	mov	r0, r3
    8a3c:	eb000244 	bl	9354 <_ZN10Generation7predictEfi>
    8a40:	ed0b0a0a 	vstr	s0, [fp, #-40]	; 0xffffffd8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:227
			
		//Print the prediction value to the user
		print_str_and_float(file, PREDICTION, prediction);
    8a44:	ed1b0a0a 	vldr	s0, [fp, #-40]	; 0xffffffd8
    8a48:	e59f109c 	ldr	r1, [pc, #156]	; 8aec <_Z12count_valuesPcjfP10Read_Utils+0x3d8>
    8a4c:	e51b0034 	ldr	r0, [fp, #-52]	; 0xffffffcc
    8a50:	eb0003d1 	bl	999c <_Z19print_str_and_floatjPKcf>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:231
	}

	//Store the value into the circular buffer and increment counter
	values_buffer[values_counter % gens_needed] = input;
    8a54:	e59f3074 	ldr	r3, [pc, #116]	; 8ad0 <_Z12count_valuesPcjfP10Read_Utils+0x3bc>
    8a58:	e5934000 	ldr	r4, [r3]
    8a5c:	e59f305c 	ldr	r3, [pc, #92]	; 8ac0 <_Z12count_valuesPcjfP10Read_Utils+0x3ac>
    8a60:	e5933000 	ldr	r3, [r3]
    8a64:	e59f2058 	ldr	r2, [pc, #88]	; 8ac4 <_Z12count_valuesPcjfP10Read_Utils+0x3b0>
    8a68:	e5922000 	ldr	r2, [r2]
    8a6c:	e1a01002 	mov	r1, r2
    8a70:	e1a00003 	mov	r0, r3
    8a74:	eb0009cf 	bl	b1b8 <__aeabi_uidivmod>
    8a78:	e1a03001 	mov	r3, r1
    8a7c:	e1a03103 	lsl	r3, r3, #2
    8a80:	e0843003 	add	r3, r4, r3
    8a84:	e51b2038 	ldr	r2, [fp, #-56]	; 0xffffffc8
    8a88:	e5832000 	str	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:232
	values_counter++;
    8a8c:	e59f302c 	ldr	r3, [pc, #44]	; 8ac0 <_Z12count_valuesPcjfP10Read_Utils+0x3ac>
    8a90:	e5933000 	ldr	r3, [r3]
    8a94:	e2833001 	add	r3, r3, #1
    8a98:	e59f2020 	ldr	r2, [pc, #32]	; 8ac0 <_Z12count_valuesPcjfP10Read_Utils+0x3ac>
    8a9c:	e5823000 	str	r3, [r2]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:233
}
    8aa0:	e320f000 	nop	{0}
    8aa4:	e24bd008 	sub	sp, fp, #8
    8aa8:	e8bd8810 	pop	{r4, fp, pc}
    8aac:	e320f000 	nop	{0}
    8ab0:	e2308c3a 	eors	r8, r0, #14848	; 0x3a00
    8ab4:	be45798e 	vmlalt.f16	s15, s11, s28	; <UNPREDICTABLE>
    8ab8:	e2308c3a 	eors	r8, r0, #14848	; 0x3a00
    8abc:	3e45798e 	vmlacc.f16	s15, s11, s28	; <UNPREDICTABLE>
    8ac0:	0000b6fc 	strdeq	fp, [r0], -ip
    8ac4:	0000b6e4 	andeq	fp, r0, r4, ror #13
    8ac8:	0000b4cc 	andeq	fp, r0, ip, asr #9
    8acc:	0000b4d0 	ldrdeq	fp, [r0], -r0
    8ad0:	0000b6f8 	strdeq	fp, [r0], -r8
    8ad4:	0000b6f4 	strdeq	fp, [r0], -r4
    8ad8:	0000b6ec 	andeq	fp, r0, ip, ror #13
    8adc:	0000b4dc 	ldrdeq	fp, [r0], -ip
    8ae0:	000f4240 	andeq	r4, pc, r0, asr #4
    8ae4:	0000b6e0 	andeq	fp, r0, r0, ror #13
    8ae8:	0000b4fc 	strdeq	fp, [r0], -ip
    8aec:	0000b510 	andeq	fp, r0, r0, lsl r5

00008af0 <main>:
main():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:236

int main(int argc, char** argv)
{
    8af0:	e92d4810 	push	{r4, fp, lr}
    8af4:	e28db008 	add	fp, sp, #8
    8af8:	e24ddf49 	sub	sp, sp, #292	; 0x124
    8afc:	e50b0128 	str	r0, [fp, #-296]	; 0xfffffed8
    8b00:	e50b112c 	str	r1, [fp, #-300]	; 0xfffffed4
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:237
	Read_Utils read_utils;
    8b04:	e24b30a0 	sub	r3, fp, #160	; 0xa0
    8b08:	e1a00003 	mov	r0, r3
    8b0c:	eb0007f3 	bl	aae0 <_ZN10Read_UtilsC1Ev>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:240

	char buffer[MESSAGE_BUFFER_SIZE];
	bzero(buffer, MESSAGE_BUFFER_SIZE);
    8b10:	e24b3e12 	sub	r3, fp, #288	; 0x120
    8b14:	e3a01080 	mov	r1, #128	; 0x80
    8b18:	e1a00003 	mov	r0, r3
    8b1c:	eb0007b5 	bl	a9f8 <_Z5bzeroPvi>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:242

	uint32_t uart_file = init_uart();
    8b20:	ebfffdc2 	bl	8230 <_Z9init_uartv>
    8b24:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:243
	rnd.set_generator(open("DEV:trng", NFile_Open_Mode::Read_Write)); //Init random generator singleton
    8b28:	e3a01002 	mov	r1, #2
    8b2c:	e59f022c 	ldr	r0, [pc, #556]	; 8d60 <main+0x270>
    8b30:	eb0003d4 	bl	9a88 <_Z4openPKc15NFile_Open_Mode>
    8b34:	e1a03000 	mov	r3, r0
    8b38:	e1a01003 	mov	r1, r3
    8b3c:	e59f0220 	ldr	r0, [pc, #544]	; 8d64 <main+0x274>
    8b40:	eb000899 	bl	adac <_ZN13Rnd_Generator13set_generatorEj>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:246

	//Print intro message
	println(uart_file, INTRO_LINE1);
    8b44:	e59f121c 	ldr	r1, [pc, #540]	; 8d68 <main+0x278>
    8b48:	e51b0010 	ldr	r0, [fp, #-16]
    8b4c:	eb000379 	bl	9938 <_Z7printlnjPKc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:247
	println(uart_file, INTRO_LINE2);
    8b50:	e59f1214 	ldr	r1, [pc, #532]	; 8d6c <main+0x27c>
    8b54:	e51b0010 	ldr	r0, [fp, #-16]
    8b58:	eb000376 	bl	9938 <_Z7printlnjPKc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:248
	println(uart_file, INTRO_LINE3);
    8b5c:	e59f120c 	ldr	r1, [pc, #524]	; 8d70 <main+0x280>
    8b60:	e51b0010 	ldr	r0, [fp, #-16]
    8b64:	eb000373 	bl	9938 <_Z7printlnjPKc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:249
	println(uart_file, INTRO_LINE4);
    8b68:	e59f1204 	ldr	r1, [pc, #516]	; 8d74 <main+0x284>
    8b6c:	e51b0010 	ldr	r0, [fp, #-16]
    8b70:	eb000370 	bl	9938 <_Z7printlnjPKc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:252

	//Read step and prediction time from user
	step_time = read_step_time(buffer, uart_file, &read_utils);
    8b74:	e24b20a0 	sub	r2, fp, #160	; 0xa0
    8b78:	e24b3e12 	sub	r3, fp, #288	; 0x120
    8b7c:	e51b1010 	ldr	r1, [fp, #-16]
    8b80:	e1a00003 	mov	r0, r3
    8b84:	ebfffe2f 	bl	8448 <_Z14read_step_timePcjP10Read_Utils>
    8b88:	e1a03000 	mov	r3, r0
    8b8c:	e59f21e4 	ldr	r2, [pc, #484]	; 8d78 <main+0x288>
    8b90:	e5823000 	str	r3, [r2]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:253
	pred_time = read_prediction_time(buffer, uart_file, &read_utils);
    8b94:	e24b20a0 	sub	r2, fp, #160	; 0xa0
    8b98:	e24b3e12 	sub	r3, fp, #288	; 0x120
    8b9c:	e51b1010 	ldr	r1, [fp, #-16]
    8ba0:	e1a00003 	mov	r0, r3
    8ba4:	ebfffe37 	bl	8488 <_Z20read_prediction_timePcjP10Read_Utils>
    8ba8:	e1a03000 	mov	r3, r0
    8bac:	e59f21c8 	ldr	r2, [pc, #456]	; 8d7c <main+0x28c>
    8bb0:	e5823000 	str	r3, [r2]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:256

	//Prepare generation values
	gens_needed = (pred_time / step_time) + ((pred_time % step_time) != 0);
    8bb4:	e59f31c0 	ldr	r3, [pc, #448]	; 8d7c <main+0x28c>
    8bb8:	e5933000 	ldr	r3, [r3]
    8bbc:	e59f21b4 	ldr	r2, [pc, #436]	; 8d78 <main+0x288>
    8bc0:	e5922000 	ldr	r2, [r2]
    8bc4:	e1a01002 	mov	r1, r2
    8bc8:	e1a00003 	mov	r0, r3
    8bcc:	eb000981 	bl	b1d8 <__divsi3>
    8bd0:	e1a03000 	mov	r3, r0
    8bd4:	e1a04003 	mov	r4, r3
    8bd8:	e59f319c 	ldr	r3, [pc, #412]	; 8d7c <main+0x28c>
    8bdc:	e5933000 	ldr	r3, [r3]
    8be0:	e59f2190 	ldr	r2, [pc, #400]	; 8d78 <main+0x288>
    8be4:	e5922000 	ldr	r2, [r2]
    8be8:	e1a01002 	mov	r1, r2
    8bec:	e1a00003 	mov	r0, r3
    8bf0:	eb0009af 	bl	b2b4 <__aeabi_idivmod>
    8bf4:	e1a03001 	mov	r3, r1
    8bf8:	e3530000 	cmp	r3, #0
    8bfc:	13a03001 	movne	r3, #1
    8c00:	03a03000 	moveq	r3, #0
    8c04:	e6ef3073 	uxtb	r3, r3
    8c08:	e0843003 	add	r3, r4, r3
    8c0c:	e1a02003 	mov	r2, r3
    8c10:	e59f3168 	ldr	r3, [pc, #360]	; 8d80 <main+0x290>
    8c14:	e5832000 	str	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:257
	gens = reinterpret_cast<Generation*>(malloc(3 * sizeof(Generation))); //Store old and new generation and backup of the previous generation
    8c18:	e59f0164 	ldr	r0, [pc, #356]	; 8d84 <main+0x294>
    8c1c:	eb000493 	bl	9e70 <_Z6mallocj>
    8c20:	e1a03000 	mov	r3, r0
    8c24:	e59f215c 	ldr	r2, [pc, #348]	; 8d88 <main+0x298>
    8c28:	e5823000 	str	r3, [r2]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:258
	values_buffer = reinterpret_cast<float*>(malloc(gens_needed * sizeof(float)));
    8c2c:	e59f314c 	ldr	r3, [pc, #332]	; 8d80 <main+0x290>
    8c30:	e5933000 	ldr	r3, [r3]
    8c34:	e1a03103 	lsl	r3, r3, #2
    8c38:	e1a00003 	mov	r0, r3
    8c3c:	eb00048b 	bl	9e70 <_Z6mallocj>
    8c40:	e1a03000 	mov	r3, r0
    8c44:	e59f2140 	ldr	r2, [pc, #320]	; 8d8c <main+0x29c>
    8c48:	e5823000 	str	r3, [r2]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:261

	// init first generation randomly - Save it to the backup index
	gens[2].init_random();
    8c4c:	e59f3134 	ldr	r3, [pc, #308]	; 8d88 <main+0x298>
    8c50:	e5933000 	ldr	r3, [r3]
    8c54:	e2833d4b 	add	r3, r3, #4800	; 0x12c0
    8c58:	e1a00003 	mov	r0, r3
    8c5c:	eb0001a3 	bl	92f0 <_ZN10Generation11init_randomEv>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:267

	//Generation loop
	while (true)
	{
		//If we received value during previous counting, we want to count it immediately before reading another value from the user.
		if (input_value_received_while_counting != NAN_FLOAT) {
    8c60:	e59f3128 	ldr	r3, [pc, #296]	; 8d90 <main+0x2a0>
    8c64:	edd37a00 	vldr	s15, [r3]
    8c68:	ed9f7a3b 	vldr	s14, [pc, #236]	; 8d5c <main+0x26c>
    8c6c:	eef47a47 	vcmp.f32	s15, s14
    8c70:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8c74:	0a00000b 	beq	8ca8 <main+0x1b8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:268 (discriminator 1)
			count_values(buffer, uart_file, input_value_received_while_counting, &read_utils);
    8c78:	e59f3110 	ldr	r3, [pc, #272]	; 8d90 <main+0x2a0>
    8c7c:	edd37a00 	vldr	s15, [r3]
    8c80:	e24b20a0 	sub	r2, fp, #160	; 0xa0
    8c84:	e24b3e12 	sub	r3, fp, #288	; 0x120
    8c88:	eeb00a67 	vmov.f32	s0, s15
    8c8c:	e51b1010 	ldr	r1, [fp, #-16]
    8c90:	e1a00003 	mov	r0, r3
    8c94:	ebfffe9e 	bl	8714 <_Z12count_valuesPcjfP10Read_Utils>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:269 (discriminator 1)
			input_value_received_while_counting = NAN_FLOAT;
    8c98:	e59f30f0 	ldr	r3, [pc, #240]	; 8d90 <main+0x2a0>
    8c9c:	e59f20f0 	ldr	r2, [pc, #240]	; 8d94 <main+0x2a4>
    8ca0:	e5832000 	str	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:270 (discriminator 1)
			continue;
    8ca4:	ea00002b 	b	8d58 <main+0x268>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:274
		}

		//Read value from the user - if read_line is blocking, then it waits for the file to notify the process.
		fputs(uart_file, WRITE_SYMBOL);
    8ca8:	e59f10e8 	ldr	r1, [pc, #232]	; 8d98 <main+0x2a8>
    8cac:	e51b0010 	ldr	r0, [fp, #-16]
    8cb0:	eb000311 	bl	98fc <_Z5fputsjPKc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:275
		bzero(buffer, MESSAGE_BUFFER_SIZE);
    8cb4:	e24b3e12 	sub	r3, fp, #288	; 0x120
    8cb8:	e3a01080 	mov	r1, #128	; 0x80
    8cbc:	e1a00003 	mov	r0, r3
    8cc0:	eb00074c 	bl	a9f8 <_Z5bzeroPvi>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:276
		uint32_t read_chars = read_utils.read_line(buffer, uart_file, true);
    8cc4:	e24b1e12 	sub	r1, fp, #288	; 0x120
    8cc8:	e24b00a0 	sub	r0, fp, #160	; 0xa0
    8ccc:	e3a03001 	mov	r3, #1
    8cd0:	e51b2010 	ldr	r2, [fp, #-16]
    8cd4:	eb00078c 	bl	ab0c <_ZN10Read_Utils9read_lineEPcjb>
    8cd8:	e50b0014 	str	r0, [fp, #-20]	; 0xffffffec
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:279

		//Process the input 
		if (process_param(buffer, uart_file) == 0) {
    8cdc:	e24b3e12 	sub	r3, fp, #288	; 0x120
    8ce0:	e51b1010 	ldr	r1, [fp, #-16]
    8ce4:	e1a00003 	mov	r0, r3
    8ce8:	ebfffdf6 	bl	84c8 <_Z13process_paramPcj>
    8cec:	e1a03000 	mov	r3, r0
    8cf0:	e3530000 	cmp	r3, #0
    8cf4:	03a03001 	moveq	r3, #1
    8cf8:	13a03000 	movne	r3, #0
    8cfc:	e6ef3073 	uxtb	r3, r3
    8d00:	e3530000 	cmp	r3, #0
    8d04:	0affffd5 	beq	8c60 <main+0x170>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:280
			float input_value = read_float_val(buffer, uart_file);
    8d08:	e24b3e12 	sub	r3, fp, #288	; 0x120
    8d0c:	e51b1010 	ldr	r1, [fp, #-16]
    8d10:	e1a00003 	mov	r0, r3
    8d14:	ebfffdb2 	bl	83e4 <_Z14read_float_valPcj>
    8d18:	ed0b0a06 	vstr	s0, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:282

			if (input_value == NAN_FLOAT) {
    8d1c:	ed5b7a06 	vldr	s15, [fp, #-24]	; 0xffffffe8
    8d20:	ed9f7a0d 	vldr	s14, [pc, #52]	; 8d5c <main+0x26c>
    8d24:	eef47a47 	vcmp.f32	s15, s14
    8d28:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8d2c:	1a000003 	bne	8d40 <main+0x250>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:283
				println(uart_file, INCORRECT_VALUE);
    8d30:	e59f1064 	ldr	r1, [pc, #100]	; 8d9c <main+0x2ac>
    8d34:	e51b0010 	ldr	r0, [fp, #-16]
    8d38:	eb0002fe 	bl	9938 <_Z7printlnjPKc>
    8d3c:	eaffffc7 	b	8c60 <main+0x170>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:285
			} else {
				count_values(buffer, uart_file, input_value, &read_utils);
    8d40:	e24b20a0 	sub	r2, fp, #160	; 0xa0
    8d44:	e24b3e12 	sub	r3, fp, #288	; 0x120
    8d48:	ed1b0a06 	vldr	s0, [fp, #-24]	; 0xffffffe8
    8d4c:	e51b1010 	ldr	r1, [fp, #-16]
    8d50:	e1a00003 	mov	r0, r3
    8d54:	ebfffe6e 	bl	8714 <_Z12count_valuesPcjfP10Read_Utils>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:288 (discriminator 1)
			}
		}		
	}
    8d58:	eaffffc0 	b	8c60 <main+0x170>
    8d5c:	bf800000 	svclt	0x00800000
    8d60:	0000b51c 	andeq	fp, r0, ip, lsl r5
    8d64:	0000b700 	andeq	fp, r0, r0, lsl #14
    8d68:	0000b528 	andeq	fp, r0, r8, lsr #10
    8d6c:	0000b534 	andeq	fp, r0, r4, lsr r5
    8d70:	0000b558 	andeq	fp, r0, r8, asr r5
    8d74:	0000b5b0 			; <UNDEFINED> instruction: 0x0000b5b0
    8d78:	0000b6ec 	andeq	fp, r0, ip, ror #13
    8d7c:	0000b6f0 	strdeq	fp, [r0], -r0
    8d80:	0000b6e4 	andeq	fp, r0, r4, ror #13
    8d84:	00001c20 	andeq	r1, r0, r0, lsr #24
    8d88:	0000b6f4 	strdeq	fp, [r0], -r4
    8d8c:	0000b6f8 	strdeq	fp, [r0], -r8
    8d90:	0000b6e0 	andeq	fp, r0, r0, ror #13
    8d94:	bf800000 	svclt	0x00800000
    8d98:	0000b42c 	andeq	fp, r0, ip, lsr #8
    8d9c:	0000b444 	andeq	fp, r0, r4, asr #8

00008da0 <_ZN10ChromosomeltERKS_>:
_ZN10ChromosomeltERKS_():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:10

/**
 *  Operators that are necessary for comparing two chromosomes together. Used in quicksort.
 */
bool Chromosome::operator < (Chromosome const &obj)
{
    8da0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8da4:	e28db000 	add	fp, sp, #0
    8da8:	e24dd00c 	sub	sp, sp, #12
    8dac:	e50b0008 	str	r0, [fp, #-8]
    8db0:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:11
    return fit < obj.fit;
    8db4:	e51b3008 	ldr	r3, [fp, #-8]
    8db8:	ed937a05 	vldr	s14, [r3, #20]
    8dbc:	e51b300c 	ldr	r3, [fp, #-12]
    8dc0:	edd37a05 	vldr	s15, [r3, #20]
    8dc4:	eeb47ae7 	vcmpe.f32	s14, s15
    8dc8:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8dcc:	43a03001 	movmi	r3, #1
    8dd0:	53a03000 	movpl	r3, #0
    8dd4:	e6ef3073 	uxtb	r3, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:12
}
    8dd8:	e1a00003 	mov	r0, r3
    8ddc:	e28bd000 	add	sp, fp, #0
    8de0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8de4:	e12fff1e 	bx	lr

00008de8 <_ZN10ChromosomegtERKS_>:
_ZN10ChromosomegtERKS_():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:15

bool Chromosome::operator > (Chromosome const &obj)
{
    8de8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8dec:	e28db000 	add	fp, sp, #0
    8df0:	e24dd00c 	sub	sp, sp, #12
    8df4:	e50b0008 	str	r0, [fp, #-8]
    8df8:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:16
    return fit > obj.fit;
    8dfc:	e51b3008 	ldr	r3, [fp, #-8]
    8e00:	ed937a05 	vldr	s14, [r3, #20]
    8e04:	e51b300c 	ldr	r3, [fp, #-12]
    8e08:	edd37a05 	vldr	s15, [r3, #20]
    8e0c:	eeb47ae7 	vcmpe.f32	s14, s15
    8e10:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8e14:	c3a03001 	movgt	r3, #1
    8e18:	d3a03000 	movle	r3, #0
    8e1c:	e6ef3073 	uxtb	r3, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:17
}
    8e20:	e1a00003 	mov	r0, r3
    8e24:	e28bd000 	add	sp, fp, #0
    8e28:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8e2c:	e12fff1e 	bx	lr

00008e30 <_ZN10Chromosome2btEfi>:
_ZN10Chromosome2btEfi():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:25
 * Calculate bt value. Equation is from the assignment. 
 * 
 * b(t) = D/E * dy(t)/dt + 1/E * y(t)
 */
float Chromosome::bt(float yt, int tdelta)
{
    8e30:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8e34:	e28db000 	add	fp, sp, #0
    8e38:	e24dd01c 	sub	sp, sp, #28
    8e3c:	e50b0010 	str	r0, [fp, #-16]
    8e40:	ed0b0a05 	vstr	s0, [fp, #-20]	; 0xffffffec
    8e44:	e50b1018 	str	r1, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:26
    float derivation = tdelta / 1.0 / (24.0 * 60.0); // Tady by asi mela byt delta t
    8e48:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8e4c:	ee073a90 	vmov	s15, r3
    8e50:	eeb86be7 	vcvt.f64.s32	d6, s15
    8e54:	ed9f5b15 	vldr	d5, [pc, #84]	; 8eb0 <_ZN10Chromosome2btEfi+0x80>
    8e58:	ee867b05 	vdiv.f64	d7, d6, d5
    8e5c:	eef77bc7 	vcvt.f32.f64	s15, d7
    8e60:	ed4b7a02 	vstr	s15, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:27
    return (params[Params::D] / params[Params::E]) * derivation + (1 / params[Params::E]) * yt;
    8e64:	e51b3010 	ldr	r3, [fp, #-16]
    8e68:	edd36a03 	vldr	s13, [r3, #12]
    8e6c:	e51b3010 	ldr	r3, [fp, #-16]
    8e70:	edd37a04 	vldr	s15, [r3, #16]
    8e74:	ee867aa7 	vdiv.f32	s14, s13, s15
    8e78:	ed5b7a02 	vldr	s15, [fp, #-8]
    8e7c:	ee277a27 	vmul.f32	s14, s14, s15
    8e80:	e51b3010 	ldr	r3, [fp, #-16]
    8e84:	edd37a04 	vldr	s15, [r3, #16]
    8e88:	ed9f6a0a 	vldr	s12, [pc, #40]	; 8eb8 <_ZN10Chromosome2btEfi+0x88>
    8e8c:	eec66a27 	vdiv.f32	s13, s12, s15
    8e90:	ed5b7a05 	vldr	s15, [fp, #-20]	; 0xffffffec
    8e94:	ee667aa7 	vmul.f32	s15, s13, s15
    8e98:	ee777a27 	vadd.f32	s15, s14, s15
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:28
}
    8e9c:	eeb00a67 	vmov.f32	s0, s15
    8ea0:	e28bd000 	add	sp, fp, #0
    8ea4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8ea8:	e12fff1e 	bx	lr
    8eac:	e320f000 	nop	{0}
    8eb0:	00000000 	andeq	r0, r0, r0
    8eb4:	40968000 	addsmi	r8, r6, r0
    8eb8:	3f800000 	svccc	0x00800000

00008ebc <_ZN10Chromosome7predictEfi>:
_ZN10Chromosome7predictEfi():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:36
 * Predict new value. Equation is from the assignment.
 * 
 * y(t + t_pred) = A * b(t) + B * b(t) * (b(t) - y(t)) + C
 */
float Chromosome::predict(float yt, int tdelta)
{
    8ebc:	e92d4800 	push	{fp, lr}
    8ec0:	e28db004 	add	fp, sp, #4
    8ec4:	e24dd018 	sub	sp, sp, #24
    8ec8:	e50b0010 	str	r0, [fp, #-16]
    8ecc:	ed0b0a05 	vstr	s0, [fp, #-20]	; 0xffffffec
    8ed0:	e50b1018 	str	r1, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:37
    float btVal = bt(yt, tdelta);
    8ed4:	e51b1018 	ldr	r1, [fp, #-24]	; 0xffffffe8
    8ed8:	ed1b0a05 	vldr	s0, [fp, #-20]	; 0xffffffec
    8edc:	e51b0010 	ldr	r0, [fp, #-16]
    8ee0:	ebffffd2 	bl	8e30 <_ZN10Chromosome2btEfi>
    8ee4:	ed0b0a02 	vstr	s0, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:38
    return params[Params::A] * btVal + params[Params::B] * btVal * (btVal - yt) + params[Params::C];
    8ee8:	e51b3010 	ldr	r3, [fp, #-16]
    8eec:	ed937a00 	vldr	s14, [r3]
    8ef0:	ed5b7a02 	vldr	s15, [fp, #-8]
    8ef4:	ee277a27 	vmul.f32	s14, s14, s15
    8ef8:	e51b3010 	ldr	r3, [fp, #-16]
    8efc:	edd36a01 	vldr	s13, [r3, #4]
    8f00:	ed5b7a02 	vldr	s15, [fp, #-8]
    8f04:	ee666aa7 	vmul.f32	s13, s13, s15
    8f08:	ed1b6a02 	vldr	s12, [fp, #-8]
    8f0c:	ed5b7a05 	vldr	s15, [fp, #-20]	; 0xffffffec
    8f10:	ee767a67 	vsub.f32	s15, s12, s15
    8f14:	ee667aa7 	vmul.f32	s15, s13, s15
    8f18:	ee377a27 	vadd.f32	s14, s14, s15
    8f1c:	e51b3010 	ldr	r3, [fp, #-16]
    8f20:	edd37a02 	vldr	s15, [r3, #8]
    8f24:	ee777a27 	vadd.f32	s15, s14, s15
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:39
}
    8f28:	eeb00a67 	vmov.f32	s0, s15
    8f2c:	e24bd004 	sub	sp, fp, #4
    8f30:	e8bd8800 	pop	{fp, pc}

00008f34 <_ZN10Chromosome7fitnessERffi>:
_ZN10Chromosome7fitnessERffi():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:45

/**
 * Calculate fitness value of the current chromosome
 */
float Chromosome::fitness(float &measured_value, float yt, int tdelta)
{
    8f34:	e92d4800 	push	{fp, lr}
    8f38:	e28db004 	add	fp, sp, #4
    8f3c:	e24dd018 	sub	sp, sp, #24
    8f40:	e50b0010 	str	r0, [fp, #-16]
    8f44:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8f48:	ed0b0a06 	vstr	s0, [fp, #-24]	; 0xffffffe8
    8f4c:	e50b201c 	str	r2, [fp, #-28]	; 0xffffffe4
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:46
    float yt_pred = predict(yt, tdelta);
    8f50:	e51b101c 	ldr	r1, [fp, #-28]	; 0xffffffe4
    8f54:	ed1b0a06 	vldr	s0, [fp, #-24]	; 0xffffffe8
    8f58:	e51b0010 	ldr	r0, [fp, #-16]
    8f5c:	ebffffd6 	bl	8ebc <_ZN10Chromosome7predictEfi>
    8f60:	ed0b0a02 	vstr	s0, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:47
    fit = (yt_pred - measured_value) * (yt_pred - measured_value);
    8f64:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8f68:	edd37a00 	vldr	s15, [r3]
    8f6c:	ed1b7a02 	vldr	s14, [fp, #-8]
    8f70:	ee377a67 	vsub.f32	s14, s14, s15
    8f74:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8f78:	edd37a00 	vldr	s15, [r3]
    8f7c:	ed5b6a02 	vldr	s13, [fp, #-8]
    8f80:	ee767ae7 	vsub.f32	s15, s13, s15
    8f84:	ee677a27 	vmul.f32	s15, s14, s15
    8f88:	e51b3010 	ldr	r3, [fp, #-16]
    8f8c:	edc37a05 	vstr	s15, [r3, #20]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:48
    return fit;
    8f90:	e51b3010 	ldr	r3, [fp, #-16]
    8f94:	e5933014 	ldr	r3, [r3, #20]
    8f98:	ee073a90 	vmov	s15, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:49
}
    8f9c:	eeb00a67 	vmov.f32	s0, s15
    8fa0:	e24bd004 	sub	sp, fp, #4
    8fa4:	e8bd8800 	pop	{fp, pc}

00008fa8 <_ZN10Chromosome6mutateEv>:
_ZN10Chromosome6mutateEv():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:55

/**
 * Generate random value to random index of the current chromosome
 */
void Chromosome::mutate()
{
    8fa8:	e92d4800 	push	{fp, lr}
    8fac:	e28db004 	add	fp, sp, #4
    8fb0:	e24dd010 	sub	sp, sp, #16
    8fb4:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:56
    int index = rnd.generate_int(0, PARAM_COUNT);
    8fb8:	e3a02005 	mov	r2, #5
    8fbc:	e3a01000 	mov	r1, #0
    8fc0:	e59f0038 	ldr	r0, [pc, #56]	; 9000 <_ZN10Chromosome6mutateEv+0x58>
    8fc4:	eb000737 	bl	aca8 <_ZN13Rnd_Generator12generate_intEii>
    8fc8:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:57
    params[index] = rnd.generate(RND_LOW_STOP, RND_HIGH_STOP); 
    8fcc:	e3a02005 	mov	r2, #5
    8fd0:	e3e01004 	mvn	r1, #4
    8fd4:	e59f0024 	ldr	r0, [pc, #36]	; 9000 <_ZN10Chromosome6mutateEv+0x58>
    8fd8:	eb000744 	bl	acf0 <_ZN13Rnd_Generator8generateEii>
    8fdc:	eef07a40 	vmov.f32	s15, s0
    8fe0:	e51b2010 	ldr	r2, [fp, #-16]
    8fe4:	e51b3008 	ldr	r3, [fp, #-8]
    8fe8:	e1a03103 	lsl	r3, r3, #2
    8fec:	e0823003 	add	r3, r2, r3
    8ff0:	edc37a00 	vstr	s15, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:58
}
    8ff4:	e320f000 	nop	{0}
    8ff8:	e24bd004 	sub	sp, fp, #4
    8ffc:	e8bd8800 	pop	{fp, pc}
    9000:	0000b700 	andeq	fp, r0, r0, lsl #14

00009004 <_ZN10Chromosome9crossoverERS_>:
_ZN10Chromosome9crossoverERS_():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:65
/**
 * Create new chromosome by randomly breeding two parent chromosomes together.
 * With rare probability, the new chromosome may mutate during breeding.
 */
Chromosome Chromosome::crossover(Chromosome &other)
{
    9004:	e92d4800 	push	{fp, lr}
    9008:	e28db004 	add	fp, sp, #4
    900c:	e24dd018 	sub	sp, sp, #24
    9010:	e50b0010 	str	r0, [fp, #-16]
    9014:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    9018:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:66
    Chromosome newChromosome;
    901c:	e51b3010 	ldr	r3, [fp, #-16]
    9020:	e1a02003 	mov	r2, r3
    9024:	e3a03000 	mov	r3, #0
    9028:	e5823000 	str	r3, [r2]
    902c:	e5823004 	str	r3, [r2, #4]
    9030:	e5823008 	str	r3, [r2, #8]
    9034:	e582300c 	str	r3, [r2, #12]
    9038:	e5823010 	str	r3, [r2, #16]
    903c:	e5823014 	str	r3, [r2, #20]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:68

    for (int i = 0; i < PARAM_COUNT; i++)
    9040:	e3a03000 	mov	r3, #0
    9044:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:68 (discriminator 1)
    9048:	e51b3008 	ldr	r3, [fp, #-8]
    904c:	e3530004 	cmp	r3, #4
    9050:	ca000034 	bgt	9128 <_ZN10Chromosome9crossoverERS_+0x124>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:71
    {
        // random probability 
        float p = rnd.generate(0, 1);
    9054:	e3a02001 	mov	r2, #1
    9058:	e3a01000 	mov	r1, #0
    905c:	e59f00e4 	ldr	r0, [pc, #228]	; 9148 <_ZN10Chromosome9crossoverERS_+0x144>
    9060:	eb000722 	bl	acf0 <_ZN13Rnd_Generator8generateEii>
    9064:	ed0b0a03 	vstr	s0, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:75
  
        // if prob is less than 0.45, insert gene
        // from parent 1 
        if(p < 0.45) {
    9068:	ed5b7a03 	vldr	s15, [fp, #-12]
    906c:	eeb77ae7 	vcvt.f64.f32	d7, s15
    9070:	ed9f6b30 	vldr	d6, [pc, #192]	; 9138 <_ZN10Chromosome9crossoverERS_+0x134>
    9074:	eeb47bc6 	vcmpe.f64	d7, d6
    9078:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    907c:	5a00000a 	bpl	90ac <_ZN10Chromosome9crossoverERS_+0xa8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:76
            newChromosome.params[i] = params[i];
    9080:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    9084:	e51b3008 	ldr	r3, [fp, #-8]
    9088:	e1a03103 	lsl	r3, r3, #2
    908c:	e0823003 	add	r3, r2, r3
    9090:	e5932000 	ldr	r2, [r3]
    9094:	e51b1010 	ldr	r1, [fp, #-16]
    9098:	e51b3008 	ldr	r3, [fp, #-8]
    909c:	e1a03103 	lsl	r3, r3, #2
    90a0:	e0813003 	add	r3, r1, r3
    90a4:	e5832000 	str	r2, [r3]
    90a8:	ea00001a 	b	9118 <_ZN10Chromosome9crossoverERS_+0x114>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:81
        }
  
        // if prob is between 0.45 and 0.90, insert
        // gene from parent 2
        else if(p < 0.90) {
    90ac:	ed5b7a03 	vldr	s15, [fp, #-12]
    90b0:	eeb77ae7 	vcvt.f64.f32	d7, s15
    90b4:	ed9f6b21 	vldr	d6, [pc, #132]	; 9140 <_ZN10Chromosome9crossoverERS_+0x13c>
    90b8:	eeb47bc6 	vcmpe.f64	d7, d6
    90bc:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    90c0:	5a00000a 	bpl	90f0 <_ZN10Chromosome9crossoverERS_+0xec>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:82
            newChromosome.params[i] = other.params[i];
    90c4:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    90c8:	e51b3008 	ldr	r3, [fp, #-8]
    90cc:	e1a03103 	lsl	r3, r3, #2
    90d0:	e0823003 	add	r3, r2, r3
    90d4:	e5932000 	ldr	r2, [r3]
    90d8:	e51b1010 	ldr	r1, [fp, #-16]
    90dc:	e51b3008 	ldr	r3, [fp, #-8]
    90e0:	e1a03103 	lsl	r3, r3, #2
    90e4:	e0813003 	add	r3, r1, r3
    90e8:	e5832000 	str	r2, [r3]
    90ec:	ea000009 	b	9118 <_ZN10Chromosome9crossoverERS_+0x114>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:88
        }
  
        // otherwise insert random gene(mutate), 
        // for maintaining diversity
        else {
            newChromosome.params[i] = rnd.generate(RND_LOW_STOP, RND_HIGH_STOP);
    90f0:	e3a02005 	mov	r2, #5
    90f4:	e3e01004 	mvn	r1, #4
    90f8:	e59f0048 	ldr	r0, [pc, #72]	; 9148 <_ZN10Chromosome9crossoverERS_+0x144>
    90fc:	eb0006fb 	bl	acf0 <_ZN13Rnd_Generator8generateEii>
    9100:	eef07a40 	vmov.f32	s15, s0
    9104:	e51b2010 	ldr	r2, [fp, #-16]
    9108:	e51b3008 	ldr	r3, [fp, #-8]
    910c:	e1a03103 	lsl	r3, r3, #2
    9110:	e0823003 	add	r3, r2, r3
    9114:	edc37a00 	vstr	s15, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:68 (discriminator 2)
    for (int i = 0; i < PARAM_COUNT; i++)
    9118:	e51b3008 	ldr	r3, [fp, #-8]
    911c:	e2833001 	add	r3, r3, #1
    9120:	e50b3008 	str	r3, [fp, #-8]
    9124:	eaffffc7 	b	9048 <_ZN10Chromosome9crossoverERS_+0x44>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:92
        }
    }

    return newChromosome;
    9128:	e320f000 	nop	{0}
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:93
}
    912c:	e51b0010 	ldr	r0, [fp, #-16]
    9130:	e24bd004 	sub	sp, fp, #4
    9134:	e8bd8800 	pop	{fp, pc}
    9138:	cccccccd 	stclgt	12, cr12, [ip], {205}	; 0xcd
    913c:	3fdccccc 	svccc	0x00dccccc
    9140:	cccccccd 	stclgt	12, cr12, [ip], {205}	; 0xcd
    9144:	3feccccc 	svccc	0x00eccccc
    9148:	0000b700 	andeq	fp, r0, r0, lsl #14

0000914c <_ZN10Chromosome13init_randomlyEv>:
_ZN10Chromosome13init_randomlyEv():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:99

/**
 * Init current chromosome with new values.
 */
void Chromosome::init_randomly()
{
    914c:	e92d4800 	push	{fp, lr}
    9150:	e28db004 	add	fp, sp, #4
    9154:	e24dd010 	sub	sp, sp, #16
    9158:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:100
    for (int i = 0; i < PARAM_COUNT; i++) {
    915c:	e3a03000 	mov	r3, #0
    9160:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:100 (discriminator 3)
    9164:	e51b3008 	ldr	r3, [fp, #-8]
    9168:	e3530004 	cmp	r3, #4
    916c:	ca00000d 	bgt	91a8 <_ZN10Chromosome13init_randomlyEv+0x5c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:101 (discriminator 2)
        params[i] = rnd.generate(RND_LOW_STOP, RND_HIGH_STOP); 
    9170:	e3a02005 	mov	r2, #5
    9174:	e3e01004 	mvn	r1, #4
    9178:	e59f0034 	ldr	r0, [pc, #52]	; 91b4 <_ZN10Chromosome13init_randomlyEv+0x68>
    917c:	eb0006db 	bl	acf0 <_ZN13Rnd_Generator8generateEii>
    9180:	eef07a40 	vmov.f32	s15, s0
    9184:	e51b2010 	ldr	r2, [fp, #-16]
    9188:	e51b3008 	ldr	r3, [fp, #-8]
    918c:	e1a03103 	lsl	r3, r3, #2
    9190:	e0823003 	add	r3, r2, r3
    9194:	edc37a00 	vstr	s15, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:100 (discriminator 2)
    for (int i = 0; i < PARAM_COUNT; i++) {
    9198:	e51b3008 	ldr	r3, [fp, #-8]
    919c:	e2833001 	add	r3, r3, #1
    91a0:	e50b3008 	str	r3, [fp, #-8]
    91a4:	eaffffee 	b	9164 <_ZN10Chromosome13init_randomlyEv+0x18>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:103
    }
}
    91a8:	e320f000 	nop	{0}
    91ac:	e24bd004 	sub	sp, fp, #4
    91b0:	e8bd8800 	pop	{fp, pc}
    91b4:	0000b700 	andeq	fp, r0, r0, lsl #14

000091b8 <_ZN10Chromosome11get_fitnessEv>:
_ZN10Chromosome11get_fitnessEv():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:109

/**
 * Returns precalculated fitness of the current Chromosome
 */
float Chromosome::get_fitness()
{
    91b8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    91bc:	e28db000 	add	fp, sp, #0
    91c0:	e24dd00c 	sub	sp, sp, #12
    91c4:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:110
    return fit;
    91c8:	e51b3008 	ldr	r3, [fp, #-8]
    91cc:	e5933014 	ldr	r3, [r3, #20]
    91d0:	ee073a90 	vmov	s15, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:111
}
    91d4:	eeb00a67 	vmov.f32	s0, s15
    91d8:	e28bd000 	add	sp, fp, #0
    91dc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    91e0:	e12fff1e 	bx	lr

000091e4 <_ZN10Chromosome9get_modelEv>:
_ZN10Chromosome9get_modelEv():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:117

/**
 * Returns values of the model.
 */
Model Chromosome::get_model() 
{
    91e4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    91e8:	e28db000 	add	fp, sp, #0
    91ec:	e24dd00c 	sub	sp, sp, #12
    91f0:	e50b0008 	str	r0, [fp, #-8]
    91f4:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:119
    Model model;
    model.A = params[Params::A];
    91f8:	e51b300c 	ldr	r3, [fp, #-12]
    91fc:	e5932000 	ldr	r2, [r3]
    9200:	e51b3008 	ldr	r3, [fp, #-8]
    9204:	e5832000 	str	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:120
    model.B = params[Params::B];
    9208:	e51b300c 	ldr	r3, [fp, #-12]
    920c:	e5932004 	ldr	r2, [r3, #4]
    9210:	e51b3008 	ldr	r3, [fp, #-8]
    9214:	e5832004 	str	r2, [r3, #4]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:121
    model.C = params[Params::C];
    9218:	e51b300c 	ldr	r3, [fp, #-12]
    921c:	e5932008 	ldr	r2, [r3, #8]
    9220:	e51b3008 	ldr	r3, [fp, #-8]
    9224:	e5832008 	str	r2, [r3, #8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:122
    model.D = params[Params::D];
    9228:	e51b300c 	ldr	r3, [fp, #-12]
    922c:	e593200c 	ldr	r2, [r3, #12]
    9230:	e51b3008 	ldr	r3, [fp, #-8]
    9234:	e583200c 	str	r2, [r3, #12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:123
    model.E = params[Params::E];
    9238:	e51b300c 	ldr	r3, [fp, #-12]
    923c:	e5932010 	ldr	r2, [r3, #16]
    9240:	e51b3008 	ldr	r3, [fp, #-8]
    9244:	e5832010 	str	r2, [r3, #16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:125

    return model;
    9248:	e320f000 	nop	{0}
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/chromosome.cpp:126
    924c:	e51b0008 	ldr	r0, [fp, #-8]
    9250:	e28bd000 	add	sp, fp, #0
    9254:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9258:	e12fff1e 	bx	lr

0000925c <_ZN10Generation12evaluate_genEfjfi>:
_ZN10Generation12evaluate_genEfjfi():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:8
#include <stdfile.h>
#include <stdstring.h>
#include <quicksort.h>

void Generation::evaluate_gen(float measured_value, uint32_t file, float yt, int tdelta)
{
    925c:	e92d4800 	push	{fp, lr}
    9260:	e28db004 	add	fp, sp, #4
    9264:	e24dd020 	sub	sp, sp, #32
    9268:	e50b0010 	str	r0, [fp, #-16]
    926c:	ed0b0a05 	vstr	s0, [fp, #-20]	; 0xffffffec
    9270:	e50b1018 	str	r1, [fp, #-24]	; 0xffffffe8
    9274:	ed4b0a07 	vstr	s1, [fp, #-28]	; 0xffffffe4
    9278:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:9
    for (int i = 0; i < GEN_SIZE; i++)
    927c:	e3a03000 	mov	r3, #0
    9280:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:9 (discriminator 3)
    9284:	e51b3008 	ldr	r3, [fp, #-8]
    9288:	e3530063 	cmp	r3, #99	; 0x63
    928c:	ca00000f 	bgt	92d0 <_ZN10Generation12evaluate_genEfjfi+0x74>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:11 (discriminator 2)
    {
        gen[i].fitness(measured_value, yt, tdelta);
    9290:	e51b2008 	ldr	r2, [fp, #-8]
    9294:	e1a03002 	mov	r3, r2
    9298:	e1a03083 	lsl	r3, r3, #1
    929c:	e0833002 	add	r3, r3, r2
    92a0:	e1a03183 	lsl	r3, r3, #3
    92a4:	e51b2010 	ldr	r2, [fp, #-16]
    92a8:	e0823003 	add	r3, r2, r3
    92ac:	e24b1014 	sub	r1, fp, #20
    92b0:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    92b4:	ed1b0a07 	vldr	s0, [fp, #-28]	; 0xffffffe4
    92b8:	e1a00003 	mov	r0, r3
    92bc:	ebffff1c 	bl	8f34 <_ZN10Chromosome7fitnessERffi>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:9 (discriminator 2)
    for (int i = 0; i < GEN_SIZE; i++)
    92c0:	e51b3008 	ldr	r3, [fp, #-8]
    92c4:	e2833001 	add	r3, r3, #1
    92c8:	e50b3008 	str	r3, [fp, #-8]
    92cc:	eaffffec 	b	9284 <_ZN10Generation12evaluate_genEfjfi+0x28>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:14
    }
    
    quicksort(gen, GEN_SIZE);
    92d0:	e51b3010 	ldr	r3, [fp, #-16]
    92d4:	e3a02000 	mov	r2, #0
    92d8:	e3a01064 	mov	r1, #100	; 0x64
    92dc:	e1a00003 	mov	r0, r3
    92e0:	eb0000d1 	bl	962c <_Z9quicksortI10ChromosomeEvPT_ii>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:15
}
    92e4:	e320f000 	nop	{0}
    92e8:	e24bd004 	sub	sp, fp, #4
    92ec:	e8bd8800 	pop	{fp, pc}

000092f0 <_ZN10Generation11init_randomEv>:
_ZN10Generation11init_randomEv():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:18

void Generation::init_random()
{
    92f0:	e92d4800 	push	{fp, lr}
    92f4:	e28db004 	add	fp, sp, #4
    92f8:	e24dd010 	sub	sp, sp, #16
    92fc:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:19
    for (int i = 0; i < GEN_SIZE; i++)
    9300:	e3a03000 	mov	r3, #0
    9304:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:19 (discriminator 3)
    9308:	e51b3008 	ldr	r3, [fp, #-8]
    930c:	e3530063 	cmp	r3, #99	; 0x63
    9310:	ca00000c 	bgt	9348 <_ZN10Generation11init_randomEv+0x58>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:20 (discriminator 2)
        gen[i].init_randomly();
    9314:	e51b2008 	ldr	r2, [fp, #-8]
    9318:	e1a03002 	mov	r3, r2
    931c:	e1a03083 	lsl	r3, r3, #1
    9320:	e0833002 	add	r3, r3, r2
    9324:	e1a03183 	lsl	r3, r3, #3
    9328:	e51b2010 	ldr	r2, [fp, #-16]
    932c:	e0823003 	add	r3, r2, r3
    9330:	e1a00003 	mov	r0, r3
    9334:	ebffff84 	bl	914c <_ZN10Chromosome13init_randomlyEv>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:19 (discriminator 2)
    for (int i = 0; i < GEN_SIZE; i++)
    9338:	e51b3008 	ldr	r3, [fp, #-8]
    933c:	e2833001 	add	r3, r3, #1
    9340:	e50b3008 	str	r3, [fp, #-8]
    9344:	eaffffef 	b	9308 <_ZN10Generation11init_randomEv+0x18>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:21
}
    9348:	e320f000 	nop	{0}
    934c:	e24bd004 	sub	sp, fp, #4
    9350:	e8bd8800 	pop	{fp, pc}

00009354 <_ZN10Generation7predictEfi>:
_ZN10Generation7predictEfi():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:25


float Generation::predict(float currentYt, int tdelta)
{
    9354:	e92d4800 	push	{fp, lr}
    9358:	e28db004 	add	fp, sp, #4
    935c:	e24dd010 	sub	sp, sp, #16
    9360:	e50b0008 	str	r0, [fp, #-8]
    9364:	ed0b0a03 	vstr	s0, [fp, #-12]
    9368:	e50b1010 	str	r1, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:26
    quicksort(gen, GEN_SIZE);
    936c:	e51b3008 	ldr	r3, [fp, #-8]
    9370:	e3a02000 	mov	r2, #0
    9374:	e3a01064 	mov	r1, #100	; 0x64
    9378:	e1a00003 	mov	r0, r3
    937c:	eb0000aa 	bl	962c <_Z9quicksortI10ChromosomeEvPT_ii>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:28
    
    return gen[0].predict(currentYt, tdelta);
    9380:	e51b3008 	ldr	r3, [fp, #-8]
    9384:	e51b1010 	ldr	r1, [fp, #-16]
    9388:	ed1b0a03 	vldr	s0, [fp, #-12]
    938c:	e1a00003 	mov	r0, r3
    9390:	ebfffec9 	bl	8ebc <_ZN10Chromosome7predictEfi>
    9394:	eef07a40 	vmov.f32	s15, s0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:29
}
    9398:	eeb00a67 	vmov.f32	s0, s15
    939c:	e24bd004 	sub	sp, fp, #4
    93a0:	e8bd8800 	pop	{fp, pc}

000093a4 <_ZN10Generation10crossbreedEPS_i>:
_ZN10Generation10crossbreedEPS_i():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:31

void Generation::crossbreed(Generation *g, int index) {
    93a4:	e92d4810 	push	{r4, fp, lr}
    93a8:	e28db008 	add	fp, sp, #8
    93ac:	e24dd064 	sub	sp, sp, #100	; 0x64
    93b0:	e50b0048 	str	r0, [fp, #-72]	; 0xffffffb8
    93b4:	e50b104c 	str	r1, [fp, #-76]	; 0xffffffb4
    93b8:	e50b2050 	str	r2, [fp, #-80]	; 0xffffffb0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:32
    int firstParentIndex = rnd.generate_int(0, GEN_SIZE);
    93bc:	e3a02064 	mov	r2, #100	; 0x64
    93c0:	e3a01000 	mov	r1, #0
    93c4:	e59f00d4 	ldr	r0, [pc, #212]	; 94a0 <_ZN10Generation10crossbreedEPS_i+0xfc>
    93c8:	eb000636 	bl	aca8 <_ZN13Rnd_Generator12generate_intEii>
    93cc:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:33
    Chromosome firstParent = gen[firstParentIndex];
    93d0:	e51b1048 	ldr	r1, [fp, #-72]	; 0xffffffb8
    93d4:	e51b2010 	ldr	r2, [fp, #-16]
    93d8:	e1a03002 	mov	r3, r2
    93dc:	e1a03083 	lsl	r3, r3, #1
    93e0:	e0833002 	add	r3, r3, r2
    93e4:	e1a03183 	lsl	r3, r3, #3
    93e8:	e0813003 	add	r3, r1, r3
    93ec:	e24bc02c 	sub	ip, fp, #44	; 0x2c
    93f0:	e1a0e003 	mov	lr, r3
    93f4:	e8be000f 	ldm	lr!, {r0, r1, r2, r3}
    93f8:	e8ac000f 	stmia	ip!, {r0, r1, r2, r3}
    93fc:	e89e0003 	ldm	lr, {r0, r1}
    9400:	e88c0003 	stm	ip, {r0, r1}
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:35

    int secondParentIndex = rnd.generate_int(0, GEN_SIZE);
    9404:	e3a02064 	mov	r2, #100	; 0x64
    9408:	e3a01000 	mov	r1, #0
    940c:	e59f008c 	ldr	r0, [pc, #140]	; 94a0 <_ZN10Generation10crossbreedEPS_i+0xfc>
    9410:	eb000624 	bl	aca8 <_ZN13Rnd_Generator12generate_intEii>
    9414:	e50b0014 	str	r0, [fp, #-20]	; 0xffffffec
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:36
    Chromosome secondParent = gen[secondParentIndex];
    9418:	e51b1048 	ldr	r1, [fp, #-72]	; 0xffffffb8
    941c:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    9420:	e1a03002 	mov	r3, r2
    9424:	e1a03083 	lsl	r3, r3, #1
    9428:	e0833002 	add	r3, r3, r2
    942c:	e1a03183 	lsl	r3, r3, #3
    9430:	e0813003 	add	r3, r1, r3
    9434:	e24bc044 	sub	ip, fp, #68	; 0x44
    9438:	e1a0e003 	mov	lr, r3
    943c:	e8be000f 	ldm	lr!, {r0, r1, r2, r3}
    9440:	e8ac000f 	stmia	ip!, {r0, r1, r2, r3}
    9444:	e89e0003 	ldm	lr, {r0, r1}
    9448:	e88c0003 	stm	ip, {r0, r1}
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:38
    
    g->gen[index] = firstParent.crossover(secondParent);
    944c:	e51b104c 	ldr	r1, [fp, #-76]	; 0xffffffb4
    9450:	e51b2050 	ldr	r2, [fp, #-80]	; 0xffffffb0
    9454:	e1a03002 	mov	r3, r2
    9458:	e1a03083 	lsl	r3, r3, #1
    945c:	e0833002 	add	r3, r3, r2
    9460:	e1a03183 	lsl	r3, r3, #3
    9464:	e0814003 	add	r4, r1, r3
    9468:	e24b306c 	sub	r3, fp, #108	; 0x6c
    946c:	e24b2044 	sub	r2, fp, #68	; 0x44
    9470:	e24b102c 	sub	r1, fp, #44	; 0x2c
    9474:	e1a00003 	mov	r0, r3
    9478:	ebfffee1 	bl	9004 <_ZN10Chromosome9crossoverERS_>
    947c:	e1a0e004 	mov	lr, r4
    9480:	e24bc06c 	sub	ip, fp, #108	; 0x6c
    9484:	e8bc000f 	ldm	ip!, {r0, r1, r2, r3}
    9488:	e8ae000f 	stmia	lr!, {r0, r1, r2, r3}
    948c:	e89c0003 	ldm	ip, {r0, r1}
    9490:	e88e0003 	stm	lr, {r0, r1}
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:39
}
    9494:	e320f000 	nop	{0}
    9498:	e24bd008 	sub	sp, fp, #8
    949c:	e8bd8810 	pop	{r4, fp, pc}
    94a0:	0000b700 	andeq	fp, r0, r0, lsl #14

000094a4 <_ZN10Generation8next_genEPS_>:
_ZN10Generation8next_genEPS_():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:42

void Generation::next_gen(Generation *g)
{
    94a4:	e92d4800 	push	{fp, lr}
    94a8:	e28db004 	add	fp, sp, #4
    94ac:	e24dd018 	sub	sp, sp, #24
    94b0:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    94b4:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:43
    int i = 0;
    94b8:	e3a03000 	mov	r3, #0
    94bc:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:45 (discriminator 2)
    // --- use top 10% without change
    for (; i < (GEN_SIZE / 100) * 10; i++)
    94c0:	e51b3008 	ldr	r3, [fp, #-8]
    94c4:	e3530009 	cmp	r3, #9
    94c8:	ca000017 	bgt	952c <_ZN10Generation8next_genEPS_+0x88>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:46 (discriminator 1)
        g->gen[i] = gen[i];
    94cc:	e51b101c 	ldr	r1, [fp, #-28]	; 0xffffffe4
    94d0:	e51b2008 	ldr	r2, [fp, #-8]
    94d4:	e1a03002 	mov	r3, r2
    94d8:	e1a03083 	lsl	r3, r3, #1
    94dc:	e0833002 	add	r3, r3, r2
    94e0:	e1a03183 	lsl	r3, r3, #3
    94e4:	e0810003 	add	r0, r1, r3
    94e8:	e51b1018 	ldr	r1, [fp, #-24]	; 0xffffffe8
    94ec:	e51b2008 	ldr	r2, [fp, #-8]
    94f0:	e1a03002 	mov	r3, r2
    94f4:	e1a03083 	lsl	r3, r3, #1
    94f8:	e0833002 	add	r3, r3, r2
    94fc:	e1a03183 	lsl	r3, r3, #3
    9500:	e0813003 	add	r3, r1, r3
    9504:	e1a0c000 	mov	ip, r0
    9508:	e1a0e003 	mov	lr, r3
    950c:	e8be000f 	ldm	lr!, {r0, r1, r2, r3}
    9510:	e8ac000f 	stmia	ip!, {r0, r1, r2, r3}
    9514:	e89e0003 	ldm	lr, {r0, r1}
    9518:	e88c0003 	stm	ip, {r0, r1}
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:45 (discriminator 1)
    for (; i < (GEN_SIZE / 100) * 10; i++)
    951c:	e51b3008 	ldr	r3, [fp, #-8]
    9520:	e2833001 	add	r3, r3, #1
    9524:	e50b3008 	str	r3, [fp, #-8]
    9528:	eaffffe4 	b	94c0 <_ZN10Generation8next_genEPS_+0x1c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:49 (discriminator 2)

    // Generate 80% of population by crossbreeding
    for (; i < (GEN_SIZE / 100) * 90; i++)
    952c:	e51b3008 	ldr	r3, [fp, #-8]
    9530:	e3530059 	cmp	r3, #89	; 0x59
    9534:	ca000007 	bgt	9558 <_ZN10Generation8next_genEPS_+0xb4>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:51 (discriminator 1)
    {
        crossbreed(g, i);
    9538:	e51b2008 	ldr	r2, [fp, #-8]
    953c:	e51b101c 	ldr	r1, [fp, #-28]	; 0xffffffe4
    9540:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    9544:	ebffff96 	bl	93a4 <_ZN10Generation10crossbreedEPS_i>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:49 (discriminator 1)
    for (; i < (GEN_SIZE / 100) * 90; i++)
    9548:	e51b3008 	ldr	r3, [fp, #-8]
    954c:	e2833001 	add	r3, r3, #1
    9550:	e50b3008 	str	r3, [fp, #-8]
    9554:	eafffff4 	b	952c <_ZN10Generation8next_genEPS_+0x88>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:55
    }

    // --- put copy of top 10% to the back
    int j = 0;
    9558:	e3a03000 	mov	r3, #0
    955c:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:56 (discriminator 2)
    for (; i < GEN_SIZE; i++) {
    9560:	e51b3008 	ldr	r3, [fp, #-8]
    9564:	e3530063 	cmp	r3, #99	; 0x63
    9568:	ca00001a 	bgt	95d8 <_ZN10Generation8next_genEPS_+0x134>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:57 (discriminator 1)
        g->gen[i] = gen[j];
    956c:	e51b101c 	ldr	r1, [fp, #-28]	; 0xffffffe4
    9570:	e51b2008 	ldr	r2, [fp, #-8]
    9574:	e1a03002 	mov	r3, r2
    9578:	e1a03083 	lsl	r3, r3, #1
    957c:	e0833002 	add	r3, r3, r2
    9580:	e1a03183 	lsl	r3, r3, #3
    9584:	e0810003 	add	r0, r1, r3
    9588:	e51b1018 	ldr	r1, [fp, #-24]	; 0xffffffe8
    958c:	e51b200c 	ldr	r2, [fp, #-12]
    9590:	e1a03002 	mov	r3, r2
    9594:	e1a03083 	lsl	r3, r3, #1
    9598:	e0833002 	add	r3, r3, r2
    959c:	e1a03183 	lsl	r3, r3, #3
    95a0:	e0813003 	add	r3, r1, r3
    95a4:	e1a0c000 	mov	ip, r0
    95a8:	e1a0e003 	mov	lr, r3
    95ac:	e8be000f 	ldm	lr!, {r0, r1, r2, r3}
    95b0:	e8ac000f 	stmia	ip!, {r0, r1, r2, r3}
    95b4:	e89e0003 	ldm	lr, {r0, r1}
    95b8:	e88c0003 	stm	ip, {r0, r1}
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:58 (discriminator 1)
        j++;
    95bc:	e51b300c 	ldr	r3, [fp, #-12]
    95c0:	e2833001 	add	r3, r3, #1
    95c4:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:56 (discriminator 1)
    for (; i < GEN_SIZE; i++) {
    95c8:	e51b3008 	ldr	r3, [fp, #-8]
    95cc:	e2833001 	add	r3, r3, #1
    95d0:	e50b3008 	str	r3, [fp, #-8]
    95d4:	eaffffe1 	b	9560 <_ZN10Generation8next_genEPS_+0xbc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:62
    }

    // --- mutate 40%? last
    for (int i = (GEN_SIZE / 100) * 60; i < GEN_SIZE; i++)
    95d8:	e3a0303c 	mov	r3, #60	; 0x3c
    95dc:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:62 (discriminator 3)
    95e0:	e51b3010 	ldr	r3, [fp, #-16]
    95e4:	e3530063 	cmp	r3, #99	; 0x63
    95e8:	ca00000c 	bgt	9620 <_ZN10Generation8next_genEPS_+0x17c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:63 (discriminator 2)
        g->gen[i].mutate();
    95ec:	e51b2010 	ldr	r2, [fp, #-16]
    95f0:	e1a03002 	mov	r3, r2
    95f4:	e1a03083 	lsl	r3, r3, #1
    95f8:	e0833002 	add	r3, r3, r2
    95fc:	e1a03183 	lsl	r3, r3, #3
    9600:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    9604:	e0823003 	add	r3, r2, r3
    9608:	e1a00003 	mov	r0, r3
    960c:	ebfffe65 	bl	8fa8 <_ZN10Chromosome6mutateEv>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:62 (discriminator 2)
    for (int i = (GEN_SIZE / 100) * 60; i < GEN_SIZE; i++)
    9610:	e51b3010 	ldr	r3, [fp, #-16]
    9614:	e2833001 	add	r3, r3, #1
    9618:	e50b3010 	str	r3, [fp, #-16]
    961c:	eaffffef 	b	95e0 <_ZN10Generation8next_genEPS_+0x13c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/evolution/generation.cpp:64
    9620:	e320f000 	nop	{0}
    9624:	e24bd004 	sub	sp, fp, #4
    9628:	e8bd8800 	pop	{fp, pc}

0000962c <_Z9quicksortI10ChromosomeEvPT_ii>:
_Z9quicksortI10ChromosomeEvPT_ii():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/../stdutils/include/quicksort.h:11
  T temp=v2;
  v2=v1;
  v1=temp;
}
template<class T>
void quicksort(T *array,int hi,int lo=0)
    962c:	e92d4800 	push	{fp, lr}
    9630:	e28db004 	add	fp, sp, #4
    9634:	e24dd018 	sub	sp, sp, #24
    9638:	e50b0010 	str	r0, [fp, #-16]
    963c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    9640:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/../stdutils/include/quicksort.h:13
{
  while(hi>lo)
    9644:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    9648:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    964c:	e1520003 	cmp	r2, r3
    9650:	da000088 	ble	9878 <_Z9quicksortI10ChromosomeEvPT_ii+0x24c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/../stdutils/include/quicksort.h:15
  {
    int i=lo;
    9654:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9658:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/../stdutils/include/quicksort.h:16
    int j=hi;
    965c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9660:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/../stdutils/include/quicksort.h:19
    do
    {
      while(array[i]<array[lo]&&i<j)
    9664:	e51b2008 	ldr	r2, [fp, #-8]
    9668:	e1a03002 	mov	r3, r2
    966c:	e1a03083 	lsl	r3, r3, #1
    9670:	e0833002 	add	r3, r3, r2
    9674:	e1a03183 	lsl	r3, r3, #3
    9678:	e1a02003 	mov	r2, r3
    967c:	e51b3010 	ldr	r3, [fp, #-16]
    9680:	e0830002 	add	r0, r3, r2
    9684:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    9688:	e1a03002 	mov	r3, r2
    968c:	e1a03083 	lsl	r3, r3, #1
    9690:	e0833002 	add	r3, r3, r2
    9694:	e1a03183 	lsl	r3, r3, #3
    9698:	e1a02003 	mov	r2, r3
    969c:	e51b3010 	ldr	r3, [fp, #-16]
    96a0:	e0833002 	add	r3, r3, r2
    96a4:	e1a01003 	mov	r1, r3
    96a8:	ebfffdbc 	bl	8da0 <_ZN10ChromosomeltERKS_>
    96ac:	e1a03000 	mov	r3, r0
    96b0:	e3530000 	cmp	r3, #0
    96b4:	0a000005 	beq	96d0 <_Z9quicksortI10ChromosomeEvPT_ii+0xa4>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/../stdutils/include/quicksort.h:19 (discriminator 1)
    96b8:	e51b2008 	ldr	r2, [fp, #-8]
    96bc:	e51b300c 	ldr	r3, [fp, #-12]
    96c0:	e1520003 	cmp	r2, r3
    96c4:	aa000001 	bge	96d0 <_Z9quicksortI10ChromosomeEvPT_ii+0xa4>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/../stdutils/include/quicksort.h:19 (discriminator 3)
    96c8:	e3a03001 	mov	r3, #1
    96cc:	ea000000 	b	96d4 <_Z9quicksortI10ChromosomeEvPT_ii+0xa8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/../stdutils/include/quicksort.h:19 (discriminator 4)
    96d0:	e3a03000 	mov	r3, #0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/../stdutils/include/quicksort.h:19 (discriminator 6)
    96d4:	e3530000 	cmp	r3, #0
    96d8:	0a000003 	beq	96ec <_Z9quicksortI10ChromosomeEvPT_ii+0xc0>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/../stdutils/include/quicksort.h:20
         i++;
    96dc:	e51b3008 	ldr	r3, [fp, #-8]
    96e0:	e2833001 	add	r3, r3, #1
    96e4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/../stdutils/include/quicksort.h:19
      while(array[i]<array[lo]&&i<j)
    96e8:	eaffffdd 	b	9664 <_Z9quicksortI10ChromosomeEvPT_ii+0x38>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/../stdutils/include/quicksort.h:21
      while(array[--j]>array[lo])
    96ec:	e51b300c 	ldr	r3, [fp, #-12]
    96f0:	e2433001 	sub	r3, r3, #1
    96f4:	e50b300c 	str	r3, [fp, #-12]
    96f8:	e51b200c 	ldr	r2, [fp, #-12]
    96fc:	e1a03002 	mov	r3, r2
    9700:	e1a03083 	lsl	r3, r3, #1
    9704:	e0833002 	add	r3, r3, r2
    9708:	e1a03183 	lsl	r3, r3, #3
    970c:	e1a02003 	mov	r2, r3
    9710:	e51b3010 	ldr	r3, [fp, #-16]
    9714:	e0830002 	add	r0, r3, r2
    9718:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    971c:	e1a03002 	mov	r3, r2
    9720:	e1a03083 	lsl	r3, r3, #1
    9724:	e0833002 	add	r3, r3, r2
    9728:	e1a03183 	lsl	r3, r3, #3
    972c:	e1a02003 	mov	r2, r3
    9730:	e51b3010 	ldr	r3, [fp, #-16]
    9734:	e0833002 	add	r3, r3, r2
    9738:	e1a01003 	mov	r1, r3
    973c:	ebfffda9 	bl	8de8 <_ZN10ChromosomegtERKS_>
    9740:	e1a03000 	mov	r3, r0
    9744:	e3530000 	cmp	r3, #0
    9748:	0a000000 	beq	9750 <_Z9quicksortI10ChromosomeEvPT_ii+0x124>
    974c:	eaffffe6 	b	96ec <_Z9quicksortI10ChromosomeEvPT_ii+0xc0>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/../stdutils/include/quicksort.h:23
                 ;
      if(i<j)
    9750:	e51b2008 	ldr	r2, [fp, #-8]
    9754:	e51b300c 	ldr	r3, [fp, #-12]
    9758:	e1520003 	cmp	r2, r3
    975c:	aa000011 	bge	97a8 <_Z9quicksortI10ChromosomeEvPT_ii+0x17c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/../stdutils/include/quicksort.h:24
         swap(array[i],array[j]);
    9760:	e51b2008 	ldr	r2, [fp, #-8]
    9764:	e1a03002 	mov	r3, r2
    9768:	e1a03083 	lsl	r3, r3, #1
    976c:	e0833002 	add	r3, r3, r2
    9770:	e1a03183 	lsl	r3, r3, #3
    9774:	e1a02003 	mov	r2, r3
    9778:	e51b3010 	ldr	r3, [fp, #-16]
    977c:	e0830002 	add	r0, r3, r2
    9780:	e51b200c 	ldr	r2, [fp, #-12]
    9784:	e1a03002 	mov	r3, r2
    9788:	e1a03083 	lsl	r3, r3, #1
    978c:	e0833002 	add	r3, r3, r2
    9790:	e1a03183 	lsl	r3, r3, #3
    9794:	e1a02003 	mov	r2, r3
    9798:	e51b3010 	ldr	r3, [fp, #-16]
    979c:	e0833002 	add	r3, r3, r2
    97a0:	e1a01003 	mov	r1, r3
    97a4:	eb000036 	bl	9884 <_Z4swapI10ChromosomeEvRT_S2_>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/../stdutils/include/quicksort.h:25
    }while(i<j);
    97a8:	e51b2008 	ldr	r2, [fp, #-8]
    97ac:	e51b300c 	ldr	r3, [fp, #-12]
    97b0:	e1520003 	cmp	r2, r3
    97b4:	aa000000 	bge	97bc <_Z9quicksortI10ChromosomeEvPT_ii+0x190>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/../stdutils/include/quicksort.h:17
    do
    97b8:	eaffffa9 	b	9664 <_Z9quicksortI10ChromosomeEvPT_ii+0x38>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/../stdutils/include/quicksort.h:26
    swap(array[lo],array[j]);
    97bc:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    97c0:	e1a03002 	mov	r3, r2
    97c4:	e1a03083 	lsl	r3, r3, #1
    97c8:	e0833002 	add	r3, r3, r2
    97cc:	e1a03183 	lsl	r3, r3, #3
    97d0:	e1a02003 	mov	r2, r3
    97d4:	e51b3010 	ldr	r3, [fp, #-16]
    97d8:	e0830002 	add	r0, r3, r2
    97dc:	e51b200c 	ldr	r2, [fp, #-12]
    97e0:	e1a03002 	mov	r3, r2
    97e4:	e1a03083 	lsl	r3, r3, #1
    97e8:	e0833002 	add	r3, r3, r2
    97ec:	e1a03183 	lsl	r3, r3, #3
    97f0:	e1a02003 	mov	r2, r3
    97f4:	e51b3010 	ldr	r3, [fp, #-16]
    97f8:	e0833002 	add	r3, r3, r2
    97fc:	e1a01003 	mov	r1, r3
    9800:	eb00001f 	bl	9884 <_Z4swapI10ChromosomeEvRT_S2_>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/../stdutils/include/quicksort.h:28
 
    if(j-lo>hi-(j+1)) {
    9804:	e51b200c 	ldr	r2, [fp, #-12]
    9808:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    980c:	e0422003 	sub	r2, r2, r3
    9810:	e51b300c 	ldr	r3, [fp, #-12]
    9814:	e2833001 	add	r3, r3, #1
    9818:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    981c:	e0413003 	sub	r3, r1, r3
    9820:	e1520003 	cmp	r2, r3
    9824:	da000009 	ble	9850 <_Z9quicksortI10ChromosomeEvPT_ii+0x224>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/../stdutils/include/quicksort.h:29
       quicksort(array,j-1,lo);
    9828:	e51b300c 	ldr	r3, [fp, #-12]
    982c:	e2433001 	sub	r3, r3, #1
    9830:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    9834:	e1a01003 	mov	r1, r3
    9838:	e51b0010 	ldr	r0, [fp, #-16]
    983c:	ebffff7a 	bl	962c <_Z9quicksortI10ChromosomeEvPT_ii>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/../stdutils/include/quicksort.h:30
       lo=j+1;
    9840:	e51b300c 	ldr	r3, [fp, #-12]
    9844:	e2833001 	add	r3, r3, #1
    9848:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
    984c:	eaffff7c 	b	9644 <_Z9quicksortI10ChromosomeEvPT_ii+0x18>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/../stdutils/include/quicksort.h:32
    }else{
       quicksort(array,hi,j+1);
    9850:	e51b300c 	ldr	r3, [fp, #-12]
    9854:	e2833001 	add	r3, r3, #1
    9858:	e1a02003 	mov	r2, r3
    985c:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    9860:	e51b0010 	ldr	r0, [fp, #-16]
    9864:	ebffff70 	bl	962c <_Z9quicksortI10ChromosomeEvPT_ii>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/../stdutils/include/quicksort.h:33
       hi=j-1;
    9868:	e51b300c 	ldr	r3, [fp, #-12]
    986c:	e2433001 	sub	r3, r3, #1
    9870:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/../stdutils/include/quicksort.h:13
  while(hi>lo)
    9874:	eaffff72 	b	9644 <_Z9quicksortI10ChromosomeEvPT_ii+0x18>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/../stdutils/include/quicksort.h:36
    }
  }
    9878:	e320f000 	nop	{0}
    987c:	e24bd004 	sub	sp, fp, #4
    9880:	e8bd8800 	pop	{fp, pc}

00009884 <_Z4swapI10ChromosomeEvRT_S2_>:
_Z4swapI10ChromosomeEvRT_S2_():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/../stdutils/include/quicksort.h:4
inline void swap(T& v1,T& v2)
    9884:	e92d4800 	push	{fp, lr}
    9888:	e28db004 	add	fp, sp, #4
    988c:	e24dd020 	sub	sp, sp, #32
    9890:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
    9894:	e50b1024 	str	r1, [fp, #-36]	; 0xffffffdc
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/../stdutils/include/quicksort.h:6
  T temp=v2;
    9898:	e51b3024 	ldr	r3, [fp, #-36]	; 0xffffffdc
    989c:	e24bc01c 	sub	ip, fp, #28
    98a0:	e1a0e003 	mov	lr, r3
    98a4:	e8be000f 	ldm	lr!, {r0, r1, r2, r3}
    98a8:	e8ac000f 	stmia	ip!, {r0, r1, r2, r3}
    98ac:	e89e0003 	ldm	lr, {r0, r1}
    98b0:	e88c0003 	stm	ip, {r0, r1}
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/../stdutils/include/quicksort.h:7
  v2=v1;
    98b4:	e51b2024 	ldr	r2, [fp, #-36]	; 0xffffffdc
    98b8:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    98bc:	e1a0c002 	mov	ip, r2
    98c0:	e1a0e003 	mov	lr, r3
    98c4:	e8be000f 	ldm	lr!, {r0, r1, r2, r3}
    98c8:	e8ac000f 	stmia	ip!, {r0, r1, r2, r3}
    98cc:	e89e0003 	ldm	lr, {r0, r1}
    98d0:	e88c0003 	stm	ip, {r0, r1}
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/../stdutils/include/quicksort.h:8
  v1=temp;
    98d4:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    98d8:	e1a0e003 	mov	lr, r3
    98dc:	e24bc01c 	sub	ip, fp, #28
    98e0:	e8bc000f 	ldm	ip!, {r0, r1, r2, r3}
    98e4:	e8ae000f 	stmia	lr!, {r0, r1, r2, r3}
    98e8:	e89c0003 	ldm	ip, {r0, r1}
    98ec:	e88e0003 	stm	lr, {r0, r1}
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/../stdutils/include/quicksort.h:9
}
    98f0:	e320f000 	nop	{0}
    98f4:	e24bd004 	sub	sp, fp, #4
    98f8:	e8bd8800 	pop	{fp, pc}

000098fc <_Z5fputsjPKc>:
_Z5fputsjPKc():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/utils.cpp:4
#include <utils.h>

void fputs(uint32_t file, const char* string)
{
    98fc:	e92d4800 	push	{fp, lr}
    9900:	e28db004 	add	fp, sp, #4
    9904:	e24dd008 	sub	sp, sp, #8
    9908:	e50b0008 	str	r0, [fp, #-8]
    990c:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/utils.cpp:5
	write(file, string, strlen(string));
    9910:	e51b000c 	ldr	r0, [fp, #-12]
    9914:	eb000422 	bl	a9a4 <_Z6strlenPKc>
    9918:	e1a03000 	mov	r3, r0
    991c:	e1a02003 	mov	r2, r3
    9920:	e51b100c 	ldr	r1, [fp, #-12]
    9924:	e51b0008 	ldr	r0, [fp, #-8]
    9928:	eb00007b 	bl	9b1c <_Z5writejPKcj>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/utils.cpp:6
}
    992c:	e320f000 	nop	{0}
    9930:	e24bd004 	sub	sp, fp, #4
    9934:	e8bd8800 	pop	{fp, pc}

00009938 <_Z7printlnjPKc>:
_Z7printlnjPKc():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/utils.cpp:9

void println(uint32_t file, const char* string)
{
    9938:	e92d4800 	push	{fp, lr}
    993c:	e28db004 	add	fp, sp, #4
    9940:	e24dd088 	sub	sp, sp, #136	; 0x88
    9944:	e50b0088 	str	r0, [fp, #-136]	; 0xffffff78
    9948:	e50b108c 	str	r1, [fp, #-140]	; 0xffffff74
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/utils.cpp:11
	char messageBuffer[MESSAGE_BUFFER_SIZE];
	bzero(messageBuffer, MESSAGE_BUFFER_SIZE);
    994c:	e24b3084 	sub	r3, fp, #132	; 0x84
    9950:	e3a01080 	mov	r1, #128	; 0x80
    9954:	e1a00003 	mov	r0, r3
    9958:	eb000426 	bl	a9f8 <_Z5bzeroPvi>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/utils.cpp:12
	strcat(messageBuffer, string);
    995c:	e24b3084 	sub	r3, fp, #132	; 0x84
    9960:	e51b108c 	ldr	r1, [fp, #-140]	; 0xffffff74
    9964:	e1a00003 	mov	r0, r3
    9968:	eb0003ad 	bl	a824 <_Z6strcatPcPKc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/utils.cpp:13
	strcat(messageBuffer, NEWLINE);
    996c:	e24b3084 	sub	r3, fp, #132	; 0x84
    9970:	e59f1020 	ldr	r1, [pc, #32]	; 9998 <_Z7printlnjPKc+0x60>
    9974:	e1a00003 	mov	r0, r3
    9978:	eb0003a9 	bl	a824 <_Z6strcatPcPKc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/utils.cpp:14
	fputs(file, messageBuffer);
    997c:	e24b3084 	sub	r3, fp, #132	; 0x84
    9980:	e1a01003 	mov	r1, r3
    9984:	e51b0088 	ldr	r0, [fp, #-136]	; 0xffffff78
    9988:	ebffffdb 	bl	98fc <_Z5fputsjPKc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/utils.cpp:15
}
    998c:	e320f000 	nop	{0}
    9990:	e24bd004 	sub	sp, fp, #4
    9994:	e8bd8800 	pop	{fp, pc}
    9998:	0000b634 	andeq	fp, r0, r4, lsr r6

0000999c <_Z19print_str_and_floatjPKcf>:
_Z19print_str_and_floatjPKcf():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/utils.cpp:17

void print_str_and_float(uint32_t file, const char* string, float val) {
    999c:	e92d4800 	push	{fp, lr}
    99a0:	e28db004 	add	fp, sp, #4
    99a4:	e24dd0a0 	sub	sp, sp, #160	; 0xa0
    99a8:	e50b0098 	str	r0, [fp, #-152]	; 0xffffff68
    99ac:	e50b109c 	str	r1, [fp, #-156]	; 0xffffff64
    99b0:	ed0b0a28 	vstr	s0, [fp, #-160]	; 0xffffff60
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/utils.cpp:21
	char messageBuffer[MESSAGE_BUFFER_SIZE];
	char tmpBuffer[TMP_BUFFER_SIZE];

	bzero(messageBuffer, MESSAGE_BUFFER_SIZE);			
    99b4:	e24b3084 	sub	r3, fp, #132	; 0x84
    99b8:	e3a01080 	mov	r1, #128	; 0x80
    99bc:	e1a00003 	mov	r0, r3
    99c0:	eb00040c 	bl	a9f8 <_Z5bzeroPvi>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/utils.cpp:22
	strcat(messageBuffer, string);
    99c4:	e24b3084 	sub	r3, fp, #132	; 0x84
    99c8:	e51b109c 	ldr	r1, [fp, #-156]	; 0xffffff64
    99cc:	e1a00003 	mov	r0, r3
    99d0:	eb000393 	bl	a824 <_Z6strcatPcPKc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/utils.cpp:23
	ftoa(tmpBuffer, val);
    99d4:	e24b3090 	sub	r3, fp, #144	; 0x90
    99d8:	ed1b0a28 	vldr	s0, [fp, #-160]	; 0xffffff60
    99dc:	e1a00003 	mov	r0, r3
    99e0:	eb0002d1 	bl	a52c <_Z4ftoaPcf>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/utils.cpp:24
	strcat(messageBuffer, tmpBuffer);
    99e4:	e24b2090 	sub	r2, fp, #144	; 0x90
    99e8:	e24b3084 	sub	r3, fp, #132	; 0x84
    99ec:	e1a01002 	mov	r1, r2
    99f0:	e1a00003 	mov	r0, r3
    99f4:	eb00038a 	bl	a824 <_Z6strcatPcPKc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/utils.cpp:26
	
	println(file, messageBuffer);
    99f8:	e24b3084 	sub	r3, fp, #132	; 0x84
    99fc:	e1a01003 	mov	r1, r3
    9a00:	e51b0098 	ldr	r0, [fp, #-152]	; 0xffffff68
    9a04:	ebffffcb 	bl	9938 <_Z7printlnjPKc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/src/utils.cpp:27
}
    9a08:	e320f000 	nop	{0}
    9a0c:	e24bd004 	sub	sp, fp, #4
    9a10:	e8bd8800 	pop	{fp, pc}

00009a14 <_Z6getpidv>:
_Z6getpidv():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    9a14:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9a18:	e28db000 	add	fp, sp, #0
    9a1c:	e24dd00c 	sub	sp, sp, #12
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    9a20:	ef000000 	svc	0x00000000
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    9a24:	e1a03000 	mov	r3, r0
    9a28:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:11

    return pid;
    9a2c:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:12
}
    9a30:	e1a00003 	mov	r0, r3
    9a34:	e28bd000 	add	sp, fp, #0
    9a38:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9a3c:	e12fff1e 	bx	lr

00009a40 <_Z9terminatei>:
_Z9terminatei():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    9a40:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9a44:	e28db000 	add	fp, sp, #0
    9a48:	e24dd00c 	sub	sp, sp, #12
    9a4c:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r" (exitcode));
    9a50:	e51b3008 	ldr	r3, [fp, #-8]
    9a54:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    9a58:	ef000001 	svc	0x00000001
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:18
}
    9a5c:	e320f000 	nop	{0}
    9a60:	e28bd000 	add	sp, fp, #0
    9a64:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9a68:	e12fff1e 	bx	lr

00009a6c <_Z11sched_yieldv>:
_Z11sched_yieldv():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    9a6c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9a70:	e28db000 	add	fp, sp, #0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    9a74:	ef000002 	svc	0x00000002
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:23
}
    9a78:	e320f000 	nop	{0}
    9a7c:	e28bd000 	add	sp, fp, #0
    9a80:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9a84:	e12fff1e 	bx	lr

00009a88 <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    9a88:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9a8c:	e28db000 	add	fp, sp, #0
    9a90:	e24dd014 	sub	sp, sp, #20
    9a94:	e50b0010 	str	r0, [fp, #-16]
    9a98:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    9a9c:	e51b3010 	ldr	r3, [fp, #-16]
    9aa0:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r" (mode));
    9aa4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9aa8:	e1a01003 	mov	r1, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    9aac:	ef000040 	svc	0x00000040
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r" (file));
    9ab0:	e1a03000 	mov	r3, r0
    9ab4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:34

    return file;
    9ab8:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:35
}
    9abc:	e1a00003 	mov	r0, r3
    9ac0:	e28bd000 	add	sp, fp, #0
    9ac4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9ac8:	e12fff1e 	bx	lr

00009acc <_Z4readjPcj>:
_Z4readjPcj():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    9acc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9ad0:	e28db000 	add	fp, sp, #0
    9ad4:	e24dd01c 	sub	sp, sp, #28
    9ad8:	e50b0010 	str	r0, [fp, #-16]
    9adc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    9ae0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    9ae4:	e51b3010 	ldr	r3, [fp, #-16]
    9ae8:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r" (buffer));
    9aec:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9af0:	e1a01003 	mov	r1, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r" (size));
    9af4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9af8:	e1a02003 	mov	r2, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    9afc:	ef000041 	svc	0x00000041
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r" (rdnum));
    9b00:	e1a03000 	mov	r3, r0
    9b04:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:47

    return rdnum;
    9b08:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:48
}
    9b0c:	e1a00003 	mov	r0, r3
    9b10:	e28bd000 	add	sp, fp, #0
    9b14:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9b18:	e12fff1e 	bx	lr

00009b1c <_Z5writejPKcj>:
_Z5writejPKcj():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:51

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    9b1c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9b20:	e28db000 	add	fp, sp, #0
    9b24:	e24dd01c 	sub	sp, sp, #28
    9b28:	e50b0010 	str	r0, [fp, #-16]
    9b2c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    9b30:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:54
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    9b34:	e51b3010 	ldr	r3, [fp, #-16]
    9b38:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:55
    asm volatile("mov r1, %0" : : "r" (buffer));
    9b3c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9b40:	e1a01003 	mov	r1, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:56
    asm volatile("mov r2, %0" : : "r" (size));
    9b44:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9b48:	e1a02003 	mov	r2, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:57
    asm volatile("swi 66");
    9b4c:	ef000042 	svc	0x00000042
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:58
    asm volatile("mov %0, r0" : "=r" (wrnum));
    9b50:	e1a03000 	mov	r3, r0
    9b54:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:60

    return wrnum;
    9b58:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:61
}
    9b5c:	e1a00003 	mov	r0, r3
    9b60:	e28bd000 	add	sp, fp, #0
    9b64:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9b68:	e12fff1e 	bx	lr

00009b6c <_Z5closej>:
_Z5closej():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:64

void close(uint32_t file)
{
    9b6c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9b70:	e28db000 	add	fp, sp, #0
    9b74:	e24dd00c 	sub	sp, sp, #12
    9b78:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:65
    asm volatile("mov r0, %0" : : "r" (file));
    9b7c:	e51b3008 	ldr	r3, [fp, #-8]
    9b80:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:66
    asm volatile("swi 67");
    9b84:	ef000043 	svc	0x00000043
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:67
}
    9b88:	e320f000 	nop	{0}
    9b8c:	e28bd000 	add	sp, fp, #0
    9b90:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9b94:	e12fff1e 	bx	lr

00009b98 <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:70

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    9b98:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9b9c:	e28db000 	add	fp, sp, #0
    9ba0:	e24dd01c 	sub	sp, sp, #28
    9ba4:	e50b0010 	str	r0, [fp, #-16]
    9ba8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    9bac:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:73
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    9bb0:	e51b3010 	ldr	r3, [fp, #-16]
    9bb4:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:74
    asm volatile("mov r1, %0" : : "r" (operation));
    9bb8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9bbc:	e1a01003 	mov	r1, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:75
    asm volatile("mov r2, %0" : : "r" (param));
    9bc0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9bc4:	e1a02003 	mov	r2, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:76
    asm volatile("swi 68");
    9bc8:	ef000044 	svc	0x00000044
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:77
    asm volatile("mov %0, r0" : "=r" (retcode));
    9bcc:	e1a03000 	mov	r3, r0
    9bd0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:79

    return retcode;
    9bd4:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:80
}
    9bd8:	e1a00003 	mov	r0, r3
    9bdc:	e28bd000 	add	sp, fp, #0
    9be0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9be4:	e12fff1e 	bx	lr

00009be8 <_Z6notifyjj>:
_Z6notifyjj():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:83

uint32_t notify(uint32_t file, uint32_t count)
{
    9be8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9bec:	e28db000 	add	fp, sp, #0
    9bf0:	e24dd014 	sub	sp, sp, #20
    9bf4:	e50b0010 	str	r0, [fp, #-16]
    9bf8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:86
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    9bfc:	e51b3010 	ldr	r3, [fp, #-16]
    9c00:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:87
    asm volatile("mov r1, %0" : : "r" (count));
    9c04:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9c08:	e1a01003 	mov	r1, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:88
    asm volatile("swi 69");
    9c0c:	ef000045 	svc	0x00000045
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:89
    asm volatile("mov %0, r0" : "=r" (retcnt));
    9c10:	e1a03000 	mov	r3, r0
    9c14:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:91

    return retcnt;
    9c18:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:92
}
    9c1c:	e1a00003 	mov	r0, r3
    9c20:	e28bd000 	add	sp, fp, #0
    9c24:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9c28:	e12fff1e 	bx	lr

00009c2c <_Z4waitjjj>:
_Z4waitjjj():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:95

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    9c2c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9c30:	e28db000 	add	fp, sp, #0
    9c34:	e24dd01c 	sub	sp, sp, #28
    9c38:	e50b0010 	str	r0, [fp, #-16]
    9c3c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    9c40:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:98
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    9c44:	e51b3010 	ldr	r3, [fp, #-16]
    9c48:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:99
    asm volatile("mov r1, %0" : : "r" (count));
    9c4c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9c50:	e1a01003 	mov	r1, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:100
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    9c54:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9c58:	e1a02003 	mov	r2, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:101
    asm volatile("swi 70");
    9c5c:	ef000046 	svc	0x00000046
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:102
    asm volatile("mov %0, r0" : "=r" (retcode));
    9c60:	e1a03000 	mov	r3, r0
    9c64:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:104

    return retcode;
    9c68:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:105
}
    9c6c:	e1a00003 	mov	r0, r3
    9c70:	e28bd000 	add	sp, fp, #0
    9c74:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9c78:	e12fff1e 	bx	lr

00009c7c <_Z5sleepjj>:
_Z5sleepjj():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:108

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    9c7c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9c80:	e28db000 	add	fp, sp, #0
    9c84:	e24dd014 	sub	sp, sp, #20
    9c88:	e50b0010 	str	r0, [fp, #-16]
    9c8c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:111
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    9c90:	e51b3010 	ldr	r3, [fp, #-16]
    9c94:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:112
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    9c98:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9c9c:	e1a01003 	mov	r1, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:113
    asm volatile("swi 3");
    9ca0:	ef000003 	svc	0x00000003
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:114
    asm volatile("mov %0, r0" : "=r" (retcode));
    9ca4:	e1a03000 	mov	r3, r0
    9ca8:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:116

    return retcode;
    9cac:	e51b3008 	ldr	r3, [fp, #-8]
    9cb0:	e3530000 	cmp	r3, #0
    9cb4:	13a03001 	movne	r3, #1
    9cb8:	03a03000 	moveq	r3, #0
    9cbc:	e6ef3073 	uxtb	r3, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:117
}
    9cc0:	e1a00003 	mov	r0, r3
    9cc4:	e28bd000 	add	sp, fp, #0
    9cc8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9ccc:	e12fff1e 	bx	lr

00009cd0 <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:120

uint32_t get_active_process_count()
{
    9cd0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9cd4:	e28db000 	add	fp, sp, #0
    9cd8:	e24dd00c 	sub	sp, sp, #12
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:121
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    9cdc:	e3a03000 	mov	r3, #0
    9ce0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:124
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    9ce4:	e3a03000 	mov	r3, #0
    9ce8:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:125
    asm volatile("mov r1, %0" : : "r" (&retval));
    9cec:	e24b300c 	sub	r3, fp, #12
    9cf0:	e1a01003 	mov	r1, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:126
    asm volatile("swi 4");
    9cf4:	ef000004 	svc	0x00000004
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:128

    return retval;
    9cf8:	e51b300c 	ldr	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:129
}
    9cfc:	e1a00003 	mov	r0, r3
    9d00:	e28bd000 	add	sp, fp, #0
    9d04:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9d08:	e12fff1e 	bx	lr

00009d0c <_Z14get_tick_countv>:
_Z14get_tick_countv():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:132

uint32_t get_tick_count()
{
    9d0c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9d10:	e28db000 	add	fp, sp, #0
    9d14:	e24dd00c 	sub	sp, sp, #12
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:133
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    9d18:	e3a03001 	mov	r3, #1
    9d1c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:136
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    9d20:	e3a03001 	mov	r3, #1
    9d24:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:137
    asm volatile("mov r1, %0" : : "r" (&retval));
    9d28:	e24b300c 	sub	r3, fp, #12
    9d2c:	e1a01003 	mov	r1, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:138
    asm volatile("swi 4");
    9d30:	ef000004 	svc	0x00000004
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:140

    return retval;
    9d34:	e51b300c 	ldr	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:141
}
    9d38:	e1a00003 	mov	r0, r3
    9d3c:	e28bd000 	add	sp, fp, #0
    9d40:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9d44:	e12fff1e 	bx	lr

00009d48 <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:144

void set_task_deadline(uint32_t tick_count_required)
{
    9d48:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9d4c:	e28db000 	add	fp, sp, #0
    9d50:	e24dd014 	sub	sp, sp, #20
    9d54:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:145
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    9d58:	e3a03000 	mov	r3, #0
    9d5c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:147

    asm volatile("mov r0, %0" : : "r" (req));
    9d60:	e3a03000 	mov	r3, #0
    9d64:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:148
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    9d68:	e24b3010 	sub	r3, fp, #16
    9d6c:	e1a01003 	mov	r1, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:149
    asm volatile("swi 5");
    9d70:	ef000005 	svc	0x00000005
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:150
}
    9d74:	e320f000 	nop	{0}
    9d78:	e28bd000 	add	sp, fp, #0
    9d7c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9d80:	e12fff1e 	bx	lr

00009d84 <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:153

uint32_t get_task_ticks_to_deadline()
{
    9d84:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9d88:	e28db000 	add	fp, sp, #0
    9d8c:	e24dd00c 	sub	sp, sp, #12
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:154
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    9d90:	e3a03001 	mov	r3, #1
    9d94:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:157
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    9d98:	e3a03001 	mov	r3, #1
    9d9c:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:158
    asm volatile("mov r1, %0" : : "r" (&ticks));
    9da0:	e24b300c 	sub	r3, fp, #12
    9da4:	e1a01003 	mov	r1, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:159
    asm volatile("swi 5");
    9da8:	ef000005 	svc	0x00000005
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:161

    return ticks;
    9dac:	e51b300c 	ldr	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:162
}
    9db0:	e1a00003 	mov	r0, r3
    9db4:	e28bd000 	add	sp, fp, #0
    9db8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9dbc:	e12fff1e 	bx	lr

00009dc0 <_Z4pipePKcj>:
_Z4pipePKcj():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:167

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    9dc0:	e92d4800 	push	{fp, lr}
    9dc4:	e28db004 	add	fp, sp, #4
    9dc8:	e24dd050 	sub	sp, sp, #80	; 0x50
    9dcc:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    9dd0:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:169
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    9dd4:	e24b3048 	sub	r3, fp, #72	; 0x48
    9dd8:	e3a0200a 	mov	r2, #10
    9ddc:	e59f1088 	ldr	r1, [pc, #136]	; 9e6c <_Z4pipePKcj+0xac>
    9de0:	e1a00003 	mov	r0, r3
    9de4:	eb00025e 	bl	a764 <_Z7strncpyPcPKci>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:170
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    9de8:	e24b3048 	sub	r3, fp, #72	; 0x48
    9dec:	e283300a 	add	r3, r3, #10
    9df0:	e3a02035 	mov	r2, #53	; 0x35
    9df4:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    9df8:	e1a00003 	mov	r0, r3
    9dfc:	eb000258 	bl	a764 <_Z7strncpyPcPKci>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:172

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    9e00:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    9e04:	eb0002e6 	bl	a9a4 <_Z6strlenPKc>
    9e08:	e1a03000 	mov	r3, r0
    9e0c:	e283300a 	add	r3, r3, #10
    9e10:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:174

    fname[ncur++] = '#';
    9e14:	e51b3008 	ldr	r3, [fp, #-8]
    9e18:	e2832001 	add	r2, r3, #1
    9e1c:	e50b2008 	str	r2, [fp, #-8]
    9e20:	e24b2004 	sub	r2, fp, #4
    9e24:	e0823003 	add	r3, r2, r3
    9e28:	e3a02023 	mov	r2, #35	; 0x23
    9e2c:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:176

    itoa(buf_size, &fname[ncur], 10);
    9e30:	e24b2048 	sub	r2, fp, #72	; 0x48
    9e34:	e51b3008 	ldr	r3, [fp, #-8]
    9e38:	e0823003 	add	r3, r2, r3
    9e3c:	e3a0200a 	mov	r2, #10
    9e40:	e1a01003 	mov	r1, r3
    9e44:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    9e48:	eb000016 	bl	9ea8 <_Z4itoajPcj>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:178

    return open(fname, NFile_Open_Mode::Read_Write);
    9e4c:	e24b3048 	sub	r3, fp, #72	; 0x48
    9e50:	e3a01002 	mov	r1, #2
    9e54:	e1a00003 	mov	r0, r3
    9e58:	ebffff0a 	bl	9a88 <_Z4openPKc15NFile_Open_Mode>
    9e5c:	e1a03000 	mov	r3, r0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:179
}
    9e60:	e1a00003 	mov	r0, r3
    9e64:	e24bd004 	sub	sp, fp, #4
    9e68:	e8bd8800 	pop	{fp, pc}
    9e6c:	0000b664 	andeq	fp, r0, r4, ror #12

00009e70 <_Z6mallocj>:
_Z6mallocj():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdmem.cpp:8
/**
 * In this function we could have placed anorther second layer of memory assignment resulting in 
 * less often calls of software interrupt and memory allocation.
 */
void* malloc(uint32_t size)
{
    9e70:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9e74:	e28db000 	add	fp, sp, #0
    9e78:	e24dd014 	sub	sp, sp, #20
    9e7c:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdmem.cpp:11
    uint32_t memAddress;

    asm volatile("mov r0, %0" : : "r" (size));
    9e80:	e51b3010 	ldr	r3, [fp, #-16]
    9e84:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdmem.cpp:12
    asm volatile("swi 128");
    9e88:	ef000080 	svc	0x00000080
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdmem.cpp:13
    asm volatile("mov %0, r0" : "=r" (memAddress));
    9e8c:	e1a03000 	mov	r3, r0
    9e90:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdmem.cpp:15

    return reinterpret_cast<void*>(memAddress);
    9e94:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdmem.cpp:16
}
    9e98:	e1a00003 	mov	r0, r3
    9e9c:	e28bd000 	add	sp, fp, #0
    9ea0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9ea4:	e12fff1e 	bx	lr

00009ea8 <_Z4itoajPcj>:
_Z4itoajPcj():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:11
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    9ea8:	e92d4800 	push	{fp, lr}
    9eac:	e28db004 	add	fp, sp, #4
    9eb0:	e24dd020 	sub	sp, sp, #32
    9eb4:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    9eb8:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    9ebc:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:12
	int i = 0;
    9ec0:	e3a03000 	mov	r3, #0
    9ec4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:14

	while (input > 0)
    9ec8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9ecc:	e3530000 	cmp	r3, #0
    9ed0:	0a000014 	beq	9f28 <_Z4itoajPcj+0x80>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:16
	{
		output[i] = CharConvArr[input % base];
    9ed4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9ed8:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    9edc:	e1a00003 	mov	r0, r3
    9ee0:	eb0004b4 	bl	b1b8 <__aeabi_uidivmod>
    9ee4:	e1a03001 	mov	r3, r1
    9ee8:	e1a01003 	mov	r1, r3
    9eec:	e51b3008 	ldr	r3, [fp, #-8]
    9ef0:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    9ef4:	e0823003 	add	r3, r2, r3
    9ef8:	e59f2118 	ldr	r2, [pc, #280]	; a018 <_Z4itoajPcj+0x170>
    9efc:	e7d22001 	ldrb	r2, [r2, r1]
    9f00:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:17
		input /= base;
    9f04:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    9f08:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    9f0c:	eb00047f 	bl	b110 <__udivsi3>
    9f10:	e1a03000 	mov	r3, r0
    9f14:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:18
		i++;
    9f18:	e51b3008 	ldr	r3, [fp, #-8]
    9f1c:	e2833001 	add	r3, r3, #1
    9f20:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:14
	while (input > 0)
    9f24:	eaffffe7 	b	9ec8 <_Z4itoajPcj+0x20>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:21
	}

    if (i == 0)
    9f28:	e51b3008 	ldr	r3, [fp, #-8]
    9f2c:	e3530000 	cmp	r3, #0
    9f30:	1a000007 	bne	9f54 <_Z4itoajPcj+0xac>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:23
    {
        output[i] = CharConvArr[0];
    9f34:	e51b3008 	ldr	r3, [fp, #-8]
    9f38:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    9f3c:	e0823003 	add	r3, r2, r3
    9f40:	e3a02030 	mov	r2, #48	; 0x30
    9f44:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:24
        i++;
    9f48:	e51b3008 	ldr	r3, [fp, #-8]
    9f4c:	e2833001 	add	r3, r3, #1
    9f50:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:27
    }

	output[i] = '\0';
    9f54:	e51b3008 	ldr	r3, [fp, #-8]
    9f58:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    9f5c:	e0823003 	add	r3, r2, r3
    9f60:	e3a02000 	mov	r2, #0
    9f64:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:28
	i--;
    9f68:	e51b3008 	ldr	r3, [fp, #-8]
    9f6c:	e2433001 	sub	r3, r3, #1
    9f70:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:30

	for (int j = 0; j <= i/2; j++)
    9f74:	e3a03000 	mov	r3, #0
    9f78:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:30 (discriminator 3)
    9f7c:	e51b3008 	ldr	r3, [fp, #-8]
    9f80:	e1a02fa3 	lsr	r2, r3, #31
    9f84:	e0823003 	add	r3, r2, r3
    9f88:	e1a030c3 	asr	r3, r3, #1
    9f8c:	e1a02003 	mov	r2, r3
    9f90:	e51b300c 	ldr	r3, [fp, #-12]
    9f94:	e1530002 	cmp	r3, r2
    9f98:	ca00001b 	bgt	a00c <_Z4itoajPcj+0x164>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:32 (discriminator 2)
	{
		char c = output[i - j];
    9f9c:	e51b2008 	ldr	r2, [fp, #-8]
    9fa0:	e51b300c 	ldr	r3, [fp, #-12]
    9fa4:	e0423003 	sub	r3, r2, r3
    9fa8:	e1a02003 	mov	r2, r3
    9fac:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9fb0:	e0833002 	add	r3, r3, r2
    9fb4:	e5d33000 	ldrb	r3, [r3]
    9fb8:	e54b300d 	strb	r3, [fp, #-13]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:33 (discriminator 2)
		output[i - j] = output[j];
    9fbc:	e51b300c 	ldr	r3, [fp, #-12]
    9fc0:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    9fc4:	e0822003 	add	r2, r2, r3
    9fc8:	e51b1008 	ldr	r1, [fp, #-8]
    9fcc:	e51b300c 	ldr	r3, [fp, #-12]
    9fd0:	e0413003 	sub	r3, r1, r3
    9fd4:	e1a01003 	mov	r1, r3
    9fd8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9fdc:	e0833001 	add	r3, r3, r1
    9fe0:	e5d22000 	ldrb	r2, [r2]
    9fe4:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:34 (discriminator 2)
		output[j] = c;
    9fe8:	e51b300c 	ldr	r3, [fp, #-12]
    9fec:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    9ff0:	e0823003 	add	r3, r2, r3
    9ff4:	e55b200d 	ldrb	r2, [fp, #-13]
    9ff8:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:30 (discriminator 2)
	for (int j = 0; j <= i/2; j++)
    9ffc:	e51b300c 	ldr	r3, [fp, #-12]
    a000:	e2833001 	add	r3, r3, #1
    a004:	e50b300c 	str	r3, [fp, #-12]
    a008:	eaffffdb 	b	9f7c <_Z4itoajPcj+0xd4>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:36
	}
}
    a00c:	e320f000 	nop	{0}
    a010:	e24bd004 	sub	sp, fp, #4
    a014:	e8bd8800 	pop	{fp, pc}
    a018:	0000b670 	andeq	fp, r0, r0, ror r6

0000a01c <_Z4atoiPKc>:
_Z4atoiPKc():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:39

int atoi(const char* input)
{
    a01c:	e92d4800 	push	{fp, lr}
    a020:	e28db004 	add	fp, sp, #4
    a024:	e24dd010 	sub	sp, sp, #16
    a028:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:40
	int output = 0;
    a02c:	e3a03000 	mov	r3, #0
    a030:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:42

  if (isnan(input, false)) {
    a034:	e3a01000 	mov	r1, #0
    a038:	e51b0010 	ldr	r0, [fp, #-16]
    a03c:	eb000055 	bl	a198 <_Z5isnanPKcb>
    a040:	e1a03000 	mov	r3, r0
    a044:	e3530000 	cmp	r3, #0
    a048:	0a000001 	beq	a054 <_Z4atoiPKc+0x38>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:43
    return 0;
    a04c:	e3a03000 	mov	r3, #0
    a050:	ea00001c 	b	a0c8 <_Z4atoiPKc+0xac>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:46
  }

	while (*input != '\0')
    a054:	e51b3010 	ldr	r3, [fp, #-16]
    a058:	e5d33000 	ldrb	r3, [r3]
    a05c:	e3530000 	cmp	r3, #0
    a060:	0a000017 	beq	a0c4 <_Z4atoiPKc+0xa8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:48
	{
		output *= 10;
    a064:	e51b2008 	ldr	r2, [fp, #-8]
    a068:	e1a03002 	mov	r3, r2
    a06c:	e1a03103 	lsl	r3, r3, #2
    a070:	e0833002 	add	r3, r3, r2
    a074:	e1a03083 	lsl	r3, r3, #1
    a078:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:49
		if (*input > '9' || *input < '0')
    a07c:	e51b3010 	ldr	r3, [fp, #-16]
    a080:	e5d33000 	ldrb	r3, [r3]
    a084:	e3530039 	cmp	r3, #57	; 0x39
    a088:	8a00000d 	bhi	a0c4 <_Z4atoiPKc+0xa8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:49 (discriminator 1)
    a08c:	e51b3010 	ldr	r3, [fp, #-16]
    a090:	e5d33000 	ldrb	r3, [r3]
    a094:	e353002f 	cmp	r3, #47	; 0x2f
    a098:	9a000009 	bls	a0c4 <_Z4atoiPKc+0xa8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:52
			break;

		output += *input - '0';
    a09c:	e51b3010 	ldr	r3, [fp, #-16]
    a0a0:	e5d33000 	ldrb	r3, [r3]
    a0a4:	e2433030 	sub	r3, r3, #48	; 0x30
    a0a8:	e51b2008 	ldr	r2, [fp, #-8]
    a0ac:	e0823003 	add	r3, r2, r3
    a0b0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:54

		input++;
    a0b4:	e51b3010 	ldr	r3, [fp, #-16]
    a0b8:	e2833001 	add	r3, r3, #1
    a0bc:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:46
	while (*input != '\0')
    a0c0:	eaffffe3 	b	a054 <_Z4atoiPKc+0x38>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:57
	}

	return output;
    a0c4:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:58
}
    a0c8:	e1a00003 	mov	r0, r3
    a0cc:	e24bd004 	sub	sp, fp, #4
    a0d0:	e8bd8800 	pop	{fp, pc}

0000a0d4 <_Z9normalizePf>:
_Z9normalizePf():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:60

int normalize(float *val) {
    a0d4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a0d8:	e28db000 	add	fp, sp, #0
    a0dc:	e24dd014 	sub	sp, sp, #20
    a0e0:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:61
    int exponent = 0;
    a0e4:	e3a03000 	mov	r3, #0
    a0e8:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:62
    float value = *val;
    a0ec:	e51b3010 	ldr	r3, [fp, #-16]
    a0f0:	e5933000 	ldr	r3, [r3]
    a0f4:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:64

    while (value >= 1.0) {
    a0f8:	ed5b7a03 	vldr	s15, [fp, #-12]
    a0fc:	ed9f7a23 	vldr	s14, [pc, #140]	; a190 <_Z9normalizePf+0xbc>
    a100:	eef47ac7 	vcmpe.f32	s15, s14
    a104:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    a108:	aa000000 	bge	a110 <_Z9normalizePf+0x3c>
    a10c:	ea000007 	b	a130 <_Z9normalizePf+0x5c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:65
        value = value / 10.0;
    a110:	ed1b7a03 	vldr	s14, [fp, #-12]
    a114:	eddf6a1e 	vldr	s13, [pc, #120]	; a194 <_Z9normalizePf+0xc0>
    a118:	eec77a26 	vdiv.f32	s15, s14, s13
    a11c:	ed4b7a03 	vstr	s15, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:66
        ++exponent;
    a120:	e51b3008 	ldr	r3, [fp, #-8]
    a124:	e2833001 	add	r3, r3, #1
    a128:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:64
    while (value >= 1.0) {
    a12c:	eafffff1 	b	a0f8 <_Z9normalizePf+0x24>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:69
    }

    while (value < 0.1) {
    a130:	ed5b7a03 	vldr	s15, [fp, #-12]
    a134:	eeb77ae7 	vcvt.f64.f32	d7, s15
    a138:	ed9f6b12 	vldr	d6, [pc, #72]	; a188 <_Z9normalizePf+0xb4>
    a13c:	eeb47bc6 	vcmpe.f64	d7, d6
    a140:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    a144:	5a000007 	bpl	a168 <_Z9normalizePf+0x94>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:70
        value = value * 10.0;
    a148:	ed5b7a03 	vldr	s15, [fp, #-12]
    a14c:	ed9f7a10 	vldr	s14, [pc, #64]	; a194 <_Z9normalizePf+0xc0>
    a150:	ee677a87 	vmul.f32	s15, s15, s14
    a154:	ed4b7a03 	vstr	s15, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:71
        --exponent;
    a158:	e51b3008 	ldr	r3, [fp, #-8]
    a15c:	e2433001 	sub	r3, r3, #1
    a160:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:69
    while (value < 0.1) {
    a164:	eafffff1 	b	a130 <_Z9normalizePf+0x5c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:73
    }
    *val = value;
    a168:	e51b3010 	ldr	r3, [fp, #-16]
    a16c:	e51b200c 	ldr	r2, [fp, #-12]
    a170:	e5832000 	str	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:74
    return exponent;
    a174:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:75
}
    a178:	e1a00003 	mov	r0, r3
    a17c:	e28bd000 	add	sp, fp, #0
    a180:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a184:	e12fff1e 	bx	lr
    a188:	9999999a 	ldmibls	r9, {r1, r3, r4, r7, r8, fp, ip, pc}
    a18c:	3fb99999 	svccc	0x00b99999
    a190:	3f800000 	svccc	0x00800000
    a194:	41200000 			; <UNDEFINED> instruction: 0x41200000

0000a198 <_Z5isnanPKcb>:
_Z5isnanPKcb():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:78

bool isnan(const char *s, bool isFloat) 
{
    a198:	e92d4800 	push	{fp, lr}
    a19c:	e28db004 	add	fp, sp, #4
    a1a0:	e24dd018 	sub	sp, sp, #24
    a1a4:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    a1a8:	e1a03001 	mov	r3, r1
    a1ac:	e54b3019 	strb	r3, [fp, #-25]	; 0xffffffe7
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:79
  int length = strlen(s);
    a1b0:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    a1b4:	eb0001fa 	bl	a9a4 <_Z6strlenPKc>
    a1b8:	e50b000c 	str	r0, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:80
  if (length == 0) {
    a1bc:	e51b300c 	ldr	r3, [fp, #-12]
    a1c0:	e3530000 	cmp	r3, #0
    a1c4:	1a000001 	bne	a1d0 <_Z5isnanPKcb+0x38>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:81
    return true;
    a1c8:	e3a03001 	mov	r3, #1
    a1cc:	ea000025 	b	a268 <_Z5isnanPKcb+0xd0>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:84
  }

	for (int i = 0; i < strlen(s); i++) {
    a1d0:	e3a03000 	mov	r3, #0
    a1d4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:84 (discriminator 1)
    a1d8:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    a1dc:	eb0001f0 	bl	a9a4 <_Z6strlenPKc>
    a1e0:	e1a02000 	mov	r2, r0
    a1e4:	e51b3008 	ldr	r3, [fp, #-8]
    a1e8:	e1530002 	cmp	r3, r2
    a1ec:	b3a03001 	movlt	r3, #1
    a1f0:	a3a03000 	movge	r3, #0
    a1f4:	e6ef3073 	uxtb	r3, r3
    a1f8:	e3530000 	cmp	r3, #0
    a1fc:	0a000018 	beq	a264 <_Z5isnanPKcb+0xcc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:85
		char c = s[i];
    a200:	e51b3008 	ldr	r3, [fp, #-8]
    a204:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    a208:	e0823003 	add	r3, r2, r3
    a20c:	e5d33000 	ldrb	r3, [r3]
    a210:	e54b300d 	strb	r3, [fp, #-13]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:86
		if ((c != 46 || !isFloat) && (c < 48 || c > 57 )) { //Pokud neni tecka (Kdyz kontrolujeme jen float cisla) a zaroven je mimo rozsah cislic, vyhod ze neni number
    a214:	e55b300d 	ldrb	r3, [fp, #-13]
    a218:	e353002e 	cmp	r3, #46	; 0x2e
    a21c:	1a000004 	bne	a234 <_Z5isnanPKcb+0x9c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:86 (discriminator 2)
    a220:	e55b3019 	ldrb	r3, [fp, #-25]	; 0xffffffe7
    a224:	e2233001 	eor	r3, r3, #1
    a228:	e6ef3073 	uxtb	r3, r3
    a22c:	e3530000 	cmp	r3, #0
    a230:	0a000007 	beq	a254 <_Z5isnanPKcb+0xbc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:86 (discriminator 3)
    a234:	e55b300d 	ldrb	r3, [fp, #-13]
    a238:	e353002f 	cmp	r3, #47	; 0x2f
    a23c:	9a000002 	bls	a24c <_Z5isnanPKcb+0xb4>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:86 (discriminator 4)
    a240:	e55b300d 	ldrb	r3, [fp, #-13]
    a244:	e3530039 	cmp	r3, #57	; 0x39
    a248:	9a000001 	bls	a254 <_Z5isnanPKcb+0xbc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:87
			return true;
    a24c:	e3a03001 	mov	r3, #1
    a250:	ea000004 	b	a268 <_Z5isnanPKcb+0xd0>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:84 (discriminator 2)
	for (int i = 0; i < strlen(s); i++) {
    a254:	e51b3008 	ldr	r3, [fp, #-8]
    a258:	e2833001 	add	r3, r3, #1
    a25c:	e50b3008 	str	r3, [fp, #-8]
    a260:	eaffffdc 	b	a1d8 <_Z5isnanPKcb+0x40>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:91
		}
	}

	return false;
    a264:	e3a03000 	mov	r3, #0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:92
}
    a268:	e1a00003 	mov	r0, r3
    a26c:	e24bd004 	sub	sp, fp, #4
    a270:	e8bd8800 	pop	{fp, pc}

0000a274 <_Z4atofPKc>:
_Z4atofPKc():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:95

float atof(const char *s)
{
    a274:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a278:	e28db000 	add	fp, sp, #0
    a27c:	e24dd024 	sub	sp, sp, #36	; 0x24
    a280:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:100
  // This function stolen from either Rolf Neugebauer or Andrew Tolmach. 
  // Probably Rolf.
  // -----------------------------------
  // I stole it from https://github.com/GaloisInc/minlibc/blob/master/atof.c
  float a = 0.0;
    a284:	e3a03000 	mov	r3, #0
    a288:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:101
  int e = 0;
    a28c:	e3a03000 	mov	r3, #0
    a290:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:103
  int c;
  while ((c = *s++) != '\0' && isdigit(c)) {
    a294:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a298:	e2832001 	add	r2, r3, #1
    a29c:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    a2a0:	e5d33000 	ldrb	r3, [r3]
    a2a4:	e50b3010 	str	r3, [fp, #-16]
    a2a8:	e51b3010 	ldr	r3, [fp, #-16]
    a2ac:	e3530000 	cmp	r3, #0
    a2b0:	0a000007 	beq	a2d4 <_Z4atofPKc+0x60>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:103 (discriminator 1)
    a2b4:	e51b3010 	ldr	r3, [fp, #-16]
    a2b8:	e353002f 	cmp	r3, #47	; 0x2f
    a2bc:	da000004 	ble	a2d4 <_Z4atofPKc+0x60>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:103 (discriminator 3)
    a2c0:	e51b3010 	ldr	r3, [fp, #-16]
    a2c4:	e3530039 	cmp	r3, #57	; 0x39
    a2c8:	ca000001 	bgt	a2d4 <_Z4atofPKc+0x60>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:103 (discriminator 5)
    a2cc:	e3a03001 	mov	r3, #1
    a2d0:	ea000000 	b	a2d8 <_Z4atofPKc+0x64>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:103 (discriminator 6)
    a2d4:	e3a03000 	mov	r3, #0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:103 (discriminator 8)
    a2d8:	e3530000 	cmp	r3, #0
    a2dc:	0a00000b 	beq	a310 <_Z4atofPKc+0x9c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:104
    a = a*10.0 + (c - '0');
    a2e0:	ed5b7a02 	vldr	s15, [fp, #-8]
    a2e4:	eeb77ae7 	vcvt.f64.f32	d7, s15
    a2e8:	ed9f6b8a 	vldr	d6, [pc, #552]	; a518 <_Z4atofPKc+0x2a4>
    a2ec:	ee276b06 	vmul.f64	d6, d7, d6
    a2f0:	e51b3010 	ldr	r3, [fp, #-16]
    a2f4:	e2433030 	sub	r3, r3, #48	; 0x30
    a2f8:	ee073a90 	vmov	s15, r3
    a2fc:	eeb87be7 	vcvt.f64.s32	d7, s15
    a300:	ee367b07 	vadd.f64	d7, d6, d7
    a304:	eef77bc7 	vcvt.f32.f64	s15, d7
    a308:	ed4b7a02 	vstr	s15, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:103
  while ((c = *s++) != '\0' && isdigit(c)) {
    a30c:	eaffffe0 	b	a294 <_Z4atofPKc+0x20>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:106
  }
  if (c == '.') {
    a310:	e51b3010 	ldr	r3, [fp, #-16]
    a314:	e353002e 	cmp	r3, #46	; 0x2e
    a318:	1a000021 	bne	a3a4 <_Z4atofPKc+0x130>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:107
    while ((c = *s++) != '\0' && isdigit(c)) {
    a31c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a320:	e2832001 	add	r2, r3, #1
    a324:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    a328:	e5d33000 	ldrb	r3, [r3]
    a32c:	e50b3010 	str	r3, [fp, #-16]
    a330:	e51b3010 	ldr	r3, [fp, #-16]
    a334:	e3530000 	cmp	r3, #0
    a338:	0a000007 	beq	a35c <_Z4atofPKc+0xe8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:107 (discriminator 1)
    a33c:	e51b3010 	ldr	r3, [fp, #-16]
    a340:	e353002f 	cmp	r3, #47	; 0x2f
    a344:	da000004 	ble	a35c <_Z4atofPKc+0xe8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:107 (discriminator 3)
    a348:	e51b3010 	ldr	r3, [fp, #-16]
    a34c:	e3530039 	cmp	r3, #57	; 0x39
    a350:	ca000001 	bgt	a35c <_Z4atofPKc+0xe8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:107 (discriminator 5)
    a354:	e3a03001 	mov	r3, #1
    a358:	ea000000 	b	a360 <_Z4atofPKc+0xec>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:107 (discriminator 6)
    a35c:	e3a03000 	mov	r3, #0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:107 (discriminator 8)
    a360:	e3530000 	cmp	r3, #0
    a364:	0a00000e 	beq	a3a4 <_Z4atofPKc+0x130>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:108
      a = a*10.0 + (c - '0');
    a368:	ed5b7a02 	vldr	s15, [fp, #-8]
    a36c:	eeb77ae7 	vcvt.f64.f32	d7, s15
    a370:	ed9f6b68 	vldr	d6, [pc, #416]	; a518 <_Z4atofPKc+0x2a4>
    a374:	ee276b06 	vmul.f64	d6, d7, d6
    a378:	e51b3010 	ldr	r3, [fp, #-16]
    a37c:	e2433030 	sub	r3, r3, #48	; 0x30
    a380:	ee073a90 	vmov	s15, r3
    a384:	eeb87be7 	vcvt.f64.s32	d7, s15
    a388:	ee367b07 	vadd.f64	d7, d6, d7
    a38c:	eef77bc7 	vcvt.f32.f64	s15, d7
    a390:	ed4b7a02 	vstr	s15, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:109
      e = e-1;
    a394:	e51b300c 	ldr	r3, [fp, #-12]
    a398:	e2433001 	sub	r3, r3, #1
    a39c:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:107
    while ((c = *s++) != '\0' && isdigit(c)) {
    a3a0:	eaffffdd 	b	a31c <_Z4atofPKc+0xa8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:112
    }
  }
  if (c == 'e' || c == 'E') {
    a3a4:	e51b3010 	ldr	r3, [fp, #-16]
    a3a8:	e3530065 	cmp	r3, #101	; 0x65
    a3ac:	0a000002 	beq	a3bc <_Z4atofPKc+0x148>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:112 (discriminator 1)
    a3b0:	e51b3010 	ldr	r3, [fp, #-16]
    a3b4:	e3530045 	cmp	r3, #69	; 0x45
    a3b8:	1a000037 	bne	a49c <_Z4atofPKc+0x228>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:113
    int sign = 1;
    a3bc:	e3a03001 	mov	r3, #1
    a3c0:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:114
    int i = 0;
    a3c4:	e3a03000 	mov	r3, #0
    a3c8:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:115
    c = *s++;
    a3cc:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a3d0:	e2832001 	add	r2, r3, #1
    a3d4:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    a3d8:	e5d33000 	ldrb	r3, [r3]
    a3dc:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:116
    if (c == '+')
    a3e0:	e51b3010 	ldr	r3, [fp, #-16]
    a3e4:	e353002b 	cmp	r3, #43	; 0x2b
    a3e8:	1a000005 	bne	a404 <_Z4atofPKc+0x190>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:117
      c = *s++;
    a3ec:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a3f0:	e2832001 	add	r2, r3, #1
    a3f4:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    a3f8:	e5d33000 	ldrb	r3, [r3]
    a3fc:	e50b3010 	str	r3, [fp, #-16]
    a400:	ea000009 	b	a42c <_Z4atofPKc+0x1b8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:118
    else if (c == '-') {
    a404:	e51b3010 	ldr	r3, [fp, #-16]
    a408:	e353002d 	cmp	r3, #45	; 0x2d
    a40c:	1a000006 	bne	a42c <_Z4atofPKc+0x1b8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:119
      c = *s++;
    a410:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a414:	e2832001 	add	r2, r3, #1
    a418:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    a41c:	e5d33000 	ldrb	r3, [r3]
    a420:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:120
      sign = -1;
    a424:	e3e03000 	mvn	r3, #0
    a428:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:122
    }
    while (isdigit(c)) {
    a42c:	e51b3010 	ldr	r3, [fp, #-16]
    a430:	e353002f 	cmp	r3, #47	; 0x2f
    a434:	da000012 	ble	a484 <_Z4atofPKc+0x210>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:122 (discriminator 1)
    a438:	e51b3010 	ldr	r3, [fp, #-16]
    a43c:	e3530039 	cmp	r3, #57	; 0x39
    a440:	ca00000f 	bgt	a484 <_Z4atofPKc+0x210>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:123
      i = i*10 + (c - '0');
    a444:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    a448:	e1a03002 	mov	r3, r2
    a44c:	e1a03103 	lsl	r3, r3, #2
    a450:	e0833002 	add	r3, r3, r2
    a454:	e1a03083 	lsl	r3, r3, #1
    a458:	e1a02003 	mov	r2, r3
    a45c:	e51b3010 	ldr	r3, [fp, #-16]
    a460:	e2433030 	sub	r3, r3, #48	; 0x30
    a464:	e0823003 	add	r3, r2, r3
    a468:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:124
      c = *s++;
    a46c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a470:	e2832001 	add	r2, r3, #1
    a474:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    a478:	e5d33000 	ldrb	r3, [r3]
    a47c:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:122
    while (isdigit(c)) {
    a480:	eaffffe9 	b	a42c <_Z4atofPKc+0x1b8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:126
    }
    e += i*sign;
    a484:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a488:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    a48c:	e0030392 	mul	r3, r2, r3
    a490:	e51b200c 	ldr	r2, [fp, #-12]
    a494:	e0823003 	add	r3, r2, r3
    a498:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:128
  }
  while (e > 0) {
    a49c:	e51b300c 	ldr	r3, [fp, #-12]
    a4a0:	e3530000 	cmp	r3, #0
    a4a4:	da000007 	ble	a4c8 <_Z4atofPKc+0x254>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:129
    a *= 10.0;
    a4a8:	ed5b7a02 	vldr	s15, [fp, #-8]
    a4ac:	ed9f7a1d 	vldr	s14, [pc, #116]	; a528 <_Z4atofPKc+0x2b4>
    a4b0:	ee677a87 	vmul.f32	s15, s15, s14
    a4b4:	ed4b7a02 	vstr	s15, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:130
    e--;
    a4b8:	e51b300c 	ldr	r3, [fp, #-12]
    a4bc:	e2433001 	sub	r3, r3, #1
    a4c0:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:128
  while (e > 0) {
    a4c4:	eafffff4 	b	a49c <_Z4atofPKc+0x228>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:132
  }
  while (e < 0) {
    a4c8:	e51b300c 	ldr	r3, [fp, #-12]
    a4cc:	e3530000 	cmp	r3, #0
    a4d0:	aa000009 	bge	a4fc <_Z4atofPKc+0x288>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:133
    a *= 0.1;
    a4d4:	ed5b7a02 	vldr	s15, [fp, #-8]
    a4d8:	eeb77ae7 	vcvt.f64.f32	d7, s15
    a4dc:	ed9f6b0f 	vldr	d6, [pc, #60]	; a520 <_Z4atofPKc+0x2ac>
    a4e0:	ee277b06 	vmul.f64	d7, d7, d6
    a4e4:	eef77bc7 	vcvt.f32.f64	s15, d7
    a4e8:	ed4b7a02 	vstr	s15, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:134
    e++;
    a4ec:	e51b300c 	ldr	r3, [fp, #-12]
    a4f0:	e2833001 	add	r3, r3, #1
    a4f4:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:132
  while (e < 0) {
    a4f8:	eafffff2 	b	a4c8 <_Z4atofPKc+0x254>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:136
  }
  return a;
    a4fc:	e51b3008 	ldr	r3, [fp, #-8]
    a500:	ee073a90 	vmov	s15, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:137
}
    a504:	eeb00a67 	vmov.f32	s0, s15
    a508:	e28bd000 	add	sp, fp, #0
    a50c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a510:	e12fff1e 	bx	lr
    a514:	e320f000 	nop	{0}
    a518:	00000000 	andeq	r0, r0, r0
    a51c:	40240000 	eormi	r0, r4, r0
    a520:	9999999a 	ldmibls	r9, {r1, r3, r4, r7, r8, fp, ip, pc}
    a524:	3fb99999 	svccc	0x00b99999
    a528:	41200000 			; <UNDEFINED> instruction: 0x41200000

0000a52c <_Z4ftoaPcf>:
_Z4ftoaPcf():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:139

void ftoa(char *buffer, float value) {  
    a52c:	e92d4800 	push	{fp, lr}
    a530:	e28db004 	add	fp, sp, #4
    a534:	e24dd020 	sub	sp, sp, #32
    a538:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
    a53c:	ed0b0a09 	vstr	s0, [fp, #-36]	; 0xffffffdc
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:148
     * The largest value we expect is an IEEE 754 double precision real, with maximum magnitude of approximately
     * e+308. The C standard requires an implementation to allow a single conversion to produce up to 512 
     * characters, so that's what we really expect as the buffer size.     
     */

    int exponent = 0;
    a540:	e3a03000 	mov	r3, #0
    a544:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:149
    int places = 0;
    a548:	e3a03000 	mov	r3, #0
    a54c:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:150
    const int width = 6;
    a550:	e3a03006 	mov	r3, #6
    a554:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:152

    if (value == 0.0) {
    a558:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    a55c:	eef57a40 	vcmp.f32	s15, #0.0
    a560:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    a564:	1a000007 	bne	a588 <_Z4ftoaPcf+0x5c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:153
        buffer[0] = '0';
    a568:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a56c:	e3a02030 	mov	r2, #48	; 0x30
    a570:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:154
        buffer[1] = '\0';
    a574:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a578:	e2833001 	add	r3, r3, #1
    a57c:	e3a02000 	mov	r2, #0
    a580:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:155
        return;
    a584:	ea000071 	b	a750 <_Z4ftoaPcf+0x224>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:158
    } 

    if (value < 0.0) {
    a588:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    a58c:	eef57ac0 	vcmpe.f32	s15, #0.0
    a590:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    a594:	5a000007 	bpl	a5b8 <_Z4ftoaPcf+0x8c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:159
        *buffer++ = '-';
    a598:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a59c:	e2832001 	add	r2, r3, #1
    a5a0:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    a5a4:	e3a0202d 	mov	r2, #45	; 0x2d
    a5a8:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:160
        value = -value;
    a5ac:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    a5b0:	eef17a67 	vneg.f32	s15, s15
    a5b4:	ed4b7a09 	vstr	s15, [fp, #-36]	; 0xffffffdc
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:163
    }

    exponent = normalize(&value);
    a5b8:	e24b3024 	sub	r3, fp, #36	; 0x24
    a5bc:	e1a00003 	mov	r0, r3
    a5c0:	ebfffec3 	bl	a0d4 <_Z9normalizePf>
    a5c4:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:165

    while (exponent > 0) {
    a5c8:	e51b3008 	ldr	r3, [fp, #-8]
    a5cc:	e3530000 	cmp	r3, #0
    a5d0:	da00001c 	ble	a648 <_Z4ftoaPcf+0x11c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:166
        int digit = value * 10;
    a5d4:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    a5d8:	ed9f7a60 	vldr	s14, [pc, #384]	; a760 <_Z4ftoaPcf+0x234>
    a5dc:	ee677a87 	vmul.f32	s15, s15, s14
    a5e0:	eefd7ae7 	vcvt.s32.f32	s15, s15
    a5e4:	ee173a90 	vmov	r3, s15
    a5e8:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:167
        *buffer++ = digit + '0';
    a5ec:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a5f0:	e6ef2073 	uxtb	r2, r3
    a5f4:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a5f8:	e2831001 	add	r1, r3, #1
    a5fc:	e50b1020 	str	r1, [fp, #-32]	; 0xffffffe0
    a600:	e2822030 	add	r2, r2, #48	; 0x30
    a604:	e6ef2072 	uxtb	r2, r2
    a608:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:168
        value = value * 10 - digit;
    a60c:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    a610:	ed9f7a52 	vldr	s14, [pc, #328]	; a760 <_Z4ftoaPcf+0x234>
    a614:	ee277a87 	vmul.f32	s14, s15, s14
    a618:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a61c:	ee073a90 	vmov	s15, r3
    a620:	eef87ae7 	vcvt.f32.s32	s15, s15
    a624:	ee777a67 	vsub.f32	s15, s14, s15
    a628:	ed4b7a09 	vstr	s15, [fp, #-36]	; 0xffffffdc
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:169
        ++places;
    a62c:	e51b300c 	ldr	r3, [fp, #-12]
    a630:	e2833001 	add	r3, r3, #1
    a634:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:170
        --exponent;
    a638:	e51b3008 	ldr	r3, [fp, #-8]
    a63c:	e2433001 	sub	r3, r3, #1
    a640:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:165
    while (exponent > 0) {
    a644:	eaffffdf 	b	a5c8 <_Z4ftoaPcf+0x9c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:173
    }

    if (places == 0)
    a648:	e51b300c 	ldr	r3, [fp, #-12]
    a64c:	e3530000 	cmp	r3, #0
    a650:	1a000004 	bne	a668 <_Z4ftoaPcf+0x13c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:174
        *buffer++ = '0';
    a654:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a658:	e2832001 	add	r2, r3, #1
    a65c:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    a660:	e3a02030 	mov	r2, #48	; 0x30
    a664:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:176

    *buffer++ = '.';
    a668:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a66c:	e2832001 	add	r2, r3, #1
    a670:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    a674:	e3a0202e 	mov	r2, #46	; 0x2e
    a678:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:178

    while (exponent < 0 && places < width) {
    a67c:	e51b3008 	ldr	r3, [fp, #-8]
    a680:	e3530000 	cmp	r3, #0
    a684:	aa00000e 	bge	a6c4 <_Z4ftoaPcf+0x198>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:178 (discriminator 1)
    a688:	e51b300c 	ldr	r3, [fp, #-12]
    a68c:	e3530005 	cmp	r3, #5
    a690:	ca00000b 	bgt	a6c4 <_Z4ftoaPcf+0x198>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:179
        *buffer++ = '0';
    a694:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a698:	e2832001 	add	r2, r3, #1
    a69c:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    a6a0:	e3a02030 	mov	r2, #48	; 0x30
    a6a4:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:180
        --exponent;
    a6a8:	e51b3008 	ldr	r3, [fp, #-8]
    a6ac:	e2433001 	sub	r3, r3, #1
    a6b0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:181
        ++places;
    a6b4:	e51b300c 	ldr	r3, [fp, #-12]
    a6b8:	e2833001 	add	r3, r3, #1
    a6bc:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:178
    while (exponent < 0 && places < width) {
    a6c0:	eaffffed 	b	a67c <_Z4ftoaPcf+0x150>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:184
    }

    while (places < width) {
    a6c4:	e51b300c 	ldr	r3, [fp, #-12]
    a6c8:	e3530005 	cmp	r3, #5
    a6cc:	ca00001c 	bgt	a744 <_Z4ftoaPcf+0x218>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:185
        int digit = value * 10.0;
    a6d0:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    a6d4:	eeb77ae7 	vcvt.f64.f32	d7, s15
    a6d8:	ed9f6b1e 	vldr	d6, [pc, #120]	; a758 <_Z4ftoaPcf+0x22c>
    a6dc:	ee277b06 	vmul.f64	d7, d7, d6
    a6e0:	eefd7bc7 	vcvt.s32.f64	s15, d7
    a6e4:	ee173a90 	vmov	r3, s15
    a6e8:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:186
        *buffer++ = digit + '0';
    a6ec:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a6f0:	e6ef2073 	uxtb	r2, r3
    a6f4:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a6f8:	e2831001 	add	r1, r3, #1
    a6fc:	e50b1020 	str	r1, [fp, #-32]	; 0xffffffe0
    a700:	e2822030 	add	r2, r2, #48	; 0x30
    a704:	e6ef2072 	uxtb	r2, r2
    a708:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:187
        value = value * 10.0 - digit;
    a70c:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    a710:	eeb77ae7 	vcvt.f64.f32	d7, s15
    a714:	ed9f6b0f 	vldr	d6, [pc, #60]	; a758 <_Z4ftoaPcf+0x22c>
    a718:	ee276b06 	vmul.f64	d6, d7, d6
    a71c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a720:	ee073a90 	vmov	s15, r3
    a724:	eeb87be7 	vcvt.f64.s32	d7, s15
    a728:	ee367b47 	vsub.f64	d7, d6, d7
    a72c:	eef77bc7 	vcvt.f32.f64	s15, d7
    a730:	ed4b7a09 	vstr	s15, [fp, #-36]	; 0xffffffdc
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:188
        ++places;
    a734:	e51b300c 	ldr	r3, [fp, #-12]
    a738:	e2833001 	add	r3, r3, #1
    a73c:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:184
    while (places < width) {
    a740:	eaffffdf 	b	a6c4 <_Z4ftoaPcf+0x198>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:190
    }
    *buffer = '\0';
    a744:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a748:	e3a02000 	mov	r2, #0
    a74c:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:191
}
    a750:	e24bd004 	sub	sp, fp, #4
    a754:	e8bd8800 	pop	{fp, pc}
    a758:	00000000 	andeq	r0, r0, r0
    a75c:	40240000 	eormi	r0, r4, r0
    a760:	41200000 			; <UNDEFINED> instruction: 0x41200000

0000a764 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:194

char* strncpy(char* dest, const char *src, int num)
{
    a764:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a768:	e28db000 	add	fp, sp, #0
    a76c:	e24dd01c 	sub	sp, sp, #28
    a770:	e50b0010 	str	r0, [fp, #-16]
    a774:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    a778:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:197
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
    a77c:	e3a03000 	mov	r3, #0
    a780:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:197 (discriminator 4)
    a784:	e51b2008 	ldr	r2, [fp, #-8]
    a788:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a78c:	e1520003 	cmp	r2, r3
    a790:	aa000011 	bge	a7dc <_Z7strncpyPcPKci+0x78>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:197 (discriminator 2)
    a794:	e51b3008 	ldr	r3, [fp, #-8]
    a798:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    a79c:	e0823003 	add	r3, r2, r3
    a7a0:	e5d33000 	ldrb	r3, [r3]
    a7a4:	e3530000 	cmp	r3, #0
    a7a8:	0a00000b 	beq	a7dc <_Z7strncpyPcPKci+0x78>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:198 (discriminator 3)
		dest[i] = src[i];
    a7ac:	e51b3008 	ldr	r3, [fp, #-8]
    a7b0:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    a7b4:	e0822003 	add	r2, r2, r3
    a7b8:	e51b3008 	ldr	r3, [fp, #-8]
    a7bc:	e51b1010 	ldr	r1, [fp, #-16]
    a7c0:	e0813003 	add	r3, r1, r3
    a7c4:	e5d22000 	ldrb	r2, [r2]
    a7c8:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:197 (discriminator 3)
	for (i = 0; i < num && src[i] != '\0'; i++)
    a7cc:	e51b3008 	ldr	r3, [fp, #-8]
    a7d0:	e2833001 	add	r3, r3, #1
    a7d4:	e50b3008 	str	r3, [fp, #-8]
    a7d8:	eaffffe9 	b	a784 <_Z7strncpyPcPKci+0x20>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:199 (discriminator 2)
	for (; i < num; i++)
    a7dc:	e51b2008 	ldr	r2, [fp, #-8]
    a7e0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a7e4:	e1520003 	cmp	r2, r3
    a7e8:	aa000008 	bge	a810 <_Z7strncpyPcPKci+0xac>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:200 (discriminator 1)
		dest[i] = '\0';
    a7ec:	e51b3008 	ldr	r3, [fp, #-8]
    a7f0:	e51b2010 	ldr	r2, [fp, #-16]
    a7f4:	e0823003 	add	r3, r2, r3
    a7f8:	e3a02000 	mov	r2, #0
    a7fc:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:199 (discriminator 1)
	for (; i < num; i++)
    a800:	e51b3008 	ldr	r3, [fp, #-8]
    a804:	e2833001 	add	r3, r3, #1
    a808:	e50b3008 	str	r3, [fp, #-8]
    a80c:	eafffff2 	b	a7dc <_Z7strncpyPcPKci+0x78>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:202

   return dest;
    a810:	e51b3010 	ldr	r3, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:203
}
    a814:	e1a00003 	mov	r0, r3
    a818:	e28bd000 	add	sp, fp, #0
    a81c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a820:	e12fff1e 	bx	lr

0000a824 <_Z6strcatPcPKc>:
_Z6strcatPcPKc():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:206

char* strcat(char *dest, const char *src)
{
    a824:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a828:	e28db000 	add	fp, sp, #0
    a82c:	e24dd014 	sub	sp, sp, #20
    a830:	e50b0010 	str	r0, [fp, #-16]
    a834:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:209
    int i,j;

    for (i = 0; dest[i] != '\0'; i++)
    a838:	e3a03000 	mov	r3, #0
    a83c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:209 (discriminator 3)
    a840:	e51b3008 	ldr	r3, [fp, #-8]
    a844:	e51b2010 	ldr	r2, [fp, #-16]
    a848:	e0823003 	add	r3, r2, r3
    a84c:	e5d33000 	ldrb	r3, [r3]
    a850:	e3530000 	cmp	r3, #0
    a854:	0a000003 	beq	a868 <_Z6strcatPcPKc+0x44>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:209 (discriminator 2)
    a858:	e51b3008 	ldr	r3, [fp, #-8]
    a85c:	e2833001 	add	r3, r3, #1
    a860:	e50b3008 	str	r3, [fp, #-8]
    a864:	eafffff5 	b	a840 <_Z6strcatPcPKc+0x1c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:211
        ;
    for (j = 0; src[j] != '\0'; j++)
    a868:	e3a03000 	mov	r3, #0
    a86c:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:211 (discriminator 3)
    a870:	e51b300c 	ldr	r3, [fp, #-12]
    a874:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    a878:	e0823003 	add	r3, r2, r3
    a87c:	e5d33000 	ldrb	r3, [r3]
    a880:	e3530000 	cmp	r3, #0
    a884:	0a00000e 	beq	a8c4 <_Z6strcatPcPKc+0xa0>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:212 (discriminator 2)
        dest[i+j] = src[j];
    a888:	e51b300c 	ldr	r3, [fp, #-12]
    a88c:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    a890:	e0822003 	add	r2, r2, r3
    a894:	e51b1008 	ldr	r1, [fp, #-8]
    a898:	e51b300c 	ldr	r3, [fp, #-12]
    a89c:	e0813003 	add	r3, r1, r3
    a8a0:	e1a01003 	mov	r1, r3
    a8a4:	e51b3010 	ldr	r3, [fp, #-16]
    a8a8:	e0833001 	add	r3, r3, r1
    a8ac:	e5d22000 	ldrb	r2, [r2]
    a8b0:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:211 (discriminator 2)
    for (j = 0; src[j] != '\0'; j++)
    a8b4:	e51b300c 	ldr	r3, [fp, #-12]
    a8b8:	e2833001 	add	r3, r3, #1
    a8bc:	e50b300c 	str	r3, [fp, #-12]
    a8c0:	eaffffea 	b	a870 <_Z6strcatPcPKc+0x4c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:214

    dest[i+j] = '\0';
    a8c4:	e51b2008 	ldr	r2, [fp, #-8]
    a8c8:	e51b300c 	ldr	r3, [fp, #-12]
    a8cc:	e0823003 	add	r3, r2, r3
    a8d0:	e1a02003 	mov	r2, r3
    a8d4:	e51b3010 	ldr	r3, [fp, #-16]
    a8d8:	e0833002 	add	r3, r3, r2
    a8dc:	e3a02000 	mov	r2, #0
    a8e0:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:216
	
    return dest;
    a8e4:	e51b3010 	ldr	r3, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:217
}
    a8e8:	e1a00003 	mov	r0, r3
    a8ec:	e28bd000 	add	sp, fp, #0
    a8f0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a8f4:	e12fff1e 	bx	lr

0000a8f8 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:220

int strncmp(const char *s1, const char *s2, int num)
{
    a8f8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a8fc:	e28db000 	add	fp, sp, #0
    a900:	e24dd01c 	sub	sp, sp, #28
    a904:	e50b0010 	str	r0, [fp, #-16]
    a908:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    a90c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:222
	unsigned char u1, u2;
  	while (num-- > 0)
    a910:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a914:	e2432001 	sub	r2, r3, #1
    a918:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    a91c:	e3530000 	cmp	r3, #0
    a920:	c3a03001 	movgt	r3, #1
    a924:	d3a03000 	movle	r3, #0
    a928:	e6ef3073 	uxtb	r3, r3
    a92c:	e3530000 	cmp	r3, #0
    a930:	0a000016 	beq	a990 <_Z7strncmpPKcS0_i+0x98>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:224
    {
      	u1 = (unsigned char) *s1++;
    a934:	e51b3010 	ldr	r3, [fp, #-16]
    a938:	e2832001 	add	r2, r3, #1
    a93c:	e50b2010 	str	r2, [fp, #-16]
    a940:	e5d33000 	ldrb	r3, [r3]
    a944:	e54b3005 	strb	r3, [fp, #-5]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:225
     	u2 = (unsigned char) *s2++;
    a948:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a94c:	e2832001 	add	r2, r3, #1
    a950:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    a954:	e5d33000 	ldrb	r3, [r3]
    a958:	e54b3006 	strb	r3, [fp, #-6]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:226
      	if (u1 != u2)
    a95c:	e55b2005 	ldrb	r2, [fp, #-5]
    a960:	e55b3006 	ldrb	r3, [fp, #-6]
    a964:	e1520003 	cmp	r2, r3
    a968:	0a000003 	beq	a97c <_Z7strncmpPKcS0_i+0x84>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:227
        	return u1 - u2;
    a96c:	e55b2005 	ldrb	r2, [fp, #-5]
    a970:	e55b3006 	ldrb	r3, [fp, #-6]
    a974:	e0423003 	sub	r3, r2, r3
    a978:	ea000005 	b	a994 <_Z7strncmpPKcS0_i+0x9c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:228
      	if (u1 == '\0')
    a97c:	e55b3005 	ldrb	r3, [fp, #-5]
    a980:	e3530000 	cmp	r3, #0
    a984:	1affffe1 	bne	a910 <_Z7strncmpPKcS0_i+0x18>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:229
        	return 0;
    a988:	e3a03000 	mov	r3, #0
    a98c:	ea000000 	b	a994 <_Z7strncmpPKcS0_i+0x9c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:232
    }

  	return 0;
    a990:	e3a03000 	mov	r3, #0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:233
}
    a994:	e1a00003 	mov	r0, r3
    a998:	e28bd000 	add	sp, fp, #0
    a99c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a9a0:	e12fff1e 	bx	lr

0000a9a4 <_Z6strlenPKc>:
_Z6strlenPKc():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:236

int strlen(const char* s)
{
    a9a4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a9a8:	e28db000 	add	fp, sp, #0
    a9ac:	e24dd014 	sub	sp, sp, #20
    a9b0:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:237
	int i = 0;
    a9b4:	e3a03000 	mov	r3, #0
    a9b8:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:239

	while (s[i] != '\0')
    a9bc:	e51b3008 	ldr	r3, [fp, #-8]
    a9c0:	e51b2010 	ldr	r2, [fp, #-16]
    a9c4:	e0823003 	add	r3, r2, r3
    a9c8:	e5d33000 	ldrb	r3, [r3]
    a9cc:	e3530000 	cmp	r3, #0
    a9d0:	0a000003 	beq	a9e4 <_Z6strlenPKc+0x40>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:240
		i++;
    a9d4:	e51b3008 	ldr	r3, [fp, #-8]
    a9d8:	e2833001 	add	r3, r3, #1
    a9dc:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:239
	while (s[i] != '\0')
    a9e0:	eafffff5 	b	a9bc <_Z6strlenPKc+0x18>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:242

	return i;
    a9e4:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:243
}
    a9e8:	e1a00003 	mov	r0, r3
    a9ec:	e28bd000 	add	sp, fp, #0
    a9f0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a9f4:	e12fff1e 	bx	lr

0000a9f8 <_Z5bzeroPvi>:
_Z5bzeroPvi():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:246

void bzero(void* memory, int length)
{
    a9f8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a9fc:	e28db000 	add	fp, sp, #0
    aa00:	e24dd014 	sub	sp, sp, #20
    aa04:	e50b0010 	str	r0, [fp, #-16]
    aa08:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:247
	char* mem = reinterpret_cast<char*>(memory);
    aa0c:	e51b3010 	ldr	r3, [fp, #-16]
    aa10:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:249

	for (int i = 0; i < length; i++)
    aa14:	e3a03000 	mov	r3, #0
    aa18:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:249 (discriminator 3)
    aa1c:	e51b2008 	ldr	r2, [fp, #-8]
    aa20:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    aa24:	e1520003 	cmp	r2, r3
    aa28:	aa000008 	bge	aa50 <_Z5bzeroPvi+0x58>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:250 (discriminator 2)
		mem[i] = 0;
    aa2c:	e51b3008 	ldr	r3, [fp, #-8]
    aa30:	e51b200c 	ldr	r2, [fp, #-12]
    aa34:	e0823003 	add	r3, r2, r3
    aa38:	e3a02000 	mov	r2, #0
    aa3c:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:249 (discriminator 2)
	for (int i = 0; i < length; i++)
    aa40:	e51b3008 	ldr	r3, [fp, #-8]
    aa44:	e2833001 	add	r3, r3, #1
    aa48:	e50b3008 	str	r3, [fp, #-8]
    aa4c:	eafffff2 	b	aa1c <_Z5bzeroPvi+0x24>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:251
}
    aa50:	e320f000 	nop	{0}
    aa54:	e28bd000 	add	sp, fp, #0
    aa58:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    aa5c:	e12fff1e 	bx	lr

0000aa60 <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:254

void memcpy(const void* src, void* dst, int num)
{
    aa60:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    aa64:	e28db000 	add	fp, sp, #0
    aa68:	e24dd024 	sub	sp, sp, #36	; 0x24
    aa6c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    aa70:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    aa74:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:255
	const char* memsrc = reinterpret_cast<const char*>(src);
    aa78:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    aa7c:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:256
	char* memdst = reinterpret_cast<char*>(dst);
    aa80:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    aa84:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:258

	for (int i = 0; i < num; i++)
    aa88:	e3a03000 	mov	r3, #0
    aa8c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:258 (discriminator 3)
    aa90:	e51b2008 	ldr	r2, [fp, #-8]
    aa94:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    aa98:	e1520003 	cmp	r2, r3
    aa9c:	aa00000b 	bge	aad0 <_Z6memcpyPKvPvi+0x70>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:259 (discriminator 2)
		memdst[i] = memsrc[i];
    aaa0:	e51b3008 	ldr	r3, [fp, #-8]
    aaa4:	e51b200c 	ldr	r2, [fp, #-12]
    aaa8:	e0822003 	add	r2, r2, r3
    aaac:	e51b3008 	ldr	r3, [fp, #-8]
    aab0:	e51b1010 	ldr	r1, [fp, #-16]
    aab4:	e0813003 	add	r3, r1, r3
    aab8:	e5d22000 	ldrb	r2, [r2]
    aabc:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:258 (discriminator 2)
	for (int i = 0; i < num; i++)
    aac0:	e51b3008 	ldr	r3, [fp, #-8]
    aac4:	e2833001 	add	r3, r3, #1
    aac8:	e50b3008 	str	r3, [fp, #-8]
    aacc:	eaffffef 	b	aa90 <_Z6memcpyPKvPvi+0x30>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:260
}
    aad0:	e320f000 	nop	{0}
    aad4:	e28bd000 	add	sp, fp, #0
    aad8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    aadc:	e12fff1e 	bx	lr

0000aae0 <_ZN10Read_UtilsC1Ev>:
_ZN10Read_UtilsC2Ev():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/read_utils.cpp:5
#include <read_utils.h>
#include <stdfile.h>
#include <stdstring.h>

Read_Utils::Read_Utils() {
    aae0:	e92d4800 	push	{fp, lr}
    aae4:	e28db004 	add	fp, sp, #4
    aae8:	e24dd008 	sub	sp, sp, #8
    aaec:	e50b0008 	str	r0, [fp, #-8]
    aaf0:	e51b3008 	ldr	r3, [fp, #-8]
    aaf4:	e1a00003 	mov	r0, r3
    aaf8:	eb0000b7 	bl	addc <_ZN15Circular_BufferC1Ev>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/read_utils.cpp:7
    // Prazdny konstruktor
};
    aafc:	e51b3008 	ldr	r3, [fp, #-8]
    ab00:	e1a00003 	mov	r0, r3
    ab04:	e24bd004 	sub	sp, fp, #4
    ab08:	e8bd8800 	pop	{fp, pc}

0000ab0c <_ZN10Read_Utils9read_lineEPcjb>:
_ZN10Read_Utils9read_lineEPcjb():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/read_utils.cpp:9

uint32_t Read_Utils::read_line(char * returnBuffer, uint32_t file, bool blocking) {
    ab0c:	e92d4800 	push	{fp, lr}
    ab10:	e28db004 	add	fp, sp, #4
    ab14:	e24dd0a0 	sub	sp, sp, #160	; 0xa0
    ab18:	e50b0098 	str	r0, [fp, #-152]	; 0xffffff68
    ab1c:	e50b109c 	str	r1, [fp, #-156]	; 0xffffff64
    ab20:	e50b20a0 	str	r2, [fp, #-160]	; 0xffffff60
    ab24:	e54b30a1 	strb	r3, [fp, #-161]	; 0xffffff5f
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/read_utils.cpp:11
    char readBuffer[128];
	bzero(readBuffer, 128);
    ab28:	e24b3090 	sub	r3, fp, #144	; 0x90
    ab2c:	e3a01080 	mov	r1, #128	; 0x80
    ab30:	e1a00003 	mov	r0, r3
    ab34:	ebffffaf 	bl	a9f8 <_Z5bzeroPvi>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/read_utils.cpp:12
	uint32_t readChars = 0;
    ab38:	e3a03000 	mov	r3, #0
    ab3c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/read_utils.cpp:16

    //Read from UART if data are available.
	do {
		if (blocking == true) {	//If we want to block the process, we just wait until we receive something from  UART
    ab40:	e55b30a1 	ldrb	r3, [fp, #-161]	; 0xffffff5f
    ab44:	e3530001 	cmp	r3, #1
    ab48:	1a000003 	bne	ab5c <_ZN10Read_Utils9read_lineEPcjb+0x50>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/read_utils.cpp:17
			wait(file, 0x1000, Indefinite);
    ab4c:	e3e02000 	mvn	r2, #0
    ab50:	e3a01a01 	mov	r1, #4096	; 0x1000
    ab54:	e51b00a0 	ldr	r0, [fp, #-160]	; 0xffffff60
    ab58:	ebfffc33 	bl	9c2c <_Z4waitjjj>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/read_utils.cpp:20
		}

		uint32_t len = read(file, readBuffer, 128);
    ab5c:	e24b3090 	sub	r3, fp, #144	; 0x90
    ab60:	e3a02080 	mov	r2, #128	; 0x80
    ab64:	e1a01003 	mov	r1, r3
    ab68:	e51b00a0 	ldr	r0, [fp, #-160]	; 0xffffff60
    ab6c:	ebfffbd6 	bl	9acc <_Z4readjPcj>
    ab70:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/read_utils.cpp:21
		if (len != 0) {
    ab74:	e51b3010 	ldr	r3, [fp, #-16]
    ab78:	e3530000 	cmp	r3, #0
    ab7c:	0a00003d 	beq	ac78 <_ZN10Read_Utils9read_lineEPcjb+0x16c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/read_utils.cpp:28
			//Write into it's own circular buffer holding previous values.
			//This is used for example if user pastes two lines, we don't want to scrap the result.
			//Other scenario might be that user might enter for example only two characters without pressing \n - We still 
			//Want to save the results and return them on next read_line call.
			
			circular_buffer.write(readBuffer, len);
    ab80:	e51b3098 	ldr	r3, [fp, #-152]	; 0xffffff68
    ab84:	e24b1090 	sub	r1, fp, #144	; 0x90
    ab88:	e51b2010 	ldr	r2, [fp, #-16]
    ab8c:	e1a00003 	mov	r0, r3
    ab90:	eb00012f 	bl	b054 <_ZN15Circular_Buffer5writeEPcj>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/read_utils.cpp:29
			readChars = circular_buffer.read_until('\n', returnBuffer);
    ab94:	e51b3098 	ldr	r3, [fp, #-152]	; 0xffffff68
    ab98:	e51b209c 	ldr	r2, [fp, #-156]	; 0xffffff64
    ab9c:	e3a0100a 	mov	r1, #10
    aba0:	e1a00003 	mov	r0, r3
    aba4:	eb0000f6 	bl	af84 <_ZN15Circular_Buffer10read_untilEcPc>
    aba8:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/read_utils.cpp:36
			//Workaround for QEMU since it only sends \r, not \n - we replace the last read char with \n - in production we still should get \r\n
			//but in QEMU, we replace the last \r with \n, thus going on new line, not only returning to the beggining of the line. If we get \n (Linux style)
			//We still should end up with only \n in the end. Possible values are then \r\n and \n.
			//
			//We also send the new line character to the UART, so we end up on correct line. In rare occassions this might cause sending two newlines.
			if (readChars == 0) {
    abac:	e51b3008 	ldr	r3, [fp, #-8]
    abb0:	e3530000 	cmp	r3, #0
    abb4:	1a000012 	bne	ac04 <_ZN10Read_Utils9read_lineEPcjb+0xf8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/read_utils.cpp:37
				readChars = circular_buffer.read_until('\r', returnBuffer);
    abb8:	e51b3098 	ldr	r3, [fp, #-152]	; 0xffffff68
    abbc:	e51b209c 	ldr	r2, [fp, #-156]	; 0xffffff64
    abc0:	e3a0100d 	mov	r1, #13
    abc4:	e1a00003 	mov	r0, r3
    abc8:	eb0000ed 	bl	af84 <_ZN15Circular_Buffer10read_untilEcPc>
    abcc:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/read_utils.cpp:39

				if (readChars != 0) {
    abd0:	e51b3008 	ldr	r3, [fp, #-8]
    abd4:	e3530000 	cmp	r3, #0
    abd8:	0a000009 	beq	ac04 <_ZN10Read_Utils9read_lineEPcjb+0xf8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/read_utils.cpp:40
					write(file, "\n", 1);
    abdc:	e3a02001 	mov	r2, #1
    abe0:	e59f10bc 	ldr	r1, [pc, #188]	; aca4 <_ZN10Read_Utils9read_lineEPcjb+0x198>
    abe4:	e51b00a0 	ldr	r0, [fp, #-160]	; 0xffffff60
    abe8:	ebfffbcb 	bl	9b1c <_Z5writejPKcj>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/read_utils.cpp:41
					returnBuffer[readChars - 1] = '\n';
    abec:	e51b3008 	ldr	r3, [fp, #-8]
    abf0:	e2433001 	sub	r3, r3, #1
    abf4:	e51b209c 	ldr	r2, [fp, #-156]	; 0xffffff64
    abf8:	e0823003 	add	r3, r2, r3
    abfc:	e3a0200a 	mov	r2, #10
    ac00:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/read_utils.cpp:46
				}
			}

			//Remove newLine and carriage return characters from the end of the string.
			for (int i = readChars - 1; i >= 0; i--) {
    ac04:	e51b3008 	ldr	r3, [fp, #-8]
    ac08:	e2433001 	sub	r3, r3, #1
    ac0c:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/read_utils.cpp:46 (discriminator 1)
    ac10:	e51b300c 	ldr	r3, [fp, #-12]
    ac14:	e3530000 	cmp	r3, #0
    ac18:	ba000016 	blt	ac78 <_ZN10Read_Utils9read_lineEPcjb+0x16c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/read_utils.cpp:47
				if (returnBuffer[i] == '\r' || returnBuffer[i] == '\n') {
    ac1c:	e51b300c 	ldr	r3, [fp, #-12]
    ac20:	e51b209c 	ldr	r2, [fp, #-156]	; 0xffffff64
    ac24:	e0823003 	add	r3, r2, r3
    ac28:	e5d33000 	ldrb	r3, [r3]
    ac2c:	e353000d 	cmp	r3, #13
    ac30:	0a000005 	beq	ac4c <_ZN10Read_Utils9read_lineEPcjb+0x140>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/read_utils.cpp:47 (discriminator 2)
    ac34:	e51b300c 	ldr	r3, [fp, #-12]
    ac38:	e51b209c 	ldr	r2, [fp, #-156]	; 0xffffff64
    ac3c:	e0823003 	add	r3, r2, r3
    ac40:	e5d33000 	ldrb	r3, [r3]
    ac44:	e353000a 	cmp	r3, #10
    ac48:	1a000009 	bne	ac74 <_ZN10Read_Utils9read_lineEPcjb+0x168>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/read_utils.cpp:48 (discriminator 3)
					returnBuffer[i] = '\0';
    ac4c:	e51b300c 	ldr	r3, [fp, #-12]
    ac50:	e51b209c 	ldr	r2, [fp, #-156]	; 0xffffff64
    ac54:	e0823003 	add	r3, r2, r3
    ac58:	e3a02000 	mov	r2, #0
    ac5c:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/read_utils.cpp:49 (discriminator 3)
					continue; //Replace and continue to another character 
    ac60:	e320f000 	nop	{0}
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/read_utils.cpp:46 (discriminator 3)
			for (int i = readChars - 1; i >= 0; i--) {
    ac64:	e51b300c 	ldr	r3, [fp, #-12]
    ac68:	e2433001 	sub	r3, r3, #1
    ac6c:	e50b300c 	str	r3, [fp, #-12]
    ac70:	eaffffe6 	b	ac10 <_ZN10Read_Utils9read_lineEPcjb+0x104>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/read_utils.cpp:52
				}

				break; //There was no newline, we suspect that there is alphanumeric characters and no new line char will be present, so we can stop the search.
    ac74:	e320f000 	nop	{0}
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/read_utils.cpp:55
			}
		}
	} while (readChars == 0 && blocking == true);
    ac78:	e51b3008 	ldr	r3, [fp, #-8]
    ac7c:	e3530000 	cmp	r3, #0
    ac80:	1a000003 	bne	ac94 <_ZN10Read_Utils9read_lineEPcjb+0x188>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/read_utils.cpp:55 (discriminator 1)
    ac84:	e55b30a1 	ldrb	r3, [fp, #-161]	; 0xffffff5f
    ac88:	e3530001 	cmp	r3, #1
    ac8c:	1a000000 	bne	ac94 <_ZN10Read_Utils9read_lineEPcjb+0x188>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/read_utils.cpp:15
	do {
    ac90:	eaffffaa 	b	ab40 <_ZN10Read_Utils9read_lineEPcjb+0x34>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/read_utils.cpp:57
	
    return readChars;
    ac94:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/read_utils.cpp:58
}
    ac98:	e1a00003 	mov	r0, r3
    ac9c:	e24bd004 	sub	sp, fp, #4
    aca0:	e8bd8800 	pop	{fp, pc}
    aca4:	0000b6b0 			; <UNDEFINED> instruction: 0x0000b6b0

0000aca8 <_ZN13Rnd_Generator12generate_intEii>:
_ZN13Rnd_Generator12generate_intEii():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/rnd_generator.cpp:6
#include <rnd_generator.h>
#include <stdfile.h>

Rnd_Generator rnd;

int Rnd_Generator::generate_int(int32_t low, int32_t high) {
    aca8:	e92d4800 	push	{fp, lr}
    acac:	e28db004 	add	fp, sp, #4
    acb0:	e24dd010 	sub	sp, sp, #16
    acb4:	e50b0008 	str	r0, [fp, #-8]
    acb8:	e50b100c 	str	r1, [fp, #-12]
    acbc:	e50b2010 	str	r2, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/rnd_generator.cpp:7
	return generate(low, high + 1); //Add 1 to high since it wouldn't be able to get to this value if we trim the decimal part
    acc0:	e51b3010 	ldr	r3, [fp, #-16]
    acc4:	e2833001 	add	r3, r3, #1
    acc8:	e1a02003 	mov	r2, r3
    accc:	e51b100c 	ldr	r1, [fp, #-12]
    acd0:	e51b0008 	ldr	r0, [fp, #-8]
    acd4:	eb000005 	bl	acf0 <_ZN13Rnd_Generator8generateEii>
    acd8:	eef07a40 	vmov.f32	s15, s0
    acdc:	eefd7ae7 	vcvt.s32.f32	s15, s15
    ace0:	ee173a90 	vmov	r3, s15
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/rnd_generator.cpp:8
}
    ace4:	e1a00003 	mov	r0, r3
    ace8:	e24bd004 	sub	sp, fp, #4
    acec:	e8bd8800 	pop	{fp, pc}

0000acf0 <_ZN13Rnd_Generator8generateEii>:
_ZN13Rnd_Generator8generateEii():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/rnd_generator.cpp:15
/**
 * Generates float value between low and high parameters. 
 * 
 * Generator has to be initialized using set_generator function, otherwise always returns 0.
 */
float Rnd_Generator::generate(int32_t low, int32_t high) {
    acf0:	e92d4800 	push	{fp, lr}
    acf4:	e28db004 	add	fp, sp, #4
    acf8:	e24dd020 	sub	sp, sp, #32
    acfc:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    ad00:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    ad04:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/rnd_generator.cpp:16
	if (rnd_file == RND_NOT_INITIALIZED) {
    ad08:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    ad0c:	e5933000 	ldr	r3, [r3]
    ad10:	e3730001 	cmn	r3, #1
    ad14:	1a000001 	bne	ad20 <_ZN13Rnd_Generator8generateEii+0x30>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/rnd_generator.cpp:17
		return 0;
    ad18:	e3a03000 	mov	r3, #0
    ad1c:	ea00001d 	b	ad98 <_ZN13Rnd_Generator8generateEii+0xa8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/rnd_generator.cpp:20
	}

	char buf[sizeof(uint32_t)] = {0};
    ad20:	e3a03000 	mov	r3, #0
    ad24:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/rnd_generator.cpp:21
	read(rnd_file, buf, sizeof(uint32_t));
    ad28:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    ad2c:	e5933000 	ldr	r3, [r3]
    ad30:	e24b1014 	sub	r1, fp, #20
    ad34:	e3a02004 	mov	r2, #4
    ad38:	e1a00003 	mov	r0, r3
    ad3c:	ebfffb62 	bl	9acc <_Z4readjPcj>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/rnd_generator.cpp:22
	int32_t diff = high - low;
    ad40:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    ad44:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    ad48:	e0423003 	sub	r3, r2, r3
    ad4c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/rnd_generator.cpp:24

	uint32_t rnd_value = reinterpret_cast<uint32_t*>(buf)[0];
    ad50:	e24b3014 	sub	r3, fp, #20
    ad54:	e5933000 	ldr	r3, [r3]
    ad58:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/rnd_generator.cpp:25
	float rnd_final = static_cast<float>(rnd_value / (static_cast<float>(UINT32_T_MAX) / diff)) + low;
    ad5c:	e51b300c 	ldr	r3, [fp, #-12]
    ad60:	ee073a90 	vmov	s15, r3
    ad64:	eef86a67 	vcvt.f32.u32	s13, s15
    ad68:	e51b3008 	ldr	r3, [fp, #-8]
    ad6c:	ee073a90 	vmov	s15, r3
    ad70:	eeb87ae7 	vcvt.f32.s32	s14, s15
    ad74:	ed9f6a0b 	vldr	s12, [pc, #44]	; ada8 <_ZN13Rnd_Generator8generateEii+0xb8>
    ad78:	eec67a07 	vdiv.f32	s15, s12, s14
    ad7c:	ee867aa7 	vdiv.f32	s14, s13, s15
    ad80:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    ad84:	ee073a90 	vmov	s15, r3
    ad88:	eef87ae7 	vcvt.f32.s32	s15, s15
    ad8c:	ee777a27 	vadd.f32	s15, s14, s15
    ad90:	ed4b7a04 	vstr	s15, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/rnd_generator.cpp:27

	return rnd_final;
    ad94:	e51b3010 	ldr	r3, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/rnd_generator.cpp:28 (discriminator 1)
}
    ad98:	ee073a90 	vmov	s15, r3
    ad9c:	eeb00a67 	vmov.f32	s0, s15
    ada0:	e24bd004 	sub	sp, fp, #4
    ada4:	e8bd8800 	pop	{fp, pc}
    ada8:	4f800000 	svcmi	0x00800000

0000adac <_ZN13Rnd_Generator13set_generatorEj>:
_ZN13Rnd_Generator13set_generatorEj():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/rnd_generator.cpp:30

void Rnd_Generator::set_generator(uint32_t file) {
    adac:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    adb0:	e28db000 	add	fp, sp, #0
    adb4:	e24dd00c 	sub	sp, sp, #12
    adb8:	e50b0008 	str	r0, [fp, #-8]
    adbc:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/rnd_generator.cpp:31
	rnd_file = file;
    adc0:	e51b3008 	ldr	r3, [fp, #-8]
    adc4:	e51b200c 	ldr	r2, [fp, #-12]
    adc8:	e5832000 	str	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/rnd_generator.cpp:32
    adcc:	e320f000 	nop	{0}
    add0:	e28bd000 	add	sp, fp, #0
    add4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    add8:	e12fff1e 	bx	lr

0000addc <_ZN15Circular_BufferC1Ev>:
_ZN15Circular_BufferC2Ev():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:4
#include <circular_buffer.h>
#include <stdstring.h>

Circular_Buffer::Circular_Buffer() {
    addc:	e92d4800 	push	{fp, lr}
    ade0:	e28db004 	add	fp, sp, #4
    ade4:	e24dd008 	sub	sp, sp, #8
    ade8:	e50b0008 	str	r0, [fp, #-8]
    adec:	e51b3008 	ldr	r3, [fp, #-8]
    adf0:	e3a02000 	mov	r2, #0
    adf4:	e5832080 	str	r2, [r3, #128]	; 0x80
    adf8:	e51b3008 	ldr	r3, [fp, #-8]
    adfc:	e3a02000 	mov	r2, #0
    ae00:	e5832084 	str	r2, [r3, #132]	; 0x84
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:5
    bzero(buffer, BUFFER_SIZE);
    ae04:	e51b3008 	ldr	r3, [fp, #-8]
    ae08:	e3a01080 	mov	r1, #128	; 0x80
    ae0c:	e1a00003 	mov	r0, r3
    ae10:	ebfffef8 	bl	a9f8 <_Z5bzeroPvi>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:6
};
    ae14:	e51b3008 	ldr	r3, [fp, #-8]
    ae18:	e1a00003 	mov	r0, r3
    ae1c:	e24bd004 	sub	sp, fp, #4
    ae20:	e8bd8800 	pop	{fp, pc}

0000ae24 <_ZN15Circular_Buffer4readEPc>:
_ZN15Circular_Buffer4readEPc():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:11

/* TODO: Vyresit tady nejak try_spinlock_lock. Mozna predat spinlock z UARTu, ktery muze UART driver zavrit externe nez spusti read. */

//Precte vsechna dostupna data, vrati pocet prectenych znaku.
uint32_t Circular_Buffer::read(char * returnBuffer) {
    ae24:	e92d4800 	push	{fp, lr}
    ae28:	e28db004 	add	fp, sp, #4
    ae2c:	e24dd008 	sub	sp, sp, #8
    ae30:	e50b0008 	str	r0, [fp, #-8]
    ae34:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:12
    return read(returnBuffer, writeIndex - readIndex); //Precti rozdil mezi indexem pro cteni a zapis -> vsechno
    ae38:	e51b3008 	ldr	r3, [fp, #-8]
    ae3c:	e5932084 	ldr	r2, [r3, #132]	; 0x84
    ae40:	e51b3008 	ldr	r3, [fp, #-8]
    ae44:	e5933080 	ldr	r3, [r3, #128]	; 0x80
    ae48:	e0423003 	sub	r3, r2, r3
    ae4c:	e1a02003 	mov	r2, r3
    ae50:	e51b100c 	ldr	r1, [fp, #-12]
    ae54:	e51b0008 	ldr	r0, [fp, #-8]
    ae58:	eb000003 	bl	ae6c <_ZN15Circular_Buffer4readEPcj>
    ae5c:	e1a03000 	mov	r3, r0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:13
}
    ae60:	e1a00003 	mov	r0, r3
    ae64:	e24bd004 	sub	sp, fp, #4
    ae68:	e8bd8800 	pop	{fp, pc}

0000ae6c <_ZN15Circular_Buffer4readEPcj>:
_ZN15Circular_Buffer4readEPcj():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:16

//Precte zadany pocet znaku, vrati realny pocet prectenych znaku.
uint32_t Circular_Buffer::read(char * returnBuffer, uint32_t len) {
    ae6c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    ae70:	e28db000 	add	fp, sp, #0
    ae74:	e24dd024 	sub	sp, sp, #36	; 0x24
    ae78:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    ae7c:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    ae80:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:17
    int readChars = 0;
    ae84:	e3a03000 	mov	r3, #0
    ae88:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:21

    //Drop the values that are inaccessible - They have already been written over by something else
    //Increment value of BUFFER_SIZE to readIndex since we have usigned value and we cannot subtract in the start of program.
    if(readIndex + BUFFER_SIZE < writeIndex) {
    ae8c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    ae90:	e5933080 	ldr	r3, [r3, #128]	; 0x80
    ae94:	e2832080 	add	r2, r3, #128	; 0x80
    ae98:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    ae9c:	e5933084 	ldr	r3, [r3, #132]	; 0x84
    aea0:	e1520003 	cmp	r2, r3
    aea4:	2a000004 	bcs	aebc <_ZN15Circular_Buffer4readEPcj+0x50>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:22
        readIndex = writeIndex - BUFFER_SIZE + 1;
    aea8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    aeac:	e5933084 	ldr	r3, [r3, #132]	; 0x84
    aeb0:	e243207f 	sub	r2, r3, #127	; 0x7f
    aeb4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    aeb8:	e5832080 	str	r2, [r3, #128]	; 0x80
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:25
    }

    uint32_t maxLen = writeIndex - readIndex;
    aebc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    aec0:	e5932084 	ldr	r2, [r3, #132]	; 0x84
    aec4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    aec8:	e5933080 	ldr	r3, [r3, #128]	; 0x80
    aecc:	e0423003 	sub	r3, r2, r3
    aed0:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:27

    if (maxLen < len) {
    aed4:	e51b2010 	ldr	r2, [fp, #-16]
    aed8:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    aedc:	e1520003 	cmp	r2, r3
    aee0:	2a000001 	bcs	aeec <_ZN15Circular_Buffer4readEPcj+0x80>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:28
        len = maxLen;
    aee4:	e51b3010 	ldr	r3, [fp, #-16]
    aee8:	e50b3020 	str	r3, [fp, #-32]	; 0xffffffe0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:31
    }

    for (int i = 0; i < len; i++) {
    aeec:	e3a03000 	mov	r3, #0
    aef0:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:31 (discriminator 3)
    aef4:	e51b300c 	ldr	r3, [fp, #-12]
    aef8:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    aefc:	e1520003 	cmp	r2, r3
    af00:	9a00001a 	bls	af70 <_ZN15Circular_Buffer4readEPcj+0x104>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:32 (discriminator 2)
        returnBuffer[readChars] = buffer[readIndex % BUFFER_SIZE];
    af04:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    af08:	e5933080 	ldr	r3, [r3, #128]	; 0x80
    af0c:	e203207f 	and	r2, r3, #127	; 0x7f
    af10:	e51b3008 	ldr	r3, [fp, #-8]
    af14:	e51b101c 	ldr	r1, [fp, #-28]	; 0xffffffe4
    af18:	e0813003 	add	r3, r1, r3
    af1c:	e51b1018 	ldr	r1, [fp, #-24]	; 0xffffffe8
    af20:	e7d12002 	ldrb	r2, [r1, r2]
    af24:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:33 (discriminator 2)
        buffer[readIndex % BUFFER_SIZE] = '\0'; //Remove the value from the buffer
    af28:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    af2c:	e5933080 	ldr	r3, [r3, #128]	; 0x80
    af30:	e203307f 	and	r3, r3, #127	; 0x7f
    af34:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    af38:	e3a01000 	mov	r1, #0
    af3c:	e7c21003 	strb	r1, [r2, r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:35 (discriminator 2)

        readChars++; //Increment counter to return
    af40:	e51b3008 	ldr	r3, [fp, #-8]
    af44:	e2833001 	add	r3, r3, #1
    af48:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:36 (discriminator 2)
        readIndex++; //Increment readIndex
    af4c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    af50:	e5933080 	ldr	r3, [r3, #128]	; 0x80
    af54:	e2832001 	add	r2, r3, #1
    af58:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    af5c:	e5832080 	str	r2, [r3, #128]	; 0x80
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:31 (discriminator 2)
    for (int i = 0; i < len; i++) {
    af60:	e51b300c 	ldr	r3, [fp, #-12]
    af64:	e2833001 	add	r3, r3, #1
    af68:	e50b300c 	str	r3, [fp, #-12]
    af6c:	eaffffe0 	b	aef4 <_ZN15Circular_Buffer4readEPcj+0x88>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:39
    }

    return readChars;
    af70:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:40
}
    af74:	e1a00003 	mov	r0, r3
    af78:	e28bd000 	add	sp, fp, #0
    af7c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    af80:	e12fff1e 	bx	lr

0000af84 <_ZN15Circular_Buffer10read_untilEcPc>:
_ZN15Circular_Buffer10read_untilEcPc():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:43

//Precte data dokud nenalezene znak v parametru. Pokud v bufferu tento znak neni, vlozi retezec zpet do bufferu a vrati hodnotu 0.
uint32_t Circular_Buffer::read_until(char stop, char* returnBuffer) {
    af84:	e92d4800 	push	{fp, lr}
    af88:	e28db004 	add	fp, sp, #4
    af8c:	e24dd018 	sub	sp, sp, #24
    af90:	e50b0010 	str	r0, [fp, #-16]
    af94:	e1a03001 	mov	r3, r1
    af98:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    af9c:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:46
    int readTempIndex;

    for (readTempIndex = readIndex; readTempIndex < writeIndex; readTempIndex++) {
    afa0:	e51b3010 	ldr	r3, [fp, #-16]
    afa4:	e5933080 	ldr	r3, [r3, #128]	; 0x80
    afa8:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:46 (discriminator 1)
    afac:	e51b3010 	ldr	r3, [fp, #-16]
    afb0:	e5932084 	ldr	r2, [r3, #132]	; 0x84
    afb4:	e51b3008 	ldr	r3, [fp, #-8]
    afb8:	e1520003 	cmp	r2, r3
    afbc:	9a000016 	bls	b01c <_ZN15Circular_Buffer10read_untilEcPc+0x98>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:47
        if (buffer[readTempIndex % BUFFER_SIZE] == stop) {
    afc0:	e51b3008 	ldr	r3, [fp, #-8]
    afc4:	e2732000 	rsbs	r2, r3, #0
    afc8:	e203307f 	and	r3, r3, #127	; 0x7f
    afcc:	e202207f 	and	r2, r2, #127	; 0x7f
    afd0:	52623000 	rsbpl	r3, r2, #0
    afd4:	e51b2010 	ldr	r2, [fp, #-16]
    afd8:	e7d23003 	ldrb	r3, [r2, r3]
    afdc:	e55b2011 	ldrb	r2, [fp, #-17]	; 0xffffffef
    afe0:	e1520003 	cmp	r2, r3
    afe4:	0a00000b 	beq	b018 <_ZN15Circular_Buffer10read_untilEcPc+0x94>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:52
            break;
        }

        //Pokud jsem doted nenasel ten znak, tak vratim nulu a neresim buffer
        if (readTempIndex == writeIndex - 1) {
    afe8:	e51b3010 	ldr	r3, [fp, #-16]
    afec:	e5933084 	ldr	r3, [r3, #132]	; 0x84
    aff0:	e2432001 	sub	r2, r3, #1
    aff4:	e51b3008 	ldr	r3, [fp, #-8]
    aff8:	e1520003 	cmp	r2, r3
    affc:	1a000001 	bne	b008 <_ZN15Circular_Buffer10read_untilEcPc+0x84>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:53
            return 0;
    b000:	e3a03000 	mov	r3, #0
    b004:	ea00000f 	b	b048 <_ZN15Circular_Buffer10read_untilEcPc+0xc4>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:46 (discriminator 2)
    for (readTempIndex = readIndex; readTempIndex < writeIndex; readTempIndex++) {
    b008:	e51b3008 	ldr	r3, [fp, #-8]
    b00c:	e2833001 	add	r3, r3, #1
    b010:	e50b3008 	str	r3, [fp, #-8]
    b014:	eaffffe4 	b	afac <_ZN15Circular_Buffer10read_untilEcPc+0x28>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:48
            break;
    b018:	e320f000 	nop	{0}
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:58
        }
    }

    //V promenne readTempIndex mam hodnotu, kde se zrovna nachazi
    return read(returnBuffer, readTempIndex - readIndex + 1); //Read one more char - if we have asd\n, then \n is readTempIndex 3 - readIndex 0 = 3 - but we want 4 letters
    b01c:	e51b2008 	ldr	r2, [fp, #-8]
    b020:	e51b3010 	ldr	r3, [fp, #-16]
    b024:	e5933080 	ldr	r3, [r3, #128]	; 0x80
    b028:	e0423003 	sub	r3, r2, r3
    b02c:	e2833001 	add	r3, r3, #1
    b030:	e1a02003 	mov	r2, r3
    b034:	e51b1018 	ldr	r1, [fp, #-24]	; 0xffffffe8
    b038:	e51b0010 	ldr	r0, [fp, #-16]
    b03c:	ebffff8a 	bl	ae6c <_ZN15Circular_Buffer4readEPcj>
    b040:	e1a03000 	mov	r3, r0
    b044:	e320f000 	nop	{0}
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:59
}
    b048:	e1a00003 	mov	r0, r3
    b04c:	e24bd004 	sub	sp, fp, #4
    b050:	e8bd8800 	pop	{fp, pc}

0000b054 <_ZN15Circular_Buffer5writeEPcj>:
_ZN15Circular_Buffer5writeEPcj():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:62

// Vlozi vice znaku do bufferu
void Circular_Buffer::write(char* input, uint32_t len) {
    b054:	e92d4800 	push	{fp, lr}
    b058:	e28db004 	add	fp, sp, #4
    b05c:	e24dd018 	sub	sp, sp, #24
    b060:	e50b0010 	str	r0, [fp, #-16]
    b064:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    b068:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:63
    for (int i = 0; i < len; i++) {
    b06c:	e3a03000 	mov	r3, #0
    b070:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:63 (discriminator 3)
    b074:	e51b3008 	ldr	r3, [fp, #-8]
    b078:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    b07c:	e1520003 	cmp	r2, r3
    b080:	9a00000a 	bls	b0b0 <_ZN15Circular_Buffer5writeEPcj+0x5c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:64 (discriminator 2)
        write(input[i]);
    b084:	e51b3008 	ldr	r3, [fp, #-8]
    b088:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    b08c:	e0823003 	add	r3, r2, r3
    b090:	e5d33000 	ldrb	r3, [r3]
    b094:	e1a01003 	mov	r1, r3
    b098:	e51b0010 	ldr	r0, [fp, #-16]
    b09c:	eb000006 	bl	b0bc <_ZN15Circular_Buffer5writeEc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:63 (discriminator 2)
    for (int i = 0; i < len; i++) {
    b0a0:	e51b3008 	ldr	r3, [fp, #-8]
    b0a4:	e2833001 	add	r3, r3, #1
    b0a8:	e50b3008 	str	r3, [fp, #-8]
    b0ac:	eafffff0 	b	b074 <_ZN15Circular_Buffer5writeEPcj+0x20>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:66
    }
}
    b0b0:	e320f000 	nop	{0}
    b0b4:	e24bd004 	sub	sp, fp, #4
    b0b8:	e8bd8800 	pop	{fp, pc}

0000b0bc <_ZN15Circular_Buffer5writeEc>:
_ZN15Circular_Buffer5writeEc():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:69

// Vlozi jeden znak do bufferu
void Circular_Buffer::write(char input) {
    b0bc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    b0c0:	e28db000 	add	fp, sp, #0
    b0c4:	e24dd00c 	sub	sp, sp, #12
    b0c8:	e50b0008 	str	r0, [fp, #-8]
    b0cc:	e1a03001 	mov	r3, r1
    b0d0:	e54b3009 	strb	r3, [fp, #-9]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:70
    buffer[writeIndex % BUFFER_SIZE] = input;
    b0d4:	e51b3008 	ldr	r3, [fp, #-8]
    b0d8:	e5933084 	ldr	r3, [r3, #132]	; 0x84
    b0dc:	e203307f 	and	r3, r3, #127	; 0x7f
    b0e0:	e51b2008 	ldr	r2, [fp, #-8]
    b0e4:	e55b1009 	ldrb	r1, [fp, #-9]
    b0e8:	e7c21003 	strb	r1, [r2, r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:71
    writeIndex++;
    b0ec:	e51b3008 	ldr	r3, [fp, #-8]
    b0f0:	e5933084 	ldr	r3, [r3, #132]	; 0x84
    b0f4:	e2832001 	add	r2, r3, #1
    b0f8:	e51b3008 	ldr	r3, [fp, #-8]
    b0fc:	e5832084 	str	r2, [r3, #132]	; 0x84
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdutils/src/circular_buffer.cpp:72
    b100:	e320f000 	nop	{0}
    b104:	e28bd000 	add	sp, fp, #0
    b108:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    b10c:	e12fff1e 	bx	lr

0000b110 <__udivsi3>:
__udivsi3():
    b110:	e2512001 	subs	r2, r1, #1
    b114:	012fff1e 	bxeq	lr
    b118:	3a000023 	bcc	b1ac <__udivsi3+0x9c>
    b11c:	e1500001 	cmp	r0, r1
    b120:	9a00001a 	bls	b190 <__udivsi3+0x80>
    b124:	e1110002 	tst	r1, r2
    b128:	0a00001b 	beq	b19c <__udivsi3+0x8c>
    b12c:	e16f3f11 	clz	r3, r1
    b130:	e16f2f10 	clz	r2, r0
    b134:	e0432002 	sub	r2, r3, r2
    b138:	e3a03001 	mov	r3, #1
    b13c:	e1a01211 	lsl	r1, r1, r2
    b140:	e1a03213 	lsl	r3, r3, r2
    b144:	e3a02000 	mov	r2, #0
    b148:	e1500001 	cmp	r0, r1
    b14c:	20400001 	subcs	r0, r0, r1
    b150:	21822003 	orrcs	r2, r2, r3
    b154:	e15000a1 	cmp	r0, r1, lsr #1
    b158:	204000a1 	subcs	r0, r0, r1, lsr #1
    b15c:	218220a3 	orrcs	r2, r2, r3, lsr #1
    b160:	e1500121 	cmp	r0, r1, lsr #2
    b164:	20400121 	subcs	r0, r0, r1, lsr #2
    b168:	21822123 	orrcs	r2, r2, r3, lsr #2
    b16c:	e15001a1 	cmp	r0, r1, lsr #3
    b170:	204001a1 	subcs	r0, r0, r1, lsr #3
    b174:	218221a3 	orrcs	r2, r2, r3, lsr #3
    b178:	e3500000 	cmp	r0, #0
    b17c:	11b03223 	lsrsne	r3, r3, #4
    b180:	11a01221 	lsrne	r1, r1, #4
    b184:	1affffef 	bne	b148 <__udivsi3+0x38>
    b188:	e1a00002 	mov	r0, r2
    b18c:	e12fff1e 	bx	lr
    b190:	03a00001 	moveq	r0, #1
    b194:	13a00000 	movne	r0, #0
    b198:	e12fff1e 	bx	lr
    b19c:	e16f2f11 	clz	r2, r1
    b1a0:	e262201f 	rsb	r2, r2, #31
    b1a4:	e1a00230 	lsr	r0, r0, r2
    b1a8:	e12fff1e 	bx	lr
    b1ac:	e3500000 	cmp	r0, #0
    b1b0:	13e00000 	mvnne	r0, #0
    b1b4:	ea000046 	b	b2d4 <__aeabi_idiv0>

0000b1b8 <__aeabi_uidivmod>:
__aeabi_uidivmod():
    b1b8:	e3510000 	cmp	r1, #0
    b1bc:	0afffffa 	beq	b1ac <__udivsi3+0x9c>
    b1c0:	e92d4003 	push	{r0, r1, lr}
    b1c4:	ebffffd1 	bl	b110 <__udivsi3>
    b1c8:	e8bd4006 	pop	{r1, r2, lr}
    b1cc:	e0030092 	mul	r3, r2, r0
    b1d0:	e0411003 	sub	r1, r1, r3
    b1d4:	e12fff1e 	bx	lr

0000b1d8 <__divsi3>:
__divsi3():
    b1d8:	e3510000 	cmp	r1, #0
    b1dc:	0a000030 	beq	b2a4 <.divsi3_skip_div0_test+0xc4>

0000b1e0 <.divsi3_skip_div0_test>:
    b1e0:	e020c001 	eor	ip, r0, r1
    b1e4:	42611000 	rsbmi	r1, r1, #0
    b1e8:	e2512001 	subs	r2, r1, #1
    b1ec:	0a00001f 	beq	b270 <.divsi3_skip_div0_test+0x90>
    b1f0:	e1b03000 	movs	r3, r0
    b1f4:	42603000 	rsbmi	r3, r0, #0
    b1f8:	e1530001 	cmp	r3, r1
    b1fc:	9a00001e 	bls	b27c <.divsi3_skip_div0_test+0x9c>
    b200:	e1110002 	tst	r1, r2
    b204:	0a000020 	beq	b28c <.divsi3_skip_div0_test+0xac>
    b208:	e16f2f11 	clz	r2, r1
    b20c:	e16f0f13 	clz	r0, r3
    b210:	e0420000 	sub	r0, r2, r0
    b214:	e3a02001 	mov	r2, #1
    b218:	e1a01011 	lsl	r1, r1, r0
    b21c:	e1a02012 	lsl	r2, r2, r0
    b220:	e3a00000 	mov	r0, #0
    b224:	e1530001 	cmp	r3, r1
    b228:	20433001 	subcs	r3, r3, r1
    b22c:	21800002 	orrcs	r0, r0, r2
    b230:	e15300a1 	cmp	r3, r1, lsr #1
    b234:	204330a1 	subcs	r3, r3, r1, lsr #1
    b238:	218000a2 	orrcs	r0, r0, r2, lsr #1
    b23c:	e1530121 	cmp	r3, r1, lsr #2
    b240:	20433121 	subcs	r3, r3, r1, lsr #2
    b244:	21800122 	orrcs	r0, r0, r2, lsr #2
    b248:	e15301a1 	cmp	r3, r1, lsr #3
    b24c:	204331a1 	subcs	r3, r3, r1, lsr #3
    b250:	218001a2 	orrcs	r0, r0, r2, lsr #3
    b254:	e3530000 	cmp	r3, #0
    b258:	11b02222 	lsrsne	r2, r2, #4
    b25c:	11a01221 	lsrne	r1, r1, #4
    b260:	1affffef 	bne	b224 <.divsi3_skip_div0_test+0x44>
    b264:	e35c0000 	cmp	ip, #0
    b268:	42600000 	rsbmi	r0, r0, #0
    b26c:	e12fff1e 	bx	lr
    b270:	e13c0000 	teq	ip, r0
    b274:	42600000 	rsbmi	r0, r0, #0
    b278:	e12fff1e 	bx	lr
    b27c:	33a00000 	movcc	r0, #0
    b280:	01a00fcc 	asreq	r0, ip, #31
    b284:	03800001 	orreq	r0, r0, #1
    b288:	e12fff1e 	bx	lr
    b28c:	e16f2f11 	clz	r2, r1
    b290:	e262201f 	rsb	r2, r2, #31
    b294:	e35c0000 	cmp	ip, #0
    b298:	e1a00233 	lsr	r0, r3, r2
    b29c:	42600000 	rsbmi	r0, r0, #0
    b2a0:	e12fff1e 	bx	lr
    b2a4:	e3500000 	cmp	r0, #0
    b2a8:	c3e00102 	mvngt	r0, #-2147483648	; 0x80000000
    b2ac:	b3a00102 	movlt	r0, #-2147483648	; 0x80000000
    b2b0:	ea000007 	b	b2d4 <__aeabi_idiv0>

0000b2b4 <__aeabi_idivmod>:
__aeabi_idivmod():
    b2b4:	e3510000 	cmp	r1, #0
    b2b8:	0afffff9 	beq	b2a4 <.divsi3_skip_div0_test+0xc4>
    b2bc:	e92d4003 	push	{r0, r1, lr}
    b2c0:	ebffffc6 	bl	b1e0 <.divsi3_skip_div0_test>
    b2c4:	e8bd4006 	pop	{r1, r2, lr}
    b2c8:	e0030092 	mul	r3, r2, r0
    b2cc:	e0411003 	sub	r1, r1, r3
    b2d0:	e12fff1e 	bx	lr

0000b2d4 <__aeabi_idiv0>:
__aeabi_ldiv0():
    b2d4:	e12fff1e 	bx	lr

0000b2d8 <memcpy>:
memcpy():
/home/buildozer/aports/community/newlib/src/newlib-4.1.0/newlib/libc/machine/arm/../../string/memcpy.c:73
    b2d8:	e352000f 	cmp	r2, #15
    b2dc:	9a000035 	bls	b3b8 <memcpy+0xe0>
/home/buildozer/aports/community/newlib/src/newlib-4.1.0/newlib/libc/machine/arm/../../string/memcpy.c:73 (discriminator 1)
    b2e0:	e1803001 	orr	r3, r0, r1
    b2e4:	e3130003 	tst	r3, #3
    b2e8:	1a00003e 	bne	b3e8 <memcpy+0x110>
    b2ec:	e242c010 	sub	ip, r2, #16
/home/buildozer/aports/community/newlib/src/newlib-4.1.0/newlib/libc/machine/arm/../../string/memcpy.c:52
    b2f0:	e92d40f0 	push	{r4, r5, r6, r7, lr}
    b2f4:	e3cc300f 	bic	r3, ip, #15
    b2f8:	e2814020 	add	r4, r1, #32
    b2fc:	e0844003 	add	r4, r4, r3
    b300:	e2815010 	add	r5, r1, #16
    b304:	e2806010 	add	r6, r0, #16
    b308:	e1a0322c 	lsr	r3, ip, #4
/home/buildozer/aports/community/newlib/src/newlib-4.1.0/newlib/libc/machine/arm/../../string/memcpy.c:82
    b30c:	e515e00c 	ldr	lr, [r5, #-12]
/home/buildozer/aports/community/newlib/src/newlib-4.1.0/newlib/libc/machine/arm/../../string/memcpy.c:83
    b310:	e515c008 	ldr	ip, [r5, #-8]
/home/buildozer/aports/community/newlib/src/newlib-4.1.0/newlib/libc/machine/arm/../../string/memcpy.c:81
    b314:	e5157010 	ldr	r7, [r5, #-16]
/home/buildozer/aports/community/newlib/src/newlib-4.1.0/newlib/libc/machine/arm/../../string/memcpy.c:82
    b318:	e506e00c 	str	lr, [r6, #-12]
/home/buildozer/aports/community/newlib/src/newlib-4.1.0/newlib/libc/machine/arm/../../string/memcpy.c:79
    b31c:	e2855010 	add	r5, r5, #16
/home/buildozer/aports/community/newlib/src/newlib-4.1.0/newlib/libc/machine/arm/../../string/memcpy.c:84
    b320:	e515e014 	ldr	lr, [r5, #-20]	; 0xffffffec
/home/buildozer/aports/community/newlib/src/newlib-4.1.0/newlib/libc/machine/arm/../../string/memcpy.c:79
    b324:	e1550004 	cmp	r5, r4
/home/buildozer/aports/community/newlib/src/newlib-4.1.0/newlib/libc/machine/arm/../../string/memcpy.c:81
    b328:	e5067010 	str	r7, [r6, #-16]
/home/buildozer/aports/community/newlib/src/newlib-4.1.0/newlib/libc/machine/arm/../../string/memcpy.c:84
    b32c:	e9065000 	stmdb	r6, {ip, lr}
/home/buildozer/aports/community/newlib/src/newlib-4.1.0/newlib/libc/machine/arm/../../string/memcpy.c:79
    b330:	e2866010 	add	r6, r6, #16
    b334:	1afffff4 	bne	b30c <memcpy+0x34>
    b338:	e283c001 	add	ip, r3, #1
/home/buildozer/aports/community/newlib/src/newlib-4.1.0/newlib/libc/machine/arm/../../string/memcpy.c:89
    b33c:	e312000c 	tst	r2, #12
/home/buildozer/aports/community/newlib/src/newlib-4.1.0/newlib/libc/machine/arm/../../string/memcpy.c:85
    b340:	e202300f 	and	r3, r2, #15
/home/buildozer/aports/community/newlib/src/newlib-4.1.0/newlib/libc/machine/arm/../../string/memcpy.c:84
    b344:	e081120c 	add	r1, r1, ip, lsl #4
/home/buildozer/aports/community/newlib/src/newlib-4.1.0/newlib/libc/machine/arm/../../string/memcpy.c:89
    b348:	01a02003 	moveq	r2, r3
/home/buildozer/aports/community/newlib/src/newlib-4.1.0/newlib/libc/machine/arm/../../string/memcpy.c:84
    b34c:	e080c20c 	add	ip, r0, ip, lsl #4
/home/buildozer/aports/community/newlib/src/newlib-4.1.0/newlib/libc/machine/arm/../../string/memcpy.c:89
    b350:	0a00000d 	beq	b38c <memcpy+0xb4>
    b354:	e2433004 	sub	r3, r3, #4
    b358:	e3c36003 	bic	r6, r3, #3
    b35c:	e1a0e123 	lsr	lr, r3, #2
    b360:	e08c6006 	add	r6, ip, r6
    b364:	e24c3004 	sub	r3, ip, #4
/home/buildozer/aports/community/newlib/src/newlib-4.1.0/newlib/libc/machine/arm/../../string/memcpy.c:84
    b368:	e1a04001 	mov	r4, r1
/home/buildozer/aports/community/newlib/src/newlib-4.1.0/newlib/libc/machine/arm/../../string/memcpy.c:91
    b36c:	e4945004 	ldr	r5, [r4], #4
    b370:	e5a35004 	str	r5, [r3, #4]!
/home/buildozer/aports/community/newlib/src/newlib-4.1.0/newlib/libc/machine/arm/../../string/memcpy.c:89
    b374:	e1530006 	cmp	r3, r6
    b378:	1afffffb 	bne	b36c <memcpy+0x94>
    b37c:	e28e3001 	add	r3, lr, #1
/home/buildozer/aports/community/newlib/src/newlib-4.1.0/newlib/libc/machine/arm/../../string/memcpy.c:92
    b380:	e2022003 	and	r2, r2, #3
/home/buildozer/aports/community/newlib/src/newlib-4.1.0/newlib/libc/machine/arm/../../string/memcpy.c:91
    b384:	e08cc103 	add	ip, ip, r3, lsl #2
    b388:	e0811103 	add	r1, r1, r3, lsl #2
/home/buildozer/aports/community/newlib/src/newlib-4.1.0/newlib/libc/machine/arm/../../string/memcpy.c:100
    b38c:	e3520000 	cmp	r2, #0
    b390:	e2423001 	sub	r3, r2, #1
    b394:	08bd80f0 	popeq	{r4, r5, r6, r7, pc}
    b398:	e2833001 	add	r3, r3, #1
    b39c:	e24c2001 	sub	r2, ip, #1
    b3a0:	e0813003 	add	r3, r1, r3
/home/buildozer/aports/community/newlib/src/newlib-4.1.0/newlib/libc/machine/arm/../../string/memcpy.c:101
    b3a4:	e4d1c001 	ldrb	ip, [r1], #1
    b3a8:	e5e2c001 	strb	ip, [r2, #1]!
/home/buildozer/aports/community/newlib/src/newlib-4.1.0/newlib/libc/machine/arm/../../string/memcpy.c:100
    b3ac:	e1510003 	cmp	r1, r3
    b3b0:	1afffffb 	bne	b3a4 <memcpy+0xcc>
    b3b4:	e8bd80f0 	pop	{r4, r5, r6, r7, pc}
    b3b8:	e3520000 	cmp	r2, #0
/home/buildozer/aports/community/newlib/src/newlib-4.1.0/newlib/libc/machine/arm/../../string/memcpy.c:66
    b3bc:	e1a0c000 	mov	ip, r0
/home/buildozer/aports/community/newlib/src/newlib-4.1.0/newlib/libc/machine/arm/../../string/memcpy.c:100
    b3c0:	e2423001 	sub	r3, r2, #1
    b3c4:	012fff1e 	bxeq	lr
    b3c8:	e2833001 	add	r3, r3, #1
    b3cc:	e24c2001 	sub	r2, ip, #1
    b3d0:	e0813003 	add	r3, r1, r3
/home/buildozer/aports/community/newlib/src/newlib-4.1.0/newlib/libc/machine/arm/../../string/memcpy.c:101
    b3d4:	e4d1c001 	ldrb	ip, [r1], #1
    b3d8:	e5e2c001 	strb	ip, [r2, #1]!
/home/buildozer/aports/community/newlib/src/newlib-4.1.0/newlib/libc/machine/arm/../../string/memcpy.c:100
    b3dc:	e1510003 	cmp	r1, r3
    b3e0:	1afffffb 	bne	b3d4 <memcpy+0xfc>
    b3e4:	e12fff1e 	bx	lr
    b3e8:	e2423001 	sub	r3, r2, #1
/home/buildozer/aports/community/newlib/src/newlib-4.1.0/newlib/libc/machine/arm/../../string/memcpy.c:66
    b3ec:	e1a0c000 	mov	ip, r0
    b3f0:	eafffff4 	b	b3c8 <memcpy+0xf0>

Disassembly of section .rodata:

0000b3f4 <_ZL13Lock_Unlocked>:
    b3f4:	00000000 	andeq	r0, r0, r0

0000b3f8 <_ZL11Lock_Locked>:
    b3f8:	00000001 	andeq	r0, r0, r1

0000b3fc <_ZL21MaxFSDriverNameLength>:
    b3fc:	00000010 	andeq	r0, r0, r0, lsl r0

0000b400 <_ZL17MaxFilenameLength>:
    b400:	00000010 	andeq	r0, r0, r0, lsl r0

0000b404 <_ZL13MaxPathLength>:
    b404:	00000080 	andeq	r0, r0, r0, lsl #1

0000b408 <_ZL18NoFilesystemDriver>:
    b408:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000b40c <_ZL9NotifyAll>:
    b40c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000b410 <_ZL24Max_Process_Opened_Files>:
    b410:	00000010 	andeq	r0, r0, r0, lsl r0

0000b414 <_ZL10Indefinite>:
    b414:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000b418 <_ZL18Deadline_Unchanged>:
    b418:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

0000b41c <_ZL14Invalid_Handle>:
    b41c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    b420:	3a564544 	bcc	159c938 <__bss_end+0x1591224>
    b424:	74726175 	ldrbtvc	r6, [r2], #-373	; 0xfffffe8b
    b428:	0000302f 	andeq	r3, r0, pc, lsr #32
    b42c:	0000203e 	andeq	r2, r0, lr, lsr r0
    b430:	202c4b4f 	eorcs	r4, ip, pc, asr #22
    b434:	00000000 	andeq	r0, r0, r0
    b438:	00000020 	andeq	r0, r0, r0, lsr #32
    b43c:	6e696d20 	cdpvs	13, 6, cr6, cr9, cr0, {1}
    b440:	00007475 	andeq	r7, r0, r5, ror r4
    b444:	7073654e 	rsbsvc	r6, r3, lr, asr #10
    b448:	6e766172 	mrcvs	1, 3, r6, cr6, cr2, {3}
    b44c:	6f682061 	svcvs	0x00682061
    b450:	746f6e64 	strbtvc	r6, [pc], #-3684	; b458 <_ZL14Invalid_Handle+0x3c>
    b454:	00000061 	andeq	r0, r0, r1, rrx
    b458:	74617053 	strbtvc	r7, [r1], #-83	; 0xffffffad
    b45c:	6620796e 	strtvs	r7, [r0], -lr, ror #18
    b460:	616d726f 	cmnvs	sp, pc, ror #4
    b464:	617a2074 	cmnvs	sl, r4, ror r0
    b468:	656e6164 	strbvs	r6, [lr, #-356]!	; 0xfffffe9c
    b46c:	63206f68 			; <UNDEFINED> instruction: 0x63206f68
    b470:	616c7369 	cmnvs	ip, r9, ror #6
    b474:	0000002e 	andeq	r0, r0, lr, lsr #32
    b478:	6b6f726b 	blvs	1be7e2c <__bss_end+0x1bdc718>
    b47c:	6e61766f 	cdpvs	6, 6, cr7, cr1, cr15, {3}
    b480:	00000069 	andeq	r0, r0, r9, rrx
    b484:	64657270 	strbtvs	r7, [r5], #-624	; 0xfffffd90
    b488:	65766f70 	ldrbvs	r6, [r6, #-3952]!	; 0xfffff090
    b48c:	00000064 	andeq	r0, r0, r4, rrx
    b490:	61726170 	cmnvs	r2, r0, ror r1
    b494:	6574656d 	ldrbvs	r6, [r4, #-1389]!	; 0xfffffa93
    b498:	00007372 	andeq	r7, r0, r2, ror r3
    b49c:	203d2041 	eorscs	r2, sp, r1, asr #32
    b4a0:	00000000 	andeq	r0, r0, r0
    b4a4:	2042202c 	subcs	r2, r2, ip, lsr #32
    b4a8:	0000203d 	andeq	r2, r0, sp, lsr r0
    b4ac:	2043202c 	subcs	r2, r3, ip, lsr #32
    b4b0:	0000203d 	andeq	r2, r0, sp, lsr r0
    b4b4:	2044202c 	subcs	r2, r4, ip, lsr #32
    b4b8:	0000203d 	andeq	r2, r0, sp, lsr r0
    b4bc:	2045202c 	subcs	r2, r5, ip, lsr #32
    b4c0:	0000203d 	andeq	r2, r0, sp, lsr r0
    b4c4:	706f7473 	rsbvc	r7, pc, r3, ror r4	; <UNPREDICTABLE>
    b4c8:	00000000 	andeq	r0, r0, r0
    b4cc:	004e614e 	subeq	r6, lr, lr, asr #2
    b4d0:	69636f50 	stmdbvs	r3!, {r4, r6, r8, r9, sl, fp, sp, lr}^
    b4d4:	2e6d6174 	mcrcs	1, 3, r6, cr13, cr4, {3}
    b4d8:	00002e2e 	andeq	r2, r0, lr, lsr #28
    b4dc:	656c614e 	strbvs	r6, [ip, #-334]!	; 0xfffffeb2
    b4e0:	616e657a 	smcvs	58970	; 0xe65a
    b4e4:	74706f20 	ldrbtvc	r6, [r0], #-3872	; 0xfffff0e0
    b4e8:	6c616d69 	stclvs	13, cr6, [r1], #-420	; 0xfffffe5c
    b4ec:	6720696e 	strvs	r6, [r0, -lr, ror #18]!
    b4f0:	72656e65 	rsbvc	r6, r5, #1616	; 0x650
    b4f4:	2e656361 	cdpcs	3, 6, cr6, cr5, cr1, {3}
    b4f8:	00000000 	andeq	r0, r0, r0
    b4fc:	6f707956 	svcvs	0x00707956
    b500:	20746563 	rsbscs	r6, r4, r3, ror #10
    b504:	7375727a 	cmnvc	r5, #-1610612729	; 0xa0000007
    b508:	2e2e6e65 	cdpcs	14, 2, cr6, cr14, cr5, {3}
    b50c:	0000002e 	andeq	r0, r0, lr, lsr #32
    b510:	64657250 	strbtvs	r7, [r5], #-592	; 0xfffffdb0
    b514:	65636b69 	strbvs	r6, [r3, #-2921]!	; 0xfffff497
    b518:	0000203a 	andeq	r2, r0, sl, lsr r0
    b51c:	3a564544 	bcc	159ca34 <__bss_end+0x1591320>
    b520:	676e7274 			; <UNDEFINED> instruction: 0x676e7274
    b524:	00000000 	andeq	r0, r0, r0
    b528:	636c6143 	cmnvs	ip, #-1073741808	; 0xc0000010
    b52c:	7620534f 	strtvc	r5, [r0], -pc, asr #6
    b530:	00302e31 	eorseq	r2, r0, r1, lsr lr
    b534:	6f747541 	svcvs	0x00747541
    b538:	54203a72 	strtpl	r3, [r0], #-2674	; 0xfffff58e
    b53c:	73616d6f 	cmnvc	r1, #7104	; 0x1bc0
    b540:	6e694c20 	cdpvs	12, 6, cr4, cr9, cr0, {1}
    b544:	74726168 	ldrbtvc	r6, [r2], #-360	; 0xfffffe98
    b548:	32412820 	subcc	r2, r1, #32, 16	; 0x200000
    b54c:	30304e32 	eorscc	r4, r0, r2, lsr lr
    b550:	29503535 	ldmdbcs	r0, {r0, r2, r4, r5, r8, sl, ip, sp}^
    b554:	00000000 	andeq	r0, r0, r0
    b558:	6564615a 	strbvs	r6, [r4, #-346]!	; 0xfffffea6
    b55c:	2065746a 	rsbcs	r7, r5, sl, ror #8
    b560:	706a656e 	rsbvc	r6, sl, lr, ror #10
    b564:	20657672 	rsbcs	r7, r5, r2, ror r6
    b568:	6f736163 	svcvs	0x00736163
    b56c:	72207976 	eorvc	r7, r0, #1933312	; 0x1d8000
    b570:	73657a6f 	cmnvc	r5, #454656	; 0x6f000
    b574:	20707574 	rsbscs	r7, r0, r4, ror r5
    b578:	72702061 	rsbsvc	r2, r0, #97	; 0x61
    b57c:	6b696465 	blvs	1a64718 <__bss_end+0x1a59004>
    b580:	20696e63 	rsbcs	r6, r9, r3, ror #28
    b584:	6e656b6f 	vnmulvs.f64	d22, d5, d31
    b588:	76206f6b 	strtvc	r6, [r0], -fp, ror #30
    b58c:	6e696d20 	cdpvs	13, 6, cr6, cr9, cr0, {1}
    b590:	63617475 	cmnvs	r1, #1962934272	; 0x75000000
    b594:	28202e68 	stmdacs	r0!, {r3, r5, r6, r9, sl, fp, sp}
    b598:	6973754d 	ldmdbvs	r3!, {r0, r2, r3, r6, r8, sl, ip, sp, lr}^
    b59c:	74796220 	ldrbtvc	r6, [r9], #-544	; 0xfffffde0
    b5a0:	6c656320 	stclvs	3, cr6, [r5], #-128	; 0xffffff80
    b5a4:	69632065 	stmdbvs	r3!, {r0, r2, r5, r6, sp}^
    b5a8:	2e6f6c73 	mcrcs	12, 3, r6, cr15, cr3, {3}
    b5ac:	00000029 	andeq	r0, r0, r9, lsr #32
    b5b0:	656c6144 	strbvs	r6, [ip, #-324]!	; 0xfffffebc
    b5b4:	646f7020 	strbtvs	r7, [pc], #-32	; b5bc <_ZL14Invalid_Handle+0x1a0>
    b5b8:	6f726f70 	svcvs	0x00726f70
    b5bc:	796e6176 	stmdbvc	lr!, {r1, r2, r4, r5, r6, r8, sp, lr}^
    b5c0:	69727020 	ldmdbvs	r2!, {r5, ip, sp, lr}^
    b5c4:	797a616b 	ldmdbvc	sl!, {r0, r1, r3, r5, r6, r8, sp, lr}^
    b5c8:	7473203a 	ldrbtvc	r2, [r3], #-58	; 0xffffffc6
    b5cc:	202c706f 	eorcs	r7, ip, pc, rrx
    b5d0:	61726170 	cmnvs	r2, r0, ror r1
    b5d4:	6574656d 	ldrbvs	r6, [r4, #-1389]!	; 0xfffffa93
    b5d8:	00007372 	andeq	r7, r0, r2, ror r3

0000b5dc <_ZL13Lock_Unlocked>:
    b5dc:	00000000 	andeq	r0, r0, r0

0000b5e0 <_ZL11Lock_Locked>:
    b5e0:	00000001 	andeq	r0, r0, r1

0000b5e4 <_ZL21MaxFSDriverNameLength>:
    b5e4:	00000010 	andeq	r0, r0, r0, lsl r0

0000b5e8 <_ZL17MaxFilenameLength>:
    b5e8:	00000010 	andeq	r0, r0, r0, lsl r0

0000b5ec <_ZL13MaxPathLength>:
    b5ec:	00000080 	andeq	r0, r0, r0, lsl #1

0000b5f0 <_ZL18NoFilesystemDriver>:
    b5f0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000b5f4 <_ZL9NotifyAll>:
    b5f4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000b5f8 <_ZL24Max_Process_Opened_Files>:
    b5f8:	00000010 	andeq	r0, r0, r0, lsl r0

0000b5fc <_ZL10Indefinite>:
    b5fc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000b600 <_ZL18Deadline_Unchanged>:
    b600:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

0000b604 <_ZL14Invalid_Handle>:
    b604:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000b608 <_ZL13Lock_Unlocked>:
    b608:	00000000 	andeq	r0, r0, r0

0000b60c <_ZL11Lock_Locked>:
    b60c:	00000001 	andeq	r0, r0, r1

0000b610 <_ZL21MaxFSDriverNameLength>:
    b610:	00000010 	andeq	r0, r0, r0, lsl r0

0000b614 <_ZL17MaxFilenameLength>:
    b614:	00000010 	andeq	r0, r0, r0, lsl r0

0000b618 <_ZL13MaxPathLength>:
    b618:	00000080 	andeq	r0, r0, r0, lsl #1

0000b61c <_ZL18NoFilesystemDriver>:
    b61c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000b620 <_ZL9NotifyAll>:
    b620:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000b624 <_ZL24Max_Process_Opened_Files>:
    b624:	00000010 	andeq	r0, r0, r0, lsl r0

0000b628 <_ZL10Indefinite>:
    b628:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000b62c <_ZL18Deadline_Unchanged>:
    b62c:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

0000b630 <_ZL14Invalid_Handle>:
    b630:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    b634:	0000000a 	andeq	r0, r0, sl

0000b638 <_ZL13Lock_Unlocked>:
    b638:	00000000 	andeq	r0, r0, r0

0000b63c <_ZL11Lock_Locked>:
    b63c:	00000001 	andeq	r0, r0, r1

0000b640 <_ZL21MaxFSDriverNameLength>:
    b640:	00000010 	andeq	r0, r0, r0, lsl r0

0000b644 <_ZL17MaxFilenameLength>:
    b644:	00000010 	andeq	r0, r0, r0, lsl r0

0000b648 <_ZL13MaxPathLength>:
    b648:	00000080 	andeq	r0, r0, r0, lsl #1

0000b64c <_ZL18NoFilesystemDriver>:
    b64c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000b650 <_ZL9NotifyAll>:
    b650:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000b654 <_ZL24Max_Process_Opened_Files>:
    b654:	00000010 	andeq	r0, r0, r0, lsl r0

0000b658 <_ZL10Indefinite>:
    b658:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000b65c <_ZL18Deadline_Unchanged>:
    b65c:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

0000b660 <_ZL14Invalid_Handle>:
    b660:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000b664 <_ZL16Pipe_File_Prefix>:
    b664:	3a535953 	bcc	14e1bb8 <__bss_end+0x14d64a4>
    b668:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    b66c:	0000002f 	andeq	r0, r0, pc, lsr #32

0000b670 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    b670:	33323130 	teqcc	r2, #48, 2
    b674:	37363534 			; <UNDEFINED> instruction: 0x37363534
    b678:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    b67c:	46454443 	strbmi	r4, [r5], -r3, asr #8
    b680:	00000000 	andeq	r0, r0, r0

0000b684 <_ZL13Lock_Unlocked>:
    b684:	00000000 	andeq	r0, r0, r0

0000b688 <_ZL11Lock_Locked>:
    b688:	00000001 	andeq	r0, r0, r1

0000b68c <_ZL21MaxFSDriverNameLength>:
    b68c:	00000010 	andeq	r0, r0, r0, lsl r0

0000b690 <_ZL17MaxFilenameLength>:
    b690:	00000010 	andeq	r0, r0, r0, lsl r0

0000b694 <_ZL13MaxPathLength>:
    b694:	00000080 	andeq	r0, r0, r0, lsl #1

0000b698 <_ZL18NoFilesystemDriver>:
    b698:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000b69c <_ZL9NotifyAll>:
    b69c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000b6a0 <_ZL24Max_Process_Opened_Files>:
    b6a0:	00000010 	andeq	r0, r0, r0, lsl r0

0000b6a4 <_ZL10Indefinite>:
    b6a4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000b6a8 <_ZL18Deadline_Unchanged>:
    b6a8:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

0000b6ac <_ZL14Invalid_Handle>:
    b6ac:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    b6b0:	0000000a 	andeq	r0, r0, sl

0000b6b4 <_ZL13Lock_Unlocked>:
    b6b4:	00000000 	andeq	r0, r0, r0

0000b6b8 <_ZL11Lock_Locked>:
    b6b8:	00000001 	andeq	r0, r0, r1

0000b6bc <_ZL21MaxFSDriverNameLength>:
    b6bc:	00000010 	andeq	r0, r0, r0, lsl r0

0000b6c0 <_ZL17MaxFilenameLength>:
    b6c0:	00000010 	andeq	r0, r0, r0, lsl r0

0000b6c4 <_ZL13MaxPathLength>:
    b6c4:	00000080 	andeq	r0, r0, r0, lsl #1

0000b6c8 <_ZL18NoFilesystemDriver>:
    b6c8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000b6cc <_ZL9NotifyAll>:
    b6cc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000b6d0 <_ZL24Max_Process_Opened_Files>:
    b6d0:	00000010 	andeq	r0, r0, r0, lsl r0

0000b6d4 <_ZL10Indefinite>:
    b6d4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000b6d8 <_ZL18Deadline_Unchanged>:
    b6d8:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

0000b6dc <_ZL14Invalid_Handle>:
    b6dc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

Disassembly of section .data:

0000b6e0 <__CTOR_LIST__>:
__DTOR_END__():
    b6e0:	bf800000 	svclt	0x00800000

Disassembly of section .bss:

0000b6e4 <gens_needed>:
__bss_start():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:27
uint32_t gens_needed;
    b6e4:	00000000 	andeq	r0, r0, r0

0000b6e8 <gen_index>:
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:28
uint32_t gen_index = 0;
    b6e8:	00000000 	andeq	r0, r0, r0

0000b6ec <step_time>:
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:30
int step_time = 0;
    b6ec:	00000000 	andeq	r0, r0, r0

0000b6f0 <pred_time>:
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:31
int pred_time = 0;
    b6f0:	00000000 	andeq	r0, r0, r0

0000b6f4 <gens>:
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:33
Generation *gens;
    b6f4:	00000000 	andeq	r0, r0, r0

0000b6f8 <values_buffer>:
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:35
float *values_buffer;
    b6f8:	00000000 	andeq	r0, r0, r0

0000b6fc <values_counter>:
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/semestral_task/main.cpp:36
uint32_t values_counter = 0;
    b6fc:	00000000 	andeq	r0, r0, r0

0000b700 <rnd>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x1682118>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x36d10>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3a924>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c5610>
   4:	6c412820 	mcrrvs	8, 2, r2, r1, cr0
   8:	656e6970 	strbvs	r6, [lr, #-2416]!	; 0xfffff690
   c:	6e694c20 	cdpvs	12, 6, cr4, cr9, cr0, {1}
  10:	20297875 	eorcs	r7, r9, r5, ror r8
  14:	332e3031 			; <UNDEFINED> instruction: 0x332e3031
  18:	Address 0x0000000000000018 is out of bounds.


Disassembly of section .debug_line:

00000000 <.debug_line>:
       0:	00000078 	andeq	r0, r0, r8, ror r0
       4:	00620003 	rsbeq	r0, r2, r3
       8:	01020000 	mrseq	r0, (UNDEF: 2)
       c:	000d0efb 	strdeq	r0, [sp], -fp
      10:	01010101 	tsteq	r1, r1, lsl #2
      14:	01000000 	mrseq	r0, (UNDEF: 0)
      18:	2f010000 	svccs	0x00010000
      1c:	2f746e6d 	svccs	0x00746e6d
      20:	73752f63 	cmnvc	r5, #396	; 0x18c
      24:	702f7265 	eorvc	r7, pc, r5, ror #4
      28:	61766972 	cmnvs	r6, r2, ror r9
      2c:	6f576574 	svcvs	0x00576574
      30:	70736b72 	rsbsvc	r6, r3, r2, ror fp
      34:	2f656361 	svccs	0x00656361
      38:	6f686353 	svcvs	0x00686353
      3c:	4f2f6c6f 	svcmi	0x002f6c6f
      40:	50532f53 	subspl	r2, r3, r3, asr pc
      44:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
      48:	4f54522d 	svcmi	0x0054522d
      4c:	6f732f53 	svcvs	0x00732f53
      50:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
      54:	73752f73 	cmnvc	r5, #460	; 0x1cc
      58:	70737265 	rsbsvc	r7, r3, r5, ror #4
      5c:	00656361 	rsbeq	r6, r5, r1, ror #6
      60:	74726300 	ldrbtvc	r6, [r2], #-768	; 0xfffffd00
      64:	00732e30 	rsbseq	r2, r3, r0, lsr lr
      68:	00000001 	andeq	r0, r0, r1
      6c:	00020500 	andeq	r0, r2, r0, lsl #10
      70:	03000080 	movweq	r0, #128	; 0x80
      74:	02310109 	eorseq	r0, r1, #1073741826	; 0x40000002
      78:	01010002 	tsteq	r1, r2
      7c:	000000a7 	andeq	r0, r0, r7, lsr #1
      80:	00620003 	rsbeq	r0, r2, r3
      84:	01020000 	mrseq	r0, (UNDEF: 2)
      88:	000d0efb 	strdeq	r0, [sp], -fp
      8c:	01010101 	tsteq	r1, r1, lsl #2
      90:	01000000 	mrseq	r0, (UNDEF: 0)
      94:	2f010000 	svccs	0x00010000
      98:	2f746e6d 	svccs	0x00746e6d
      9c:	73752f63 	cmnvc	r5, #396	; 0x18c
      a0:	702f7265 	eorvc	r7, pc, r5, ror #4
      a4:	61766972 	cmnvs	r6, r2, ror r9
      a8:	6f576574 	svcvs	0x00576574
      ac:	70736b72 	rsbsvc	r6, r3, r2, ror fp
      b0:	2f656361 	svccs	0x00656361
      b4:	6f686353 	svcvs	0x00686353
      b8:	4f2f6c6f 	svcmi	0x002f6c6f
      bc:	50532f53 	subspl	r2, r3, r3, asr pc
      c0:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
      c4:	4f54522d 	svcmi	0x0054522d
      c8:	6f732f53 	svcvs	0x00732f53
      cc:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
      d0:	73752f73 	cmnvc	r5, #460	; 0x1cc
      d4:	70737265 	rsbsvc	r7, r3, r5, ror #4
      d8:	00656361 	rsbeq	r6, r5, r1, ror #6
      dc:	74726300 	ldrbtvc	r6, [r2], #-768	; 0xfffffd00
      e0:	00632e30 	rsbeq	r2, r3, r0, lsr lr
      e4:	00000001 	andeq	r0, r0, r1
      e8:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
      ec:	00800802 	addeq	r0, r0, r2, lsl #16
      f0:	01090300 	mrseq	r0, (UNDEF: 57)
      f4:	05671805 	strbeq	r1, [r7, #-2053]!	; 0xfffff7fb
      f8:	0e054a05 	vmlaeq.f32	s8, s10, s10
      fc:	03040200 	movweq	r0, #16896	; 0x4200
     100:	0041052f 	subeq	r0, r1, pc, lsr #10
     104:	65030402 	strvs	r0, [r3, #-1026]	; 0xfffffbfe
     108:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
     10c:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
     110:	05d98401 	ldrbeq	r8, [r9, #1025]	; 0x401
     114:	05316805 	ldreq	r6, [r1, #-2053]!	; 0xfffff7fb
     118:	05053312 	streq	r3, [r5, #-786]	; 0xfffffcee
     11c:	054b3185 	strbeq	r3, [fp, #-389]	; 0xfffffe7b
     120:	06022f01 	streq	r2, [r2], -r1, lsl #30
     124:	fd010100 	stc2	1, cr0, [r1, #-0]
     128:	03000000 	movweq	r0, #0
     12c:	00007400 	andeq	r7, r0, r0, lsl #8
     130:	fb010200 	blx	4093a <__bss_end+0x35226>
     134:	01000d0e 	tsteq	r0, lr, lsl #26
     138:	00010101 	andeq	r0, r1, r1, lsl #2
     13c:	00010000 	andeq	r0, r1, r0
     140:	6d2f0100 	stfvss	f0, [pc, #-0]	; 148 <_start-0x7eb8>
     144:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
     148:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     14c:	72702f72 	rsbsvc	r2, r0, #456	; 0x1c8
     150:	74617669 	strbtvc	r7, [r1], #-1641	; 0xfffff997
     154:	726f5765 	rsbvc	r5, pc, #26476544	; 0x1940000
     158:	6170736b 	cmnvs	r0, fp, ror #6
     15c:	532f6563 			; <UNDEFINED> instruction: 0x532f6563
     160:	6f6f6863 	svcvs	0x006f6863
     164:	534f2f6c 	movtpl	r2, #65388	; 0xff6c
     168:	2f50532f 	svccs	0x0050532f
     16c:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
     170:	534f5452 	movtpl	r5, #62546	; 0xf452
     174:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffe4d <__bss_end+0xffff4739>
     178:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     17c:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     180:	61707372 	cmnvs	r0, r2, ror r3
     184:	00006563 	andeq	r6, r0, r3, ror #10
     188:	61787863 	cmnvs	r8, r3, ror #16
     18c:	632e6962 			; <UNDEFINED> instruction: 0x632e6962
     190:	01007070 	tsteq	r0, r0, ror r0
     194:	623c0000 	eorsvs	r0, ip, #0
     198:	746c6975 	strbtvc	r6, [ip], #-2421	; 0xfffff68b
     19c:	3e6e692d 	vmulcc.f16	s13, s28, s27	; <UNPREDICTABLE>
     1a0:	00000000 	andeq	r0, r0, r0
     1a4:	00020500 	andeq	r0, r2, r0, lsl #10
     1a8:	80a40205 	adchi	r0, r4, r5, lsl #4
     1ac:	0a030000 	beq	c01b4 <__bss_end+0xb4aa0>
     1b0:	830b0501 	movwhi	r0, #46337	; 0xb501
     1b4:	054a0a05 	strbeq	r0, [sl, #-2565]	; 0xfffff5fb
     1b8:	05858302 	streq	r8, [r5, #770]	; 0x302
     1bc:	0205830e 	andeq	r8, r5, #939524096	; 0x38000000
     1c0:	05848567 	streq	r8, [r4, #1383]	; 0x567
     1c4:	854c8601 	strbhi	r8, [ip, #-1537]	; 0xfffff9ff
     1c8:	854c854c 	strbhi	r8, [ip, #-1356]	; 0xfffffab4
     1cc:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
     1d0:	054b0104 	strbeq	r0, [fp, #-260]	; 0xfffffefc
     1d4:	2e120301 	cdpcs	3, 1, cr0, cr2, cr1, {0}
     1d8:	056b0d05 	strbeq	r0, [fp, #-3333]!	; 0xfffff2fb
     1dc:	04020024 	streq	r0, [r2], #-36	; 0xffffffdc
     1e0:	04054a03 	streq	r4, [r5], #-2563	; 0xfffff5fd
     1e4:	02040200 	andeq	r0, r4, #0, 4
     1e8:	000b0583 	andeq	r0, fp, r3, lsl #11
     1ec:	4a020402 	bmi	811fc <__bss_end+0x75ae8>
     1f0:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
     1f4:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
     1f8:	01058509 	tsteq	r5, r9, lsl #10
     1fc:	0d05a12f 	stfeqd	f2, [r5, #-188]	; 0xffffff44
     200:	0024056a 	eoreq	r0, r4, sl, ror #10
     204:	4a030402 	bmi	c1214 <__bss_end+0xb5b00>
     208:	02000405 	andeq	r0, r0, #83886080	; 0x5000000
     20c:	05830204 	streq	r0, [r3, #516]	; 0x204
     210:	0402000b 	streq	r0, [r2], #-11
     214:	02054a02 	andeq	r4, r5, #8192	; 0x2000
     218:	02040200 	andeq	r0, r4, #0, 4
     21c:	8509052d 	strhi	r0, [r9, #-1325]	; 0xfffffad3
     220:	022f0105 	eoreq	r0, pc, #1073741825	; 0x40000001
     224:	0101000a 	tsteq	r1, sl
     228:	000005b2 			; <UNDEFINED> instruction: 0x000005b2
     22c:	037f0003 	cmneq	pc, #3
     230:	01020000 	mrseq	r0, (UNDEF: 2)
     234:	000d0efb 	strdeq	r0, [sp], -fp
     238:	01010101 	tsteq	r1, r1, lsl #2
     23c:	01000000 	mrseq	r0, (UNDEF: 0)
     240:	2f010000 	svccs	0x00010000
     244:	2f746e6d 	svccs	0x00746e6d
     248:	73752f63 	cmnvc	r5, #396	; 0x18c
     24c:	702f7265 	eorvc	r7, pc, r5, ror #4
     250:	61766972 	cmnvs	r6, r2, ror r9
     254:	6f576574 	svcvs	0x00576574
     258:	70736b72 	rsbsvc	r6, r3, r2, ror fp
     25c:	2f656361 	svccs	0x00656361
     260:	6f686353 	svcvs	0x00686353
     264:	4f2f6c6f 	svcmi	0x002f6c6f
     268:	50532f53 	subspl	r2, r3, r3, asr pc
     26c:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
     270:	4f54522d 	svcmi	0x0054522d
     274:	6f732f53 	svcvs	0x00732f53
     278:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     27c:	73752f73 	cmnvc	r5, #460	; 0x1cc
     280:	70737265 	rsbsvc	r7, r3, r5, ror #4
     284:	2f656361 	svccs	0x00656361
     288:	656d6573 	strbvs	r6, [sp, #-1395]!	; 0xfffffa8d
     28c:	61727473 	cmnvs	r2, r3, ror r4
     290:	61745f6c 	cmnvs	r4, ip, ror #30
     294:	2f006b73 	svccs	0x00006b73
     298:	2f746e6d 	svccs	0x00746e6d
     29c:	73752f63 	cmnvc	r5, #396	; 0x18c
     2a0:	702f7265 	eorvc	r7, pc, r5, ror #4
     2a4:	61766972 	cmnvs	r6, r2, ror r9
     2a8:	6f576574 	svcvs	0x00576574
     2ac:	70736b72 	rsbsvc	r6, r3, r2, ror fp
     2b0:	2f656361 	svccs	0x00656361
     2b4:	6f686353 	svcvs	0x00686353
     2b8:	4f2f6c6f 	svcmi	0x002f6c6f
     2bc:	50532f53 	subspl	r2, r3, r3, asr pc
     2c0:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
     2c4:	4f54522d 	svcmi	0x0054522d
     2c8:	6f732f53 	svcvs	0x00732f53
     2cc:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     2d0:	73752f73 	cmnvc	r5, #460	; 0x1cc
     2d4:	70737265 	rsbsvc	r7, r3, r5, ror #4
     2d8:	2f656361 	svccs	0x00656361
     2dc:	6b2f2e2e 	blvs	bcbb9c <__bss_end+0xbc0488>
     2e0:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     2e4:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
     2e8:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     2ec:	6f622f65 	svcvs	0x00622f65
     2f0:	2f647261 	svccs	0x00647261
     2f4:	30697072 	rsbcc	r7, r9, r2, ror r0
     2f8:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
     2fc:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
     300:	2f632f74 	svccs	0x00632f74
     304:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     308:	6972702f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, ip, sp, lr}^
     30c:	65746176 	ldrbvs	r6, [r4, #-374]!	; 0xfffffe8a
     310:	6b726f57 	blvs	1c9c074 <__bss_end+0x1c90960>
     314:	63617073 	cmnvs	r1, #115	; 0x73
     318:	63532f65 	cmpvs	r3, #404	; 0x194
     31c:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 184 <_start-0x7e7c>
     320:	2f534f2f 	svccs	0x00534f2f
     324:	4b2f5053 	blmi	bd4478 <__bss_end+0xbc8d64>
     328:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
     32c:	2f534f54 	svccs	0x00534f54
     330:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     334:	2f736563 	svccs	0x00736563
     338:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     33c:	63617073 	cmnvs	r1, #115	; 0x73
     340:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
     344:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     348:	2f6c656e 	svccs	0x006c656e
     34c:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     350:	2f656475 	svccs	0x00656475
     354:	636f7270 	cmnvs	pc, #112, 4
     358:	00737365 	rsbseq	r7, r3, r5, ror #6
     35c:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
     360:	752f632f 	strvc	r6, [pc, #-815]!	; 39 <_start-0x7fc7>
     364:	2f726573 	svccs	0x00726573
     368:	76697270 			; <UNDEFINED> instruction: 0x76697270
     36c:	57657461 	strbpl	r7, [r5, -r1, ror #8]!
     370:	736b726f 	cmnvc	fp, #-268435450	; 0xf0000006
     374:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     378:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
     37c:	2f6c6f6f 	svccs	0x006c6f6f
     380:	532f534f 			; <UNDEFINED> instruction: 0x532f534f
     384:	494b2f50 	stmdbmi	fp, {r4, r6, r8, r9, sl, fp, sp}^
     388:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
     38c:	732f534f 			; <UNDEFINED> instruction: 0x732f534f
     390:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     394:	752f7365 	strvc	r7, [pc, #-869]!	; 37 <_start-0x7fc9>
     398:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     39c:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     3a0:	2f2e2e2f 	svccs	0x002e2e2f
     3a4:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     3a8:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     3ac:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     3b0:	662f6564 	strtvs	r6, [pc], -r4, ror #10
     3b4:	6d2f0073 	stcvs	0, cr0, [pc, #-460]!	; 1f0 <_start-0x7e10>
     3b8:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
     3bc:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     3c0:	72702f72 	rsbsvc	r2, r0, #456	; 0x1c8
     3c4:	74617669 	strbtvc	r7, [r1], #-1641	; 0xfffff997
     3c8:	726f5765 	rsbvc	r5, pc, #26476544	; 0x1940000
     3cc:	6170736b 	cmnvs	r0, fp, ror #6
     3d0:	532f6563 			; <UNDEFINED> instruction: 0x532f6563
     3d4:	6f6f6863 	svcvs	0x006f6863
     3d8:	534f2f6c 	movtpl	r2, #65388	; 0xff6c
     3dc:	2f50532f 	svccs	0x0050532f
     3e0:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
     3e4:	534f5452 	movtpl	r5, #62546	; 0xf452
     3e8:	756f732f 	strbvc	r7, [pc, #-815]!	; c1 <_start-0x7f3f>
     3ec:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     3f0:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     3f4:	61707372 	cmnvs	r0, r2, ror r3
     3f8:	2e2f6563 	cfsh64cs	mvdx6, mvdx15, #51
     3fc:	74732f2e 	ldrbtvc	r2, [r3], #-3886	; 0xfffff0d2
     400:	69747564 	ldmdbvs	r4!, {r2, r5, r6, r8, sl, ip, sp, lr}^
     404:	692f736c 	stmdbvs	pc!, {r2, r3, r5, r6, r8, r9, ip, sp, lr}	; <UNPREDICTABLE>
     408:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     40c:	2f006564 	svccs	0x00006564
     410:	2f746e6d 	svccs	0x00746e6d
     414:	73752f63 	cmnvc	r5, #396	; 0x18c
     418:	702f7265 	eorvc	r7, pc, r5, ror #4
     41c:	61766972 	cmnvs	r6, r2, ror r9
     420:	6f576574 	svcvs	0x00576574
     424:	70736b72 	rsbsvc	r6, r3, r2, ror fp
     428:	2f656361 	svccs	0x00656361
     42c:	6f686353 	svcvs	0x00686353
     430:	4f2f6c6f 	svcmi	0x002f6c6f
     434:	50532f53 	subspl	r2, r3, r3, asr pc
     438:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
     43c:	4f54522d 	svcmi	0x0054522d
     440:	6f732f53 	svcvs	0x00732f53
     444:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     448:	73752f73 	cmnvc	r5, #460	; 0x1cc
     44c:	70737265 	rsbsvc	r7, r3, r5, ror #4
     450:	2f656361 	svccs	0x00656361
     454:	656d6573 	strbvs	r6, [sp, #-1395]!	; 0xfffffa8d
     458:	61727473 	cmnvs	r2, r3, ror r4
     45c:	61745f6c 	cmnvs	r4, ip, ror #30
     460:	692f6b73 	stmdbvs	pc!, {r0, r1, r4, r5, r6, r8, r9, fp, sp, lr}	; <UNPREDICTABLE>
     464:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     468:	652f6564 	strvs	r6, [pc, #-1380]!	; ffffff0c <__bss_end+0xffff47f8>
     46c:	756c6f76 	strbvc	r6, [ip, #-3958]!	; 0xfffff08a
     470:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     474:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
     478:	2f632f74 	svccs	0x00632f74
     47c:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     480:	6972702f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, ip, sp, lr}^
     484:	65746176 	ldrbvs	r6, [r4, #-374]!	; 0xfffffe8a
     488:	6b726f57 	blvs	1c9c1ec <__bss_end+0x1c90ad8>
     48c:	63617073 	cmnvs	r1, #115	; 0x73
     490:	63532f65 	cmpvs	r3, #404	; 0x194
     494:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 2fc <_start-0x7d04>
     498:	2f534f2f 	svccs	0x00534f2f
     49c:	4b2f5053 	blmi	bd45f0 <__bss_end+0xbc8edc>
     4a0:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
     4a4:	2f534f54 	svccs	0x00534f54
     4a8:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     4ac:	2f736563 	svccs	0x00736563
     4b0:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     4b4:	63617073 	cmnvs	r1, #115	; 0x73
     4b8:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
     4bc:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     4c0:	2f6c656e 	svccs	0x006c656e
     4c4:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     4c8:	2f656475 	svccs	0x00656475
     4cc:	76697264 	strbtvc	r7, [r9], -r4, ror #4
     4d0:	2f737265 	svccs	0x00737265
     4d4:	64697262 	strbtvs	r7, [r9], #-610	; 0xfffffd9e
     4d8:	00736567 	rsbseq	r6, r3, r7, ror #10
     4dc:	69616d00 	stmdbvs	r1!, {r8, sl, fp, sp, lr}^
     4e0:	70632e6e 	rsbvc	r2, r3, lr, ror #28
     4e4:	00010070 	andeq	r0, r1, r0, ror r0
     4e8:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
     4ec:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
     4f0:	00020068 	andeq	r0, r2, r8, rrx
     4f4:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
     4f8:	0300682e 	movweq	r6, #2094	; 0x82e
     4fc:	70730000 	rsbsvc	r0, r3, r0
     500:	6f6c6e69 	svcvs	0x006c6e69
     504:	682e6b63 	stmdavs	lr!, {r0, r1, r5, r6, r8, r9, fp, sp, lr}
     508:	00000300 	andeq	r0, r0, r0, lsl #6
     50c:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     510:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     514:	682e6d65 	stmdavs	lr!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
     518:	00000400 	andeq	r0, r0, r0, lsl #8
     51c:	636f7270 	cmnvs	pc, #112, 4
     520:	2e737365 	cdpcs	3, 7, cr7, cr3, cr5, {3}
     524:	00030068 	andeq	r0, r3, r8, rrx
     528:	6f727000 	svcvs	0x00727000
     52c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     530:	6e616d5f 	mcrvs	13, 3, r6, cr1, cr15, {2}
     534:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     538:	0300682e 	movweq	r6, #2094	; 0x82e
     53c:	69630000 	stmdbvs	r3!, {}^	; <UNPREDICTABLE>
     540:	6c756372 	ldclvs	3, cr6, [r5], #-456	; 0xfffffe38
     544:	625f7261 	subsvs	r7, pc, #268435462	; 0x10000006
     548:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
     54c:	00682e72 	rsbeq	r2, r8, r2, ror lr
     550:	72000005 	andvc	r0, r0, #5
     554:	5f646165 	svcpl	0x00646165
     558:	6c697475 	cfstrdvs	mvd7, [r9], #-468	; 0xfffffe2c
     55c:	00682e73 	rsbeq	r2, r8, r3, ror lr
     560:	72000005 	andvc	r0, r0, #5
     564:	675f646e 	ldrbvs	r6, [pc, -lr, ror #8]
     568:	72656e65 	rsbvc	r6, r5, #1616	; 0x650
     56c:	726f7461 	rsbvc	r7, pc, #1627389952	; 0x61000000
     570:	0500682e 	streq	r6, [r0, #-2094]	; 0xfffff7d2
     574:	6f6d0000 	svcvs	0x006d0000
     578:	2e6c6564 	cdpcs	5, 6, cr6, cr12, cr4, {3}
     57c:	00060068 	andeq	r0, r6, r8, rrx
     580:	72686300 	rsbvc	r6, r8, #0, 6
     584:	736f6d6f 	cmnvc	pc, #7104	; 0x1bc0
     588:	2e656d6f 	cdpcs	13, 6, cr6, cr5, cr15, {3}
     58c:	00060068 	andeq	r0, r6, r8, rrx
     590:	6e656700 	cdpvs	7, 6, cr6, cr5, cr0, {0}
     594:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
     598:	2e6e6f69 	cdpcs	15, 6, cr6, cr14, cr9, {3}
     59c:	00060068 	andeq	r0, r6, r8, rrx
     5a0:	72617500 	rsbvc	r7, r1, #0, 10
     5a4:	65645f74 	strbvs	r5, [r4, #-3956]!	; 0xfffff08c
     5a8:	682e7366 	stmdavs	lr!, {r1, r2, r5, r6, r8, r9, ip, sp, lr}
     5ac:	00000700 	andeq	r0, r0, r0, lsl #14
     5b0:	00160500 	andseq	r0, r6, r0, lsl #10
     5b4:	82300205 	eorshi	r0, r0, #1342177280	; 0x50000000
     5b8:	2b030000 	blcs	c05c0 <__bss_end+0xb4eac>
     5bc:	671b0501 	ldrvs	r0, [fp, -r1, lsl #10]
     5c0:	05851305 	streq	r1, [r5, #773]	; 0x305
     5c4:	07054b15 	smladeq	r5, r5, fp, r4
     5c8:	a118054b 	tstge	r8, fp, asr #10
     5cc:	054b0705 	strbeq	r0, [fp, #-1797]	; 0xfffff8fb
     5d0:	0105a009 	tsteq	r5, r9
     5d4:	a05f052f 	subsge	r0, pc, pc, lsr #10
     5d8:	05d70605 	ldrbeq	r0, [r7, #1541]	; 0x605
     5dc:	08054e12 	stmdaeq	r5, {r1, r4, r9, sl, fp, lr}
     5e0:	682e0567 	stmdavs	lr!, {r0, r1, r2, r5, r6, r8, sl}
     5e4:	83bb0805 			; <UNDEFINED> instruction: 0x83bb0805
     5e8:	05841205 	streq	r1, [r4, #517]	; 0x205
     5ec:	08056803 	stmdaeq	r5, {r0, r1, fp, sp, lr}
     5f0:	a00a0567 	andge	r0, sl, r7, ror #10
     5f4:	9f838383 	svcls	0x00838383
     5f8:	020585a0 	andeq	r8, r5, #160, 10	; 0x28000000
     5fc:	05826b03 	streq	r6, [r2, #2819]	; 0xb03
     600:	2e180309 	cdpcs	3, 1, cr0, cr8, cr9, {0}
     604:	052f0105 	streq	r0, [pc, #-261]!	; 507 <_start-0x7af9>
     608:	0b05f438 	bleq	17d6f0 <__bss_end+0x171fdc>
     60c:	8202059f 	andhi	r0, r2, #666894336	; 0x27c00000
     610:	674b0a05 	strbvs	r0, [fp, -r5, lsl #20]
     614:	054d0d05 	strbeq	r0, [sp, #-3333]	; 0xfffff2fb
     618:	01056614 	tsteq	r5, r4, lsl r6
     61c:	a04e052f 	subge	r0, lr, pc, lsr #10
     620:	05bb1505 	ldreq	r1, [fp, #1285]!	; 0x505
     624:	5405bb01 	strpl	fp, [r5], #-2817	; 0xfffff4ff
     628:	bb150584 	bllt	541c40 <__bss_end+0x53652c>
     62c:	05bb0105 	ldreq	r0, [fp, #261]!	; 0x105
     630:	0d058930 	vstreq.16	s16, [r5, #-96]	; 0xffffffa0	; <UNPREDICTABLE>
     634:	f23e05a0 	vrshl.s64	d0, d16, d30
     638:	05820205 	streq	r0, [r2, #517]	; 0x205
     63c:	2a054e17 	bcs	153ea0 <__bss_end+0x14878c>
     640:	a0090566 	andge	r0, r9, r6, ror #10
     644:	05830705 	streq	r0, [r3, #1797]	; 0x705
     648:	08059f09 	stmdaeq	r5, {r0, r3, r8, r9, sl, fp, ip, pc}
     64c:	8409059f 	strhi	r0, [r9], #-1439	; 0xfffffa61
     650:	05830705 	streq	r0, [r3, #1797]	; 0x705
     654:	08059f09 	stmdaeq	r5, {r0, r3, r8, r9, sl, fp, ip, pc}
     658:	8409059f 	strhi	r0, [r9], #-1439	; 0xfffffa61
     65c:	05830705 	streq	r0, [r3, #1797]	; 0x705
     660:	08059f09 	stmdaeq	r5, {r0, r3, r8, r9, sl, fp, ip, pc}
     664:	8409059f 	strhi	r0, [r9], #-1439	; 0xfffffa61
     668:	05830705 	streq	r0, [r3, #1797]	; 0x705
     66c:	08059f09 	stmdaeq	r5, {r0, r3, r8, r9, sl, fp, ip, pc}
     670:	8409059f 	strhi	r0, [r9], #-1439	; 0xfffffa61
     674:	05830705 	streq	r0, [r3, #1797]	; 0x705
     678:	0a059f09 	beq	1682a4 <__bss_end+0x15cb90>
     67c:	0d0583a0 	stceq	3, cr8, [r5, #-640]	; 0xfffffd80
     680:	f23a054e 	vrshl.s64	q0, q7, q5
     684:	05820205 	streq	r0, [r2, #517]	; 0x205
     688:	09054b0a 	stmdbeq	r5, {r1, r3, r8, r9, fp, lr}
     68c:	0001054e 	andeq	r0, r1, lr, asr #10
     690:	2f010402 	svccs	0x00010402
     694:	5b085505 	blpl	215ab0 <__bss_end+0x20a39c>
     698:	4bd70705 	blmi	ff5c22b4 <__bss_end+0xff5b6ba0>
     69c:	054c1505 	strbeq	r1, [ip, #-1285]	; 0xfffffafb
     6a0:	0a058202 	beq	160eb0 <__bss_end+0x15579c>
     6a4:	4805844b 	stmdami	r5, {r0, r1, r3, r6, sl, pc}
     6a8:	4a2c0569 	bmi	b01c54 <__bss_end+0xaf6540>
     6ac:	059e3b05 	ldreq	r3, [lr, #2821]	; 0xb05
     6b0:	0905ba48 	stmdbeq	r5, {r3, r6, r9, fp, ip, sp, pc}
     6b4:	4d0b054a 	cfstr32mi	mvfx0, [fp, #-296]	; 0xfffffed8
     6b8:	3e080c05 	cdpcc	12, 0, cr0, cr8, cr5, {0}
     6bc:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
     6c0:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     6c4:	04056908 	streq	r6, [r5], #-2312	; 0xfffff6f8
     6c8:	4b190566 	blmi	641c68 <__bss_end+0x636554>
     6cc:	23081f05 	movwcs	r1, #36613	; 0x8f05
     6d0:	054a3305 	strbeq	r3, [sl, #-773]	; 0xfffffcfb
     6d4:	05056709 	streq	r6, [r5, #-1801]	; 0xfffff8f7
     6d8:	002d054a 	eoreq	r0, sp, sl, asr #10
     6dc:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
     6e0:	02002a05 	andeq	r2, r0, #20480	; 0x5000
     6e4:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     6e8:	1405830d 	strne	r8, [r5], #-781	; 0xfffffcf3
     6ec:	68160567 	ldmdavs	r6, {r0, r1, r2, r5, r6, r8, sl}
     6f0:	05f30e05 	ldrbeq	r0, [r3, #3589]!	; 0xe05
     6f4:	05240816 	streq	r0, [r4, #-2070]!	; 0xfffff7ea
     6f8:	0402001f 	streq	r0, [r2], #-31	; 0xffffffe1
     6fc:	04054a03 	streq	r4, [r5], #-2563	; 0xfffff5fd
     700:	02040200 	andeq	r0, r4, #0, 4
     704:	872f05f2 			; <UNDEFINED> instruction: 0x872f05f2
     708:	05bb0405 	ldreq	r0, [fp, #1029]!	; 0x405
     70c:	05056724 	streq	r6, [r5, #-1828]	; 0xfffff8dc
     710:	673a0583 	ldrvs	r0, [sl, -r3, lsl #11]!
     714:	05822a05 	streq	r2, [r2, #2565]	; 0xa05
     718:	0d054e05 	stceq	14, cr4, [r5, #-20]	; 0xffffffec
     71c:	670e0568 	strvs	r0, [lr, -r8, ror #10]
     720:	3d081705 	stccc	7, cr1, [r8, #-20]	; 0xffffffec
     724:	054b0605 	strbeq	r0, [fp, #-1541]	; 0xfffff9fb
     728:	04020003 	streq	r0, [r2], #-3
     72c:	2e5d0302 	cdpcs	3, 5, cr0, cr13, cr2, {0}
     730:	29030705 	stmdbcs	r3, {r0, r2, r8, r9, sl}
     734:	66030582 	strvs	r0, [r3], -r2, lsl #11
     738:	054c1405 	strbeq	r1, [ip, #-1029]	; 0xfffffbfb
     73c:	18054a0c 	stmdane	r5, {r2, r3, r9, fp, lr}
     740:	082505f5 	stmdaeq	r5!, {r0, r2, r4, r5, r6, r7, r8, sl}
     744:	08160540 	ldmdaeq	r6, {r6, r8, sl}
     748:	862c053f 			; <UNDEFINED> instruction: 0x862c053f
     74c:	054a1f05 	strbeq	r1, [sl, #-3845]	; 0xfffff0fb
     750:	2e05f22c 	cdpcs	2, 0, cr15, cr5, cr12, {1}
     754:	4b10054a 	blmi	401c84 <__bss_end+0x3f6570>
     758:	029f0105 	addseq	r0, pc, #1073741825	; 0x40000001
     75c:	0d051528 	cfstr32eq	mvfx1, [r5, #-160]	; 0xffffff60
     760:	6907059f 	stmdbvs	r7, {r0, r1, r2, r3, r4, r7, r8, sl}
     764:	05842005 	streq	r2, [r4, #5]
     768:	09054b13 	stmdbeq	r5, {r0, r1, r4, r8, r9, fp, lr}
     76c:	676767d9 			; <UNDEFINED> instruction: 0x676767d9
     770:	05691c05 	strbeq	r1, [r9, #-3077]!	; 0xfffff3fb
     774:	2205ba0c 	andcs	fp, r5, #12, 20	; 0xc000
     778:	ba0c054b 	blt	301cac <__bss_end+0x2f6598>
     77c:	054d1b05 	strbeq	r1, [sp, #-2821]	; 0xfffff4fb
     780:	05200836 	streq	r0, [r0, #-2102]!	; 0xfffff7ca
     784:	2805f243 	stmdacs	r5, {r0, r1, r6, r9, ip, sp, lr, pc}
     788:	4a0e0582 	bmi	381d98 <__bss_end+0x376684>
     78c:	054b2d05 	strbeq	r2, [fp, #-3333]	; 0xfffff2fb
     790:	31056607 	tstcc	r5, r7, lsl #12
     794:	ba10054b 	blt	401cc8 <__bss_end+0x3f65b4>
     798:	054d1505 	strbeq	r1, [sp, #-1285]	; 0xfffffafb
     79c:	0305a42b 	movweq	sl, #21547	; 0x542b
     7a0:	0010054a 	andseq	r0, r0, sl, asr #10
     7a4:	83010402 	movwhi	r0, #5122	; 0x1402
     7a8:	02002805 	andeq	r2, r0, #327680	; 0x50000
     7ac:	05f30104 	ldrbeq	r0, [r3, #260]!	; 0x104
     7b0:	04020004 	streq	r0, [r2], #-4
     7b4:	08056701 	stmdaeq	r5, {r0, r8, r9, sl, sp, lr}
     7b8:	2d056732 	stccs	7, cr6, [r5, #-200]	; 0xffffff38
     7bc:	bd140583 	cfldr32lt	mvfx0, [r4, #-524]	; 0xfffffdf4
     7c0:	059e2805 	ldreq	r2, [lr, #2053]	; 0x805
     7c4:	26058203 	strcs	r8, [r5], -r3, lsl #4
     7c8:	a004054b 	andge	r0, r4, fp, asr #10
     7cc:	059f0c05 	ldreq	r0, [pc, #3077]	; 13d9 <_start-0x6c27>
     7d0:	02058411 	andeq	r8, r5, #285212672	; 0x11000000
     7d4:	01040200 	mrseq	r0, R12_usr
     7d8:	002402bd 	strhteq	r0, [r4], -sp
     7dc:	03080101 	movweq	r0, #33025	; 0x8101
     7e0:	00030000 	andeq	r0, r3, r0
     7e4:	000001e6 	andeq	r0, r0, r6, ror #3
     7e8:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
     7ec:	0101000d 	tsteq	r1, sp
     7f0:	00000101 	andeq	r0, r0, r1, lsl #2
     7f4:	00000100 	andeq	r0, r0, r0, lsl #2
     7f8:	6e6d2f01 	cdpvs	15, 6, cr2, cr13, cr1, {0}
     7fc:	2f632f74 	svccs	0x00632f74
     800:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     804:	6972702f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, ip, sp, lr}^
     808:	65746176 	ldrbvs	r6, [r4, #-374]!	; 0xfffffe8a
     80c:	6b726f57 	blvs	1c9c570 <__bss_end+0x1c90e5c>
     810:	63617073 	cmnvs	r1, #115	; 0x73
     814:	63532f65 	cmpvs	r3, #404	; 0x194
     818:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 680 <_start-0x7980>
     81c:	2f534f2f 	svccs	0x00534f2f
     820:	4b2f5053 	blmi	bd4974 <__bss_end+0xbc9260>
     824:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
     828:	2f534f54 	svccs	0x00534f54
     82c:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     830:	2f736563 	svccs	0x00736563
     834:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     838:	63617073 	cmnvs	r1, #115	; 0x73
     83c:	65732f65 	ldrbvs	r2, [r3, #-3941]!	; 0xfffff09b
     840:	7473656d 	ldrbtvc	r6, [r3], #-1389	; 0xfffffa93
     844:	5f6c6172 	svcpl	0x006c6172
     848:	6b736174 	blvs	1cd8e20 <__bss_end+0x1ccd70c>
     84c:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     850:	6f76652f 	svcvs	0x0076652f
     854:	6974756c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sl, ip, sp, lr}^
     858:	2f006e6f 	svccs	0x00006e6f
     85c:	2f746e6d 	svccs	0x00746e6d
     860:	73752f63 	cmnvc	r5, #396	; 0x18c
     864:	702f7265 	eorvc	r7, pc, r5, ror #4
     868:	61766972 	cmnvs	r6, r2, ror r9
     86c:	6f576574 	svcvs	0x00576574
     870:	70736b72 	rsbsvc	r6, r3, r2, ror fp
     874:	2f656361 	svccs	0x00656361
     878:	6f686353 	svcvs	0x00686353
     87c:	4f2f6c6f 	svcmi	0x002f6c6f
     880:	50532f53 	subspl	r2, r3, r3, asr pc
     884:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
     888:	4f54522d 	svcmi	0x0054522d
     88c:	6f732f53 	svcvs	0x00732f53
     890:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     894:	73752f73 	cmnvc	r5, #460	; 0x1cc
     898:	70737265 	rsbsvc	r7, r3, r5, ror #4
     89c:	2f656361 	svccs	0x00656361
     8a0:	6b2f2e2e 	blvs	bcc160 <__bss_end+0xbc0a4c>
     8a4:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     8a8:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
     8ac:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     8b0:	6f622f65 	svcvs	0x00622f65
     8b4:	2f647261 	svccs	0x00647261
     8b8:	30697072 	rsbcc	r7, r9, r2, ror r0
     8bc:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
     8c0:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
     8c4:	2f632f74 	svccs	0x00632f74
     8c8:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     8cc:	6972702f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, ip, sp, lr}^
     8d0:	65746176 	ldrbvs	r6, [r4, #-374]!	; 0xfffffe8a
     8d4:	6b726f57 	blvs	1c9c638 <__bss_end+0x1c90f24>
     8d8:	63617073 	cmnvs	r1, #115	; 0x73
     8dc:	63532f65 	cmpvs	r3, #404	; 0x194
     8e0:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 748 <_start-0x78b8>
     8e4:	2f534f2f 	svccs	0x00534f2f
     8e8:	4b2f5053 	blmi	bd4a3c <__bss_end+0xbc9328>
     8ec:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
     8f0:	2f534f54 	svccs	0x00534f54
     8f4:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     8f8:	2f736563 	svccs	0x00736563
     8fc:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     900:	63617073 	cmnvs	r1, #115	; 0x73
     904:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
     908:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
     90c:	6c697475 	cfstrdvs	mvd7, [r9], #-468	; 0xfffffe2c
     910:	6e692f73 	mcrvs	15, 3, r2, cr9, cr3, {3}
     914:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     918:	6d2f0065 	stcvs	0, cr0, [pc, #-404]!	; 78c <_start-0x7874>
     91c:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
     920:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     924:	72702f72 	rsbsvc	r2, r0, #456	; 0x1c8
     928:	74617669 	strbtvc	r7, [r1], #-1641	; 0xfffff997
     92c:	726f5765 	rsbvc	r5, pc, #26476544	; 0x1940000
     930:	6170736b 	cmnvs	r0, fp, ror #6
     934:	532f6563 			; <UNDEFINED> instruction: 0x532f6563
     938:	6f6f6863 	svcvs	0x006f6863
     93c:	534f2f6c 	movtpl	r2, #65388	; 0xff6c
     940:	2f50532f 	svccs	0x0050532f
     944:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
     948:	534f5452 	movtpl	r5, #62546	; 0xf452
     94c:	756f732f 	strbvc	r7, [pc, #-815]!	; 625 <_start-0x79db>
     950:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     954:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     958:	61707372 	cmnvs	r0, r2, ror r3
     95c:	732f6563 			; <UNDEFINED> instruction: 0x732f6563
     960:	73656d65 	cmnvc	r5, #6464	; 0x1940
     964:	6c617274 	sfmvs	f7, 2, [r1], #-464	; 0xfffffe30
     968:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     96c:	6e692f6b 	cdpvs	15, 6, cr2, cr9, cr11, {3}
     970:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     974:	76652f65 	strbtvc	r2, [r5], -r5, ror #30
     978:	74756c6f 	ldrbtvc	r6, [r5], #-3183	; 0xfffff391
     97c:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     980:	72686300 	rsbvc	r6, r8, #0, 6
     984:	736f6d6f 	cmnvc	pc, #7104	; 0x1bc0
     988:	2e656d6f 	cdpcs	13, 6, cr6, cr5, cr15, {3}
     98c:	00707063 	rsbseq	r7, r0, r3, rrx
     990:	69000001 	stmdbvs	r0, {r0}
     994:	6564746e 	strbvs	r7, [r4, #-1134]!	; 0xfffffb92
     998:	00682e66 	rsbeq	r2, r8, r6, ror #28
     99c:	72000002 	andvc	r0, r0, #2
     9a0:	675f646e 	ldrbvs	r6, [pc, -lr, ror #8]
     9a4:	72656e65 	rsbvc	r6, r5, #1616	; 0x650
     9a8:	726f7461 	rsbvc	r7, pc, #1627389952	; 0x61000000
     9ac:	0300682e 	movweq	r6, #2094	; 0x82e
     9b0:	6f6d0000 	svcvs	0x006d0000
     9b4:	2e6c6564 	cdpcs	5, 6, cr6, cr12, cr4, {3}
     9b8:	00040068 	andeq	r0, r4, r8, rrx
     9bc:	72686300 	rsbvc	r6, r8, #0, 6
     9c0:	736f6d6f 	cmnvc	pc, #7104	; 0x1bc0
     9c4:	2e656d6f 	cdpcs	13, 6, cr6, cr5, cr15, {3}
     9c8:	00040068 	andeq	r0, r4, r8, rrx
     9cc:	01050000 	mrseq	r0, (UNDEF: 5)
     9d0:	a0020500 	andge	r0, r2, r0, lsl #10
     9d4:	0300008d 	movweq	r0, #141	; 0x8d
     9d8:	0c050109 	stfeqs	f0, [r5], {9}
     9dc:	4a16059f 	bmi	582060 <__bss_end+0x57694c>
     9e0:	85d70105 	ldrbhi	r0, [r7, #261]	; 0x105
     9e4:	059f0c05 	ldreq	r0, [pc, #3077]	; 15f1 <_start-0x6a0f>
     9e8:	01054a16 	tsteq	r5, r6, lsl sl
     9ec:	25058ad7 	strcs	r8, [r5, #-2775]	; 0xfffff529
     9f0:	9e0b05bb 	mcrls	5, 0, r0, cr11, cr11, {5}
     9f4:	054b1d05 	strbeq	r1, [fp, #-3333]	; 0xfffff2fb
     9f8:	1f054a31 	svcne	0x00054a31
     9fc:	2e34054a 	cdpcs	5, 3, cr0, cr4, cr10, {2}
     a00:	054a5805 	strbeq	r5, [sl, #-2053]	; 0xfffff7fb
     a04:	5b054a46 	blpl	153324 <__bss_end+0x147c10>
     a08:	4a5d054a 	bmi	1741f38 <__bss_end+0x1736824>
     a0c:	fa2f0105 	blx	bc0e28 <__bss_end+0xbb5714>
     a10:	05bb1505 	ldreq	r1, [fp, #1285]!	; 0x505
     a14:	1e059f1c 	mcrne	15, 0, r9, cr5, cr12, {0}
     a18:	4a38054a 	bmi	e01f48 <__bss_end+0xdf6834>
     a1c:	054a3a05 	strbeq	r3, [sl, #-2565]	; 0xfffff5fb
     a20:	42054a4b 	andmi	r4, r5, #307200	; 0x4b000
     a24:	2e260566 	cfsh64cs	mvdx0, mvdx6, #54
     a28:	052e6305 	streq	r6, [lr, #-773]!	; 0xfffffcfb
     a2c:	056c6701 	strbeq	r6, [ip, #-1793]!	; 0xfffff8ff
     a30:	1605d71c 			; <UNDEFINED> instruction: 0x1605d71c
     a34:	4a14059f 	bmi	5020b8 <__bss_end+0x4f69a4>
     a38:	054a3305 	strbeq	r3, [sl, #-773]	; 0xfffffcfb
     a3c:	26054a31 			; <UNDEFINED> instruction: 0x26054a31
     a40:	2e09054a 	cfsh32cs	mvfx0, mvfx9, #42
     a44:	054b0c05 	strbeq	r0, [fp, #-3077]	; 0xfffff3fb
     a48:	056c6701 	strbeq	r6, [ip, #-1793]!	; 0xfffff8ff
     a4c:	059f8321 	ldreq	r8, [pc, #801]	; d75 <_start-0x728b>
     a50:	01059e13 	tsteq	r5, r3, lsl lr
     a54:	1005899f 	mulne	r5, pc, r9	; <UNPREDICTABLE>
     a58:	080e05bb 	stmdaeq	lr, {r0, r1, r3, r4, r5, r7, r8, sl}
     a5c:	00170522 	andseq	r0, r7, r2, lsr #10
     a60:	4a010402 	bmi	41a70 <__bss_end+0x3635c>
     a64:	05691f05 	strbeq	r1, [r9, #-3845]!	; 0xfffff0fb
     a68:	0905a20c 	stmdbeq	r5, {r2, r3, r9, sp, pc}
     a6c:	832f054a 			; <UNDEFINED> instruction: 0x832f054a
     a70:	059e2505 	ldreq	r2, [lr, #1285]	; 0x505
     a74:	0e05bf11 	mcreq	15, 0, fp, cr5, cr1, {0}
     a78:	8335054a 	teqhi	r5, #310378496	; 0x12800000
     a7c:	059e2505 	ldreq	r2, [lr, #1285]	; 0x505
     a80:	2505c033 	strcs	ip, [r5, #-51]	; 0xffffffcd
     a84:	0005059e 	muleq	r5, lr, r5
     a88:	03020402 	movweq	r0, #9218	; 0x2402
     a8c:	0c059e6c 	stceq	14, cr9, [r5], {108}	; 0x6c
     a90:	05821803 	streq	r1, [r2, #2051]	; 0x803
     a94:	05f82f01 	ldrbeq	r2, [r8, #3841]!	; 0xf01
     a98:	1705830e 	strne	r8, [r5, -lr, lsl #6]
     a9c:	03040200 	movweq	r0, #16896	; 0x4200
     aa0:	0021054a 	eoreq	r0, r1, sl, asr #10
     aa4:	67020402 	strvs	r0, [r2, -r2, lsl #8]
     aa8:	02001305 	andeq	r1, r0, #335544320	; 0x14000000
     aac:	059e0204 	ldreq	r0, [lr, #516]	; 0x204
     ab0:	04020005 	streq	r0, [r2], #-5
     ab4:	01059d02 	tsteq	r5, r2, lsl #26
     ab8:	0c058885 	stceq	8, cr8, [r5], {133}	; 0x85
     abc:	67010583 	strvs	r0, [r1, -r3, lsl #11]
     ac0:	a01f0588 	andsge	r0, pc, r8, lsl #11
     ac4:	054a0d05 	strbeq	r0, [sl, #-3333]	; 0xfffff2fb
     ac8:	0d054b1f 	vstreq	d4, [r5, #-124]	; 0xffffff84
     acc:	4b1f054a 	blmi	7c1ffc <__bss_end+0x7b68e8>
     ad0:	054a0d05 	strbeq	r0, [sl, #-3333]	; 0xfffff2fb
     ad4:	0d054b1f 	vstreq	d4, [r5, #-124]	; 0xffffff84
     ad8:	4b1f054a 	blmi	7c2008 <__bss_end+0x7b68f4>
     adc:	054a0d05 	strbeq	r0, [sl, #-3333]	; 0xfffff2fb
     ae0:	01054c0c 	tsteq	r5, ip, lsl #24
     ae4:	0008022f 	andeq	r0, r8, pc, lsr #4
     ae8:	04a70101 	strteq	r0, [r7], #257	; 0x101
     aec:	00030000 	andeq	r0, r3, r0
     af0:	000002fe 	strdeq	r0, [r0], -lr
     af4:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
     af8:	0101000d 	tsteq	r1, sp
     afc:	00000101 	andeq	r0, r0, r1, lsl #2
     b00:	00000100 	andeq	r0, r0, r0, lsl #2
     b04:	6e6d2f01 	cdpvs	15, 6, cr2, cr13, cr1, {0}
     b08:	2f632f74 	svccs	0x00632f74
     b0c:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     b10:	6972702f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, ip, sp, lr}^
     b14:	65746176 	ldrbvs	r6, [r4, #-374]!	; 0xfffffe8a
     b18:	6b726f57 	blvs	1c9c87c <__bss_end+0x1c91168>
     b1c:	63617073 	cmnvs	r1, #115	; 0x73
     b20:	63532f65 	cmpvs	r3, #404	; 0x194
     b24:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 98c <_start-0x7674>
     b28:	2f534f2f 	svccs	0x00534f2f
     b2c:	4b2f5053 	blmi	bd4c80 <__bss_end+0xbc956c>
     b30:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
     b34:	2f534f54 	svccs	0x00534f54
     b38:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     b3c:	2f736563 	svccs	0x00736563
     b40:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     b44:	63617073 	cmnvs	r1, #115	; 0x73
     b48:	65732f65 	ldrbvs	r2, [r3, #-3941]!	; 0xfffff09b
     b4c:	7473656d 	ldrbtvc	r6, [r3], #-1389	; 0xfffffa93
     b50:	5f6c6172 	svcpl	0x006c6172
     b54:	6b736174 	blvs	1cd912c <__bss_end+0x1ccda18>
     b58:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     b5c:	6f76652f 	svcvs	0x0076652f
     b60:	6974756c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sl, ip, sp, lr}^
     b64:	2f006e6f 	svccs	0x00006e6f
     b68:	2f746e6d 	svccs	0x00746e6d
     b6c:	73752f63 	cmnvc	r5, #396	; 0x18c
     b70:	702f7265 	eorvc	r7, pc, r5, ror #4
     b74:	61766972 	cmnvs	r6, r2, ror r9
     b78:	6f576574 	svcvs	0x00576574
     b7c:	70736b72 	rsbsvc	r6, r3, r2, ror fp
     b80:	2f656361 	svccs	0x00656361
     b84:	6f686353 	svcvs	0x00686353
     b88:	4f2f6c6f 	svcmi	0x002f6c6f
     b8c:	50532f53 	subspl	r2, r3, r3, asr pc
     b90:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
     b94:	4f54522d 	svcmi	0x0054522d
     b98:	6f732f53 	svcvs	0x00732f53
     b9c:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     ba0:	73752f73 	cmnvc	r5, #460	; 0x1cc
     ba4:	70737265 	rsbsvc	r7, r3, r5, ror #4
     ba8:	2f656361 	svccs	0x00656361
     bac:	732f2e2e 			; <UNDEFINED> instruction: 0x732f2e2e
     bb0:	74756474 	ldrbtvc	r6, [r5], #-1140	; 0xfffffb8c
     bb4:	2f736c69 	svccs	0x00736c69
     bb8:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     bbc:	00656475 	rsbeq	r6, r5, r5, ror r4
     bc0:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
     bc4:	752f632f 	strvc	r6, [pc, #-815]!	; 89d <_start-0x7763>
     bc8:	2f726573 	svccs	0x00726573
     bcc:	76697270 			; <UNDEFINED> instruction: 0x76697270
     bd0:	57657461 	strbpl	r7, [r5, -r1, ror #8]!
     bd4:	736b726f 	cmnvc	fp, #-268435450	; 0xf0000006
     bd8:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     bdc:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
     be0:	2f6c6f6f 	svccs	0x006c6f6f
     be4:	532f534f 			; <UNDEFINED> instruction: 0x532f534f
     be8:	494b2f50 	stmdbmi	fp, {r4, r6, r8, r9, sl, fp, sp}^
     bec:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
     bf0:	732f534f 			; <UNDEFINED> instruction: 0x732f534f
     bf4:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     bf8:	752f7365 	strvc	r7, [pc, #-869]!	; 89b <_start-0x7765>
     bfc:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     c00:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     c04:	2f2e2e2f 	svccs	0x002e2e2f
     c08:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     c0c:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     c10:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     c14:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
     c18:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
     c1c:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
     c20:	61682f30 	cmnvs	r8, r0, lsr pc
     c24:	6d2f006c 	stcvs	0, cr0, [pc, #-432]!	; a7c <_start-0x7584>
     c28:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
     c2c:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     c30:	72702f72 	rsbsvc	r2, r0, #456	; 0x1c8
     c34:	74617669 	strbtvc	r7, [r1], #-1641	; 0xfffff997
     c38:	726f5765 	rsbvc	r5, pc, #26476544	; 0x1940000
     c3c:	6170736b 	cmnvs	r0, fp, ror #6
     c40:	532f6563 			; <UNDEFINED> instruction: 0x532f6563
     c44:	6f6f6863 	svcvs	0x006f6863
     c48:	534f2f6c 	movtpl	r2, #65388	; 0xff6c
     c4c:	2f50532f 	svccs	0x0050532f
     c50:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
     c54:	534f5452 	movtpl	r5, #62546	; 0xf452
     c58:	756f732f 	strbvc	r7, [pc, #-815]!	; 931 <_start-0x76cf>
     c5c:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     c60:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     c64:	61707372 	cmnvs	r0, r2, ror r3
     c68:	732f6563 			; <UNDEFINED> instruction: 0x732f6563
     c6c:	73656d65 	cmnvc	r5, #6464	; 0x1940
     c70:	6c617274 	sfmvs	f7, 2, [r1], #-464	; 0xfffffe30
     c74:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     c78:	6e692f6b 	cdpvs	15, 6, cr2, cr9, cr11, {3}
     c7c:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     c80:	76652f65 	strbtvc	r2, [r5], -r5, ror #30
     c84:	74756c6f 	ldrbtvc	r6, [r5], #-3183	; 0xfffff391
     c88:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     c8c:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
     c90:	752f632f 	strvc	r6, [pc, #-815]!	; 969 <_start-0x7697>
     c94:	2f726573 	svccs	0x00726573
     c98:	76697270 			; <UNDEFINED> instruction: 0x76697270
     c9c:	57657461 	strbpl	r7, [r5, -r1, ror #8]!
     ca0:	736b726f 	cmnvc	fp, #-268435450	; 0xf0000006
     ca4:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     ca8:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
     cac:	2f6c6f6f 	svccs	0x006c6f6f
     cb0:	532f534f 			; <UNDEFINED> instruction: 0x532f534f
     cb4:	494b2f50 	stmdbmi	fp, {r4, r6, r8, r9, sl, fp, sp}^
     cb8:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
     cbc:	732f534f 			; <UNDEFINED> instruction: 0x732f534f
     cc0:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     cc4:	752f7365 	strvc	r7, [pc, #-869]!	; 967 <_start-0x7699>
     cc8:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     ccc:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     cd0:	2f2e2e2f 	svccs	0x002e2e2f
     cd4:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     cd8:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     cdc:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     ce0:	702f6564 	eorvc	r6, pc, r4, ror #10
     ce4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     ce8:	2f007373 	svccs	0x00007373
     cec:	2f746e6d 	svccs	0x00746e6d
     cf0:	73752f63 	cmnvc	r5, #396	; 0x18c
     cf4:	702f7265 	eorvc	r7, pc, r5, ror #4
     cf8:	61766972 	cmnvs	r6, r2, ror r9
     cfc:	6f576574 	svcvs	0x00576574
     d00:	70736b72 	rsbsvc	r6, r3, r2, ror fp
     d04:	2f656361 	svccs	0x00656361
     d08:	6f686353 	svcvs	0x00686353
     d0c:	4f2f6c6f 	svcmi	0x002f6c6f
     d10:	50532f53 	subspl	r2, r3, r3, asr pc
     d14:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
     d18:	4f54522d 	svcmi	0x0054522d
     d1c:	6f732f53 	svcvs	0x00732f53
     d20:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     d24:	73752f73 	cmnvc	r5, #460	; 0x1cc
     d28:	70737265 	rsbsvc	r7, r3, r5, ror #4
     d2c:	2f656361 	svccs	0x00656361
     d30:	6b2f2e2e 	blvs	bcc5f0 <__bss_end+0xbc0edc>
     d34:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     d38:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
     d3c:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     d40:	73662f65 	cmnvc	r6, #404	; 0x194
     d44:	65670000 	strbvs	r0, [r7, #-0]!
     d48:	6172656e 	cmnvs	r2, lr, ror #10
     d4c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     d50:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     d54:	00000100 	andeq	r0, r0, r0, lsl #2
     d58:	63697571 	cmnvs	r9, #473956352	; 0x1c400000
     d5c:	726f736b 	rsbvc	r7, pc, #-1409286143	; 0xac000001
     d60:	00682e74 	rsbeq	r2, r8, r4, ror lr
     d64:	69000002 	stmdbvs	r0, {r1}
     d68:	6564746e 	strbvs	r7, [r4, #-1134]!	; 0xfffffb92
     d6c:	00682e66 	rsbeq	r2, r8, r6, ror #28
     d70:	72000003 	andvc	r0, r0, #3
     d74:	675f646e 	ldrbvs	r6, [pc, -lr, ror #8]
     d78:	72656e65 	rsbvc	r6, r5, #1616	; 0x650
     d7c:	726f7461 	rsbvc	r7, pc, #1627389952	; 0x61000000
     d80:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
     d84:	6f6d0000 	svcvs	0x006d0000
     d88:	2e6c6564 	cdpcs	5, 6, cr6, cr12, cr4, {3}
     d8c:	00040068 	andeq	r0, r4, r8, rrx
     d90:	72686300 	rsbvc	r6, r8, #0, 6
     d94:	736f6d6f 	cmnvc	pc, #7104	; 0x1bc0
     d98:	2e656d6f 	cdpcs	13, 6, cr6, cr5, cr15, {3}
     d9c:	00040068 	andeq	r0, r4, r8, rrx
     da0:	6e656700 	cdpvs	7, 6, cr6, cr5, cr0, {0}
     da4:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
     da8:	2e6e6f69 	cdpcs	15, 6, cr6, cr14, cr9, {3}
     dac:	00040068 	andeq	r0, r4, r8, rrx
     db0:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
     db4:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
     db8:	00682e6b 	rsbeq	r2, r8, fp, ror #28
     dbc:	66000005 	strvs	r0, [r0], -r5
     dc0:	73656c69 	cmnvc	r5, #26880	; 0x6900
     dc4:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     dc8:	00682e6d 	rsbeq	r2, r8, sp, ror #28
     dcc:	70000006 	andvc	r0, r0, r6
     dd0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     dd4:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
     dd8:	00000500 	andeq	r0, r0, r0, lsl #10
     ddc:	636f7270 	cmnvs	pc, #112, 4
     de0:	5f737365 	svcpl	0x00737365
     de4:	616e616d 	cmnvs	lr, sp, ror #2
     de8:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
     dec:	00050068 	andeq	r0, r5, r8, rrx
     df0:	01050000 	mrseq	r0, (UNDEF: 5)
     df4:	5c020500 	cfstr32pl	mvfx0, [r2], {-0}
     df8:	19000092 	stmdbne	r0, {r1, r4, r7}
     dfc:	05f30e05 	ldrbeq	r0, [r3, #3589]!	; 0xe05
     e00:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
     e04:	02004a03 	andeq	r4, r0, #12288	; 0x3000
     e08:	05680204 	strbeq	r0, [r8, #-516]!	; 0xfffffdfc
     e0c:	04020005 	streq	r0, [r2], #-5
     e10:	05720802 	ldrbeq	r0, [r2, #-2050]!	; 0xfffff7fe
     e14:	0e05870f 	cdpeq	7, 0, cr8, cr5, cr15, {0}
     e18:	8301052e 	movwhi	r0, #5422	; 0x152e
     e1c:	830e0569 	movwhi	r0, #58729	; 0xe569
     e20:	02001705 	andeq	r1, r0, #1310720	; 0x140000
     e24:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     e28:	0402001d 	streq	r0, [r2], #-29	; 0xffffffe3
     e2c:	05056702 	streq	r6, [r5, #-1794]	; 0xfffff8fe
     e30:	02040200 	andeq	r0, r4, #0, 4
     e34:	01051f08 	tsteq	r5, r8, lsl #30
     e38:	0f056a84 	svceq	0x00056a84
     e3c:	2e0e05bb 	mcrcs	5, 0, r0, cr14, cr11, {5}
     e40:	05841a05 	streq	r1, [r4, #2565]	; 0xa05
     e44:	3705bb01 	strcc	fp, [r5, -r1, lsl #22]
     e48:	bb2c0568 	bllt	b023f0 <__bss_end+0xaf6cdc>
     e4c:	059f1005 	ldreq	r1, [pc, #5]	; e59 <_start-0x71a7>
     e50:	0592082d 	ldreq	r0, [r2, #2093]	; 0x82d
     e54:	37059f10 	smladcc	r5, r0, pc, r9	; <UNPREDICTABLE>
     e58:	01059208 	tsteq	r5, r8, lsl #4
     e5c:	85132402 	ldrhi	r2, [r3, #-1026]	; 0xfffffbfe
     e60:	059f0905 	ldreq	r0, [pc, #2309]	; 176d <_start-0x6893>
     e64:	0402000e 	streq	r0, [r2], #-14
     e68:	13054c02 	movwne	r4, #23554	; 0x5c02
     e6c:	01040200 	mrseq	r0, R12_usr
     e70:	00050567 	andeq	r0, r5, r7, ror #10
     e74:	02010402 	andeq	r0, r1, #33554432	; 0x2000000
     e78:	0e051128 	adfeqsp	f1, f5, #0.0
     e7c:	02040200 	andeq	r0, r4, #0, 4
     e80:	00130586 	andseq	r0, r3, r6, lsl #11
     e84:	68010402 	stmdavs	r1, {r1, sl}
     e88:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
     e8c:	05800104 	streq	r0, [r0, #260]	; 0x104
     e90:	0e058809 	cdpeq	8, 0, cr8, cr5, cr9, {0}
     e94:	02040200 	andeq	r0, r4, #0, 4
     e98:	0013054b 	andseq	r0, r3, fp, asr #10
     e9c:	67010402 	strvs	r0, [r1, -r2, lsl #8]
     ea0:	02000a05 	andeq	r0, r0, #20480	; 0x5000
     ea4:	28020104 	stmdacs	r2, {r2, r8}
     ea8:	00050513 	andeq	r0, r5, r3, lsl r5
     eac:	64010402 	strvs	r0, [r1], #-1026	; 0xfffffbfe
     eb0:	05880e05 	streq	r0, [r8, #3589]	; 0xe05
     eb4:	0402002b 	streq	r0, [r2], #-43	; 0xffffffd5
     eb8:	19054a03 	stmdbne	r5, {r0, r1, r9, fp, lr}
     ebc:	02040200 	andeq	r0, r4, #0, 4
     ec0:	00050567 	andeq	r0, r5, r7, ror #10
     ec4:	08020402 	stmdaeq	r2, {r1, sl}
     ec8:	8401051f 	strhi	r0, [r1], #-1311	; 0xfffffae1
     ecc:	01000602 	tsteq	r0, r2, lsl #12
     ed0:	05020401 	streq	r0, [r2, #-1025]	; 0xfffffbff
     ed4:	02050006 	andeq	r0, r5, #6
     ed8:	0000962c 	andeq	r9, r0, ip, lsr #12
     edc:	05010a03 	streq	r0, [r1, #-2563]	; 0xfffff5fd
     ee0:	0905bc0b 	stmdbeq	r5, {r0, r1, r3, sl, fp, ip, sp, pc}
     ee4:	13054b84 	movwne	r4, #23428	; 0x5b84
     ee8:	2e12054d 	cfmac32cs	mvfx0, mvfx2, mvfx13
     eec:	059e1505 	ldreq	r1, [lr, #1285]	; 0x505
     ef0:	1b054a1c 	blne	153768 <__bss_end+0x148054>
     ef4:	d615052e 	ldrle	r0, [r5], -lr, lsr #10
     ef8:	00661f05 	rsbeq	r1, r6, r5, lsl #30
     efc:	06010402 	streq	r0, [r1], -r2, lsl #8
     f00:	0402004a 	streq	r0, [r2], #-74	; 0xffffffb6
     f04:	02008203 	andeq	r8, r0, #805306368	; 0x30000000
     f08:	004a0404 	subeq	r0, sl, r4, lsl #8
     f0c:	2e060402 	cdpcs	4, 0, cr0, cr6, cr2, {0}
     f10:	4b060a05 	blmi	18372c <__bss_end+0x178018>
     f14:	05650705 	strbeq	r0, [r5, #-1797]!	; 0xfffff8fb
     f18:	12053017 	andne	r3, r5, #23
     f1c:	ba170566 	blt	5c24bc <__bss_end+0x5b6da8>
     f20:	054a1e05 	strbeq	r1, [sl, #-3589]	; 0xfffff1fb
     f24:	17052e1d 	smladne	r5, sp, lr, r2
     f28:	9e0705d6 	mcrls	5, 0, r0, cr7, cr6, {6}
     f2c:	83150530 	tsthi	r5, #48, 10	; 0xc000000
     f30:	052e1405 	streq	r1, [lr, #-1029]!	; 0xfffffbfb
     f34:	1d05d61e 	stcne	6, cr13, [r5, #-120]	; 0xffffff88
     f38:	d60e052e 	strle	r0, [lr], -lr, lsr #10
     f3c:	054b0d05 	strbeq	r0, [fp, #-3333]	; 0xfffff2fb
     f40:	82780305 	rsbshi	r0, r8, #335544320	; 0x14000000
     f44:	09031005 	stmdbeq	r3, {r0, r2, ip}
     f48:	2e0f052e 	cfsh32cs	mvfx0, mvfx15, #30
     f4c:	05d61a05 	ldrbeq	r1, [r6, #2565]	; 0xa05
     f50:	09052e19 	stmdbeq	r5, {r0, r3, r4, r9, sl, fp, sp}
     f54:	12054cd6 	andne	r4, r5, #54784	; 0xd600
     f58:	4a0f0566 	bmi	3c24f8 <__bss_end+0x3b6de4>
     f5c:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
     f60:	0a054b11 	beq	153bac <__bss_end+0x148498>
     f64:	841105bb 	ldrhi	r0, [r1], #-1467	; 0xfffffa45
     f68:	05bb0a05 	ldreq	r0, [fp, #2565]!	; 0xa05
     f6c:	666c0303 	strbtvs	r0, [ip], -r3, lsl #6
     f70:	17030105 	strne	r0, [r3, -r5, lsl #2]
     f74:	0006022e 	andeq	r0, r6, lr, lsr #4
     f78:	02040101 	andeq	r0, r4, #1073741824	; 0x40000000
     f7c:	05000d05 	streq	r0, [r0, #-3333]	; 0xfffff2fb
     f80:	00988402 	addseq	r8, r8, r2, lsl #8
     f84:	05051500 	streq	r1, [r5, #-1280]	; 0xfffffb00
     f88:	d70305a0 	strle	r0, [r3, -r0, lsr #11]
     f8c:	d70105f3 			; <UNDEFINED> instruction: 0xd70105f3
     f90:	01000602 	tsteq	r0, r2, lsl #12
     f94:	00022401 	andeq	r2, r2, r1, lsl #8
     f98:	e3000300 	movw	r0, #768	; 0x300
     f9c:	02000001 	andeq	r0, r0, #1
     fa0:	0d0efb01 	vstreq	d15, [lr, #-4]
     fa4:	01010100 	mrseq	r0, (UNDEF: 17)
     fa8:	00000001 	andeq	r0, r0, r1
     fac:	01000001 	tsteq	r0, r1
     fb0:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
     fb4:	752f632f 	strvc	r6, [pc, #-815]!	; c8d <_start-0x7373>
     fb8:	2f726573 	svccs	0x00726573
     fbc:	76697270 			; <UNDEFINED> instruction: 0x76697270
     fc0:	57657461 	strbpl	r7, [r5, -r1, ror #8]!
     fc4:	736b726f 	cmnvc	fp, #-268435450	; 0xf0000006
     fc8:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     fcc:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
     fd0:	2f6c6f6f 	svccs	0x006c6f6f
     fd4:	532f534f 			; <UNDEFINED> instruction: 0x532f534f
     fd8:	494b2f50 	stmdbmi	fp, {r4, r6, r8, r9, sl, fp, sp}^
     fdc:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
     fe0:	732f534f 			; <UNDEFINED> instruction: 0x732f534f
     fe4:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     fe8:	752f7365 	strvc	r7, [pc, #-869]!	; c8b <_start-0x7375>
     fec:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     ff0:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     ff4:	6d65732f 	stclvs	3, cr7, [r5, #-188]!	; 0xffffff44
     ff8:	72747365 	rsbsvc	r7, r4, #-1811939327	; 0x94000001
     ffc:	745f6c61 	ldrbvc	r6, [pc], #-3169	; 1004 <_start-0x6ffc>
    1000:	2f6b7361 	svccs	0x006b7361
    1004:	00637273 	rsbeq	r7, r3, r3, ror r2
    1008:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
    100c:	752f632f 	strvc	r6, [pc, #-815]!	; ce5 <_start-0x731b>
    1010:	2f726573 	svccs	0x00726573
    1014:	76697270 			; <UNDEFINED> instruction: 0x76697270
    1018:	57657461 	strbpl	r7, [r5, -r1, ror #8]!
    101c:	736b726f 	cmnvc	fp, #-268435450	; 0xf0000006
    1020:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
    1024:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
    1028:	2f6c6f6f 	svccs	0x006c6f6f
    102c:	532f534f 			; <UNDEFINED> instruction: 0x532f534f
    1030:	494b2f50 	stmdbmi	fp, {r4, r6, r8, r9, sl, fp, sp}^
    1034:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
    1038:	732f534f 			; <UNDEFINED> instruction: 0x732f534f
    103c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    1040:	752f7365 	strvc	r7, [pc, #-869]!	; ce3 <_start-0x731d>
    1044:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
    1048:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
    104c:	2f2e2e2f 	svccs	0x002e2e2f
    1050:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    1054:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
    1058:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
    105c:	702f6564 	eorvc	r6, pc, r4, ror #10
    1060:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1064:	2f007373 	svccs	0x00007373
    1068:	2f746e6d 	svccs	0x00746e6d
    106c:	73752f63 	cmnvc	r5, #396	; 0x18c
    1070:	702f7265 	eorvc	r7, pc, r5, ror #4
    1074:	61766972 	cmnvs	r6, r2, ror r9
    1078:	6f576574 	svcvs	0x00576574
    107c:	70736b72 	rsbsvc	r6, r3, r2, ror fp
    1080:	2f656361 	svccs	0x00656361
    1084:	6f686353 	svcvs	0x00686353
    1088:	4f2f6c6f 	svcmi	0x002f6c6f
    108c:	50532f53 	subspl	r2, r3, r3, asr pc
    1090:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
    1094:	4f54522d 	svcmi	0x0054522d
    1098:	6f732f53 	svcvs	0x00732f53
    109c:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    10a0:	73752f73 	cmnvc	r5, #460	; 0x1cc
    10a4:	70737265 	rsbsvc	r7, r3, r5, ror #4
    10a8:	2f656361 	svccs	0x00656361
    10ac:	6b2f2e2e 	blvs	bcc96c <__bss_end+0xbc1258>
    10b0:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    10b4:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
    10b8:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
    10bc:	73662f65 	cmnvc	r6, #404	; 0x194
    10c0:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
    10c4:	2f632f74 	svccs	0x00632f74
    10c8:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
    10cc:	6972702f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, ip, sp, lr}^
    10d0:	65746176 	ldrbvs	r6, [r4, #-374]!	; 0xfffffe8a
    10d4:	6b726f57 	blvs	1c9ce38 <__bss_end+0x1c91724>
    10d8:	63617073 	cmnvs	r1, #115	; 0x73
    10dc:	63532f65 	cmpvs	r3, #404	; 0x194
    10e0:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; f48 <_start-0x70b8>
    10e4:	2f534f2f 	svccs	0x00534f2f
    10e8:	4b2f5053 	blmi	bd523c <__bss_end+0xbc9b28>
    10ec:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
    10f0:	2f534f54 	svccs	0x00534f54
    10f4:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
    10f8:	2f736563 	svccs	0x00736563
    10fc:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
    1100:	63617073 	cmnvs	r1, #115	; 0x73
    1104:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
    1108:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    110c:	2f6c656e 	svccs	0x006c656e
    1110:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
    1114:	2f656475 	svccs	0x00656475
    1118:	72616f62 	rsbvc	r6, r1, #392	; 0x188
    111c:	70722f64 	rsbsvc	r2, r2, r4, ror #30
    1120:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
    1124:	00006c61 	andeq	r6, r0, r1, ror #24
    1128:	6c697475 	cfstrdvs	mvd7, [r9], #-468	; 0xfffffe2c
    112c:	70632e73 	rsbvc	r2, r3, r3, ror lr
    1130:	00010070 	andeq	r0, r1, r0, ror r0
    1134:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
    1138:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
    113c:	00682e6b 	rsbeq	r2, r8, fp, ror #28
    1140:	66000002 	strvs	r0, [r0], -r2
    1144:	73656c69 	cmnvc	r5, #26880	; 0x6900
    1148:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
    114c:	00682e6d 	rsbeq	r2, r8, sp, ror #28
    1150:	70000003 	andvc	r0, r0, r3
    1154:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1158:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
    115c:	00000200 	andeq	r0, r0, r0, lsl #4
    1160:	636f7270 	cmnvs	pc, #112, 4
    1164:	5f737365 	svcpl	0x00737365
    1168:	616e616d 	cmnvs	lr, sp, ror #2
    116c:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
    1170:	00020068 	andeq	r0, r2, r8, rrx
    1174:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
    1178:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
    117c:	00040068 	andeq	r0, r4, r8, rrx
    1180:	01050000 	mrseq	r0, (UNDEF: 5)
    1184:	fc020500 	stc2	5, cr0, [r2], {-0}
    1188:	15000098 	strne	r0, [r0, #-152]	; 0xffffff68
    118c:	059f1c05 	ldreq	r1, [pc, #3077]	; 1d99 <_start-0x6267>
    1190:	01056607 	tsteq	r5, r7, lsl #12
    1194:	07056983 	streq	r6, [r5, -r3, lsl #19]
    1198:	830805a0 	movwhi	r0, #34208	; 0x85a0
    119c:	83070583 	movwhi	r0, #30083	; 0x7583
    11a0:	05830105 	streq	r0, [r3, #261]	; 0x105
    11a4:	07058448 	streq	r8, [r5, -r8, asr #8]
    11a8:	830805be 	movwhi	r0, #34238	; 0x85be
    11ac:	05830605 	streq	r0, [r3, #1541]	; 0x605
    11b0:	09058308 	stmdbeq	r5, {r3, r8, r9, pc}
    11b4:	830105a0 	movwhi	r0, #5536	; 0x15a0
    11b8:	01000602 	tsteq	r0, r2, lsl #12
    11bc:	0002a001 	andeq	sl, r2, r1
    11c0:	b5000300 	strlt	r0, [r0, #-768]	; 0xfffffd00
    11c4:	02000001 	andeq	r0, r0, #1
    11c8:	0d0efb01 	vstreq	d15, [lr, #-4]
    11cc:	01010100 	mrseq	r0, (UNDEF: 17)
    11d0:	00000001 	andeq	r0, r0, r1
    11d4:	01000001 	tsteq	r0, r1
    11d8:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
    11dc:	752f632f 	strvc	r6, [pc, #-815]!	; eb5 <_start-0x714b>
    11e0:	2f726573 	svccs	0x00726573
    11e4:	76697270 			; <UNDEFINED> instruction: 0x76697270
    11e8:	57657461 	strbpl	r7, [r5, -r1, ror #8]!
    11ec:	736b726f 	cmnvc	fp, #-268435450	; 0xf0000006
    11f0:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
    11f4:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
    11f8:	2f6c6f6f 	svccs	0x006c6f6f
    11fc:	532f534f 			; <UNDEFINED> instruction: 0x532f534f
    1200:	494b2f50 	stmdbmi	fp, {r4, r6, r8, r9, sl, fp, sp}^
    1204:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
    1208:	732f534f 			; <UNDEFINED> instruction: 0x732f534f
    120c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    1210:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
    1214:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
    1218:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
    121c:	6d2f0063 	stcvs	0, cr0, [pc, #-396]!	; 1098 <_start-0x6f68>
    1220:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
    1224:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
    1228:	72702f72 	rsbsvc	r2, r0, #456	; 0x1c8
    122c:	74617669 	strbtvc	r7, [r1], #-1641	; 0xfffff997
    1230:	726f5765 	rsbvc	r5, pc, #26476544	; 0x1940000
    1234:	6170736b 	cmnvs	r0, fp, ror #6
    1238:	532f6563 			; <UNDEFINED> instruction: 0x532f6563
    123c:	6f6f6863 	svcvs	0x006f6863
    1240:	534f2f6c 	movtpl	r2, #65388	; 0xff6c
    1244:	2f50532f 	svccs	0x0050532f
    1248:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
    124c:	534f5452 	movtpl	r5, #62546	; 0xf452
    1250:	756f732f 	strbvc	r7, [pc, #-815]!	; f29 <_start-0x70d7>
    1254:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    1258:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    125c:	2f6c656e 	svccs	0x006c656e
    1260:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
    1264:	2f656475 	svccs	0x00656475
    1268:	636f7270 	cmnvs	pc, #112, 4
    126c:	00737365 	rsbseq	r7, r3, r5, ror #6
    1270:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
    1274:	752f632f 	strvc	r6, [pc, #-815]!	; f4d <_start-0x70b3>
    1278:	2f726573 	svccs	0x00726573
    127c:	76697270 			; <UNDEFINED> instruction: 0x76697270
    1280:	57657461 	strbpl	r7, [r5, -r1, ror #8]!
    1284:	736b726f 	cmnvc	fp, #-268435450	; 0xf0000006
    1288:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
    128c:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
    1290:	2f6c6f6f 	svccs	0x006c6f6f
    1294:	532f534f 			; <UNDEFINED> instruction: 0x532f534f
    1298:	494b2f50 	stmdbmi	fp, {r4, r6, r8, r9, sl, fp, sp}^
    129c:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
    12a0:	732f534f 			; <UNDEFINED> instruction: 0x732f534f
    12a4:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    12a8:	6b2f7365 	blvs	bde044 <__bss_end+0xbd2930>
    12ac:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    12b0:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
    12b4:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
    12b8:	73662f65 	cmnvc	r6, #404	; 0x194
    12bc:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
    12c0:	2f632f74 	svccs	0x00632f74
    12c4:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
    12c8:	6972702f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, ip, sp, lr}^
    12cc:	65746176 	ldrbvs	r6, [r4, #-374]!	; 0xfffffe8a
    12d0:	6b726f57 	blvs	1c9d034 <__bss_end+0x1c91920>
    12d4:	63617073 	cmnvs	r1, #115	; 0x73
    12d8:	63532f65 	cmpvs	r3, #404	; 0x194
    12dc:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 1144 <_start-0x6ebc>
    12e0:	2f534f2f 	svccs	0x00534f2f
    12e4:	4b2f5053 	blmi	bd5438 <__bss_end+0xbc9d24>
    12e8:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
    12ec:	2f534f54 	svccs	0x00534f54
    12f0:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
    12f4:	2f736563 	svccs	0x00736563
    12f8:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    12fc:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
    1300:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
    1304:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
    1308:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
    130c:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
    1310:	61682f30 	cmnvs	r8, r0, lsr pc
    1314:	7300006c 	movwvc	r0, #108	; 0x6c
    1318:	69666474 	stmdbvs	r6!, {r2, r4, r5, r6, sl, sp, lr}^
    131c:	632e656c 			; <UNDEFINED> instruction: 0x632e656c
    1320:	01007070 	tsteq	r0, r0, ror r0
    1324:	77730000 	ldrbvc	r0, [r3, -r0]!
    1328:	00682e69 	rsbeq	r2, r8, r9, ror #28
    132c:	73000002 	movwvc	r0, #2
    1330:	6c6e6970 			; <UNDEFINED> instruction: 0x6c6e6970
    1334:	2e6b636f 	cdpcs	3, 6, cr6, cr11, cr15, {3}
    1338:	00020068 	andeq	r0, r2, r8, rrx
    133c:	6c696600 	stclvs	6, cr6, [r9], #-0
    1340:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
    1344:	2e6d6574 	mcrcs	5, 3, r6, cr13, cr4, {3}
    1348:	00030068 	andeq	r0, r3, r8, rrx
    134c:	6f727000 	svcvs	0x00727000
    1350:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1354:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
    1358:	72700000 	rsbsvc	r0, r0, #0
    135c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1360:	616d5f73 	smcvs	54771	; 0xd5f3
    1364:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    1368:	00682e72 	rsbeq	r2, r8, r2, ror lr
    136c:	69000002 	stmdbvs	r0, {r1}
    1370:	6564746e 	strbvs	r7, [r4, #-1134]!	; 0xfffffb92
    1374:	00682e66 	rsbeq	r2, r8, r6, ror #28
    1378:	00000004 	andeq	r0, r0, r4
    137c:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
    1380:	009a1402 	addseq	r1, sl, r2, lsl #8
    1384:	05051600 	streq	r1, [r5, #-1536]	; 0xfffffa00
    1388:	0c052f69 	stceq	15, cr2, [r5], {105}	; 0x69
    138c:	2f01054c 	svccs	0x0001054c
    1390:	83050585 	movwhi	r0, #21893	; 0x5585
    1394:	2f01054b 	svccs	0x0001054b
    1398:	4b050585 	blmi	1429b4 <__bss_end+0x1372a0>
    139c:	852f0105 	strhi	r0, [pc, #-261]!	; 129f <_start-0x6d61>
    13a0:	4ba10505 	blmi	fe8427bc <__bss_end+0xfe8370a8>
    13a4:	0c052f4b 	stceq	15, cr2, [r5], {75}	; 0x4b
    13a8:	2f01054c 	svccs	0x0001054c
    13ac:	bd050585 	cfstr32lt	mvfx0, [r5, #-532]	; 0xfffffdec
    13b0:	2f4b4b4b 	svccs	0x004b4b4b
    13b4:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
    13b8:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
    13bc:	4b4bbd05 	blmi	12f07d8 <__bss_end+0x12e50c4>
    13c0:	0c052f4b 	stceq	15, cr2, [r5], {75}	; 0x4b
    13c4:	2f01054c 	svccs	0x0001054c
    13c8:	83050585 	movwhi	r0, #21893	; 0x5585
    13cc:	2f01054b 	svccs	0x0001054b
    13d0:	bd050585 	cfstr32lt	mvfx0, [r5, #-532]	; 0xfffffdec
    13d4:	2f4b4b4b 	svccs	0x004b4b4b
    13d8:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
    13dc:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
    13e0:	4b4ba105 	blmi	12e97fc <__bss_end+0x12de0e8>
    13e4:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
    13e8:	852f0105 	strhi	r0, [pc, #-261]!	; 12eb <_start-0x6d15>
    13ec:	4bbd0505 	blmi	fef42808 <__bss_end+0xfef370f4>
    13f0:	052f4b4b 	streq	r4, [pc, #-2891]!	; 8ad <_start-0x7753>
    13f4:	01054c0c 	tsteq	r5, ip, lsl #24
    13f8:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
    13fc:	2f4b4ba1 	svccs	0x004b4ba1
    1400:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
    1404:	05859f01 	streq	r9, [r5, #3841]	; 0xf01
    1408:	05056720 	streq	r6, [r5, #-1824]	; 0xfffff8e0
    140c:	054b4b4d 	strbeq	r4, [fp, #-2893]	; 0xfffff4b3
    1410:	0105300c 	tsteq	r5, ip
    1414:	2005852f 	andcs	r8, r5, pc, lsr #10
    1418:	4d050567 	cfstr32mi	mvfx0, [r5, #-412]	; 0xfffffe64
    141c:	0c054b4b 			; <UNDEFINED> instruction: 0x0c054b4b
    1420:	2f010530 	svccs	0x00010530
    1424:	83200585 			; <UNDEFINED> instruction: 0x83200585
    1428:	4b4c0505 	blmi	1302844 <__bss_end+0x12f7130>
    142c:	2f01054b 	svccs	0x0001054b
    1430:	67200585 	strvs	r0, [r0, -r5, lsl #11]!
    1434:	4b4d0505 	blmi	1342850 <__bss_end+0x133713c>
    1438:	300c054b 	andcc	r0, ip, fp, asr #10
    143c:	872f0105 	strhi	r0, [pc, -r5, lsl #2]!
    1440:	9fa00c05 	svcls	0x00a00c05
    1444:	05bc3105 	ldreq	r3, [ip, #261]!	; 0x105
    1448:	36056629 	strcc	r6, [r5], -r9, lsr #12
    144c:	300f052e 	andcc	r0, pc, lr, lsr #10
    1450:	05661305 	strbeq	r1, [r6, #-773]!	; 0xfffffcfb
    1454:	10058409 	andne	r8, r5, r9, lsl #8
    1458:	9f0105d8 	svcls	0x000105d8
    145c:	01000802 	tsteq	r0, r2, lsl #16
    1460:	0000ec01 	andeq	lr, r0, r1, lsl #24
    1464:	cc000300 	stcgt	3, cr0, [r0], {-0}
    1468:	02000000 	andeq	r0, r0, #0
    146c:	0d0efb01 	vstreq	d15, [lr, #-4]
    1470:	01010100 	mrseq	r0, (UNDEF: 17)
    1474:	00000001 	andeq	r0, r0, r1
    1478:	01000001 	tsteq	r0, r1
    147c:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
    1480:	752f632f 	strvc	r6, [pc, #-815]!	; 1159 <_start-0x6ea7>
    1484:	2f726573 	svccs	0x00726573
    1488:	76697270 			; <UNDEFINED> instruction: 0x76697270
    148c:	57657461 	strbpl	r7, [r5, -r1, ror #8]!
    1490:	736b726f 	cmnvc	fp, #-268435450	; 0xf0000006
    1494:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
    1498:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
    149c:	2f6c6f6f 	svccs	0x006c6f6f
    14a0:	532f534f 			; <UNDEFINED> instruction: 0x532f534f
    14a4:	494b2f50 	stmdbmi	fp, {r4, r6, r8, r9, sl, fp, sp}^
    14a8:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
    14ac:	732f534f 			; <UNDEFINED> instruction: 0x732f534f
    14b0:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    14b4:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
    14b8:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
    14bc:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
    14c0:	6d2f0063 	stcvs	0, cr0, [pc, #-396]!	; 133c <_start-0x6cc4>
    14c4:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
    14c8:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
    14cc:	72702f72 	rsbsvc	r2, r0, #456	; 0x1c8
    14d0:	74617669 	strbtvc	r7, [r1], #-1641	; 0xfffff997
    14d4:	726f5765 	rsbvc	r5, pc, #26476544	; 0x1940000
    14d8:	6170736b 	cmnvs	r0, fp, ror #6
    14dc:	532f6563 			; <UNDEFINED> instruction: 0x532f6563
    14e0:	6f6f6863 	svcvs	0x006f6863
    14e4:	534f2f6c 	movtpl	r2, #65388	; 0xff6c
    14e8:	2f50532f 	svccs	0x0050532f
    14ec:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
    14f0:	534f5452 	movtpl	r5, #62546	; 0xf452
    14f4:	756f732f 	strbvc	r7, [pc, #-815]!	; 11cd <_start-0x6e33>
    14f8:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    14fc:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    1500:	2f6c656e 	svccs	0x006c656e
    1504:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
    1508:	2f656475 	svccs	0x00656475
    150c:	72616f62 	rsbvc	r6, r1, #392	; 0x188
    1510:	70722f64 	rsbsvc	r2, r2, r4, ror #30
    1514:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
    1518:	00006c61 	andeq	r6, r0, r1, ror #24
    151c:	6d647473 	cfstrdvs	mvd7, [r4, #-460]!	; 0xfffffe34
    1520:	632e6d65 			; <UNDEFINED> instruction: 0x632e6d65
    1524:	01007070 	tsteq	r0, r0, ror r0
    1528:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
    152c:	66656474 			; <UNDEFINED> instruction: 0x66656474
    1530:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
    1534:	05000000 	streq	r0, [r0, #-0]
    1538:	02050001 	andeq	r0, r5, #1
    153c:	00009e70 	andeq	r9, r0, r0, ror lr
    1540:	85050519 	strhi	r0, [r5, #-1305]	; 0xfffffae7
    1544:	2e052f4b 	cdpcs	15, 0, cr2, cr5, cr11, {2}
    1548:	2f01054c 	svccs	0x0001054c
    154c:	01000802 	tsteq	r0, r2, lsl #16
    1550:	00053701 	andeq	r3, r5, r1, lsl #14
    1554:	6a000300 	bvs	215c <_start-0x5ea4>
    1558:	02000000 	andeq	r0, r0, #0
    155c:	0d0efb01 	vstreq	d15, [lr, #-4]
    1560:	01010100 	mrseq	r0, (UNDEF: 17)
    1564:	00000001 	andeq	r0, r0, r1
    1568:	01000001 	tsteq	r0, r1
    156c:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
    1570:	752f632f 	strvc	r6, [pc, #-815]!	; 1249 <_start-0x6db7>
    1574:	2f726573 	svccs	0x00726573
    1578:	76697270 			; <UNDEFINED> instruction: 0x76697270
    157c:	57657461 	strbpl	r7, [r5, -r1, ror #8]!
    1580:	736b726f 	cmnvc	fp, #-268435450	; 0xf0000006
    1584:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
    1588:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
    158c:	2f6c6f6f 	svccs	0x006c6f6f
    1590:	532f534f 			; <UNDEFINED> instruction: 0x532f534f
    1594:	494b2f50 	stmdbmi	fp, {r4, r6, r8, r9, sl, fp, sp}^
    1598:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
    159c:	732f534f 			; <UNDEFINED> instruction: 0x732f534f
    15a0:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    15a4:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
    15a8:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
    15ac:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
    15b0:	73000063 	movwvc	r0, #99	; 0x63
    15b4:	74736474 	ldrbtvc	r6, [r3], #-1140	; 0xfffffb8c
    15b8:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    15bc:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    15c0:	00000100 	andeq	r0, r0, r0, lsl #2
    15c4:	00010500 	andeq	r0, r1, r0, lsl #10
    15c8:	9ea80205 	cdpls	2, 10, cr0, cr8, cr5, {0}
    15cc:	0a030000 	beq	c15d4 <__bss_end+0xb5ec0>
    15d0:	bb060501 	bllt	1829dc <__bss_end+0x1772c8>
    15d4:	054c0f05 	strbeq	r0, [ip, #-3845]	; 0xfffff0fb
    15d8:	0a056821 	beq	15b664 <__bss_end+0x14ff50>
    15dc:	2e0b05ba 	mcrcs	5, 0, r0, cr11, cr10, {5}
    15e0:	054a2705 	strbeq	r2, [sl, #-1797]	; 0xfffff8fb
    15e4:	09054a0d 	stmdbeq	r5, {r0, r2, r3, r9, fp, lr}
    15e8:	9f04052f 	svcls	0x0004052f
    15ec:	05620205 	strbeq	r0, [r2, #-517]!	; 0xfffffdfb
    15f0:	10053505 	andne	r3, r5, r5, lsl #10
    15f4:	2e110568 	cfmsc32cs	mvfx0, mvfx1, mvfx8
    15f8:	054a2205 	strbeq	r2, [sl, #-517]	; 0xfffffdfb
    15fc:	0a052e13 	beq	14ce50 <__bss_end+0x14173c>
    1600:	6909052f 	stmdbvs	r9, {r0, r1, r2, r3, r5, r8, sl}
    1604:	052e0a05 	streq	r0, [lr, #-2565]!	; 0xfffff5fb
    1608:	03054a0c 	movweq	r4, #23052	; 0x5a0c
    160c:	680b054b 	stmdavs	fp, {r0, r1, r3, r6, r8, sl}
    1610:	02001805 	andeq	r1, r0, #327680	; 0x50000
    1614:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
    1618:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
    161c:	15059e03 	strne	r9, [r5, #-3587]	; 0xfffff1fd
    1620:	02040200 	andeq	r0, r4, #0, 4
    1624:	00180568 	andseq	r0, r8, r8, ror #10
    1628:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
    162c:	02000805 	andeq	r0, r0, #327680	; 0x50000
    1630:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
    1634:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
    1638:	1b054b02 	blne	154248 <__bss_end+0x148b34>
    163c:	02040200 	andeq	r0, r4, #0, 4
    1640:	000c052e 	andeq	r0, ip, lr, lsr #10
    1644:	4a020402 	bmi	82654 <__bss_end+0x76f40>
    1648:	02000f05 	andeq	r0, r0, #5, 30
    164c:	05820204 	streq	r0, [r2, #516]	; 0x204
    1650:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
    1654:	11054a02 	tstne	r5, r2, lsl #20
    1658:	02040200 	andeq	r0, r4, #0, 4
    165c:	000a052e 	andeq	r0, sl, lr, lsr #10
    1660:	2f020402 	svccs	0x00020402
    1664:	02000b05 	andeq	r0, r0, #5120	; 0x1400
    1668:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
    166c:	0402000d 	streq	r0, [r2], #-13
    1670:	02054a02 	andeq	r4, r5, #8192	; 0x2000
    1674:	02040200 	andeq	r0, r4, #0, 4
    1678:	88010546 	stmdahi	r1, {r1, r2, r6, r8, sl}
    167c:	83060585 	movwhi	r0, #25989	; 0x6585
    1680:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
    1684:	0c058203 	sfmeq	f0, 1, [r5], {3}
    1688:	4d09054b 	cfstr32mi	mvfx0, [r9, #-300]	; 0xfffffed4
    168c:	054a1005 	strbeq	r1, [sl, #-5]
    1690:	07054c0a 	streq	r4, [r5, -sl, lsl #24]
    1694:	4a0305bb 	bmi	c2d88 <__bss_end+0xb7674>
    1698:	02001705 	andeq	r1, r0, #1310720	; 0x140000
    169c:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
    16a0:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
    16a4:	0d054a01 	vstreq	s8, [r5, #-4]
    16a8:	4a14054d 	bmi	502be4 <__bss_end+0x4f74d0>
    16ac:	052e0a05 	streq	r0, [lr, #-2565]!	; 0xfffff5fb
    16b0:	02056808 	andeq	r6, r5, #8, 16	; 0x80000
    16b4:	05667803 	strbeq	r7, [r6, #-2051]!	; 0xfffff7fd
    16b8:	2e0b0309 	cdpcs	3, 0, cr0, cr11, cr9, {0}
    16bc:	052f0105 	streq	r0, [pc, #-261]!	; 15bf <_start-0x6a41>
    16c0:	0905681b 	stmdbeq	r5, {r0, r1, r3, r4, fp, sp, lr}
    16c4:	4b0b0583 	blmi	2c2cd8 <__bss_end+0x2b75c4>
    16c8:	05681205 	strbeq	r1, [r8, #-517]!	; 0xfffffdfb
    16cc:	0905bb0f 	stmdbeq	r5, {r0, r1, r2, r3, r8, r9, fp, ip, sp, pc}
    16d0:	64050583 	strvs	r0, [r5], #-1411	; 0xfffffa7d
    16d4:	05330c05 	ldreq	r0, [r3, #-3077]!	; 0xfffff3fb
    16d8:	0f054a12 	svceq	0x00054a12
    16dc:	83090583 	movwhi	r0, #38275	; 0x9583
    16e0:	05640505 	strbeq	r0, [r4, #-1285]!	; 0xfffffafb
    16e4:	0c05320a 	sfmeq	f3, 4, [r5], {10}
    16e8:	2f010567 	svccs	0x00010567
    16ec:	bb1605f5 	bllt	582ec8 <__bss_end+0x5777b4>
    16f0:	05670305 	strbeq	r0, [r7, #-773]!	; 0xfffffcfb
    16f4:	0b05670c 	bleq	15b32c <__bss_end+0x14fc18>
    16f8:	001c054d 	andseq	r0, ip, sp, asr #10
    16fc:	4a010402 	bmi	4270c <__bss_end+0x36ff8>
    1700:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
    1704:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
    1708:	0f05d70e 	svceq	0x0005d70e
    170c:	4a08052e 	bmi	202bcc <__bss_end+0x1f74b8>
    1710:	054b0305 	strbeq	r0, [fp, #-773]	; 0xfffffcfb
    1714:	04020013 	streq	r0, [r2], #-19	; 0xffffffed
    1718:	10056602 	andne	r6, r5, r2, lsl #12
    171c:	02040200 	andeq	r0, r4, #0, 4
    1720:	001d0566 	andseq	r0, sp, r6, ror #10
    1724:	4a030402 	bmi	c2734 <__bss_end+0xb7020>
    1728:	02002805 	andeq	r2, r0, #327680	; 0x50000
    172c:	05660404 	strbeq	r0, [r6, #-1028]!	; 0xfffffbfc
    1730:	0205670b 	andeq	r6, r5, #2883584	; 0x2c0000
    1734:	02040200 	andeq	r0, r4, #0, 4
    1738:	89090547 	stmdbhi	r9, {r0, r1, r2, r6, r8, sl}
    173c:	692f0105 	stmdbvs	pc!, {r0, r2, r8}	; <UNPREDICTABLE>
    1740:	05870905 	streq	r0, [r7, #2309]	; 0x905
    1744:	11054b07 	tstne	r5, r7, lsl #22
    1748:	660f054c 	strvs	r0, [pc], -ip, asr #10
    174c:	052e0d05 	streq	r0, [lr, #-3333]!	; 0xfffff2fb
    1750:	02002e1d 	andeq	r2, r0, #464	; 0x1d0
    1754:	66060104 	strvs	r0, [r6], -r4, lsl #2
    1758:	02002005 	andeq	r2, r0, #5
    175c:	66060304 	strvs	r0, [r6], -r4, lsl #6
    1760:	02001d05 	andeq	r1, r0, #320	; 0x140
    1764:	00660504 	rsbeq	r0, r6, r4, lsl #10
    1768:	06060402 	streq	r0, [r6], -r2, lsl #8
    176c:	0402004a 	streq	r0, [r2], #-74	; 0xffffffb6
    1770:	09052e08 	stmdbeq	r5, {r3, r9, sl, fp, sp}
    1774:	0a054b06 	beq	154394 <__bss_end+0x148c80>
    1778:	4a15054a 	bmi	542ca8 <__bss_end+0x537594>
    177c:	054a1005 	strbeq	r1, [sl, #-5]
    1780:	03056607 	movweq	r6, #22023	; 0x5607
    1784:	13053149 	movwne	r3, #20809	; 0x5149
    1788:	66110567 	ldrvs	r0, [r1], -r7, ror #10
    178c:	052e0f05 	streq	r0, [lr, #-3845]!	; 0xfffff0fb
    1790:	02002e1f 	andeq	r2, r0, #496	; 0x1f0
    1794:	66060104 	strvs	r0, [r6], -r4, lsl #2
    1798:	02002205 	andeq	r2, r0, #1342177280	; 0x50000000
    179c:	66060304 	strvs	r0, [r6], -r4, lsl #6
    17a0:	02001f05 	andeq	r1, r0, #5, 30
    17a4:	00660504 	rsbeq	r0, r6, r4, lsl #10
    17a8:	06060402 	streq	r0, [r6], -r2, lsl #8
    17ac:	0402004a 	streq	r0, [r2], #-74	; 0xffffffb6
    17b0:	0b052e08 	bleq	14cfd8 <__bss_end+0x1418c4>
    17b4:	0c054b06 			; <UNDEFINED> instruction: 0x0c054b06
    17b8:	4a17054a 	bmi	5c2ce8 <__bss_end+0x5b75d4>
    17bc:	054a1205 	strbeq	r1, [sl, #-517]	; 0xfffffdfb
    17c0:	054b6609 	strbeq	r6, [fp, #-1545]	; 0xfffff9f7
    17c4:	03056405 	movweq	r6, #21509	; 0x5405
    17c8:	00100533 	andseq	r0, r0, r3, lsr r5
    17cc:	66010402 	strvs	r0, [r1], -r2, lsl #8
    17d0:	4b670905 	blmi	19c3bec <__bss_end+0x19b84d8>
    17d4:	054b0b05 	strbeq	r0, [fp, #-2821]	; 0xfffff4fb
    17d8:	07056609 	streq	r6, [r5, -r9, lsl #12]
    17dc:	2f05052e 	svccs	0x0005052e
    17e0:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
    17e4:	0905660b 	stmdbeq	r5, {r0, r1, r3, r9, sl, sp, lr}
    17e8:	4b0a052e 	blmi	282ca8 <__bss_end+0x277594>
    17ec:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
    17f0:	0905660b 	stmdbeq	r5, {r0, r1, r3, r9, sl, sp, lr}
    17f4:	2f0c052e 	svccs	0x000c052e
    17f8:	0402004c 	streq	r0, [r2], #-76	; 0xffffffb4
    17fc:	06660601 	strbteq	r0, [r6], -r1, lsl #12
    1800:	ba150567 	blt	542da4 <__bss_end+0x537690>
    1804:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
    1808:	0b054b0d 	bleq	154444 <__bss_end+0x148d30>
    180c:	2e090566 	cfsh32cs	mvfx0, mvfx9, #54
    1810:	052c0505 	streq	r0, [ip, #-1285]!	; 0xfffffafb
    1814:	0705320b 	streq	r3, [r5, -fp, lsl #4]
    1818:	680c0566 	stmdavs	ip, {r1, r2, r5, r6, r8, sl}
    181c:	05670705 	strbeq	r0, [r7, #-1797]!	; 0xfffff8fb
    1820:	03058306 	movweq	r8, #21254	; 0x5306
    1824:	320c0564 	andcc	r0, ip, #100, 10	; 0x19000000
    1828:	05670705 	strbeq	r0, [r7, #-1797]!	; 0xfffff8fb
    182c:	0305bb06 	movweq	fp, #23302	; 0x5b06
    1830:	320a0564 	andcc	r0, sl, #100, 10	; 0x19000000
    1834:	054b0105 	strbeq	r0, [fp, #-261]	; 0xfffffefb
    1838:	053e0826 	ldreq	r0, [lr, #-2086]!	; 0xfffff7da
    183c:	9e090309 	cdpls	3, 0, cr0, cr9, cr9, {0}
    1840:	4b0f054b 	blmi	3c2d74 <__bss_end+0x3b7660>
    1844:	2e05054c 	cfsh32cs	mvfx0, mvfx5, #44
    1848:	05671305 	strbeq	r1, [r7, #-773]!	; 0xfffffcfb
    184c:	13056711 	movwne	r6, #22289	; 0x5711
    1850:	4b09054a 	blmi	242d80 <__bss_end+0x23766c>
    1854:	05310f05 	ldreq	r0, [r1, #-3845]!	; 0xfffff0fb
    1858:	10052e05 	andne	r2, r5, r5, lsl #28
    185c:	66130567 	ldrvs	r0, [r3], -r7, ror #10
    1860:	054b1105 	strbeq	r1, [fp, #-261]	; 0xfffffefb
    1864:	19054a0f 	stmdbne	r5, {r0, r1, r2, r3, r9, fp, lr}
    1868:	84150531 	ldrhi	r0, [r5], #-1329	; 0xfffffacf
    186c:	05671b05 	strbeq	r1, [r7, #-2821]!	; 0xfffff4fb
    1870:	1b05660d 	blne	15b0ac <__bss_end+0x14f998>
    1874:	4a100567 	bmi	402e18 <__bss_end+0x3f7704>
    1878:	05661b05 	strbeq	r1, [r6, #-2821]!	; 0xfffff4fb
    187c:	17054a13 	smladne	r5, r3, sl, r4
    1880:	661c052f 	ldrvs	r0, [ip], -pc, lsr #10
    1884:	05820f05 	streq	r0, [r2, #3845]	; 0xf05
    1888:	05672f09 	strbeq	r2, [r7, #-3849]!	; 0xfffff0f7
    188c:	05366105 	ldreq	r6, [r6, #-261]!	; 0xfffffefb
    1890:	13056710 	movwne	r6, #22288	; 0x5710
    1894:	4c0c0566 	cfstr32mi	mvfx0, [ip], {102}	; 0x66
    1898:	05660f05 	strbeq	r0, [r6, #-3845]!	; 0xfffff0fb
    189c:	02004c19 	andeq	r4, r0, #6400	; 0x1900
    18a0:	66060104 	strvs	r0, [r6], -r4, lsl #2
    18a4:	67061005 	strvs	r1, [r6, -r5]
    18a8:	05661305 	strbeq	r1, [r6, #-773]!	; 0xfffffcfb
    18ac:	05674b09 	strbeq	r4, [r7, #-2825]!	; 0xfffff4f7
    18b0:	13056305 	movwne	r6, #21253	; 0x5305
    18b4:	67150534 			; <UNDEFINED> instruction: 0x67150534
    18b8:	054a1b05 	strbeq	r1, [sl, #-2821]	; 0xfffff4fb
    18bc:	1b054a0d 	blne	1540f8 <__bss_end+0x1489e4>
    18c0:	4a100567 	bmi	402e64 <__bss_end+0x3f7750>
    18c4:	05661b05 	strbeq	r1, [r6, #-2821]!	; 0xfffff4fb
    18c8:	11054a13 	tstne	r5, r3, lsl sl
    18cc:	4a17052f 	bmi	5c2d90 <__bss_end+0x5b767c>
    18d0:	054a1e05 	strbeq	r1, [sl, #-3589]	; 0xfffff1fb
    18d4:	09059e0f 	stmdbeq	r5, {r0, r1, r2, r3, r9, sl, fp, ip, pc}
    18d8:	6205052f 	andvs	r0, r5, #197132288	; 0xbc00000
    18dc:	05340d05 	ldreq	r0, [r4, #-3333]!	; 0xfffff2fb
    18e0:	05a16701 	streq	r6, [r1, #1793]!	; 0x701
    18e4:	1605bd09 	strne	fp, [r5], -r9, lsl #26
    18e8:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
    18ec:	001d054a 	andseq	r0, sp, sl, asr #10
    18f0:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
    18f4:	02001e05 	andeq	r1, r0, #5, 28	; 0x50
    18f8:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
    18fc:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
    1900:	11056602 	tstne	r5, r2, lsl #12
    1904:	03040200 	movweq	r0, #16896	; 0x4200
    1908:	0012054b 	andseq	r0, r2, fp, asr #10
    190c:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
    1910:	02000805 	andeq	r0, r0, #327680	; 0x50000
    1914:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
    1918:	04020009 	streq	r0, [r2], #-9
    191c:	12052e03 	andne	r2, r5, #3, 28	; 0x30
    1920:	03040200 	movweq	r0, #16896	; 0x4200
    1924:	000b054a 	andeq	r0, fp, sl, asr #10
    1928:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
    192c:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
    1930:	052d0304 	streq	r0, [sp, #-772]!	; 0xfffffcfc
    1934:	0402000b 	streq	r0, [r2], #-11
    1938:	08058402 	stmdaeq	r5, {r1, sl, pc}
    193c:	01040200 	mrseq	r0, R12_usr
    1940:	00090583 	andeq	r0, r9, r3, lsl #11
    1944:	2e010402 	cdpcs	4, 0, cr0, cr1, cr2, {0}
    1948:	02000b05 	andeq	r0, r0, #5120	; 0x1400
    194c:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
    1950:	04020002 	streq	r0, [r2], #-2
    1954:	0b054901 	bleq	153d60 <__bss_end+0x14864c>
    1958:	2f010585 	svccs	0x00010585
    195c:	a10c0585 	smlabbge	ip, r5, r5, r0
    1960:	02001605 	andeq	r1, r0, #5242880	; 0x500000
    1964:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
    1968:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
    196c:	19052e03 	stmdbne	r5, {r0, r1, r9, sl, fp, sp}
    1970:	03040200 	movweq	r0, #16896	; 0x4200
    1974:	00050566 	andeq	r0, r5, r6, ror #10
    1978:	4a020402 	bmi	82988 <__bss_end+0x77274>
    197c:	05840c05 	streq	r0, [r4, #3077]	; 0xc05
    1980:	04020015 	streq	r0, [r2], #-21	; 0xffffffeb
    1984:	16054a03 	strne	r4, [r5], -r3, lsl #20
    1988:	03040200 	movweq	r0, #16896	; 0x4200
    198c:	0018052e 	andseq	r0, r8, lr, lsr #10
    1990:	66030402 	strvs	r0, [r3], -r2, lsl #8
    1994:	02001905 	andeq	r1, r0, #81920	; 0x14000
    1998:	054b0204 	strbeq	r0, [fp, #-516]	; 0xfffffdfc
    199c:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
    19a0:	0f052e02 	svceq	0x00052e02
    19a4:	02040200 	andeq	r0, r4, #0, 4
    19a8:	0011054a 	andseq	r0, r1, sl, asr #10
    19ac:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
    19b0:	02001a05 	andeq	r1, r0, #20480	; 0x5000
    19b4:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
    19b8:	04020013 	streq	r0, [r2], #-19	; 0xffffffed
    19bc:	05052e02 	streq	r2, [r5, #-3586]	; 0xfffff1fe
    19c0:	02040200 	andeq	r0, r4, #0, 4
    19c4:	850b052d 	strhi	r0, [fp, #-1325]	; 0xfffffad3
    19c8:	05820d05 	streq	r0, [r2, #3333]	; 0xd05
    19cc:	0c054a0f 			; <UNDEFINED> instruction: 0x0c054a0f
    19d0:	2f01054c 	svccs	0x0001054c
    19d4:	bc0e0585 	cfstr32lt	mvfx0, [lr], {133}	; 0x85
    19d8:	05661105 	strbeq	r1, [r6, #-261]!	; 0xfffffefb
    19dc:	0b05bc20 	bleq	170a64 <__bss_end+0x165350>
    19e0:	4b1f0566 	blmi	7c2f80 <__bss_end+0x7b786c>
    19e4:	05660a05 	strbeq	r0, [r6, #-2565]!	; 0xfffff5fb
    19e8:	11054b08 	tstne	r5, r8, lsl #22
    19ec:	2e160583 	cdpcs	5, 1, cr0, cr6, cr3, {4}
    19f0:	05670805 	strbeq	r0, [r7, #-2053]!	; 0xfffff7fb
    19f4:	0b056711 	bleq	15b640 <__bss_end+0x14ff2c>
    19f8:	2f01054d 	svccs	0x0001054d
    19fc:	83060585 	movwhi	r0, #25989	; 0x6585
    1a00:	054c0b05 	strbeq	r0, [ip, #-2821]	; 0xfffff4fb
    1a04:	0e052e0c 	cdpeq	14, 0, cr2, cr5, cr12, {0}
    1a08:	4b040566 	blmi	102fa8 <__bss_end+0xf7894>
    1a0c:	05650205 	strbeq	r0, [r5, #-517]!	; 0xfffffdfb
    1a10:	01053109 	tsteq	r5, r9, lsl #2
    1a14:	0805852f 	stmdaeq	r5, {r0, r1, r2, r3, r5, r8, sl, pc}
    1a18:	4c0b059f 	cfstr32mi	mvfx0, [fp], {159}	; 0x9f
    1a1c:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
    1a20:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
    1a24:	04020007 	streq	r0, [r2], #-7
    1a28:	08058302 	stmdaeq	r5, {r1, r8, r9, pc}
    1a2c:	02040200 	andeq	r0, r4, #0, 4
    1a30:	000a052e 	andeq	r0, sl, lr, lsr #10
    1a34:	4a020402 	bmi	82a44 <__bss_end+0x77330>
    1a38:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
    1a3c:	05490204 	strbeq	r0, [r9, #-516]	; 0xfffffdfc
    1a40:	05858401 	streq	r8, [r5, #1025]	; 0x401
    1a44:	0805bb0e 	stmdaeq	r5, {r1, r2, r3, r8, r9, fp, ip, sp, pc}
    1a48:	4c0b054b 	cfstr32mi	mvfx0, [fp], {75}	; 0x4b
    1a4c:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
    1a50:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
    1a54:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
    1a58:	17058302 	strne	r8, [r5, -r2, lsl #6]
    1a5c:	02040200 	andeq	r0, r4, #0, 4
    1a60:	000a052e 	andeq	r0, sl, lr, lsr #10
    1a64:	4a020402 	bmi	82a74 <__bss_end+0x77360>
    1a68:	02000b05 	andeq	r0, r0, #5120	; 0x1400
    1a6c:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
    1a70:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
    1a74:	0d054a02 	vstreq	s8, [r5, #-8]
    1a78:	02040200 	andeq	r0, r4, #0, 4
    1a7c:	0002052e 	andeq	r0, r2, lr, lsr #10
    1a80:	2d020402 	cfstrscs	mvf0, [r2, #-8]
    1a84:	02840105 	addeq	r0, r4, #1073741825	; 0x40000001
    1a88:	01010008 	tsteq	r1, r8
    1a8c:	000002dc 	ldrdeq	r0, [r0], -ip
    1a90:	02220003 	eoreq	r0, r2, #3
    1a94:	01020000 	mrseq	r0, (UNDEF: 2)
    1a98:	000d0efb 	strdeq	r0, [sp], -fp
    1a9c:	01010101 	tsteq	r1, r1, lsl #2
    1aa0:	01000000 	mrseq	r0, (UNDEF: 0)
    1aa4:	2f010000 	svccs	0x00010000
    1aa8:	2f746e6d 	svccs	0x00746e6d
    1aac:	73752f63 	cmnvc	r5, #396	; 0x18c
    1ab0:	702f7265 	eorvc	r7, pc, r5, ror #4
    1ab4:	61766972 	cmnvs	r6, r2, ror r9
    1ab8:	6f576574 	svcvs	0x00576574
    1abc:	70736b72 	rsbsvc	r6, r3, r2, ror fp
    1ac0:	2f656361 	svccs	0x00656361
    1ac4:	6f686353 	svcvs	0x00686353
    1ac8:	4f2f6c6f 	svcmi	0x002f6c6f
    1acc:	50532f53 	subspl	r2, r3, r3, asr pc
    1ad0:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
    1ad4:	4f54522d 	svcmi	0x0054522d
    1ad8:	6f732f53 	svcvs	0x00732f53
    1adc:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    1ae0:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
    1ae4:	69747564 	ldmdbvs	r4!, {r2, r5, r6, r8, sl, ip, sp, lr}^
    1ae8:	732f736c 			; <UNDEFINED> instruction: 0x732f736c
    1aec:	2f006372 	svccs	0x00006372
    1af0:	2f746e6d 	svccs	0x00746e6d
    1af4:	73752f63 	cmnvc	r5, #396	; 0x18c
    1af8:	702f7265 	eorvc	r7, pc, r5, ror #4
    1afc:	61766972 	cmnvs	r6, r2, ror r9
    1b00:	6f576574 	svcvs	0x00576574
    1b04:	70736b72 	rsbsvc	r6, r3, r2, ror fp
    1b08:	2f656361 	svccs	0x00656361
    1b0c:	6f686353 	svcvs	0x00686353
    1b10:	4f2f6c6f 	svcmi	0x002f6c6f
    1b14:	50532f53 	subspl	r2, r3, r3, asr pc
    1b18:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
    1b1c:	4f54522d 	svcmi	0x0054522d
    1b20:	6f732f53 	svcvs	0x00732f53
    1b24:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    1b28:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
    1b2c:	69747564 	ldmdbvs	r4!, {r2, r5, r6, r8, sl, ip, sp, lr}^
    1b30:	692f736c 	stmdbvs	pc!, {r2, r3, r5, r6, r8, r9, ip, sp, lr}	; <UNPREDICTABLE>
    1b34:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
    1b38:	2f006564 	svccs	0x00006564
    1b3c:	2f746e6d 	svccs	0x00746e6d
    1b40:	73752f63 	cmnvc	r5, #396	; 0x18c
    1b44:	702f7265 	eorvc	r7, pc, r5, ror #4
    1b48:	61766972 	cmnvs	r6, r2, ror r9
    1b4c:	6f576574 	svcvs	0x00576574
    1b50:	70736b72 	rsbsvc	r6, r3, r2, ror fp
    1b54:	2f656361 	svccs	0x00656361
    1b58:	6f686353 	svcvs	0x00686353
    1b5c:	4f2f6c6f 	svcmi	0x002f6c6f
    1b60:	50532f53 	subspl	r2, r3, r3, asr pc
    1b64:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
    1b68:	4f54522d 	svcmi	0x0054522d
    1b6c:	6f732f53 	svcvs	0x00732f53
    1b70:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    1b74:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
    1b78:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
    1b7c:	636e692f 	cmnvs	lr, #770048	; 0xbc000
    1b80:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
    1b84:	6f72702f 	svcvs	0x0072702f
    1b88:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1b8c:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
    1b90:	2f632f74 	svccs	0x00632f74
    1b94:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
    1b98:	6972702f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, ip, sp, lr}^
    1b9c:	65746176 	ldrbvs	r6, [r4, #-374]!	; 0xfffffe8a
    1ba0:	6b726f57 	blvs	1c9d904 <__bss_end+0x1c921f0>
    1ba4:	63617073 	cmnvs	r1, #115	; 0x73
    1ba8:	63532f65 	cmpvs	r3, #404	; 0x194
    1bac:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 1a14 <_start-0x65ec>
    1bb0:	2f534f2f 	svccs	0x00534f2f
    1bb4:	4b2f5053 	blmi	bd5d08 <__bss_end+0xbca5f4>
    1bb8:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
    1bbc:	2f534f54 	svccs	0x00534f54
    1bc0:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
    1bc4:	2f736563 	svccs	0x00736563
    1bc8:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    1bcc:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
    1bd0:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
    1bd4:	662f6564 	strtvs	r6, [pc], -r4, ror #10
    1bd8:	6d2f0073 	stcvs	0, cr0, [pc, #-460]!	; 1a14 <_start-0x65ec>
    1bdc:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
    1be0:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
    1be4:	72702f72 	rsbsvc	r2, r0, #456	; 0x1c8
    1be8:	74617669 	strbtvc	r7, [r1], #-1641	; 0xfffff997
    1bec:	726f5765 	rsbvc	r5, pc, #26476544	; 0x1940000
    1bf0:	6170736b 	cmnvs	r0, fp, ror #6
    1bf4:	532f6563 			; <UNDEFINED> instruction: 0x532f6563
    1bf8:	6f6f6863 	svcvs	0x006f6863
    1bfc:	534f2f6c 	movtpl	r2, #65388	; 0xff6c
    1c00:	2f50532f 	svccs	0x0050532f
    1c04:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
    1c08:	534f5452 	movtpl	r5, #62546	; 0xf452
    1c0c:	756f732f 	strbvc	r7, [pc, #-815]!	; 18e5 <_start-0x671b>
    1c10:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    1c14:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    1c18:	2f6c656e 	svccs	0x006c656e
    1c1c:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
    1c20:	2f656475 	svccs	0x00656475
    1c24:	72616f62 	rsbvc	r6, r1, #392	; 0x188
    1c28:	70722f64 	rsbsvc	r2, r2, r4, ror #30
    1c2c:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
    1c30:	00006c61 	andeq	r6, r0, r1, ror #24
    1c34:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
    1c38:	6974755f 	ldmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r8, sl, ip, sp, lr}^
    1c3c:	632e736c 			; <UNDEFINED> instruction: 0x632e736c
    1c40:	01007070 	tsteq	r0, r0, ror r0
    1c44:	69630000 	stmdbvs	r3!, {}^	; <UNPREDICTABLE>
    1c48:	6c756372 	ldclvs	3, cr6, [r5], #-456	; 0xfffffe38
    1c4c:	625f7261 	subsvs	r7, pc, #268435462	; 0x10000006
    1c50:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
    1c54:	00682e72 	rsbeq	r2, r8, r2, ror lr
    1c58:	72000002 	andvc	r0, r0, #2
    1c5c:	5f646165 	svcpl	0x00646165
    1c60:	6c697475 	cfstrdvs	mvd7, [r9], #-468	; 0xfffffe2c
    1c64:	00682e73 	rsbeq	r2, r8, r3, ror lr
    1c68:	73000002 	movwvc	r0, #2
    1c6c:	6c6e6970 			; <UNDEFINED> instruction: 0x6c6e6970
    1c70:	2e6b636f 	cdpcs	3, 6, cr6, cr11, cr15, {3}
    1c74:	00030068 	andeq	r0, r3, r8, rrx
    1c78:	6c696600 	stclvs	6, cr6, [r9], #-0
    1c7c:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
    1c80:	2e6d6574 	mcrcs	5, 3, r6, cr13, cr4, {3}
    1c84:	00040068 	andeq	r0, r4, r8, rrx
    1c88:	6f727000 	svcvs	0x00727000
    1c8c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1c90:	0300682e 	movweq	r6, #2094	; 0x82e
    1c94:	72700000 	rsbsvc	r0, r0, #0
    1c98:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1c9c:	616d5f73 	smcvs	54771	; 0xd5f3
    1ca0:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    1ca4:	00682e72 	rsbeq	r2, r8, r2, ror lr
    1ca8:	69000003 	stmdbvs	r0, {r0, r1}
    1cac:	6564746e 	strbvs	r7, [r4, #-1134]!	; 0xfffffb92
    1cb0:	00682e66 	rsbeq	r2, r8, r6, ror #28
    1cb4:	00000005 	andeq	r0, r0, r5
    1cb8:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
    1cbc:	00aae002 	adceq	lr, sl, r2
    1cc0:	18051600 	stmdane	r5, {r9, sl, ip}
    1cc4:	68010582 	stmdavs	r1, {r1, r7, r8, sl}
    1cc8:	05845305 	streq	r5, [r4, #773]	; 0x305
    1ccc:	0b05d807 	bleq	177cf0 <__bss_end+0x16c5dc>
    1cd0:	4e100583 	cdpmi	5, 1, cr0, cr0, cr3, {4}
    1cd4:	052e0305 	streq	r0, [lr, #-773]!	; 0xfffffcfb
    1cd8:	16054b08 	strne	r4, [r5], -r8, lsl #22
    1cdc:	bb030585 	bllt	c32f8 <__bss_end+0xb7be4>
    1ce0:	056d1905 	strbeq	r1, [sp, #-2309]!	; 0xfffff6fb
    1ce4:	04059f2a 	streq	r9, [r5], #-3882	; 0xfffff0d6
    1ce8:	672b05c1 	strvs	r0, [fp, -r1, asr #11]!
    1cec:	05bc0505 	ldreq	r0, [ip, #1285]!	; 0x505
    1cf0:	2005670b 	andcs	r6, r5, fp, lsl #14
    1cf4:	82220583 	eorhi	r0, r2, #549453824	; 0x20c00000
    1cf8:	054f1b05 	strbeq	r1, [pc, #-2821]	; 11fb <_start-0x6e05>
    1cfc:	22054a0d 	andcs	r4, r5, #53248	; 0xd000
    1d00:	01040200 	mrseq	r0, R12_usr
    1d04:	6716052e 	ldrvs	r0, [r6, -lr, lsr #10]
    1d08:	052e1705 	streq	r1, [lr, #-1797]!	; 0xfffff8fb
    1d0c:	31056605 	tstcc	r5, r5, lsl #12
    1d10:	02040200 	andeq	r0, r4, #0, 4
    1d14:	0032054a 	eorseq	r0, r2, sl, asr #10
    1d18:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
    1d1c:	02002105 	andeq	r2, r0, #1073741825	; 0x40000001
    1d20:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
    1d24:	04020013 	streq	r0, [r2], #-19	; 0xffffffed
    1d28:	14054b03 	strne	r4, [r5], #-2819	; 0xfffff4fd
    1d2c:	03040200 	movweq	r0, #16896	; 0x4200
    1d30:	0016052e 	andseq	r0, r6, lr, lsr #10
    1d34:	4a030402 	bmi	c2d44 <__bss_end+0xb7630>
    1d38:	02000605 	andeq	r0, r0, #5242880	; 0x500000
    1d3c:	054b0304 	strbeq	r0, [fp, #-772]	; 0xfffffcfc
    1d40:	04020004 	streq	r0, [r2], #-4
    1d44:	05052b03 	streq	r2, [r5, #-2819]	; 0xfffff4fd
    1d48:	311a0588 	tstcc	sl, r8, lsl #11
    1d4c:	02002605 	andeq	r2, r0, #5242880	; 0x500000
    1d50:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
    1d54:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
    1d58:	02052e01 	andeq	r2, r5, #1, 28
    1d5c:	054a5803 	strbeq	r5, [sl, #-2051]	; 0xfffff7fd
    1d60:	2e2a030c 	cdpcs	3, 2, cr0, cr10, cr12, {0}
    1d64:	022f0105 	eoreq	r0, pc, #1073741825	; 0x40000001
    1d68:	01010008 	tsteq	r1, r8
    1d6c:	00000277 	andeq	r0, r0, r7, ror r2
    1d70:	021c0003 	andseq	r0, ip, #3
    1d74:	01020000 	mrseq	r0, (UNDEF: 2)
    1d78:	000d0efb 	strdeq	r0, [sp], -fp
    1d7c:	01010101 	tsteq	r1, r1, lsl #2
    1d80:	01000000 	mrseq	r0, (UNDEF: 0)
    1d84:	2f010000 	svccs	0x00010000
    1d88:	2f746e6d 	svccs	0x00746e6d
    1d8c:	73752f63 	cmnvc	r5, #396	; 0x18c
    1d90:	702f7265 	eorvc	r7, pc, r5, ror #4
    1d94:	61766972 	cmnvs	r6, r2, ror r9
    1d98:	6f576574 	svcvs	0x00576574
    1d9c:	70736b72 	rsbsvc	r6, r3, r2, ror fp
    1da0:	2f656361 	svccs	0x00656361
    1da4:	6f686353 	svcvs	0x00686353
    1da8:	4f2f6c6f 	svcmi	0x002f6c6f
    1dac:	50532f53 	subspl	r2, r3, r3, asr pc
    1db0:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
    1db4:	4f54522d 	svcmi	0x0054522d
    1db8:	6f732f53 	svcvs	0x00732f53
    1dbc:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    1dc0:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
    1dc4:	69747564 	ldmdbvs	r4!, {r2, r5, r6, r8, sl, ip, sp, lr}^
    1dc8:	732f736c 			; <UNDEFINED> instruction: 0x732f736c
    1dcc:	2f006372 	svccs	0x00006372
    1dd0:	2f746e6d 	svccs	0x00746e6d
    1dd4:	73752f63 	cmnvc	r5, #396	; 0x18c
    1dd8:	702f7265 	eorvc	r7, pc, r5, ror #4
    1ddc:	61766972 	cmnvs	r6, r2, ror r9
    1de0:	6f576574 	svcvs	0x00576574
    1de4:	70736b72 	rsbsvc	r6, r3, r2, ror fp
    1de8:	2f656361 	svccs	0x00656361
    1dec:	6f686353 	svcvs	0x00686353
    1df0:	4f2f6c6f 	svcmi	0x002f6c6f
    1df4:	50532f53 	subspl	r2, r3, r3, asr pc
    1df8:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
    1dfc:	4f54522d 	svcmi	0x0054522d
    1e00:	6f732f53 	svcvs	0x00732f53
    1e04:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    1e08:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
    1e0c:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
    1e10:	636e692f 	cmnvs	lr, #770048	; 0xbc000
    1e14:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
    1e18:	616f622f 	cmnvs	pc, pc, lsr #4
    1e1c:	722f6472 	eorvc	r6, pc, #1912602624	; 0x72000000
    1e20:	2f306970 	svccs	0x00306970
    1e24:	006c6168 	rsbeq	r6, ip, r8, ror #2
    1e28:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
    1e2c:	752f632f 	strvc	r6, [pc, #-815]!	; 1b05 <_start-0x64fb>
    1e30:	2f726573 	svccs	0x00726573
    1e34:	76697270 			; <UNDEFINED> instruction: 0x76697270
    1e38:	57657461 	strbpl	r7, [r5, -r1, ror #8]!
    1e3c:	736b726f 	cmnvc	fp, #-268435450	; 0xf0000006
    1e40:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
    1e44:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
    1e48:	2f6c6f6f 	svccs	0x006c6f6f
    1e4c:	532f534f 			; <UNDEFINED> instruction: 0x532f534f
    1e50:	494b2f50 	stmdbmi	fp, {r4, r6, r8, r9, sl, fp, sp}^
    1e54:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
    1e58:	732f534f 			; <UNDEFINED> instruction: 0x732f534f
    1e5c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    1e60:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
    1e64:	74756474 	ldrbtvc	r6, [r5], #-1140	; 0xfffffb8c
    1e68:	2f736c69 	svccs	0x00736c69
    1e6c:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
    1e70:	00656475 	rsbeq	r6, r5, r5, ror r4
    1e74:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
    1e78:	752f632f 	strvc	r6, [pc, #-815]!	; 1b51 <_start-0x64af>
    1e7c:	2f726573 	svccs	0x00726573
    1e80:	76697270 			; <UNDEFINED> instruction: 0x76697270
    1e84:	57657461 	strbpl	r7, [r5, -r1, ror #8]!
    1e88:	736b726f 	cmnvc	fp, #-268435450	; 0xf0000006
    1e8c:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
    1e90:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
    1e94:	2f6c6f6f 	svccs	0x006c6f6f
    1e98:	532f534f 			; <UNDEFINED> instruction: 0x532f534f
    1e9c:	494b2f50 	stmdbmi	fp, {r4, r6, r8, r9, sl, fp, sp}^
    1ea0:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
    1ea4:	732f534f 			; <UNDEFINED> instruction: 0x732f534f
    1ea8:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    1eac:	6b2f7365 	blvs	bdec48 <__bss_end+0xbd3534>
    1eb0:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    1eb4:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
    1eb8:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
    1ebc:	72702f65 	rsbsvc	r2, r0, #404	; 0x194
    1ec0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1ec4:	6d2f0073 	stcvs	0, cr0, [pc, #-460]!	; 1d00 <_start-0x6300>
    1ec8:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
    1ecc:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
    1ed0:	72702f72 	rsbsvc	r2, r0, #456	; 0x1c8
    1ed4:	74617669 	strbtvc	r7, [r1], #-1641	; 0xfffff997
    1ed8:	726f5765 	rsbvc	r5, pc, #26476544	; 0x1940000
    1edc:	6170736b 	cmnvs	r0, fp, ror #6
    1ee0:	532f6563 			; <UNDEFINED> instruction: 0x532f6563
    1ee4:	6f6f6863 	svcvs	0x006f6863
    1ee8:	534f2f6c 	movtpl	r2, #65388	; 0xff6c
    1eec:	2f50532f 	svccs	0x0050532f
    1ef0:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
    1ef4:	534f5452 	movtpl	r5, #62546	; 0xf452
    1ef8:	756f732f 	strbvc	r7, [pc, #-815]!	; 1bd1 <_start-0x642f>
    1efc:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    1f00:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    1f04:	2f6c656e 	svccs	0x006c656e
    1f08:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
    1f0c:	2f656475 	svccs	0x00656475
    1f10:	00007366 	andeq	r7, r0, r6, ror #6
    1f14:	5f646e72 	svcpl	0x00646e72
    1f18:	656e6567 	strbvs	r6, [lr, #-1383]!	; 0xfffffa99
    1f1c:	6f746172 	svcvs	0x00746172
    1f20:	70632e72 	rsbvc	r2, r3, r2, ror lr
    1f24:	00010070 	andeq	r0, r1, r0, ror r0
    1f28:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
    1f2c:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
    1f30:	00020068 	andeq	r0, r2, r8, rrx
    1f34:	646e7200 	strbtvs	r7, [lr], #-512	; 0xfffffe00
    1f38:	6e65675f 	mcrvs	7, 3, r6, cr5, cr15, {2}
    1f3c:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
    1f40:	682e726f 	stmdavs	lr!, {r0, r1, r2, r3, r5, r6, r9, ip, sp, lr}
    1f44:	00000300 	andeq	r0, r0, r0, lsl #6
    1f48:	2e697773 	mcrcs	7, 3, r7, cr9, cr3, {3}
    1f4c:	00040068 	andeq	r0, r4, r8, rrx
    1f50:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
    1f54:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
    1f58:	00682e6b 	rsbeq	r2, r8, fp, ror #28
    1f5c:	66000004 	strvs	r0, [r0], -r4
    1f60:	73656c69 	cmnvc	r5, #26880	; 0x6900
    1f64:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
    1f68:	00682e6d 	rsbeq	r2, r8, sp, ror #28
    1f6c:	70000005 	andvc	r0, r0, r5
    1f70:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1f74:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
    1f78:	00000400 	andeq	r0, r0, r0, lsl #8
    1f7c:	636f7270 	cmnvs	pc, #112, 4
    1f80:	5f737365 	svcpl	0x00737365
    1f84:	616e616d 	cmnvs	lr, sp, ror #2
    1f88:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
    1f8c:	00040068 	andeq	r0, r4, r8, rrx
    1f90:	3c050000 	stccc	0, cr0, [r5], {-0}
    1f94:	a8020500 	stmdage	r2, {r8, sl}
    1f98:	170000ac 	strne	r0, [r0, -ip, lsr #1]
    1f9c:	05bb1105 	ldreq	r1, [fp, #261]!	; 0x105
    1fa0:	0105d61f 	tsteq	r5, pc, lsl r6
    1fa4:	6d3a054b 	cfldr32vs	mvfx0, [sl, #-300]!	; 0xfffffed4
    1fa8:	05bb0605 	ldreq	r0, [fp, #1541]!	; 0x605
    1fac:	0a054a02 	beq	1547bc <__bss_end+0x1490a8>
    1fb0:	4d07054b 	cfstr32mi	mvfx0, [r7, #-300]	; 0xfffffed4
    1fb4:	054b0605 	strbeq	r0, [fp, #-1541]	; 0xfffff9fb
    1fb8:	3305bb0a 	movwcc	fp, #23306	; 0x5b0a
    1fbc:	2e0b0584 	cfsh32cs	mvfx0, mvfx11, #-60
    1fc0:	054b3105 	strbeq	r3, [fp, #-261]	; 0xfffffefb
    1fc4:	31056655 	tstcc	r5, r5, asr r6
    1fc8:	2e5e059e 	mrccs	5, 2, r0, cr14, cr14, {4}
    1fcc:	05660805 	strbeq	r0, [r6, #-2053]!	; 0xfffff7fb
    1fd0:	01054c09 	tsteq	r5, r9, lsl #24
    1fd4:	01040200 	mrseq	r0, R12_usr
    1fd8:	a032052f 	eorsge	r0, r2, pc, lsr #10
    1fdc:	059f0b05 	ldreq	r0, [pc, #2821]	; 2ae9 <_start-0x5517>
    1fe0:	08026701 	stmdaeq	r2, {r0, r8, r9, sl, sp, lr}
    1fe4:	a2010100 	andge	r0, r1, #0, 2
    1fe8:	03000002 	movweq	r0, #2
    1fec:	00013800 	andeq	r3, r1, r0, lsl #16
    1ff0:	fb010200 	blx	427fa <__bss_end+0x370e6>
    1ff4:	01000d0e 	tsteq	r0, lr, lsl #26
    1ff8:	00010101 	andeq	r0, r1, r1, lsl #2
    1ffc:	00010000 	andeq	r0, r1, r0
    2000:	6d2f0100 	stfvss	f0, [pc, #-0]	; 2008 <_start-0x5ff8>
    2004:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
    2008:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
    200c:	72702f72 	rsbsvc	r2, r0, #456	; 0x1c8
    2010:	74617669 	strbtvc	r7, [r1], #-1641	; 0xfffff997
    2014:	726f5765 	rsbvc	r5, pc, #26476544	; 0x1940000
    2018:	6170736b 	cmnvs	r0, fp, ror #6
    201c:	532f6563 			; <UNDEFINED> instruction: 0x532f6563
    2020:	6f6f6863 	svcvs	0x006f6863
    2024:	534f2f6c 	movtpl	r2, #65388	; 0xff6c
    2028:	2f50532f 	svccs	0x0050532f
    202c:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
    2030:	534f5452 	movtpl	r5, #62546	; 0xf452
    2034:	756f732f 	strbvc	r7, [pc, #-815]!	; 1d0d <_start-0x62f3>
    2038:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    203c:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    2040:	6c697475 	cfstrdvs	mvd7, [r9], #-468	; 0xfffffe2c
    2044:	72732f73 	rsbsvc	r2, r3, #460	; 0x1cc
    2048:	6d2f0063 	stcvs	0, cr0, [pc, #-396]!	; 1ec4 <_start-0x613c>
    204c:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
    2050:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
    2054:	72702f72 	rsbsvc	r2, r0, #456	; 0x1c8
    2058:	74617669 	strbtvc	r7, [r1], #-1641	; 0xfffff997
    205c:	726f5765 	rsbvc	r5, pc, #26476544	; 0x1940000
    2060:	6170736b 	cmnvs	r0, fp, ror #6
    2064:	532f6563 			; <UNDEFINED> instruction: 0x532f6563
    2068:	6f6f6863 	svcvs	0x006f6863
    206c:	534f2f6c 	movtpl	r2, #65388	; 0xff6c
    2070:	2f50532f 	svccs	0x0050532f
    2074:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
    2078:	534f5452 	movtpl	r5, #62546	; 0xf452
    207c:	756f732f 	strbvc	r7, [pc, #-815]!	; 1d55 <_start-0x62ab>
    2080:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    2084:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    2088:	6c697475 	cfstrdvs	mvd7, [r9], #-468	; 0xfffffe2c
    208c:	6e692f73 	mcrvs	15, 3, r2, cr9, cr3, {3}
    2090:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
    2094:	6d2f0065 	stcvs	0, cr0, [pc, #-404]!	; 1f08 <_start-0x60f8>
    2098:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
    209c:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
    20a0:	72702f72 	rsbsvc	r2, r0, #456	; 0x1c8
    20a4:	74617669 	strbtvc	r7, [r1], #-1641	; 0xfffff997
    20a8:	726f5765 	rsbvc	r5, pc, #26476544	; 0x1940000
    20ac:	6170736b 	cmnvs	r0, fp, ror #6
    20b0:	532f6563 			; <UNDEFINED> instruction: 0x532f6563
    20b4:	6f6f6863 	svcvs	0x006f6863
    20b8:	534f2f6c 	movtpl	r2, #65388	; 0xff6c
    20bc:	2f50532f 	svccs	0x0050532f
    20c0:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
    20c4:	534f5452 	movtpl	r5, #62546	; 0xf452
    20c8:	756f732f 	strbvc	r7, [pc, #-815]!	; 1da1 <_start-0x625f>
    20cc:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    20d0:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    20d4:	2f6c656e 	svccs	0x006c656e
    20d8:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
    20dc:	2f656475 	svccs	0x00656475
    20e0:	72616f62 	rsbvc	r6, r1, #392	; 0x188
    20e4:	70722f64 	rsbsvc	r2, r2, r4, ror #30
    20e8:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
    20ec:	00006c61 	andeq	r6, r0, r1, ror #24
    20f0:	63726963 	cmnvs	r2, #1622016	; 0x18c000
    20f4:	72616c75 	rsbvc	r6, r1, #29952	; 0x7500
    20f8:	6675625f 			; <UNDEFINED> instruction: 0x6675625f
    20fc:	2e726566 	cdpcs	5, 7, cr6, cr2, cr6, {3}
    2100:	00707063 	rsbseq	r7, r0, r3, rrx
    2104:	63000001 	movwvs	r0, #1
    2108:	75637269 	strbvc	r7, [r3, #-617]!	; 0xfffffd97
    210c:	5f72616c 	svcpl	0x0072616c
    2110:	66667562 	strbtvs	r7, [r6], -r2, ror #10
    2114:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
    2118:	00000200 	andeq	r0, r0, r0, lsl #4
    211c:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
    2120:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
    2124:	00000300 	andeq	r0, r0, r0, lsl #6
    2128:	00010500 	andeq	r0, r1, r0, lsl #10
    212c:	addc0205 	lfmge	f0, 2, [ip, #20]
    2130:	05150000 	ldreq	r0, [r5, #-0]
    2134:	0b058222 	bleq	1629c4 <__bss_end+0x1572b0>
    2138:	2e0a05bb 	mcrcs	5, 0, r0, cr10, cr11, {5}
    213c:	05670105 	strbeq	r0, [r7, #-261]!	; 0xfffffefb
    2140:	1f058735 	svcne	0x00058735
    2144:	4a2c059f 	bmi	b037c8 <__bss_end+0xaf80b4>
    2148:	054a1005 	strbeq	r1, [sl, #-5]
    214c:	4305bb01 	movwmi	fp, #23297	; 0x5b01
    2150:	bb090569 	bllt	2436fc <__bss_end+0x237fe8>
    2154:	054e0805 	strbeq	r0, [lr, #-2053]	; 0xfffff7fb
    2158:	22054a12 	andcs	r4, r5, #73728	; 0x12000
    215c:	4a05052e 	bmi	14361c <__bss_end+0x137f08>
    2160:	054b1505 	strbeq	r1, [fp, #-1285]	; 0xfffffafb
    2164:	13054a2e 	movwne	r4, #23086	; 0x5a2e
    2168:	4d17052e 	cfldr32mi	mvfx0, [r7, #-184]	; 0xffffff48
    216c:	054a2405 	strbeq	r2, [sl, #-1029]	; 0xfffffbfb
    2170:	05054a0e 	streq	r4, [r5, #-2574]	; 0xfffff5f2
    2174:	830d054c 	movwhi	r0, #54604	; 0xd54c
    2178:	054d0e05 	strbeq	r0, [sp, #-3589]	; 0xfffff1fb
    217c:	04020015 	streq	r0, [r2], #-21	; 0xffffffeb
    2180:	17054a03 	strne	r4, [r5, -r3, lsl #20]
    2184:	03040200 	movweq	r0, #16896	; 0x4200
    2188:	002a052e 	eoreq	r0, sl, lr, lsr #10
    218c:	67020402 	strvs	r0, [r2, -r2, lsl #8]
    2190:	02003405 	andeq	r3, r0, #83886080	; 0x5000000
    2194:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
    2198:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
    219c:	1f052e02 	svcne	0x00052e02
    21a0:	02040200 	andeq	r0, r4, #0, 4
    21a4:	0041052e 	subeq	r0, r1, lr, lsr #10
    21a8:	4a020402 	bmi	831b8 <__bss_end+0x77aa4>
    21ac:	02002105 	andeq	r2, r0, #1073741825	; 0x40000001
    21b0:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
    21b4:	04020010 	streq	r0, [r2], #-16
    21b8:	1a052f02 	bne	14ddc8 <__bss_end+0x1426b4>
    21bc:	02040200 	andeq	r0, r4, #0, 4
    21c0:	0029054a 	eoreq	r0, r9, sl, asr #10
    21c4:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
    21c8:	02001205 	andeq	r1, r0, #1342177280	; 0x50000000
    21cc:	05680204 	strbeq	r0, [r8, #-516]!	; 0xfffffdfc
    21d0:	04020009 	streq	r0, [r2], #-9
    21d4:	12056702 	andne	r6, r5, #524288	; 0x80000
    21d8:	02040200 	andeq	r0, r4, #0, 4
    21dc:	0005054a 	andeq	r0, r5, sl, asr #10
    21e0:	61020402 	tstvs	r2, r2, lsl #8
    21e4:	058a0c05 	streq	r0, [sl, #3077]	; 0xc05
    21e8:	45052f01 	strmi	r2, [r5, #-3841]	; 0xfffff0ff
    21ec:	d91a0585 	ldmdble	sl, {r0, r2, r7, r8, sl}
    21f0:	054a1805 	strbeq	r1, [sl, #-2053]	; 0xfffff7fb
    21f4:	04020035 	streq	r0, [r2], #-53	; 0xffffffcb
    21f8:	25052e01 	strcs	r2, [r5, #-3585]	; 0xfffff1ff
    21fc:	01040200 	mrseq	r0, R12_usr
    2200:	0033054a 	eorseq	r0, r3, sl, asr #10
    2204:	2e010402 	cdpcs	4, 0, cr0, cr1, cr2, {0}
    2208:	054b2205 	strbeq	r2, [fp, #-517]	; 0xfffffdfb
    220c:	09059e2f 	stmdbeq	r5, {r0, r1, r2, r3, r5, r9, sl, fp, ip, pc}
    2210:	6b1e054a 	blvs	783740 <__bss_end+0x77802c>
    2214:	054a2905 	strbeq	r2, [sl, #-2309]	; 0xfffff6fb
    2218:	09052e0d 	stmdbeq	r5, {r0, r2, r3, r9, sl, fp, sp}
    221c:	4b14052e 	blmi	5036dc <__bss_end+0x4f7fc8>
    2220:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
    2224:	79030204 	stmdbvc	r3, {r2, r9}
    2228:	840d054a 	strhi	r0, [sp], #-1354	; 0xfffffab6
    222c:	0a031f05 	beq	c9e48 <__bss_end+0xbe734>
    2230:	2e2f052e 	cfsh64cs	mvdx0, mvdx15, #30
    2234:	054a2d05 	strbeq	r2, [sl, #-3333]	; 0xfffff2fb
    2238:	3c052e10 	stccc	14, cr2, [r5], {16}
    223c:	2f0105ba 	svccs	0x000105ba
    2240:	05693805 	strbeq	r3, [r9, #-2053]!	; 0xfffff7fb
    2244:	1505bb0e 	strne	fp, [r5, #-2830]	; 0xfffff4f2
    2248:	03040200 	movweq	r0, #16896	; 0x4200
    224c:	0017054a 	andseq	r0, r7, sl, asr #10
    2250:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
    2254:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
    2258:	05670204 	strbeq	r0, [r7, #-516]!	; 0xfffffdfc
    225c:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
    2260:	0e052e02 	cdpeq	14, 0, cr2, cr5, cr2, {0}
    2264:	02040200 	andeq	r0, r4, #0, 4
    2268:	0005054a 	andeq	r0, r5, sl, asr #10
    226c:	81020402 	tsthi	r2, r2, lsl #8
    2270:	05850105 	streq	r0, [r5, #261]	; 0x105
    2274:	0c056929 			; <UNDEFINED> instruction: 0x0c056929
    2278:	4a1705bb 	bmi	5c396c <__bss_end+0x5b8258>
    227c:	052e2605 	streq	r2, [lr, #-1541]!	; 0xfffff9fb
    2280:	0f056705 	svceq	0x00056705
    2284:	6701054a 	strvs	r0, [r1, -sl, asr #10]
    2288:	01000802 	tsteq	r0, r2, lsl #16
    228c:	0001f101 	andeq	pc, r1, r1, lsl #2
    2290:	0c000300 	stceq	3, cr0, [r0], {-0}
    2294:	02000001 	andeq	r0, r0, #1
    2298:	0d0efb01 	vstreq	d15, [lr, #-4]
    229c:	01010100 	mrseq	r0, (UNDEF: 17)
    22a0:	00000001 	andeq	r0, r0, r1
    22a4:	01000001 	tsteq	r0, r1
    22a8:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 21f4 <_start-0x5e0c>
    22ac:	75622f65 	strbvc	r2, [r2, #-3941]!	; 0xfffff09b
    22b0:	6f646c69 	svcvs	0x00646c69
    22b4:	2f72657a 	svccs	0x0072657a
    22b8:	726f7061 	rsbvc	r7, pc, #97	; 0x61
    22bc:	632f7374 			; <UNDEFINED> instruction: 0x632f7374
    22c0:	756d6d6f 	strbvc	r6, [sp, #-3439]!	; 0xfffff291
    22c4:	7974696e 	ldmdbvc	r4!, {r1, r2, r3, r5, r6, r8, fp, sp, lr}^
    22c8:	77656e2f 	strbvc	r6, [r5, -pc, lsr #28]!
    22cc:	2f62696c 	svccs	0x0062696c
    22d0:	2f637273 	svccs	0x00637273
    22d4:	6c77656e 	cfldr64vs	mvdx6, [r7], #-440	; 0xfffffe48
    22d8:	342d6269 	strtcc	r6, [sp], #-617	; 0xfffffd97
    22dc:	302e312e 	eorcc	r3, lr, lr, lsr #2
    22e0:	77656e2f 	strbvc	r6, [r5, -pc, lsr #28]!
    22e4:	2f62696c 	svccs	0x0062696c
    22e8:	6362696c 	cmnvs	r2, #108, 18	; 0x1b0000
    22ec:	63616d2f 	cmnvs	r1, #3008	; 0xbc0
    22f0:	656e6968 	strbvs	r6, [lr, #-2408]!	; 0xfffff698
    22f4:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    22f8:	2f2e2e2f 	svccs	0x002e2e2f
    22fc:	732f2e2e 			; <UNDEFINED> instruction: 0x732f2e2e
    2300:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    2304:	752f0067 	strvc	r0, [pc, #-103]!	; 22a5 <_start-0x5d5b>
    2308:	6c2f7273 	sfmvs	f7, 4, [pc], #-460	; 2144 <_start-0x5ebc>
    230c:	672f6269 	strvs	r6, [pc, -r9, ror #4]!
    2310:	612f6363 			; <UNDEFINED> instruction: 0x612f6363
    2314:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    2318:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    231c:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    2320:	2e30312f 	rsfcssp	f3, f0, #10.0
    2324:	2f302e33 	svccs	0x00302e33
    2328:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
    232c:	00656475 	rsbeq	r6, r5, r5, ror r4
    2330:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 227c <_start-0x5d84>
    2334:	75622f65 	strbvc	r2, [r2, #-3941]!	; 0xfffff09b
    2338:	6f646c69 	svcvs	0x00646c69
    233c:	2f72657a 	svccs	0x0072657a
    2340:	726f7061 	rsbvc	r7, pc, #97	; 0x61
    2344:	632f7374 			; <UNDEFINED> instruction: 0x632f7374
    2348:	756d6d6f 	strbvc	r6, [sp, #-3439]!	; 0xfffff291
    234c:	7974696e 	ldmdbvc	r4!, {r1, r2, r3, r5, r6, r8, fp, sp, lr}^
    2350:	77656e2f 	strbvc	r6, [r5, -pc, lsr #28]!
    2354:	2f62696c 	svccs	0x0062696c
    2358:	2f637273 	svccs	0x00637273
    235c:	6c77656e 	cfldr64vs	mvdx6, [r7], #-440	; 0xfffffe48
    2360:	342d6269 	strtcc	r6, [sp], #-617	; 0xfffffd97
    2364:	302e312e 	eorcc	r3, lr, lr, lsr #2
    2368:	77656e2f 	strbvc	r6, [r5, -pc, lsr #28]!
    236c:	2f62696c 	svccs	0x0062696c
    2370:	6362696c 	cmnvs	r2, #108, 18	; 0x1b0000
    2374:	636e692f 	cmnvs	lr, #770048	; 0xbc000
    2378:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
    237c:	656d0000 	strbvs	r0, [sp, #-0]!
    2380:	7970636d 	ldmdbvc	r0!, {r0, r2, r3, r5, r6, r8, r9, sp, lr}^
    2384:	0100632e 	tsteq	r0, lr, lsr #6
    2388:	74730000 	ldrbtvc	r0, [r3], #-0
    238c:	66656464 	strbtvs	r6, [r5], -r4, ror #8
    2390:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
    2394:	74730000 	ldrbtvc	r0, [r3], #-0
    2398:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    239c:	0300682e 	movweq	r6, #2094	; 0x82e
    23a0:	05000000 	streq	r0, [r0, #-0]
    23a4:	02050001 	andeq	r0, r5, #1
    23a8:	0000b2d8 	ldrdeq	fp, [r0], -r8
    23ac:	05013303 	streq	r3, [r1, #-771]	; 0xfffffcfd
    23b0:	010e0303 	tsteq	lr, r3, lsl #6
    23b4:	19060605 	stmdbne	r6, {r0, r2, r9, sl}
    23b8:	03060305 	movweq	r0, #25349	; 0x6305
    23bc:	13132e7a 	tstne	r3, #1952	; 0x7a0
    23c0:	06060516 			; <UNDEFINED> instruction: 0x06060516
    23c4:	001c0501 	andseq	r0, ip, r1, lsl #10
    23c8:	2e010402 	cdpcs	4, 0, cr0, cr1, cr2, {0}
    23cc:	02001805 	andeq	r1, r0, #327680	; 0x50000
    23d0:	052e0104 	streq	r0, [lr, #-260]!	; 0xfffffefc
    23d4:	666b0301 	strbtvs	r0, [fp], -r1, lsl #6
    23d8:	03060b05 	movweq	r0, #27397	; 0x6b05
    23dc:	1a05d61d 	bne	177c58 <__bss_end+0x16c544>
    23e0:	2c2f1306 	stccs	3, cr1, [pc], #-24	; 23d0 <_start-0x5c30>
    23e4:	2b0d052f 	blcs	3438a8 <__bss_end+0x338194>
    23e8:	05331a05 	ldreq	r1, [r3, #-2565]!	; 0xfffff5fb
    23ec:	1a05290d 	bne	14c828 <__bss_end+0x141114>
    23f0:	060b0530 			; <UNDEFINED> instruction: 0x060b0530
    23f4:	1a05132f 	bne	1470b8 <__bss_end+0x13b9a4>
    23f8:	0b051306 	bleq	147018 <__bss_end+0x13b904>
    23fc:	0d052f06 	stceq	15, cr2, [r5, #-24]	; 0xffffffe8
    2400:	06017a03 	streq	r7, [r1], -r3, lsl #20
    2404:	05660a03 	strbeq	r0, [r6, #-2563]!	; 0xfffff5fd
    2408:	28052a10 	stmdacs	r5, {r4, r9, fp, sp}
    240c:	330d052d 	movwcc	r0, #54573	; 0xd52d
    2410:	05291705 	streq	r1, [r9, #-1797]!	; 0xfffff8fb
    2414:	0533060d 	ldreq	r0, [r3, #-1549]!	; 0xfffff9f3
    2418:	05b50628 	ldreq	r0, [r5, #1576]!	; 0x628
    241c:	0535060b 	ldreq	r0, [r5, #-1547]!	; 0xfffff9f5
    2420:	2e01061a 	mcrcs	6, 0, r0, cr1, cr10, {0}
    2424:	2f060b05 	svccs	0x00060b05
    2428:	050f0d05 	streq	r0, [pc, #-3333]	; 172b <_start-0x68d5>
    242c:	05690610 	strbeq	r0, [r9, #-1552]!	; 0xfffff9f0
    2430:	28052d17 	stmdacs	r5, {r0, r1, r2, r4, r8, sl, fp, sp}
    2434:	0609052e 	streq	r0, [r9], -lr, lsr #10
    2438:	052e0903 	streq	r0, [lr, #-2307]!	; 0xfffff6fd
    243c:	052e060e 	streq	r0, [lr, #-1550]!	; 0xfffff9f2
    2440:	054a2e09 	strbeq	r2, [sl, #-3593]	; 0xfffff1f7
    2444:	054b0605 	strbeq	r0, [fp, #-1541]	; 0xfffff9fb
    2448:	2e01060c 	cfmadd32cs	mvax0, mvfx0, mvfx1, mvfx12
    244c:	2d060905 	vstrcs.16	s0, [r6, #-10]	; <UNPREDICTABLE>
    2450:	03660106 	cmneq	r6, #-2147483647	; 0x80000001
    2454:	03062e5e 	movweq	r2, #28254	; 0x6e5e
    2458:	0e052e22 	cdpeq	14, 0, cr2, cr5, cr2, {1}
    245c:	09050106 	stmdbeq	r5, {r1, r2, r8}
    2460:	052e2e2e 	streq	r2, [lr, #-3630]!	; 0xfffff1d2
    2464:	054b0605 	strbeq	r0, [fp, #-1541]	; 0xfffff9fb
    2468:	2e01060c 	cfmadd32cs	mvax0, mvfx0, mvfx1, mvfx12
    246c:	2d060905 	vstrcs.16	s0, [r6, #-10]	; <UNPREDICTABLE>
    2470:	66060106 	strvs	r0, [r6], -r6, lsl #2
    2474:	01060e05 	tsteq	r6, r5, lsl #28
    2478:	5e030905 	vmlapl.f16	s0, s6, s10	; <UNPREDICTABLE>
    247c:	0004022e 	andeq	r0, r4, lr, lsr #4
    2480:	Address 0x0000000000002480 is out of bounds.


Disassembly of section .debug_info:

00000000 <.debug_info>:
       0:	00000022 	andeq	r0, r0, r2, lsr #32
       4:	00000002 	andeq	r0, r0, r2
       8:	01040000 	mrseq	r0, (UNDEF: 4)
       c:	00000000 	andeq	r0, r0, r0
      10:	00008000 	andeq	r8, r0, r0
      14:	00008008 	andeq	r8, r0, r8
      18:	00000000 	andeq	r0, r0, r0
      1c:	0000004c 	andeq	r0, r0, ip, asr #32
      20:	00000097 	muleq	r0, r7, r0
      24:	00a48001 	adceq	r8, r4, r1
      28:	00040000 	andeq	r0, r4, r0
      2c:	00000014 	andeq	r0, r0, r4, lsl r0
      30:	00d00104 	sbcseq	r0, r0, r4, lsl #2
      34:	4f0c0000 	svcmi	0x000c0000
      38:	4c000001 	stcmi	0, cr0, [r0], {1}
      3c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
      40:	9c000080 	stcls	0, cr0, [r0], {128}	; 0x80
      44:	7c000000 	stcvc	0, cr0, [r0], {-0}
      48:	02000000 	andeq	r0, r0, #0
      4c:	000000c4 	andeq	r0, r0, r4, asr #1
      50:	31150601 	tstcc	r5, r1, lsl #12
      54:	03000000 	movweq	r0, #0
      58:	1d280704 	stcne	7, cr0, [r8, #-16]!
      5c:	b3020000 	movwlt	r0, #8192	; 0x2000
      60:	01000000 	mrseq	r0, (UNDEF: 0)
      64:	00311507 	eorseq	r1, r1, r7, lsl #10
      68:	9b040000 	blls	100070 <__bss_end+0xf495c>
      6c:	01000001 	tsteq	r0, r1
      70:	8064060f 	rsbhi	r0, r4, pc, lsl #12
      74:	00400000 	subeq	r0, r0, r0
      78:	9c010000 	stcls	0, cr0, [r1], {-0}
      7c:	0000006a 	andeq	r0, r0, sl, rrx
      80:	0000bd05 	andeq	fp, r0, r5, lsl #26
      84:	091a0100 	ldmdbeq	sl, {r8}
      88:	0000006a 	andeq	r0, r0, sl, rrx
      8c:	00749102 	rsbseq	r9, r4, r2, lsl #2
      90:	69050406 	stmdbvs	r5, {r1, r2, sl}
      94:	0700746e 	streq	r7, [r0, -lr, ror #8]
      98:	000000a3 	andeq	r0, r0, r3, lsr #1
      9c:	08060901 	stmdaeq	r6, {r0, r8, fp}
      a0:	5c000080 	stcpl	0, cr0, [r0], {128}	; 0x80
      a4:	01000000 	mrseq	r0, (UNDEF: 0)
      a8:	0000a19c 	muleq	r0, ip, r1
      ac:	80140800 	andshi	r0, r4, r0, lsl #16
      b0:	00340000 	eorseq	r0, r4, r0
      b4:	63090000 	movwvs	r0, #36864	; 0x9000
      b8:	01007275 	tsteq	r0, r5, ror r2
      bc:	00a1180b 	adceq	r1, r1, fp, lsl #16
      c0:	91020000 	mrsls	r0, (UNDEF: 2)
      c4:	0a000074 	beq	29c <_start-0x7d64>
      c8:	00003104 	andeq	r3, r0, r4, lsl #2
      cc:	02020000 	andeq	r0, r2, #0
      d0:	00040000 	andeq	r0, r4, r0
      d4:	000000b9 	strheq	r0, [r0], -r9
      d8:	02330104 	eorseq	r0, r3, #4, 2
      dc:	0c040000 	stceq	0, cr0, [r4], {-0}
      e0:	4c000003 	stcmi	0, cr0, [r0], {3}
      e4:	a4000000 	strge	r0, [r0], #-0
      e8:	88000080 	stmdahi	r0, {r7}
      ec:	27000001 	strcs	r0, [r0, -r1]
      f0:	02000001 	andeq	r0, r0, #1
      f4:	0000037c 	andeq	r0, r0, ip, ror r3
      f8:	31072f01 	tstcc	r7, r1, lsl #30
      fc:	03000000 	movweq	r0, #0
     100:	00003704 	andeq	r3, r0, r4, lsl #14
     104:	ce020400 	cfcpysgt	mvf0, mvf2
     108:	01000002 	tsteq	r0, r2
     10c:	00310730 	eorseq	r0, r1, r0, lsr r7
     110:	25050000 	strcs	r0, [r5, #-0]
     114:	57000000 	strpl	r0, [r0, -r0]
     118:	06000000 	streq	r0, [r0], -r0
     11c:	00000057 	andeq	r0, r0, r7, asr r0
     120:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
     124:	07040700 	streq	r0, [r4, -r0, lsl #14]
     128:	00001d28 	andeq	r1, r0, r8, lsr #26
     12c:	00036e08 	andeq	r6, r3, r8, lsl #28
     130:	15330100 	ldrne	r0, [r3, #-256]!	; 0xffffff00
     134:	00000044 	andeq	r0, r0, r4, asr #32
     138:	00020b08 	andeq	r0, r2, r8, lsl #22
     13c:	15350100 	ldrne	r0, [r5, #-256]!	; 0xffffff00
     140:	00000044 	andeq	r0, r0, r4, asr #32
     144:	00003805 	andeq	r3, r0, r5, lsl #16
     148:	00008900 	andeq	r8, r0, r0, lsl #18
     14c:	00570600 	subseq	r0, r7, r0, lsl #12
     150:	ffff0000 			; <UNDEFINED> instruction: 0xffff0000
     154:	0800ffff 	stmdaeq	r0, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, sp, lr, pc}
     158:	00000225 	andeq	r0, r0, r5, lsr #4
     15c:	76153801 	ldrvc	r3, [r5], -r1, lsl #16
     160:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
     164:	000002d7 	ldrdeq	r0, [r0], -r7
     168:	76153a01 	ldrvc	r3, [r5], -r1, lsl #20
     16c:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     170:	000001c5 	andeq	r0, r0, r5, asr #3
     174:	cb104801 	blgt	412180 <__bss_end+0x406a6c>
     178:	d4000000 	strle	r0, [r0], #-0
     17c:	58000081 	stmdapl	r0, {r0, r7}
     180:	01000000 	mrseq	r0, (UNDEF: 0)
     184:	0000cb9c 	muleq	r0, ip, fp
     188:	01d30a00 	bicseq	r0, r3, r0, lsl #20
     18c:	4a010000 	bmi	40194 <__bss_end+0x34a80>
     190:	0000d20c 	andeq	sp, r0, ip, lsl #4
     194:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     198:	05040b00 	streq	r0, [r4, #-2816]	; 0xfffff500
     19c:	00746e69 	rsbseq	r6, r4, r9, ror #28
     1a0:	00380403 	eorseq	r0, r8, r3, lsl #8
     1a4:	ff090000 			; <UNDEFINED> instruction: 0xff090000
     1a8:	01000002 	tsteq	r0, r2
     1ac:	00cb103c 	sbceq	r1, fp, ip, lsr r0
     1b0:	817c0000 	cmnhi	ip, r0
     1b4:	00580000 	subseq	r0, r8, r0
     1b8:	9c010000 	stcls	0, cr0, [r1], {-0}
     1bc:	00000102 	andeq	r0, r0, r2, lsl #2
     1c0:	0001d30a 	andeq	sp, r1, sl, lsl #6
     1c4:	0c3e0100 	ldfeqs	f0, [lr], #-0
     1c8:	00000102 	andeq	r0, r0, r2, lsl #2
     1cc:	00749102 	rsbseq	r9, r4, r2, lsl #2
     1d0:	00250403 	eoreq	r0, r5, r3, lsl #8
     1d4:	ae0c0000 	cdpge	0, 0, cr0, cr12, cr0, {0}
     1d8:	01000001 	tsteq	r0, r1
     1dc:	81701129 	cmnhi	r0, r9, lsr #2
     1e0:	000c0000 	andeq	r0, ip, r0
     1e4:	9c010000 	stcls	0, cr0, [r1], {-0}
     1e8:	0001e40c 	andeq	lr, r1, ip, lsl #8
     1ec:	11240100 			; <UNDEFINED> instruction: 0x11240100
     1f0:	00008158 	andeq	r8, r0, r8, asr r1
     1f4:	00000018 	andeq	r0, r0, r8, lsl r0
     1f8:	e40c9c01 	str	r9, [ip], #-3073	; 0xfffff3ff
     1fc:	01000002 	tsteq	r0, r2
     200:	8140111f 	cmphi	r0, pc, lsl r1
     204:	00180000 	andseq	r0, r8, r0
     208:	9c010000 	stcls	0, cr0, [r1], {-0}
     20c:	0002180c 	andeq	r1, r2, ip, lsl #16
     210:	111a0100 	tstne	sl, r0, lsl #2
     214:	00008128 	andeq	r8, r0, r8, lsr #2
     218:	00000018 	andeq	r0, r0, r8, lsl r0
     21c:	d90d9c01 	stmdble	sp, {r0, sl, fp, ip, pc}
     220:	02000001 	andeq	r0, r0, #1
     224:	00019e00 	andeq	r9, r1, r0, lsl #28
     228:	035c0e00 	cmpeq	ip, #0, 28
     22c:	14010000 	strne	r0, [r1], #-0
     230:	00016d12 	andeq	r6, r1, r2, lsl sp
     234:	019e0f00 	orrseq	r0, lr, r0, lsl #30
     238:	02000000 	andeq	r0, r0, #0
     23c:	000001a6 	andeq	r0, r0, r6, lsr #3
     240:	a41c0401 	ldrge	r0, [ip], #-1025	; 0xfffffbff
     244:	0e000001 	cdpeq	0, 0, cr0, cr0, cr1, {0}
     248:	000001f7 	strdeq	r0, [r0], -r7
     24c:	8b120f01 	blhi	483e58 <__bss_end+0x478744>
     250:	0f000001 	svceq	0x00000001
     254:	0000019e 	muleq	r0, lr, r1
     258:	03851000 	orreq	r1, r5, #0
     25c:	0a010000 	beq	40264 <__bss_end+0x34b50>
     260:	0000cb11 	andeq	ip, r0, r1, lsl fp
     264:	019e0f00 	orrseq	r0, lr, r0, lsl #30
     268:	00000000 	andeq	r0, r0, r0
     26c:	016d0403 	cmneq	sp, r3, lsl #8
     270:	08070000 	stmdaeq	r7, {}	; <UNPREDICTABLE>
     274:	0002f105 	andeq	pc, r2, r5, lsl #2
     278:	015b1100 	cmpeq	fp, r0, lsl #2
     27c:	81080000 	mrshi	r0, (UNDEF: 8)
     280:	00200000 	eoreq	r0, r0, r0
     284:	9c010000 	stcls	0, cr0, [r1], {-0}
     288:	000001c7 	andeq	r0, r0, r7, asr #3
     28c:	00019e12 	andeq	r9, r1, r2, lsl lr
     290:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     294:	01791100 	cmneq	r9, r0, lsl #2
     298:	80dc0000 	sbcshi	r0, ip, r0
     29c:	002c0000 	eoreq	r0, ip, r0
     2a0:	9c010000 	stcls	0, cr0, [r1], {-0}
     2a4:	000001e8 	andeq	r0, r0, r8, ror #3
     2a8:	01006713 	tsteq	r0, r3, lsl r7
     2ac:	019e300f 	orrseq	r3, lr, pc
     2b0:	91020000 	mrsls	r0, (UNDEF: 2)
     2b4:	8b140074 	blhi	50048c <__bss_end+0x4f4d78>
     2b8:	a4000001 	strge	r0, [r0], #-1
     2bc:	38000080 	stmdacc	r0, {r7}
     2c0:	01000000 	mrseq	r0, (UNDEF: 0)
     2c4:	0067139c 	mlseq	r7, ip, r3, r1
     2c8:	9e2f0a01 	vmulls.f32	s0, s30, s2
     2cc:	02000001 	andeq	r0, r0, #1
     2d0:	00007491 	muleq	r0, r1, r4
     2d4:	00001159 	andeq	r1, r0, r9, asr r1
     2d8:	01e00004 	mvneq	r0, r4
     2dc:	01040000 	mrseq	r0, (UNDEF: 4)
     2e0:	00000233 	andeq	r0, r0, r3, lsr r2
     2e4:	00065204 	andeq	r5, r6, r4, lsl #4
     2e8:	00004c00 	andeq	r4, r0, r0, lsl #24
     2ec:	00823000 	addeq	r3, r2, r0
     2f0:	000b7000 	andeq	r7, fp, r0
     2f4:	00022800 	andeq	r2, r2, r0, lsl #16
     2f8:	08010200 	stmdaeq	r1, {r9}
     2fc:	00000daa 	andeq	r0, r0, sl, lsr #27
     300:	00002503 	andeq	r2, r0, r3, lsl #10
     304:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
     308:	00000e39 	andeq	r0, r0, r9, lsr lr
     30c:	000ed604 	andeq	sp, lr, r4, lsl #12
     310:	07050200 	streq	r0, [r5, -r0, lsl #4]
     314:	00000044 	andeq	r0, r0, r4, asr #32
     318:	69050405 	stmdbvs	r5, {r0, r2, sl}
     31c:	0600746e 	streq	r7, [r0], -lr, ror #8
     320:	00000044 	andeq	r0, r0, r4, asr #32
     324:	a1080102 	tstge	r8, r2, lsl #2
     328:	0200000d 	andeq	r0, r0, #13
     32c:	0a1b0702 	beq	6c1f3c <__bss_end+0x6b6828>
     330:	d5040000 	strle	r0, [r4, #-0]
     334:	0200000e 	andeq	r0, r0, #14
     338:	006f0709 	rsbeq	r0, pc, r9, lsl #14
     33c:	5e030000 	cdppl	0, 0, cr0, cr3, cr0, {0}
     340:	02000000 	andeq	r0, r0, #0
     344:	1d280704 	stcne	7, cr0, [r8, #-16]!
     348:	0c070000 	stceq	0, cr0, [r7], {-0}
     34c:	08000008 	stmdaeq	r0, {r3}
     350:	9c080603 	stcls	6, cr0, [r8], {3}
     354:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
     358:	03003072 	movweq	r3, #114	; 0x72
     35c:	005e0e08 	subseq	r0, lr, r8, lsl #28
     360:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
     364:	03003172 	movweq	r3, #370	; 0x172
     368:	005e0e09 	subseq	r0, lr, r9, lsl #28
     36c:	00040000 	andeq	r0, r4, r0
     370:	0005b309 	andeq	fp, r5, r9, lsl #6
     374:	44040500 	strmi	r0, [r4], #-1280	; 0xfffffb00
     378:	03000000 	movweq	r0, #0
     37c:	00d30c1f 	sbcseq	r0, r3, pc, lsl ip
     380:	8c0a0000 	stchi	0, cr0, [sl], {-0}
     384:	00000008 	andeq	r0, r0, r8
     388:	0012c30a 	andseq	ip, r2, sl, lsl #6
     38c:	970a0100 	strls	r0, [sl, -r0, lsl #2]
     390:	02000012 	andeq	r0, r0, #18
     394:	000acb0a 	andeq	ip, sl, sl, lsl #22
     398:	d10a0300 	mrsle	r0, (UNDEF: 58)
     39c:	0400000c 	streq	r0, [r0], #-12
     3a0:	0008550a 	andeq	r5, r8, sl, lsl #10
     3a4:	09000500 	stmdbeq	r0, {r8, sl}
     3a8:	00001179 	andeq	r1, r0, r9, ror r1
     3ac:	00440405 	subeq	r0, r4, r5, lsl #8
     3b0:	40030000 	andmi	r0, r3, r0
     3b4:	0001100c 	andeq	r1, r1, ip
     3b8:	03c80a00 	biceq	r0, r8, #0, 20
     3bc:	0a000000 	beq	3c4 <_start-0x7c3c>
     3c0:	000005c8 	andeq	r0, r0, r8, asr #11
     3c4:	0ca00a01 	vstmiaeq	r0!, {s0}
     3c8:	0a020000 	beq	803d0 <__bss_end+0x74cbc>
     3cc:	00001220 	andeq	r1, r0, r0, lsr #4
     3d0:	12cd0a03 	sbcne	r0, sp, #12288	; 0x3000
     3d4:	0a040000 	beq	1003dc <__bss_end+0xf4cc8>
     3d8:	00000bf7 	strdeq	r0, [r0], -r7
     3dc:	0a490a05 	beq	1242bf8 <__bss_end+0x12374e4>
     3e0:	00060000 	andeq	r0, r6, r0
     3e4:	000e8a09 	andeq	r8, lr, r9, lsl #20
     3e8:	44040500 	strmi	r0, [r4], #-1280	; 0xfffffb00
     3ec:	03000000 	movweq	r0, #0
     3f0:	01290c66 			; <UNDEFINED> instruction: 0x01290c66
     3f4:	cc0a0000 	stcgt	0, cr0, [sl], {-0}
     3f8:	0000000c 	andeq	r0, r0, ip
     3fc:	11160900 	tstne	r6, r0, lsl #18
     400:	04050000 	streq	r0, [r5], #-0
     404:	00000044 	andeq	r0, r0, r4, asr #32
     408:	540c6f03 	strpl	r6, [ip], #-3843	; 0xfffff0fd
     40c:	0a000001 	beq	418 <_start-0x7be8>
     410:	00000d76 	andeq	r0, r0, r6, ror sp
     414:	09fd0a00 	ldmibeq	sp!, {r9, fp}^
     418:	0a010000 	beq	40420 <__bss_end+0x34d0c>
     41c:	00000e73 	andeq	r0, r0, r3, ror lr
     420:	0a4e0a02 	beq	1382c30 <__bss_end+0x137751c>
     424:	00030000 	andeq	r0, r3, r0
     428:	000c250b 	andeq	r2, ip, fp, lsl #10
     42c:	14050400 	strne	r0, [r5], #-1024	; 0xfffffc00
     430:	0000006a 	andeq	r0, r0, sl, rrx
     434:	b3f40305 	mvnslt	r0, #335544320	; 0x14000000
     438:	7c0b0000 	stcvc	0, cr0, [fp], {-0}
     43c:	0400000c 	streq	r0, [r0], #-12
     440:	006a1406 	rsbeq	r1, sl, r6, lsl #8
     444:	03050000 	movweq	r0, #20480	; 0x5000
     448:	0000b3f8 	strdeq	fp, [r0], -r8
     44c:	000be10b 	andeq	lr, fp, fp, lsl #2
     450:	1a070500 	bne	1c1858 <__bss_end+0x1b6144>
     454:	0000006a 	andeq	r0, r0, sl, rrx
     458:	b3fc0305 	mvnslt	r0, #335544320	; 0x14000000
     45c:	eb0b0000 	bl	2c0464 <__bss_end+0x2b4d50>
     460:	05000006 	streq	r0, [r0, #-6]
     464:	006a1a09 	rsbeq	r1, sl, r9, lsl #20
     468:	03050000 	movweq	r0, #20480	; 0x5000
     46c:	0000b400 	andeq	fp, r0, r0, lsl #8
     470:	000d810b 	andeq	r8, sp, fp, lsl #2
     474:	1a0b0500 	bne	2c187c <__bss_end+0x2b6168>
     478:	0000006a 	andeq	r0, r0, sl, rrx
     47c:	b4040305 	strlt	r0, [r4], #-773	; 0xfffffcfb
     480:	ea0b0000 	b	2c0488 <__bss_end+0x2b4d74>
     484:	05000009 	streq	r0, [r0, #-9]
     488:	006a1a0d 	rsbeq	r1, sl, sp, lsl #20
     48c:	03050000 	movweq	r0, #20480	; 0x5000
     490:	0000b408 	andeq	fp, r0, r8, lsl #8
     494:	00083e0b 	andeq	r3, r8, fp, lsl #28
     498:	1a0f0500 	bne	3c18a0 <__bss_end+0x3b618c>
     49c:	0000006a 	andeq	r0, r0, sl, rrx
     4a0:	b40c0305 	strlt	r0, [ip], #-773	; 0xfffffcfb
     4a4:	14090000 	strne	r0, [r9], #-0
     4a8:	05000019 	streq	r0, [r0, #-25]	; 0xffffffe7
     4ac:	00004404 	andeq	r4, r0, r4, lsl #8
     4b0:	0c1b0500 	cfldr32eq	mvfx0, [fp], {-0}
     4b4:	000001f7 	strdeq	r0, [r0], -r7
     4b8:	000f4c0a 	andeq	r4, pc, sl, lsl #24
     4bc:	6d0a0000 	stcvs	0, cr0, [sl, #-0]
     4c0:	01000012 	tsteq	r0, r2, lsl r0
     4c4:	000c9b0a 	andeq	r9, ip, sl, lsl #22
     4c8:	0c000200 	sfmeq	f0, 4, [r0], {-0}
     4cc:	00000d62 	andeq	r0, r0, r2, ror #26
     4d0:	e2020102 	and	r0, r2, #-2147483648	; 0x80000000
     4d4:	0d00000a 	stceq	0, cr0, [r0, #-40]	; 0xffffffd8
     4d8:	00002c04 	andeq	r2, r0, r4, lsl #24
     4dc:	f7040d00 			; <UNDEFINED> instruction: 0xf7040d00
     4e0:	0b000001 	bleq	4ec <_start-0x7b14>
     4e4:	0000091e 	andeq	r0, r0, lr, lsl r9
     4e8:	6a140406 	bvs	501508 <__bss_end+0x4f5df4>
     4ec:	05000000 	streq	r0, [r0, #-0]
     4f0:	00b41003 	adcseq	r1, r4, r3
     4f4:	03bd0b00 			; <UNDEFINED> instruction: 0x03bd0b00
     4f8:	07060000 	streq	r0, [r6, -r0]
     4fc:	00006a14 	andeq	r6, r0, r4, lsl sl
     500:	14030500 	strne	r0, [r3], #-1280	; 0xfffffb00
     504:	0b0000b4 	bleq	7dc <_start-0x7824>
     508:	00000733 	andeq	r0, r0, r3, lsr r7
     50c:	6a140a06 	bvs	502d2c <__bss_end+0x4f7618>
     510:	05000000 	streq	r0, [r0, #-0]
     514:	00b41803 	adcseq	r1, r4, r3, lsl #16
     518:	0b450900 	bleq	1142920 <__bss_end+0x113720c>
     51c:	04050000 	streq	r0, [r5], #-0
     520:	00000044 	andeq	r0, r0, r4, asr #32
     524:	7c0c0d06 	stcvc	13, cr0, [ip], {6}
     528:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
     52c:	0077654e 	rsbseq	r6, r7, lr, asr #10
     530:	0b3c0a00 	bleq	f02d38 <__bss_end+0xef7624>
     534:	0a010000 	beq	4053c <__bss_end+0x34e28>
     538:	00000eae 	andeq	r0, r0, lr, lsr #29
     53c:	0b140a02 	bleq	502d4c <__bss_end+0x4f7638>
     540:	0a030000 	beq	c0548 <__bss_end+0xb4e34>
     544:	00000abd 			; <UNDEFINED> instruction: 0x00000abd
     548:	0ca60a04 	vstmiaeq	r6!, {s0-s3}
     54c:	00050000 	andeq	r0, r5, r0
     550:	00084807 	andeq	r4, r8, r7, lsl #16
     554:	1b061000 	blne	18455c <__bss_end+0x178e48>
     558:	0002bb08 	andeq	fp, r2, r8, lsl #22
     55c:	726c0800 	rsbvc	r0, ip, #0, 16
     560:	131d0600 	tstne	sp, #0, 12
     564:	000002bb 			; <UNDEFINED> instruction: 0x000002bb
     568:	70730800 	rsbsvc	r0, r3, r0, lsl #16
     56c:	131e0600 	tstne	lr, #0, 12
     570:	000002bb 			; <UNDEFINED> instruction: 0x000002bb
     574:	63700804 	cmnvs	r0, #4, 16	; 0x40000
     578:	131f0600 	tstne	pc, #0, 12
     57c:	000002bb 			; <UNDEFINED> instruction: 0x000002bb
     580:	085e0f08 	ldmdaeq	lr, {r3, r8, r9, sl, fp}^
     584:	20060000 	andcs	r0, r6, r0
     588:	0002bb13 	andeq	fp, r2, r3, lsl fp
     58c:	02000c00 	andeq	r0, r0, #0, 24
     590:	1d230704 	stcne	7, cr0, [r3, #-16]!
     594:	52070000 	andpl	r0, r7, #0
     598:	80000004 	andhi	r0, r0, r4
     59c:	85082806 	strhi	r2, [r8, #-2054]	; 0xfffff7fa
     5a0:	0f000003 	svceq	0x00000003
     5a4:	00000f40 	andeq	r0, r0, r0, asr #30
     5a8:	7c122a06 			; <UNDEFINED> instruction: 0x7c122a06
     5ac:	00000002 	andeq	r0, r0, r2
     5b0:	64697008 	strbtvs	r7, [r9], #-8
     5b4:	122b0600 	eorne	r0, fp, #0, 12
     5b8:	0000006f 	andeq	r0, r0, pc, rrx
     5bc:	06b80f10 	ssateq	r0, #25, r0, lsl #30
     5c0:	2c060000 	stccs	0, cr0, [r6], {-0}
     5c4:	00024511 	andeq	r4, r2, r1, lsl r5
     5c8:	7f0f1400 	svcvc	0x000f1400
     5cc:	0600000b 	streq	r0, [r0], -fp
     5d0:	006f122d 	rsbeq	r1, pc, sp, lsr #4
     5d4:	0f180000 	svceq	0x00180000
     5d8:	00000b8d 	andeq	r0, r0, sp, lsl #23
     5dc:	6f122e06 	svcvs	0x00122e06
     5e0:	1c000000 	stcne	0, cr0, [r0], {-0}
     5e4:	00082c0f 	andeq	r2, r8, pc, lsl #24
     5e8:	0c2f0600 	stceq	6, cr0, [pc], #-0	; 5f0 <_start-0x7a10>
     5ec:	00000385 	andeq	r0, r0, r5, lsl #7
     5f0:	0ba90f20 	bleq	fea44278 <__bss_end+0xfea38b64>
     5f4:	30060000 	andcc	r0, r6, r0
     5f8:	00004409 	andeq	r4, r0, r9, lsl #8
     5fc:	710f6000 	mrsvc	r6, CPSR
     600:	0600000f 	streq	r0, [r0], -pc
     604:	005e0e31 	subseq	r0, lr, r1, lsr lr
     608:	0f640000 	svceq	0x00640000
     60c:	000008d4 	ldrdeq	r0, [r0], -r4
     610:	5e0e3306 	cdppl	3, 0, cr3, cr14, cr6, {0}
     614:	68000000 	stmdavs	r0, {}	; <UNPREDICTABLE>
     618:	0008cb0f 	andeq	ip, r8, pc, lsl #22
     61c:	0e340600 	cfmsuba32eq	mvax0, mvax0, mvfx4, mvfx0
     620:	0000005e 	andeq	r0, r0, lr, asr r0
     624:	7470086c 	ldrbtvc	r0, [r0], #-2156	; 0xfffff794
     628:	0f350600 	svceq	0x00350600
     62c:	00000395 	muleq	r0, r5, r3
     630:	122b0f70 	eorne	r0, fp, #112, 30	; 0x1c0
     634:	37060000 	strcc	r0, [r6, -r0]
     638:	00005e0e 	andeq	r5, r0, lr, lsl #28
     63c:	180f7400 	stmdane	pc, {sl, ip, sp, lr}	; <UNPREDICTABLE>
     640:	06000008 	streq	r0, [r0], -r8
     644:	005e0e38 	subseq	r0, lr, r8, lsr lr
     648:	0f780000 	svceq	0x00780000
     64c:	00000ec2 	andeq	r0, r0, r2, asr #29
     650:	5e0e3906 	vmlapl.f16	s6, s28, s12	; <UNPREDICTABLE>
     654:	7c000000 	stcvc	0, cr0, [r0], {-0}
     658:	02091000 	andeq	r1, r9, #0
     65c:	03950000 	orrseq	r0, r5, #0
     660:	6f110000 	svcvs	0x00110000
     664:	0f000000 	svceq	0x00000000
     668:	5e040d00 	cdppl	13, 0, cr0, cr4, cr0, {0}
     66c:	0b000000 	bleq	674 <_start-0x798c>
     670:	000011cf 	andeq	r1, r0, pc, asr #3
     674:	6a140a07 	bvs	502e98 <__bss_end+0x4f7784>
     678:	05000000 	streq	r0, [r0, #-0]
     67c:	00b41c03 	adcseq	r1, r4, r3, lsl #24
     680:	0b1c0900 	bleq	702a88 <__bss_end+0x6f7374>
     684:	04050000 	streq	r0, [r5], #-0
     688:	00000044 	andeq	r0, r0, r4, asr #32
     68c:	cc0c0d07 	stcgt	13, cr0, [ip], {7}
     690:	0a000003 	beq	6a4 <_start-0x795c>
     694:	000005dc 	ldrdeq	r0, [r0], -ip
     698:	03b20a00 			; <UNDEFINED> instruction: 0x03b20a00
     69c:	00010000 	andeq	r0, r1, r0
     6a0:	00109107 	andseq	r9, r0, r7, lsl #2
     6a4:	1b070c00 	blne	1c36ac <__bss_end+0x1b7f98>
     6a8:	00040108 	andeq	r0, r4, r8, lsl #2
     6ac:	04240f00 	strteq	r0, [r4], #-3840	; 0xfffff100
     6b0:	1d070000 	stcne	0, cr0, [r7, #-0]
     6b4:	00040119 	andeq	r0, r4, r9, lsl r1
     6b8:	8e0f0000 	cdphi	0, 0, cr0, cr15, cr0, {0}
     6bc:	07000005 	streq	r0, [r0, -r5]
     6c0:	0401191e 	streq	r1, [r1], #-2334	; 0xfffff6e2
     6c4:	0f040000 	svceq	0x00040000
     6c8:	00000fef 	andeq	r0, r0, pc, ror #31
     6cc:	07131f07 	ldreq	r1, [r3, -r7, lsl #30]
     6d0:	08000004 	stmdaeq	r0, {r2}
     6d4:	cc040d00 	stcgt	13, cr0, [r4], {-0}
     6d8:	0d000003 	stceq	0, cr0, [r0, #-12]
     6dc:	0002c204 	andeq	ip, r2, r4, lsl #4
     6e0:	07461200 	strbeq	r1, [r6, -r0, lsl #4]
     6e4:	07140000 	ldreq	r0, [r4, -r0]
     6e8:	06c30722 	strbeq	r0, [r3], r2, lsr #14
     6ec:	0a0f0000 	beq	3c06f4 <__bss_end+0x3b4fe0>
     6f0:	0700000b 	streq	r0, [r0, -fp]
     6f4:	005e1226 	subseq	r1, lr, r6, lsr #4
     6f8:	0f000000 	svceq	0x00000000
     6fc:	000004a1 	andeq	r0, r0, r1, lsr #9
     700:	011d2907 	tsteq	sp, r7, lsl #18
     704:	04000004 	streq	r0, [r0], #-4
     708:	000eeb0f 	andeq	lr, lr, pc, lsl #22
     70c:	1d2c0700 	stcne	7, cr0, [ip, #-0]
     710:	00000401 	andeq	r0, r0, r1, lsl #8
     714:	11521308 	cmpne	r2, r8, lsl #6
     718:	2f070000 	svccs	0x00070000
     71c:	00106e0e 	andseq	r6, r0, lr, lsl #28
     720:	00045500 	andeq	r5, r4, r0, lsl #10
     724:	00046000 	andeq	r6, r4, r0
     728:	06c81400 	strbeq	r1, [r8], r0, lsl #8
     72c:	01150000 	tsteq	r5, r0
     730:	00000004 	andeq	r0, r0, r4
     734:	00100716 	andseq	r0, r0, r6, lsl r7
     738:	0e310700 	cdpeq	7, 3, cr0, cr1, cr0, {0}
     73c:	00000429 	andeq	r0, r0, r9, lsr #8
     740:	000001fc 	strdeq	r0, [r0], -ip
     744:	00000478 	andeq	r0, r0, r8, ror r4
     748:	00000483 	andeq	r0, r0, r3, lsl #9
     74c:	0006c814 	andeq	ip, r6, r4, lsl r8
     750:	04071500 	streq	r1, [r7], #-1280	; 0xfffffb00
     754:	17000000 	strne	r0, [r0, -r0]
     758:	000010b3 	strheq	r1, [r0], -r3
     75c:	ca1d3507 	bgt	74db80 <__bss_end+0x74246c>
     760:	0100000f 	tsteq	r0, pc
     764:	02000004 	andeq	r0, r0, #4
     768:	0000049c 	muleq	r0, ip, r4
     76c:	000004a2 	andeq	r0, r0, r2, lsr #9
     770:	0006c814 	andeq	ip, r6, r4, lsl r8
     774:	3c170000 	ldccc	0, cr0, [r7], {-0}
     778:	0700000a 	streq	r0, [r0, -sl]
     77c:	0de71d37 	stcleq	13, cr1, [r7, #220]!	; 0xdc
     780:	04010000 	streq	r0, [r1], #-0
     784:	bb020000 	bllt	8078c <__bss_end+0x75078>
     788:	c1000004 	tstgt	r0, r4
     78c:	14000004 	strne	r0, [r0], #-4
     790:	000006c8 	andeq	r0, r0, r8, asr #13
     794:	0bd31800 	bleq	ff4c679c <__bss_end+0xff4bb088>
     798:	39070000 	stmdbcc	r7, {}	; <UNPREDICTABLE>
     79c:	0006e131 	andeq	lr, r6, r1, lsr r1
     7a0:	17020c00 	strne	r0, [r2, -r0, lsl #24]
     7a4:	00000746 	andeq	r0, r0, r6, asr #14
     7a8:	9d093c07 	stcls	12, cr3, [r9, #-28]	; 0xffffffe4
     7ac:	c8000012 	stmdagt	r0, {r1, r4}
     7b0:	01000006 	tsteq	r0, r6
     7b4:	000004e8 	andeq	r0, r0, r8, ror #9
     7b8:	000004ee 	andeq	r0, r0, lr, ror #9
     7bc:	0006c814 	andeq	ip, r6, r4, lsl r8
     7c0:	24170000 	ldrcs	r0, [r7], #-0
     7c4:	07000006 	streq	r0, [r0, -r6]
     7c8:	1127123f 			; <UNDEFINED> instruction: 0x1127123f
     7cc:	005e0000 	subseq	r0, lr, r0
     7d0:	07010000 	streq	r0, [r1, -r0]
     7d4:	1c000005 	stcne	0, cr0, [r0], {5}
     7d8:	14000005 	strne	r0, [r0], #-5
     7dc:	000006c8 	andeq	r0, r0, r8, asr #13
     7e0:	0006ea15 	andeq	lr, r6, r5, lsl sl
     7e4:	006f1500 	rsbeq	r1, pc, r0, lsl #10
     7e8:	fc150000 	ldc2	0, cr0, [r5], {-0}
     7ec:	00000001 	andeq	r0, r0, r1
     7f0:	00101619 	andseq	r1, r0, r9, lsl r6
     7f4:	0e420700 	cdpeq	7, 4, cr0, cr2, cr0, {0}
     7f8:	00000d14 	andeq	r0, r0, r4, lsl sp
     7fc:	00053101 	andeq	r3, r5, r1, lsl #2
     800:	00053700 	andeq	r3, r5, r0, lsl #14
     804:	06c81400 	strbeq	r1, [r8], r0, lsl #8
     808:	17000000 	strne	r0, [r0, -r0]
     80c:	00000963 	andeq	r0, r0, r3, ror #18
     810:	fd174507 	ldc2	5, cr4, [r7, #-28]	; 0xffffffe4
     814:	07000004 	streq	r0, [r0, -r4]
     818:	01000004 	tsteq	r0, r4
     81c:	00000550 	andeq	r0, r0, r0, asr r5
     820:	00000556 	andeq	r0, r0, r6, asr r5
     824:	0006f014 	andeq	pc, r6, r4, lsl r0	; <UNPREDICTABLE>
     828:	93170000 	tstls	r7, #0
     82c:	07000005 	streq	r0, [r0, -r5]
     830:	0f7d1748 	svceq	0x007d1748
     834:	04070000 	streq	r0, [r7], #-0
     838:	6f010000 	svcvs	0x00010000
     83c:	7a000005 	bvc	858 <_start-0x77a8>
     840:	14000005 	strne	r0, [r0], #-5
     844:	000006f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     848:	00005e15 	andeq	r5, r0, r5, lsl lr
     84c:	de190000 	cdple	0, 1, cr0, cr9, cr0, {0}
     850:	07000011 	smladeq	r0, r1, r0, r0
     854:	03cd0e4b 	biceq	r0, sp, #1200	; 0x4b0
     858:	8f010000 	svchi	0x00010000
     85c:	95000005 	strls	r0, [r0, #-5]
     860:	14000005 	strne	r0, [r0], #-5
     864:	000006c8 	andeq	r0, r0, r8, asr #13
     868:	10071700 	andne	r1, r7, r0, lsl #14
     86c:	4d070000 	stcmi	0, cr0, [r7, #-0]
     870:	0008640e 	andeq	r6, r8, lr, lsl #8
     874:	0001fc00 	andeq	pc, r1, r0, lsl #24
     878:	05ae0100 	streq	r0, [lr, #256]!	; 0x100
     87c:	05b90000 	ldreq	r0, [r9, #0]!
     880:	c8140000 	ldmdagt	r4, {}	; <UNPREDICTABLE>
     884:	15000006 	strne	r0, [r0, #-6]
     888:	0000005e 	andeq	r0, r0, lr, asr r0
     88c:	097e1700 	ldmdbeq	lr!, {r8, r9, sl, ip}^
     890:	50070000 	andpl	r0, r7, r0
     894:	000d3512 	andeq	r3, sp, r2, lsl r5
     898:	00005e00 	andeq	r5, r0, r0, lsl #28
     89c:	05d20100 	ldrbeq	r0, [r2, #256]	; 0x100
     8a0:	05dd0000 	ldrbeq	r0, [sp]
     8a4:	c8140000 	ldmdagt	r4, {}	; <UNPREDICTABLE>
     8a8:	15000006 	strne	r0, [r0, #-6]
     8ac:	00000209 	andeq	r0, r0, r9, lsl #4
     8b0:	04691700 	strbteq	r1, [r9], #-1792	; 0xfffff900
     8b4:	53070000 	movwpl	r0, #28672	; 0x7000
     8b8:	0009370e 	andeq	r3, r9, lr, lsl #14
     8bc:	0001fc00 	andeq	pc, r1, r0, lsl #24
     8c0:	05f60100 	ldrbeq	r0, [r6, #256]!	; 0x100
     8c4:	06010000 	streq	r0, [r1], -r0
     8c8:	c8140000 	ldmdagt	r4, {}	; <UNPREDICTABLE>
     8cc:	15000006 	strne	r0, [r0, #-6]
     8d0:	0000005e 	andeq	r0, r0, lr, asr r0
     8d4:	0a081900 	beq	206cdc <__bss_end+0x1fb5c8>
     8d8:	56070000 	strpl	r0, [r7], -r0
     8dc:	0010bf0e 	andseq	fp, r0, lr, lsl #30
     8e0:	06160100 	ldreq	r0, [r6], -r0, lsl #2
     8e4:	06350000 	ldrteq	r0, [r5], -r0
     8e8:	c8140000 	ldmdagt	r4, {}	; <UNPREDICTABLE>
     8ec:	15000006 	strne	r0, [r0, #-6]
     8f0:	0000009c 	muleq	r0, ip, r0
     8f4:	00005e15 	andeq	r5, r0, r5, lsl lr
     8f8:	005e1500 	subseq	r1, lr, r0, lsl #10
     8fc:	5e150000 	cdppl	0, 1, cr0, cr5, cr0, {0}
     900:	15000000 	strne	r0, [r0, #-0]
     904:	000006f6 	strdeq	r0, [r0], -r6
     908:	0faa1900 	svceq	0x00aa1900
     90c:	58070000 	stmdapl	r7, {}	; <UNPREDICTABLE>
     910:	0007c00e 	andeq	ip, r7, lr
     914:	064a0100 	strbeq	r0, [sl], -r0, lsl #2
     918:	06690000 	strbteq	r0, [r9], -r0
     91c:	c8140000 	ldmdagt	r4, {}	; <UNPREDICTABLE>
     920:	15000006 	strne	r0, [r0, #-6]
     924:	000000d3 	ldrdeq	r0, [r0], -r3
     928:	00005e15 	andeq	r5, r0, r5, lsl lr
     92c:	005e1500 	subseq	r1, lr, r0, lsl #10
     930:	5e150000 	cdppl	0, 1, cr0, cr5, cr0, {0}
     934:	15000000 	strne	r0, [r0, #-0]
     938:	000006f6 	strdeq	r0, [r0], -r6
     93c:	0d8f1900 	vstreq.16	s2, [pc]	; 944 <_start-0x76bc>	; <UNPREDICTABLE>
     940:	5a070000 	bpl	1c0948 <__bss_end+0x1b5234>
     944:	00099a0e 	andeq	r9, r9, lr, lsl #20
     948:	067e0100 	ldrbteq	r0, [lr], -r0, lsl #2
     94c:	069d0000 	ldreq	r0, [sp], r0
     950:	c8140000 	ldmdagt	r4, {}	; <UNPREDICTABLE>
     954:	15000006 	strne	r0, [r0, #-6]
     958:	00000110 	andeq	r0, r0, r0, lsl r1
     95c:	00005e15 	andeq	r5, r0, r5, lsl lr
     960:	005e1500 	subseq	r1, lr, r0, lsl #10
     964:	5e150000 	cdppl	0, 1, cr0, cr5, cr0, {0}
     968:	15000000 	strne	r0, [r0, #-0]
     96c:	000006f6 	strdeq	r0, [r0], -r6
     970:	07201a00 	streq	r1, [r0, -r0, lsl #20]!
     974:	5d070000 	stcpl	0, cr0, [r7, #-0]
     978:	0007680e 	andeq	r6, r7, lr, lsl #16
     97c:	0001fc00 	andeq	pc, r1, r0, lsl #24
     980:	06b20100 	ldrteq	r0, [r2], r0, lsl #2
     984:	c8140000 	ldmdagt	r4, {}	; <UNPREDICTABLE>
     988:	15000006 	strne	r0, [r0, #-6]
     98c:	000003ad 	andeq	r0, r0, sp, lsr #7
     990:	0006fc15 	andeq	pc, r6, r5, lsl ip	; <UNPREDICTABLE>
     994:	03000000 	movweq	r0, #0
     998:	0000040d 	andeq	r0, r0, sp, lsl #8
     99c:	040d040d 	streq	r0, [sp], #-1037	; 0xfffffbf3
     9a0:	011b0000 	tsteq	fp, r0
     9a4:	db000004 	blle	9bc <_start-0x7644>
     9a8:	e1000006 	tst	r0, r6
     9ac:	14000006 	strne	r0, [r0], #-6
     9b0:	000006c8 	andeq	r0, r0, r8, asr #13
     9b4:	040d1c00 	streq	r1, [sp], #-3072	; 0xfffff400
     9b8:	06ce0000 	strbeq	r0, [lr], r0
     9bc:	040d0000 	streq	r0, [sp], #-0
     9c0:	00000050 	andeq	r0, r0, r0, asr r0
     9c4:	06c3040d 	strbeq	r0, [r3], sp, lsl #8
     9c8:	041d0000 	ldreq	r0, [sp], #-0
     9cc:	00000076 	andeq	r0, r0, r6, ror r0
     9d0:	3612041e 			; <UNDEFINED> instruction: 0x3612041e
     9d4:	88000012 	stmdahi	r0, {r1, r4}
     9d8:	09070708 	stmdbeq	r7, {r3, r8, r9, sl}
     9dc:	0f000008 	svceq	0x00000008
     9e0:	0000061d 	andeq	r0, r0, sp, lsl r6
     9e4:	090e0b08 	stmdbeq	lr, {r3, r8, r9, fp}
     9e8:	00000008 	andeq	r0, r0, r8
     9ec:	000fc00f 	andeq	ip, pc, pc
     9f0:	120e0800 	andne	r0, lr, #0, 16
     9f4:	0000005e 	andeq	r0, r0, lr, asr r0
     9f8:	04190f80 	ldreq	r0, [r9], #-3968	; 0xfffff080
     9fc:	0f080000 	svceq	0x00080000
     a00:	00005e12 	andeq	r5, r0, r2, lsl lr
     a04:	36178400 	ldrcc	r8, [r7], -r0, lsl #8
     a08:	08000012 	stmdaeq	r0, {r1, r4}
     a0c:	0bfe0913 	bleq	fff82e60 <__bss_end+0xfff7774c>
     a10:	08190000 	ldmdaeq	r9, {}	; <UNPREDICTABLE>
     a14:	4b010000 	blmi	40a1c <__bss_end+0x35308>
     a18:	51000007 	tstpl	r0, r7
     a1c:	14000007 	strne	r0, [r0], #-7
     a20:	00000819 	andeq	r0, r0, r9, lsl r8
     a24:	121b1700 	andsne	r1, fp, #0, 14
     a28:	16080000 	strne	r0, [r8], -r0
     a2c:	0006fd12 	andeq	pc, r6, r2, lsl sp	; <UNPREDICTABLE>
     a30:	00005e00 	andeq	r5, r0, r0, lsl #28
     a34:	076a0100 	strbeq	r0, [sl, -r0, lsl #2]!
     a38:	07750000 	ldrbeq	r0, [r5, -r0]!
     a3c:	19140000 	ldmdbne	r4, {}	; <UNPREDICTABLE>
     a40:	15000008 	strne	r0, [r0, #-8]
     a44:	0000081f 	andeq	r0, r0, pc, lsl r8
     a48:	121b1700 	andsne	r1, fp, #0, 14
     a4c:	19080000 	stmdbne	r8, {}	; <UNPREDICTABLE>
     a50:	00057012 	andeq	r7, r5, r2, lsl r0
     a54:	00005e00 	andeq	r5, r0, r0, lsl #28
     a58:	078e0100 	streq	r0, [lr, r0, lsl #2]
     a5c:	079e0000 	ldreq	r0, [lr, r0]
     a60:	19140000 	ldmdbne	r4, {}	; <UNPREDICTABLE>
     a64:	15000008 	strne	r0, [r0, #-8]
     a68:	0000081f 	andeq	r0, r0, pc, lsl r8
     a6c:	00005e15 	andeq	r5, r0, r5, lsl lr
     a70:	9e170000 	cdpls	0, 1, cr0, cr7, cr0, {0}
     a74:	0800000e 	stmdaeq	r0, {r1, r2, r3}
     a78:	0b5a121c 	bleq	16852f0 <__bss_end+0x1679bdc>
     a7c:	005e0000 	subseq	r0, lr, r0
     a80:	b7010000 	strlt	r0, [r1, -r0]
     a84:	c7000007 	strgt	r0, [r0, -r7]
     a88:	14000007 	strne	r0, [r0], #-7
     a8c:	00000819 	andeq	r0, r0, r9, lsl r8
     a90:	00002515 	andeq	r2, r0, r5, lsl r5
     a94:	081f1500 	ldmdaeq	pc, {r8, sl, ip}	; <UNPREDICTABLE>
     a98:	19000000 	stmdbne	r0, {}	; <UNPREDICTABLE>
     a9c:	00000ba3 	andeq	r0, r0, r3, lsr #23
     aa0:	290e1f08 	stmdbcs	lr, {r3, r8, r9, sl, fp, ip}
     aa4:	01000010 	tsteq	r0, r0, lsl r0
     aa8:	000007dc 	ldrdeq	r0, [r0], -ip
     aac:	000007ec 	andeq	r0, r0, ip, ror #15
     ab0:	00081914 	andeq	r1, r8, r4, lsl r9
     ab4:	081f1500 	ldmdaeq	pc, {r8, sl, ip}	; <UNPREDICTABLE>
     ab8:	5e150000 	cdppl	0, 1, cr0, cr5, cr0, {0}
     abc:	00000000 	andeq	r0, r0, r0
     ac0:	000ba31f 	andeq	sl, fp, pc, lsl r3
     ac4:	0e220800 	cdpeq	8, 2, cr0, cr2, cr0, {0}
     ac8:	00000e4c 	andeq	r0, r0, ip, asr #28
     acc:	0007fd01 	andeq	pc, r7, r1, lsl #26
     ad0:	08191400 	ldmdaeq	r9, {sl, ip}
     ad4:	25150000 	ldrcs	r0, [r5, #-0]
     ad8:	00000000 	andeq	r0, r0, r0
     adc:	00251000 	eoreq	r1, r5, r0
     ae0:	08190000 	ldmdaeq	r9, {}	; <UNPREDICTABLE>
     ae4:	6f110000 	svcvs	0x00110000
     ae8:	7f000000 	svcvc	0x00000000
     aec:	fe040d00 	vdot.bf16	d0, d4, d0[0]
     af0:	0d000006 	stceq	0, cr0, [r0, #-24]	; 0xffffffe8
     af4:	00002504 	andeq	r2, r0, r4, lsl #10
     af8:	0a9b1200 	beq	fe6c5300 <__bss_end+0xfe6b9bec>
     afc:	09880000 	stmibeq	r8, {}	; <UNPREDICTABLE>
     b00:	08890708 	stmeq	r9, {r3, r8, r9, sl}
     b04:	a20f0000 	andge	r0, pc, #0
     b08:	09000003 	stmdbeq	r0, {r0, r1}
     b0c:	06fe190c 	ldrbteq	r1, [lr], ip, lsl #18
     b10:	17000000 	strne	r0, [r0, -r0]
     b14:	00000a9b 	muleq	r0, fp, sl
     b18:	35091009 	strcc	r1, [r9, #-9]
     b1c:	89000005 	stmdbhi	r0, {r0, r2}
     b20:	01000008 	tsteq	r0, r8
     b24:	00000858 	andeq	r0, r0, r8, asr r8
     b28:	0000085e 	andeq	r0, r0, lr, asr r8
     b2c:	00088914 	andeq	r8, r8, r4, lsl r9
     b30:	2b1a0000 	blcs	680b38 <__bss_end+0x675424>
     b34:	09000005 	stmdbeq	r0, {r0, r2}
     b38:	11f41213 	mvnsne	r1, r3, lsl r2
     b3c:	005e0000 	subseq	r0, lr, r0
     b40:	73010000 	movwvc	r0, #4096	; 0x1000
     b44:	14000008 	strne	r0, [r0], #-8
     b48:	00000889 	andeq	r0, r0, r9, lsl #17
     b4c:	00081f15 	andeq	r1, r8, r5, lsl pc
     b50:	005e1500 	subseq	r1, lr, r0, lsl #10
     b54:	fc150000 	ldc2	0, cr0, [r5], {-0}
     b58:	00000001 	andeq	r0, r0, r1
     b5c:	25040d00 	strcs	r0, [r4, #-3328]	; 0xfffff300
     b60:	12000008 	andne	r0, r0, #8
     b64:	00000a2e 	andeq	r0, r0, lr, lsr #20
     b68:	07070a04 	streq	r0, [r7, -r4, lsl #20]
     b6c:	00000918 	andeq	r0, r0, r8, lsl r9
     b70:	000e430f 	andeq	r4, lr, pc, lsl #6
     b74:	0e0a0a00 	vmlaeq.f32	s0, s20, s0
     b78:	0000005e 	andeq	r0, r0, lr, asr r0
     b7c:	11911700 	orrsne	r1, r1, r0, lsl #14
     b80:	0c0a0000 	stceq	0, cr0, [sl], {-0}
     b84:	000dc309 	andeq	ip, sp, r9, lsl #6
     b88:	00004400 	andeq	r4, r0, r0, lsl #8
     b8c:	08c20100 	stmiaeq	r2, {r8}^
     b90:	08d20000 	ldmeq	r2, {}^	; <UNPREDICTABLE>
     b94:	18140000 	ldmdane	r4, {}	; <UNPREDICTABLE>
     b98:	15000009 	strne	r0, [r0, #-9]
     b9c:	00000038 	andeq	r0, r0, r8, lsr r0
     ba0:	00003815 	andeq	r3, r0, r5, lsl r8
     ba4:	af170000 	svcge	0x00170000
     ba8:	0a000006 	beq	bc8 <_start-0x7438>
     bac:	05510b0d 	ldrbeq	r0, [r1, #-2829]	; 0xfffff4f3
     bb0:	091e0000 	ldmdbeq	lr, {}	; <UNPREDICTABLE>
     bb4:	eb010000 	bl	40bbc <__bss_end+0x354a8>
     bb8:	fb000008 	blx	be2 <_start-0x741e>
     bbc:	14000008 	strne	r0, [r0], #-8
     bc0:	00000918 	andeq	r0, r0, r8, lsl r9
     bc4:	00003815 	andeq	r3, r0, r5, lsl r8
     bc8:	00381500 	eorseq	r1, r8, r0, lsl #10
     bcc:	1f000000 	svcne	0x00000000
     bd0:	000004ef 	andeq	r0, r0, pc, ror #9
     bd4:	d30a0e0a 	movwle	r0, #44554	; 0xae0a
     bd8:	01000012 	tsteq	r0, r2, lsl r0
     bdc:	0000090c 	andeq	r0, r0, ip, lsl #18
     be0:	00091814 	andeq	r1, r9, r4, lsl r8
     be4:	005e1500 	subseq	r1, lr, r0, lsl #10
     be8:	00000000 	andeq	r0, r0, r0
     bec:	088f040d 	stmeq	pc, {r0, r2, r3, sl}	; <UNPREDICTABLE>
     bf0:	04020000 	streq	r0, [r2], #-0
     bf4:	00159a04 	andseq	r9, r5, r4, lsl #20
     bf8:	6e722000 	cdpvs	0, 7, cr2, cr2, cr0, {0}
     bfc:	110a0064 	tstne	sl, r4, rrx
     c00:	00088f16 	andeq	r8, r8, r6, lsl pc
     c04:	12670700 	rsbne	r0, r7, #0, 14
     c08:	0b140000 	bleq	500c10 <__bss_end+0x4f54fc>
     c0c:	09760803 	ldmdbeq	r6!, {r0, r1, fp}^
     c10:	41080000 	mrsmi	r0, (UNDEF: 8)
     c14:	08050b00 	stmdaeq	r5, {r8, r9, fp}
     c18:	0000091e 	andeq	r0, r0, lr, lsl r9
     c1c:	00420800 	subeq	r0, r2, r0, lsl #16
     c20:	1e08060b 	cfmadd32ne	mvax0, mvfx0, mvfx8, mvfx11
     c24:	04000009 	streq	r0, [r0], #-9
     c28:	0b004308 	bleq	11850 <__bss_end+0x613c>
     c2c:	091e0807 	ldmdbeq	lr, {r0, r1, r2, fp}
     c30:	08080000 	stmdaeq	r8, {}	; <UNPREDICTABLE>
     c34:	080b0044 	stmdaeq	fp, {r2, r6}
     c38:	00091e08 	andeq	r1, r9, r8, lsl #28
     c3c:	45080c00 	strmi	r0, [r8, #-3072]	; 0xfffff400
     c40:	08090b00 	stmdaeq	r9, {r8, r9, fp}
     c44:	0000091e 	andeq	r0, r0, lr, lsl r9
     c48:	0f120010 	svceq	0x00120010
     c4c:	18000013 	stmdane	r0, {r0, r1, r4}
     c50:	f807110c 			; <UNDEFINED> instruction: 0xf807110c
     c54:	0f00000a 	svceq	0x0000000a
     c58:	00000f39 	andeq	r0, r0, r9, lsr pc
     c5c:	fd0f140c 	stc2	4, cr1, [pc, #-48]	; c34 <_start-0x73cc>
     c60:	0000000a 	andeq	r0, r0, sl
     c64:	74696608 	strbtvc	r6, [r9], #-1544	; 0xfffff9f8
     c68:	0f150c00 	svceq	0x00150c00
     c6c:	0000091e 	andeq	r0, r0, lr, lsl r9
     c70:	74622114 	strbtvc	r2, [r2], #-276	; 0xfffffeec
     c74:	0f160c00 	svceq	0x00160c00
     c78:	00000cb6 			; <UNDEFINED> instruction: 0x00000cb6
     c7c:	0000091e 	andeq	r0, r0, lr, lsl r9
     c80:	000009b4 			; <UNDEFINED> instruction: 0x000009b4
     c84:	000009c4 	andeq	r0, r0, r4, asr #19
     c88:	000b0d14 	andeq	r0, fp, r4, lsl sp
     c8c:	091e1500 	ldmdbeq	lr, {r8, sl, ip}
     c90:	44150000 	ldrmi	r0, [r5], #-0
     c94:	00000000 	andeq	r0, r0, r0
     c98:	00125f17 	andseq	r5, r2, r7, lsl pc
     c9c:	0f190c00 	svceq	0x00190c00
     ca0:	000008a2 	andeq	r0, r0, r2, lsr #17
     ca4:	0000091e 	andeq	r0, r0, lr, lsl r9
     ca8:	0009dd01 	andeq	sp, r9, r1, lsl #26
     cac:	0009f200 	andeq	pc, r9, r0, lsl #4
     cb0:	0b0d1400 	bleq	345cb8 <__bss_end+0x33a5a4>
     cb4:	13150000 	tstne	r5, #0
     cb8:	1500000b 	strne	r0, [r0, #-11]
     cbc:	0000091e 	andeq	r0, r0, lr, lsl r9
     cc0:	00004415 	andeq	r4, r0, r5, lsl r4
     cc4:	77190000 	ldrvc	r0, [r9, -r0]
     cc8:	0c000009 	stceq	0, cr0, [r0], {9}
     ccc:	0cfb0e1a 	ldcleq	14, cr0, [fp], #104	; 0x68
     cd0:	07010000 	streq	r0, [r1, -r0]
     cd4:	0d00000a 	stceq	0, cr0, [r0, #-40]	; 0xffffffd8
     cd8:	1400000a 	strne	r0, [r0], #-10
     cdc:	00000b0d 	andeq	r0, r0, sp, lsl #22
     ce0:	0ff41700 	svceq	0x00f41700
     ce4:	1b0c0000 	blne	300cec <__bss_end+0x2f55d8>
     ce8:	000a6614 	andeq	r6, sl, r4, lsl r6
     cec:	00097600 	andeq	r7, r9, r0, lsl #12
     cf0:	0a260100 	beq	9810f8 <__bss_end+0x9759e4>
     cf4:	0a310000 	beq	c40cfc <__bss_end+0xc355e8>
     cf8:	0d140000 	ldceq	0, cr0, [r4, #-0]
     cfc:	1500000b 	strne	r0, [r0, #-11]
     d00:	00000b19 	andeq	r0, r0, r9, lsl fp
     d04:	0f2b1900 	svceq	0x002b1900
     d08:	1c0c0000 	stcne	0, cr0, [ip], {-0}
     d0c:	000f0a0e 	andeq	r0, pc, lr, lsl #20
     d10:	0a460100 	beq	1181118 <__bss_end+0x1175a04>
     d14:	0a4c0000 	beq	1300d1c <__bss_end+0x12f5608>
     d18:	0d140000 	ldceq	0, cr0, [r4, #-0]
     d1c:	0000000b 	andeq	r0, r0, fp
     d20:	00125b17 	andseq	r5, r2, r7, lsl fp
     d24:	0f1d0c00 	svceq	0x001d0c00
     d28:	00000633 	andeq	r0, r0, r3, lsr r6
     d2c:	0000091e 	andeq	r0, r0, lr, lsl r9
     d30:	000a6501 	andeq	r6, sl, r1, lsl #10
     d34:	000a6b00 	andeq	r6, sl, r0, lsl #22
     d38:	0b0d1400 	bleq	345d40 <__bss_end+0x33a62c>
     d3c:	17000000 	strne	r0, [r0, -r0]
     d40:	00000daf 	andeq	r0, r0, pc, lsr #27
     d44:	570e1e0c 	strpl	r1, [lr, -ip, lsl #28]
     d48:	fc000010 	stc2	0, cr0, [r0], {16}
     d4c:	01000001 	tsteq	r0, r1
     d50:	00000a84 	andeq	r0, r0, r4, lsl #21
     d54:	00000a8f 	andeq	r0, r0, pc, lsl #21
     d58:	000b0d14 	andeq	r0, fp, r4, lsl sp
     d5c:	0b1f1500 	bleq	7c6164 <__bss_end+0x7baa50>
     d60:	17000000 	strne	r0, [r0, -r0]
     d64:	00000db9 			; <UNDEFINED> instruction: 0x00000db9
     d68:	780e1f0c 	stmdavc	lr, {r2, r3, r8, r9, sl, fp, ip}
     d6c:	fc000012 	stc2	0, cr0, [r0], {18}
     d70:	01000001 	tsteq	r0, r1
     d74:	00000aa8 	andeq	r0, r0, r8, lsr #21
     d78:	00000ab3 			; <UNDEFINED> instruction: 0x00000ab3
     d7c:	000b0d14 	andeq	r0, fp, r4, lsl sp
     d80:	0b1f1500 	bleq	7c6188 <__bss_end+0x7baa74>
     d84:	17000000 	strne	r0, [r0, -r0]
     d88:	0000128f 	andeq	r1, r0, pc, lsl #5
     d8c:	e00f200c 	and	r2, pc, ip
     d90:	1e00000c 	cdpne	0, 0, cr0, cr0, cr12, {0}
     d94:	01000009 	tsteq	r0, r9
     d98:	00000acc 	andeq	r0, r0, ip, asr #21
     d9c:	00000adc 	ldrdeq	r0, [r0], -ip
     da0:	000b0d14 	andeq	r0, fp, r4, lsl sp
     da4:	091e1500 	ldmdbeq	lr, {r8, sl, ip}
     da8:	44150000 	ldrmi	r0, [r5], #-0
     dac:	00000000 	andeq	r0, r0, r0
     db0:	00101f1a 	andseq	r1, r0, sl, lsl pc
     db4:	0f210c00 	svceq	0x00210c00
     db8:	00000485 	andeq	r0, r0, r5, lsl #9
     dbc:	00000931 	andeq	r0, r0, r1, lsr r9
     dc0:	000af101 	andeq	pc, sl, r1, lsl #2
     dc4:	0b0d1400 	bleq	345dcc <__bss_end+0x33a6b8>
     dc8:	00000000 	andeq	r0, r0, r0
     dcc:	00097603 	andeq	r7, r9, r3, lsl #12
     dd0:	091e1000 	ldmdbeq	lr, {ip}
     dd4:	0b0d0000 	bleq	340ddc <__bss_end+0x3356c8>
     dd8:	6f110000 	svcvs	0x00110000
     ddc:	04000000 	streq	r0, [r0], #-0
     de0:	76040d00 	strvc	r0, [r4], -r0, lsl #26
     de4:	1d000009 	stcne	0, cr0, [r0, #-36]	; 0xffffffdc
     de8:	00091e04 	andeq	r1, r9, r4, lsl #28
     dec:	76041d00 	strvc	r1, [r4], -r0, lsl #26
     df0:	1d000009 	stcne	0, cr0, [r0, #-36]	; 0xffffffdc
     df4:	000af804 	andeq	pc, sl, r4, lsl #16
     df8:	040e2200 	streq	r2, [lr], #-512	; 0xfffffe00
     dfc:	09600000 	stmdbeq	r0!, {}^	; <UNPREDICTABLE>
     e00:	f5070a0d 			; <UNDEFINED> instruction: 0xf5070a0d
     e04:	1300000b 	movwne	r0, #11
     e08:	000008f4 	strdeq	r0, [r0], -r4
     e0c:	180e0d0d 	stmdane	lr, {r0, r2, r3, r8, sl, fp}
     e10:	4700000e 	strmi	r0, [r0, -lr]
     e14:	5700000b 	strpl	r0, [r0, -fp]
     e18:	1400000b 	strne	r0, [r0], #-11
     e1c:	00000bf5 	strdeq	r0, [r0], -r5
     e20:	000bf515 	andeq	pc, fp, r5, lsl r5	; <UNPREDICTABLE>
     e24:	00441500 	subeq	r1, r4, r0, lsl #10
     e28:	23000000 	movwcs	r0, #0
     e2c:	006e6567 	rsbeq	r6, lr, r7, ror #10
     e30:	fb14100d 	blx	504e6e <__bss_end+0x4f975a>
     e34:	0000000b 	andeq	r0, r0, fp
     e38:	05a61901 	streq	r1, [r6, #2305]!	; 0x901
     e3c:	120d0000 	andne	r0, sp, #0
     e40:	000ae70e 	andeq	lr, sl, lr, lsl #14
     e44:	0b7a0100 	bleq	1e8124c <__bss_end+0x1e75b38>
     e48:	0b940000 	bleq	fe500e50 <__bss_end+0xfe4f573c>
     e4c:	f5140000 			; <UNDEFINED> instruction: 0xf5140000
     e50:	1500000b 	strne	r0, [r0, #-11]
     e54:	0000091e 	andeq	r0, r0, lr, lsl r9
     e58:	00005e15 	andeq	r5, r0, r5, lsl lr
     e5c:	091e1500 	ldmdbeq	lr, {r8, sl, ip}
     e60:	44150000 	ldrmi	r0, [r5], #-0
     e64:	00000000 	andeq	r0, r0, r0
     e68:	000cad19 	andeq	sl, ip, r9, lsl sp
     e6c:	0e130d00 	cdpeq	13, 1, cr0, cr3, cr0, {0}
     e70:	0000115c 	andeq	r1, r0, ip, asr r1
     e74:	000ba901 	andeq	sl, fp, r1, lsl #18
     e78:	000bb400 	andeq	fp, fp, r0, lsl #8
     e7c:	0bf51400 	bleq	ffd45e84 <__bss_end+0xffd3a770>
     e80:	f5150000 			; <UNDEFINED> instruction: 0xf5150000
     e84:	0000000b 	andeq	r0, r0, fp
     e88:	000f5619 	andeq	r5, pc, r9, lsl r6	; <UNPREDICTABLE>
     e8c:	0e140d00 	cdpeq	13, 1, cr0, cr4, cr0, {0}
     e90:	000008ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     e94:	000bc901 	andeq	ip, fp, r1, lsl #18
     e98:	000bcf00 	andeq	ip, fp, r0, lsl #30
     e9c:	0bf51400 	bleq	ffd45ea4 <__bss_end+0xffd3a790>
     ea0:	1a000000 	bne	ea8 <_start-0x7158>
     ea4:	0000128f 	andeq	r1, r0, pc, lsl #5
     ea8:	9e0f160d 	cfmadd32ls	mvax0, mvfx1, mvfx15, mvfx13
     eac:	1e000011 	mcrne	0, 0, r0, cr0, cr1, {0}
     eb0:	01000009 	tsteq	r0, r9
     eb4:	00000be4 	andeq	r0, r0, r4, ror #23
     eb8:	000bf514 	andeq	pc, fp, r4, lsl r5	; <UNPREDICTABLE>
     ebc:	091e1500 	ldmdbeq	lr, {r8, sl, ip}
     ec0:	44150000 	ldrmi	r0, [r5], #-0
     ec4:	00000000 	andeq	r0, r0, r0
     ec8:	25040d00 	strcs	r0, [r4, #-3328]	; 0xfffff300
     ecc:	1000000b 	andne	r0, r0, fp
     ed0:	00000976 	andeq	r0, r0, r6, ror r9
     ed4:	00000c0b 	andeq	r0, r0, fp, lsl #24
     ed8:	00006f11 	andeq	r6, r0, r1, lsl pc
     edc:	09006300 	stmdbeq	r0, {r8, r9, sp, lr}
     ee0:	000003fc 	strdeq	r0, [r0], -ip
     ee4:	00440405 	subeq	r0, r4, r5, lsl #8
     ee8:	030e0000 	movweq	r0, #57344	; 0xe000
     eec:	000c2a0c 	andeq	r2, ip, ip, lsl #20
     ef0:	08ed0a00 	stmiaeq	sp!, {r9, fp}^
     ef4:	0a000000 	beq	efc <_start-0x7104>
     ef8:	00000757 	andeq	r0, r0, r7, asr r7
     efc:	dd090001 	stcle	0, cr0, [r9, #-4]
     f00:	05000008 	streq	r0, [r0, #-8]
     f04:	00004404 	andeq	r4, r0, r4, lsl #8
     f08:	0c090e00 	stceq	14, cr0, [r9], {-0}
     f0c:	00000c77 	andeq	r0, r0, r7, ror ip
     f10:	0011b924 	andseq	fp, r1, r4, lsr #18
     f14:	2404b000 	strcs	fp, [r4], #-0
     f18:	00000992 	muleq	r0, r2, r9
     f1c:	49240960 	stmdbmi	r4!, {r5, r6, r8, fp}
     f20:	c0000005 	andgt	r0, r0, r5
     f24:	12132412 	andsne	r2, r3, #301989888	; 0x12000000
     f28:	25800000 	strcs	r0, [r0]
     f2c:	000ffe24 	andeq	pc, pc, r4, lsr #28
     f30:	244b0000 	strbcs	r0, [fp], #-0
     f34:	00000b51 	andeq	r0, r0, r1, asr fp
     f38:	99249600 	stmdbls	r4!, {r9, sl, ip, pc}
     f3c:	00000003 	andeq	r0, r0, r3
     f40:	0bb325e1 	bleq	fecca6cc <__bss_end+0xfecbefb8>
     f44:	c2000000 	andgt	r0, r0, #0
     f48:	09000001 	stmdbeq	r0, {r0}
     f4c:	00001246 	andeq	r1, r0, r6, asr #4
     f50:	00440405 	subeq	r0, r4, r5, lsl #8
     f54:	160e0000 	strne	r0, [lr], -r0
     f58:	000c940c 	andeq	r9, ip, ip, lsl #8
     f5c:	58520e00 	ldmdapl	r2, {r9, sl, fp}^
     f60:	540e0000 	strpl	r0, [lr], #-0
     f64:	00010058 	andeq	r0, r1, r8, asr r0
     f68:	000c8807 	andeq	r8, ip, r7, lsl #16
     f6c:	1d0e0c00 	stcne	12, cr0, [lr, #-0]
     f70:	000cc908 	andeq	ip, ip, r8, lsl #18
     f74:	12b70f00 	adcsne	r0, r7, #0, 30
     f78:	1f0e0000 	svcne	0x000e0000
     f7c:	000c0b17 	andeq	r0, ip, r7, lsl fp
     f80:	e50f0000 	str	r0, [pc, #-0]	; f88 <_start-0x7078>
     f84:	0e000004 	cdpeq	0, 0, cr0, cr0, cr4, {0}
     f88:	0c2a1520 	cfstr32eq	mvfx1, [sl], #-128	; 0xffffff80
     f8c:	0f040000 	svceq	0x00040000
     f90:	00001048 	andeq	r1, r0, r8, asr #32
     f94:	771a210e 	ldrvc	r2, [sl, -lr, lsl #2]
     f98:	0800000c 	stmdaeq	r0, {r2, r3}
     f9c:	04c12600 	strbeq	r2, [r1], #1536	; 0x600
     fa0:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
     fa4:	00091e07 	andeq	r1, r9, r7, lsl #28
     fa8:	e0030500 	and	r0, r3, r0, lsl #10
     fac:	260000b6 			; <UNDEFINED> instruction: 0x260000b6
     fb0:	00000eb6 			; <UNDEFINED> instruction: 0x00000eb6
     fb4:	5e0a1b01 	vmlapl.f64	d1, d10, d1
     fb8:	05000000 	streq	r0, [r0, #-0]
     fbc:	00b6e403 	adcseq	lr, r6, r3, lsl #8
     fc0:	045f2600 	ldrbeq	r2, [pc], #-1536	; fc8 <_start-0x7038>
     fc4:	1c010000 	stcne	0, cr0, [r1], {-0}
     fc8:	00005e0a 	andeq	r5, r0, sl, lsl #28
     fcc:	e8030500 	stmda	r3, {r8, sl}
     fd0:	260000b6 			; <UNDEFINED> instruction: 0x260000b6
     fd4:	000005d2 	ldrdeq	r0, [r0], -r2
     fd8:	44051e01 	strmi	r1, [r5], #-3585	; 0xfffff1ff
     fdc:	05000000 	streq	r0, [r0, #-0]
     fe0:	00b6ec03 	adcseq	lr, r6, r3, lsl #24
     fe4:	06be2600 	ldrteq	r2, [lr], r0, lsl #12
     fe8:	1f010000 	svcne	0x00010000
     fec:	00004405 	andeq	r4, r0, r5, lsl #8
     ff0:	f0030500 			; <UNDEFINED> instruction: 0xf0030500
     ff4:	260000b6 			; <UNDEFINED> instruction: 0x260000b6
     ff8:	00000ea9 	andeq	r0, r0, r9, lsr #29
     ffc:	f50d2101 			; <UNDEFINED> instruction: 0xf50d2101
    1000:	0500000b 	streq	r0, [r0, #-11]
    1004:	00b6f403 	adcseq	pc, r6, r3, lsl #8
    1008:	11c12600 	bicne	r2, r1, r0, lsl #12
    100c:	23010000 	movwcs	r0, #4096	; 0x1000
    1010:	000d4708 	andeq	r4, sp, r8, lsl #14
    1014:	f8030500 			; <UNDEFINED> instruction: 0xf8030500
    1018:	0d0000b6 	stceq	0, cr0, [r0, #-728]	; 0xfffffd28
    101c:	00091e04 	andeq	r1, r9, r4, lsl #28
    1020:	0f622600 	svceq	0x00622600
    1024:	24010000 	strcs	r0, [r1], #-0
    1028:	00005e0a 	andeq	r5, r0, sl, lsl #28
    102c:	fc030500 	stc2	5, cr0, [r3], {-0}
    1030:	270000b6 			; <UNDEFINED> instruction: 0x270000b6
    1034:	00000839 	andeq	r0, r0, r9, lsr r8
    1038:	4405eb01 	strmi	lr, [r5], #-2817	; 0xfffff4ff
    103c:	f0000000 			; <UNDEFINED> instruction: 0xf0000000
    1040:	b000008a 	andlt	r0, r0, sl, lsl #1
    1044:	01000002 	tsteq	r0, r2
    1048:	000dfd9c 	muleq	sp, ip, sp
    104c:	12262800 	eorne	r2, r6, #0, 16
    1050:	eb010000 	bl	41058 <__bss_end+0x35944>
    1054:	0000440e 	andeq	r4, r0, lr, lsl #8
    1058:	d4910300 	ldrle	r0, [r1], #768	; 0x300
    105c:	1111287d 	tstne	r1, sp, ror r8
    1060:	eb010000 	bl	41068 <__bss_end+0x35954>
    1064:	000dfd1b 	andeq	pc, sp, fp, lsl sp	; <UNPREDICTABLE>
    1068:	d0910300 	addsle	r0, r1, r0, lsl #6
    106c:	0ab2297d 	beq	fec8b668 <__bss_end+0xfec7ff54>
    1070:	ed010000 	stc	0, cr0, [r1, #-0]
    1074:	0008250d 	andeq	r2, r8, sp, lsl #10
    1078:	dc910300 	ldcle	3, cr0, [r1], {0}
    107c:	061d297e 			; <UNDEFINED> instruction: 0x061d297e
    1080:	ef010000 	svc	0x00010000
    1084:	00080907 	andeq	r0, r8, r7, lsl #18
    1088:	dc910300 	ldcle	3, cr0, [r1], {0}
    108c:	0e69297d 			; <UNDEFINED> instruction: 0x0e69297d
    1090:	f2010000 	vhadd.s8	d0, d1, d0
    1094:	00005e0b 	andeq	r5, r0, fp, lsl #28
    1098:	6c910200 	lfmvs	f0, 4, [r1], {0}
    109c:	008c602a 	addeq	r6, ip, sl, lsr #32
    10a0:	0000f800 	andeq	pc, r0, r0, lsl #16
    10a4:	0e0d2b00 	vmlaeq.f64	d2, d13, d0
    10a8:	14010000 	strne	r0, [r1], #-0
    10ac:	005e0c01 	subseq	r0, lr, r1, lsl #24
    10b0:	91020000 	mrsls	r0, (UNDEF: 2)
    10b4:	8d082a68 	vstrhi	s4, [r8, #-416]	; 0xfffffe60
    10b8:	00500000 	subseq	r0, r0, r0
    10bc:	bf2b0000 	svclt	0x002b0000
    10c0:	01000008 	tsteq	r0, r8
    10c4:	1e0a0118 	mcrne	1, 0, r0, cr10, cr8, {0}
    10c8:	02000009 	andeq	r0, r0, #9
    10cc:	00006491 	muleq	r0, r1, r4
    10d0:	1f040d00 	svcne	0x00040d00
    10d4:	2c000008 	stccs	0, cr0, [r0], {8}
    10d8:	00000ede 	ldrdeq	r0, [r0], -lr
    10dc:	84069f01 	strhi	r9, [r6], #-3841	; 0xfffff0ff
    10e0:	1400000a 	strne	r0, [r0], #-10
    10e4:	dc000087 	stcle	0, cr0, [r0], {135}	; 0x87
    10e8:	01000003 	tsteq	r0, r3
    10ec:	000f209c 	muleq	pc, ip, r0	; <UNPREDICTABLE>
    10f0:	061d2800 	ldreq	r2, [sp], -r0, lsl #16
    10f4:	9f010000 	svcls	0x00010000
    10f8:	00081f19 	andeq	r1, r8, r9, lsl pc
    10fc:	4c910200 	lfmmi	f0, 4, [r1], {0}
    1100:	000e4728 	andeq	r4, lr, r8, lsr #14
    1104:	2a9f0100 	bcs	fe7c150c <__bss_end+0xfe7b5df8>
    1108:	0000005e 	andeq	r0, r0, lr, asr r0
    110c:	28489102 	stmdacs	r8, {r1, r8, ip, pc}^
    1110:	0000071a 	andeq	r0, r0, sl, lsl r7
    1114:	1e369f01 	cdpne	15, 3, cr9, cr6, cr1, {0}
    1118:	02000009 	andeq	r0, r0, #9
    111c:	b2284491 	eorlt	r4, r8, #-1862270976	; 0x91000000
    1120:	0100000a 	tsteq	r0, sl
    1124:	0889499f 	stmeq	r9, {r0, r1, r2, r3, r4, r7, r8, fp, lr}
    1128:	91020000 	mrsls	r0, (UNDEF: 2)
    112c:	0ad12940 	beq	ff44b634 <__bss_end+0xff43ff20>
    1130:	a0010000 	andge	r0, r1, r0
    1134:	0001fc07 	andeq	pc, r1, r7, lsl #24
    1138:	6f910200 	svcvs	0x00910200
    113c:	000c1729 	andeq	r1, ip, r9, lsr #14
    1140:	07a10100 	streq	r0, [r1, r0, lsl #2]!
    1144:	000001fc 	strdeq	r0, [r0], -ip
    1148:	2a6e9102 	bcs	1ba5558 <__bss_end+0x1b99e44>
    114c:	00008768 	andeq	r8, r0, r8, ror #14
    1150:	000002ec 	andeq	r0, r0, ip, ror #5
    1154:	0074792d 	rsbseq	r7, r4, sp, lsr #18
    1158:	1e09a901 	vmlane.f16	s20, s18, s2	; <UNPREDICTABLE>
    115c:	02000009 	andeq	r0, r0, #9
    1160:	71296491 			; <UNDEFINED> instruction: 0x71296491
    1164:	0100000c 	tsteq	r0, ip
    1168:	091e09e0 	ldmdbeq	lr, {r5, r6, r7, r8, fp}
    116c:	91020000 	mrsls	r0, (UNDEF: 2)
    1170:	87e02a54 	ubfxhi	r2, r4, #20, #1
    1174:	01d80000 	bicseq	r0, r8, r0
    1178:	692d0000 	pushvs	{}	; <UNPREDICTABLE>
    117c:	0cae0100 	stfeqs	f0, [lr]
    1180:	00000044 	andeq	r0, r0, r4, asr #32
    1184:	2a689102 	bcs	1a25594 <__bss_end+0x1a19e80>
    1188:	000087f4 	strdeq	r8, [r0], -r4
    118c:	000001b4 			; <UNDEFINED> instruction: 0x000001b4
    1190:	000e0d29 	andeq	r0, lr, r9, lsr #26
    1194:	0dc40100 	stfeqe	f0, [r4]
    1198:	0000005e 	andeq	r0, r0, lr, asr r0
    119c:	2e5c9102 	logcse	f1, f2
    11a0:	00008808 	andeq	r8, r0, r8, lsl #16
    11a4:	000000c4 	andeq	r0, r0, r4, asr #1
    11a8:	00000ee8 	andeq	r0, r0, r8, ror #29
    11ac:	000efe29 	andeq	pc, lr, r9, lsr #28
    11b0:	0bb50100 	bleq	fed415b8 <__bss_end+0xfed35ea4>
    11b4:	0000091e 	andeq	r0, r0, lr, lsl r9
    11b8:	00609102 	rsbeq	r9, r0, r2, lsl #2
    11bc:	0088cc2e 	addeq	ip, r8, lr, lsr #24
    11c0:	00003800 	andeq	r3, r0, r0, lsl #16
    11c4:	000f0300 	andeq	r0, pc, r0, lsl #6
    11c8:	006a2d00 	rsbeq	r2, sl, r0, lsl #26
    11cc:	4b16bf01 	blmi	5b0dd8 <__bss_end+0x5a56c4>
    11d0:	02000000 	andeq	r0, r0, #0
    11d4:	2a005091 	bcs	15420 <__bss_end+0x9d0c>
    11d8:	00008928 	andeq	r8, r0, r8, lsr #18
    11dc:	00000080 	andeq	r0, r0, r0, lsl #1
    11e0:	000aa629 	andeq	sl, sl, r9, lsr #12
    11e4:	09c60100 	stmibeq	r6, {r8}^
    11e8:	00000044 	andeq	r0, r0, r4, asr #32
    11ec:	00589102 	subseq	r9, r8, r2, lsl #2
    11f0:	00000000 	andeq	r0, r0, r0
    11f4:	000d682f 	andeq	r6, sp, pc, lsr #16
    11f8:	05710100 	ldrbeq	r0, [r1, #-256]!	; 0xffffff00
    11fc:	00000c33 	andeq	r0, r0, r3, lsr ip
    1200:	00000044 	andeq	r0, r0, r4, asr #32
    1204:	000084c8 	andeq	r8, r0, r8, asr #9
    1208:	0000024c 	andeq	r0, r0, ip, asr #4
    120c:	0f979c01 	svceq	0x00979c01
    1210:	1d280000 	stcne	0, cr0, [r8, #-0]
    1214:	01000006 	tsteq	r0, r6
    1218:	081f1971 	ldmdaeq	pc, {r0, r4, r5, r6, r8, fp, ip}	; <UNPREDICTABLE>
    121c:	91030000 	mrsls	r0, (UNDEF: 3)
    1220:	47287ed4 			; <UNDEFINED> instruction: 0x47287ed4
    1224:	0100000e 	tsteq	r0, lr
    1228:	005e2a71 	subseq	r2, lr, r1, ror sl
    122c:	91030000 	mrsls	r0, (UNDEF: 3)
    1230:	142a7ed0 	strtne	r7, [sl], #-3792	; 0xfffff130
    1234:	90000085 	andls	r0, r0, r5, lsl #1
    1238:	29000001 	stmdbcs	r0, {r0}
    123c:	00000615 	andeq	r0, r0, r5, lsl r6
    1240:	09087401 	stmdbeq	r8, {r0, sl, ip, sp, lr}
    1244:	03000008 	movweq	r0, #8
    1248:	297ed891 	ldmdbcs	lr!, {r0, r4, r7, fp, ip, lr, pc}^
    124c:	00000b31 	andeq	r0, r0, r1, lsr fp
    1250:	97087501 	strls	r7, [r8, -r1, lsl #10]
    1254:	0200000f 	andeq	r0, r0, #15
    1258:	23296c91 			; <UNDEFINED> instruction: 0x23296c91
    125c:	01000010 	tsteq	r0, r0, lsl r0
    1260:	09310977 	ldmdbeq	r1!, {r0, r1, r2, r4, r5, r6, r8, fp}
    1264:	91020000 	mrsls	r0, (UNDEF: 2)
    1268:	10000058 	andne	r0, r0, r8, asr r0
    126c:	00000025 	andeq	r0, r0, r5, lsr #32
    1270:	00000fa7 	andeq	r0, r0, r7, lsr #31
    1274:	00006f11 	andeq	r6, r0, r1, lsl pc
    1278:	2f000900 	svccs	0x00000900
    127c:	000007ab 	andeq	r0, r0, fp, lsr #15
    1280:	48056801 	stmdami	r5, {r0, fp, sp, lr}
    1284:	4400000c 	strmi	r0, [r0], #-12
    1288:	88000000 	stmdahi	r0, {}	; <UNPREDICTABLE>
    128c:	40000084 	andmi	r0, r0, r4, lsl #1
    1290:	01000000 	mrseq	r0, (UNDEF: 0)
    1294:	000ff39c 	muleq	pc, ip, r3	; <UNPREDICTABLE>
    1298:	061d2800 	ldreq	r2, [sp], -r0, lsl #16
    129c:	68010000 	stmdavs	r1, {}	; <UNPREDICTABLE>
    12a0:	00081f20 	andeq	r1, r8, r0, lsr #30
    12a4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    12a8:	000e6928 	andeq	r6, lr, r8, lsr #18
    12ac:	31680100 	cmncc	r8, r0, lsl #2
    12b0:	0000005e 	andeq	r0, r0, lr, asr r0
    12b4:	28709102 	ldmdacs	r0!, {r1, r8, ip, pc}^
    12b8:	00000ab2 			; <UNDEFINED> instruction: 0x00000ab2
    12bc:	89486801 	stmdbhi	r8, {r0, fp, sp, lr}^
    12c0:	02000008 	andeq	r0, r0, #8
    12c4:	2f006c91 	svccs	0x00006c91
    12c8:	000005cd 	andeq	r0, r0, sp, asr #11
    12cc:	c8056401 	stmdagt	r5, {r0, sl, sp, lr}
    12d0:	44000006 	strmi	r0, [r0], #-6
    12d4:	48000000 	stmdami	r0, {}	; <UNPREDICTABLE>
    12d8:	40000084 	andmi	r0, r0, r4, lsl #1
    12dc:	01000000 	mrseq	r0, (UNDEF: 0)
    12e0:	00103f9c 	mulseq	r0, ip, pc	; <UNPREDICTABLE>
    12e4:	061d2800 	ldreq	r2, [sp], -r0, lsl #16
    12e8:	64010000 	strvs	r0, [r1], #-0
    12ec:	00081f1a 	andeq	r1, r8, sl, lsl pc
    12f0:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    12f4:	000e6928 	andeq	r6, lr, r8, lsr #18
    12f8:	2b640100 	blcs	1901700 <__bss_end+0x18f5fec>
    12fc:	0000005e 	andeq	r0, r0, lr, asr r0
    1300:	28709102 	ldmdacs	r0!, {r1, r8, ip, pc}^
    1304:	00000ab2 			; <UNDEFINED> instruction: 0x00000ab2
    1308:	89426401 	stmdbhi	r2, {r0, sl, sp, lr}^
    130c:	02000008 	andeq	r0, r0, #8
    1310:	2f006c91 	svccs	0x00006c91
    1314:	000010a4 	andeq	r1, r0, r4, lsr #1
    1318:	bd075b01 	vstrlt	d5, [r7, #-4]
    131c:	1e00000b 	cdpne	0, 0, cr0, cr0, cr11, {0}
    1320:	e4000009 	str	r0, [r0], #-9
    1324:	64000083 	strvs	r0, [r0], #-131	; 0xffffff7d
    1328:	01000000 	mrseq	r0, (UNDEF: 0)
    132c:	00107c9c 	mulseq	r0, ip, ip
    1330:	061d2800 	ldreq	r2, [sp], -r0, lsl #16
    1334:	5b010000 	blpl	4133c <__bss_end+0x35c28>
    1338:	00081f1c 	andeq	r1, r8, ip, lsl pc
    133c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1340:	000e6928 	andeq	r6, lr, r8, lsr #18
    1344:	2d5b0100 	ldfcse	f0, [fp, #-0]
    1348:	0000005e 	andeq	r0, r0, lr, asr r0
    134c:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1350:	0004b42f 	andeq	fp, r4, pc, lsr #8
    1354:	053b0100 	ldreq	r0, [fp, #-256]!	; 0xffffff00
    1358:	000005f1 	strdeq	r0, [r0], -r1
    135c:	00000044 	andeq	r0, r0, r4, asr #32
    1360:	000082a4 	andeq	r8, r0, r4, lsr #5
    1364:	00000140 	andeq	r0, r0, r0, asr #2
    1368:	11239c01 			; <UNDEFINED> instruction: 0x11239c01
    136c:	1d280000 	stcne	0, cr0, [r8, #-0]
    1370:	01000006 	tsteq	r0, r6
    1374:	081f183b 	ldmdaeq	pc, {r0, r1, r3, r4, r5, fp, ip}	; <UNPREDICTABLE>
    1378:	91030000 	mrsls	r0, (UNDEF: 3)
    137c:	69287edc 	stmdbvs	r8!, {r2, r3, r4, r6, r7, r9, sl, fp, ip, sp, lr}
    1380:	0100000e 	tsteq	r0, lr
    1384:	005e293b 	subseq	r2, lr, fp, lsr r9
    1388:	91030000 	mrsls	r0, (UNDEF: 3)
    138c:	b2287ed8 	eorlt	r7, r8, #216, 28	; 0xd80
    1390:	0100000a 	tsteq	r0, sl
    1394:	0889403b 	stmeq	r9, {r0, r1, r3, r4, r5, lr}
    1398:	91030000 	mrsls	r0, (UNDEF: 3)
    139c:	28287ed4 	stmdacs	r8!, {r2, r4, r6, r7, r9, sl, fp, ip, sp, lr}
    13a0:	01000013 	tsteq	r0, r3, lsl r0
    13a4:	0203583b 	andeq	r5, r3, #3866624	; 0x3b0000
    13a8:	91030000 	mrsls	r0, (UNDEF: 3)
    13ac:	7c297ed0 	stcvc	14, cr7, [r9], #-832	; 0xfffffcc0
    13b0:	01000004 	tsteq	r0, r4
    13b4:	0044063c 	subeq	r0, r4, ip, lsr r6
    13b8:	91020000 	mrsls	r0, (UNDEF: 2)
    13bc:	06152974 			; <UNDEFINED> instruction: 0x06152974
    13c0:	3d010000 	stccc	0, cr0, [r1, #-0]
    13c4:	00080907 	andeq	r0, r8, r7, lsl #18
    13c8:	f0910300 			; <UNDEFINED> instruction: 0xf0910300
    13cc:	0b31297e 	bleq	c4b9cc <__bss_end+0xc402b8>
    13d0:	3e010000 	cdpcc	0, 0, cr0, cr1, cr0, {0}
    13d4:	000f9707 	andeq	r9, pc, r7, lsl #14
    13d8:	e4910300 	ldr	r0, [r1], #768	; 0x300
    13dc:	82d42a7e 	sbcshi	r2, r4, #516096	; 0x7e000
    13e0:	00e80000 	rsceq	r0, r8, r0
    13e4:	0d290000 	stceq	0, cr0, [r9, #-0]
    13e8:	0100000e 	tsteq	r0, lr
    13ec:	005e0c43 	subseq	r0, lr, r3, asr #24
    13f0:	91020000 	mrsls	r0, (UNDEF: 2)
    13f4:	30000070 	andcc	r0, r0, r0, ror r0
    13f8:	0000075e 	andeq	r0, r0, lr, asr r7
    13fc:	940a2c01 	strls	r2, [sl], #-3073	; 0xfffff3ff
    1400:	5e000008 	cdppl	0, 0, cr0, cr0, cr8, {0}
    1404:	30000000 	andcc	r0, r0, r0
    1408:	74000082 	strvc	r0, [r0], #-130	; 0xffffff7e
    140c:	01000000 	mrseq	r0, (UNDEF: 0)
    1410:	0e69299c 			; <UNDEFINED> instruction: 0x0e69299c
    1414:	2d010000 	stccs	0, cr0, [r1, #-0]
    1418:	00005e0b 	andeq	r5, r0, fp, lsl #28
    141c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1420:	000f3929 	andeq	r3, pc, r9, lsr #18
    1424:	152f0100 	strne	r0, [pc, #-256]!	; 132c <_start-0x6cd4>
    1428:	00000c94 	muleq	r0, r4, ip
    142c:	00689102 	rsbeq	r9, r8, r2, lsl #2
    1430:	0005e300 	andeq	lr, r5, r0, lsl #6
    1434:	e5000400 	str	r0, [r0, #-1024]	; 0xfffffc00
    1438:	04000004 	streq	r0, [r0], #-4
    143c:	00023301 	andeq	r3, r2, r1, lsl #6
    1440:	133f0400 	teqne	pc, #0, 8
    1444:	004c0000 	subeq	r0, ip, r0
    1448:	8da00000 	stchi	0, cr0, [r0]
    144c:	04bc0000 	ldrteq	r0, [ip], #0
    1450:	07de0000 	ldrbeq	r0, [lr, r0]
    1454:	01020000 	mrseq	r0, (UNDEF: 2)
    1458:	000daa08 	andeq	sl, sp, r8, lsl #20
    145c:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
    1460:	00000e39 	andeq	r0, r0, r9, lsr lr
    1464:	000ed603 	andeq	sp, lr, r3, lsl #12
    1468:	07050200 	streq	r0, [r5, -r0, lsl #4]
    146c:	0000003f 	andeq	r0, r0, pc, lsr r0
    1470:	69050404 	stmdbvs	r5, {r2, sl}
    1474:	0200746e 	andeq	r7, r0, #1845493760	; 0x6e000000
    1478:	0da10801 	stceq	8, cr0, [r1, #4]!
    147c:	02020000 	andeq	r0, r2, #0
    1480:	000a1b07 	andeq	r1, sl, r7, lsl #22
    1484:	0ed50300 	cdpeq	3, 13, cr0, cr5, cr0, {0}
    1488:	09020000 	stmdbeq	r2, {}	; <UNPREDICTABLE>
    148c:	00006007 	andeq	r6, r0, r7
    1490:	07040200 	streq	r0, [r4, -r0, lsl #4]
    1494:	00001d28 	andeq	r1, r0, r8, lsr #26
    1498:	000a2e05 	andeq	r2, sl, r5, lsl #28
    149c:	07030400 	streq	r0, [r3, -r0, lsl #8]
    14a0:	0000f007 	andeq	pc, r0, r7
    14a4:	0e430600 	cdpeq	6, 4, cr0, cr3, cr0, {0}
    14a8:	0a030000 	beq	c14b0 <__bss_end+0xb5d9c>
    14ac:	0000540e 	andeq	r5, r0, lr, lsl #8
    14b0:	91070000 	mrsls	r0, (UNDEF: 7)
    14b4:	03000011 	movweq	r0, #17
    14b8:	0dc3090c 	vstreq.16	s1, [r3, #24]	; <UNPREDICTABLE>
    14bc:	003f0000 	eorseq	r0, pc, r0
    14c0:	9a010000 	bls	414c8 <__bss_end+0x35db4>
    14c4:	aa000000 	bge	14cc <_start-0x6b34>
    14c8:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    14cc:	000000f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    14d0:	00003309 	andeq	r3, r0, r9, lsl #6
    14d4:	00330900 	eorseq	r0, r3, r0, lsl #18
    14d8:	07000000 	streq	r0, [r0, -r0]
    14dc:	000006af 	andeq	r0, r0, pc, lsr #13
    14e0:	510b0d03 	tstpl	fp, r3, lsl #26
    14e4:	f6000005 			; <UNDEFINED> instruction: 0xf6000005
    14e8:	01000000 	mrseq	r0, (UNDEF: 0)
    14ec:	000000c3 	andeq	r0, r0, r3, asr #1
    14f0:	000000d3 	ldrdeq	r0, [r0], -r3
    14f4:	0000f008 	andeq	pc, r0, r8
    14f8:	00330900 	eorseq	r0, r3, r0, lsl #18
    14fc:	33090000 	movwcc	r0, #36864	; 0x9000
    1500:	00000000 	andeq	r0, r0, r0
    1504:	0004ef0a 	andeq	lr, r4, sl, lsl #30
    1508:	0a0e0300 	beq	382110 <__bss_end+0x3769fc>
    150c:	000012d3 	ldrdeq	r1, [r0], -r3
    1510:	0000e401 	andeq	lr, r0, r1, lsl #8
    1514:	00f00800 	rscseq	r0, r0, r0, lsl #16
    1518:	54090000 	strpl	r0, [r9], #-0
    151c:	00000000 	andeq	r0, r0, r0
    1520:	67040b00 	strvs	r0, [r4, -r0, lsl #22]
    1524:	02000000 	andeq	r0, r0, #0
    1528:	159a0404 	ldrne	r0, [sl, #1028]	; 0x404
    152c:	720c0000 	andvc	r0, ip, #0
    1530:	0300646e 	movweq	r6, #1134	; 0x46e
    1534:	00671611 	rsbeq	r1, r7, r1, lsl r6
    1538:	670d0000 	strvs	r0, [sp, -r0]
    153c:	14000012 	strne	r0, [r0], #-18	; 0xffffffee
    1540:	4e080304 	cdpmi	3, 0, cr0, cr8, cr4, {0}
    1544:	0e000001 	cdpeq	0, 0, cr0, cr0, cr1, {0}
    1548:	05040041 	streq	r0, [r4, #-65]	; 0xffffffbf
    154c:	0000f608 	andeq	pc, r0, r8, lsl #12
    1550:	420e0000 	andmi	r0, lr, #0
    1554:	08060400 	stmdaeq	r6, {sl}
    1558:	000000f6 	strdeq	r0, [r0], -r6
    155c:	00430e04 	subeq	r0, r3, r4, lsl #28
    1560:	f6080704 			; <UNDEFINED> instruction: 0xf6080704
    1564:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    1568:	0400440e 	streq	r4, [r0], #-1038	; 0xfffffbf2
    156c:	00f60808 	rscseq	r0, r6, r8, lsl #16
    1570:	0e0c0000 	cdpeq	0, 0, cr0, cr12, cr0, {0}
    1574:	09040045 	stmdbeq	r4, {r0, r2, r6}
    1578:	0000f608 	andeq	pc, r0, r8, lsl #12
    157c:	0f001000 	svceq	0x00001000
    1580:	00000c94 	muleq	r0, r4, ip
    1584:	003f0405 	eorseq	r0, pc, r5, lsl #8
    1588:	08050000 	stmdaeq	r5, {}	; <UNPREDICTABLE>
    158c:	00017506 	andeq	r7, r1, r6, lsl #10
    1590:	00411000 	subeq	r1, r1, r0
    1594:	00421000 	subeq	r1, r2, r0
    1598:	00431001 	subeq	r1, r3, r1
    159c:	00441002 	subeq	r1, r4, r2
    15a0:	00451003 	subeq	r1, r5, r3
    15a4:	0f050004 	svceq	0x00050004
    15a8:	18000013 	stmdane	r0, {r0, r1, r4}
    15ac:	f7071105 			; <UNDEFINED> instruction: 0xf7071105
    15b0:	06000002 	streq	r0, [r0], -r2
    15b4:	00000f39 	andeq	r0, r0, r9, lsr pc
    15b8:	fc0f1405 	stc2	4, cr1, [pc], {5}
    15bc:	00000002 	andeq	r0, r0, r2
    15c0:	7469660e 	strbtvc	r6, [r9], #-1550	; 0xfffff9f2
    15c4:	0f150500 	svceq	0x00150500
    15c8:	000000f6 	strdeq	r0, [r0], -r6
    15cc:	74621114 	strbtvc	r1, [r2], #-276	; 0xfffffeec
    15d0:	0f160500 	svceq	0x00160500
    15d4:	00000cb6 			; <UNDEFINED> instruction: 0x00000cb6
    15d8:	000000f6 	strdeq	r0, [r0], -r6
    15dc:	000001b3 			; <UNDEFINED> instruction: 0x000001b3
    15e0:	000001c3 	andeq	r0, r0, r3, asr #3
    15e4:	00030c08 	andeq	r0, r3, r8, lsl #24
    15e8:	00f60900 	rscseq	r0, r6, r0, lsl #18
    15ec:	3f090000 	svccc	0x00090000
    15f0:	00000000 	andeq	r0, r0, r0
    15f4:	00125f07 	andseq	r5, r2, r7, lsl #30
    15f8:	0f190500 	svceq	0x00190500
    15fc:	000008a2 	andeq	r0, r0, r2, lsr #17
    1600:	000000f6 	strdeq	r0, [r0], -r6
    1604:	0001dc01 	andeq	sp, r1, r1, lsl #24
    1608:	0001f100 	andeq	pc, r1, r0, lsl #2
    160c:	030c0800 	movweq	r0, #51200	; 0xc800
    1610:	17090000 	strne	r0, [r9, -r0]
    1614:	09000003 	stmdbeq	r0, {r0, r1}
    1618:	000000f6 	strdeq	r0, [r0], -r6
    161c:	00003f09 	andeq	r3, r0, r9, lsl #30
    1620:	77120000 	ldrvc	r0, [r2, -r0]
    1624:	05000009 	streq	r0, [r0, #-9]
    1628:	0cfb0e1a 	ldcleq	14, cr0, [fp], #104	; 0x68
    162c:	06010000 	streq	r0, [r1], -r0
    1630:	0c000002 	stceq	0, cr0, [r0], {2}
    1634:	08000002 	stmdaeq	r0, {r1}
    1638:	0000030c 	andeq	r0, r0, ip, lsl #6
    163c:	0ff40700 	svceq	0x00f40700
    1640:	1b050000 	blne	141648 <__bss_end+0x135f34>
    1644:	000a6614 	andeq	r6, sl, r4, lsl r6
    1648:	00017500 	andeq	r7, r1, r0, lsl #10
    164c:	02250100 	eoreq	r0, r5, #0, 2
    1650:	02300000 	eorseq	r0, r0, #0
    1654:	0c080000 	stceq	0, cr0, [r8], {-0}
    1658:	09000003 	stmdbeq	r0, {r0, r1}
    165c:	0000031d 	andeq	r0, r0, sp, lsl r3
    1660:	0f2b1200 	svceq	0x002b1200
    1664:	1c050000 	stcne	0, cr0, [r5], {-0}
    1668:	000f0a0e 	andeq	r0, pc, lr, lsl #20
    166c:	02450100 	subeq	r0, r5, #0, 2
    1670:	024b0000 	subeq	r0, fp, #0
    1674:	0c080000 	stceq	0, cr0, [r8], {-0}
    1678:	00000003 	andeq	r0, r0, r3
    167c:	00125b07 	andseq	r5, r2, r7, lsl #22
    1680:	0f1d0500 	svceq	0x001d0500
    1684:	00000633 	andeq	r0, r0, r3, lsr r6
    1688:	000000f6 	strdeq	r0, [r0], -r6
    168c:	00026401 	andeq	r6, r2, r1, lsl #8
    1690:	00026a00 	andeq	r6, r2, r0, lsl #20
    1694:	030c0800 	movweq	r0, #51200	; 0xc800
    1698:	07000000 	streq	r0, [r0, -r0]
    169c:	00000daf 	andeq	r0, r0, pc, lsr #27
    16a0:	570e1e05 	strpl	r1, [lr, -r5, lsl #28]
    16a4:	23000010 	movwcs	r0, #16
    16a8:	01000003 	tsteq	r0, r3
    16ac:	00000283 	andeq	r0, r0, r3, lsl #5
    16b0:	0000028e 	andeq	r0, r0, lr, lsl #5
    16b4:	00030c08 	andeq	r0, r3, r8, lsl #24
    16b8:	032a0900 			; <UNDEFINED> instruction: 0x032a0900
    16bc:	07000000 	streq	r0, [r0, -r0]
    16c0:	00000db9 			; <UNDEFINED> instruction: 0x00000db9
    16c4:	780e1f05 	stmdavc	lr, {r0, r2, r8, r9, sl, fp, ip}
    16c8:	23000012 	movwcs	r0, #18
    16cc:	01000003 	tsteq	r0, r3
    16d0:	000002a7 	andeq	r0, r0, r7, lsr #5
    16d4:	000002b2 			; <UNDEFINED> instruction: 0x000002b2
    16d8:	00030c08 	andeq	r0, r3, r8, lsl #24
    16dc:	032a0900 			; <UNDEFINED> instruction: 0x032a0900
    16e0:	07000000 	streq	r0, [r0, -r0]
    16e4:	0000128f 	andeq	r1, r0, pc, lsl #5
    16e8:	e00f2005 	and	r2, pc, r5
    16ec:	f600000c 			; <UNDEFINED> instruction: 0xf600000c
    16f0:	01000000 	mrseq	r0, (UNDEF: 0)
    16f4:	000002cb 	andeq	r0, r0, fp, asr #5
    16f8:	000002db 	ldrdeq	r0, [r0], -fp
    16fc:	00030c08 	andeq	r0, r3, r8, lsl #24
    1700:	00f60900 	rscseq	r0, r6, r0, lsl #18
    1704:	3f090000 	svccc	0x00090000
    1708:	00000000 	andeq	r0, r0, r0
    170c:	00101f13 	andseq	r1, r0, r3, lsl pc
    1710:	0f210500 	svceq	0x00210500
    1714:	00000485 	andeq	r0, r0, r5, lsl #9
    1718:	00000109 	andeq	r0, r0, r9, lsl #2
    171c:	0002f001 	andeq	pc, r2, r1
    1720:	030c0800 	movweq	r0, #51200	; 0xc800
    1724:	00000000 	andeq	r0, r0, r0
    1728:	00017514 	andeq	r7, r1, r4, lsl r5
    172c:	00f61500 	rscseq	r1, r6, r0, lsl #10
    1730:	030c0000 	movweq	r0, #49152	; 0xc000
    1734:	60160000 	andsvs	r0, r6, r0
    1738:	04000000 	streq	r0, [r0], #-0
    173c:	75040b00 	strvc	r0, [r4, #-2816]	; 0xfffff500
    1740:	14000001 	strne	r0, [r0], #-1
    1744:	0000030c 	andeq	r0, r0, ip, lsl #6
    1748:	00f60417 	rscseq	r0, r6, r7, lsl r4
    174c:	04170000 	ldreq	r0, [r7], #-0
    1750:	00000175 	andeq	r0, r0, r5, ror r1
    1754:	e2020102 	and	r0, r2, #-2147483648	; 0x80000000
    1758:	1700000a 	strne	r0, [r0, -sl]
    175c:	0002f704 	andeq	pc, r2, r4, lsl #14
    1760:	02db1800 	sbcseq	r1, fp, #0, 16
    1764:	74010000 	strvc	r0, [r1], #-0
    1768:	00034a07 	andeq	r4, r3, r7, lsl #20
    176c:	0091e400 	addseq	lr, r1, r0, lsl #8
    1770:	00007800 	andeq	r7, r0, r0, lsl #16
    1774:	679c0100 	ldrvs	r0, [ip, r0, lsl #2]
    1778:	19000003 	stmdbne	r0, {r0, r1}
    177c:	0000131a 	andeq	r1, r0, sl, lsl r3
    1780:	00000312 	andeq	r0, r0, r2, lsl r3
    1784:	1a709102 	bne	1c25b94 <__bss_end+0x1c1a480>
    1788:	00001023 	andeq	r1, r0, r3, lsr #32
    178c:	090b7601 	stmdbeq	fp, {r0, r9, sl, ip, sp, lr}
    1790:	03000001 	movweq	r0, #1
    1794:	00067491 	muleq	r6, r1, r4
    1798:	00024b18 	andeq	r4, r2, r8, lsl fp
    179c:	076c0100 	strbeq	r0, [ip, -r0, lsl #2]!
    17a0:	00000381 	andeq	r0, r0, r1, lsl #7
    17a4:	000091b8 			; <UNDEFINED> instruction: 0x000091b8
    17a8:	0000002c 	andeq	r0, r0, ip, lsr #32
    17ac:	038e9c01 	orreq	r9, lr, #256	; 0x100
    17b0:	1a190000 	bne	6417b8 <__bss_end+0x6360a4>
    17b4:	12000013 	andne	r0, r0, #19
    17b8:	02000003 	andeq	r0, r0, #3
    17bc:	1b007491 	blne	1ea08 <__bss_end+0x132f4>
    17c0:	00000230 	andeq	r0, r0, r0, lsr r2
    17c4:	a8066201 	stmdage	r6, {r0, r9, sp, lr}
    17c8:	4c000003 	stcmi	0, cr0, [r0], {3}
    17cc:	6c000091 	stcvs	0, cr0, [r0], {145}	; 0x91
    17d0:	01000000 	mrseq	r0, (UNDEF: 0)
    17d4:	0003cc9c 	muleq	r3, ip, ip
    17d8:	131a1900 	tstne	sl, #0, 18
    17dc:	03120000 	tsteq	r2, #0
    17e0:	91020000 	mrsls	r0, (UNDEF: 2)
    17e4:	915c1c6c 	cmpls	ip, ip, ror #24
    17e8:	004c0000 	subeq	r0, ip, r0
    17ec:	691d0000 	ldmdbvs	sp, {}	; <UNPREDICTABLE>
    17f0:	0e640100 	poweqs	f0, f4, f0
    17f4:	0000003f 	andeq	r0, r0, pc, lsr r0
    17f8:	00749102 	rsbseq	r9, r4, r2, lsl #2
    17fc:	020c1b00 	andeq	r1, ip, #0, 22
    1800:	40010000 	andmi	r0, r1, r0
    1804:	0003e60c 	andeq	lr, r3, ip, lsl #12
    1808:	00900400 	addseq	r0, r0, r0, lsl #8
    180c:	00014800 	andeq	r4, r1, r0, lsl #16
    1810:	409c0100 	addsmi	r0, ip, r0, lsl #2
    1814:	19000004 	stmdbne	r0, {r2}
    1818:	0000131a 	andeq	r1, r0, sl, lsl r3
    181c:	00000312 	andeq	r0, r0, r2, lsl r3
    1820:	1e689102 	lgnnee	f1, f2
    1824:	00001339 	andeq	r1, r0, r9, lsr r3
    1828:	1d2e4001 	stcne	0, cr4, [lr, #-4]!
    182c:	02000003 	andeq	r0, r0, #3
    1830:	0c1a6491 	cfldrseq	mvf6, [sl], {145}	; 0x91
    1834:	01000013 	tsteq	r0, r3, lsl r0
    1838:	01751042 	cmneq	r5, r2, asr #32
    183c:	91030000 	mrsls	r0, (UNDEF: 3)
    1840:	401c066c 	andsmi	r0, ip, ip, ror #12
    1844:	e8000090 	stmda	r0, {r4, r7}
    1848:	1d000000 	stcne	0, cr0, [r0, #-0]
    184c:	44010069 	strmi	r0, [r1], #-105	; 0xffffff97
    1850:	00003f0e 	andeq	r3, r0, lr, lsl #30
    1854:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1858:	0090541c 	addseq	r5, r0, ip, lsl r4
    185c:	0000c400 	andeq	ip, r0, r0, lsl #8
    1860:	00701d00 	rsbseq	r1, r0, r0, lsl #26
    1864:	f60f4701 			; <UNDEFINED> instruction: 0xf60f4701
    1868:	02000000 	andeq	r0, r0, #0
    186c:	00007091 	muleq	r0, r1, r0
    1870:	01f11b00 	mvnseq	r1, r0, lsl #22
    1874:	36010000 	strcc	r0, [r1], -r0
    1878:	00045a06 	andeq	r5, r4, r6, lsl #20
    187c:	008fa800 	addeq	sl, pc, r0, lsl #16
    1880:	00005c00 	andeq	r5, r0, r0, lsl #24
    1884:	769c0100 	ldrvc	r0, [ip], r0, lsl #2
    1888:	19000004 	stmdbne	r0, {r2}
    188c:	0000131a 	andeq	r1, r0, sl, lsl r3
    1890:	00000312 	andeq	r0, r0, r2, lsl r3
    1894:	1a6c9102 	bne	1b25ca4 <__bss_end+0x1b1a590>
    1898:	00000463 	andeq	r0, r0, r3, ror #8
    189c:	3f093801 	svccc	0x00093801
    18a0:	02000000 	andeq	r0, r0, #0
    18a4:	1b007491 	blne	1eaf0 <__bss_end+0x133dc>
    18a8:	000001c3 	andeq	r0, r0, r3, asr #3
    18ac:	90072c01 	andls	r2, r7, r1, lsl #24
    18b0:	34000004 	strcc	r0, [r0], #-4
    18b4:	7400008f 	strvc	r0, [r0], #-143	; 0xffffff71
    18b8:	01000000 	mrseq	r0, (UNDEF: 0)
    18bc:	0004d89c 	muleq	r4, ip, r8
    18c0:	131a1900 	tstne	sl, #0, 18
    18c4:	03120000 	tsteq	r2, #0
    18c8:	91020000 	mrsls	r0, (UNDEF: 2)
    18cc:	131f1e6c 	tstne	pc, #108, 28	; 0x6c0
    18d0:	2c010000 	stccs	0, cr0, [r1], {-0}
    18d4:	00031722 	andeq	r1, r3, r2, lsr #14
    18d8:	68910200 	ldmvs	r1, {r9}
    18dc:	0074791f 	rsbseq	r7, r4, pc, lsl r9
    18e0:	f6382c01 			; <UNDEFINED> instruction: 0xf6382c01
    18e4:	02000000 	andeq	r0, r0, #0
    18e8:	ff1e6491 			; <UNDEFINED> instruction: 0xff1e6491
    18ec:	01000012 	tsteq	r0, r2, lsl r0
    18f0:	003f402c 	eorseq	r4, pc, ip, lsr #32
    18f4:	91020000 	mrsls	r0, (UNDEF: 2)
    18f8:	12f71a60 	rscsne	r1, r7, #96, 20	; 0x60000
    18fc:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
    1900:	0000f60b 	andeq	pc, r0, fp, lsl #12
    1904:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1908:	02b21b00 	adcseq	r1, r2, #0, 22
    190c:	23010000 	movwcs	r0, #4096	; 0x1000
    1910:	0004f207 	andeq	pc, r4, r7, lsl #4
    1914:	008ebc00 	addeq	fp, lr, r0, lsl #24
    1918:	00007800 	andeq	r7, r0, r0, lsl #16
    191c:	2b9c0100 	blcs	fe701d24 <__bss_end+0xfe6f6610>
    1920:	19000005 	stmdbne	r0, {r0, r2}
    1924:	0000131a 	andeq	r1, r0, sl, lsl r3
    1928:	00000312 	andeq	r0, r0, r2, lsl r3
    192c:	1f6c9102 	svcne	0x006c9102
    1930:	01007479 	tsteq	r0, r9, ror r4
    1934:	00f62123 	rscseq	r2, r6, r3, lsr #2
    1938:	91020000 	mrsls	r0, (UNDEF: 2)
    193c:	12ff1e68 	rscsne	r1, pc, #104, 28	; 0x680
    1940:	23010000 	movwcs	r0, #4096	; 0x1000
    1944:	00003f29 	andeq	r3, r0, r9, lsr #30
    1948:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    194c:	0013061a 	andseq	r0, r3, sl, lsl r6
    1950:	0b250100 	bleq	941d58 <__bss_end+0x936644>
    1954:	000000f6 	strdeq	r0, [r0], -r6
    1958:	00749102 	rsbseq	r9, r4, r2, lsl #2
    195c:	00019c18 	andeq	r9, r1, r8, lsl ip
    1960:	07180100 	ldreq	r0, [r8, -r0, lsl #2]
    1964:	00000545 	andeq	r0, r0, r5, asr #10
    1968:	00008e30 	andeq	r8, r0, r0, lsr lr
    196c:	0000008c 	andeq	r0, r0, ip, lsl #1
    1970:	057e9c01 	ldrbeq	r9, [lr, #-3073]!	; 0xfffff3ff
    1974:	1a190000 	bne	64197c <__bss_end+0x636268>
    1978:	12000013 	andne	r0, r0, #19
    197c:	02000003 	andeq	r0, r0, #3
    1980:	791f6c91 	ldmdbvc	pc, {r0, r4, r7, sl, fp, sp, lr}	; <UNPREDICTABLE>
    1984:	18010074 	stmdane	r1, {r2, r4, r5, r6}
    1988:	0000f61c 	andeq	pc, r0, ip, lsl r6	; <UNPREDICTABLE>
    198c:	68910200 	ldmvs	r1, {r9}
    1990:	0012ff1e 	andseq	pc, r2, lr, lsl pc	; <UNPREDICTABLE>
    1994:	24180100 	ldrcs	r0, [r8], #-256	; 0xffffff00
    1998:	0000003f 	andeq	r0, r0, pc, lsr r0
    199c:	1a649102 	bne	1925dac <__bss_end+0x191a698>
    19a0:	0000132e 	andeq	r1, r0, lr, lsr #6
    19a4:	f60b1a01 			; <UNDEFINED> instruction: 0xf60b1a01
    19a8:	02000000 	andeq	r0, r0, #0
    19ac:	18007491 	stmdane	r0, {r0, r4, r7, sl, ip, sp, lr}
    19b0:	0000028e 	andeq	r0, r0, lr, lsl #5
    19b4:	98060e01 	stmdals	r6, {r0, r9, sl, fp}
    19b8:	e8000005 	stmda	r0, {r0, r2}
    19bc:	4800008d 	stmdami	r0, {r0, r2, r3, r7}
    19c0:	01000000 	mrseq	r0, (UNDEF: 0)
    19c4:	0005b49c 	muleq	r5, ip, r4
    19c8:	131a1900 	tstne	sl, #0, 18
    19cc:	03120000 	tsteq	r2, #0
    19d0:	91020000 	mrsls	r0, (UNDEF: 2)
    19d4:	626f1f74 	rsbvs	r1, pc, #116, 30	; 0x1d0
    19d8:	0e01006a 	cdpeq	0, 0, cr0, cr1, cr10, {3}
    19dc:	00032a30 	andeq	r2, r3, r0, lsr sl
    19e0:	70910200 	addsvc	r0, r1, r0, lsl #4
    19e4:	026a2000 	rsbeq	r2, sl, #0
    19e8:	09010000 	stmdbeq	r1, {}	; <UNPREDICTABLE>
    19ec:	0005ca06 	andeq	ip, r5, r6, lsl #20
    19f0:	008da000 	addeq	sl, sp, r0
    19f4:	00004800 	andeq	r4, r0, r0, lsl #16
    19f8:	199c0100 	ldmibne	ip, {r8}
    19fc:	0000131a 	andeq	r1, r0, sl, lsl r3
    1a00:	00000312 	andeq	r0, r0, r2, lsl r3
    1a04:	1f749102 	svcne	0x00749102
    1a08:	006a626f 	rsbeq	r6, sl, pc, ror #4
    1a0c:	2a300901 	bcs	c03e18 <__bss_end+0xbf8704>
    1a10:	02000003 	andeq	r0, r0, #3
    1a14:	00007091 	muleq	r0, r1, r0
    1a18:	0000075c 	andeq	r0, r0, ip, asr r7
    1a1c:	06f10004 	ldrbteq	r0, [r1], r4
    1a20:	01040000 	mrseq	r0, (UNDEF: 4)
    1a24:	00000233 	andeq	r0, r0, r3, lsr r2
    1a28:	00141a04 	andseq	r1, r4, r4, lsl #20
    1a2c:	00004c00 	andeq	r4, r0, r0, lsl #24
	...
    1a38:	000aea00 	andeq	lr, sl, r0, lsl #20
    1a3c:	08010200 	stmdaeq	r1, {r9}
    1a40:	00000daa 	andeq	r0, r0, sl, lsr #27
    1a44:	39050202 	stmdbcc	r5, {r1, r9}
    1a48:	0300000e 	movweq	r0, #14
    1a4c:	00000ed6 	ldrdeq	r0, [r0], -r6
    1a50:	3f070503 	svccc	0x00070503
    1a54:	04000000 	streq	r0, [r0], #-0
    1a58:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    1a5c:	01020074 	tsteq	r2, r4, ror r0
    1a60:	000da108 	andeq	sl, sp, r8, lsl #2
    1a64:	07020200 	streq	r0, [r2, -r0, lsl #4]
    1a68:	00000a1b 	andeq	r0, r0, fp, lsl sl
    1a6c:	000ed503 	andeq	sp, lr, r3, lsl #10
    1a70:	07090300 	streq	r0, [r9, -r0, lsl #6]
    1a74:	00000065 	andeq	r0, r0, r5, rrx
    1a78:	00005405 	andeq	r5, r0, r5, lsl #8
    1a7c:	07040200 	streq	r0, [r4, -r0, lsl #4]
    1a80:	00001d28 	andeq	r1, r0, r8, lsr #26
    1a84:	000a2e06 	andeq	r2, sl, r6, lsl #28
    1a88:	07040400 	streq	r0, [r4, -r0, lsl #8]
    1a8c:	0000f507 	andeq	pc, r0, r7, lsl #10
    1a90:	0e430700 	cdpeq	7, 4, cr0, cr3, cr0, {0}
    1a94:	0a040000 	beq	101a9c <__bss_end+0xf6388>
    1a98:	0000540e 	andeq	r5, r0, lr, lsl #8
    1a9c:	91080000 	mrsls	r0, (UNDEF: 8)
    1aa0:	04000011 	streq	r0, [r0], #-17	; 0xffffffef
    1aa4:	0dc3090c 	vstreq.16	s1, [r3, #24]	; <UNPREDICTABLE>
    1aa8:	003f0000 	eorseq	r0, pc, r0
    1aac:	9f010000 	svcls	0x00010000
    1ab0:	af000000 	svcge	0x00000000
    1ab4:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    1ab8:	000000f5 	strdeq	r0, [r0], -r5
    1abc:	0000330a 	andeq	r3, r0, sl, lsl #6
    1ac0:	00330a00 	eorseq	r0, r3, r0, lsl #20
    1ac4:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    1ac8:	000006af 	andeq	r0, r0, pc, lsr #13
    1acc:	510b0d04 	tstpl	fp, r4, lsl #26
    1ad0:	fb000005 	blx	1aee <_start-0x6512>
    1ad4:	01000000 	mrseq	r0, (UNDEF: 0)
    1ad8:	000000c8 	andeq	r0, r0, r8, asr #1
    1adc:	000000d8 	ldrdeq	r0, [r0], -r8
    1ae0:	0000f509 	andeq	pc, r0, r9, lsl #10
    1ae4:	00330a00 	eorseq	r0, r3, r0, lsl #20
    1ae8:	330a0000 	movwcc	r0, #40960	; 0xa000
    1aec:	00000000 	andeq	r0, r0, r0
    1af0:	0004ef0b 	andeq	lr, r4, fp, lsl #30
    1af4:	0a0e0400 	beq	382afc <__bss_end+0x3773e8>
    1af8:	000012d3 	ldrdeq	r1, [r0], -r3
    1afc:	0000e901 	andeq	lr, r0, r1, lsl #18
    1b00:	00f50900 	rscseq	r0, r5, r0, lsl #18
    1b04:	540a0000 	strpl	r0, [sl], #-0
    1b08:	00000000 	andeq	r0, r0, r0
    1b0c:	6c040c00 	stcvs	12, cr0, [r4], {-0}
    1b10:	02000000 	andeq	r0, r0, #0
    1b14:	159a0404 	ldrne	r0, [sl, #1028]	; 0x404
    1b18:	720d0000 	andvc	r0, sp, #0
    1b1c:	0400646e 	streq	r6, [r0], #-1134	; 0xfffffb92
    1b20:	006c1611 	rsbeq	r1, ip, r1, lsl r6
    1b24:	670e0000 	strvs	r0, [lr, -r0]
    1b28:	14000012 	strne	r0, [r0], #-18	; 0xffffffee
    1b2c:	53080305 	movwpl	r0, #33541	; 0x8305
    1b30:	0f000001 	svceq	0x00000001
    1b34:	05050041 	streq	r0, [r5, #-65]	; 0xffffffbf
    1b38:	0000fb08 	andeq	pc, r0, r8, lsl #22
    1b3c:	420f0000 	andmi	r0, pc, #0
    1b40:	08060500 	stmdaeq	r6, {r8, sl}
    1b44:	000000fb 	strdeq	r0, [r0], -fp
    1b48:	00430f04 	subeq	r0, r3, r4, lsl #30
    1b4c:	fb080705 	blx	20376a <__bss_end+0x1f8056>
    1b50:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    1b54:	0500440f 	streq	r4, [r0, #-1039]	; 0xfffffbf1
    1b58:	00fb0808 	rscseq	r0, fp, r8, lsl #16
    1b5c:	0f0c0000 	svceq	0x000c0000
    1b60:	09050045 	stmdbeq	r5, {r0, r2, r6}
    1b64:	0000fb08 	andeq	pc, r0, r8, lsl #22
    1b68:	06001000 	streq	r1, [r0], -r0
    1b6c:	0000130f 	andeq	r1, r0, pc, lsl #6
    1b70:	07110618 			; <UNDEFINED> instruction: 0x07110618
    1b74:	000002d5 	ldrdeq	r0, [r0], -r5
    1b78:	000f3907 	andeq	r3, pc, r7, lsl #18
    1b7c:	0f140600 	svceq	0x00140600
    1b80:	000002da 	ldrdeq	r0, [r0], -sl
    1b84:	69660f00 	stmdbvs	r6!, {r8, r9, sl, fp}^
    1b88:	15060074 	strne	r0, [r6, #-116]	; 0xffffff8c
    1b8c:	0000fb0f 	andeq	pc, r0, pc, lsl #22
    1b90:	62101400 	andsvs	r1, r0, #0, 8
    1b94:	16060074 			; <UNDEFINED> instruction: 0x16060074
    1b98:	000cb60f 	andeq	fp, ip, pc, lsl #12
    1b9c:	0000fb00 	andeq	pc, r0, r0, lsl #22
    1ba0:	00019100 	andeq	r9, r1, r0, lsl #2
    1ba4:	0001a100 	andeq	sl, r1, r0, lsl #2
    1ba8:	02ea0900 	rsceq	r0, sl, #0, 18
    1bac:	fb0a0000 	blx	281bb6 <__bss_end+0x2764a2>
    1bb0:	0a000000 	beq	1bb8 <_start-0x6448>
    1bb4:	0000003f 	andeq	r0, r0, pc, lsr r0
    1bb8:	125f0800 	subsne	r0, pc, #0, 16
    1bbc:	19060000 	stmdbne	r6, {}	; <UNPREDICTABLE>
    1bc0:	0008a20f 	andeq	sl, r8, pc, lsl #4
    1bc4:	0000fb00 	andeq	pc, r0, r0, lsl #22
    1bc8:	01ba0100 			; <UNDEFINED> instruction: 0x01ba0100
    1bcc:	01cf0000 	biceq	r0, pc, r0
    1bd0:	ea090000 	b	241bd8 <__bss_end+0x2364c4>
    1bd4:	0a000002 	beq	1be4 <_start-0x641c>
    1bd8:	000002f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    1bdc:	0000fb0a 	andeq	pc, r0, sl, lsl #22
    1be0:	003f0a00 	eorseq	r0, pc, r0, lsl #20
    1be4:	11000000 	mrsne	r0, (UNDEF: 0)
    1be8:	00000977 	andeq	r0, r0, r7, ror r9
    1bec:	fb0e1a06 	blx	38840e <__bss_end+0x37ccfa>
    1bf0:	0100000c 	tsteq	r0, ip
    1bf4:	000001e4 	andeq	r0, r0, r4, ror #3
    1bf8:	000001ea 	andeq	r0, r0, sl, ror #3
    1bfc:	0002ea09 	andeq	lr, r2, r9, lsl #20
    1c00:	f4080000 	vst4.8	{d0-d3}, [r8], r0
    1c04:	0600000f 	streq	r0, [r0], -pc
    1c08:	0a66141b 	beq	1986c7c <__bss_end+0x197b568>
    1c0c:	01530000 	cmpeq	r3, r0
    1c10:	03010000 	movweq	r0, #4096	; 0x1000
    1c14:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
    1c18:	09000002 	stmdbeq	r0, {r1}
    1c1c:	000002ea 	andeq	r0, r0, sl, ror #5
    1c20:	0002f60a 	andeq	pc, r2, sl, lsl #12
    1c24:	2b110000 	blcs	441c2c <__bss_end+0x436518>
    1c28:	0600000f 	streq	r0, [r0], -pc
    1c2c:	0f0a0e1c 	svceq	0x000a0e1c
    1c30:	23010000 	movwcs	r0, #4096	; 0x1000
    1c34:	29000002 	stmdbcs	r0, {r1}
    1c38:	09000002 	stmdbeq	r0, {r1}
    1c3c:	000002ea 	andeq	r0, r0, sl, ror #5
    1c40:	125b0800 	subsne	r0, fp, #0, 16
    1c44:	1d060000 	stcne	0, cr0, [r6, #-0]
    1c48:	0006330f 	andeq	r3, r6, pc, lsl #6
    1c4c:	0000fb00 	andeq	pc, r0, r0, lsl #22
    1c50:	02420100 	subeq	r0, r2, #0, 2
    1c54:	02480000 	subeq	r0, r8, #0
    1c58:	ea090000 	b	241c60 <__bss_end+0x23654c>
    1c5c:	00000002 	andeq	r0, r0, r2
    1c60:	000daf08 	andeq	sl, sp, r8, lsl #30
    1c64:	0e1e0600 	cfmsub32eq	mvax0, mvfx0, mvfx14, mvfx0
    1c68:	00001057 	andeq	r1, r0, r7, asr r0
    1c6c:	000002fc 	strdeq	r0, [r0], -ip
    1c70:	00026101 	andeq	r6, r2, r1, lsl #2
    1c74:	00026c00 	andeq	r6, r2, r0, lsl #24
    1c78:	02ea0900 	rsceq	r0, sl, #0, 18
    1c7c:	030a0000 	movweq	r0, #40960	; 0xa000
    1c80:	00000003 	andeq	r0, r0, r3
    1c84:	000db908 	andeq	fp, sp, r8, lsl #18
    1c88:	0e1f0600 	cfmsub32eq	mvax0, mvfx0, mvfx15, mvfx0
    1c8c:	00001278 	andeq	r1, r0, r8, ror r2
    1c90:	000002fc 	strdeq	r0, [r0], -ip
    1c94:	00028501 	andeq	r8, r2, r1, lsl #10
    1c98:	00029000 	andeq	r9, r2, r0
    1c9c:	02ea0900 	rsceq	r0, sl, #0, 18
    1ca0:	030a0000 	movweq	r0, #40960	; 0xa000
    1ca4:	00000003 	andeq	r0, r0, r3
    1ca8:	00128f08 	andseq	r8, r2, r8, lsl #30
    1cac:	0f200600 	svceq	0x00200600
    1cb0:	00000ce0 	andeq	r0, r0, r0, ror #25
    1cb4:	000000fb 	strdeq	r0, [r0], -fp
    1cb8:	0002a901 	andeq	sl, r2, r1, lsl #18
    1cbc:	0002b900 	andeq	fp, r2, r0, lsl #18
    1cc0:	02ea0900 	rsceq	r0, sl, #0, 18
    1cc4:	fb0a0000 	blx	281cce <__bss_end+0x2765ba>
    1cc8:	0a000000 	beq	1cd0 <_start-0x6330>
    1ccc:	0000003f 	andeq	r0, r0, pc, lsr r0
    1cd0:	101f1200 	andsne	r1, pc, r0, lsl #4
    1cd4:	21060000 	mrscs	r0, (UNDEF: 6)
    1cd8:	0004850f 	andeq	r8, r4, pc, lsl #10
    1cdc:	00010e00 	andeq	r0, r1, r0, lsl #28
    1ce0:	02ce0100 	sbceq	r0, lr, #0, 2
    1ce4:	ea090000 	b	241cec <__bss_end+0x2365d8>
    1ce8:	00000002 	andeq	r0, r0, r2
    1cec:	01530500 	cmpeq	r3, r0, lsl #10
    1cf0:	fb130000 	blx	4c1cfa <__bss_end+0x4b65e6>
    1cf4:	ea000000 	b	1cfc <_start-0x6304>
    1cf8:	14000002 	strne	r0, [r0], #-2
    1cfc:	00000065 	andeq	r0, r0, r5, rrx
    1d00:	040c0004 	streq	r0, [ip], #-4
    1d04:	00000153 	andeq	r0, r0, r3, asr r1
    1d08:	00fb0415 	rscseq	r0, fp, r5, lsl r4
    1d0c:	04150000 	ldreq	r0, [r5], #-0
    1d10:	00000153 	andeq	r0, r0, r3, asr r1
    1d14:	e2020102 	and	r0, r2, #-2147483648	; 0x80000000
    1d18:	1500000a 	strne	r0, [r0, #-10]
    1d1c:	0002d504 	andeq	sp, r2, r4, lsl #10
    1d20:	040e1600 	streq	r1, [lr], #-1536	; 0xfffffa00
    1d24:	09600000 	stmdbeq	r0!, {}^	; <UNPREDICTABLE>
    1d28:	d9070a07 	stmdble	r7, {r0, r1, r2, r9, fp}
    1d2c:	17000003 	strne	r0, [r0, -r3]
    1d30:	000008f4 	strdeq	r0, [r0], -r4
    1d34:	180e0d07 	stmdane	lr, {r0, r1, r2, r8, sl, fp}
    1d38:	2b00000e 	blcs	1d78 <_start-0x6288>
    1d3c:	3b000003 	blcc	1d50 <_start-0x62b0>
    1d40:	09000003 	stmdbeq	r0, {r0, r1}
    1d44:	000003d9 	ldrdeq	r0, [r0], -r9
    1d48:	0003d90a 	andeq	sp, r3, sl, lsl #18
    1d4c:	003f0a00 	eorseq	r0, pc, r0, lsl #20
    1d50:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    1d54:	006e6567 	rsbeq	r6, lr, r7, ror #10
    1d58:	e4141007 	ldr	r1, [r4], #-7
    1d5c:	00000003 	andeq	r0, r0, r3
    1d60:	05a61101 	streq	r1, [r6, #257]!	; 0x101
    1d64:	12070000 	andne	r0, r7, #0
    1d68:	000ae70e 	andeq	lr, sl, lr, lsl #14
    1d6c:	035e0100 	cmpeq	lr, #0, 2
    1d70:	03780000 	cmneq	r8, #0
    1d74:	d9090000 	stmdble	r9, {}	; <UNPREDICTABLE>
    1d78:	0a000003 	beq	1d8c <_start-0x6274>
    1d7c:	000000fb 	strdeq	r0, [r0], -fp
    1d80:	0000540a 	andeq	r5, r0, sl, lsl #8
    1d84:	00fb0a00 	rscseq	r0, fp, r0, lsl #20
    1d88:	3f0a0000 	svccc	0x000a0000
    1d8c:	00000000 	andeq	r0, r0, r0
    1d90:	000cad11 	andeq	sl, ip, r1, lsl sp
    1d94:	0e130700 	cdpeq	7, 1, cr0, cr3, cr0, {0}
    1d98:	0000115c 	andeq	r1, r0, ip, asr r1
    1d9c:	00038d01 	andeq	r8, r3, r1, lsl #26
    1da0:	00039800 	andeq	r9, r3, r0, lsl #16
    1da4:	03d90900 	bicseq	r0, r9, #0, 18
    1da8:	d90a0000 	stmdble	sl, {}	; <UNPREDICTABLE>
    1dac:	00000003 	andeq	r0, r0, r3
    1db0:	000f5611 	andeq	r5, pc, r1, lsl r6	; <UNPREDICTABLE>
    1db4:	0e140700 	cdpeq	7, 1, cr0, cr4, cr0, {0}
    1db8:	000008ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    1dbc:	0003ad01 	andeq	sl, r3, r1, lsl #26
    1dc0:	0003b300 	andeq	fp, r3, r0, lsl #6
    1dc4:	03d90900 	bicseq	r0, r9, #0, 18
    1dc8:	12000000 	andne	r0, r0, #0
    1dcc:	0000128f 	andeq	r1, r0, pc, lsl #5
    1dd0:	9e0f1607 	cfmadd32ls	mvax0, mvfx1, mvfx15, mvfx7
    1dd4:	fb000011 	blx	1e22 <_start-0x61de>
    1dd8:	01000000 	mrseq	r0, (UNDEF: 0)
    1ddc:	000003c8 	andeq	r0, r0, r8, asr #7
    1de0:	0003d909 	andeq	sp, r3, r9, lsl #18
    1de4:	00fb0a00 	rscseq	r0, fp, r0, lsl #20
    1de8:	3f0a0000 	svccc	0x000a0000
    1dec:	00000000 	andeq	r0, r0, r0
    1df0:	09040c00 	stmdbeq	r4, {sl, fp}
    1df4:	05000003 	streq	r0, [r0, #-3]
    1df8:	000003d9 	ldrdeq	r0, [r0], -r9
    1dfc:	00015313 	andeq	r5, r1, r3, lsl r3
    1e00:	0003f400 	andeq	pc, r3, r0, lsl #8
    1e04:	00651400 	rsbeq	r1, r5, r0, lsl #8
    1e08:	00630000 	rsbeq	r0, r3, r0
    1e0c:	000c2519 	andeq	r2, ip, r9, lsl r5
    1e10:	14050800 	strne	r0, [r5], #-2048	; 0xfffff800
    1e14:	00000060 	andeq	r0, r0, r0, rrx
    1e18:	b5dc0305 	ldrblt	r0, [ip, #773]	; 0x305
    1e1c:	7c190000 	ldcvc	0, cr0, [r9], {-0}
    1e20:	0800000c 	stmdaeq	r0, {r2, r3}
    1e24:	00601406 	rsbeq	r1, r0, r6, lsl #8
    1e28:	03050000 	movweq	r0, #20480	; 0x5000
    1e2c:	0000b5e0 	andeq	fp, r0, r0, ror #11
    1e30:	000be119 	andeq	lr, fp, r9, lsl r1
    1e34:	1a070900 	bne	1c423c <__bss_end+0x1b8b28>
    1e38:	00000060 	andeq	r0, r0, r0, rrx
    1e3c:	b5e40305 	strblt	r0, [r4, #773]!	; 0x305
    1e40:	eb190000 	bl	641e48 <__bss_end+0x636734>
    1e44:	09000006 	stmdbeq	r0, {r1, r2}
    1e48:	00601a09 	rsbeq	r1, r0, r9, lsl #20
    1e4c:	03050000 	movweq	r0, #20480	; 0x5000
    1e50:	0000b5e8 	andeq	fp, r0, r8, ror #11
    1e54:	000d8119 	andeq	r8, sp, r9, lsl r1
    1e58:	1a0b0900 	bne	2c4260 <__bss_end+0x2b8b4c>
    1e5c:	00000060 	andeq	r0, r0, r0, rrx
    1e60:	b5ec0305 	strblt	r0, [ip, #773]!	; 0x305
    1e64:	ea190000 	b	641e6c <__bss_end+0x636758>
    1e68:	09000009 	stmdbeq	r0, {r0, r3}
    1e6c:	00601a0d 	rsbeq	r1, r0, sp, lsl #20
    1e70:	03050000 	movweq	r0, #20480	; 0x5000
    1e74:	0000b5f0 	strdeq	fp, [r0], -r0
    1e78:	00083e19 	andeq	r3, r8, r9, lsl lr
    1e7c:	1a0f0900 	bne	3c4284 <__bss_end+0x3b8b70>
    1e80:	00000060 	andeq	r0, r0, r0, rrx
    1e84:	b5f40305 	ldrblt	r0, [r4, #773]!	; 0x305
    1e88:	1e190000 	cdpne	0, 1, cr0, cr9, cr0, {0}
    1e8c:	0a000009 	beq	1eb8 <_start-0x6148>
    1e90:	00601404 	rsbeq	r1, r0, r4, lsl #8
    1e94:	03050000 	movweq	r0, #20480	; 0x5000
    1e98:	0000b5f8 	strdeq	fp, [r0], -r8
    1e9c:	0003bd19 	andeq	fp, r3, r9, lsl sp
    1ea0:	14070a00 	strne	r0, [r7], #-2560	; 0xfffff600
    1ea4:	00000060 	andeq	r0, r0, r0, rrx
    1ea8:	b5fc0305 	ldrblt	r0, [ip, #773]!	; 0x305
    1eac:	33190000 	tstcc	r9, #0
    1eb0:	0a000007 	beq	1ed4 <_start-0x612c>
    1eb4:	0060140a 	rsbeq	r1, r0, sl, lsl #8
    1eb8:	03050000 	movweq	r0, #20480	; 0x5000
    1ebc:	0000b600 	andeq	fp, r0, r0, lsl #12
    1ec0:	23070402 	movwcs	r0, #29698	; 0x7402
    1ec4:	1900001d 	stmdbne	r0, {r0, r2, r3, r4}
    1ec8:	000011cf 	andeq	r1, r0, pc, asr #3
    1ecc:	60140a0b 	andsvs	r0, r4, fp, lsl #20
    1ed0:	05000000 	streq	r0, [r0, #-0]
    1ed4:	00b60403 	adcseq	r0, r6, r3, lsl #8
    1ed8:	148b1a00 	strne	r1, [fp], #2560	; 0xa00
    1edc:	04020000 	streq	r0, [r2], #-0
    1ee0:	0014ba0d 	andseq	fp, r4, sp, lsl #20
    1ee4:	00988400 	addseq	r8, r8, r0, lsl #8
    1ee8:	00007800 	andeq	r7, r0, r0, lsl #16
    1eec:	0e9c0100 	fmleqe	f0, f4, f0
    1ef0:	1b000005 	blne	1f0c <_start-0x60f4>
    1ef4:	01530054 	cmpeq	r3, r4, asr r0
    1ef8:	761c0000 	ldrvc	r0, [ip], -r0
    1efc:	04020031 	streq	r0, [r2], #-49	; 0xffffffcf
    1f00:	0002f615 	andeq	pc, r2, r5, lsl r6	; <UNPREDICTABLE>
    1f04:	5c910200 	lfmpl	f0, 4, [r1], {0}
    1f08:	0032761c 	eorseq	r7, r2, ip, lsl r6
    1f0c:	f61b0402 			; <UNDEFINED> instruction: 0xf61b0402
    1f10:	02000002 	andeq	r0, r0, #2
    1f14:	d41d5891 	ldrle	r5, [sp], #-2193	; 0xfffff76f
    1f18:	02000013 	andeq	r0, r0, #19
    1f1c:	01530506 	cmpeq	r3, r6, lsl #10
    1f20:	91020000 	mrsls	r0, (UNDEF: 2)
    1f24:	d91e0060 	ldmdble	lr, {r5, r6}
    1f28:	02000013 	andeq	r0, r0, #19
    1f2c:	13f9060b 	mvnsne	r0, #11534336	; 0xb00000
    1f30:	962c0000 	strtls	r0, [ip], -r0
    1f34:	02580000 	subseq	r0, r8, #0
    1f38:	9c010000 	stcls	0, cr0, [r1], {-0}
    1f3c:	0000057f 	andeq	r0, r0, pc, ror r5
    1f40:	5300541b 	movwpl	r5, #1051	; 0x41b
    1f44:	1f000001 	svcne	0x00000001
    1f48:	000013c1 	andeq	r1, r0, r1, asr #7
    1f4c:	ea130b02 	b	4c4b5c <__bss_end+0x4b9448>
    1f50:	02000002 	andeq	r0, r0, #2
    1f54:	681c6c91 	ldmdavs	ip, {r0, r4, r7, sl, fp, sp, lr}
    1f58:	0b020069 	bleq	82104 <__bss_end+0x769f0>
    1f5c:	00003f1d 	andeq	r3, r0, sp, lsl pc
    1f60:	68910200 	ldmvs	r1, {r9}
    1f64:	006f6c1c 	rsbeq	r6, pc, ip, lsl ip	; <UNPREDICTABLE>
    1f68:	3f240b02 	svccc	0x00240b02
    1f6c:	02000000 	andeq	r0, r0, #0
    1f70:	54206491 	strtpl	r6, [r0], #-1169	; 0xfffffb6f
    1f74:	20000096 	mulcs	r0, r6, r0
    1f78:	21000002 	tstcs	r0, r2
    1f7c:	0f020069 	svceq	0x00020069
    1f80:	00003f09 	andeq	r3, r0, r9, lsl #30
    1f84:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1f88:	02006a21 	andeq	r6, r0, #135168	; 0x21000
    1f8c:	003f0910 	eorseq	r0, pc, r0, lsl r9	; <UNPREDICTABLE>
    1f90:	91020000 	mrsls	r0, (UNDEF: 2)
    1f94:	22000070 	andcs	r0, r0, #112	; 0x70
    1f98:	00000378 	andeq	r0, r0, r8, ror r3
    1f9c:	99062901 	stmdbls	r6, {r0, r8, fp, sp}
    1fa0:	a4000005 	strge	r0, [r0], #-5
    1fa4:	88000094 	stmdahi	r0, {r2, r4, r7}
    1fa8:	01000001 	tsteq	r0, r1
    1fac:	0005e49c 	muleq	r5, ip, r4
    1fb0:	131a2300 	tstne	sl, #0, 6
    1fb4:	03df0000 	bicseq	r0, pc, #0
    1fb8:	91020000 	mrsls	r0, (UNDEF: 2)
    1fbc:	00671c64 	rsbeq	r1, r7, r4, ror #24
    1fc0:	d9272901 	stmdble	r7!, {r0, r8, fp, sp}
    1fc4:	02000003 	andeq	r0, r0, #3
    1fc8:	69216091 	stmdbvs	r1!, {r0, r4, r7, sp, lr}
    1fcc:	092b0100 	stmdbeq	fp!, {r8}
    1fd0:	0000003f 	andeq	r0, r0, pc, lsr r0
    1fd4:	21749102 	cmncs	r4, r2, lsl #2
    1fd8:	3701006a 	strcc	r0, [r1, -sl, rrx]
    1fdc:	00003f09 	andeq	r3, r0, r9, lsl #30
    1fe0:	70910200 	addsvc	r0, r1, r0, lsl #4
    1fe4:	0095d820 	addseq	sp, r5, r0, lsr #16
    1fe8:	00004800 	andeq	r4, r0, r0, lsl #16
    1fec:	00692100 	rsbeq	r2, r9, r0, lsl #2
    1ff0:	3f0e3e01 	svccc	0x000e3e01
    1ff4:	02000000 	andeq	r0, r0, #0
    1ff8:	00006c91 	muleq	r0, r1, ip
    1ffc:	00031722 	andeq	r1, r3, r2, lsr #14
    2000:	061f0100 	ldreq	r0, [pc], -r0, lsl #2
    2004:	000005fe 	strdeq	r0, [r0], -lr
    2008:	000093a4 	andeq	r9, r0, r4, lsr #7
    200c:	00000100 	andeq	r0, r0, r0, lsl #2
    2010:	06679c01 	strbteq	r9, [r7], -r1, lsl #24
    2014:	1a230000 	bne	8c201c <__bss_end+0x8b6908>
    2018:	df000013 	svcle	0x00000013
    201c:	03000003 	movweq	r0, #3
    2020:	1c7fb491 	cfldrdne	mvd11, [pc], #-580	; 1de4 <_start-0x621c>
    2024:	1f010067 	svcne	0x00010067
    2028:	0003d929 	andeq	sp, r3, r9, lsr #18
    202c:	b0910300 	addslt	r0, r1, r0, lsl #6
    2030:	04631f7f 	strbteq	r1, [r3], #-3967	; 0xfffff081
    2034:	1f010000 	svcne	0x00010000
    2038:	00003f30 	andeq	r3, r0, r0, lsr pc
    203c:	ac910300 	ldcge	3, cr0, [r1], {0}
    2040:	13b01d7f 	movsne	r1, #8128	; 0x1fc0
    2044:	20010000 	andcs	r0, r1, r0
    2048:	00003f09 	andeq	r3, r0, r9, lsl #30
    204c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2050:	00149c1d 	andseq	r9, r4, sp, lsl ip
    2054:	10210100 	eorne	r0, r1, r0, lsl #2
    2058:	00000153 	andeq	r0, r0, r3, asr r1
    205c:	1d509102 	ldfnep	f1, [r0, #-8]
    2060:	000014a8 	andeq	r1, r0, r8, lsr #9
    2064:	3f092301 	svccc	0x00092301
    2068:	02000000 	andeq	r0, r0, #0
    206c:	c71d6891 			; <UNDEFINED> instruction: 0xc71d6891
    2070:	01000013 	tsteq	r0, r3, lsl r0
    2074:	01531024 	cmpeq	r3, r4, lsr #32
    2078:	91030000 	mrsls	r0, (UNDEF: 3)
    207c:	22007fb8 	andcs	r7, r0, #184, 30	; 0x2e0
    2080:	000003b3 			; <UNDEFINED> instruction: 0x000003b3
    2084:	81071801 	tsthi	r7, r1, lsl #16
    2088:	54000006 	strpl	r0, [r0], #-6
    208c:	50000093 	mulpl	r0, r3, r0
    2090:	01000000 	mrseq	r0, (UNDEF: 0)
    2094:	0006ac9c 	muleq	r6, ip, ip
    2098:	131a2300 	tstne	sl, #0, 6
    209c:	03df0000 	bicseq	r0, pc, #0
    20a0:	91020000 	mrsls	r0, (UNDEF: 2)
    20a4:	13ef1f74 	mvnne	r1, #116, 30	; 0x1d0
    20a8:	18010000 	stmdane	r1, {}	; <UNPREDICTABLE>
    20ac:	0000fb21 	andeq	pc, r0, r1, lsr #22
    20b0:	70910200 	addsvc	r0, r1, r0, lsl #4
    20b4:	0012ff1f 	andseq	pc, r2, pc, lsl pc	; <UNPREDICTABLE>
    20b8:	30180100 	andscc	r0, r8, r0, lsl #2
    20bc:	0000003f 	andeq	r0, r0, pc, lsr r0
    20c0:	006c9102 	rsbeq	r9, ip, r2, lsl #2
    20c4:	00039822 	andeq	r9, r3, r2, lsr #16
    20c8:	06110100 	ldreq	r0, [r1], -r0, lsl #2
    20cc:	000006c6 	andeq	r0, r0, r6, asr #13
    20d0:	000092f0 	strdeq	r9, [r0], -r0
    20d4:	00000064 	andeq	r0, r0, r4, rrx
    20d8:	06ea9c01 	strbteq	r9, [sl], r1, lsl #24
    20dc:	1a230000 	bne	8c20e4 <__bss_end+0x8b69d0>
    20e0:	df000013 	svcle	0x00000013
    20e4:	02000003 	andeq	r0, r0, #3
    20e8:	00206c91 	mlaeq	r0, r1, ip, r6
    20ec:	48000093 	stmdami	r0, {r0, r1, r4, r7}
    20f0:	21000000 	mrscs	r0, (UNDEF: 0)
    20f4:	13010069 	movwne	r0, #4201	; 0x1069
    20f8:	00003f0e 	andeq	r3, r0, lr, lsl #30
    20fc:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2100:	49240000 	stmdbmi	r4!, {}	; <UNPREDICTABLE>
    2104:	01000003 	tsteq	r0, r3
    2108:	07000607 	streq	r0, [r0, -r7, lsl #12]
    210c:	925c0000 	subsls	r0, ip, #0
    2110:	00940000 	addseq	r0, r4, r0
    2114:	9c010000 	stcls	0, cr0, [r1], {-0}
    2118:	00131a23 	andseq	r1, r3, r3, lsr #20
    211c:	0003df00 	andeq	sp, r3, r0, lsl #30
    2120:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2124:	00131f1f 	andseq	r1, r3, pc, lsl pc
    2128:	25070100 	strcs	r0, [r7, #-256]	; 0xffffff00
    212c:	000000fb 	strdeq	r0, [r0], -fp
    2130:	1f689102 	svcne	0x00689102
    2134:	00000e47 	andeq	r0, r0, r7, asr #28
    2138:	543e0701 	ldrtpl	r0, [lr], #-1793	; 0xfffff8ff
    213c:	02000000 	andeq	r0, r0, #0
    2140:	791c6491 	ldmdbvc	ip, {r0, r4, r7, sl, sp, lr}
    2144:	07010074 	smlsdxeq	r1, r4, r0, r0
    2148:	0000fb4a 	andeq	pc, r0, sl, asr #22
    214c:	60910200 	addsvs	r0, r1, r0, lsl #4
    2150:	0012ff1f 	andseq	pc, r2, pc, lsl pc	; <UNPREDICTABLE>
    2154:	52070100 	andpl	r0, r7, #0, 2
    2158:	0000003f 	andeq	r0, r0, pc, lsr r0
    215c:	205c9102 	subscs	r9, ip, r2, lsl #2
    2160:	0000927c 	andeq	r9, r0, ip, ror r2
    2164:	00000054 	andeq	r0, r0, r4, asr r0
    2168:	01006921 	tsteq	r0, r1, lsr #18
    216c:	003f0e09 	eorseq	r0, pc, r9, lsl #28
    2170:	91020000 	mrsls	r0, (UNDEF: 2)
    2174:	00000074 	andeq	r0, r0, r4, ror r0
    2178:	0000024e 	andeq	r0, r0, lr, asr #4
    217c:	09540004 	ldmdbeq	r4, {r2}^
    2180:	01040000 	mrseq	r0, (UNDEF: 4)
    2184:	00000233 	andeq	r0, r0, r3, lsr r2
    2188:	0014fb04 	andseq	pc, r4, r4, lsl #22
    218c:	00004c00 	andeq	r4, r0, r0, lsl #24
    2190:	0098fc00 	addseq	pc, r8, r0, lsl #24
    2194:	00011800 	andeq	r1, r1, r0, lsl #16
    2198:	000f9500 	andeq	r9, pc, r0, lsl #10
    219c:	08010200 	stmdaeq	r1, {r9}
    21a0:	00000daa 	andeq	r0, r0, sl, lsr #27
    21a4:	00002503 	andeq	r2, r0, r3, lsl #10
    21a8:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
    21ac:	00000e39 	andeq	r0, r0, r9, lsr lr
    21b0:	69050404 	stmdbvs	r5, {r2, sl}
    21b4:	0200746e 	andeq	r7, r0, #1845493760	; 0x6e000000
    21b8:	0da10801 	stceq	8, cr0, [r1, #4]!
    21bc:	02020000 	andeq	r0, r2, #0
    21c0:	000a1b07 	andeq	r1, sl, r7, lsl #22
    21c4:	0ed50500 	cdpeq	5, 13, cr0, cr5, cr0, {0}
    21c8:	09060000 	stmdbeq	r6, {}	; <UNPREDICTABLE>
    21cc:	00005e07 	andeq	r5, r0, r7, lsl #28
    21d0:	004d0300 	subeq	r0, sp, r0, lsl #6
    21d4:	04020000 	streq	r0, [r2], #-0
    21d8:	001d2807 	andseq	r2, sp, r7, lsl #16
    21dc:	0c250600 	stceq	6, cr0, [r5], #-0
    21e0:	05020000 	streq	r0, [r2, #-0]
    21e4:	00005914 	andeq	r5, r0, r4, lsl r9
    21e8:	08030500 	stmdaeq	r3, {r8, sl}
    21ec:	060000b6 			; <UNDEFINED> instruction: 0x060000b6
    21f0:	00000c7c 	andeq	r0, r0, ip, ror ip
    21f4:	59140602 	ldmdbpl	r4, {r1, r9, sl}
    21f8:	05000000 	streq	r0, [r0, #-0]
    21fc:	00b60c03 	adcseq	r0, r6, r3, lsl #24
    2200:	0be10600 	bleq	ff843a08 <__bss_end+0xff8382f4>
    2204:	07030000 	streq	r0, [r3, -r0]
    2208:	0000591a 	andeq	r5, r0, sl, lsl r9
    220c:	10030500 	andne	r0, r3, r0, lsl #10
    2210:	060000b6 			; <UNDEFINED> instruction: 0x060000b6
    2214:	000006eb 	andeq	r0, r0, fp, ror #13
    2218:	591a0903 	ldmdbpl	sl, {r0, r1, r8, fp}
    221c:	05000000 	streq	r0, [r0, #-0]
    2220:	00b61403 	adcseq	r1, r6, r3, lsl #8
    2224:	0d810600 	stceq	6, cr0, [r1]
    2228:	0b030000 	bleq	c2230 <__bss_end+0xb6b1c>
    222c:	0000591a 	andeq	r5, r0, sl, lsl r9
    2230:	18030500 	stmdane	r3, {r8, sl}
    2234:	060000b6 			; <UNDEFINED> instruction: 0x060000b6
    2238:	000009ea 	andeq	r0, r0, sl, ror #19
    223c:	591a0d03 	ldmdbpl	sl, {r0, r1, r8, sl, fp}
    2240:	05000000 	streq	r0, [r0, #-0]
    2244:	00b61c03 	adcseq	r1, r6, r3, lsl #24
    2248:	083e0600 	ldmdaeq	lr!, {r9, sl}
    224c:	0f030000 	svceq	0x00030000
    2250:	0000591a 	andeq	r5, r0, sl, lsl r9
    2254:	20030500 	andcs	r0, r3, r0, lsl #10
    2258:	020000b6 	andeq	r0, r0, #182	; 0xb6
    225c:	0ae20201 	beq	ff882a68 <__bss_end+0xff877354>
    2260:	04070000 	streq	r0, [r7], #-0
    2264:	0000002c 	andeq	r0, r0, ip, lsr #32
    2268:	00091e06 	andeq	r1, r9, r6, lsl #28
    226c:	14040400 	strne	r0, [r4], #-1024	; 0xfffffc00
    2270:	00000059 	andeq	r0, r0, r9, asr r0
    2274:	b6240305 	strtlt	r0, [r4], -r5, lsl #6
    2278:	bd060000 	stclt	0, cr0, [r6, #-0]
    227c:	04000003 	streq	r0, [r0], #-3
    2280:	00591407 	subseq	r1, r9, r7, lsl #8
    2284:	03050000 	movweq	r0, #20480	; 0x5000
    2288:	0000b628 	andeq	fp, r0, r8, lsr #12
    228c:	00073306 	andeq	r3, r7, r6, lsl #6
    2290:	140a0400 	strne	r0, [sl], #-1024	; 0xfffffc00
    2294:	00000059 	andeq	r0, r0, r9, asr r0
    2298:	b62c0305 	strtlt	r0, [ip], -r5, lsl #6
    229c:	04020000 	streq	r0, [r2], #-0
    22a0:	001d2307 	andseq	r2, sp, r7, lsl #6
    22a4:	11cf0600 	bicne	r0, pc, r0, lsl #12
    22a8:	0a050000 	beq	1422b0 <__bss_end+0x136b9c>
    22ac:	00005914 	andeq	r5, r0, r4, lsl r9
    22b0:	30030500 	andcc	r0, r3, r0, lsl #10
    22b4:	080000b6 	stmdaeq	r0, {r1, r2, r4, r5, r7}
    22b8:	0000158c 	andeq	r1, r0, ip, lsl #11
    22bc:	5d061101 	stfpls	f1, [r6, #-4]
    22c0:	9c000015 	stcls	0, cr0, [r0], {21}
    22c4:	78000099 	stmdavc	r0, {r0, r3, r4, r7}
    22c8:	01000000 	mrseq	r0, (UNDEF: 0)
    22cc:	0001aa9c 	muleq	r1, ip, sl
    22d0:	0e470900 	vmlaeq.f16	s1, s14, s0	; <UNPREDICTABLE>
    22d4:	11010000 	mrsne	r0, (UNDEF: 1)
    22d8:	00004d23 	andeq	r4, r0, r3, lsr #26
    22dc:	e4910300 	ldr	r0, [r1], #768	; 0x300
    22e0:	14f4097e 	ldrbtne	r0, [r4], #2430	; 0x97e
    22e4:	11010000 	mrsne	r0, (UNDEF: 1)
    22e8:	0000ea35 	andeq	lr, r0, r5, lsr sl
    22ec:	e0910300 	adds	r0, r1, r0, lsl #6
    22f0:	61760a7e 	cmnvs	r6, lr, ror sl
    22f4:	1101006c 	tstne	r1, ip, rrx
    22f8:	0001aa43 	andeq	sl, r1, r3, asr #20
    22fc:	dc910300 	ldcle	3, cr0, [r1], {0}
    2300:	14d70b7e 	ldrbne	r0, [r7], #2942	; 0xb7e
    2304:	12010000 	andne	r0, r1, #0
    2308:	0001b107 	andeq	fp, r1, r7, lsl #2
    230c:	f8910300 			; <UNDEFINED> instruction: 0xf8910300
    2310:	157a0b7e 	ldrbne	r0, [sl, #-2942]!	; 0xfffff482
    2314:	13010000 	movwne	r0, #4096	; 0x1000
    2318:	0001c107 	andeq	ip, r1, r7, lsl #2
    231c:	ec910300 	ldc	3, cr0, [r1], {0}
    2320:	0402007e 	streq	r0, [r2], #-126	; 0xffffff82
    2324:	00159a04 	andseq	r9, r5, r4, lsl #20
    2328:	00250c00 	eoreq	r0, r5, r0, lsl #24
    232c:	01c10000 	biceq	r0, r1, r0
    2330:	5e0d0000 	cdppl	0, 0, cr0, cr13, cr0, {0}
    2334:	7f000000 	svcvc	0x00000000
    2338:	00250c00 	eoreq	r0, r5, r0, lsl #24
    233c:	01d10000 	bicseq	r0, r1, r0
    2340:	5e0d0000 	cdppl	0, 0, cr0, cr13, cr0, {0}
    2344:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    2348:	15840800 	strne	r0, [r4, #2048]	; 0x800
    234c:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    2350:	0014e506 	andseq	lr, r4, r6, lsl #10
    2354:	00993800 	addseq	r3, r9, r0, lsl #16
    2358:	00006400 	andeq	r6, r0, r0, lsl #8
    235c:	1c9c0100 	ldfnes	f0, [ip], {0}
    2360:	09000002 	stmdbeq	r0, {r1}
    2364:	00000e47 	andeq	r0, r0, r7, asr #28
    2368:	4d170801 	ldcmi	8, cr0, [r7, #-4]
    236c:	03000000 	movweq	r0, #0
    2370:	097ef491 	ldmdbeq	lr!, {r0, r4, r7, sl, ip, sp, lr, pc}^
    2374:	000014f4 	strdeq	r1, [r0], -r4
    2378:	ea290801 	b	a44384 <__bss_end+0xa38c70>
    237c:	03000000 	movweq	r0, #0
    2380:	0b7ef091 	bleq	1fbe5cc <__bss_end+0x1fb2eb8>
    2384:	000014d7 	ldrdeq	r1, [r0], -r7
    2388:	b1070a01 	tstlt	r7, r1, lsl #20
    238c:	03000001 	movweq	r0, #1
    2390:	007ef891 			; <UNDEFINED> instruction: 0x007ef891
    2394:	0015a00e 	andseq	sl, r5, lr
    2398:	06030100 	streq	r0, [r3], -r0, lsl #2
    239c:	000015a6 	andeq	r1, r0, r6, lsr #11
    23a0:	000098fc 	strdeq	r9, [r0], -ip
    23a4:	0000003c 	andeq	r0, r0, ip, lsr r0
    23a8:	47099c01 	strmi	r9, [r9, -r1, lsl #24]
    23ac:	0100000e 	tsteq	r0, lr
    23b0:	004d1503 	subeq	r1, sp, r3, lsl #10
    23b4:	91020000 	mrsls	r0, (UNDEF: 2)
    23b8:	14f40974 	ldrbtne	r0, [r4], #2420	; 0x974
    23bc:	03010000 	movweq	r0, #4096	; 0x1000
    23c0:	0000ea27 	andeq	lr, r0, r7, lsr #20
    23c4:	70910200 	addsvc	r0, r1, r0, lsl #4
    23c8:	0ba50000 	bleq	fe9423d0 <__bss_end+0xfe936cbc>
    23cc:	00040000 	andeq	r0, r4, r0
    23d0:	00000a2b 	andeq	r0, r0, fp, lsr #20
    23d4:	177f0104 	ldrbne	r0, [pc, -r4, lsl #2]!
    23d8:	ec040000 	stc	0, cr0, [r4], {-0}
    23dc:	24000016 	strcs	r0, [r0], #-22	; 0xffffffea
    23e0:	14000019 	strne	r0, [r0], #-25	; 0xffffffe7
    23e4:	5c00009a 	stcpl	0, cr0, [r0], {154}	; 0x9a
    23e8:	bd000004 	stclt	0, cr0, [r0, #-16]
    23ec:	02000011 	andeq	r0, r0, #17
    23f0:	0daa0801 	stceq	8, cr0, [sl, #4]!
    23f4:	25030000 	strcs	r0, [r3, #-0]
    23f8:	02000000 	andeq	r0, r0, #0
    23fc:	0e390502 	cdpeq	5, 3, cr0, cr9, cr2, {0}
    2400:	04040000 	streq	r0, [r4], #-0
    2404:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    2408:	08010200 	stmdaeq	r1, {r9}
    240c:	00000da1 	andeq	r0, r0, r1, lsr #27
    2410:	1b070202 	blne	1c2c20 <__bss_end+0x1b750c>
    2414:	0500000a 	streq	r0, [r0, #-10]
    2418:	00000ed5 	ldrdeq	r0, [r0], -r5
    241c:	5e070907 	vmlapl.f16	s0, s14, s14	; <UNPREDICTABLE>
    2420:	03000000 	movweq	r0, #0
    2424:	0000004d 	andeq	r0, r0, sp, asr #32
    2428:	28070402 	stmdacs	r7, {r1, sl}
    242c:	0600001d 			; <UNDEFINED> instruction: 0x0600001d
    2430:	0000080c 	andeq	r0, r0, ip, lsl #16
    2434:	08060208 	stmdaeq	r6, {r3, r9}
    2438:	0000008b 	andeq	r0, r0, fp, lsl #1
    243c:	00307207 	eorseq	r7, r0, r7, lsl #4
    2440:	4d0e0802 	stcmi	8, cr0, [lr, #-8]
    2444:	00000000 	andeq	r0, r0, r0
    2448:	00317207 	eorseq	r7, r1, r7, lsl #4
    244c:	4d0e0902 	vstrmi.16	s0, [lr, #-4]	; <UNPREDICTABLE>
    2450:	04000000 	streq	r0, [r0], #-0
    2454:	18680800 	stmdane	r8!, {fp}^
    2458:	04050000 	streq	r0, [r5], #-0
    245c:	00000038 	andeq	r0, r0, r8, lsr r0
    2460:	a90c0d02 	stmdbge	ip, {r1, r8, sl, fp}
    2464:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    2468:	00004b4f 	andeq	r4, r0, pc, asr #22
    246c:	0016160a 	andseq	r1, r6, sl, lsl #12
    2470:	08000100 	stmdaeq	r0, {r8}
    2474:	000005b3 			; <UNDEFINED> instruction: 0x000005b3
    2478:	00380405 	eorseq	r0, r8, r5, lsl #8
    247c:	1f020000 	svcne	0x00020000
    2480:	0000e00c 	andeq	lr, r0, ip
    2484:	088c0a00 	stmeq	ip, {r9, fp}
    2488:	0a000000 	beq	2490 <_start-0x5b70>
    248c:	000012c3 	andeq	r1, r0, r3, asr #5
    2490:	12970a01 	addsne	r0, r7, #4096	; 0x1000
    2494:	0a020000 	beq	8249c <__bss_end+0x76d88>
    2498:	00000acb 	andeq	r0, r0, fp, asr #21
    249c:	0cd10a03 	vldmiaeq	r1, {s1-s3}
    24a0:	0a040000 	beq	1024a8 <__bss_end+0xf6d94>
    24a4:	00000855 	andeq	r0, r0, r5, asr r8
    24a8:	79080005 	stmdbvc	r8, {r0, r2}
    24ac:	05000011 	streq	r0, [r0, #-17]	; 0xffffffef
    24b0:	00003804 	andeq	r3, r0, r4, lsl #16
    24b4:	0c400200 	sfmeq	f0, 2, [r0], {-0}
    24b8:	0000011d 	andeq	r0, r0, sp, lsl r1
    24bc:	0003c80a 	andeq	ip, r3, sl, lsl #16
    24c0:	c80a0000 	stmdagt	sl, {}	; <UNPREDICTABLE>
    24c4:	01000005 	tsteq	r0, r5
    24c8:	000ca00a 	andeq	sl, ip, sl
    24cc:	200a0200 	andcs	r0, sl, r0, lsl #4
    24d0:	03000012 	movweq	r0, #18
    24d4:	0012cd0a 	andseq	ip, r2, sl, lsl #26
    24d8:	f70a0400 			; <UNDEFINED> instruction: 0xf70a0400
    24dc:	0500000b 	streq	r0, [r0, #-11]
    24e0:	000a490a 	andeq	r4, sl, sl, lsl #18
    24e4:	08000600 	stmdaeq	r0, {r9, sl}
    24e8:	00000e8a 	andeq	r0, r0, sl, lsl #29
    24ec:	00380405 	eorseq	r0, r8, r5, lsl #8
    24f0:	66020000 	strvs	r0, [r2], -r0
    24f4:	0001360c 	andeq	r3, r1, ip, lsl #12
    24f8:	0ccc0a00 	vstmiaeq	ip, {s1-s0}
    24fc:	00000000 	andeq	r0, r0, r0
    2500:	00111608 	andseq	r1, r1, r8, lsl #12
    2504:	38040500 	stmdacc	r4, {r8, sl}
    2508:	02000000 	andeq	r0, r0, #0
    250c:	01610c6f 	cmneq	r1, pc, ror #24
    2510:	760a0000 	strvc	r0, [sl], -r0
    2514:	0000000d 	andeq	r0, r0, sp
    2518:	0009fd0a 	andeq	pc, r9, sl, lsl #26
    251c:	730a0100 	movwvc	r0, #41216	; 0xa100
    2520:	0200000e 	andeq	r0, r0, #14
    2524:	000a4e0a 	andeq	r4, sl, sl, lsl #28
    2528:	0b000300 	bleq	3130 <_start-0x4ed0>
    252c:	00000c25 	andeq	r0, r0, r5, lsr #24
    2530:	59140503 	ldmdbpl	r4, {r0, r1, r8, sl}
    2534:	05000000 	streq	r0, [r0, #-0]
    2538:	00b63803 	adcseq	r3, r6, r3, lsl #16
    253c:	0c7c0b00 			; <UNDEFINED> instruction: 0x0c7c0b00
    2540:	06030000 	streq	r0, [r3], -r0
    2544:	00005914 	andeq	r5, r0, r4, lsl r9
    2548:	3c030500 	cfstr32cc	mvfx0, [r3], {-0}
    254c:	0b0000b6 	bleq	282c <_start-0x57d4>
    2550:	00000be1 	andeq	r0, r0, r1, ror #23
    2554:	591a0704 	ldmdbpl	sl, {r2, r8, r9, sl}
    2558:	05000000 	streq	r0, [r0, #-0]
    255c:	00b64003 	adcseq	r4, r6, r3
    2560:	06eb0b00 	strbteq	r0, [fp], r0, lsl #22
    2564:	09040000 	stmdbeq	r4, {}	; <UNPREDICTABLE>
    2568:	0000591a 	andeq	r5, r0, sl, lsl r9
    256c:	44030500 	strmi	r0, [r3], #-1280	; 0xfffffb00
    2570:	0b0000b6 	bleq	2850 <_start-0x57b0>
    2574:	00000d81 	andeq	r0, r0, r1, lsl #27
    2578:	591a0b04 	ldmdbpl	sl, {r2, r8, r9, fp}
    257c:	05000000 	streq	r0, [r0, #-0]
    2580:	00b64803 	adcseq	r4, r6, r3, lsl #16
    2584:	09ea0b00 	stmibeq	sl!, {r8, r9, fp}^
    2588:	0d040000 	stceq	0, cr0, [r4, #-0]
    258c:	0000591a 	andeq	r5, r0, sl, lsl r9
    2590:	4c030500 	cfstr32mi	mvfx0, [r3], {-0}
    2594:	0b0000b6 	bleq	2874 <_start-0x578c>
    2598:	0000083e 	andeq	r0, r0, lr, lsr r8
    259c:	591a0f04 	ldmdbpl	sl, {r2, r8, r9, sl, fp}
    25a0:	05000000 	streq	r0, [r0, #-0]
    25a4:	00b65003 	adcseq	r5, r6, r3
    25a8:	19140800 	ldmdbne	r4, {fp}
    25ac:	04050000 	streq	r0, [r5], #-0
    25b0:	00000038 	andeq	r0, r0, r8, lsr r0
    25b4:	040c1b04 	streq	r1, [ip], #-2820	; 0xfffff4fc
    25b8:	0a000002 	beq	25c8 <_start-0x5a38>
    25bc:	00000f4c 	andeq	r0, r0, ip, asr #30
    25c0:	126d0a00 	rsbne	r0, sp, #0, 20
    25c4:	0a010000 	beq	425cc <__bss_end+0x36eb8>
    25c8:	00000c9b 	muleq	r0, fp, ip
    25cc:	620c0002 	andvs	r0, ip, #2
    25d0:	0200000d 	andeq	r0, r0, #13
    25d4:	0ae20201 	beq	ff882de0 <__bss_end+0xff8776cc>
    25d8:	040d0000 	streq	r0, [sp], #-0
    25dc:	0000002c 	andeq	r0, r0, ip, lsr #32
    25e0:	0204040d 	andeq	r0, r4, #218103808	; 0xd000000
    25e4:	1e0b0000 	cdpne	0, 0, cr0, cr11, cr0, {0}
    25e8:	05000009 	streq	r0, [r0, #-9]
    25ec:	00591404 	subseq	r1, r9, r4, lsl #8
    25f0:	03050000 	movweq	r0, #20480	; 0x5000
    25f4:	0000b654 	andeq	fp, r0, r4, asr r6
    25f8:	0003bd0b 	andeq	fp, r3, fp, lsl #26
    25fc:	14070500 	strne	r0, [r7], #-1280	; 0xfffffb00
    2600:	00000059 	andeq	r0, r0, r9, asr r0
    2604:	b6580305 	ldrblt	r0, [r8], -r5, lsl #6
    2608:	330b0000 	movwcc	r0, #45056	; 0xb000
    260c:	05000007 	streq	r0, [r0, #-7]
    2610:	0059140a 	subseq	r1, r9, sl, lsl #8
    2614:	03050000 	movweq	r0, #20480	; 0x5000
    2618:	0000b65c 	andeq	fp, r0, ip, asr r6
    261c:	000b4508 	andeq	r4, fp, r8, lsl #10
    2620:	38040500 	stmdacc	r4, {r8, sl}
    2624:	05000000 	streq	r0, [r0, #-0]
    2628:	02890c0d 	addeq	r0, r9, #3328	; 0xd00
    262c:	4e090000 	cdpmi	0, 0, cr0, cr9, cr0, {0}
    2630:	00007765 	andeq	r7, r0, r5, ror #14
    2634:	000b3c0a 	andeq	r3, fp, sl, lsl #24
    2638:	ae0a0100 	adfgee	f0, f2, f0
    263c:	0200000e 	andeq	r0, r0, #14
    2640:	000b140a 	andeq	r1, fp, sl, lsl #8
    2644:	bd0a0300 	stclt	3, cr0, [sl, #-0]
    2648:	0400000a 	streq	r0, [r0], #-10
    264c:	000ca60a 	andeq	sl, ip, sl, lsl #12
    2650:	06000500 	streq	r0, [r0], -r0, lsl #10
    2654:	00000848 	andeq	r0, r0, r8, asr #16
    2658:	081b0510 	ldmdaeq	fp, {r4, r8, sl}
    265c:	000002c8 	andeq	r0, r0, r8, asr #5
    2660:	00726c07 	rsbseq	r6, r2, r7, lsl #24
    2664:	c8131d05 	ldmdagt	r3, {r0, r2, r8, sl, fp, ip}
    2668:	00000002 	andeq	r0, r0, r2
    266c:	00707307 	rsbseq	r7, r0, r7, lsl #6
    2670:	c8131e05 	ldmdagt	r3, {r0, r2, r9, sl, fp, ip}
    2674:	04000002 	streq	r0, [r0], #-2
    2678:	00637007 	rsbeq	r7, r3, r7
    267c:	c8131f05 	ldmdagt	r3, {r0, r2, r8, r9, sl, fp, ip}
    2680:	08000002 	stmdaeq	r0, {r1}
    2684:	00085e0e 	andeq	r5, r8, lr, lsl #28
    2688:	13200500 	nopne	{0}	; <UNPREDICTABLE>
    268c:	000002c8 	andeq	r0, r0, r8, asr #5
    2690:	0402000c 	streq	r0, [r2], #-12
    2694:	001d2307 	andseq	r2, sp, r7, lsl #6
    2698:	04520600 	ldrbeq	r0, [r2], #-1536	; 0xfffffa00
    269c:	05800000 	streq	r0, [r0]
    26a0:	03920828 	orrseq	r0, r2, #40, 16	; 0x280000
    26a4:	400e0000 	andmi	r0, lr, r0
    26a8:	0500000f 	streq	r0, [r0, #-15]
    26ac:	0289122a 	addeq	r1, r9, #-1610612734	; 0xa0000002
    26b0:	07000000 	streq	r0, [r0, -r0]
    26b4:	00646970 	rsbeq	r6, r4, r0, ror r9
    26b8:	5e122b05 	vnmlspl.f64	d2, d2, d5
    26bc:	10000000 	andne	r0, r0, r0
    26c0:	0006b80e 	andeq	fp, r6, lr, lsl #16
    26c4:	112c0500 			; <UNDEFINED> instruction: 0x112c0500
    26c8:	00000252 	andeq	r0, r0, r2, asr r2
    26cc:	0b7f0e14 	bleq	1fc5f24 <__bss_end+0x1fba810>
    26d0:	2d050000 	stccs	0, cr0, [r5, #-0]
    26d4:	00005e12 	andeq	r5, r0, r2, lsl lr
    26d8:	8d0e1800 	stchi	8, cr1, [lr, #-0]
    26dc:	0500000b 	streq	r0, [r0, #-11]
    26e0:	005e122e 	subseq	r1, lr, lr, lsr #4
    26e4:	0e1c0000 	cdpeq	0, 1, cr0, cr12, cr0, {0}
    26e8:	0000082c 	andeq	r0, r0, ip, lsr #16
    26ec:	920c2f05 	andls	r2, ip, #5, 30
    26f0:	20000003 	andcs	r0, r0, r3
    26f4:	000ba90e 	andeq	sl, fp, lr, lsl #18
    26f8:	09300500 	ldmdbeq	r0!, {r8, sl}
    26fc:	00000038 	andeq	r0, r0, r8, lsr r0
    2700:	0f710e60 	svceq	0x00710e60
    2704:	31050000 	mrscc	r0, (UNDEF: 5)
    2708:	00004d0e 	andeq	r4, r0, lr, lsl #26
    270c:	d40e6400 	strle	r6, [lr], #-1024	; 0xfffffc00
    2710:	05000008 	streq	r0, [r0, #-8]
    2714:	004d0e33 	subeq	r0, sp, r3, lsr lr
    2718:	0e680000 	cdpeq	0, 6, cr0, cr8, cr0, {0}
    271c:	000008cb 	andeq	r0, r0, fp, asr #17
    2720:	4d0e3405 	cfstrsmi	mvf3, [lr, #-20]	; 0xffffffec
    2724:	6c000000 	stcvs	0, cr0, [r0], {-0}
    2728:	00747007 	rsbseq	r7, r4, r7
    272c:	a20f3505 	andge	r3, pc, #20971520	; 0x1400000
    2730:	70000003 	andvc	r0, r0, r3
    2734:	00122b0e 	andseq	r2, r2, lr, lsl #22
    2738:	0e370500 	cfabs32eq	mvfx0, mvfx7
    273c:	0000004d 	andeq	r0, r0, sp, asr #32
    2740:	08180e74 	ldmdaeq	r8, {r2, r4, r5, r6, r9, sl, fp}
    2744:	38050000 	stmdacc	r5, {}	; <UNPREDICTABLE>
    2748:	00004d0e 	andeq	r4, r0, lr, lsl #26
    274c:	c20e7800 	andgt	r7, lr, #0, 16
    2750:	0500000e 	streq	r0, [r0, #-14]
    2754:	004d0e39 	subeq	r0, sp, r9, lsr lr
    2758:	007c0000 	rsbseq	r0, ip, r0
    275c:	0002160f 	andeq	r1, r2, pc, lsl #12
    2760:	0003a200 	andeq	sl, r3, r0, lsl #4
    2764:	005e1000 	subseq	r1, lr, r0
    2768:	000f0000 	andeq	r0, pc, r0
    276c:	004d040d 	subeq	r0, sp, sp, lsl #8
    2770:	cf0b0000 	svcgt	0x000b0000
    2774:	06000011 			; <UNDEFINED> instruction: 0x06000011
    2778:	0059140a 	subseq	r1, r9, sl, lsl #8
    277c:	03050000 	movweq	r0, #20480	; 0x5000
    2780:	0000b660 	andeq	fp, r0, r0, ror #12
    2784:	000b1c08 	andeq	r1, fp, r8, lsl #24
    2788:	38040500 	stmdacc	r4, {r8, sl}
    278c:	06000000 	streq	r0, [r0], -r0
    2790:	03d90c0d 	bicseq	r0, r9, #3328	; 0xd00
    2794:	dc0a0000 	stcle	0, cr0, [sl], {-0}
    2798:	00000005 	andeq	r0, r0, r5
    279c:	0003b20a 	andeq	fp, r3, sl, lsl #4
    27a0:	03000100 	movweq	r0, #256	; 0x100
    27a4:	000003ba 			; <UNDEFINED> instruction: 0x000003ba
    27a8:	0016d708 	andseq	sp, r6, r8, lsl #14
    27ac:	38040500 	stmdacc	r4, {r8, sl}
    27b0:	06000000 	streq	r0, [r0], -r0
    27b4:	03fd0c14 	mvnseq	r0, #20, 24	; 0x1400
    27b8:	b90a0000 	stmdblt	sl, {}	; <UNPREDICTABLE>
    27bc:	00000015 	andeq	r0, r0, r5, lsl r0
    27c0:	00183a0a 	andseq	r3, r8, sl, lsl #20
    27c4:	03000100 	movweq	r0, #256	; 0x100
    27c8:	000003de 	ldrdeq	r0, [r0], -lr
    27cc:	00109106 	andseq	r9, r0, r6, lsl #2
    27d0:	1b060c00 	blne	1857d8 <__bss_end+0x17a0c4>
    27d4:	00043708 	andeq	r3, r4, r8, lsl #14
    27d8:	04240e00 	strteq	r0, [r4], #-3584	; 0xfffff200
    27dc:	1d060000 	stcne	0, cr0, [r6, #-0]
    27e0:	00043719 	andeq	r3, r4, r9, lsl r7
    27e4:	8e0e0000 	cdphi	0, 0, cr0, cr14, cr0, {0}
    27e8:	06000005 	streq	r0, [r0], -r5
    27ec:	0437191e 	ldrteq	r1, [r7], #-2334	; 0xfffff6e2
    27f0:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
    27f4:	00000fef 	andeq	r0, r0, pc, ror #31
    27f8:	3d131f06 	ldccc	15, cr1, [r3, #-24]	; 0xffffffe8
    27fc:	08000004 	stmdaeq	r0, {r2}
    2800:	02040d00 	andeq	r0, r4, #0, 26
    2804:	0d000004 	stceq	0, cr0, [r0, #-16]
    2808:	0002cf04 	andeq	ip, r2, r4, lsl #30
    280c:	07461100 	strbeq	r1, [r6, -r0, lsl #2]
    2810:	06140000 	ldreq	r0, [r4], -r0
    2814:	06f90722 	ldrbteq	r0, [r9], r2, lsr #14
    2818:	0a0e0000 	beq	382820 <__bss_end+0x37710c>
    281c:	0600000b 	streq	r0, [r0], -fp
    2820:	004d1226 	subeq	r1, sp, r6, lsr #4
    2824:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    2828:	000004a1 	andeq	r0, r0, r1, lsr #9
    282c:	371d2906 	ldrcc	r2, [sp, -r6, lsl #18]
    2830:	04000004 	streq	r0, [r0], #-4
    2834:	000eeb0e 	andeq	lr, lr, lr, lsl #22
    2838:	1d2c0600 	stcne	6, cr0, [ip, #-0]
    283c:	00000437 	andeq	r0, r0, r7, lsr r4
    2840:	11521208 	cmpne	r2, r8, lsl #4
    2844:	2f060000 	svccs	0x00060000
    2848:	00106e0e 	andseq	r6, r0, lr, lsl #28
    284c:	00048b00 	andeq	r8, r4, r0, lsl #22
    2850:	00049600 	andeq	r9, r4, r0, lsl #12
    2854:	06fe1300 	ldrbteq	r1, [lr], r0, lsl #6
    2858:	37140000 	ldrcc	r0, [r4, -r0]
    285c:	00000004 	andeq	r0, r0, r4
    2860:	00100715 	andseq	r0, r0, r5, lsl r7
    2864:	0e310600 	cfmsuba32eq	mvax0, mvax0, mvfx1, mvfx0
    2868:	00000429 	andeq	r0, r0, r9, lsr #8
    286c:	00000209 	andeq	r0, r0, r9, lsl #4
    2870:	000004ae 	andeq	r0, r0, lr, lsr #9
    2874:	000004b9 			; <UNDEFINED> instruction: 0x000004b9
    2878:	0006fe13 	andeq	pc, r6, r3, lsl lr	; <UNPREDICTABLE>
    287c:	043d1400 	ldrteq	r1, [sp], #-1024	; 0xfffffc00
    2880:	16000000 	strne	r0, [r0], -r0
    2884:	000010b3 	strheq	r1, [r0], -r3
    2888:	ca1d3506 	bgt	74fca8 <__bss_end+0x744594>
    288c:	3700000f 	strcc	r0, [r0, -pc]
    2890:	02000004 	andeq	r0, r0, #4
    2894:	000004d2 	ldrdeq	r0, [r0], -r2
    2898:	000004d8 	ldrdeq	r0, [r0], -r8
    289c:	0006fe13 	andeq	pc, r6, r3, lsl lr	; <UNPREDICTABLE>
    28a0:	3c160000 	ldccc	0, cr0, [r6], {-0}
    28a4:	0600000a 	streq	r0, [r0], -sl
    28a8:	0de71d37 	stcleq	13, cr1, [r7, #220]!	; 0xdc
    28ac:	04370000 	ldrteq	r0, [r7], #-0
    28b0:	f1020000 	cps	#0
    28b4:	f7000004 			; <UNDEFINED> instruction: 0xf7000004
    28b8:	13000004 	movwne	r0, #4
    28bc:	000006fe 	strdeq	r0, [r0], -lr
    28c0:	0bd31700 	bleq	ff4c84c8 <__bss_end+0xff4bcdb4>
    28c4:	39060000 	stmdbcc	r6, {}	; <UNPREDICTABLE>
    28c8:	00071731 	andeq	r1, r7, r1, lsr r7
    28cc:	16020c00 	strne	r0, [r2], -r0, lsl #24
    28d0:	00000746 	andeq	r0, r0, r6, asr #14
    28d4:	9d093c06 	stcls	12, cr3, [r9, #-24]	; 0xffffffe8
    28d8:	fe000012 	mcr2	0, 0, r0, cr0, cr2, {0}
    28dc:	01000006 	tsteq	r0, r6
    28e0:	0000051e 	andeq	r0, r0, lr, lsl r5
    28e4:	00000524 	andeq	r0, r0, r4, lsr #10
    28e8:	0006fe13 	andeq	pc, r6, r3, lsl lr	; <UNPREDICTABLE>
    28ec:	24160000 	ldrcs	r0, [r6], #-0
    28f0:	06000006 	streq	r0, [r0], -r6
    28f4:	1127123f 			; <UNDEFINED> instruction: 0x1127123f
    28f8:	004d0000 	subeq	r0, sp, r0
    28fc:	3d010000 	stccc	0, cr0, [r1, #-0]
    2900:	52000005 	andpl	r0, r0, #5
    2904:	13000005 	movwne	r0, #5
    2908:	000006fe 	strdeq	r0, [r0], -lr
    290c:	00072014 	andeq	r2, r7, r4, lsl r0
    2910:	005e1400 	subseq	r1, lr, r0, lsl #8
    2914:	09140000 	ldmdbeq	r4, {}	; <UNPREDICTABLE>
    2918:	00000002 	andeq	r0, r0, r2
    291c:	00101618 	andseq	r1, r0, r8, lsl r6
    2920:	0e420600 	cdpeq	6, 4, cr0, cr2, cr0, {0}
    2924:	00000d14 	andeq	r0, r0, r4, lsl sp
    2928:	00056701 	andeq	r6, r5, r1, lsl #14
    292c:	00056d00 	andeq	r6, r5, r0, lsl #26
    2930:	06fe1300 	ldrbteq	r1, [lr], r0, lsl #6
    2934:	16000000 	strne	r0, [r0], -r0
    2938:	00000963 	andeq	r0, r0, r3, ror #18
    293c:	fd174506 	ldc2	5, cr4, [r7, #-24]	; 0xffffffe8
    2940:	3d000004 	stccc	0, cr0, [r0, #-16]
    2944:	01000004 	tsteq	r0, r4
    2948:	00000586 	andeq	r0, r0, r6, lsl #11
    294c:	0000058c 	andeq	r0, r0, ip, lsl #11
    2950:	00072613 	andeq	r2, r7, r3, lsl r6
    2954:	93160000 	tstls	r6, #0
    2958:	06000005 	streq	r0, [r0], -r5
    295c:	0f7d1748 	svceq	0x007d1748
    2960:	043d0000 	ldrteq	r0, [sp], #-0
    2964:	a5010000 	strge	r0, [r1, #-0]
    2968:	b0000005 	andlt	r0, r0, r5
    296c:	13000005 	movwne	r0, #5
    2970:	00000726 	andeq	r0, r0, r6, lsr #14
    2974:	00004d14 	andeq	r4, r0, r4, lsl sp
    2978:	de180000 	cdple	0, 1, cr0, cr8, cr0, {0}
    297c:	06000011 			; <UNDEFINED> instruction: 0x06000011
    2980:	03cd0e4b 	biceq	r0, sp, #1200	; 0x4b0
    2984:	c5010000 	strgt	r0, [r1, #-0]
    2988:	cb000005 	blgt	29a4 <_start-0x565c>
    298c:	13000005 	movwne	r0, #5
    2990:	000006fe 	strdeq	r0, [r0], -lr
    2994:	10071600 	andne	r1, r7, r0, lsl #12
    2998:	4d060000 	stcmi	0, cr0, [r6, #-0]
    299c:	0008640e 	andeq	r6, r8, lr, lsl #8
    29a0:	00020900 	andeq	r0, r2, r0, lsl #18
    29a4:	05e40100 	strbeq	r0, [r4, #256]!	; 0x100
    29a8:	05ef0000 	strbeq	r0, [pc, #0]!	; 29b0 <_start-0x5650>
    29ac:	fe130000 	cdp2	0, 1, cr0, cr3, cr0, {0}
    29b0:	14000006 	strne	r0, [r0], #-6
    29b4:	0000004d 	andeq	r0, r0, sp, asr #32
    29b8:	097e1600 	ldmdbeq	lr!, {r9, sl, ip}^
    29bc:	50060000 	andpl	r0, r6, r0
    29c0:	000d3512 	andeq	r3, sp, r2, lsl r5
    29c4:	00004d00 	andeq	r4, r0, r0, lsl #26
    29c8:	06080100 	streq	r0, [r8], -r0, lsl #2
    29cc:	06130000 	ldreq	r0, [r3], -r0
    29d0:	fe130000 	cdp2	0, 1, cr0, cr3, cr0, {0}
    29d4:	14000006 	strne	r0, [r0], #-6
    29d8:	00000216 	andeq	r0, r0, r6, lsl r2
    29dc:	04691600 	strbteq	r1, [r9], #-1536	; 0xfffffa00
    29e0:	53060000 	movwpl	r0, #24576	; 0x6000
    29e4:	0009370e 	andeq	r3, r9, lr, lsl #14
    29e8:	00020900 	andeq	r0, r2, r0, lsl #18
    29ec:	062c0100 	strteq	r0, [ip], -r0, lsl #2
    29f0:	06370000 	ldrteq	r0, [r7], -r0
    29f4:	fe130000 	cdp2	0, 1, cr0, cr3, cr0, {0}
    29f8:	14000006 	strne	r0, [r0], #-6
    29fc:	0000004d 	andeq	r0, r0, sp, asr #32
    2a00:	0a081800 	beq	208a08 <__bss_end+0x1fd2f4>
    2a04:	56060000 	strpl	r0, [r6], -r0
    2a08:	0010bf0e 	andseq	fp, r0, lr, lsl #30
    2a0c:	064c0100 	strbeq	r0, [ip], -r0, lsl #2
    2a10:	066b0000 	strbteq	r0, [fp], -r0
    2a14:	fe130000 	cdp2	0, 1, cr0, cr3, cr0, {0}
    2a18:	14000006 	strne	r0, [r0], #-6
    2a1c:	000000a9 	andeq	r0, r0, r9, lsr #1
    2a20:	00004d14 	andeq	r4, r0, r4, lsl sp
    2a24:	004d1400 	subeq	r1, sp, r0, lsl #8
    2a28:	4d140000 	ldcmi	0, cr0, [r4, #-0]
    2a2c:	14000000 	strne	r0, [r0], #-0
    2a30:	0000072c 	andeq	r0, r0, ip, lsr #14
    2a34:	0faa1800 	svceq	0x00aa1800
    2a38:	58060000 	stmdapl	r6, {}	; <UNPREDICTABLE>
    2a3c:	0007c00e 	andeq	ip, r7, lr
    2a40:	06800100 	streq	r0, [r0], r0, lsl #2
    2a44:	069f0000 	ldreq	r0, [pc], r0
    2a48:	fe130000 	cdp2	0, 1, cr0, cr3, cr0, {0}
    2a4c:	14000006 	strne	r0, [r0], #-6
    2a50:	000000e0 	andeq	r0, r0, r0, ror #1
    2a54:	00004d14 	andeq	r4, r0, r4, lsl sp
    2a58:	004d1400 	subeq	r1, sp, r0, lsl #8
    2a5c:	4d140000 	ldcmi	0, cr0, [r4, #-0]
    2a60:	14000000 	strne	r0, [r0], #-0
    2a64:	0000072c 	andeq	r0, r0, ip, lsr #14
    2a68:	0d8f1800 	stceq	8, cr1, [pc]	; 2a70 <_start-0x5590>
    2a6c:	5a060000 	bpl	182a74 <__bss_end+0x177360>
    2a70:	00099a0e 	andeq	r9, r9, lr, lsl #20
    2a74:	06b40100 	ldrteq	r0, [r4], r0, lsl #2
    2a78:	06d30000 	ldrbeq	r0, [r3], r0
    2a7c:	fe130000 	cdp2	0, 1, cr0, cr3, cr0, {0}
    2a80:	14000006 	strne	r0, [r0], #-6
    2a84:	0000011d 	andeq	r0, r0, sp, lsl r1
    2a88:	00004d14 	andeq	r4, r0, r4, lsl sp
    2a8c:	004d1400 	subeq	r1, sp, r0, lsl #8
    2a90:	4d140000 	ldcmi	0, cr0, [r4, #-0]
    2a94:	14000000 	strne	r0, [r0], #-0
    2a98:	0000072c 	andeq	r0, r0, ip, lsr #14
    2a9c:	07201900 	streq	r1, [r0, -r0, lsl #18]!
    2aa0:	5d060000 	stcpl	0, cr0, [r6, #-0]
    2aa4:	0007680e 	andeq	r6, r7, lr, lsl #16
    2aa8:	00020900 	andeq	r0, r2, r0, lsl #18
    2aac:	06e80100 	strbteq	r0, [r8], r0, lsl #2
    2ab0:	fe130000 	cdp2	0, 1, cr0, cr3, cr0, {0}
    2ab4:	14000006 	strne	r0, [r0], #-6
    2ab8:	000003ba 			; <UNDEFINED> instruction: 0x000003ba
    2abc:	00073214 	andeq	r3, r7, r4, lsl r2
    2ac0:	03000000 	movweq	r0, #0
    2ac4:	00000443 	andeq	r0, r0, r3, asr #8
    2ac8:	0443040d 	strbeq	r0, [r3], #-1037	; 0xfffffbf3
    2acc:	371a0000 	ldrcc	r0, [sl, -r0]
    2ad0:	11000004 	tstne	r0, r4
    2ad4:	17000007 	strne	r0, [r0, -r7]
    2ad8:	13000007 	movwne	r0, #7
    2adc:	000006fe 	strdeq	r0, [r0], -lr
    2ae0:	04431b00 	strbeq	r1, [r3], #-2816	; 0xfffff500
    2ae4:	07040000 	streq	r0, [r4, -r0]
    2ae8:	040d0000 	streq	r0, [sp], #-0
    2aec:	0000003f 	andeq	r0, r0, pc, lsr r0
    2af0:	06f9040d 	ldrbteq	r0, [r9], sp, lsl #8
    2af4:	041c0000 	ldreq	r0, [ip], #-0
    2af8:	00000065 	andeq	r0, r0, r5, rrx
    2afc:	2c0f041d 	cfstrscs	mvf0, [pc], {29}
    2b00:	44000000 	strmi	r0, [r0], #-0
    2b04:	10000007 	andne	r0, r0, r7
    2b08:	0000005e 	andeq	r0, r0, lr, asr r0
    2b0c:	34030009 	strcc	r0, [r3], #-9
    2b10:	1e000007 	cdpne	0, 0, cr0, cr0, cr7, {0}
    2b14:	00001662 	andeq	r1, r0, r2, ror #12
    2b18:	440ca401 	strmi	sl, [ip], #-1025	; 0xfffffbff
    2b1c:	05000007 	streq	r0, [r0, #-7]
    2b20:	00b66403 	adcseq	r6, r6, r3, lsl #8
    2b24:	15d21f00 	ldrbne	r1, [r2, #3840]	; 0xf00
    2b28:	a6010000 	strge	r0, [r1], -r0
    2b2c:	0016cb0a 	andseq	ip, r6, sl, lsl #22
    2b30:	00004d00 	andeq	r4, r0, r0, lsl #26
    2b34:	009dc000 	addseq	ip, sp, r0
    2b38:	0000b000 	andeq	fp, r0, r0
    2b3c:	b99c0100 	ldmiblt	ip, {r8}
    2b40:	20000007 	andcs	r0, r0, r7
    2b44:	000018fc 	strdeq	r1, [r0], -ip
    2b48:	101ba601 	andsne	sl, fp, r1, lsl #12
    2b4c:	03000002 	movweq	r0, #2
    2b50:	207fac91 			; <UNDEFINED> instruction: 0x207fac91
    2b54:	00001776 	andeq	r1, r0, r6, ror r7
    2b58:	4d2aa601 	stcmi	6, cr10, [sl, #-4]!
    2b5c:	03000000 	movweq	r0, #0
    2b60:	1e7fa891 	mrcne	8, 3, sl, cr15, cr1, {4}
    2b64:	000016ba 			; <UNDEFINED> instruction: 0x000016ba
    2b68:	b90aa801 	stmdblt	sl, {r0, fp, sp, pc}
    2b6c:	03000007 	movweq	r0, #7
    2b70:	1e7fb491 	mrcne	4, 3, fp, cr15, cr1, {4}
    2b74:	000015cd 	andeq	r1, r0, sp, asr #11
    2b78:	3809ac01 	stmdacc	r9, {r0, sl, fp, sp, pc}
    2b7c:	02000000 	andeq	r0, r0, #0
    2b80:	0f007491 	svceq	0x00007491
    2b84:	00000025 	andeq	r0, r0, r5, lsr #32
    2b88:	000007c9 	andeq	r0, r0, r9, asr #15
    2b8c:	00005e10 	andeq	r5, r0, r0, lsl lr
    2b90:	21003f00 	tstcs	r0, r0, lsl #30
    2b94:	0000175b 	andeq	r1, r0, fp, asr r7
    2b98:	480a9801 	stmdami	sl, {r0, fp, ip, pc}
    2b9c:	4d000018 	stcmi	0, cr0, [r0, #-96]	; 0xffffffa0
    2ba0:	84000000 	strhi	r0, [r0], #-0
    2ba4:	3c00009d 	stccc	0, cr0, [r0], {157}	; 0x9d
    2ba8:	01000000 	mrseq	r0, (UNDEF: 0)
    2bac:	0008069c 	muleq	r8, ip, r6
    2bb0:	65722200 	ldrbvs	r2, [r2, #-512]!	; 0xfffffe00
    2bb4:	9a010071 	bls	42d80 <__bss_end+0x3766c>
    2bb8:	0003fd20 	andeq	pc, r3, r0, lsr #26
    2bbc:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2bc0:	0016c01e 	andseq	ip, r6, lr, lsl r0
    2bc4:	0e9b0100 	fmleqe	f0, f3, f0
    2bc8:	0000004d 	andeq	r0, r0, sp, asr #32
    2bcc:	00709102 	rsbseq	r9, r0, r2, lsl #2
    2bd0:	00181d23 	andseq	r1, r8, r3, lsr #26
    2bd4:	068f0100 	streq	r0, [pc], r0, lsl #2
    2bd8:	000015ee 	andeq	r1, r0, lr, ror #11
    2bdc:	00009d48 	andeq	r9, r0, r8, asr #26
    2be0:	0000003c 	andeq	r0, r0, ip, lsr r0
    2be4:	083f9c01 	ldmdaeq	pc!, {r0, sl, fp, ip, pc}	; <UNPREDICTABLE>
    2be8:	30200000 	eorcc	r0, r0, r0
    2bec:	01000016 	tsteq	r0, r6, lsl r0
    2bf0:	004d218f 	subeq	r2, sp, pc, lsl #3
    2bf4:	91020000 	mrsls	r0, (UNDEF: 2)
    2bf8:	6572226c 	ldrbvs	r2, [r2, #-620]!	; 0xfffffd94
    2bfc:	91010071 	tstls	r1, r1, ror r0
    2c00:	0003fd20 	andeq	pc, r3, r0, lsr #26
    2c04:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2c08:	173e2100 	ldrne	r2, [lr, -r0, lsl #2]!
    2c0c:	83010000 	movwhi	r0, #4096	; 0x1000
    2c10:	0016730a 	andseq	r7, r6, sl, lsl #6
    2c14:	00004d00 	andeq	r4, r0, r0, lsl #26
    2c18:	009d0c00 	addseq	r0, sp, r0, lsl #24
    2c1c:	00003c00 	andeq	r3, r0, r0, lsl #24
    2c20:	7c9c0100 	ldfvcs	f0, [ip], {0}
    2c24:	22000008 	andcs	r0, r0, #8
    2c28:	00716572 	rsbseq	r6, r1, r2, ror r5
    2c2c:	d9208501 	stmdble	r0!, {r0, r8, sl, pc}
    2c30:	02000003 	andeq	r0, r0, #3
    2c34:	c61e7491 			; <UNDEFINED> instruction: 0xc61e7491
    2c38:	01000015 	tsteq	r0, r5, lsl r0
    2c3c:	004d0e86 	subeq	r0, sp, r6, lsl #29
    2c40:	91020000 	mrsls	r0, (UNDEF: 2)
    2c44:	df210070 	svcle	0x00210070
    2c48:	01000018 	tsteq	r0, r8, lsl r0
    2c4c:	16440a77 			; <UNDEFINED> instruction: 0x16440a77
    2c50:	004d0000 	subeq	r0, sp, r0
    2c54:	9cd00000 	ldclls	0, cr0, [r0], {0}
    2c58:	003c0000 	eorseq	r0, ip, r0
    2c5c:	9c010000 	stcls	0, cr0, [r1], {-0}
    2c60:	000008b9 			; <UNDEFINED> instruction: 0x000008b9
    2c64:	71657222 	cmnvc	r5, r2, lsr #4
    2c68:	20790100 	rsbscs	r0, r9, r0, lsl #2
    2c6c:	000003d9 	ldrdeq	r0, [r0], -r9
    2c70:	1e749102 	expnes	f1, f2
    2c74:	000015c6 	andeq	r1, r0, r6, asr #11
    2c78:	4d0e7a01 	vstrmi	s14, [lr, #-4]
    2c7c:	02000000 	andeq	r0, r0, #0
    2c80:	21007091 	swpcs	r7, r1, [r0]
    2c84:	00001687 	andeq	r1, r0, r7, lsl #13
    2c88:	2f066b01 	svccs	0x00066b01
    2c8c:	09000018 	stmdbeq	r0, {r3, r4}
    2c90:	7c000002 	stcvc	0, cr0, [r0], {2}
    2c94:	5400009c 	strpl	r0, [r0], #-156	; 0xffffff64
    2c98:	01000000 	mrseq	r0, (UNDEF: 0)
    2c9c:	0009059c 	muleq	r9, ip, r5
    2ca0:	16c02000 	strbne	r2, [r0], r0
    2ca4:	6b010000 	blvs	42cac <__bss_end+0x37598>
    2ca8:	00004d15 	andeq	r4, r0, r5, lsl sp
    2cac:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2cb0:	0008cb20 	andeq	ip, r8, r0, lsr #22
    2cb4:	256b0100 	strbcs	r0, [fp, #-256]!	; 0xffffff00
    2cb8:	0000004d 	andeq	r0, r0, sp, asr #32
    2cbc:	1e689102 	lgnnee	f1, f2
    2cc0:	000018d7 	ldrdeq	r1, [r0], -r7
    2cc4:	4d0e6d01 	stcmi	13, cr6, [lr, #-4]
    2cc8:	02000000 	andeq	r0, r0, #0
    2ccc:	21007491 			; <UNDEFINED> instruction: 0x21007491
    2cd0:	00001605 	andeq	r1, r0, r5, lsl #12
    2cd4:	7f125e01 	svcvc	0x00125e01
    2cd8:	8b000018 	blhi	2d40 <_start-0x52c0>
    2cdc:	2c000000 	stccs	0, cr0, [r0], {-0}
    2ce0:	5000009c 	mulpl	r0, ip, r0
    2ce4:	01000000 	mrseq	r0, (UNDEF: 0)
    2ce8:	0009609c 	muleq	r9, ip, r0
    2cec:	0e472000 	cdpeq	0, 4, cr2, cr7, cr0, {0}
    2cf0:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    2cf4:	00004d20 	andeq	r4, r0, r0, lsr #26
    2cf8:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2cfc:	00174720 	andseq	r4, r7, r0, lsr #14
    2d00:	2f5e0100 	svccs	0x005e0100
    2d04:	0000004d 	andeq	r0, r0, sp, asr #32
    2d08:	20689102 	rsbcs	r9, r8, r2, lsl #2
    2d0c:	000008cb 	andeq	r0, r0, fp, asr #17
    2d10:	4d3f5e01 	ldcmi	14, cr5, [pc, #-4]!	; 2d14 <_start-0x52ec>
    2d14:	02000000 	andeq	r0, r0, #0
    2d18:	d71e6491 			; <UNDEFINED> instruction: 0xd71e6491
    2d1c:	01000018 	tsteq	r0, r8, lsl r0
    2d20:	008b1660 	addeq	r1, fp, r0, ror #12
    2d24:	91020000 	mrsls	r0, (UNDEF: 2)
    2d28:	b5210074 	strlt	r0, [r1, #-116]!	; 0xffffff8c
    2d2c:	01000018 	tsteq	r0, r8, lsl r0
    2d30:	160a0a52 			; <UNDEFINED> instruction: 0x160a0a52
    2d34:	004d0000 	subeq	r0, sp, r0
    2d38:	9be80000 	blls	ffa02d40 <__bss_end+0xff9f762c>
    2d3c:	00440000 	subeq	r0, r4, r0
    2d40:	9c010000 	stcls	0, cr0, [r1], {-0}
    2d44:	000009ac 	andeq	r0, r0, ip, lsr #19
    2d48:	000e4720 	andeq	r4, lr, r0, lsr #14
    2d4c:	1a520100 	bne	1483154 <__bss_end+0x1477a40>
    2d50:	0000004d 	andeq	r0, r0, sp, asr #32
    2d54:	206c9102 	rsbcs	r9, ip, r2, lsl #2
    2d58:	00001747 	andeq	r1, r0, r7, asr #14
    2d5c:	4d295201 	sfmmi	f5, 4, [r9, #-4]!
    2d60:	02000000 	andeq	r0, r0, #0
    2d64:	ae1e6891 	mrcge	8, 0, r6, cr14, cr1, {4}
    2d68:	01000018 	tsteq	r0, r8, lsl r0
    2d6c:	004d0e54 	subeq	r0, sp, r4, asr lr
    2d70:	91020000 	mrsls	r0, (UNDEF: 2)
    2d74:	a8210074 	stmdage	r1!, {r2, r4, r5, r6}
    2d78:	01000018 	tsteq	r0, r8, lsl r0
    2d7c:	188a0a45 	stmne	sl, {r0, r2, r6, r9, fp}
    2d80:	004d0000 	subeq	r0, sp, r0
    2d84:	9b980000 	blls	fe602d8c <__bss_end+0xfe5f7678>
    2d88:	00500000 	subseq	r0, r0, r0
    2d8c:	9c010000 	stcls	0, cr0, [r1], {-0}
    2d90:	00000a07 	andeq	r0, r0, r7, lsl #20
    2d94:	000e4720 	andeq	r4, lr, r0, lsr #14
    2d98:	19450100 	stmdbne	r5, {r8}^
    2d9c:	0000004d 	andeq	r0, r0, sp, asr #32
    2da0:	206c9102 	rsbcs	r9, ip, r2, lsl #2
    2da4:	0000169b 	muleq	r0, fp, r6
    2da8:	36304501 	ldrtcc	r4, [r0], -r1, lsl #10
    2dac:	02000001 	andeq	r0, r0, #1
    2db0:	70206891 	mlavc	r0, r1, r8, r6
    2db4:	0100000d 	tsteq	r0, sp
    2db8:	07324145 	ldreq	r4, [r2, -r5, asr #2]!
    2dbc:	91020000 	mrsls	r0, (UNDEF: 2)
    2dc0:	18d71e64 	ldmne	r7, {r2, r5, r6, r9, sl, fp, ip}^
    2dc4:	47010000 	strmi	r0, [r1, -r0]
    2dc8:	00004d0e 	andeq	r4, r0, lr, lsl #26
    2dcc:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2dd0:	15b32300 	ldrne	r2, [r3, #768]!	; 0x300
    2dd4:	3f010000 	svccc	0x00010000
    2dd8:	0016a506 	andseq	sl, r6, r6, lsl #10
    2ddc:	009b6c00 	addseq	r6, fp, r0, lsl #24
    2de0:	00002c00 	andeq	r2, r0, r0, lsl #24
    2de4:	319c0100 	orrscc	r0, ip, r0, lsl #2
    2de8:	2000000a 	andcs	r0, r0, sl
    2dec:	00000e47 	andeq	r0, r0, r7, asr #28
    2df0:	4d153f01 	ldcmi	15, cr3, [r5, #-4]
    2df4:	02000000 	andeq	r0, r0, #0
    2df8:	21007491 			; <UNDEFINED> instruction: 0x21007491
    2dfc:	00000ba3 	andeq	r0, r0, r3, lsr #23
    2e00:	4d0a3201 	sfmmi	f3, 4, [sl, #-4]
    2e04:	4d000017 	stcmi	0, cr0, [r0, #-92]	; 0xffffffa4
    2e08:	1c000000 	stcne	0, cr0, [r0], {-0}
    2e0c:	5000009b 	mulpl	r0, fp, r0
    2e10:	01000000 	mrseq	r0, (UNDEF: 0)
    2e14:	000a8c9c 	muleq	sl, ip, ip
    2e18:	0e472000 	cdpeq	0, 4, cr2, cr7, cr0, {0}
    2e1c:	32010000 	andcc	r0, r1, #0
    2e20:	00004d19 	andeq	r4, r0, r9, lsl sp
    2e24:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2e28:	00061d20 	andeq	r1, r6, r0, lsr #26
    2e2c:	2b320100 	blcs	c83234 <__bss_end+0xc77b20>
    2e30:	00000210 	andeq	r0, r0, r0, lsl r2
    2e34:	20689102 	rsbcs	r9, r8, r2, lsl #2
    2e38:	0000177a 	andeq	r1, r0, sl, ror r7
    2e3c:	4d3c3201 	lfmmi	f3, 4, [ip, #-4]!
    2e40:	02000000 	andeq	r0, r0, #0
    2e44:	791e6491 	ldmdbvc	lr, {r0, r4, r7, sl, sp, lr}
    2e48:	01000018 	tsteq	r0, r8, lsl r0
    2e4c:	004d0e34 	subeq	r0, sp, r4, lsr lr
    2e50:	91020000 	mrsls	r0, (UNDEF: 2)
    2e54:	1b210074 	blne	84302c <__bss_end+0x837918>
    2e58:	01000012 	tsteq	r0, r2, lsl r0
    2e5c:	18cb0a25 	stmiane	fp, {r0, r2, r5, r9, fp}^
    2e60:	004d0000 	subeq	r0, sp, r0
    2e64:	9acc0000 	bls	ff302e6c <__bss_end+0xff2f7758>
    2e68:	00500000 	subseq	r0, r0, r0
    2e6c:	9c010000 	stcls	0, cr0, [r1], {-0}
    2e70:	00000ae7 	andeq	r0, r0, r7, ror #21
    2e74:	000e4720 	andeq	r4, lr, r0, lsr #14
    2e78:	18250100 	stmdane	r5!, {r8}
    2e7c:	0000004d 	andeq	r0, r0, sp, asr #32
    2e80:	206c9102 	rsbcs	r9, ip, r2, lsl #2
    2e84:	0000061d 	andeq	r0, r0, sp, lsl r6
    2e88:	ed2a2501 	cfstr32	mvfx2, [sl, #-4]!
    2e8c:	0200000a 	andeq	r0, r0, #10
    2e90:	7a206891 	bvc	81d0dc <__bss_end+0x8119c8>
    2e94:	01000017 	tsteq	r0, r7, lsl r0
    2e98:	004d3b25 	subeq	r3, sp, r5, lsr #22
    2e9c:	91020000 	mrsls	r0, (UNDEF: 2)
    2ea0:	15d71e64 	ldrbne	r1, [r7, #3684]	; 0xe64
    2ea4:	27010000 	strcs	r0, [r1, -r0]
    2ea8:	00004d0e 	andeq	r4, r0, lr, lsl #26
    2eac:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2eb0:	25040d00 	strcs	r0, [r4, #-3328]	; 0xfffff300
    2eb4:	03000000 	movweq	r0, #0
    2eb8:	00000ae7 	andeq	r0, r0, r7, ror #21
    2ebc:	0016c621 	andseq	ip, r6, r1, lsr #12
    2ec0:	0a190100 	beq	6432c8 <__bss_end+0x637bb4>
    2ec4:	00001908 	andeq	r1, r0, r8, lsl #18
    2ec8:	0000004d 	andeq	r0, r0, sp, asr #32
    2ecc:	00009a88 	andeq	r9, r0, r8, lsl #21
    2ed0:	00000044 	andeq	r0, r0, r4, asr #32
    2ed4:	0b3e9c01 	bleq	fa9ee0 <__bss_end+0xf9e7cc>
    2ed8:	f8200000 			; <UNDEFINED> instruction: 0xf8200000
    2edc:	01000018 	tsteq	r0, r8, lsl r0
    2ee0:	02101b19 	andseq	r1, r0, #25600	; 0x6400
    2ee4:	91020000 	mrsls	r0, (UNDEF: 2)
    2ee8:	18c6206c 	stmiane	r6, {r2, r3, r5, r6, sp}^
    2eec:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
    2ef0:	0001df35 	andeq	sp, r1, r5, lsr pc
    2ef4:	68910200 	ldmvs	r1, {r9}
    2ef8:	000e471e 	andeq	r4, lr, lr, lsl r7
    2efc:	0e1b0100 	mufeqe	f0, f3, f0
    2f00:	0000004d 	andeq	r0, r0, sp, asr #32
    2f04:	00749102 	rsbseq	r9, r4, r2, lsl #2
    2f08:	00162424 	andseq	r2, r6, r4, lsr #8
    2f0c:	06140100 	ldreq	r0, [r4], -r0, lsl #2
    2f10:	000015dd 	ldrdeq	r1, [r0], -sp
    2f14:	00009a6c 	andeq	r9, r0, ip, ror #20
    2f18:	0000001c 	andeq	r0, r0, ip, lsl r0
    2f1c:	bc239c01 	stclt	12, cr9, [r3], #-4
    2f20:	01000018 	tsteq	r0, r8, lsl r0
    2f24:	168d060e 	strne	r0, [sp], lr, lsl #12
    2f28:	9a400000 	bls	1002f30 <__bss_end+0xff781c>
    2f2c:	002c0000 	eoreq	r0, ip, r0
    2f30:	9c010000 	stcls	0, cr0, [r1], {-0}
    2f34:	00000b7e 	andeq	r0, r0, lr, ror fp
    2f38:	00161b20 	andseq	r1, r6, r0, lsr #22
    2f3c:	140e0100 	strne	r0, [lr], #-256	; 0xffffff00
    2f40:	00000038 	andeq	r0, r0, r8, lsr r0
    2f44:	00749102 	rsbseq	r9, r4, r2, lsl #2
    2f48:	00190125 	andseq	r0, r9, r5, lsr #2
    2f4c:	0a040100 	beq	103354 <__bss_end+0xf7c40>
    2f50:	000016af 	andeq	r1, r0, pc, lsr #13
    2f54:	0000004d 	andeq	r0, r0, sp, asr #32
    2f58:	00009a14 	andeq	r9, r0, r4, lsl sl
    2f5c:	0000002c 	andeq	r0, r0, ip, lsr #32
    2f60:	70229c01 	eorvc	r9, r2, r1, lsl #24
    2f64:	01006469 	tsteq	r0, r9, ror #8
    2f68:	004d0e06 	subeq	r0, sp, r6, lsl #28
    2f6c:	91020000 	mrsls	r0, (UNDEF: 2)
    2f70:	97000074 	smlsdxls	r0, r4, r0, r0
    2f74:	04000000 	streq	r0, [r0], #-0
    2f78:	000c9400 	andeq	r9, ip, r0, lsl #8
    2f7c:	7f010400 	svcvc	0x00010400
    2f80:	04000017 	streq	r0, [r0], #-23	; 0xffffffe9
    2f84:	00001982 	andeq	r1, r0, r2, lsl #19
    2f88:	00001924 	andeq	r1, r0, r4, lsr #18
    2f8c:	00009e70 	andeq	r9, r0, r0, ror lr
    2f90:	00000038 	andeq	r0, r0, r8, lsr r0
    2f94:	00001461 	andeq	r1, r0, r1, ror #8
    2f98:	aa080102 	bge	2033a8 <__bss_end+0x1f7c94>
    2f9c:	0200000d 	andeq	r0, r0, #13
    2fa0:	0e390502 	cdpeq	5, 3, cr0, cr9, cr2, {0}
    2fa4:	04030000 	streq	r0, [r3], #-0
    2fa8:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    2fac:	08010200 	stmdaeq	r1, {r9}
    2fb0:	00000da1 	andeq	r0, r0, r1, lsr #27
    2fb4:	1b070202 	blne	1c37c4 <__bss_end+0x1b80b0>
    2fb8:	0400000a 	streq	r0, [r0], #-10
    2fbc:	00000ed5 	ldrdeq	r0, [r0], -r5
    2fc0:	54070902 	strpl	r0, [r7], #-2306	; 0xfffff6fe
    2fc4:	02000000 	andeq	r0, r0, #0
    2fc8:	1d280704 	stcne	7, cr0, [r8, #-16]!
    2fcc:	7b050000 	blvc	142fd4 <__bss_end+0x1378c0>
    2fd0:	01000019 	tsteq	r0, r9, lsl r0
    2fd4:	19700707 	ldmdbne	r0!, {r0, r1, r2, r8, r9, sl}^
    2fd8:	00980000 	addseq	r0, r8, r0
    2fdc:	9e700000 	cdpls	0, 7, cr0, cr0, cr0, {0}
    2fe0:	00380000 	eorseq	r0, r8, r0
    2fe4:	9c010000 	stcls	0, cr0, [r1], {-0}
    2fe8:	00000098 	muleq	r0, r8, r0
    2fec:	00177a06 	andseq	r7, r7, r6, lsl #20
    2ff0:	17070100 	strne	r0, [r7, -r0, lsl #2]
    2ff4:	00000048 	andeq	r0, r0, r8, asr #32
    2ff8:	076c9102 	strbeq	r9, [ip, -r2, lsl #2]!
    2ffc:	00001965 	andeq	r1, r0, r5, ror #18
    3000:	480e0901 	stmdami	lr, {r0, r8, fp}
    3004:	02000000 	andeq	r0, r0, #0
    3008:	08007491 	stmdaeq	r0, {r0, r4, r7, sl, ip, sp, lr}
    300c:	05790004 	ldrbeq	r0, [r9, #-4]!
    3010:	00040000 	andeq	r0, r4, r0
    3014:	00000d14 	andeq	r0, r0, r4, lsl sp
    3018:	177f0104 	ldrbne	r0, [pc, -r4, lsl #2]!
    301c:	14040000 	strne	r0, [r4], #-0
    3020:	2400001a 	strcs	r0, [r0], #-26	; 0xffffffe6
    3024:	a8000019 	stmdage	r0, {r0, r3, r4}
    3028:	3800009e 	stmdacc	r0, {r1, r2, r3, r4, r7}
    302c:	5100000c 	tstpl	r0, ip
    3030:	02000015 	andeq	r0, r0, #21
    3034:	00000049 	andeq	r0, r0, r9, asr #32
    3038:	001ae403 	andseq	lr, sl, r3, lsl #8
    303c:	10070100 	andne	r0, r7, r0, lsl #2
    3040:	00000061 	andeq	r0, r0, r1, rrx
    3044:	32313011 	eorscc	r3, r1, #17
    3048:	36353433 			; <UNDEFINED> instruction: 0x36353433
    304c:	41393837 	teqmi	r9, r7, lsr r8
    3050:	45444342 	strbmi	r4, [r4, #-834]	; 0xfffffcbe
    3054:	04000046 	streq	r0, [r0], #-70	; 0xffffffba
    3058:	25010501 	strcs	r0, [r1, #-1281]	; 0xfffffaff
    305c:	05000000 	streq	r0, [r0, #-0]
    3060:	00000074 	andeq	r0, r0, r4, ror r0
    3064:	00000061 	andeq	r0, r0, r1, rrx
    3068:	00006606 	andeq	r6, r0, r6, lsl #12
    306c:	07001000 	streq	r1, [r0, -r0]
    3070:	00000051 	andeq	r0, r0, r1, asr r0
    3074:	28070408 	stmdacs	r7, {r3, sl}
    3078:	0800001d 	stmdaeq	r0, {r0, r2, r3, r4}
    307c:	0daa0801 	stceq	8, cr0, [sl, #4]!
    3080:	6d070000 	stcvs	0, cr0, [r7, #-0]
    3084:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    3088:	0000002a 	andeq	r0, r0, sl, lsr #32
    308c:	001b020a 	andseq	r0, fp, sl, lsl #4
    3090:	06fd0100 	ldrbteq	r0, [sp], r0, lsl #2
    3094:	000019dd 	ldrdeq	r1, [r0], -sp
    3098:	0000aa60 	andeq	sl, r0, r0, ror #20
    309c:	00000080 	andeq	r0, r0, r0, lsl #1
    30a0:	00fd9c01 	rscseq	r9, sp, r1, lsl #24
    30a4:	730b0000 	movwvc	r0, #45056	; 0xb000
    30a8:	01006372 	tsteq	r0, r2, ror r3
    30ac:	00fd19fd 	ldrshteq	r1, [sp], #157	; 0x9d
    30b0:	91020000 	mrsls	r0, (UNDEF: 2)
    30b4:	73640b64 	cmnvc	r4, #100, 22	; 0x19000
    30b8:	fd010074 	stc2	0, cr0, [r1, #-464]	; 0xfffffe30
    30bc:	00010424 	andeq	r0, r1, r4, lsr #8
    30c0:	60910200 	addsvs	r0, r1, r0, lsl #4
    30c4:	6d756e0b 	ldclvs	14, cr6, [r5, #-44]!	; 0xffffffd4
    30c8:	2dfd0100 	ldfcse	f0, [sp]
    30cc:	00000106 	andeq	r0, r0, r6, lsl #2
    30d0:	0c5c9102 	ldfeqp	f1, [ip], {2}
    30d4:	00001af5 	strdeq	r1, [r0], -r5
    30d8:	120eff01 	andne	pc, lr, #1, 30
    30dc:	02000001 	andeq	r0, r0, #1
    30e0:	dd0d7091 	stcle	0, cr7, [sp, #-580]	; 0xfffffdbc
    30e4:	0100001a 	tsteq	r0, sl, lsl r0
    30e8:	18080100 	stmdane	r8, {r8}
    30ec:	02000001 	andeq	r0, r0, #1
    30f0:	880e6c91 	stmdahi	lr, {r0, r4, r7, sl, fp, sp, lr}
    30f4:	480000aa 	stmdami	r0, {r1, r3, r5, r7}
    30f8:	0f000000 	svceq	0x00000000
    30fc:	02010069 	andeq	r0, r1, #105	; 0x69
    3100:	01060b01 	tsteq	r6, r1, lsl #22
    3104:	91020000 	mrsls	r0, (UNDEF: 2)
    3108:	10000074 	andne	r0, r0, r4, ror r0
    310c:	00010304 	andeq	r0, r1, r4, lsl #6
    3110:	04121100 	ldreq	r1, [r2], #-256	; 0xffffff00
    3114:	69050413 	stmdbvs	r5, {r0, r1, r4, sl}
    3118:	0700746e 	streq	r7, [r0, -lr, ror #8]
    311c:	00000106 	andeq	r0, r0, r6, lsl #2
    3120:	00740410 	rsbseq	r0, r4, r0, lsl r4
    3124:	04100000 	ldreq	r0, [r0], #-0
    3128:	0000006d 	andeq	r0, r0, sp, rrx
    312c:	001afc0a 	andseq	pc, sl, sl, lsl #24
    3130:	06f50100 	ldrbteq	r0, [r5], r0, lsl #2
    3134:	00001a8b 	andeq	r1, r0, fp, lsl #21
    3138:	0000a9f8 	strdeq	sl, [r0], -r8
    313c:	00000068 	andeq	r0, r0, r8, rrx
    3140:	017d9c01 	cmneq	sp, r1, lsl #24
    3144:	67140000 	ldrvs	r0, [r4, -r0]
    3148:	0100001b 	tsteq	r0, fp, lsl r0
    314c:	010412f5 	strdeq	r1, [r4, -r5]
    3150:	91020000 	mrsls	r0, (UNDEF: 2)
    3154:	12bc146c 	adcsne	r1, ip, #108, 8	; 0x6c000000
    3158:	f5010000 			; <UNDEFINED> instruction: 0xf5010000
    315c:	0001061e 	andeq	r0, r1, lr, lsl r6
    3160:	68910200 	ldmvs	r1, {r9}
    3164:	6d656d15 	stclvs	13, cr6, [r5, #-84]!	; 0xffffffac
    3168:	08f70100 	ldmeq	r7!, {r8}^
    316c:	00000118 	andeq	r0, r0, r8, lsl r1
    3170:	0e709102 	expeqs	f1, f2
    3174:	0000aa14 	andeq	sl, r0, r4, lsl sl
    3178:	0000003c 	andeq	r0, r0, ip, lsr r0
    317c:	01006915 	tsteq	r0, r5, lsl r9
    3180:	01060bf9 	strdeq	r0, [r6, -r9]
    3184:	91020000 	mrsls	r0, (UNDEF: 2)
    3188:	16000074 			; <UNDEFINED> instruction: 0x16000074
    318c:	00001a0d 	andeq	r1, r0, sp, lsl #20
    3190:	3605eb01 	strcc	lr, [r5], -r1, lsl #22
    3194:	0600001b 			; <UNDEFINED> instruction: 0x0600001b
    3198:	a4000001 	strge	r0, [r0], #-1
    319c:	540000a9 	strpl	r0, [r0], #-169	; 0xffffff57
    31a0:	01000000 	mrseq	r0, (UNDEF: 0)
    31a4:	0001b69c 	muleq	r1, ip, r6
    31a8:	00730b00 	rsbseq	r0, r3, r0, lsl #22
    31ac:	1218eb01 	andsne	lr, r8, #1024	; 0x400
    31b0:	02000001 	andeq	r0, r0, #1
    31b4:	69156c91 	ldmdbvs	r5, {r0, r4, r7, sl, fp, sp, lr}
    31b8:	06ed0100 	strbteq	r0, [sp], r0, lsl #2
    31bc:	00000106 	andeq	r0, r0, r6, lsl #2
    31c0:	00749102 	rsbseq	r9, r4, r2, lsl #2
    31c4:	001b0e16 	andseq	r0, fp, r6, lsl lr
    31c8:	05db0100 	ldrbeq	r0, [fp, #256]	; 0x100
    31cc:	00001b43 	andeq	r1, r0, r3, asr #22
    31d0:	00000106 	andeq	r0, r0, r6, lsl #2
    31d4:	0000a8f8 	strdeq	sl, [r0], -r8
    31d8:	000000ac 	andeq	r0, r0, ip, lsr #1
    31dc:	021c9c01 	andseq	r9, ip, #256	; 0x100
    31e0:	730b0000 	movwvc	r0, #45056	; 0xb000
    31e4:	db010031 	blle	432b0 <__bss_end+0x37b9c>
    31e8:	00011219 	andeq	r1, r1, r9, lsl r2
    31ec:	6c910200 	lfmvs	f0, 4, [r1], {0}
    31f0:	0032730b 	eorseq	r7, r2, fp, lsl #6
    31f4:	1229db01 	eorne	sp, r9, #1024	; 0x400
    31f8:	02000001 	andeq	r0, r0, #1
    31fc:	6e0b6891 	mcrvs	8, 0, r6, cr11, cr1, {4}
    3200:	01006d75 	tsteq	r0, r5, ror sp
    3204:	010631db 	ldrdeq	r3, [r6, -fp]
    3208:	91020000 	mrsls	r0, (UNDEF: 2)
    320c:	31751564 	cmncc	r5, r4, ror #10
    3210:	10dd0100 	sbcsne	r0, sp, r0, lsl #2
    3214:	0000021c 	andeq	r0, r0, ip, lsl r2
    3218:	15779102 	ldrbne	r9, [r7, #-258]!	; 0xfffffefe
    321c:	01003275 	tsteq	r0, r5, ror r2
    3220:	021c14dd 	andseq	r1, ip, #-587202560	; 0xdd000000
    3224:	91020000 	mrsls	r0, (UNDEF: 2)
    3228:	01080076 	tsteq	r8, r6, ror r0
    322c:	000da108 	andeq	sl, sp, r8, lsl #2
    3230:	1a841600 	bne	fe108a38 <__bss_end+0xfe0fd324>
    3234:	cd010000 	stcgt	0, cr0, [r1, #-0]
    3238:	001ac307 	andseq	ip, sl, r7, lsl #6
    323c:	00011800 	andeq	r1, r1, r0, lsl #16
    3240:	00a82400 	adceq	r2, r8, r0, lsl #8
    3244:	0000d400 	andeq	sp, r0, r0, lsl #8
    3248:	7a9c0100 	bvc	fe703650 <__bss_end+0xfe6f7f3c>
    324c:	14000002 	strne	r0, [r0], #-2
    3250:	00001a68 	andeq	r1, r0, r8, ror #20
    3254:	1814cd01 	ldmdane	r4, {r0, r8, sl, fp, lr, pc}
    3258:	02000001 	andeq	r0, r0, #1
    325c:	730b6c91 	movwvc	r6, #48273	; 0xbc91
    3260:	01006372 	tsteq	r0, r2, ror r3
    3264:	011226cd 	tsteq	r2, sp, asr #13
    3268:	91020000 	mrsls	r0, (UNDEF: 2)
    326c:	00691568 	rsbeq	r1, r9, r8, ror #10
    3270:	0609cf01 	streq	ip, [r9], -r1, lsl #30
    3274:	02000001 	andeq	r0, r0, #1
    3278:	6a157491 	bvs	5604c4 <__bss_end+0x554db0>
    327c:	0bcf0100 	bleq	ff3c3684 <__bss_end+0xff3b7f70>
    3280:	00000106 	andeq	r0, r0, r6, lsl #2
    3284:	00709102 	rsbseq	r9, r0, r2, lsl #2
    3288:	001a9f16 	andseq	r9, sl, r6, lsl pc
    328c:	07c10100 	strbeq	r0, [r1, r0, lsl #2]
    3290:	00001ab2 			; <UNDEFINED> instruction: 0x00001ab2
    3294:	00000118 	andeq	r0, r0, r8, lsl r1
    3298:	0000a764 	andeq	sl, r0, r4, ror #14
    329c:	000000c0 	andeq	r0, r0, r0, asr #1
    32a0:	02d39c01 	sbcseq	r9, r3, #256	; 0x100
    32a4:	68140000 	ldmdavs	r4, {}	; <UNPREDICTABLE>
    32a8:	0100001a 	tsteq	r0, sl, lsl r0
    32ac:	011815c1 	tsteq	r8, r1, asr #11
    32b0:	91020000 	mrsls	r0, (UNDEF: 2)
    32b4:	72730b6c 	rsbsvc	r0, r3, #108, 22	; 0x1b000
    32b8:	c1010063 	tstgt	r1, r3, rrx
    32bc:	00011227 	andeq	r1, r1, r7, lsr #4
    32c0:	68910200 	ldmvs	r1, {r9}
    32c4:	6d756e0b 	ldclvs	14, cr6, [r5, #-44]!	; 0xffffffd4
    32c8:	30c10100 	sbccc	r0, r1, r0, lsl #2
    32cc:	00000106 	andeq	r0, r0, r6, lsl #2
    32d0:	15649102 	strbne	r9, [r4, #-258]!	; 0xfffffefe
    32d4:	c3010069 	movwgt	r0, #4201	; 0x1069
    32d8:	00010606 	andeq	r0, r1, r6, lsl #12
    32dc:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    32e0:	1af01700 	bne	ffc08ee8 <__bss_end+0xffbfd7d4>
    32e4:	8b010000 	blhi	432ec <__bss_end+0x37bd8>
    32e8:	001aa706 	andseq	sl, sl, r6, lsl #14
    32ec:	00a52c00 	adceq	r2, r5, r0, lsl #24
    32f0:	00023800 	andeq	r3, r2, r0, lsl #16
    32f4:	6f9c0100 	svcvs	0x009c0100
    32f8:	14000003 	strne	r0, [r0], #-3
    32fc:	0000061d 	andeq	r0, r0, sp, lsl r6
    3300:	18118b01 	ldmdane	r1, {r0, r8, r9, fp, pc}
    3304:	02000001 	andeq	r0, r0, #1
    3308:	28145c91 	ldmdacs	r4, {r0, r4, r7, sl, fp, ip, lr}
    330c:	01000013 	tsteq	r0, r3, lsl r0
    3310:	036f1f8b 	cmneq	pc, #556	; 0x22c
    3314:	91020000 	mrsls	r0, (UNDEF: 2)
    3318:	19ff0c58 	ldmibne	pc!, {r3, r4, r6, sl, fp}^	; <UNPREDICTABLE>
    331c:	94010000 	strls	r0, [r1], #-0
    3320:	00010609 	andeq	r0, r1, r9, lsl #12
    3324:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    3328:	001b6e0c 	andseq	r6, fp, ip, lsl #28
    332c:	09950100 	ldmibeq	r5, {r8}
    3330:	00000106 	andeq	r0, r0, r6, lsl #2
    3334:	0c709102 	ldfeqp	f1, [r0], #-8
    3338:	00001b16 	andeq	r1, r0, r6, lsl fp
    333c:	0d0f9601 	stceq	6, cr9, [pc, #-4]	; 3340 <_start-0x4cc0>
    3340:	02000001 	andeq	r0, r0, #1
    3344:	d4186c91 	ldrle	r6, [r8], #-3217	; 0xfffff36f
    3348:	700000a5 	andvc	r0, r0, r5, lsr #1
    334c:	55000000 	strpl	r0, [r0, #-0]
    3350:	0c000003 	stceq	0, cr0, [r0], {3}
    3354:	00001ad2 	ldrdeq	r1, [r0], -r2
    3358:	060da601 	streq	sl, [sp], -r1, lsl #12
    335c:	02000001 	andeq	r0, r0, #1
    3360:	0e006891 	mcreq	8, 0, r6, cr0, cr1, {4}
    3364:	0000a6d0 	ldrdeq	sl, [r0], -r0
    3368:	00000070 	andeq	r0, r0, r0, ror r0
    336c:	001ad20c 	andseq	sp, sl, ip, lsl #4
    3370:	0db90100 	ldfeqs	f0, [r9]
    3374:	00000106 	andeq	r0, r0, r6, lsl #2
    3378:	00649102 	rsbeq	r9, r4, r2, lsl #2
    337c:	04040800 	streq	r0, [r4], #-2048	; 0xfffff800
    3380:	0000159a 	muleq	r0, sl, r5
    3384:	001ad816 	andseq	sp, sl, r6, lsl r8
    3388:	075e0100 	ldrbeq	r0, [lr, -r0, lsl #2]
    338c:	00001b1c 	andeq	r1, r0, ip, lsl fp
    3390:	0000036f 	andeq	r0, r0, pc, ror #6
    3394:	0000a274 	andeq	sl, r0, r4, ror r2
    3398:	000002b8 			; <UNDEFINED> instruction: 0x000002b8
    339c:	03ef9c01 	mvneq	r9, #256	; 0x100
    33a0:	730b0000 	movwvc	r0, #45056	; 0xb000
    33a4:	185e0100 	ldmdane	lr, {r8}^
    33a8:	00000112 	andeq	r0, r0, r2, lsl r1
    33ac:	155c9102 	ldrbne	r9, [ip, #-258]	; 0xfffffefe
    33b0:	64010061 	strvs	r0, [r1], #-97	; 0xffffff9f
    33b4:	00036f09 	andeq	r6, r3, r9, lsl #30
    33b8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    33bc:	01006515 	tsteq	r0, r5, lsl r5
    33c0:	01060765 	tsteq	r6, r5, ror #14
    33c4:	91020000 	mrsls	r0, (UNDEF: 2)
    33c8:	00631570 	rsbeq	r1, r3, r0, ror r5
    33cc:	06076601 	streq	r6, [r7], -r1, lsl #12
    33d0:	02000001 	andeq	r0, r0, #1
    33d4:	bc0e6c91 	stclt	12, cr6, [lr], {145}	; 0x91
    33d8:	e00000a3 	and	r0, r0, r3, lsr #1
    33dc:	0c000000 	stceq	0, cr0, [r0], {-0}
    33e0:	00001a7a 	andeq	r1, r0, sl, ror sl
    33e4:	06097101 	streq	r7, [r9], -r1, lsl #2
    33e8:	02000001 	andeq	r0, r0, #1
    33ec:	69156891 	ldmdbvs	r5, {r0, r4, r7, fp, sp, lr}
    33f0:	09720100 	ldmdbeq	r2!, {r8}^
    33f4:	00000106 	andeq	r0, r0, r6, lsl #2
    33f8:	00649102 	rsbeq	r9, r4, r2, lsl #2
    33fc:	19ed1900 	stmibne	sp!, {r8, fp, ip}^
    3400:	4d010000 	stcmi	0, cr0, [r1, #-0]
    3404:	001a6d06 	andseq	r6, sl, r6, lsl #26
    3408:	00046700 	andeq	r6, r4, r0, lsl #14
    340c:	00a19800 	adceq	r9, r1, r0, lsl #16
    3410:	0000dc00 	andeq	sp, r0, r0, lsl #24
    3414:	679c0100 	ldrvs	r0, [ip, r0, lsl #2]
    3418:	0b000004 	bleq	3430 <_start-0x4bd0>
    341c:	4d010073 	stcmi	0, cr0, [r1, #-460]	; 0xfffffe34
    3420:	00011218 	andeq	r1, r1, r8, lsl r2
    3424:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    3428:	001a9714 	andseq	r9, sl, r4, lsl r7
    342c:	204d0100 	subcs	r0, sp, r0, lsl #2
    3430:	00000467 	andeq	r0, r0, r7, ror #8
    3434:	0c639102 	stfeqp	f1, [r3], #-8
    3438:	000012bc 			; <UNDEFINED> instruction: 0x000012bc
    343c:	06074f01 	streq	r4, [r7], -r1, lsl #30
    3440:	02000001 	andeq	r0, r0, #1
    3444:	d00e7091 	mulle	lr, r1, r0
    3448:	940000a1 	strls	r0, [r0], #-161	; 0xffffff5f
    344c:	15000000 	strne	r0, [r0, #-0]
    3450:	54010069 	strpl	r0, [r1], #-105	; 0xffffff97
    3454:	0001060b 	andeq	r0, r1, fp, lsl #12
    3458:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    345c:	00a2000e 	adceq	r0, r2, lr
    3460:	00005400 	andeq	r5, r0, r0, lsl #8
    3464:	00631500 	rsbeq	r1, r3, r0, lsl #10
    3468:	6d085501 	cfstr32vs	mvfx5, [r8, #-4]
    346c:	02000000 	andeq	r0, r0, #0
    3470:	00006f91 	muleq	r0, r1, pc	; <UNPREDICTABLE>
    3474:	02010800 	andeq	r0, r1, #0, 16
    3478:	00000ae2 	andeq	r0, r0, r2, ror #21
    347c:	0019d316 	andseq	sp, r9, r6, lsl r3
    3480:	053c0100 	ldreq	r0, [ip, #-256]!	; 0xffffff00
    3484:	00001b27 	andeq	r1, r0, r7, lsr #22
    3488:	00000106 	andeq	r0, r0, r6, lsl #2
    348c:	0000a0d4 	ldrdeq	sl, [r0], -r4
    3490:	000000c4 	andeq	r0, r0, r4, asr #1
    3494:	04ba9c01 	ldrteq	r9, [sl], #3073	; 0xc01
    3498:	760b0000 	strvc	r0, [fp], -r0
    349c:	01006c61 	tsteq	r0, r1, ror #24
    34a0:	04ba163c 	ldrteq	r1, [sl], #1596	; 0x63c
    34a4:	91020000 	mrsls	r0, (UNDEF: 2)
    34a8:	19ff0c6c 	ldmibne	pc!, {r2, r3, r5, r6, sl, fp}^	; <UNPREDICTABLE>
    34ac:	3d010000 	stccc	0, cr0, [r1, #-0]
    34b0:	00010609 	andeq	r0, r1, r9, lsl #12
    34b4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    34b8:	0013280c 	andseq	r2, r3, ip, lsl #16
    34bc:	0b3e0100 	bleq	f838c4 <__bss_end+0xf781b0>
    34c0:	0000036f 	andeq	r0, r0, pc, ror #6
    34c4:	00709102 	rsbseq	r9, r0, r2, lsl #2
    34c8:	036f0410 	cmneq	pc, #16, 8	; 0x10000000
    34cc:	08190000 	ldmdaeq	r9, {}	; <UNPREDICTABLE>
    34d0:	0100001a 	tsteq	r0, sl, lsl r0
    34d4:	1b550526 	blne	1544974 <__bss_end+0x1539260>
    34d8:	01060000 	mrseq	r0, (UNDEF: 6)
    34dc:	a01c0000 	andsge	r0, ip, r0
    34e0:	00b80000 	adcseq	r0, r8, r0
    34e4:	9c010000 	stcls	0, cr0, [r1], {-0}
    34e8:	000004fd 	strdeq	r0, [r0], -sp
    34ec:	00071a14 	andeq	r1, r7, r4, lsl sl
    34f0:	16260100 	strtne	r0, [r6], -r0, lsl #2
    34f4:	00000112 	andeq	r0, r0, r2, lsl r1
    34f8:	0c6c9102 	stfeqp	f1, [ip], #-8
    34fc:	00001b60 	andeq	r1, r0, r0, ror #22
    3500:	06062801 	streq	r2, [r6], -r1, lsl #16
    3504:	02000001 	andeq	r0, r0, #1
    3508:	1a007491 	bne	20754 <__bss_end+0x15040>
    350c:	00001a7f 	andeq	r1, r0, pc, ror sl
    3510:	f3060a01 	vpmax.u8	d0, d6, d1
    3514:	a8000019 	stmdage	r0, {r0, r3, r4}
    3518:	7400009e 	strvc	r0, [r0], #-158	; 0xffffff62
    351c:	01000001 	tsteq	r0, r1
    3520:	071a149c 			; <UNDEFINED> instruction: 0x071a149c
    3524:	0a010000 	beq	4352c <__bss_end+0x37e18>
    3528:	00006618 	andeq	r6, r0, r8, lsl r6
    352c:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    3530:	001b6014 	andseq	r6, fp, r4, lsl r0
    3534:	250a0100 	strcs	r0, [sl, #-256]	; 0xffffff00
    3538:	00000118 	andeq	r0, r0, r8, lsl r1
    353c:	14609102 	strbtne	r9, [r0], #-258	; 0xfffffefe
    3540:	00001b09 	andeq	r1, r0, r9, lsl #22
    3544:	663a0a01 	ldrtvs	r0, [sl], -r1, lsl #20
    3548:	02000000 	andeq	r0, r0, #0
    354c:	69155c91 	ldmdbvs	r5, {r0, r4, r7, sl, fp, ip, lr}
    3550:	060c0100 	streq	r0, [ip], -r0, lsl #2
    3554:	00000106 	andeq	r0, r0, r6, lsl #2
    3558:	0e749102 	expeqs	f1, f2
    355c:	00009f74 	andeq	r9, r0, r4, ror pc
    3560:	00000098 	muleq	r0, r8, r0
    3564:	01006a15 	tsteq	r0, r5, lsl sl
    3568:	01060b1e 	tsteq	r6, lr, lsl fp
    356c:	91020000 	mrsls	r0, (UNDEF: 2)
    3570:	9f9c0e70 	svcls	0x009c0e70
    3574:	00600000 	rsbeq	r0, r0, r0
    3578:	63150000 	tstvs	r5, #0
    357c:	08200100 	stmdaeq	r0!, {r8}
    3580:	0000006d 	andeq	r0, r0, sp, rrx
    3584:	006f9102 	rsbeq	r9, pc, r2, lsl #2
    3588:	a9000000 	stmdbge	r0, {}	; <UNPREDICTABLE>
    358c:	04000003 	streq	r0, [r0], #-3
    3590:	000ea200 	andeq	sl, lr, r0, lsl #4
    3594:	7f010400 	svcvc	0x00010400
    3598:	04000017 	streq	r0, [r0], #-23	; 0xffffffe9
    359c:	00001b75 	andeq	r1, r0, r5, ror fp
    35a0:	00001924 	andeq	r1, r0, r4, lsr #18
    35a4:	0000aae0 	andeq	sl, r0, r0, ror #21
    35a8:	000001c8 	andeq	r0, r0, r8, asr #3
    35ac:	00001a8c 	andeq	r1, r0, ip, lsl #21
    35b0:	aa080102 	bge	2039c0 <__bss_end+0x1f82ac>
    35b4:	0200000d 	andeq	r0, r0, #13
    35b8:	0e390502 	cdpeq	5, 3, cr0, cr9, cr2, {0}
    35bc:	04030000 	streq	r0, [r3], #-0
    35c0:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    35c4:	08010200 	stmdaeq	r1, {r9}
    35c8:	00000da1 	andeq	r0, r0, r1, lsr #27
    35cc:	1b070202 	blne	1c3ddc <__bss_end+0x1b86c8>
    35d0:	0400000a 	streq	r0, [r0], #-10
    35d4:	00000ed5 	ldrdeq	r0, [r0], -r5
    35d8:	59070908 	stmdbpl	r7, {r3, r8, fp}
    35dc:	05000000 	streq	r0, [r0, #-0]
    35e0:	00000048 	andeq	r0, r0, r8, asr #32
    35e4:	28070402 	stmdacs	r7, {r1, sl}
    35e8:	0600001d 			; <UNDEFINED> instruction: 0x0600001d
    35ec:	00001236 	andeq	r1, r0, r6, lsr r2
    35f0:	07070288 	streq	r0, [r7, -r8, lsl #5]
    35f4:	0000016b 	andeq	r0, r0, fp, ror #2
    35f8:	00061d07 	andeq	r1, r6, r7, lsl #26
    35fc:	0e0b0200 	cdpeq	2, 0, cr0, cr11, cr0, {0}
    3600:	0000016b 	andeq	r0, r0, fp, ror #2
    3604:	0fc00700 	svceq	0x00c00700
    3608:	0e020000 	cdpeq	0, 0, cr0, cr2, cr0, {0}
    360c:	00004812 	andeq	r4, r0, r2, lsl r8
    3610:	19078000 	stmdbne	r7, {pc}
    3614:	02000004 	andeq	r0, r0, #4
    3618:	0048120f 	subeq	r1, r8, pc, lsl #4
    361c:	08840000 	stmeq	r4, {}	; <UNPREDICTABLE>
    3620:	00001236 	andeq	r1, r0, r6, lsr r2
    3624:	fe091302 	cdp2	3, 0, cr1, cr9, cr2, {0}
    3628:	7b00000b 	blvc	365c <_start-0x49a4>
    362c:	01000001 	tsteq	r0, r1
    3630:	000000ad 	andeq	r0, r0, sp, lsr #1
    3634:	000000b3 	strheq	r0, [r0], -r3
    3638:	00017b09 	andeq	r7, r1, r9, lsl #22
    363c:	1b080000 	blne	203644 <__bss_end+0x1f7f30>
    3640:	02000012 	andeq	r0, r0, #18
    3644:	06fd1216 	usateq	r1, #29, r6, lsl #4
    3648:	00480000 	subeq	r0, r8, r0
    364c:	cc010000 	stcgt	0, cr0, [r1], {-0}
    3650:	d7000000 	strle	r0, [r0, -r0]
    3654:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    3658:	0000017b 	andeq	r0, r0, fp, ror r1
    365c:	0001810a 	andeq	r8, r1, sl, lsl #2
    3660:	1b080000 	blne	203668 <__bss_end+0x1f7f54>
    3664:	02000012 	andeq	r0, r0, #18
    3668:	05701219 	ldrbeq	r1, [r0, #-537]!	; 0xfffffde7
    366c:	00480000 	subeq	r0, r8, r0
    3670:	f0010000 			; <UNDEFINED> instruction: 0xf0010000
    3674:	00000000 	andeq	r0, r0, r0
    3678:	09000001 	stmdbeq	r0, {r0}
    367c:	0000017b 	andeq	r0, r0, fp, ror r1
    3680:	0001810a 	andeq	r8, r1, sl, lsl #2
    3684:	00480a00 	subeq	r0, r8, r0, lsl #20
    3688:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    368c:	00000e9e 	muleq	r0, lr, lr
    3690:	5a121c02 	bpl	48a6a0 <__bss_end+0x47ef8c>
    3694:	4800000b 	stmdami	r0, {r0, r1, r3}
    3698:	01000000 	mrseq	r0, (UNDEF: 0)
    369c:	00000119 	andeq	r0, r0, r9, lsl r1
    36a0:	00000129 	andeq	r0, r0, r9, lsr #2
    36a4:	00017b09 	andeq	r7, r1, r9, lsl #22
    36a8:	00250a00 	eoreq	r0, r5, r0, lsl #20
    36ac:	810a0000 	mrshi	r0, (UNDEF: 10)
    36b0:	00000001 	andeq	r0, r0, r1
    36b4:	000ba30b 	andeq	sl, fp, fp, lsl #6
    36b8:	0e1f0200 	cdpeq	2, 1, cr0, cr15, cr0, {0}
    36bc:	00001029 	andeq	r1, r0, r9, lsr #32
    36c0:	00013e01 	andeq	r3, r1, r1, lsl #28
    36c4:	00014e00 	andeq	r4, r1, r0, lsl #28
    36c8:	017b0900 	cmneq	fp, r0, lsl #18
    36cc:	810a0000 	mrshi	r0, (UNDEF: 10)
    36d0:	0a000001 	beq	36dc <_start-0x4924>
    36d4:	00000048 	andeq	r0, r0, r8, asr #32
    36d8:	0ba30c00 	bleq	fe8c66e0 <__bss_end+0xfe8bafcc>
    36dc:	22020000 	andcs	r0, r2, #0
    36e0:	000e4c0e 	andeq	r4, lr, lr, lsl #24
    36e4:	015f0100 	cmpeq	pc, r0, lsl #2
    36e8:	7b090000 	blvc	2436f0 <__bss_end+0x237fdc>
    36ec:	0a000001 	beq	36f8 <_start-0x4908>
    36f0:	00000025 	andeq	r0, r0, r5, lsr #32
    36f4:	250d0000 	strcs	r0, [sp, #-0]
    36f8:	7b000000 	blvc	3700 <_start-0x4900>
    36fc:	0e000001 	cdpeq	0, 0, cr0, cr0, cr1, {0}
    3700:	00000059 	andeq	r0, r0, r9, asr r0
    3704:	040f007f 	streq	r0, [pc], #-127	; 370c <_start-0x48f4>
    3708:	00000060 	andeq	r0, r0, r0, rrx
    370c:	0025040f 	eoreq	r0, r5, pc, lsl #8
    3710:	9b060000 	blls	183718 <__bss_end+0x178004>
    3714:	8800000a 	stmdahi	r0, {r1, r3}
    3718:	eb070803 	bl	1c572c <__bss_end+0x1ba018>
    371c:	07000001 	streq	r0, [r0, -r1]
    3720:	000003a2 	andeq	r0, r0, r2, lsr #7
    3724:	60190c03 	andsvs	r0, r9, r3, lsl #24
    3728:	00000000 	andeq	r0, r0, r0
    372c:	000a9b08 	andeq	r9, sl, r8, lsl #22
    3730:	09100300 	ldmdbeq	r0, {r8, r9}
    3734:	00000535 	andeq	r0, r0, r5, lsr r5
    3738:	000001eb 	andeq	r0, r0, fp, ror #3
    373c:	0001ba01 	andeq	fp, r1, r1, lsl #20
    3740:	0001c000 	andeq	ip, r1, r0
    3744:	01eb0900 	mvneq	r0, r0, lsl #18
    3748:	10000000 	andne	r0, r0, r0
    374c:	0000052b 	andeq	r0, r0, fp, lsr #10
    3750:	f4121303 			; <UNDEFINED> instruction: 0xf4121303
    3754:	48000011 	stmdami	r0, {r0, r4}
    3758:	01000000 	mrseq	r0, (UNDEF: 0)
    375c:	000001d5 	ldrdeq	r0, [r0], -r5
    3760:	0001eb09 	andeq	lr, r1, r9, lsl #22
    3764:	01810a00 	orreq	r0, r1, r0, lsl #20
    3768:	480a0000 	stmdami	sl, {}	; <UNPREDICTABLE>
    376c:	0a000000 	beq	3774 <_start-0x488c>
    3770:	000001f6 	strdeq	r0, [r0], -r6
    3774:	040f0000 	streq	r0, [pc], #-0	; 377c <_start-0x4884>
    3778:	00000187 	andeq	r0, r0, r7, lsl #3
    377c:	0001eb05 	andeq	lr, r1, r5, lsl #22
    3780:	02010200 	andeq	r0, r1, #0, 4
    3784:	00000ae2 	andeq	r0, r0, r2, ror #21
    3788:	000c2511 	andeq	r2, ip, r1, lsl r5
    378c:	14050400 	strne	r0, [r5], #-1024	; 0xfffffc00
    3790:	00000054 	andeq	r0, r0, r4, asr r0
    3794:	b6840305 	strlt	r0, [r4], r5, lsl #6
    3798:	7c110000 	ldcvc	0, cr0, [r1], {-0}
    379c:	0400000c 	streq	r0, [r0], #-12
    37a0:	00541406 	subseq	r1, r4, r6, lsl #8
    37a4:	03050000 	movweq	r0, #20480	; 0x5000
    37a8:	0000b688 	andeq	fp, r0, r8, lsl #13
    37ac:	000be111 	andeq	lr, fp, r1, lsl r1
    37b0:	1a070500 	bne	1c4bb8 <__bss_end+0x1b94a4>
    37b4:	00000054 	andeq	r0, r0, r4, asr r0
    37b8:	b68c0305 	strlt	r0, [ip], r5, lsl #6
    37bc:	eb110000 	bl	4437c4 <__bss_end+0x4380b0>
    37c0:	05000006 	streq	r0, [r0, #-6]
    37c4:	00541a09 	subseq	r1, r4, r9, lsl #20
    37c8:	03050000 	movweq	r0, #20480	; 0x5000
    37cc:	0000b690 	muleq	r0, r0, r6
    37d0:	000d8111 	andeq	r8, sp, r1, lsl r1
    37d4:	1a0b0500 	bne	2c4bdc <__bss_end+0x2b94c8>
    37d8:	00000054 	andeq	r0, r0, r4, asr r0
    37dc:	b6940305 	ldrlt	r0, [r4], r5, lsl #6
    37e0:	ea110000 	b	4437e8 <__bss_end+0x4380d4>
    37e4:	05000009 	streq	r0, [r0, #-9]
    37e8:	00541a0d 	subseq	r1, r4, sp, lsl #20
    37ec:	03050000 	movweq	r0, #20480	; 0x5000
    37f0:	0000b698 	muleq	r0, r8, r6
    37f4:	00083e11 	andeq	r3, r8, r1, lsl lr
    37f8:	1a0f0500 	bne	3c4c00 <__bss_end+0x3b94ec>
    37fc:	00000054 	andeq	r0, r0, r4, asr r0
    3800:	b69c0305 	ldrlt	r0, [ip], r5, lsl #6
    3804:	1e110000 	cdpne	0, 1, cr0, cr1, cr0, {0}
    3808:	06000009 	streq	r0, [r0], -r9
    380c:	00541404 	subseq	r1, r4, r4, lsl #8
    3810:	03050000 	movweq	r0, #20480	; 0x5000
    3814:	0000b6a0 	andeq	fp, r0, r0, lsr #13
    3818:	0003bd11 	andeq	fp, r3, r1, lsl sp
    381c:	14070600 	strne	r0, [r7], #-1536	; 0xfffffa00
    3820:	00000054 	andeq	r0, r0, r4, asr r0
    3824:	b6a40305 	strtlt	r0, [r4], r5, lsl #6
    3828:	33110000 	tstcc	r1, #0
    382c:	06000007 	streq	r0, [r0], -r7
    3830:	0054140a 	subseq	r1, r4, sl, lsl #8
    3834:	03050000 	movweq	r0, #20480	; 0x5000
    3838:	0000b6a8 	andeq	fp, r0, r8, lsr #13
    383c:	23070402 	movwcs	r0, #29698	; 0x7402
    3840:	1100001d 	tstne	r0, sp, lsl r0
    3844:	000011cf 	andeq	r1, r0, pc, asr #3
    3848:	54140a07 	ldrpl	r0, [r4], #-2567	; 0xfffff5f9
    384c:	05000000 	streq	r0, [r0, #-0]
    3850:	00b6ac03 	adcseq	sl, r6, r3, lsl #24
    3854:	01c01200 	biceq	r1, r0, r0, lsl #4
    3858:	09010000 	stmdbeq	r1, {}	; <UNPREDICTABLE>
    385c:	0002e40a 	andeq	lr, r2, sl, lsl #8
    3860:	00ab0c00 	adceq	r0, fp, r0, lsl #24
    3864:	00019c00 	andeq	r9, r1, r0, lsl #24
    3868:	719c0100 	orrsvc	r0, ip, r0, lsl #2
    386c:	13000003 	movwne	r0, #3
    3870:	0000131a 	andeq	r1, r0, sl, lsl r3
    3874:	000001f1 	strdeq	r0, [r0], -r1
    3878:	7ee49103 	urdvcs	f1, f3
    387c:	001bea14 	andseq	lr, fp, r4, lsl sl
    3880:	27090100 	strcs	r0, [r9, -r0, lsl #2]
    3884:	00000181 	andeq	r0, r0, r1, lsl #3
    3888:	7ee09103 	urdvcs	f1, f3
    388c:	000e4714 	andeq	r4, lr, r4, lsl r7
    3890:	3e090100 	adfcce	f0, f1, f0
    3894:	00000048 	andeq	r0, r0, r8, asr #32
    3898:	7edc9103 	atnvce	f1, f3
    389c:	001bf714 	andseq	pc, fp, r4, lsl r7	; <UNPREDICTABLE>
    38a0:	49090100 	stmdbmi	r9, {r8}
    38a4:	000001f6 	strdeq	r0, [r0], -r6
    38a8:	7edb9103 	atnvce	f1, f3
    38ac:	001c0015 	andseq	r0, ip, r5, lsl r0
    38b0:	0a0a0100 	beq	283cb8 <__bss_end+0x2785a4>
    38b4:	0000016b 	andeq	r0, r0, fp, ror #2
    38b8:	7eec9103 	urdvce	f1, f3
    38bc:	001be015 	andseq	lr, fp, r5, lsl r0
    38c0:	0b0c0100 	bleq	303cc8 <__bss_end+0x2f85b4>
    38c4:	00000048 	andeq	r0, r0, r8, asr #32
    38c8:	16749102 	ldrbtne	r9, [r4], -r2, lsl #2
    38cc:	0000ab40 	andeq	sl, r0, r0, asr #22
    38d0:	00000138 	andeq	r0, r0, r8, lsr r1
    38d4:	6e656c17 	mcrvs	12, 3, r6, cr5, cr7, {0}
    38d8:	0c140100 	ldfeqs	f0, [r4], {-0}
    38dc:	00000048 	andeq	r0, r0, r8, asr #32
    38e0:	166c9102 	strbtne	r9, [ip], -r2, lsl #2
    38e4:	0000ac04 	andeq	sl, r0, r4, lsl #24
    38e8:	00000074 	andeq	r0, r0, r4, ror r0
    38ec:	01006917 	tsteq	r0, r7, lsl r9
    38f0:	00330d2e 	eorseq	r0, r3, lr, lsr #26
    38f4:	91020000 	mrsls	r0, (UNDEF: 2)
    38f8:	00000070 	andeq	r0, r0, r0, ror r0
    38fc:	0001a118 	andeq	sl, r1, r8, lsl r1
    3900:	01050100 	mrseq	r0, (UNDEF: 21)
    3904:	00000382 	andeq	r0, r0, r2, lsl #7
    3908:	00038c00 	andeq	r8, r3, r0, lsl #24
    390c:	131a1900 	tstne	sl, #0, 18
    3910:	01f10000 	mvnseq	r0, r0
    3914:	1a000000 	bne	391c <_start-0x46e4>
    3918:	00000371 	andeq	r0, r0, r1, ror r3
    391c:	00001bcc 	andeq	r1, r0, ip, asr #23
    3920:	000003a3 	andeq	r0, r0, r3, lsr #7
    3924:	0000aae0 	andeq	sl, r0, r0, ror #21
    3928:	0000002c 	andeq	r0, r0, ip, lsr #32
    392c:	821b9c01 	andshi	r9, fp, #256	; 0x100
    3930:	02000003 	andeq	r0, r0, #3
    3934:	00007491 	muleq	r0, r1, r4
    3938:	00000858 	andeq	r0, r0, r8, asr r8
    393c:	10440004 	subne	r0, r4, r4
    3940:	01040000 	mrseq	r0, (UNDEF: 4)
    3944:	0000177f 	andeq	r1, r0, pc, ror r7
    3948:	001c0b04 	andseq	r0, ip, r4, lsl #22
    394c:	00192400 	andseq	r2, r9, r0, lsl #8
    3950:	00aca800 	adceq	sl, ip, r0, lsl #16
    3954:	00013400 	andeq	r3, r1, r0, lsl #8
    3958:	001d6c00 	andseq	r6, sp, r0, lsl #24
    395c:	08010200 	stmdaeq	r1, {r9}
    3960:	00000daa 	andeq	r0, r0, sl, lsr #27
    3964:	39050202 	stmdbcc	r5, {r1, r9}
    3968:	0300000e 	movweq	r0, #14
    396c:	00000ed6 	ldrdeq	r0, [r0], -r6
    3970:	3f070502 	svccc	0x00070502
    3974:	04000000 	streq	r0, [r0], #-0
    3978:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    397c:	01020074 	tsteq	r2, r4, ror r0
    3980:	000da108 	andeq	sl, sp, r8, lsl #2
    3984:	07020200 	streq	r0, [r2, -r0, lsl #4]
    3988:	00000a1b 	andeq	r0, r0, fp, lsl sl
    398c:	000ed503 	andeq	sp, lr, r3, lsl #10
    3990:	07090200 	streq	r0, [r9, -r0, lsl #4]
    3994:	00000065 	andeq	r0, r0, r5, rrx
    3998:	00005405 	andeq	r5, r0, r5, lsl #8
    399c:	07040200 	streq	r0, [r4, -r0, lsl #4]
    39a0:	00001d28 	andeq	r1, r0, r8, lsr #26
    39a4:	000a2e06 	andeq	r2, sl, r6, lsl #28
    39a8:	07030400 	streq	r0, [r3, -r0, lsl #8]
    39ac:	0000f507 	andeq	pc, r0, r7, lsl #10
    39b0:	0e430700 	cdpeq	7, 4, cr0, cr3, cr0, {0}
    39b4:	0a030000 	beq	c39bc <__bss_end+0xb82a8>
    39b8:	0000540e 	andeq	r5, r0, lr, lsl #8
    39bc:	91080000 	mrsls	r0, (UNDEF: 8)
    39c0:	03000011 	movweq	r0, #17
    39c4:	0dc3090c 	vstreq.16	s1, [r3, #24]	; <UNPREDICTABLE>
    39c8:	003f0000 	eorseq	r0, pc, r0
    39cc:	9f010000 	svcls	0x00010000
    39d0:	af000000 	svcge	0x00000000
    39d4:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    39d8:	000000f5 	strdeq	r0, [r0], -r5
    39dc:	0000330a 	andeq	r3, r0, sl, lsl #6
    39e0:	00330a00 	eorseq	r0, r3, r0, lsl #20
    39e4:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    39e8:	000006af 	andeq	r0, r0, pc, lsr #13
    39ec:	510b0d03 	tstpl	fp, r3, lsl #26
    39f0:	00000005 	andeq	r0, r0, r5
    39f4:	01000001 	tsteq	r0, r1
    39f8:	000000c8 	andeq	r0, r0, r8, asr #1
    39fc:	000000d8 	ldrdeq	r0, [r0], -r8
    3a00:	0000f509 	andeq	pc, r0, r9, lsl #10
    3a04:	00330a00 	eorseq	r0, r3, r0, lsl #20
    3a08:	330a0000 	movwcc	r0, #40960	; 0xa000
    3a0c:	00000000 	andeq	r0, r0, r0
    3a10:	0004ef0b 	andeq	lr, r4, fp, lsl #30
    3a14:	0a0e0300 	beq	38461c <__bss_end+0x378f08>
    3a18:	000012d3 	ldrdeq	r1, [r0], -r3
    3a1c:	0000e901 	andeq	lr, r0, r1, lsl #18
    3a20:	00f50900 	rscseq	r0, r5, r0, lsl #18
    3a24:	540a0000 	strpl	r0, [sl], #-0
    3a28:	00000000 	andeq	r0, r0, r0
    3a2c:	6c040c00 	stcvs	12, cr0, [r4], {-0}
    3a30:	05000000 	streq	r0, [r0, #-0]
    3a34:	000000f5 	strdeq	r0, [r0], -r5
    3a38:	9a040402 	bls	104a48 <__bss_end+0xf9334>
    3a3c:	0d000015 	stceq	0, cr0, [r0, #-84]	; 0xffffffac
    3a40:	00646e72 	rsbeq	r6, r4, r2, ror lr
    3a44:	6c161103 	ldfvss	f1, [r6], {3}
    3a48:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    3a4c:	0000080c 	andeq	r0, r0, ip, lsl #16
    3a50:	08060408 	stmdaeq	r6, {r3, sl}
    3a54:	00000139 	andeq	r0, r0, r9, lsr r1
    3a58:	0030720f 	eorseq	r7, r0, pc, lsl #4
    3a5c:	540e0804 	strpl	r0, [lr], #-2052	; 0xfffff7fc
    3a60:	00000000 	andeq	r0, r0, r0
    3a64:	0031720f 	eorseq	r7, r1, pc, lsl #4
    3a68:	540e0904 	strpl	r0, [lr], #-2308	; 0xfffff6fc
    3a6c:	04000000 	streq	r0, [r0], #-0
    3a70:	05b31000 	ldreq	r1, [r3, #0]!
    3a74:	04050000 	streq	r0, [r5], #-0
    3a78:	0000003f 	andeq	r0, r0, pc, lsr r0
    3a7c:	700c1f04 	andvc	r1, ip, r4, lsl #30
    3a80:	11000001 	tstne	r0, r1
    3a84:	0000088c 	andeq	r0, r0, ip, lsl #17
    3a88:	12c31100 	sbcne	r1, r3, #0, 2
    3a8c:	11010000 	mrsne	r0, (UNDEF: 1)
    3a90:	00001297 	muleq	r0, r7, r2
    3a94:	0acb1102 	beq	ff2c7ea4 <__bss_end+0xff2bc790>
    3a98:	11030000 	mrsne	r0, (UNDEF: 3)
    3a9c:	00000cd1 	ldrdeq	r0, [r0], -r1
    3aa0:	08551104 	ldmdaeq	r5, {r2, r8, ip}^
    3aa4:	00050000 	andeq	r0, r5, r0
    3aa8:	00117910 	andseq	r7, r1, r0, lsl r9
    3aac:	3f040500 	svccc	0x00040500
    3ab0:	04000000 	streq	r0, [r0], #-0
    3ab4:	01ad0c40 			; <UNDEFINED> instruction: 0x01ad0c40
    3ab8:	c8110000 	ldmdagt	r1, {}	; <UNPREDICTABLE>
    3abc:	00000003 	andeq	r0, r0, r3
    3ac0:	0005c811 	andeq	ip, r5, r1, lsl r8
    3ac4:	a0110100 	andsge	r0, r1, r0, lsl #2
    3ac8:	0200000c 	andeq	r0, r0, #12
    3acc:	00122011 	andseq	r2, r2, r1, lsl r0
    3ad0:	cd110300 	ldcgt	3, cr0, [r1, #-0]
    3ad4:	04000012 	streq	r0, [r0], #-18	; 0xffffffee
    3ad8:	000bf711 	andeq	pc, fp, r1, lsl r7	; <UNPREDICTABLE>
    3adc:	49110500 	ldmdbmi	r1, {r8, sl}
    3ae0:	0600000a 	streq	r0, [r0], -sl
    3ae4:	0e8a1000 	cdpeq	0, 8, cr1, cr10, cr0, {0}
    3ae8:	04050000 	streq	r0, [r5], #-0
    3aec:	0000003f 	andeq	r0, r0, pc, lsr r0
    3af0:	c60c6604 	strgt	r6, [ip], -r4, lsl #12
    3af4:	11000001 	tstne	r0, r1
    3af8:	00000ccc 	andeq	r0, r0, ip, asr #25
    3afc:	25120000 	ldrcs	r0, [r2, #-0]
    3b00:	0500000c 	streq	r0, [r0, #-12]
    3b04:	00601405 	rsbeq	r1, r0, r5, lsl #8
    3b08:	03050000 	movweq	r0, #20480	; 0x5000
    3b0c:	0000b6b4 			; <UNDEFINED> instruction: 0x0000b6b4
    3b10:	000c7c12 	andeq	r7, ip, r2, lsl ip
    3b14:	14060500 	strne	r0, [r6], #-1280	; 0xfffffb00
    3b18:	00000060 	andeq	r0, r0, r0, rrx
    3b1c:	b6b80305 	ldrtlt	r0, [r8], r5, lsl #6
    3b20:	e1120000 	tst	r2, r0
    3b24:	0600000b 	streq	r0, [r0], -fp
    3b28:	00601a07 	rsbeq	r1, r0, r7, lsl #20
    3b2c:	03050000 	movweq	r0, #20480	; 0x5000
    3b30:	0000b6bc 			; <UNDEFINED> instruction: 0x0000b6bc
    3b34:	0006eb12 	andeq	lr, r6, r2, lsl fp
    3b38:	1a090600 	bne	245340 <__bss_end+0x239c2c>
    3b3c:	00000060 	andeq	r0, r0, r0, rrx
    3b40:	b6c00305 	strblt	r0, [r0], r5, lsl #6
    3b44:	81120000 	tsthi	r2, r0
    3b48:	0600000d 	streq	r0, [r0], -sp
    3b4c:	00601a0b 	rsbeq	r1, r0, fp, lsl #20
    3b50:	03050000 	movweq	r0, #20480	; 0x5000
    3b54:	0000b6c4 	andeq	fp, r0, r4, asr #13
    3b58:	0009ea12 	andeq	lr, r9, r2, lsl sl
    3b5c:	1a0d0600 	bne	345364 <__bss_end+0x339c50>
    3b60:	00000060 	andeq	r0, r0, r0, rrx
    3b64:	b6c80305 	strblt	r0, [r8], r5, lsl #6
    3b68:	3e120000 	cdpcc	0, 1, cr0, cr2, cr0, {0}
    3b6c:	06000008 	streq	r0, [r0], -r8
    3b70:	00601a0f 	rsbeq	r1, r0, pc, lsl #20
    3b74:	03050000 	movweq	r0, #20480	; 0x5000
    3b78:	0000b6cc 	andeq	fp, r0, ip, asr #13
    3b7c:	000d6213 	andeq	r6, sp, r3, lsl r2
    3b80:	02010200 	andeq	r0, r1, #0, 4
    3b84:	00000ae2 	andeq	r0, r0, r2, ror #21
    3b88:	0244040c 	subeq	r0, r4, #12, 8	; 0xc000000
    3b8c:	1e120000 	cdpne	0, 1, cr0, cr2, cr0, {0}
    3b90:	07000009 	streq	r0, [r0, -r9]
    3b94:	00601404 	rsbeq	r1, r0, r4, lsl #8
    3b98:	03050000 	movweq	r0, #20480	; 0x5000
    3b9c:	0000b6d0 	ldrdeq	fp, [r0], -r0
    3ba0:	0003bd12 	andeq	fp, r3, r2, lsl sp
    3ba4:	14070700 	strne	r0, [r7], #-1792	; 0xfffff900
    3ba8:	00000060 	andeq	r0, r0, r0, rrx
    3bac:	b6d40305 	ldrblt	r0, [r4], r5, lsl #6
    3bb0:	33120000 	tstcc	r2, #0
    3bb4:	07000007 	streq	r0, [r0, -r7]
    3bb8:	0060140a 	rsbeq	r1, r0, sl, lsl #8
    3bbc:	03050000 	movweq	r0, #20480	; 0x5000
    3bc0:	0000b6d8 	ldrdeq	fp, [r0], -r8
    3bc4:	000b4510 	andeq	r4, fp, r0, lsl r5
    3bc8:	3f040500 	svccc	0x00040500
    3bcc:	07000000 	streq	r0, [r0, -r0]
    3bd0:	02c30c0d 	sbceq	r0, r3, #3328	; 0xd00
    3bd4:	4e140000 	cdpmi	0, 1, cr0, cr4, cr0, {0}
    3bd8:	00007765 	andeq	r7, r0, r5, ror #14
    3bdc:	000b3c11 	andeq	r3, fp, r1, lsl ip
    3be0:	ae110100 	mufges	f0, f1, f0
    3be4:	0200000e 	andeq	r0, r0, #14
    3be8:	000b1411 	andeq	r1, fp, r1, lsl r4
    3bec:	bd110300 	ldclt	3, cr0, [r1, #-0]
    3bf0:	0400000a 	streq	r0, [r0], #-10
    3bf4:	000ca611 	andeq	sl, ip, r1, lsl r6
    3bf8:	0e000500 	cfsh32eq	mvfx0, mvfx0, #0
    3bfc:	00000848 	andeq	r0, r0, r8, asr #16
    3c00:	081b0710 	ldmdaeq	fp, {r4, r8, r9, sl}
    3c04:	00000302 	andeq	r0, r0, r2, lsl #6
    3c08:	00726c0f 	rsbseq	r6, r2, pc, lsl #24
    3c0c:	02131d07 	andseq	r1, r3, #448	; 0x1c0
    3c10:	00000003 	andeq	r0, r0, r3
    3c14:	0070730f 	rsbseq	r7, r0, pc, lsl #6
    3c18:	02131e07 	andseq	r1, r3, #7, 28	; 0x70
    3c1c:	04000003 	streq	r0, [r0], #-3
    3c20:	0063700f 	rsbeq	r7, r3, pc
    3c24:	02131f07 	andseq	r1, r3, #7, 30
    3c28:	08000003 	stmdaeq	r0, {r0, r1}
    3c2c:	00085e07 	andeq	r5, r8, r7, lsl #28
    3c30:	13200700 	nopne	{0}	; <UNPREDICTABLE>
    3c34:	00000302 	andeq	r0, r0, r2, lsl #6
    3c38:	0402000c 	streq	r0, [r2], #-12
    3c3c:	001d2307 	andseq	r2, sp, r7, lsl #6
    3c40:	04520e00 	ldrbeq	r0, [r2], #-3584	; 0xfffff200
    3c44:	07800000 	streq	r0, [r0, r0]
    3c48:	03cc0828 	biceq	r0, ip, #40, 16	; 0x280000
    3c4c:	40070000 	andmi	r0, r7, r0
    3c50:	0700000f 	streq	r0, [r0, -pc]
    3c54:	02c3122a 	sbceq	r1, r3, #-1610612734	; 0xa0000002
    3c58:	0f000000 	svceq	0x00000000
    3c5c:	00646970 	rsbeq	r6, r4, r0, ror r9
    3c60:	65122b07 	ldrvs	r2, [r2, #-2823]	; 0xfffff4f9
    3c64:	10000000 	andne	r0, r0, r0
    3c68:	0006b807 	andeq	fp, r6, r7, lsl #16
    3c6c:	112c0700 			; <UNDEFINED> instruction: 0x112c0700
    3c70:	0000028c 	andeq	r0, r0, ip, lsl #5
    3c74:	0b7f0714 	bleq	1fc58cc <__bss_end+0x1fba1b8>
    3c78:	2d070000 	stccs	0, cr0, [r7, #-0]
    3c7c:	00006512 	andeq	r6, r0, r2, lsl r5
    3c80:	8d071800 	stchi	8, cr1, [r7, #-0]
    3c84:	0700000b 	streq	r0, [r0, -fp]
    3c88:	0065122e 	rsbeq	r1, r5, lr, lsr #4
    3c8c:	071c0000 	ldreq	r0, [ip, -r0]
    3c90:	0000082c 	andeq	r0, r0, ip, lsr #16
    3c94:	cc0c2f07 	stcgt	15, cr2, [ip], {7}
    3c98:	20000003 	andcs	r0, r0, r3
    3c9c:	000ba907 	andeq	sl, fp, r7, lsl #18
    3ca0:	09300700 	ldmdbeq	r0!, {r8, r9, sl}
    3ca4:	0000003f 	andeq	r0, r0, pc, lsr r0
    3ca8:	0f710760 	svceq	0x00710760
    3cac:	31070000 	mrscc	r0, (UNDEF: 7)
    3cb0:	0000540e 	andeq	r5, r0, lr, lsl #8
    3cb4:	d4076400 	strle	r6, [r7], #-1024	; 0xfffffc00
    3cb8:	07000008 	streq	r0, [r0, -r8]
    3cbc:	00540e33 	subseq	r0, r4, r3, lsr lr
    3cc0:	07680000 	strbeq	r0, [r8, -r0]!
    3cc4:	000008cb 	andeq	r0, r0, fp, asr #17
    3cc8:	540e3407 	strpl	r3, [lr], #-1031	; 0xfffffbf9
    3ccc:	6c000000 	stcvs	0, cr0, [r0], {-0}
    3cd0:	0074700f 	rsbseq	r7, r4, pc
    3cd4:	dc0f3507 	cfstr32le	mvfx3, [pc], {7}
    3cd8:	70000003 	andvc	r0, r0, r3
    3cdc:	00122b07 	andseq	r2, r2, r7, lsl #22
    3ce0:	0e370700 	cdpeq	7, 3, cr0, cr7, cr0, {0}
    3ce4:	00000054 	andeq	r0, r0, r4, asr r0
    3ce8:	08180774 	ldmdaeq	r8, {r2, r4, r5, r6, r8, r9, sl}
    3cec:	38070000 	stmdacc	r7, {}	; <UNPREDICTABLE>
    3cf0:	0000540e 	andeq	r5, r0, lr, lsl #8
    3cf4:	c2077800 	andgt	r7, r7, #0, 16
    3cf8:	0700000e 	streq	r0, [r0, -lr]
    3cfc:	00540e39 	subseq	r0, r4, r9, lsr lr
    3d00:	007c0000 	rsbseq	r0, ip, r0
    3d04:	00025015 	andeq	r5, r2, r5, lsl r0
    3d08:	0003dc00 	andeq	sp, r3, r0, lsl #24
    3d0c:	00651600 	rsbeq	r1, r5, r0, lsl #12
    3d10:	000f0000 	andeq	r0, pc, r0
    3d14:	0054040c 	subseq	r0, r4, ip, lsl #8
    3d18:	cf120000 	svcgt	0x00120000
    3d1c:	08000011 	stmdaeq	r0, {r0, r4}
    3d20:	0060140a 	rsbeq	r1, r0, sl, lsl #8
    3d24:	03050000 	movweq	r0, #20480	; 0x5000
    3d28:	0000b6dc 	ldrdeq	fp, [r0], -ip
    3d2c:	000b1c10 	andeq	r1, fp, r0, lsl ip
    3d30:	3f040500 	svccc	0x00040500
    3d34:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    3d38:	04130c0d 	ldreq	r0, [r3], #-3085	; 0xfffff3f3
    3d3c:	dc110000 	ldcle	0, cr0, [r1], {-0}
    3d40:	00000005 	andeq	r0, r0, r5
    3d44:	0003b211 	andeq	fp, r3, r1, lsl r2
    3d48:	0e000100 	adfeqs	f0, f0, f0
    3d4c:	00001091 	muleq	r0, r1, r0
    3d50:	081b080c 	ldmdaeq	fp, {r2, r3, fp}
    3d54:	00000448 	andeq	r0, r0, r8, asr #8
    3d58:	00042407 	andeq	r2, r4, r7, lsl #8
    3d5c:	191d0800 	ldmdbne	sp, {fp}
    3d60:	00000448 	andeq	r0, r0, r8, asr #8
    3d64:	058e0700 	streq	r0, [lr, #1792]	; 0x700
    3d68:	1e080000 	cdpne	0, 0, cr0, cr8, cr0, {0}
    3d6c:	00044819 	andeq	r4, r4, r9, lsl r8
    3d70:	ef070400 	svc	0x00070400
    3d74:	0800000f 	stmdaeq	r0, {r0, r1, r2, r3}
    3d78:	044e131f 	strbeq	r1, [lr], #-799	; 0xfffffce1
    3d7c:	00080000 	andeq	r0, r8, r0
    3d80:	0413040c 	ldreq	r0, [r3], #-1036	; 0xfffffbf4
    3d84:	040c0000 	streq	r0, [ip], #-0
    3d88:	00000309 	andeq	r0, r0, r9, lsl #6
    3d8c:	00074606 	andeq	r4, r7, r6, lsl #12
    3d90:	22081400 	andcs	r1, r8, #0, 8
    3d94:	00070a07 	andeq	r0, r7, r7, lsl #20
    3d98:	0b0a0700 	bleq	2859a0 <__bss_end+0x27a28c>
    3d9c:	26080000 	strcs	r0, [r8], -r0
    3da0:	00005412 	andeq	r5, r0, r2, lsl r4
    3da4:	a1070000 	mrsge	r0, (UNDEF: 7)
    3da8:	08000004 	stmdaeq	r0, {r2}
    3dac:	04481d29 	strbeq	r1, [r8], #-3369	; 0xfffff2d7
    3db0:	07040000 	streq	r0, [r4, -r0]
    3db4:	00000eeb 	andeq	r0, r0, fp, ror #29
    3db8:	481d2c08 	ldmdami	sp, {r3, sl, fp, sp}
    3dbc:	08000004 	stmdaeq	r0, {r2}
    3dc0:	00115217 	andseq	r5, r1, r7, lsl r2
    3dc4:	0e2f0800 	cdpeq	8, 2, cr0, cr15, cr0, {0}
    3dc8:	0000106e 	andeq	r1, r0, lr, rrx
    3dcc:	0000049c 	muleq	r0, ip, r4
    3dd0:	000004a7 	andeq	r0, r0, r7, lsr #9
    3dd4:	00070f09 	andeq	r0, r7, r9, lsl #30
    3dd8:	04480a00 	strbeq	r0, [r8], #-2560	; 0xfffff600
    3ddc:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    3de0:	00001007 	andeq	r1, r0, r7
    3de4:	290e3108 	stmdbcs	lr, {r3, r8, ip, sp}
    3de8:	49000004 	stmdbmi	r0, {r2}
    3dec:	bf000002 	svclt	0x00000002
    3df0:	ca000004 	bgt	3e08 <_start-0x41f8>
    3df4:	09000004 	stmdbeq	r0, {r2}
    3df8:	0000070f 	andeq	r0, r0, pc, lsl #14
    3dfc:	00044e0a 	andeq	r4, r4, sl, lsl #28
    3e00:	b3080000 	movwlt	r0, #32768	; 0x8000
    3e04:	08000010 	stmdaeq	r0, {r4}
    3e08:	0fca1d35 	svceq	0x00ca1d35
    3e0c:	04480000 	strbeq	r0, [r8], #-0
    3e10:	e3020000 	movw	r0, #8192	; 0x2000
    3e14:	e9000004 	stmdb	r0, {r2}
    3e18:	09000004 	stmdbeq	r0, {r2}
    3e1c:	0000070f 	andeq	r0, r0, pc, lsl #14
    3e20:	0a3c0800 	beq	f05e28 <__bss_end+0xefa714>
    3e24:	37080000 	strcc	r0, [r8, -r0]
    3e28:	000de71d 	andeq	lr, sp, sp, lsl r7
    3e2c:	00044800 	andeq	r4, r4, r0, lsl #16
    3e30:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
    3e34:	05080000 	streq	r0, [r8, #-0]
    3e38:	0f090000 	svceq	0x00090000
    3e3c:	00000007 	andeq	r0, r0, r7
    3e40:	000bd319 	andeq	sp, fp, r9, lsl r3
    3e44:	31390800 	teqcc	r9, r0, lsl #16
    3e48:	00000728 	andeq	r0, r0, r8, lsr #14
    3e4c:	4608020c 	strmi	r0, [r8], -ip, lsl #4
    3e50:	08000007 	stmdaeq	r0, {r0, r1, r2}
    3e54:	129d093c 	addsne	r0, sp, #60, 18	; 0xf0000
    3e58:	070f0000 	streq	r0, [pc, -r0]
    3e5c:	2f010000 	svccs	0x00010000
    3e60:	35000005 	strcc	r0, [r0, #-5]
    3e64:	09000005 	stmdbeq	r0, {r0, r2}
    3e68:	0000070f 	andeq	r0, r0, pc, lsl #14
    3e6c:	06240800 	strteq	r0, [r4], -r0, lsl #16
    3e70:	3f080000 	svccc	0x00080000
    3e74:	00112712 	andseq	r2, r1, r2, lsl r7
    3e78:	00005400 	andeq	r5, r0, r0, lsl #8
    3e7c:	054e0100 	strbeq	r0, [lr, #-256]	; 0xffffff00
    3e80:	05630000 	strbeq	r0, [r3, #-0]!
    3e84:	0f090000 	svceq	0x00090000
    3e88:	0a000007 	beq	3eac <_start-0x4154>
    3e8c:	00000731 	andeq	r0, r0, r1, lsr r7
    3e90:	0000650a 	andeq	r6, r0, sl, lsl #10
    3e94:	02490a00 	subeq	r0, r9, #0, 20
    3e98:	1a000000 	bne	3ea0 <_start-0x4160>
    3e9c:	00001016 	andeq	r1, r0, r6, lsl r0
    3ea0:	140e4208 	strne	r4, [lr], #-520	; 0xfffffdf8
    3ea4:	0100000d 	tsteq	r0, sp
    3ea8:	00000578 	andeq	r0, r0, r8, ror r5
    3eac:	0000057e 	andeq	r0, r0, lr, ror r5
    3eb0:	00070f09 	andeq	r0, r7, r9, lsl #30
    3eb4:	63080000 	movwvs	r0, #32768	; 0x8000
    3eb8:	08000009 	stmdaeq	r0, {r0, r3}
    3ebc:	04fd1745 	ldrbteq	r1, [sp], #1861	; 0x745
    3ec0:	044e0000 	strbeq	r0, [lr], #-0
    3ec4:	97010000 	strls	r0, [r1, -r0]
    3ec8:	9d000005 	stcls	0, cr0, [r0, #-20]	; 0xffffffec
    3ecc:	09000005 	stmdbeq	r0, {r0, r2}
    3ed0:	00000737 	andeq	r0, r0, r7, lsr r7
    3ed4:	05930800 	ldreq	r0, [r3, #2048]	; 0x800
    3ed8:	48080000 	stmdami	r8, {}	; <UNPREDICTABLE>
    3edc:	000f7d17 	andeq	r7, pc, r7, lsl sp	; <UNPREDICTABLE>
    3ee0:	00044e00 	andeq	r4, r4, r0, lsl #28
    3ee4:	05b60100 	ldreq	r0, [r6, #256]!	; 0x100
    3ee8:	05c10000 	strbeq	r0, [r1]
    3eec:	37090000 	strcc	r0, [r9, -r0]
    3ef0:	0a000007 	beq	3f14 <_start-0x40ec>
    3ef4:	00000054 	andeq	r0, r0, r4, asr r0
    3ef8:	11de1a00 	bicsne	r1, lr, r0, lsl #20
    3efc:	4b080000 	blmi	203f04 <__bss_end+0x1f87f0>
    3f00:	0003cd0e 	andeq	ip, r3, lr, lsl #26
    3f04:	05d60100 	ldrbeq	r0, [r6, #256]	; 0x100
    3f08:	05dc0000 	ldrbeq	r0, [ip]
    3f0c:	0f090000 	svceq	0x00090000
    3f10:	00000007 	andeq	r0, r0, r7
    3f14:	00100708 	andseq	r0, r0, r8, lsl #14
    3f18:	0e4d0800 	cdpeq	8, 4, cr0, cr13, cr0, {0}
    3f1c:	00000864 	andeq	r0, r0, r4, ror #16
    3f20:	00000249 	andeq	r0, r0, r9, asr #4
    3f24:	0005f501 	andeq	pc, r5, r1, lsl #10
    3f28:	00060000 	andeq	r0, r6, r0
    3f2c:	070f0900 	streq	r0, [pc, -r0, lsl #18]
    3f30:	540a0000 	strpl	r0, [sl], #-0
    3f34:	00000000 	andeq	r0, r0, r0
    3f38:	00097e08 	andeq	r7, r9, r8, lsl #28
    3f3c:	12500800 	subsne	r0, r0, #0, 16
    3f40:	00000d35 	andeq	r0, r0, r5, lsr sp
    3f44:	00000054 	andeq	r0, r0, r4, asr r0
    3f48:	00061901 	andeq	r1, r6, r1, lsl #18
    3f4c:	00062400 	andeq	r2, r6, r0, lsl #8
    3f50:	070f0900 	streq	r0, [pc, -r0, lsl #18]
    3f54:	500a0000 	andpl	r0, sl, r0
    3f58:	00000002 	andeq	r0, r0, r2
    3f5c:	00046908 	andeq	r6, r4, r8, lsl #18
    3f60:	0e530800 	cdpeq	8, 5, cr0, cr3, cr0, {0}
    3f64:	00000937 	andeq	r0, r0, r7, lsr r9
    3f68:	00000249 	andeq	r0, r0, r9, asr #4
    3f6c:	00063d01 	andeq	r3, r6, r1, lsl #26
    3f70:	00064800 	andeq	r4, r6, r0, lsl #16
    3f74:	070f0900 	streq	r0, [pc, -r0, lsl #18]
    3f78:	540a0000 	strpl	r0, [sl], #-0
    3f7c:	00000000 	andeq	r0, r0, r0
    3f80:	000a081a 	andeq	r0, sl, sl, lsl r8
    3f84:	0e560800 	cdpeq	8, 5, cr0, cr6, cr0, {0}
    3f88:	000010bf 	strheq	r1, [r0], -pc	; <UNPREDICTABLE>
    3f8c:	00065d01 	andeq	r5, r6, r1, lsl #26
    3f90:	00067c00 	andeq	r7, r6, r0, lsl #24
    3f94:	070f0900 	streq	r0, [pc, -r0, lsl #18]
    3f98:	390a0000 	stmdbcc	sl, {}	; <UNPREDICTABLE>
    3f9c:	0a000001 	beq	3fa8 <_start-0x4058>
    3fa0:	00000054 	andeq	r0, r0, r4, asr r0
    3fa4:	0000540a 	andeq	r5, r0, sl, lsl #8
    3fa8:	00540a00 	subseq	r0, r4, r0, lsl #20
    3fac:	3d0a0000 	stccc	0, cr0, [sl, #-0]
    3fb0:	00000007 	andeq	r0, r0, r7
    3fb4:	000faa1a 	andeq	sl, pc, sl, lsl sl	; <UNPREDICTABLE>
    3fb8:	0e580800 	cdpeq	8, 5, cr0, cr8, cr0, {0}
    3fbc:	000007c0 	andeq	r0, r0, r0, asr #15
    3fc0:	00069101 	andeq	r9, r6, r1, lsl #2
    3fc4:	0006b000 	andeq	fp, r6, r0
    3fc8:	070f0900 	streq	r0, [pc, -r0, lsl #18]
    3fcc:	700a0000 	andvc	r0, sl, r0
    3fd0:	0a000001 	beq	3fdc <_start-0x4024>
    3fd4:	00000054 	andeq	r0, r0, r4, asr r0
    3fd8:	0000540a 	andeq	r5, r0, sl, lsl #8
    3fdc:	00540a00 	subseq	r0, r4, r0, lsl #20
    3fe0:	3d0a0000 	stccc	0, cr0, [sl, #-0]
    3fe4:	00000007 	andeq	r0, r0, r7
    3fe8:	000d8f1a 	andeq	r8, sp, sl, lsl pc
    3fec:	0e5a0800 	cdpeq	8, 5, cr0, cr10, cr0, {0}
    3ff0:	0000099a 	muleq	r0, sl, r9
    3ff4:	0006c501 	andeq	ip, r6, r1, lsl #10
    3ff8:	0006e400 	andeq	lr, r6, r0, lsl #8
    3ffc:	070f0900 	streq	r0, [pc, -r0, lsl #18]
    4000:	ad0a0000 	stcge	0, cr0, [sl, #-0]
    4004:	0a000001 	beq	4010 <_start-0x3ff0>
    4008:	00000054 	andeq	r0, r0, r4, asr r0
    400c:	0000540a 	andeq	r5, r0, sl, lsl #8
    4010:	00540a00 	subseq	r0, r4, r0, lsl #20
    4014:	3d0a0000 	stccc	0, cr0, [sl, #-0]
    4018:	00000007 	andeq	r0, r0, r7
    401c:	0007201b 	andeq	r2, r7, fp, lsl r0
    4020:	0e5d0800 	cdpeq	8, 5, cr0, cr13, cr0, {0}
    4024:	00000768 	andeq	r0, r0, r8, ror #14
    4028:	00000249 	andeq	r0, r0, r9, asr #4
    402c:	0006f901 	andeq	pc, r6, r1, lsl #18
    4030:	070f0900 	streq	r0, [pc, -r0, lsl #18]
    4034:	f40a0000 	vst4.8	{d0-d3}, [sl], r0
    4038:	0a000003 	beq	404c <_start-0x3fb4>
    403c:	00000743 	andeq	r0, r0, r3, asr #14
    4040:	54050000 	strpl	r0, [r5], #-0
    4044:	0c000004 	stceq	0, cr0, [r0], {4}
    4048:	00045404 	andeq	r5, r4, r4, lsl #8
    404c:	04481c00 	strbeq	r1, [r8], #-3072	; 0xfffff400
    4050:	07220000 	streq	r0, [r2, -r0]!
    4054:	07280000 	streq	r0, [r8, -r0]!
    4058:	0f090000 	svceq	0x00090000
    405c:	00000007 	andeq	r0, r0, r7
    4060:	0004541d 	andeq	r5, r4, sp, lsl r4
    4064:	00071500 	andeq	r1, r7, r0, lsl #10
    4068:	46040c00 	strmi	r0, [r4], -r0, lsl #24
    406c:	0c000000 	stceq	0, cr0, [r0], {-0}
    4070:	00070a04 	andeq	r0, r7, r4, lsl #20
    4074:	13041e00 	movwne	r1, #19968	; 0x4e00
    4078:	1f000001 	svcne	0x00000001
    407c:	01072004 	tsteq	r7, r4
    4080:	04010000 	streq	r0, [r1], #-0
    4084:	0003050f 	andeq	r0, r3, pc, lsl #10
    4088:	210000b7 	strhcs	r0, [r0, -r7]
    408c:	000000d8 	ldrdeq	r0, [r0], -r8
    4090:	6d061e01 	stcvs	14, cr1, [r6, #-4]
    4094:	ac000007 	stcge	0, cr0, [r0], {7}
    4098:	300000ad 	andcc	r0, r0, sp, lsr #1
    409c:	01000000 	mrseq	r0, (UNDEF: 0)
    40a0:	0007899c 	muleq	r7, ip, r9
    40a4:	131a2200 	tstne	sl, #0, 4
    40a8:	00fb0000 	rscseq	r0, fp, r0
    40ac:	91020000 	mrsls	r0, (UNDEF: 2)
    40b0:	0e472374 	mcreq	3, 2, r2, cr7, cr4, {3}
    40b4:	1e010000 	cdpne	0, 0, cr0, cr1, cr0, {0}
    40b8:	0000542c 	andeq	r5, r0, ip, lsr #8
    40bc:	70910200 	addsvc	r0, r1, r0, lsl #4
    40c0:	00af2400 	adceq	r2, pc, r0, lsl #8
    40c4:	0f010000 	svceq	0x00010000
    40c8:	0007a307 	andeq	sl, r7, r7, lsl #6
    40cc:	00acf000 	adceq	pc, ip, r0
    40d0:	0000bc00 	andeq	fp, r0, r0, lsl #24
    40d4:	0a9c0100 	beq	fe7044dc <__bss_end+0xfe6f8dc8>
    40d8:	22000008 	andcs	r0, r0, #8
    40dc:	0000131a 	andeq	r1, r0, sl, lsl r3
    40e0:	000000fb 	strdeq	r0, [r0], -fp
    40e4:	25649102 	strbcs	r9, [r4, #-258]!	; 0xfffffefe
    40e8:	00776f6c 	rsbseq	r6, r7, ip, ror #30
    40ec:	33270f01 			; <UNDEFINED> instruction: 0x33270f01
    40f0:	02000000 	andeq	r0, r0, #0
    40f4:	7e236091 	mcrvc	0, 1, r6, cr3, cr1, {4}
    40f8:	0100001c 	tsteq	r0, ip, lsl r0
    40fc:	0033340f 	eorseq	r3, r3, pc, lsl #8
    4100:	91020000 	mrsls	r0, (UNDEF: 2)
    4104:	7562265c 	strbvc	r2, [r2, #-1628]!	; 0xfffff9a4
    4108:	14010066 	strne	r0, [r1], #-102	; 0xffffff9a
    410c:	00080a07 	andeq	r0, r8, r7, lsl #20
    4110:	68910200 	ldmvs	r1, {r9}
    4114:	001c6527 	andseq	r6, ip, r7, lsr #10
    4118:	0a160100 	beq	584520 <__bss_end+0x578e0c>
    411c:	00000033 	andeq	r0, r0, r3, lsr r0
    4120:	27749102 	ldrbcs	r9, [r4, -r2, lsl #2]!
    4124:	00001c74 	andeq	r1, r0, r4, ror ip
    4128:	540b1801 	strpl	r1, [fp], #-2049	; 0xfffff7ff
    412c:	02000000 	andeq	r0, r0, #0
    4130:	6a277091 	bvs	9e037c <__bss_end+0x9d4c68>
    4134:	0100001c 	tsteq	r0, ip, lsl r0
    4138:	01000819 	tsteq	r0, r9, lsl r8
    413c:	91020000 	mrsls	r0, (UNDEF: 2)
    4140:	2515006c 	ldrcs	r0, [r5, #-108]	; 0xffffff94
    4144:	1a000000 	bne	414c <_start-0x3eb4>
    4148:	16000008 	strne	r0, [r0], -r8
    414c:	00000065 	andeq	r0, r0, r5, rrx
    4150:	86280003 	strthi	r0, [r8], -r3
    4154:	01000000 	mrseq	r0, (UNDEF: 0)
    4158:	08300506 	ldmdaeq	r0!, {r1, r2, r8, sl}
    415c:	aca80000 	stcge	0, cr0, [r8]
    4160:	00480000 	subeq	r0, r8, r0
    4164:	9c010000 	stcls	0, cr0, [r1], {-0}
    4168:	00131a22 	andseq	r1, r3, r2, lsr #20
    416c:	0000fb00 	andeq	pc, r0, r0, lsl #22
    4170:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    4174:	776f6c25 	strbvc	r6, [pc, -r5, lsr #24]!
    4178:	29060100 	stmdbcs	r6, {r8}
    417c:	00000033 	andeq	r0, r0, r3, lsr r0
    4180:	23709102 	cmncs	r0, #-2147483648	; 0x80000000
    4184:	00001c7e 	andeq	r1, r0, lr, ror ip
    4188:	33360601 	teqcc	r6, #1048576	; 0x100000
    418c:	02000000 	andeq	r0, r0, #0
    4190:	00006c91 	muleq	r0, r1, ip
    4194:	00000355 	andeq	r0, r0, r5, asr r3
    4198:	12c20004 	sbcne	r0, r2, #4
    419c:	01040000 	mrseq	r0, (UNDEF: 4)
    41a0:	0000177f 	andeq	r1, r0, pc, ror r7
    41a4:	001caa04 	andseq	sl, ip, r4, lsl #20
    41a8:	00192400 	andseq	r2, r9, r0, lsl #8
    41ac:	00addc00 	adceq	sp, sp, r0, lsl #24
    41b0:	00033400 	andeq	r3, r3, r0, lsl #8
    41b4:	001fe700 	andseq	lr, pc, r0, lsl #14
    41b8:	08010200 	stmdaeq	r1, {r9}
    41bc:	00000daa 	andeq	r0, r0, sl, lsr #27
    41c0:	39050202 	stmdbcc	r5, {r1, r9}
    41c4:	0300000e 	movweq	r0, #14
    41c8:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    41cc:	01020074 	tsteq	r2, r4, ror r0
    41d0:	000da108 	andeq	sl, sp, r8, lsl #2
    41d4:	07020200 	streq	r0, [r2, -r0, lsl #4]
    41d8:	00000a1b 	andeq	r0, r0, fp, lsl sl
    41dc:	000ed504 	andeq	sp, lr, r4, lsl #10
    41e0:	07090300 	streq	r0, [r9, -r0, lsl #6]
    41e4:	00000054 	andeq	r0, r0, r4, asr r0
    41e8:	28070402 	stmdacs	r7, {r1, sl}
    41ec:	0500001d 	streq	r0, [r0, #-29]	; 0xffffffe3
    41f0:	00001236 	andeq	r1, r0, r6, lsr r2
    41f4:	07070288 	streq	r0, [r7, -r8, lsl #5]
    41f8:	00000166 	andeq	r0, r0, r6, ror #2
    41fc:	00061d06 	andeq	r1, r6, r6, lsl #26
    4200:	0e0b0200 	cdpeq	2, 0, cr0, cr11, cr0, {0}
    4204:	00000166 	andeq	r0, r0, r6, ror #2
    4208:	0fc00600 	svceq	0x00c00600
    420c:	0e020000 	cdpeq	0, 0, cr0, cr2, cr0, {0}
    4210:	00004812 	andeq	r4, r0, r2, lsl r8
    4214:	19068000 	stmdbne	r6, {pc}
    4218:	02000004 	andeq	r0, r0, #4
    421c:	0048120f 	subeq	r1, r8, pc, lsl #4
    4220:	07840000 	streq	r0, [r4, r0]
    4224:	00001236 	andeq	r1, r0, r6, lsr r2
    4228:	fe091302 	cdp2	3, 0, cr1, cr9, cr2, {0}
    422c:	7600000b 	strvc	r0, [r0], -fp
    4230:	01000001 	tsteq	r0, r1
    4234:	000000a8 	andeq	r0, r0, r8, lsr #1
    4238:	000000ae 	andeq	r0, r0, lr, lsr #1
    423c:	00017608 	andeq	r7, r1, r8, lsl #12
    4240:	1b070000 	blne	1c4248 <__bss_end+0x1b8b34>
    4244:	02000012 	andeq	r0, r0, #18
    4248:	06fd1216 	usateq	r1, #29, r6, lsl #4
    424c:	00480000 	subeq	r0, r8, r0
    4250:	c7010000 	strgt	r0, [r1, -r0]
    4254:	d2000000 	andle	r0, r0, #0
    4258:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    425c:	00000176 	andeq	r0, r0, r6, ror r1
    4260:	00018109 	andeq	r8, r1, r9, lsl #2
    4264:	1b070000 	blne	1c426c <__bss_end+0x1b8b58>
    4268:	02000012 	andeq	r0, r0, #18
    426c:	05701219 	ldrbeq	r1, [r0, #-537]!	; 0xfffffde7
    4270:	00480000 	subeq	r0, r8, r0
    4274:	eb010000 	bl	4427c <__bss_end+0x38b68>
    4278:	fb000000 	blx	4282 <_start-0x3d7e>
    427c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    4280:	00000176 	andeq	r0, r0, r6, ror r1
    4284:	00018109 	andeq	r8, r1, r9, lsl #2
    4288:	00480900 	subeq	r0, r8, r0, lsl #18
    428c:	07000000 	streq	r0, [r0, -r0]
    4290:	00000e9e 	muleq	r0, lr, lr
    4294:	5a121c02 	bpl	48b2a4 <__bss_end+0x47fb90>
    4298:	4800000b 	stmdami	r0, {r0, r1, r3}
    429c:	01000000 	mrseq	r0, (UNDEF: 0)
    42a0:	00000114 	andeq	r0, r0, r4, lsl r1
    42a4:	00000124 	andeq	r0, r0, r4, lsr #2
    42a8:	00017608 	andeq	r7, r1, r8, lsl #12
    42ac:	00250900 	eoreq	r0, r5, r0, lsl #18
    42b0:	81090000 	mrshi	r0, (UNDEF: 9)
    42b4:	00000001 	andeq	r0, r0, r1
    42b8:	000ba30a 	andeq	sl, fp, sl, lsl #6
    42bc:	0e1f0200 	cdpeq	2, 1, cr0, cr15, cr0, {0}
    42c0:	00001029 	andeq	r1, r0, r9, lsr #32
    42c4:	00013901 	andeq	r3, r1, r1, lsl #18
    42c8:	00014900 	andeq	r4, r1, r0, lsl #18
    42cc:	01760800 	cmneq	r6, r0, lsl #16
    42d0:	81090000 	mrshi	r0, (UNDEF: 9)
    42d4:	09000001 	stmdbeq	r0, {r0}
    42d8:	00000048 	andeq	r0, r0, r8, asr #32
    42dc:	0ba30b00 	bleq	fe8c6ee4 <__bss_end+0xfe8bb7d0>
    42e0:	22020000 	andcs	r0, r2, #0
    42e4:	000e4c0e 	andeq	r4, lr, lr, lsl #24
    42e8:	015a0100 	cmpeq	sl, r0, lsl #2
    42ec:	76080000 	strvc	r0, [r8], -r0
    42f0:	09000001 	stmdbeq	r0, {r0}
    42f4:	00000025 	andeq	r0, r0, r5, lsr #32
    42f8:	250c0000 	strcs	r0, [ip, #-0]
    42fc:	76000000 	strvc	r0, [r0], -r0
    4300:	0d000001 	stceq	0, cr0, [r0, #-4]
    4304:	00000054 	andeq	r0, r0, r4, asr r0
    4308:	040e007f 	streq	r0, [lr], #-127	; 0xffffff81
    430c:	0000005b 	andeq	r0, r0, fp, asr r0
    4310:	0001760f 	andeq	r7, r1, pc, lsl #12
    4314:	25040e00 	strcs	r0, [r4, #-3584]	; 0xfffff200
    4318:	10000000 	andne	r0, r0, r0
    431c:	00000149 	andeq	r0, r0, r9, asr #2
    4320:	a1064501 	tstge	r6, r1, lsl #10
    4324:	bc000001 	stclt	0, cr0, [r0], {1}
    4328:	540000b0 	strpl	r0, [r0], #-176	; 0xffffff50
    432c:	01000000 	mrseq	r0, (UNDEF: 0)
    4330:	0001bd9c 	muleq	r1, ip, sp
    4334:	131a1100 	tstne	sl, #0, 2
    4338:	017c0000 	cmneq	ip, r0
    433c:	91020000 	mrsls	r0, (UNDEF: 2)
    4340:	071a1274 			; <UNDEFINED> instruction: 0x071a1274
    4344:	45010000 	strmi	r0, [r1, #-0]
    4348:	00002522 	andeq	r2, r0, r2, lsr #10
    434c:	73910200 	orrsvc	r0, r1, #0, 4
    4350:	01241300 			; <UNDEFINED> instruction: 0x01241300
    4354:	3e010000 	cdpcc	0, 0, cr0, cr1, cr0, {0}
    4358:	0001d706 	andeq	sp, r1, r6, lsl #14
    435c:	00b05400 	adcseq	r5, r0, r0, lsl #8
    4360:	00006800 	andeq	r6, r0, r0, lsl #16
    4364:	199c0100 	ldmibne	ip, {r8}
    4368:	11000002 	tstne	r0, r2
    436c:	0000131a 	andeq	r1, r0, sl, lsl r3
    4370:	0000017c 	andeq	r0, r0, ip, ror r1
    4374:	126c9102 	rsbne	r9, ip, #-2147483648	; 0x80000000
    4378:	0000071a 	andeq	r0, r0, sl, lsl r7
    437c:	81233e01 			; <UNDEFINED> instruction: 0x81233e01
    4380:	02000001 	andeq	r0, r0, #1
    4384:	6c146891 	ldcvs	8, cr6, [r4], {145}	; 0x91
    4388:	01006e65 	tsteq	r0, r5, ror #28
    438c:	0048333e 	subeq	r3, r8, lr, lsr r3
    4390:	91020000 	mrsls	r0, (UNDEF: 2)
    4394:	b06c1564 	rsblt	r1, ip, r4, ror #10
    4398:	00440000 	subeq	r0, r4, r0
    439c:	69160000 	ldmdbvs	r6, {}	; <UNPREDICTABLE>
    43a0:	0e3f0100 	rsfeqe	f0, f7, f0
    43a4:	00000033 	andeq	r0, r0, r3, lsr r0
    43a8:	00749102 	rsbseq	r9, r4, r2, lsl #2
    43ac:	00fb1300 	rscseq	r1, fp, r0, lsl #6
    43b0:	2b010000 	blcs	443b8 <__bss_end+0x38ca4>
    43b4:	0002330a 	andeq	r3, r2, sl, lsl #6
    43b8:	00af8400 	adceq	r8, pc, r0, lsl #8
    43bc:	0000d000 	andeq	sp, r0, r0
    43c0:	6d9c0100 	ldfvss	f0, [ip]
    43c4:	11000002 	tstne	r0, r2
    43c8:	0000131a 	andeq	r1, r0, sl, lsl r3
    43cc:	0000017c 	andeq	r0, r0, ip, ror r1
    43d0:	126c9102 	rsbne	r9, ip, #-2147483648	; 0x80000000
    43d4:	00001d0d 	andeq	r1, r0, sp, lsl #26
    43d8:	252b2b01 	strcs	r2, [fp, #-2817]!	; 0xfffff4ff
    43dc:	02000000 	andeq	r0, r0, #0
    43e0:	ea126b91 	b	49f22c <__bss_end+0x493b18>
    43e4:	0100001b 	tsteq	r0, fp, lsl r0
    43e8:	0181372b 	orreq	r3, r1, fp, lsr #14
    43ec:	91020000 	mrsls	r0, (UNDEF: 2)
    43f0:	1c9c1764 	ldcne	7, cr1, [ip], {100}	; 0x64
    43f4:	2c010000 	stccs	0, cr0, [r1], {-0}
    43f8:	00003309 	andeq	r3, r0, r9, lsl #6
    43fc:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    4400:	00d21000 	sbcseq	r1, r2, r0
    4404:	10010000 	andne	r0, r1, r0
    4408:	0002870a 	andeq	r8, r2, sl, lsl #14
    440c:	00ae6c00 	adceq	r6, lr, r0, lsl #24
    4410:	00011800 	andeq	r1, r1, r0, lsl #16
    4414:	e79c0100 	ldr	r0, [ip, r0, lsl #2]
    4418:	11000002 	tstne	r0, r2
    441c:	0000131a 	andeq	r1, r0, sl, lsl r3
    4420:	0000017c 	andeq	r0, r0, ip, ror r1
    4424:	12649102 	rsbne	r9, r4, #-2147483648	; 0x80000000
    4428:	00001bea 	andeq	r1, r0, sl, ror #23
    442c:	81271001 			; <UNDEFINED> instruction: 0x81271001
    4430:	02000001 	andeq	r0, r0, #1
    4434:	6c146091 	ldcvs	0, cr6, [r4], {145}	; 0x91
    4438:	01006e65 	tsteq	r0, r5, ror #28
    443c:	00483e10 	subeq	r3, r8, r0, lsl lr
    4440:	91020000 	mrsls	r0, (UNDEF: 2)
    4444:	1be0175c 	blne	ff80a1bc <__bss_end+0xff7feaa8>
    4448:	11010000 	mrsne	r0, (UNDEF: 1)
    444c:	00003309 	andeq	r3, r0, r9, lsl #6
    4450:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    4454:	001d0617 	andseq	r0, sp, r7, lsl r6
    4458:	0e190100 	mufeqe	f0, f1, f0
    445c:	00000048 	andeq	r0, r0, r8, asr #32
    4460:	156c9102 	strbne	r9, [ip, #-258]!	; 0xfffffefe
    4464:	0000aeec 	andeq	sl, r0, ip, ror #29
    4468:	00000084 	andeq	r0, r0, r4, lsl #1
    446c:	01006916 	tsteq	r0, r6, lsl r9
    4470:	00330e1f 	eorseq	r0, r3, pc, lsl lr
    4474:	91020000 	mrsls	r0, (UNDEF: 2)
    4478:	13000070 	movwne	r0, #112	; 0x70
    447c:	000000ae 	andeq	r0, r0, lr, lsr #1
    4480:	010a0b01 	tsteq	sl, r1, lsl #22
    4484:	24000003 	strcs	r0, [r0], #-3
    4488:	480000ae 	stmdami	r0, {r1, r2, r3, r5, r7}
    448c:	01000000 	mrseq	r0, (UNDEF: 0)
    4490:	00031d9c 	muleq	r3, ip, sp
    4494:	131a1100 	tstne	sl, #0, 2
    4498:	017c0000 	cmneq	ip, r0
    449c:	91020000 	mrsls	r0, (UNDEF: 2)
    44a0:	1bea1274 	blne	ffa88e78 <__bss_end+0xffa7d764>
    44a4:	0b010000 	bleq	444ac <__bss_end+0x38d98>
    44a8:	00018127 	andeq	r8, r1, r7, lsr #2
    44ac:	70910200 	addsvc	r0, r1, r0, lsl #4
    44b0:	008f1800 	addeq	r1, pc, r0, lsl #16
    44b4:	04010000 	streq	r0, [r1], #-0
    44b8:	00032e01 	andeq	r2, r3, r1, lsl #28
    44bc:	03380000 	teqeq	r8, #0
    44c0:	1a190000 	bne	6444c8 <__bss_end+0x638db4>
    44c4:	7c000013 	stcvc	0, cr0, [r0], {19}
    44c8:	00000001 	andeq	r0, r0, r1
    44cc:	00031d1a 	andeq	r1, r3, sl, lsl sp
    44d0:	001c8300 	andseq	r8, ip, r0, lsl #6
    44d4:	00034f00 	andeq	r4, r3, r0, lsl #30
    44d8:	00addc00 	adceq	sp, sp, r0, lsl #24
    44dc:	00004800 	andeq	r4, r0, r0, lsl #16
    44e0:	1b9c0100 	blne	fe7048e8 <__bss_end+0xfe6f91d4>
    44e4:	0000032e 	andeq	r0, r0, lr, lsr #6
    44e8:	00749102 	rsbseq	r9, r4, r2, lsl #2
    44ec:	00015800 	andeq	r5, r1, r0, lsl #16
    44f0:	63000400 	movwvs	r0, #1024	; 0x400
    44f4:	04000014 	streq	r0, [r0], #-20	; 0xffffffec
    44f8:	001d5201 	andseq	r5, sp, r1, lsl #4
    44fc:	1daf0c00 	stcne	12, cr0, [pc]	; 4504 <_start-0x3afc>
    4500:	1e1f0000 	cdpne	0, 1, cr0, cr15, cr0, {0}
    4504:	b2d80000 	sbcslt	r0, r8, #0
    4508:	011c0000 	tsteq	ip, r0
    450c:	228d0000 	addcs	r0, sp, #0
    4510:	04020000 	streq	r0, [r2], #-0
    4514:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    4518:	1d120300 	ldcne	3, cr0, [r2, #-0]
    451c:	d1020000 	mrsle	r0, (UNDEF: 2)
    4520:	00003817 	andeq	r3, r0, r7, lsl r8
    4524:	07040400 	streq	r0, [r4, -r0, lsl #8]
    4528:	00001d28 	andeq	r1, r0, r8, lsr #26
    452c:	f1050804 			; <UNDEFINED> instruction: 0xf1050804
    4530:	04000002 	streq	r0, [r0], #-2
    4534:	1e130408 	cfmulsne	mvf0, mvf3, mvf8
    4538:	01040000 	mrseq	r0, (UNDEF: 4)
    453c:	000da306 	andeq	sl, sp, r6, lsl #6
    4540:	08010400 	stmdaeq	r1, {sl}
    4544:	00000da1 	andeq	r0, r0, r1, lsr #27
    4548:	39050204 	stmdbcc	r5, {r2, r9}
    454c:	0400000e 	streq	r0, [r0], #-14
    4550:	0a1b0702 	beq	6c6160 <__bss_end+0x6baa4c>
    4554:	04040000 	streq	r0, [r4], #-0
    4558:	0002f605 	andeq	pc, r2, r5, lsl #12
    455c:	00690500 	rsbeq	r0, r9, r0, lsl #10
    4560:	04040000 	streq	r0, [r4], #-0
    4564:	001d2307 	andseq	r2, sp, r7, lsl #6
    4568:	07080400 	streq	r0, [r8, -r0, lsl #8]
    456c:	00001d1e 	andeq	r1, r0, lr, lsl sp
    4570:	83070406 	movwhi	r0, #29702	; 0x7406
    4574:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    4578:	00009004 	andeq	r9, r0, r4
    457c:	08010400 	stmdaeq	r1, {sl}
    4580:	00000daa 	andeq	r0, r0, sl, lsr #27
    4584:	00009005 	andeq	r9, r0, r5
    4588:	97040800 	strls	r0, [r4, -r0, lsl #16]
    458c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    4590:	0000ad04 	andeq	sl, r0, r4, lsl #26
    4594:	00a20700 	adceq	r0, r2, r0, lsl #14
    4598:	0a090000 	beq	2445a0 <__bss_end+0x238e8c>
    459c:	00001b02 	andeq	r1, r0, r2, lsl #22
    45a0:	83091f03 	movwhi	r1, #40707	; 0x9f03
    45a4:	d8000000 	stmdale	r0, {}	; <UNPREDICTABLE>
    45a8:	1c0000b2 	stcne	0, cr0, [r0], {178}	; 0xb2
    45ac:	01000001 	tsteq	r0, r1
    45b0:	00014f9c 	muleq	r1, ip, pc	; <UNPREDICTABLE>
    45b4:	1d350b00 	vldmdbne	r5!, {d0-d-1}
    45b8:	31010000 	mrscc	r0, (UNDEF: 1)
    45bc:	0000851a 	andeq	r8, r0, sl, lsl r5
    45c0:	0c500100 	ldfeqe	f0, [r0], {-0}
    45c4:	00001d19 	andeq	r1, r0, r9, lsl sp
    45c8:	a8193201 	ldmdage	r9, {r0, r9, ip, sp}
    45cc:	0a000000 	beq	45d4 <_start-0x3a2c>
    45d0:	00000000 	andeq	r0, r0, r0
    45d4:	0c000000 	stceq	0, cr0, [r0], {-0}
    45d8:	00001e0e 	andeq	r1, r0, lr, lsl #28
    45dc:	2c093301 	stccs	3, cr3, [r9], {1}
    45e0:	61000000 	mrsvs	r0, (UNDEF: 0)
    45e4:	4f000000 	svcmi	0x00000000
    45e8:	0d000000 	stceq	0, cr0, [r0, #-0]
    45ec:	00747364 	rsbseq	r7, r4, r4, ror #6
    45f0:	8a094201 	bhi	254dfc <__bss_end+0x2496e8>
    45f4:	da000000 	ble	45fc <_start-0x3a04>
    45f8:	d0000000 	andle	r0, r0, r0
    45fc:	0d000000 	stceq	0, cr0, [r0, #-0]
    4600:	00637273 	rsbeq	r7, r3, r3, ror r2
    4604:	9c0f4301 	stcls	3, cr4, [pc], {1}
    4608:	27000000 	strcs	r0, [r0, -r0]
    460c:	19000001 	stmdbne	r0, {r0}
    4610:	0e000001 	cdpeq	0, 0, cr0, cr0, cr1, {0}
    4614:	00001d3a 	andeq	r1, r0, sl, lsr sp
    4618:	4f094401 	svcmi	0x00094401
    461c:	85000001 	strhi	r0, [r0, #-1]
    4620:	83000001 	movwhi	r0, #1
    4624:	0e000001 	cdpeq	0, 0, cr0, cr0, cr1, {0}
    4628:	00001d46 	andeq	r1, r0, r6, asr #26
    462c:	550f4501 	strpl	r4, [pc, #-1281]	; 4133 <_start-0x3ecd>
    4630:	aa000001 	bge	463c <_start-0x39c4>
    4634:	98000001 	stmdals	r0, {r0}
    4638:	00000001 	andeq	r0, r0, r1
    463c:	00690408 	rsbeq	r0, r9, r8, lsl #8
    4640:	04080000 	streq	r0, [r8], #-0
    4644:	00000070 	andeq	r0, r0, r0, ror r0
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
       0:	10001101 	andne	r1, r0, r1, lsl #2
       4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
       8:	1b0e0301 	blne	380c14 <__bss_end+0x375500>
       c:	130e250e 	movwne	r2, #58638	; 0xe50e
      10:	00000005 	andeq	r0, r0, r5
      14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
      18:	030b130e 	movweq	r1, #45838	; 0xb30e
      1c:	110e1b0e 	tstne	lr, lr, lsl #22
      20:	10061201 	andne	r1, r6, r1, lsl #4
      24:	02000017 	andeq	r0, r0, #23
      28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
      2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb7608>
      30:	13490b39 	movtne	r0, #39737	; 0x9b39
      34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
      38:	24030000 	strcs	r0, [r3], #-0
      3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
      40:	000e030b 	andeq	r0, lr, fp, lsl #6
      44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
      48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
      4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb7628>
      50:	01110b39 	tsteq	r1, r9, lsr fp
      54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
      58:	01194296 			; <UNDEFINED> instruction: 0x01194296
      5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
      60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
      64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb7640>
      68:	13490b39 	movtne	r0, #39737	; 0x9b39
      6c:	00001802 	andeq	r1, r0, r2, lsl #16
      70:	0b002406 	bleq	9090 <_ZN10Chromosome9crossoverERS_+0x8c>
      74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
      78:	07000008 	streq	r0, [r0, -r8]
      7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
      80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe78180>
      84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe37664>
      88:	06120111 			; <UNDEFINED> instruction: 0x06120111
      8c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
      90:	00130119 	andseq	r0, r3, r9, lsl r1
      94:	010b0800 	tsteq	fp, r0, lsl #16
      98:	06120111 			; <UNDEFINED> instruction: 0x06120111
      9c:	34090000 	strcc	r0, [r9], #-0
      a0:	3a080300 	bcc	200ca8 <__bss_end+0x1f5594>
      a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
      a8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
      ac:	0a000018 	beq	114 <_start-0x7eec>
      b0:	0b0b000f 	bleq	2c00f4 <__bss_end+0x2b49e0>
      b4:	00001349 	andeq	r1, r0, r9, asr #6
      b8:	01110100 	tsteq	r1, r0, lsl #2
      bc:	0b130e25 	bleq	4c3958 <__bss_end+0x4b8244>
      c0:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
      c4:	06120111 			; <UNDEFINED> instruction: 0x06120111
      c8:	00001710 	andeq	r1, r0, r0, lsl r7
      cc:	03001602 	movweq	r1, #1538	; 0x602
      d0:	3b0b3a0e 	blcc	2ce910 <__bss_end+0x2c31fc>
      d4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
      d8:	03000013 	movweq	r0, #19
      dc:	0b0b000f 	bleq	2c0120 <__bss_end+0x2b4a0c>
      e0:	00001349 	andeq	r1, r0, r9, asr #6
      e4:	00001504 	andeq	r1, r0, r4, lsl #10
      e8:	01010500 	tsteq	r1, r0, lsl #10
      ec:	13011349 	movwne	r1, #4937	; 0x1349
      f0:	21060000 	mrscs	r0, (UNDEF: 6)
      f4:	2f134900 	svccs	0x00134900
      f8:	07000006 	streq	r0, [r0, -r6]
      fc:	0b0b0024 	bleq	2c0194 <__bss_end+0x2b4a80>
     100:	0e030b3e 	vmoveq.16	d3[0], r0
     104:	34080000 	strcc	r0, [r8], #-0
     108:	3a0e0300 	bcc	380d10 <__bss_end+0x3755fc>
     10c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     110:	3f13490b 	svccc	0x0013490b
     114:	00193c19 	andseq	r3, r9, r9, lsl ip
     118:	012e0900 			; <UNDEFINED> instruction: 0x012e0900
     11c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb76fc>
     124:	13490b39 	movtne	r0, #39737	; 0x9b39
     128:	06120111 			; <UNDEFINED> instruction: 0x06120111
     12c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     130:	00130119 	andseq	r0, r3, r9, lsl r1
     134:	00340a00 	eorseq	r0, r4, r0, lsl #20
     138:	0b3a0e03 	bleq	e8394c <__bss_end+0xe78238>
     13c:	0b390b3b 	bleq	e42e30 <__bss_end+0xe3771c>
     140:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     144:	240b0000 	strcs	r0, [fp], #-0
     148:	3e0b0b00 	vmlacc.f64	d0, d11, d0
     14c:	0008030b 	andeq	r0, r8, fp, lsl #6
     150:	002e0c00 	eoreq	r0, lr, r0, lsl #24
     154:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     158:	0b3b0b3a 	bleq	ec2e48 <__bss_end+0xeb7734>
     15c:	01110b39 	tsteq	r1, r9, lsr fp
     160:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     164:	00194297 	mulseq	r9, r7, r2
     168:	01390d00 	teqeq	r9, r0, lsl #26
     16c:	0b3a0e03 	bleq	e83980 <__bss_end+0xe7826c>
     170:	13010b3b 	movwne	r0, #6971	; 0x1b3b
     174:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
     178:	03193f01 	tsteq	r9, #1, 30
     17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c32a8>
     180:	3c0b390b 			; <UNDEFINED> instruction: 0x3c0b390b
     184:	00130119 	andseq	r0, r3, r9, lsl r1
     188:	00050f00 	andeq	r0, r5, r0, lsl #30
     18c:	00001349 	andeq	r1, r0, r9, asr #6
     190:	3f012e10 	svccc	0x00012e10
     194:	3a0e0319 	bcc	380e00 <__bss_end+0x3756ec>
     198:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     19c:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
     1a0:	11000019 	tstne	r0, r9, lsl r0
     1a4:	1347012e 	movtne	r0, #28974	; 0x712e
     1a8:	06120111 			; <UNDEFINED> instruction: 0x06120111
     1ac:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
     1b0:	00130119 	andseq	r0, r3, r9, lsl r1
     1b4:	00051200 	andeq	r1, r5, r0, lsl #4
     1b8:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     1bc:	05130000 	ldreq	r0, [r3, #-0]
     1c0:	3a080300 	bcc	200dc8 <__bss_end+0x1f56b4>
     1c4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     1c8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     1cc:	14000018 	strne	r0, [r0], #-24	; 0xffffffe8
     1d0:	1347012e 	movtne	r0, #28974	; 0x712e
     1d4:	06120111 			; <UNDEFINED> instruction: 0x06120111
     1d8:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
     1dc:	00000019 	andeq	r0, r0, r9, lsl r0
     1e0:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
     1e4:	030b130e 	movweq	r1, #45838	; 0xb30e
     1e8:	110e1b0e 	tstne	lr, lr, lsl #22
     1ec:	10061201 	andne	r1, r6, r1, lsl #4
     1f0:	02000017 	andeq	r0, r0, #23
     1f4:	0b0b0024 	bleq	2c028c <__bss_end+0x2b4b78>
     1f8:	0e030b3e 	vmoveq.16	d3[0], r0
     1fc:	26030000 	strcs	r0, [r3], -r0
     200:	00134900 	andseq	r4, r3, r0, lsl #18
     204:	00160400 	andseq	r0, r6, r0, lsl #8
     208:	0b3a0e03 	bleq	e83a1c <__bss_end+0xe78308>
     20c:	0b390b3b 	bleq	e42f00 <__bss_end+0xe377ec>
     210:	00001349 	andeq	r1, r0, r9, asr #6
     214:	0b002405 	bleq	9230 <_ZN10Chromosome9get_modelEv+0x4c>
     218:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
     21c:	06000008 	streq	r0, [r0], -r8
     220:	13490035 	movtne	r0, #36917	; 0x9035
     224:	13070000 	movwne	r0, #28672	; 0x7000
     228:	0b0e0301 	bleq	380e34 <__bss_end+0x375720>
     22c:	3b0b3a0b 	blcc	2cea60 <__bss_end+0x2c334c>
     230:	010b390b 	tsteq	fp, fp, lsl #18
     234:	08000013 	stmdaeq	r0, {r0, r1, r4}
     238:	0803000d 	stmdaeq	r3, {r0, r2, r3}
     23c:	0b3b0b3a 	bleq	ec2f2c <__bss_end+0xeb7818>
     240:	13490b39 	movtne	r0, #39737	; 0x9b39
     244:	00000b38 	andeq	r0, r0, r8, lsr fp
     248:	03010409 	movweq	r0, #5129	; 0x1409
     24c:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
     250:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
     254:	3b0b3a13 	blcc	2ceaa8 <__bss_end+0x2c3394>
     258:	010b390b 	tsteq	fp, fp, lsl #18
     25c:	0a000013 	beq	2b0 <_start-0x7d50>
     260:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
     264:	00000b1c 	andeq	r0, r0, ip, lsl fp
     268:	0300340b 	movweq	r3, #1035	; 0x40b
     26c:	3b0b3a0e 	blcc	2ceaac <__bss_end+0x2c3398>
     270:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     274:	02196c13 	andseq	r6, r9, #4864	; 0x1300
     278:	0c000018 	stceq	0, cr0, [r0], {24}
     27c:	0e030002 	cdpeq	0, 0, cr0, cr3, cr2, {0}
     280:	0000193c 	andeq	r1, r0, ip, lsr r9
     284:	0b000f0d 	bleq	3ec0 <_start-0x4140>
     288:	0013490b 	andseq	r4, r3, fp, lsl #18
     28c:	00280e00 	eoreq	r0, r8, r0, lsl #28
     290:	0b1c0803 	bleq	7022a4 <__bss_end+0x6f6b90>
     294:	0d0f0000 	stceq	0, cr0, [pc, #-0]	; 29c <_start-0x7d64>
     298:	3a0e0300 	bcc	380ea0 <__bss_end+0x37578c>
     29c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     2a0:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
     2a4:	1000000b 	andne	r0, r0, fp
     2a8:	13490101 	movtne	r0, #37121	; 0x9101
     2ac:	00001301 	andeq	r1, r0, r1, lsl #6
     2b0:	49002111 	stmdbmi	r0, {r0, r4, r8, sp}
     2b4:	000b2f13 	andeq	r2, fp, r3, lsl pc
     2b8:	01021200 	mrseq	r1, R10_usr
     2bc:	0b0b0e03 	bleq	2c3ad0 <__bss_end+0x2b83bc>
     2c0:	0b3b0b3a 	bleq	ec2fb0 <__bss_end+0xeb789c>
     2c4:	13010b39 	movwne	r0, #6969	; 0x1b39
     2c8:	2e130000 	cdpcs	0, 1, cr0, cr3, cr0, {0}
     2cc:	03193f01 	tsteq	r9, #1, 30
     2d0:	3b0b3a0e 	blcc	2ceb10 <__bss_end+0x2c33fc>
     2d4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     2d8:	64193c0e 	ldrvs	r3, [r9], #-3086	; 0xfffff3f2
     2dc:	00130113 	andseq	r0, r3, r3, lsl r1
     2e0:	00051400 	andeq	r1, r5, r0, lsl #8
     2e4:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
     2e8:	05150000 	ldreq	r0, [r5, #-0]
     2ec:	00134900 	andseq	r4, r3, r0, lsl #18
     2f0:	012e1600 			; <UNDEFINED> instruction: 0x012e1600
     2f4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     2f8:	0b3b0b3a 	bleq	ec2fe8 <__bss_end+0xeb78d4>
     2fc:	0e6e0b39 	vmoveq.8	d14[5], r0
     300:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
     304:	13011364 	movwne	r1, #4964	; 0x1364
     308:	2e170000 	cdpcs	0, 1, cr0, cr7, cr0, {0}
     30c:	03193f01 	tsteq	r9, #1, 30
     310:	3b0b3a0e 	blcc	2ceb50 <__bss_end+0x2c343c>
     314:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     318:	3213490e 	andscc	r4, r3, #229376	; 0x38000
     31c:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     320:	00130113 	andseq	r0, r3, r3, lsl r1
     324:	000d1800 	andeq	r1, sp, r0, lsl #16
     328:	0b3a0e03 	bleq	e83b3c <__bss_end+0xe78428>
     32c:	0b390b3b 	bleq	e43020 <__bss_end+0xe3790c>
     330:	0b381349 	bleq	e0505c <__bss_end+0xdf9948>
     334:	00000b32 	andeq	r0, r0, r2, lsr fp
     338:	3f012e19 	svccc	0x00012e19
     33c:	3a0e0319 	bcc	380fa8 <__bss_end+0x375894>
     340:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     344:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
     348:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     34c:	00130113 	andseq	r0, r3, r3, lsl r1
     350:	012e1a00 			; <UNDEFINED> instruction: 0x012e1a00
     354:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     358:	0b3b0b3a 	bleq	ec3048 <__bss_end+0xeb7934>
     35c:	0e6e0b39 	vmoveq.8	d14[5], r0
     360:	0b321349 	bleq	c8508c <__bss_end+0xc79978>
     364:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     368:	151b0000 	ldrne	r0, [fp, #-0]
     36c:	64134901 	ldrvs	r4, [r3], #-2305	; 0xfffff6ff
     370:	00130113 	andseq	r0, r3, r3, lsl r1
     374:	001f1c00 	andseq	r1, pc, r0, lsl #24
     378:	1349131d 	movtne	r1, #37661	; 0x931d
     37c:	101d0000 	andsne	r0, sp, r0
     380:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
     384:	1e000013 	mcrne	0, 0, r0, cr0, cr3, {0}
     388:	0b0b000f 	bleq	2c03cc <__bss_end+0x2b4cb8>
     38c:	2e1f0000 	cdpcs	0, 1, cr0, cr15, cr0, {0}
     390:	03193f01 	tsteq	r9, #1, 30
     394:	3b0b3a0e 	blcc	2cebd4 <__bss_end+0x2c34c0>
     398:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     39c:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
     3a0:	00136419 	andseq	r6, r3, r9, lsl r4
     3a4:	00342000 	eorseq	r2, r4, r0
     3a8:	0b3a0803 	bleq	e823bc <__bss_end+0xe76ca8>
     3ac:	0b390b3b 	bleq	e430a0 <__bss_end+0xe3798c>
     3b0:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
     3b4:	0000193c 	andeq	r1, r0, ip, lsr r9
     3b8:	3f012e21 	svccc	0x00012e21
     3bc:	3a080319 	bcc	201028 <__bss_end+0x1f5914>
     3c0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     3c4:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
     3c8:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
     3cc:	00130113 	andseq	r0, r3, r3, lsl r1
     3d0:	01022200 	mrseq	r2, R10_usr
     3d4:	050b0e03 	streq	r0, [fp, #-3587]	; 0xfffff1fd
     3d8:	0b3b0b3a 	bleq	ec30c8 <__bss_end+0xeb79b4>
     3dc:	13010b39 	movwne	r0, #6969	; 0x1b39
     3e0:	0d230000 	stceq	0, cr0, [r3, #-0]
     3e4:	3a080300 	bcc	200fec <__bss_end+0x1f58d8>
     3e8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     3ec:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
     3f0:	000b320b 	andeq	r3, fp, fp, lsl #4
     3f4:	00282400 	eoreq	r2, r8, r0, lsl #8
     3f8:	051c0e03 	ldreq	r0, [ip, #-3587]	; 0xfffff1fd
     3fc:	28250000 	stmdacs	r5!, {}	; <UNPREDICTABLE>
     400:	1c0e0300 	stcne	3, cr0, [lr], {-0}
     404:	26000006 	strcs	r0, [r0], -r6
     408:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     40c:	0b3b0b3a 	bleq	ec30fc <__bss_end+0xeb79e8>
     410:	13490b39 	movtne	r0, #39737	; 0x9b39
     414:	1802193f 	stmdane	r2, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
     418:	2e270000 	cdpcs	0, 2, cr0, cr7, cr0, {0}
     41c:	03193f01 	tsteq	r9, #1, 30
     420:	3b0b3a0e 	blcc	2cec60 <__bss_end+0x2c354c>
     424:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     428:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
     42c:	96184006 	ldrls	r4, [r8], -r6
     430:	13011942 	movwne	r1, #6466	; 0x1942
     434:	05280000 	streq	r0, [r8, #-0]!
     438:	3a0e0300 	bcc	381040 <__bss_end+0x37592c>
     43c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     440:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     444:	29000018 	stmdbcs	r0, {r3, r4}
     448:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     44c:	0b3b0b3a 	bleq	ec313c <__bss_end+0xeb7a28>
     450:	13490b39 	movtne	r0, #39737	; 0x9b39
     454:	00001802 	andeq	r1, r0, r2, lsl #16
     458:	11010b2a 	tstne	r1, sl, lsr #22
     45c:	00061201 	andeq	r1, r6, r1, lsl #4
     460:	00342b00 	eorseq	r2, r4, r0, lsl #22
     464:	0b3a0e03 	bleq	e83c78 <__bss_end+0xe78564>
     468:	0b39053b 	bleq	e4195c <__bss_end+0xe36248>
     46c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     470:	2e2c0000 	cdpcs	0, 2, cr0, cr12, cr0, {0}
     474:	03193f01 	tsteq	r9, #1, 30
     478:	3b0b3a0e 	blcc	2cecb8 <__bss_end+0x2c35a4>
     47c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     480:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
     484:	96184006 	ldrls	r4, [r8], -r6
     488:	13011942 	movwne	r1, #6466	; 0x1942
     48c:	342d0000 	strtcc	r0, [sp], #-0
     490:	3a080300 	bcc	201098 <__bss_end+0x1f5984>
     494:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     498:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     49c:	2e000018 	mcrcs	0, 0, r0, cr0, cr8, {0}
     4a0:	0111010b 	tsteq	r1, fp, lsl #2
     4a4:	13010612 	movwne	r0, #5650	; 0x1612
     4a8:	2e2f0000 	cdpcs	0, 2, cr0, cr15, cr0, {0}
     4ac:	03193f01 	tsteq	r9, #1, 30
     4b0:	3b0b3a0e 	blcc	2cecf0 <__bss_end+0x2c35dc>
     4b4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     4b8:	1113490e 	tstne	r3, lr, lsl #18
     4bc:	40061201 	andmi	r1, r6, r1, lsl #4
     4c0:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     4c4:	00001301 	andeq	r1, r0, r1, lsl #6
     4c8:	3f012e30 	svccc	0x00012e30
     4cc:	3a0e0319 	bcc	381138 <__bss_end+0x375a24>
     4d0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     4d4:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
     4d8:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
     4dc:	96184006 	ldrls	r4, [r8], -r6
     4e0:	00001942 	andeq	r1, r0, r2, asr #18
     4e4:	01110100 	tsteq	r1, r0, lsl #2
     4e8:	0b130e25 	bleq	4c3d84 <__bss_end+0x4b8670>
     4ec:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
     4f0:	06120111 			; <UNDEFINED> instruction: 0x06120111
     4f4:	00001710 	andeq	r1, r0, r0, lsl r7
     4f8:	0b002402 	bleq	9508 <_ZN10Generation8next_genEPS_+0x64>
     4fc:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
     500:	0300000e 	movweq	r0, #14
     504:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
     508:	0b3b0b3a 	bleq	ec31f8 <__bss_end+0xeb7ae4>
     50c:	13490b39 	movtne	r0, #39737	; 0x9b39
     510:	24040000 	strcs	r0, [r4], #-0
     514:	3e0b0b00 	vmlacc.f64	d0, d11, d0
     518:	0008030b 	andeq	r0, r8, fp, lsl #6
     51c:	01020500 	tsteq	r2, r0, lsl #10
     520:	0b0b0e03 	bleq	2c3d34 <__bss_end+0x2b8620>
     524:	0b3b0b3a 	bleq	ec3214 <__bss_end+0xeb7b00>
     528:	13010b39 	movwne	r0, #6969	; 0x1b39
     52c:	0d060000 	stceq	0, cr0, [r6, #-0]
     530:	3a0e0300 	bcc	381138 <__bss_end+0x375a24>
     534:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     538:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
     53c:	0700000b 	streq	r0, [r0, -fp]
     540:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     544:	0b3a0e03 	bleq	e83d58 <__bss_end+0xe78644>
     548:	0b390b3b 	bleq	e4323c <__bss_end+0xe37b28>
     54c:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     550:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     554:	13011364 	movwne	r1, #4964	; 0x1364
     558:	05080000 	streq	r0, [r8, #-0]
     55c:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
     560:	09000019 	stmdbeq	r0, {r0, r3, r4}
     564:	13490005 	movtne	r0, #36869	; 0x9005
     568:	2e0a0000 	cdpcs	0, 0, cr0, cr10, cr0, {0}
     56c:	03193f01 	tsteq	r9, #1, 30
     570:	3b0b3a0e 	blcc	2cedb0 <__bss_end+0x2c369c>
     574:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     578:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
     57c:	00136419 	andseq	r6, r3, r9, lsl r4
     580:	000f0b00 	andeq	r0, pc, r0, lsl #22
     584:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     588:	340c0000 	strcc	r0, [ip], #-0
     58c:	3a080300 	bcc	201194 <__bss_end+0x1f5a80>
     590:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     594:	3f13490b 	svccc	0x0013490b
     598:	00193c19 	andseq	r3, r9, r9, lsl ip
     59c:	01130d00 	tsteq	r3, r0, lsl #26
     5a0:	0b0b0e03 	bleq	2c3db4 <__bss_end+0x2b86a0>
     5a4:	0b3b0b3a 	bleq	ec3294 <__bss_end+0xeb7b80>
     5a8:	13010b39 	movwne	r0, #6969	; 0x1b39
     5ac:	0d0e0000 	stceq	0, cr0, [lr, #-0]
     5b0:	3a080300 	bcc	2011b8 <__bss_end+0x1f5aa4>
     5b4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     5b8:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
     5bc:	0f00000b 	svceq	0x0000000b
     5c0:	0e030104 	adfeqs	f0, f3, f4
     5c4:	0b0b0b3e 	bleq	2c32c4 <__bss_end+0x2b7bb0>
     5c8:	0b3a1349 	bleq	e852f4 <__bss_end+0xe79be0>
     5cc:	0b390b3b 	bleq	e432c0 <__bss_end+0xe37bac>
     5d0:	00001301 	andeq	r1, r0, r1, lsl #6
     5d4:	03002810 	movweq	r2, #2064	; 0x810
     5d8:	000b1c08 	andeq	r1, fp, r8, lsl #24
     5dc:	012e1100 			; <UNDEFINED> instruction: 0x012e1100
     5e0:	0803193f 	stmdaeq	r3, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
     5e4:	0b3b0b3a 	bleq	ec32d4 <__bss_end+0xeb7bc0>
     5e8:	0e6e0b39 	vmoveq.8	d14[5], r0
     5ec:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
     5f0:	13011364 	movwne	r1, #4964	; 0x1364
     5f4:	2e120000 	cdpcs	0, 1, cr0, cr2, cr0, {0}
     5f8:	03193f01 	tsteq	r9, #1, 30
     5fc:	3b0b3a0e 	blcc	2cee3c <__bss_end+0x2c3728>
     600:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     604:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
     608:	01136419 	tsteq	r3, r9, lsl r4
     60c:	13000013 	movwne	r0, #19
     610:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     614:	0b3a0e03 	bleq	e83e28 <__bss_end+0xe78714>
     618:	0b390b3b 	bleq	e4330c <__bss_end+0xe37bf8>
     61c:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     620:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     624:	00001364 	andeq	r1, r0, r4, ror #6
     628:	49002614 	stmdbmi	r0, {r2, r4, r9, sl, sp}
     62c:	15000013 	strne	r0, [r0, #-19]	; 0xffffffed
     630:	13490101 	movtne	r0, #37121	; 0x9101
     634:	00001301 	andeq	r1, r0, r1, lsl #6
     638:	49002116 	stmdbmi	r0, {r1, r2, r4, r8, sp}
     63c:	000b2f13 	andeq	r2, fp, r3, lsl pc
     640:	00101700 	andseq	r1, r0, r0, lsl #14
     644:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     648:	2e180000 	cdpcs	0, 1, cr0, cr8, cr0, {0}
     64c:	3a134701 	bcc	4d2258 <__bss_end+0x4c6b44>
     650:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     654:	1113640b 	tstne	r3, fp, lsl #8
     658:	40061201 	andmi	r1, r6, r1, lsl #4
     65c:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
     660:	00001301 	andeq	r1, r0, r1, lsl #6
     664:	03000519 	movweq	r0, #1305	; 0x519
     668:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
     66c:	00180219 	andseq	r0, r8, r9, lsl r2
     670:	00341a00 	eorseq	r1, r4, r0, lsl #20
     674:	0b3a0e03 	bleq	e83e88 <__bss_end+0xe78774>
     678:	0b390b3b 	bleq	e4336c <__bss_end+0xe37c58>
     67c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     680:	2e1b0000 	cdpcs	0, 1, cr0, cr11, cr0, {0}
     684:	3a134701 	bcc	4d2290 <__bss_end+0x4c6b7c>
     688:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     68c:	1113640b 	tstne	r3, fp, lsl #8
     690:	40061201 	andmi	r1, r6, r1, lsl #4
     694:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     698:	00001301 	andeq	r1, r0, r1, lsl #6
     69c:	11010b1c 	tstne	r1, ip, lsl fp
     6a0:	00061201 	andeq	r1, r6, r1, lsl #4
     6a4:	00341d00 	eorseq	r1, r4, r0, lsl #26
     6a8:	0b3a0803 	bleq	e826bc <__bss_end+0xe76fa8>
     6ac:	0b390b3b 	bleq	e433a0 <__bss_end+0xe37c8c>
     6b0:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     6b4:	051e0000 	ldreq	r0, [lr, #-0]
     6b8:	3a0e0300 	bcc	3812c0 <__bss_end+0x375bac>
     6bc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     6c0:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     6c4:	1f000018 	svcne	0x00000018
     6c8:	08030005 	stmdaeq	r3, {r0, r2}
     6cc:	0b3b0b3a 	bleq	ec33bc <__bss_end+0xeb7ca8>
     6d0:	13490b39 	movtne	r0, #39737	; 0x9b39
     6d4:	00001802 	andeq	r1, r0, r2, lsl #16
     6d8:	47012e20 	strmi	r2, [r1, -r0, lsr #28]
     6dc:	3b0b3a13 	blcc	2cef30 <__bss_end+0x2c381c>
     6e0:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
     6e4:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
     6e8:	97184006 	ldrls	r4, [r8, -r6]
     6ec:	00001942 	andeq	r1, r0, r2, asr #18
     6f0:	01110100 	tsteq	r1, r0, lsl #2
     6f4:	0b130e25 	bleq	4c3f90 <__bss_end+0x4b887c>
     6f8:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
     6fc:	01111755 	tsteq	r1, r5, asr r7
     700:	00001710 	andeq	r1, r0, r0, lsl r7
     704:	0b002402 	bleq	9714 <_Z9quicksortI10ChromosomeEvPT_ii+0xe8>
     708:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
     70c:	0300000e 	movweq	r0, #14
     710:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
     714:	0b3b0b3a 	bleq	ec3404 <__bss_end+0xeb7cf0>
     718:	13490b39 	movtne	r0, #39737	; 0x9b39
     71c:	24040000 	strcs	r0, [r4], #-0
     720:	3e0b0b00 	vmlacc.f64	d0, d11, d0
     724:	0008030b 	andeq	r0, r8, fp, lsl #6
     728:	00260500 	eoreq	r0, r6, r0, lsl #10
     72c:	00001349 	andeq	r1, r0, r9, asr #6
     730:	03010206 	movweq	r0, #4614	; 0x1206
     734:	3a0b0b0e 	bcc	2c3374 <__bss_end+0x2b7c60>
     738:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     73c:	0013010b 	andseq	r0, r3, fp, lsl #2
     740:	000d0700 	andeq	r0, sp, r0, lsl #14
     744:	0b3a0e03 	bleq	e83f58 <__bss_end+0xe78844>
     748:	0b390b3b 	bleq	e4343c <__bss_end+0xe37d28>
     74c:	0b381349 	bleq	e05478 <__bss_end+0xdf9d64>
     750:	2e080000 	cdpcs	0, 0, cr0, cr8, cr0, {0}
     754:	03193f01 	tsteq	r9, #1, 30
     758:	3b0b3a0e 	blcc	2cef98 <__bss_end+0x2c3884>
     75c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     760:	3213490e 	andscc	r4, r3, #229376	; 0x38000
     764:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     768:	00130113 	andseq	r0, r3, r3, lsl r1
     76c:	00050900 	andeq	r0, r5, r0, lsl #18
     770:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
     774:	050a0000 	streq	r0, [sl, #-0]
     778:	00134900 	andseq	r4, r3, r0, lsl #18
     77c:	012e0b00 			; <UNDEFINED> instruction: 0x012e0b00
     780:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     784:	0b3b0b3a 	bleq	ec3474 <__bss_end+0xeb7d60>
     788:	0e6e0b39 	vmoveq.8	d14[5], r0
     78c:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     790:	00001364 	andeq	r1, r0, r4, ror #6
     794:	0b000f0c 	bleq	43cc <_start-0x3c34>
     798:	0013490b 	andseq	r4, r3, fp, lsl #18
     79c:	00340d00 	eorseq	r0, r4, r0, lsl #26
     7a0:	0b3a0803 	bleq	e827b4 <__bss_end+0xe770a0>
     7a4:	0b390b3b 	bleq	e43498 <__bss_end+0xe37d84>
     7a8:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
     7ac:	0000193c 	andeq	r1, r0, ip, lsr r9
     7b0:	0301130e 	movweq	r1, #4878	; 0x130e
     7b4:	3a0b0b0e 	bcc	2c33f4 <__bss_end+0x2b7ce0>
     7b8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     7bc:	0013010b 	andseq	r0, r3, fp, lsl #2
     7c0:	000d0f00 	andeq	r0, sp, r0, lsl #30
     7c4:	0b3a0803 	bleq	e827d8 <__bss_end+0xe770c4>
     7c8:	0b390b3b 	bleq	e434bc <__bss_end+0xe37da8>
     7cc:	0b381349 	bleq	e054f8 <__bss_end+0xdf9de4>
     7d0:	2e100000 	cdpcs	0, 1, cr0, cr0, cr0, {0}
     7d4:	03193f01 	tsteq	r9, #1, 30
     7d8:	3b0b3a08 	blcc	2cf000 <__bss_end+0x2c38ec>
     7dc:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     7e0:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
     7e4:	01136419 	tsteq	r3, r9, lsl r4
     7e8:	11000013 	tstne	r0, r3, lsl r0
     7ec:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     7f0:	0b3a0e03 	bleq	e84004 <__bss_end+0xe788f0>
     7f4:	0b390b3b 	bleq	e434e8 <__bss_end+0xe37dd4>
     7f8:	0b320e6e 	bleq	c841b8 <__bss_end+0xc78aa4>
     7fc:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     800:	00001301 	andeq	r1, r0, r1, lsl #6
     804:	3f012e12 	svccc	0x00012e12
     808:	3a0e0319 	bcc	381474 <__bss_end+0x375d60>
     80c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     810:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
     814:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
     818:	00136419 	andseq	r6, r3, r9, lsl r4
     81c:	01011300 	mrseq	r1, SP_irq
     820:	13011349 	movwne	r1, #4937	; 0x1349
     824:	21140000 	tstcs	r4, r0
     828:	2f134900 	svccs	0x00134900
     82c:	1500000b 	strne	r0, [r0, #-11]
     830:	0b0b0010 	bleq	2c0878 <__bss_end+0x2b5164>
     834:	00001349 	andeq	r1, r0, r9, asr #6
     838:	03010216 	movweq	r0, #4630	; 0x1216
     83c:	3a050b0e 	bcc	14347c <__bss_end+0x137d68>
     840:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     844:	0013010b 	andseq	r0, r3, fp, lsl #2
     848:	012e1700 			; <UNDEFINED> instruction: 0x012e1700
     84c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     850:	0b3b0b3a 	bleq	ec3540 <__bss_end+0xeb7e2c>
     854:	0e6e0b39 	vmoveq.8	d14[5], r0
     858:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     85c:	00001301 	andeq	r1, r0, r1, lsl #6
     860:	03000d18 	movweq	r0, #3352	; 0xd18
     864:	3b0b3a08 	blcc	2cf08c <__bss_end+0x2c3978>
     868:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     86c:	320b3813 	andcc	r3, fp, #1245184	; 0x130000
     870:	1900000b 	stmdbne	r0, {r0, r1, r3}
     874:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     878:	0b3b0b3a 	bleq	ec3568 <__bss_end+0xeb7e54>
     87c:	13490b39 	movtne	r0, #39737	; 0x9b39
     880:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
     884:	2e1a0000 	cdpcs	0, 1, cr0, cr10, cr0, {0}
     888:	03193f01 	tsteq	r9, #1, 30
     88c:	3b0b3a0e 	blcc	2cf0cc <__bss_end+0x2c39b8>
     890:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     894:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
     898:	97184006 	ldrls	r4, [r8, -r6]
     89c:	13011942 	movwne	r1, #6466	; 0x1942
     8a0:	2f1b0000 	svccs	0x001b0000
     8a4:	49080300 	stmdbmi	r8, {r8, r9}
     8a8:	1c000013 	stcne	0, cr0, [r0], {19}
     8ac:	08030005 	stmdaeq	r3, {r0, r2}
     8b0:	0b3b0b3a 	bleq	ec35a0 <__bss_end+0xeb7e8c>
     8b4:	13490b39 	movtne	r0, #39737	; 0x9b39
     8b8:	00001802 	andeq	r1, r0, r2, lsl #16
     8bc:	0300341d 	movweq	r3, #1053	; 0x41d
     8c0:	3b0b3a0e 	blcc	2cf100 <__bss_end+0x2c39ec>
     8c4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     8c8:	00180213 	andseq	r0, r8, r3, lsl r2
     8cc:	012e1e00 			; <UNDEFINED> instruction: 0x012e1e00
     8d0:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     8d4:	0b3b0b3a 	bleq	ec35c4 <__bss_end+0xeb7eb0>
     8d8:	0e6e0b39 	vmoveq.8	d14[5], r0
     8dc:	06120111 			; <UNDEFINED> instruction: 0x06120111
     8e0:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     8e4:	00130119 	andseq	r0, r3, r9, lsl r1
     8e8:	00051f00 	andeq	r1, r5, r0, lsl #30
     8ec:	0b3a0e03 	bleq	e84100 <__bss_end+0xe789ec>
     8f0:	0b390b3b 	bleq	e435e4 <__bss_end+0xe37ed0>
     8f4:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     8f8:	0b200000 	bleq	800900 <__bss_end+0x7f51ec>
     8fc:	12011101 	andne	r1, r1, #1073741824	; 0x40000000
     900:	21000006 	tstcs	r0, r6
     904:	08030034 	stmdaeq	r3, {r2, r4, r5}
     908:	0b3b0b3a 	bleq	ec35f8 <__bss_end+0xeb7ee4>
     90c:	13490b39 	movtne	r0, #39737	; 0x9b39
     910:	00001802 	andeq	r1, r0, r2, lsl #16
     914:	47012e22 	strmi	r2, [r1, -r2, lsr #28]
     918:	3b0b3a13 	blcc	2cf16c <__bss_end+0x2c3a58>
     91c:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
     920:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
     924:	96184006 	ldrls	r4, [r8], -r6
     928:	13011942 	movwne	r1, #6466	; 0x1942
     92c:	05230000 	streq	r0, [r3, #-0]!
     930:	490e0300 	stmdbmi	lr, {r8, r9}
     934:	02193413 	andseq	r3, r9, #318767104	; 0x13000000
     938:	24000018 	strcs	r0, [r0], #-24	; 0xffffffe8
     93c:	1347012e 	movtne	r0, #28974	; 0x712e
     940:	0b3b0b3a 	bleq	ec3630 <__bss_end+0xeb7f1c>
     944:	13640b39 	cmnne	r4, #58368	; 0xe400
     948:	06120111 			; <UNDEFINED> instruction: 0x06120111
     94c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     950:	00000019 	andeq	r0, r0, r9, lsl r0
     954:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
     958:	030b130e 	movweq	r1, #45838	; 0xb30e
     95c:	110e1b0e 	tstne	lr, lr, lsl #22
     960:	10061201 	andne	r1, r6, r1, lsl #4
     964:	02000017 	andeq	r0, r0, #23
     968:	0b0b0024 	bleq	2c0a00 <__bss_end+0x2b52ec>
     96c:	0e030b3e 	vmoveq.16	d3[0], r0
     970:	26030000 	strcs	r0, [r3], -r0
     974:	00134900 	andseq	r4, r3, r0, lsl #18
     978:	00240400 	eoreq	r0, r4, r0, lsl #8
     97c:	0b3e0b0b 	bleq	f835b0 <__bss_end+0xf77e9c>
     980:	00000803 	andeq	r0, r0, r3, lsl #16
     984:	03001605 	movweq	r1, #1541	; 0x605
     988:	3b0b3a0e 	blcc	2cf1c8 <__bss_end+0x2c3ab4>
     98c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     990:	06000013 			; <UNDEFINED> instruction: 0x06000013
     994:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     998:	0b3b0b3a 	bleq	ec3688 <__bss_end+0xeb7f74>
     99c:	13490b39 	movtne	r0, #39737	; 0x9b39
     9a0:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
     9a4:	0f070000 	svceq	0x00070000
     9a8:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
     9ac:	08000013 	stmdaeq	r0, {r0, r1, r4}
     9b0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     9b4:	0b3a0e03 	bleq	e841c8 <__bss_end+0xe78ab4>
     9b8:	0b390b3b 	bleq	e436ac <__bss_end+0xe37f98>
     9bc:	01110e6e 	tsteq	r1, lr, ror #28
     9c0:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     9c4:	01194296 			; <UNDEFINED> instruction: 0x01194296
     9c8:	09000013 	stmdbeq	r0, {r0, r1, r4}
     9cc:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
     9d0:	0b3b0b3a 	bleq	ec36c0 <__bss_end+0xeb7fac>
     9d4:	13490b39 	movtne	r0, #39737	; 0x9b39
     9d8:	00001802 	andeq	r1, r0, r2, lsl #16
     9dc:	0300050a 	movweq	r0, #1290	; 0x50a
     9e0:	3b0b3a08 	blcc	2cf208 <__bss_end+0x2c3af4>
     9e4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     9e8:	00180213 	andseq	r0, r8, r3, lsl r2
     9ec:	00340b00 	eorseq	r0, r4, r0, lsl #22
     9f0:	0b3a0e03 	bleq	e84204 <__bss_end+0xe78af0>
     9f4:	0b390b3b 	bleq	e436e8 <__bss_end+0xe37fd4>
     9f8:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     9fc:	010c0000 	mrseq	r0, (UNDEF: 12)
     a00:	01134901 	tsteq	r3, r1, lsl #18
     a04:	0d000013 	stceq	0, cr0, [r0, #-76]	; 0xffffffb4
     a08:	13490021 	movtne	r0, #36897	; 0x9021
     a0c:	00000b2f 	andeq	r0, r0, pc, lsr #22
     a10:	3f012e0e 	svccc	0x00012e0e
     a14:	3a0e0319 	bcc	381680 <__bss_end+0x375f6c>
     a18:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     a1c:	110e6e0b 	tstne	lr, fp, lsl #28
     a20:	40061201 	andmi	r1, r6, r1, lsl #4
     a24:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     a28:	01000000 	mrseq	r0, (UNDEF: 0)
     a2c:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
     a30:	0e030b13 	vmoveq.32	d3[0], r0
     a34:	01110e1b 	tsteq	r1, fp, lsl lr
     a38:	17100612 			; <UNDEFINED> instruction: 0x17100612
     a3c:	24020000 	strcs	r0, [r2], #-0
     a40:	3e0b0b00 	vmlacc.f64	d0, d11, d0
     a44:	000e030b 	andeq	r0, lr, fp, lsl #6
     a48:	00260300 	eoreq	r0, r6, r0, lsl #6
     a4c:	00001349 	andeq	r1, r0, r9, asr #6
     a50:	0b002404 	bleq	9a68 <_Z9terminatei+0x28>
     a54:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
     a58:	05000008 	streq	r0, [r0, #-8]
     a5c:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
     a60:	0b3b0b3a 	bleq	ec3750 <__bss_end+0xeb803c>
     a64:	13490b39 	movtne	r0, #39737	; 0x9b39
     a68:	13060000 	movwne	r0, #24576	; 0x6000
     a6c:	0b0e0301 	bleq	381678 <__bss_end+0x375f64>
     a70:	3b0b3a0b 	blcc	2cf2a4 <__bss_end+0x2c3b90>
     a74:	010b390b 	tsteq	fp, fp, lsl #18
     a78:	07000013 	smladeq	r0, r3, r0, r0
     a7c:	0803000d 	stmdaeq	r3, {r0, r2, r3}
     a80:	0b3b0b3a 	bleq	ec3770 <__bss_end+0xeb805c>
     a84:	13490b39 	movtne	r0, #39737	; 0x9b39
     a88:	00000b38 	andeq	r0, r0, r8, lsr fp
     a8c:	03010408 	movweq	r0, #5128	; 0x1408
     a90:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
     a94:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
     a98:	3b0b3a13 	blcc	2cf2ec <__bss_end+0x2c3bd8>
     a9c:	010b390b 	tsteq	fp, fp, lsl #18
     aa0:	09000013 	stmdbeq	r0, {r0, r1, r4}
     aa4:	08030028 	stmdaeq	r3, {r3, r5}
     aa8:	00000b1c 	andeq	r0, r0, ip, lsl fp
     aac:	0300280a 	movweq	r2, #2058	; 0x80a
     ab0:	000b1c0e 	andeq	r1, fp, lr, lsl #24
     ab4:	00340b00 	eorseq	r0, r4, r0, lsl #22
     ab8:	0b3a0e03 	bleq	e842cc <__bss_end+0xe78bb8>
     abc:	0b390b3b 	bleq	e437b0 <__bss_end+0xe3809c>
     ac0:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
     ac4:	00001802 	andeq	r1, r0, r2, lsl #16
     ac8:	0300020c 	movweq	r0, #524	; 0x20c
     acc:	00193c0e 	andseq	r3, r9, lr, lsl #24
     ad0:	000f0d00 	andeq	r0, pc, r0, lsl #26
     ad4:	13490b0b 	movtne	r0, #39691	; 0x9b0b
     ad8:	0d0e0000 	stceq	0, cr0, [lr, #-0]
     adc:	3a0e0300 	bcc	3816e4 <__bss_end+0x375fd0>
     ae0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     ae4:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
     ae8:	0f00000b 	svceq	0x0000000b
     aec:	13490101 	movtne	r0, #37121	; 0x9101
     af0:	00001301 	andeq	r1, r0, r1, lsl #6
     af4:	49002110 	stmdbmi	r0, {r4, r8, sp}
     af8:	000b2f13 	andeq	r2, fp, r3, lsl pc
     afc:	01021100 	mrseq	r1, (UNDEF: 18)
     b00:	0b0b0e03 	bleq	2c4314 <__bss_end+0x2b8c00>
     b04:	0b3b0b3a 	bleq	ec37f4 <__bss_end+0xeb80e0>
     b08:	13010b39 	movwne	r0, #6969	; 0x1b39
     b0c:	2e120000 	cdpcs	0, 1, cr0, cr2, cr0, {0}
     b10:	03193f01 	tsteq	r9, #1, 30
     b14:	3b0b3a0e 	blcc	2cf354 <__bss_end+0x2c3c40>
     b18:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     b1c:	64193c0e 	ldrvs	r3, [r9], #-3086	; 0xfffff3f2
     b20:	00130113 	andseq	r0, r3, r3, lsl r1
     b24:	00051300 	andeq	r1, r5, r0, lsl #6
     b28:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
     b2c:	05140000 	ldreq	r0, [r4, #-0]
     b30:	00134900 	andseq	r4, r3, r0, lsl #18
     b34:	012e1500 			; <UNDEFINED> instruction: 0x012e1500
     b38:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     b3c:	0b3b0b3a 	bleq	ec382c <__bss_end+0xeb8118>
     b40:	0e6e0b39 	vmoveq.8	d14[5], r0
     b44:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
     b48:	13011364 	movwne	r1, #4964	; 0x1364
     b4c:	2e160000 	cdpcs	0, 1, cr0, cr6, cr0, {0}
     b50:	03193f01 	tsteq	r9, #1, 30
     b54:	3b0b3a0e 	blcc	2cf394 <__bss_end+0x2c3c80>
     b58:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     b5c:	3213490e 	andscc	r4, r3, #229376	; 0x38000
     b60:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     b64:	00130113 	andseq	r0, r3, r3, lsl r1
     b68:	000d1700 	andeq	r1, sp, r0, lsl #14
     b6c:	0b3a0e03 	bleq	e84380 <__bss_end+0xe78c6c>
     b70:	0b390b3b 	bleq	e43864 <__bss_end+0xe38150>
     b74:	0b381349 	bleq	e058a0 <__bss_end+0xdfa18c>
     b78:	00000b32 	andeq	r0, r0, r2, lsr fp
     b7c:	3f012e18 	svccc	0x00012e18
     b80:	3a0e0319 	bcc	3817ec <__bss_end+0x3760d8>
     b84:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     b88:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
     b8c:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     b90:	00130113 	andseq	r0, r3, r3, lsl r1
     b94:	012e1900 			; <UNDEFINED> instruction: 0x012e1900
     b98:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     b9c:	0b3b0b3a 	bleq	ec388c <__bss_end+0xeb8178>
     ba0:	0e6e0b39 	vmoveq.8	d14[5], r0
     ba4:	0b321349 	bleq	c858d0 <__bss_end+0xc7a1bc>
     ba8:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     bac:	151a0000 	ldrne	r0, [sl, #-0]
     bb0:	64134901 	ldrvs	r4, [r3], #-2305	; 0xfffff6ff
     bb4:	00130113 	andseq	r0, r3, r3, lsl r1
     bb8:	001f1b00 	andseq	r1, pc, r0, lsl #22
     bbc:	1349131d 	movtne	r1, #37661	; 0x931d
     bc0:	101c0000 	andsne	r0, ip, r0
     bc4:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
     bc8:	1d000013 	stcne	0, cr0, [r0, #-76]	; 0xffffffb4
     bcc:	0b0b000f 	bleq	2c0c10 <__bss_end+0x2b54fc>
     bd0:	341e0000 	ldrcc	r0, [lr], #-0
     bd4:	3a0e0300 	bcc	3817dc <__bss_end+0x3760c8>
     bd8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     bdc:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     be0:	1f000018 	svcne	0x00000018
     be4:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     be8:	0b3a0e03 	bleq	e843fc <__bss_end+0xe78ce8>
     bec:	0b390b3b 	bleq	e438e0 <__bss_end+0xe381cc>
     bf0:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     bf4:	06120111 			; <UNDEFINED> instruction: 0x06120111
     bf8:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     bfc:	00130119 	andseq	r0, r3, r9, lsl r1
     c00:	00052000 	andeq	r2, r5, r0
     c04:	0b3a0e03 	bleq	e84418 <__bss_end+0xe78d04>
     c08:	0b390b3b 	bleq	e438fc <__bss_end+0xe381e8>
     c0c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     c10:	2e210000 	cdpcs	0, 2, cr0, cr1, cr0, {0}
     c14:	03193f01 	tsteq	r9, #1, 30
     c18:	3b0b3a0e 	blcc	2cf458 <__bss_end+0x2c3d44>
     c1c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     c20:	1113490e 	tstne	r3, lr, lsl #18
     c24:	40061201 	andmi	r1, r6, r1, lsl #4
     c28:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
     c2c:	00001301 	andeq	r1, r0, r1, lsl #6
     c30:	03003422 	movweq	r3, #1058	; 0x422
     c34:	3b0b3a08 	blcc	2cf45c <__bss_end+0x2c3d48>
     c38:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     c3c:	00180213 	andseq	r0, r8, r3, lsl r2
     c40:	012e2300 			; <UNDEFINED> instruction: 0x012e2300
     c44:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     c48:	0b3b0b3a 	bleq	ec3938 <__bss_end+0xeb8224>
     c4c:	0e6e0b39 	vmoveq.8	d14[5], r0
     c50:	06120111 			; <UNDEFINED> instruction: 0x06120111
     c54:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
     c58:	00130119 	andseq	r0, r3, r9, lsl r1
     c5c:	002e2400 	eoreq	r2, lr, r0, lsl #8
     c60:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     c64:	0b3b0b3a 	bleq	ec3954 <__bss_end+0xeb8240>
     c68:	0e6e0b39 	vmoveq.8	d14[5], r0
     c6c:	06120111 			; <UNDEFINED> instruction: 0x06120111
     c70:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
     c74:	25000019 	strcs	r0, [r0, #-25]	; 0xffffffe7
     c78:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     c7c:	0b3a0e03 	bleq	e84490 <__bss_end+0xe78d7c>
     c80:	0b390b3b 	bleq	e43974 <__bss_end+0xe38260>
     c84:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     c88:	06120111 			; <UNDEFINED> instruction: 0x06120111
     c8c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
     c90:	00000019 	andeq	r0, r0, r9, lsl r0
     c94:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
     c98:	030b130e 	movweq	r1, #45838	; 0xb30e
     c9c:	110e1b0e 	tstne	lr, lr, lsl #22
     ca0:	10061201 	andne	r1, r6, r1, lsl #4
     ca4:	02000017 	andeq	r0, r0, #23
     ca8:	0b0b0024 	bleq	2c0d40 <__bss_end+0x2b562c>
     cac:	0e030b3e 	vmoveq.16	d3[0], r0
     cb0:	24030000 	strcs	r0, [r3], #-0
     cb4:	3e0b0b00 	vmlacc.f64	d0, d11, d0
     cb8:	0008030b 	andeq	r0, r8, fp, lsl #6
     cbc:	00160400 	andseq	r0, r6, r0, lsl #8
     cc0:	0b3a0e03 	bleq	e844d4 <__bss_end+0xe78dc0>
     cc4:	0b390b3b 	bleq	e439b8 <__bss_end+0xe382a4>
     cc8:	00001349 	andeq	r1, r0, r9, asr #6
     ccc:	3f012e05 	svccc	0x00012e05
     cd0:	3a0e0319 	bcc	38193c <__bss_end+0x376228>
     cd4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     cd8:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
     cdc:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
     ce0:	97184006 	ldrls	r4, [r8, -r6]
     ce4:	13011942 	movwne	r1, #6466	; 0x1942
     ce8:	05060000 	streq	r0, [r6, #-0]
     cec:	3a0e0300 	bcc	3818f4 <__bss_end+0x3761e0>
     cf0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     cf4:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     cf8:	07000018 	smladeq	r0, r8, r0, r0
     cfc:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     d00:	0b3b0b3a 	bleq	ec39f0 <__bss_end+0xeb82dc>
     d04:	13490b39 	movtne	r0, #39737	; 0x9b39
     d08:	00001802 	andeq	r1, r0, r2, lsl #16
     d0c:	0b000f08 	bleq	4934 <_start-0x36cc>
     d10:	0000000b 	andeq	r0, r0, fp
     d14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
     d18:	030b130e 	movweq	r1, #45838	; 0xb30e
     d1c:	110e1b0e 	tstne	lr, lr, lsl #22
     d20:	10061201 	andne	r1, r6, r1, lsl #4
     d24:	02000017 	andeq	r0, r0, #23
     d28:	13010139 	movwne	r0, #4409	; 0x1139
     d2c:	34030000 	strcc	r0, [r3], #-0
     d30:	3a0e0300 	bcc	381938 <__bss_end+0x376224>
     d34:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     d38:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
     d3c:	000a1c19 	andeq	r1, sl, r9, lsl ip
     d40:	003a0400 	eorseq	r0, sl, r0, lsl #8
     d44:	0b3b0b3a 	bleq	ec3a34 <__bss_end+0xeb8320>
     d48:	13180b39 	tstne	r8, #58368	; 0xe400
     d4c:	01050000 	mrseq	r0, (UNDEF: 5)
     d50:	01134901 	tsteq	r3, r1, lsl #18
     d54:	06000013 			; <UNDEFINED> instruction: 0x06000013
     d58:	13490021 	movtne	r0, #36897	; 0x9021
     d5c:	00000b2f 	andeq	r0, r0, pc, lsr #22
     d60:	49002607 	stmdbmi	r0, {r0, r1, r2, r9, sl, sp}
     d64:	08000013 	stmdaeq	r0, {r0, r1, r4}
     d68:	0b0b0024 	bleq	2c0e00 <__bss_end+0x2b56ec>
     d6c:	0e030b3e 	vmoveq.16	d3[0], r0
     d70:	34090000 	strcc	r0, [r9], #-0
     d74:	00134700 	andseq	r4, r3, r0, lsl #14
     d78:	012e0a00 			; <UNDEFINED> instruction: 0x012e0a00
     d7c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     d80:	0b3b0b3a 	bleq	ec3a70 <__bss_end+0xeb835c>
     d84:	0e6e0b39 	vmoveq.8	d14[5], r0
     d88:	06120111 			; <UNDEFINED> instruction: 0x06120111
     d8c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
     d90:	00130119 	andseq	r0, r3, r9, lsl r1
     d94:	00050b00 	andeq	r0, r5, r0, lsl #22
     d98:	0b3a0803 	bleq	e82dac <__bss_end+0xe77698>
     d9c:	0b390b3b 	bleq	e43a90 <__bss_end+0xe3837c>
     da0:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     da4:	340c0000 	strcc	r0, [ip], #-0
     da8:	3a0e0300 	bcc	3819b0 <__bss_end+0x37629c>
     dac:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     db0:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     db4:	0d000018 	stceq	0, cr0, [r0, #-96]	; 0xffffffa0
     db8:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     dbc:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
     dc0:	13490b39 	movtne	r0, #39737	; 0x9b39
     dc4:	00001802 	andeq	r1, r0, r2, lsl #16
     dc8:	11010b0e 	tstne	r1, lr, lsl #22
     dcc:	00061201 	andeq	r1, r6, r1, lsl #4
     dd0:	00340f00 	eorseq	r0, r4, r0, lsl #30
     dd4:	0b3a0803 	bleq	e82de8 <__bss_end+0xe776d4>
     dd8:	0b39053b 	bleq	e422cc <__bss_end+0xe36bb8>
     ddc:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     de0:	0f100000 	svceq	0x00100000
     de4:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
     de8:	11000013 	tstne	r0, r3, lsl r0
     dec:	00000026 	andeq	r0, r0, r6, lsr #32
     df0:	0b000f12 	bleq	4a40 <_start-0x35c0>
     df4:	1300000b 	movwne	r0, #11
     df8:	0b0b0024 	bleq	2c0e90 <__bss_end+0x2b577c>
     dfc:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
     e00:	05140000 	ldreq	r0, [r4, #-0]
     e04:	3a0e0300 	bcc	381a0c <__bss_end+0x3762f8>
     e08:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     e0c:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     e10:	15000018 	strne	r0, [r0, #-24]	; 0xffffffe8
     e14:	08030034 	stmdaeq	r3, {r2, r4, r5}
     e18:	0b3b0b3a 	bleq	ec3b08 <__bss_end+0xeb83f4>
     e1c:	13490b39 	movtne	r0, #39737	; 0x9b39
     e20:	00001802 	andeq	r1, r0, r2, lsl #16
     e24:	3f012e16 	svccc	0x00012e16
     e28:	3a0e0319 	bcc	381a94 <__bss_end+0x376380>
     e2c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     e30:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
     e34:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
     e38:	97184006 	ldrls	r4, [r8, -r6]
     e3c:	13011942 	movwne	r1, #6466	; 0x1942
     e40:	2e170000 	cdpcs	0, 1, cr0, cr7, cr0, {0}
     e44:	03193f01 	tsteq	r9, #1, 30
     e48:	3b0b3a0e 	blcc	2cf688 <__bss_end+0x2c3f74>
     e4c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     e50:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
     e54:	96184006 	ldrls	r4, [r8], -r6
     e58:	13011942 	movwne	r1, #6466	; 0x1942
     e5c:	0b180000 	bleq	600e64 <__bss_end+0x5f5750>
     e60:	12011101 	andne	r1, r1, #1073741824	; 0x40000000
     e64:	00130106 	andseq	r0, r3, r6, lsl #2
     e68:	012e1900 			; <UNDEFINED> instruction: 0x012e1900
     e6c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     e70:	0b3b0b3a 	bleq	ec3b60 <__bss_end+0xeb844c>
     e74:	0e6e0b39 	vmoveq.8	d14[5], r0
     e78:	01111349 	tsteq	r1, r9, asr #6
     e7c:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     e80:	01194296 			; <UNDEFINED> instruction: 0x01194296
     e84:	1a000013 	bne	ed8 <_start-0x7128>
     e88:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     e8c:	0b3a0e03 	bleq	e846a0 <__bss_end+0xe78f8c>
     e90:	0b390b3b 	bleq	e43b84 <__bss_end+0xe38470>
     e94:	01110e6e 	tsteq	r1, lr, ror #28
     e98:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     e9c:	00194296 	mulseq	r9, r6, r2
     ea0:	11010000 	mrsne	r0, (UNDEF: 1)
     ea4:	130e2501 	movwne	r2, #58625	; 0xe501
     ea8:	1b0e030b 	blne	381adc <__bss_end+0x3763c8>
     eac:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
     eb0:	00171006 	andseq	r1, r7, r6
     eb4:	00240200 	eoreq	r0, r4, r0, lsl #4
     eb8:	0b3e0b0b 	bleq	f83aec <__bss_end+0xf783d8>
     ebc:	00000e03 	andeq	r0, r0, r3, lsl #28
     ec0:	0b002403 	bleq	9ed4 <_Z4itoajPcj+0x2c>
     ec4:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
     ec8:	04000008 	streq	r0, [r0], #-8
     ecc:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
     ed0:	0b3b0b3a 	bleq	ec3bc0 <__bss_end+0xeb84ac>
     ed4:	13490b39 	movtne	r0, #39737	; 0x9b39
     ed8:	26050000 	strcs	r0, [r5], -r0
     edc:	00134900 	andseq	r4, r3, r0, lsl #18
     ee0:	01020600 	tsteq	r2, r0, lsl #12
     ee4:	0b0b0e03 	bleq	2c46f8 <__bss_end+0x2b8fe4>
     ee8:	0b3b0b3a 	bleq	ec3bd8 <__bss_end+0xeb84c4>
     eec:	13010b39 	movwne	r0, #6969	; 0x1b39
     ef0:	0d070000 	stceq	0, cr0, [r7, #-0]
     ef4:	3a0e0300 	bcc	381afc <__bss_end+0x3763e8>
     ef8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     efc:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
     f00:	0800000b 	stmdaeq	r0, {r0, r1, r3}
     f04:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     f08:	0b3a0e03 	bleq	e8471c <__bss_end+0xe79008>
     f0c:	0b390b3b 	bleq	e43c00 <__bss_end+0xe384ec>
     f10:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     f14:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     f18:	13011364 	movwne	r1, #4964	; 0x1364
     f1c:	05090000 	streq	r0, [r9, #-0]
     f20:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
     f24:	0a000019 	beq	f90 <_start-0x7070>
     f28:	13490005 	movtne	r0, #36869	; 0x9005
     f2c:	2e0b0000 	cdpcs	0, 0, cr0, cr11, cr0, {0}
     f30:	03193f01 	tsteq	r9, #1, 30
     f34:	3b0b3a0e 	blcc	2cf774 <__bss_end+0x2c4060>
     f38:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     f3c:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
     f40:	01136419 	tsteq	r3, r9, lsl r4
     f44:	0c000013 	stceq	0, cr0, [r0], {19}
     f48:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     f4c:	0b3a0e03 	bleq	e84760 <__bss_end+0xe7904c>
     f50:	0b390b3b 	bleq	e43c44 <__bss_end+0xe38530>
     f54:	0b320e6e 	bleq	c84914 <__bss_end+0xc79200>
     f58:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     f5c:	010d0000 	mrseq	r0, (UNDEF: 13)
     f60:	01134901 	tsteq	r3, r1, lsl #18
     f64:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
     f68:	13490021 	movtne	r0, #36897	; 0x9021
     f6c:	00000b2f 	andeq	r0, r0, pc, lsr #22
     f70:	0b000f0f 	bleq	4bb4 <_start-0x344c>
     f74:	0013490b 	andseq	r4, r3, fp, lsl #18
     f78:	012e1000 			; <UNDEFINED> instruction: 0x012e1000
     f7c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     f80:	0b3b0b3a 	bleq	ec3c70 <__bss_end+0xeb855c>
     f84:	0e6e0b39 	vmoveq.8	d14[5], r0
     f88:	0b321349 	bleq	c85cb4 <__bss_end+0xc7a5a0>
     f8c:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     f90:	34110000 	ldrcc	r0, [r1], #-0
     f94:	3a0e0300 	bcc	381b9c <__bss_end+0x376488>
     f98:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     f9c:	6c13490b 			; <UNDEFINED> instruction: 0x6c13490b
     fa0:	00180219 	andseq	r0, r8, r9, lsl r2
     fa4:	012e1200 			; <UNDEFINED> instruction: 0x012e1200
     fa8:	0b3a1347 	bleq	e85ccc <__bss_end+0xe7a5b8>
     fac:	0b390b3b 	bleq	e43ca0 <__bss_end+0xe3858c>
     fb0:	01111364 	tsteq	r1, r4, ror #6
     fb4:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     fb8:	01194296 			; <UNDEFINED> instruction: 0x01194296
     fbc:	13000013 	movwne	r0, #19
     fc0:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
     fc4:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
     fc8:	00001802 	andeq	r1, r0, r2, lsl #16
     fcc:	03000514 	movweq	r0, #1300	; 0x514
     fd0:	3b0b3a0e 	blcc	2cf810 <__bss_end+0x2c40fc>
     fd4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     fd8:	00180213 	andseq	r0, r8, r3, lsl r2
     fdc:	00341500 	eorseq	r1, r4, r0, lsl #10
     fe0:	0b3a0e03 	bleq	e847f4 <__bss_end+0xe790e0>
     fe4:	0b390b3b 	bleq	e43cd8 <__bss_end+0xe385c4>
     fe8:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     fec:	0b160000 	bleq	580ff4 <__bss_end+0x5758e0>
     ff0:	12011101 	andne	r1, r1, #1073741824	; 0x40000000
     ff4:	17000006 	strne	r0, [r0, -r6]
     ff8:	08030034 	stmdaeq	r3, {r2, r4, r5}
     ffc:	0b3b0b3a 	bleq	ec3cec <__bss_end+0xeb85d8>
    1000:	13490b39 	movtne	r0, #39737	; 0x9b39
    1004:	00001802 	andeq	r1, r0, r2, lsl #16
    1008:	47012e18 	smladmi	r1, r8, lr, r2
    100c:	3b0b3a13 	blcc	2cf860 <__bss_end+0x2c414c>
    1010:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
    1014:	010b2013 	tsteq	fp, r3, lsl r0
    1018:	19000013 	stmdbne	r0, {r0, r1, r4}
    101c:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
    1020:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
    1024:	2e1a0000 	cdpcs	0, 1, cr0, cr10, cr0, {0}
    1028:	6e133101 	mufvss	f3, f3, f1
    102c:	1113640e 	tstne	r3, lr, lsl #8
    1030:	40061201 	andmi	r1, r6, r1, lsl #4
    1034:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
    1038:	051b0000 	ldreq	r0, [fp, #-0]
    103c:	02133100 	andseq	r3, r3, #0, 2
    1040:	00000018 	andeq	r0, r0, r8, lsl r0
    1044:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
    1048:	030b130e 	movweq	r1, #45838	; 0xb30e
    104c:	110e1b0e 	tstne	lr, lr, lsl #22
    1050:	10061201 	andne	r1, r6, r1, lsl #4
    1054:	02000017 	andeq	r0, r0, #23
    1058:	0b0b0024 	bleq	2c10f0 <__bss_end+0x2b59dc>
    105c:	0e030b3e 	vmoveq.16	d3[0], r0
    1060:	16030000 	strne	r0, [r3], -r0
    1064:	3a0e0300 	bcc	381c6c <__bss_end+0x376558>
    1068:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    106c:	0013490b 	andseq	r4, r3, fp, lsl #18
    1070:	00240400 	eoreq	r0, r4, r0, lsl #8
    1074:	0b3e0b0b 	bleq	f83ca8 <__bss_end+0xf78594>
    1078:	00000803 	andeq	r0, r0, r3, lsl #16
    107c:	49002605 	stmdbmi	r0, {r0, r2, r9, sl, sp}
    1080:	06000013 			; <UNDEFINED> instruction: 0x06000013
    1084:	0e030102 	adfeqs	f0, f3, f2
    1088:	0b3a0b0b 	bleq	e83cbc <__bss_end+0xe785a8>
    108c:	0b390b3b 	bleq	e43d80 <__bss_end+0xe3866c>
    1090:	00001301 	andeq	r1, r0, r1, lsl #6
    1094:	03000d07 	movweq	r0, #3335	; 0xd07
    1098:	3b0b3a0e 	blcc	2cf8d8 <__bss_end+0x2c41c4>
    109c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    10a0:	000b3813 	andeq	r3, fp, r3, lsl r8
    10a4:	012e0800 			; <UNDEFINED> instruction: 0x012e0800
    10a8:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
    10ac:	0b3b0b3a 	bleq	ec3d9c <__bss_end+0xeb8688>
    10b0:	0e6e0b39 	vmoveq.8	d14[5], r0
    10b4:	0b321349 	bleq	c85de0 <__bss_end+0xc7a6cc>
    10b8:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
    10bc:	00001301 	andeq	r1, r0, r1, lsl #6
    10c0:	49000509 	stmdbmi	r0, {r0, r3, r8, sl}
    10c4:	00193413 	andseq	r3, r9, r3, lsl r4
    10c8:	00050a00 	andeq	r0, r5, r0, lsl #20
    10cc:	00001349 	andeq	r1, r0, r9, asr #6
    10d0:	3f012e0b 	svccc	0x00012e0b
    10d4:	3a0e0319 	bcc	381d40 <__bss_end+0x37662c>
    10d8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    10dc:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
    10e0:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
    10e4:	0c000013 	stceq	0, cr0, [r0], {19}
    10e8:	0b0b000f 	bleq	2c112c <__bss_end+0x2b5a18>
    10ec:	00001349 	andeq	r1, r0, r9, asr #6
    10f0:	0300340d 	movweq	r3, #1037	; 0x40d
    10f4:	3b0b3a08 	blcc	2cf91c <__bss_end+0x2c4208>
    10f8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    10fc:	3c193f13 	ldccc	15, cr3, [r9], {19}
    1100:	0e000019 	mcreq	0, 0, r0, cr0, cr9, {0}
    1104:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
    1108:	0b3a0b0b 	bleq	e83d3c <__bss_end+0xe78628>
    110c:	0b390b3b 	bleq	e43e00 <__bss_end+0xe386ec>
    1110:	00001301 	andeq	r1, r0, r1, lsl #6
    1114:	03000d0f 	movweq	r0, #3343	; 0xd0f
    1118:	3b0b3a08 	blcc	2cf940 <__bss_end+0x2c422c>
    111c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    1120:	000b3813 	andeq	r3, fp, r3, lsl r8
    1124:	01041000 	mrseq	r1, (UNDEF: 4)
    1128:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
    112c:	0b0b0b3e 	bleq	2c3e2c <__bss_end+0x2b8718>
    1130:	0b3a1349 	bleq	e85e5c <__bss_end+0xe7a748>
    1134:	0b390b3b 	bleq	e43e28 <__bss_end+0xe38714>
    1138:	00001301 	andeq	r1, r0, r1, lsl #6
    113c:	03002811 	movweq	r2, #2065	; 0x811
    1140:	000b1c0e 	andeq	r1, fp, lr, lsl #24
    1144:	00341200 	eorseq	r1, r4, r0, lsl #4
    1148:	0b3a0e03 	bleq	e8495c <__bss_end+0xe79248>
    114c:	0b390b3b 	bleq	e43e40 <__bss_end+0xe3872c>
    1150:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
    1154:	00001802 	andeq	r1, r0, r2, lsl #16
    1158:	03000213 	movweq	r0, #531	; 0x213
    115c:	00193c0e 	andseq	r3, r9, lr, lsl #24
    1160:	00281400 	eoreq	r1, r8, r0, lsl #8
    1164:	0b1c0803 	bleq	703178 <__bss_end+0x6f7a64>
    1168:	01150000 	tsteq	r5, r0
    116c:	01134901 	tsteq	r3, r1, lsl #18
    1170:	16000013 			; <UNDEFINED> instruction: 0x16000013
    1174:	13490021 	movtne	r0, #36897	; 0x9021
    1178:	00000b2f 	andeq	r0, r0, pc, lsr #22
    117c:	3f012e17 	svccc	0x00012e17
    1180:	3a0e0319 	bcc	381dec <__bss_end+0x3766d8>
    1184:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1188:	3c0e6e0b 	stccc	14, cr6, [lr], {11}
    118c:	01136419 	tsteq	r3, r9, lsl r4
    1190:	18000013 	stmdane	r0, {r0, r1, r4}
    1194:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
    1198:	0b3a0e03 	bleq	e849ac <__bss_end+0xe79298>
    119c:	0b390b3b 	bleq	e43e90 <__bss_end+0xe3877c>
    11a0:	13490e6e 	movtne	r0, #40558	; 0x9e6e
    11a4:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
    11a8:	00001301 	andeq	r1, r0, r1, lsl #6
    11ac:	03000d19 	movweq	r0, #3353	; 0xd19
    11b0:	3b0b3a0e 	blcc	2cf9f0 <__bss_end+0x2c42dc>
    11b4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    11b8:	320b3813 	andcc	r3, fp, #1245184	; 0x130000
    11bc:	1a00000b 	bne	11f0 <_start-0x6e10>
    11c0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
    11c4:	0b3a0e03 	bleq	e849d8 <__bss_end+0xe792c4>
    11c8:	0b390b3b 	bleq	e43ebc <__bss_end+0xe387a8>
    11cc:	0b320e6e 	bleq	c84b8c <__bss_end+0xc79478>
    11d0:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
    11d4:	00001301 	andeq	r1, r0, r1, lsl #6
    11d8:	3f012e1b 	svccc	0x00012e1b
    11dc:	3a0e0319 	bcc	381e48 <__bss_end+0x376734>
    11e0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    11e4:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
    11e8:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
    11ec:	00136419 	andseq	r6, r3, r9, lsl r4
    11f0:	01151c00 	tsteq	r5, r0, lsl #24
    11f4:	13641349 	cmnne	r4, #603979777	; 0x24000001
    11f8:	00001301 	andeq	r1, r0, r1, lsl #6
    11fc:	1d001f1d 	stcne	15, cr1, [r0, #-116]	; 0xffffff8c
    1200:	00134913 	andseq	r4, r3, r3, lsl r9
    1204:	00101e00 	andseq	r1, r0, r0, lsl #28
    1208:	13490b0b 	movtne	r0, #39691	; 0x9b0b
    120c:	0f1f0000 	svceq	0x001f0000
    1210:	000b0b00 	andeq	r0, fp, r0, lsl #22
    1214:	00342000 	eorseq	r2, r4, r0
    1218:	0b3a1347 	bleq	e85f3c <__bss_end+0xe7a828>
    121c:	0b390b3b 	bleq	e43f10 <__bss_end+0xe387fc>
    1220:	00001802 	andeq	r1, r0, r2, lsl #16
    1224:	47012e21 	strmi	r2, [r1, -r1, lsr #28]
    1228:	3b0b3a13 	blcc	2cfa7c <__bss_end+0x2c4368>
    122c:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
    1230:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
    1234:	97184006 	ldrls	r4, [r8, -r6]
    1238:	13011942 	movwne	r1, #6466	; 0x1942
    123c:	05220000 	streq	r0, [r2, #-0]!
    1240:	490e0300 	stmdbmi	lr, {r8, r9}
    1244:	02193413 	andseq	r3, r9, #318767104	; 0x13000000
    1248:	23000018 	movwcs	r0, #24
    124c:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
    1250:	0b3b0b3a 	bleq	ec3f40 <__bss_end+0xeb882c>
    1254:	13490b39 	movtne	r0, #39737	; 0x9b39
    1258:	00001802 	andeq	r1, r0, r2, lsl #16
    125c:	47012e24 	strmi	r2, [r1, -r4, lsr #28]
    1260:	3b0b3a13 	blcc	2cfab4 <__bss_end+0x2c43a0>
    1264:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
    1268:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
    126c:	96184006 	ldrls	r4, [r8], -r6
    1270:	13011942 	movwne	r1, #6466	; 0x1942
    1274:	05250000 	streq	r0, [r5, #-0]!
    1278:	3a080300 	bcc	201e80 <__bss_end+0x1f676c>
    127c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1280:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
    1284:	26000018 			; <UNDEFINED> instruction: 0x26000018
    1288:	08030034 	stmdaeq	r3, {r2, r4, r5}
    128c:	0b3b0b3a 	bleq	ec3f7c <__bss_end+0xeb8868>
    1290:	13490b39 	movtne	r0, #39737	; 0x9b39
    1294:	00001802 	andeq	r1, r0, r2, lsl #16
    1298:	03003427 	movweq	r3, #1063	; 0x427
    129c:	3b0b3a0e 	blcc	2cfadc <__bss_end+0x2c43c8>
    12a0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    12a4:	00180213 	andseq	r0, r8, r3, lsl r2
    12a8:	012e2800 			; <UNDEFINED> instruction: 0x012e2800
    12ac:	0b3a1347 	bleq	e85fd0 <__bss_end+0xe7a8bc>
    12b0:	0b390b3b 	bleq	e43fa4 <__bss_end+0xe38890>
    12b4:	01111364 	tsteq	r1, r4, ror #6
    12b8:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
    12bc:	00194296 	mulseq	r9, r6, r2
    12c0:	11010000 	mrsne	r0, (UNDEF: 1)
    12c4:	130e2501 	movwne	r2, #58625	; 0xe501
    12c8:	1b0e030b 	blne	381efc <__bss_end+0x3767e8>
    12cc:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
    12d0:	00171006 	andseq	r1, r7, r6
    12d4:	00240200 	eoreq	r0, r4, r0, lsl #4
    12d8:	0b3e0b0b 	bleq	f83f0c <__bss_end+0xf787f8>
    12dc:	00000e03 	andeq	r0, r0, r3, lsl #28
    12e0:	0b002403 	bleq	a2f4 <_Z4atofPKc+0x80>
    12e4:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
    12e8:	04000008 	streq	r0, [r0], #-8
    12ec:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
    12f0:	0b3b0b3a 	bleq	ec3fe0 <__bss_end+0xeb88cc>
    12f4:	13490b39 	movtne	r0, #39737	; 0x9b39
    12f8:	02050000 	andeq	r0, r5, #0
    12fc:	0b0e0301 	bleq	381f08 <__bss_end+0x3767f4>
    1300:	3b0b3a0b 	blcc	2cfb34 <__bss_end+0x2c4420>
    1304:	010b390b 	tsteq	fp, fp, lsl #18
    1308:	06000013 			; <UNDEFINED> instruction: 0x06000013
    130c:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
    1310:	0b3b0b3a 	bleq	ec4000 <__bss_end+0xeb88ec>
    1314:	13490b39 	movtne	r0, #39737	; 0x9b39
    1318:	00000b38 	andeq	r0, r0, r8, lsr fp
    131c:	3f012e07 	svccc	0x00012e07
    1320:	3a0e0319 	bcc	381f8c <__bss_end+0x376878>
    1324:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1328:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
    132c:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
    1330:	01136419 	tsteq	r3, r9, lsl r4
    1334:	08000013 	stmdaeq	r0, {r0, r1, r4}
    1338:	13490005 	movtne	r0, #36869	; 0x9005
    133c:	00001934 	andeq	r1, r0, r4, lsr r9
    1340:	49000509 	stmdbmi	r0, {r0, r3, r8, sl}
    1344:	0a000013 	beq	1398 <_start-0x6c68>
    1348:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
    134c:	0b3a0e03 	bleq	e84b60 <__bss_end+0xe7944c>
    1350:	0b390b3b 	bleq	e44044 <__bss_end+0xe38930>
    1354:	0b320e6e 	bleq	c84d14 <__bss_end+0xc79600>
    1358:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
    135c:	00001301 	andeq	r1, r0, r1, lsl #6
    1360:	3f012e0b 	svccc	0x00012e0b
    1364:	3a0e0319 	bcc	381fd0 <__bss_end+0x3768bc>
    1368:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    136c:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
    1370:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
    1374:	0c000013 	stceq	0, cr0, [r0], {19}
    1378:	13490101 	movtne	r0, #37121	; 0x9101
    137c:	00001301 	andeq	r1, r0, r1, lsl #6
    1380:	4900210d 	stmdbmi	r0, {r0, r2, r3, r8, sp}
    1384:	000b2f13 	andeq	r2, fp, r3, lsl pc
    1388:	000f0e00 	andeq	r0, pc, r0, lsl #28
    138c:	13490b0b 	movtne	r0, #39691	; 0x9b0b
    1390:	260f0000 	strcs	r0, [pc], -r0
    1394:	00134900 	andseq	r4, r3, r0, lsl #18
    1398:	012e1000 			; <UNDEFINED> instruction: 0x012e1000
    139c:	0b3a1347 	bleq	e860c0 <__bss_end+0xe7a9ac>
    13a0:	0b390b3b 	bleq	e44094 <__bss_end+0xe38980>
    13a4:	01111364 	tsteq	r1, r4, ror #6
    13a8:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
    13ac:	01194297 			; <UNDEFINED> instruction: 0x01194297
    13b0:	11000013 	tstne	r0, r3, lsl r0
    13b4:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
    13b8:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
    13bc:	00001802 	andeq	r1, r0, r2, lsl #16
    13c0:	03000512 	movweq	r0, #1298	; 0x512
    13c4:	3b0b3a0e 	blcc	2cfc04 <__bss_end+0x2c44f0>
    13c8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    13cc:	00180213 	andseq	r0, r8, r3, lsl r2
    13d0:	012e1300 			; <UNDEFINED> instruction: 0x012e1300
    13d4:	0b3a1347 	bleq	e860f8 <__bss_end+0xe7a9e4>
    13d8:	0b390b3b 	bleq	e440cc <__bss_end+0xe389b8>
    13dc:	01111364 	tsteq	r1, r4, ror #6
    13e0:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
    13e4:	01194296 			; <UNDEFINED> instruction: 0x01194296
    13e8:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
    13ec:	08030005 	stmdaeq	r3, {r0, r2}
    13f0:	0b3b0b3a 	bleq	ec40e0 <__bss_end+0xeb89cc>
    13f4:	13490b39 	movtne	r0, #39737	; 0x9b39
    13f8:	00001802 	andeq	r1, r0, r2, lsl #16
    13fc:	11010b15 	tstne	r1, r5, lsl fp
    1400:	00061201 	andeq	r1, r6, r1, lsl #4
    1404:	00341600 	eorseq	r1, r4, r0, lsl #12
    1408:	0b3a0803 	bleq	e8341c <__bss_end+0xe77d08>
    140c:	0b390b3b 	bleq	e44100 <__bss_end+0xe389ec>
    1410:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
    1414:	34170000 	ldrcc	r0, [r7], #-0
    1418:	3a0e0300 	bcc	382020 <__bss_end+0x37690c>
    141c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1420:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
    1424:	18000018 	stmdane	r0, {r3, r4}
    1428:	1347012e 	movtne	r0, #28974	; 0x712e
    142c:	0b3b0b3a 	bleq	ec411c <__bss_end+0xeb8a08>
    1430:	13640b39 	cmnne	r4, #58368	; 0xe400
    1434:	13010b20 	movwne	r0, #6944	; 0x1b20
    1438:	05190000 	ldreq	r0, [r9, #-0]
    143c:	490e0300 	stmdbmi	lr, {r8, r9}
    1440:	00193413 	andseq	r3, r9, r3, lsl r4
    1444:	012e1a00 			; <UNDEFINED> instruction: 0x012e1a00
    1448:	0e6e1331 	mcreq	3, 3, r1, cr14, cr1, {1}
    144c:	01111364 	tsteq	r1, r4, ror #6
    1450:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
    1454:	00194296 	mulseq	r9, r6, r2
    1458:	00051b00 	andeq	r1, r5, r0, lsl #22
    145c:	18021331 	stmdane	r2, {r0, r4, r5, r8, r9, ip}
    1460:	01000000 	mrseq	r0, (UNDEF: 0)
    1464:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
    1468:	0e030b13 	vmoveq.32	d3[0], r0
    146c:	01110e1b 	tsteq	r1, fp, lsl lr
    1470:	17100612 			; <UNDEFINED> instruction: 0x17100612
    1474:	24020000 	strcs	r0, [r2], #-0
    1478:	3e0b0b00 	vmlacc.f64	d0, d11, d0
    147c:	0008030b 	andeq	r0, r8, fp, lsl #6
    1480:	00160300 	andseq	r0, r6, r0, lsl #6
    1484:	0b3a0e03 	bleq	e84c98 <__bss_end+0xe79584>
    1488:	0b390b3b 	bleq	e4417c <__bss_end+0xe38a68>
    148c:	00001349 	andeq	r1, r0, r9, asr #6
    1490:	0b002404 	bleq	a4a8 <_Z4atofPKc+0x234>
    1494:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
    1498:	0500000e 	streq	r0, [r0, #-14]
    149c:	13490026 	movtne	r0, #36902	; 0x9026
    14a0:	0f060000 	svceq	0x00060000
    14a4:	000b0b00 	andeq	r0, fp, r0, lsl #22
    14a8:	00370700 	eorseq	r0, r7, r0, lsl #14
    14ac:	00001349 	andeq	r1, r0, r9, asr #6
    14b0:	0b000f08 	bleq	50d8 <_start-0x2f28>
    14b4:	0013490b 	andseq	r4, r3, fp, lsl #18
    14b8:	00260900 	eoreq	r0, r6, r0, lsl #18
    14bc:	2e0a0000 	cdpcs	0, 0, cr0, cr10, cr0, {0}
    14c0:	03193f01 	tsteq	r9, #1, 30
    14c4:	3b0b3a0e 	blcc	2cfd04 <__bss_end+0x2c45f0>
    14c8:	270b390b 	strcs	r3, [fp, -fp, lsl #18]
    14cc:	11134919 	tstne	r3, r9, lsl r9
    14d0:	40061201 	andmi	r1, r6, r1, lsl #4
    14d4:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
    14d8:	00001301 	andeq	r1, r0, r1, lsl #6
    14dc:	0300050b 	movweq	r0, #1291	; 0x50b
    14e0:	3b0b3a0e 	blcc	2cfd20 <__bss_end+0x2c460c>
    14e4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    14e8:	00180213 	andseq	r0, r8, r3, lsl r2
    14ec:	00050c00 	andeq	r0, r5, r0, lsl #24
    14f0:	0b3a0e03 	bleq	e84d04 <__bss_end+0xe795f0>
    14f4:	0b390b3b 	bleq	e441e8 <__bss_end+0xe38ad4>
    14f8:	17021349 	strne	r1, [r2, -r9, asr #6]
    14fc:	001742b7 			; <UNDEFINED> instruction: 0x001742b7
    1500:	00340d00 	eorseq	r0, r4, r0, lsl #26
    1504:	0b3a0803 	bleq	e83518 <__bss_end+0xe77e04>
    1508:	0b390b3b 	bleq	e441fc <__bss_end+0xe38ae8>
    150c:	17021349 	strne	r1, [r2, -r9, asr #6]
    1510:	001742b7 			; <UNDEFINED> instruction: 0x001742b7
    1514:	00340e00 	eorseq	r0, r4, r0, lsl #28
    1518:	0b3a0e03 	bleq	e84d2c <__bss_end+0xe79618>
    151c:	0b390b3b 	bleq	e44210 <__bss_end+0xe38afc>
    1520:	17021349 	strne	r1, [r2, -r9, asr #6]
    1524:	001742b7 			; <UNDEFINED> instruction: 0x001742b7
	...

Disassembly of section .debug_aranges:

00000000 <.debug_aranges>:
   0:	0000001c 	andeq	r0, r0, ip, lsl r0
   4:	00000002 	andeq	r0, r0, r2
   8:	00040000 	andeq	r0, r4, r0
   c:	00000000 	andeq	r0, r0, r0
  10:	00008000 	andeq	r8, r0, r0
  14:	00000008 	andeq	r0, r0, r8
	...
  20:	0000001c 	andeq	r0, r0, ip, lsl r0
  24:	00260002 	eoreq	r0, r6, r2
  28:	00040000 	andeq	r0, r4, r0
  2c:	00000000 	andeq	r0, r0, r0
  30:	00008008 	andeq	r8, r0, r8
  34:	0000009c 	muleq	r0, ip, r0
	...
  40:	0000001c 	andeq	r0, r0, ip, lsl r0
  44:	00ce0002 	sbceq	r0, lr, r2
  48:	00040000 	andeq	r0, r4, r0
  4c:	00000000 	andeq	r0, r0, r0
  50:	000080a4 	andeq	r8, r0, r4, lsr #1
  54:	00000188 	andeq	r0, r0, r8, lsl #3
	...
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	02d40002 	sbcseq	r0, r4, #2
  68:	00040000 	andeq	r0, r4, r0
  6c:	00000000 	andeq	r0, r0, r0
  70:	00008230 	andeq	r8, r0, r0, lsr r2
  74:	00000b70 	andeq	r0, r0, r0, ror fp
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	14310002 	ldrtne	r0, [r1], #-2
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	00008da0 	andeq	r8, r0, r0, lsr #27
  94:	000004bc 			; <UNDEFINED> instruction: 0x000004bc
	...
  a0:	0000002c 	andeq	r0, r0, ip, lsr #32
  a4:	1a180002 	bne	6000b4 <__bss_end+0x5f49a0>
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	0000925c 	andeq	r9, r0, ip, asr r2
  b4:	000003d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
  b8:	0000962c 	andeq	r9, r0, ip, lsr #12
  bc:	00000258 	andeq	r0, r0, r8, asr r2
  c0:	00009884 	andeq	r9, r0, r4, lsl #17
  c4:	00000078 	andeq	r0, r0, r8, ror r0
	...
  d0:	0000001c 	andeq	r0, r0, ip, lsl r0
  d4:	21780002 	cmncs	r8, r2
  d8:	00040000 	andeq	r0, r4, r0
  dc:	00000000 	andeq	r0, r0, r0
  e0:	000098fc 	strdeq	r9, [r0], -ip
  e4:	00000118 	andeq	r0, r0, r8, lsl r1
	...
  f0:	0000001c 	andeq	r0, r0, ip, lsl r0
  f4:	23ca0002 	biccs	r0, sl, #2
  f8:	00040000 	andeq	r0, r4, r0
  fc:	00000000 	andeq	r0, r0, r0
 100:	00009a14 	andeq	r9, r0, r4, lsl sl
 104:	0000045c 	andeq	r0, r0, ip, asr r4
	...
 110:	0000001c 	andeq	r0, r0, ip, lsl r0
 114:	2f730002 	svccs	0x00730002
 118:	00040000 	andeq	r0, r4, r0
 11c:	00000000 	andeq	r0, r0, r0
 120:	00009e70 	andeq	r9, r0, r0, ror lr
 124:	00000038 	andeq	r0, r0, r8, lsr r0
	...
 130:	0000001c 	andeq	r0, r0, ip, lsl r0
 134:	300e0002 	andcc	r0, lr, r2
 138:	00040000 	andeq	r0, r4, r0
 13c:	00000000 	andeq	r0, r0, r0
 140:	00009ea8 	andeq	r9, r0, r8, lsr #29
 144:	00000c38 	andeq	r0, r0, r8, lsr ip
	...
 150:	0000001c 	andeq	r0, r0, ip, lsl r0
 154:	358b0002 	strcc	r0, [fp, #2]
 158:	00040000 	andeq	r0, r4, r0
 15c:	00000000 	andeq	r0, r0, r0
 160:	0000aae0 	andeq	sl, r0, r0, ror #21
 164:	000001c8 	andeq	r0, r0, r8, asr #3
	...
 170:	0000001c 	andeq	r0, r0, ip, lsl r0
 174:	39380002 	ldmdbcc	r8!, {r1}
 178:	00040000 	andeq	r0, r4, r0
 17c:	00000000 	andeq	r0, r0, r0
 180:	0000aca8 	andeq	sl, r0, r8, lsr #25
 184:	00000134 	andeq	r0, r0, r4, lsr r1
	...
 190:	0000001c 	andeq	r0, r0, ip, lsl r0
 194:	41940002 	orrsmi	r0, r4, r2
 198:	00040000 	andeq	r0, r4, r0
 19c:	00000000 	andeq	r0, r0, r0
 1a0:	0000addc 	ldrdeq	sl, [r0], -ip
 1a4:	00000334 	andeq	r0, r0, r4, lsr r3
	...
 1b0:	0000001c 	andeq	r0, r0, ip, lsl r0
 1b4:	44ed0002 	strbtmi	r0, [sp], #2
 1b8:	00040000 	andeq	r0, r4, r0
 1bc:	00000000 	andeq	r0, r0, r0
 1c0:	0000b2d8 	ldrdeq	fp, [r0], -r8
 1c4:	0000011c 	andeq	r0, r0, ip, lsl r1
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
       4:	752f632f 	strvc	r6, [pc, #-815]!	; fffffcdd <__bss_end+0xffff45c9>
       8:	2f726573 	svccs	0x00726573
       c:	76697270 			; <UNDEFINED> instruction: 0x76697270
      10:	57657461 	strbpl	r7, [r5, -r1, ror #8]!
      14:	736b726f 	cmnvc	fp, #-268435450	; 0xf0000006
      18:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
      1c:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
      20:	2f6c6f6f 	svccs	0x006c6f6f
      24:	532f534f 			; <UNDEFINED> instruction: 0x532f534f
      28:	494b2f50 	stmdbmi	fp, {r4, r6, r8, r9, sl, fp, sp}^
      2c:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
      30:	732f534f 			; <UNDEFINED> instruction: 0x732f534f
      34:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
      38:	752f7365 	strvc	r7, [pc, #-869]!	; fffffcdb <__bss_end+0xffff45c7>
      3c:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
      40:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
      44:	7472632f 	ldrbtvc	r6, [r2], #-815	; 0xfffffcd1
      48:	00732e30 	rsbseq	r2, r3, r0, lsr lr
      4c:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
      50:	752f632f 	strvc	r6, [pc, #-815]!	; fffffd29 <__bss_end+0xffff4615>
      54:	2f726573 	svccs	0x00726573
      58:	76697270 			; <UNDEFINED> instruction: 0x76697270
      5c:	57657461 	strbpl	r7, [r5, -r1, ror #8]!
      60:	736b726f 	cmnvc	fp, #-268435450	; 0xf0000006
      64:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
      68:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
      6c:	2f6c6f6f 	svccs	0x006c6f6f
      70:	532f534f 			; <UNDEFINED> instruction: 0x532f534f
      74:	494b2f50 	stmdbmi	fp, {r4, r6, r8, r9, sl, fp, sp}^
      78:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
      7c:	732f534f 			; <UNDEFINED> instruction: 0x732f534f
      80:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
      84:	752f7365 	strvc	r7, [pc, #-869]!	; fffffd27 <__bss_end+0xffff4613>
      88:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
      8c:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
      90:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
      94:	4700646c 	strmi	r6, [r0, -ip, ror #8]
      98:	4120554e 			; <UNDEFINED> instruction: 0x4120554e
      9c:	2e322053 	mrccs	0, 1, r2, cr2, cr3, {2}
      a0:	5f003733 	svcpl	0x00003733
      a4:	7472635f 	ldrbtvc	r6, [r2], #-863	; 0xfffffca1
      a8:	6e695f30 	mcrvs	15, 3, r5, cr9, cr0, {1}
      ac:	625f7469 	subsvs	r7, pc, #1761607680	; 0x69000000
      b0:	5f007373 	svcpl	0x00007373
      b4:	7373625f 	cmnvc	r3, #-268435451	; 0xf0000005
      b8:	646e655f 	strbtvs	r6, [lr], #-1375	; 0xfffffaa1
      bc:	73657200 	cmnvc	r5, #0, 4
      c0:	00746c75 	rsbseq	r6, r4, r5, ror ip
      c4:	73625f5f 	cmnvc	r2, #380	; 0x17c
      c8:	74735f73 	ldrbtvc	r5, [r3], #-3955	; 0xfffff08d
      cc:	00747261 	rsbseq	r7, r4, r1, ror #4
      d0:	20554e47 	subscs	r4, r5, r7, asr #28
      d4:	20373143 	eorscs	r3, r7, r3, asr #2
      d8:	332e3031 			; <UNDEFINED> instruction: 0x332e3031
      dc:	2d20302e 	stccs	0, cr3, [r0, #-184]!	; 0xffffff48
      e0:	6f6c666d 	svcvs	0x006c666d
      e4:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
      e8:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
      ec:	20647261 	rsbcs	r7, r4, r1, ror #4
      f0:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
      f4:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
      f8:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
      fc:	616f6c66 	cmnvs	pc, r6, ror #24
     100:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
     104:	61683d69 	cmnvs	r8, r9, ror #26
     108:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
     10c:	7570666d 	ldrbvc	r6, [r0, #-1645]!	; 0xfffff993
     110:	7066763d 	rsbvc	r7, r6, sp, lsr r6
     114:	746d2d20 	strbtvc	r2, [sp], #-3360	; 0xfffff2e0
     118:	3d656e75 	stclcc	14, cr6, [r5, #-468]!	; 0xfffffe2c
     11c:	316d7261 	cmncc	sp, r1, ror #4
     120:	6a363731 	bvs	d8ddec <__bss_end+0xd826d8>
     124:	732d667a 			; <UNDEFINED> instruction: 0x732d667a
     128:	616d2d20 	cmnvs	sp, r0, lsr #26
     12c:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
     130:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
     134:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
     138:	7a36766d 	bvc	d9daf4 <__bss_end+0xd923e0>
     13c:	70662b6b 	rsbvc	r2, r6, fp, ror #22
     140:	20672d20 	rsbcs	r2, r7, r0, lsr #26
     144:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
     148:	2d20304f 	stccs	0, cr3, [r0, #-316]!	; 0xfffffec4
     14c:	2f00304f 	svccs	0x0000304f
     150:	2f746e6d 	svccs	0x00746e6d
     154:	73752f63 	cmnvc	r5, #396	; 0x18c
     158:	702f7265 	eorvc	r7, pc, r5, ror #4
     15c:	61766972 	cmnvs	r6, r2, ror r9
     160:	6f576574 	svcvs	0x00576574
     164:	70736b72 	rsbsvc	r6, r3, r2, ror fp
     168:	2f656361 	svccs	0x00656361
     16c:	6f686353 	svcvs	0x00686353
     170:	4f2f6c6f 	svcmi	0x002f6c6f
     174:	50532f53 	subspl	r2, r3, r3, asr pc
     178:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
     17c:	4f54522d 	svcmi	0x0054522d
     180:	6f732f53 	svcvs	0x00732f53
     184:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     188:	73752f73 	cmnvc	r5, #460	; 0x1cc
     18c:	70737265 	rsbsvc	r7, r3, r5, ror #4
     190:	2f656361 	svccs	0x00656361
     194:	30747263 	rsbscc	r7, r4, r3, ror #4
     198:	5f00632e 	svcpl	0x0000632e
     19c:	7472635f 	ldrbtvc	r6, [r2], #-863	; 0xfffffca1
     1a0:	75725f30 	ldrbvc	r5, [r2, #-3888]!	; 0xfffff0d0
     1a4:	5f5f006e 	svcpl	0x005f006e
     1a8:	72617567 	rsbvc	r7, r1, #432013312	; 0x19c00000
     1ac:	5f5f0064 	svcpl	0x005f0064
     1b0:	62616561 	rsbvs	r6, r1, #406847488	; 0x18400000
     1b4:	6e755f69 	cdpvs	15, 7, cr5, cr5, cr9, {3}
     1b8:	646e6977 	strbtvs	r6, [lr], #-2423	; 0xfffff689
     1bc:	7070635f 	rsbsvc	r6, r0, pc, asr r3
     1c0:	3172705f 	cmncc	r2, pc, asr r0
     1c4:	70635f00 	rsbvc	r5, r3, r0, lsl #30
     1c8:	68735f70 	ldmdavs	r3!, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     1cc:	6f647475 	svcvs	0x00647475
     1d0:	66006e77 			; <UNDEFINED> instruction: 0x66006e77
     1d4:	7274706e 	rsbsvc	r7, r4, #110	; 0x6e
     1d8:	635f5f00 	cmpvs	pc, #0, 30
     1dc:	62617878 	rsbvs	r7, r1, #120, 16	; 0x780000
     1e0:	00317669 	eorseq	r7, r1, r9, ror #12
     1e4:	78635f5f 	stmdavc	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
     1e8:	75705f61 	ldrbvc	r5, [r0, #-3937]!	; 0xfffff09f
     1ec:	765f6572 			; <UNDEFINED> instruction: 0x765f6572
     1f0:	75747269 	ldrbvc	r7, [r4, #-617]!	; 0xfffffd97
     1f4:	5f006c61 	svcpl	0x00006c61
     1f8:	6178635f 	cmnvs	r8, pc, asr r3
     1fc:	6175675f 	cmnvs	r5, pc, asr r7
     200:	725f6472 	subsvc	r6, pc, #1912602624	; 0x72000000
     204:	61656c65 	cmnvs	r5, r5, ror #24
     208:	5f006573 	svcpl	0x00006573
     20c:	4f54435f 	svcmi	0x0054435f
     210:	4e455f52 	mcrmi	15, 2, r5, cr5, cr2, {2}
     214:	005f5f44 	subseq	r5, pc, r4, asr #30
     218:	73645f5f 	cmnvc	r4, #380	; 0x17c
     21c:	61685f6f 	cmnvs	r8, pc, ror #30
     220:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     224:	445f5f00 	ldrbmi	r5, [pc], #-3840	; 22c <_start-0x7dd4>
     228:	5f524f54 	svcpl	0x00524f54
     22c:	5453494c 	ldrbpl	r4, [r3], #-2380	; 0xfffff6b4
     230:	47005f5f 	smlsdmi	r0, pc, pc, r5	; <UNPREDICTABLE>
     234:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
     238:	34312b2b 	ldrtcc	r2, [r1], #-2859	; 0xfffff4d5
     23c:	2e303120 	rsfcssp	f3, f0, f0
     240:	20302e33 	eorscs	r2, r0, r3, lsr lr
     244:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
     248:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
     24c:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
     250:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
     254:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     258:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
     25c:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     260:	6f6c666d 	svcvs	0x006c666d
     264:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
     268:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
     26c:	20647261 	rsbcs	r7, r4, r1, ror #4
     270:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
     274:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
     278:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
     27c:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
     280:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
     284:	36373131 			; <UNDEFINED> instruction: 0x36373131
     288:	2d667a6a 	vstmdbcs	r6!, {s15-s120}
     28c:	6d2d2073 	stcvs	0, cr2, [sp, #-460]!	; 0xfffffe34
     290:	206d7261 	rsbcs	r7, sp, r1, ror #4
     294:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
     298:	613d6863 	teqvs	sp, r3, ror #16
     29c:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
     2a0:	662b6b7a 			; <UNDEFINED> instruction: 0x662b6b7a
     2a4:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
     2a8:	20672d20 	rsbcs	r2, r7, r0, lsr #26
     2ac:	20304f2d 	eorscs	r4, r0, sp, lsr #30
     2b0:	20304f2d 	eorscs	r4, r0, sp, lsr #30
     2b4:	6f6e662d 	svcvs	0x006e662d
     2b8:	6378652d 	cmnvs	r8, #188743680	; 0xb400000
     2bc:	69747065 	ldmdbvs	r4!, {r0, r2, r5, r6, ip, sp, lr}^
     2c0:	20736e6f 	rsbscs	r6, r3, pc, ror #28
     2c4:	6f6e662d 	svcvs	0x006e662d
     2c8:	7474722d 	ldrbtvc	r7, [r4], #-557	; 0xfffffdd3
     2cc:	74640069 	strbtvc	r0, [r4], #-105	; 0xffffff97
     2d0:	705f726f 	subsvc	r7, pc, pc, ror #4
     2d4:	5f007274 	svcpl	0x00007274
     2d8:	4f54445f 	svcmi	0x0054445f
     2dc:	4e455f52 	mcrmi	15, 2, r5, cr5, cr2, {2}
     2e0:	005f5f44 	subseq	r5, pc, r4, asr #30
     2e4:	78635f5f 	stmdavc	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
     2e8:	74615f61 	strbtvc	r5, [r1], #-3937	; 0xfffff09f
     2ec:	74697865 	strbtvc	r7, [r9], #-2149	; 0xfffff79b
     2f0:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
     2f4:	6f6c2067 	svcvs	0x006c2067
     2f8:	6920676e 	stmdbvs	r0!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}
     2fc:	5f00746e 	svcpl	0x0000746e
     300:	5f707063 	svcpl	0x00707063
     304:	72617473 	rsbvc	r7, r1, #1929379840	; 0x73000000
     308:	00707574 	rsbseq	r7, r0, r4, ror r5
     30c:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
     310:	752f632f 	strvc	r6, [pc, #-815]!	; ffffffe9 <__bss_end+0xffff48d5>
     314:	2f726573 	svccs	0x00726573
     318:	76697270 			; <UNDEFINED> instruction: 0x76697270
     31c:	57657461 	strbpl	r7, [r5, -r1, ror #8]!
     320:	736b726f 	cmnvc	fp, #-268435450	; 0xf0000006
     324:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     328:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
     32c:	2f6c6f6f 	svccs	0x006c6f6f
     330:	532f534f 			; <UNDEFINED> instruction: 0x532f534f
     334:	494b2f50 	stmdbmi	fp, {r4, r6, r8, r9, sl, fp, sp}^
     338:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
     33c:	732f534f 			; <UNDEFINED> instruction: 0x732f534f
     340:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     344:	752f7365 	strvc	r7, [pc, #-869]!	; ffffffe7 <__bss_end+0xffff48d3>
     348:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     34c:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     350:	7878632f 	ldmdavc	r8!, {r0, r1, r2, r3, r5, r8, r9, sp, lr}^
     354:	2e696261 	cdpcs	2, 6, cr6, cr9, cr1, {3}
     358:	00707063 	rsbseq	r7, r0, r3, rrx
     35c:	78635f5f 	stmdavc	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
     360:	75675f61 	strbvc	r5, [r7, #-3937]!	; 0xfffff09f
     364:	5f647261 	svcpl	0x00647261
     368:	726f6261 	rsbvc	r6, pc, #268435462	; 0x10000006
     36c:	5f5f0074 	svcpl	0x005f0074
     370:	524f5443 	subpl	r5, pc, #1124073472	; 0x43000000
     374:	53494c5f 	movtpl	r4, #40031	; 0x9c5f
     378:	005f5f54 	subseq	r5, pc, r4, asr pc	; <UNPREDICTABLE>
     37c:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
     380:	7274705f 	rsbsvc	r7, r4, #95	; 0x5f
     384:	635f5f00 	cmpvs	pc, #0, 30
     388:	675f6178 			; <UNDEFINED> instruction: 0x675f6178
     38c:	64726175 	ldrbtvs	r6, [r2], #-373	; 0xfffffe8b
     390:	7163615f 	cmnvc	r3, pc, asr r1
     394:	65726975 	ldrbvs	r6, [r2, #-2421]!	; 0xfffff68b
     398:	5f524200 	svcpl	0x00524200
     39c:	30363735 	eorscc	r3, r6, r5, lsr r7
     3a0:	69630030 	stmdbvs	r3!, {r4, r5}^
     3a4:	6c756372 	ldclvs	3, cr6, [r5], #-456	; 0xfffffe38
     3a8:	625f7261 	subsvs	r7, pc, #268435462	; 0x10000006
     3ac:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
     3b0:	69540072 	ldmdbvs	r4, {r1, r4, r5, r6}^
     3b4:	435f6b63 	cmpmi	pc, #101376	; 0x18c00
     3b8:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     3bc:	646e4900 	strbtvs	r4, [lr], #-2304	; 0xfffff700
     3c0:	6e696665 	cdpvs	6, 6, cr6, cr9, cr5, {3}
     3c4:	00657469 	rsbeq	r7, r5, r9, ror #8
     3c8:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     3cc:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     3d0:	50433631 	subpl	r3, r3, r1, lsr r6
     3d4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     3d8:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 214 <_start-0x7dec>
     3dc:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     3e0:	31327265 	teqcc	r2, r5, ror #4
     3e4:	636f6c42 	cmnvs	pc, #16896	; 0x4200
     3e8:	75435f6b 	strbvc	r5, [r3, #-3947]	; 0xfffff095
     3ec:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     3f0:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     3f4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     3f8:	00764573 	rsbseq	r4, r6, r3, ror r5
     3fc:	5241554e 	subpl	r5, r1, #327155712	; 0x13800000
     400:	68435f54 	stmdavs	r3, {r2, r4, r6, r8, r9, sl, fp, ip, lr}^
     404:	4c5f7261 	lfmmi	f7, 2, [pc], {97}	; 0x61
     408:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     40c:	65470068 	strbvs	r0, [r7, #-104]	; 0xffffff98
     410:	6172656e 	cmnvs	r2, lr, ror #10
     414:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     418:	69727700 	ldmdbvs	r2!, {r8, r9, sl, ip, sp, lr}^
     41c:	6e496574 	mcrvs	5, 2, r6, cr9, cr4, {3}
     420:	00786564 	rsbseq	r6, r8, r4, ror #10
     424:	76657270 			; <UNDEFINED> instruction: 0x76657270
     428:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     42c:	50433631 	subpl	r3, r3, r1, lsr r6
     430:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     434:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 270 <_start-0x7d90>
     438:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     43c:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
     440:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     444:	505f7966 	subspl	r7, pc, r6, ror #18
     448:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     44c:	50457373 	subpl	r7, r5, r3, ror r3
     450:	54543231 	ldrbpl	r3, [r4], #-561	; 0xfffffdcf
     454:	5f6b7361 	svcpl	0x006b7361
     458:	75727453 	ldrbvc	r7, [r2, #-1107]!	; 0xfffffbad
     45c:	67007463 	strvs	r7, [r0, -r3, ror #8]
     460:	695f6e65 	ldmdbvs	pc, {r0, r2, r5, r6, r9, sl, fp, sp, lr}^	; <UNPREDICTABLE>
     464:	7865646e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, sp, lr}^
     468:	6d6e5500 	cfstr64vs	mvdx5, [lr, #-0]
     46c:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
     470:	5f656c69 	svcpl	0x00656c69
     474:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     478:	00746e65 	rsbseq	r6, r4, r5, ror #28
     47c:	56746572 			; <UNDEFINED> instruction: 0x56746572
     480:	65756c61 	ldrbvs	r6, [r5, #-3169]!	; 0xfffff39f
     484:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     488:	68433031 	stmdavs	r3, {r0, r4, r5, ip, sp}^
     48c:	6f6d6f72 	svcvs	0x006d6f72
     490:	656d6f73 	strbvs	r6, [sp, #-3955]!	; 0xfffff08d
     494:	74656739 	strbtvc	r6, [r5], #-1849	; 0xfffff8c7
     498:	646f6d5f 	strbtvs	r6, [pc], #-3423	; 4a0 <_start-0x7b60>
     49c:	76456c65 	strbvc	r6, [r5], -r5, ror #24
     4a0:	72506d00 	subsvc	r6, r0, #0, 26
     4a4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     4a8:	694c5f73 	stmdbvs	ip, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     4ac:	485f7473 	ldmdami	pc, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
     4b0:	00646165 	rsbeq	r6, r4, r5, ror #2
     4b4:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
     4b8:	6d756e5f 	ldclvs	14, cr6, [r5, #-380]!	; 0xfffffe84
     4bc:	6c61765f 	stclvs	6, cr7, [r1], #-380	; 0xfffffe84
     4c0:	706e6900 	rsbvc	r6, lr, r0, lsl #18
     4c4:	765f7475 			; <UNDEFINED> instruction: 0x765f7475
     4c8:	65756c61 	ldrbvs	r6, [r5, #-3169]!	; 0xfffff39f
     4cc:	6365725f 	cmnvs	r5, #-268435451	; 0xf0000005
     4d0:	65766965 	ldrbvs	r6, [r6, #-2405]!	; 0xfffff69b
     4d4:	68775f64 	ldmdavs	r7!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     4d8:	5f656c69 	svcpl	0x00656c69
     4dc:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     4e0:	676e6974 			; <UNDEFINED> instruction: 0x676e6974
     4e4:	75616200 	strbvc	r6, [r1, #-512]!	; 0xfffffe00
     4e8:	61725f64 	cmnvs	r2, r4, ror #30
     4ec:	73006574 	movwvc	r6, #1396	; 0x574
     4f0:	675f7465 	ldrbvs	r7, [pc, -r5, ror #8]
     4f4:	72656e65 	rsbvc	r6, r5, #1616	; 0x650
     4f8:	726f7461 	rsbvc	r7, pc, #1627389952	; 0x61000000
     4fc:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     500:	4336314b 	teqmi	r6, #-1073741806	; 0xc0000012
     504:	636f7250 	cmnvs	pc, #80, 4
     508:	5f737365 	svcpl	0x00737365
     50c:	616e614d 	cmnvs	lr, sp, asr #2
     510:	31726567 	cmncc	r2, r7, ror #10
     514:	74654739 	strbtvc	r4, [r5], #-1849	; 0xfffff8c7
     518:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     51c:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     520:	6f72505f 	svcvs	0x0072505f
     524:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     528:	72007645 	andvc	r7, r0, #72351744	; 0x4500000
     52c:	5f646165 	svcpl	0x00646165
     530:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     534:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     538:	65523031 	ldrbvs	r3, [r2, #-49]	; 0xffffffcf
     53c:	555f6461 	ldrbpl	r6, [pc, #-1121]	; e3 <_start-0x7f1d>
     540:	736c6974 	cmnvc	ip, #116, 18	; 0x1d0000
     544:	76453443 	strbvc	r3, [r5], -r3, asr #8
     548:	5f524200 	svcpl	0x00524200
     54c:	30303834 	eorscc	r3, r0, r4, lsr r8
     550:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     554:	6e523331 	mrcvs	3, 2, r3, cr2, cr1, {1}
     558:	65475f64 	strbvs	r5, [r7, #-3940]	; 0xfffff09c
     55c:	6172656e 	cmnvs	r2, lr, ror #10
     560:	38726f74 	ldmdacc	r2!, {r2, r4, r5, r6, r8, r9, sl, fp, sp, lr}^
     564:	656e6567 	strbvs	r6, [lr, #-1383]!	; 0xfffffa99
     568:	65746172 	ldrbvs	r6, [r4, #-370]!	; 0xfffffe8e
     56c:	00696945 	rsbeq	r6, r9, r5, asr #18
     570:	314e5a5f 	cmpcc	lr, pc, asr sl
     574:	72694335 	rsbvc	r4, r9, #-738197504	; 0xd4000000
     578:	616c7563 	cmnvs	ip, r3, ror #10
     57c:	75425f72 	strbvc	r5, [r2, #-3954]	; 0xfffff08e
     580:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
     584:	61657234 	cmnvs	r5, r4, lsr r2
     588:	63504564 	cmpvs	r0, #100, 10	; 0x19000000
     58c:	656e006a 	strbvs	r0, [lr, #-106]!	; 0xffffff96
     590:	47007478 	smlsdxmi	r0, r8, r4, r7
     594:	505f7465 	subspl	r7, pc, r5, ror #8
     598:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     59c:	425f7373 	subsmi	r7, pc, #-872415231	; 0xcc000001
     5a0:	49505f79 	ldmdbmi	r0, {r0, r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     5a4:	76650044 	strbtvc	r0, [r5], -r4, asr #32
     5a8:	61756c61 	cmnvs	r5, r1, ror #24
     5ac:	675f6574 			; <UNDEFINED> instruction: 0x675f6574
     5b0:	4e006e65 	cdpmi	14, 0, cr6, cr0, cr5, {3}
     5b4:	5f495753 	svcpl	0x00495753
     5b8:	636f7250 	cmnvs	pc, #80, 4
     5bc:	5f737365 	svcpl	0x00737365
     5c0:	76726553 			; <UNDEFINED> instruction: 0x76726553
     5c4:	00656369 	rsbeq	r6, r5, r9, ror #6
     5c8:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     5cc:	61657200 	cmnvs	r5, r0, lsl #4
     5d0:	74735f64 	ldrbtvc	r5, [r3], #-3940	; 0xfffff09c
     5d4:	745f7065 	ldrbvc	r7, [pc], #-101	; 5dc <_start-0x7a24>
     5d8:	00656d69 	rsbeq	r6, r5, r9, ror #26
     5dc:	69746341 	ldmdbvs	r4!, {r0, r6, r8, r9, sp, lr}^
     5e0:	505f6576 	subspl	r6, pc, r6, ror r5	; <UNPREDICTABLE>
     5e4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     5e8:	435f7373 	cmpmi	pc, #-872415231	; 0xcc000001
     5ec:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     5f0:	315a5f00 	cmpcc	sl, r0, lsl #30
     5f4:	61657232 	cmnvs	r5, r2, lsr r2
     5f8:	756e5f64 	strbvc	r5, [lr, #-3940]!	; 0xfffff09c
     5fc:	61765f6d 	cmnvs	r6, sp, ror #30
     600:	6a63506c 	bvs	18d47b8 <__bss_end+0x18c90a4>
     604:	52303150 	eorspl	r3, r0, #80, 2
     608:	5f646165 	svcpl	0x00646165
     60c:	6c697455 	cfstrdvs	mvd7, [r9], #-340	; 0xfffffeac
     610:	634b5073 	movtvs	r5, #45171	; 0xb073
     614:	73656d00 	cmnvc	r5, #0, 26
     618:	65676173 	strbvs	r6, [r7, #-371]!	; 0xfffffe8d
     61c:	6675625f 			; <UNDEFINED> instruction: 0x6675625f
     620:	00726566 	rsbseq	r6, r2, r6, ror #10
     624:	61657243 	cmnvs	r5, r3, asr #4
     628:	505f6574 	subspl	r6, pc, r4, ror r5	; <UNPREDICTABLE>
     62c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     630:	5f007373 	svcpl	0x00007373
     634:	30314e5a 	eorscc	r4, r1, sl, asr lr
     638:	6f726843 	svcvs	0x00726843
     63c:	6f736f6d 	svcvs	0x00736f6d
     640:	3131656d 	teqcc	r1, sp, ror #10
     644:	5f746567 	svcpl	0x00746567
     648:	6e746966 	vsubvs.f16	s13, s8, s13	; <UNPREDICTABLE>
     64c:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     650:	6d2f0076 	stcvs	0, cr0, [pc, #-472]!	; 480 <_start-0x7b80>
     654:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
     658:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     65c:	72702f72 	rsbsvc	r2, r0, #456	; 0x1c8
     660:	74617669 	strbtvc	r7, [r1], #-1641	; 0xfffff997
     664:	726f5765 	rsbvc	r5, pc, #26476544	; 0x1940000
     668:	6170736b 	cmnvs	r0, fp, ror #6
     66c:	532f6563 			; <UNDEFINED> instruction: 0x532f6563
     670:	6f6f6863 	svcvs	0x006f6863
     674:	534f2f6c 	movtpl	r2, #65388	; 0xff6c
     678:	2f50532f 	svccs	0x0050532f
     67c:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
     680:	534f5452 	movtpl	r5, #62546	; 0xf452
     684:	756f732f 	strbvc	r7, [pc, #-815]!	; 35d <_start-0x7ca3>
     688:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     68c:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     690:	61707372 	cmnvs	r0, r2, ror r3
     694:	732f6563 			; <UNDEFINED> instruction: 0x732f6563
     698:	73656d65 	cmnvc	r5, #6464	; 0x1940
     69c:	6c617274 	sfmvs	f7, 2, [r1], #-464	; 0xfffffe30
     6a0:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     6a4:	616d2f6b 	cmnvs	sp, fp, ror #30
     6a8:	632e6e69 			; <UNDEFINED> instruction: 0x632e6e69
     6ac:	67007070 	smlsdxvs	r0, r0, r0, r7
     6b0:	72656e65 	rsbvc	r6, r5, #1616	; 0x650
     6b4:	00657461 	rsbeq	r7, r5, r1, ror #8
     6b8:	74617473 	strbtvc	r7, [r1], #-1139	; 0xfffffb8d
     6bc:	72700065 	rsbsvc	r0, r0, #101	; 0x65
     6c0:	745f6465 	ldrbvc	r6, [pc], #-1125	; 6c8 <_start-0x7938>
     6c4:	00656d69 	rsbeq	r6, r5, r9, ror #26
     6c8:	34315a5f 	ldrtcc	r5, [r1], #-2655	; 0xfffff5a1
     6cc:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
     6d0:	6574735f 	ldrbvs	r7, [r4, #-863]!	; 0xfffffca1
     6d4:	69745f70 	ldmdbvs	r4!, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     6d8:	6350656d 	cmpvs	r0, #457179136	; 0x1b400000
     6dc:	3031506a 	eorscc	r5, r1, sl, rrx
     6e0:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     6e4:	6974555f 	ldmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r8, sl, ip, lr}^
     6e8:	4d00736c 	stcmi	3, cr7, [r0, #-432]	; 0xfffffe50
     6ec:	69467861 	stmdbvs	r6, {r0, r5, r6, fp, ip, sp, lr}^
     6f0:	616e656c 	cmnvs	lr, ip, ror #10
     6f4:	654c656d 	strbvs	r6, [ip, #-1389]	; 0xfffffa93
     6f8:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     6fc:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     700:	69433531 	stmdbvs	r3, {r0, r4, r5, r8, sl, ip, sp}^
     704:	6c756372 	ldclvs	3, cr6, [r5], #-456	; 0xfffffe38
     708:	425f7261 	subsmi	r7, pc, #268435462	; 0x10000006
     70c:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
     710:	65723472 	ldrbvs	r3, [r2, #-1138]!	; 0xfffffb8e
     714:	50456461 	subpl	r6, r5, r1, ror #8
     718:	6e690063 	cdpvs	0, 6, cr0, cr9, cr3, {3}
     71c:	00747570 	rsbseq	r7, r4, r0, ror r5
     720:	5f746547 	svcpl	0x00746547
     724:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     728:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     72c:	6e495f72 	mcrvs	15, 2, r5, cr9, cr2, {3}
     730:	44006f66 	strmi	r6, [r0], #-3942	; 0xfffff09a
     734:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     738:	5f656e69 	svcpl	0x00656e69
     73c:	68636e55 	stmdavs	r3!, {r0, r2, r4, r6, r9, sl, fp, sp, lr}^
     740:	65676e61 	strbvs	r6, [r7, #-3681]!	; 0xfffff19f
     744:	50430064 	subpl	r0, r3, r4, rrx
     748:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     74c:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 588 <_start-0x7a78>
     750:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     754:	43007265 	movwmi	r7, #613	; 0x265
     758:	5f726168 	svcpl	0x00726168
     75c:	6e690038 	mcrvs	0, 3, r0, cr9, cr8, {1}
     760:	755f7469 	ldrbvc	r7, [pc, #-1129]	; 2ff <_start-0x7d01>
     764:	00747261 	rsbseq	r7, r4, r1, ror #4
     768:	314e5a5f 	cmpcc	lr, pc, asr sl
     76c:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     770:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     774:	614d5f73 	hvcvs	54771	; 0xd5f3
     778:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     77c:	47383172 			; <UNDEFINED> instruction: 0x47383172
     780:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     784:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     788:	72656c75 	rsbvc	r6, r5, #29952	; 0x7500
     78c:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     790:	3032456f 	eorscc	r4, r2, pc, ror #10
     794:	7465474e 	strbtvc	r4, [r5], #-1870	; 0xfffff8b2
     798:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     79c:	495f6465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     7a0:	5f6f666e 	svcpl	0x006f666e
     7a4:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     7a8:	72007650 	andvc	r7, r0, #80, 12	; 0x5000000
     7ac:	5f646165 	svcpl	0x00646165
     7b0:	64657270 	strbtvs	r7, [r5], #-624	; 0xfffffd90
     7b4:	69746369 	ldmdbvs	r4!, {r0, r3, r5, r6, r8, r9, sp, lr}^
     7b8:	745f6e6f 	ldrbvc	r6, [pc], #-3695	; 7c0 <_start-0x7840>
     7bc:	00656d69 	rsbeq	r6, r5, r9, ror #26
     7c0:	314e5a5f 	cmpcc	lr, pc, asr sl
     7c4:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     7c8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     7cc:	614d5f73 	hvcvs	54771	; 0xd5f3
     7d0:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     7d4:	48313272 	ldmdami	r1!, {r1, r4, r5, r6, r9, ip, sp}
     7d8:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     7dc:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     7e0:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     7e4:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     7e8:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     7ec:	4e333245 	cdpmi	2, 3, cr3, cr3, cr5, {2}
     7f0:	5f495753 	svcpl	0x00495753
     7f4:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     7f8:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     7fc:	535f6d65 	cmppl	pc, #6464	; 0x1940
     800:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     804:	6a6a6563 	bvs	1a99d98 <__bss_end+0x1a8e684>
     808:	3131526a 	teqcc	r1, sl, ror #4
     80c:	49575354 	ldmdbmi	r7, {r2, r4, r6, r8, r9, ip, lr}^
     810:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
     814:	00746c75 	rsbseq	r6, r4, r5, ror ip
     818:	70616568 	rsbvc	r6, r1, r8, ror #10
     81c:	7968705f 	stmdbvc	r8!, {r0, r1, r2, r3, r4, r6, ip, sp, lr}^
     820:	61636973 	smcvs	13971	; 0x3693
     824:	696c5f6c 	stmdbvs	ip!, {r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     828:	0074696d 	rsbseq	r6, r4, sp, ror #18
     82c:	6e65706f 	cdpvs	0, 6, cr7, cr5, cr15, {3}
     830:	665f6465 	ldrbvs	r6, [pc], -r5, ror #8
     834:	73656c69 	cmnvc	r5, #26880	; 0x6900
     838:	69616d00 	stmdbvs	r1!, {r8, sl, fp, sp, lr}^
     83c:	6f4e006e 	svcvs	0x004e006e
     840:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     844:	006c6c41 	rsbeq	r6, ip, r1, asr #24
     848:	55504354 	ldrbpl	r4, [r0, #-852]	; 0xfffffcac
     84c:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     850:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
     854:	61654400 	cmnvs	r5, r0, lsl #8
     858:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     85c:	74740065 	ldrbtvc	r0, [r4], #-101	; 0xffffff9b
     860:	00307262 	eorseq	r7, r0, r2, ror #4
     864:	314e5a5f 	cmpcc	lr, pc, asr sl
     868:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     86c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     870:	614d5f73 	hvcvs	54771	; 0xd5f3
     874:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     878:	4e343172 	mrcmi	1, 1, r3, cr4, cr2, {3}
     87c:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     880:	72505f79 	subsvc	r5, r0, #484	; 0x1e4
     884:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     888:	006a4573 	rsbeq	r4, sl, r3, ror r5
     88c:	5f746547 	svcpl	0x00746547
     890:	00444950 	subeq	r4, r4, r0, asr r9
     894:	69395a5f 	ldmdbvs	r9!, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}
     898:	5f74696e 	svcpl	0x0074696e
     89c:	74726175 	ldrbtvc	r6, [r2], #-373	; 0xfffffe8b
     8a0:	5a5f0076 	bpl	17c0a80 <__bss_end+0x17b536c>
     8a4:	4330314e 	teqmi	r0, #-2147483629	; 0x80000013
     8a8:	6d6f7268 	sfmvs	f7, 2, [pc, #-416]!	; 710 <_start-0x78f0>
     8ac:	6d6f736f 	stclvs	3, cr7, [pc, #-444]!	; 6f8 <_start-0x7908>
     8b0:	69663765 	stmdbvs	r6!, {r0, r2, r5, r6, r8, r9, sl, ip, sp}^
     8b4:	73656e74 	cmnvc	r5, #116, 28	; 0x740
     8b8:	66524573 			; <UNDEFINED> instruction: 0x66524573
     8bc:	69006966 	stmdbvs	r0, {r1, r2, r5, r6, r8, fp, sp, lr}
     8c0:	7475706e 	ldrbtvc	r7, [r5], #-110	; 0xffffff92
     8c4:	6c61765f 	stclvs	6, cr7, [r1], #-380	; 0xfffffe84
     8c8:	6e006575 	cfrshl64vs	mvdx0, mvdx5, r6
     8cc:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     8d0:	5f646569 	svcpl	0x00646569
     8d4:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
     8d8:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     8dc:	41554e00 	cmpmi	r5, r0, lsl #28
     8e0:	425f5452 	subsmi	r5, pc, #1375731712	; 0x52000000
     8e4:	5f647561 	svcpl	0x00647561
     8e8:	65746152 	ldrbvs	r6, [r4, #-338]!	; 0xfffffeae
     8ec:	61684300 	cmnvs	r8, r0, lsl #6
     8f0:	00375f72 	eorseq	r5, r7, r2, ror pc
     8f4:	736f7263 	cmnvc	pc, #805306374	; 0x30000006
     8f8:	65726273 	ldrbvs	r6, [r2, #-627]!	; 0xfffffd8d
     8fc:	5f006465 	svcpl	0x00006465
     900:	30314e5a 	eorscc	r4, r1, sl, asr lr
     904:	656e6547 	strbvs	r6, [lr, #-1351]!	; 0xfffffab9
     908:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
     90c:	31316e6f 	teqcc	r1, pc, ror #28
     910:	74696e69 	strbtvc	r6, [r9], #-3689	; 0xfffff197
     914:	6e61725f 	mcrvs	2, 3, r7, cr1, cr15, {2}
     918:	456d6f64 	strbmi	r6, [sp, #-3940]!	; 0xfffff09c
     91c:	614d0076 	hvcvs	53254	; 0xd006
     920:	72505f78 	subsvc	r5, r0, #120, 30	; 0x1e0
     924:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     928:	704f5f73 	subvc	r5, pc, r3, ror pc	; <UNPREDICTABLE>
     92c:	64656e65 	strbtvs	r6, [r5], #-3685	; 0xfffff19b
     930:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     934:	5f007365 	svcpl	0x00007365
     938:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     93c:	6f725043 	svcvs	0x00725043
     940:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     944:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     948:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     94c:	6e553831 	mrcvs	8, 2, r3, cr5, cr1, {1}
     950:	5f70616d 	svcpl	0x0070616d
     954:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     958:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     95c:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     960:	47006a45 	strmi	r6, [r0, -r5, asr #20]
     964:	435f7465 	cmpmi	pc, #1694498816	; 0x65000000
     968:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     96c:	505f746e 	subspl	r7, pc, lr, ror #8
     970:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     974:	6d007373 	stcvs	3, cr7, [r0, #-460]	; 0xfffffe34
     978:	74617475 	strbtvc	r7, [r1], #-1141	; 0xfffffb8b
     97c:	614d0065 	cmpvs	sp, r5, rrx
     980:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     984:	545f656c 	ldrbpl	r6, [pc], #-1388	; 98c <_start-0x7674>
     988:	75435f6f 	strbvc	r5, [r3, #-3951]	; 0xfffff091
     98c:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     990:	52420074 	subpl	r0, r2, #116	; 0x74
     994:	3034325f 	eorscc	r3, r4, pc, asr r2
     998:	5a5f0030 	bpl	17c0a60 <__bss_end+0x17b534c>
     99c:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     9a0:	636f7250 	cmnvs	pc, #80, 4
     9a4:	5f737365 	svcpl	0x00737365
     9a8:	616e614d 	cmnvs	lr, sp, asr #2
     9ac:	31726567 	cmncc	r2, r7, ror #10
     9b0:	6e614837 	mcrvs	8, 3, r4, cr1, cr7, {1}
     9b4:	5f656c64 	svcpl	0x00656c64
     9b8:	6f6d654d 	svcvs	0x006d654d
     9bc:	535f7972 	cmppl	pc, #1867776	; 0x1c8000
     9c0:	31454957 	cmpcc	r5, r7, asr r9
     9c4:	57534e39 	smmlarpl	r3, r9, lr, r4
     9c8:	654d5f49 	strbvs	r5, [sp, #-3913]	; 0xfffff0b7
     9cc:	79726f6d 	ldmdbvc	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     9d0:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     9d4:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     9d8:	526a6a6a 	rsbpl	r6, sl, #434176	; 0x6a000
     9dc:	53543131 	cmppl	r4, #1073741836	; 0x4000000c
     9e0:	525f4957 	subspl	r4, pc, #1425408	; 0x15c000
     9e4:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
     9e8:	6f4e0074 	svcvs	0x004e0074
     9ec:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     9f0:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     9f4:	72446d65 	subvc	r6, r4, #6464	; 0x1940
     9f8:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     9fc:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
     a00:	7261505f 	rsbvc	r5, r1, #95	; 0x5f
     a04:	00736d61 	rsbseq	r6, r3, r1, ror #26
     a08:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     a0c:	505f656c 	subspl	r6, pc, ip, ror #10
     a10:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     a14:	535f7373 	cmppl	pc, #-872415231	; 0xcc000001
     a18:	73004957 	movwvc	r4, #2391	; 0x957
     a1c:	74726f68 	ldrbtvc	r6, [r2], #-3944	; 0xfffff098
     a20:	736e7520 	cmnvc	lr, #32, 10	; 0x8000000
     a24:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
     a28:	6e692064 	cdpvs	0, 6, cr2, cr9, cr4, {3}
     a2c:	6e520074 	mrcvs	0, 2, r0, cr2, cr4, {3}
     a30:	65475f64 	strbvs	r5, [r7, #-3940]	; 0xfffff09c
     a34:	6172656e 	cmnvs	r2, lr, ror #10
     a38:	00726f74 	rsbseq	r6, r2, r4, ror pc
     a3c:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     a40:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     a44:	4644455f 			; <UNDEFINED> instruction: 0x4644455f
     a48:	69615700 	stmdbvs	r1!, {r8, r9, sl, ip, lr}^
     a4c:	69440074 	stmdbvs	r4, {r2, r4, r5, r6}^
     a50:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
     a54:	76455f65 	strbvc	r5, [r5], -r5, ror #30
     a58:	5f746e65 	svcpl	0x00746e65
     a5c:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     a60:	6f697463 	svcvs	0x00697463
     a64:	5a5f006e 	bpl	17c0c24 <__bss_end+0x17b5510>
     a68:	4330314e 	teqmi	r0, #-2147483629	; 0x80000013
     a6c:	6d6f7268 	sfmvs	f7, 2, [pc, #-416]!	; 8d4 <_start-0x772c>
     a70:	6d6f736f 	stclvs	3, cr7, [pc, #-444]!	; 8bc <_start-0x7744>
     a74:	72633965 	rsbvc	r3, r3, #1654784	; 0x194000
     a78:	6f73736f 	svcvs	0x0073736f
     a7c:	45726576 	ldrbmi	r6, [r2, #-1398]!	; 0xfffffa8a
     a80:	005f5352 	subseq	r5, pc, r2, asr r3	; <UNPREDICTABLE>
     a84:	32315a5f 	eorscc	r5, r1, #389120	; 0x5f000
     a88:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     a8c:	61765f74 	cmnvs	r6, r4, ror pc
     a90:	7365756c 	cmnvc	r5, #108, 10	; 0x1b000000
     a94:	666a6350 			; <UNDEFINED> instruction: 0x666a6350
     a98:	52303150 	eorspl	r3, r0, #80, 2
     a9c:	5f646165 	svcpl	0x00646165
     aa0:	6c697455 	cfstrdvs	mvd7, [r9], #-340	; 0xfffffeac
     aa4:	72700073 	rsbsvc	r0, r0, #115	; 0x73
     aa8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     aac:	616c4673 	smcvs	50275	; 0xc463
     ab0:	65720067 	ldrbvs	r0, [r2, #-103]!	; 0xffffff99
     ab4:	755f6461 	ldrbvc	r6, [pc, #-1121]	; 65b <_start-0x79a5>
     ab8:	736c6974 	cmnvc	ip, #116, 18	; 0x1d0000
     abc:	746e4900 	strbtvc	r4, [lr], #-2304	; 0xfffff700
     ac0:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     ac4:	62617470 	rsbvs	r7, r1, #112, 8	; 0x70000000
     ac8:	535f656c 	cmppl	pc, #108, 10	; 0x1b000000
     acc:	7065656c 	rsbvc	r6, r5, ip, ror #10
     ad0:	6f747300 	svcvs	0x00747300
     ad4:	64657070 	strbtvs	r7, [r5], #-112	; 0xffffff90
     ad8:	756f635f 	strbvc	r6, [pc, #-863]!	; 781 <_start-0x787f>
     adc:	6e69746e 	cdpvs	4, 6, cr7, cr9, cr14, {3}
     ae0:	6f620067 	svcvs	0x00620067
     ae4:	5f006c6f 	svcpl	0x00006c6f
     ae8:	30314e5a 	eorscc	r4, r1, sl, asr lr
     aec:	656e6547 	strbvs	r6, [lr, #-1351]!	; 0xfffffab9
     af0:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
     af4:	32316e6f 	eorscc	r6, r1, #1776	; 0x6f0
     af8:	6c617665 	stclvs	6, cr7, [r1], #-404	; 0xfffffe6c
     afc:	65746175 	ldrbvs	r6, [r4, #-373]!	; 0xfffffe8b
     b00:	6e65675f 	mcrvs	7, 3, r6, cr5, cr15, {2}
     b04:	666a6645 	strbtvs	r6, [sl], -r5, asr #12
     b08:	4c6d0069 	stclmi	0, cr0, [sp], #-420	; 0xfffffe5c
     b0c:	5f747361 	svcpl	0x00747361
     b10:	00444950 	subeq	r4, r4, r0, asr r9
     b14:	636f6c42 	cmnvs	pc, #16896	; 0x4200
     b18:	0064656b 	rsbeq	r6, r4, fp, ror #10
     b1c:	7465474e 	strbtvc	r4, [r5], #-1870	; 0xfffff8b2
     b20:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     b24:	495f6465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     b28:	5f6f666e 	svcpl	0x006f666e
     b2c:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     b30:	706d7400 	rsbvc	r7, sp, r0, lsl #8
     b34:	6675625f 			; <UNDEFINED> instruction: 0x6675625f
     b38:	00726566 	rsbseq	r6, r2, r6, ror #10
     b3c:	6e6e7552 	mcrvs	5, 3, r7, cr14, cr2, {2}
     b40:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     b44:	61544e00 	cmpvs	r4, r0, lsl #28
     b48:	535f6b73 	cmppl	pc, #117760	; 0x1cc00
     b4c:	65746174 	ldrbvs	r6, [r4, #-372]!	; 0xfffffe8c
     b50:	5f524200 	svcpl	0x00524200
     b54:	30343833 	eorscc	r3, r4, r3, lsr r8
     b58:	5a5f0030 	bpl	17c0c20 <__bss_end+0x17b550c>
     b5c:	4335314e 	teqmi	r5, #-2147483629	; 0x80000013
     b60:	75637269 	strbvc	r7, [r3, #-617]!	; 0xfffffd97
     b64:	5f72616c 	svcpl	0x0072616c
     b68:	66667542 	strbtvs	r7, [r6], -r2, asr #10
     b6c:	30317265 	eorscc	r7, r1, r5, ror #4
     b70:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
     b74:	746e755f 	strbtvc	r7, [lr], #-1375	; 0xfffffaa1
     b78:	63456c69 	movtvs	r6, #23657	; 0x5c69
     b7c:	73006350 	movwvc	r6, #848	; 0x350
     b80:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     b84:	756f635f 	strbvc	r6, [pc, #-863]!	; 82d <_start-0x77d3>
     b88:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     b8c:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
     b90:	735f6465 	cmpvc	pc, #1694498816	; 0x65000000
     b94:	69746174 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, sp, lr}^
     b98:	72705f63 	rsbsvc	r5, r0, #396	; 0x18c
     b9c:	69726f69 	ldmdbvs	r2!, {r0, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     ba0:	77007974 	smlsdxvc	r0, r4, r9, r7
     ba4:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
     ba8:	69786500 	ldmdbvs	r8!, {r8, sl, sp, lr}^
     bac:	6f635f74 	svcvs	0x00635f74
     bb0:	42006564 	andmi	r6, r0, #100, 10	; 0x19000000
     bb4:	31315f52 	teqcc	r1, r2, asr pc
     bb8:	30303235 	eorscc	r3, r0, r5, lsr r2
     bbc:	315a5f00 	cmpcc	sl, r0, lsl #30
     bc0:	61657234 	cmnvs	r5, r4, lsr r2
     bc4:	6c665f64 	stclvs	15, cr5, [r6], #-400	; 0xfffffe70
     bc8:	5f74616f 	svcpl	0x0074616f
     bcc:	506c6176 	rsbpl	r6, ip, r6, ror r1
     bd0:	6d006a63 	vstrvs	s12, [r0, #-396]	; 0xfffffe74
     bd4:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     bd8:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     bdc:	636e465f 	cmnvs	lr, #99614720	; 0x5f00000
     be0:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     be4:	72445346 	subvc	r5, r4, #402653185	; 0x18000001
     be8:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     bec:	656d614e 	strbvs	r6, [sp, #-334]!	; 0xfffffeb2
     bf0:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     bf4:	4e006874 	mcrmi	8, 0, r6, cr0, cr4, {3}
     bf8:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     bfc:	5a5f0079 	bpl	17c0de8 <__bss_end+0x17b56d4>
     c00:	4335314e 	teqmi	r5, #-2147483629	; 0x80000013
     c04:	75637269 	strbvc	r7, [r3, #-617]!	; 0xfffffd97
     c08:	5f72616c 	svcpl	0x0072616c
     c0c:	66667542 	strbtvs	r7, [r6], -r2, asr #10
     c10:	34437265 	strbcc	r7, [r3], #-613	; 0xfffffd9b
     c14:	66007645 	strvs	r7, [r0], -r5, asr #12
     c18:	646e756f 	strbtvs	r7, [lr], #-1391	; 0xfffffa91
     c1c:	74706f5f 	ldrbtvc	r6, [r0], #-3935	; 0xfffff0a1
     c20:	6c616d69 	stclvs	13, cr6, [r1], #-420	; 0xfffffe5c
     c24:	636f4c00 	cmnvs	pc, #0, 24
     c28:	6e555f6b 	cdpvs	15, 5, cr5, cr5, cr11, {3}
     c2c:	6b636f6c 	blvs	18dc9e4 <__bss_end+0x18d12d0>
     c30:	5f006465 	svcpl	0x00006465
     c34:	7033315a 	eorsvc	r3, r3, sl, asr r1
     c38:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     c3c:	705f7373 	subsvc	r7, pc, r3, ror r3	; <UNPREDICTABLE>
     c40:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
     c44:	006a6350 	rsbeq	r6, sl, r0, asr r3
     c48:	30325a5f 	eorscc	r5, r2, pc, asr sl
     c4c:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
     c50:	6572705f 	ldrbvs	r7, [r2, #-95]!	; 0xffffffa1
     c54:	74636964 	strbtvc	r6, [r3], #-2404	; 0xfffff69c
     c58:	5f6e6f69 	svcpl	0x006e6f69
     c5c:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
     c60:	506a6350 	rsbpl	r6, sl, r0, asr r3
     c64:	65523031 	ldrbvs	r3, [r2, #-49]	; 0xffffffcf
     c68:	555f6461 	ldrbpl	r6, [pc, #-1121]	; 80f <_start-0x77f1>
     c6c:	736c6974 	cmnvc	ip, #116, 18	; 0x1d0000
     c70:	65727000 	ldrbvs	r7, [r2, #-0]!
     c74:	74636964 	strbtvc	r6, [r3], #-2404	; 0xfffff69c
     c78:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     c7c:	6b636f4c 	blvs	18dc9b4 <__bss_end+0x18d12a0>
     c80:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     c84:	0064656b 	rsbeq	r6, r4, fp, ror #10
     c88:	52415554 	subpl	r5, r1, #84, 10	; 0x15000000
     c8c:	4f495f54 	svcmi	0x00495f54
     c90:	5f6c7443 	svcpl	0x006c7443
     c94:	61726150 	cmnvs	r2, r0, asr r1
     c98:	5200736d 	andpl	r7, r0, #-1275068415	; 0xb4000001
     c9c:	5f646165 	svcpl	0x00646165
     ca0:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
     ca4:	6f5a0065 	svcvs	0x005a0065
     ca8:	6569626d 	strbvs	r6, [r9, #-621]!	; 0xfffffd93
     cac:	78656e00 	stmdavc	r5!, {r9, sl, fp, sp, lr}^
     cb0:	65675f74 	strbvs	r5, [r7, #-3956]!	; 0xfffff08c
     cb4:	5a5f006e 	bpl	17c0e74 <__bss_end+0x17b5760>
     cb8:	4330314e 	teqmi	r0, #-2147483629	; 0x80000013
     cbc:	6d6f7268 	sfmvs	f7, 2, [pc, #-416]!	; b24 <_start-0x74dc>
     cc0:	6d6f736f 	stclvs	3, cr7, [pc, #-444]!	; b0c <_start-0x74f4>
     cc4:	74623265 	strbtvc	r3, [r2], #-613	; 0xfffffd9b
     cc8:	00696645 	rsbeq	r6, r9, r5, asr #12
     ccc:	6b726273 	blvs	1c996a0 <__bss_end+0x1c8df8c>
     cd0:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     cd4:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     cd8:	495f6465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     cdc:	006f666e 	rsbeq	r6, pc, lr, ror #12
     ce0:	314e5a5f 	cmpcc	lr, pc, asr sl
     ce4:	72684330 	rsbvc	r4, r8, #48, 6	; 0xc0000000
     ce8:	736f6d6f 	cmnvc	pc, #7104	; 0x1bc0
     cec:	37656d6f 	strbcc	r6, [r5, -pc, ror #26]!
     cf0:	64657270 	strbtvs	r7, [r5], #-624	; 0xfffffd90
     cf4:	45746369 	ldrbmi	r6, [r4, #-873]!	; 0xfffffc97
     cf8:	5f006966 	svcpl	0x00006966
     cfc:	30314e5a 	eorscc	r4, r1, sl, asr lr
     d00:	6f726843 	svcvs	0x00726843
     d04:	6f736f6d 	svcvs	0x00736f6d
     d08:	6d36656d 	cfldr32vs	mvfx6, [r6, #-436]!	; 0xfffffe4c
     d0c:	74617475 	strbtvc	r7, [r1], #-1141	; 0xfffffb8b
     d10:	00764565 	rsbseq	r4, r6, r5, ror #10
     d14:	314e5a5f 	cmpcc	lr, pc, asr sl
     d18:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     d1c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     d20:	614d5f73 	hvcvs	54771	; 0xd5f3
     d24:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     d28:	63533872 	cmpvs	r3, #7471104	; 0x720000
     d2c:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     d30:	7645656c 	strbvc	r6, [r5], -ip, ror #10
     d34:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     d38:	50433631 	subpl	r3, r3, r1, lsr r6
     d3c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     d40:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; b7c <_start-0x7484>
     d44:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     d48:	39317265 	ldmdbcc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     d4c:	5f70614d 	svcpl	0x0070614d
     d50:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     d54:	5f6f545f 	svcpl	0x006f545f
     d58:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     d5c:	45746e65 	ldrbmi	r6, [r4, #-3685]!	; 0xfffff19b
     d60:	46493550 			; <UNDEFINED> instruction: 0x46493550
     d64:	00656c69 	rsbeq	r6, r5, r9, ror #24
     d68:	636f7270 	cmnvs	pc, #112, 4
     d6c:	5f737365 	svcpl	0x00737365
     d70:	61726170 	cmnvs	r2, r0, ror r1
     d74:	6547006d 	strbvs	r0, [r7, #-109]	; 0xffffff93
     d78:	61505f74 	cmpvs	r0, r4, ror pc
     d7c:	736d6172 	cmnvc	sp, #-2147483620	; 0x8000001c
     d80:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     d84:	68746150 	ldmdavs	r4!, {r4, r6, r8, sp, lr}^
     d88:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     d8c:	48006874 	stmdami	r0, {r2, r4, r5, r6, fp, sp, lr}
     d90:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     d94:	654d5f65 	strbvs	r5, [sp, #-3941]	; 0xfffff09b
     d98:	79726f6d 	ldmdbvc	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     d9c:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     da0:	736e7500 	cmnvc	lr, #0, 10
     da4:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
     da8:	68632064 	stmdavs	r3!, {r2, r5, r6, sp}^
     dac:	6f007261 	svcvs	0x00007261
     db0:	61726570 	cmnvs	r2, r0, ror r5
     db4:	3c726f74 	ldclcc	15, cr6, [r2], #-464	; 0xfffffe30
     db8:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
     dbc:	6f746172 	svcvs	0x00746172
     dc0:	5f003e72 	svcpl	0x00003e72
     dc4:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     dc8:	5f646e52 	svcpl	0x00646e52
     dcc:	656e6547 	strbvs	r6, [lr, #-1351]!	; 0xfffffab9
     dd0:	6f746172 	svcvs	0x00746172
     dd4:	67323172 			; <UNDEFINED> instruction: 0x67323172
     dd8:	72656e65 	rsbvc	r6, r5, #1616	; 0x650
     ddc:	5f657461 	svcpl	0x00657461
     de0:	45746e69 	ldrbmi	r6, [r4, #-3689]!	; 0xfffff197
     de4:	5f006969 	svcpl	0x00006969
     de8:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     dec:	6f725043 	svcvs	0x00725043
     df0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     df4:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     df8:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     dfc:	63533231 	cmpvs	r3, #268435459	; 0x10000003
     e00:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     e04:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 8a0 <_start-0x7760>
     e08:	76454644 	strbvc	r4, [r5], -r4, asr #12
     e0c:	61657200 	cmnvs	r5, r0, lsl #4
     e10:	68635f64 	stmdavs	r3!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     e14:	00737261 	rsbseq	r7, r3, r1, ror #4
     e18:	314e5a5f 	cmpcc	lr, pc, asr sl
     e1c:	6e654730 	mcrvs	7, 3, r4, cr5, cr0, {1}
     e20:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
     e24:	316e6f69 	cmncc	lr, r9, ror #30
     e28:	6f726330 	svcvs	0x00726330
     e2c:	72627373 	rsbvc	r7, r2, #-872415231	; 0xcc000001
     e30:	45646565 	strbmi	r6, [r4, #-1381]!	; 0xfffffa9b
     e34:	695f5350 	ldmdbvs	pc, {r4, r6, r8, r9, ip, lr}^	; <UNPREDICTABLE>
     e38:	6f687300 	svcvs	0x00687300
     e3c:	69207472 	stmdbvs	r0!, {r1, r4, r5, r6, sl, ip, sp, lr}
     e40:	7200746e 	andvc	r7, r0, #1845493760	; 0x6e000000
     e44:	665f646e 	ldrbvs	r6, [pc], -lr, ror #8
     e48:	00656c69 	rsbeq	r6, r5, r9, ror #24
     e4c:	314e5a5f 	cmpcc	lr, pc, asr sl
     e50:	72694335 	rsbvc	r4, r9, #-738197504	; 0xd4000000
     e54:	616c7563 	cmnvs	ip, r3, ror #10
     e58:	75425f72 	strbvc	r5, [r2, #-3954]	; 0xfffff08e
     e5c:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
     e60:	69727735 	ldmdbvs	r2!, {r0, r2, r4, r5, r8, r9, sl, ip, sp, lr}^
     e64:	63456574 	movtvs	r6, #21876	; 0x5574
     e68:	72617500 	rsbvc	r7, r1, #0, 10
     e6c:	69665f74 	stmdbvs	r6!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     e70:	4500656c 	strmi	r6, [r0, #-1388]	; 0xfffffa94
     e74:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     e78:	76455f65 	strbvc	r5, [r5], -r5, ror #30
     e7c:	5f746e65 	svcpl	0x00746e65
     e80:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     e84:	6f697463 	svcvs	0x00697463
     e88:	534e006e 	movtpl	r0, #57454	; 0xe06e
     e8c:	4d5f4957 	vldrmi.16	s9, [pc, #-174]	; de6 <_start-0x721a>	; <UNPREDICTABLE>
     e90:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
     e94:	65535f79 	ldrbvs	r5, [r3, #-3961]	; 0xfffff087
     e98:	63697672 	cmnvs	r9, #119537664	; 0x7200000
     e9c:	65720065 	ldrbvs	r0, [r2, #-101]!	; 0xffffff9b
     ea0:	755f6461 	ldrbvc	r6, [pc, #-1121]	; a47 <_start-0x75b9>
     ea4:	6c69746e 	cfstrdvs	mvd7, [r9], #-440	; 0xfffffe48
     ea8:	6e656700 	cdpvs	7, 6, cr6, cr5, cr0, {0}
     eac:	75520073 	ldrbvc	r0, [r2, #-115]	; 0xffffff8d
     eb0:	6e696e6e 	cdpvs	14, 6, cr6, cr9, cr14, {3}
     eb4:	65670067 	strbvs	r0, [r7, #-103]!	; 0xffffff99
     eb8:	6e5f736e 	cdpvs	3, 5, cr7, cr15, cr14, {3}
     ebc:	65646565 	strbvs	r6, [r4, #-1381]!	; 0xfffffa9b
     ec0:	65680064 	strbvs	r0, [r8, #-100]!	; 0xffffff9c
     ec4:	6c5f7061 	mrrcvs	0, 6, r7, pc, cr1	; <UNPREDICTABLE>
     ec8:	6369676f 	cmnvs	r9, #29097984	; 0x1bc0000
     ecc:	6c5f6c61 	mrrcvs	12, 6, r6, pc, cr1	; <UNPREDICTABLE>
     ed0:	74696d69 	strbtvc	r6, [r9], #-3433	; 0xfffff297
     ed4:	6e697500 	cdpvs	5, 6, cr7, cr9, cr0, {0}
     ed8:	5f323374 	svcpl	0x00323374
     edc:	6f630074 	svcvs	0x00630074
     ee0:	5f746e75 	svcpl	0x00746e75
     ee4:	756c6176 	strbvc	r6, [ip, #-374]!	; 0xfffffe8a
     ee8:	6d007365 	stcvs	3, cr7, [r0, #-404]	; 0xfffffe6c
     eec:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     ef0:	5f746e65 	svcpl	0x00746e65
     ef4:	6b736154 	blvs	1cd944c <__bss_end+0x1ccdd38>
     ef8:	646f4e5f 	strbtvs	r4, [pc], #-3679	; f00 <_start-0x7100>
     efc:	65620065 	strbvs	r0, [r2, #-101]!	; 0xffffff9b
     f00:	69467473 	stmdbvs	r6, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
     f04:	73656e74 	cmnvc	r5, #116, 28	; 0x740
     f08:	5a5f0073 	bpl	17c10dc <__bss_end+0x17b59c8>
     f0c:	4330314e 	teqmi	r0, #-2147483629	; 0x80000013
     f10:	6d6f7268 	sfmvs	f7, 2, [pc, #-416]!	; d78 <_start-0x7288>
     f14:	6d6f736f 	stclvs	3, cr7, [pc, #-444]!	; d60 <_start-0x72a0>
     f18:	69333165 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, ip, sp}
     f1c:	5f74696e 	svcpl	0x0074696e
     f20:	646e6172 	strbtvs	r6, [lr], #-370	; 0xfffffe8e
     f24:	796c6d6f 	stmdbvc	ip!, {r0, r1, r2, r3, r5, r6, r8, sl, fp, sp, lr}^
     f28:	69007645 	stmdbvs	r0, {r0, r2, r6, r9, sl, ip, sp, lr}
     f2c:	5f74696e 	svcpl	0x0074696e
     f30:	646e6172 	strbtvs	r6, [lr], #-370	; 0xfffffe8e
     f34:	796c6d6f 	stmdbvc	ip!, {r0, r1, r2, r3, r5, r6, r8, sl, fp, sp, lr}^
     f38:	72617000 	rsbvc	r7, r1, #0
     f3c:	00736d61 	rsbseq	r6, r3, r1, ror #26
     f40:	5f757063 	svcpl	0x00757063
     f44:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
     f48:	00747865 	rsbseq	r7, r4, r5, ror #16
     f4c:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     f50:	6c6e4f5f 	stclvs	15, cr4, [lr], #-380	; 0xfffffe84
     f54:	6e690079 	mcrvs	0, 3, r0, cr9, cr9, {3}
     f58:	725f7469 	subsvc	r7, pc, #1761607680	; 0x69000000
     f5c:	6f646e61 	svcvs	0x00646e61
     f60:	6176006d 	cmnvs	r6, sp, rrx
     f64:	7365756c 	cmnvc	r5, #108, 10	; 0x1b000000
     f68:	756f635f 	strbvc	r6, [pc, #-863]!	; c11 <_start-0x73ef>
     f6c:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     f70:	656c7300 	strbvs	r7, [ip, #-768]!	; 0xfffffd00
     f74:	745f7065 	ldrbvc	r7, [pc], #-101	; f7c <_start-0x7084>
     f78:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     f7c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     f80:	4336314b 	teqmi	r6, #-1073741806	; 0xc0000012
     f84:	636f7250 	cmnvs	pc, #80, 4
     f88:	5f737365 	svcpl	0x00737365
     f8c:	616e614d 	cmnvs	lr, sp, asr #2
     f90:	31726567 	cmncc	r2, r7, ror #10
     f94:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     f98:	6f72505f 	svcvs	0x0072505f
     f9c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     fa0:	5f79425f 	svcpl	0x0079425f
     fa4:	45444950 	strbmi	r4, [r4, #-2384]	; 0xfffff6b0
     fa8:	6148006a 	cmpvs	r8, sl, rrx
     fac:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     fb0:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     fb4:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     fb8:	5f6d6574 	svcpl	0x006d6574
     fbc:	00495753 	subeq	r5, r9, r3, asr r7
     fc0:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
     fc4:	65646e49 	strbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     fc8:	5a5f0078 	bpl	17c11b0 <__bss_end+0x17b5a9c>
     fcc:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     fd0:	636f7250 	cmnvs	pc, #80, 4
     fd4:	5f737365 	svcpl	0x00737365
     fd8:	616e614d 	cmnvs	lr, sp, asr #2
     fdc:	31726567 	cmncc	r2, r7, ror #10
     fe0:	68635331 	stmdavs	r3!, {r0, r4, r5, r8, r9, ip, lr}^
     fe4:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     fe8:	52525f65 	subspl	r5, r2, #404	; 0x194
     fec:	74007645 	strvc	r7, [r0], #-1605	; 0xfffff9bb
     ff0:	006b7361 	rsbeq	r7, fp, r1, ror #6
     ff4:	736f7263 	cmnvc	pc, #805306374	; 0x30000006
     ff8:	65766f73 	ldrbvs	r6, [r6, #-3955]!	; 0xfffff08d
     ffc:	52420072 	subpl	r0, r2, #114	; 0x72
    1000:	3239315f 	eorscc	r3, r9, #-1073741801	; 0xc0000017
    1004:	4e003030 	mcrmi	0, 0, r3, cr0, cr0, {1}
    1008:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
    100c:	72505f79 	subsvc	r5, r0, #484	; 0x1e4
    1010:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1014:	63530073 	cmpvs	r3, #115	; 0x73
    1018:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
    101c:	6700656c 	strvs	r6, [r0, -ip, ror #10]
    1020:	6d5f7465 	cfldrdvs	mvd7, [pc, #-404]	; e94 <_start-0x716c>
    1024:	6c65646f 	cfstrdvs	mvd6, [r5], #-444	; 0xfffffe44
    1028:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    102c:	69433531 	stmdbvs	r3, {r0, r4, r5, r8, sl, ip, sp}^
    1030:	6c756372 	ldclvs	3, cr6, [r5], #-456	; 0xfffffe38
    1034:	425f7261 	subsmi	r7, pc, #268435462	; 0x10000006
    1038:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
    103c:	72773572 	rsbsvc	r3, r7, #478150656	; 0x1c800000
    1040:	45657469 	strbmi	r7, [r5, #-1129]!	; 0xfffffb97
    1044:	006a6350 	rsbeq	r6, sl, r0, asr r3
    1048:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    104c:	70757272 	rsbsvc	r7, r5, r2, ror r2
    1050:	79745f74 	ldmdbvc	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1054:	5f006570 	svcpl	0x00006570
    1058:	30314e5a 	eorscc	r4, r1, sl, asr lr
    105c:	6f726843 	svcvs	0x00726843
    1060:	6f736f6d 	svcvs	0x00736f6d
    1064:	746c656d 	strbtvc	r6, [ip], #-1389	; 0xfffffa93
    1068:	534b5245 	movtpl	r5, #45637	; 0xb245
    106c:	5a5f005f 	bpl	17c11f0 <__bss_end+0x17b5adc>
    1070:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
    1074:	636f7250 	cmnvs	pc, #80, 4
    1078:	5f737365 	svcpl	0x00737365
    107c:	616e614d 	cmnvs	lr, sp, asr #2
    1080:	39726567 	ldmdbcc	r2!, {r0, r1, r2, r5, r6, r8, sl, sp, lr}^
    1084:	74697753 	strbtvc	r7, [r9], #-1875	; 0xfffff8ad
    1088:	545f6863 	ldrbpl	r6, [pc], #-2147	; 1090 <_start-0x6f70>
    108c:	3150456f 	cmpcc	r0, pc, ror #10
    1090:	72504338 	subsvc	r4, r0, #56, 6	; 0xe0000000
    1094:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1098:	694c5f73 	stmdbvs	ip, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    109c:	4e5f7473 	mrcmi	4, 2, r7, cr15, cr3, {3}
    10a0:	0065646f 	rsbeq	r6, r5, pc, ror #8
    10a4:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
    10a8:	6f6c665f 	svcvs	0x006c665f
    10ac:	765f7461 	ldrbvc	r7, [pc], -r1, ror #8
    10b0:	53006c61 	movwpl	r6, #3169	; 0xc61
    10b4:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    10b8:	5f656c75 	svcpl	0x00656c75
    10bc:	5f005252 	svcpl	0x00005252
    10c0:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
    10c4:	6f725043 	svcvs	0x00725043
    10c8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    10cc:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    10d0:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    10d4:	61483831 	cmpvs	r8, r1, lsr r8
    10d8:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    10dc:	6f72505f 	svcvs	0x0072505f
    10e0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    10e4:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
    10e8:	4e303245 	cdpmi	2, 3, cr3, cr0, cr5, {2}
    10ec:	5f495753 	svcpl	0x00495753
    10f0:	636f7250 	cmnvs	pc, #80, 4
    10f4:	5f737365 	svcpl	0x00737365
    10f8:	76726553 			; <UNDEFINED> instruction: 0x76726553
    10fc:	6a656369 	bvs	1959ea8 <__bss_end+0x194e794>
    1100:	31526a6a 	cmpcc	r2, sl, ror #20
    1104:	57535431 	smmlarpl	r3, r1, r4, r5
    1108:	65525f49 	ldrbvs	r5, [r2, #-3913]	; 0xfffff0b7
    110c:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
    1110:	67726100 	ldrbvs	r6, [r2, -r0, lsl #2]!
    1114:	494e0076 	stmdbmi	lr, {r1, r2, r4, r5, r6}^
    1118:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
    111c:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
    1120:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
    1124:	5f006e6f 	svcpl	0x00006e6f
    1128:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
    112c:	6f725043 	svcvs	0x00725043
    1130:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1134:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    1138:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    113c:	72433431 	subvc	r3, r3, #822083584	; 0x31000000
    1140:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
    1144:	6f72505f 	svcvs	0x0072505f
    1148:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    114c:	6a685045 	bvs	1a15268 <__bss_end+0x1a09b54>
    1150:	77530062 	ldrbvc	r0, [r3, -r2, rrx]
    1154:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
    1158:	006f545f 	rsbeq	r5, pc, pc, asr r4	; <UNPREDICTABLE>
    115c:	314e5a5f 	cmpcc	lr, pc, asr sl
    1160:	6e654730 	mcrvs	7, 3, r4, cr5, cr0, {1}
    1164:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
    1168:	386e6f69 	stmdacc	lr!, {r0, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    116c:	7478656e 	ldrbtvc	r6, [r8], #-1390	; 0xfffffa92
    1170:	6e65675f 	mcrvs	7, 3, r6, cr5, cr15, {2}
    1174:	5f535045 	svcpl	0x00535045
    1178:	57534e00 	ldrbpl	r4, [r3, -r0, lsl #28]
    117c:	69465f49 	stmdbvs	r6, {r0, r3, r6, r8, r9, sl, fp, ip, lr}^
    1180:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
    1184:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
    1188:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
    118c:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
    1190:	6e656700 	cdpvs	7, 6, cr6, cr5, cr0, {0}
    1194:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
    1198:	6e695f65 	cdpvs	15, 6, cr5, cr9, cr5, {3}
    119c:	5a5f0074 	bpl	17c1374 <__bss_end+0x17b5c60>
    11a0:	4730314e 	ldrmi	r3, [r0, -lr, asr #2]!
    11a4:	72656e65 	rsbvc	r6, r5, #1616	; 0x650
    11a8:	6f697461 	svcvs	0x00697461
    11ac:	7270376e 	rsbsvc	r3, r0, #28835840	; 0x1b80000
    11b0:	63696465 	cmnvs	r9, #1694498816	; 0x65000000
    11b4:	69664574 	stmdbvs	r6!, {r2, r4, r5, r6, r8, sl, lr}^
    11b8:	5f524200 	svcpl	0x00524200
    11bc:	30303231 	eorscc	r3, r0, r1, lsr r2
    11c0:	6c617600 	stclvs	6, cr7, [r1], #-0
    11c4:	5f736575 	svcpl	0x00736575
    11c8:	66667562 	strbtvs	r7, [r6], -r2, ror #10
    11cc:	49007265 	stmdbmi	r0, {r0, r2, r5, r6, r9, ip, sp, lr}
    11d0:	6c61766e 	stclvs	6, cr7, [r1], #-440	; 0xfffffe48
    11d4:	485f6469 	ldmdami	pc, {r0, r3, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
    11d8:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
    11dc:	6c420065 	mcrrvs	0, 6, r0, r2, cr5
    11e0:	5f6b636f 	svcpl	0x006b636f
    11e4:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
    11e8:	5f746e65 	svcpl	0x00746e65
    11ec:	636f7250 	cmnvs	pc, #80, 4
    11f0:	00737365 	rsbseq	r7, r3, r5, ror #6
    11f4:	314e5a5f 	cmpcc	lr, pc, asr sl
    11f8:	61655230 	cmnvs	r5, r0, lsr r2
    11fc:	74555f64 	ldrbvc	r5, [r5], #-3940	; 0xfffff09c
    1200:	39736c69 	ldmdbcc	r3!, {r0, r3, r5, r6, sl, fp, sp, lr}^
    1204:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
    1208:	6e696c5f 	mcrvs	12, 3, r6, cr9, cr15, {2}
    120c:	63504565 	cmpvs	r0, #423624704	; 0x19400000
    1210:	4200626a 	andmi	r6, r0, #-1610612730	; 0xa0000006
    1214:	36395f52 	shsaxcc	r5, r9, r2
    1218:	72003030 	andvc	r3, r0, #48	; 0x30
    121c:	00646165 	rsbeq	r6, r4, r5, ror #2
    1220:	736f6c43 	cmnvc	pc, #17152	; 0x4300
    1224:	72610065 	rsbvc	r0, r1, #101	; 0x65
    1228:	68006367 	stmdavs	r0, {r0, r1, r2, r5, r6, r8, r9, sp, lr}
    122c:	5f706165 	svcpl	0x00706165
    1230:	72617473 	rsbvc	r7, r1, #1929379840	; 0x73000000
    1234:	69430074 	stmdbvs	r3, {r2, r4, r5, r6}^
    1238:	6c756372 	ldclvs	3, cr6, [r5], #-456	; 0xfffffe38
    123c:	425f7261 	subsmi	r7, pc, #268435462	; 0x10000006
    1240:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
    1244:	554e0072 	strbpl	r0, [lr, #-114]	; 0xffffff8e
    1248:	5f545241 	svcpl	0x00545241
    124c:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
    1250:	70757272 	rsbsvc	r7, r5, r2, ror r2
    1254:	79545f74 	ldmdbvc	r4, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1258:	67006570 	smlsdxvs	r0, r0, r5, r6
    125c:	665f7465 	ldrbvs	r7, [pc], -r5, ror #8
    1260:	656e7469 	strbvs	r7, [lr, #-1129]!	; 0xfffffb97
    1264:	4d007373 	stcmi	3, cr7, [r0, #-460]	; 0xfffffe34
    1268:	6c65646f 	cfstrdvs	mvd6, [r5], #-444	; 0xfffffe44
    126c:	69725700 	ldmdbvs	r2!, {r8, r9, sl, ip, lr}^
    1270:	4f5f6574 	svcmi	0x005f6574
    1274:	00796c6e 	rsbseq	r6, r9, lr, ror #24
    1278:	314e5a5f 	cmpcc	lr, pc, asr sl
    127c:	72684330 	rsbvc	r4, r8, #48, 6	; 0xc0000000
    1280:	736f6d6f 	cmnvc	pc, #7104	; 0x1bc0
    1284:	67656d6f 	strbvs	r6, [r5, -pc, ror #26]!
    1288:	4b524574 	blmi	1492860 <__bss_end+0x148714c>
    128c:	70005f53 	andvc	r5, r0, r3, asr pc
    1290:	69646572 	stmdbvs	r4!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    1294:	59007463 	stmdbpl	r0, {r0, r1, r5, r6, sl, ip, sp, lr}
    1298:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
    129c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    12a0:	50433631 	subpl	r3, r3, r1, lsr r6
    12a4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    12a8:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 10e4 <_start-0x6f1c>
    12ac:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    12b0:	34437265 	strbcc	r7, [r3], #-613	; 0xfffffd9b
    12b4:	63007645 	movwvs	r7, #1605	; 0x645
    12b8:	5f726168 	svcpl	0x00726168
    12bc:	676e656c 	strbvs	r6, [lr, -ip, ror #10]!
    12c0:	54006874 	strpl	r6, [r0], #-2164	; 0xfffff78c
    12c4:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
    12c8:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
    12cc:	434f4900 	movtmi	r4, #63744	; 0xf900
    12d0:	5f006c74 	svcpl	0x00006c74
    12d4:	33314e5a 	teqcc	r1, #1440	; 0x5a0
    12d8:	5f646e52 	svcpl	0x00646e52
    12dc:	656e6547 	strbvs	r6, [lr, #-1351]!	; 0xfffffab9
    12e0:	6f746172 	svcvs	0x00746172
    12e4:	73333172 	teqvc	r3, #-2147483620	; 0x8000001c
    12e8:	675f7465 	ldrbvs	r7, [pc, -r5, ror #8]
    12ec:	72656e65 	rsbvc	r6, r5, #1616	; 0x650
    12f0:	726f7461 	rsbvc	r7, pc, #1627389952	; 0x61000000
    12f4:	79006a45 	stmdbvc	r0, {r0, r2, r6, r9, fp, sp, lr}
    12f8:	72705f74 	rsbsvc	r5, r0, #116, 30	; 0x1d0
    12fc:	74006465 	strvc	r6, [r0], #-1125	; 0xfffffb9b
    1300:	746c6564 	strbtvc	r6, [ip], #-1380	; 0xfffffa9c
    1304:	74620061 	strbtvc	r0, [r2], #-97	; 0xffffff9f
    1308:	006c6156 	rsbeq	r6, ip, r6, asr r1
    130c:	4377656e 	cmnmi	r7, #461373440	; 0x1b800000
    1310:	6d6f7268 	sfmvs	f7, 2, [pc, #-416]!	; 1178 <_start-0x6e88>
    1314:	6d6f736f 	stclvs	3, cr7, [pc, #-444]!	; 1160 <_start-0x6ea0>
    1318:	68740065 	ldmdavs	r4!, {r0, r2, r5, r6}^
    131c:	6d007369 	stcvs	3, cr7, [r0, #-420]	; 0xfffffe5c
    1320:	75736165 	ldrbvc	r6, [r3, #-357]!	; 0xfffffe9b
    1324:	5f646572 	svcpl	0x00646572
    1328:	756c6176 	strbvc	r6, [ip, #-374]!	; 0xfffffe8a
    132c:	65640065 	strbvs	r0, [r4, #-101]!	; 0xffffff9b
    1330:	61766972 	cmnvs	r6, r2, ror r9
    1334:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    1338:	68746f00 	ldmdavs	r4!, {r8, r9, sl, fp, sp, lr}^
    133c:	2f007265 	svccs	0x00007265
    1340:	2f746e6d 	svccs	0x00746e6d
    1344:	73752f63 	cmnvc	r5, #396	; 0x18c
    1348:	702f7265 	eorvc	r7, pc, r5, ror #4
    134c:	61766972 	cmnvs	r6, r2, ror r9
    1350:	6f576574 	svcvs	0x00576574
    1354:	70736b72 	rsbsvc	r6, r3, r2, ror fp
    1358:	2f656361 	svccs	0x00656361
    135c:	6f686353 	svcvs	0x00686353
    1360:	4f2f6c6f 	svcmi	0x002f6c6f
    1364:	50532f53 	subspl	r2, r3, r3, asr pc
    1368:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
    136c:	4f54522d 	svcmi	0x0054522d
    1370:	6f732f53 	svcvs	0x00732f53
    1374:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    1378:	73752f73 	cmnvc	r5, #460	; 0x1cc
    137c:	70737265 	rsbsvc	r7, r3, r5, ror #4
    1380:	2f656361 	svccs	0x00656361
    1384:	656d6573 	strbvs	r6, [sp, #-1395]!	; 0xfffffa8d
    1388:	61727473 	cmnvs	r2, r3, ror r4
    138c:	61745f6c 	cmnvs	r4, ip, ror #30
    1390:	732f6b73 			; <UNDEFINED> instruction: 0x732f6b73
    1394:	652f6372 	strvs	r6, [pc, #-882]!	; 102a <_start-0x6fd6>
    1398:	756c6f76 	strbvc	r6, [ip, #-3958]!	; 0xfffff08a
    139c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    13a0:	7268632f 	rsbvc	r6, r8, #-1140850688	; 0xbc000000
    13a4:	736f6d6f 	cmnvc	pc, #7104	; 0x1bc0
    13a8:	2e656d6f 	cdpcs	13, 6, cr6, cr5, cr15, {3}
    13ac:	00707063 	rsbseq	r7, r0, r3, rrx
    13b0:	73726966 	cmnvc	r2, #1671168	; 0x198000
    13b4:	72615074 	rsbvc	r5, r1, #116	; 0x74
    13b8:	49746e65 	ldmdbmi	r4!, {r0, r2, r5, r6, r9, sl, fp, sp, lr}^
    13bc:	7865646e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, sp, lr}^
    13c0:	72726100 	rsbsvc	r6, r2, #0, 2
    13c4:	73007961 	movwvc	r7, #2401	; 0x961
    13c8:	6e6f6365 	cdpvs	3, 6, cr6, cr15, cr5, {3}
    13cc:	72615064 	rsbvc	r5, r1, #100	; 0x64
    13d0:	00746e65 	rsbseq	r6, r4, r5, ror #28
    13d4:	706d6574 	rsbvc	r6, sp, r4, ror r5
    13d8:	69757100 	ldmdbvs	r5!, {r8, ip, sp, lr}^
    13dc:	6f736b63 	svcvs	0x00736b63
    13e0:	433c7472 	teqmi	ip, #1912602624	; 0x72000000
    13e4:	6d6f7268 	sfmvs	f7, 2, [pc, #-416]!	; 124c <_start-0x6db4>
    13e8:	6d6f736f 	stclvs	3, cr7, [pc, #-444]!	; 1234 <_start-0x6dcc>
    13ec:	63003e65 	movwvs	r3, #3685	; 0xe65
    13f0:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
    13f4:	7459746e 	ldrbvc	r7, [r9], #-1134	; 0xfffffb92
    13f8:	395a5f00 	ldmdbcc	sl, {r8, r9, sl, fp, ip, lr}^
    13fc:	63697571 	cmnvs	r9, #473956352	; 0x1c400000
    1400:	726f736b 	rsbvc	r7, pc, #-1409286143	; 0xac000001
    1404:	30314974 	eorscc	r4, r1, r4, ror r9
    1408:	6f726843 	svcvs	0x00726843
    140c:	6f736f6d 	svcvs	0x00736f6d
    1410:	7645656d 	strbvc	r6, [r5], -sp, ror #10
    1414:	695f5450 	ldmdbvs	pc, {r4, r6, sl, ip, lr}^	; <UNPREDICTABLE>
    1418:	6d2f0069 	stcvs	0, cr0, [pc, #-420]!	; 127c <_start-0x6d84>
    141c:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
    1420:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
    1424:	72702f72 	rsbsvc	r2, r0, #456	; 0x1c8
    1428:	74617669 	strbtvc	r7, [r1], #-1641	; 0xfffff997
    142c:	726f5765 	rsbvc	r5, pc, #26476544	; 0x1940000
    1430:	6170736b 	cmnvs	r0, fp, ror #6
    1434:	532f6563 			; <UNDEFINED> instruction: 0x532f6563
    1438:	6f6f6863 	svcvs	0x006f6863
    143c:	534f2f6c 	movtpl	r2, #65388	; 0xff6c
    1440:	2f50532f 	svccs	0x0050532f
    1444:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
    1448:	534f5452 	movtpl	r5, #62546	; 0xf452
    144c:	756f732f 	strbvc	r7, [pc, #-815]!	; 1125 <_start-0x6edb>
    1450:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    1454:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
    1458:	61707372 	cmnvs	r0, r2, ror r3
    145c:	732f6563 			; <UNDEFINED> instruction: 0x732f6563
    1460:	73656d65 	cmnvc	r5, #6464	; 0x1940
    1464:	6c617274 	sfmvs	f7, 2, [r1], #-464	; 0xfffffe30
    1468:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
    146c:	72732f6b 	rsbsvc	r2, r3, #428	; 0x1ac
    1470:	76652f63 	strbtvc	r2, [r5], -r3, ror #30
    1474:	74756c6f 	ldrbtvc	r6, [r5], #-3183	; 0xfffff391
    1478:	2f6e6f69 	svccs	0x006e6f69
    147c:	656e6567 	strbvs	r6, [lr, #-1383]!	; 0xfffffa99
    1480:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
    1484:	632e6e6f 			; <UNDEFINED> instruction: 0x632e6e6f
    1488:	73007070 	movwvc	r7, #112	; 0x70
    148c:	3c706177 	ldfcce	f6, [r0], #-476	; 0xfffffe24
    1490:	6f726843 	svcvs	0x00726843
    1494:	6f736f6d 	svcvs	0x00736f6d
    1498:	003e656d 	eorseq	r6, lr, sp, ror #10
    149c:	73726966 	cmnvc	r2, #1671168	; 0x198000
    14a0:	72615074 	rsbvc	r5, r1, #116	; 0x74
    14a4:	00746e65 	rsbseq	r6, r4, r5, ror #28
    14a8:	6f636573 	svcvs	0x00636573
    14ac:	6150646e 	cmpvs	r0, lr, ror #8
    14b0:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
    14b4:	65646e49 	strbvs	r6, [r4, #-3657]!	; 0xfffff1b7
    14b8:	5a5f0078 	bpl	17c16a0 <__bss_end+0x17b5f8c>
    14bc:	61777334 	cmnvs	r7, r4, lsr r3
    14c0:	30314970 	eorscc	r4, r1, r0, ror r9
    14c4:	6f726843 	svcvs	0x00726843
    14c8:	6f736f6d 	svcvs	0x00736f6d
    14cc:	7645656d 	strbvc	r6, [r5], -sp, ror #10
    14d0:	535f5452 	cmppl	pc, #1375731712	; 0x52000000
    14d4:	6d005f32 	stcvs	15, cr5, [r0, #-200]	; 0xffffff38
    14d8:	61737365 	cmnvs	r3, r5, ror #6
    14dc:	75426567 	strbvc	r6, [r2, #-1383]	; 0xfffffa99
    14e0:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
    14e4:	375a5f00 	ldrbcc	r5, [sl, -r0, lsl #30]
    14e8:	6e697270 	mcrvs	2, 3, r7, cr9, cr0, {3}
    14ec:	6a6e6c74 	bvs	1b9c6c4 <__bss_end+0x1b90fb0>
    14f0:	00634b50 	rsbeq	r4, r3, r0, asr fp
    14f4:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    14f8:	2f00676e 	svccs	0x0000676e
    14fc:	2f746e6d 	svccs	0x00746e6d
    1500:	73752f63 	cmnvc	r5, #396	; 0x18c
    1504:	702f7265 	eorvc	r7, pc, r5, ror #4
    1508:	61766972 	cmnvs	r6, r2, ror r9
    150c:	6f576574 	svcvs	0x00576574
    1510:	70736b72 	rsbsvc	r6, r3, r2, ror fp
    1514:	2f656361 	svccs	0x00656361
    1518:	6f686353 	svcvs	0x00686353
    151c:	4f2f6c6f 	svcmi	0x002f6c6f
    1520:	50532f53 	subspl	r2, r3, r3, asr pc
    1524:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
    1528:	4f54522d 	svcmi	0x0054522d
    152c:	6f732f53 	svcvs	0x00732f53
    1530:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    1534:	73752f73 	cmnvc	r5, #460	; 0x1cc
    1538:	70737265 	rsbsvc	r7, r3, r5, ror #4
    153c:	2f656361 	svccs	0x00656361
    1540:	656d6573 	strbvs	r6, [sp, #-1395]!	; 0xfffffa8d
    1544:	61727473 	cmnvs	r2, r3, ror r4
    1548:	61745f6c 	cmnvs	r4, ip, ror #30
    154c:	732f6b73 			; <UNDEFINED> instruction: 0x732f6b73
    1550:	752f6372 	strvc	r6, [pc, #-882]!	; 11e6 <_start-0x6e1a>
    1554:	736c6974 	cmnvc	ip, #116, 18	; 0x1d0000
    1558:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    155c:	315a5f00 	cmpcc	sl, r0, lsl #30
    1560:	69727039 	ldmdbvs	r2!, {r0, r3, r4, r5, ip, sp, lr}^
    1564:	735f746e 	cmpvc	pc, #1845493760	; 0x6e000000
    1568:	615f7274 	cmpvs	pc, r4, ror r2	; <UNPREDICTABLE>
    156c:	665f646e 	ldrbvs	r6, [pc], -lr, ror #8
    1570:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    1574:	634b506a 	movtvs	r5, #45162	; 0xb06a
    1578:	6d740066 	ldclvs	0, cr0, [r4, #-408]!	; 0xfffffe68
    157c:	66754270 			; <UNDEFINED> instruction: 0x66754270
    1580:	00726566 	rsbseq	r6, r2, r6, ror #10
    1584:	6e697270 	mcrvs	2, 3, r7, cr9, cr0, {3}
    1588:	006e6c74 	rsbeq	r6, lr, r4, ror ip
    158c:	6e697270 	mcrvs	2, 3, r7, cr9, cr0, {3}
    1590:	74735f74 	ldrbtvc	r5, [r3], #-3956	; 0xfffff08c
    1594:	6e615f72 	mcrvs	15, 3, r5, cr1, cr2, {3}
    1598:	6c665f64 	stclvs	15, cr5, [r6], #-400	; 0xfffffe70
    159c:	0074616f 	rsbseq	r6, r4, pc, ror #2
    15a0:	74757066 	ldrbtvc	r7, [r5], #-102	; 0xffffff9a
    15a4:	5a5f0073 	bpl	17c1778 <__bss_end+0x17b6064>
    15a8:	75706635 	ldrbvc	r6, [r0, #-1589]!	; 0xfffff9cb
    15ac:	506a7374 	rsbpl	r7, sl, r4, ror r3
    15b0:	6300634b 	movwvs	r6, #843	; 0x34b
    15b4:	65736f6c 	ldrbvs	r6, [r3, #-3948]!	; 0xfffff094
    15b8:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
    15bc:	6c65525f 	sfmvs	f5, 2, [r5], #-380	; 0xfffffe84
    15c0:	76697461 	strbtvc	r7, [r9], -r1, ror #8
    15c4:	65720065 	ldrbvs	r0, [r2, #-101]!	; 0xffffff9b
    15c8:	6c617674 	stclvs	6, cr7, [r1], #-464	; 0xfffffe30
    15cc:	75636e00 	strbvc	r6, [r3, #-3584]!	; 0xfffff200
    15d0:	69700072 	ldmdbvs	r0!, {r1, r4, r5, r6}^
    15d4:	72006570 	andvc	r6, r0, #112, 10	; 0x1c000000
    15d8:	6d756e64 	ldclvs	14, cr6, [r5, #-400]!	; 0xfffffe70
    15dc:	315a5f00 	cmpcc	sl, r0, lsl #30
    15e0:	68637331 	stmdavs	r3!, {r0, r4, r5, r8, r9, ip, sp, lr}^
    15e4:	795f6465 	ldmdbvc	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
    15e8:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
    15ec:	5a5f0076 	bpl	17c17cc <__bss_end+0x17b60b8>
    15f0:	65733731 	ldrbvs	r3, [r3, #-1841]!	; 0xfffff8cf
    15f4:	61745f74 	cmnvs	r4, r4, ror pc
    15f8:	645f6b73 	ldrbvs	r6, [pc], #-2931	; 1600 <_start-0x6a00>
    15fc:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
    1600:	6a656e69 	bvs	195cfac <__bss_end+0x1951898>
    1604:	69617700 	stmdbvs	r1!, {r8, r9, sl, ip, sp, lr}^
    1608:	5a5f0074 	bpl	17c17e0 <__bss_end+0x17b60cc>
    160c:	746f6e36 	strbtvc	r6, [pc], #-3638	; 1614 <_start-0x69ec>
    1610:	6a796669 	bvs	1e5afbc <__bss_end+0x1e4f8a8>
    1614:	6146006a 	cmpvs	r6, sl, rrx
    1618:	65006c69 	strvs	r6, [r0, #-3177]	; 0xfffff397
    161c:	63746978 	cmnvs	r4, #120, 18	; 0x1e0000
    1620:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1624:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
    1628:	69795f64 	ldmdbvs	r9!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    162c:	00646c65 	rsbeq	r6, r4, r5, ror #24
    1630:	6b636974 	blvs	18dbc08 <__bss_end+0x18d04f4>
    1634:	756f635f 	strbvc	r6, [pc, #-863]!	; 12dd <_start-0x6d23>
    1638:	725f746e 	subsvc	r7, pc, #1845493760	; 0x6e000000
    163c:	69757165 	ldmdbvs	r5!, {r0, r2, r5, r6, r8, ip, sp, lr}^
    1640:	00646572 	rsbeq	r6, r4, r2, ror r5
    1644:	34325a5f 	ldrtcc	r5, [r2], #-2655	; 0xfffff5a1
    1648:	5f746567 	svcpl	0x00746567
    164c:	69746361 	ldmdbvs	r4!, {r0, r5, r6, r8, r9, sp, lr}^
    1650:	705f6576 	subsvc	r6, pc, r6, ror r5	; <UNPREDICTABLE>
    1654:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1658:	635f7373 	cmpvs	pc, #-872415231	; 0xcc000001
    165c:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    1660:	69500076 	ldmdbvs	r0, {r1, r2, r4, r5, r6}^
    1664:	465f6570 			; <UNDEFINED> instruction: 0x465f6570
    1668:	5f656c69 	svcpl	0x00656c69
    166c:	66657250 			; <UNDEFINED> instruction: 0x66657250
    1670:	5f007869 	svcpl	0x00007869
    1674:	6734315a 			; <UNDEFINED> instruction: 0x6734315a
    1678:	745f7465 	ldrbvc	r7, [pc], #-1125	; 1680 <_start-0x6980>
    167c:	5f6b6369 	svcpl	0x006b6369
    1680:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    1684:	73007674 	movwvc	r7, #1652	; 0x674
    1688:	7065656c 	rsbvc	r6, r5, ip, ror #10
    168c:	395a5f00 	ldmdbcc	sl, {r8, r9, sl, fp, ip, lr}^
    1690:	6d726574 	cfldr64vs	mvdx6, [r2, #-464]!	; 0xfffffe30
    1694:	74616e69 	strbtvc	r6, [r1], #-3689	; 0xfffff197
    1698:	6f006965 	svcvs	0x00006965
    169c:	61726570 	cmnvs	r2, r0, ror r5
    16a0:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    16a4:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    16a8:	736f6c63 	cmnvc	pc, #25344	; 0x6300
    16ac:	5f006a65 	svcpl	0x00006a65
    16b0:	6567365a 	strbvs	r3, [r7, #-1626]!	; 0xfffff9a6
    16b4:	64697074 	strbtvs	r7, [r9], #-116	; 0xffffff8c
    16b8:	6e660076 	mcrvs	0, 3, r0, cr6, cr6, {3}
    16bc:	00656d61 	rsbeq	r6, r5, r1, ror #26
    16c0:	6b636974 	blvs	18dbc98 <__bss_end+0x18d0584>
    16c4:	706f0073 	rsbvc	r0, pc, r3, ror r0	; <UNPREDICTABLE>
    16c8:	5f006e65 	svcpl	0x00006e65
    16cc:	6970345a 	ldmdbvs	r0!, {r1, r3, r4, r6, sl, ip, sp}^
    16d0:	4b506570 	blmi	141ac98 <__bss_end+0x140f584>
    16d4:	4e006a63 	vmlsmi.f32	s12, s0, s7
    16d8:	64616544 	strbtvs	r6, [r1], #-1348	; 0xfffffabc
    16dc:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    16e0:	6275535f 	rsbsvs	r5, r5, #2080374785	; 0x7c000001
    16e4:	76726573 			; <UNDEFINED> instruction: 0x76726573
    16e8:	00656369 	rsbeq	r6, r5, r9, ror #6
    16ec:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
    16f0:	752f632f 	strvc	r6, [pc, #-815]!	; 13c9 <_start-0x6c37>
    16f4:	2f726573 	svccs	0x00726573
    16f8:	76697270 			; <UNDEFINED> instruction: 0x76697270
    16fc:	57657461 	strbpl	r7, [r5, -r1, ror #8]!
    1700:	736b726f 	cmnvc	fp, #-268435450	; 0xf0000006
    1704:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
    1708:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
    170c:	2f6c6f6f 	svccs	0x006c6f6f
    1710:	532f534f 			; <UNDEFINED> instruction: 0x532f534f
    1714:	494b2f50 	stmdbmi	fp, {r4, r6, r8, r9, sl, fp, sp}^
    1718:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
    171c:	732f534f 			; <UNDEFINED> instruction: 0x732f534f
    1720:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    1724:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
    1728:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
    172c:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
    1730:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
    1734:	6c696664 	stclvs	6, cr6, [r9], #-400	; 0xfffffe70
    1738:	70632e65 	rsbvc	r2, r3, r5, ror #28
    173c:	65670070 	strbvs	r0, [r7, #-112]!	; 0xffffff90
    1740:	69745f74 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1744:	635f6b63 	cmpvs	pc, #101376	; 0x18c00
    1748:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    174c:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    1750:	74697277 	strbtvc	r7, [r9], #-631	; 0xfffffd89
    1754:	4b506a65 	blmi	141c0f0 <__bss_end+0x14109dc>
    1758:	67006a63 	strvs	r6, [r0, -r3, ror #20]
    175c:	745f7465 	ldrbvc	r7, [pc], #-1125	; 1764 <_start-0x689c>
    1760:	5f6b7361 	svcpl	0x006b7361
    1764:	6b636974 	blvs	18dbd3c <__bss_end+0x18d0628>
    1768:	6f745f73 	svcvs	0x00745f73
    176c:	6165645f 	cmnvs	r5, pc, asr r4
    1770:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
    1774:	75620065 	strbvc	r0, [r2, #-101]!	; 0xffffff9b
    1778:	69735f66 	ldmdbvs	r3!, {r1, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    177c:	4700657a 	smlsdxmi	r0, sl, r5, r6
    1780:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
    1784:	34312b2b 	ldrtcc	r2, [r1], #-2859	; 0xfffff4d5
    1788:	2e303120 	rsfcssp	f3, f0, f0
    178c:	20302e33 	eorscs	r2, r0, r3, lsr lr
    1790:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
    1794:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
    1798:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
    179c:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    17a0:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    17a4:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
    17a8:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    17ac:	6f6c666d 	svcvs	0x006c666d
    17b0:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
    17b4:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
    17b8:	20647261 	rsbcs	r7, r4, r1, ror #4
    17bc:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
    17c0:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
    17c4:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
    17c8:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    17cc:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
    17d0:	36373131 			; <UNDEFINED> instruction: 0x36373131
    17d4:	2d667a6a 	vstmdbcs	r6!, {s15-s120}
    17d8:	6d2d2073 	stcvs	0, cr2, [sp, #-460]!	; 0xfffffe34
    17dc:	206d7261 	rsbcs	r7, sp, r1, ror #4
    17e0:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    17e4:	613d6863 	teqvs	sp, r3, ror #16
    17e8:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    17ec:	662b6b7a 			; <UNDEFINED> instruction: 0x662b6b7a
    17f0:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
    17f4:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    17f8:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    17fc:	2d20304f 	stccs	0, cr3, [r0, #-316]!	; 0xfffffec4
    1800:	2d20304f 	stccs	0, cr3, [r0, #-316]!	; 0xfffffec4
    1804:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 1674 <_start-0x698c>
    1808:	65637865 	strbvs	r7, [r3, #-2149]!	; 0xfffff79b
    180c:	6f697470 	svcvs	0x00697470
    1810:	2d20736e 	stccs	3, cr7, [r0, #-440]!	; 0xfffffe48
    1814:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 1684 <_start-0x697c>
    1818:	69747472 	ldmdbvs	r4!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    181c:	74657300 	strbtvc	r7, [r5], #-768	; 0xfffffd00
    1820:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
    1824:	65645f6b 	strbvs	r5, [r4, #-3947]!	; 0xfffff095
    1828:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
    182c:	5f00656e 	svcpl	0x0000656e
    1830:	6c73355a 	cfldr64vs	mvdx3, [r3], #-360	; 0xfffffe98
    1834:	6a706565 	bvs	1c1add0 <__bss_end+0x1c0f6bc>
    1838:	6547006a 	strbvs	r0, [r7, #-106]	; 0xffffff96
    183c:	65525f74 	ldrbvs	r5, [r2, #-3956]	; 0xfffff08c
    1840:	6e69616d 	powvsez	f6, f1, #5.0
    1844:	00676e69 	rsbeq	r6, r7, r9, ror #28
    1848:	36325a5f 			; <UNDEFINED> instruction: 0x36325a5f
    184c:	5f746567 	svcpl	0x00746567
    1850:	6b736174 	blvs	1cd9e28 <__bss_end+0x1cce714>
    1854:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
    1858:	745f736b 	ldrbvc	r7, [pc], #-875	; 1860 <_start-0x67a0>
    185c:	65645f6f 	strbvs	r5, [r4, #-3951]!	; 0xfffff091
    1860:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
    1864:	0076656e 	rsbseq	r6, r6, lr, ror #10
    1868:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
    186c:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
    1870:	5f746c75 	svcpl	0x00746c75
    1874:	65646f43 	strbvs	r6, [r4, #-3907]!	; 0xfffff0bd
    1878:	6e727700 	cdpvs	7, 7, cr7, cr2, cr0, {0}
    187c:	5f006d75 	svcpl	0x00006d75
    1880:	6177345a 	cmnvs	r7, sl, asr r4
    1884:	6a6a7469 	bvs	1a9ea30 <__bss_end+0x1a9331c>
    1888:	5a5f006a 	bpl	17c1a38 <__bss_end+0x17b6324>
    188c:	636f6935 	cmnvs	pc, #868352	; 0xd4000
    1890:	316a6c74 	smccc	42692	; 0xa6c4
    1894:	4f494e36 	svcmi	0x00494e36
    1898:	5f6c7443 	svcpl	0x006c7443
    189c:	7265704f 	rsbvc	r7, r5, #79	; 0x4f
    18a0:	6f697461 	svcvs	0x00697461
    18a4:	0076506e 	rsbseq	r5, r6, lr, rrx
    18a8:	74636f69 	strbtvc	r6, [r3], #-3945	; 0xfffff097
    18ac:	6572006c 	ldrbvs	r0, [r2, #-108]!	; 0xffffff94
    18b0:	746e6374 	strbtvc	r6, [lr], #-884	; 0xfffffc8c
    18b4:	746f6e00 	strbtvc	r6, [pc], #-3584	; 18bc <_start-0x6744>
    18b8:	00796669 	rsbseq	r6, r9, r9, ror #12
    18bc:	6d726574 	cfldr64vs	mvdx6, [r2, #-464]!	; 0xfffffe30
    18c0:	74616e69 	strbtvc	r6, [r1], #-3689	; 0xfffff197
    18c4:	6f6d0065 	svcvs	0x006d0065
    18c8:	5f006564 	svcpl	0x00006564
    18cc:	6572345a 	ldrbvs	r3, [r2, #-1114]!	; 0xfffffba6
    18d0:	506a6461 	rsbpl	r6, sl, r1, ror #8
    18d4:	72006a63 	andvc	r6, r0, #405504	; 0x63000
    18d8:	6f637465 	svcvs	0x00637465
    18dc:	67006564 	strvs	r6, [r0, -r4, ror #10]
    18e0:	615f7465 	cmpvs	pc, r5, ror #8
    18e4:	76697463 	strbtvc	r7, [r9], -r3, ror #8
    18e8:	72705f65 	rsbsvc	r5, r0, #404	; 0x194
    18ec:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    18f0:	6f635f73 	svcvs	0x00635f73
    18f4:	00746e75 	rsbseq	r6, r4, r5, ror lr
    18f8:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
    18fc:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
    1900:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
    1904:	00646970 	rsbeq	r6, r4, r0, ror r9
    1908:	6f345a5f 	svcvs	0x00345a5f
    190c:	506e6570 	rsbpl	r6, lr, r0, ror r5
    1910:	3531634b 	ldrcc	r6, [r1, #-843]!	; 0xfffffcb5
    1914:	6c69464e 	stclvs	6, cr4, [r9], #-312	; 0xfffffec8
    1918:	704f5f65 	subvc	r5, pc, r5, ror #30
    191c:	4d5f6e65 	ldclmi	14, cr6, [pc, #-404]	; 1790 <_start-0x6870>
    1920:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1924:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
    1928:	752f632f 	strvc	r6, [pc, #-815]!	; 1601 <_start-0x69ff>
    192c:	2f726573 	svccs	0x00726573
    1930:	76697270 			; <UNDEFINED> instruction: 0x76697270
    1934:	57657461 	strbpl	r7, [r5, -r1, ror #8]!
    1938:	736b726f 	cmnvc	fp, #-268435450	; 0xf0000006
    193c:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
    1940:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
    1944:	2f6c6f6f 	svccs	0x006c6f6f
    1948:	532f534f 			; <UNDEFINED> instruction: 0x532f534f
    194c:	494b2f50 	stmdbmi	fp, {r4, r6, r8, r9, sl, fp, sp}^
    1950:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
    1954:	732f534f 			; <UNDEFINED> instruction: 0x732f534f
    1958:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    195c:	622f7365 	eorvs	r7, pc, #-1811939327	; 0x94000001
    1960:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    1964:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    1968:	72646441 	rsbvc	r6, r4, #1090519040	; 0x41000000
    196c:	00737365 	rsbseq	r7, r3, r5, ror #6
    1970:	6d365a5f 	vldmdbvs	r6!, {s10-s104}
    1974:	6f6c6c61 	svcvs	0x006c6c61
    1978:	6d006a63 	vstrvs	s12, [r0, #-396]	; 0xfffffe74
    197c:	6f6c6c61 	svcvs	0x006c6c61
    1980:	6d2f0063 	stcvs	0, cr0, [pc, #-396]!	; 17fc <_start-0x6804>
    1984:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
    1988:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
    198c:	72702f72 	rsbsvc	r2, r0, #456	; 0x1c8
    1990:	74617669 	strbtvc	r7, [r1], #-1641	; 0xfffff997
    1994:	726f5765 	rsbvc	r5, pc, #26476544	; 0x1940000
    1998:	6170736b 	cmnvs	r0, fp, ror #6
    199c:	532f6563 			; <UNDEFINED> instruction: 0x532f6563
    19a0:	6f6f6863 	svcvs	0x006f6863
    19a4:	534f2f6c 	movtpl	r2, #65388	; 0xff6c
    19a8:	2f50532f 	svccs	0x0050532f
    19ac:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
    19b0:	534f5452 	movtpl	r5, #62546	; 0xf452
    19b4:	756f732f 	strbvc	r7, [pc, #-815]!	; 168d <_start-0x6973>
    19b8:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    19bc:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    19c0:	2f62696c 	svccs	0x0062696c
    19c4:	2f637273 	svccs	0x00637273
    19c8:	6d647473 	cfstrdvs	mvd7, [r4, #-460]!	; 0xfffffe34
    19cc:	632e6d65 			; <UNDEFINED> instruction: 0x632e6d65
    19d0:	6e007070 	mcrvs	0, 0, r7, cr0, cr0, {3}
    19d4:	616d726f 	cmnvs	sp, pc, ror #4
    19d8:	657a696c 	ldrbvs	r6, [sl, #-2412]!	; 0xfffff694
    19dc:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    19e0:	636d656d 	cmnvs	sp, #457179136	; 0x1b400000
    19e4:	4b507970 	blmi	141ffac <__bss_end+0x1414898>
    19e8:	69765076 	ldmdbvs	r6!, {r1, r2, r4, r5, r6, ip, lr}^
    19ec:	6e736900 	vaddvs.f16	s13, s6, s0	; <UNPREDICTABLE>
    19f0:	5f006e61 	svcpl	0x00006e61
    19f4:	7469345a 	strbtvc	r3, [r9], #-1114	; 0xfffffba6
    19f8:	506a616f 	rsbpl	r6, sl, pc, ror #2
    19fc:	65006a63 	strvs	r6, [r0, #-2659]	; 0xfffff59d
    1a00:	6e6f7078 	mcrvs	0, 3, r7, cr15, cr8, {3}
    1a04:	00746e65 	rsbseq	r6, r4, r5, ror #28
    1a08:	696f7461 	stmdbvs	pc!, {r0, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1a0c:	72747300 	rsbsvc	r7, r4, #0, 6
    1a10:	006e656c 	rsbeq	r6, lr, ip, ror #10
    1a14:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
    1a18:	752f632f 	strvc	r6, [pc, #-815]!	; 16f1 <_start-0x690f>
    1a1c:	2f726573 	svccs	0x00726573
    1a20:	76697270 			; <UNDEFINED> instruction: 0x76697270
    1a24:	57657461 	strbpl	r7, [r5, -r1, ror #8]!
    1a28:	736b726f 	cmnvc	fp, #-268435450	; 0xf0000006
    1a2c:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
    1a30:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
    1a34:	2f6c6f6f 	svccs	0x006c6f6f
    1a38:	532f534f 			; <UNDEFINED> instruction: 0x532f534f
    1a3c:	494b2f50 	stmdbmi	fp, {r4, r6, r8, r9, sl, fp, sp}^
    1a40:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
    1a44:	732f534f 			; <UNDEFINED> instruction: 0x732f534f
    1a48:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    1a4c:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
    1a50:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
    1a54:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
    1a58:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
    1a5c:	72747364 	rsbsvc	r7, r4, #100, 6	; 0x90000001
    1a60:	2e676e69 	cdpcs	14, 6, cr6, cr7, cr9, {3}
    1a64:	00707063 	rsbseq	r7, r0, r3, rrx
    1a68:	74736564 	ldrbtvc	r6, [r3], #-1380	; 0xfffffa9c
    1a6c:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    1a70:	616e7369 	cmnvs	lr, r9, ror #6
    1a74:	634b506e 	movtvs	r5, #45166	; 0xb06e
    1a78:	69730062 	ldmdbvs	r3!, {r1, r5, r6}^
    1a7c:	69006e67 	stmdbvs	r0, {r0, r1, r2, r5, r6, r9, sl, fp, sp, lr}
    1a80:	00616f74 	rsbeq	r6, r1, r4, ror pc
    1a84:	63727473 	cmnvs	r2, #1929379840	; 0x73000000
    1a88:	5f007461 	svcpl	0x00007461
    1a8c:	7a62355a 	bvc	188effc <__bss_end+0x18838e8>
    1a90:	506f7265 	rsbpl	r7, pc, r5, ror #4
    1a94:	69006976 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, fp, sp, lr}
    1a98:	6f6c4673 	svcvs	0x006c4673
    1a9c:	73007461 	movwvc	r7, #1121	; 0x461
    1aa0:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    1aa4:	5f007970 	svcpl	0x00007970
    1aa8:	7466345a 	strbtvc	r3, [r6], #-1114	; 0xfffffba6
    1aac:	6350616f 	cmpvs	r0, #-1073741797	; 0xc000001b
    1ab0:	5a5f0066 	bpl	17c1c50 <__bss_end+0x17b653c>
    1ab4:	72747337 	rsbsvc	r7, r4, #-603979776	; 0xdc000000
    1ab8:	7970636e 	ldmdbvc	r0!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
    1abc:	4b506350 	blmi	141a804 <__bss_end+0x140f0f0>
    1ac0:	5f006963 	svcpl	0x00006963
    1ac4:	7473365a 	ldrbtvc	r3, [r3], #-1626	; 0xfffff9a6
    1ac8:	74616372 	strbtvc	r6, [r1], #-882	; 0xfffffc8e
    1acc:	4b506350 	blmi	141a814 <__bss_end+0x140f100>
    1ad0:	69640063 	stmdbvs	r4!, {r0, r1, r5, r6}^
    1ad4:	00746967 	rsbseq	r6, r4, r7, ror #18
    1ad8:	666f7461 	strbtvs	r7, [pc], -r1, ror #8
    1adc:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    1ae0:	00747364 	rsbseq	r7, r4, r4, ror #6
    1ae4:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
    1ae8:	766e6f43 	strbtvc	r6, [lr], -r3, asr #30
    1aec:	00727241 	rsbseq	r7, r2, r1, asr #4
    1af0:	616f7466 	cmnvs	pc, r6, ror #8
    1af4:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    1af8:	00637273 	rsbeq	r7, r3, r3, ror r2
    1afc:	72657a62 	rsbvc	r7, r5, #401408	; 0x62000
    1b00:	656d006f 	strbvs	r0, [sp, #-111]!	; 0xffffff91
    1b04:	7970636d 	ldmdbvc	r0!, {r0, r2, r3, r5, r6, r8, r9, sp, lr}^
    1b08:	73616200 	cmnvc	r1, #0, 4
    1b0c:	74730065 	ldrbtvc	r0, [r3], #-101	; 0xffffff9b
    1b10:	6d636e72 	stclvs	14, cr6, [r3, #-456]!	; 0xfffffe38
    1b14:	69770070 	ldmdbvs	r7!, {r4, r5, r6}^
    1b18:	00687464 	rsbeq	r7, r8, r4, ror #8
    1b1c:	61345a5f 	teqvs	r4, pc, asr sl
    1b20:	50666f74 	rsbpl	r6, r6, r4, ror pc
    1b24:	5f00634b 	svcpl	0x0000634b
    1b28:	6f6e395a 	svcvs	0x006e395a
    1b2c:	6c616d72 	stclvs	13, cr6, [r1], #-456	; 0xfffffe38
    1b30:	50657a69 	rsbpl	r7, r5, r9, ror #20
    1b34:	5a5f0066 	bpl	17c1cd4 <__bss_end+0x17b65c0>
    1b38:	72747336 	rsbsvc	r7, r4, #-671088640	; 0xd8000000
    1b3c:	506e656c 	rsbpl	r6, lr, ip, ror #10
    1b40:	5f00634b 	svcpl	0x0000634b
    1b44:	7473375a 	ldrbtvc	r3, [r3], #-1882	; 0xfffff8a6
    1b48:	6d636e72 	stclvs	14, cr6, [r3, #-456]!	; 0xfffffe38
    1b4c:	634b5070 	movtvs	r5, #45168	; 0xb070
    1b50:	695f3053 	ldmdbvs	pc, {r0, r1, r4, r6, ip, sp}^	; <UNPREDICTABLE>
    1b54:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1b58:	696f7461 	stmdbvs	pc!, {r0, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1b5c:	00634b50 	rsbeq	r4, r3, r0, asr fp
    1b60:	7074756f 	rsbsvc	r7, r4, pc, ror #10
    1b64:	6d007475 	cfstrsvs	mvf7, [r0, #-468]	; 0xfffffe2c
    1b68:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
    1b6c:	6c700079 	ldclvs	0, cr0, [r0], #-484	; 0xfffffe1c
    1b70:	73656361 	cmnvc	r5, #-2080374783	; 0x84000001
    1b74:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
    1b78:	2f632f74 	svccs	0x00632f74
    1b7c:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
    1b80:	6972702f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, ip, sp, lr}^
    1b84:	65746176 	ldrbvs	r6, [r4, #-374]!	; 0xfffffe8a
    1b88:	6b726f57 	blvs	1c9d8ec <__bss_end+0x1c921d8>
    1b8c:	63617073 	cmnvs	r1, #115	; 0x73
    1b90:	63532f65 	cmpvs	r3, #404	; 0x194
    1b94:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 19fc <_start-0x6604>
    1b98:	2f534f2f 	svccs	0x00534f2f
    1b9c:	4b2f5053 	blmi	bd5cf0 <__bss_end+0xbca5dc>
    1ba0:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
    1ba4:	2f534f54 	svccs	0x00534f54
    1ba8:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
    1bac:	2f736563 	svccs	0x00736563
    1bb0:	75647473 	strbvc	r7, [r4, #-1139]!	; 0xfffffb8d
    1bb4:	736c6974 	cmnvc	ip, #116, 18	; 0x1d0000
    1bb8:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    1bbc:	6165722f 	cmnvs	r5, pc, lsr #4
    1bc0:	74755f64 	ldrbtvc	r5, [r5], #-3940	; 0xfffff09c
    1bc4:	2e736c69 	cdpcs	12, 7, cr6, cr3, cr9, {3}
    1bc8:	00707063 	rsbseq	r7, r0, r3, rrx
    1bcc:	314e5a5f 	cmpcc	lr, pc, asr sl
    1bd0:	61655230 	cmnvs	r5, r0, lsr r2
    1bd4:	74555f64 	ldrbvc	r5, [r5], #-3940	; 0xfffff09c
    1bd8:	43736c69 	cmnmi	r3, #26880	; 0x6900
    1bdc:	00764532 	rsbseq	r4, r6, r2, lsr r5
    1be0:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
    1be4:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
    1be8:	65720073 	ldrbvs	r0, [r2, #-115]!	; 0xffffff8d
    1bec:	6e727574 	mrcvs	5, 3, r7, cr2, cr4, {3}
    1bf0:	66667542 	strbtvs	r7, [r6], -r2, asr #10
    1bf4:	62007265 	andvs	r7, r0, #1342177286	; 0x50000006
    1bf8:	6b636f6c 	blvs	18dd9b0 <__bss_end+0x18d229c>
    1bfc:	00676e69 	rsbeq	r6, r7, r9, ror #28
    1c00:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
    1c04:	66667542 	strbtvs	r7, [r6], -r2, asr #10
    1c08:	2f007265 	svccs	0x00007265
    1c0c:	2f746e6d 	svccs	0x00746e6d
    1c10:	73752f63 	cmnvc	r5, #396	; 0x18c
    1c14:	702f7265 	eorvc	r7, pc, r5, ror #4
    1c18:	61766972 	cmnvs	r6, r2, ror r9
    1c1c:	6f576574 	svcvs	0x00576574
    1c20:	70736b72 	rsbsvc	r6, r3, r2, ror fp
    1c24:	2f656361 	svccs	0x00656361
    1c28:	6f686353 	svcvs	0x00686353
    1c2c:	4f2f6c6f 	svcmi	0x002f6c6f
    1c30:	50532f53 	subspl	r2, r3, r3, asr pc
    1c34:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
    1c38:	4f54522d 	svcmi	0x0054522d
    1c3c:	6f732f53 	svcvs	0x00732f53
    1c40:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    1c44:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
    1c48:	69747564 	ldmdbvs	r4!, {r2, r5, r6, r8, sl, ip, sp, lr}^
    1c4c:	732f736c 			; <UNDEFINED> instruction: 0x732f736c
    1c50:	722f6372 	eorvc	r6, pc, #-939524095	; 0xc8000001
    1c54:	675f646e 	ldrbvs	r6, [pc, -lr, ror #8]
    1c58:	72656e65 	rsbvc	r6, r5, #1616	; 0x650
    1c5c:	726f7461 	rsbvc	r7, pc, #1627389952	; 0x61000000
    1c60:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    1c64:	66696400 	strbtvs	r6, [r9], -r0, lsl #8
    1c68:	6e720066 	cdpvs	0, 7, cr0, cr2, cr6, {3}
    1c6c:	69665f64 	stmdbvs	r6!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    1c70:	006c616e 	rsbeq	r6, ip, lr, ror #2
    1c74:	5f646e72 	svcpl	0x00646e72
    1c78:	756c6176 	strbvc	r6, [ip, #-374]!	; 0xfffffe8a
    1c7c:	69680065 	stmdbvs	r8!, {r0, r2, r5, r6}^
    1c80:	5f006867 	svcpl	0x00006867
    1c84:	35314e5a 	ldrcc	r4, [r1, #-3674]!	; 0xfffff1a6
    1c88:	63726943 	cmnvs	r2, #1097728	; 0x10c000
    1c8c:	72616c75 	rsbvc	r6, r1, #29952	; 0x7500
    1c90:	6675425f 			; <UNDEFINED> instruction: 0x6675425f
    1c94:	43726566 	cmnmi	r2, #427819008	; 0x19800000
    1c98:	00764532 	rsbseq	r4, r6, r2, lsr r5
    1c9c:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
    1ca0:	706d6554 	rsbvc	r6, sp, r4, asr r5
    1ca4:	65646e49 	strbvs	r6, [r4, #-3657]!	; 0xfffff1b7
    1ca8:	6d2f0078 	stcvs	0, cr0, [pc, #-480]!	; 1ad0 <_start-0x6530>
    1cac:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
    1cb0:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
    1cb4:	72702f72 	rsbsvc	r2, r0, #456	; 0x1c8
    1cb8:	74617669 	strbtvc	r7, [r1], #-1641	; 0xfffff997
    1cbc:	726f5765 	rsbvc	r5, pc, #26476544	; 0x1940000
    1cc0:	6170736b 	cmnvs	r0, fp, ror #6
    1cc4:	532f6563 			; <UNDEFINED> instruction: 0x532f6563
    1cc8:	6f6f6863 	svcvs	0x006f6863
    1ccc:	534f2f6c 	movtpl	r2, #65388	; 0xff6c
    1cd0:	2f50532f 	svccs	0x0050532f
    1cd4:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
    1cd8:	534f5452 	movtpl	r5, #62546	; 0xf452
    1cdc:	756f732f 	strbvc	r7, [pc, #-815]!	; 19b5 <_start-0x664b>
    1ce0:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    1ce4:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    1ce8:	6c697475 	cfstrdvs	mvd7, [r9], #-468	; 0xfffffe2c
    1cec:	72732f73 	rsbsvc	r2, r3, #460	; 0x1cc
    1cf0:	69632f63 	stmdbvs	r3!, {r0, r1, r5, r6, r8, r9, sl, fp, sp}^
    1cf4:	6c756372 	ldclvs	3, cr6, [r5], #-456	; 0xfffffe38
    1cf8:	625f7261 	subsvs	r7, pc, #268435462	; 0x10000006
    1cfc:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
    1d00:	70632e72 	rsbvc	r2, r3, r2, ror lr
    1d04:	616d0070 	smcvs	53248	; 0xd000
    1d08:	6e654c78 	mcrvs	12, 3, r4, cr5, cr8, {3}
    1d0c:	6f747300 	svcvs	0x00747300
    1d10:	69730070 	ldmdbvs	r3!, {r4, r5, r6}^
    1d14:	745f657a 	ldrbvc	r6, [pc], #-1402	; 1d1c <_start-0x62e4>
    1d18:	63727300 	cmnvs	r2, #0, 6
    1d1c:	6f6c0030 	svcvs	0x006c0030
    1d20:	6c20676e 	stcvs	7, cr6, [r0], #-440	; 0xfffffe48
    1d24:	20676e6f 	rsbcs	r6, r7, pc, ror #28
    1d28:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
    1d2c:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
    1d30:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
    1d34:	74736400 	ldrbtvc	r6, [r3], #-1024	; 0xfffffc00
    1d38:	6c610030 	stclvs	0, cr0, [r1], #-192	; 0xffffff40
    1d3c:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
    1d40:	73645f64 	cmnvc	r4, #100, 30	; 0x190
    1d44:	6c610074 	stclvs	0, cr0, [r1], #-464	; 0xfffffe30
    1d48:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
    1d4c:	72735f64 	rsbsvc	r5, r3, #100, 30	; 0x190
    1d50:	4e470063 	cdpmi	0, 4, cr0, cr7, cr3, {3}
    1d54:	31432055 	qdaddcc	r2, r5, r3
    1d58:	30312037 	eorscc	r2, r1, r7, lsr r0
    1d5c:	302e332e 	eorcc	r3, lr, lr, lsr #6
    1d60:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    1d64:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    1d68:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
    1d6c:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
    1d70:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
    1d74:	206d7261 	rsbcs	r7, sp, r1, ror #4
    1d78:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
    1d7c:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
    1d80:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1d84:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    1d88:	616d2d20 	cmnvs	sp, r0, lsr #26
    1d8c:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
    1d90:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1d94:	2b657435 	blcs	195ee70 <__bss_end+0x195375c>
    1d98:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    1d9c:	4f2d2067 	svcmi	0x002d2067
    1da0:	662d2032 			; <UNDEFINED> instruction: 0x662d2032
    1da4:	622d6f6e 	eorvs	r6, sp, #440	; 0x1b8
    1da8:	746c6975 	strbtvc	r6, [ip], #-2421	; 0xfffff68b
    1dac:	2f006e69 	svccs	0x00006e69
    1db0:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    1db4:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
    1db8:	7a6f646c 	bvc	1bdaf70 <__bss_end+0x1bcf85c>
    1dbc:	612f7265 			; <UNDEFINED> instruction: 0x612f7265
    1dc0:	74726f70 	ldrbtvc	r6, [r2], #-3952	; 0xfffff090
    1dc4:	6f632f73 	svcvs	0x00632f73
    1dc8:	6e756d6d 	cdpvs	13, 7, cr6, cr5, cr13, {3}
    1dcc:	2f797469 	svccs	0x00797469
    1dd0:	6c77656e 	cfldr64vs	mvdx6, [r7], #-440	; 0xfffffe48
    1dd4:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
    1dd8:	6e2f6372 	mcrvs	3, 1, r6, cr15, cr2, {3}
    1ddc:	696c7765 	stmdbvs	ip!, {r0, r2, r5, r6, r8, r9, sl, ip, sp, lr}^
    1de0:	2e342d62 	cdpcs	13, 3, cr2, cr4, cr2, {3}
    1de4:	2f302e31 	svccs	0x00302e31
    1de8:	6c77656e 	cfldr64vs	mvdx6, [r7], #-440	; 0xfffffe48
    1dec:	6c2f6269 	sfmvs	f6, 4, [pc], #-420	; 1c50 <_start-0x63b0>
    1df0:	2f636269 	svccs	0x00636269
    1df4:	6863616d 	stmdavs	r3!, {r0, r2, r3, r5, r6, r8, sp, lr}^
    1df8:	2f656e69 	svccs	0x00656e69
    1dfc:	2f6d7261 	svccs	0x006d7261
    1e00:	636d656d 	cmnvs	sp, #457179136	; 0x1b400000
    1e04:	732d7970 			; <UNDEFINED> instruction: 0x732d7970
    1e08:	2e627574 	mcrcs	5, 3, r7, cr2, cr4, {3}
    1e0c:	656c0063 	strbvs	r0, [ip, #-99]!	; 0xffffff9d
    1e10:	6c00306e 	stcvs	0, cr3, [r0], {110}	; 0x6e
    1e14:	20676e6f 	rsbcs	r6, r7, pc, ror #28
    1e18:	62756f64 	rsbsvs	r6, r5, #100, 30	; 0x190
    1e1c:	2f00656c 	svccs	0x0000656c
    1e20:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    1e24:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
    1e28:	7a6f646c 	bvc	1bdafe0 <__bss_end+0x1bcf8cc>
    1e2c:	612f7265 			; <UNDEFINED> instruction: 0x612f7265
    1e30:	74726f70 	ldrbtvc	r6, [r2], #-3952	; 0xfffff090
    1e34:	6f632f73 	svcvs	0x00632f73
    1e38:	6e756d6d 	cdpvs	13, 7, cr6, cr5, cr13, {3}
    1e3c:	2f797469 	svccs	0x00797469
    1e40:	6c77656e 	cfldr64vs	mvdx6, [r7], #-440	; 0xfffffe48
    1e44:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
    1e48:	6e2f6372 	mcrvs	3, 1, r6, cr15, cr2, {3}
    1e4c:	696c7765 	stmdbvs	ip!, {r0, r2, r5, r6, r8, r9, sl, ip, sp, lr}^
    1e50:	2e342d62 	cdpcs	13, 3, cr2, cr4, cr2, {3}
    1e54:	2f302e31 	svccs	0x00302e31
    1e58:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    1e5c:	72612d64 	rsbvc	r2, r1, #100, 26	; 0x1900
    1e60:	6f6e2d6d 	svcvs	0x006e2d6d
    1e64:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    1e68:	2f696261 	svccs	0x00696261
    1e6c:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1e70:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    1e74:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    1e78:	72612f69 	rsbvc	r2, r1, #420	; 0x1a4
    1e7c:	35762f6d 	ldrbcc	r2, [r6, #-3949]!	; 0xfffff093
    1e80:	682f6574 	stmdavs	pc!, {r2, r4, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
    1e84:	2f647261 	svccs	0x00647261
    1e88:	6c77656e 	cfldr64vs	mvdx6, [r7], #-440	; 0xfffffe48
    1e8c:	6c2f6269 	sfmvs	f6, 4, [pc], #-420	; 1cf0 <_start-0x6310>
    1e90:	2f636269 	svccs	0x00636269
    1e94:	6863616d 	stmdavs	r3!, {r0, r2, r3, r5, r6, r8, sp, lr}^
    1e98:	2f656e69 	svccs	0x00656e69
    1e9c:	006d7261 	rsbeq	r7, sp, r1, ror #4

Disassembly of section .debug_frame:

00000000 <.debug_frame>:
   0:	0000000c 	andeq	r0, r0, ip
   4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
   8:	7c020001 	stcvc	0, cr0, [r2], {1}
   c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  10:	0000001c 	andeq	r0, r0, ip, lsl r0
  14:	00000000 	andeq	r0, r0, r0
  18:	00008008 	andeq	r8, r0, r8
  1c:	0000005c 	andeq	r0, r0, ip, asr r0
  20:	8b040e42 	blhi	103930 <__bss_end+0xf821c>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x34511c>
  28:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008064 	andeq	r8, r0, r4, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1f823c>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf756c>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a4 	andeq	r8, r0, r4, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xf826c>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x34516c>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080dc 	ldrdeq	r8, [r0], -ip
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xf828c>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x34518c>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008108 	andeq	r8, r0, r8, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xf82ac>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x3451ac>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008128 	andeq	r8, r0, r8, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xf82cc>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x3451cc>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008140 	andeq	r8, r0, r0, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xf82ec>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x3451ec>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008158 	andeq	r8, r0, r8, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xf830c>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x34520c>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008170 	andeq	r8, r0, r0, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xf832c>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x34522c>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	0000817c 	andeq	r8, r0, ip, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1f8344>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d4 	ldrdeq	r8, [r0], -r4
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1f8364>
 16c:	42018e02 	andmi	r8, r1, #2, 28
 170:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 174:	00080d0c 	andeq	r0, r8, ip, lsl #26
 178:	0000000c 	andeq	r0, r0, ip
 17c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 180:	7c020001 	stcvc	0, cr0, [r2], {1}
 184:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 188:	0000001c 	andeq	r0, r0, ip, lsl r0
 18c:	00000178 	andeq	r0, r0, r8, ror r1
 190:	00008230 	andeq	r8, r0, r0, lsr r2
 194:	00000074 	andeq	r0, r0, r4, ror r0
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1f8394>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	70040b0c 	andvc	r0, r4, ip, lsl #22
 1a4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1a8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1ac:	00000178 	andeq	r0, r0, r8, ror r1
 1b0:	000082a4 	andeq	r8, r0, r4, lsr #5
 1b4:	00000140 	andeq	r0, r0, r0, asr #2
 1b8:	8b080e42 	blhi	203ac8 <__bss_end+0x1f83b4>
 1bc:	42018e02 	andmi	r8, r1, #2, 28
 1c0:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 1c4:	080d0c90 	stmdaeq	sp, {r4, r7, sl, fp}
 1c8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1cc:	00000178 	andeq	r0, r0, r8, ror r1
 1d0:	000083e4 	andeq	r8, r0, r4, ror #7
 1d4:	00000064 	andeq	r0, r0, r4, rrx
 1d8:	8b080e42 	blhi	203ae8 <__bss_end+0x1f83d4>
 1dc:	42018e02 	andmi	r8, r1, #2, 28
 1e0:	68040b0c 	stmdavs	r4, {r2, r3, r8, r9, fp}
 1e4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1e8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1ec:	00000178 	andeq	r0, r0, r8, ror r1
 1f0:	00008448 	andeq	r8, r0, r8, asr #8
 1f4:	00000040 	andeq	r0, r0, r0, asr #32
 1f8:	8b080e42 	blhi	203b08 <__bss_end+0x1f83f4>
 1fc:	42018e02 	andmi	r8, r1, #2, 28
 200:	58040b0c 	stmdapl	r4, {r2, r3, r8, r9, fp}
 204:	00080d0c 	andeq	r0, r8, ip, lsl #26
 208:	0000001c 	andeq	r0, r0, ip, lsl r0
 20c:	00000178 	andeq	r0, r0, r8, ror r1
 210:	00008488 	andeq	r8, r0, r8, lsl #9
 214:	00000040 	andeq	r0, r0, r0, asr #32
 218:	8b080e42 	blhi	203b28 <__bss_end+0x1f8414>
 21c:	42018e02 	andmi	r8, r1, #2, 28
 220:	58040b0c 	stmdapl	r4, {r2, r3, r8, r9, fp}
 224:	00080d0c 	andeq	r0, r8, ip, lsl #26
 228:	00000020 	andeq	r0, r0, r0, lsr #32
 22c:	00000178 	andeq	r0, r0, r8, ror r1
 230:	000084c8 	andeq	r8, r0, r8, asr #9
 234:	0000024c 	andeq	r0, r0, ip, asr #4
 238:	8b080e42 	blhi	203b48 <__bss_end+0x1f8434>
 23c:	42018e02 	andmi	r8, r1, #2, 28
 240:	03040b0c 	movweq	r0, #19212	; 0x4b0c
 244:	0d0c0110 	stfeqs	f0, [ip, #-64]	; 0xffffffc0
 248:	00000008 	andeq	r0, r0, r8
 24c:	00000020 	andeq	r0, r0, r0, lsr #32
 250:	00000178 	andeq	r0, r0, r8, ror r1
 254:	00008714 	andeq	r8, r0, r4, lsl r7
 258:	000003dc 	ldrdeq	r0, [r0], -ip
 25c:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 260:	8e028b03 	vmlahi.f64	d8, d2, d3
 264:	0b0c4201 	bleq	310a70 <__bss_end+0x30535c>
 268:	01c60304 	biceq	r0, r6, r4, lsl #6
 26c:	000c0d0c 	andeq	r0, ip, ip, lsl #26
 270:	0000001c 	andeq	r0, r0, ip, lsl r0
 274:	00000178 	andeq	r0, r0, r8, ror r1
 278:	00008af0 	strdeq	r8, [r0], -r0
 27c:	000002b0 			; <UNDEFINED> instruction: 0x000002b0
 280:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 284:	8e028b03 	vmlahi.f64	d8, d2, d3
 288:	0b0c4201 	bleq	310a94 <__bss_end+0x305380>
 28c:	00000004 	andeq	r0, r0, r4
 290:	0000000c 	andeq	r0, r0, ip
 294:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 298:	7c020001 	stcvc	0, cr0, [r2], {1}
 29c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 2a0:	0000001c 	andeq	r0, r0, ip, lsl r0
 2a4:	00000290 	muleq	r0, r0, r2
 2a8:	00008da0 	andeq	r8, r0, r0, lsr #27
 2ac:	00000048 	andeq	r0, r0, r8, asr #32
 2b0:	8b040e42 	blhi	103bc0 <__bss_end+0xf84ac>
 2b4:	0b0d4201 	bleq	350ac0 <__bss_end+0x3453ac>
 2b8:	420d0d5c 	andmi	r0, sp, #92, 26	; 0x1700
 2bc:	00000ecb 	andeq	r0, r0, fp, asr #29
 2c0:	0000001c 	andeq	r0, r0, ip, lsl r0
 2c4:	00000290 	muleq	r0, r0, r2
 2c8:	00008de8 	andeq	r8, r0, r8, ror #27
 2cc:	00000048 	andeq	r0, r0, r8, asr #32
 2d0:	8b040e42 	blhi	103be0 <__bss_end+0xf84cc>
 2d4:	0b0d4201 	bleq	350ae0 <__bss_end+0x3453cc>
 2d8:	420d0d5c 	andmi	r0, sp, #92, 26	; 0x1700
 2dc:	00000ecb 	andeq	r0, r0, fp, asr #29
 2e0:	0000001c 	andeq	r0, r0, ip, lsl r0
 2e4:	00000290 	muleq	r0, r0, r2
 2e8:	00008e30 	andeq	r8, r0, r0, lsr lr
 2ec:	0000008c 	andeq	r0, r0, ip, lsl #1
 2f0:	8b040e42 	blhi	103c00 <__bss_end+0xf84ec>
 2f4:	0b0d4201 	bleq	350b00 <__bss_end+0x3453ec>
 2f8:	420d0d76 	andmi	r0, sp, #7552	; 0x1d80
 2fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 300:	0000001c 	andeq	r0, r0, ip, lsl r0
 304:	00000290 	muleq	r0, r0, r2
 308:	00008ebc 			; <UNDEFINED> instruction: 0x00008ebc
 30c:	00000078 	andeq	r0, r0, r8, ror r0
 310:	8b080e42 	blhi	203c20 <__bss_end+0x1f850c>
 314:	42018e02 	andmi	r8, r1, #2, 28
 318:	76040b0c 	strvc	r0, [r4], -ip, lsl #22
 31c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 320:	0000001c 	andeq	r0, r0, ip, lsl r0
 324:	00000290 	muleq	r0, r0, r2
 328:	00008f34 	andeq	r8, r0, r4, lsr pc
 32c:	00000074 	andeq	r0, r0, r4, ror r0
 330:	8b080e42 	blhi	203c40 <__bss_end+0x1f852c>
 334:	42018e02 	andmi	r8, r1, #2, 28
 338:	74040b0c 	strvc	r0, [r4], #-2828	; 0xfffff4f4
 33c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 340:	0000001c 	andeq	r0, r0, ip, lsl r0
 344:	00000290 	muleq	r0, r0, r2
 348:	00008fa8 	andeq	r8, r0, r8, lsr #31
 34c:	0000005c 	andeq	r0, r0, ip, asr r0
 350:	8b080e42 	blhi	203c60 <__bss_end+0x1f854c>
 354:	42018e02 	andmi	r8, r1, #2, 28
 358:	66040b0c 	strvs	r0, [r4], -ip, lsl #22
 35c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 360:	0000001c 	andeq	r0, r0, ip, lsl r0
 364:	00000290 	muleq	r0, r0, r2
 368:	00009004 	andeq	r9, r0, r4
 36c:	00000148 	andeq	r0, r0, r8, asr #2
 370:	8b080e42 	blhi	203c80 <__bss_end+0x1f856c>
 374:	42018e02 	andmi	r8, r1, #2, 28
 378:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 37c:	080d0c94 	stmdaeq	sp, {r2, r4, r7, sl, fp}
 380:	0000001c 	andeq	r0, r0, ip, lsl r0
 384:	00000290 	muleq	r0, r0, r2
 388:	0000914c 	andeq	r9, r0, ip, asr #2
 38c:	0000006c 	andeq	r0, r0, ip, rrx
 390:	8b080e42 	blhi	203ca0 <__bss_end+0x1f858c>
 394:	42018e02 	andmi	r8, r1, #2, 28
 398:	6e040b0c 	vmlavs.f64	d0, d4, d12
 39c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 3a0:	0000001c 	andeq	r0, r0, ip, lsl r0
 3a4:	00000290 	muleq	r0, r0, r2
 3a8:	000091b8 			; <UNDEFINED> instruction: 0x000091b8
 3ac:	0000002c 	andeq	r0, r0, ip, lsr #32
 3b0:	8b040e42 	blhi	103cc0 <__bss_end+0xf85ac>
 3b4:	0b0d4201 	bleq	350bc0 <__bss_end+0x3454ac>
 3b8:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 3bc:	00000ecb 	andeq	r0, r0, fp, asr #29
 3c0:	0000001c 	andeq	r0, r0, ip, lsl r0
 3c4:	00000290 	muleq	r0, r0, r2
 3c8:	000091e4 	andeq	r9, r0, r4, ror #3
 3cc:	00000078 	andeq	r0, r0, r8, ror r0
 3d0:	8b040e42 	blhi	103ce0 <__bss_end+0xf85cc>
 3d4:	0b0d4201 	bleq	350be0 <__bss_end+0x3454cc>
 3d8:	420d0d74 	andmi	r0, sp, #116, 26	; 0x1d00
 3dc:	00000ecb 	andeq	r0, r0, fp, asr #29
 3e0:	0000000c 	andeq	r0, r0, ip
 3e4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3e8:	7c020001 	stcvc	0, cr0, [r2], {1}
 3ec:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3f0:	0000001c 	andeq	r0, r0, ip, lsl r0
 3f4:	000003e0 	andeq	r0, r0, r0, ror #7
 3f8:	0000925c 	andeq	r9, r0, ip, asr r2
 3fc:	00000094 	muleq	r0, r4, r0
 400:	8b080e42 	blhi	203d10 <__bss_end+0x1f85fc>
 404:	42018e02 	andmi	r8, r1, #2, 28
 408:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 40c:	080d0c44 	stmdaeq	sp, {r2, r6, sl, fp}
 410:	0000001c 	andeq	r0, r0, ip, lsl r0
 414:	000003e0 	andeq	r0, r0, r0, ror #7
 418:	000092f0 	strdeq	r9, [r0], -r0
 41c:	00000064 	andeq	r0, r0, r4, rrx
 420:	8b080e42 	blhi	203d30 <__bss_end+0x1f861c>
 424:	42018e02 	andmi	r8, r1, #2, 28
 428:	6c040b0c 			; <UNDEFINED> instruction: 0x6c040b0c
 42c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 430:	0000001c 	andeq	r0, r0, ip, lsl r0
 434:	000003e0 	andeq	r0, r0, r0, ror #7
 438:	00009354 	andeq	r9, r0, r4, asr r3
 43c:	00000050 	andeq	r0, r0, r0, asr r0
 440:	8b080e42 	blhi	203d50 <__bss_end+0x1f863c>
 444:	42018e02 	andmi	r8, r1, #2, 28
 448:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 44c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 450:	00000020 	andeq	r0, r0, r0, lsr #32
 454:	000003e0 	andeq	r0, r0, r0, ror #7
 458:	000093a4 	andeq	r9, r0, r4, lsr #7
 45c:	00000100 	andeq	r0, r0, r0, lsl #2
 460:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 464:	8e028b03 	vmlahi.f64	d8, d2, d3
 468:	0b0c4201 	bleq	310c74 <__bss_end+0x305560>
 46c:	0c780204 	lfmeq	f0, 2, [r8], #-16
 470:	00000c0d 	andeq	r0, r0, sp, lsl #24
 474:	0000001c 	andeq	r0, r0, ip, lsl r0
 478:	000003e0 	andeq	r0, r0, r0, ror #7
 47c:	000094a4 	andeq	r9, r0, r4, lsr #9
 480:	00000188 	andeq	r0, r0, r8, lsl #3
 484:	8b080e42 	blhi	203d94 <__bss_end+0x1f8680>
 488:	42018e02 	andmi	r8, r1, #2, 28
 48c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 490:	080d0cbe 	stmdaeq	sp, {r1, r2, r3, r4, r5, r7, sl, fp}
 494:	00000020 	andeq	r0, r0, r0, lsr #32
 498:	000003e0 	andeq	r0, r0, r0, ror #7
 49c:	0000962c 	andeq	r9, r0, ip, lsr #12
 4a0:	00000258 	andeq	r0, r0, r8, asr r2
 4a4:	8b080e42 	blhi	203db4 <__bss_end+0x1f86a0>
 4a8:	42018e02 	andmi	r8, r1, #2, 28
 4ac:	03040b0c 	movweq	r0, #19212	; 0x4b0c
 4b0:	0d0c0126 	stfeqs	f0, [ip, #-152]	; 0xffffff68
 4b4:	00000008 	andeq	r0, r0, r8
 4b8:	0000001c 	andeq	r0, r0, ip, lsl r0
 4bc:	000003e0 	andeq	r0, r0, r0, ror #7
 4c0:	00009884 	andeq	r9, r0, r4, lsl #17
 4c4:	00000078 	andeq	r0, r0, r8, ror r0
 4c8:	8b080e42 	blhi	203dd8 <__bss_end+0x1f86c4>
 4cc:	42018e02 	andmi	r8, r1, #2, 28
 4d0:	76040b0c 	strvc	r0, [r4], -ip, lsl #22
 4d4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 4d8:	0000000c 	andeq	r0, r0, ip
 4dc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 4e0:	7c020001 	stcvc	0, cr0, [r2], {1}
 4e4:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 4e8:	0000001c 	andeq	r0, r0, ip, lsl r0
 4ec:	000004d8 	ldrdeq	r0, [r0], -r8
 4f0:	000098fc 	strdeq	r9, [r0], -ip
 4f4:	0000003c 	andeq	r0, r0, ip, lsr r0
 4f8:	8b080e42 	blhi	203e08 <__bss_end+0x1f86f4>
 4fc:	42018e02 	andmi	r8, r1, #2, 28
 500:	58040b0c 	stmdapl	r4, {r2, r3, r8, r9, fp}
 504:	00080d0c 	andeq	r0, r8, ip, lsl #26
 508:	0000001c 	andeq	r0, r0, ip, lsl r0
 50c:	000004d8 	ldrdeq	r0, [r0], -r8
 510:	00009938 	andeq	r9, r0, r8, lsr r9
 514:	00000064 	andeq	r0, r0, r4, rrx
 518:	8b080e42 	blhi	203e28 <__bss_end+0x1f8714>
 51c:	42018e02 	andmi	r8, r1, #2, 28
 520:	6a040b0c 	bvs	103158 <__bss_end+0xf7a44>
 524:	00080d0c 	andeq	r0, r8, ip, lsl #26
 528:	0000001c 	andeq	r0, r0, ip, lsl r0
 52c:	000004d8 	ldrdeq	r0, [r0], -r8
 530:	0000999c 	muleq	r0, ip, r9
 534:	00000078 	andeq	r0, r0, r8, ror r0
 538:	8b080e42 	blhi	203e48 <__bss_end+0x1f8734>
 53c:	42018e02 	andmi	r8, r1, #2, 28
 540:	76040b0c 	strvc	r0, [r4], -ip, lsl #22
 544:	00080d0c 	andeq	r0, r8, ip, lsl #26
 548:	0000000c 	andeq	r0, r0, ip
 54c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 550:	7c020001 	stcvc	0, cr0, [r2], {1}
 554:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 558:	0000001c 	andeq	r0, r0, ip, lsl r0
 55c:	00000548 	andeq	r0, r0, r8, asr #10
 560:	00009a14 	andeq	r9, r0, r4, lsl sl
 564:	0000002c 	andeq	r0, r0, ip, lsr #32
 568:	8b040e42 	blhi	103e78 <__bss_end+0xf8764>
 56c:	0b0d4201 	bleq	350d78 <__bss_end+0x345664>
 570:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 574:	00000ecb 	andeq	r0, r0, fp, asr #29
 578:	0000001c 	andeq	r0, r0, ip, lsl r0
 57c:	00000548 	andeq	r0, r0, r8, asr #10
 580:	00009a40 	andeq	r9, r0, r0, asr #20
 584:	0000002c 	andeq	r0, r0, ip, lsr #32
 588:	8b040e42 	blhi	103e98 <__bss_end+0xf8784>
 58c:	0b0d4201 	bleq	350d98 <__bss_end+0x345684>
 590:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 594:	00000ecb 	andeq	r0, r0, fp, asr #29
 598:	0000001c 	andeq	r0, r0, ip, lsl r0
 59c:	00000548 	andeq	r0, r0, r8, asr #10
 5a0:	00009a6c 	andeq	r9, r0, ip, ror #20
 5a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 5a8:	8b040e42 	blhi	103eb8 <__bss_end+0xf87a4>
 5ac:	0b0d4201 	bleq	350db8 <__bss_end+0x3456a4>
 5b0:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 5b4:	00000ecb 	andeq	r0, r0, fp, asr #29
 5b8:	0000001c 	andeq	r0, r0, ip, lsl r0
 5bc:	00000548 	andeq	r0, r0, r8, asr #10
 5c0:	00009a88 	andeq	r9, r0, r8, lsl #21
 5c4:	00000044 	andeq	r0, r0, r4, asr #32
 5c8:	8b040e42 	blhi	103ed8 <__bss_end+0xf87c4>
 5cc:	0b0d4201 	bleq	350dd8 <__bss_end+0x3456c4>
 5d0:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 5d4:	00000ecb 	andeq	r0, r0, fp, asr #29
 5d8:	0000001c 	andeq	r0, r0, ip, lsl r0
 5dc:	00000548 	andeq	r0, r0, r8, asr #10
 5e0:	00009acc 	andeq	r9, r0, ip, asr #21
 5e4:	00000050 	andeq	r0, r0, r0, asr r0
 5e8:	8b040e42 	blhi	103ef8 <__bss_end+0xf87e4>
 5ec:	0b0d4201 	bleq	350df8 <__bss_end+0x3456e4>
 5f0:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 5f4:	00000ecb 	andeq	r0, r0, fp, asr #29
 5f8:	0000001c 	andeq	r0, r0, ip, lsl r0
 5fc:	00000548 	andeq	r0, r0, r8, asr #10
 600:	00009b1c 	andeq	r9, r0, ip, lsl fp
 604:	00000050 	andeq	r0, r0, r0, asr r0
 608:	8b040e42 	blhi	103f18 <__bss_end+0xf8804>
 60c:	0b0d4201 	bleq	350e18 <__bss_end+0x345704>
 610:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 614:	00000ecb 	andeq	r0, r0, fp, asr #29
 618:	0000001c 	andeq	r0, r0, ip, lsl r0
 61c:	00000548 	andeq	r0, r0, r8, asr #10
 620:	00009b6c 	andeq	r9, r0, ip, ror #22
 624:	0000002c 	andeq	r0, r0, ip, lsr #32
 628:	8b040e42 	blhi	103f38 <__bss_end+0xf8824>
 62c:	0b0d4201 	bleq	350e38 <__bss_end+0x345724>
 630:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 634:	00000ecb 	andeq	r0, r0, fp, asr #29
 638:	0000001c 	andeq	r0, r0, ip, lsl r0
 63c:	00000548 	andeq	r0, r0, r8, asr #10
 640:	00009b98 	muleq	r0, r8, fp
 644:	00000050 	andeq	r0, r0, r0, asr r0
 648:	8b040e42 	blhi	103f58 <__bss_end+0xf8844>
 64c:	0b0d4201 	bleq	350e58 <__bss_end+0x345744>
 650:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 654:	00000ecb 	andeq	r0, r0, fp, asr #29
 658:	0000001c 	andeq	r0, r0, ip, lsl r0
 65c:	00000548 	andeq	r0, r0, r8, asr #10
 660:	00009be8 	andeq	r9, r0, r8, ror #23
 664:	00000044 	andeq	r0, r0, r4, asr #32
 668:	8b040e42 	blhi	103f78 <__bss_end+0xf8864>
 66c:	0b0d4201 	bleq	350e78 <__bss_end+0x345764>
 670:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 674:	00000ecb 	andeq	r0, r0, fp, asr #29
 678:	0000001c 	andeq	r0, r0, ip, lsl r0
 67c:	00000548 	andeq	r0, r0, r8, asr #10
 680:	00009c2c 	andeq	r9, r0, ip, lsr #24
 684:	00000050 	andeq	r0, r0, r0, asr r0
 688:	8b040e42 	blhi	103f98 <__bss_end+0xf8884>
 68c:	0b0d4201 	bleq	350e98 <__bss_end+0x345784>
 690:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 694:	00000ecb 	andeq	r0, r0, fp, asr #29
 698:	0000001c 	andeq	r0, r0, ip, lsl r0
 69c:	00000548 	andeq	r0, r0, r8, asr #10
 6a0:	00009c7c 	andeq	r9, r0, ip, ror ip
 6a4:	00000054 	andeq	r0, r0, r4, asr r0
 6a8:	8b040e42 	blhi	103fb8 <__bss_end+0xf88a4>
 6ac:	0b0d4201 	bleq	350eb8 <__bss_end+0x3457a4>
 6b0:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 6b4:	00000ecb 	andeq	r0, r0, fp, asr #29
 6b8:	0000001c 	andeq	r0, r0, ip, lsl r0
 6bc:	00000548 	andeq	r0, r0, r8, asr #10
 6c0:	00009cd0 	ldrdeq	r9, [r0], -r0
 6c4:	0000003c 	andeq	r0, r0, ip, lsr r0
 6c8:	8b040e42 	blhi	103fd8 <__bss_end+0xf88c4>
 6cc:	0b0d4201 	bleq	350ed8 <__bss_end+0x3457c4>
 6d0:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 6d4:	00000ecb 	andeq	r0, r0, fp, asr #29
 6d8:	0000001c 	andeq	r0, r0, ip, lsl r0
 6dc:	00000548 	andeq	r0, r0, r8, asr #10
 6e0:	00009d0c 	andeq	r9, r0, ip, lsl #26
 6e4:	0000003c 	andeq	r0, r0, ip, lsr r0
 6e8:	8b040e42 	blhi	103ff8 <__bss_end+0xf88e4>
 6ec:	0b0d4201 	bleq	350ef8 <__bss_end+0x3457e4>
 6f0:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 6f4:	00000ecb 	andeq	r0, r0, fp, asr #29
 6f8:	0000001c 	andeq	r0, r0, ip, lsl r0
 6fc:	00000548 	andeq	r0, r0, r8, asr #10
 700:	00009d48 	andeq	r9, r0, r8, asr #26
 704:	0000003c 	andeq	r0, r0, ip, lsr r0
 708:	8b040e42 	blhi	104018 <__bss_end+0xf8904>
 70c:	0b0d4201 	bleq	350f18 <__bss_end+0x345804>
 710:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 714:	00000ecb 	andeq	r0, r0, fp, asr #29
 718:	0000001c 	andeq	r0, r0, ip, lsl r0
 71c:	00000548 	andeq	r0, r0, r8, asr #10
 720:	00009d84 	andeq	r9, r0, r4, lsl #27
 724:	0000003c 	andeq	r0, r0, ip, lsr r0
 728:	8b040e42 	blhi	104038 <__bss_end+0xf8924>
 72c:	0b0d4201 	bleq	350f38 <__bss_end+0x345824>
 730:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 734:	00000ecb 	andeq	r0, r0, fp, asr #29
 738:	0000001c 	andeq	r0, r0, ip, lsl r0
 73c:	00000548 	andeq	r0, r0, r8, asr #10
 740:	00009dc0 	andeq	r9, r0, r0, asr #27
 744:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 748:	8b080e42 	blhi	204058 <__bss_end+0x1f8944>
 74c:	42018e02 	andmi	r8, r1, #2, 28
 750:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 754:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 758:	0000000c 	andeq	r0, r0, ip
 75c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 760:	7c020001 	stcvc	0, cr0, [r2], {1}
 764:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 768:	0000001c 	andeq	r0, r0, ip, lsl r0
 76c:	00000758 	andeq	r0, r0, r8, asr r7
 770:	00009e70 	andeq	r9, r0, r0, ror lr
 774:	00000038 	andeq	r0, r0, r8, lsr r0
 778:	8b040e42 	blhi	104088 <__bss_end+0xf8974>
 77c:	0b0d4201 	bleq	350f88 <__bss_end+0x345874>
 780:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
 784:	00000ecb 	andeq	r0, r0, fp, asr #29
 788:	0000000c 	andeq	r0, r0, ip
 78c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 790:	7c020001 	stcvc	0, cr0, [r2], {1}
 794:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 798:	0000001c 	andeq	r0, r0, ip, lsl r0
 79c:	00000788 	andeq	r0, r0, r8, lsl #15
 7a0:	00009ea8 	andeq	r9, r0, r8, lsr #29
 7a4:	00000174 	andeq	r0, r0, r4, ror r1
 7a8:	8b080e42 	blhi	2040b8 <__bss_end+0x1f89a4>
 7ac:	42018e02 	andmi	r8, r1, #2, 28
 7b0:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 7b4:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 7b8:	0000001c 	andeq	r0, r0, ip, lsl r0
 7bc:	00000788 	andeq	r0, r0, r8, lsl #15
 7c0:	0000a01c 	andeq	sl, r0, ip, lsl r0
 7c4:	000000b8 	strheq	r0, [r0], -r8
 7c8:	8b080e42 	blhi	2040d8 <__bss_end+0x1f89c4>
 7cc:	42018e02 	andmi	r8, r1, #2, 28
 7d0:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 7d4:	080d0c56 	stmdaeq	sp, {r1, r2, r4, r6, sl, fp}
 7d8:	0000001c 	andeq	r0, r0, ip, lsl r0
 7dc:	00000788 	andeq	r0, r0, r8, lsl #15
 7e0:	0000a0d4 	ldrdeq	sl, [r0], -r4
 7e4:	000000c4 	andeq	r0, r0, r4, asr #1
 7e8:	8b040e42 	blhi	1040f8 <__bss_end+0xf89e4>
 7ec:	0b0d4201 	bleq	350ff8 <__bss_end+0x3458e4>
 7f0:	0d0d5202 	sfmeq	f5, 4, [sp, #-8]
 7f4:	000ecb42 	andeq	ip, lr, r2, asr #22
 7f8:	0000001c 	andeq	r0, r0, ip, lsl r0
 7fc:	00000788 	andeq	r0, r0, r8, lsl #15
 800:	0000a198 	muleq	r0, r8, r1
 804:	000000dc 	ldrdeq	r0, [r0], -ip
 808:	8b080e42 	blhi	204118 <__bss_end+0x1f8a04>
 80c:	42018e02 	andmi	r8, r1, #2, 28
 810:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 814:	080d0c68 	stmdaeq	sp, {r3, r5, r6, sl, fp}
 818:	00000020 	andeq	r0, r0, r0, lsr #32
 81c:	00000788 	andeq	r0, r0, r8, lsl #15
 820:	0000a274 	andeq	sl, r0, r4, ror r2
 824:	000002b8 			; <UNDEFINED> instruction: 0x000002b8
 828:	8b040e42 	blhi	104138 <__bss_end+0xf8a24>
 82c:	0b0d4201 	bleq	351038 <__bss_end+0x345924>
 830:	0d014803 	stceq	8, cr4, [r1, #-12]
 834:	0ecb420d 	cdpeq	2, 12, cr4, cr11, cr13, {0}
 838:	00000000 	andeq	r0, r0, r0
 83c:	00000020 	andeq	r0, r0, r0, lsr #32
 840:	00000788 	andeq	r0, r0, r8, lsl #15
 844:	0000a52c 	andeq	sl, r0, ip, lsr #10
 848:	00000238 	andeq	r0, r0, r8, lsr r2
 84c:	8b080e42 	blhi	20415c <__bss_end+0x1f8a48>
 850:	42018e02 	andmi	r8, r1, #2, 28
 854:	03040b0c 	movweq	r0, #19212	; 0x4b0c
 858:	0d0c0110 	stfeqs	f0, [ip, #-64]	; 0xffffffc0
 85c:	00000008 	andeq	r0, r0, r8
 860:	0000001c 	andeq	r0, r0, ip, lsl r0
 864:	00000788 	andeq	r0, r0, r8, lsl #15
 868:	0000a764 	andeq	sl, r0, r4, ror #14
 86c:	000000c0 	andeq	r0, r0, r0, asr #1
 870:	8b040e42 	blhi	104180 <__bss_end+0xf8a6c>
 874:	0b0d4201 	bleq	351080 <__bss_end+0x34596c>
 878:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 87c:	000ecb42 	andeq	ip, lr, r2, asr #22
 880:	0000001c 	andeq	r0, r0, ip, lsl r0
 884:	00000788 	andeq	r0, r0, r8, lsl #15
 888:	0000a824 	andeq	sl, r0, r4, lsr #16
 88c:	000000d4 	ldrdeq	r0, [r0], -r4
 890:	8b040e42 	blhi	1041a0 <__bss_end+0xf8a8c>
 894:	0b0d4201 	bleq	3510a0 <__bss_end+0x34598c>
 898:	0d0d6202 	sfmeq	f6, 4, [sp, #-8]
 89c:	000ecb42 	andeq	ip, lr, r2, asr #22
 8a0:	0000001c 	andeq	r0, r0, ip, lsl r0
 8a4:	00000788 	andeq	r0, r0, r8, lsl #15
 8a8:	0000a8f8 	strdeq	sl, [r0], -r8
 8ac:	000000ac 	andeq	r0, r0, ip, lsr #1
 8b0:	8b040e42 	blhi	1041c0 <__bss_end+0xf8aac>
 8b4:	0b0d4201 	bleq	3510c0 <__bss_end+0x3459ac>
 8b8:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 8bc:	000ecb42 	andeq	ip, lr, r2, asr #22
 8c0:	0000001c 	andeq	r0, r0, ip, lsl r0
 8c4:	00000788 	andeq	r0, r0, r8, lsl #15
 8c8:	0000a9a4 	andeq	sl, r0, r4, lsr #19
 8cc:	00000054 	andeq	r0, r0, r4, asr r0
 8d0:	8b040e42 	blhi	1041e0 <__bss_end+0xf8acc>
 8d4:	0b0d4201 	bleq	3510e0 <__bss_end+0x3459cc>
 8d8:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 8dc:	00000ecb 	andeq	r0, r0, fp, asr #29
 8e0:	0000001c 	andeq	r0, r0, ip, lsl r0
 8e4:	00000788 	andeq	r0, r0, r8, lsl #15
 8e8:	0000a9f8 	strdeq	sl, [r0], -r8
 8ec:	00000068 	andeq	r0, r0, r8, rrx
 8f0:	8b040e42 	blhi	104200 <__bss_end+0xf8aec>
 8f4:	0b0d4201 	bleq	351100 <__bss_end+0x3459ec>
 8f8:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 8fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 900:	0000001c 	andeq	r0, r0, ip, lsl r0
 904:	00000788 	andeq	r0, r0, r8, lsl #15
 908:	0000aa60 	andeq	sl, r0, r0, ror #20
 90c:	00000080 	andeq	r0, r0, r0, lsl #1
 910:	8b040e42 	blhi	104220 <__bss_end+0xf8b0c>
 914:	0b0d4201 	bleq	351120 <__bss_end+0x345a0c>
 918:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 91c:	00000ecb 	andeq	r0, r0, fp, asr #29
 920:	0000000c 	andeq	r0, r0, ip
 924:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 928:	7c020001 	stcvc	0, cr0, [r2], {1}
 92c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 930:	0000001c 	andeq	r0, r0, ip, lsl r0
 934:	00000920 	andeq	r0, r0, r0, lsr #18
 938:	0000aae0 	andeq	sl, r0, r0, ror #21
 93c:	0000002c 	andeq	r0, r0, ip, lsr #32
 940:	8b080e42 	blhi	204250 <__bss_end+0x1f8b3c>
 944:	42018e02 	andmi	r8, r1, #2, 28
 948:	50040b0c 	andpl	r0, r4, ip, lsl #22
 94c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 950:	0000001c 	andeq	r0, r0, ip, lsl r0
 954:	00000920 	andeq	r0, r0, r0, lsr #18
 958:	0000ab0c 	andeq	sl, r0, ip, lsl #22
 95c:	0000019c 	muleq	r0, ip, r1
 960:	8b080e42 	blhi	204270 <__bss_end+0x1f8b5c>
 964:	42018e02 	andmi	r8, r1, #2, 28
 968:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 96c:	080d0cc6 	stmdaeq	sp, {r1, r2, r6, r7, sl, fp}
 970:	0000000c 	andeq	r0, r0, ip
 974:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 978:	7c020001 	stcvc	0, cr0, [r2], {1}
 97c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 980:	0000001c 	andeq	r0, r0, ip, lsl r0
 984:	00000970 	andeq	r0, r0, r0, ror r9
 988:	0000aca8 	andeq	sl, r0, r8, lsr #25
 98c:	00000048 	andeq	r0, r0, r8, asr #32
 990:	8b080e42 	blhi	2042a0 <__bss_end+0x1f8b8c>
 994:	42018e02 	andmi	r8, r1, #2, 28
 998:	5e040b0c 	vmlapl.f64	d0, d4, d12
 99c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 9a0:	0000001c 	andeq	r0, r0, ip, lsl r0
 9a4:	00000970 	andeq	r0, r0, r0, ror r9
 9a8:	0000acf0 	strdeq	sl, [r0], -r0
 9ac:	000000bc 	strheq	r0, [r0], -ip
 9b0:	8b080e42 	blhi	2042c0 <__bss_end+0x1f8bac>
 9b4:	42018e02 	andmi	r8, r1, #2, 28
 9b8:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 9bc:	080d0c56 	stmdaeq	sp, {r1, r2, r4, r6, sl, fp}
 9c0:	0000001c 	andeq	r0, r0, ip, lsl r0
 9c4:	00000970 	andeq	r0, r0, r0, ror r9
 9c8:	0000adac 	andeq	sl, r0, ip, lsr #27
 9cc:	00000030 	andeq	r0, r0, r0, lsr r0
 9d0:	8b040e42 	blhi	1042e0 <__bss_end+0xf8bcc>
 9d4:	0b0d4201 	bleq	3511e0 <__bss_end+0x345acc>
 9d8:	420d0d50 	andmi	r0, sp, #80, 26	; 0x1400
 9dc:	00000ecb 	andeq	r0, r0, fp, asr #29
 9e0:	0000000c 	andeq	r0, r0, ip
 9e4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 9e8:	7c020001 	stcvc	0, cr0, [r2], {1}
 9ec:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 9f0:	0000001c 	andeq	r0, r0, ip, lsl r0
 9f4:	000009e0 	andeq	r0, r0, r0, ror #19
 9f8:	0000addc 	ldrdeq	sl, [r0], -ip
 9fc:	00000048 	andeq	r0, r0, r8, asr #32
 a00:	8b080e42 	blhi	204310 <__bss_end+0x1f8bfc>
 a04:	42018e02 	andmi	r8, r1, #2, 28
 a08:	5e040b0c 	vmlapl.f64	d0, d4, d12
 a0c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 a10:	0000001c 	andeq	r0, r0, ip, lsl r0
 a14:	000009e0 	andeq	r0, r0, r0, ror #19
 a18:	0000ae24 	andeq	sl, r0, r4, lsr #28
 a1c:	00000048 	andeq	r0, r0, r8, asr #32
 a20:	8b080e42 	blhi	204330 <__bss_end+0x1f8c1c>
 a24:	42018e02 	andmi	r8, r1, #2, 28
 a28:	5e040b0c 	vmlapl.f64	d0, d4, d12
 a2c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 a30:	0000001c 	andeq	r0, r0, ip, lsl r0
 a34:	000009e0 	andeq	r0, r0, r0, ror #19
 a38:	0000ae6c 	andeq	sl, r0, ip, ror #28
 a3c:	00000118 	andeq	r0, r0, r8, lsl r1
 a40:	8b040e42 	blhi	104350 <__bss_end+0xf8c3c>
 a44:	0b0d4201 	bleq	351250 <__bss_end+0x345b3c>
 a48:	0d0d8402 	cfstrseq	mvf8, [sp, #-8]
 a4c:	000ecb42 	andeq	ip, lr, r2, asr #22
 a50:	0000001c 	andeq	r0, r0, ip, lsl r0
 a54:	000009e0 	andeq	r0, r0, r0, ror #19
 a58:	0000af84 	andeq	sl, r0, r4, lsl #31
 a5c:	000000d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 a60:	8b080e42 	blhi	204370 <__bss_end+0x1f8c5c>
 a64:	42018e02 	andmi	r8, r1, #2, 28
 a68:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 a6c:	080d0c62 	stmdaeq	sp, {r1, r5, r6, sl, fp}
 a70:	0000001c 	andeq	r0, r0, ip, lsl r0
 a74:	000009e0 	andeq	r0, r0, r0, ror #19
 a78:	0000b054 	andeq	fp, r0, r4, asr r0
 a7c:	00000068 	andeq	r0, r0, r8, rrx
 a80:	8b080e42 	blhi	204390 <__bss_end+0x1f8c7c>
 a84:	42018e02 	andmi	r8, r1, #2, 28
 a88:	6e040b0c 	vmlavs.f64	d0, d4, d12
 a8c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 a90:	0000001c 	andeq	r0, r0, ip, lsl r0
 a94:	000009e0 	andeq	r0, r0, r0, ror #19
 a98:	0000b0bc 	strheq	fp, [r0], -ip
 a9c:	00000054 	andeq	r0, r0, r4, asr r0
 aa0:	8b040e42 	blhi	1043b0 <__bss_end+0xf8c9c>
 aa4:	0b0d4201 	bleq	3512b0 <__bss_end+0x345b9c>
 aa8:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 aac:	00000ecb 	andeq	r0, r0, fp, asr #29
 ab0:	0000000c 	andeq	r0, r0, ip
 ab4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 ab8:	7c020001 	stcvc	0, cr0, [r2], {1}
 abc:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 ac0:	00000024 	andeq	r0, r0, r4, lsr #32
 ac4:	00000ab0 			; <UNDEFINED> instruction: 0x00000ab0
 ac8:	0000b2d8 	ldrdeq	fp, [r0], -r8
 acc:	0000011c 	andeq	r0, r0, ip, lsl r1
 ad0:	84140e4e 	ldrhi	r0, [r4], #-3662	; 0xfffff1b2
 ad4:	86048505 	strhi	r8, [r4], -r5, lsl #10
 ad8:	8e028703 	cdphi	7, 0, cr8, cr2, cr3, {0}
 adc:	0e620201 	cdpeq	2, 6, cr0, cr2, cr1, {0}
 ae0:	c6c5c400 	strbgt	ip, [r5], r0, lsl #8
 ae4:	0000cec7 	andeq	ip, r0, r7, asr #29

Disassembly of section .debug_ranges:

00000000 <.debug_ranges>:
   0:	0000925c 	andeq	r9, r0, ip, asr r2
   4:	0000962c 	andeq	r9, r0, ip, lsr #12
   8:	0000962c 	andeq	r9, r0, ip, lsr #12
   c:	00009884 	andeq	r9, r0, r4, lsl #17
  10:	00009884 	andeq	r9, r0, r4, lsl #17
  14:	000098fc 	strdeq	r9, [r0], -ip
	...

Disassembly of section .debug_loc:

00000000 <.debug_loc>:
	...
   c:	00700000 	rsbseq	r0, r0, r0
  10:	00010000 	andeq	r0, r1, r0
  14:	00007051 	andeq	r7, r0, r1, asr r0
  18:	0000e000 	andeq	lr, r0, r0
  1c:	f3000400 	vshl.u8	d0, d0, d0
  20:	e09f5101 	adds	r5, pc, r1, lsl #2
  24:	fc000000 	stc2	0, cr0, [r0], {-0}
  28:	01000000 	mrseq	r0, (UNDEF: 0)
  2c:	00fc5100 	rscseq	r5, ip, r0, lsl #2
  30:	01100000 	tsteq	r0, r0
  34:	00040000 	andeq	r0, r4, r0
  38:	9f5101f3 	svcls	0x005101f3
  3c:	00000110 	andeq	r0, r0, r0, lsl r1
  40:	0000011c 	andeq	r0, r0, ip, lsl r1
  44:	00510001 	subseq	r0, r1, r1
	...
  64:	00003400 	andeq	r3, r0, r0, lsl #8
  68:	52000100 	andpl	r0, r0, #0, 2
  6c:	000000b4 	strheq	r0, [r0], -r4
  70:	000000bc 	strheq	r0, [r0], -ip
  74:	bc520001 	mrrclt	0, 0, r0, r2, cr1
  78:	c4000000 	strgt	r0, [r0], #-0
  7c:	01000000 	mrseq	r0, (UNDEF: 0)
  80:	00c45300 	sbceq	r5, r4, r0, lsl #6
  84:	00cc0000 	sbceq	r0, ip, r0
  88:	00030000 	andeq	r0, r3, r0
  8c:	e09f7f73 	adds	r7, pc, r3, ror pc	; <UNPREDICTABLE>
  90:	ec000000 	stc	0, cr0, [r0], {-0}
  94:	01000000 	mrseq	r0, (UNDEF: 0)
  98:	00ec5200 	rsceq	r5, ip, r0, lsl #4
  9c:	00f40000 	rscseq	r0, r4, r0
  a0:	00010000 	andeq	r0, r1, r0
  a4:	0000f453 	andeq	pc, r0, r3, asr r4	; <UNPREDICTABLE>
  a8:	0000fc00 	andeq	pc, r0, r0, lsl #24
  ac:	73000300 	movwvc	r0, #768	; 0x300
  b0:	01109f7f 	tsteq	r0, pc, ror pc
  b4:	01140000 	tsteq	r4, r0
  b8:	00010000 	andeq	r0, r1, r0
  bc:	00011452 	andeq	r1, r1, r2, asr r4
  c0:	00011c00 	andeq	r1, r1, r0, lsl #24
  c4:	53000100 	movwpl	r0, #256	; 0x100
	...
  d8:	00040000 	andeq	r0, r4, r0
  dc:	00b40000 	adcseq	r0, r4, r0
  e0:	00010000 	andeq	r0, r1, r0
  e4:	0000b450 	andeq	fp, r0, r0, asr r4
  e8:	0000cc00 	andeq	ip, r0, r0, lsl #24
  ec:	5c000100 	stfpls	f0, [r0], {-0}
  f0:	000000e0 	andeq	r0, r0, r0, ror #1
  f4:	000000e8 	andeq	r0, r0, r8, ror #1
  f8:	e8500001 	ldmda	r0, {r0}^
  fc:	f0000000 			; <UNDEFINED> instruction: 0xf0000000
 100:	01000000 	mrseq	r0, (UNDEF: 0)
 104:	00fc5c00 	rscseq	r5, ip, r0, lsl #24
 108:	011c0000 	tsteq	ip, r0
 10c:	00010000 	andeq	r0, r1, r0
 110:	00000050 	andeq	r0, r0, r0, asr r0
 114:	00000000 	andeq	r0, r0, r0
 118:	00000100 	andeq	r0, r0, r0, lsl #2
 11c:	01010000 	mrseq	r0, (UNDEF: 1)
 120:	01010000 	mrseq	r0, (UNDEF: 1)
 124:	04000000 	streq	r0, [r0], #-0
 128:	70000000 	andvc	r0, r0, r0
 12c:	01000000 	mrseq	r0, (UNDEF: 0)
 130:	00705100 	rsbseq	r5, r0, r0, lsl #2
 134:	00b40000 	adcseq	r0, r4, r0
 138:	00040000 	andeq	r0, r4, r0
 13c:	9f5101f3 	svcls	0x005101f3
 140:	000000b4 	strheq	r0, [r0], -r4
 144:	000000cc 	andeq	r0, r0, ip, asr #1
 148:	cc510001 	mrrcgt	0, 0, r0, r1, cr1
 14c:	d0000000 	andle	r0, r0, r0
 150:	03000000 	movweq	r0, #0
 154:	9f017100 	svcls	0x00017100
 158:	000000d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 15c:	000000fc 	strdeq	r0, [r0], -ip
 160:	fc510001 	mrrc2	0, 0, r0, r1, cr1
 164:	00000000 	andeq	r0, r0, r0
 168:	03000001 	movweq	r0, #1
 16c:	9f017100 	svcls	0x00017100
 170:	00000100 	andeq	r0, r0, r0, lsl #2
 174:	0000011c 	andeq	r0, r0, ip, lsl r1
 178:	00510001 	subseq	r0, r1, r1
	...
 184:	00007800 	andeq	r7, r0, r0, lsl #16
 188:	00009400 	andeq	r9, r0, r0, lsl #8
 18c:	5c000100 	stfpls	f0, [r0], {-0}
	...
 198:	00010100 	andeq	r0, r1, r0, lsl #2
 19c:	02010100 	andeq	r0, r1, #0, 2
 1a0:	00000102 	andeq	r0, r0, r2, lsl #2
 1a4:	00010100 	andeq	r0, r1, r0, lsl #2
 1a8:	00340000 	eorseq	r0, r4, r0
 1ac:	00340000 	eorseq	r0, r4, r0
 1b0:	00030000 	andeq	r0, r3, r0
 1b4:	349f7075 	ldrcc	r7, [pc], #117	; 1bc <_start-0x7e44>
 1b8:	48000000 	stmdami	r0, {}	; <UNPREDICTABLE>
 1bc:	03000000 	movweq	r0, #0
 1c0:	9f747500 	svcls	0x00747500
 1c4:	00000048 	andeq	r0, r0, r8, asr #32
 1c8:	00000054 	andeq	r0, r0, r4, asr r0
 1cc:	64750003 	ldrbtvs	r0, [r5], #-3
 1d0:	0000549f 	muleq	r0, pc, r4	; <UNPREDICTABLE>
 1d4:	00005400 	andeq	r5, r0, r0, lsl #8
 1d8:	75000300 	strvc	r0, [r0, #-768]	; 0xfffffd00
 1dc:	00549f68 	subseq	r9, r4, r8, ror #30
 1e0:	00580000 	subseq	r0, r8, r0
 1e4:	00030000 	andeq	r0, r3, r0
 1e8:	789f6c75 	ldmvc	pc, {r0, r2, r4, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 1ec:	94000000 	strls	r0, [r0], #-0
 1f0:	01000000 	mrseq	r0, (UNDEF: 0)
 1f4:	00945100 	addseq	r5, r4, r0, lsl #2
 1f8:	00940000 	addseq	r0, r4, r0
 1fc:	00010000 	andeq	r0, r1, r0
 200:	00009454 	andeq	r9, r0, r4, asr r4
 204:	00009800 	andeq	r9, r0, r0, lsl #16
 208:	74000300 	strvc	r0, [r0], #-768	; 0xfffffd00
 20c:	00989f04 	addseq	r9, r8, r4, lsl #30
 210:	00b40000 	adcseq	r0, r4, r0
 214:	00010000 	andeq	r0, r1, r0
 218:	00000054 	andeq	r0, r0, r4, asr r0
 21c:	00000000 	andeq	r0, r0, r0
	...
