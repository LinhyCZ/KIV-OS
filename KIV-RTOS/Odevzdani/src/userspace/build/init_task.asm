
./init_task:     file format elf32-littlearm


Disassembly of section .text:

00008000 <_start>:
_start():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/crt0.s:10
;@ startovaci symbol - vstupni bod z jadra OS do uzivatelskeho programu
;@ v podstate jen ihned zavola nejakou C funkci, nepotrebujeme nic tak kritickeho, abychom to vsechno museli psal v ASM
;@ jen _start vlastne ani neni funkce, takze by tento vstupni bod mel byt psany takto; rovnez je treba se ujistit, ze
;@ je tento symbol relokovany spravne na 0x8000 (tam OS ocekava, ze se nachazi vstupni bod)
_start:
    bl __crt0_run
    8000:	eb000017 	bl	8064 <__crt0_run>

00008004 <_hang>:
_hang():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/crt0.s:13
    ;@ z funkce __crt0_run by se nemel proces uz vratit, ale kdyby neco, tak se zacyklime
_hang:
    b _hang
    8004:	eafffffe 	b	8004 <_hang>

00008008 <__crt0_init_bss>:
__crt0_init_bss():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/crt0.c:10

extern unsigned int __bss_start;
extern unsigned int __bss_end;

void __crt0_init_bss()
{
    8008:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    800c:	e28db000 	add	fp, sp, #0
    8010:	e24dd00c 	sub	sp, sp, #12
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/crt0.c:11
    for (unsigned int* cur = &__bss_start; cur < &__bss_end; cur++)
    8014:	e59f3040 	ldr	r3, [pc, #64]	; 805c <__crt0_init_bss+0x54>
    8018:	e50b3008 	str	r3, [fp, #-8]
    801c:	ea000005 	b	8038 <__crt0_init_bss+0x30>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/crt0.c:12 (discriminator 3)
        *cur = 0;
    8020:	e51b3008 	ldr	r3, [fp, #-8]
    8024:	e3a02000 	mov	r2, #0
    8028:	e5832000 	str	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/crt0.c:11 (discriminator 3)
    for (unsigned int* cur = &__bss_start; cur < &__bss_end; cur++)
    802c:	e51b3008 	ldr	r3, [fp, #-8]
    8030:	e2833004 	add	r3, r3, #4
    8034:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/crt0.c:11 (discriminator 1)
    8038:	e51b3008 	ldr	r3, [fp, #-8]
    803c:	e59f201c 	ldr	r2, [pc, #28]	; 8060 <__crt0_init_bss+0x58>
    8040:	e1530002 	cmp	r3, r2
    8044:	3afffff5 	bcc	8020 <__crt0_init_bss+0x18>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/crt0.c:13
}
    8048:	e320f000 	nop	{0}
    804c:	e320f000 	nop	{0}
    8050:	e28bd000 	add	sp, fp, #0
    8054:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8058:	e12fff1e 	bx	lr
    805c:	0000944c 	andeq	r9, r0, ip, asr #8
    8060:	0000945c 	andeq	r9, r0, ip, asr r4

00008064 <__crt0_run>:
__crt0_run():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/crt0.c:16

void __crt0_run()
{
    8064:	e92d4800 	push	{fp, lr}
    8068:	e28db004 	add	fp, sp, #4
    806c:	e24dd008 	sub	sp, sp, #8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/crt0.c:18
    // inicializace .bss sekce (vynulovani)
    __crt0_init_bss();
    8070:	ebffffe4 	bl	8008 <__crt0_init_bss>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/crt0.c:21

    // volani konstruktoru globalnich trid (C++)
    _cpp_startup();
    8074:	eb000040 	bl	817c <_cpp_startup>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/crt0.c:26

    // volani funkce main
    // nebudeme se zde zabyvat predavanim parametru do funkce main
    // jinak by se mohly predavat napr. namapovane do virtualniho adr. prostoru a odkazem pres zasobnik (kam nam muze OS pushnout co chce)
    int result = main(0, 0);
    8078:	e3a01000 	mov	r1, #0
    807c:	e3a00000 	mov	r0, #0
    8080:	eb000069 	bl	822c <main>
    8084:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/crt0.c:29

    // volani destruktoru globalnich trid (C++)
    _cpp_shutdown();
    8088:	eb000051 	bl	81d4 <_cpp_shutdown>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/crt0.c:32

    // volani terminate() syscallu s navratovym kodem funkce main
    asm volatile("mov r0, %0" : : "r" (result));
    808c:	e51b3008 	ldr	r3, [fp, #-8]
    8090:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/crt0.c:33
    asm volatile("svc #1");
    8094:	ef000001 	svc	0x00000001
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/crt0.c:34
}
    8098:	e320f000 	nop	{0}
    809c:	e24bd004 	sub	sp, fp, #4
    80a0:	e8bd8800 	pop	{fp, pc}

000080a4 <__cxa_guard_acquire>:
__cxa_guard_acquire():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/cxxabi.cpp:11
	extern "C" int __cxa_guard_acquire (__guard *);
	extern "C" void __cxa_guard_release (__guard *);
	extern "C" void __cxa_guard_abort (__guard *);

	extern "C" int __cxa_guard_acquire (__guard *g)
	{
    80a4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80a8:	e28db000 	add	fp, sp, #0
    80ac:	e24dd00c 	sub	sp, sp, #12
    80b0:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/cxxabi.cpp:12
		return !*(char *)(g);
    80b4:	e51b3008 	ldr	r3, [fp, #-8]
    80b8:	e5d33000 	ldrb	r3, [r3]
    80bc:	e3530000 	cmp	r3, #0
    80c0:	03a03001 	moveq	r3, #1
    80c4:	13a03000 	movne	r3, #0
    80c8:	e6ef3073 	uxtb	r3, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/cxxabi.cpp:13
	}
    80cc:	e1a00003 	mov	r0, r3
    80d0:	e28bd000 	add	sp, fp, #0
    80d4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80d8:	e12fff1e 	bx	lr

000080dc <__cxa_guard_release>:
__cxa_guard_release():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/cxxabi.cpp:16

	extern "C" void __cxa_guard_release (__guard *g)
	{
    80dc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80e0:	e28db000 	add	fp, sp, #0
    80e4:	e24dd00c 	sub	sp, sp, #12
    80e8:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/cxxabi.cpp:17
		*(char *)g = 1;
    80ec:	e51b3008 	ldr	r3, [fp, #-8]
    80f0:	e3a02001 	mov	r2, #1
    80f4:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/cxxabi.cpp:18
	}
    80f8:	e320f000 	nop	{0}
    80fc:	e28bd000 	add	sp, fp, #0
    8100:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8104:	e12fff1e 	bx	lr

00008108 <__cxa_guard_abort>:
__cxa_guard_abort():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/cxxabi.cpp:21

	extern "C" void __cxa_guard_abort (__guard *)
	{
    8108:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    810c:	e28db000 	add	fp, sp, #0
    8110:	e24dd00c 	sub	sp, sp, #12
    8114:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/cxxabi.cpp:23

	}
    8118:	e320f000 	nop	{0}
    811c:	e28bd000 	add	sp, fp, #0
    8120:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8124:	e12fff1e 	bx	lr

00008128 <__dso_handle>:
__dso_handle():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/cxxabi.cpp:27
}

extern "C" void __dso_handle()
{
    8128:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    812c:	e28db000 	add	fp, sp, #0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/cxxabi.cpp:29
    // ignore dtors for now
}
    8130:	e320f000 	nop	{0}
    8134:	e28bd000 	add	sp, fp, #0
    8138:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    813c:	e12fff1e 	bx	lr

00008140 <__cxa_atexit>:
__cxa_atexit():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/cxxabi.cpp:32

extern "C" void __cxa_atexit()
{
    8140:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8144:	e28db000 	add	fp, sp, #0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/cxxabi.cpp:34
    // ignore dtors for now
}
    8148:	e320f000 	nop	{0}
    814c:	e28bd000 	add	sp, fp, #0
    8150:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8154:	e12fff1e 	bx	lr

00008158 <__cxa_pure_virtual>:
__cxa_pure_virtual():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/cxxabi.cpp:37

extern "C" void __cxa_pure_virtual()
{
    8158:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    815c:	e28db000 	add	fp, sp, #0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/cxxabi.cpp:39
    // pure virtual method called
}
    8160:	e320f000 	nop	{0}
    8164:	e28bd000 	add	sp, fp, #0
    8168:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    816c:	e12fff1e 	bx	lr

00008170 <__aeabi_unwind_cpp_pr1>:
__aeabi_unwind_cpp_pr1():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/cxxabi.cpp:42

extern "C" void __aeabi_unwind_cpp_pr1()
{
    8170:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8174:	e28db000 	add	fp, sp, #0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/cxxabi.cpp:43 (discriminator 1)
	while (true)
    8178:	eafffffe 	b	8178 <__aeabi_unwind_cpp_pr1+0x8>

0000817c <_cpp_startup>:
_cpp_startup():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/cxxabi.cpp:61
extern "C" dtor_ptr __DTOR_LIST__[0];
// konec pole destruktoru
extern "C" dtor_ptr __DTOR_END__[0];

extern "C" int _cpp_startup(void)
{
    817c:	e92d4800 	push	{fp, lr}
    8180:	e28db004 	add	fp, sp, #4
    8184:	e24dd008 	sub	sp, sp, #8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/cxxabi.cpp:66
	ctor_ptr* fnptr;
	
	// zavolame konstruktory globalnich C++ trid
	// v poli __CTOR_LIST__ jsou ukazatele na vygenerovane stuby volani konstruktoru
	for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    8188:	e59f303c 	ldr	r3, [pc, #60]	; 81cc <_cpp_startup+0x50>
    818c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/cxxabi.cpp:66 (discriminator 3)
    8190:	e51b3008 	ldr	r3, [fp, #-8]
    8194:	e59f2034 	ldr	r2, [pc, #52]	; 81d0 <_cpp_startup+0x54>
    8198:	e1530002 	cmp	r3, r2
    819c:	2a000006 	bcs	81bc <_cpp_startup+0x40>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/cxxabi.cpp:67 (discriminator 2)
		(*fnptr)();
    81a0:	e51b3008 	ldr	r3, [fp, #-8]
    81a4:	e5933000 	ldr	r3, [r3]
    81a8:	e12fff33 	blx	r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/cxxabi.cpp:66 (discriminator 2)
	for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    81ac:	e51b3008 	ldr	r3, [fp, #-8]
    81b0:	e2833004 	add	r3, r3, #4
    81b4:	e50b3008 	str	r3, [fp, #-8]
    81b8:	eafffff4 	b	8190 <_cpp_startup+0x14>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/cxxabi.cpp:69
	
	return 0;
    81bc:	e3a03000 	mov	r3, #0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/cxxabi.cpp:70
}
    81c0:	e1a00003 	mov	r0, r3
    81c4:	e24bd004 	sub	sp, fp, #4
    81c8:	e8bd8800 	pop	{fp, pc}
    81cc:	00009449 	andeq	r9, r0, r9, asr #8
    81d0:	00009449 	andeq	r9, r0, r9, asr #8

000081d4 <_cpp_shutdown>:
_cpp_shutdown():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/cxxabi.cpp:73

extern "C" int _cpp_shutdown(void)
{
    81d4:	e92d4800 	push	{fp, lr}
    81d8:	e28db004 	add	fp, sp, #4
    81dc:	e24dd008 	sub	sp, sp, #8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/cxxabi.cpp:77
	dtor_ptr* fnptr;
	
	// zavolame destruktory globalnich C++ trid
	for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    81e0:	e59f303c 	ldr	r3, [pc, #60]	; 8224 <_cpp_shutdown+0x50>
    81e4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/cxxabi.cpp:77 (discriminator 3)
    81e8:	e51b3008 	ldr	r3, [fp, #-8]
    81ec:	e59f2034 	ldr	r2, [pc, #52]	; 8228 <_cpp_shutdown+0x54>
    81f0:	e1530002 	cmp	r3, r2
    81f4:	2a000006 	bcs	8214 <_cpp_shutdown+0x40>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/cxxabi.cpp:78 (discriminator 2)
		(*fnptr)();
    81f8:	e51b3008 	ldr	r3, [fp, #-8]
    81fc:	e5933000 	ldr	r3, [r3]
    8200:	e12fff33 	blx	r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/cxxabi.cpp:77 (discriminator 2)
	for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    8204:	e51b3008 	ldr	r3, [fp, #-8]
    8208:	e2833004 	add	r3, r3, #4
    820c:	e50b3008 	str	r3, [fp, #-8]
    8210:	eafffff4 	b	81e8 <_cpp_shutdown+0x14>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/cxxabi.cpp:80
	
	return 0;
    8214:	e3a03000 	mov	r3, #0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/cxxabi.cpp:81
}
    8218:	e1a00003 	mov	r0, r3
    821c:	e24bd004 	sub	sp, fp, #4
    8220:	e8bd8800 	pop	{fp, pc}
    8224:	00009449 	andeq	r9, r0, r9, asr #8
    8228:	00009449 	andeq	r9, r0, r9, asr #8

0000822c <main>:
main():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/init_task/main.cpp:6
#include <stdfile.h>

#include <process/process_manager.h>

int main(int argc, char** argv)
{
    822c:	e92d4800 	push	{fp, lr}
    8230:	e28db004 	add	fp, sp, #4
    8234:	e24dd008 	sub	sp, sp, #8
    8238:	e50b0008 	str	r0, [fp, #-8]
    823c:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/init_task/main.cpp:11
	// systemovy init task startuje jako prvni, a ma nejnizsi prioritu ze vsech - bude se tedy planovat v podstate jen tehdy,
	// kdy nic jineho nikdo nema na praci

	// nastavime deadline na "nekonecno" = vlastne snizime dynamickou prioritu na nejnizsi moznou
	set_task_deadline(Indefinite);
    8240:	e3e00000 	mvn	r0, #0
    8244:	eb0000d7 	bl	85a8 <_Z17set_task_deadlinej>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/init_task/main.cpp:18
	// TODO: tady budeme chtit nechat spoustet zbytek procesu, az budeme umet nacitat treba z eMMC a SD karty
	
	while (true)
	{
		// kdyz je planovany jen tento proces, pockame na udalost (preruseni, ...)
		if (get_active_process_count() == 1)
    8248:	eb0000b8 	bl	8530 <_Z24get_active_process_countv>
    824c:	e1a03000 	mov	r3, r0
    8250:	e3530001 	cmp	r3, #1
    8254:	03a03001 	moveq	r3, #1
    8258:	13a03000 	movne	r3, #0
    825c:	e6ef3073 	uxtb	r3, r3
    8260:	e3530000 	cmp	r3, #0
    8264:	0a000000 	beq	826c <main+0x40>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/init_task/main.cpp:19
			asm volatile("wfe");
    8268:	e320f002 	wfe
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/init_task/main.cpp:22

		// predame zbytek casoveho kvanta dalsimu procesu
		sched_yield();
    826c:	eb000016 	bl	82cc <_Z11sched_yieldv>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/userspace/init_task/main.cpp:18
		if (get_active_process_count() == 1)
    8270:	eafffff4 	b	8248 <main+0x1c>

00008274 <_Z6getpidv>:
_Z6getpidv():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    8274:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8278:	e28db000 	add	fp, sp, #0
    827c:	e24dd00c 	sub	sp, sp, #12
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    8280:	ef000000 	svc	0x00000000
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    8284:	e1a03000 	mov	r3, r0
    8288:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:11

    return pid;
    828c:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:12
}
    8290:	e1a00003 	mov	r0, r3
    8294:	e28bd000 	add	sp, fp, #0
    8298:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    829c:	e12fff1e 	bx	lr

000082a0 <_Z9terminatei>:
_Z9terminatei():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    82a0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82a4:	e28db000 	add	fp, sp, #0
    82a8:	e24dd00c 	sub	sp, sp, #12
    82ac:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r" (exitcode));
    82b0:	e51b3008 	ldr	r3, [fp, #-8]
    82b4:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    82b8:	ef000001 	svc	0x00000001
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:18
}
    82bc:	e320f000 	nop	{0}
    82c0:	e28bd000 	add	sp, fp, #0
    82c4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    82c8:	e12fff1e 	bx	lr

000082cc <_Z11sched_yieldv>:
_Z11sched_yieldv():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    82cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82d0:	e28db000 	add	fp, sp, #0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    82d4:	ef000002 	svc	0x00000002
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:23
}
    82d8:	e320f000 	nop	{0}
    82dc:	e28bd000 	add	sp, fp, #0
    82e0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    82e4:	e12fff1e 	bx	lr

000082e8 <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    82e8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82ec:	e28db000 	add	fp, sp, #0
    82f0:	e24dd014 	sub	sp, sp, #20
    82f4:	e50b0010 	str	r0, [fp, #-16]
    82f8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    82fc:	e51b3010 	ldr	r3, [fp, #-16]
    8300:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r" (mode));
    8304:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8308:	e1a01003 	mov	r1, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    830c:	ef000040 	svc	0x00000040
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r" (file));
    8310:	e1a03000 	mov	r3, r0
    8314:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:34

    return file;
    8318:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:35
}
    831c:	e1a00003 	mov	r0, r3
    8320:	e28bd000 	add	sp, fp, #0
    8324:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8328:	e12fff1e 	bx	lr

0000832c <_Z4readjPcj>:
_Z4readjPcj():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    832c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8330:	e28db000 	add	fp, sp, #0
    8334:	e24dd01c 	sub	sp, sp, #28
    8338:	e50b0010 	str	r0, [fp, #-16]
    833c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8340:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8344:	e51b3010 	ldr	r3, [fp, #-16]
    8348:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r" (buffer));
    834c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8350:	e1a01003 	mov	r1, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r" (size));
    8354:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8358:	e1a02003 	mov	r2, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    835c:	ef000041 	svc	0x00000041
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r" (rdnum));
    8360:	e1a03000 	mov	r3, r0
    8364:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:47

    return rdnum;
    8368:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:48
}
    836c:	e1a00003 	mov	r0, r3
    8370:	e28bd000 	add	sp, fp, #0
    8374:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8378:	e12fff1e 	bx	lr

0000837c <_Z5writejPKcj>:
_Z5writejPKcj():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:51

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    837c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8380:	e28db000 	add	fp, sp, #0
    8384:	e24dd01c 	sub	sp, sp, #28
    8388:	e50b0010 	str	r0, [fp, #-16]
    838c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8390:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:54
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8394:	e51b3010 	ldr	r3, [fp, #-16]
    8398:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:55
    asm volatile("mov r1, %0" : : "r" (buffer));
    839c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    83a0:	e1a01003 	mov	r1, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:56
    asm volatile("mov r2, %0" : : "r" (size));
    83a4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    83a8:	e1a02003 	mov	r2, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:57
    asm volatile("swi 66");
    83ac:	ef000042 	svc	0x00000042
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:58
    asm volatile("mov %0, r0" : "=r" (wrnum));
    83b0:	e1a03000 	mov	r3, r0
    83b4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:60

    return wrnum;
    83b8:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:61
}
    83bc:	e1a00003 	mov	r0, r3
    83c0:	e28bd000 	add	sp, fp, #0
    83c4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83c8:	e12fff1e 	bx	lr

000083cc <_Z5closej>:
_Z5closej():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:64

void close(uint32_t file)
{
    83cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83d0:	e28db000 	add	fp, sp, #0
    83d4:	e24dd00c 	sub	sp, sp, #12
    83d8:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:65
    asm volatile("mov r0, %0" : : "r" (file));
    83dc:	e51b3008 	ldr	r3, [fp, #-8]
    83e0:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:66
    asm volatile("swi 67");
    83e4:	ef000043 	svc	0x00000043
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:67
}
    83e8:	e320f000 	nop	{0}
    83ec:	e28bd000 	add	sp, fp, #0
    83f0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83f4:	e12fff1e 	bx	lr

000083f8 <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:70

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    83f8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83fc:	e28db000 	add	fp, sp, #0
    8400:	e24dd01c 	sub	sp, sp, #28
    8404:	e50b0010 	str	r0, [fp, #-16]
    8408:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    840c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:73
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    8410:	e51b3010 	ldr	r3, [fp, #-16]
    8414:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:74
    asm volatile("mov r1, %0" : : "r" (operation));
    8418:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    841c:	e1a01003 	mov	r1, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:75
    asm volatile("mov r2, %0" : : "r" (param));
    8420:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8424:	e1a02003 	mov	r2, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:76
    asm volatile("swi 68");
    8428:	ef000044 	svc	0x00000044
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:77
    asm volatile("mov %0, r0" : "=r" (retcode));
    842c:	e1a03000 	mov	r3, r0
    8430:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:79

    return retcode;
    8434:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:80
}
    8438:	e1a00003 	mov	r0, r3
    843c:	e28bd000 	add	sp, fp, #0
    8440:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8444:	e12fff1e 	bx	lr

00008448 <_Z6notifyjj>:
_Z6notifyjj():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:83

uint32_t notify(uint32_t file, uint32_t count)
{
    8448:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    844c:	e28db000 	add	fp, sp, #0
    8450:	e24dd014 	sub	sp, sp, #20
    8454:	e50b0010 	str	r0, [fp, #-16]
    8458:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:86
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    845c:	e51b3010 	ldr	r3, [fp, #-16]
    8460:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:87
    asm volatile("mov r1, %0" : : "r" (count));
    8464:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8468:	e1a01003 	mov	r1, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:88
    asm volatile("swi 69");
    846c:	ef000045 	svc	0x00000045
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:89
    asm volatile("mov %0, r0" : "=r" (retcnt));
    8470:	e1a03000 	mov	r3, r0
    8474:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:91

    return retcnt;
    8478:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:92
}
    847c:	e1a00003 	mov	r0, r3
    8480:	e28bd000 	add	sp, fp, #0
    8484:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8488:	e12fff1e 	bx	lr

0000848c <_Z4waitjjj>:
_Z4waitjjj():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:95

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    848c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8490:	e28db000 	add	fp, sp, #0
    8494:	e24dd01c 	sub	sp, sp, #28
    8498:	e50b0010 	str	r0, [fp, #-16]
    849c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    84a0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:98
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    84a4:	e51b3010 	ldr	r3, [fp, #-16]
    84a8:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:99
    asm volatile("mov r1, %0" : : "r" (count));
    84ac:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84b0:	e1a01003 	mov	r1, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:100
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    84b4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    84b8:	e1a02003 	mov	r2, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:101
    asm volatile("swi 70");
    84bc:	ef000046 	svc	0x00000046
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:102
    asm volatile("mov %0, r0" : "=r" (retcode));
    84c0:	e1a03000 	mov	r3, r0
    84c4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:104

    return retcode;
    84c8:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:105
}
    84cc:	e1a00003 	mov	r0, r3
    84d0:	e28bd000 	add	sp, fp, #0
    84d4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84d8:	e12fff1e 	bx	lr

000084dc <_Z5sleepjj>:
_Z5sleepjj():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:108

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    84dc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84e0:	e28db000 	add	fp, sp, #0
    84e4:	e24dd014 	sub	sp, sp, #20
    84e8:	e50b0010 	str	r0, [fp, #-16]
    84ec:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:111
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    84f0:	e51b3010 	ldr	r3, [fp, #-16]
    84f4:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:112
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    84f8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84fc:	e1a01003 	mov	r1, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:113
    asm volatile("swi 3");
    8500:	ef000003 	svc	0x00000003
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:114
    asm volatile("mov %0, r0" : "=r" (retcode));
    8504:	e1a03000 	mov	r3, r0
    8508:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:116

    return retcode;
    850c:	e51b3008 	ldr	r3, [fp, #-8]
    8510:	e3530000 	cmp	r3, #0
    8514:	13a03001 	movne	r3, #1
    8518:	03a03000 	moveq	r3, #0
    851c:	e6ef3073 	uxtb	r3, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:117
}
    8520:	e1a00003 	mov	r0, r3
    8524:	e28bd000 	add	sp, fp, #0
    8528:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    852c:	e12fff1e 	bx	lr

00008530 <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:120

uint32_t get_active_process_count()
{
    8530:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8534:	e28db000 	add	fp, sp, #0
    8538:	e24dd00c 	sub	sp, sp, #12
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:121
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    853c:	e3a03000 	mov	r3, #0
    8540:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:124
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    8544:	e3a03000 	mov	r3, #0
    8548:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:125
    asm volatile("mov r1, %0" : : "r" (&retval));
    854c:	e24b300c 	sub	r3, fp, #12
    8550:	e1a01003 	mov	r1, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:126
    asm volatile("swi 4");
    8554:	ef000004 	svc	0x00000004
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:128

    return retval;
    8558:	e51b300c 	ldr	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:129
}
    855c:	e1a00003 	mov	r0, r3
    8560:	e28bd000 	add	sp, fp, #0
    8564:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8568:	e12fff1e 	bx	lr

0000856c <_Z14get_tick_countv>:
_Z14get_tick_countv():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:132

uint32_t get_tick_count()
{
    856c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8570:	e28db000 	add	fp, sp, #0
    8574:	e24dd00c 	sub	sp, sp, #12
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:133
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    8578:	e3a03001 	mov	r3, #1
    857c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:136
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    8580:	e3a03001 	mov	r3, #1
    8584:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:137
    asm volatile("mov r1, %0" : : "r" (&retval));
    8588:	e24b300c 	sub	r3, fp, #12
    858c:	e1a01003 	mov	r1, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:138
    asm volatile("swi 4");
    8590:	ef000004 	svc	0x00000004
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:140

    return retval;
    8594:	e51b300c 	ldr	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:141
}
    8598:	e1a00003 	mov	r0, r3
    859c:	e28bd000 	add	sp, fp, #0
    85a0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85a4:	e12fff1e 	bx	lr

000085a8 <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:144

void set_task_deadline(uint32_t tick_count_required)
{
    85a8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85ac:	e28db000 	add	fp, sp, #0
    85b0:	e24dd014 	sub	sp, sp, #20
    85b4:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:145
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    85b8:	e3a03000 	mov	r3, #0
    85bc:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:147

    asm volatile("mov r0, %0" : : "r" (req));
    85c0:	e3a03000 	mov	r3, #0
    85c4:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:148
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    85c8:	e24b3010 	sub	r3, fp, #16
    85cc:	e1a01003 	mov	r1, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:149
    asm volatile("swi 5");
    85d0:	ef000005 	svc	0x00000005
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:150
}
    85d4:	e320f000 	nop	{0}
    85d8:	e28bd000 	add	sp, fp, #0
    85dc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85e0:	e12fff1e 	bx	lr

000085e4 <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:153

uint32_t get_task_ticks_to_deadline()
{
    85e4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85e8:	e28db000 	add	fp, sp, #0
    85ec:	e24dd00c 	sub	sp, sp, #12
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:154
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    85f0:	e3a03001 	mov	r3, #1
    85f4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:157
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    85f8:	e3a03001 	mov	r3, #1
    85fc:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:158
    asm volatile("mov r1, %0" : : "r" (&ticks));
    8600:	e24b300c 	sub	r3, fp, #12
    8604:	e1a01003 	mov	r1, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:159
    asm volatile("swi 5");
    8608:	ef000005 	svc	0x00000005
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:161

    return ticks;
    860c:	e51b300c 	ldr	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:162
}
    8610:	e1a00003 	mov	r0, r3
    8614:	e28bd000 	add	sp, fp, #0
    8618:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    861c:	e12fff1e 	bx	lr

00008620 <_Z4pipePKcj>:
_Z4pipePKcj():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:167

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    8620:	e92d4800 	push	{fp, lr}
    8624:	e28db004 	add	fp, sp, #4
    8628:	e24dd050 	sub	sp, sp, #80	; 0x50
    862c:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    8630:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:169
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    8634:	e24b3048 	sub	r3, fp, #72	; 0x48
    8638:	e3a0200a 	mov	r2, #10
    863c:	e59f1088 	ldr	r1, [pc, #136]	; 86cc <_Z4pipePKcj+0xac>
    8640:	e1a00003 	mov	r0, r3
    8644:	eb000250 	bl	8f8c <_Z7strncpyPcPKci>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:170
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    8648:	e24b3048 	sub	r3, fp, #72	; 0x48
    864c:	e283300a 	add	r3, r3, #10
    8650:	e3a02035 	mov	r2, #53	; 0x35
    8654:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    8658:	e1a00003 	mov	r0, r3
    865c:	eb00024a 	bl	8f8c <_Z7strncpyPcPKci>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:172

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    8660:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    8664:	eb0002d8 	bl	91cc <_Z6strlenPKc>
    8668:	e1a03000 	mov	r3, r0
    866c:	e283300a 	add	r3, r3, #10
    8670:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:174

    fname[ncur++] = '#';
    8674:	e51b3008 	ldr	r3, [fp, #-8]
    8678:	e2832001 	add	r2, r3, #1
    867c:	e50b2008 	str	r2, [fp, #-8]
    8680:	e24b2004 	sub	r2, fp, #4
    8684:	e0823003 	add	r3, r2, r3
    8688:	e3a02023 	mov	r2, #35	; 0x23
    868c:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:176

    itoa(buf_size, &fname[ncur], 10);
    8690:	e24b2048 	sub	r2, fp, #72	; 0x48
    8694:	e51b3008 	ldr	r3, [fp, #-8]
    8698:	e0823003 	add	r3, r2, r3
    869c:	e3a0200a 	mov	r2, #10
    86a0:	e1a01003 	mov	r1, r3
    86a4:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    86a8:	eb000008 	bl	86d0 <_Z4itoajPcj>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:178

    return open(fname, NFile_Open_Mode::Read_Write);
    86ac:	e24b3048 	sub	r3, fp, #72	; 0x48
    86b0:	e3a01002 	mov	r1, #2
    86b4:	e1a00003 	mov	r0, r3
    86b8:	ebffff0a 	bl	82e8 <_Z4openPKc15NFile_Open_Mode>
    86bc:	e1a03000 	mov	r3, r0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdfile.cpp:179
}
    86c0:	e1a00003 	mov	r0, r3
    86c4:	e24bd004 	sub	sp, fp, #4
    86c8:	e8bd8800 	pop	{fp, pc}
    86cc:	0000942c 	andeq	r9, r0, ip, lsr #8

000086d0 <_Z4itoajPcj>:
_Z4itoajPcj():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:11
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    86d0:	e92d4800 	push	{fp, lr}
    86d4:	e28db004 	add	fp, sp, #4
    86d8:	e24dd020 	sub	sp, sp, #32
    86dc:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    86e0:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    86e4:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:12
	int i = 0;
    86e8:	e3a03000 	mov	r3, #0
    86ec:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:14

	while (input > 0)
    86f0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    86f4:	e3530000 	cmp	r3, #0
    86f8:	0a000014 	beq	8750 <_Z4itoajPcj+0x80>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:16
	{
		output[i] = CharConvArr[input % base];
    86fc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8700:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8704:	e1a00003 	mov	r0, r3
    8708:	eb000328 	bl	93b0 <__aeabi_uidivmod>
    870c:	e1a03001 	mov	r3, r1
    8710:	e1a01003 	mov	r1, r3
    8714:	e51b3008 	ldr	r3, [fp, #-8]
    8718:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    871c:	e0823003 	add	r3, r2, r3
    8720:	e59f2118 	ldr	r2, [pc, #280]	; 8840 <_Z4itoajPcj+0x170>
    8724:	e7d22001 	ldrb	r2, [r2, r1]
    8728:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:17
		input /= base;
    872c:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8730:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8734:	eb0002f3 	bl	9308 <__udivsi3>
    8738:	e1a03000 	mov	r3, r0
    873c:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:18
		i++;
    8740:	e51b3008 	ldr	r3, [fp, #-8]
    8744:	e2833001 	add	r3, r3, #1
    8748:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:14
	while (input > 0)
    874c:	eaffffe7 	b	86f0 <_Z4itoajPcj+0x20>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:21
	}

    if (i == 0)
    8750:	e51b3008 	ldr	r3, [fp, #-8]
    8754:	e3530000 	cmp	r3, #0
    8758:	1a000007 	bne	877c <_Z4itoajPcj+0xac>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:23
    {
        output[i] = CharConvArr[0];
    875c:	e51b3008 	ldr	r3, [fp, #-8]
    8760:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8764:	e0823003 	add	r3, r2, r3
    8768:	e3a02030 	mov	r2, #48	; 0x30
    876c:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:24
        i++;
    8770:	e51b3008 	ldr	r3, [fp, #-8]
    8774:	e2833001 	add	r3, r3, #1
    8778:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:27
    }

	output[i] = '\0';
    877c:	e51b3008 	ldr	r3, [fp, #-8]
    8780:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8784:	e0823003 	add	r3, r2, r3
    8788:	e3a02000 	mov	r2, #0
    878c:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:28
	i--;
    8790:	e51b3008 	ldr	r3, [fp, #-8]
    8794:	e2433001 	sub	r3, r3, #1
    8798:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:30

	for (int j = 0; j <= i/2; j++)
    879c:	e3a03000 	mov	r3, #0
    87a0:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:30 (discriminator 3)
    87a4:	e51b3008 	ldr	r3, [fp, #-8]
    87a8:	e1a02fa3 	lsr	r2, r3, #31
    87ac:	e0823003 	add	r3, r2, r3
    87b0:	e1a030c3 	asr	r3, r3, #1
    87b4:	e1a02003 	mov	r2, r3
    87b8:	e51b300c 	ldr	r3, [fp, #-12]
    87bc:	e1530002 	cmp	r3, r2
    87c0:	ca00001b 	bgt	8834 <_Z4itoajPcj+0x164>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:32 (discriminator 2)
	{
		char c = output[i - j];
    87c4:	e51b2008 	ldr	r2, [fp, #-8]
    87c8:	e51b300c 	ldr	r3, [fp, #-12]
    87cc:	e0423003 	sub	r3, r2, r3
    87d0:	e1a02003 	mov	r2, r3
    87d4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    87d8:	e0833002 	add	r3, r3, r2
    87dc:	e5d33000 	ldrb	r3, [r3]
    87e0:	e54b300d 	strb	r3, [fp, #-13]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:33 (discriminator 2)
		output[i - j] = output[j];
    87e4:	e51b300c 	ldr	r3, [fp, #-12]
    87e8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    87ec:	e0822003 	add	r2, r2, r3
    87f0:	e51b1008 	ldr	r1, [fp, #-8]
    87f4:	e51b300c 	ldr	r3, [fp, #-12]
    87f8:	e0413003 	sub	r3, r1, r3
    87fc:	e1a01003 	mov	r1, r3
    8800:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8804:	e0833001 	add	r3, r3, r1
    8808:	e5d22000 	ldrb	r2, [r2]
    880c:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:34 (discriminator 2)
		output[j] = c;
    8810:	e51b300c 	ldr	r3, [fp, #-12]
    8814:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8818:	e0823003 	add	r3, r2, r3
    881c:	e55b200d 	ldrb	r2, [fp, #-13]
    8820:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:30 (discriminator 2)
	for (int j = 0; j <= i/2; j++)
    8824:	e51b300c 	ldr	r3, [fp, #-12]
    8828:	e2833001 	add	r3, r3, #1
    882c:	e50b300c 	str	r3, [fp, #-12]
    8830:	eaffffdb 	b	87a4 <_Z4itoajPcj+0xd4>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:36
	}
}
    8834:	e320f000 	nop	{0}
    8838:	e24bd004 	sub	sp, fp, #4
    883c:	e8bd8800 	pop	{fp, pc}
    8840:	00009438 	andeq	r9, r0, r8, lsr r4

00008844 <_Z4atoiPKc>:
_Z4atoiPKc():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:39

int atoi(const char* input)
{
    8844:	e92d4800 	push	{fp, lr}
    8848:	e28db004 	add	fp, sp, #4
    884c:	e24dd010 	sub	sp, sp, #16
    8850:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:40
	int output = 0;
    8854:	e3a03000 	mov	r3, #0
    8858:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:42

  if (isnan(input, false)) {
    885c:	e3a01000 	mov	r1, #0
    8860:	e51b0010 	ldr	r0, [fp, #-16]
    8864:	eb000055 	bl	89c0 <_Z5isnanPKcb>
    8868:	e1a03000 	mov	r3, r0
    886c:	e3530000 	cmp	r3, #0
    8870:	0a000001 	beq	887c <_Z4atoiPKc+0x38>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:43
    return 0;
    8874:	e3a03000 	mov	r3, #0
    8878:	ea00001c 	b	88f0 <_Z4atoiPKc+0xac>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:46
  }

	while (*input != '\0')
    887c:	e51b3010 	ldr	r3, [fp, #-16]
    8880:	e5d33000 	ldrb	r3, [r3]
    8884:	e3530000 	cmp	r3, #0
    8888:	0a000017 	beq	88ec <_Z4atoiPKc+0xa8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:48
	{
		output *= 10;
    888c:	e51b2008 	ldr	r2, [fp, #-8]
    8890:	e1a03002 	mov	r3, r2
    8894:	e1a03103 	lsl	r3, r3, #2
    8898:	e0833002 	add	r3, r3, r2
    889c:	e1a03083 	lsl	r3, r3, #1
    88a0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:49
		if (*input > '9' || *input < '0')
    88a4:	e51b3010 	ldr	r3, [fp, #-16]
    88a8:	e5d33000 	ldrb	r3, [r3]
    88ac:	e3530039 	cmp	r3, #57	; 0x39
    88b0:	8a00000d 	bhi	88ec <_Z4atoiPKc+0xa8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:49 (discriminator 1)
    88b4:	e51b3010 	ldr	r3, [fp, #-16]
    88b8:	e5d33000 	ldrb	r3, [r3]
    88bc:	e353002f 	cmp	r3, #47	; 0x2f
    88c0:	9a000009 	bls	88ec <_Z4atoiPKc+0xa8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:52
			break;

		output += *input - '0';
    88c4:	e51b3010 	ldr	r3, [fp, #-16]
    88c8:	e5d33000 	ldrb	r3, [r3]
    88cc:	e2433030 	sub	r3, r3, #48	; 0x30
    88d0:	e51b2008 	ldr	r2, [fp, #-8]
    88d4:	e0823003 	add	r3, r2, r3
    88d8:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:54

		input++;
    88dc:	e51b3010 	ldr	r3, [fp, #-16]
    88e0:	e2833001 	add	r3, r3, #1
    88e4:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:46
	while (*input != '\0')
    88e8:	eaffffe3 	b	887c <_Z4atoiPKc+0x38>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:57
	}

	return output;
    88ec:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:58
}
    88f0:	e1a00003 	mov	r0, r3
    88f4:	e24bd004 	sub	sp, fp, #4
    88f8:	e8bd8800 	pop	{fp, pc}

000088fc <_Z9normalizePf>:
_Z9normalizePf():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:60

int normalize(float *val) {
    88fc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8900:	e28db000 	add	fp, sp, #0
    8904:	e24dd014 	sub	sp, sp, #20
    8908:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:61
    int exponent = 0;
    890c:	e3a03000 	mov	r3, #0
    8910:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:62
    float value = *val;
    8914:	e51b3010 	ldr	r3, [fp, #-16]
    8918:	e5933000 	ldr	r3, [r3]
    891c:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:64

    while (value >= 1.0) {
    8920:	ed5b7a03 	vldr	s15, [fp, #-12]
    8924:	ed9f7a23 	vldr	s14, [pc, #140]	; 89b8 <_Z9normalizePf+0xbc>
    8928:	eef47ac7 	vcmpe.f32	s15, s14
    892c:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8930:	aa000000 	bge	8938 <_Z9normalizePf+0x3c>
    8934:	ea000007 	b	8958 <_Z9normalizePf+0x5c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:65
        value = value / 10.0;
    8938:	ed1b7a03 	vldr	s14, [fp, #-12]
    893c:	eddf6a1e 	vldr	s13, [pc, #120]	; 89bc <_Z9normalizePf+0xc0>
    8940:	eec77a26 	vdiv.f32	s15, s14, s13
    8944:	ed4b7a03 	vstr	s15, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:66
        ++exponent;
    8948:	e51b3008 	ldr	r3, [fp, #-8]
    894c:	e2833001 	add	r3, r3, #1
    8950:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:64
    while (value >= 1.0) {
    8954:	eafffff1 	b	8920 <_Z9normalizePf+0x24>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:69
    }

    while (value < 0.1) {
    8958:	ed5b7a03 	vldr	s15, [fp, #-12]
    895c:	eeb77ae7 	vcvt.f64.f32	d7, s15
    8960:	ed9f6b12 	vldr	d6, [pc, #72]	; 89b0 <_Z9normalizePf+0xb4>
    8964:	eeb47bc6 	vcmpe.f64	d7, d6
    8968:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    896c:	5a000007 	bpl	8990 <_Z9normalizePf+0x94>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:70
        value = value * 10.0;
    8970:	ed5b7a03 	vldr	s15, [fp, #-12]
    8974:	ed9f7a10 	vldr	s14, [pc, #64]	; 89bc <_Z9normalizePf+0xc0>
    8978:	ee677a87 	vmul.f32	s15, s15, s14
    897c:	ed4b7a03 	vstr	s15, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:71
        --exponent;
    8980:	e51b3008 	ldr	r3, [fp, #-8]
    8984:	e2433001 	sub	r3, r3, #1
    8988:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:69
    while (value < 0.1) {
    898c:	eafffff1 	b	8958 <_Z9normalizePf+0x5c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:73
    }
    *val = value;
    8990:	e51b3010 	ldr	r3, [fp, #-16]
    8994:	e51b200c 	ldr	r2, [fp, #-12]
    8998:	e5832000 	str	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:74
    return exponent;
    899c:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:75
}
    89a0:	e1a00003 	mov	r0, r3
    89a4:	e28bd000 	add	sp, fp, #0
    89a8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    89ac:	e12fff1e 	bx	lr
    89b0:	9999999a 	ldmibls	r9, {r1, r3, r4, r7, r8, fp, ip, pc}
    89b4:	3fb99999 	svccc	0x00b99999
    89b8:	3f800000 	svccc	0x00800000
    89bc:	41200000 			; <UNDEFINED> instruction: 0x41200000

000089c0 <_Z5isnanPKcb>:
_Z5isnanPKcb():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:78

bool isnan(const char *s, bool isFloat) 
{
    89c0:	e92d4800 	push	{fp, lr}
    89c4:	e28db004 	add	fp, sp, #4
    89c8:	e24dd018 	sub	sp, sp, #24
    89cc:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    89d0:	e1a03001 	mov	r3, r1
    89d4:	e54b3019 	strb	r3, [fp, #-25]	; 0xffffffe7
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:79
  int length = strlen(s);
    89d8:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    89dc:	eb0001fa 	bl	91cc <_Z6strlenPKc>
    89e0:	e50b000c 	str	r0, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:80
  if (length == 0) {
    89e4:	e51b300c 	ldr	r3, [fp, #-12]
    89e8:	e3530000 	cmp	r3, #0
    89ec:	1a000001 	bne	89f8 <_Z5isnanPKcb+0x38>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:81
    return true;
    89f0:	e3a03001 	mov	r3, #1
    89f4:	ea000025 	b	8a90 <_Z5isnanPKcb+0xd0>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:84
  }

	for (int i = 0; i < strlen(s); i++) {
    89f8:	e3a03000 	mov	r3, #0
    89fc:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:84 (discriminator 1)
    8a00:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8a04:	eb0001f0 	bl	91cc <_Z6strlenPKc>
    8a08:	e1a02000 	mov	r2, r0
    8a0c:	e51b3008 	ldr	r3, [fp, #-8]
    8a10:	e1530002 	cmp	r3, r2
    8a14:	b3a03001 	movlt	r3, #1
    8a18:	a3a03000 	movge	r3, #0
    8a1c:	e6ef3073 	uxtb	r3, r3
    8a20:	e3530000 	cmp	r3, #0
    8a24:	0a000018 	beq	8a8c <_Z5isnanPKcb+0xcc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:85
		char c = s[i];
    8a28:	e51b3008 	ldr	r3, [fp, #-8]
    8a2c:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8a30:	e0823003 	add	r3, r2, r3
    8a34:	e5d33000 	ldrb	r3, [r3]
    8a38:	e54b300d 	strb	r3, [fp, #-13]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:86
		if ((c != 46 || !isFloat) && (c < 48 || c > 57 )) { //Pokud neni tecka (Kdyz kontrolujeme jen float cisla) a zaroven je mimo rozsah cislic, vyhod ze neni number
    8a3c:	e55b300d 	ldrb	r3, [fp, #-13]
    8a40:	e353002e 	cmp	r3, #46	; 0x2e
    8a44:	1a000004 	bne	8a5c <_Z5isnanPKcb+0x9c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:86 (discriminator 2)
    8a48:	e55b3019 	ldrb	r3, [fp, #-25]	; 0xffffffe7
    8a4c:	e2233001 	eor	r3, r3, #1
    8a50:	e6ef3073 	uxtb	r3, r3
    8a54:	e3530000 	cmp	r3, #0
    8a58:	0a000007 	beq	8a7c <_Z5isnanPKcb+0xbc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:86 (discriminator 3)
    8a5c:	e55b300d 	ldrb	r3, [fp, #-13]
    8a60:	e353002f 	cmp	r3, #47	; 0x2f
    8a64:	9a000002 	bls	8a74 <_Z5isnanPKcb+0xb4>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:86 (discriminator 4)
    8a68:	e55b300d 	ldrb	r3, [fp, #-13]
    8a6c:	e3530039 	cmp	r3, #57	; 0x39
    8a70:	9a000001 	bls	8a7c <_Z5isnanPKcb+0xbc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:87
			return true;
    8a74:	e3a03001 	mov	r3, #1
    8a78:	ea000004 	b	8a90 <_Z5isnanPKcb+0xd0>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:84 (discriminator 2)
	for (int i = 0; i < strlen(s); i++) {
    8a7c:	e51b3008 	ldr	r3, [fp, #-8]
    8a80:	e2833001 	add	r3, r3, #1
    8a84:	e50b3008 	str	r3, [fp, #-8]
    8a88:	eaffffdc 	b	8a00 <_Z5isnanPKcb+0x40>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:91
		}
	}

	return false;
    8a8c:	e3a03000 	mov	r3, #0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:92
}
    8a90:	e1a00003 	mov	r0, r3
    8a94:	e24bd004 	sub	sp, fp, #4
    8a98:	e8bd8800 	pop	{fp, pc}

00008a9c <_Z4atofPKc>:
_Z4atofPKc():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:95

float atof(const char *s)
{
    8a9c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8aa0:	e28db000 	add	fp, sp, #0
    8aa4:	e24dd024 	sub	sp, sp, #36	; 0x24
    8aa8:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:100
  // This function stolen from either Rolf Neugebauer or Andrew Tolmach. 
  // Probably Rolf.
  // -----------------------------------
  // I stole it from https://github.com/GaloisInc/minlibc/blob/master/atof.c
  float a = 0.0;
    8aac:	e3a03000 	mov	r3, #0
    8ab0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:101
  int e = 0;
    8ab4:	e3a03000 	mov	r3, #0
    8ab8:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:103
  int c;
  while ((c = *s++) != '\0' && isdigit(c)) {
    8abc:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8ac0:	e2832001 	add	r2, r3, #1
    8ac4:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8ac8:	e5d33000 	ldrb	r3, [r3]
    8acc:	e50b3010 	str	r3, [fp, #-16]
    8ad0:	e51b3010 	ldr	r3, [fp, #-16]
    8ad4:	e3530000 	cmp	r3, #0
    8ad8:	0a000007 	beq	8afc <_Z4atofPKc+0x60>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:103 (discriminator 1)
    8adc:	e51b3010 	ldr	r3, [fp, #-16]
    8ae0:	e353002f 	cmp	r3, #47	; 0x2f
    8ae4:	da000004 	ble	8afc <_Z4atofPKc+0x60>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:103 (discriminator 3)
    8ae8:	e51b3010 	ldr	r3, [fp, #-16]
    8aec:	e3530039 	cmp	r3, #57	; 0x39
    8af0:	ca000001 	bgt	8afc <_Z4atofPKc+0x60>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:103 (discriminator 5)
    8af4:	e3a03001 	mov	r3, #1
    8af8:	ea000000 	b	8b00 <_Z4atofPKc+0x64>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:103 (discriminator 6)
    8afc:	e3a03000 	mov	r3, #0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:103 (discriminator 8)
    8b00:	e3530000 	cmp	r3, #0
    8b04:	0a00000b 	beq	8b38 <_Z4atofPKc+0x9c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:104
    a = a*10.0 + (c - '0');
    8b08:	ed5b7a02 	vldr	s15, [fp, #-8]
    8b0c:	eeb77ae7 	vcvt.f64.f32	d7, s15
    8b10:	ed9f6b8a 	vldr	d6, [pc, #552]	; 8d40 <_Z4atofPKc+0x2a4>
    8b14:	ee276b06 	vmul.f64	d6, d7, d6
    8b18:	e51b3010 	ldr	r3, [fp, #-16]
    8b1c:	e2433030 	sub	r3, r3, #48	; 0x30
    8b20:	ee073a90 	vmov	s15, r3
    8b24:	eeb87be7 	vcvt.f64.s32	d7, s15
    8b28:	ee367b07 	vadd.f64	d7, d6, d7
    8b2c:	eef77bc7 	vcvt.f32.f64	s15, d7
    8b30:	ed4b7a02 	vstr	s15, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:103
  while ((c = *s++) != '\0' && isdigit(c)) {
    8b34:	eaffffe0 	b	8abc <_Z4atofPKc+0x20>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:106
  }
  if (c == '.') {
    8b38:	e51b3010 	ldr	r3, [fp, #-16]
    8b3c:	e353002e 	cmp	r3, #46	; 0x2e
    8b40:	1a000021 	bne	8bcc <_Z4atofPKc+0x130>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:107
    while ((c = *s++) != '\0' && isdigit(c)) {
    8b44:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8b48:	e2832001 	add	r2, r3, #1
    8b4c:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8b50:	e5d33000 	ldrb	r3, [r3]
    8b54:	e50b3010 	str	r3, [fp, #-16]
    8b58:	e51b3010 	ldr	r3, [fp, #-16]
    8b5c:	e3530000 	cmp	r3, #0
    8b60:	0a000007 	beq	8b84 <_Z4atofPKc+0xe8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:107 (discriminator 1)
    8b64:	e51b3010 	ldr	r3, [fp, #-16]
    8b68:	e353002f 	cmp	r3, #47	; 0x2f
    8b6c:	da000004 	ble	8b84 <_Z4atofPKc+0xe8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:107 (discriminator 3)
    8b70:	e51b3010 	ldr	r3, [fp, #-16]
    8b74:	e3530039 	cmp	r3, #57	; 0x39
    8b78:	ca000001 	bgt	8b84 <_Z4atofPKc+0xe8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:107 (discriminator 5)
    8b7c:	e3a03001 	mov	r3, #1
    8b80:	ea000000 	b	8b88 <_Z4atofPKc+0xec>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:107 (discriminator 6)
    8b84:	e3a03000 	mov	r3, #0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:107 (discriminator 8)
    8b88:	e3530000 	cmp	r3, #0
    8b8c:	0a00000e 	beq	8bcc <_Z4atofPKc+0x130>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:108
      a = a*10.0 + (c - '0');
    8b90:	ed5b7a02 	vldr	s15, [fp, #-8]
    8b94:	eeb77ae7 	vcvt.f64.f32	d7, s15
    8b98:	ed9f6b68 	vldr	d6, [pc, #416]	; 8d40 <_Z4atofPKc+0x2a4>
    8b9c:	ee276b06 	vmul.f64	d6, d7, d6
    8ba0:	e51b3010 	ldr	r3, [fp, #-16]
    8ba4:	e2433030 	sub	r3, r3, #48	; 0x30
    8ba8:	ee073a90 	vmov	s15, r3
    8bac:	eeb87be7 	vcvt.f64.s32	d7, s15
    8bb0:	ee367b07 	vadd.f64	d7, d6, d7
    8bb4:	eef77bc7 	vcvt.f32.f64	s15, d7
    8bb8:	ed4b7a02 	vstr	s15, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:109
      e = e-1;
    8bbc:	e51b300c 	ldr	r3, [fp, #-12]
    8bc0:	e2433001 	sub	r3, r3, #1
    8bc4:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:107
    while ((c = *s++) != '\0' && isdigit(c)) {
    8bc8:	eaffffdd 	b	8b44 <_Z4atofPKc+0xa8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:112
    }
  }
  if (c == 'e' || c == 'E') {
    8bcc:	e51b3010 	ldr	r3, [fp, #-16]
    8bd0:	e3530065 	cmp	r3, #101	; 0x65
    8bd4:	0a000002 	beq	8be4 <_Z4atofPKc+0x148>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:112 (discriminator 1)
    8bd8:	e51b3010 	ldr	r3, [fp, #-16]
    8bdc:	e3530045 	cmp	r3, #69	; 0x45
    8be0:	1a000037 	bne	8cc4 <_Z4atofPKc+0x228>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:113
    int sign = 1;
    8be4:	e3a03001 	mov	r3, #1
    8be8:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:114
    int i = 0;
    8bec:	e3a03000 	mov	r3, #0
    8bf0:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:115
    c = *s++;
    8bf4:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8bf8:	e2832001 	add	r2, r3, #1
    8bfc:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8c00:	e5d33000 	ldrb	r3, [r3]
    8c04:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:116
    if (c == '+')
    8c08:	e51b3010 	ldr	r3, [fp, #-16]
    8c0c:	e353002b 	cmp	r3, #43	; 0x2b
    8c10:	1a000005 	bne	8c2c <_Z4atofPKc+0x190>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:117
      c = *s++;
    8c14:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8c18:	e2832001 	add	r2, r3, #1
    8c1c:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8c20:	e5d33000 	ldrb	r3, [r3]
    8c24:	e50b3010 	str	r3, [fp, #-16]
    8c28:	ea000009 	b	8c54 <_Z4atofPKc+0x1b8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:118
    else if (c == '-') {
    8c2c:	e51b3010 	ldr	r3, [fp, #-16]
    8c30:	e353002d 	cmp	r3, #45	; 0x2d
    8c34:	1a000006 	bne	8c54 <_Z4atofPKc+0x1b8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:119
      c = *s++;
    8c38:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8c3c:	e2832001 	add	r2, r3, #1
    8c40:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8c44:	e5d33000 	ldrb	r3, [r3]
    8c48:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:120
      sign = -1;
    8c4c:	e3e03000 	mvn	r3, #0
    8c50:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:122
    }
    while (isdigit(c)) {
    8c54:	e51b3010 	ldr	r3, [fp, #-16]
    8c58:	e353002f 	cmp	r3, #47	; 0x2f
    8c5c:	da000012 	ble	8cac <_Z4atofPKc+0x210>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:122 (discriminator 1)
    8c60:	e51b3010 	ldr	r3, [fp, #-16]
    8c64:	e3530039 	cmp	r3, #57	; 0x39
    8c68:	ca00000f 	bgt	8cac <_Z4atofPKc+0x210>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:123
      i = i*10 + (c - '0');
    8c6c:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8c70:	e1a03002 	mov	r3, r2
    8c74:	e1a03103 	lsl	r3, r3, #2
    8c78:	e0833002 	add	r3, r3, r2
    8c7c:	e1a03083 	lsl	r3, r3, #1
    8c80:	e1a02003 	mov	r2, r3
    8c84:	e51b3010 	ldr	r3, [fp, #-16]
    8c88:	e2433030 	sub	r3, r3, #48	; 0x30
    8c8c:	e0823003 	add	r3, r2, r3
    8c90:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:124
      c = *s++;
    8c94:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8c98:	e2832001 	add	r2, r3, #1
    8c9c:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8ca0:	e5d33000 	ldrb	r3, [r3]
    8ca4:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:122
    while (isdigit(c)) {
    8ca8:	eaffffe9 	b	8c54 <_Z4atofPKc+0x1b8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:126
    }
    e += i*sign;
    8cac:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8cb0:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8cb4:	e0030392 	mul	r3, r2, r3
    8cb8:	e51b200c 	ldr	r2, [fp, #-12]
    8cbc:	e0823003 	add	r3, r2, r3
    8cc0:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:128
  }
  while (e > 0) {
    8cc4:	e51b300c 	ldr	r3, [fp, #-12]
    8cc8:	e3530000 	cmp	r3, #0
    8ccc:	da000007 	ble	8cf0 <_Z4atofPKc+0x254>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:129
    a *= 10.0;
    8cd0:	ed5b7a02 	vldr	s15, [fp, #-8]
    8cd4:	ed9f7a1d 	vldr	s14, [pc, #116]	; 8d50 <_Z4atofPKc+0x2b4>
    8cd8:	ee677a87 	vmul.f32	s15, s15, s14
    8cdc:	ed4b7a02 	vstr	s15, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:130
    e--;
    8ce0:	e51b300c 	ldr	r3, [fp, #-12]
    8ce4:	e2433001 	sub	r3, r3, #1
    8ce8:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:128
  while (e > 0) {
    8cec:	eafffff4 	b	8cc4 <_Z4atofPKc+0x228>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:132
  }
  while (e < 0) {
    8cf0:	e51b300c 	ldr	r3, [fp, #-12]
    8cf4:	e3530000 	cmp	r3, #0
    8cf8:	aa000009 	bge	8d24 <_Z4atofPKc+0x288>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:133
    a *= 0.1;
    8cfc:	ed5b7a02 	vldr	s15, [fp, #-8]
    8d00:	eeb77ae7 	vcvt.f64.f32	d7, s15
    8d04:	ed9f6b0f 	vldr	d6, [pc, #60]	; 8d48 <_Z4atofPKc+0x2ac>
    8d08:	ee277b06 	vmul.f64	d7, d7, d6
    8d0c:	eef77bc7 	vcvt.f32.f64	s15, d7
    8d10:	ed4b7a02 	vstr	s15, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:134
    e++;
    8d14:	e51b300c 	ldr	r3, [fp, #-12]
    8d18:	e2833001 	add	r3, r3, #1
    8d1c:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:132
  while (e < 0) {
    8d20:	eafffff2 	b	8cf0 <_Z4atofPKc+0x254>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:136
  }
  return a;
    8d24:	e51b3008 	ldr	r3, [fp, #-8]
    8d28:	ee073a90 	vmov	s15, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:137
}
    8d2c:	eeb00a67 	vmov.f32	s0, s15
    8d30:	e28bd000 	add	sp, fp, #0
    8d34:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8d38:	e12fff1e 	bx	lr
    8d3c:	e320f000 	nop	{0}
    8d40:	00000000 	andeq	r0, r0, r0
    8d44:	40240000 	eormi	r0, r4, r0
    8d48:	9999999a 	ldmibls	r9, {r1, r3, r4, r7, r8, fp, ip, pc}
    8d4c:	3fb99999 	svccc	0x00b99999
    8d50:	41200000 			; <UNDEFINED> instruction: 0x41200000

00008d54 <_Z4ftoaPcf>:
_Z4ftoaPcf():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:139

void ftoa(char *buffer, float value) {  
    8d54:	e92d4800 	push	{fp, lr}
    8d58:	e28db004 	add	fp, sp, #4
    8d5c:	e24dd020 	sub	sp, sp, #32
    8d60:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
    8d64:	ed0b0a09 	vstr	s0, [fp, #-36]	; 0xffffffdc
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:148
     * The largest value we expect is an IEEE 754 double precision real, with maximum magnitude of approximately
     * e+308. The C standard requires an implementation to allow a single conversion to produce up to 512 
     * characters, so that's what we really expect as the buffer size.     
     */

    int exponent = 0;
    8d68:	e3a03000 	mov	r3, #0
    8d6c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:149
    int places = 0;
    8d70:	e3a03000 	mov	r3, #0
    8d74:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:150
    const int width = 6;
    8d78:	e3a03006 	mov	r3, #6
    8d7c:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:152

    if (value == 0.0) {
    8d80:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    8d84:	eef57a40 	vcmp.f32	s15, #0.0
    8d88:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8d8c:	1a000007 	bne	8db0 <_Z4ftoaPcf+0x5c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:153
        buffer[0] = '0';
    8d90:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8d94:	e3a02030 	mov	r2, #48	; 0x30
    8d98:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:154
        buffer[1] = '\0';
    8d9c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8da0:	e2833001 	add	r3, r3, #1
    8da4:	e3a02000 	mov	r2, #0
    8da8:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:155
        return;
    8dac:	ea000071 	b	8f78 <_Z4ftoaPcf+0x224>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:158
    } 

    if (value < 0.0) {
    8db0:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    8db4:	eef57ac0 	vcmpe.f32	s15, #0.0
    8db8:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8dbc:	5a000007 	bpl	8de0 <_Z4ftoaPcf+0x8c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:159
        *buffer++ = '-';
    8dc0:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8dc4:	e2832001 	add	r2, r3, #1
    8dc8:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8dcc:	e3a0202d 	mov	r2, #45	; 0x2d
    8dd0:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:160
        value = -value;
    8dd4:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    8dd8:	eef17a67 	vneg.f32	s15, s15
    8ddc:	ed4b7a09 	vstr	s15, [fp, #-36]	; 0xffffffdc
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:163
    }

    exponent = normalize(&value);
    8de0:	e24b3024 	sub	r3, fp, #36	; 0x24
    8de4:	e1a00003 	mov	r0, r3
    8de8:	ebfffec3 	bl	88fc <_Z9normalizePf>
    8dec:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:165

    while (exponent > 0) {
    8df0:	e51b3008 	ldr	r3, [fp, #-8]
    8df4:	e3530000 	cmp	r3, #0
    8df8:	da00001c 	ble	8e70 <_Z4ftoaPcf+0x11c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:166
        int digit = value * 10;
    8dfc:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    8e00:	ed9f7a60 	vldr	s14, [pc, #384]	; 8f88 <_Z4ftoaPcf+0x234>
    8e04:	ee677a87 	vmul.f32	s15, s15, s14
    8e08:	eefd7ae7 	vcvt.s32.f32	s15, s15
    8e0c:	ee173a90 	vmov	r3, s15
    8e10:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:167
        *buffer++ = digit + '0';
    8e14:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8e18:	e6ef2073 	uxtb	r2, r3
    8e1c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8e20:	e2831001 	add	r1, r3, #1
    8e24:	e50b1020 	str	r1, [fp, #-32]	; 0xffffffe0
    8e28:	e2822030 	add	r2, r2, #48	; 0x30
    8e2c:	e6ef2072 	uxtb	r2, r2
    8e30:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:168
        value = value * 10 - digit;
    8e34:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    8e38:	ed9f7a52 	vldr	s14, [pc, #328]	; 8f88 <_Z4ftoaPcf+0x234>
    8e3c:	ee277a87 	vmul.f32	s14, s15, s14
    8e40:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8e44:	ee073a90 	vmov	s15, r3
    8e48:	eef87ae7 	vcvt.f32.s32	s15, s15
    8e4c:	ee777a67 	vsub.f32	s15, s14, s15
    8e50:	ed4b7a09 	vstr	s15, [fp, #-36]	; 0xffffffdc
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:169
        ++places;
    8e54:	e51b300c 	ldr	r3, [fp, #-12]
    8e58:	e2833001 	add	r3, r3, #1
    8e5c:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:170
        --exponent;
    8e60:	e51b3008 	ldr	r3, [fp, #-8]
    8e64:	e2433001 	sub	r3, r3, #1
    8e68:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:165
    while (exponent > 0) {
    8e6c:	eaffffdf 	b	8df0 <_Z4ftoaPcf+0x9c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:173
    }

    if (places == 0)
    8e70:	e51b300c 	ldr	r3, [fp, #-12]
    8e74:	e3530000 	cmp	r3, #0
    8e78:	1a000004 	bne	8e90 <_Z4ftoaPcf+0x13c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:174
        *buffer++ = '0';
    8e7c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8e80:	e2832001 	add	r2, r3, #1
    8e84:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8e88:	e3a02030 	mov	r2, #48	; 0x30
    8e8c:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:176

    *buffer++ = '.';
    8e90:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8e94:	e2832001 	add	r2, r3, #1
    8e98:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8e9c:	e3a0202e 	mov	r2, #46	; 0x2e
    8ea0:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:178

    while (exponent < 0 && places < width) {
    8ea4:	e51b3008 	ldr	r3, [fp, #-8]
    8ea8:	e3530000 	cmp	r3, #0
    8eac:	aa00000e 	bge	8eec <_Z4ftoaPcf+0x198>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:178 (discriminator 1)
    8eb0:	e51b300c 	ldr	r3, [fp, #-12]
    8eb4:	e3530005 	cmp	r3, #5
    8eb8:	ca00000b 	bgt	8eec <_Z4ftoaPcf+0x198>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:179
        *buffer++ = '0';
    8ebc:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8ec0:	e2832001 	add	r2, r3, #1
    8ec4:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8ec8:	e3a02030 	mov	r2, #48	; 0x30
    8ecc:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:180
        --exponent;
    8ed0:	e51b3008 	ldr	r3, [fp, #-8]
    8ed4:	e2433001 	sub	r3, r3, #1
    8ed8:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:181
        ++places;
    8edc:	e51b300c 	ldr	r3, [fp, #-12]
    8ee0:	e2833001 	add	r3, r3, #1
    8ee4:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:178
    while (exponent < 0 && places < width) {
    8ee8:	eaffffed 	b	8ea4 <_Z4ftoaPcf+0x150>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:184
    }

    while (places < width) {
    8eec:	e51b300c 	ldr	r3, [fp, #-12]
    8ef0:	e3530005 	cmp	r3, #5
    8ef4:	ca00001c 	bgt	8f6c <_Z4ftoaPcf+0x218>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:185
        int digit = value * 10.0;
    8ef8:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    8efc:	eeb77ae7 	vcvt.f64.f32	d7, s15
    8f00:	ed9f6b1e 	vldr	d6, [pc, #120]	; 8f80 <_Z4ftoaPcf+0x22c>
    8f04:	ee277b06 	vmul.f64	d7, d7, d6
    8f08:	eefd7bc7 	vcvt.s32.f64	s15, d7
    8f0c:	ee173a90 	vmov	r3, s15
    8f10:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:186
        *buffer++ = digit + '0';
    8f14:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8f18:	e6ef2073 	uxtb	r2, r3
    8f1c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8f20:	e2831001 	add	r1, r3, #1
    8f24:	e50b1020 	str	r1, [fp, #-32]	; 0xffffffe0
    8f28:	e2822030 	add	r2, r2, #48	; 0x30
    8f2c:	e6ef2072 	uxtb	r2, r2
    8f30:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:187
        value = value * 10.0 - digit;
    8f34:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    8f38:	eeb77ae7 	vcvt.f64.f32	d7, s15
    8f3c:	ed9f6b0f 	vldr	d6, [pc, #60]	; 8f80 <_Z4ftoaPcf+0x22c>
    8f40:	ee276b06 	vmul.f64	d6, d7, d6
    8f44:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8f48:	ee073a90 	vmov	s15, r3
    8f4c:	eeb87be7 	vcvt.f64.s32	d7, s15
    8f50:	ee367b47 	vsub.f64	d7, d6, d7
    8f54:	eef77bc7 	vcvt.f32.f64	s15, d7
    8f58:	ed4b7a09 	vstr	s15, [fp, #-36]	; 0xffffffdc
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:188
        ++places;
    8f5c:	e51b300c 	ldr	r3, [fp, #-12]
    8f60:	e2833001 	add	r3, r3, #1
    8f64:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:184
    while (places < width) {
    8f68:	eaffffdf 	b	8eec <_Z4ftoaPcf+0x198>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:190
    }
    *buffer = '\0';
    8f6c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8f70:	e3a02000 	mov	r2, #0
    8f74:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:191
}
    8f78:	e24bd004 	sub	sp, fp, #4
    8f7c:	e8bd8800 	pop	{fp, pc}
    8f80:	00000000 	andeq	r0, r0, r0
    8f84:	40240000 	eormi	r0, r4, r0
    8f88:	41200000 			; <UNDEFINED> instruction: 0x41200000

00008f8c <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:194

char* strncpy(char* dest, const char *src, int num)
{
    8f8c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8f90:	e28db000 	add	fp, sp, #0
    8f94:	e24dd01c 	sub	sp, sp, #28
    8f98:	e50b0010 	str	r0, [fp, #-16]
    8f9c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8fa0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:197
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
    8fa4:	e3a03000 	mov	r3, #0
    8fa8:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:197 (discriminator 4)
    8fac:	e51b2008 	ldr	r2, [fp, #-8]
    8fb0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8fb4:	e1520003 	cmp	r2, r3
    8fb8:	aa000011 	bge	9004 <_Z7strncpyPcPKci+0x78>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:197 (discriminator 2)
    8fbc:	e51b3008 	ldr	r3, [fp, #-8]
    8fc0:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8fc4:	e0823003 	add	r3, r2, r3
    8fc8:	e5d33000 	ldrb	r3, [r3]
    8fcc:	e3530000 	cmp	r3, #0
    8fd0:	0a00000b 	beq	9004 <_Z7strncpyPcPKci+0x78>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:198 (discriminator 3)
		dest[i] = src[i];
    8fd4:	e51b3008 	ldr	r3, [fp, #-8]
    8fd8:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8fdc:	e0822003 	add	r2, r2, r3
    8fe0:	e51b3008 	ldr	r3, [fp, #-8]
    8fe4:	e51b1010 	ldr	r1, [fp, #-16]
    8fe8:	e0813003 	add	r3, r1, r3
    8fec:	e5d22000 	ldrb	r2, [r2]
    8ff0:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:197 (discriminator 3)
	for (i = 0; i < num && src[i] != '\0'; i++)
    8ff4:	e51b3008 	ldr	r3, [fp, #-8]
    8ff8:	e2833001 	add	r3, r3, #1
    8ffc:	e50b3008 	str	r3, [fp, #-8]
    9000:	eaffffe9 	b	8fac <_Z7strncpyPcPKci+0x20>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:199 (discriminator 2)
	for (; i < num; i++)
    9004:	e51b2008 	ldr	r2, [fp, #-8]
    9008:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    900c:	e1520003 	cmp	r2, r3
    9010:	aa000008 	bge	9038 <_Z7strncpyPcPKci+0xac>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:200 (discriminator 1)
		dest[i] = '\0';
    9014:	e51b3008 	ldr	r3, [fp, #-8]
    9018:	e51b2010 	ldr	r2, [fp, #-16]
    901c:	e0823003 	add	r3, r2, r3
    9020:	e3a02000 	mov	r2, #0
    9024:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:199 (discriminator 1)
	for (; i < num; i++)
    9028:	e51b3008 	ldr	r3, [fp, #-8]
    902c:	e2833001 	add	r3, r3, #1
    9030:	e50b3008 	str	r3, [fp, #-8]
    9034:	eafffff2 	b	9004 <_Z7strncpyPcPKci+0x78>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:202

   return dest;
    9038:	e51b3010 	ldr	r3, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:203
}
    903c:	e1a00003 	mov	r0, r3
    9040:	e28bd000 	add	sp, fp, #0
    9044:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9048:	e12fff1e 	bx	lr

0000904c <_Z6strcatPcPKc>:
_Z6strcatPcPKc():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:206

char* strcat(char *dest, const char *src)
{
    904c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9050:	e28db000 	add	fp, sp, #0
    9054:	e24dd014 	sub	sp, sp, #20
    9058:	e50b0010 	str	r0, [fp, #-16]
    905c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:209
    int i,j;

    for (i = 0; dest[i] != '\0'; i++)
    9060:	e3a03000 	mov	r3, #0
    9064:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:209 (discriminator 3)
    9068:	e51b3008 	ldr	r3, [fp, #-8]
    906c:	e51b2010 	ldr	r2, [fp, #-16]
    9070:	e0823003 	add	r3, r2, r3
    9074:	e5d33000 	ldrb	r3, [r3]
    9078:	e3530000 	cmp	r3, #0
    907c:	0a000003 	beq	9090 <_Z6strcatPcPKc+0x44>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:209 (discriminator 2)
    9080:	e51b3008 	ldr	r3, [fp, #-8]
    9084:	e2833001 	add	r3, r3, #1
    9088:	e50b3008 	str	r3, [fp, #-8]
    908c:	eafffff5 	b	9068 <_Z6strcatPcPKc+0x1c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:211
        ;
    for (j = 0; src[j] != '\0'; j++)
    9090:	e3a03000 	mov	r3, #0
    9094:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:211 (discriminator 3)
    9098:	e51b300c 	ldr	r3, [fp, #-12]
    909c:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    90a0:	e0823003 	add	r3, r2, r3
    90a4:	e5d33000 	ldrb	r3, [r3]
    90a8:	e3530000 	cmp	r3, #0
    90ac:	0a00000e 	beq	90ec <_Z6strcatPcPKc+0xa0>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:212 (discriminator 2)
        dest[i+j] = src[j];
    90b0:	e51b300c 	ldr	r3, [fp, #-12]
    90b4:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    90b8:	e0822003 	add	r2, r2, r3
    90bc:	e51b1008 	ldr	r1, [fp, #-8]
    90c0:	e51b300c 	ldr	r3, [fp, #-12]
    90c4:	e0813003 	add	r3, r1, r3
    90c8:	e1a01003 	mov	r1, r3
    90cc:	e51b3010 	ldr	r3, [fp, #-16]
    90d0:	e0833001 	add	r3, r3, r1
    90d4:	e5d22000 	ldrb	r2, [r2]
    90d8:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:211 (discriminator 2)
    for (j = 0; src[j] != '\0'; j++)
    90dc:	e51b300c 	ldr	r3, [fp, #-12]
    90e0:	e2833001 	add	r3, r3, #1
    90e4:	e50b300c 	str	r3, [fp, #-12]
    90e8:	eaffffea 	b	9098 <_Z6strcatPcPKc+0x4c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:214

    dest[i+j] = '\0';
    90ec:	e51b2008 	ldr	r2, [fp, #-8]
    90f0:	e51b300c 	ldr	r3, [fp, #-12]
    90f4:	e0823003 	add	r3, r2, r3
    90f8:	e1a02003 	mov	r2, r3
    90fc:	e51b3010 	ldr	r3, [fp, #-16]
    9100:	e0833002 	add	r3, r3, r2
    9104:	e3a02000 	mov	r2, #0
    9108:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:216
	
    return dest;
    910c:	e51b3010 	ldr	r3, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:217
}
    9110:	e1a00003 	mov	r0, r3
    9114:	e28bd000 	add	sp, fp, #0
    9118:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    911c:	e12fff1e 	bx	lr

00009120 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:220

int strncmp(const char *s1, const char *s2, int num)
{
    9120:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9124:	e28db000 	add	fp, sp, #0
    9128:	e24dd01c 	sub	sp, sp, #28
    912c:	e50b0010 	str	r0, [fp, #-16]
    9130:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    9134:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:222
	unsigned char u1, u2;
  	while (num-- > 0)
    9138:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    913c:	e2432001 	sub	r2, r3, #1
    9140:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    9144:	e3530000 	cmp	r3, #0
    9148:	c3a03001 	movgt	r3, #1
    914c:	d3a03000 	movle	r3, #0
    9150:	e6ef3073 	uxtb	r3, r3
    9154:	e3530000 	cmp	r3, #0
    9158:	0a000016 	beq	91b8 <_Z7strncmpPKcS0_i+0x98>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:224
    {
      	u1 = (unsigned char) *s1++;
    915c:	e51b3010 	ldr	r3, [fp, #-16]
    9160:	e2832001 	add	r2, r3, #1
    9164:	e50b2010 	str	r2, [fp, #-16]
    9168:	e5d33000 	ldrb	r3, [r3]
    916c:	e54b3005 	strb	r3, [fp, #-5]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:225
     	u2 = (unsigned char) *s2++;
    9170:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9174:	e2832001 	add	r2, r3, #1
    9178:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    917c:	e5d33000 	ldrb	r3, [r3]
    9180:	e54b3006 	strb	r3, [fp, #-6]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:226
      	if (u1 != u2)
    9184:	e55b2005 	ldrb	r2, [fp, #-5]
    9188:	e55b3006 	ldrb	r3, [fp, #-6]
    918c:	e1520003 	cmp	r2, r3
    9190:	0a000003 	beq	91a4 <_Z7strncmpPKcS0_i+0x84>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:227
        	return u1 - u2;
    9194:	e55b2005 	ldrb	r2, [fp, #-5]
    9198:	e55b3006 	ldrb	r3, [fp, #-6]
    919c:	e0423003 	sub	r3, r2, r3
    91a0:	ea000005 	b	91bc <_Z7strncmpPKcS0_i+0x9c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:228
      	if (u1 == '\0')
    91a4:	e55b3005 	ldrb	r3, [fp, #-5]
    91a8:	e3530000 	cmp	r3, #0
    91ac:	1affffe1 	bne	9138 <_Z7strncmpPKcS0_i+0x18>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:229
        	return 0;
    91b0:	e3a03000 	mov	r3, #0
    91b4:	ea000000 	b	91bc <_Z7strncmpPKcS0_i+0x9c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:232
    }

  	return 0;
    91b8:	e3a03000 	mov	r3, #0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:233
}
    91bc:	e1a00003 	mov	r0, r3
    91c0:	e28bd000 	add	sp, fp, #0
    91c4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    91c8:	e12fff1e 	bx	lr

000091cc <_Z6strlenPKc>:
_Z6strlenPKc():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:236

int strlen(const char* s)
{
    91cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    91d0:	e28db000 	add	fp, sp, #0
    91d4:	e24dd014 	sub	sp, sp, #20
    91d8:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:237
	int i = 0;
    91dc:	e3a03000 	mov	r3, #0
    91e0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:239

	while (s[i] != '\0')
    91e4:	e51b3008 	ldr	r3, [fp, #-8]
    91e8:	e51b2010 	ldr	r2, [fp, #-16]
    91ec:	e0823003 	add	r3, r2, r3
    91f0:	e5d33000 	ldrb	r3, [r3]
    91f4:	e3530000 	cmp	r3, #0
    91f8:	0a000003 	beq	920c <_Z6strlenPKc+0x40>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:240
		i++;
    91fc:	e51b3008 	ldr	r3, [fp, #-8]
    9200:	e2833001 	add	r3, r3, #1
    9204:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:239
	while (s[i] != '\0')
    9208:	eafffff5 	b	91e4 <_Z6strlenPKc+0x18>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:242

	return i;
    920c:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:243
}
    9210:	e1a00003 	mov	r0, r3
    9214:	e28bd000 	add	sp, fp, #0
    9218:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    921c:	e12fff1e 	bx	lr

00009220 <_Z5bzeroPvi>:
_Z5bzeroPvi():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:246

void bzero(void* memory, int length)
{
    9220:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9224:	e28db000 	add	fp, sp, #0
    9228:	e24dd014 	sub	sp, sp, #20
    922c:	e50b0010 	str	r0, [fp, #-16]
    9230:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:247
	char* mem = reinterpret_cast<char*>(memory);
    9234:	e51b3010 	ldr	r3, [fp, #-16]
    9238:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:249

	for (int i = 0; i < length; i++)
    923c:	e3a03000 	mov	r3, #0
    9240:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:249 (discriminator 3)
    9244:	e51b2008 	ldr	r2, [fp, #-8]
    9248:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    924c:	e1520003 	cmp	r2, r3
    9250:	aa000008 	bge	9278 <_Z5bzeroPvi+0x58>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:250 (discriminator 2)
		mem[i] = 0;
    9254:	e51b3008 	ldr	r3, [fp, #-8]
    9258:	e51b200c 	ldr	r2, [fp, #-12]
    925c:	e0823003 	add	r3, r2, r3
    9260:	e3a02000 	mov	r2, #0
    9264:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:249 (discriminator 2)
	for (int i = 0; i < length; i++)
    9268:	e51b3008 	ldr	r3, [fp, #-8]
    926c:	e2833001 	add	r3, r3, #1
    9270:	e50b3008 	str	r3, [fp, #-8]
    9274:	eafffff2 	b	9244 <_Z5bzeroPvi+0x24>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:251
}
    9278:	e320f000 	nop	{0}
    927c:	e28bd000 	add	sp, fp, #0
    9280:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9284:	e12fff1e 	bx	lr

00009288 <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:254

void memcpy(const void* src, void* dst, int num)
{
    9288:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    928c:	e28db000 	add	fp, sp, #0
    9290:	e24dd024 	sub	sp, sp, #36	; 0x24
    9294:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    9298:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    929c:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:255
	const char* memsrc = reinterpret_cast<const char*>(src);
    92a0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    92a4:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:256
	char* memdst = reinterpret_cast<char*>(dst);
    92a8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    92ac:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:258

	for (int i = 0; i < num; i++)
    92b0:	e3a03000 	mov	r3, #0
    92b4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:258 (discriminator 3)
    92b8:	e51b2008 	ldr	r2, [fp, #-8]
    92bc:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    92c0:	e1520003 	cmp	r2, r3
    92c4:	aa00000b 	bge	92f8 <_Z6memcpyPKvPvi+0x70>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:259 (discriminator 2)
		memdst[i] = memsrc[i];
    92c8:	e51b3008 	ldr	r3, [fp, #-8]
    92cc:	e51b200c 	ldr	r2, [fp, #-12]
    92d0:	e0822003 	add	r2, r2, r3
    92d4:	e51b3008 	ldr	r3, [fp, #-8]
    92d8:	e51b1010 	ldr	r1, [fp, #-16]
    92dc:	e0813003 	add	r3, r1, r3
    92e0:	e5d22000 	ldrb	r2, [r2]
    92e4:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:258 (discriminator 2)
	for (int i = 0; i < num; i++)
    92e8:	e51b3008 	ldr	r3, [fp, #-8]
    92ec:	e2833001 	add	r3, r3, #1
    92f0:	e50b3008 	str	r3, [fp, #-8]
    92f4:	eaffffef 	b	92b8 <_Z6memcpyPKvPvi+0x30>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/Odevzdani/src/stdlib/src/stdstring.cpp:260
}
    92f8:	e320f000 	nop	{0}
    92fc:	e28bd000 	add	sp, fp, #0
    9300:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9304:	e12fff1e 	bx	lr

00009308 <__udivsi3>:
__udivsi3():
    9308:	e2512001 	subs	r2, r1, #1
    930c:	012fff1e 	bxeq	lr
    9310:	3a000023 	bcc	93a4 <__udivsi3+0x9c>
    9314:	e1500001 	cmp	r0, r1
    9318:	9a00001a 	bls	9388 <__udivsi3+0x80>
    931c:	e1110002 	tst	r1, r2
    9320:	0a00001b 	beq	9394 <__udivsi3+0x8c>
    9324:	e16f3f11 	clz	r3, r1
    9328:	e16f2f10 	clz	r2, r0
    932c:	e0432002 	sub	r2, r3, r2
    9330:	e3a03001 	mov	r3, #1
    9334:	e1a01211 	lsl	r1, r1, r2
    9338:	e1a03213 	lsl	r3, r3, r2
    933c:	e3a02000 	mov	r2, #0
    9340:	e1500001 	cmp	r0, r1
    9344:	20400001 	subcs	r0, r0, r1
    9348:	21822003 	orrcs	r2, r2, r3
    934c:	e15000a1 	cmp	r0, r1, lsr #1
    9350:	204000a1 	subcs	r0, r0, r1, lsr #1
    9354:	218220a3 	orrcs	r2, r2, r3, lsr #1
    9358:	e1500121 	cmp	r0, r1, lsr #2
    935c:	20400121 	subcs	r0, r0, r1, lsr #2
    9360:	21822123 	orrcs	r2, r2, r3, lsr #2
    9364:	e15001a1 	cmp	r0, r1, lsr #3
    9368:	204001a1 	subcs	r0, r0, r1, lsr #3
    936c:	218221a3 	orrcs	r2, r2, r3, lsr #3
    9370:	e3500000 	cmp	r0, #0
    9374:	11b03223 	lsrsne	r3, r3, #4
    9378:	11a01221 	lsrne	r1, r1, #4
    937c:	1affffef 	bne	9340 <__udivsi3+0x38>
    9380:	e1a00002 	mov	r0, r2
    9384:	e12fff1e 	bx	lr
    9388:	03a00001 	moveq	r0, #1
    938c:	13a00000 	movne	r0, #0
    9390:	e12fff1e 	bx	lr
    9394:	e16f2f11 	clz	r2, r1
    9398:	e262201f 	rsb	r2, r2, #31
    939c:	e1a00230 	lsr	r0, r0, r2
    93a0:	e12fff1e 	bx	lr
    93a4:	e3500000 	cmp	r0, #0
    93a8:	13e00000 	mvnne	r0, #0
    93ac:	ea000007 	b	93d0 <__aeabi_idiv0>

000093b0 <__aeabi_uidivmod>:
__aeabi_uidivmod():
    93b0:	e3510000 	cmp	r1, #0
    93b4:	0afffffa 	beq	93a4 <__udivsi3+0x9c>
    93b8:	e92d4003 	push	{r0, r1, lr}
    93bc:	ebffffd1 	bl	9308 <__udivsi3>
    93c0:	e8bd4006 	pop	{r1, r2, lr}
    93c4:	e0030092 	mul	r3, r2, r0
    93c8:	e0411003 	sub	r1, r1, r3
    93cc:	e12fff1e 	bx	lr

000093d0 <__aeabi_idiv0>:
__aeabi_ldiv0():
    93d0:	e12fff1e 	bx	lr

Disassembly of section .rodata:

000093d4 <_ZL13Lock_Unlocked>:
    93d4:	00000000 	andeq	r0, r0, r0

000093d8 <_ZL11Lock_Locked>:
    93d8:	00000001 	andeq	r0, r0, r1

000093dc <_ZL21MaxFSDriverNameLength>:
    93dc:	00000010 	andeq	r0, r0, r0, lsl r0

000093e0 <_ZL17MaxFilenameLength>:
    93e0:	00000010 	andeq	r0, r0, r0, lsl r0

000093e4 <_ZL13MaxPathLength>:
    93e4:	00000080 	andeq	r0, r0, r0, lsl #1

000093e8 <_ZL18NoFilesystemDriver>:
    93e8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

000093ec <_ZL9NotifyAll>:
    93ec:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

000093f0 <_ZL24Max_Process_Opened_Files>:
    93f0:	00000010 	andeq	r0, r0, r0, lsl r0

000093f4 <_ZL10Indefinite>:
    93f4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

000093f8 <_ZL18Deadline_Unchanged>:
    93f8:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

000093fc <_ZL14Invalid_Handle>:
    93fc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009400 <_ZL13Lock_Unlocked>:
    9400:	00000000 	andeq	r0, r0, r0

00009404 <_ZL11Lock_Locked>:
    9404:	00000001 	andeq	r0, r0, r1

00009408 <_ZL21MaxFSDriverNameLength>:
    9408:	00000010 	andeq	r0, r0, r0, lsl r0

0000940c <_ZL17MaxFilenameLength>:
    940c:	00000010 	andeq	r0, r0, r0, lsl r0

00009410 <_ZL13MaxPathLength>:
    9410:	00000080 	andeq	r0, r0, r0, lsl #1

00009414 <_ZL18NoFilesystemDriver>:
    9414:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009418 <_ZL9NotifyAll>:
    9418:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000941c <_ZL24Max_Process_Opened_Files>:
    941c:	00000010 	andeq	r0, r0, r0, lsl r0

00009420 <_ZL10Indefinite>:
    9420:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009424 <_ZL18Deadline_Unchanged>:
    9424:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009428 <_ZL14Invalid_Handle>:
    9428:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000942c <_ZL16Pipe_File_Prefix>:
    942c:	3a535953 	bcc	14df980 <__bss_end+0x14d6524>
    9430:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    9434:	0000002f 	andeq	r0, r0, pc, lsr #32

00009438 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    9438:	33323130 	teqcc	r2, #48, 2
    943c:	37363534 			; <UNDEFINED> instruction: 0x37363534
    9440:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    9444:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .bss:

0000944c <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x16843d0>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x38fc8>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3cbdc>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c78c8>
   4:	6c412820 	mcrrvs	8, 2, r2, r1, cr0
   8:	656e6970 	strbvs	r6, [lr, #-2416]!	; 0xfffff690
   c:	6e694c20 	cdpvs	12, 6, cr4, cr9, cr0, {1}
  10:	20297875 	eorcs	r7, r9, r5, ror r8
  14:	332e3031 			; <UNDEFINED> instruction: 0x332e3031
  18:	Address 0x0000000000000018 is out of bounds.


Disassembly of section .debug_line:

00000000 <.debug_line>:
   0:	0000007e 	andeq	r0, r0, lr, ror r0
   4:	00680003 	rsbeq	r0, r8, r3
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
  4c:	644f2f53 	strbvs	r2, [pc], #-3923	; 54 <_start-0x7fac>
  50:	647a7665 	ldrbtvs	r7, [sl], #-1637	; 0xfffff99b
  54:	2f696e61 	svccs	0x00696e61
  58:	2f637273 	svccs	0x00637273
  5c:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
  60:	63617073 	cmnvs	r1, #115	; 0x73
  64:	63000065 	movwvs	r0, #101	; 0x65
  68:	2e307472 	mrccs	4, 1, r7, cr0, cr2, {3}
  6c:	00010073 	andeq	r0, r1, r3, ror r0
  70:	05000000 	streq	r0, [r0, #-0]
  74:	00800002 	addeq	r0, r0, r2
  78:	01090300 	mrseq	r0, (UNDEF: 57)
  7c:	00020231 	andeq	r0, r2, r1, lsr r2
  80:	00ad0101 	adceq	r0, sp, r1, lsl #2
  84:	00030000 	andeq	r0, r3, r0
  88:	00000068 	andeq	r0, r0, r8, rrx
  8c:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
  90:	0101000d 	tsteq	r1, sp
  94:	00000101 	andeq	r0, r0, r1, lsl #2
  98:	00000100 	andeq	r0, r0, r0, lsl #2
  9c:	6e6d2f01 	cdpvs	15, 6, cr2, cr13, cr1, {0}
  a0:	2f632f74 	svccs	0x00632f74
  a4:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
  a8:	6972702f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, ip, sp, lr}^
  ac:	65746176 	ldrbvs	r6, [r4, #-374]!	; 0xfffffe8a
  b0:	6b726f57 	blvs	1c9be14 <__bss_end+0x1c929b8>
  b4:	63617073 	cmnvs	r1, #115	; 0x73
  b8:	63532f65 	cmpvs	r3, #404	; 0x194
  bc:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; ffffff24 <__bss_end+0xffff6ac8>
  c0:	2f534f2f 	svccs	0x00534f2f
  c4:	4b2f5053 	blmi	bd4218 <__bss_end+0xbcadbc>
  c8:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
  cc:	2f534f54 	svccs	0x00534f54
  d0:	7665644f 	strbtvc	r6, [r5], -pc, asr #8
  d4:	6e61647a 	mcrvs	4, 3, r6, cr1, cr10, {3}
  d8:	72732f69 	rsbsvc	r2, r3, #420	; 0x1a4
  dc:	73752f63 	cmnvc	r5, #396	; 0x18c
  e0:	70737265 	rsbsvc	r7, r3, r5, ror #4
  e4:	00656361 	rsbeq	r6, r5, r1, ror #6
  e8:	74726300 	ldrbtvc	r6, [r2], #-768	; 0xfffffd00
  ec:	00632e30 	rsbeq	r2, r3, r0, lsr lr
  f0:	00000001 	andeq	r0, r0, r1
  f4:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
  f8:	00800802 	addeq	r0, r0, r2, lsl #16
  fc:	01090300 	mrseq	r0, (UNDEF: 57)
 100:	05671805 	strbeq	r1, [r7, #-2053]!	; 0xfffff7fb
 104:	0e054a05 	vmlaeq.f32	s8, s10, s10
 108:	03040200 	movweq	r0, #16896	; 0x4200
 10c:	0041052f 	subeq	r0, r1, pc, lsr #10
 110:	65030402 	strvs	r0, [r3, #-1026]	; 0xfffffbfe
 114:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
 118:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
 11c:	05d98401 	ldrbeq	r8, [r9, #1025]	; 0x401
 120:	05316805 	ldreq	r6, [r1, #-2053]!	; 0xfffff7fb
 124:	05053312 	streq	r3, [r5, #-786]	; 0xfffffcee
 128:	054b3185 	strbeq	r3, [fp, #-389]	; 0xfffffe7b
 12c:	06022f01 	streq	r2, [r2], -r1, lsl #30
 130:	03010100 	movweq	r0, #4352	; 0x1100
 134:	03000001 	movweq	r0, #1
 138:	00007a00 	andeq	r7, r0, r0, lsl #20
 13c:	fb010200 	blx	40946 <__bss_end+0x374ea>
 140:	01000d0e 	tsteq	r0, lr, lsl #26
 144:	00010101 	andeq	r0, r1, r1, lsl #2
 148:	00010000 	andeq	r0, r1, r0
 14c:	6d2f0100 	stfvss	f0, [pc, #-0]	; 154 <_start-0x7eac>
 150:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 154:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
 158:	72702f72 	rsbsvc	r2, r0, #456	; 0x1c8
 15c:	74617669 	strbtvc	r7, [r1], #-1641	; 0xfffff997
 160:	726f5765 	rsbvc	r5, pc, #26476544	; 0x1940000
 164:	6170736b 	cmnvs	r0, fp, ror #6
 168:	532f6563 			; <UNDEFINED> instruction: 0x532f6563
 16c:	6f6f6863 	svcvs	0x006f6863
 170:	534f2f6c 	movtpl	r2, #65388	; 0xff6c
 174:	2f50532f 	svccs	0x0050532f
 178:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
 17c:	534f5452 	movtpl	r5, #62546	; 0xf452
 180:	65644f2f 	strbvs	r4, [r4, #-3887]!	; 0xfffff0d1
 184:	61647a76 	smcvs	18342	; 0x47a6
 188:	732f696e 			; <UNDEFINED> instruction: 0x732f696e
 18c:	752f6372 	strvc	r6, [pc, #-882]!	; fffffe22 <__bss_end+0xffff69c6>
 190:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 194:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 198:	78630000 	stmdavc	r3!, {}^	; <UNPREDICTABLE>
 19c:	69626178 	stmdbvs	r2!, {r3, r4, r5, r6, r8, sp, lr}^
 1a0:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 1a4:	00000100 	andeq	r0, r0, r0, lsl #2
 1a8:	6975623c 	ldmdbvs	r5!, {r2, r3, r4, r5, r9, sp, lr}^
 1ac:	692d746c 	pushvs	{r2, r3, r5, r6, sl, ip, sp, lr}
 1b0:	00003e6e 	andeq	r3, r0, lr, ror #28
 1b4:	05000000 	streq	r0, [r0, #-0]
 1b8:	02050002 	andeq	r0, r5, #2
 1bc:	000080a4 	andeq	r8, r0, r4, lsr #1
 1c0:	05010a03 	streq	r0, [r1, #-2563]	; 0xfffff5fd
 1c4:	0a05830b 	beq	160df8 <__bss_end+0x15799c>
 1c8:	8302054a 	movwhi	r0, #9546	; 0x254a
 1cc:	830e0585 	movwhi	r0, #58757	; 0xe585
 1d0:	85670205 	strbhi	r0, [r7, #-517]!	; 0xfffffdfb
 1d4:	86010584 	strhi	r0, [r1], -r4, lsl #11
 1d8:	854c854c 	strbhi	r8, [ip, #-1356]	; 0xfffffab4
 1dc:	0205854c 	andeq	r8, r5, #76, 10	; 0x13000000
 1e0:	01040200 	mrseq	r0, R12_usr
 1e4:	0301054b 	movweq	r0, #5451	; 0x154b
 1e8:	0d052e12 	stceq	14, cr2, [r5, #-72]	; 0xffffffb8
 1ec:	0024056b 	eoreq	r0, r4, fp, ror #10
 1f0:	4a030402 	bmi	c1200 <__bss_end+0xb7da4>
 1f4:	02000405 	andeq	r0, r0, #83886080	; 0x5000000
 1f8:	05830204 	streq	r0, [r3, #516]	; 0x204
 1fc:	0402000b 	streq	r0, [r2], #-11
 200:	02054a02 	andeq	r4, r5, #8192	; 0x2000
 204:	02040200 	andeq	r0, r4, #0, 4
 208:	8509052d 	strhi	r0, [r9, #-1325]	; 0xfffffad3
 20c:	a12f0105 			; <UNDEFINED> instruction: 0xa12f0105
 210:	056a0d05 	strbeq	r0, [sl, #-3333]!	; 0xfffff2fb
 214:	04020024 	streq	r0, [r2], #-36	; 0xffffffdc
 218:	04054a03 	streq	r4, [r5], #-2563	; 0xfffff5fd
 21c:	02040200 	andeq	r0, r4, #0, 4
 220:	000b0583 	andeq	r0, fp, r3, lsl #11
 224:	4a020402 	bmi	81234 <__bss_end+0x77dd8>
 228:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 22c:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
 230:	01058509 	tsteq	r5, r9, lsl #10
 234:	000a022f 	andeq	r0, sl, pc, lsr #4
 238:	021b0101 	andseq	r0, fp, #1073741824	; 0x40000000
 23c:	00030000 	andeq	r0, r3, r0
 240:	000001f1 	strdeq	r0, [r0], -r1
 244:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 248:	0101000d 	tsteq	r1, sp
 24c:	00000101 	andeq	r0, r0, r1, lsl #2
 250:	00000100 	andeq	r0, r0, r0, lsl #2
 254:	6e6d2f01 	cdpvs	15, 6, cr2, cr13, cr1, {0}
 258:	2f632f74 	svccs	0x00632f74
 25c:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 260:	6972702f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, ip, sp, lr}^
 264:	65746176 	ldrbvs	r6, [r4, #-374]!	; 0xfffffe8a
 268:	6b726f57 	blvs	1c9bfcc <__bss_end+0x1c92b70>
 26c:	63617073 	cmnvs	r1, #115	; 0x73
 270:	63532f65 	cmpvs	r3, #404	; 0x194
 274:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; dc <_start-0x7f24>
 278:	2f534f2f 	svccs	0x00534f2f
 27c:	4b2f5053 	blmi	bd43d0 <__bss_end+0xbcaf74>
 280:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
 284:	2f534f54 	svccs	0x00534f54
 288:	7665644f 	strbtvc	r6, [r5], -pc, asr #8
 28c:	6e61647a 	mcrvs	4, 3, r6, cr1, cr10, {3}
 290:	72732f69 	rsbsvc	r2, r3, #420	; 0x1a4
 294:	73752f63 	cmnvc	r5, #396	; 0x18c
 298:	70737265 	rsbsvc	r7, r3, r5, ror #4
 29c:	2f656361 	svccs	0x00656361
 2a0:	74696e69 	strbtvc	r6, [r9], #-3689	; 0xfffff197
 2a4:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
 2a8:	6d2f006b 	stcvs	0, cr0, [pc, #-428]!	; 104 <_start-0x7efc>
 2ac:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 2b0:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
 2b4:	72702f72 	rsbsvc	r2, r0, #456	; 0x1c8
 2b8:	74617669 	strbtvc	r7, [r1], #-1641	; 0xfffff997
 2bc:	726f5765 	rsbvc	r5, pc, #26476544	; 0x1940000
 2c0:	6170736b 	cmnvs	r0, fp, ror #6
 2c4:	532f6563 			; <UNDEFINED> instruction: 0x532f6563
 2c8:	6f6f6863 	svcvs	0x006f6863
 2cc:	534f2f6c 	movtpl	r2, #65388	; 0xff6c
 2d0:	2f50532f 	svccs	0x0050532f
 2d4:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
 2d8:	534f5452 	movtpl	r5, #62546	; 0xf452
 2dc:	65644f2f 	strbvs	r4, [r4, #-3887]!	; 0xfffff0d1
 2e0:	61647a76 	smcvs	18342	; 0x47a6
 2e4:	732f696e 			; <UNDEFINED> instruction: 0x732f696e
 2e8:	752f6372 	strvc	r6, [pc, #-882]!	; ffffff7e <__bss_end+0xffff6b22>
 2ec:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 2f0:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 2f4:	2f2e2e2f 	svccs	0x002e2e2f
 2f8:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 2fc:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 300:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 304:	702f6564 	eorvc	r6, pc, r4, ror #10
 308:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 30c:	2f007373 	svccs	0x00007373
 310:	2f746e6d 	svccs	0x00746e6d
 314:	73752f63 	cmnvc	r5, #396	; 0x18c
 318:	702f7265 	eorvc	r7, pc, r5, ror #4
 31c:	61766972 	cmnvs	r6, r2, ror r9
 320:	6f576574 	svcvs	0x00576574
 324:	70736b72 	rsbsvc	r6, r3, r2, ror fp
 328:	2f656361 	svccs	0x00656361
 32c:	6f686353 	svcvs	0x00686353
 330:	4f2f6c6f 	svcmi	0x002f6c6f
 334:	50532f53 	subspl	r2, r3, r3, asr pc
 338:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
 33c:	4f54522d 	svcmi	0x0054522d
 340:	644f2f53 	strbvs	r2, [pc], #-3923	; 348 <_start-0x7cb8>
 344:	647a7665 	ldrbtvs	r7, [sl], #-1637	; 0xfffff99b
 348:	2f696e61 	svccs	0x00696e61
 34c:	2f637273 	svccs	0x00637273
 350:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 354:	63617073 	cmnvs	r1, #115	; 0x73
 358:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
 35c:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 360:	2f6c656e 	svccs	0x006c656e
 364:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 368:	2f656475 	svccs	0x00656475
 36c:	2f007366 	svccs	0x00007366
 370:	2f746e6d 	svccs	0x00746e6d
 374:	73752f63 	cmnvc	r5, #396	; 0x18c
 378:	702f7265 	eorvc	r7, pc, r5, ror #4
 37c:	61766972 	cmnvs	r6, r2, ror r9
 380:	6f576574 	svcvs	0x00576574
 384:	70736b72 	rsbsvc	r6, r3, r2, ror fp
 388:	2f656361 	svccs	0x00656361
 38c:	6f686353 	svcvs	0x00686353
 390:	4f2f6c6f 	svcmi	0x002f6c6f
 394:	50532f53 	subspl	r2, r3, r3, asr pc
 398:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
 39c:	4f54522d 	svcmi	0x0054522d
 3a0:	644f2f53 	strbvs	r2, [pc], #-3923	; 3a8 <_start-0x7c58>
 3a4:	647a7665 	ldrbtvs	r7, [sl], #-1637	; 0xfffff99b
 3a8:	2f696e61 	svccs	0x00696e61
 3ac:	2f637273 	svccs	0x00637273
 3b0:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 3b4:	63617073 	cmnvs	r1, #115	; 0x73
 3b8:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
 3bc:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 3c0:	2f6c656e 	svccs	0x006c656e
 3c4:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 3c8:	2f656475 	svccs	0x00656475
 3cc:	72616f62 	rsbvc	r6, r1, #392	; 0x188
 3d0:	70722f64 	rsbsvc	r2, r2, r4, ror #30
 3d4:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
 3d8:	00006c61 	andeq	r6, r0, r1, ror #24
 3dc:	6e69616d 	powvsez	f6, f1, #5.0
 3e0:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 3e4:	00000100 	andeq	r0, r0, r0, lsl #2
 3e8:	6e697073 	mcrvs	0, 3, r7, cr9, cr3, {3}
 3ec:	6b636f6c 	blvs	18dc1a4 <__bss_end+0x18d2d48>
 3f0:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 3f4:	69660000 	stmdbvs	r6!, {}^	; <UNPREDICTABLE>
 3f8:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
 3fc:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
 400:	0300682e 	movweq	r6, #2094	; 0x82e
 404:	72700000 	rsbsvc	r0, r0, #0
 408:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 40c:	00682e73 	rsbeq	r2, r8, r3, ror lr
 410:	70000002 	andvc	r0, r0, r2
 414:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 418:	6d5f7373 	ldclvs	3, cr7, [pc, #-460]	; 254 <_start-0x7dac>
 41c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
 420:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
 424:	00000200 	andeq	r0, r0, r0, lsl #4
 428:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
 42c:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
 430:	00000400 	andeq	r0, r0, r0, lsl #8
 434:	00010500 	andeq	r0, r1, r0, lsl #10
 438:	822c0205 	eorhi	r0, ip, #1342177280	; 0x50000000
 43c:	05170000 	ldreq	r0, [r7, #-0]
 440:	1f05a313 	svcne	0x0005a313
 444:	4a220551 	bmi	881990 <__bss_end+0x878534>
 448:	05820305 	streq	r0, [r2, #773]	; 0x305
 44c:	0e054b04 	vmlaeq.f64	d4, d5, d4
 450:	2a030531 	bcs	c191c <__bss_end+0xb84c0>
 454:	01000202 	tsteq	r0, r2, lsl #4
 458:	0002b801 	andeq	fp, r2, r1, lsl #16
 45c:	cd000300 	stcgt	3, cr0, [r0, #-0]
 460:	02000001 	andeq	r0, r0, #1
 464:	0d0efb01 	vstreq	d15, [lr, #-4]
 468:	01010100 	mrseq	r0, (UNDEF: 17)
 46c:	00000001 	andeq	r0, r0, r1
 470:	01000001 	tsteq	r0, r1
 474:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
 478:	752f632f 	strvc	r6, [pc, #-815]!	; 151 <_start-0x7eaf>
 47c:	2f726573 	svccs	0x00726573
 480:	76697270 			; <UNDEFINED> instruction: 0x76697270
 484:	57657461 	strbpl	r7, [r5, -r1, ror #8]!
 488:	736b726f 	cmnvc	fp, #-268435450	; 0xf0000006
 48c:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 490:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
 494:	2f6c6f6f 	svccs	0x006c6f6f
 498:	532f534f 			; <UNDEFINED> instruction: 0x532f534f
 49c:	494b2f50 	stmdbmi	fp, {r4, r6, r8, r9, sl, fp, sp}^
 4a0:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
 4a4:	4f2f534f 	svcmi	0x002f534f
 4a8:	7a766564 	bvc	1d99a40 <__bss_end+0x1d905e4>
 4ac:	696e6164 	stmdbvs	lr!, {r2, r5, r6, r8, sp, lr}^
 4b0:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
 4b4:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
 4b8:	2f62696c 	svccs	0x0062696c
 4bc:	00637273 	rsbeq	r7, r3, r3, ror r2
 4c0:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
 4c4:	752f632f 	strvc	r6, [pc, #-815]!	; 19d <_start-0x7e63>
 4c8:	2f726573 	svccs	0x00726573
 4cc:	76697270 			; <UNDEFINED> instruction: 0x76697270
 4d0:	57657461 	strbpl	r7, [r5, -r1, ror #8]!
 4d4:	736b726f 	cmnvc	fp, #-268435450	; 0xf0000006
 4d8:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 4dc:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
 4e0:	2f6c6f6f 	svccs	0x006c6f6f
 4e4:	532f534f 			; <UNDEFINED> instruction: 0x532f534f
 4e8:	494b2f50 	stmdbmi	fp, {r4, r6, r8, r9, sl, fp, sp}^
 4ec:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
 4f0:	4f2f534f 	svcmi	0x002f534f
 4f4:	7a766564 	bvc	1d99a8c <__bss_end+0x1d90630>
 4f8:	696e6164 	stmdbvs	lr!, {r2, r5, r6, r8, sp, lr}^
 4fc:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
 500:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 504:	2f6c656e 	svccs	0x006c656e
 508:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 50c:	2f656475 	svccs	0x00656475
 510:	636f7270 	cmnvs	pc, #112, 4
 514:	00737365 	rsbseq	r7, r3, r5, ror #6
 518:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
 51c:	752f632f 	strvc	r6, [pc, #-815]!	; 1f5 <_start-0x7e0b>
 520:	2f726573 	svccs	0x00726573
 524:	76697270 			; <UNDEFINED> instruction: 0x76697270
 528:	57657461 	strbpl	r7, [r5, -r1, ror #8]!
 52c:	736b726f 	cmnvc	fp, #-268435450	; 0xf0000006
 530:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 534:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
 538:	2f6c6f6f 	svccs	0x006c6f6f
 53c:	532f534f 			; <UNDEFINED> instruction: 0x532f534f
 540:	494b2f50 	stmdbmi	fp, {r4, r6, r8, r9, sl, fp, sp}^
 544:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
 548:	4f2f534f 	svcmi	0x002f534f
 54c:	7a766564 	bvc	1d99ae4 <__bss_end+0x1d90688>
 550:	696e6164 	stmdbvs	lr!, {r2, r5, r6, r8, sp, lr}^
 554:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
 558:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 55c:	2f6c656e 	svccs	0x006c656e
 560:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 564:	2f656475 	svccs	0x00656475
 568:	2f007366 	svccs	0x00007366
 56c:	2f746e6d 	svccs	0x00746e6d
 570:	73752f63 	cmnvc	r5, #396	; 0x18c
 574:	702f7265 	eorvc	r7, pc, r5, ror #4
 578:	61766972 	cmnvs	r6, r2, ror r9
 57c:	6f576574 	svcvs	0x00576574
 580:	70736b72 	rsbsvc	r6, r3, r2, ror fp
 584:	2f656361 	svccs	0x00656361
 588:	6f686353 	svcvs	0x00686353
 58c:	4f2f6c6f 	svcmi	0x002f6c6f
 590:	50532f53 	subspl	r2, r3, r3, asr pc
 594:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
 598:	4f54522d 	svcmi	0x0054522d
 59c:	644f2f53 	strbvs	r2, [pc], #-3923	; 5a4 <_start-0x7a5c>
 5a0:	647a7665 	ldrbtvs	r7, [sl], #-1637	; 0xfffff99b
 5a4:	2f696e61 	svccs	0x00696e61
 5a8:	2f637273 	svccs	0x00637273
 5ac:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 5b0:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 5b4:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 5b8:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
 5bc:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
 5c0:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
 5c4:	61682f30 	cmnvs	r8, r0, lsr pc
 5c8:	7300006c 	movwvc	r0, #108	; 0x6c
 5cc:	69666474 	stmdbvs	r6!, {r2, r4, r5, r6, sl, sp, lr}^
 5d0:	632e656c 			; <UNDEFINED> instruction: 0x632e656c
 5d4:	01007070 	tsteq	r0, r0, ror r0
 5d8:	77730000 	ldrbvc	r0, [r3, -r0]!
 5dc:	00682e69 	rsbeq	r2, r8, r9, ror #28
 5e0:	73000002 	movwvc	r0, #2
 5e4:	6c6e6970 			; <UNDEFINED> instruction: 0x6c6e6970
 5e8:	2e6b636f 	cdpcs	3, 6, cr6, cr11, cr15, {3}
 5ec:	00020068 	andeq	r0, r2, r8, rrx
 5f0:	6c696600 	stclvs	6, cr6, [r9], #-0
 5f4:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
 5f8:	2e6d6574 	mcrcs	5, 3, r6, cr13, cr4, {3}
 5fc:	00030068 	andeq	r0, r3, r8, rrx
 600:	6f727000 	svcvs	0x00727000
 604:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 608:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 60c:	72700000 	rsbsvc	r0, r0, #0
 610:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 614:	616d5f73 	smcvs	54771	; 0xd5f3
 618:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
 61c:	00682e72 	rsbeq	r2, r8, r2, ror lr
 620:	69000002 	stmdbvs	r0, {r1}
 624:	6564746e 	strbvs	r7, [r4, #-1134]!	; 0xfffffb92
 628:	00682e66 	rsbeq	r2, r8, r6, ror #28
 62c:	00000004 	andeq	r0, r0, r4
 630:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 634:	00827402 	addeq	r7, r2, r2, lsl #8
 638:	05051600 	streq	r1, [r5, #-1536]	; 0xfffffa00
 63c:	0c052f69 	stceq	15, cr2, [r5], {105}	; 0x69
 640:	2f01054c 	svccs	0x0001054c
 644:	83050585 	movwhi	r0, #21893	; 0x5585
 648:	2f01054b 	svccs	0x0001054b
 64c:	4b050585 	blmi	141c68 <__bss_end+0x13880c>
 650:	852f0105 	strhi	r0, [pc, #-261]!	; 553 <_start-0x7aad>
 654:	4ba10505 	blmi	fe841a70 <__bss_end+0xfe838614>
 658:	0c052f4b 	stceq	15, cr2, [r5], {75}	; 0x4b
 65c:	2f01054c 	svccs	0x0001054c
 660:	bd050585 	cfstr32lt	mvfx0, [r5, #-532]	; 0xfffffdec
 664:	2f4b4b4b 	svccs	0x004b4b4b
 668:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 66c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 670:	4b4bbd05 	blmi	12efa8c <__bss_end+0x12e6630>
 674:	0c052f4b 	stceq	15, cr2, [r5], {75}	; 0x4b
 678:	2f01054c 	svccs	0x0001054c
 67c:	83050585 	movwhi	r0, #21893	; 0x5585
 680:	2f01054b 	svccs	0x0001054b
 684:	bd050585 	cfstr32lt	mvfx0, [r5, #-532]	; 0xfffffdec
 688:	2f4b4b4b 	svccs	0x004b4b4b
 68c:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 690:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 694:	4b4ba105 	blmi	12e8ab0 <__bss_end+0x12df654>
 698:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 69c:	852f0105 	strhi	r0, [pc, #-261]!	; 59f <_start-0x7a61>
 6a0:	4bbd0505 	blmi	fef41abc <__bss_end+0xfef38660>
 6a4:	052f4b4b 	streq	r4, [pc, #-2891]!	; fffffb61 <__bss_end+0xffff6705>
 6a8:	01054c0c 	tsteq	r5, ip, lsl #24
 6ac:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
 6b0:	2f4b4ba1 	svccs	0x004b4ba1
 6b4:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 6b8:	05859f01 	streq	r9, [r5, #3841]	; 0xf01
 6bc:	05056720 	streq	r6, [r5, #-1824]	; 0xfffff8e0
 6c0:	054b4b4d 	strbeq	r4, [fp, #-2893]	; 0xfffff4b3
 6c4:	0105300c 	tsteq	r5, ip
 6c8:	2005852f 	andcs	r8, r5, pc, lsr #10
 6cc:	4d050567 	cfstr32mi	mvfx0, [r5, #-412]	; 0xfffffe64
 6d0:	0c054b4b 			; <UNDEFINED> instruction: 0x0c054b4b
 6d4:	2f010530 	svccs	0x00010530
 6d8:	83200585 			; <UNDEFINED> instruction: 0x83200585
 6dc:	4b4c0505 	blmi	1301af8 <__bss_end+0x12f869c>
 6e0:	2f01054b 	svccs	0x0001054b
 6e4:	67200585 	strvs	r0, [r0, -r5, lsl #11]!
 6e8:	4b4d0505 	blmi	1341b04 <__bss_end+0x13386a8>
 6ec:	300c054b 	andcc	r0, ip, fp, asr #10
 6f0:	872f0105 	strhi	r0, [pc, -r5, lsl #2]!
 6f4:	9fa00c05 	svcls	0x00a00c05
 6f8:	05bc3105 	ldreq	r3, [ip, #261]!	; 0x105
 6fc:	36056629 	strcc	r6, [r5], -r9, lsr #12
 700:	300f052e 	andcc	r0, pc, lr, lsr #10
 704:	05661305 	strbeq	r1, [r6, #-773]!	; 0xfffffcfb
 708:	10058409 	andne	r8, r5, r9, lsl #8
 70c:	9f0105d8 	svcls	0x000105d8
 710:	01000802 	tsteq	r0, r2, lsl #16
 714:	00053d01 	andeq	r3, r5, r1, lsl #26
 718:	70000300 	andvc	r0, r0, r0, lsl #6
 71c:	02000000 	andeq	r0, r0, #0
 720:	0d0efb01 	vstreq	d15, [lr, #-4]
 724:	01010100 	mrseq	r0, (UNDEF: 17)
 728:	00000001 	andeq	r0, r0, r1
 72c:	01000001 	tsteq	r0, r1
 730:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
 734:	752f632f 	strvc	r6, [pc, #-815]!	; 40d <_start-0x7bf3>
 738:	2f726573 	svccs	0x00726573
 73c:	76697270 			; <UNDEFINED> instruction: 0x76697270
 740:	57657461 	strbpl	r7, [r5, -r1, ror #8]!
 744:	736b726f 	cmnvc	fp, #-268435450	; 0xf0000006
 748:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 74c:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
 750:	2f6c6f6f 	svccs	0x006c6f6f
 754:	532f534f 			; <UNDEFINED> instruction: 0x532f534f
 758:	494b2f50 	stmdbmi	fp, {r4, r6, r8, r9, sl, fp, sp}^
 75c:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
 760:	4f2f534f 	svcmi	0x002f534f
 764:	7a766564 	bvc	1d99cfc <__bss_end+0x1d908a0>
 768:	696e6164 	stmdbvs	lr!, {r2, r5, r6, r8, sp, lr}^
 76c:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
 770:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
 774:	2f62696c 	svccs	0x0062696c
 778:	00637273 	rsbeq	r7, r3, r3, ror r2
 77c:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
 780:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
 784:	632e676e 			; <UNDEFINED> instruction: 0x632e676e
 788:	01007070 	tsteq	r0, r0, ror r0
 78c:	05000000 	streq	r0, [r0, #-0]
 790:	02050001 	andeq	r0, r5, #1
 794:	000086d0 	ldrdeq	r8, [r0], -r0
 798:	05010a03 	streq	r0, [r1, #-2563]	; 0xfffff5fd
 79c:	0f05bb06 	svceq	0x0005bb06
 7a0:	6821054c 	stmdavs	r1!, {r2, r3, r6, r8, sl}
 7a4:	05ba0a05 	ldreq	r0, [sl, #2565]!	; 0xa05
 7a8:	27052e0b 	strcs	r2, [r5, -fp, lsl #28]
 7ac:	4a0d054a 	bmi	341cdc <__bss_end+0x338880>
 7b0:	052f0905 	streq	r0, [pc, #-2309]!	; fffffeb3 <__bss_end+0xffff6a57>
 7b4:	02059f04 	andeq	r9, r5, #4, 30
 7b8:	35050562 	strcc	r0, [r5, #-1378]	; 0xfffffa9e
 7bc:	05681005 	strbeq	r1, [r8, #-5]!
 7c0:	22052e11 	andcs	r2, r5, #272	; 0x110
 7c4:	2e13054a 	cfmac32cs	mvfx0, mvfx3, mvfx10
 7c8:	052f0a05 	streq	r0, [pc, #-2565]!	; fffffdcb <__bss_end+0xffff696f>
 7cc:	0a056909 	beq	15abf8 <__bss_end+0x15179c>
 7d0:	4a0c052e 	bmi	301c90 <__bss_end+0x2f8834>
 7d4:	054b0305 	strbeq	r0, [fp, #-773]	; 0xfffffcfb
 7d8:	1805680b 	stmdane	r5, {r0, r1, r3, fp, sp, lr}
 7dc:	03040200 	movweq	r0, #16896	; 0x4200
 7e0:	0014054a 	andseq	r0, r4, sl, asr #10
 7e4:	9e030402 	cdpls	4, 0, cr0, cr3, cr2, {0}
 7e8:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
 7ec:	05680204 	strbeq	r0, [r8, #-516]!	; 0xfffffdfc
 7f0:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
 7f4:	08058202 	stmdaeq	r5, {r1, r9, pc}
 7f8:	02040200 	andeq	r0, r4, #0, 4
 7fc:	001a054a 	andseq	r0, sl, sl, asr #10
 800:	4b020402 	blmi	81810 <__bss_end+0x783b4>
 804:	02001b05 	andeq	r1, r0, #5120	; 0x1400
 808:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 80c:	0402000c 	streq	r0, [r2], #-12
 810:	0f054a02 	svceq	0x00054a02
 814:	02040200 	andeq	r0, r4, #0, 4
 818:	001b0582 	andseq	r0, fp, r2, lsl #11
 81c:	4a020402 	bmi	8182c <__bss_end+0x783d0>
 820:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
 824:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 828:	0402000a 	streq	r0, [r2], #-10
 82c:	0b052f02 	bleq	14c43c <__bss_end+0x142fe0>
 830:	02040200 	andeq	r0, r4, #0, 4
 834:	000d052e 	andeq	r0, sp, lr, lsr #10
 838:	4a020402 	bmi	81848 <__bss_end+0x783ec>
 83c:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 840:	05460204 	strbeq	r0, [r6, #-516]	; 0xfffffdfc
 844:	05858801 	streq	r8, [r5, #2049]	; 0x801
 848:	0c058306 	stceq	3, cr8, [r5], {6}
 84c:	8203054c 	andhi	r0, r3, #76, 10	; 0x13000000
 850:	054b0c05 	strbeq	r0, [fp, #-3077]	; 0xfffff3fb
 854:	10054d09 	andne	r4, r5, r9, lsl #26
 858:	4c0a054a 	cfstr32mi	mvfx0, [sl], {74}	; 0x4a
 85c:	05bb0705 	ldreq	r0, [fp, #1797]!	; 0x705
 860:	17054a03 	strne	r4, [r5, -r3, lsl #20]
 864:	01040200 	mrseq	r0, R12_usr
 868:	0014054a 	andseq	r0, r4, sl, asr #10
 86c:	4a010402 	bmi	4187c <__bss_end+0x38420>
 870:	054d0d05 	strbeq	r0, [sp, #-3333]	; 0xfffff2fb
 874:	0a054a14 	beq	1530cc <__bss_end+0x149c70>
 878:	6808052e 	stmdavs	r8, {r1, r2, r3, r5, r8, sl}
 87c:	78030205 	stmdavc	r3, {r0, r2, r9}
 880:	03090566 	movweq	r0, #38246	; 0x9566
 884:	01052e0b 	tsteq	r5, fp, lsl #28
 888:	681b052f 	ldmdavs	fp, {r0, r1, r2, r3, r5, r8, sl}
 88c:	05830905 	streq	r0, [r3, #2309]	; 0x905
 890:	12054b0b 	andne	r4, r5, #11264	; 0x2c00
 894:	bb0f0568 	bllt	3c1e3c <__bss_end+0x3b89e0>
 898:	05830905 	streq	r0, [r3, #2309]	; 0x905
 89c:	0c056405 	cfstrseq	mvf6, [r5], {5}
 8a0:	4a120533 	bmi	481d74 <__bss_end+0x478918>
 8a4:	05830f05 	streq	r0, [r3, #3845]	; 0xf05
 8a8:	05058309 	streq	r8, [r5, #-777]	; 0xfffffcf7
 8ac:	320a0564 	andcc	r0, sl, #100, 10	; 0x19000000
 8b0:	05670c05 	strbeq	r0, [r7, #-3077]!	; 0xfffff3fb
 8b4:	05f52f01 	ldrbeq	r2, [r5, #3841]!	; 0xf01
 8b8:	0305bb16 	movweq	fp, #23318	; 0x5b16
 8bc:	670c0567 	strvs	r0, [ip, -r7, ror #10]
 8c0:	054d0b05 	strbeq	r0, [sp, #-2821]	; 0xfffff4fb
 8c4:	0402001c 	streq	r0, [r2], #-28	; 0xffffffe4
 8c8:	14054a01 	strne	r4, [r5], #-2561	; 0xfffff5ff
 8cc:	01040200 	mrseq	r0, R12_usr
 8d0:	d70e0566 	strle	r0, [lr, -r6, ror #10]
 8d4:	052e0f05 	streq	r0, [lr, #-3845]!	; 0xfffff0fb
 8d8:	03054a08 	movweq	r4, #23048	; 0x5a08
 8dc:	0013054b 	andseq	r0, r3, fp, asr #10
 8e0:	66020402 	strvs	r0, [r2], -r2, lsl #8
 8e4:	02001005 	andeq	r1, r0, #5
 8e8:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
 8ec:	0402001d 	streq	r0, [r2], #-29	; 0xffffffe3
 8f0:	28054a03 	stmdacs	r5, {r0, r1, r9, fp, lr}
 8f4:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 8f8:	670b0566 	strvs	r0, [fp, -r6, ror #10]
 8fc:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 900:	05470204 	strbeq	r0, [r7, #-516]	; 0xfffffdfc
 904:	01058909 	tsteq	r5, r9, lsl #18
 908:	0905692f 	stmdbeq	r5, {r0, r1, r2, r3, r5, r8, fp, sp, lr}
 90c:	4b070587 	blmi	1c1f30 <__bss_end+0x1b8ad4>
 910:	054c1105 	strbeq	r1, [ip, #-261]	; 0xfffffefb
 914:	0d05660f 	stceq	6, cr6, [r5, #-60]	; 0xffffffc4
 918:	2e1d052e 	cfmul64cs	mvdx0, mvdx13, mvdx14
 91c:	01040200 	mrseq	r0, R12_usr
 920:	20056606 	andcs	r6, r5, r6, lsl #12
 924:	03040200 	movweq	r0, #16896	; 0x4200
 928:	1d056606 	stcne	6, cr6, [r5, #-24]	; 0xffffffe8
 92c:	05040200 	streq	r0, [r4, #-512]	; 0xfffffe00
 930:	04020066 	streq	r0, [r2], #-102	; 0xffffff9a
 934:	004a0606 	subeq	r0, sl, r6, lsl #12
 938:	2e080402 	cdpcs	4, 0, cr0, cr8, cr2, {0}
 93c:	4b060905 	blmi	182d58 <__bss_end+0x1798fc>
 940:	054a0a05 	strbeq	r0, [sl, #-2565]	; 0xfffff5fb
 944:	10054a15 	andne	r4, r5, r5, lsl sl
 948:	6607054a 	strvs	r0, [r7], -sl, asr #10
 94c:	31490305 	cmpcc	r9, r5, lsl #6
 950:	05671305 	strbeq	r1, [r7, #-773]!	; 0xfffffcfb
 954:	0f056611 	svceq	0x00056611
 958:	2e1f052e 	cfmul64cs	mvdx0, mvdx15, mvdx14
 95c:	01040200 	mrseq	r0, R12_usr
 960:	22056606 	andcs	r6, r5, #6291456	; 0x600000
 964:	03040200 	movweq	r0, #16896	; 0x4200
 968:	1f056606 	svcne	0x00056606
 96c:	05040200 	streq	r0, [r4, #-512]	; 0xfffffe00
 970:	04020066 	streq	r0, [r2], #-102	; 0xffffff9a
 974:	004a0606 	subeq	r0, sl, r6, lsl #12
 978:	2e080402 	cdpcs	4, 0, cr0, cr8, cr2, {0}
 97c:	4b060b05 	blmi	183598 <__bss_end+0x17a13c>
 980:	054a0c05 	strbeq	r0, [sl, #-3077]	; 0xfffff3fb
 984:	12054a17 	andne	r4, r5, #94208	; 0x17000
 988:	6609054a 	strvs	r0, [r9], -sl, asr #10
 98c:	6405054b 	strvs	r0, [r5], #-1355	; 0xfffffab5
 990:	05330305 	ldreq	r0, [r3, #-773]!	; 0xfffffcfb
 994:	04020010 	streq	r0, [r2], #-16
 998:	09056601 	stmdbeq	r5, {r0, r9, sl, sp, lr}
 99c:	0b054b67 	bleq	153740 <__bss_end+0x14a2e4>
 9a0:	6609054b 	strvs	r0, [r9], -fp, asr #10
 9a4:	052e0705 	streq	r0, [lr, #-1797]!	; 0xfffff8fb
 9a8:	0d052f05 	stceq	15, cr2, [r5, #-20]	; 0xffffffec
 9ac:	660b0567 	strvs	r0, [fp], -r7, ror #10
 9b0:	052e0905 	streq	r0, [lr, #-2309]!	; 0xfffff6fb
 9b4:	0d054b0a 	vstreq	d4, [r5, #-40]	; 0xffffffd8
 9b8:	660b0567 	strvs	r0, [fp], -r7, ror #10
 9bc:	052e0905 	streq	r0, [lr, #-2309]!	; 0xfffff6fb
 9c0:	004c2f0c 	subeq	r2, ip, ip, lsl #30
 9c4:	06010402 	streq	r0, [r1], -r2, lsl #8
 9c8:	05670666 	strbeq	r0, [r7, #-1638]!	; 0xfffff99a
 9cc:	0905ba15 	stmdbeq	r5, {r0, r2, r4, r9, fp, ip, sp, pc}
 9d0:	4b0d054a 	blmi	341f00 <__bss_end+0x338aa4>
 9d4:	05660b05 	strbeq	r0, [r6, #-2821]!	; 0xfffff4fb
 9d8:	05052e09 	streq	r2, [r5, #-3593]	; 0xfffff1f7
 9dc:	320b052c 	andcc	r0, fp, #44, 10	; 0xb000000
 9e0:	05660705 	strbeq	r0, [r6, #-1797]!	; 0xfffff8fb
 9e4:	0705680c 	streq	r6, [r5, -ip, lsl #16]
 9e8:	83060567 	movwhi	r0, #25959	; 0x6567
 9ec:	05640305 	strbeq	r0, [r4, #-773]!	; 0xfffffcfb
 9f0:	0705320c 	streq	r3, [r5, -ip, lsl #4]
 9f4:	bb060567 	bllt	181f98 <__bss_end+0x178b3c>
 9f8:	05640305 	strbeq	r0, [r4, #-773]!	; 0xfffffcfb
 9fc:	0105320a 	tsteq	r5, sl, lsl #4
 a00:	0826054b 	stmdaeq	r6!, {r0, r1, r3, r6, r8, sl}
 a04:	0309053e 	movweq	r0, #38206	; 0x953e
 a08:	054b9e09 	strbeq	r9, [fp, #-3593]	; 0xfffff1f7
 a0c:	054c4b0f 	strbeq	r4, [ip, #-2831]	; 0xfffff4f1
 a10:	13052e05 	movwne	r2, #24069	; 0x5e05
 a14:	67110567 	ldrvs	r0, [r1, -r7, ror #10]
 a18:	054a1305 	strbeq	r1, [sl, #-773]	; 0xfffffcfb
 a1c:	0f054b09 	svceq	0x00054b09
 a20:	2e050531 	mcrcs	5, 0, r0, cr5, cr1, {1}
 a24:	05671005 	strbeq	r1, [r7, #-5]!
 a28:	11056613 	tstne	r5, r3, lsl r6
 a2c:	4a0f054b 	bmi	3c1f60 <__bss_end+0x3b8b04>
 a30:	05311905 	ldreq	r1, [r1, #-2309]!	; 0xfffff6fb
 a34:	1b058415 	blne	161a90 <__bss_end+0x158634>
 a38:	660d0567 	strvs	r0, [sp], -r7, ror #10
 a3c:	05671b05 	strbeq	r1, [r7, #-2821]!	; 0xfffff4fb
 a40:	1b054a10 	blne	153288 <__bss_end+0x149e2c>
 a44:	4a130566 	bmi	4c1fe4 <__bss_end+0x4b8b88>
 a48:	052f1705 	streq	r1, [pc, #-1797]!	; 34b <_start-0x7cb5>
 a4c:	0f05661c 	svceq	0x0005661c
 a50:	2f090582 	svccs	0x00090582
 a54:	61050567 	tstvs	r5, r7, ror #10
 a58:	67100536 			; <UNDEFINED> instruction: 0x67100536
 a5c:	05661305 	strbeq	r1, [r6, #-773]!	; 0xfffffcfb
 a60:	0f054c0c 	svceq	0x00054c0c
 a64:	4c190566 	cfldr32mi	mvfx0, [r9], {102}	; 0x66
 a68:	01040200 	mrseq	r0, R12_usr
 a6c:	10056606 	andne	r6, r5, r6, lsl #12
 a70:	13056706 	movwne	r6, #22278	; 0x5706
 a74:	4b090566 	blmi	242014 <__bss_end+0x238bb8>
 a78:	63050567 	movwvs	r0, #21863	; 0x5567
 a7c:	05341305 	ldreq	r1, [r4, #-773]!	; 0xfffffcfb
 a80:	1b056715 	blne	15a6dc <__bss_end+0x151280>
 a84:	4a0d054a 	bmi	341fb4 <__bss_end+0x338b58>
 a88:	05671b05 	strbeq	r1, [r7, #-2821]!	; 0xfffff4fb
 a8c:	1b054a10 	blne	1532d4 <__bss_end+0x149e78>
 a90:	4a130566 	bmi	4c2030 <__bss_end+0x4b8bd4>
 a94:	052f1105 	streq	r1, [pc, #-261]!	; 997 <_start-0x7669>
 a98:	1e054a17 			; <UNDEFINED> instruction: 0x1e054a17
 a9c:	9e0f054a 	cfsh32ls	mvfx0, mvfx15, #42
 aa0:	052f0905 	streq	r0, [pc, #-2309]!	; 1a3 <_start-0x7e5d>
 aa4:	0d056205 	sfmeq	f6, 4, [r5, #-20]	; 0xffffffec
 aa8:	67010534 	smladxvs	r1, r4, r5, r0
 aac:	bd0905a1 	cfstr32lt	mvfx0, [r9, #-644]	; 0xfffffd7c
 ab0:	02001605 	andeq	r1, r0, #5242880	; 0x500000
 ab4:	054a0404 	strbeq	r0, [sl, #-1028]	; 0xfffffbfc
 ab8:	0402001d 	streq	r0, [r2], #-29	; 0xffffffe3
 abc:	1e058202 	cdpne	2, 0, cr8, cr5, cr2, {0}
 ac0:	02040200 	andeq	r0, r4, #0, 4
 ac4:	0016052e 	andseq	r0, r6, lr, lsr #10
 ac8:	66020402 	strvs	r0, [r2], -r2, lsl #8
 acc:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
 ad0:	054b0304 	strbeq	r0, [fp, #-772]	; 0xfffffcfc
 ad4:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
 ad8:	08052e03 	stmdaeq	r5, {r0, r1, r9, sl, fp, sp}
 adc:	03040200 	movweq	r0, #16896	; 0x4200
 ae0:	0009054a 	andeq	r0, r9, sl, asr #10
 ae4:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
 ae8:	02001205 	andeq	r1, r0, #1342177280	; 0x50000000
 aec:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 af0:	0402000b 	streq	r0, [r2], #-11
 af4:	02052e03 	andeq	r2, r5, #3, 28	; 0x30
 af8:	03040200 	movweq	r0, #16896	; 0x4200
 afc:	000b052d 	andeq	r0, fp, sp, lsr #10
 b00:	84020402 	strhi	r0, [r2], #-1026	; 0xfffffbfe
 b04:	02000805 	andeq	r0, r0, #327680	; 0x50000
 b08:	05830104 	streq	r0, [r3, #260]	; 0x104
 b0c:	04020009 	streq	r0, [r2], #-9
 b10:	0b052e01 	bleq	14c31c <__bss_end+0x142ec0>
 b14:	01040200 	mrseq	r0, R12_usr
 b18:	0002054a 	andeq	r0, r2, sl, asr #10
 b1c:	49010402 	stmdbmi	r1, {r1, sl}
 b20:	05850b05 	streq	r0, [r5, #2821]	; 0xb05
 b24:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 b28:	1605a10c 	strne	sl, [r5], -ip, lsl #2
 b2c:	03040200 	movweq	r0, #16896	; 0x4200
 b30:	0017054a 	andseq	r0, r7, sl, asr #10
 b34:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
 b38:	02001905 	andeq	r1, r0, #81920	; 0x14000
 b3c:	05660304 	strbeq	r0, [r6, #-772]!	; 0xfffffcfc
 b40:	04020005 	streq	r0, [r2], #-5
 b44:	0c054a02 			; <UNDEFINED> instruction: 0x0c054a02
 b48:	00150584 	andseq	r0, r5, r4, lsl #11
 b4c:	4a030402 	bmi	c1b5c <__bss_end+0xb8700>
 b50:	02001605 	andeq	r1, r0, #5242880	; 0x500000
 b54:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
 b58:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
 b5c:	19056603 	stmdbne	r5, {r0, r1, r9, sl, sp, lr}
 b60:	02040200 	andeq	r0, r4, #0, 4
 b64:	001a054b 	andseq	r0, sl, fp, asr #10
 b68:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 b6c:	02000f05 	andeq	r0, r0, #5, 30
 b70:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 b74:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
 b78:	1a058202 	bne	161388 <__bss_end+0x157f2c>
 b7c:	02040200 	andeq	r0, r4, #0, 4
 b80:	0013054a 	andseq	r0, r3, sl, asr #10
 b84:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 b88:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
 b8c:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
 b90:	0d05850b 	cfstr32eq	mvfx8, [r5, #-44]	; 0xffffffd4
 b94:	4a0f0582 	bmi	3c21a4 <__bss_end+0x3b8d48>
 b98:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 b9c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 ba0:	1105bc0e 	tstne	r5, lr, lsl #24
 ba4:	bc200566 	cfstr32lt	mvfx0, [r0], #-408	; 0xfffffe68
 ba8:	05660b05 	strbeq	r0, [r6, #-2821]!	; 0xfffff4fb
 bac:	0a054b1f 	beq	153830 <__bss_end+0x14a3d4>
 bb0:	4b080566 	blmi	202150 <__bss_end+0x1f8cf4>
 bb4:	05831105 	streq	r1, [r3, #261]	; 0x105
 bb8:	08052e16 	stmdaeq	r5, {r1, r2, r4, r9, sl, fp, sp}
 bbc:	67110567 	ldrvs	r0, [r1, -r7, ror #10]
 bc0:	054d0b05 	strbeq	r0, [sp, #-2821]	; 0xfffff4fb
 bc4:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 bc8:	0b058306 	bleq	1617e8 <__bss_end+0x15838c>
 bcc:	2e0c054c 	cfsh32cs	mvfx0, mvfx12, #44
 bd0:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
 bd4:	02054b04 	andeq	r4, r5, #4, 22	; 0x1000
 bd8:	31090565 	tstcc	r9, r5, ror #10
 bdc:	852f0105 	strhi	r0, [pc, #-261]!	; adf <_start-0x7521>
 be0:	059f0805 	ldreq	r0, [pc, #2053]	; 13ed <_start-0x6c13>
 be4:	14054c0b 	strne	r4, [r5], #-3083	; 0xfffff3f5
 be8:	03040200 	movweq	r0, #16896	; 0x4200
 bec:	0007054a 	andeq	r0, r7, sl, asr #10
 bf0:	83020402 	movwhi	r0, #9218	; 0x2402
 bf4:	02000805 	andeq	r0, r0, #327680	; 0x50000
 bf8:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 bfc:	0402000a 	streq	r0, [r2], #-10
 c00:	02054a02 	andeq	r4, r5, #8192	; 0x2000
 c04:	02040200 	andeq	r0, r4, #0, 4
 c08:	84010549 	strhi	r0, [r1], #-1353	; 0xfffffab7
 c0c:	bb0e0585 	bllt	382228 <__bss_end+0x378dcc>
 c10:	054b0805 	strbeq	r0, [fp, #-2053]	; 0xfffff7fb
 c14:	14054c0b 	strne	r4, [r5], #-3083	; 0xfffff3f5
 c18:	03040200 	movweq	r0, #16896	; 0x4200
 c1c:	0016054a 	andseq	r0, r6, sl, asr #10
 c20:	83020402 	movwhi	r0, #9218	; 0x2402
 c24:	02001705 	andeq	r1, r0, #1310720	; 0x140000
 c28:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 c2c:	0402000a 	streq	r0, [r2], #-10
 c30:	0b054a02 	bleq	153440 <__bss_end+0x149fe4>
 c34:	02040200 	andeq	r0, r4, #0, 4
 c38:	0017052e 	andseq	r0, r7, lr, lsr #10
 c3c:	4a020402 	bmi	81c4c <__bss_end+0x787f0>
 c40:	02000d05 	andeq	r0, r0, #320	; 0x140
 c44:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 c48:	04020002 	streq	r0, [r2], #-2
 c4c:	01052d02 	tsteq	r5, r2, lsl #26
 c50:	00080284 	andeq	r0, r8, r4, lsl #5
 c54:	Address 0x0000000000000c54 is out of bounds.


Disassembly of section .debug_info:

00000000 <.debug_info>:
       0:	00000022 	andeq	r0, r0, r2, lsr #32
       4:	00000002 	andeq	r0, r0, r2
       8:	01040000 	mrseq	r0, (UNDEF: 4)
       c:	00000000 	andeq	r0, r0, r0
      10:	00008000 	andeq	r8, r0, r0
      14:	00008008 	andeq	r8, r0, r8
      18:	00000000 	andeq	r0, r0, r0
      1c:	00000052 	andeq	r0, r0, r2, asr r0
      20:	000000a3 	andeq	r0, r0, r3, lsr #1
      24:	00a48001 	adceq	r8, r4, r1
      28:	00040000 	andeq	r0, r4, r0
      2c:	00000014 	andeq	r0, r0, r4, lsl r0
      30:	012e0104 			; <UNDEFINED> instruction: 0x012e0104
      34:	af0c0000 	svcge	0x000c0000
      38:	52000000 	andpl	r0, r0, #0
      3c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
      40:	9c000080 	stcls	0, cr0, [r0], {128}	; 0x80
      44:	82000000 	andhi	r0, r0, #0
      48:	02000000 	andeq	r0, r0, #0
      4c:	00000122 	andeq	r0, r0, r2, lsr #2
      50:	31150601 	tstcc	r5, r1, lsl #12
      54:	03000000 	movweq	r0, #0
      58:	03f40704 	mvnseq	r0, #4, 14	; 0x100000
      5c:	11020000 	mrsne	r0, (UNDEF: 2)
      60:	01000001 	tsteq	r0, r1
      64:	00311507 	eorseq	r1, r1, r7, lsl #10
      68:	ad040000 	stcge	0, cr0, [r4, #-0]
      6c:	01000001 	tsteq	r0, r1
      70:	8064060f 	rsbhi	r0, r4, pc, lsl #12
      74:	00400000 	subeq	r0, r0, r0
      78:	9c010000 	stcls	0, cr0, [r1], {-0}
      7c:	0000006a 	andeq	r0, r0, sl, rrx
      80:	00011b05 	andeq	r1, r1, r5, lsl #22
      84:	091a0100 	ldmdbeq	sl, {r8}
      88:	0000006a 	andeq	r0, r0, sl, rrx
      8c:	00749102 	rsbseq	r9, r4, r2, lsl #2
      90:	69050406 	stmdbvs	r5, {r1, r2, sl}
      94:	0700746e 	streq	r7, [r0, -lr, ror #8]
      98:	00000101 	andeq	r0, r0, r1, lsl #2
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
      d8:	029b0104 	addseq	r0, fp, #4, 2
      dc:	f0040000 			; <UNDEFINED> instruction: 0xf0040000
      e0:	52000001 	andpl	r0, r0, #1
      e4:	a4000000 	strge	r0, [r0], #-0
      e8:	88000080 	stmdahi	r0, {r7}
      ec:	33000001 	movwcc	r0, #1
      f0:	02000001 	andeq	r0, r0, #1
      f4:	00000394 	muleq	r0, r4, r3
      f8:	31072f01 	tstcc	r7, r1, lsl #30
      fc:	03000000 	movweq	r0, #0
     100:	00003704 	andeq	r3, r0, r4, lsl #14
     104:	36020400 	strcc	r0, [r2], -r0, lsl #8
     108:	01000003 	tsteq	r0, r3
     10c:	00310730 	eorseq	r0, r1, r0, lsr r7
     110:	25050000 	strcs	r0, [r5, #-0]
     114:	57000000 	strpl	r0, [r0, -r0]
     118:	06000000 	streq	r0, [r0], -r0
     11c:	00000057 	andeq	r0, r0, r7, asr r0
     120:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
     124:	07040700 	streq	r0, [r4, -r0, lsl #14]
     128:	000003f4 	strdeq	r0, [r0], -r4
     12c:	00038608 	andeq	r8, r3, r8, lsl #12
     130:	15330100 	ldrne	r0, [r3, #-256]!	; 0xffffff00
     134:	00000044 	andeq	r0, r0, r4, asr #32
     138:	00027308 	andeq	r7, r2, r8, lsl #6
     13c:	15350100 	ldrne	r0, [r5, #-256]!	; 0xffffff00
     140:	00000044 	andeq	r0, r0, r4, asr #32
     144:	00003805 	andeq	r3, r0, r5, lsl #16
     148:	00008900 	andeq	r8, r0, r0, lsl #18
     14c:	00570600 	subseq	r0, r7, r0, lsl #12
     150:	ffff0000 			; <UNDEFINED> instruction: 0xffff0000
     154:	0800ffff 	stmdaeq	r0, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, sp, lr, pc}
     158:	0000028d 	andeq	r0, r0, sp, lsl #5
     15c:	76153801 	ldrvc	r3, [r5], -r1, lsl #16
     160:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
     164:	0000033f 	andeq	r0, r0, pc, lsr r3
     168:	76153a01 	ldrvc	r3, [r5], -r1, lsl #20
     16c:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     170:	000001e2 	andeq	r0, r0, r2, ror #3
     174:	cb104801 	blgt	412180 <__bss_end+0x408d24>
     178:	d4000000 	strle	r0, [r0], #-0
     17c:	58000081 	stmdapl	r0, {r0, r7}
     180:	01000000 	mrseq	r0, (UNDEF: 0)
     184:	0000cb9c 	muleq	r0, ip, fp
     188:	02460a00 	subeq	r0, r6, #0, 20
     18c:	4a010000 	bmi	40194 <__bss_end+0x36d38>
     190:	0000d20c 	andeq	sp, r0, ip, lsl #4
     194:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     198:	05040b00 	streq	r0, [r4, #-2816]	; 0xfffff500
     19c:	00746e69 	rsbseq	r6, r4, r9, ror #28
     1a0:	00380403 	eorseq	r0, r8, r3, lsl #8
     1a4:	67090000 	strvs	r0, [r9, -r0]
     1a8:	01000003 	tsteq	r0, r3
     1ac:	00cb103c 	sbceq	r1, fp, ip, lsr r0
     1b0:	817c0000 	cmnhi	ip, r0
     1b4:	00580000 	subseq	r0, r8, r0
     1b8:	9c010000 	stcls	0, cr0, [r1], {-0}
     1bc:	00000102 	andeq	r0, r0, r2, lsl #2
     1c0:	0002460a 	andeq	r4, r2, sl, lsl #12
     1c4:	0c3e0100 	ldfeqs	f0, [lr], #-0
     1c8:	00000102 	andeq	r0, r0, r2, lsl #2
     1cc:	00749102 	rsbseq	r9, r4, r2, lsl #2
     1d0:	00250403 	eoreq	r0, r5, r3, lsl #8
     1d4:	cb0c0000 	blgt	3001dc <__bss_end+0x2f6d80>
     1d8:	01000001 	tsteq	r0, r1
     1dc:	81701129 	cmnhi	r0, r9, lsr #2
     1e0:	000c0000 	andeq	r0, ip, r0
     1e4:	9c010000 	stcls	0, cr0, [r1], {-0}
     1e8:	00024c0c 	andeq	r4, r2, ip, lsl #24
     1ec:	11240100 			; <UNDEFINED> instruction: 0x11240100
     1f0:	00008158 	andeq	r8, r0, r8, asr r1
     1f4:	00000018 	andeq	r0, r0, r8, lsl r0
     1f8:	4c0c9c01 	stcmi	12, cr9, [ip], {1}
     1fc:	01000003 	tsteq	r0, r3
     200:	8140111f 	cmphi	r0, pc, lsl r1
     204:	00180000 	andseq	r0, r8, r0
     208:	9c010000 	stcls	0, cr0, [r1], {-0}
     20c:	0002800c 	andeq	r8, r2, ip
     210:	111a0100 	tstne	sl, r0, lsl #2
     214:	00008128 	andeq	r8, r0, r8, lsr #2
     218:	00000018 	andeq	r0, r0, r8, lsl r0
     21c:	c00d9c01 	andgt	r9, sp, r1, lsl #24
     220:	02000001 	andeq	r0, r0, #1
     224:	00019e00 	andeq	r9, r1, r0, lsl #28
     228:	03740e00 	cmneq	r4, #0, 28
     22c:	14010000 	strne	r0, [r1], #-0
     230:	00016d12 	andeq	r6, r1, r2, lsl sp
     234:	019e0f00 	orrseq	r0, lr, r0, lsl #30
     238:	02000000 	andeq	r0, r0, #0
     23c:	000001b8 			; <UNDEFINED> instruction: 0x000001b8
     240:	a41c0401 	ldrge	r0, [ip], #-1025	; 0xfffffbff
     244:	0e000001 	cdpeq	0, 0, cr0, cr0, cr1, {0}
     248:	0000025f 	andeq	r0, r0, pc, asr r2
     24c:	8b120f01 	blhi	483e58 <__bss_end+0x47a9fc>
     250:	0f000001 	svceq	0x00000001
     254:	0000019e 	muleq	r0, lr, r1
     258:	039d1000 	orrseq	r1, sp, #0
     25c:	0a010000 	beq	40264 <__bss_end+0x36e08>
     260:	0000cb11 	andeq	ip, r0, r1, lsl fp
     264:	019e0f00 	orrseq	r0, lr, r0, lsl #30
     268:	00000000 	andeq	r0, r0, r0
     26c:	016d0403 	cmneq	sp, r3, lsl #8
     270:	08070000 	stmdaeq	r7, {}	; <UNPREDICTABLE>
     274:	00035905 	andeq	r5, r3, r5, lsl #18
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
     2b4:	8b140074 	blhi	50048c <__bss_end+0x4f7030>
     2b8:	a4000001 	strge	r0, [r0], #-1
     2bc:	38000080 	stmdacc	r0, {r7}
     2c0:	01000000 	mrseq	r0, (UNDEF: 0)
     2c4:	0067139c 	mlseq	r7, ip, r3, r1
     2c8:	9e2f0a01 	vmulls.f32	s0, s30, s2
     2cc:	02000001 	andeq	r0, r0, #1
     2d0:	00007491 	muleq	r0, r1, r4
     2d4:	00000176 	andeq	r0, r0, r6, ror r1
     2d8:	01e00004 	mvneq	r0, r4
     2dc:	01040000 	mrseq	r0, (UNDEF: 4)
     2e0:	0000029b 	muleq	r0, fp, r2
     2e4:	00048004 	andeq	r8, r4, r4
     2e8:	00005200 	andeq	r5, r0, r0, lsl #4
     2ec:	00822c00 	addeq	r2, r2, r0, lsl #24
     2f0:	00004800 	andeq	r4, r0, r0, lsl #16
     2f4:	00023a00 	andeq	r3, r2, r0, lsl #20
     2f8:	08010200 	stmdaeq	r1, {r9}
     2fc:	00000443 	andeq	r0, r0, r3, asr #8
     300:	f7050202 			; <UNDEFINED> instruction: 0xf7050202
     304:	03000004 	movweq	r0, #4
     308:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
     30c:	01020074 	tsteq	r2, r4, ror r0
     310:	00043a08 	andeq	r3, r4, r8, lsl #20
     314:	07020200 	streq	r0, [r2, -r0, lsl #4]
     318:	0000046d 	andeq	r0, r0, sp, ror #8
     31c:	00044d04 	andeq	r4, r4, r4, lsl #26
     320:	07090600 	streq	r0, [r9, -r0, lsl #12]
     324:	00000059 	andeq	r0, r0, r9, asr r0
     328:	00004805 	andeq	r4, r0, r5, lsl #16
     32c:	07040200 	streq	r0, [r4, -r0, lsl #4]
     330:	000003f4 	strdeq	r0, [r0], -r4
     334:	0003c806 	andeq	ip, r3, r6, lsl #16
     338:	14050200 	strne	r0, [r5], #-512	; 0xfffffe00
     33c:	00000054 	andeq	r0, r0, r4, asr r0
     340:	93d40305 	bicsls	r0, r4, #335544320	; 0x14000000
     344:	56060000 	strpl	r0, [r6], -r0
     348:	02000004 	andeq	r0, r0, #4
     34c:	00541406 	subseq	r1, r4, r6, lsl #8
     350:	03050000 	movweq	r0, #20480	; 0x5000
     354:	000093d8 	ldrdeq	r9, [r0], -r8
     358:	00050106 	andeq	r0, r5, r6, lsl #2
     35c:	1a070300 	bne	1c0f64 <__bss_end+0x1b7b08>
     360:	00000054 	andeq	r0, r0, r4, asr r0
     364:	93dc0305 	bicsls	r0, ip, #335544320	; 0x14000000
     368:	b1060000 	mrslt	r0, (UNDEF: 6)
     36c:	03000003 	movweq	r0, #3
     370:	00541a09 	subseq	r1, r4, r9, lsl #20
     374:	03050000 	movweq	r0, #20480	; 0x5000
     378:	000093e0 	andeq	r9, r0, r0, ror #7
     37c:	00040106 	andeq	r0, r4, r6, lsl #2
     380:	1a0b0300 	bne	2c0f88 <__bss_end+0x2b7b2c>
     384:	00000054 	andeq	r0, r0, r4, asr r0
     388:	93e40305 	mvnls	r0, #335544320	; 0x14000000
     38c:	27060000 	strcs	r0, [r6, -r0]
     390:	03000004 	movweq	r0, #4
     394:	00541a0d 	subseq	r1, r4, sp, lsl #20
     398:	03050000 	movweq	r0, #20480	; 0x5000
     39c:	000093e8 	andeq	r9, r0, r8, ror #7
     3a0:	0003d606 	andeq	sp, r3, r6, lsl #12
     3a4:	1a0f0300 	bne	3c0fac <__bss_end+0x3b7b50>
     3a8:	00000054 	andeq	r0, r0, r4, asr r0
     3ac:	93ec0305 	mvnls	r0, #335544320	; 0x14000000
     3b0:	01020000 	mrseq	r0, (UNDEF: 2)
     3b4:	00040f02 	andeq	r0, r4, r2, lsl #30
     3b8:	04de0600 	ldrbeq	r0, [lr], #1536	; 0x600
     3bc:	04040000 	streq	r0, [r4], #-0
     3c0:	00005414 	andeq	r5, r0, r4, lsl r4
     3c4:	f0030500 			; <UNDEFINED> instruction: 0xf0030500
     3c8:	06000093 			; <UNDEFINED> instruction: 0x06000093
     3cc:	00000462 	andeq	r0, r0, r2, ror #8
     3d0:	54140704 	ldrpl	r0, [r4], #-1796	; 0xfffff8fc
     3d4:	05000000 	streq	r0, [r0, #-0]
     3d8:	0093f403 	addseq	pc, r3, r3, lsl #8
     3dc:	04140600 	ldreq	r0, [r4], #-1536	; 0xfffffa00
     3e0:	0a040000 	beq	1003e8 <__bss_end+0xf6f8c>
     3e4:	00005414 	andeq	r5, r0, r4, lsl r4
     3e8:	f8030500 			; <UNDEFINED> instruction: 0xf8030500
     3ec:	02000093 	andeq	r0, r0, #147	; 0x93
     3f0:	03ef0704 	mvneq	r0, #4, 14	; 0x100000
     3f4:	e0060000 	and	r0, r6, r0
     3f8:	05000003 	streq	r0, [r0, #-3]
     3fc:	0054140a 	subseq	r1, r4, sl, lsl #8
     400:	03050000 	movweq	r0, #20480	; 0x5000
     404:	000093fc 	strdeq	r9, [r0], -ip
     408:	00044807 	andeq	r4, r4, r7, lsl #16
     40c:	05050100 	streq	r0, [r5, #-256]	; 0xffffff00
     410:	00000033 	andeq	r0, r0, r3, lsr r0
     414:	0000822c 	andeq	r8, r0, ip, lsr #4
     418:	00000048 	andeq	r0, r0, r8, asr #32
     41c:	016d9c01 	cmneq	sp, r1, lsl #24
     420:	c3080000 	movwgt	r0, #32768	; 0x8000
     424:	01000003 	tsteq	r0, r3
     428:	00330e05 	eorseq	r0, r3, r5, lsl #28
     42c:	91020000 	mrsls	r0, (UNDEF: 2)
     430:	05170874 	ldreq	r0, [r7, #-2164]	; 0xfffff78c
     434:	05010000 	streq	r0, [r1, #-0]
     438:	00016d1b 	andeq	r6, r1, fp, lsl sp
     43c:	70910200 	addsvc	r0, r1, r0, lsl #4
     440:	73040900 	movwvc	r0, #18688	; 0x4900
     444:	09000001 	stmdbeq	r0, {r0}
     448:	00002504 	andeq	r2, r0, r4, lsl #10
     44c:	0ba50000 	bleq	fe940454 <__bss_end+0xfe936ff8>
     450:	00040000 	andeq	r0, r4, r0
     454:	00000269 	andeq	r0, r0, r9, ror #4
     458:	0acd0104 	beq	ff340870 <__bss_end+0xff337414>
     45c:	5f040000 	svcpl	0x00040000
     460:	b4000008 	strlt	r0, [r0], #-8
     464:	7400000c 	strvc	r0, [r0], #-12
     468:	5c000082 	stcpl	0, cr0, [r0], {130}	; 0x82
     46c:	59000004 	stmdbpl	r0, {r2}
     470:	02000004 	andeq	r0, r0, #4
     474:	04430801 	strbeq	r0, [r3], #-2049	; 0xfffff7ff
     478:	25030000 	strcs	r0, [r3, #-0]
     47c:	02000000 	andeq	r0, r0, #0
     480:	04f70502 	ldrbteq	r0, [r7], #1282	; 0x502
     484:	04040000 	streq	r0, [r4], #-0
     488:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
     48c:	08010200 	stmdaeq	r1, {r9}
     490:	0000043a 	andeq	r0, r0, sl, lsr r4
     494:	6d070202 	sfmvs	f0, 4, [r7, #-8]
     498:	05000004 	streq	r0, [r0, #-4]
     49c:	0000044d 	andeq	r0, r0, sp, asr #8
     4a0:	5e070907 	vmlapl.f16	s0, s14, s14	; <UNPREDICTABLE>
     4a4:	03000000 	movweq	r0, #0
     4a8:	0000004d 	andeq	r0, r0, sp, asr #32
     4ac:	f4070402 	vst3.8	{d0-d2}, [r7], r2
     4b0:	06000003 	streq	r0, [r0], -r3
     4b4:	00000726 	andeq	r0, r0, r6, lsr #14
     4b8:	08060208 	stmdaeq	r6, {r3, r9}
     4bc:	0000008b 	andeq	r0, r0, fp, lsl #1
     4c0:	00307207 	eorseq	r7, r0, r7, lsl #4
     4c4:	4d0e0802 	stcmi	8, cr0, [lr, #-8]
     4c8:	00000000 	andeq	r0, r0, r0
     4cc:	00317207 	eorseq	r7, r1, r7, lsl #4
     4d0:	4d0e0902 	vstrmi.16	s0, [lr, #-4]	; <UNPREDICTABLE>
     4d4:	04000000 	streq	r0, [r0], #-0
     4d8:	0ca30800 	stceq	8, cr0, [r3]
     4dc:	04050000 	streq	r0, [r5], #-0
     4e0:	00000038 	andeq	r0, r0, r8, lsr r0
     4e4:	a90c0d02 	stmdbge	ip, {r1, r8, sl, fp}
     4e8:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     4ec:	00004b4f 	andeq	r4, r0, pc, asr #22
     4f0:	0007530a 	andeq	r5, r7, sl, lsl #6
     4f4:	08000100 	stmdaeq	r0, {r8}
     4f8:	00000607 	andeq	r0, r0, r7, lsl #12
     4fc:	00380405 	eorseq	r0, r8, r5, lsl #8
     500:	1f020000 	svcne	0x00020000
     504:	0000e00c 	andeq	lr, r0, ip
     508:	07a50a00 	streq	r0, [r5, r0, lsl #20]!
     50c:	0a000000 	beq	514 <_start-0x7aec>
     510:	00000fd7 	ldrdeq	r0, [r0], -r7
     514:	0fb70a01 	svceq	0x00b70a01
     518:	0a020000 	beq	80520 <__bss_end+0x770c4>
     51c:	000009aa 	andeq	r0, r0, sl, lsr #19
     520:	0b820a03 	bleq	fe082d34 <__bss_end+0xfe0798d8>
     524:	0a040000 	beq	10052c <__bss_end+0xf70d0>
     528:	00000765 	andeq	r0, r0, r5, ror #14
     52c:	1b080005 	blne	200548 <__bss_end+0x1f70ec>
     530:	0500000f 	streq	r0, [r0, #-15]
     534:	00003804 	andeq	r3, r0, r4, lsl #16
     538:	0c400200 	sfmeq	f0, 2, [r0], {-0}
     53c:	0000011d 	andeq	r0, r0, sp, lsl r1
     540:	0005270a 	andeq	r2, r5, sl, lsl #14
     544:	1c0a0000 	stcne	0, cr0, [sl], {-0}
     548:	01000006 	tsteq	r0, r6
     54c:	000b700a 	andeq	r7, fp, sl
     550:	780a0200 	stmdavc	sl, {r9}
     554:	0300000f 	movweq	r0, #15
     558:	000fe10a 	andeq	lr, pc, sl, lsl #2
     55c:	8e0a0400 	cfcpyshi	mvf0, mvf10
     560:	0500000a 	streq	r0, [r0, #-10]
     564:	0009710a 	andeq	r7, r9, sl, lsl #2
     568:	08000600 	stmdaeq	r0, {r9, sl}
     56c:	00000c6f 	andeq	r0, r0, pc, ror #24
     570:	00380405 	eorseq	r0, r8, r5, lsl #8
     574:	66020000 	strvs	r0, [r2], -r0
     578:	0001360c 	andeq	r3, r1, ip, lsl #12
     57c:	0b7d0a00 	bleq	1f42d84 <__bss_end+0x1f39928>
     580:	00000000 	andeq	r0, r0, r0
     584:	000ed508 	andeq	sp, lr, r8, lsl #10
     588:	38040500 	stmdacc	r4, {r8, sl}
     58c:	02000000 	andeq	r0, r0, #0
     590:	01610c6f 	cmneq	r1, pc, ror #24
     594:	f70a0000 			; <UNDEFINED> instruction: 0xf70a0000
     598:	0000000b 	andeq	r0, r0, fp
     59c:	00092c0a 	andeq	r2, r9, sl, lsl #24
     5a0:	580a0100 	stmdapl	sl, {r8}
     5a4:	0200000c 	andeq	r0, r0, #12
     5a8:	0009760a 	andeq	r7, r9, sl, lsl #12
     5ac:	0b000300 	bleq	11b4 <_start-0x6e4c>
     5b0:	000003c8 	andeq	r0, r0, r8, asr #7
     5b4:	59140503 	ldmdbpl	r4, {r0, r1, r8, sl}
     5b8:	05000000 	streq	r0, [r0, #-0]
     5bc:	00940003 	addseq	r0, r4, r3
     5c0:	04560b00 	ldrbeq	r0, [r6], #-2816	; 0xfffff500
     5c4:	06030000 	streq	r0, [r3], -r0
     5c8:	00005914 	andeq	r5, r0, r4, lsl r9
     5cc:	04030500 	streq	r0, [r3], #-1280	; 0xfffffb00
     5d0:	0b000094 	bleq	828 <_start-0x77d8>
     5d4:	00000501 	andeq	r0, r0, r1, lsl #10
     5d8:	591a0704 	ldmdbpl	sl, {r2, r8, r9, sl}
     5dc:	05000000 	streq	r0, [r0, #-0]
     5e0:	00940803 	addseq	r0, r4, r3, lsl #16
     5e4:	03b10b00 			; <UNDEFINED> instruction: 0x03b10b00
     5e8:	09040000 	stmdbeq	r4, {}	; <UNPREDICTABLE>
     5ec:	0000591a 	andeq	r5, r0, sl, lsl r9
     5f0:	0c030500 	cfstr32eq	mvfx0, [r3], {-0}
     5f4:	0b000094 	bleq	84c <_start-0x77b4>
     5f8:	00000401 	andeq	r0, r0, r1, lsl #8
     5fc:	591a0b04 	ldmdbpl	sl, {r2, r8, r9, fp}
     600:	05000000 	streq	r0, [r0, #-0]
     604:	00941003 	addseq	r1, r4, r3
     608:	04270b00 	strteq	r0, [r7], #-2816	; 0xfffff500
     60c:	0d040000 	stceq	0, cr0, [r4, #-0]
     610:	0000591a 	andeq	r5, r0, sl, lsl r9
     614:	14030500 	strne	r0, [r3], #-1280	; 0xfffffb00
     618:	0b000094 	bleq	870 <_start-0x7790>
     61c:	000003d6 	ldrdeq	r0, [r0], -r6
     620:	591a0f04 	ldmdbpl	sl, {r2, r8, r9, sl, fp}
     624:	05000000 	streq	r0, [r0, #-0]
     628:	00941803 	addseq	r1, r4, r3, lsl #16
     62c:	0f9c0800 	svceq	0x009c0800
     630:	04050000 	streq	r0, [r5], #-0
     634:	00000038 	andeq	r0, r0, r8, lsr r0
     638:	040c1b04 	streq	r1, [ip], #-2820	; 0xfffff4fc
     63c:	0a000002 	beq	64c <_start-0x79b4>
     640:	00000d7f 	andeq	r0, r0, pc, ror sp
     644:	0fac0a00 	svceq	0x00ac0a00
     648:	0a010000 	beq	40650 <__bss_end+0x371f4>
     64c:	00000b6b 	andeq	r0, r0, fp, ror #22
     650:	f10c0002 	cps	#2
     654:	0200000b 	andeq	r0, r0, #11
     658:	040f0201 	streq	r0, [pc], #-513	; 660 <_start-0x79a0>
     65c:	040d0000 	streq	r0, [sp], #-0
     660:	0000002c 	andeq	r0, r0, ip, lsr #32
     664:	0204040d 	andeq	r0, r4, #218103808	; 0xd000000
     668:	de0b0000 	cdple	0, 0, cr0, cr11, cr0, {0}
     66c:	05000004 	streq	r0, [r0, #-4]
     670:	00591404 	subseq	r1, r9, r4, lsl #8
     674:	03050000 	movweq	r0, #20480	; 0x5000
     678:	0000941c 	andeq	r9, r0, ip, lsl r4
     67c:	0004620b 	andeq	r6, r4, fp, lsl #4
     680:	14070500 	strne	r0, [r7], #-1280	; 0xfffffb00
     684:	00000059 	andeq	r0, r0, r9, asr r0
     688:	94200305 	strtls	r0, [r0], #-773	; 0xfffffcfb
     68c:	140b0000 	strne	r0, [fp], #-0
     690:	05000004 	streq	r0, [r0, #-4]
     694:	0059140a 	subseq	r1, r9, sl, lsl #8
     698:	03050000 	movweq	r0, #20480	; 0x5000
     69c:	00009424 	andeq	r9, r0, r4, lsr #8
     6a0:	000a0508 	andeq	r0, sl, r8, lsl #10
     6a4:	38040500 	stmdacc	r4, {r8, sl}
     6a8:	05000000 	streq	r0, [r0, #-0]
     6ac:	02890c0d 	addeq	r0, r9, #3328	; 0xd00
     6b0:	4e090000 	cdpmi	0, 0, cr0, cr9, cr0, {0}
     6b4:	00007765 	andeq	r7, r0, r5, ror #14
     6b8:	0009fc0a 	andeq	pc, r9, sl, lsl #24
     6bc:	e70a0100 	str	r0, [sl, -r0, lsl #2]
     6c0:	0200000f 	andeq	r0, r0, #15
     6c4:	0009ce0a 	andeq	ip, r9, sl, lsl #28
     6c8:	9c0a0300 	stcls	3, cr0, [sl], {-0}
     6cc:	04000009 	streq	r0, [r0], #-9
     6d0:	000b760a 	andeq	r7, fp, sl, lsl #12
     6d4:	06000500 	streq	r0, [r0], -r0, lsl #10
     6d8:	00000758 	andeq	r0, r0, r8, asr r7
     6dc:	081b0510 	ldmdaeq	fp, {r4, r8, sl}
     6e0:	000002c8 	andeq	r0, r0, r8, asr #5
     6e4:	00726c07 	rsbseq	r6, r2, r7, lsl #24
     6e8:	c8131d05 	ldmdagt	r3, {r0, r2, r8, sl, fp, ip}
     6ec:	00000002 	andeq	r0, r0, r2
     6f0:	00707307 	rsbseq	r7, r0, r7, lsl #6
     6f4:	c8131e05 	ldmdagt	r3, {r0, r2, r9, sl, fp, ip}
     6f8:	04000002 	streq	r0, [r0], #-2
     6fc:	00637007 	rsbeq	r7, r3, r7
     700:	c8131f05 	ldmdagt	r3, {r0, r2, r8, r9, sl, fp, ip}
     704:	08000002 	stmdaeq	r0, {r1}
     708:	0007770e 	andeq	r7, r7, lr, lsl #14
     70c:	13200500 	nopne	{0}	; <UNPREDICTABLE>
     710:	000002c8 	andeq	r0, r0, r8, asr #5
     714:	0402000c 	streq	r0, [r2], #-12
     718:	0003ef07 	andeq	lr, r3, r7, lsl #30
     71c:	08140600 	ldmdaeq	r4, {r9, sl}
     720:	05800000 	streq	r0, [r0]
     724:	03920828 	orrseq	r0, r2, #40, 16	; 0x280000
     728:	730e0000 	movwvc	r0, #57344	; 0xe000
     72c:	0500000d 	streq	r0, [r0, #-13]
     730:	0289122a 	addeq	r1, r9, #-1610612734	; 0xa0000002
     734:	07000000 	streq	r0, [r0, -r0]
     738:	00646970 	rsbeq	r6, r4, r0, ror r9
     73c:	5e122b05 	vnmlspl.f64	d2, d2, d5
     740:	10000000 	andne	r0, r0, r0
     744:	0006610e 	andeq	r6, r6, lr, lsl #2
     748:	112c0500 			; <UNDEFINED> instruction: 0x112c0500
     74c:	00000252 	andeq	r0, r0, r2, asr r2
     750:	0a110e14 	beq	443fa8 <__bss_end+0x43ab4c>
     754:	2d050000 	stccs	0, cr0, [r5, #-0]
     758:	00005e12 	andeq	r5, r0, r2, lsl lr
     75c:	1f0e1800 	svcne	0x000e1800
     760:	0500000a 	streq	r0, [r0, #-10]
     764:	005e122e 	subseq	r1, lr, lr, lsr #4
     768:	0e1c0000 	cdpeq	0, 1, cr0, cr12, cr0, {0}
     76c:	00000746 	andeq	r0, r0, r6, asr #14
     770:	920c2f05 	andls	r2, ip, #5, 30
     774:	20000003 	andcs	r0, r0, r3
     778:	000a3b0e 	andeq	r3, sl, lr, lsl #22
     77c:	09300500 	ldmdbeq	r0!, {r8, sl}
     780:	00000038 	andeq	r0, r0, r8, lsr r0
     784:	0d900e60 	ldceq	14, cr0, [r0, #384]	; 0x180
     788:	31050000 	mrscc	r0, (UNDEF: 5)
     78c:	00004d0e 	andeq	r4, r0, lr, lsl #26
     790:	b60e6400 	strlt	r6, [lr], -r0, lsl #8
     794:	05000007 	streq	r0, [r0, #-7]
     798:	004d0e33 	subeq	r0, sp, r3, lsr lr
     79c:	0e680000 	cdpeq	0, 6, cr0, cr8, cr0, {0}
     7a0:	000007ad 	andeq	r0, r0, sp, lsr #15
     7a4:	4d0e3405 	cfstrsmi	mvf3, [lr, #-20]	; 0xffffffec
     7a8:	6c000000 	stcvs	0, cr0, [r0], {-0}
     7ac:	00747007 	rsbseq	r7, r4, r7
     7b0:	a20f3505 	andge	r3, pc, #20971520	; 0x1400000
     7b4:	70000003 	andvc	r0, r0, r3
     7b8:	000f7e0e 	andeq	r7, pc, lr, lsl #28
     7bc:	0e370500 	cfabs32eq	mvfx0, mvfx7
     7c0:	0000004d 	andeq	r0, r0, sp, asr #32
     7c4:	07320e74 			; <UNDEFINED> instruction: 0x07320e74
     7c8:	38050000 	stmdacc	r5, {}	; <UNPREDICTABLE>
     7cc:	00004d0e 	andeq	r4, r0, lr, lsl #26
     7d0:	fb0e7800 	blx	39e7da <__bss_end+0x39537e>
     7d4:	0500000c 	streq	r0, [r0, #-12]
     7d8:	004d0e39 	subeq	r0, sp, r9, lsr lr
     7dc:	007c0000 	rsbseq	r0, ip, r0
     7e0:	0002160f 	andeq	r1, r2, pc, lsl #12
     7e4:	0003a200 	andeq	sl, r3, r0, lsl #4
     7e8:	005e1000 	subseq	r1, lr, r0
     7ec:	000f0000 	andeq	r0, pc, r0
     7f0:	004d040d 	subeq	r0, sp, sp, lsl #8
     7f4:	e00b0000 	and	r0, fp, r0
     7f8:	06000003 	streq	r0, [r0], -r3
     7fc:	0059140a 	subseq	r1, r9, sl, lsl #8
     800:	03050000 	movweq	r0, #20480	; 0x5000
     804:	00009428 	andeq	r9, r0, r8, lsr #8
     808:	0009d608 	andeq	sp, r9, r8, lsl #12
     80c:	38040500 	stmdacc	r4, {r8, sl}
     810:	06000000 	streq	r0, [r0], -r0
     814:	03d90c0d 	bicseq	r0, r9, #3328	; 0xd00
     818:	210a0000 	mrscs	r0, (UNDEF: 10)
     81c:	00000006 	andeq	r0, r0, r6
     820:	00051c0a 	andeq	r1, r5, sl, lsl #24
     824:	03000100 	movweq	r0, #256	; 0x100
     828:	000003ba 			; <UNDEFINED> instruction: 0x000003ba
     82c:	000a6a08 	andeq	r6, sl, r8, lsl #20
     830:	38040500 	stmdacc	r4, {r8, sl}
     834:	06000000 	streq	r0, [r0], -r0
     838:	03fd0c14 	mvnseq	r0, #20, 24	; 0x1400
     83c:	660a0000 	strvs	r0, [sl], -r0
     840:	00000005 	andeq	r0, r0, r5
     844:	000c4a0a 	andeq	r4, ip, sl, lsl #20
     848:	03000100 	movweq	r0, #256	; 0x100
     84c:	000003de 	ldrdeq	r0, [r0], -lr
     850:	000e6406 	andeq	r6, lr, r6, lsl #8
     854:	1b060c00 	blne	18385c <__bss_end+0x17a400>
     858:	00043708 	andeq	r3, r4, r8, lsl #14
     85c:	05610e00 	strbeq	r0, [r1, #-3584]!	; 0xfffff200
     860:	1d060000 	stcne	0, cr0, [r6, #-0]
     864:	00043719 	andeq	r3, r4, r9, lsl r7
     868:	de0e0000 	cdple	0, 0, cr0, cr14, cr0, {0}
     86c:	06000005 	streq	r0, [r0], -r5
     870:	0437191e 	ldrteq	r1, [r7], #-2334	; 0xfffff6e2
     874:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
     878:	00000e18 	andeq	r0, r0, r8, lsl lr
     87c:	3d131f06 	ldccc	15, cr1, [r3, #-24]	; 0xffffffe8
     880:	08000004 	stmdaeq	r0, {r2}
     884:	02040d00 	andeq	r0, r4, #0, 26
     888:	0d000004 	stceq	0, cr0, [r0, #-16]
     88c:	0002cf04 	andeq	ip, r2, r4, lsl #30
     890:	06861100 	streq	r1, [r6], r0, lsl #2
     894:	06140000 	ldreq	r0, [r4], -r0
     898:	06f90722 	ldrbteq	r0, [r9], r2, lsr #14
     89c:	c40e0000 	strgt	r0, [lr], #-0
     8a0:	06000009 	streq	r0, [r0], -r9
     8a4:	004d1226 	subeq	r1, sp, r6, lsr #4
     8a8:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     8ac:	00000592 	muleq	r0, r2, r5
     8b0:	371d2906 	ldrcc	r2, [sp, -r6, lsl #18]
     8b4:	04000004 	streq	r0, [r0], #-4
     8b8:	000d4a0e 	andeq	r4, sp, lr, lsl #20
     8bc:	1d2c0600 	stcne	6, cr0, [ip, #-0]
     8c0:	00000437 	andeq	r0, r0, r7, lsr r4
     8c4:	0f111208 	svceq	0x00111208
     8c8:	2f060000 	svccs	0x00060000
     8cc:	000e410e 	andeq	r4, lr, lr, lsl #2
     8d0:	00048b00 	andeq	r8, r4, r0, lsl #22
     8d4:	00049600 	andeq	r9, r4, r0, lsl #12
     8d8:	06fe1300 	ldrbteq	r1, [lr], r0, lsl #6
     8dc:	37140000 	ldrcc	r0, [r4, -r0]
     8e0:	00000004 	andeq	r0, r0, r4
     8e4:	000e2915 	andeq	r2, lr, r5, lsl r9
     8e8:	0e310600 	cfmsuba32eq	mvax0, mvax0, mvfx1, mvfx0
     8ec:	000007eb 	andeq	r0, r0, fp, ror #15
     8f0:	00000209 	andeq	r0, r0, r9, lsl #4
     8f4:	000004ae 	andeq	r0, r0, lr, lsr #9
     8f8:	000004b9 			; <UNDEFINED> instruction: 0x000004b9
     8fc:	0006fe13 	andeq	pc, r6, r3, lsl lr	; <UNPREDICTABLE>
     900:	043d1400 	ldrteq	r1, [sp], #-1024	; 0xfffffc00
     904:	16000000 	strne	r0, [r0], -r0
     908:	00000e77 	andeq	r0, r0, r7, ror lr
     90c:	f31d3506 	vrshl.u16	d3, d6, d13
     910:	3700000d 	strcc	r0, [r0, -sp]
     914:	02000004 	andeq	r0, r0, #4
     918:	000004d2 	ldrdeq	r0, [r0], -r2
     91c:	000004d8 	ldrdeq	r0, [r0], -r8
     920:	0006fe13 	andeq	pc, r6, r3, lsl lr	; <UNPREDICTABLE>
     924:	64160000 	ldrvs	r0, [r6], #-0
     928:	06000009 	streq	r0, [r0], -r9
     92c:	0c141d37 	ldceq	13, cr1, [r4], {55}	; 0x37
     930:	04370000 	ldrteq	r0, [r7], #-0
     934:	f1020000 	cps	#0
     938:	f7000004 			; <UNDEFINED> instruction: 0xf7000004
     93c:	13000004 	movwne	r0, #4
     940:	000006fe 	strdeq	r0, [r0], -lr
     944:	0a4b1700 	beq	12c654c <__bss_end+0x12bd0f0>
     948:	39060000 	stmdbcc	r6, {}	; <UNPREDICTABLE>
     94c:	00071731 	andeq	r1, r7, r1, lsr r7
     950:	16020c00 	strne	r0, [r2], -r0, lsl #24
     954:	00000686 	andeq	r0, r0, r6, lsl #13
     958:	bd093c06 	stclt	12, cr3, [r9, #-24]	; 0xffffffe8
     95c:	fe00000f 	cdp2	0, 0, cr0, cr0, cr15, {0}
     960:	01000006 	tsteq	r0, r6
     964:	0000051e 	andeq	r0, r0, lr, lsl r5
     968:	00000524 	andeq	r0, r0, r4, lsr #10
     96c:	0006fe13 	andeq	pc, r6, r3, lsl lr	; <UNPREDICTABLE>
     970:	36160000 	ldrcc	r0, [r6], -r0
     974:	06000006 	streq	r0, [r0], -r6
     978:	0ee6123f 	mcreq	2, 7, r1, cr6, cr15, {1}
     97c:	004d0000 	subeq	r0, sp, r0
     980:	3d010000 	stccc	0, cr0, [r1, #-0]
     984:	52000005 	andpl	r0, r0, #5
     988:	13000005 	movwne	r0, #5
     98c:	000006fe 	strdeq	r0, [r0], -lr
     990:	00072014 	andeq	r2, r7, r4, lsl r0
     994:	005e1400 	subseq	r1, lr, r0, lsl #8
     998:	09140000 	ldmdbeq	r4, {}	; <UNPREDICTABLE>
     99c:	00000002 	andeq	r0, r0, r2
     9a0:	000e3818 	andeq	r3, lr, r8, lsl r8
     9a4:	0e420600 	cdpeq	6, 4, cr0, cr2, cr0, {0}
     9a8:	00000ba3 	andeq	r0, r0, r3, lsr #23
     9ac:	00056701 	andeq	r6, r5, r1, lsl #14
     9b0:	00056d00 	andeq	r6, r5, r0, lsl #26
     9b4:	06fe1300 	ldrbteq	r1, [lr], r0, lsl #6
     9b8:	16000000 	strne	r0, [r0], -r0
     9bc:	00000dc9 	andeq	r0, r0, r9, asr #27
     9c0:	aa174506 	bge	5d1de0 <__bss_end+0x5c8984>
     9c4:	3d000005 	stccc	0, cr0, [r0, #-20]	; 0xffffffec
     9c8:	01000004 	tsteq	r0, r4
     9cc:	00000586 	andeq	r0, r0, r6, lsl #11
     9d0:	0000058c 	andeq	r0, r0, ip, lsl #11
     9d4:	00072613 	andeq	r2, r7, r3, lsl r6
     9d8:	e3160000 	tst	r6, #0
     9dc:	06000005 	streq	r0, [r0], -r5
     9e0:	0d9c1748 	ldceq	7, cr1, [ip, #288]	; 0x120
     9e4:	043d0000 	ldrteq	r0, [sp], #-0
     9e8:	a5010000 	strge	r0, [r1, #-0]
     9ec:	b0000005 	andlt	r0, r0, r5
     9f0:	13000005 	movwne	r0, #5
     9f4:	00000726 	andeq	r0, r0, r6, lsr #14
     9f8:	00004d14 	andeq	r4, r0, r4, lsl sp
     9fc:	5d180000 	ldcpl	0, cr0, [r8, #-0]
     a00:	0600000f 	streq	r0, [r0], -pc
     a04:	052c0e4b 	streq	r0, [ip, #-3659]!	; 0xfffff1b5
     a08:	c5010000 	strgt	r0, [r1, #-0]
     a0c:	cb000005 	blgt	a28 <_start-0x75d8>
     a10:	13000005 	movwne	r0, #5
     a14:	000006fe 	strdeq	r0, [r0], -lr
     a18:	0e291600 	cfmadda32eq	mvax0, mvax1, mvfx9, mvfx0
     a1c:	4d060000 	stcmi	0, cr0, [r6, #-0]
     a20:	00077d0e 	andeq	r7, r7, lr, lsl #26
     a24:	00020900 	andeq	r0, r2, r0, lsl #18
     a28:	05e40100 	strbeq	r0, [r4, #256]!	; 0x100
     a2c:	05ef0000 	strbeq	r0, [pc, #0]!	; a34 <_start-0x75cc>
     a30:	fe130000 	cdp2	0, 1, cr0, cr3, cr0, {0}
     a34:	14000006 	strne	r0, [r0], #-6
     a38:	0000004d 	andeq	r0, r0, sp, asr #32
     a3c:	08c81600 	stmiaeq	r8, {r9, sl, ip}^
     a40:	50060000 	andpl	r0, r6, r0
     a44:	000bc412 	andeq	ip, fp, r2, lsl r4
     a48:	00004d00 	andeq	r4, r0, r0, lsl #26
     a4c:	06080100 	streq	r0, [r8], -r0, lsl #2
     a50:	06130000 	ldreq	r0, [r3], -r0
     a54:	fe130000 	cdp2	0, 1, cr0, cr3, cr0, {0}
     a58:	14000006 	strne	r0, [r0], #-6
     a5c:	00000216 	andeq	r0, r0, r6, lsl r2
     a60:	05731600 	ldrbeq	r1, [r3, #-1536]!	; 0xfffffa00
     a64:	53060000 	movwpl	r0, #24576	; 0x6000
     a68:	0007bf0e 	andeq	fp, r7, lr, lsl #30
     a6c:	00020900 	andeq	r0, r2, r0, lsl #18
     a70:	062c0100 	strteq	r0, [ip], -r0, lsl #2
     a74:	06370000 	ldrteq	r0, [r7], -r0
     a78:	fe130000 	cdp2	0, 1, cr0, cr3, cr0, {0}
     a7c:	14000006 	strne	r0, [r0], #-6
     a80:	0000004d 	andeq	r0, r0, sp, asr #32
     a84:	094b1800 	stmdbeq	fp, {fp, ip}^
     a88:	56060000 	strpl	r0, [r6], -r0
     a8c:	000e830e 	andeq	r8, lr, lr, lsl #6
     a90:	064c0100 	strbeq	r0, [ip], -r0, lsl #2
     a94:	066b0000 	strbteq	r0, [fp], -r0
     a98:	fe130000 	cdp2	0, 1, cr0, cr3, cr0, {0}
     a9c:	14000006 	strne	r0, [r0], #-6
     aa0:	000000a9 	andeq	r0, r0, r9, lsr #1
     aa4:	00004d14 	andeq	r4, r0, r4, lsl sp
     aa8:	004d1400 	subeq	r1, sp, r0, lsl #8
     aac:	4d140000 	ldcmi	0, cr0, [r4, #-0]
     ab0:	14000000 	strne	r0, [r0], #-0
     ab4:	0000072c 	andeq	r0, r0, ip, lsr #14
     ab8:	0ddd1800 	ldcleq	8, cr1, [sp]
     abc:	58060000 	stmdapl	r6, {}	; <UNPREDICTABLE>
     ac0:	0006da0e 	andeq	sp, r6, lr, lsl #20
     ac4:	06800100 	streq	r0, [r0], r0, lsl #2
     ac8:	069f0000 	ldreq	r0, [pc], r0
     acc:	fe130000 	cdp2	0, 1, cr0, cr3, cr0, {0}
     ad0:	14000006 	strne	r0, [r0], #-6
     ad4:	000000e0 	andeq	r0, r0, r0, ror #1
     ad8:	00004d14 	andeq	r4, r0, r4, lsl sp
     adc:	004d1400 	subeq	r1, sp, r0, lsl #8
     ae0:	4d140000 	ldcmi	0, cr0, [r4, #-0]
     ae4:	14000000 	strne	r0, [r0], #-0
     ae8:	0000072c 	andeq	r0, r0, ip, lsr #14
     aec:	0c021800 	stceq	8, cr1, [r2], {-0}
     af0:	5a060000 	bpl	180af8 <__bss_end+0x17769c>
     af4:	0008dc0e 	andeq	sp, r8, lr, lsl #24
     af8:	06b40100 	ldrteq	r0, [r4], r0, lsl #2
     afc:	06d30000 	ldrbeq	r0, [r3], r0
     b00:	fe130000 	cdp2	0, 1, cr0, cr3, cr0, {0}
     b04:	14000006 	strne	r0, [r0], #-6
     b08:	0000011d 	andeq	r0, r0, sp, lsl r1
     b0c:	00004d14 	andeq	r4, r0, r4, lsl sp
     b10:	004d1400 	subeq	r1, sp, r0, lsl #8
     b14:	4d140000 	ldcmi	0, cr0, [r4, #-0]
     b18:	14000000 	strne	r0, [r0], #-0
     b1c:	0000072c 	andeq	r0, r0, ip, lsr #14
     b20:	06731900 	ldrbteq	r1, [r3], -r0, lsl #18
     b24:	5d060000 	stcpl	0, cr0, [r6, #-0]
     b28:	0006970e 	andeq	r9, r6, lr, lsl #14
     b2c:	00020900 	andeq	r0, r2, r0, lsl #18
     b30:	06e80100 	strbteq	r0, [r8], r0, lsl #2
     b34:	fe130000 	cdp2	0, 1, cr0, cr3, cr0, {0}
     b38:	14000006 	strne	r0, [r0], #-6
     b3c:	000003ba 			; <UNDEFINED> instruction: 0x000003ba
     b40:	00073214 	andeq	r3, r7, r4, lsl r2
     b44:	03000000 	movweq	r0, #0
     b48:	00000443 	andeq	r0, r0, r3, asr #8
     b4c:	0443040d 	strbeq	r0, [r3], #-1037	; 0xfffffbf3
     b50:	371a0000 	ldrcc	r0, [sl, -r0]
     b54:	11000004 	tstne	r0, r4
     b58:	17000007 	strne	r0, [r0, -r7]
     b5c:	13000007 	movwne	r0, #7
     b60:	000006fe 	strdeq	r0, [r0], -lr
     b64:	04431b00 	strbeq	r1, [r3], #-2816	; 0xfffff500
     b68:	07040000 	streq	r0, [r4, -r0]
     b6c:	040d0000 	streq	r0, [sp], #-0
     b70:	0000003f 	andeq	r0, r0, pc, lsr r0
     b74:	06f9040d 	ldrbteq	r0, [r9], sp, lsl #8
     b78:	041c0000 	ldreq	r0, [ip], #-0
     b7c:	00000065 	andeq	r0, r0, r5, rrx
     b80:	2c0f041d 	cfstrscs	mvf0, [pc], {29}
     b84:	44000000 	strmi	r0, [r0], #-0
     b88:	10000007 	andne	r0, r0, r7
     b8c:	0000005e 	andeq	r0, r0, lr, asr r0
     b90:	34030009 	strcc	r0, [r3], #-9
     b94:	1e000007 	cdpne	0, 0, cr0, cr0, cr7, {0}
     b98:	000008b7 			; <UNDEFINED> instruction: 0x000008b7
     b9c:	440ca401 	strmi	sl, [ip], #-1025	; 0xfffffbff
     ba0:	05000007 	streq	r0, [r0, #-7]
     ba4:	00942c03 	addseq	r2, r4, r3, lsl #24
     ba8:	05a51f00 	streq	r1, [r5, #3840]!	; 0xf00
     bac:	a6010000 	strge	r0, [r1], -r0
     bb0:	000a5e0a 	andeq	r5, sl, sl, lsl #28
     bb4:	00004d00 	andeq	r4, r0, r0, lsl #26
     bb8:	00862000 	addeq	r2, r6, r0
     bbc:	0000b000 	andeq	fp, r0, r0
     bc0:	b99c0100 	ldmiblt	ip, {r8}
     bc4:	20000007 	andcs	r0, r0, r7
     bc8:	00000f58 	andeq	r0, r0, r8, asr pc
     bcc:	101ba601 	andsne	sl, fp, r1, lsl #12
     bd0:	03000002 	movweq	r0, #2
     bd4:	207fac91 			; <UNDEFINED> instruction: 0x207fac91
     bd8:	00000ac4 	andeq	r0, r0, r4, asr #21
     bdc:	4d2aa601 	stcmi	6, cr10, [sl, #-4]!
     be0:	03000000 	movweq	r0, #0
     be4:	1e7fa891 	mrcne	8, 3, sl, cr15, cr1, {4}
     be8:	000009f6 	strdeq	r0, [r0], -r6
     bec:	b90aa801 	stmdblt	sl, {r0, fp, sp, pc}
     bf0:	03000007 	movweq	r0, #7
     bf4:	1e7fb491 	mrcne	4, 3, fp, cr15, cr1, {4}
     bf8:	0000058d 	andeq	r0, r0, sp, lsl #11
     bfc:	3809ac01 	stmdacc	r9, {r0, sl, fp, sp, pc}
     c00:	02000000 	andeq	r0, r0, #0
     c04:	0f007491 	svceq	0x00007491
     c08:	00000025 	andeq	r0, r0, r5, lsr #32
     c0c:	000007c9 	andeq	r0, r0, r9, asr #15
     c10:	00005e10 	andeq	r5, r0, r0, lsl lr
     c14:	21003f00 	tstcs	r0, r0, lsl #30
     c18:	00000aa9 	andeq	r0, r0, r9, lsr #21
     c1c:	830a9801 	movwhi	r9, #43009	; 0xa801
     c20:	4d00000c 	stcmi	0, cr0, [r0, #-48]	; 0xffffffd0
     c24:	e4000000 	str	r0, [r0], #-0
     c28:	3c000085 	stccc	0, cr0, [r0], {133}	; 0x85
     c2c:	01000000 	mrseq	r0, (UNDEF: 0)
     c30:	0008069c 	muleq	r8, ip, r6
     c34:	65722200 	ldrbvs	r2, [r2, #-512]!	; 0xfffffe00
     c38:	9a010071 	bls	40e04 <__bss_end+0x379a8>
     c3c:	0003fd20 	andeq	pc, r3, r0, lsr #26
     c40:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     c44:	000a451e 	andeq	r4, sl, lr, lsl r5
     c48:	0e9b0100 	fmleqe	f0, f3, f0
     c4c:	0000004d 	andeq	r0, r0, sp, asr #32
     c50:	00709102 	rsbseq	r9, r0, r2, lsl #2
     c54:	000b9123 	andeq	r9, fp, r3, lsr #2
     c58:	068f0100 	streq	r0, [pc], r0, lsl #2
     c5c:	00000645 	andeq	r0, r0, r5, asr #12
     c60:	000085a8 	andeq	r8, r0, r8, lsr #11
     c64:	0000003c 	andeq	r0, r0, ip, lsr r0
     c68:	083f9c01 	ldmdaeq	pc!, {r0, sl, fp, ip, pc}	; <UNPREDICTABLE>
     c6c:	2d200000 	stccs	0, cr0, [r0, #-0]
     c70:	01000008 	tsteq	r0, r8
     c74:	004d218f 	subeq	r2, sp, pc, lsl #3
     c78:	91020000 	mrsls	r0, (UNDEF: 2)
     c7c:	6572226c 	ldrbvs	r2, [r2, #-620]!	; 0xfffffd94
     c80:	91010071 	tstls	r1, r1, ror r0
     c84:	0003fd20 	andeq	pc, r3, r0, lsr #26
     c88:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     c8c:	0a7f2100 	beq	1fc9094 <__bss_end+0x1fbfc38>
     c90:	83010000 	movwhi	r0, #4096	; 0x1000
     c94:	0009370a 	andeq	r3, r9, sl, lsl #14
     c98:	00004d00 	andeq	r4, r0, r0, lsl #26
     c9c:	00856c00 	addeq	r6, r5, r0, lsl #24
     ca0:	00003c00 	andeq	r3, r0, r0, lsl #24
     ca4:	7c9c0100 	ldfvcs	f0, [ip], {0}
     ca8:	22000008 	andcs	r0, r0, #8
     cac:	00716572 	rsbseq	r6, r1, r2, ror r5
     cb0:	d9208501 	stmdble	r0!, {r0, r8, sl, pc}
     cb4:	02000003 	andeq	r0, r0, #3
     cb8:	861e7491 			; <UNDEFINED> instruction: 0x861e7491
     cbc:	01000005 	tsteq	r0, r5
     cc0:	004d0e86 	subeq	r0, sp, r6, lsl #29
     cc4:	91020000 	mrsls	r0, (UNDEF: 2)
     cc8:	3b210070 	blcc	840e90 <__bss_end+0x837a34>
     ccc:	0100000f 	tsteq	r0, pc
     cd0:	08410a77 	stmdaeq	r1, {r0, r1, r2, r4, r5, r6, r9, fp}^
     cd4:	004d0000 	subeq	r0, sp, r0
     cd8:	85300000 	ldrhi	r0, [r0, #-0]!
     cdc:	003c0000 	eorseq	r0, ip, r0
     ce0:	9c010000 	stcls	0, cr0, [r1], {-0}
     ce4:	000008b9 			; <UNDEFINED> instruction: 0x000008b9
     ce8:	71657222 	cmnvc	r5, r2, lsr #4
     cec:	20790100 	rsbscs	r0, r9, r0, lsl #2
     cf0:	000003d9 	ldrdeq	r0, [r0], -r9
     cf4:	1e749102 	expnes	f1, f2
     cf8:	00000586 	andeq	r0, r0, r6, lsl #11
     cfc:	4d0e7a01 	vstrmi	s14, [lr, #-4]
     d00:	02000000 	andeq	r0, r0, #0
     d04:	21007091 	swpcs	r7, r1, [r0]
     d08:	0000095e 	andeq	r0, r0, lr, asr r9
     d0c:	3a066b01 	bcc	19b918 <__bss_end+0x1924bc>
     d10:	0900000c 	stmdbeq	r0, {r2, r3}
     d14:	dc000002 	stcle	0, cr0, [r0], {2}
     d18:	54000084 	strpl	r0, [r0], #-132	; 0xffffff7c
     d1c:	01000000 	mrseq	r0, (UNDEF: 0)
     d20:	0009059c 	muleq	r9, ip, r5
     d24:	0a452000 	beq	1148d2c <__bss_end+0x113f8d0>
     d28:	6b010000 	blvs	40d30 <__bss_end+0x378d4>
     d2c:	00004d15 	andeq	r4, r0, r5, lsl sp
     d30:	6c910200 	lfmvs	f0, 4, [r1], {0}
     d34:	0007ad20 	andeq	sl, r7, r0, lsr #26
     d38:	256b0100 	strbcs	r0, [fp, #-256]!	; 0xffffff00
     d3c:	0000004d 	andeq	r0, r0, sp, asr #32
     d40:	1e689102 	lgnnee	f1, f2
     d44:	00000f33 	andeq	r0, r0, r3, lsr pc
     d48:	4d0e6d01 	stcmi	13, cr6, [lr, #-4]
     d4c:	02000000 	andeq	r0, r0, #0
     d50:	21007491 			; <UNDEFINED> instruction: 0x21007491
     d54:	0000065c 	andeq	r0, r0, ip, asr r6
     d58:	14125e01 	ldrne	r5, [r2], #-3585	; 0xfffff1ff
     d5c:	8b00000d 	blhi	d98 <_start-0x7268>
     d60:	8c000000 	stchi	0, cr0, [r0], {-0}
     d64:	50000084 	andpl	r0, r0, r4, lsl #1
     d68:	01000000 	mrseq	r0, (UNDEF: 0)
     d6c:	0009609c 	muleq	r9, ip, r0
     d70:	0c452000 	mareq	acc0, r2, r5
     d74:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
     d78:	00004d20 	andeq	r4, r0, r0, lsr #26
     d7c:	6c910200 	lfmvs	f0, 4, [r1], {0}
     d80:	000a8820 	andeq	r8, sl, r0, lsr #16
     d84:	2f5e0100 	svccs	0x005e0100
     d88:	0000004d 	andeq	r0, r0, sp, asr #32
     d8c:	20689102 	rsbcs	r9, r8, r2, lsl #2
     d90:	000007ad 	andeq	r0, r0, sp, lsr #15
     d94:	4d3f5e01 	ldcmi	14, cr5, [pc, #-4]!	; d98 <_start-0x7268>
     d98:	02000000 	andeq	r0, r0, #0
     d9c:	331e6491 	tstcc	lr, #-1862270976	; 0x91000000
     da0:	0100000f 	tsteq	r0, pc
     da4:	008b1660 	addeq	r1, fp, r0, ror #12
     da8:	91020000 	mrsls	r0, (UNDEF: 2)
     dac:	5d210074 	stcpl	0, cr0, [r1, #-464]!	; 0xfffffe30
     db0:	0100000d 	tsteq	r0, sp
     db4:	06670a52 			; <UNDEFINED> instruction: 0x06670a52
     db8:	004d0000 	subeq	r0, sp, r0
     dbc:	84480000 	strbhi	r0, [r8], #-0
     dc0:	00440000 	subeq	r0, r4, r0
     dc4:	9c010000 	stcls	0, cr0, [r1], {-0}
     dc8:	000009ac 	andeq	r0, r0, ip, lsr #19
     dcc:	000c4520 	andeq	r4, ip, r0, lsr #10
     dd0:	1a520100 	bne	14811d8 <__bss_end+0x1477d7c>
     dd4:	0000004d 	andeq	r0, r0, sp, asr #32
     dd8:	206c9102 	rsbcs	r9, ip, r2, lsl #2
     ddc:	00000a88 	andeq	r0, r0, r8, lsl #21
     de0:	4d295201 	sfmmi	f5, 4, [r9, #-4]!
     de4:	02000000 	andeq	r0, r0, #0
     de8:	431e6891 	tstmi	lr, #9502720	; 0x910000
     dec:	0100000d 	tsteq	r0, sp
     df0:	004d0e54 	subeq	r0, sp, r4, asr lr
     df4:	91020000 	mrsls	r0, (UNDEF: 2)
     df8:	3d210074 	stccc	0, cr0, [r1, #-464]!	; 0xfffffe30
     dfc:	0100000d 	tsteq	r0, sp
     e00:	0d1f0a45 	vldreq	s0, [pc, #-276]	; cf4 <_start-0x730c>
     e04:	004d0000 	subeq	r0, sp, r0
     e08:	83f80000 	mvnshi	r0, #0
     e0c:	00500000 	subseq	r0, r0, r0
     e10:	9c010000 	stcls	0, cr0, [r1], {-0}
     e14:	00000a07 	andeq	r0, r0, r7, lsl #20
     e18:	000c4520 	andeq	r4, ip, r0, lsr #10
     e1c:	19450100 	stmdbne	r5, {r8}^
     e20:	0000004d 	andeq	r0, r0, sp, asr #32
     e24:	206c9102 	rsbcs	r9, ip, r2, lsl #2
     e28:	000009b0 			; <UNDEFINED> instruction: 0x000009b0
     e2c:	36304501 	ldrtcc	r4, [r0], -r1, lsl #10
     e30:	02000001 	andeq	r0, r0, #1
     e34:	95206891 	strls	r6, [r0, #-2193]!	; 0xfffff76f
     e38:	0100000a 	tsteq	r0, sl
     e3c:	07324145 	ldreq	r4, [r2, -r5, asr #2]!
     e40:	91020000 	mrsls	r0, (UNDEF: 2)
     e44:	0f331e64 	svceq	0x00331e64
     e48:	47010000 	strmi	r0, [r1, -r0]
     e4c:	00004d0e 	andeq	r4, r0, lr, lsl #26
     e50:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     e54:	055b2300 	ldrbeq	r2, [fp, #-768]	; 0xfffffd00
     e58:	3f010000 	svccc	0x00010000
     e5c:	0009ba06 	andeq	fp, r9, r6, lsl #20
     e60:	0083cc00 	addeq	ip, r3, r0, lsl #24
     e64:	00002c00 	andeq	r2, r0, r0, lsl #24
     e68:	319c0100 	orrscc	r0, ip, r0, lsl #2
     e6c:	2000000a 	andcs	r0, r0, sl
     e70:	00000c45 	andeq	r0, r0, r5, asr #24
     e74:	4d153f01 	ldcmi	15, cr3, [r5, #-4]
     e78:	02000000 	andeq	r0, r0, #0
     e7c:	21007491 			; <UNDEFINED> instruction: 0x21007491
     e80:	00000a35 	andeq	r0, r0, r5, lsr sl
     e84:	9b0a3201 	blls	28d690 <__bss_end+0x284234>
     e88:	4d00000a 	stcmi	0, cr0, [r0, #-40]	; 0xffffffd8
     e8c:	7c000000 	stcvc	0, cr0, [r0], {-0}
     e90:	50000083 	andpl	r0, r0, r3, lsl #1
     e94:	01000000 	mrseq	r0, (UNDEF: 0)
     e98:	000a8c9c 	muleq	sl, ip, ip
     e9c:	0c452000 	mareq	acc0, r2, r5
     ea0:	32010000 	andcc	r0, r1, #0
     ea4:	00004d19 	andeq	r4, r0, r9, lsl sp
     ea8:	6c910200 	lfmvs	f0, 4, [r1], {0}
     eac:	000d8920 	andeq	r8, sp, r0, lsr #18
     eb0:	2b320100 	blcs	c812b8 <__bss_end+0xc77e5c>
     eb4:	00000210 	andeq	r0, r0, r0, lsl r2
     eb8:	20689102 	rsbcs	r9, r8, r2, lsl #2
     ebc:	00000ac8 	andeq	r0, r0, r8, asr #21
     ec0:	4d3c3201 	lfmmi	f3, 4, [ip, #-4]!
     ec4:	02000000 	andeq	r0, r0, #0
     ec8:	0e1e6491 	cfcmpseq	r6, mvf14, mvf1
     ecc:	0100000d 	tsteq	r0, sp
     ed0:	004d0e34 	subeq	r0, sp, r4, lsr lr
     ed4:	91020000 	mrsls	r0, (UNDEF: 2)
     ed8:	73210074 			; <UNDEFINED> instruction: 0x73210074
     edc:	0100000f 	tsteq	r0, pc
     ee0:	0e1d0a25 	vnmlseq.f32	s0, s26, s11
     ee4:	004d0000 	subeq	r0, sp, r0
     ee8:	832c0000 			; <UNDEFINED> instruction: 0x832c0000
     eec:	00500000 	subseq	r0, r0, r0
     ef0:	9c010000 	stcls	0, cr0, [r1], {-0}
     ef4:	00000ae7 	andeq	r0, r0, r7, ror #21
     ef8:	000c4520 	andeq	r4, ip, r0, lsr #10
     efc:	18250100 	stmdane	r5!, {r8}
     f00:	0000004d 	andeq	r0, r0, sp, asr #32
     f04:	206c9102 	rsbcs	r9, ip, r2, lsl #2
     f08:	00000d89 	andeq	r0, r0, r9, lsl #27
     f0c:	ed2a2501 	cfstr32	mvfx2, [sl, #-4]!
     f10:	0200000a 	andeq	r0, r0, #10
     f14:	c8206891 	stmdagt	r0!, {r0, r4, r7, fp, sp, lr}
     f18:	0100000a 	tsteq	r0, sl
     f1c:	004d3b25 	subeq	r3, sp, r5, lsr #22
     f20:	91020000 	mrsls	r0, (UNDEF: 2)
     f24:	05d81e64 	ldrbeq	r1, [r8, #3684]	; 0xe64
     f28:	27010000 	strcs	r0, [r1, -r0]
     f2c:	00004d0e 	andeq	r4, r0, lr, lsl #26
     f30:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     f34:	25040d00 	strcs	r0, [r4, #-3328]	; 0xfffff300
     f38:	03000000 	movweq	r0, #0
     f3c:	00000ae7 	andeq	r0, r0, r7, ror #21
     f40:	000a5921 	andeq	r5, sl, r1, lsr #18
     f44:	0a190100 	beq	64134c <__bss_end+0x637ef0>
     f48:	00000f90 	muleq	r0, r0, pc	; <UNPREDICTABLE>
     f4c:	0000004d 	andeq	r0, r0, sp, asr #32
     f50:	000082e8 	andeq	r8, r0, r8, ror #5
     f54:	00000044 	andeq	r0, r0, r4, asr #32
     f58:	0b3e9c01 	bleq	fa7f64 <__bss_end+0xf9eb08>
     f5c:	54200000 	strtpl	r0, [r0], #-0
     f60:	0100000f 	tsteq	r0, pc
     f64:	02101b19 	andseq	r1, r0, #25600	; 0x6400
     f68:	91020000 	mrsls	r0, (UNDEF: 2)
     f6c:	0d6e206c 	stcleq	0, cr2, [lr, #-432]!	; 0xfffffe50
     f70:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
     f74:	0001df35 	andeq	sp, r1, r5, lsr pc
     f78:	68910200 	ldmvs	r1, {r9}
     f7c:	000c451e 	andeq	r4, ip, lr, lsl r5
     f80:	0e1b0100 	mufeqe	f0, f3, f0
     f84:	0000004d 	andeq	r0, r0, sp, asr #32
     f88:	00749102 	rsbseq	r9, r4, r2, lsl #2
     f8c:	00082124 	andeq	r2, r8, r4, lsr #2
     f90:	06140100 	ldreq	r0, [r4], -r0, lsl #2
     f94:	000005f6 	strdeq	r0, [r0], -r6
     f98:	000082cc 	andeq	r8, r0, ip, asr #5
     f9c:	0000001c 	andeq	r0, r0, ip, lsl r0
     fa0:	64239c01 	strtvs	r9, [r3], #-3073	; 0xfffff3ff
     fa4:	0100000d 	tsteq	r0, sp
     fa8:	098e060e 	stmibeq	lr, {r1, r2, r3, r9, sl}
     fac:	82a00000 	adchi	r0, r0, #0
     fb0:	002c0000 	eoreq	r0, ip, r0
     fb4:	9c010000 	stcls	0, cr0, [r1], {-0}
     fb8:	00000b7e 	andeq	r0, r0, lr, ror fp
     fbc:	00076e20 	andeq	r6, r7, r0, lsr #28
     fc0:	140e0100 	strne	r0, [lr], #-256	; 0xffffff00
     fc4:	00000038 	andeq	r0, r0, r8, lsr r0
     fc8:	00749102 	rsbseq	r9, r4, r2, lsl #2
     fcc:	000f8925 	andeq	r8, pc, r5, lsr #18
     fd0:	0a040100 	beq	1013d8 <__bss_end+0xf7f7c>
     fd4:	000009eb 	andeq	r0, r0, fp, ror #19
     fd8:	0000004d 	andeq	r0, r0, sp, asr #32
     fdc:	00008274 	andeq	r8, r0, r4, ror r2
     fe0:	0000002c 	andeq	r0, r0, ip, lsr #32
     fe4:	70229c01 	eorvc	r9, r2, r1, lsl #24
     fe8:	01006469 	tsteq	r0, r9, ror #8
     fec:	004d0e06 	subeq	r0, sp, r6, lsl #28
     ff0:	91020000 	mrsls	r0, (UNDEF: 2)
     ff4:	79000074 	stmdbvc	r0, {r2, r4, r5, r6}
     ff8:	04000005 	streq	r0, [r0], #-5
     ffc:	0004d200 	andeq	sp, r4, r0, lsl #4
    1000:	cd010400 	cfstrsgt	mvf0, [r1, #-0]
    1004:	0400000a 	streq	r0, [r0], #-10
    1008:	00001009 	andeq	r1, r0, r9
    100c:	00000cb4 			; <UNDEFINED> instruction: 0x00000cb4
    1010:	000086d0 	ldrdeq	r8, [r0], -r0
    1014:	00000c38 	andeq	r0, r0, r8, lsr ip
    1018:	00000715 	andeq	r0, r0, r5, lsl r7
    101c:	00004902 	andeq	r4, r0, r2, lsl #18
    1020:	11320300 	teqne	r2, r0, lsl #6
    1024:	07010000 	streq	r0, [r1, -r0]
    1028:	00006110 	andeq	r6, r0, r0, lsl r1
    102c:	31301100 	teqcc	r0, r0, lsl #2
    1030:	35343332 	ldrcc	r3, [r4, #-818]!	; 0xfffffcce
    1034:	39383736 	ldmdbcc	r8!, {r1, r2, r4, r5, r8, r9, sl, ip, sp}
    1038:	44434241 	strbmi	r4, [r3], #-577	; 0xfffffdbf
    103c:	00004645 	andeq	r4, r0, r5, asr #12
    1040:	01050104 	tsteq	r5, r4, lsl #2
    1044:	00000025 	andeq	r0, r0, r5, lsr #32
    1048:	00007405 	andeq	r7, r0, r5, lsl #8
    104c:	00006100 	andeq	r6, r0, r0, lsl #2
    1050:	00660600 	rsbeq	r0, r6, r0, lsl #12
    1054:	00100000 	andseq	r0, r0, r0
    1058:	00005107 	andeq	r5, r0, r7, lsl #2
    105c:	07040800 	streq	r0, [r4, -r0, lsl #16]
    1060:	000003f4 	strdeq	r0, [r0], -r4
    1064:	43080108 	movwmi	r0, #33032	; 0x8108
    1068:	07000004 	streq	r0, [r0, -r4]
    106c:	0000006d 	andeq	r0, r0, sp, rrx
    1070:	00002a09 	andeq	r2, r0, r9, lsl #20
    1074:	11500a00 	cmpne	r0, r0, lsl #20
    1078:	fd010000 	stc2	0, cr0, [r1, #-0]
    107c:	000ff906 	andeq	pc, pc, r6, lsl #18
    1080:	00928800 	addseq	r8, r2, r0, lsl #16
    1084:	00008000 	andeq	r8, r0, r0
    1088:	fd9c0100 	ldc2	1, cr0, [ip]
    108c:	0b000000 	bleq	1094 <_start-0x6f6c>
    1090:	00637273 	rsbeq	r7, r3, r3, ror r2
    1094:	fd19fd01 	ldc2	13, cr15, [r9, #-4]
    1098:	02000000 	andeq	r0, r0, #0
    109c:	640b6491 	strvs	r6, [fp], #-1169	; 0xfffffb6f
    10a0:	01007473 	tsteq	r0, r3, ror r4
    10a4:	010424fd 	strdeq	r2, [r4, -sp]
    10a8:	91020000 	mrsls	r0, (UNDEF: 2)
    10ac:	756e0b60 	strbvc	r0, [lr, #-2912]!	; 0xfffff4a0
    10b0:	fd01006d 	stc2	0, cr0, [r1, #-436]	; 0xfffffe4c
    10b4:	0001062d 	andeq	r0, r1, sp, lsr #12
    10b8:	5c910200 	lfmpl	f0, 4, [r1], {0}
    10bc:	0011430c 	andseq	r4, r1, ip, lsl #6
    10c0:	0eff0100 	cdpeq	1, 15, cr0, cr15, cr0, {0}
    10c4:	00000112 	andeq	r0, r0, r2, lsl r1
    10c8:	0d709102 	ldfeqp	f1, [r0, #-8]!
    10cc:	0000112b 	andeq	r1, r0, fp, lsr #2
    10d0:	08010001 	stmdaeq	r1, {r0}
    10d4:	00000118 	andeq	r0, r0, r8, lsl r1
    10d8:	0e6c9102 	lgneqe	f1, f2
    10dc:	000092b0 			; <UNDEFINED> instruction: 0x000092b0
    10e0:	00000048 	andeq	r0, r0, r8, asr #32
    10e4:	0100690f 	tsteq	r0, pc, lsl #18
    10e8:	060b0102 	streq	r0, [fp], -r2, lsl #2
    10ec:	02000001 	andeq	r0, r0, #1
    10f0:	00007491 	muleq	r0, r1, r4
    10f4:	01030410 	tsteq	r3, r0, lsl r4
    10f8:	12110000 	andsne	r0, r1, #0
    10fc:	05041304 	streq	r1, [r4, #-772]	; 0xfffffcfc
    1100:	00746e69 	rsbseq	r6, r4, r9, ror #28
    1104:	00010607 	andeq	r0, r1, r7, lsl #12
    1108:	74041000 	strvc	r1, [r4], #-0
    110c:	10000000 	andne	r0, r0, r0
    1110:	00006d04 	andeq	r6, r0, r4, lsl #26
    1114:	114a0a00 	cmpne	sl, r0, lsl #20
    1118:	f5010000 			; <UNDEFINED> instruction: 0xf5010000
    111c:	0010c406 	andseq	ip, r0, r6, lsl #8
    1120:	00922000 	addseq	r2, r2, r0
    1124:	00006800 	andeq	r6, r0, r0, lsl #16
    1128:	7d9c0100 	ldfvcs	f0, [ip]
    112c:	14000001 	strne	r0, [r0], #-1
    1130:	0000119b 	muleq	r0, fp, r1
    1134:	0412f501 	ldreq	pc, [r2], #-1281	; 0xfffffaff
    1138:	02000001 	andeq	r0, r0, #1
    113c:	a2146c91 	andsge	r6, r4, #37120	; 0x9100
    1140:	01000011 	tsteq	r0, r1, lsl r0
    1144:	01061ef5 	strdeq	r1, [r6, -r5]
    1148:	91020000 	mrsls	r0, (UNDEF: 2)
    114c:	656d1568 	strbvs	r1, [sp, #-1384]!	; 0xfffffa98
    1150:	f701006d 			; <UNDEFINED> instruction: 0xf701006d
    1154:	00011808 	andeq	r1, r1, r8, lsl #16
    1158:	70910200 	addsvc	r0, r1, r0, lsl #4
    115c:	00923c0e 	addseq	r3, r2, lr, lsl #24
    1160:	00003c00 	andeq	r3, r0, r0, lsl #24
    1164:	00691500 	rsbeq	r1, r9, r0, lsl #10
    1168:	060bf901 	streq	pc, [fp], -r1, lsl #18
    116c:	02000001 	andeq	r0, r0, #1
    1170:	00007491 	muleq	r0, r1, r4
    1174:	00108f16 	andseq	r8, r0, r6, lsl pc
    1178:	05eb0100 	strbeq	r0, [fp, #256]!	; 0x100
    117c:	0000116a 	andeq	r1, r0, sl, ror #2
    1180:	00000106 	andeq	r0, r0, r6, lsl #2
    1184:	000091cc 	andeq	r9, r0, ip, asr #3
    1188:	00000054 	andeq	r0, r0, r4, asr r0
    118c:	01b69c01 			; <UNDEFINED> instruction: 0x01b69c01
    1190:	730b0000 	movwvc	r0, #45056	; 0xb000
    1194:	18eb0100 	stmiane	fp!, {r8}^
    1198:	00000112 	andeq	r0, r0, r2, lsl r1
    119c:	156c9102 	strbne	r9, [ip, #-258]!	; 0xfffffefe
    11a0:	ed010069 	stc	0, cr0, [r1, #-420]	; 0xfffffe5c
    11a4:	00010606 	andeq	r0, r1, r6, lsl #12
    11a8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    11ac:	115c1600 	cmpne	ip, r0, lsl #12
    11b0:	db010000 	blle	411b8 <__bss_end+0x37d5c>
    11b4:	00117705 	andseq	r7, r1, r5, lsl #14
    11b8:	00010600 	andeq	r0, r1, r0, lsl #12
    11bc:	00912000 	addseq	r2, r1, r0
    11c0:	0000ac00 	andeq	sl, r0, r0, lsl #24
    11c4:	1c9c0100 	ldfnes	f0, [ip], {0}
    11c8:	0b000002 	bleq	11d8 <_start-0x6e28>
    11cc:	01003173 	tsteq	r0, r3, ror r1
    11d0:	011219db 			; <UNDEFINED> instruction: 0x011219db
    11d4:	91020000 	mrsls	r0, (UNDEF: 2)
    11d8:	32730b6c 	rsbscc	r0, r3, #108, 22	; 0x1b000
    11dc:	29db0100 	ldmibcs	fp, {r8}^
    11e0:	00000112 	andeq	r0, r0, r2, lsl r1
    11e4:	0b689102 	bleq	1a255f4 <__bss_end+0x1a1c198>
    11e8:	006d756e 	rsbeq	r7, sp, lr, ror #10
    11ec:	0631db01 	ldrteq	sp, [r1], -r1, lsl #22
    11f0:	02000001 	andeq	r0, r0, #1
    11f4:	75156491 	ldrvc	r6, [r5, #-1169]	; 0xfffffb6f
    11f8:	dd010031 	stcle	0, cr0, [r1, #-196]	; 0xffffff3c
    11fc:	00021c10 	andeq	r1, r2, r0, lsl ip
    1200:	77910200 	ldrvc	r0, [r1, r0, lsl #4]
    1204:	00327515 	eorseq	r7, r2, r5, lsl r5
    1208:	1c14dd01 	ldcne	13, cr13, [r4], {1}
    120c:	02000002 	andeq	r0, r0, #2
    1210:	08007691 	stmdaeq	r0, {r0, r4, r7, r9, sl, ip, sp, lr}
    1214:	043a0801 	ldrteq	r0, [sl], #-2049	; 0xfffff7ff
    1218:	bd160000 	ldclt	0, cr0, [r6, #-0]
    121c:	01000010 	tsteq	r0, r0, lsl r0
    1220:	110207cd 	smlabtne	r2, sp, r7, r0
    1224:	01180000 	tsteq	r8, r0
    1228:	904c0000 	subls	r0, ip, r0
    122c:	00d40000 	sbcseq	r0, r4, r0
    1230:	9c010000 	stcls	0, cr0, [r1], {-0}
    1234:	0000027a 	andeq	r0, r0, sl, ror r2
    1238:	0010a114 	andseq	sl, r0, r4, lsl r1
    123c:	14cd0100 	strbne	r0, [sp], #256	; 0x100
    1240:	00000118 	andeq	r0, r0, r8, lsl r1
    1244:	0b6c9102 	bleq	1b25654 <__bss_end+0x1b1c1f8>
    1248:	00637273 	rsbeq	r7, r3, r3, ror r2
    124c:	1226cd01 	eorne	ip, r6, #1, 26	; 0x40
    1250:	02000001 	andeq	r0, r0, #1
    1254:	69156891 	ldmdbvs	r5, {r0, r4, r7, fp, sp, lr}
    1258:	09cf0100 	stmibeq	pc, {r8}^	; <UNPREDICTABLE>
    125c:	00000106 	andeq	r0, r0, r6, lsl #2
    1260:	15749102 	ldrbne	r9, [r4, #-258]!	; 0xfffffefe
    1264:	cf01006a 	svcgt	0x0001006a
    1268:	0001060b 	andeq	r0, r1, fp, lsl #12
    126c:	70910200 	addsvc	r0, r1, r0, lsl #4
    1270:	10d81600 	sbcsne	r1, r8, r0, lsl #12
    1274:	c1010000 	mrsgt	r0, (UNDEF: 1)
    1278:	0010f107 	andseq	pc, r0, r7, lsl #2
    127c:	00011800 	andeq	r1, r1, r0, lsl #16
    1280:	008f8c00 	addeq	r8, pc, r0, lsl #24
    1284:	0000c000 	andeq	ip, r0, r0
    1288:	d39c0100 	orrsle	r0, ip, #0, 2
    128c:	14000002 	strne	r0, [r0], #-2
    1290:	000010a1 	andeq	r1, r0, r1, lsr #1
    1294:	1815c101 	ldmdane	r5, {r0, r8, lr, pc}
    1298:	02000001 	andeq	r0, r0, #1
    129c:	730b6c91 	movwvc	r6, #48273	; 0xbc91
    12a0:	01006372 	tsteq	r0, r2, ror r3
    12a4:	011227c1 	tsteq	r2, r1, asr #15
    12a8:	91020000 	mrsls	r0, (UNDEF: 2)
    12ac:	756e0b68 	strbvc	r0, [lr, #-2920]!	; 0xfffff498
    12b0:	c101006d 	tstgt	r1, sp, rrx
    12b4:	00010630 	andeq	r0, r1, r0, lsr r6
    12b8:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    12bc:	01006915 	tsteq	r0, r5, lsl r9
    12c0:	010606c3 	smlabteq	r6, r3, r6, r0
    12c4:	91020000 	mrsls	r0, (UNDEF: 2)
    12c8:	3e170074 	mrccc	0, 0, r0, cr7, cr4, {3}
    12cc:	01000011 	tsteq	r0, r1, lsl r0
    12d0:	10e0068b 	rscne	r0, r0, fp, lsl #13
    12d4:	8d540000 	ldclhi	0, cr0, [r4, #-0]
    12d8:	02380000 	eorseq	r0, r8, #0
    12dc:	9c010000 	stcls	0, cr0, [r1], {-0}
    12e0:	0000036f 	andeq	r0, r0, pc, ror #6
    12e4:	000d8914 	andeq	r8, sp, r4, lsl r9
    12e8:	118b0100 	orrne	r0, fp, r0, lsl #2
    12ec:	00000118 	andeq	r0, r0, r8, lsl r1
    12f0:	145c9102 	ldrbne	r9, [ip], #-258	; 0xfffffefe
    12f4:	0000106f 	andeq	r1, r0, pc, rrx
    12f8:	6f1f8b01 	svcvs	0x001f8b01
    12fc:	02000003 	andeq	r0, r0, #3
    1300:	810c5891 			; <UNDEFINED> instruction: 0x810c5891
    1304:	01000010 	tsteq	r0, r0, lsl r0
    1308:	01060994 			; <UNDEFINED> instruction: 0x01060994
    130c:	91020000 	mrsls	r0, (UNDEF: 2)
    1310:	11a90c74 			; <UNDEFINED> instruction: 0x11a90c74
    1314:	95010000 	strls	r0, [r1, #-0]
    1318:	00010609 	andeq	r0, r1, r9, lsl #12
    131c:	70910200 	addsvc	r0, r1, r0, lsl #4
    1320:	0011640c 	andseq	r6, r1, ip, lsl #8
    1324:	0f960100 	svceq	0x00960100
    1328:	0000010d 	andeq	r0, r0, sp, lsl #2
    132c:	186c9102 	stmdane	ip!, {r1, r8, ip, pc}^
    1330:	00008dfc 	strdeq	r8, [r0], -ip
    1334:	00000070 	andeq	r0, r0, r0, ror r0
    1338:	00000355 	andeq	r0, r0, r5, asr r3
    133c:	0011200c 	andseq	r2, r1, ip
    1340:	0da60100 	stfeqs	f0, [r6]
    1344:	00000106 	andeq	r0, r0, r6, lsl #2
    1348:	00689102 	rsbeq	r9, r8, r2, lsl #2
    134c:	008ef80e 	addeq	pc, lr, lr, lsl #16
    1350:	00007000 	andeq	r7, r0, r0
    1354:	11200c00 			; <UNDEFINED> instruction: 0x11200c00
    1358:	b9010000 	stmdblt	r1, {}	; <UNPREDICTABLE>
    135c:	0001060d 	andeq	r0, r1, sp, lsl #12
    1360:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1364:	04080000 	streq	r0, [r8], #-0
    1368:	00106304 	andseq	r6, r0, r4, lsl #6
    136c:	11261600 			; <UNDEFINED> instruction: 0x11261600
    1370:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    1374:	00109607 	andseq	r9, r0, r7, lsl #12
    1378:	00036f00 	andeq	r6, r3, r0, lsl #30
    137c:	008a9c00 	addeq	r9, sl, r0, lsl #24
    1380:	0002b800 	andeq	fp, r2, r0, lsl #16
    1384:	ef9c0100 	svc	0x009c0100
    1388:	0b000003 	bleq	139c <_start-0x6c64>
    138c:	5e010073 	mcrpl	0, 0, r0, cr1, cr3, {3}
    1390:	00011218 	andeq	r1, r1, r8, lsl r2
    1394:	5c910200 	lfmpl	f0, 4, [r1], {0}
    1398:	01006115 	tsteq	r0, r5, lsl r1
    139c:	036f0964 	cmneq	pc, #100, 18	; 0x190000
    13a0:	91020000 	mrsls	r0, (UNDEF: 2)
    13a4:	00651574 	rsbeq	r1, r5, r4, ror r5
    13a8:	06076501 	streq	r6, [r7], -r1, lsl #10
    13ac:	02000001 	andeq	r0, r0, #1
    13b0:	63157091 	tstvs	r5, #145	; 0x91
    13b4:	07660100 	strbeq	r0, [r6, -r0, lsl #2]!
    13b8:	00000106 	andeq	r0, r0, r6, lsl #2
    13bc:	0e6c9102 	lgneqe	f1, f2
    13c0:	00008be4 	andeq	r8, r0, r4, ror #23
    13c4:	000000e0 	andeq	r0, r0, r0, ror #1
    13c8:	0010b30c 	andseq	fp, r0, ip, lsl #6
    13cc:	09710100 	ldmdbeq	r1!, {r8}^
    13d0:	00000106 	andeq	r0, r0, r6, lsl #2
    13d4:	15689102 	strbne	r9, [r8, #-258]!	; 0xfffffefe
    13d8:	72010069 	andvc	r0, r1, #105	; 0x69
    13dc:	00010609 	andeq	r0, r1, r9, lsl #12
    13e0:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    13e4:	69190000 	ldmdbvs	r9, {}	; <UNPREDICTABLE>
    13e8:	01000010 	tsteq	r0, r0, lsl r0
    13ec:	10a6064d 	adcne	r0, r6, sp, asr #12
    13f0:	04670000 	strbteq	r0, [r7], #-0
    13f4:	89c00000 	stmibhi	r0, {}^	; <UNPREDICTABLE>
    13f8:	00dc0000 	sbcseq	r0, ip, r0
    13fc:	9c010000 	stcls	0, cr0, [r1], {-0}
    1400:	00000467 	andeq	r0, r0, r7, ror #8
    1404:	0100730b 	tsteq	r0, fp, lsl #6
    1408:	0112184d 	tsteq	r2, sp, asr #16
    140c:	91020000 	mrsls	r0, (UNDEF: 2)
    1410:	10d01464 	sbcsne	r1, r0, r4, ror #8
    1414:	4d010000 	stcmi	0, cr0, [r1, #-0]
    1418:	00046720 	andeq	r6, r4, r0, lsr #14
    141c:	63910200 	orrsvs	r0, r1, #0, 4
    1420:	0011a20c 	andseq	sl, r1, ip, lsl #4
    1424:	074f0100 	strbeq	r0, [pc, -r0, lsl #2]
    1428:	00000106 	andeq	r0, r0, r6, lsl #2
    142c:	0e709102 	expeqs	f1, f2
    1430:	000089f8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
    1434:	00000094 	muleq	r0, r4, r0
    1438:	01006915 	tsteq	r0, r5, lsl r9
    143c:	01060b54 	tsteq	r6, r4, asr fp
    1440:	91020000 	mrsls	r0, (UNDEF: 2)
    1444:	8a280e74 	bhi	a04e1c <__bss_end+0x9fb9c0>
    1448:	00540000 	subseq	r0, r4, r0
    144c:	63150000 	tstvs	r5, #0
    1450:	08550100 	ldmdaeq	r5, {r8}^
    1454:	0000006d 	andeq	r0, r0, sp, rrx
    1458:	006f9102 	rsbeq	r9, pc, r2, lsl #2
    145c:	01080000 	mrseq	r0, (UNDEF: 8)
    1460:	00040f02 	andeq	r0, r4, r2, lsl #30
    1464:	0fef1600 	svceq	0x00ef1600
    1468:	3c010000 	stccc	0, cr0, [r1], {-0}
    146c:	00111105 	andseq	r1, r1, r5, lsl #2
    1470:	00010600 	andeq	r0, r1, r0, lsl #12
    1474:	0088fc00 	addeq	pc, r8, r0, lsl #24
    1478:	0000c400 	andeq	ip, r0, r0, lsl #8
    147c:	ba9c0100 	blt	fe701884 <__bss_end+0xfe6f8428>
    1480:	0b000004 	bleq	1498 <_start-0x6b68>
    1484:	006c6176 	rsbeq	r6, ip, r6, ror r1
    1488:	ba163c01 	blt	590494 <__bss_end+0x587038>
    148c:	02000004 	andeq	r0, r0, #4
    1490:	810c6c91 			; <UNDEFINED> instruction: 0x810c6c91
    1494:	01000010 	tsteq	r0, r0, lsl r0
    1498:	0106093d 	tsteq	r6, sp, lsr r9
    149c:	91020000 	mrsls	r0, (UNDEF: 2)
    14a0:	106f0c74 	rsbne	r0, pc, r4, ror ip	; <UNPREDICTABLE>
    14a4:	3e010000 	cdpcc	0, 0, cr0, cr1, cr0, {0}
    14a8:	00036f0b 	andeq	r6, r3, fp, lsl #30
    14ac:	70910200 	addsvc	r0, r1, r0, lsl #4
    14b0:	6f041000 	svcvs	0x00041000
    14b4:	19000003 	stmdbne	r0, {r0, r1}
    14b8:	0000108a 	andeq	r1, r0, sl, lsl #1
    14bc:	89052601 	stmdbhi	r5, {r0, r9, sl, sp}
    14c0:	06000011 			; <UNDEFINED> instruction: 0x06000011
    14c4:	44000001 	strmi	r0, [r0], #-1
    14c8:	b8000088 	stmdalt	r0, {r3, r7}
    14cc:	01000000 	mrseq	r0, (UNDEF: 0)
    14d0:	0004fd9c 	muleq	r4, ip, sp
    14d4:	10eb1400 	rscne	r1, fp, r0, lsl #8
    14d8:	26010000 	strcs	r0, [r1], -r0
    14dc:	00011216 	andeq	r1, r1, r6, lsl r2
    14e0:	6c910200 	lfmvs	f0, 4, [r1], {0}
    14e4:	0011940c 	andseq	r9, r1, ip, lsl #8
    14e8:	06280100 	strteq	r0, [r8], -r0, lsl #2
    14ec:	00000106 	andeq	r0, r0, r6, lsl #2
    14f0:	00749102 	rsbseq	r9, r4, r2, lsl #2
    14f4:	0010b81a 	andseq	fp, r0, sl, lsl r8
    14f8:	060a0100 	streq	r0, [sl], -r0, lsl #2
    14fc:	00001075 	andeq	r1, r0, r5, ror r0
    1500:	000086d0 	ldrdeq	r8, [r0], -r0
    1504:	00000174 	andeq	r0, r0, r4, ror r1
    1508:	eb149c01 	bl	528514 <__bss_end+0x51f0b8>
    150c:	01000010 	tsteq	r0, r0, lsl r0
    1510:	0066180a 	rsbeq	r1, r6, sl, lsl #16
    1514:	91020000 	mrsls	r0, (UNDEF: 2)
    1518:	11941464 	orrsne	r1, r4, r4, ror #8
    151c:	0a010000 	beq	41524 <__bss_end+0x380c8>
    1520:	00011825 	andeq	r1, r1, r5, lsr #16
    1524:	60910200 	addsvs	r0, r1, r0, lsl #4
    1528:	00115714 	andseq	r5, r1, r4, lsl r7
    152c:	3a0a0100 	bcc	281934 <__bss_end+0x2784d8>
    1530:	00000066 	andeq	r0, r0, r6, rrx
    1534:	155c9102 	ldrbne	r9, [ip, #-258]	; 0xfffffefe
    1538:	0c010069 	stceq	0, cr0, [r1], {105}	; 0x69
    153c:	00010606 	andeq	r0, r1, r6, lsl #12
    1540:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1544:	00879c0e 	addeq	r9, r7, lr, lsl #24
    1548:	00009800 	andeq	r9, r0, r0, lsl #16
    154c:	006a1500 	rsbeq	r1, sl, r0, lsl #10
    1550:	060b1e01 	streq	r1, [fp], -r1, lsl #28
    1554:	02000001 	andeq	r0, r0, #1
    1558:	c40e7091 	strgt	r7, [lr], #-145	; 0xffffff6f
    155c:	60000087 	andvs	r0, r0, r7, lsl #1
    1560:	15000000 	strne	r0, [r0, #-0]
    1564:	20010063 	andcs	r0, r1, r3, rrx
    1568:	00006d08 	andeq	r6, r0, r8, lsl #26
    156c:	6f910200 	svcvs	0x00910200
    1570:	00000000 	andeq	r0, r0, r0

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x3777b8>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb98c0>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb98e0>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb98f8>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <_Z6strcatPcPKc+0x44>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe7a438>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe3991c>
  88:	06120111 			; <UNDEFINED> instruction: 0x06120111
  8c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  90:	00130119 	andseq	r0, r3, r9, lsl r1
  94:	010b0800 	tsteq	fp, r0, lsl #16
  98:	06120111 			; <UNDEFINED> instruction: 0x06120111
  9c:	34090000 	strcc	r0, [r9], #-0
  a0:	3a080300 	bcc	200ca8 <__bss_end+0x1f784c>
  a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  a8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
  ac:	0a000018 	beq	114 <_start-0x7eec>
  b0:	0b0b000f 	bleq	2c00f4 <__bss_end+0x2b6c98>
  b4:	00001349 	andeq	r1, r0, r9, asr #6
  b8:	01110100 	tsteq	r1, r0, lsl #2
  bc:	0b130e25 	bleq	4c3958 <__bss_end+0x4ba4fc>
  c0:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
  c4:	06120111 			; <UNDEFINED> instruction: 0x06120111
  c8:	00001710 	andeq	r1, r0, r0, lsl r7
  cc:	03001602 	movweq	r1, #1538	; 0x602
  d0:	3b0b3a0e 	blcc	2ce910 <__bss_end+0x2c54b4>
  d4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  d8:	03000013 	movweq	r0, #19
  dc:	0b0b000f 	bleq	2c0120 <__bss_end+0x2b6cc4>
  e0:	00001349 	andeq	r1, r0, r9, asr #6
  e4:	00001504 	andeq	r1, r0, r4, lsl #10
  e8:	01010500 	tsteq	r1, r0, lsl #10
  ec:	13011349 	movwne	r1, #4937	; 0x1349
  f0:	21060000 	mrscs	r0, (UNDEF: 6)
  f4:	2f134900 	svccs	0x00134900
  f8:	07000006 	streq	r0, [r0, -r6]
  fc:	0b0b0024 	bleq	2c0194 <__bss_end+0x2b6d38>
 100:	0e030b3e 	vmoveq.16	d3[0], r0
 104:	34080000 	strcc	r0, [r8], #-0
 108:	3a0e0300 	bcc	380d10 <__bss_end+0x3778b4>
 10c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 110:	3f13490b 	svccc	0x0013490b
 114:	00193c19 	andseq	r3, r9, r9, lsl ip
 118:	012e0900 			; <UNDEFINED> instruction: 0x012e0900
 11c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb99b4>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	06120111 			; <UNDEFINED> instruction: 0x06120111
 12c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 130:	00130119 	andseq	r0, r3, r9, lsl r1
 134:	00340a00 	eorseq	r0, r4, r0, lsl #20
 138:	0b3a0e03 	bleq	e8394c <__bss_end+0xe7a4f0>
 13c:	0b390b3b 	bleq	e42e30 <__bss_end+0xe399d4>
 140:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 144:	240b0000 	strcs	r0, [fp], #-0
 148:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 14c:	0008030b 	andeq	r0, r8, fp, lsl #6
 150:	002e0c00 	eoreq	r0, lr, r0, lsl #24
 154:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 158:	0b3b0b3a 	bleq	ec2e48 <__bss_end+0xeb99ec>
 15c:	01110b39 	tsteq	r1, r9, lsr fp
 160:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 164:	00194297 	mulseq	r9, r7, r2
 168:	01390d00 	teqeq	r9, r0, lsl #26
 16c:	0b3a0e03 	bleq	e83980 <__bss_end+0xe7a524>
 170:	13010b3b 	movwne	r0, #6971	; 0x1b3b
 174:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c5560>
 180:	3c0b390b 			; <UNDEFINED> instruction: 0x3c0b390b
 184:	00130119 	andseq	r0, r3, r9, lsl r1
 188:	00050f00 	andeq	r0, r5, r0, lsl #30
 18c:	00001349 	andeq	r1, r0, r9, asr #6
 190:	3f012e10 	svccc	0x00012e10
 194:	3a0e0319 	bcc	380e00 <__bss_end+0x3779a4>
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
 1c0:	3a080300 	bcc	200dc8 <__bss_end+0x1f796c>
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
 1f4:	0b0b0024 	bleq	2c028c <__bss_end+0x2b6e30>
 1f8:	0e030b3e 	vmoveq.16	d3[0], r0
 1fc:	24030000 	strcs	r0, [r3], #-0
 200:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 204:	0008030b 	andeq	r0, r8, fp, lsl #6
 208:	00160400 	andseq	r0, r6, r0, lsl #8
 20c:	0b3a0e03 	bleq	e83a20 <__bss_end+0xe7a5c4>
 210:	0b390b3b 	bleq	e42f04 <__bss_end+0xe39aa8>
 214:	00001349 	andeq	r1, r0, r9, asr #6
 218:	49002605 	stmdbmi	r0, {r0, r2, r9, sl, sp}
 21c:	06000013 			; <UNDEFINED> instruction: 0x06000013
 220:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 224:	0b3b0b3a 	bleq	ec2f14 <__bss_end+0xeb9ab8>
 228:	13490b39 	movtne	r0, #39737	; 0x9b39
 22c:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 230:	2e070000 	cdpcs	0, 0, cr0, cr7, cr0, {0}
 234:	03193f01 	tsteq	r9, #1, 30
 238:	3b0b3a0e 	blcc	2cea78 <__bss_end+0x2c561c>
 23c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 240:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 244:	96184006 	ldrls	r4, [r8], -r6
 248:	13011942 	movwne	r1, #6466	; 0x1942
 24c:	05080000 	streq	r0, [r8, #-0]
 250:	3a0e0300 	bcc	380e58 <__bss_end+0x3779fc>
 254:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 258:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 25c:	09000018 	stmdbeq	r0, {r3, r4}
 260:	0b0b000f 	bleq	2c02a4 <__bss_end+0x2b6e48>
 264:	00001349 	andeq	r1, r0, r9, asr #6
 268:	01110100 	tsteq	r1, r0, lsl #2
 26c:	0b130e25 	bleq	4c3b08 <__bss_end+0x4ba6ac>
 270:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 274:	06120111 			; <UNDEFINED> instruction: 0x06120111
 278:	00001710 	andeq	r1, r0, r0, lsl r7
 27c:	0b002402 	bleq	928c <_Z6memcpyPKvPvi+0x4>
 280:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 284:	0300000e 	movweq	r0, #14
 288:	13490026 	movtne	r0, #36902	; 0x9026
 28c:	24040000 	strcs	r0, [r4], #-0
 290:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 294:	0008030b 	andeq	r0, r8, fp, lsl #6
 298:	00160500 	andseq	r0, r6, r0, lsl #10
 29c:	0b3a0e03 	bleq	e83ab0 <__bss_end+0xe7a654>
 2a0:	0b390b3b 	bleq	e42f94 <__bss_end+0xe39b38>
 2a4:	00001349 	andeq	r1, r0, r9, asr #6
 2a8:	03011306 	movweq	r1, #4870	; 0x1306
 2ac:	3a0b0b0e 	bcc	2c2eec <__bss_end+0x2b9a90>
 2b0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2b4:	0013010b 	andseq	r0, r3, fp, lsl #2
 2b8:	000d0700 	andeq	r0, sp, r0, lsl #14
 2bc:	0b3a0803 	bleq	e822d0 <__bss_end+0xe78e74>
 2c0:	0b390b3b 	bleq	e42fb4 <__bss_end+0xe39b58>
 2c4:	0b381349 	bleq	e04ff0 <__bss_end+0xdfbb94>
 2c8:	04080000 	streq	r0, [r8], #-0
 2cc:	6d0e0301 	stcvs	3, cr0, [lr, #-4]
 2d0:	0b0b3e19 	bleq	2cfb3c <__bss_end+0x2c66e0>
 2d4:	3a13490b 	bcc	4d2708 <__bss_end+0x4c92ac>
 2d8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2dc:	0013010b 	andseq	r0, r3, fp, lsl #2
 2e0:	00280900 	eoreq	r0, r8, r0, lsl #18
 2e4:	0b1c0803 	bleq	7022f8 <__bss_end+0x6f8e9c>
 2e8:	280a0000 	stmdacs	sl, {}	; <UNPREDICTABLE>
 2ec:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 2f0:	0b00000b 	bleq	324 <_start-0x7cdc>
 2f4:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 2f8:	0b3b0b3a 	bleq	ec2fe8 <__bss_end+0xeb9b8c>
 2fc:	13490b39 	movtne	r0, #39737	; 0x9b39
 300:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 304:	020c0000 	andeq	r0, ip, #0
 308:	3c0e0300 	stccc	3, cr0, [lr], {-0}
 30c:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 310:	0b0b000f 	bleq	2c0354 <__bss_end+0x2b6ef8>
 314:	00001349 	andeq	r1, r0, r9, asr #6
 318:	03000d0e 	movweq	r0, #3342	; 0xd0e
 31c:	3b0b3a0e 	blcc	2ceb5c <__bss_end+0x2c5700>
 320:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 324:	000b3813 	andeq	r3, fp, r3, lsl r8
 328:	01010f00 	tsteq	r1, r0, lsl #30
 32c:	13011349 	movwne	r1, #4937	; 0x1349
 330:	21100000 	tstcs	r0, r0
 334:	2f134900 	svccs	0x00134900
 338:	1100000b 	tstne	r0, fp
 33c:	0e030102 	adfeqs	f0, f3, f2
 340:	0b3a0b0b 	bleq	e82f74 <__bss_end+0xe79b18>
 344:	0b390b3b 	bleq	e43038 <__bss_end+0xe39bdc>
 348:	00001301 	andeq	r1, r0, r1, lsl #6
 34c:	3f012e12 	svccc	0x00012e12
 350:	3a0e0319 	bcc	380fbc <__bss_end+0x377b60>
 354:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 358:	3c0e6e0b 	stccc	14, cr6, [lr], {11}
 35c:	01136419 	tsteq	r3, r9, lsl r4
 360:	13000013 	movwne	r0, #19
 364:	13490005 	movtne	r0, #36869	; 0x9005
 368:	00001934 	andeq	r1, r0, r4, lsr r9
 36c:	49000514 	stmdbmi	r0, {r2, r4, r8, sl}
 370:	15000013 	strne	r0, [r0, #-19]	; 0xffffffed
 374:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 378:	0b3a0e03 	bleq	e83b8c <__bss_end+0xe7a730>
 37c:	0b390b3b 	bleq	e43070 <__bss_end+0xe39c14>
 380:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 384:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 388:	00001301 	andeq	r1, r0, r1, lsl #6
 38c:	3f012e16 	svccc	0x00012e16
 390:	3a0e0319 	bcc	380ffc <__bss_end+0x377ba0>
 394:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 398:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 39c:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 3a0:	01136419 	tsteq	r3, r9, lsl r4
 3a4:	17000013 	smladne	r0, r3, r0, r0
 3a8:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 3ac:	0b3b0b3a 	bleq	ec309c <__bss_end+0xeb9c40>
 3b0:	13490b39 	movtne	r0, #39737	; 0x9b39
 3b4:	0b320b38 	bleq	c8309c <__bss_end+0xc79c40>
 3b8:	2e180000 	cdpcs	0, 1, cr0, cr8, cr0, {0}
 3bc:	03193f01 	tsteq	r9, #1, 30
 3c0:	3b0b3a0e 	blcc	2cec00 <__bss_end+0x2c57a4>
 3c4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 3c8:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
 3cc:	01136419 	tsteq	r3, r9, lsl r4
 3d0:	19000013 	stmdbne	r0, {r0, r1, r4}
 3d4:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 3d8:	0b3a0e03 	bleq	e83bec <__bss_end+0xe7a790>
 3dc:	0b390b3b 	bleq	e430d0 <__bss_end+0xe39c74>
 3e0:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 3e4:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 3e8:	00001364 	andeq	r1, r0, r4, ror #6
 3ec:	4901151a 	stmdbmi	r1, {r1, r3, r4, r8, sl, ip}
 3f0:	01136413 	tsteq	r3, r3, lsl r4
 3f4:	1b000013 	blne	448 <_start-0x7bb8>
 3f8:	131d001f 	tstne	sp, #31
 3fc:	00001349 	andeq	r1, r0, r9, asr #6
 400:	0b00101c 	bleq	4478 <_start-0x3b88>
 404:	0013490b 	andseq	r4, r3, fp, lsl #18
 408:	000f1d00 	andeq	r1, pc, r0, lsl #26
 40c:	00000b0b 	andeq	r0, r0, fp, lsl #22
 410:	0300341e 	movweq	r3, #1054	; 0x41e
 414:	3b0b3a0e 	blcc	2cec54 <__bss_end+0x2c57f8>
 418:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 41c:	00180213 	andseq	r0, r8, r3, lsl r2
 420:	012e1f00 			; <UNDEFINED> instruction: 0x012e1f00
 424:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 428:	0b3b0b3a 	bleq	ec3118 <__bss_end+0xeb9cbc>
 42c:	0e6e0b39 	vmoveq.8	d14[5], r0
 430:	01111349 	tsteq	r1, r9, asr #6
 434:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 438:	01194296 			; <UNDEFINED> instruction: 0x01194296
 43c:	20000013 	andcs	r0, r0, r3, lsl r0
 440:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 444:	0b3b0b3a 	bleq	ec3134 <__bss_end+0xeb9cd8>
 448:	13490b39 	movtne	r0, #39737	; 0x9b39
 44c:	00001802 	andeq	r1, r0, r2, lsl #16
 450:	3f012e21 	svccc	0x00012e21
 454:	3a0e0319 	bcc	3810c0 <__bss_end+0x377c64>
 458:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 45c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 460:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 464:	97184006 	ldrls	r4, [r8, -r6]
 468:	13011942 	movwne	r1, #6466	; 0x1942
 46c:	34220000 	strtcc	r0, [r2], #-0
 470:	3a080300 	bcc	201078 <__bss_end+0x1f7c1c>
 474:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 478:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 47c:	23000018 	movwcs	r0, #24
 480:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 484:	0b3a0e03 	bleq	e83c98 <__bss_end+0xe7a83c>
 488:	0b390b3b 	bleq	e4317c <__bss_end+0xe39d20>
 48c:	01110e6e 	tsteq	r1, lr, ror #28
 490:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 494:	01194297 			; <UNDEFINED> instruction: 0x01194297
 498:	24000013 	strcs	r0, [r0], #-19	; 0xffffffed
 49c:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 4a0:	0b3a0e03 	bleq	e83cb4 <__bss_end+0xe7a858>
 4a4:	0b390b3b 	bleq	e43198 <__bss_end+0xe39d3c>
 4a8:	01110e6e 	tsteq	r1, lr, ror #28
 4ac:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 4b0:	00194297 	mulseq	r9, r7, r2
 4b4:	012e2500 			; <UNDEFINED> instruction: 0x012e2500
 4b8:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 4bc:	0b3b0b3a 	bleq	ec31ac <__bss_end+0xeb9d50>
 4c0:	0e6e0b39 	vmoveq.8	d14[5], r0
 4c4:	01111349 	tsteq	r1, r9, asr #6
 4c8:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 4cc:	00194297 	mulseq	r9, r7, r2
 4d0:	11010000 	mrsne	r0, (UNDEF: 1)
 4d4:	130e2501 	movwne	r2, #58625	; 0xe501
 4d8:	1b0e030b 	blne	38110c <__bss_end+0x377cb0>
 4dc:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 4e0:	00171006 	andseq	r1, r7, r6
 4e4:	01390200 	teqeq	r9, r0, lsl #4
 4e8:	00001301 	andeq	r1, r0, r1, lsl #6
 4ec:	03003403 	movweq	r3, #1027	; 0x403
 4f0:	3b0b3a0e 	blcc	2ced30 <__bss_end+0x2c58d4>
 4f4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 4f8:	1c193c13 	ldcne	12, cr3, [r9], {19}
 4fc:	0400000a 	streq	r0, [r0], #-10
 500:	0b3a003a 	bleq	e805f0 <__bss_end+0xe77194>
 504:	0b390b3b 	bleq	e431f8 <__bss_end+0xe39d9c>
 508:	00001318 	andeq	r1, r0, r8, lsl r3
 50c:	49010105 	stmdbmi	r1, {r0, r2, r8}
 510:	00130113 	andseq	r0, r3, r3, lsl r1
 514:	00210600 	eoreq	r0, r1, r0, lsl #12
 518:	0b2f1349 	bleq	bc5244 <__bss_end+0xbbbde8>
 51c:	26070000 	strcs	r0, [r7], -r0
 520:	00134900 	andseq	r4, r3, r0, lsl #18
 524:	00240800 	eoreq	r0, r4, r0, lsl #16
 528:	0b3e0b0b 	bleq	f8315c <__bss_end+0xf79d00>
 52c:	00000e03 	andeq	r0, r0, r3, lsl #28
 530:	47003409 	strmi	r3, [r0, -r9, lsl #8]
 534:	0a000013 	beq	588 <_start-0x7a78>
 538:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 53c:	0b3a0e03 	bleq	e83d50 <__bss_end+0xe7a8f4>
 540:	0b390b3b 	bleq	e43234 <__bss_end+0xe39dd8>
 544:	01110e6e 	tsteq	r1, lr, ror #28
 548:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 54c:	01194297 			; <UNDEFINED> instruction: 0x01194297
 550:	0b000013 	bleq	5a4 <_start-0x7a5c>
 554:	08030005 	stmdaeq	r3, {r0, r2}
 558:	0b3b0b3a 	bleq	ec3248 <__bss_end+0xeb9dec>
 55c:	13490b39 	movtne	r0, #39737	; 0x9b39
 560:	00001802 	andeq	r1, r0, r2, lsl #16
 564:	0300340c 	movweq	r3, #1036	; 0x40c
 568:	3b0b3a0e 	blcc	2ceda8 <__bss_end+0x2c594c>
 56c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 570:	00180213 	andseq	r0, r8, r3, lsl r2
 574:	00340d00 	eorseq	r0, r4, r0, lsl #26
 578:	0b3a0e03 	bleq	e83d8c <__bss_end+0xe7a930>
 57c:	0b39053b 	bleq	e41a70 <__bss_end+0xe38614>
 580:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 584:	0b0e0000 	bleq	38058c <__bss_end+0x377130>
 588:	12011101 	andne	r1, r1, #1073741824	; 0x40000000
 58c:	0f000006 	svceq	0x00000006
 590:	08030034 	stmdaeq	r3, {r2, r4, r5}
 594:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 598:	13490b39 	movtne	r0, #39737	; 0x9b39
 59c:	00001802 	andeq	r1, r0, r2, lsl #16
 5a0:	0b000f10 	bleq	41e8 <_start-0x3e18>
 5a4:	0013490b 	andseq	r4, r3, fp, lsl #18
 5a8:	00261100 	eoreq	r1, r6, r0, lsl #2
 5ac:	0f120000 	svceq	0x00120000
 5b0:	000b0b00 	andeq	r0, fp, r0, lsl #22
 5b4:	00241300 	eoreq	r1, r4, r0, lsl #6
 5b8:	0b3e0b0b 	bleq	f831ec <__bss_end+0xf79d90>
 5bc:	00000803 	andeq	r0, r0, r3, lsl #16
 5c0:	03000514 	movweq	r0, #1300	; 0x514
 5c4:	3b0b3a0e 	blcc	2cee04 <__bss_end+0x2c59a8>
 5c8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 5cc:	00180213 	andseq	r0, r8, r3, lsl r2
 5d0:	00341500 	eorseq	r1, r4, r0, lsl #10
 5d4:	0b3a0803 	bleq	e825e8 <__bss_end+0xe7918c>
 5d8:	0b390b3b 	bleq	e432cc <__bss_end+0xe39e70>
 5dc:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 5e0:	2e160000 	cdpcs	0, 1, cr0, cr6, cr0, {0}
 5e4:	03193f01 	tsteq	r9, #1, 30
 5e8:	3b0b3a0e 	blcc	2cee28 <__bss_end+0x2c59cc>
 5ec:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 5f0:	1113490e 	tstne	r3, lr, lsl #18
 5f4:	40061201 	andmi	r1, r6, r1, lsl #4
 5f8:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 5fc:	00001301 	andeq	r1, r0, r1, lsl #6
 600:	3f012e17 	svccc	0x00012e17
 604:	3a0e0319 	bcc	381270 <__bss_end+0x377e14>
 608:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 60c:	110e6e0b 	tstne	lr, fp, lsl #28
 610:	40061201 	andmi	r1, r6, r1, lsl #4
 614:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 618:	00001301 	andeq	r1, r0, r1, lsl #6
 61c:	11010b18 	tstne	r1, r8, lsl fp
 620:	01061201 	tsteq	r6, r1, lsl #4
 624:	19000013 	stmdbne	r0, {r0, r1, r4}
 628:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 62c:	0b3a0e03 	bleq	e83e40 <__bss_end+0xe7a9e4>
 630:	0b390b3b 	bleq	e43324 <__bss_end+0xe39ec8>
 634:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 638:	06120111 			; <UNDEFINED> instruction: 0x06120111
 63c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 640:	00130119 	andseq	r0, r3, r9, lsl r1
 644:	012e1a00 			; <UNDEFINED> instruction: 0x012e1a00
 648:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 64c:	0b3b0b3a 	bleq	ec333c <__bss_end+0xeb9ee0>
 650:	0e6e0b39 	vmoveq.8	d14[5], r0
 654:	06120111 			; <UNDEFINED> instruction: 0x06120111
 658:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 65c:	00000019 	andeq	r0, r0, r9, lsl r0

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
  70:	0000822c 	andeq	r8, r0, ip, lsr #4
  74:	00000048 	andeq	r0, r0, r8, asr #32
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	044e0002 	strbeq	r0, [lr], #-2
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	00008274 	andeq	r8, r0, r4, ror r2
  94:	0000045c 	andeq	r0, r0, ip, asr r4
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	0ff70002 	svceq	0x00f70002
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	000086d0 	ldrdeq	r8, [r0], -r0
  b4:	00000c38 	andeq	r0, r0, r8, lsr ip
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
       4:	752f632f 	strvc	r6, [pc, #-815]!	; fffffcdd <__bss_end+0xffff6881>
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
      30:	4f2f534f 	svcmi	0x002f534f
      34:	7a766564 	bvc	1d995cc <__bss_end+0x1d90170>
      38:	696e6164 	stmdbvs	lr!, {r2, r5, r6, r8, sp, lr}^
      3c:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
      40:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
      44:	61707372 	cmnvs	r0, r2, ror r3
      48:	632f6563 			; <UNDEFINED> instruction: 0x632f6563
      4c:	2e307472 	mrccs	4, 1, r7, cr0, cr2, {3}
      50:	6d2f0073 	stcvs	0, cr0, [pc, #-460]!	; fffffe8c <__bss_end+0xffff6a30>
      54:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
      58:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
      5c:	72702f72 	rsbsvc	r2, r0, #456	; 0x1c8
      60:	74617669 	strbtvc	r7, [r1], #-1641	; 0xfffff997
      64:	726f5765 	rsbvc	r5, pc, #26476544	; 0x1940000
      68:	6170736b 	cmnvs	r0, fp, ror #6
      6c:	532f6563 			; <UNDEFINED> instruction: 0x532f6563
      70:	6f6f6863 	svcvs	0x006f6863
      74:	534f2f6c 	movtpl	r2, #65388	; 0xff6c
      78:	2f50532f 	svccs	0x0050532f
      7c:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
      80:	534f5452 	movtpl	r5, #62546	; 0xf452
      84:	65644f2f 	strbvs	r4, [r4, #-3887]!	; 0xfffff0d1
      88:	61647a76 	smcvs	18342	; 0x47a6
      8c:	732f696e 			; <UNDEFINED> instruction: 0x732f696e
      90:	752f6372 	strvc	r6, [pc, #-882]!	; fffffd26 <__bss_end+0xffff68ca>
      94:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
      98:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
      9c:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
      a0:	4700646c 	strmi	r6, [r0, -ip, ror #8]
      a4:	4120554e 			; <UNDEFINED> instruction: 0x4120554e
      a8:	2e322053 	mrccs	0, 1, r2, cr2, cr3, {2}
      ac:	2f003733 	svccs	0x00003733
      b0:	2f746e6d 	svccs	0x00746e6d
      b4:	73752f63 	cmnvc	r5, #396	; 0x18c
      b8:	702f7265 	eorvc	r7, pc, r5, ror #4
      bc:	61766972 	cmnvs	r6, r2, ror r9
      c0:	6f576574 	svcvs	0x00576574
      c4:	70736b72 	rsbsvc	r6, r3, r2, ror fp
      c8:	2f656361 	svccs	0x00656361
      cc:	6f686353 	svcvs	0x00686353
      d0:	4f2f6c6f 	svcmi	0x002f6c6f
      d4:	50532f53 	subspl	r2, r3, r3, asr pc
      d8:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
      dc:	4f54522d 	svcmi	0x0054522d
      e0:	644f2f53 	strbvs	r2, [pc], #-3923	; e8 <_start-0x7f18>
      e4:	647a7665 	ldrbtvs	r7, [sl], #-1637	; 0xfffff99b
      e8:	2f696e61 	svccs	0x00696e61
      ec:	2f637273 	svccs	0x00637273
      f0:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
      f4:	63617073 	cmnvs	r1, #115	; 0x73
      f8:	72632f65 	rsbvc	r2, r3, #404	; 0x194
      fc:	632e3074 			; <UNDEFINED> instruction: 0x632e3074
     100:	635f5f00 	cmpvs	pc, #0, 30
     104:	5f307472 	svcpl	0x00307472
     108:	74696e69 	strbtvc	r6, [r9], #-3689	; 0xfffff197
     10c:	7373625f 	cmnvc	r3, #-268435451	; 0xf0000005
     110:	625f5f00 	subsvs	r5, pc, #0, 30
     114:	655f7373 	ldrbvs	r7, [pc, #-883]	; fffffda9 <__bss_end+0xffff694d>
     118:	7200646e 	andvc	r6, r0, #1845493760	; 0x6e000000
     11c:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
     120:	5f5f0074 	svcpl	0x005f0074
     124:	5f737362 	svcpl	0x00737362
     128:	72617473 	rsbvc	r7, r1, #1929379840	; 0x73000000
     12c:	4e470074 	mcrmi	0, 2, r0, cr7, cr4, {3}
     130:	31432055 	qdaddcc	r2, r5, r3
     134:	30312037 	eorscc	r2, r1, r7, lsr r0
     138:	302e332e 	eorcc	r3, lr, lr, lsr #6
     13c:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     140:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
     144:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
     148:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
     14c:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
     150:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
     154:	20706676 	rsbscs	r6, r0, r6, ror r6
     158:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
     15c:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
     160:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
     164:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
     168:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     16c:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
     170:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     174:	6e75746d 	cdpvs	4, 7, cr7, cr5, cr13, {3}
     178:	72613d65 	rsbvc	r3, r1, #6464	; 0x1940
     17c:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
     180:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
     184:	2d20732d 	stccs	3, cr7, [r0, #-180]!	; 0xffffff4c
     188:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
     18c:	616d2d20 	cmnvs	sp, r0, lsr #26
     190:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
     194:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
     198:	2b6b7a36 	blcs	1adea78 <__bss_end+0x1ad561c>
     19c:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     1a0:	672d2067 	strvs	r2, [sp, -r7, rrx]!
     1a4:	304f2d20 	subcc	r2, pc, r0, lsr #26
     1a8:	304f2d20 	subcc	r2, pc, r0, lsr #26
     1ac:	635f5f00 	cmpvs	pc, #0, 30
     1b0:	5f307472 	svcpl	0x00307472
     1b4:	006e7572 	rsbeq	r7, lr, r2, ror r5
     1b8:	75675f5f 	strbvc	r5, [r7, #-3935]!	; 0xfffff0a1
     1bc:	00647261 	rsbeq	r7, r4, r1, ror #4
     1c0:	78635f5f 	stmdavc	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
     1c4:	69626178 	stmdbvs	r2!, {r3, r4, r5, r6, r8, sp, lr}^
     1c8:	5f003176 	svcpl	0x00003176
     1cc:	6165615f 	cmnvs	r5, pc, asr r1
     1d0:	755f6962 	ldrbvc	r6, [pc, #-2402]	; fffff876 <__bss_end+0xffff641a>
     1d4:	6e69776e 	cdpvs	7, 6, cr7, cr9, cr14, {3}
     1d8:	70635f64 	rsbvc	r5, r3, r4, ror #30
     1dc:	72705f70 	rsbsvc	r5, r0, #112, 30	; 0x1c0
     1e0:	635f0031 	cmpvs	pc, #49	; 0x31
     1e4:	735f7070 	cmpvc	pc, #112	; 0x70
     1e8:	64747568 	ldrbtvs	r7, [r4], #-1384	; 0xfffffa98
     1ec:	006e776f 	rsbeq	r7, lr, pc, ror #14
     1f0:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
     1f4:	752f632f 	strvc	r6, [pc, #-815]!	; fffffecd <__bss_end+0xffff6a71>
     1f8:	2f726573 	svccs	0x00726573
     1fc:	76697270 			; <UNDEFINED> instruction: 0x76697270
     200:	57657461 	strbpl	r7, [r5, -r1, ror #8]!
     204:	736b726f 	cmnvc	fp, #-268435450	; 0xf0000006
     208:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     20c:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
     210:	2f6c6f6f 	svccs	0x006c6f6f
     214:	532f534f 			; <UNDEFINED> instruction: 0x532f534f
     218:	494b2f50 	stmdbmi	fp, {r4, r6, r8, r9, sl, fp, sp}^
     21c:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
     220:	4f2f534f 	svcmi	0x002f534f
     224:	7a766564 	bvc	1d997bc <__bss_end+0x1d90360>
     228:	696e6164 	stmdbvs	lr!, {r2, r5, r6, r8, sp, lr}^
     22c:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     230:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     234:	61707372 	cmnvs	r0, r2, ror r3
     238:	632f6563 			; <UNDEFINED> instruction: 0x632f6563
     23c:	62617878 	rsbvs	r7, r1, #120, 16	; 0x780000
     240:	70632e69 	rsbvc	r2, r3, r9, ror #28
     244:	6e660070 	mcrvs	0, 3, r0, cr6, cr0, {3}
     248:	00727470 	rsbseq	r7, r2, r0, ror r4
     24c:	78635f5f 	stmdavc	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
     250:	75705f61 	ldrbvc	r5, [r0, #-3937]!	; 0xfffff09f
     254:	765f6572 			; <UNDEFINED> instruction: 0x765f6572
     258:	75747269 	ldrbvc	r7, [r4, #-617]!	; 0xfffffd97
     25c:	5f006c61 	svcpl	0x00006c61
     260:	6178635f 	cmnvs	r8, pc, asr r3
     264:	6175675f 	cmnvs	r5, pc, asr r7
     268:	725f6472 	subsvc	r6, pc, #1912602624	; 0x72000000
     26c:	61656c65 	cmnvs	r5, r5, ror #24
     270:	5f006573 	svcpl	0x00006573
     274:	4f54435f 	svcmi	0x0054435f
     278:	4e455f52 	mcrmi	15, 2, r5, cr5, cr2, {2}
     27c:	005f5f44 	subseq	r5, pc, r4, asr #30
     280:	73645f5f 	cmnvc	r4, #380	; 0x17c
     284:	61685f6f 	cmnvs	r8, pc, ror #30
     288:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     28c:	445f5f00 	ldrbmi	r5, [pc], #-3840	; 294 <_start-0x7d6c>
     290:	5f524f54 	svcpl	0x00524f54
     294:	5453494c 	ldrbpl	r4, [r3], #-2380	; 0xfffff6b4
     298:	47005f5f 	smlsdmi	r0, pc, pc, r5	; <UNPREDICTABLE>
     29c:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
     2a0:	34312b2b 	ldrtcc	r2, [r1], #-2859	; 0xfffff4d5
     2a4:	2e303120 	rsfcssp	f3, f0, f0
     2a8:	20302e33 	eorscs	r2, r0, r3, lsr lr
     2ac:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
     2b0:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
     2b4:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
     2b8:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
     2bc:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     2c0:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
     2c4:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     2c8:	6f6c666d 	svcvs	0x006c666d
     2cc:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
     2d0:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
     2d4:	20647261 	rsbcs	r7, r4, r1, ror #4
     2d8:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
     2dc:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
     2e0:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
     2e4:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
     2e8:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
     2ec:	36373131 			; <UNDEFINED> instruction: 0x36373131
     2f0:	2d667a6a 	vstmdbcs	r6!, {s15-s120}
     2f4:	6d2d2073 	stcvs	0, cr2, [sp, #-460]!	; 0xfffffe34
     2f8:	206d7261 	rsbcs	r7, sp, r1, ror #4
     2fc:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
     300:	613d6863 	teqvs	sp, r3, ror #16
     304:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
     308:	662b6b7a 			; <UNDEFINED> instruction: 0x662b6b7a
     30c:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
     310:	20672d20 	rsbcs	r2, r7, r0, lsr #26
     314:	20304f2d 	eorscs	r4, r0, sp, lsr #30
     318:	20304f2d 	eorscs	r4, r0, sp, lsr #30
     31c:	6f6e662d 	svcvs	0x006e662d
     320:	6378652d 	cmnvs	r8, #188743680	; 0xb400000
     324:	69747065 	ldmdbvs	r4!, {r0, r2, r5, r6, ip, sp, lr}^
     328:	20736e6f 	rsbscs	r6, r3, pc, ror #28
     32c:	6f6e662d 	svcvs	0x006e662d
     330:	7474722d 	ldrbtvc	r7, [r4], #-557	; 0xfffffdd3
     334:	74640069 	strbtvc	r0, [r4], #-105	; 0xffffff97
     338:	705f726f 	subsvc	r7, pc, pc, ror #4
     33c:	5f007274 	svcpl	0x00007274
     340:	4f54445f 	svcmi	0x0054445f
     344:	4e455f52 	mcrmi	15, 2, r5, cr5, cr2, {2}
     348:	005f5f44 	subseq	r5, pc, r4, asr #30
     34c:	78635f5f 	stmdavc	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
     350:	74615f61 	strbtvc	r5, [r1], #-3937	; 0xfffff09f
     354:	74697865 	strbtvc	r7, [r9], #-2149	; 0xfffff79b
     358:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
     35c:	6f6c2067 	svcvs	0x006c2067
     360:	6920676e 	stmdbvs	r0!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}
     364:	5f00746e 	svcpl	0x0000746e
     368:	5f707063 	svcpl	0x00707063
     36c:	72617473 	rsbvc	r7, r1, #1929379840	; 0x73000000
     370:	00707574 	rsbseq	r7, r0, r4, ror r5
     374:	78635f5f 	stmdavc	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
     378:	75675f61 	strbvc	r5, [r7, #-3937]!	; 0xfffff09f
     37c:	5f647261 	svcpl	0x00647261
     380:	726f6261 	rsbvc	r6, pc, #268435462	; 0x10000006
     384:	5f5f0074 	svcpl	0x005f0074
     388:	524f5443 	subpl	r5, pc, #1124073472	; 0x43000000
     38c:	53494c5f 	movtpl	r4, #40031	; 0x9c5f
     390:	005f5f54 	subseq	r5, pc, r4, asr pc	; <UNPREDICTABLE>
     394:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
     398:	7274705f 	rsbsvc	r7, r4, #95	; 0x5f
     39c:	635f5f00 	cmpvs	pc, #0, 30
     3a0:	675f6178 			; <UNDEFINED> instruction: 0x675f6178
     3a4:	64726175 	ldrbtvs	r6, [r2], #-373	; 0xfffffe8b
     3a8:	7163615f 	cmnvc	r3, pc, asr r1
     3ac:	65726975 	ldrbvs	r6, [r2, #-2421]!	; 0xfffff68b
     3b0:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     3b4:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     3b8:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
     3bc:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     3c0:	61006874 	tstvs	r0, r4, ror r8
     3c4:	00636772 	rsbeq	r6, r3, r2, ror r7
     3c8:	6b636f4c 	blvs	18dc100 <__bss_end+0x18d2ca4>
     3cc:	6c6e555f 	cfstr64vs	mvdx5, [lr], #-380	; 0xfffffe84
     3d0:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     3d4:	6f4e0064 	svcvs	0x004e0064
     3d8:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     3dc:	006c6c41 	rsbeq	r6, ip, r1, asr #24
     3e0:	61766e49 	cmnvs	r6, r9, asr #28
     3e4:	5f64696c 	svcpl	0x0064696c
     3e8:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     3ec:	6c00656c 	cfstr32vs	mvfx6, [r0], {108}	; 0x6c
     3f0:	20676e6f 	rsbcs	r6, r7, pc, ror #28
     3f4:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     3f8:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
     3fc:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
     400:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     404:	68746150 	ldmdavs	r4!, {r4, r6, r8, sp, lr}^
     408:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     40c:	62006874 	andvs	r6, r0, #116, 16	; 0x740000
     410:	006c6f6f 	rsbeq	r6, ip, pc, ror #30
     414:	64616544 	strbtvs	r6, [r1], #-1348	; 0xfffffabc
     418:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     41c:	636e555f 	cmnvs	lr, #398458880	; 0x17c00000
     420:	676e6168 	strbvs	r6, [lr, -r8, ror #2]!
     424:	4e006465 	cdpmi	4, 0, cr6, cr0, cr5, {3}
     428:	6c69466f 	stclvs	6, cr4, [r9], #-444	; 0xfffffe44
     42c:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     430:	446d6574 	strbtmi	r6, [sp], #-1396	; 0xfffffa8c
     434:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     438:	6e750072 	mrcvs	0, 3, r0, cr5, cr2, {3}
     43c:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
     440:	63206465 			; <UNDEFINED> instruction: 0x63206465
     444:	00726168 	rsbseq	r6, r2, r8, ror #2
     448:	6e69616d 	powvsez	f6, f1, #5.0
     44c:	6e697500 	cdpvs	5, 6, cr7, cr9, cr0, {0}
     450:	5f323374 	svcpl	0x00323374
     454:	6f4c0074 	svcvs	0x004c0074
     458:	4c5f6b63 	mrrcmi	11, 6, r6, pc, cr3	; <UNPREDICTABLE>
     45c:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     460:	6e490064 	cdpvs	0, 4, cr0, cr9, cr4, {3}
     464:	69666564 	stmdbvs	r6!, {r2, r5, r6, r8, sl, sp, lr}^
     468:	6574696e 	ldrbvs	r6, [r4, #-2414]!	; 0xfffff692
     46c:	6f687300 	svcvs	0x00687300
     470:	75207472 	strvc	r7, [r0, #-1138]!	; 0xfffffb8e
     474:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
     478:	2064656e 	rsbcs	r6, r4, lr, ror #10
     47c:	00746e69 	rsbseq	r6, r4, r9, ror #28
     480:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
     484:	752f632f 	strvc	r6, [pc, #-815]!	; 15d <_start-0x7ea3>
     488:	2f726573 	svccs	0x00726573
     48c:	76697270 			; <UNDEFINED> instruction: 0x76697270
     490:	57657461 	strbpl	r7, [r5, -r1, ror #8]!
     494:	736b726f 	cmnvc	fp, #-268435450	; 0xf0000006
     498:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     49c:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
     4a0:	2f6c6f6f 	svccs	0x006c6f6f
     4a4:	532f534f 			; <UNDEFINED> instruction: 0x532f534f
     4a8:	494b2f50 	stmdbmi	fp, {r4, r6, r8, r9, sl, fp, sp}^
     4ac:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
     4b0:	4f2f534f 	svcmi	0x002f534f
     4b4:	7a766564 	bvc	1d99a4c <__bss_end+0x1d905f0>
     4b8:	696e6164 	stmdbvs	lr!, {r2, r5, r6, r8, sp, lr}^
     4bc:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     4c0:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     4c4:	61707372 	cmnvs	r0, r2, ror r3
     4c8:	692f6563 	stmdbvs	pc!, {r0, r1, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
     4cc:	5f74696e 	svcpl	0x0074696e
     4d0:	6b736174 	blvs	1cd8aa8 <__bss_end+0x1ccf64c>
     4d4:	69616d2f 	stmdbvs	r1!, {r0, r1, r2, r3, r5, r8, sl, fp, sp, lr}^
     4d8:	70632e6e 	rsbvc	r2, r3, lr, ror #28
     4dc:	614d0070 	hvcvs	53248	; 0xd000
     4e0:	72505f78 	subsvc	r5, r0, #120, 30	; 0x1e0
     4e4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     4e8:	704f5f73 	subvc	r5, pc, r3, ror pc	; <UNPREDICTABLE>
     4ec:	64656e65 	strbtvs	r6, [r5], #-3685	; 0xfffff19b
     4f0:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     4f4:	73007365 	movwvc	r7, #869	; 0x365
     4f8:	74726f68 	ldrbtvc	r6, [r2], #-3944	; 0xfffff098
     4fc:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
     500:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     504:	72445346 	subvc	r5, r4, #402653185	; 0x18000001
     508:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     50c:	656d614e 	strbvs	r6, [sp, #-334]!	; 0xfffffeb2
     510:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     514:	61006874 	tstvs	r0, r4, ror r8
     518:	00766772 	rsbseq	r6, r6, r2, ror r7
     51c:	6b636954 	blvs	18daa74 <__bss_end+0x18d1618>
     520:	756f435f 	strbvc	r4, [pc, #-863]!	; 1c9 <_start-0x7e37>
     524:	4f00746e 	svcmi	0x0000746e
     528:	006e6570 	rsbeq	r6, lr, r0, ror r5
     52c:	314e5a5f 	cmpcc	lr, pc, asr sl
     530:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     534:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     538:	614d5f73 	hvcvs	54771	; 0xd5f3
     53c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     540:	42313272 	eorsmi	r3, r1, #536870919	; 0x20000007
     544:	6b636f6c 	blvs	18dc2fc <__bss_end+0x18d2ea0>
     548:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     54c:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     550:	6f72505f 	svcvs	0x0072505f
     554:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     558:	63007645 	movwvs	r7, #1605	; 0x645
     55c:	65736f6c 	ldrbvs	r6, [r3, #-3948]!	; 0xfffff094
     560:	65727000 	ldrbvs	r7, [r2, #-0]!
     564:	65530076 	ldrbvs	r0, [r3, #-118]	; 0xffffff8a
     568:	65525f74 	ldrbvs	r5, [r2, #-3956]	; 0xfffff08c
     56c:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
     570:	55006576 	strpl	r6, [r0, #-1398]	; 0xfffffa8a
     574:	70616d6e 	rsbvc	r6, r1, lr, ror #26
     578:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     57c:	75435f65 	strbvc	r5, [r3, #-3941]	; 0xfffff09b
     580:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     584:	65720074 	ldrbvs	r0, [r2, #-116]!	; 0xffffff8c
     588:	6c617674 	stclvs	6, cr7, [r1], #-464	; 0xfffffe30
     58c:	75636e00 	strbvc	r6, [r3, #-3584]!	; 0xfffff200
     590:	506d0072 	rsbpl	r0, sp, r2, ror r0
     594:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     598:	4c5f7373 	mrrcmi	3, 7, r7, pc, cr3	; <UNPREDICTABLE>
     59c:	5f747369 	svcpl	0x00747369
     5a0:	64616548 	strbtvs	r6, [r1], #-1352	; 0xfffffab8
     5a4:	70697000 	rsbvc	r7, r9, r0
     5a8:	5a5f0065 	bpl	17c0744 <__bss_end+0x17b72e8>
     5ac:	36314b4e 	ldrtcc	r4, [r1], -lr, asr #22
     5b0:	6f725043 	svcvs	0x00725043
     5b4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     5b8:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     5bc:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     5c0:	65473931 	strbvs	r3, [r7, #-2353]	; 0xfffff6cf
     5c4:	75435f74 	strbvc	r5, [r3, #-3956]	; 0xfffff08c
     5c8:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     5cc:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     5d0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     5d4:	00764573 	rsbseq	r4, r6, r3, ror r5
     5d8:	756e6472 	strbvc	r6, [lr, #-1138]!	; 0xfffffb8e
     5dc:	656e006d 	strbvs	r0, [lr, #-109]!	; 0xffffff93
     5e0:	47007478 	smlsdxmi	r0, r8, r4, r7
     5e4:	505f7465 	subspl	r7, pc, r5, ror #8
     5e8:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     5ec:	425f7373 	subsmi	r7, pc, #-872415231	; 0xcc000001
     5f0:	49505f79 	ldmdbmi	r0, {r0, r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     5f4:	5a5f0044 	bpl	17c070c <__bss_end+0x17b72b0>
     5f8:	63733131 	cmnvs	r3, #1073741836	; 0x4000000c
     5fc:	5f646568 	svcpl	0x00646568
     600:	6c656979 			; <UNDEFINED> instruction: 0x6c656979
     604:	4e007664 	cfmadd32mi	mvax3, mvfx7, mvfx0, mvfx4
     608:	5f495753 	svcpl	0x00495753
     60c:	636f7250 	cmnvs	pc, #80, 4
     610:	5f737365 	svcpl	0x00737365
     614:	76726553 			; <UNDEFINED> instruction: 0x76726553
     618:	00656369 	rsbeq	r6, r5, r9, ror #6
     61c:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     620:	74634100 	strbtvc	r4, [r3], #-256	; 0xffffff00
     624:	5f657669 	svcpl	0x00657669
     628:	636f7250 	cmnvs	pc, #80, 4
     62c:	5f737365 	svcpl	0x00737365
     630:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     634:	72430074 	subvc	r0, r3, #116	; 0x74
     638:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
     63c:	6f72505f 	svcvs	0x0072505f
     640:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     644:	315a5f00 	cmpcc	sl, r0, lsl #30
     648:	74657337 	strbtvc	r7, [r5], #-823	; 0xfffffcc9
     64c:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     650:	65645f6b 	strbvs	r5, [r4, #-3947]!	; 0xfffff095
     654:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     658:	006a656e 	rsbeq	r6, sl, lr, ror #10
     65c:	74696177 	strbtvc	r6, [r9], #-375	; 0xfffffe89
     660:	61747300 	cmnvs	r4, r0, lsl #6
     664:	5f006574 	svcpl	0x00006574
     668:	6f6e365a 	svcvs	0x006e365a
     66c:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     670:	47006a6a 	strmi	r6, [r0, -sl, ror #20]
     674:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     678:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     67c:	72656c75 	rsbvc	r6, r5, #29952	; 0x7500
     680:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     684:	5043006f 	subpl	r0, r3, pc, rrx
     688:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     68c:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 4c8 <_start-0x7b38>
     690:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     694:	5f007265 	svcpl	0x00007265
     698:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     69c:	6f725043 	svcvs	0x00725043
     6a0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     6a4:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     6a8:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     6ac:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     6b0:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     6b4:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     6b8:	5f72656c 	svcpl	0x0072656c
     6bc:	6f666e49 	svcvs	0x00666e49
     6c0:	4e303245 	cdpmi	2, 3, cr3, cr0, cr5, {2}
     6c4:	5f746547 	svcpl	0x00746547
     6c8:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     6cc:	6e495f64 	cdpvs	15, 4, cr5, cr9, cr4, {3}
     6d0:	545f6f66 	ldrbpl	r6, [pc], #-3942	; 6d8 <_start-0x7928>
     6d4:	50657079 	rsbpl	r7, r5, r9, ror r0
     6d8:	5a5f0076 	bpl	17c08b8 <__bss_end+0x17b745c>
     6dc:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     6e0:	636f7250 	cmnvs	pc, #80, 4
     6e4:	5f737365 	svcpl	0x00737365
     6e8:	616e614d 	cmnvs	lr, sp, asr #2
     6ec:	32726567 	rsbscc	r6, r2, #432013312	; 0x19c00000
     6f0:	6e614831 	mcrvs	8, 3, r4, cr1, cr1, {1}
     6f4:	5f656c64 	svcpl	0x00656c64
     6f8:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     6fc:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     700:	535f6d65 	cmppl	pc, #6464	; 0x1940
     704:	32454957 	subcc	r4, r5, #1425408	; 0x15c000
     708:	57534e33 	smmlarpl	r3, r3, lr, r4
     70c:	69465f49 	stmdbvs	r6, {r0, r3, r6, r8, r9, sl, fp, ip, lr}^
     710:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     714:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     718:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     71c:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     720:	526a6a6a 	rsbpl	r6, sl, #434176	; 0x6a000
     724:	53543131 	cmppl	r4, #1073741836	; 0x4000000c
     728:	525f4957 	subspl	r4, pc, #1425408	; 0x15c000
     72c:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
     730:	65680074 	strbvs	r0, [r8, #-116]!	; 0xffffff8c
     734:	705f7061 	subsvc	r7, pc, r1, rrx
     738:	69737968 	ldmdbvs	r3!, {r3, r5, r6, r8, fp, ip, sp, lr}^
     73c:	5f6c6163 	svcpl	0x006c6163
     740:	696d696c 	stmdbvs	sp!, {r2, r3, r5, r6, r8, fp, sp, lr}^
     744:	706f0074 	rsbvc	r0, pc, r4, ror r0	; <UNPREDICTABLE>
     748:	64656e65 	strbtvs	r6, [r5], #-3685	; 0xfffff19b
     74c:	6c69665f 	stclvs	6, cr6, [r9], #-380	; 0xfffffe84
     750:	46007365 	strmi	r7, [r0], -r5, ror #6
     754:	006c6961 	rsbeq	r6, ip, r1, ror #18
     758:	55504354 	ldrbpl	r4, [r0, #-852]	; 0xfffffcac
     75c:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     760:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
     764:	61654400 	cmnvs	r5, r0, lsl #8
     768:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     76c:	78650065 	stmdavc	r5!, {r0, r2, r5, r6}^
     770:	6f637469 	svcvs	0x00637469
     774:	74006564 	strvc	r6, [r0], #-1380	; 0xfffffa9c
     778:	30726274 	rsbscc	r6, r2, r4, ror r2
     77c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     780:	50433631 	subpl	r3, r3, r1, lsr r6
     784:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     788:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 5c4 <_start-0x7a3c>
     78c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     790:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
     794:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     798:	505f7966 	subspl	r7, pc, r6, ror #18
     79c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     7a0:	6a457373 	bvs	115d574 <__bss_end+0x1154118>
     7a4:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     7a8:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     7ac:	746f6e00 	strbtvc	r6, [pc], #-3584	; 7b4 <_start-0x784c>
     7b0:	65696669 	strbvs	r6, [r9, #-1641]!	; 0xfffff997
     7b4:	65645f64 	strbvs	r5, [r4, #-3940]!	; 0xfffff09c
     7b8:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     7bc:	5f00656e 	svcpl	0x0000656e
     7c0:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     7c4:	6f725043 	svcvs	0x00725043
     7c8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     7cc:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     7d0:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     7d4:	6e553831 	mrcvs	8, 2, r3, cr5, cr1, {1}
     7d8:	5f70616d 	svcpl	0x0070616d
     7dc:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     7e0:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     7e4:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     7e8:	5f006a45 	svcpl	0x00006a45
     7ec:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     7f0:	6f725043 	svcvs	0x00725043
     7f4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     7f8:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     7fc:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     800:	6f4e3431 	svcvs	0x004e3431
     804:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     808:	6f72505f 	svcvs	0x0072505f
     80c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     810:	32315045 	eorscc	r5, r1, #69	; 0x45
     814:	73615454 	cmnvc	r1, #84, 8	; 0x54000000
     818:	74535f6b 	ldrbvc	r5, [r3], #-3947	; 0xfffff095
     81c:	74637572 	strbtvc	r7, [r3], #-1394	; 0xfffffa8e
     820:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
     824:	795f6465 	ldmdbvc	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     828:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
     82c:	63697400 	cmnvs	r9, #0, 8
     830:	6f635f6b 	svcvs	0x00635f6b
     834:	5f746e75 	svcpl	0x00746e75
     838:	75716572 	ldrbvc	r6, [r1, #-1394]!	; 0xfffffa8e
     83c:	64657269 	strbtvs	r7, [r5], #-617	; 0xfffffd97
     840:	325a5f00 	subscc	r5, sl, #0, 30
     844:	74656734 	strbtvc	r6, [r5], #-1844	; 0xfffff8cc
     848:	7463615f 	strbtvc	r6, [r3], #-351	; 0xfffffea1
     84c:	5f657669 	svcpl	0x00657669
     850:	636f7270 	cmnvs	pc, #112, 4
     854:	5f737365 	svcpl	0x00737365
     858:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     85c:	2f007674 	svccs	0x00007674
     860:	2f746e6d 	svccs	0x00746e6d
     864:	73752f63 	cmnvc	r5, #396	; 0x18c
     868:	702f7265 	eorvc	r7, pc, r5, ror #4
     86c:	61766972 	cmnvs	r6, r2, ror r9
     870:	6f576574 	svcvs	0x00576574
     874:	70736b72 	rsbsvc	r6, r3, r2, ror fp
     878:	2f656361 	svccs	0x00656361
     87c:	6f686353 	svcvs	0x00686353
     880:	4f2f6c6f 	svcmi	0x002f6c6f
     884:	50532f53 	subspl	r2, r3, r3, asr pc
     888:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
     88c:	4f54522d 	svcmi	0x0054522d
     890:	644f2f53 	strbvs	r2, [pc], #-3923	; 898 <_start-0x7768>
     894:	647a7665 	ldrbtvs	r7, [sl], #-1637	; 0xfffff99b
     898:	2f696e61 	svccs	0x00696e61
     89c:	2f637273 	svccs	0x00637273
     8a0:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
     8a4:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
     8a8:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
     8ac:	69666474 	stmdbvs	r6!, {r2, r4, r5, r6, sl, sp, lr}^
     8b0:	632e656c 			; <UNDEFINED> instruction: 0x632e656c
     8b4:	50007070 	andpl	r7, r0, r0, ror r0
     8b8:	5f657069 	svcpl	0x00657069
     8bc:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     8c0:	6572505f 	ldrbvs	r5, [r2, #-95]!	; 0xffffffa1
     8c4:	00786966 	rsbseq	r6, r8, r6, ror #18
     8c8:	5f70614d 	svcpl	0x0070614d
     8cc:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     8d0:	5f6f545f 	svcpl	0x006f545f
     8d4:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     8d8:	00746e65 	rsbseq	r6, r4, r5, ror #28
     8dc:	314e5a5f 	cmpcc	lr, pc, asr sl
     8e0:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     8e4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     8e8:	614d5f73 	hvcvs	54771	; 0xd5f3
     8ec:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     8f0:	48373172 	ldmdami	r7!, {r1, r4, r5, r6, r8, ip, sp}
     8f4:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     8f8:	654d5f65 	strbvs	r5, [sp, #-3941]	; 0xfffff09b
     8fc:	79726f6d 	ldmdbvc	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     900:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     904:	4e393145 	rsfmiem	f3, f1, f5
     908:	5f495753 	svcpl	0x00495753
     90c:	6f6d654d 	svcvs	0x006d654d
     910:	535f7972 	cmppl	pc, #1867776	; 0x1c8000
     914:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     918:	6a6a6563 	bvs	1a99eac <__bss_end+0x1a90a50>
     91c:	3131526a 	teqcc	r1, sl, ror #4
     920:	49575354 	ldmdbmi	r7, {r2, r4, r6, r8, r9, ip, lr}^
     924:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
     928:	00746c75 	rsbseq	r6, r4, r5, ror ip
     92c:	5f746553 	svcpl	0x00746553
     930:	61726150 	cmnvs	r2, r0, asr r1
     934:	5f00736d 	svcpl	0x0000736d
     938:	6734315a 			; <UNDEFINED> instruction: 0x6734315a
     93c:	745f7465 	ldrbvc	r7, [pc], #-1125	; 944 <_start-0x76bc>
     940:	5f6b6369 	svcpl	0x006b6369
     944:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     948:	48007674 	stmdami	r0, {r2, r4, r5, r6, r9, sl, ip, sp, lr}
     94c:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     950:	72505f65 	subsvc	r5, r0, #404	; 0x194
     954:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     958:	57535f73 			; <UNDEFINED> instruction: 0x57535f73
     95c:	6c730049 	ldclvs	0, cr0, [r3], #-292	; 0xfffffedc
     960:	00706565 	rsbseq	r6, r0, r5, ror #10
     964:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     968:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     96c:	4644455f 			; <UNDEFINED> instruction: 0x4644455f
     970:	69615700 	stmdbvs	r1!, {r8, r9, sl, ip, lr}^
     974:	69440074 	stmdbvs	r4, {r2, r4, r5, r6}^
     978:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
     97c:	76455f65 	strbvc	r5, [r5], -r5, ror #30
     980:	5f746e65 	svcpl	0x00746e65
     984:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     988:	6f697463 	svcvs	0x00697463
     98c:	5a5f006e 	bpl	17c0b4c <__bss_end+0x17b76f0>
     990:	72657439 	rsbvc	r7, r5, #956301312	; 0x39000000
     994:	616e696d 	cmnvs	lr, sp, ror #18
     998:	00696574 	rsbeq	r6, r9, r4, ror r5
     99c:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     9a0:	70757272 	rsbsvc	r7, r5, r2, ror r2
     9a4:	6c626174 	stfvse	f6, [r2], #-464	; 0xfffffe30
     9a8:	6c535f65 	mrrcvs	15, 6, r5, r3, cr5
     9ac:	00706565 	rsbseq	r6, r0, r5, ror #10
     9b0:	7265706f 	rsbvc	r7, r5, #111	; 0x6f
     9b4:	6f697461 	svcvs	0x00697461
     9b8:	5a5f006e 	bpl	17c0b78 <__bss_end+0x17b771c>
     9bc:	6f6c6335 	svcvs	0x006c6335
     9c0:	006a6573 	rsbeq	r6, sl, r3, ror r5
     9c4:	73614c6d 	cmnvc	r1, #27904	; 0x6d00
     9c8:	49505f74 	ldmdbmi	r0, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     9cc:	6c420044 	mcrrvs	0, 4, r0, r2, cr4
     9d0:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     9d4:	474e0064 	strbmi	r0, [lr, -r4, rrx]
     9d8:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     9dc:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     9e0:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     9e4:	79545f6f 	ldmdbvc	r4, {r0, r1, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     9e8:	5f006570 	svcpl	0x00006570
     9ec:	6567365a 	strbvs	r3, [r7, #-1626]!	; 0xfffff9a6
     9f0:	64697074 	strbtvs	r7, [r9], #-116	; 0xffffff8c
     9f4:	6e660076 	mcrvs	0, 3, r0, cr6, cr6, {3}
     9f8:	00656d61 	rsbeq	r6, r5, r1, ror #26
     9fc:	6e6e7552 	mcrvs	5, 3, r7, cr14, cr2, {2}
     a00:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     a04:	61544e00 	cmpvs	r4, r0, lsl #28
     a08:	535f6b73 	cmppl	pc, #117760	; 0x1cc00
     a0c:	65746174 	ldrbvs	r6, [r4, #-372]!	; 0xfffffe8c
     a10:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
     a14:	635f6465 	cmpvs	pc, #1694498816	; 0x65000000
     a18:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     a1c:	73007265 	movwvc	r7, #613	; 0x265
     a20:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     a24:	6174735f 	cmnvs	r4, pc, asr r3
     a28:	5f636974 	svcpl	0x00636974
     a2c:	6f697270 	svcvs	0x00697270
     a30:	79746972 	ldmdbvc	r4!, {r1, r4, r5, r6, r8, fp, sp, lr}^
     a34:	69727700 	ldmdbvs	r2!, {r8, r9, sl, ip, sp, lr}^
     a38:	65006574 	strvs	r6, [r0, #-1396]	; 0xfffffa8c
     a3c:	5f746978 	svcpl	0x00746978
     a40:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
     a44:	63697400 	cmnvs	r9, #0, 8
     a48:	6d00736b 	stcvs	3, cr7, [r0, #-428]	; 0xfffffe54
     a4c:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     a50:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     a54:	636e465f 	cmnvs	lr, #99614720	; 0x5f00000
     a58:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
     a5c:	5a5f006e 	bpl	17c0c1c <__bss_end+0x17b77c0>
     a60:	70697034 	rsbvc	r7, r9, r4, lsr r0
     a64:	634b5065 	movtvs	r5, #45157	; 0xb065
     a68:	444e006a 	strbmi	r0, [lr], #-106	; 0xffffff96
     a6c:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     a70:	5f656e69 	svcpl	0x00656e69
     a74:	73627553 	cmnvc	r2, #348127232	; 0x14c00000
     a78:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     a7c:	67006563 	strvs	r6, [r0, -r3, ror #10]
     a80:	745f7465 	ldrbvc	r7, [pc], #-1125	; a88 <_start-0x7578>
     a84:	5f6b6369 	svcpl	0x006b6369
     a88:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     a8c:	6f4e0074 	svcvs	0x004e0074
     a90:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     a94:	72617000 	rsbvc	r7, r1, #0
     a98:	5f006d61 	svcpl	0x00006d61
     a9c:	7277355a 	rsbsvc	r3, r7, #377487360	; 0x16800000
     aa0:	6a657469 	bvs	195dc4c <__bss_end+0x19547f0>
     aa4:	6a634b50 	bvs	18d37ec <__bss_end+0x18ca390>
     aa8:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
     aac:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     ab0:	69745f6b 	ldmdbvs	r4!, {r0, r1, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     ab4:	5f736b63 	svcpl	0x00736b63
     ab8:	645f6f74 	ldrbvs	r6, [pc], #-3956	; ac0 <_start-0x7540>
     abc:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     ac0:	00656e69 	rsbeq	r6, r5, r9, ror #28
     ac4:	5f667562 	svcpl	0x00667562
     ac8:	657a6973 	ldrbvs	r6, [sl, #-2419]!	; 0xfffff68d
     acc:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
     ad0:	2b2b4320 	blcs	ad1758 <__bss_end+0xac82fc>
     ad4:	31203431 			; <UNDEFINED> instruction: 0x31203431
     ad8:	2e332e30 	mrccs	14, 1, r2, cr3, cr0, {1}
     adc:	6d2d2030 	stcvs	0, cr2, [sp, #-192]!	; 0xffffff40
     ae0:	616f6c66 	cmnvs	pc, r6, ror #24
     ae4:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
     ae8:	61683d69 	cmnvs	r8, r9, ror #26
     aec:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
     af0:	7570666d 	ldrbvc	r6, [r0, #-1645]!	; 0xfffff993
     af4:	7066763d 	rsbvc	r7, r6, sp, lsr r6
     af8:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     afc:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
     b00:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
     b04:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
     b08:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
     b0c:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
     b10:	20706676 	rsbscs	r6, r0, r6, ror r6
     b14:	75746d2d 	ldrbvc	r6, [r4, #-3373]!	; 0xfffff2d3
     b18:	613d656e 	teqvs	sp, lr, ror #10
     b1c:	31316d72 	teqcc	r1, r2, ror sp
     b20:	7a6a3637 	bvc	1a8e404 <__bss_end+0x1a84fa8>
     b24:	20732d66 	rsbscs	r2, r3, r6, ror #26
     b28:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
     b2c:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
     b30:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
     b34:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
     b38:	6b7a3676 	blvs	1e8e518 <__bss_end+0x1e850bc>
     b3c:	2070662b 	rsbscs	r6, r0, fp, lsr #12
     b40:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
     b44:	672d2067 	strvs	r2, [sp, -r7, rrx]!
     b48:	304f2d20 	subcc	r2, pc, r0, lsr #26
     b4c:	304f2d20 	subcc	r2, pc, r0, lsr #26
     b50:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
     b54:	78652d6f 	stmdavc	r5!, {r0, r1, r2, r3, r5, r6, r8, sl, fp, sp}^
     b58:	74706563 	ldrbtvc	r6, [r0], #-1379	; 0xfffffa9d
     b5c:	736e6f69 	cmnvc	lr, #420	; 0x1a4
     b60:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
     b64:	74722d6f 	ldrbtvc	r2, [r2], #-3439	; 0xfffff291
     b68:	52006974 	andpl	r6, r0, #116, 18	; 0x1d0000
     b6c:	5f646165 	svcpl	0x00646165
     b70:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
     b74:	6f5a0065 	svcvs	0x005a0065
     b78:	6569626d 	strbvs	r6, [r9, #-621]!	; 0xfffffd93
     b7c:	72627300 	rsbvc	r7, r2, #0, 6
     b80:	6547006b 	strbvs	r0, [r7, #-107]	; 0xffffff95
     b84:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     b88:	5f646568 	svcpl	0x00646568
     b8c:	6f666e49 	svcvs	0x00666e49
     b90:	74657300 	strbtvc	r7, [r5], #-768	; 0xfffffd00
     b94:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     b98:	65645f6b 	strbvs	r5, [r4, #-3947]!	; 0xfffff095
     b9c:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     ba0:	5f00656e 	svcpl	0x0000656e
     ba4:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     ba8:	6f725043 	svcvs	0x00725043
     bac:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     bb0:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     bb4:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     bb8:	68635338 	stmdavs	r3!, {r3, r4, r5, r8, r9, ip, lr}^
     bbc:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     bc0:	00764565 	rsbseq	r4, r6, r5, ror #10
     bc4:	314e5a5f 	cmpcc	lr, pc, asr sl
     bc8:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     bcc:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     bd0:	614d5f73 	hvcvs	54771	; 0xd5f3
     bd4:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     bd8:	4d393172 	ldfmis	f3, [r9, #-456]!	; 0xfffffe38
     bdc:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
     be0:	5f656c69 	svcpl	0x00656c69
     be4:	435f6f54 	cmpmi	pc, #84, 30	; 0x150
     be8:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     bec:	5045746e 	subpl	r7, r5, lr, ror #8
     bf0:	69464935 	stmdbvs	r6, {r0, r2, r4, r5, r8, fp, lr}^
     bf4:	4700656c 	strmi	r6, [r0, -ip, ror #10]
     bf8:	505f7465 	subspl	r7, pc, r5, ror #8
     bfc:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
     c00:	61480073 	hvcvs	32771	; 0x8003
     c04:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     c08:	6d654d5f 	stclvs	13, cr4, [r5, #-380]!	; 0xfffffe84
     c0c:	5f79726f 	svcpl	0x0079726f
     c10:	00495753 	subeq	r5, r9, r3, asr r7
     c14:	314e5a5f 	cmpcc	lr, pc, asr sl
     c18:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     c1c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     c20:	614d5f73 	hvcvs	54771	; 0xd5f3
     c24:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     c28:	53323172 	teqpl	r2, #-2147483620	; 0x8000001c
     c2c:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     c30:	5f656c75 	svcpl	0x00656c75
     c34:	45464445 	strbmi	r4, [r6, #-1093]	; 0xfffffbbb
     c38:	5a5f0076 	bpl	17c0e18 <__bss_end+0x17b79bc>
     c3c:	656c7335 	strbvs	r7, [ip, #-821]!	; 0xfffffccb
     c40:	6a6a7065 	bvs	1a9cddc <__bss_end+0x1a93980>
     c44:	6c696600 	stclvs	6, cr6, [r9], #-0
     c48:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     c4c:	65525f74 	ldrbvs	r5, [r2, #-3956]	; 0xfffff08c
     c50:	6e69616d 	powvsez	f6, f1, #5.0
     c54:	00676e69 	rsbeq	r6, r7, r9, ror #28
     c58:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
     c5c:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 6f8 <_start-0x7908>
     c60:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     c64:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     c68:	69746365 	ldmdbvs	r4!, {r0, r2, r5, r6, r8, r9, sp, lr}^
     c6c:	4e006e6f 	cdpmi	14, 0, cr6, cr0, cr15, {3}
     c70:	5f495753 	svcpl	0x00495753
     c74:	6f6d654d 	svcvs	0x006d654d
     c78:	535f7972 	cmppl	pc, #1867776	; 0x1c8000
     c7c:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     c80:	5f006563 	svcpl	0x00006563
     c84:	6736325a 			; <UNDEFINED> instruction: 0x6736325a
     c88:	745f7465 	ldrbvc	r7, [pc], #-1125	; c90 <_start-0x7370>
     c8c:	5f6b7361 	svcpl	0x006b7361
     c90:	6b636974 	blvs	18db268 <__bss_end+0x18d1e0c>
     c94:	6f745f73 	svcvs	0x00745f73
     c98:	6165645f 	cmnvs	r5, pc, asr r4
     c9c:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     ca0:	4e007665 	cfmadd32mi	mvax3, mvfx7, mvfx0, mvfx5
     ca4:	5f495753 	svcpl	0x00495753
     ca8:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
     cac:	435f746c 	cmpmi	pc, #108, 8	; 0x6c000000
     cb0:	0065646f 	rsbeq	r6, r5, pc, ror #8
     cb4:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
     cb8:	752f632f 	strvc	r6, [pc, #-815]!	; 991 <_start-0x766f>
     cbc:	2f726573 	svccs	0x00726573
     cc0:	76697270 			; <UNDEFINED> instruction: 0x76697270
     cc4:	57657461 	strbpl	r7, [r5, -r1, ror #8]!
     cc8:	736b726f 	cmnvc	fp, #-268435450	; 0xf0000006
     ccc:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     cd0:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
     cd4:	2f6c6f6f 	svccs	0x006c6f6f
     cd8:	532f534f 			; <UNDEFINED> instruction: 0x532f534f
     cdc:	494b2f50 	stmdbmi	fp, {r4, r6, r8, r9, sl, fp, sp}^
     ce0:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
     ce4:	4f2f534f 	svcmi	0x002f534f
     ce8:	7a766564 	bvc	1d9a280 <__bss_end+0x1d90e24>
     cec:	696e6164 	stmdbvs	lr!, {r2, r5, r6, r8, sp, lr}^
     cf0:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     cf4:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
     cf8:	6800646c 	stmdavs	r0, {r2, r3, r5, r6, sl, sp, lr}
     cfc:	5f706165 	svcpl	0x00706165
     d00:	69676f6c 	stmdbvs	r7!, {r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     d04:	5f6c6163 	svcpl	0x006c6163
     d08:	696d696c 	stmdbvs	sp!, {r2, r3, r5, r6, r8, fp, sp, lr}^
     d0c:	72770074 	rsbsvc	r0, r7, #116	; 0x74
     d10:	006d756e 	rsbeq	r7, sp, lr, ror #10
     d14:	77345a5f 			; <UNDEFINED> instruction: 0x77345a5f
     d18:	6a746961 	bvs	1d1b2a4 <__bss_end+0x1d11e48>
     d1c:	5f006a6a 	svcpl	0x00006a6a
     d20:	6f69355a 	svcvs	0x0069355a
     d24:	6a6c7463 	bvs	1b1deb8 <__bss_end+0x1b14a5c>
     d28:	494e3631 	stmdbmi	lr, {r0, r4, r5, r9, sl, ip, sp}^
     d2c:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
     d30:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
     d34:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
     d38:	76506e6f 	ldrbvc	r6, [r0], -pc, ror #28
     d3c:	636f6900 	cmnvs	pc, #0, 18
     d40:	72006c74 	andvc	r6, r0, #116, 24	; 0x7400
     d44:	6e637465 	cdpvs	4, 6, cr7, cr3, cr5, {3}
     d48:	436d0074 	cmnmi	sp, #116	; 0x74
     d4c:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     d50:	545f746e 	ldrbpl	r7, [pc], #-1134	; d58 <_start-0x72a8>
     d54:	5f6b7361 	svcpl	0x006b7361
     d58:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
     d5c:	746f6e00 	strbtvc	r6, [pc], #-3584	; d64 <_start-0x729c>
     d60:	00796669 	rsbseq	r6, r9, r9, ror #12
     d64:	6d726574 	cfldr64vs	mvdx6, [r2, #-464]!	; 0xfffffe30
     d68:	74616e69 	strbtvc	r6, [r1], #-3689	; 0xfffff197
     d6c:	6f6d0065 	svcvs	0x006d0065
     d70:	63006564 	movwvs	r6, #1380	; 0x564
     d74:	635f7570 	cmpvs	pc, #112, 10	; 0x1c000000
     d78:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
     d7c:	52007478 	andpl	r7, r0, #120, 8	; 0x78000000
     d80:	5f646165 	svcpl	0x00646165
     d84:	796c6e4f 	stmdbvc	ip!, {r0, r1, r2, r3, r6, r9, sl, fp, sp, lr}^
     d88:	66756200 	ldrbtvs	r6, [r5], -r0, lsl #4
     d8c:	00726566 	rsbseq	r6, r2, r6, ror #10
     d90:	65656c73 	strbvs	r6, [r5, #-3187]!	; 0xfffff38d
     d94:	69745f70 	ldmdbvs	r4!, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     d98:	0072656d 	rsbseq	r6, r2, sp, ror #10
     d9c:	4b4e5a5f 	blmi	1397720 <__bss_end+0x138e2c4>
     da0:	50433631 	subpl	r3, r3, r1, lsr r6
     da4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     da8:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; be4 <_start-0x741c>
     dac:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     db0:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     db4:	5f746547 	svcpl	0x00746547
     db8:	636f7250 	cmnvs	pc, #80, 4
     dbc:	5f737365 	svcpl	0x00737365
     dc0:	505f7942 	subspl	r7, pc, r2, asr #18
     dc4:	6a454449 	bvs	1151ef0 <__bss_end+0x1148a94>
     dc8:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     dcc:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     dd0:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     dd4:	6f72505f 	svcvs	0x0072505f
     dd8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     ddc:	6e614800 	cdpvs	8, 6, cr4, cr1, cr0, {0}
     de0:	5f656c64 	svcpl	0x00656c64
     de4:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     de8:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     dec:	535f6d65 	cmppl	pc, #6464	; 0x1940
     df0:	5f004957 	svcpl	0x00004957
     df4:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     df8:	6f725043 	svcvs	0x00725043
     dfc:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     e00:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     e04:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     e08:	63533131 	cmpvs	r3, #1073741836	; 0x4000000c
     e0c:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     e10:	525f656c 	subspl	r6, pc, #108, 10	; 0x1b000000
     e14:	00764552 	rsbseq	r4, r6, r2, asr r5
     e18:	6b736174 	blvs	1cd93f0 <__bss_end+0x1ccff94>
     e1c:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
     e20:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
     e24:	6a63506a 	bvs	18d4fd4 <__bss_end+0x18cbb78>
     e28:	746f4e00 	strbtvc	r4, [pc], #-3584	; e30 <_start-0x71d0>
     e2c:	5f796669 	svcpl	0x00796669
     e30:	636f7250 	cmnvs	pc, #80, 4
     e34:	00737365 	rsbseq	r7, r3, r5, ror #6
     e38:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     e3c:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     e40:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     e44:	50433631 	subpl	r3, r3, r1, lsr r6
     e48:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     e4c:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; c88 <_start-0x7378>
     e50:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     e54:	53397265 	teqpl	r9, #1342177286	; 0x50000006
     e58:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
     e5c:	6f545f68 	svcvs	0x00545f68
     e60:	38315045 	ldmdacc	r1!, {r0, r2, r6, ip, lr}
     e64:	6f725043 	svcvs	0x00725043
     e68:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     e6c:	73694c5f 	cmnvc	r9, #24320	; 0x5f00
     e70:	6f4e5f74 	svcvs	0x004e5f74
     e74:	53006564 	movwpl	r6, #1380	; 0x564
     e78:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     e7c:	5f656c75 	svcpl	0x00656c75
     e80:	5f005252 	svcpl	0x00005252
     e84:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     e88:	6f725043 	svcvs	0x00725043
     e8c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     e90:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     e94:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     e98:	61483831 	cmpvs	r8, r1, lsr r8
     e9c:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     ea0:	6f72505f 	svcvs	0x0072505f
     ea4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     ea8:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     eac:	4e303245 	cdpmi	2, 3, cr3, cr0, cr5, {2}
     eb0:	5f495753 	svcpl	0x00495753
     eb4:	636f7250 	cmnvs	pc, #80, 4
     eb8:	5f737365 	svcpl	0x00737365
     ebc:	76726553 			; <UNDEFINED> instruction: 0x76726553
     ec0:	6a656369 	bvs	1959c6c <__bss_end+0x1950810>
     ec4:	31526a6a 	cmpcc	r2, sl, ror #20
     ec8:	57535431 	smmlarpl	r3, r1, r4, r5
     ecc:	65525f49 	ldrbvs	r5, [r2, #-3913]	; 0xfffff0b7
     ed0:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
     ed4:	4f494e00 	svcmi	0x00494e00
     ed8:	5f6c7443 	svcpl	0x006c7443
     edc:	7265704f 	rsbvc	r7, r5, #79	; 0x4f
     ee0:	6f697461 	svcvs	0x00697461
     ee4:	5a5f006e 	bpl	17c10a4 <__bss_end+0x17b7c48>
     ee8:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     eec:	636f7250 	cmnvs	pc, #80, 4
     ef0:	5f737365 	svcpl	0x00737365
     ef4:	616e614d 	cmnvs	lr, sp, asr #2
     ef8:	31726567 	cmncc	r2, r7, ror #10
     efc:	65724334 	ldrbvs	r4, [r2, #-820]!	; 0xfffffccc
     f00:	5f657461 	svcpl	0x00657461
     f04:	636f7250 	cmnvs	pc, #80, 4
     f08:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     f0c:	626a6850 	rsbvs	r6, sl, #80, 16	; 0x500000
     f10:	69775300 	ldmdbvs	r7!, {r8, r9, ip, lr}^
     f14:	5f686374 	svcpl	0x00686374
     f18:	4e006f54 	mcrmi	15, 0, r6, cr0, cr4, {2}
     f1c:	5f495753 	svcpl	0x00495753
     f20:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     f24:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     f28:	535f6d65 	cmppl	pc, #6464	; 0x1940
     f2c:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     f30:	72006563 	andvc	r6, r0, #415236096	; 0x18c00000
     f34:	6f637465 	svcvs	0x00637465
     f38:	67006564 	strvs	r6, [r0, -r4, ror #10]
     f3c:	615f7465 	cmpvs	pc, r5, ror #8
     f40:	76697463 	strbtvc	r7, [r9], -r3, ror #8
     f44:	72705f65 	rsbsvc	r5, r0, #404	; 0x194
     f48:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     f4c:	6f635f73 	svcvs	0x00635f73
     f50:	00746e75 	rsbseq	r6, r4, r5, ror lr
     f54:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     f58:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
     f5c:	6f6c4200 	svcvs	0x006c4200
     f60:	435f6b63 	cmpmi	pc, #101376	; 0x18c00
     f64:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     f68:	505f746e 	subspl	r7, pc, lr, ror #8
     f6c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     f70:	72007373 	andvc	r7, r0, #-872415231	; 0xcc000001
     f74:	00646165 	rsbeq	r6, r4, r5, ror #2
     f78:	736f6c43 	cmnvc	pc, #17152	; 0x4300
     f7c:	65680065 	strbvs	r0, [r8, #-101]!	; 0xffffff9b
     f80:	735f7061 	cmpvc	pc, #97	; 0x61
     f84:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
     f88:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
     f8c:	00646970 	rsbeq	r6, r4, r0, ror r9
     f90:	6f345a5f 	svcvs	0x00345a5f
     f94:	506e6570 	rsbpl	r6, lr, r0, ror r5
     f98:	3531634b 	ldrcc	r6, [r1, #-843]!	; 0xfffffcb5
     f9c:	6c69464e 	stclvs	6, cr4, [r9], #-312	; 0xfffffec8
     fa0:	704f5f65 	subvc	r5, pc, r5, ror #30
     fa4:	4d5f6e65 	ldclmi	14, cr6, [pc, #-404]	; e18 <_start-0x71e8>
     fa8:	0065646f 	rsbeq	r6, r5, pc, ror #8
     fac:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
     fb0:	6e4f5f65 	cdpvs	15, 4, cr5, cr15, cr5, {3}
     fb4:	5900796c 	stmdbpl	r0, {r2, r3, r5, r6, r8, fp, ip, sp, lr}
     fb8:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
     fbc:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     fc0:	50433631 	subpl	r3, r3, r1, lsr r6
     fc4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     fc8:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; e04 <_start-0x71fc>
     fcc:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     fd0:	34437265 	strbcc	r7, [r3], #-613	; 0xfffffd9b
     fd4:	54007645 	strpl	r7, [r0], #-1605	; 0xfffff9bb
     fd8:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     fdc:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
     fe0:	434f4900 	movtmi	r4, #63744	; 0xf900
     fe4:	52006c74 	andpl	r6, r0, #116, 24	; 0x7400
     fe8:	696e6e75 	stmdbvs	lr!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     fec:	6e00676e 	cdpvs	7, 0, cr6, cr0, cr14, {3}
     ff0:	616d726f 	cmnvs	sp, pc, ror #4
     ff4:	657a696c 	ldrbvs	r6, [sl, #-2412]!	; 0xfffff694
     ff8:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
     ffc:	636d656d 	cmnvs	sp, #457179136	; 0x1b400000
    1000:	4b507970 	blmi	141f5c8 <__bss_end+0x141616c>
    1004:	69765076 	ldmdbvs	r6!, {r1, r2, r4, r5, r6, ip, lr}^
    1008:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
    100c:	2f632f74 	svccs	0x00632f74
    1010:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
    1014:	6972702f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, ip, sp, lr}^
    1018:	65746176 	ldrbvs	r6, [r4, #-374]!	; 0xfffffe8a
    101c:	6b726f57 	blvs	1c9cd80 <__bss_end+0x1c93924>
    1020:	63617073 	cmnvs	r1, #115	; 0x73
    1024:	63532f65 	cmpvs	r3, #404	; 0x194
    1028:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; e90 <_start-0x7170>
    102c:	2f534f2f 	svccs	0x00534f2f
    1030:	4b2f5053 	blmi	bd5184 <__bss_end+0xbcbd28>
    1034:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
    1038:	2f534f54 	svccs	0x00534f54
    103c:	7665644f 	strbtvc	r6, [r5], -pc, asr #8
    1040:	6e61647a 	mcrvs	4, 3, r6, cr1, cr10, {3}
    1044:	72732f69 	rsbsvc	r2, r3, #420	; 0x1a4
    1048:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
    104c:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
    1050:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    1054:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    1058:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    105c:	632e676e 			; <UNDEFINED> instruction: 0x632e676e
    1060:	66007070 			; <UNDEFINED> instruction: 0x66007070
    1064:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    1068:	6e736900 	vaddvs.f16	s13, s6, s0	; <UNPREDICTABLE>
    106c:	76006e61 	strvc	r6, [r0], -r1, ror #28
    1070:	65756c61 	ldrbvs	r6, [r5, #-3169]!	; 0xfffff39f
    1074:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1078:	616f7469 	cmnvs	pc, r9, ror #8
    107c:	6a63506a 	bvs	18d522c <__bss_end+0x18cbdd0>
    1080:	70786500 	rsbsvc	r6, r8, r0, lsl #10
    1084:	6e656e6f 	cdpvs	14, 6, cr6, cr5, cr15, {3}
    1088:	74610074 	strbtvc	r0, [r1], #-116	; 0xffffff8c
    108c:	7300696f 	movwvc	r6, #2415	; 0x96f
    1090:	656c7274 	strbvs	r7, [ip, #-628]!	; 0xfffffd8c
    1094:	5a5f006e 	bpl	17c1254 <__bss_end+0x17b7df8>
    1098:	6f746134 	svcvs	0x00746134
    109c:	634b5066 	movtvs	r5, #45158	; 0xb066
    10a0:	73656400 	cmnvc	r5, #0, 8
    10a4:	5a5f0074 	bpl	17c127c <__bss_end+0x17b7e20>
    10a8:	6e736935 			; <UNDEFINED> instruction: 0x6e736935
    10ac:	4b506e61 	blmi	141ca38 <__bss_end+0x14135dc>
    10b0:	73006263 	movwvc	r6, #611	; 0x263
    10b4:	006e6769 	rsbeq	r6, lr, r9, ror #14
    10b8:	616f7469 	cmnvs	pc, r9, ror #8
    10bc:	72747300 	rsbsvc	r7, r4, #0, 6
    10c0:	00746163 	rsbseq	r6, r4, r3, ror #2
    10c4:	62355a5f 	eorsvs	r5, r5, #389120	; 0x5f000
    10c8:	6f72657a 	svcvs	0x0072657a
    10cc:	00697650 	rsbeq	r7, r9, r0, asr r6
    10d0:	6c467369 	mcrrvs	3, 6, r7, r6, cr9
    10d4:	0074616f 	rsbseq	r6, r4, pc, ror #2
    10d8:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    10dc:	00797063 	rsbseq	r7, r9, r3, rrx
    10e0:	66345a5f 			; <UNDEFINED> instruction: 0x66345a5f
    10e4:	50616f74 	rsbpl	r6, r1, r4, ror pc
    10e8:	69006663 	stmdbvs	r0, {r0, r1, r5, r6, r9, sl, sp, lr}
    10ec:	7475706e 	ldrbtvc	r7, [r5], #-110	; 0xffffff92
    10f0:	375a5f00 	ldrbcc	r5, [sl, -r0, lsl #30]
    10f4:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    10f8:	50797063 	rsbspl	r7, r9, r3, rrx
    10fc:	634b5063 	movtvs	r5, #45155	; 0xb063
    1100:	5a5f0069 	bpl	17c12ac <__bss_end+0x17b7e50>
    1104:	72747336 	rsbsvc	r7, r4, #-671088640	; 0xd8000000
    1108:	50746163 	rsbspl	r6, r4, r3, ror #2
    110c:	634b5063 	movtvs	r5, #45155	; 0xb063
    1110:	395a5f00 	ldmdbcc	sl, {r8, r9, sl, fp, ip, lr}^
    1114:	6d726f6e 	ldclvs	15, cr6, [r2, #-440]!	; 0xfffffe48
    1118:	7a696c61 	bvc	1a5c2a4 <__bss_end+0x1a52e48>
    111c:	00665065 	rsbeq	r5, r6, r5, rrx
    1120:	69676964 	stmdbvs	r7!, {r2, r5, r6, r8, fp, sp, lr}^
    1124:	74610074 	strbtvc	r0, [r1], #-116	; 0xffffff8c
    1128:	6d00666f 	stcvs	6, cr6, [r0, #-444]	; 0xfffffe44
    112c:	73646d65 	cmnvc	r4, #6464	; 0x1940
    1130:	68430074 	stmdavs	r3, {r2, r4, r5, r6}^
    1134:	6f437261 	svcvs	0x00437261
    1138:	7241766e 	subvc	r7, r1, #115343360	; 0x6e00000
    113c:	74660072 	strbtvc	r0, [r6], #-114	; 0xffffff8e
    1140:	6d00616f 	stfvss	f6, [r0, #-444]	; 0xfffffe44
    1144:	72736d65 	rsbsvc	r6, r3, #6464	; 0x1940
    1148:	7a620063 	bvc	18812dc <__bss_end+0x1877e80>
    114c:	006f7265 	rsbeq	r7, pc, r5, ror #4
    1150:	636d656d 	cmnvs	sp, #457179136	; 0x1b400000
    1154:	62007970 	andvs	r7, r0, #112, 18	; 0x1c0000
    1158:	00657361 	rsbeq	r7, r5, r1, ror #6
    115c:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    1160:	00706d63 	rsbseq	r6, r0, r3, ror #26
    1164:	74646977 	strbtvc	r6, [r4], #-2423	; 0xfffff689
    1168:	5a5f0068 	bpl	17c1310 <__bss_end+0x17b7eb4>
    116c:	72747336 	rsbsvc	r7, r4, #-671088640	; 0xd8000000
    1170:	506e656c 	rsbpl	r6, lr, ip, ror #10
    1174:	5f00634b 	svcpl	0x0000634b
    1178:	7473375a 	ldrbtvc	r3, [r3], #-1882	; 0xfffff8a6
    117c:	6d636e72 	stclvs	14, cr6, [r3, #-456]!	; 0xfffffe38
    1180:	634b5070 	movtvs	r5, #45168	; 0xb070
    1184:	695f3053 	ldmdbvs	pc, {r0, r1, r4, r6, ip, sp}^	; <UNPREDICTABLE>
    1188:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    118c:	696f7461 	stmdbvs	pc!, {r0, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1190:	00634b50 	rsbeq	r4, r3, r0, asr fp
    1194:	7074756f 	rsbsvc	r7, r4, pc, ror #10
    1198:	6d007475 	cfstrsvs	mvf7, [r0, #-468]	; 0xfffffe2c
    119c:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
    11a0:	656c0079 	strbvs	r0, [ip, #-121]!	; 0xffffff87
    11a4:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
    11a8:	616c7000 	cmnvs	ip, r0
    11ac:	00736563 	rsbseq	r6, r3, r3, ror #10

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
  20:	8b040e42 	blhi	103930 <__bss_end+0xfa4d4>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x3473d4>
  28:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008064 	andeq	r8, r0, r4, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1fa4f4>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf9824>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a4 	andeq	r8, r0, r4, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xfa524>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x347424>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080dc 	ldrdeq	r8, [r0], -ip
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xfa544>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x347444>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008108 	andeq	r8, r0, r8, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xfa564>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x347464>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008128 	andeq	r8, r0, r8, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xfa584>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x347484>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008140 	andeq	r8, r0, r0, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xfa5a4>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x3474a4>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008158 	andeq	r8, r0, r8, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xfa5c4>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x3474c4>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008170 	andeq	r8, r0, r0, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xfa5e4>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x3474e4>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	0000817c 	andeq	r8, r0, ip, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1fa5fc>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d4 	ldrdeq	r8, [r0], -r4
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1fa61c>
 16c:	42018e02 	andmi	r8, r1, #2, 28
 170:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 174:	00080d0c 	andeq	r0, r8, ip, lsl #26
 178:	0000000c 	andeq	r0, r0, ip
 17c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 180:	7c020001 	stcvc	0, cr0, [r2], {1}
 184:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 188:	00000018 	andeq	r0, r0, r8, lsl r0
 18c:	00000178 	andeq	r0, r0, r8, ror r1
 190:	0000822c 	andeq	r8, r0, ip, lsr #4
 194:	00000048 	andeq	r0, r0, r8, asr #32
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1fa64c>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1a4:	0000000c 	andeq	r0, r0, ip
 1a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1ac:	7c020001 	stcvc	0, cr0, [r2], {1}
 1b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1bc:	00008274 	andeq	r8, r0, r4, ror r2
 1c0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1c4:	8b040e42 	blhi	103ad4 <__bss_end+0xfa678>
 1c8:	0b0d4201 	bleq	3509d4 <__bss_end+0x347578>
 1cc:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1dc:	000082a0 	andeq	r8, r0, r0, lsr #5
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xfa698>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x347598>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1fc:	000082cc 	andeq	r8, r0, ip, asr #5
 200:	0000001c 	andeq	r0, r0, ip, lsl r0
 204:	8b040e42 	blhi	103b14 <__bss_end+0xfa6b8>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x3475b8>
 20c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001a4 	andeq	r0, r0, r4, lsr #3
 21c:	000082e8 	andeq	r8, r0, r8, ror #5
 220:	00000044 	andeq	r0, r0, r4, asr #32
 224:	8b040e42 	blhi	103b34 <__bss_end+0xfa6d8>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x3475d8>
 22c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001a4 	andeq	r0, r0, r4, lsr #3
 23c:	0000832c 	andeq	r8, r0, ip, lsr #6
 240:	00000050 	andeq	r0, r0, r0, asr r0
 244:	8b040e42 	blhi	103b54 <__bss_end+0xfa6f8>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x3475f8>
 24c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001a4 	andeq	r0, r0, r4, lsr #3
 25c:	0000837c 	andeq	r8, r0, ip, ror r3
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xfa718>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x347618>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001a4 	andeq	r0, r0, r4, lsr #3
 27c:	000083cc 	andeq	r8, r0, ip, asr #7
 280:	0000002c 	andeq	r0, r0, ip, lsr #32
 284:	8b040e42 	blhi	103b94 <__bss_end+0xfa738>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x347638>
 28c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001a4 	andeq	r0, r0, r4, lsr #3
 29c:	000083f8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 2a0:	00000050 	andeq	r0, r0, r0, asr r0
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xfa758>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x347658>
 2ac:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2bc:	00008448 	andeq	r8, r0, r8, asr #8
 2c0:	00000044 	andeq	r0, r0, r4, asr #32
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xfa778>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x347678>
 2cc:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2dc:	0000848c 	andeq	r8, r0, ip, lsl #9
 2e0:	00000050 	andeq	r0, r0, r0, asr r0
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xfa798>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x347698>
 2ec:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2fc:	000084dc 	ldrdeq	r8, [r0], -ip
 300:	00000054 	andeq	r0, r0, r4, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xfa7b8>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x3476b8>
 30c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001a4 	andeq	r0, r0, r4, lsr #3
 31c:	00008530 	andeq	r8, r0, r0, lsr r5
 320:	0000003c 	andeq	r0, r0, ip, lsr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xfa7d8>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x3476d8>
 32c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001a4 	andeq	r0, r0, r4, lsr #3
 33c:	0000856c 	andeq	r8, r0, ip, ror #10
 340:	0000003c 	andeq	r0, r0, ip, lsr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xfa7f8>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x3476f8>
 34c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001a4 	andeq	r0, r0, r4, lsr #3
 35c:	000085a8 	andeq	r8, r0, r8, lsr #11
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xfa818>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x347718>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001a4 	andeq	r0, r0, r4, lsr #3
 37c:	000085e4 	andeq	r8, r0, r4, ror #11
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xfa838>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x347738>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001a4 	andeq	r0, r0, r4, lsr #3
 39c:	00008620 	andeq	r8, r0, r0, lsr #12
 3a0:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 3a4:	8b080e42 	blhi	203cb4 <__bss_end+0x1fa858>
 3a8:	42018e02 	andmi	r8, r1, #2, 28
 3ac:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3b0:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 3b4:	0000000c 	andeq	r0, r0, ip
 3b8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3bc:	7c020001 	stcvc	0, cr0, [r2], {1}
 3c0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3c8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3cc:	000086d0 	ldrdeq	r8, [r0], -r0
 3d0:	00000174 	andeq	r0, r0, r4, ror r1
 3d4:	8b080e42 	blhi	203ce4 <__bss_end+0x1fa888>
 3d8:	42018e02 	andmi	r8, r1, #2, 28
 3dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3e0:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3ec:	00008844 	andeq	r8, r0, r4, asr #16
 3f0:	000000b8 	strheq	r0, [r0], -r8
 3f4:	8b080e42 	blhi	203d04 <__bss_end+0x1fa8a8>
 3f8:	42018e02 	andmi	r8, r1, #2, 28
 3fc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 400:	080d0c56 	stmdaeq	sp, {r1, r2, r4, r6, sl, fp}
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 40c:	000088fc 	strdeq	r8, [r0], -ip
 410:	000000c4 	andeq	r0, r0, r4, asr #1
 414:	8b040e42 	blhi	103d24 <__bss_end+0xfa8c8>
 418:	0b0d4201 	bleq	350c24 <__bss_end+0x3477c8>
 41c:	0d0d5202 	sfmeq	f5, 4, [sp, #-8]
 420:	000ecb42 	andeq	ip, lr, r2, asr #22
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 42c:	000089c0 	andeq	r8, r0, r0, asr #19
 430:	000000dc 	ldrdeq	r0, [r0], -ip
 434:	8b080e42 	blhi	203d44 <__bss_end+0x1fa8e8>
 438:	42018e02 	andmi	r8, r1, #2, 28
 43c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 440:	080d0c68 	stmdaeq	sp, {r3, r5, r6, sl, fp}
 444:	00000020 	andeq	r0, r0, r0, lsr #32
 448:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 44c:	00008a9c 	muleq	r0, ip, sl
 450:	000002b8 			; <UNDEFINED> instruction: 0x000002b8
 454:	8b040e42 	blhi	103d64 <__bss_end+0xfa908>
 458:	0b0d4201 	bleq	350c64 <__bss_end+0x347808>
 45c:	0d014803 	stceq	8, cr4, [r1, #-12]
 460:	0ecb420d 	cdpeq	2, 12, cr4, cr11, cr13, {0}
 464:	00000000 	andeq	r0, r0, r0
 468:	00000020 	andeq	r0, r0, r0, lsr #32
 46c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 470:	00008d54 	andeq	r8, r0, r4, asr sp
 474:	00000238 	andeq	r0, r0, r8, lsr r2
 478:	8b080e42 	blhi	203d88 <__bss_end+0x1fa92c>
 47c:	42018e02 	andmi	r8, r1, #2, 28
 480:	03040b0c 	movweq	r0, #19212	; 0x4b0c
 484:	0d0c0110 	stfeqs	f0, [ip, #-64]	; 0xffffffc0
 488:	00000008 	andeq	r0, r0, r8
 48c:	0000001c 	andeq	r0, r0, ip, lsl r0
 490:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 494:	00008f8c 	andeq	r8, r0, ip, lsl #31
 498:	000000c0 	andeq	r0, r0, r0, asr #1
 49c:	8b040e42 	blhi	103dac <__bss_end+0xfa950>
 4a0:	0b0d4201 	bleq	350cac <__bss_end+0x347850>
 4a4:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 4a8:	000ecb42 	andeq	ip, lr, r2, asr #22
 4ac:	0000001c 	andeq	r0, r0, ip, lsl r0
 4b0:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4b4:	0000904c 	andeq	r9, r0, ip, asr #32
 4b8:	000000d4 	ldrdeq	r0, [r0], -r4
 4bc:	8b040e42 	blhi	103dcc <__bss_end+0xfa970>
 4c0:	0b0d4201 	bleq	350ccc <__bss_end+0x347870>
 4c4:	0d0d6202 	sfmeq	f6, 4, [sp, #-8]
 4c8:	000ecb42 	andeq	ip, lr, r2, asr #22
 4cc:	0000001c 	andeq	r0, r0, ip, lsl r0
 4d0:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4d4:	00009120 	andeq	r9, r0, r0, lsr #2
 4d8:	000000ac 	andeq	r0, r0, ip, lsr #1
 4dc:	8b040e42 	blhi	103dec <__bss_end+0xfa990>
 4e0:	0b0d4201 	bleq	350cec <__bss_end+0x347890>
 4e4:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 4e8:	000ecb42 	andeq	ip, lr, r2, asr #22
 4ec:	0000001c 	andeq	r0, r0, ip, lsl r0
 4f0:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4f4:	000091cc 	andeq	r9, r0, ip, asr #3
 4f8:	00000054 	andeq	r0, r0, r4, asr r0
 4fc:	8b040e42 	blhi	103e0c <__bss_end+0xfa9b0>
 500:	0b0d4201 	bleq	350d0c <__bss_end+0x3478b0>
 504:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 508:	00000ecb 	andeq	r0, r0, fp, asr #29
 50c:	0000001c 	andeq	r0, r0, ip, lsl r0
 510:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 514:	00009220 	andeq	r9, r0, r0, lsr #4
 518:	00000068 	andeq	r0, r0, r8, rrx
 51c:	8b040e42 	blhi	103e2c <__bss_end+0xfa9d0>
 520:	0b0d4201 	bleq	350d2c <__bss_end+0x3478d0>
 524:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 528:	00000ecb 	andeq	r0, r0, fp, asr #29
 52c:	0000001c 	andeq	r0, r0, ip, lsl r0
 530:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 534:	00009288 	andeq	r9, r0, r8, lsl #5
 538:	00000080 	andeq	r0, r0, r0, lsl #1
 53c:	8b040e42 	blhi	103e4c <__bss_end+0xfa9f0>
 540:	0b0d4201 	bleq	350d4c <__bss_end+0x3478f0>
 544:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 548:	00000ecb 	andeq	r0, r0, fp, asr #29
