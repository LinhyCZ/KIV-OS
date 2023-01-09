
./init_task:     file format elf32-littlearm


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
    805c:	0000944c 	andeq	r9, r0, ip, asr #8
    8060:	0000945c 	andeq	r9, r0, ip, asr r4

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
    8080:	eb000069 	bl	822c <main>
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
    81cc:	00009449 	andeq	r9, r0, r9, asr #8
    81d0:	00009449 	andeq	r9, r0, r9, asr #8

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
    8224:	00009449 	andeq	r9, r0, r9, asr #8
    8228:	00009449 	andeq	r9, r0, r9, asr #8

0000822c <main>:
main():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/init_task/main.cpp:6
#include <stdfile.h>

#include <process/process_manager.h>

int main(int argc, char** argv)
{
    822c:	e92d4800 	push	{fp, lr}
    8230:	e28db004 	add	fp, sp, #4
    8234:	e24dd008 	sub	sp, sp, #8
    8238:	e50b0008 	str	r0, [fp, #-8]
    823c:	e50b100c 	str	r1, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/init_task/main.cpp:11
	// systemovy init task startuje jako prvni, a ma nejnizsi prioritu ze vsech - bude se tedy planovat v podstate jen tehdy,
	// kdy nic jineho nikdo nema na praci

	// nastavime deadline na "nekonecno" = vlastne snizime dynamickou prioritu na nejnizsi moznou
	set_task_deadline(Indefinite);
    8240:	e3e00000 	mvn	r0, #0
    8244:	eb0000d7 	bl	85a8 <_Z17set_task_deadlinej>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/init_task/main.cpp:18
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
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/init_task/main.cpp:19
			asm volatile("wfe");
    8268:	e320f002 	wfe
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/init_task/main.cpp:22

		// predame zbytek casoveho kvanta dalsimu procesu
		sched_yield();
    826c:	eb000016 	bl	82cc <_Z11sched_yieldv>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/userspace/init_task/main.cpp:18
		if (get_active_process_count() == 1)
    8270:	eafffff4 	b	8248 <main+0x1c>

00008274 <_Z6getpidv>:
_Z6getpidv():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    8274:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8278:	e28db000 	add	fp, sp, #0
    827c:	e24dd00c 	sub	sp, sp, #12
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    8280:	ef000000 	svc	0x00000000
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    8284:	e1a03000 	mov	r3, r0
    8288:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:11

    return pid;
    828c:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:12
}
    8290:	e1a00003 	mov	r0, r3
    8294:	e28bd000 	add	sp, fp, #0
    8298:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    829c:	e12fff1e 	bx	lr

000082a0 <_Z9terminatei>:
_Z9terminatei():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    82a0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82a4:	e28db000 	add	fp, sp, #0
    82a8:	e24dd00c 	sub	sp, sp, #12
    82ac:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r" (exitcode));
    82b0:	e51b3008 	ldr	r3, [fp, #-8]
    82b4:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    82b8:	ef000001 	svc	0x00000001
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:18
}
    82bc:	e320f000 	nop	{0}
    82c0:	e28bd000 	add	sp, fp, #0
    82c4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    82c8:	e12fff1e 	bx	lr

000082cc <_Z11sched_yieldv>:
_Z11sched_yieldv():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    82cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82d0:	e28db000 	add	fp, sp, #0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    82d4:	ef000002 	svc	0x00000002
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:23
}
    82d8:	e320f000 	nop	{0}
    82dc:	e28bd000 	add	sp, fp, #0
    82e0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    82e4:	e12fff1e 	bx	lr

000082e8 <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    82e8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82ec:	e28db000 	add	fp, sp, #0
    82f0:	e24dd014 	sub	sp, sp, #20
    82f4:	e50b0010 	str	r0, [fp, #-16]
    82f8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    82fc:	e51b3010 	ldr	r3, [fp, #-16]
    8300:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r" (mode));
    8304:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8308:	e1a01003 	mov	r1, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    830c:	ef000040 	svc	0x00000040
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r" (file));
    8310:	e1a03000 	mov	r3, r0
    8314:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:34

    return file;
    8318:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:35
}
    831c:	e1a00003 	mov	r0, r3
    8320:	e28bd000 	add	sp, fp, #0
    8324:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8328:	e12fff1e 	bx	lr

0000832c <_Z4readjPcj>:
_Z4readjPcj():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    832c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8330:	e28db000 	add	fp, sp, #0
    8334:	e24dd01c 	sub	sp, sp, #28
    8338:	e50b0010 	str	r0, [fp, #-16]
    833c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8340:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8344:	e51b3010 	ldr	r3, [fp, #-16]
    8348:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r" (buffer));
    834c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8350:	e1a01003 	mov	r1, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r" (size));
    8354:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8358:	e1a02003 	mov	r2, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    835c:	ef000041 	svc	0x00000041
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r" (rdnum));
    8360:	e1a03000 	mov	r3, r0
    8364:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:47

    return rdnum;
    8368:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:48
}
    836c:	e1a00003 	mov	r0, r3
    8370:	e28bd000 	add	sp, fp, #0
    8374:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8378:	e12fff1e 	bx	lr

0000837c <_Z5writejPKcj>:
_Z5writejPKcj():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:51

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    837c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8380:	e28db000 	add	fp, sp, #0
    8384:	e24dd01c 	sub	sp, sp, #28
    8388:	e50b0010 	str	r0, [fp, #-16]
    838c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8390:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:54
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8394:	e51b3010 	ldr	r3, [fp, #-16]
    8398:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:55
    asm volatile("mov r1, %0" : : "r" (buffer));
    839c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    83a0:	e1a01003 	mov	r1, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:56
    asm volatile("mov r2, %0" : : "r" (size));
    83a4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    83a8:	e1a02003 	mov	r2, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:57
    asm volatile("swi 66");
    83ac:	ef000042 	svc	0x00000042
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:58
    asm volatile("mov %0, r0" : "=r" (wrnum));
    83b0:	e1a03000 	mov	r3, r0
    83b4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:60

    return wrnum;
    83b8:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:61
}
    83bc:	e1a00003 	mov	r0, r3
    83c0:	e28bd000 	add	sp, fp, #0
    83c4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83c8:	e12fff1e 	bx	lr

000083cc <_Z5closej>:
_Z5closej():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:64

void close(uint32_t file)
{
    83cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83d0:	e28db000 	add	fp, sp, #0
    83d4:	e24dd00c 	sub	sp, sp, #12
    83d8:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:65
    asm volatile("mov r0, %0" : : "r" (file));
    83dc:	e51b3008 	ldr	r3, [fp, #-8]
    83e0:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:66
    asm volatile("swi 67");
    83e4:	ef000043 	svc	0x00000043
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:67
}
    83e8:	e320f000 	nop	{0}
    83ec:	e28bd000 	add	sp, fp, #0
    83f0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83f4:	e12fff1e 	bx	lr

000083f8 <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:70

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    83f8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83fc:	e28db000 	add	fp, sp, #0
    8400:	e24dd01c 	sub	sp, sp, #28
    8404:	e50b0010 	str	r0, [fp, #-16]
    8408:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    840c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:73
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    8410:	e51b3010 	ldr	r3, [fp, #-16]
    8414:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:74
    asm volatile("mov r1, %0" : : "r" (operation));
    8418:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    841c:	e1a01003 	mov	r1, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:75
    asm volatile("mov r2, %0" : : "r" (param));
    8420:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8424:	e1a02003 	mov	r2, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:76
    asm volatile("swi 68");
    8428:	ef000044 	svc	0x00000044
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:77
    asm volatile("mov %0, r0" : "=r" (retcode));
    842c:	e1a03000 	mov	r3, r0
    8430:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:79

    return retcode;
    8434:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:80
}
    8438:	e1a00003 	mov	r0, r3
    843c:	e28bd000 	add	sp, fp, #0
    8440:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8444:	e12fff1e 	bx	lr

00008448 <_Z6notifyjj>:
_Z6notifyjj():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:83

uint32_t notify(uint32_t file, uint32_t count)
{
    8448:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    844c:	e28db000 	add	fp, sp, #0
    8450:	e24dd014 	sub	sp, sp, #20
    8454:	e50b0010 	str	r0, [fp, #-16]
    8458:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:86
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    845c:	e51b3010 	ldr	r3, [fp, #-16]
    8460:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:87
    asm volatile("mov r1, %0" : : "r" (count));
    8464:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8468:	e1a01003 	mov	r1, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:88
    asm volatile("swi 69");
    846c:	ef000045 	svc	0x00000045
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:89
    asm volatile("mov %0, r0" : "=r" (retcnt));
    8470:	e1a03000 	mov	r3, r0
    8474:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:91

    return retcnt;
    8478:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:92
}
    847c:	e1a00003 	mov	r0, r3
    8480:	e28bd000 	add	sp, fp, #0
    8484:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8488:	e12fff1e 	bx	lr

0000848c <_Z4waitjjj>:
_Z4waitjjj():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:95

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    848c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8490:	e28db000 	add	fp, sp, #0
    8494:	e24dd01c 	sub	sp, sp, #28
    8498:	e50b0010 	str	r0, [fp, #-16]
    849c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    84a0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:98
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    84a4:	e51b3010 	ldr	r3, [fp, #-16]
    84a8:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:99
    asm volatile("mov r1, %0" : : "r" (count));
    84ac:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84b0:	e1a01003 	mov	r1, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:100
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    84b4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    84b8:	e1a02003 	mov	r2, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:101
    asm volatile("swi 70");
    84bc:	ef000046 	svc	0x00000046
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:102
    asm volatile("mov %0, r0" : "=r" (retcode));
    84c0:	e1a03000 	mov	r3, r0
    84c4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:104

    return retcode;
    84c8:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:105
}
    84cc:	e1a00003 	mov	r0, r3
    84d0:	e28bd000 	add	sp, fp, #0
    84d4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84d8:	e12fff1e 	bx	lr

000084dc <_Z5sleepjj>:
_Z5sleepjj():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:108

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    84dc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84e0:	e28db000 	add	fp, sp, #0
    84e4:	e24dd014 	sub	sp, sp, #20
    84e8:	e50b0010 	str	r0, [fp, #-16]
    84ec:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:111
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    84f0:	e51b3010 	ldr	r3, [fp, #-16]
    84f4:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:112
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    84f8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84fc:	e1a01003 	mov	r1, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:113
    asm volatile("swi 3");
    8500:	ef000003 	svc	0x00000003
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:114
    asm volatile("mov %0, r0" : "=r" (retcode));
    8504:	e1a03000 	mov	r3, r0
    8508:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:116

    return retcode;
    850c:	e51b3008 	ldr	r3, [fp, #-8]
    8510:	e3530000 	cmp	r3, #0
    8514:	13a03001 	movne	r3, #1
    8518:	03a03000 	moveq	r3, #0
    851c:	e6ef3073 	uxtb	r3, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:117
}
    8520:	e1a00003 	mov	r0, r3
    8524:	e28bd000 	add	sp, fp, #0
    8528:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    852c:	e12fff1e 	bx	lr

00008530 <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:120

uint32_t get_active_process_count()
{
    8530:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8534:	e28db000 	add	fp, sp, #0
    8538:	e24dd00c 	sub	sp, sp, #12
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:121
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    853c:	e3a03000 	mov	r3, #0
    8540:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:124
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    8544:	e3a03000 	mov	r3, #0
    8548:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:125
    asm volatile("mov r1, %0" : : "r" (&retval));
    854c:	e24b300c 	sub	r3, fp, #12
    8550:	e1a01003 	mov	r1, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:126
    asm volatile("swi 4");
    8554:	ef000004 	svc	0x00000004
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:128

    return retval;
    8558:	e51b300c 	ldr	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:129
}
    855c:	e1a00003 	mov	r0, r3
    8560:	e28bd000 	add	sp, fp, #0
    8564:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8568:	e12fff1e 	bx	lr

0000856c <_Z14get_tick_countv>:
_Z14get_tick_countv():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:132

uint32_t get_tick_count()
{
    856c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8570:	e28db000 	add	fp, sp, #0
    8574:	e24dd00c 	sub	sp, sp, #12
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:133
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    8578:	e3a03001 	mov	r3, #1
    857c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:136
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    8580:	e3a03001 	mov	r3, #1
    8584:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:137
    asm volatile("mov r1, %0" : : "r" (&retval));
    8588:	e24b300c 	sub	r3, fp, #12
    858c:	e1a01003 	mov	r1, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:138
    asm volatile("swi 4");
    8590:	ef000004 	svc	0x00000004
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:140

    return retval;
    8594:	e51b300c 	ldr	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:141
}
    8598:	e1a00003 	mov	r0, r3
    859c:	e28bd000 	add	sp, fp, #0
    85a0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85a4:	e12fff1e 	bx	lr

000085a8 <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:144

void set_task_deadline(uint32_t tick_count_required)
{
    85a8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85ac:	e28db000 	add	fp, sp, #0
    85b0:	e24dd014 	sub	sp, sp, #20
    85b4:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:145
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    85b8:	e3a03000 	mov	r3, #0
    85bc:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:147

    asm volatile("mov r0, %0" : : "r" (req));
    85c0:	e3a03000 	mov	r3, #0
    85c4:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:148
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    85c8:	e24b3010 	sub	r3, fp, #16
    85cc:	e1a01003 	mov	r1, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:149
    asm volatile("swi 5");
    85d0:	ef000005 	svc	0x00000005
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:150
}
    85d4:	e320f000 	nop	{0}
    85d8:	e28bd000 	add	sp, fp, #0
    85dc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85e0:	e12fff1e 	bx	lr

000085e4 <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:153

uint32_t get_task_ticks_to_deadline()
{
    85e4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85e8:	e28db000 	add	fp, sp, #0
    85ec:	e24dd00c 	sub	sp, sp, #12
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:154
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    85f0:	e3a03001 	mov	r3, #1
    85f4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:157
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    85f8:	e3a03001 	mov	r3, #1
    85fc:	e1a00003 	mov	r0, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:158
    asm volatile("mov r1, %0" : : "r" (&ticks));
    8600:	e24b300c 	sub	r3, fp, #12
    8604:	e1a01003 	mov	r1, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:159
    asm volatile("swi 5");
    8608:	ef000005 	svc	0x00000005
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:161

    return ticks;
    860c:	e51b300c 	ldr	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:162
}
    8610:	e1a00003 	mov	r0, r3
    8614:	e28bd000 	add	sp, fp, #0
    8618:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    861c:	e12fff1e 	bx	lr

00008620 <_Z4pipePKcj>:
_Z4pipePKcj():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:167

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    8620:	e92d4800 	push	{fp, lr}
    8624:	e28db004 	add	fp, sp, #4
    8628:	e24dd050 	sub	sp, sp, #80	; 0x50
    862c:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    8630:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:169
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    8634:	e24b3048 	sub	r3, fp, #72	; 0x48
    8638:	e3a0200a 	mov	r2, #10
    863c:	e59f1088 	ldr	r1, [pc, #136]	; 86cc <_Z4pipePKcj+0xac>
    8640:	e1a00003 	mov	r0, r3
    8644:	eb000250 	bl	8f8c <_Z7strncpyPcPKci>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:170
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    8648:	e24b3048 	sub	r3, fp, #72	; 0x48
    864c:	e283300a 	add	r3, r3, #10
    8650:	e3a02035 	mov	r2, #53	; 0x35
    8654:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    8658:	e1a00003 	mov	r0, r3
    865c:	eb00024a 	bl	8f8c <_Z7strncpyPcPKci>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:172

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    8660:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    8664:	eb0002d8 	bl	91cc <_Z6strlenPKc>
    8668:	e1a03000 	mov	r3, r0
    866c:	e283300a 	add	r3, r3, #10
    8670:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:174

    fname[ncur++] = '#';
    8674:	e51b3008 	ldr	r3, [fp, #-8]
    8678:	e2832001 	add	r2, r3, #1
    867c:	e50b2008 	str	r2, [fp, #-8]
    8680:	e24b2004 	sub	r2, fp, #4
    8684:	e0823003 	add	r3, r2, r3
    8688:	e3a02023 	mov	r2, #35	; 0x23
    868c:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:176

    itoa(buf_size, &fname[ncur], 10);
    8690:	e24b2048 	sub	r2, fp, #72	; 0x48
    8694:	e51b3008 	ldr	r3, [fp, #-8]
    8698:	e0823003 	add	r3, r2, r3
    869c:	e3a0200a 	mov	r2, #10
    86a0:	e1a01003 	mov	r1, r3
    86a4:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    86a8:	eb000008 	bl	86d0 <_Z4itoajPcj>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:178

    return open(fname, NFile_Open_Mode::Read_Write);
    86ac:	e24b3048 	sub	r3, fp, #72	; 0x48
    86b0:	e3a01002 	mov	r1, #2
    86b4:	e1a00003 	mov	r0, r3
    86b8:	ebffff0a 	bl	82e8 <_Z4openPKc15NFile_Open_Mode>
    86bc:	e1a03000 	mov	r3, r0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdfile.cpp:179
}
    86c0:	e1a00003 	mov	r0, r3
    86c4:	e24bd004 	sub	sp, fp, #4
    86c8:	e8bd8800 	pop	{fp, pc}
    86cc:	0000942c 	andeq	r9, r0, ip, lsr #8

000086d0 <_Z4itoajPcj>:
_Z4itoajPcj():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:11
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
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:12
	int i = 0;
    86e8:	e3a03000 	mov	r3, #0
    86ec:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:14

	while (input > 0)
    86f0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    86f4:	e3530000 	cmp	r3, #0
    86f8:	0a000014 	beq	8750 <_Z4itoajPcj+0x80>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:16
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
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:17
		input /= base;
    872c:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8730:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8734:	eb0002f3 	bl	9308 <__udivsi3>
    8738:	e1a03000 	mov	r3, r0
    873c:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:18
		i++;
    8740:	e51b3008 	ldr	r3, [fp, #-8]
    8744:	e2833001 	add	r3, r3, #1
    8748:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:14
	while (input > 0)
    874c:	eaffffe7 	b	86f0 <_Z4itoajPcj+0x20>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:21
	}

    if (i == 0)
    8750:	e51b3008 	ldr	r3, [fp, #-8]
    8754:	e3530000 	cmp	r3, #0
    8758:	1a000007 	bne	877c <_Z4itoajPcj+0xac>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:23
    {
        output[i] = CharConvArr[0];
    875c:	e51b3008 	ldr	r3, [fp, #-8]
    8760:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8764:	e0823003 	add	r3, r2, r3
    8768:	e3a02030 	mov	r2, #48	; 0x30
    876c:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:24
        i++;
    8770:	e51b3008 	ldr	r3, [fp, #-8]
    8774:	e2833001 	add	r3, r3, #1
    8778:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:27
    }

	output[i] = '\0';
    877c:	e51b3008 	ldr	r3, [fp, #-8]
    8780:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8784:	e0823003 	add	r3, r2, r3
    8788:	e3a02000 	mov	r2, #0
    878c:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:28
	i--;
    8790:	e51b3008 	ldr	r3, [fp, #-8]
    8794:	e2433001 	sub	r3, r3, #1
    8798:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:30

	for (int j = 0; j <= i/2; j++)
    879c:	e3a03000 	mov	r3, #0
    87a0:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:30 (discriminator 3)
    87a4:	e51b3008 	ldr	r3, [fp, #-8]
    87a8:	e1a02fa3 	lsr	r2, r3, #31
    87ac:	e0823003 	add	r3, r2, r3
    87b0:	e1a030c3 	asr	r3, r3, #1
    87b4:	e1a02003 	mov	r2, r3
    87b8:	e51b300c 	ldr	r3, [fp, #-12]
    87bc:	e1530002 	cmp	r3, r2
    87c0:	ca00001b 	bgt	8834 <_Z4itoajPcj+0x164>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:32 (discriminator 2)
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
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:33 (discriminator 2)
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
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:34 (discriminator 2)
		output[j] = c;
    8810:	e51b300c 	ldr	r3, [fp, #-12]
    8814:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8818:	e0823003 	add	r3, r2, r3
    881c:	e55b200d 	ldrb	r2, [fp, #-13]
    8820:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:30 (discriminator 2)
	for (int j = 0; j <= i/2; j++)
    8824:	e51b300c 	ldr	r3, [fp, #-12]
    8828:	e2833001 	add	r3, r3, #1
    882c:	e50b300c 	str	r3, [fp, #-12]
    8830:	eaffffdb 	b	87a4 <_Z4itoajPcj+0xd4>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:36
	}
}
    8834:	e320f000 	nop	{0}
    8838:	e24bd004 	sub	sp, fp, #4
    883c:	e8bd8800 	pop	{fp, pc}
    8840:	00009438 	andeq	r9, r0, r8, lsr r4

00008844 <_Z4atoiPKc>:
_Z4atoiPKc():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:39

int atoi(const char* input)
{
    8844:	e92d4800 	push	{fp, lr}
    8848:	e28db004 	add	fp, sp, #4
    884c:	e24dd010 	sub	sp, sp, #16
    8850:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:40
	int output = 0;
    8854:	e3a03000 	mov	r3, #0
    8858:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:42

  if (isnan(input, false)) {
    885c:	e3a01000 	mov	r1, #0
    8860:	e51b0010 	ldr	r0, [fp, #-16]
    8864:	eb000055 	bl	89c0 <_Z5isnanPKcb>
    8868:	e1a03000 	mov	r3, r0
    886c:	e3530000 	cmp	r3, #0
    8870:	0a000001 	beq	887c <_Z4atoiPKc+0x38>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:43
    return 0;
    8874:	e3a03000 	mov	r3, #0
    8878:	ea00001c 	b	88f0 <_Z4atoiPKc+0xac>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:46
  }

	while (*input != '\0')
    887c:	e51b3010 	ldr	r3, [fp, #-16]
    8880:	e5d33000 	ldrb	r3, [r3]
    8884:	e3530000 	cmp	r3, #0
    8888:	0a000017 	beq	88ec <_Z4atoiPKc+0xa8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:48
	{
		output *= 10;
    888c:	e51b2008 	ldr	r2, [fp, #-8]
    8890:	e1a03002 	mov	r3, r2
    8894:	e1a03103 	lsl	r3, r3, #2
    8898:	e0833002 	add	r3, r3, r2
    889c:	e1a03083 	lsl	r3, r3, #1
    88a0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:49
		if (*input > '9' || *input < '0')
    88a4:	e51b3010 	ldr	r3, [fp, #-16]
    88a8:	e5d33000 	ldrb	r3, [r3]
    88ac:	e3530039 	cmp	r3, #57	; 0x39
    88b0:	8a00000d 	bhi	88ec <_Z4atoiPKc+0xa8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:49 (discriminator 1)
    88b4:	e51b3010 	ldr	r3, [fp, #-16]
    88b8:	e5d33000 	ldrb	r3, [r3]
    88bc:	e353002f 	cmp	r3, #47	; 0x2f
    88c0:	9a000009 	bls	88ec <_Z4atoiPKc+0xa8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:52
			break;

		output += *input - '0';
    88c4:	e51b3010 	ldr	r3, [fp, #-16]
    88c8:	e5d33000 	ldrb	r3, [r3]
    88cc:	e2433030 	sub	r3, r3, #48	; 0x30
    88d0:	e51b2008 	ldr	r2, [fp, #-8]
    88d4:	e0823003 	add	r3, r2, r3
    88d8:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:54

		input++;
    88dc:	e51b3010 	ldr	r3, [fp, #-16]
    88e0:	e2833001 	add	r3, r3, #1
    88e4:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:46
	while (*input != '\0')
    88e8:	eaffffe3 	b	887c <_Z4atoiPKc+0x38>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:57
	}

	return output;
    88ec:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:58
}
    88f0:	e1a00003 	mov	r0, r3
    88f4:	e24bd004 	sub	sp, fp, #4
    88f8:	e8bd8800 	pop	{fp, pc}

000088fc <_Z9normalizePf>:
_Z9normalizePf():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:60

int normalize(float *val) {
    88fc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8900:	e28db000 	add	fp, sp, #0
    8904:	e24dd014 	sub	sp, sp, #20
    8908:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:61
    int exponent = 0;
    890c:	e3a03000 	mov	r3, #0
    8910:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:62
    float value = *val;
    8914:	e51b3010 	ldr	r3, [fp, #-16]
    8918:	e5933000 	ldr	r3, [r3]
    891c:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:64

    while (value >= 1.0) {
    8920:	ed5b7a03 	vldr	s15, [fp, #-12]
    8924:	ed9f7a23 	vldr	s14, [pc, #140]	; 89b8 <_Z9normalizePf+0xbc>
    8928:	eef47ac7 	vcmpe.f32	s15, s14
    892c:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8930:	aa000000 	bge	8938 <_Z9normalizePf+0x3c>
    8934:	ea000007 	b	8958 <_Z9normalizePf+0x5c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:65
        value = value / 10.0;
    8938:	ed1b7a03 	vldr	s14, [fp, #-12]
    893c:	eddf6a1e 	vldr	s13, [pc, #120]	; 89bc <_Z9normalizePf+0xc0>
    8940:	eec77a26 	vdiv.f32	s15, s14, s13
    8944:	ed4b7a03 	vstr	s15, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:66
        ++exponent;
    8948:	e51b3008 	ldr	r3, [fp, #-8]
    894c:	e2833001 	add	r3, r3, #1
    8950:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:64
    while (value >= 1.0) {
    8954:	eafffff1 	b	8920 <_Z9normalizePf+0x24>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:69
    }

    while (value < 0.1) {
    8958:	ed5b7a03 	vldr	s15, [fp, #-12]
    895c:	eeb77ae7 	vcvt.f64.f32	d7, s15
    8960:	ed9f6b12 	vldr	d6, [pc, #72]	; 89b0 <_Z9normalizePf+0xb4>
    8964:	eeb47bc6 	vcmpe.f64	d7, d6
    8968:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    896c:	5a000007 	bpl	8990 <_Z9normalizePf+0x94>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:70
        value = value * 10.0;
    8970:	ed5b7a03 	vldr	s15, [fp, #-12]
    8974:	ed9f7a10 	vldr	s14, [pc, #64]	; 89bc <_Z9normalizePf+0xc0>
    8978:	ee677a87 	vmul.f32	s15, s15, s14
    897c:	ed4b7a03 	vstr	s15, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:71
        --exponent;
    8980:	e51b3008 	ldr	r3, [fp, #-8]
    8984:	e2433001 	sub	r3, r3, #1
    8988:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:69
    while (value < 0.1) {
    898c:	eafffff1 	b	8958 <_Z9normalizePf+0x5c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:73
    }
    *val = value;
    8990:	e51b3010 	ldr	r3, [fp, #-16]
    8994:	e51b200c 	ldr	r2, [fp, #-12]
    8998:	e5832000 	str	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:74
    return exponent;
    899c:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:75
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
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:78

bool isnan(const char *s, bool isFloat) 
{
    89c0:	e92d4800 	push	{fp, lr}
    89c4:	e28db004 	add	fp, sp, #4
    89c8:	e24dd018 	sub	sp, sp, #24
    89cc:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    89d0:	e1a03001 	mov	r3, r1
    89d4:	e54b3019 	strb	r3, [fp, #-25]	; 0xffffffe7
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:79
  int length = strlen(s);
    89d8:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    89dc:	eb0001fa 	bl	91cc <_Z6strlenPKc>
    89e0:	e50b000c 	str	r0, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:80
  if (length == 0) {
    89e4:	e51b300c 	ldr	r3, [fp, #-12]
    89e8:	e3530000 	cmp	r3, #0
    89ec:	1a000001 	bne	89f8 <_Z5isnanPKcb+0x38>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:81
    return true;
    89f0:	e3a03001 	mov	r3, #1
    89f4:	ea000025 	b	8a90 <_Z5isnanPKcb+0xd0>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:84
  }

	for (int i = 0; i < strlen(s); i++) {
    89f8:	e3a03000 	mov	r3, #0
    89fc:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:84 (discriminator 1)
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
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:85
		char c = s[i];
    8a28:	e51b3008 	ldr	r3, [fp, #-8]
    8a2c:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8a30:	e0823003 	add	r3, r2, r3
    8a34:	e5d33000 	ldrb	r3, [r3]
    8a38:	e54b300d 	strb	r3, [fp, #-13]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:86
		if ((c != 46 || !isFloat) && (c < 48 || c > 57 )) { //Pokud neni tecka (Kdyz kontrolujeme jen float cisla) a zaroven je mimo rozsah cislic, vyhod ze neni number
    8a3c:	e55b300d 	ldrb	r3, [fp, #-13]
    8a40:	e353002e 	cmp	r3, #46	; 0x2e
    8a44:	1a000004 	bne	8a5c <_Z5isnanPKcb+0x9c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:86 (discriminator 2)
    8a48:	e55b3019 	ldrb	r3, [fp, #-25]	; 0xffffffe7
    8a4c:	e2233001 	eor	r3, r3, #1
    8a50:	e6ef3073 	uxtb	r3, r3
    8a54:	e3530000 	cmp	r3, #0
    8a58:	0a000007 	beq	8a7c <_Z5isnanPKcb+0xbc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:86 (discriminator 3)
    8a5c:	e55b300d 	ldrb	r3, [fp, #-13]
    8a60:	e353002f 	cmp	r3, #47	; 0x2f
    8a64:	9a000002 	bls	8a74 <_Z5isnanPKcb+0xb4>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:86 (discriminator 4)
    8a68:	e55b300d 	ldrb	r3, [fp, #-13]
    8a6c:	e3530039 	cmp	r3, #57	; 0x39
    8a70:	9a000001 	bls	8a7c <_Z5isnanPKcb+0xbc>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:87
			return true;
    8a74:	e3a03001 	mov	r3, #1
    8a78:	ea000004 	b	8a90 <_Z5isnanPKcb+0xd0>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:84 (discriminator 2)
	for (int i = 0; i < strlen(s); i++) {
    8a7c:	e51b3008 	ldr	r3, [fp, #-8]
    8a80:	e2833001 	add	r3, r3, #1
    8a84:	e50b3008 	str	r3, [fp, #-8]
    8a88:	eaffffdc 	b	8a00 <_Z5isnanPKcb+0x40>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:91
		}
	}

	return false;
    8a8c:	e3a03000 	mov	r3, #0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:92
}
    8a90:	e1a00003 	mov	r0, r3
    8a94:	e24bd004 	sub	sp, fp, #4
    8a98:	e8bd8800 	pop	{fp, pc}

00008a9c <_Z4atofPKc>:
_Z4atofPKc():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:95

float atof(const char *s)
{
    8a9c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8aa0:	e28db000 	add	fp, sp, #0
    8aa4:	e24dd024 	sub	sp, sp, #36	; 0x24
    8aa8:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:100
  // This function stolen from either Rolf Neugebauer or Andrew Tolmach. 
  // Probably Rolf.
  // -----------------------------------
  // I stole it from https://github.com/GaloisInc/minlibc/blob/master/atof.c
  float a = 0.0;
    8aac:	e3a03000 	mov	r3, #0
    8ab0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:101
  int e = 0;
    8ab4:	e3a03000 	mov	r3, #0
    8ab8:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:103
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
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:103 (discriminator 1)
    8adc:	e51b3010 	ldr	r3, [fp, #-16]
    8ae0:	e353002f 	cmp	r3, #47	; 0x2f
    8ae4:	da000004 	ble	8afc <_Z4atofPKc+0x60>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:103 (discriminator 3)
    8ae8:	e51b3010 	ldr	r3, [fp, #-16]
    8aec:	e3530039 	cmp	r3, #57	; 0x39
    8af0:	ca000001 	bgt	8afc <_Z4atofPKc+0x60>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:103 (discriminator 5)
    8af4:	e3a03001 	mov	r3, #1
    8af8:	ea000000 	b	8b00 <_Z4atofPKc+0x64>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:103 (discriminator 6)
    8afc:	e3a03000 	mov	r3, #0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:103 (discriminator 8)
    8b00:	e3530000 	cmp	r3, #0
    8b04:	0a00000b 	beq	8b38 <_Z4atofPKc+0x9c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:104
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
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:103
  while ((c = *s++) != '\0' && isdigit(c)) {
    8b34:	eaffffe0 	b	8abc <_Z4atofPKc+0x20>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:106
  }
  if (c == '.') {
    8b38:	e51b3010 	ldr	r3, [fp, #-16]
    8b3c:	e353002e 	cmp	r3, #46	; 0x2e
    8b40:	1a000021 	bne	8bcc <_Z4atofPKc+0x130>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:107
    while ((c = *s++) != '\0' && isdigit(c)) {
    8b44:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8b48:	e2832001 	add	r2, r3, #1
    8b4c:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8b50:	e5d33000 	ldrb	r3, [r3]
    8b54:	e50b3010 	str	r3, [fp, #-16]
    8b58:	e51b3010 	ldr	r3, [fp, #-16]
    8b5c:	e3530000 	cmp	r3, #0
    8b60:	0a000007 	beq	8b84 <_Z4atofPKc+0xe8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:107 (discriminator 1)
    8b64:	e51b3010 	ldr	r3, [fp, #-16]
    8b68:	e353002f 	cmp	r3, #47	; 0x2f
    8b6c:	da000004 	ble	8b84 <_Z4atofPKc+0xe8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:107 (discriminator 3)
    8b70:	e51b3010 	ldr	r3, [fp, #-16]
    8b74:	e3530039 	cmp	r3, #57	; 0x39
    8b78:	ca000001 	bgt	8b84 <_Z4atofPKc+0xe8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:107 (discriminator 5)
    8b7c:	e3a03001 	mov	r3, #1
    8b80:	ea000000 	b	8b88 <_Z4atofPKc+0xec>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:107 (discriminator 6)
    8b84:	e3a03000 	mov	r3, #0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:107 (discriminator 8)
    8b88:	e3530000 	cmp	r3, #0
    8b8c:	0a00000e 	beq	8bcc <_Z4atofPKc+0x130>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:108
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
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:109
      e = e-1;
    8bbc:	e51b300c 	ldr	r3, [fp, #-12]
    8bc0:	e2433001 	sub	r3, r3, #1
    8bc4:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:107
    while ((c = *s++) != '\0' && isdigit(c)) {
    8bc8:	eaffffdd 	b	8b44 <_Z4atofPKc+0xa8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:112
    }
  }
  if (c == 'e' || c == 'E') {
    8bcc:	e51b3010 	ldr	r3, [fp, #-16]
    8bd0:	e3530065 	cmp	r3, #101	; 0x65
    8bd4:	0a000002 	beq	8be4 <_Z4atofPKc+0x148>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:112 (discriminator 1)
    8bd8:	e51b3010 	ldr	r3, [fp, #-16]
    8bdc:	e3530045 	cmp	r3, #69	; 0x45
    8be0:	1a000037 	bne	8cc4 <_Z4atofPKc+0x228>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:113
    int sign = 1;
    8be4:	e3a03001 	mov	r3, #1
    8be8:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:114
    int i = 0;
    8bec:	e3a03000 	mov	r3, #0
    8bf0:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:115
    c = *s++;
    8bf4:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8bf8:	e2832001 	add	r2, r3, #1
    8bfc:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8c00:	e5d33000 	ldrb	r3, [r3]
    8c04:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:116
    if (c == '+')
    8c08:	e51b3010 	ldr	r3, [fp, #-16]
    8c0c:	e353002b 	cmp	r3, #43	; 0x2b
    8c10:	1a000005 	bne	8c2c <_Z4atofPKc+0x190>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:117
      c = *s++;
    8c14:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8c18:	e2832001 	add	r2, r3, #1
    8c1c:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8c20:	e5d33000 	ldrb	r3, [r3]
    8c24:	e50b3010 	str	r3, [fp, #-16]
    8c28:	ea000009 	b	8c54 <_Z4atofPKc+0x1b8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:118
    else if (c == '-') {
    8c2c:	e51b3010 	ldr	r3, [fp, #-16]
    8c30:	e353002d 	cmp	r3, #45	; 0x2d
    8c34:	1a000006 	bne	8c54 <_Z4atofPKc+0x1b8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:119
      c = *s++;
    8c38:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8c3c:	e2832001 	add	r2, r3, #1
    8c40:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8c44:	e5d33000 	ldrb	r3, [r3]
    8c48:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:120
      sign = -1;
    8c4c:	e3e03000 	mvn	r3, #0
    8c50:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:122
    }
    while (isdigit(c)) {
    8c54:	e51b3010 	ldr	r3, [fp, #-16]
    8c58:	e353002f 	cmp	r3, #47	; 0x2f
    8c5c:	da000012 	ble	8cac <_Z4atofPKc+0x210>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:122 (discriminator 1)
    8c60:	e51b3010 	ldr	r3, [fp, #-16]
    8c64:	e3530039 	cmp	r3, #57	; 0x39
    8c68:	ca00000f 	bgt	8cac <_Z4atofPKc+0x210>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:123
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
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:124
      c = *s++;
    8c94:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8c98:	e2832001 	add	r2, r3, #1
    8c9c:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8ca0:	e5d33000 	ldrb	r3, [r3]
    8ca4:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:122
    while (isdigit(c)) {
    8ca8:	eaffffe9 	b	8c54 <_Z4atofPKc+0x1b8>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:126
    }
    e += i*sign;
    8cac:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8cb0:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8cb4:	e0030392 	mul	r3, r2, r3
    8cb8:	e51b200c 	ldr	r2, [fp, #-12]
    8cbc:	e0823003 	add	r3, r2, r3
    8cc0:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:128
  }
  while (e > 0) {
    8cc4:	e51b300c 	ldr	r3, [fp, #-12]
    8cc8:	e3530000 	cmp	r3, #0
    8ccc:	da000007 	ble	8cf0 <_Z4atofPKc+0x254>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:129
    a *= 10.0;
    8cd0:	ed5b7a02 	vldr	s15, [fp, #-8]
    8cd4:	ed9f7a1d 	vldr	s14, [pc, #116]	; 8d50 <_Z4atofPKc+0x2b4>
    8cd8:	ee677a87 	vmul.f32	s15, s15, s14
    8cdc:	ed4b7a02 	vstr	s15, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:130
    e--;
    8ce0:	e51b300c 	ldr	r3, [fp, #-12]
    8ce4:	e2433001 	sub	r3, r3, #1
    8ce8:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:128
  while (e > 0) {
    8cec:	eafffff4 	b	8cc4 <_Z4atofPKc+0x228>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:132
  }
  while (e < 0) {
    8cf0:	e51b300c 	ldr	r3, [fp, #-12]
    8cf4:	e3530000 	cmp	r3, #0
    8cf8:	aa000009 	bge	8d24 <_Z4atofPKc+0x288>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:133
    a *= 0.1;
    8cfc:	ed5b7a02 	vldr	s15, [fp, #-8]
    8d00:	eeb77ae7 	vcvt.f64.f32	d7, s15
    8d04:	ed9f6b0f 	vldr	d6, [pc, #60]	; 8d48 <_Z4atofPKc+0x2ac>
    8d08:	ee277b06 	vmul.f64	d7, d7, d6
    8d0c:	eef77bc7 	vcvt.f32.f64	s15, d7
    8d10:	ed4b7a02 	vstr	s15, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:134
    e++;
    8d14:	e51b300c 	ldr	r3, [fp, #-12]
    8d18:	e2833001 	add	r3, r3, #1
    8d1c:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:132
  while (e < 0) {
    8d20:	eafffff2 	b	8cf0 <_Z4atofPKc+0x254>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:136
  }
  return a;
    8d24:	e51b3008 	ldr	r3, [fp, #-8]
    8d28:	ee073a90 	vmov	s15, r3
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:137
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
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:139

void ftoa(char *buffer, float value) {  
    8d54:	e92d4800 	push	{fp, lr}
    8d58:	e28db004 	add	fp, sp, #4
    8d5c:	e24dd020 	sub	sp, sp, #32
    8d60:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
    8d64:	ed0b0a09 	vstr	s0, [fp, #-36]	; 0xffffffdc
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:148
     * The largest value we expect is an IEEE 754 double precision real, with maximum magnitude of approximately
     * e+308. The C standard requires an implementation to allow a single conversion to produce up to 512 
     * characters, so that's what we really expect as the buffer size.     
     */

    int exponent = 0;
    8d68:	e3a03000 	mov	r3, #0
    8d6c:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:149
    int places = 0;
    8d70:	e3a03000 	mov	r3, #0
    8d74:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:150
    const int width = 6;
    8d78:	e3a03006 	mov	r3, #6
    8d7c:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:152

    if (value == 0.0) {
    8d80:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    8d84:	eef57a40 	vcmp.f32	s15, #0.0
    8d88:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8d8c:	1a000007 	bne	8db0 <_Z4ftoaPcf+0x5c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:153
        buffer[0] = '0';
    8d90:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8d94:	e3a02030 	mov	r2, #48	; 0x30
    8d98:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:154
        buffer[1] = '\0';
    8d9c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8da0:	e2833001 	add	r3, r3, #1
    8da4:	e3a02000 	mov	r2, #0
    8da8:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:155
        return;
    8dac:	ea000071 	b	8f78 <_Z4ftoaPcf+0x224>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:158
    } 

    if (value < 0.0) {
    8db0:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    8db4:	eef57ac0 	vcmpe.f32	s15, #0.0
    8db8:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8dbc:	5a000007 	bpl	8de0 <_Z4ftoaPcf+0x8c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:159
        *buffer++ = '-';
    8dc0:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8dc4:	e2832001 	add	r2, r3, #1
    8dc8:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8dcc:	e3a0202d 	mov	r2, #45	; 0x2d
    8dd0:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:160
        value = -value;
    8dd4:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    8dd8:	eef17a67 	vneg.f32	s15, s15
    8ddc:	ed4b7a09 	vstr	s15, [fp, #-36]	; 0xffffffdc
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:163
    }

    exponent = normalize(&value);
    8de0:	e24b3024 	sub	r3, fp, #36	; 0x24
    8de4:	e1a00003 	mov	r0, r3
    8de8:	ebfffec3 	bl	88fc <_Z9normalizePf>
    8dec:	e50b0008 	str	r0, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:165

    while (exponent > 0) {
    8df0:	e51b3008 	ldr	r3, [fp, #-8]
    8df4:	e3530000 	cmp	r3, #0
    8df8:	da00001c 	ble	8e70 <_Z4ftoaPcf+0x11c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:166
        int digit = value * 10;
    8dfc:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    8e00:	ed9f7a60 	vldr	s14, [pc, #384]	; 8f88 <_Z4ftoaPcf+0x234>
    8e04:	ee677a87 	vmul.f32	s15, s15, s14
    8e08:	eefd7ae7 	vcvt.s32.f32	s15, s15
    8e0c:	ee173a90 	vmov	r3, s15
    8e10:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:167
        *buffer++ = digit + '0';
    8e14:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8e18:	e6ef2073 	uxtb	r2, r3
    8e1c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8e20:	e2831001 	add	r1, r3, #1
    8e24:	e50b1020 	str	r1, [fp, #-32]	; 0xffffffe0
    8e28:	e2822030 	add	r2, r2, #48	; 0x30
    8e2c:	e6ef2072 	uxtb	r2, r2
    8e30:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:168
        value = value * 10 - digit;
    8e34:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    8e38:	ed9f7a52 	vldr	s14, [pc, #328]	; 8f88 <_Z4ftoaPcf+0x234>
    8e3c:	ee277a87 	vmul.f32	s14, s15, s14
    8e40:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8e44:	ee073a90 	vmov	s15, r3
    8e48:	eef87ae7 	vcvt.f32.s32	s15, s15
    8e4c:	ee777a67 	vsub.f32	s15, s14, s15
    8e50:	ed4b7a09 	vstr	s15, [fp, #-36]	; 0xffffffdc
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:169
        ++places;
    8e54:	e51b300c 	ldr	r3, [fp, #-12]
    8e58:	e2833001 	add	r3, r3, #1
    8e5c:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:170
        --exponent;
    8e60:	e51b3008 	ldr	r3, [fp, #-8]
    8e64:	e2433001 	sub	r3, r3, #1
    8e68:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:165
    while (exponent > 0) {
    8e6c:	eaffffdf 	b	8df0 <_Z4ftoaPcf+0x9c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:173
    }

    if (places == 0)
    8e70:	e51b300c 	ldr	r3, [fp, #-12]
    8e74:	e3530000 	cmp	r3, #0
    8e78:	1a000004 	bne	8e90 <_Z4ftoaPcf+0x13c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:174
        *buffer++ = '0';
    8e7c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8e80:	e2832001 	add	r2, r3, #1
    8e84:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8e88:	e3a02030 	mov	r2, #48	; 0x30
    8e8c:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:176

    *buffer++ = '.';
    8e90:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8e94:	e2832001 	add	r2, r3, #1
    8e98:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8e9c:	e3a0202e 	mov	r2, #46	; 0x2e
    8ea0:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:178

    while (exponent < 0 && places < width) {
    8ea4:	e51b3008 	ldr	r3, [fp, #-8]
    8ea8:	e3530000 	cmp	r3, #0
    8eac:	aa00000e 	bge	8eec <_Z4ftoaPcf+0x198>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:178 (discriminator 1)
    8eb0:	e51b300c 	ldr	r3, [fp, #-12]
    8eb4:	e3530005 	cmp	r3, #5
    8eb8:	ca00000b 	bgt	8eec <_Z4ftoaPcf+0x198>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:179
        *buffer++ = '0';
    8ebc:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8ec0:	e2832001 	add	r2, r3, #1
    8ec4:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8ec8:	e3a02030 	mov	r2, #48	; 0x30
    8ecc:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:180
        --exponent;
    8ed0:	e51b3008 	ldr	r3, [fp, #-8]
    8ed4:	e2433001 	sub	r3, r3, #1
    8ed8:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:181
        ++places;
    8edc:	e51b300c 	ldr	r3, [fp, #-12]
    8ee0:	e2833001 	add	r3, r3, #1
    8ee4:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:178
    while (exponent < 0 && places < width) {
    8ee8:	eaffffed 	b	8ea4 <_Z4ftoaPcf+0x150>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:184
    }

    while (places < width) {
    8eec:	e51b300c 	ldr	r3, [fp, #-12]
    8ef0:	e3530005 	cmp	r3, #5
    8ef4:	ca00001c 	bgt	8f6c <_Z4ftoaPcf+0x218>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:185
        int digit = value * 10.0;
    8ef8:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    8efc:	eeb77ae7 	vcvt.f64.f32	d7, s15
    8f00:	ed9f6b1e 	vldr	d6, [pc, #120]	; 8f80 <_Z4ftoaPcf+0x22c>
    8f04:	ee277b06 	vmul.f64	d7, d7, d6
    8f08:	eefd7bc7 	vcvt.s32.f64	s15, d7
    8f0c:	ee173a90 	vmov	r3, s15
    8f10:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:186
        *buffer++ = digit + '0';
    8f14:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8f18:	e6ef2073 	uxtb	r2, r3
    8f1c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8f20:	e2831001 	add	r1, r3, #1
    8f24:	e50b1020 	str	r1, [fp, #-32]	; 0xffffffe0
    8f28:	e2822030 	add	r2, r2, #48	; 0x30
    8f2c:	e6ef2072 	uxtb	r2, r2
    8f30:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:187
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
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:188
        ++places;
    8f5c:	e51b300c 	ldr	r3, [fp, #-12]
    8f60:	e2833001 	add	r3, r3, #1
    8f64:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:184
    while (places < width) {
    8f68:	eaffffdf 	b	8eec <_Z4ftoaPcf+0x198>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:190
    }
    *buffer = '\0';
    8f6c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8f70:	e3a02000 	mov	r2, #0
    8f74:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:191
}
    8f78:	e24bd004 	sub	sp, fp, #4
    8f7c:	e8bd8800 	pop	{fp, pc}
    8f80:	00000000 	andeq	r0, r0, r0
    8f84:	40240000 	eormi	r0, r4, r0
    8f88:	41200000 			; <UNDEFINED> instruction: 0x41200000

00008f8c <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:194

char* strncpy(char* dest, const char *src, int num)
{
    8f8c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8f90:	e28db000 	add	fp, sp, #0
    8f94:	e24dd01c 	sub	sp, sp, #28
    8f98:	e50b0010 	str	r0, [fp, #-16]
    8f9c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8fa0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:197
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
    8fa4:	e3a03000 	mov	r3, #0
    8fa8:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:197 (discriminator 4)
    8fac:	e51b2008 	ldr	r2, [fp, #-8]
    8fb0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8fb4:	e1520003 	cmp	r2, r3
    8fb8:	aa000011 	bge	9004 <_Z7strncpyPcPKci+0x78>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:197 (discriminator 2)
    8fbc:	e51b3008 	ldr	r3, [fp, #-8]
    8fc0:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8fc4:	e0823003 	add	r3, r2, r3
    8fc8:	e5d33000 	ldrb	r3, [r3]
    8fcc:	e3530000 	cmp	r3, #0
    8fd0:	0a00000b 	beq	9004 <_Z7strncpyPcPKci+0x78>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:198 (discriminator 3)
		dest[i] = src[i];
    8fd4:	e51b3008 	ldr	r3, [fp, #-8]
    8fd8:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8fdc:	e0822003 	add	r2, r2, r3
    8fe0:	e51b3008 	ldr	r3, [fp, #-8]
    8fe4:	e51b1010 	ldr	r1, [fp, #-16]
    8fe8:	e0813003 	add	r3, r1, r3
    8fec:	e5d22000 	ldrb	r2, [r2]
    8ff0:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:197 (discriminator 3)
	for (i = 0; i < num && src[i] != '\0'; i++)
    8ff4:	e51b3008 	ldr	r3, [fp, #-8]
    8ff8:	e2833001 	add	r3, r3, #1
    8ffc:	e50b3008 	str	r3, [fp, #-8]
    9000:	eaffffe9 	b	8fac <_Z7strncpyPcPKci+0x20>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:199 (discriminator 2)
	for (; i < num; i++)
    9004:	e51b2008 	ldr	r2, [fp, #-8]
    9008:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    900c:	e1520003 	cmp	r2, r3
    9010:	aa000008 	bge	9038 <_Z7strncpyPcPKci+0xac>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:200 (discriminator 1)
		dest[i] = '\0';
    9014:	e51b3008 	ldr	r3, [fp, #-8]
    9018:	e51b2010 	ldr	r2, [fp, #-16]
    901c:	e0823003 	add	r3, r2, r3
    9020:	e3a02000 	mov	r2, #0
    9024:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:199 (discriminator 1)
	for (; i < num; i++)
    9028:	e51b3008 	ldr	r3, [fp, #-8]
    902c:	e2833001 	add	r3, r3, #1
    9030:	e50b3008 	str	r3, [fp, #-8]
    9034:	eafffff2 	b	9004 <_Z7strncpyPcPKci+0x78>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:202

   return dest;
    9038:	e51b3010 	ldr	r3, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:203
}
    903c:	e1a00003 	mov	r0, r3
    9040:	e28bd000 	add	sp, fp, #0
    9044:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9048:	e12fff1e 	bx	lr

0000904c <_Z6strcatPcPKc>:
_Z6strcatPcPKc():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:206

char* strcat(char *dest, const char *src)
{
    904c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9050:	e28db000 	add	fp, sp, #0
    9054:	e24dd014 	sub	sp, sp, #20
    9058:	e50b0010 	str	r0, [fp, #-16]
    905c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:209
    int i,j;

    for (i = 0; dest[i] != '\0'; i++)
    9060:	e3a03000 	mov	r3, #0
    9064:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:209 (discriminator 3)
    9068:	e51b3008 	ldr	r3, [fp, #-8]
    906c:	e51b2010 	ldr	r2, [fp, #-16]
    9070:	e0823003 	add	r3, r2, r3
    9074:	e5d33000 	ldrb	r3, [r3]
    9078:	e3530000 	cmp	r3, #0
    907c:	0a000003 	beq	9090 <_Z6strcatPcPKc+0x44>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:209 (discriminator 2)
    9080:	e51b3008 	ldr	r3, [fp, #-8]
    9084:	e2833001 	add	r3, r3, #1
    9088:	e50b3008 	str	r3, [fp, #-8]
    908c:	eafffff5 	b	9068 <_Z6strcatPcPKc+0x1c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:211
        ;
    for (j = 0; src[j] != '\0'; j++)
    9090:	e3a03000 	mov	r3, #0
    9094:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:211 (discriminator 3)
    9098:	e51b300c 	ldr	r3, [fp, #-12]
    909c:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    90a0:	e0823003 	add	r3, r2, r3
    90a4:	e5d33000 	ldrb	r3, [r3]
    90a8:	e3530000 	cmp	r3, #0
    90ac:	0a00000e 	beq	90ec <_Z6strcatPcPKc+0xa0>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:212 (discriminator 2)
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
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:211 (discriminator 2)
    for (j = 0; src[j] != '\0'; j++)
    90dc:	e51b300c 	ldr	r3, [fp, #-12]
    90e0:	e2833001 	add	r3, r3, #1
    90e4:	e50b300c 	str	r3, [fp, #-12]
    90e8:	eaffffea 	b	9098 <_Z6strcatPcPKc+0x4c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:214

    dest[i+j] = '\0';
    90ec:	e51b2008 	ldr	r2, [fp, #-8]
    90f0:	e51b300c 	ldr	r3, [fp, #-12]
    90f4:	e0823003 	add	r3, r2, r3
    90f8:	e1a02003 	mov	r2, r3
    90fc:	e51b3010 	ldr	r3, [fp, #-16]
    9100:	e0833002 	add	r3, r3, r2
    9104:	e3a02000 	mov	r2, #0
    9108:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:216
	
    return dest;
    910c:	e51b3010 	ldr	r3, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:217
}
    9110:	e1a00003 	mov	r0, r3
    9114:	e28bd000 	add	sp, fp, #0
    9118:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    911c:	e12fff1e 	bx	lr

00009120 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:220

int strncmp(const char *s1, const char *s2, int num)
{
    9120:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9124:	e28db000 	add	fp, sp, #0
    9128:	e24dd01c 	sub	sp, sp, #28
    912c:	e50b0010 	str	r0, [fp, #-16]
    9130:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    9134:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:222
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
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:224
    {
      	u1 = (unsigned char) *s1++;
    915c:	e51b3010 	ldr	r3, [fp, #-16]
    9160:	e2832001 	add	r2, r3, #1
    9164:	e50b2010 	str	r2, [fp, #-16]
    9168:	e5d33000 	ldrb	r3, [r3]
    916c:	e54b3005 	strb	r3, [fp, #-5]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:225
     	u2 = (unsigned char) *s2++;
    9170:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9174:	e2832001 	add	r2, r3, #1
    9178:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    917c:	e5d33000 	ldrb	r3, [r3]
    9180:	e54b3006 	strb	r3, [fp, #-6]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:226
      	if (u1 != u2)
    9184:	e55b2005 	ldrb	r2, [fp, #-5]
    9188:	e55b3006 	ldrb	r3, [fp, #-6]
    918c:	e1520003 	cmp	r2, r3
    9190:	0a000003 	beq	91a4 <_Z7strncmpPKcS0_i+0x84>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:227
        	return u1 - u2;
    9194:	e55b2005 	ldrb	r2, [fp, #-5]
    9198:	e55b3006 	ldrb	r3, [fp, #-6]
    919c:	e0423003 	sub	r3, r2, r3
    91a0:	ea000005 	b	91bc <_Z7strncmpPKcS0_i+0x9c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:228
      	if (u1 == '\0')
    91a4:	e55b3005 	ldrb	r3, [fp, #-5]
    91a8:	e3530000 	cmp	r3, #0
    91ac:	1affffe1 	bne	9138 <_Z7strncmpPKcS0_i+0x18>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:229
        	return 0;
    91b0:	e3a03000 	mov	r3, #0
    91b4:	ea000000 	b	91bc <_Z7strncmpPKcS0_i+0x9c>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:232
    }

  	return 0;
    91b8:	e3a03000 	mov	r3, #0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:233
}
    91bc:	e1a00003 	mov	r0, r3
    91c0:	e28bd000 	add	sp, fp, #0
    91c4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    91c8:	e12fff1e 	bx	lr

000091cc <_Z6strlenPKc>:
_Z6strlenPKc():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:236

int strlen(const char* s)
{
    91cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    91d0:	e28db000 	add	fp, sp, #0
    91d4:	e24dd014 	sub	sp, sp, #20
    91d8:	e50b0010 	str	r0, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:237
	int i = 0;
    91dc:	e3a03000 	mov	r3, #0
    91e0:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:239

	while (s[i] != '\0')
    91e4:	e51b3008 	ldr	r3, [fp, #-8]
    91e8:	e51b2010 	ldr	r2, [fp, #-16]
    91ec:	e0823003 	add	r3, r2, r3
    91f0:	e5d33000 	ldrb	r3, [r3]
    91f4:	e3530000 	cmp	r3, #0
    91f8:	0a000003 	beq	920c <_Z6strlenPKc+0x40>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:240
		i++;
    91fc:	e51b3008 	ldr	r3, [fp, #-8]
    9200:	e2833001 	add	r3, r3, #1
    9204:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:239
	while (s[i] != '\0')
    9208:	eafffff5 	b	91e4 <_Z6strlenPKc+0x18>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:242

	return i;
    920c:	e51b3008 	ldr	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:243
}
    9210:	e1a00003 	mov	r0, r3
    9214:	e28bd000 	add	sp, fp, #0
    9218:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    921c:	e12fff1e 	bx	lr

00009220 <_Z5bzeroPvi>:
_Z5bzeroPvi():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:246

void bzero(void* memory, int length)
{
    9220:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9224:	e28db000 	add	fp, sp, #0
    9228:	e24dd014 	sub	sp, sp, #20
    922c:	e50b0010 	str	r0, [fp, #-16]
    9230:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:247
	char* mem = reinterpret_cast<char*>(memory);
    9234:	e51b3010 	ldr	r3, [fp, #-16]
    9238:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:249

	for (int i = 0; i < length; i++)
    923c:	e3a03000 	mov	r3, #0
    9240:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:249 (discriminator 3)
    9244:	e51b2008 	ldr	r2, [fp, #-8]
    9248:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    924c:	e1520003 	cmp	r2, r3
    9250:	aa000008 	bge	9278 <_Z5bzeroPvi+0x58>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:250 (discriminator 2)
		mem[i] = 0;
    9254:	e51b3008 	ldr	r3, [fp, #-8]
    9258:	e51b200c 	ldr	r2, [fp, #-12]
    925c:	e0823003 	add	r3, r2, r3
    9260:	e3a02000 	mov	r2, #0
    9264:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:249 (discriminator 2)
	for (int i = 0; i < length; i++)
    9268:	e51b3008 	ldr	r3, [fp, #-8]
    926c:	e2833001 	add	r3, r3, #1
    9270:	e50b3008 	str	r3, [fp, #-8]
    9274:	eafffff2 	b	9244 <_Z5bzeroPvi+0x24>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:251
}
    9278:	e320f000 	nop	{0}
    927c:	e28bd000 	add	sp, fp, #0
    9280:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9284:	e12fff1e 	bx	lr

00009288 <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:254

void memcpy(const void* src, void* dst, int num)
{
    9288:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    928c:	e28db000 	add	fp, sp, #0
    9290:	e24dd024 	sub	sp, sp, #36	; 0x24
    9294:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    9298:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    929c:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:255
	const char* memsrc = reinterpret_cast<const char*>(src);
    92a0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    92a4:	e50b300c 	str	r3, [fp, #-12]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:256
	char* memdst = reinterpret_cast<char*>(dst);
    92a8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    92ac:	e50b3010 	str	r3, [fp, #-16]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:258

	for (int i = 0; i < num; i++)
    92b0:	e3a03000 	mov	r3, #0
    92b4:	e50b3008 	str	r3, [fp, #-8]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:258 (discriminator 3)
    92b8:	e51b2008 	ldr	r2, [fp, #-8]
    92bc:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    92c0:	e1520003 	cmp	r2, r3
    92c4:	aa00000b 	bge	92f8 <_Z6memcpyPKvPvi+0x70>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:259 (discriminator 2)
		memdst[i] = memsrc[i];
    92c8:	e51b3008 	ldr	r3, [fp, #-8]
    92cc:	e51b200c 	ldr	r2, [fp, #-12]
    92d0:	e0822003 	add	r2, r2, r3
    92d4:	e51b3008 	ldr	r3, [fp, #-8]
    92d8:	e51b1010 	ldr	r1, [fp, #-16]
    92dc:	e0813003 	add	r3, r1, r3
    92e0:	e5d22000 	ldrb	r2, [r2]
    92e4:	e5c32000 	strb	r2, [r3]
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:258 (discriminator 2)
	for (int i = 0; i < num; i++)
    92e8:	e51b3008 	ldr	r3, [fp, #-8]
    92ec:	e2833001 	add	r3, r3, #1
    92f0:	e50b3008 	str	r3, [fp, #-8]
    92f4:	eaffffef 	b	92b8 <_Z6memcpyPKvPvi+0x30>
/mnt/c/user/privateWorkspace/School/OS/SP/KIV-RTOS/sources/stdlib/src/stdstring.cpp:260
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
 130:	fb010200 	blx	4093a <__bss_end+0x374de>
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
 174:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffe4d <__bss_end+0xffff69f1>
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
 1ac:	0a030000 	beq	c01b4 <__bss_end+0xb6d58>
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
 1ec:	4a020402 	bmi	811fc <__bss_end+0x77da0>
 1f0:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 1f4:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
 1f8:	01058509 	tsteq	r5, r9, lsl #10
 1fc:	0d05a12f 	stfeqd	f2, [r5, #-188]	; 0xffffff44
 200:	0024056a 	eoreq	r0, r4, sl, ror #10
 204:	4a030402 	bmi	c1214 <__bss_end+0xb7db8>
 208:	02000405 	andeq	r0, r0, #83886080	; 0x5000000
 20c:	05830204 	streq	r0, [r3, #516]	; 0x204
 210:	0402000b 	streq	r0, [r2], #-11
 214:	02054a02 	andeq	r4, r5, #8192	; 0x2000
 218:	02040200 	andeq	r0, r4, #0, 4
 21c:	8509052d 	strhi	r0, [r9, #-1325]	; 0xfffffad3
 220:	022f0105 	eoreq	r0, pc, #1073741825	; 0x40000001
 224:	0101000a 	tsteq	r1, sl
 228:	00000203 	andeq	r0, r0, r3, lsl #4
 22c:	01d90003 	bicseq	r0, r9, r3
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
 288:	74696e69 	strbtvc	r6, [r9], #-3689	; 0xfffff197
 28c:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
 290:	6d2f006b 	stcvs	0, cr0, [pc, #-428]!	; ec <_start-0x7f14>
 294:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 298:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
 29c:	72702f72 	rsbsvc	r2, r0, #456	; 0x1c8
 2a0:	74617669 	strbtvc	r7, [r1], #-1641	; 0xfffff997
 2a4:	726f5765 	rsbvc	r5, pc, #26476544	; 0x1940000
 2a8:	6170736b 	cmnvs	r0, fp, ror #6
 2ac:	532f6563 			; <UNDEFINED> instruction: 0x532f6563
 2b0:	6f6f6863 	svcvs	0x006f6863
 2b4:	534f2f6c 	movtpl	r2, #65388	; 0xff6c
 2b8:	2f50532f 	svccs	0x0050532f
 2bc:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
 2c0:	534f5452 	movtpl	r5, #62546	; 0xf452
 2c4:	756f732f 	strbvc	r7, [pc, #-815]!	; ffffff9d <__bss_end+0xffff6b41>
 2c8:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 2cc:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
 2d0:	61707372 	cmnvs	r0, r2, ror r3
 2d4:	2e2f6563 	cfsh64cs	mvdx6, mvdx15, #51
 2d8:	656b2f2e 	strbvs	r2, [fp, #-3886]!	; 0xfffff0d2
 2dc:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 2e0:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 2e4:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 2e8:	6f72702f 	svcvs	0x0072702f
 2ec:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 2f0:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
 2f4:	2f632f74 	svccs	0x00632f74
 2f8:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 2fc:	6972702f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, ip, sp, lr}^
 300:	65746176 	ldrbvs	r6, [r4, #-374]!	; 0xfffffe8a
 304:	6b726f57 	blvs	1c9c068 <__bss_end+0x1c92c0c>
 308:	63617073 	cmnvs	r1, #115	; 0x73
 30c:	63532f65 	cmpvs	r3, #404	; 0x194
 310:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 178 <_start-0x7e88>
 314:	2f534f2f 	svccs	0x00534f2f
 318:	4b2f5053 	blmi	bd446c <__bss_end+0xbcb010>
 31c:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
 320:	2f534f54 	svccs	0x00534f54
 324:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 328:	2f736563 	svccs	0x00736563
 32c:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 330:	63617073 	cmnvs	r1, #115	; 0x73
 334:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
 338:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 33c:	2f6c656e 	svccs	0x006c656e
 340:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 344:	2f656475 	svccs	0x00656475
 348:	2f007366 	svccs	0x00007366
 34c:	2f746e6d 	svccs	0x00746e6d
 350:	73752f63 	cmnvc	r5, #396	; 0x18c
 354:	702f7265 	eorvc	r7, pc, r5, ror #4
 358:	61766972 	cmnvs	r6, r2, ror r9
 35c:	6f576574 	svcvs	0x00576574
 360:	70736b72 	rsbsvc	r6, r3, r2, ror fp
 364:	2f656361 	svccs	0x00656361
 368:	6f686353 	svcvs	0x00686353
 36c:	4f2f6c6f 	svcmi	0x002f6c6f
 370:	50532f53 	subspl	r2, r3, r3, asr pc
 374:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
 378:	4f54522d 	svcmi	0x0054522d
 37c:	6f732f53 	svcvs	0x00732f53
 380:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 384:	73752f73 	cmnvc	r5, #460	; 0x1cc
 388:	70737265 	rsbsvc	r7, r3, r5, ror #4
 38c:	2f656361 	svccs	0x00656361
 390:	6b2f2e2e 	blvs	bcbc50 <__bss_end+0xbc27f4>
 394:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 398:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 39c:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 3a0:	6f622f65 	svcvs	0x00622f65
 3a4:	2f647261 	svccs	0x00647261
 3a8:	30697072 	rsbcc	r7, r9, r2, ror r0
 3ac:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
 3b0:	616d0000 	cmnvs	sp, r0
 3b4:	632e6e69 			; <UNDEFINED> instruction: 0x632e6e69
 3b8:	01007070 	tsteq	r0, r0, ror r0
 3bc:	70730000 	rsbsvc	r0, r3, r0
 3c0:	6f6c6e69 	svcvs	0x006c6e69
 3c4:	682e6b63 	stmdavs	lr!, {r0, r1, r5, r6, r8, r9, fp, sp, lr}
 3c8:	00000200 	andeq	r0, r0, r0, lsl #4
 3cc:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 3d0:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
 3d4:	682e6d65 	stmdavs	lr!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
 3d8:	00000300 	andeq	r0, r0, r0, lsl #6
 3dc:	636f7270 	cmnvs	pc, #112, 4
 3e0:	2e737365 	cdpcs	3, 7, cr7, cr3, cr5, {3}
 3e4:	00020068 	andeq	r0, r2, r8, rrx
 3e8:	6f727000 	svcvs	0x00727000
 3ec:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 3f0:	6e616d5f 	mcrvs	13, 3, r6, cr1, cr15, {2}
 3f4:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
 3f8:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 3fc:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
 400:	66656474 			; <UNDEFINED> instruction: 0x66656474
 404:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
 408:	05000000 	streq	r0, [r0, #-0]
 40c:	02050001 	andeq	r0, r5, #1
 410:	0000822c 	andeq	r8, r0, ip, lsr #4
 414:	a3130517 	tstge	r3, #96468992	; 0x5c00000
 418:	05511f05 	ldrbeq	r1, [r1, #-3845]	; 0xfffff0fb
 41c:	03054a22 	movweq	r4, #23074	; 0x5a22
 420:	4b040582 	blmi	101a30 <__bss_end+0xf85d4>
 424:	05310e05 	ldreq	r0, [r1, #-3589]!	; 0xfffff1fb
 428:	02022a03 	andeq	r2, r2, #12288	; 0x3000
 42c:	a0010100 	andge	r0, r1, r0, lsl #2
 430:	03000002 	movweq	r0, #2
 434:	0001b500 	andeq	fp, r1, r0, lsl #10
 438:	fb010200 	blx	40c42 <__bss_end+0x377e6>
 43c:	01000d0e 	tsteq	r0, lr, lsl #26
 440:	00010101 	andeq	r0, r1, r1, lsl #2
 444:	00010000 	andeq	r0, r1, r0
 448:	6d2f0100 	stfvss	f0, [pc, #-0]	; 450 <_start-0x7bb0>
 44c:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 450:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
 454:	72702f72 	rsbsvc	r2, r0, #456	; 0x1c8
 458:	74617669 	strbtvc	r7, [r1], #-1641	; 0xfffff997
 45c:	726f5765 	rsbvc	r5, pc, #26476544	; 0x1940000
 460:	6170736b 	cmnvs	r0, fp, ror #6
 464:	532f6563 			; <UNDEFINED> instruction: 0x532f6563
 468:	6f6f6863 	svcvs	0x006f6863
 46c:	534f2f6c 	movtpl	r2, #65388	; 0xff6c
 470:	2f50532f 	svccs	0x0050532f
 474:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
 478:	534f5452 	movtpl	r5, #62546	; 0xf452
 47c:	756f732f 	strbvc	r7, [pc, #-815]!	; 155 <_start-0x7eab>
 480:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 484:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
 488:	2f62696c 	svccs	0x0062696c
 48c:	00637273 	rsbeq	r7, r3, r3, ror r2
 490:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
 494:	752f632f 	strvc	r6, [pc, #-815]!	; 16d <_start-0x7e93>
 498:	2f726573 	svccs	0x00726573
 49c:	76697270 			; <UNDEFINED> instruction: 0x76697270
 4a0:	57657461 	strbpl	r7, [r5, -r1, ror #8]!
 4a4:	736b726f 	cmnvc	fp, #-268435450	; 0xf0000006
 4a8:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 4ac:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
 4b0:	2f6c6f6f 	svccs	0x006c6f6f
 4b4:	532f534f 			; <UNDEFINED> instruction: 0x532f534f
 4b8:	494b2f50 	stmdbmi	fp, {r4, r6, r8, r9, sl, fp, sp}^
 4bc:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
 4c0:	732f534f 			; <UNDEFINED> instruction: 0x732f534f
 4c4:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 4c8:	6b2f7365 	blvs	bdd264 <__bss_end+0xbd3e08>
 4cc:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 4d0:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 4d4:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 4d8:	72702f65 	rsbsvc	r2, r0, #404	; 0x194
 4dc:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 4e0:	6d2f0073 	stcvs	0, cr0, [pc, #-460]!	; 31c <_start-0x7ce4>
 4e4:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 4e8:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
 4ec:	72702f72 	rsbsvc	r2, r0, #456	; 0x1c8
 4f0:	74617669 	strbtvc	r7, [r1], #-1641	; 0xfffff997
 4f4:	726f5765 	rsbvc	r5, pc, #26476544	; 0x1940000
 4f8:	6170736b 	cmnvs	r0, fp, ror #6
 4fc:	532f6563 			; <UNDEFINED> instruction: 0x532f6563
 500:	6f6f6863 	svcvs	0x006f6863
 504:	534f2f6c 	movtpl	r2, #65388	; 0xff6c
 508:	2f50532f 	svccs	0x0050532f
 50c:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
 510:	534f5452 	movtpl	r5, #62546	; 0xf452
 514:	756f732f 	strbvc	r7, [pc, #-815]!	; 1ed <_start-0x7e13>
 518:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 51c:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 520:	2f6c656e 	svccs	0x006c656e
 524:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 528:	2f656475 	svccs	0x00656475
 52c:	2f007366 	svccs	0x00007366
 530:	2f746e6d 	svccs	0x00746e6d
 534:	73752f63 	cmnvc	r5, #396	; 0x18c
 538:	702f7265 	eorvc	r7, pc, r5, ror #4
 53c:	61766972 	cmnvs	r6, r2, ror r9
 540:	6f576574 	svcvs	0x00576574
 544:	70736b72 	rsbsvc	r6, r3, r2, ror fp
 548:	2f656361 	svccs	0x00656361
 54c:	6f686353 	svcvs	0x00686353
 550:	4f2f6c6f 	svcmi	0x002f6c6f
 554:	50532f53 	subspl	r2, r3, r3, asr pc
 558:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
 55c:	4f54522d 	svcmi	0x0054522d
 560:	6f732f53 	svcvs	0x00732f53
 564:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 568:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
 56c:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 570:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 574:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 578:	616f622f 	cmnvs	pc, pc, lsr #4
 57c:	722f6472 	eorvc	r6, pc, #1912602624	; 0x72000000
 580:	2f306970 	svccs	0x00306970
 584:	006c6168 	rsbeq	r6, ip, r8, ror #2
 588:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
 58c:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 590:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 594:	00000100 	andeq	r0, r0, r0, lsl #2
 598:	2e697773 	mcrcs	7, 3, r7, cr9, cr3, {3}
 59c:	00020068 	andeq	r0, r2, r8, rrx
 5a0:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
 5a4:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
 5a8:	00682e6b 	rsbeq	r2, r8, fp, ror #28
 5ac:	66000002 	strvs	r0, [r0], -r2
 5b0:	73656c69 	cmnvc	r5, #26880	; 0x6900
 5b4:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
 5b8:	00682e6d 	rsbeq	r2, r8, sp, ror #28
 5bc:	70000003 	andvc	r0, r0, r3
 5c0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 5c4:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
 5c8:	00000200 	andeq	r0, r0, r0, lsl #4
 5cc:	636f7270 	cmnvs	pc, #112, 4
 5d0:	5f737365 	svcpl	0x00737365
 5d4:	616e616d 	cmnvs	lr, sp, ror #2
 5d8:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
 5dc:	00020068 	andeq	r0, r2, r8, rrx
 5e0:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
 5e4:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
 5e8:	00040068 	andeq	r0, r4, r8, rrx
 5ec:	01050000 	mrseq	r0, (UNDEF: 5)
 5f0:	74020500 	strvc	r0, [r2], #-1280	; 0xfffffb00
 5f4:	16000082 	strne	r0, [r0], -r2, lsl #1
 5f8:	2f690505 	svccs	0x00690505
 5fc:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 600:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 604:	054b8305 	strbeq	r8, [fp, #-773]	; 0xfffffcfb
 608:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 60c:	01054b05 	tsteq	r5, r5, lsl #22
 610:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
 614:	2f4b4ba1 	svccs	0x004b4ba1
 618:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 61c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 620:	4b4bbd05 	blmi	12efa3c <__bss_end+0x12e65e0>
 624:	0c052f4b 	stceq	15, cr2, [r5], {75}	; 0x4b
 628:	2f01054c 	svccs	0x0001054c
 62c:	bd050585 	cfstr32lt	mvfx0, [r5, #-532]	; 0xfffffdec
 630:	2f4b4b4b 	svccs	0x004b4b4b
 634:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 638:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 63c:	054b8305 	strbeq	r8, [fp, #-773]	; 0xfffffcfb
 640:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 644:	4b4bbd05 	blmi	12efa60 <__bss_end+0x12e6604>
 648:	0c052f4b 	stceq	15, cr2, [r5], {75}	; 0x4b
 64c:	2f01054c 	svccs	0x0001054c
 650:	a1050585 	smlabbge	r5, r5, r5, r0
 654:	052f4b4b 	streq	r4, [pc, #-2891]!	; fffffb11 <__bss_end+0xffff66b5>
 658:	01054c0c 	tsteq	r5, ip, lsl #24
 65c:	0505852f 	streq	r8, [r5, #-1327]	; 0xfffffad1
 660:	4b4b4bbd 	blmi	12d355c <__bss_end+0x12ca100>
 664:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 668:	852f0105 	strhi	r0, [pc, #-261]!	; 56b <_start-0x7a95>
 66c:	4ba10505 	blmi	fe841a88 <__bss_end+0xfe83862c>
 670:	0c052f4b 	stceq	15, cr2, [r5], {75}	; 0x4b
 674:	9f01054c 	svcls	0x0001054c
 678:	67200585 	strvs	r0, [r0, -r5, lsl #11]!
 67c:	4b4d0505 	blmi	1341a98 <__bss_end+0x133863c>
 680:	300c054b 	andcc	r0, ip, fp, asr #10
 684:	852f0105 	strhi	r0, [pc, #-261]!	; 587 <_start-0x7a79>
 688:	05672005 	strbeq	r2, [r7, #-5]!
 68c:	4b4b4d05 	blmi	12d3aa8 <__bss_end+0x12ca64c>
 690:	05300c05 	ldreq	r0, [r0, #-3077]!	; 0xfffff3fb
 694:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 698:	05058320 	streq	r8, [r5, #-800]	; 0xfffffce0
 69c:	054b4b4c 	strbeq	r4, [fp, #-2892]	; 0xfffff4b4
 6a0:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 6a4:	05056720 	streq	r6, [r5, #-1824]	; 0xfffff8e0
 6a8:	054b4b4d 	strbeq	r4, [fp, #-2893]	; 0xfffff4b3
 6ac:	0105300c 	tsteq	r5, ip
 6b0:	0c05872f 	stceq	7, cr8, [r5], {47}	; 0x2f
 6b4:	31059fa0 	smlatbcc	r5, r0, pc, r9	; <UNPREDICTABLE>
 6b8:	662905bc 			; <UNDEFINED> instruction: 0x662905bc
 6bc:	052e3605 	streq	r3, [lr, #-1541]!	; 0xfffff9fb
 6c0:	1305300f 	movwne	r3, #20495	; 0x500f
 6c4:	84090566 	strhi	r0, [r9], #-1382	; 0xfffffa9a
 6c8:	05d81005 	ldrbeq	r1, [r8, #5]
 6cc:	08029f01 	stmdaeq	r2, {r0, r8, r9, sl, fp, ip, pc}
 6d0:	37010100 	strcc	r0, [r1, -r0, lsl #2]
 6d4:	03000005 	movweq	r0, #5
 6d8:	00006a00 	andeq	r6, r0, r0, lsl #20
 6dc:	fb010200 	blx	40ee6 <__bss_end+0x37a8a>
 6e0:	01000d0e 	tsteq	r0, lr, lsl #26
 6e4:	00010101 	andeq	r0, r1, r1, lsl #2
 6e8:	00010000 	andeq	r0, r1, r0
 6ec:	6d2f0100 	stfvss	f0, [pc, #-0]	; 6f4 <_start-0x790c>
 6f0:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
 6f4:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
 6f8:	72702f72 	rsbsvc	r2, r0, #456	; 0x1c8
 6fc:	74617669 	strbtvc	r7, [r1], #-1641	; 0xfffff997
 700:	726f5765 	rsbvc	r5, pc, #26476544	; 0x1940000
 704:	6170736b 	cmnvs	r0, fp, ror #6
 708:	532f6563 			; <UNDEFINED> instruction: 0x532f6563
 70c:	6f6f6863 	svcvs	0x006f6863
 710:	534f2f6c 	movtpl	r2, #65388	; 0xff6c
 714:	2f50532f 	svccs	0x0050532f
 718:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
 71c:	534f5452 	movtpl	r5, #62546	; 0xf452
 720:	756f732f 	strbvc	r7, [pc, #-815]!	; 3f9 <_start-0x7c07>
 724:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 728:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
 72c:	2f62696c 	svccs	0x0062696c
 730:	00637273 	rsbeq	r7, r3, r3, ror r2
 734:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
 738:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
 73c:	632e676e 			; <UNDEFINED> instruction: 0x632e676e
 740:	01007070 	tsteq	r0, r0, ror r0
 744:	05000000 	streq	r0, [r0, #-0]
 748:	02050001 	andeq	r0, r5, #1
 74c:	000086d0 	ldrdeq	r8, [r0], -r0
 750:	05010a03 	streq	r0, [r1, #-2563]	; 0xfffff5fd
 754:	0f05bb06 	svceq	0x0005bb06
 758:	6821054c 	stmdavs	r1!, {r2, r3, r6, r8, sl}
 75c:	05ba0a05 	ldreq	r0, [sl, #2565]!	; 0xa05
 760:	27052e0b 	strcs	r2, [r5, -fp, lsl #28]
 764:	4a0d054a 	bmi	341c94 <__bss_end+0x338838>
 768:	052f0905 	streq	r0, [pc, #-2309]!	; fffffe6b <__bss_end+0xffff6a0f>
 76c:	02059f04 	andeq	r9, r5, #4, 30
 770:	35050562 	strcc	r0, [r5, #-1378]	; 0xfffffa9e
 774:	05681005 	strbeq	r1, [r8, #-5]!
 778:	22052e11 	andcs	r2, r5, #272	; 0x110
 77c:	2e13054a 	cfmac32cs	mvfx0, mvfx3, mvfx10
 780:	052f0a05 	streq	r0, [pc, #-2565]!	; fffffd83 <__bss_end+0xffff6927>
 784:	0a056909 	beq	15abb0 <__bss_end+0x151754>
 788:	4a0c052e 	bmi	301c48 <__bss_end+0x2f87ec>
 78c:	054b0305 	strbeq	r0, [fp, #-773]	; 0xfffffcfb
 790:	1805680b 	stmdane	r5, {r0, r1, r3, fp, sp, lr}
 794:	03040200 	movweq	r0, #16896	; 0x4200
 798:	0014054a 	andseq	r0, r4, sl, asr #10
 79c:	9e030402 	cdpls	4, 0, cr0, cr3, cr2, {0}
 7a0:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
 7a4:	05680204 	strbeq	r0, [r8, #-516]!	; 0xfffffdfc
 7a8:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
 7ac:	08058202 	stmdaeq	r5, {r1, r9, pc}
 7b0:	02040200 	andeq	r0, r4, #0, 4
 7b4:	001a054a 	andseq	r0, sl, sl, asr #10
 7b8:	4b020402 	blmi	817c8 <__bss_end+0x7836c>
 7bc:	02001b05 	andeq	r1, r0, #5120	; 0x1400
 7c0:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 7c4:	0402000c 	streq	r0, [r2], #-12
 7c8:	0f054a02 	svceq	0x00054a02
 7cc:	02040200 	andeq	r0, r4, #0, 4
 7d0:	001b0582 	andseq	r0, fp, r2, lsl #11
 7d4:	4a020402 	bmi	817e4 <__bss_end+0x78388>
 7d8:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
 7dc:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 7e0:	0402000a 	streq	r0, [r2], #-10
 7e4:	0b052f02 	bleq	14c3f4 <__bss_end+0x142f98>
 7e8:	02040200 	andeq	r0, r4, #0, 4
 7ec:	000d052e 	andeq	r0, sp, lr, lsr #10
 7f0:	4a020402 	bmi	81800 <__bss_end+0x783a4>
 7f4:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 7f8:	05460204 	strbeq	r0, [r6, #-516]	; 0xfffffdfc
 7fc:	05858801 	streq	r8, [r5, #2049]	; 0x801
 800:	0c058306 	stceq	3, cr8, [r5], {6}
 804:	8203054c 	andhi	r0, r3, #76, 10	; 0x13000000
 808:	054b0c05 	strbeq	r0, [fp, #-3077]	; 0xfffff3fb
 80c:	10054d09 	andne	r4, r5, r9, lsl #26
 810:	4c0a054a 	cfstr32mi	mvfx0, [sl], {74}	; 0x4a
 814:	05bb0705 	ldreq	r0, [fp, #1797]!	; 0x705
 818:	17054a03 	strne	r4, [r5, -r3, lsl #20]
 81c:	01040200 	mrseq	r0, R12_usr
 820:	0014054a 	andseq	r0, r4, sl, asr #10
 824:	4a010402 	bmi	41834 <__bss_end+0x383d8>
 828:	054d0d05 	strbeq	r0, [sp, #-3333]	; 0xfffff2fb
 82c:	0a054a14 	beq	153084 <__bss_end+0x149c28>
 830:	6808052e 	stmdavs	r8, {r1, r2, r3, r5, r8, sl}
 834:	78030205 	stmdavc	r3, {r0, r2, r9}
 838:	03090566 	movweq	r0, #38246	; 0x9566
 83c:	01052e0b 	tsteq	r5, fp, lsl #28
 840:	681b052f 	ldmdavs	fp, {r0, r1, r2, r3, r5, r8, sl}
 844:	05830905 	streq	r0, [r3, #2309]	; 0x905
 848:	12054b0b 	andne	r4, r5, #11264	; 0x2c00
 84c:	bb0f0568 	bllt	3c1df4 <__bss_end+0x3b8998>
 850:	05830905 	streq	r0, [r3, #2309]	; 0x905
 854:	0c056405 	cfstrseq	mvf6, [r5], {5}
 858:	4a120533 	bmi	481d2c <__bss_end+0x4788d0>
 85c:	05830f05 	streq	r0, [r3, #3845]	; 0xf05
 860:	05058309 	streq	r8, [r5, #-777]	; 0xfffffcf7
 864:	320a0564 	andcc	r0, sl, #100, 10	; 0x19000000
 868:	05670c05 	strbeq	r0, [r7, #-3077]!	; 0xfffff3fb
 86c:	05f52f01 	ldrbeq	r2, [r5, #3841]!	; 0xf01
 870:	0305bb16 	movweq	fp, #23318	; 0x5b16
 874:	670c0567 	strvs	r0, [ip, -r7, ror #10]
 878:	054d0b05 	strbeq	r0, [sp, #-2821]	; 0xfffff4fb
 87c:	0402001c 	streq	r0, [r2], #-28	; 0xffffffe4
 880:	14054a01 	strne	r4, [r5], #-2561	; 0xfffff5ff
 884:	01040200 	mrseq	r0, R12_usr
 888:	d70e0566 	strle	r0, [lr, -r6, ror #10]
 88c:	052e0f05 	streq	r0, [lr, #-3845]!	; 0xfffff0fb
 890:	03054a08 	movweq	r4, #23048	; 0x5a08
 894:	0013054b 	andseq	r0, r3, fp, asr #10
 898:	66020402 	strvs	r0, [r2], -r2, lsl #8
 89c:	02001005 	andeq	r1, r0, #5
 8a0:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
 8a4:	0402001d 	streq	r0, [r2], #-29	; 0xffffffe3
 8a8:	28054a03 	stmdacs	r5, {r0, r1, r9, fp, lr}
 8ac:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 8b0:	670b0566 	strvs	r0, [fp, -r6, ror #10]
 8b4:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 8b8:	05470204 	strbeq	r0, [r7, #-516]	; 0xfffffdfc
 8bc:	01058909 	tsteq	r5, r9, lsl #18
 8c0:	0905692f 	stmdbeq	r5, {r0, r1, r2, r3, r5, r8, fp, sp, lr}
 8c4:	4b070587 	blmi	1c1ee8 <__bss_end+0x1b8a8c>
 8c8:	054c1105 	strbeq	r1, [ip, #-261]	; 0xfffffefb
 8cc:	0d05660f 	stceq	6, cr6, [r5, #-60]	; 0xffffffc4
 8d0:	2e1d052e 	cfmul64cs	mvdx0, mvdx13, mvdx14
 8d4:	01040200 	mrseq	r0, R12_usr
 8d8:	20056606 	andcs	r6, r5, r6, lsl #12
 8dc:	03040200 	movweq	r0, #16896	; 0x4200
 8e0:	1d056606 	stcne	6, cr6, [r5, #-24]	; 0xffffffe8
 8e4:	05040200 	streq	r0, [r4, #-512]	; 0xfffffe00
 8e8:	04020066 	streq	r0, [r2], #-102	; 0xffffff9a
 8ec:	004a0606 	subeq	r0, sl, r6, lsl #12
 8f0:	2e080402 	cdpcs	4, 0, cr0, cr8, cr2, {0}
 8f4:	4b060905 	blmi	182d10 <__bss_end+0x1798b4>
 8f8:	054a0a05 	strbeq	r0, [sl, #-2565]	; 0xfffff5fb
 8fc:	10054a15 	andne	r4, r5, r5, lsl sl
 900:	6607054a 	strvs	r0, [r7], -sl, asr #10
 904:	31490305 	cmpcc	r9, r5, lsl #6
 908:	05671305 	strbeq	r1, [r7, #-773]!	; 0xfffffcfb
 90c:	0f056611 	svceq	0x00056611
 910:	2e1f052e 	cfmul64cs	mvdx0, mvdx15, mvdx14
 914:	01040200 	mrseq	r0, R12_usr
 918:	22056606 	andcs	r6, r5, #6291456	; 0x600000
 91c:	03040200 	movweq	r0, #16896	; 0x4200
 920:	1f056606 	svcne	0x00056606
 924:	05040200 	streq	r0, [r4, #-512]	; 0xfffffe00
 928:	04020066 	streq	r0, [r2], #-102	; 0xffffff9a
 92c:	004a0606 	subeq	r0, sl, r6, lsl #12
 930:	2e080402 	cdpcs	4, 0, cr0, cr8, cr2, {0}
 934:	4b060b05 	blmi	183550 <__bss_end+0x17a0f4>
 938:	054a0c05 	strbeq	r0, [sl, #-3077]	; 0xfffff3fb
 93c:	12054a17 	andne	r4, r5, #94208	; 0x17000
 940:	6609054a 	strvs	r0, [r9], -sl, asr #10
 944:	6405054b 	strvs	r0, [r5], #-1355	; 0xfffffab5
 948:	05330305 	ldreq	r0, [r3, #-773]!	; 0xfffffcfb
 94c:	04020010 	streq	r0, [r2], #-16
 950:	09056601 	stmdbeq	r5, {r0, r9, sl, sp, lr}
 954:	0b054b67 	bleq	1536f8 <__bss_end+0x14a29c>
 958:	6609054b 	strvs	r0, [r9], -fp, asr #10
 95c:	052e0705 	streq	r0, [lr, #-1797]!	; 0xfffff8fb
 960:	0d052f05 	stceq	15, cr2, [r5, #-20]	; 0xffffffec
 964:	660b0567 	strvs	r0, [fp], -r7, ror #10
 968:	052e0905 	streq	r0, [lr, #-2309]!	; 0xfffff6fb
 96c:	0d054b0a 	vstreq	d4, [r5, #-40]	; 0xffffffd8
 970:	660b0567 	strvs	r0, [fp], -r7, ror #10
 974:	052e0905 	streq	r0, [lr, #-2309]!	; 0xfffff6fb
 978:	004c2f0c 	subeq	r2, ip, ip, lsl #30
 97c:	06010402 	streq	r0, [r1], -r2, lsl #8
 980:	05670666 	strbeq	r0, [r7, #-1638]!	; 0xfffff99a
 984:	0905ba15 	stmdbeq	r5, {r0, r2, r4, r9, fp, ip, sp, pc}
 988:	4b0d054a 	blmi	341eb8 <__bss_end+0x338a5c>
 98c:	05660b05 	strbeq	r0, [r6, #-2821]!	; 0xfffff4fb
 990:	05052e09 	streq	r2, [r5, #-3593]	; 0xfffff1f7
 994:	320b052c 	andcc	r0, fp, #44, 10	; 0xb000000
 998:	05660705 	strbeq	r0, [r6, #-1797]!	; 0xfffff8fb
 99c:	0705680c 	streq	r6, [r5, -ip, lsl #16]
 9a0:	83060567 	movwhi	r0, #25959	; 0x6567
 9a4:	05640305 	strbeq	r0, [r4, #-773]!	; 0xfffffcfb
 9a8:	0705320c 	streq	r3, [r5, -ip, lsl #4]
 9ac:	bb060567 	bllt	181f50 <__bss_end+0x178af4>
 9b0:	05640305 	strbeq	r0, [r4, #-773]!	; 0xfffffcfb
 9b4:	0105320a 	tsteq	r5, sl, lsl #4
 9b8:	0826054b 	stmdaeq	r6!, {r0, r1, r3, r6, r8, sl}
 9bc:	0309053e 	movweq	r0, #38206	; 0x953e
 9c0:	054b9e09 	strbeq	r9, [fp, #-3593]	; 0xfffff1f7
 9c4:	054c4b0f 	strbeq	r4, [ip, #-2831]	; 0xfffff4f1
 9c8:	13052e05 	movwne	r2, #24069	; 0x5e05
 9cc:	67110567 	ldrvs	r0, [r1, -r7, ror #10]
 9d0:	054a1305 	strbeq	r1, [sl, #-773]	; 0xfffffcfb
 9d4:	0f054b09 	svceq	0x00054b09
 9d8:	2e050531 	mcrcs	5, 0, r0, cr5, cr1, {1}
 9dc:	05671005 	strbeq	r1, [r7, #-5]!
 9e0:	11056613 	tstne	r5, r3, lsl r6
 9e4:	4a0f054b 	bmi	3c1f18 <__bss_end+0x3b8abc>
 9e8:	05311905 	ldreq	r1, [r1, #-2309]!	; 0xfffff6fb
 9ec:	1b058415 	blne	161a48 <__bss_end+0x1585ec>
 9f0:	660d0567 	strvs	r0, [sp], -r7, ror #10
 9f4:	05671b05 	strbeq	r1, [r7, #-2821]!	; 0xfffff4fb
 9f8:	1b054a10 	blne	153240 <__bss_end+0x149de4>
 9fc:	4a130566 	bmi	4c1f9c <__bss_end+0x4b8b40>
 a00:	052f1705 	streq	r1, [pc, #-1797]!	; 303 <_start-0x7cfd>
 a04:	0f05661c 	svceq	0x0005661c
 a08:	2f090582 	svccs	0x00090582
 a0c:	61050567 	tstvs	r5, r7, ror #10
 a10:	67100536 			; <UNDEFINED> instruction: 0x67100536
 a14:	05661305 	strbeq	r1, [r6, #-773]!	; 0xfffffcfb
 a18:	0f054c0c 	svceq	0x00054c0c
 a1c:	4c190566 	cfldr32mi	mvfx0, [r9], {102}	; 0x66
 a20:	01040200 	mrseq	r0, R12_usr
 a24:	10056606 	andne	r6, r5, r6, lsl #12
 a28:	13056706 	movwne	r6, #22278	; 0x5706
 a2c:	4b090566 	blmi	241fcc <__bss_end+0x238b70>
 a30:	63050567 	movwvs	r0, #21863	; 0x5567
 a34:	05341305 	ldreq	r1, [r4, #-773]!	; 0xfffffcfb
 a38:	1b056715 	blne	15a694 <__bss_end+0x151238>
 a3c:	4a0d054a 	bmi	341f6c <__bss_end+0x338b10>
 a40:	05671b05 	strbeq	r1, [r7, #-2821]!	; 0xfffff4fb
 a44:	1b054a10 	blne	15328c <__bss_end+0x149e30>
 a48:	4a130566 	bmi	4c1fe8 <__bss_end+0x4b8b8c>
 a4c:	052f1105 	streq	r1, [pc, #-261]!	; 94f <_start-0x76b1>
 a50:	1e054a17 			; <UNDEFINED> instruction: 0x1e054a17
 a54:	9e0f054a 	cfsh32ls	mvfx0, mvfx15, #42
 a58:	052f0905 	streq	r0, [pc, #-2309]!	; 15b <_start-0x7ea5>
 a5c:	0d056205 	sfmeq	f6, 4, [r5, #-20]	; 0xffffffec
 a60:	67010534 	smladxvs	r1, r4, r5, r0
 a64:	bd0905a1 	cfstr32lt	mvfx0, [r9, #-644]	; 0xfffffd7c
 a68:	02001605 	andeq	r1, r0, #5242880	; 0x500000
 a6c:	054a0404 	strbeq	r0, [sl, #-1028]	; 0xfffffbfc
 a70:	0402001d 	streq	r0, [r2], #-29	; 0xffffffe3
 a74:	1e058202 	cdpne	2, 0, cr8, cr5, cr2, {0}
 a78:	02040200 	andeq	r0, r4, #0, 4
 a7c:	0016052e 	andseq	r0, r6, lr, lsr #10
 a80:	66020402 	strvs	r0, [r2], -r2, lsl #8
 a84:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
 a88:	054b0304 	strbeq	r0, [fp, #-772]	; 0xfffffcfc
 a8c:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
 a90:	08052e03 	stmdaeq	r5, {r0, r1, r9, sl, fp, sp}
 a94:	03040200 	movweq	r0, #16896	; 0x4200
 a98:	0009054a 	andeq	r0, r9, sl, asr #10
 a9c:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
 aa0:	02001205 	andeq	r1, r0, #1342177280	; 0x50000000
 aa4:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 aa8:	0402000b 	streq	r0, [r2], #-11
 aac:	02052e03 	andeq	r2, r5, #3, 28	; 0x30
 ab0:	03040200 	movweq	r0, #16896	; 0x4200
 ab4:	000b052d 	andeq	r0, fp, sp, lsr #10
 ab8:	84020402 	strhi	r0, [r2], #-1026	; 0xfffffbfe
 abc:	02000805 	andeq	r0, r0, #327680	; 0x50000
 ac0:	05830104 	streq	r0, [r3, #260]	; 0x104
 ac4:	04020009 	streq	r0, [r2], #-9
 ac8:	0b052e01 	bleq	14c2d4 <__bss_end+0x142e78>
 acc:	01040200 	mrseq	r0, R12_usr
 ad0:	0002054a 	andeq	r0, r2, sl, asr #10
 ad4:	49010402 	stmdbmi	r1, {r1, sl}
 ad8:	05850b05 	streq	r0, [r5, #2821]	; 0xb05
 adc:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 ae0:	1605a10c 	strne	sl, [r5], -ip, lsl #2
 ae4:	03040200 	movweq	r0, #16896	; 0x4200
 ae8:	0017054a 	andseq	r0, r7, sl, asr #10
 aec:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
 af0:	02001905 	andeq	r1, r0, #81920	; 0x14000
 af4:	05660304 	strbeq	r0, [r6, #-772]!	; 0xfffffcfc
 af8:	04020005 	streq	r0, [r2], #-5
 afc:	0c054a02 			; <UNDEFINED> instruction: 0x0c054a02
 b00:	00150584 	andseq	r0, r5, r4, lsl #11
 b04:	4a030402 	bmi	c1b14 <__bss_end+0xb86b8>
 b08:	02001605 	andeq	r1, r0, #5242880	; 0x500000
 b0c:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
 b10:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
 b14:	19056603 	stmdbne	r5, {r0, r1, r9, sl, sp, lr}
 b18:	02040200 	andeq	r0, r4, #0, 4
 b1c:	001a054b 	andseq	r0, sl, fp, asr #10
 b20:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 b24:	02000f05 	andeq	r0, r0, #5, 30
 b28:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 b2c:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
 b30:	1a058202 	bne	161340 <__bss_end+0x157ee4>
 b34:	02040200 	andeq	r0, r4, #0, 4
 b38:	0013054a 	andseq	r0, r3, sl, asr #10
 b3c:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 b40:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
 b44:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
 b48:	0d05850b 	cfstr32eq	mvfx8, [r5, #-44]	; 0xffffffd4
 b4c:	4a0f0582 	bmi	3c215c <__bss_end+0x3b8d00>
 b50:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 b54:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 b58:	1105bc0e 	tstne	r5, lr, lsl #24
 b5c:	bc200566 	cfstr32lt	mvfx0, [r0], #-408	; 0xfffffe68
 b60:	05660b05 	strbeq	r0, [r6, #-2821]!	; 0xfffff4fb
 b64:	0a054b1f 	beq	1537e8 <__bss_end+0x14a38c>
 b68:	4b080566 	blmi	202108 <__bss_end+0x1f8cac>
 b6c:	05831105 	streq	r1, [r3, #261]	; 0x105
 b70:	08052e16 	stmdaeq	r5, {r1, r2, r4, r9, sl, fp, sp}
 b74:	67110567 	ldrvs	r0, [r1, -r7, ror #10]
 b78:	054d0b05 	strbeq	r0, [sp, #-2821]	; 0xfffff4fb
 b7c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 b80:	0b058306 	bleq	1617a0 <__bss_end+0x158344>
 b84:	2e0c054c 	cfsh32cs	mvfx0, mvfx12, #44
 b88:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
 b8c:	02054b04 	andeq	r4, r5, #4, 22	; 0x1000
 b90:	31090565 	tstcc	r9, r5, ror #10
 b94:	852f0105 	strhi	r0, [pc, #-261]!	; a97 <_start-0x7569>
 b98:	059f0805 	ldreq	r0, [pc, #2053]	; 13a5 <_start-0x6c5b>
 b9c:	14054c0b 	strne	r4, [r5], #-3083	; 0xfffff3f5
 ba0:	03040200 	movweq	r0, #16896	; 0x4200
 ba4:	0007054a 	andeq	r0, r7, sl, asr #10
 ba8:	83020402 	movwhi	r0, #9218	; 0x2402
 bac:	02000805 	andeq	r0, r0, #327680	; 0x50000
 bb0:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 bb4:	0402000a 	streq	r0, [r2], #-10
 bb8:	02054a02 	andeq	r4, r5, #8192	; 0x2000
 bbc:	02040200 	andeq	r0, r4, #0, 4
 bc0:	84010549 	strhi	r0, [r1], #-1353	; 0xfffffab7
 bc4:	bb0e0585 	bllt	3821e0 <__bss_end+0x378d84>
 bc8:	054b0805 	strbeq	r0, [fp, #-2053]	; 0xfffff7fb
 bcc:	14054c0b 	strne	r4, [r5], #-3083	; 0xfffff3f5
 bd0:	03040200 	movweq	r0, #16896	; 0x4200
 bd4:	0016054a 	andseq	r0, r6, sl, asr #10
 bd8:	83020402 	movwhi	r0, #9218	; 0x2402
 bdc:	02001705 	andeq	r1, r0, #1310720	; 0x140000
 be0:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 be4:	0402000a 	streq	r0, [r2], #-10
 be8:	0b054a02 	bleq	1533f8 <__bss_end+0x149f9c>
 bec:	02040200 	andeq	r0, r4, #0, 4
 bf0:	0017052e 	andseq	r0, r7, lr, lsr #10
 bf4:	4a020402 	bmi	81c04 <__bss_end+0x787a8>
 bf8:	02000d05 	andeq	r0, r0, #320	; 0x140
 bfc:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 c00:	04020002 	streq	r0, [r2], #-2
 c04:	01052d02 	tsteq	r5, r2, lsl #26
 c08:	00080284 	andeq	r0, r8, r4, lsl #5
 c0c:	Address 0x0000000000000c0c is out of bounds.


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
      58:	03dc0704 	bicseq	r0, ip, #4, 14	; 0x100000
      5c:	b3020000 	movwlt	r0, #8192	; 0x2000
      60:	01000000 	mrseq	r0, (UNDEF: 0)
      64:	00311507 	eorseq	r1, r1, r7, lsl #10
      68:	9b040000 	blls	100070 <__bss_end+0xf6c14>
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
     128:	000003dc 	ldrdeq	r0, [r0], -ip
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
     174:	cb104801 	blgt	412180 <__bss_end+0x408d24>
     178:	d4000000 	strle	r0, [r0], #-0
     17c:	58000081 	stmdapl	r0, {r0, r7}
     180:	01000000 	mrseq	r0, (UNDEF: 0)
     184:	0000cb9c 	muleq	r0, ip, fp
     188:	01d30a00 	bicseq	r0, r3, r0, lsl #20
     18c:	4a010000 	bmi	40194 <__bss_end+0x36d38>
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
     24c:	8b120f01 	blhi	483e58 <__bss_end+0x47a9fc>
     250:	0f000001 	svceq	0x00000001
     254:	0000019e 	muleq	r0, lr, r1
     258:	03851000 	orreq	r1, r5, #0
     25c:	0a010000 	beq	40264 <__bss_end+0x36e08>
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
     2e0:	00000233 	andeq	r0, r0, r3, lsr r2
     2e4:	00043c04 	andeq	r3, r4, r4, lsl #24
     2e8:	00004c00 	andeq	r4, r0, r0, lsl #24
     2ec:	00822c00 	addeq	r2, r2, r0, lsl #24
     2f0:	00004800 	andeq	r4, r0, r0, lsl #16
     2f4:	00022800 	andeq	r2, r2, r0, lsl #16
     2f8:	08010200 	stmdaeq	r1, {r9}
     2fc:	0000041d 	andeq	r0, r0, sp, lsl r4
     300:	d9050202 	stmdble	r5, {r1, r9}
     304:	03000004 	movweq	r0, #4
     308:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
     30c:	01020074 	tsteq	r2, r4, ror r0
     310:	00041408 	andeq	r1, r4, r8, lsl #8
     314:	07020200 	streq	r0, [r2, -r0, lsl #4]
     318:	0000049f 	muleq	r0, pc, r4	; <UNPREDICTABLE>
     31c:	00042704 	andeq	r2, r4, r4, lsl #14
     320:	07090600 	streq	r0, [r9, -r0, lsl #12]
     324:	00000059 	andeq	r0, r0, r9, asr r0
     328:	00004805 	andeq	r4, r0, r5, lsl #16
     32c:	07040200 	streq	r0, [r4, -r0, lsl #4]
     330:	000003dc 	ldrdeq	r0, [r0], -ip
     334:	0003b006 	andeq	fp, r3, r6
     338:	14050200 	strne	r0, [r5], #-512	; 0xfffffe00
     33c:	00000054 	andeq	r0, r0, r4, asr r0
     340:	93d40305 	bicsls	r0, r4, #335544320	; 0x14000000
     344:	30060000 	andcc	r0, r6, r0
     348:	02000004 	andeq	r0, r0, #4
     34c:	00541406 	subseq	r1, r4, r6, lsl #8
     350:	03050000 	movweq	r0, #20480	; 0x5000
     354:	000093d8 	ldrdeq	r9, [r0], -r8
     358:	0004e306 	andeq	lr, r4, r6, lsl #6
     35c:	1a070300 	bne	1c0f64 <__bss_end+0x1b7b08>
     360:	00000054 	andeq	r0, r0, r4, asr r0
     364:	93dc0305 	bicsls	r0, ip, #335544320	; 0x14000000
     368:	99060000 	stmdbls	r6, {}	; <UNPREDICTABLE>
     36c:	03000003 	movweq	r0, #3
     370:	00541a09 	subseq	r1, r4, r9, lsl #20
     374:	03050000 	movweq	r0, #20480	; 0x5000
     378:	000093e0 	andeq	r9, r0, r0, ror #7
     37c:	0004cb06 	andeq	ip, r4, r6, lsl #22
     380:	1a0b0300 	bne	2c0f88 <__bss_end+0x2b7b2c>
     384:	00000054 	andeq	r0, r0, r4, asr r0
     388:	93e40305 	mvnls	r0, #335544320	; 0x14000000
     38c:	01060000 	mrseq	r0, (UNDEF: 6)
     390:	03000004 	movweq	r0, #4
     394:	00541a0d 	subseq	r1, r4, sp, lsl #20
     398:	03050000 	movweq	r0, #20480	; 0x5000
     39c:	000093e8 	andeq	r9, r0, r8, ror #7
     3a0:	0003be06 	andeq	fp, r3, r6, lsl #28
     3a4:	1a0f0300 	bne	3c0fac <__bss_end+0x3b7b50>
     3a8:	00000054 	andeq	r0, r0, r4, asr r0
     3ac:	93ec0305 	mvnls	r0, #335544320	; 0x14000000
     3b0:	01020000 	mrseq	r0, (UNDEF: 2)
     3b4:	0003e902 	andeq	lr, r3, r2, lsl #18
     3b8:	04b20600 	ldrteq	r0, [r2], #1536	; 0x600
     3bc:	04040000 	streq	r0, [r4], #-0
     3c0:	00005414 	andeq	r5, r0, r4, lsl r4
     3c4:	f0030500 			; <UNDEFINED> instruction: 0xf0030500
     3c8:	06000093 			; <UNDEFINED> instruction: 0x06000093
     3cc:	00000494 	muleq	r0, r4, r4
     3d0:	54140704 	ldrpl	r0, [r4], #-1796	; 0xfffff8fc
     3d4:	05000000 	streq	r0, [r0, #-0]
     3d8:	0093f403 	addseq	pc, r3, r3, lsl #8
     3dc:	03ee0600 	mvneq	r0, #0, 12
     3e0:	0a040000 	beq	1003e8 <__bss_end+0xf6f8c>
     3e4:	00005414 	andeq	r5, r0, r4, lsl r4
     3e8:	f8030500 			; <UNDEFINED> instruction: 0xf8030500
     3ec:	02000093 	andeq	r0, r0, #147	; 0x93
     3f0:	03d70704 	bicseq	r0, r7, #4, 14	; 0x100000
     3f4:	c8060000 	stmdagt	r6, {}	; <UNPREDICTABLE>
     3f8:	05000003 	streq	r0, [r0, #-3]
     3fc:	0054140a 	subseq	r1, r4, sl, lsl #8
     400:	03050000 	movweq	r0, #20480	; 0x5000
     404:	000093fc 	strdeq	r9, [r0], -ip
     408:	00042207 	andeq	r2, r4, r7, lsl #4
     40c:	05050100 	streq	r0, [r5, #-256]	; 0xffffff00
     410:	00000033 	andeq	r0, r0, r3, lsr r0
     414:	0000822c 	andeq	r8, r0, ip, lsr #4
     418:	00000048 	andeq	r0, r0, r8, asr #32
     41c:	016d9c01 	cmneq	sp, r1, lsl #24
     420:	ab080000 	blge	200428 <__bss_end+0x1f6fcc>
     424:	01000003 	tsteq	r0, r3
     428:	00330e05 	eorseq	r0, r3, r5, lsl #28
     42c:	91020000 	mrsls	r0, (UNDEF: 2)
     430:	04f90874 	ldrbteq	r0, [r9], #2164	; 0x874
     434:	05010000 	streq	r0, [r1, #-0]
     438:	00016d1b 	andeq	r6, r1, fp, lsl sp
     43c:	70910200 	addsvc	r0, r1, r0, lsl #4
     440:	73040900 	movwvc	r0, #18688	; 0x4900
     444:	09000001 	stmdbeq	r0, {r0}
     448:	00002504 	andeq	r2, r0, r4, lsl #10
     44c:	0ba50000 	bleq	fe940454 <__bss_end+0xfe936ff8>
     450:	00040000 	andeq	r0, r4, r0
     454:	00000269 	andeq	r0, r0, r9, ror #4
     458:	0abd0104 	beq	fef40870 <__bss_end+0xfef37414>
     45c:	1d040000 	stcne	0, cr0, [r4, #-0]
     460:	5400000a 	strpl	r0, [r0], #-10
     464:	7400000f 	strvc	r0, [r0], #-15
     468:	5c000082 	stcpl	0, cr0, [r0], {130}	; 0x82
     46c:	2f000004 	svccs	0x00000004
     470:	02000004 	andeq	r0, r0, #4
     474:	041d0801 	ldreq	r0, [sp], #-2049	; 0xfffff7ff
     478:	25030000 	strcs	r0, [r3, #-0]
     47c:	02000000 	andeq	r0, r0, #0
     480:	04d90502 	ldrbeq	r0, [r9], #1282	; 0x502
     484:	04040000 	streq	r0, [r4], #-0
     488:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
     48c:	08010200 	stmdaeq	r1, {r9}
     490:	00000414 	andeq	r0, r0, r4, lsl r4
     494:	9f070202 	svcls	0x00070202
     498:	05000004 	streq	r0, [r0, #-4]
     49c:	00000427 	andeq	r0, r0, r7, lsr #8
     4a0:	5e070907 	vmlapl.f16	s0, s14, s14	; <UNPREDICTABLE>
     4a4:	03000000 	movweq	r0, #0
     4a8:	0000004d 	andeq	r0, r0, sp, asr #32
     4ac:	dc070402 	cfstrsle	mvf0, [r7], {2}
     4b0:	06000003 	streq	r0, [r0], -r3
     4b4:	00000708 	andeq	r0, r0, r8, lsl #14
     4b8:	08060208 	stmdaeq	r6, {r3, r9}
     4bc:	0000008b 	andeq	r0, r0, fp, lsl #1
     4c0:	00307207 	eorseq	r7, r0, r7, lsl #4
     4c4:	4d0e0802 	stcmi	8, cr0, [lr, #-8]
     4c8:	00000000 	andeq	r0, r0, r0
     4cc:	00317207 	eorseq	r7, r1, r7, lsl #4
     4d0:	4d0e0902 	vstrmi.16	s0, [lr, #-4]	; <UNPREDICTABLE>
     4d4:	04000000 	streq	r0, [r0], #-0
     4d8:	0c930800 	ldceq	8, cr0, [r3], {0}
     4dc:	04050000 	streq	r0, [r5], #-0
     4e0:	00000038 	andeq	r0, r0, r8, lsr r0
     4e4:	a90c0d02 	stmdbge	ip, {r1, r8, sl, fp}
     4e8:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     4ec:	00004b4f 	andeq	r4, r0, pc, asr #22
     4f0:	0007350a 	andeq	r3, r7, sl, lsl #10
     4f4:	08000100 	stmdaeq	r0, {r8}
     4f8:	000005e9 	andeq	r0, r0, r9, ror #11
     4fc:	00380405 	eorseq	r0, r8, r5, lsl #8
     500:	1f020000 	svcne	0x00020000
     504:	0000e00c 	andeq	lr, r0, ip
     508:	07870a00 	streq	r0, [r7, r0, lsl #20]
     50c:	0a000000 	beq	514 <_start-0x7aec>
     510:	00000fb5 			; <UNDEFINED> instruction: 0x00000fb5
     514:	0f950a01 	svceq	0x00950a01
     518:	0a020000 	beq	80520 <__bss_end+0x770c4>
     51c:	00000948 	andeq	r0, r0, r8, asr #18
     520:	0b720a03 	bleq	1c82d34 <__bss_end+0x1c798d8>
     524:	0a040000 	beq	10052c <__bss_end+0xf70d0>
     528:	00000747 	andeq	r0, r0, r7, asr #14
     52c:	b8080005 	stmdalt	r8, {r0, r2}
     530:	0500000e 	streq	r0, [r0, #-14]
     534:	00003804 	andeq	r3, r0, r4, lsl #16
     538:	0c400200 	sfmeq	f0, 2, [r0], {-0}
     53c:	0000011d 	andeq	r0, r0, sp, lsl r1
     540:	0005090a 	andeq	r0, r5, sl, lsl #18
     544:	fe0a0000 	cdp2	0, 0, cr0, cr10, cr0, {0}
     548:	01000005 	tsteq	r0, r5
     54c:	000b600a 	andeq	r6, fp, sl
     550:	150a0200 	strne	r0, [sl, #-512]	; 0xfffffe00
     554:	0300000f 	movweq	r0, #15
     558:	000fbf0a 	andeq	fp, pc, sl, lsl #30
     55c:	7e0a0400 	cfcpysvc	mvf0, mvf10
     560:	0500000a 	streq	r0, [r0, #-10]
     564:	00090f0a 	andeq	r0, r9, sl, lsl #30
     568:	08000600 	stmdaeq	r0, {r9, sl}
     56c:	00000c5f 	andeq	r0, r0, pc, asr ip
     570:	00380405 	eorseq	r0, r8, r5, lsl #8
     574:	66020000 	strvs	r0, [r2], -r0
     578:	0001360c 	andeq	r3, r1, ip, lsl #12
     57c:	0b6d0a00 	bleq	1b42d84 <__bss_end+0x1b39928>
     580:	00000000 	andeq	r0, r0, r0
     584:	000e7208 	andeq	r7, lr, r8, lsl #4
     588:	38040500 	stmdacc	r4, {r8, sl}
     58c:	02000000 	andeq	r0, r0, #0
     590:	01610c6f 	cmneq	r1, pc, ror #24
     594:	e70a0000 	str	r0, [sl, -r0]
     598:	0000000b 	andeq	r0, r0, fp
     59c:	0008ca0a 	andeq	ip, r8, sl, lsl #20
     5a0:	480a0100 	stmdami	sl, {r8}
     5a4:	0200000c 	andeq	r0, r0, #12
     5a8:	0009140a 	andeq	r1, r9, sl, lsl #8
     5ac:	0b000300 	bleq	11b4 <_start-0x6e4c>
     5b0:	000003b0 			; <UNDEFINED> instruction: 0x000003b0
     5b4:	59140503 	ldmdbpl	r4, {r0, r1, r8, sl}
     5b8:	05000000 	streq	r0, [r0, #-0]
     5bc:	00940003 	addseq	r0, r4, r3
     5c0:	04300b00 	ldrteq	r0, [r0], #-2816	; 0xfffff500
     5c4:	06030000 	streq	r0, [r3], -r0
     5c8:	00005914 	andeq	r5, r0, r4, lsl r9
     5cc:	04030500 	streq	r0, [r3], #-1280	; 0xfffffb00
     5d0:	0b000094 	bleq	828 <_start-0x77d8>
     5d4:	000004e3 	andeq	r0, r0, r3, ror #9
     5d8:	591a0704 	ldmdbpl	sl, {r2, r8, r9, sl}
     5dc:	05000000 	streq	r0, [r0, #-0]
     5e0:	00940803 	addseq	r0, r4, r3, lsl #16
     5e4:	03990b00 	orrseq	r0, r9, #0, 22
     5e8:	09040000 	stmdbeq	r4, {}	; <UNPREDICTABLE>
     5ec:	0000591a 	andeq	r5, r0, sl, lsl r9
     5f0:	0c030500 	cfstr32eq	mvfx0, [r3], {-0}
     5f4:	0b000094 	bleq	84c <_start-0x77b4>
     5f8:	000004cb 	andeq	r0, r0, fp, asr #9
     5fc:	591a0b04 	ldmdbpl	sl, {r2, r8, r9, fp}
     600:	05000000 	streq	r0, [r0, #-0]
     604:	00941003 	addseq	r1, r4, r3
     608:	04010b00 	streq	r0, [r1], #-2816	; 0xfffff500
     60c:	0d040000 	stceq	0, cr0, [r4, #-0]
     610:	0000591a 	andeq	r5, r0, sl, lsl r9
     614:	14030500 	strne	r0, [r3], #-1280	; 0xfffffb00
     618:	0b000094 	bleq	870 <_start-0x7790>
     61c:	000003be 			; <UNDEFINED> instruction: 0x000003be
     620:	591a0f04 	ldmdbpl	sl, {r2, r8, r9, sl, fp}
     624:	05000000 	streq	r0, [r0, #-0]
     628:	00941803 	addseq	r1, r4, r3, lsl #16
     62c:	0f390800 	svceq	0x00390800
     630:	04050000 	streq	r0, [r5], #-0
     634:	00000038 	andeq	r0, r0, r8, lsr r0
     638:	040c1b04 	streq	r1, [ip], #-2820	; 0xfffff4fc
     63c:	0a000002 	beq	64c <_start-0x79b4>
     640:	00000d30 	andeq	r0, r0, r0, lsr sp
     644:	0f490a00 	svceq	0x00490a00
     648:	0a010000 	beq	40650 <__bss_end+0x371f4>
     64c:	00000b5b 	andeq	r0, r0, fp, asr fp
     650:	e10c0002 	tst	ip, r2
     654:	0200000b 	andeq	r0, r0, #11
     658:	03e90201 	mvneq	r0, #268435456	; 0x10000000
     65c:	040d0000 	streq	r0, [sp], #-0
     660:	0000002c 	andeq	r0, r0, ip, lsr #32
     664:	0204040d 	andeq	r0, r4, #218103808	; 0xd000000
     668:	b20b0000 	andlt	r0, fp, #0
     66c:	05000004 	streq	r0, [r0, #-4]
     670:	00591404 	subseq	r1, r9, r4, lsl #8
     674:	03050000 	movweq	r0, #20480	; 0x5000
     678:	0000941c 	andeq	r9, r0, ip, lsl r4
     67c:	0004940b 	andeq	r9, r4, fp, lsl #8
     680:	14070500 	strne	r0, [r7], #-1280	; 0xfffffb00
     684:	00000059 	andeq	r0, r0, r9, asr r0
     688:	94200305 	strtls	r0, [r0], #-773	; 0xfffffcfb
     68c:	ee0b0000 	cdp	0, 0, cr0, cr11, cr0, {0}
     690:	05000003 	streq	r0, [r0, #-3]
     694:	0059140a 	subseq	r1, r9, sl, lsl #8
     698:	03050000 	movweq	r0, #20480	; 0x5000
     69c:	00009424 	andeq	r9, r0, r4, lsr #8
     6a0:	0009a308 	andeq	sl, r9, r8, lsl #6
     6a4:	38040500 	stmdacc	r4, {r8, sl}
     6a8:	05000000 	streq	r0, [r0, #-0]
     6ac:	02890c0d 	addeq	r0, r9, #3328	; 0xd00
     6b0:	4e090000 	cdpmi	0, 0, cr0, cr9, cr0, {0}
     6b4:	00007765 	andeq	r7, r0, r5, ror #14
     6b8:	00099a0a 	andeq	r9, r9, sl, lsl #20
     6bc:	a40a0100 	strge	r0, [sl], #-256	; 0xffffff00
     6c0:	0200000c 	andeq	r0, r0, #12
     6c4:	00096c0a 	andeq	r6, r9, sl, lsl #24
     6c8:	3a0a0300 	bcc	2812d0 <__bss_end+0x277e74>
     6cc:	04000009 	streq	r0, [r0], #-9
     6d0:	000b660a 	andeq	r6, fp, sl, lsl #12
     6d4:	06000500 	streq	r0, [r0], -r0, lsl #10
     6d8:	0000073a 	andeq	r0, r0, sl, lsr r7
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
     708:	0007590e 	andeq	r5, r7, lr, lsl #18
     70c:	13200500 	nopne	{0}	; <UNPREDICTABLE>
     710:	000002c8 	andeq	r0, r0, r8, asr #5
     714:	0402000c 	streq	r0, [r2], #-12
     718:	0003d707 	andeq	sp, r3, r7, lsl #14
     71c:	07f60600 	ldrbeq	r0, [r6, r0, lsl #12]!
     720:	05800000 	streq	r0, [r0]
     724:	03920828 	orrseq	r0, r2, #40, 16	; 0x280000
     728:	240e0000 	strcs	r0, [lr], #-0
     72c:	0500000d 	streq	r0, [r0, #-13]
     730:	0289122a 	addeq	r1, r9, #-1610612734	; 0xa0000002
     734:	07000000 	streq	r0, [r0, -r0]
     738:	00646970 	rsbeq	r6, r4, r0, ror r9
     73c:	5e122b05 	vnmlspl.f64	d2, d2, d5
     740:	10000000 	andne	r0, r0, r0
     744:	0006430e 	andeq	r4, r6, lr, lsl #6
     748:	112c0500 			; <UNDEFINED> instruction: 0x112c0500
     74c:	00000252 	andeq	r0, r0, r2, asr r2
     750:	09af0e14 	stmibeq	pc!, {r2, r4, r9, sl, fp}	; <UNPREDICTABLE>
     754:	2d050000 	stccs	0, cr0, [r5, #-0]
     758:	00005e12 	andeq	r5, r0, r2, lsl lr
     75c:	bd0e1800 	stclt	8, cr1, [lr, #-0]
     760:	05000009 	streq	r0, [r0, #-9]
     764:	005e122e 	subseq	r1, lr, lr, lsr #4
     768:	0e1c0000 	cdpeq	0, 1, cr0, cr12, cr0, {0}
     76c:	00000728 	andeq	r0, r0, r8, lsr #14
     770:	920c2f05 	andls	r2, ip, #5, 30
     774:	20000003 	andcs	r0, r0, r3
     778:	0009d90e 	andeq	sp, r9, lr, lsl #18
     77c:	09300500 	ldmdbeq	r0!, {r8, sl}
     780:	00000038 	andeq	r0, r0, r8, lsr r0
     784:	0d410e60 	stcleq	14, cr0, [r1, #-384]	; 0xfffffe80
     788:	31050000 	mrscc	r0, (UNDEF: 5)
     78c:	00004d0e 	andeq	r4, r0, lr, lsl #26
     790:	980e6400 	stmdals	lr, {sl, sp, lr}
     794:	05000007 	streq	r0, [r0, #-7]
     798:	004d0e33 	subeq	r0, sp, r3, lsr lr
     79c:	0e680000 	cdpeq	0, 6, cr0, cr8, cr0, {0}
     7a0:	0000078f 	andeq	r0, r0, pc, lsl #15
     7a4:	4d0e3405 	cfstrsmi	mvf3, [lr, #-20]	; 0xffffffec
     7a8:	6c000000 	stcvs	0, cr0, [r0], {-0}
     7ac:	00747007 	rsbseq	r7, r4, r7
     7b0:	a20f3505 	andge	r3, pc, #20971520	; 0x1400000
     7b4:	70000003 	andvc	r0, r0, r3
     7b8:	000f1b0e 	andeq	r1, pc, lr, lsl #22
     7bc:	0e370500 	cfabs32eq	mvfx0, mvfx7
     7c0:	0000004d 	andeq	r0, r0, sp, asr #32
     7c4:	07140e74 			; <UNDEFINED> instruction: 0x07140e74
     7c8:	38050000 	stmdacc	r5, {}	; <UNPREDICTABLE>
     7cc:	00004d0e 	andeq	r4, r0, lr, lsl #26
     7d0:	ac0e7800 	stcge	8, cr7, [lr], {-0}
     7d4:	0500000c 	streq	r0, [r0, #-12]
     7d8:	004d0e39 	subeq	r0, sp, r9, lsr lr
     7dc:	007c0000 	rsbseq	r0, ip, r0
     7e0:	0002160f 	andeq	r1, r2, pc, lsl #12
     7e4:	0003a200 	andeq	sl, r3, r0, lsl #4
     7e8:	005e1000 	subseq	r1, lr, r0
     7ec:	000f0000 	andeq	r0, pc, r0
     7f0:	004d040d 	subeq	r0, sp, sp, lsl #8
     7f4:	c80b0000 	stmdagt	fp, {}	; <UNPREDICTABLE>
     7f8:	06000003 	streq	r0, [r0], -r3
     7fc:	0059140a 	subseq	r1, r9, sl, lsl #8
     800:	03050000 	movweq	r0, #20480	; 0x5000
     804:	00009428 	andeq	r9, r0, r8, lsr #8
     808:	00097408 	andeq	r7, r9, r8, lsl #8
     80c:	38040500 	stmdacc	r4, {r8, sl}
     810:	06000000 	streq	r0, [r0], -r0
     814:	03d90c0d 	bicseq	r0, r9, #3328	; 0xd00
     818:	030a0000 	movweq	r0, #40960	; 0xa000
     81c:	00000006 	andeq	r0, r0, r6
     820:	0004fe0a 	andeq	pc, r4, sl, lsl #28
     824:	03000100 	movweq	r0, #256	; 0x100
     828:	000003ba 			; <UNDEFINED> instruction: 0x000003ba
     82c:	000a0808 	andeq	r0, sl, r8, lsl #16
     830:	38040500 	stmdacc	r4, {r8, sl}
     834:	06000000 	streq	r0, [r0], -r0
     838:	03fd0c14 	mvnseq	r0, #20, 24	; 0x1400
     83c:	480a0000 	stmdami	sl, {}	; <UNPREDICTABLE>
     840:	00000005 	andeq	r0, r0, r5
     844:	000c3a0a 	andeq	r3, ip, sl, lsl #20
     848:	03000100 	movweq	r0, #256	; 0x100
     84c:	000003de 	ldrdeq	r0, [r0], -lr
     850:	000e0106 	andeq	r0, lr, r6, lsl #2
     854:	1b060c00 	blne	18385c <__bss_end+0x17a400>
     858:	00043708 	andeq	r3, r4, r8, lsl #14
     85c:	05430e00 	strbeq	r0, [r3, #-3584]	; 0xfffff200
     860:	1d060000 	stcne	0, cr0, [r6, #-0]
     864:	00043719 	andeq	r3, r4, r9, lsl r7
     868:	c00e0000 	andgt	r0, lr, r0
     86c:	06000005 	streq	r0, [r0], -r5
     870:	0437191e 	ldrteq	r1, [r7], #-2334	; 0xfffff6e2
     874:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
     878:	00000db5 			; <UNDEFINED> instruction: 0x00000db5
     87c:	3d131f06 	ldccc	15, cr1, [r3, #-24]	; 0xffffffe8
     880:	08000004 	stmdaeq	r0, {r2}
     884:	02040d00 	andeq	r0, r4, #0, 26
     888:	0d000004 	stceq	0, cr0, [r0, #-16]
     88c:	0002cf04 	andeq	ip, r2, r4, lsl #30
     890:	06681100 	strbteq	r1, [r8], -r0, lsl #2
     894:	06140000 	ldreq	r0, [r4], -r0
     898:	06f90722 	ldrbteq	r0, [r9], r2, lsr #14
     89c:	620e0000 	andvs	r0, lr, #0
     8a0:	06000009 	streq	r0, [r0], -r9
     8a4:	004d1226 	subeq	r1, sp, r6, lsr #4
     8a8:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     8ac:	00000574 	andeq	r0, r0, r4, ror r5
     8b0:	371d2906 	ldrcc	r2, [sp, -r6, lsl #18]
     8b4:	04000004 	streq	r0, [r0], #-4
     8b8:	000cfb0e 	andeq	pc, ip, lr, lsl #22
     8bc:	1d2c0600 	stcne	6, cr0, [ip, #-0]
     8c0:	00000437 	andeq	r0, r0, r7, lsr r4
     8c4:	0eae1208 	cdpeq	2, 10, cr1, cr14, cr8, {0}
     8c8:	2f060000 	svccs	0x00060000
     8cc:	000dde0e 	andeq	sp, sp, lr, lsl #28
     8d0:	00048b00 	andeq	r8, r4, r0, lsl #22
     8d4:	00049600 	andeq	r9, r4, r0, lsl #12
     8d8:	06fe1300 	ldrbteq	r1, [lr], r0, lsl #6
     8dc:	37140000 	ldrcc	r0, [r4, -r0]
     8e0:	00000004 	andeq	r0, r0, r4
     8e4:	000dc615 	andeq	ip, sp, r5, lsl r6
     8e8:	0e310600 	cfmsuba32eq	mvax0, mvax0, mvfx1, mvfx0
     8ec:	000007cd 	andeq	r0, r0, sp, asr #15
     8f0:	00000209 	andeq	r0, r0, r9, lsl #4
     8f4:	000004ae 	andeq	r0, r0, lr, lsr #9
     8f8:	000004b9 			; <UNDEFINED> instruction: 0x000004b9
     8fc:	0006fe13 	andeq	pc, r6, r3, lsl lr	; <UNPREDICTABLE>
     900:	043d1400 	ldrteq	r1, [sp], #-1024	; 0xfffffc00
     904:	16000000 	strne	r0, [r0], -r0
     908:	00000e14 	andeq	r0, r0, r4, lsl lr
     90c:	901d3506 	andsls	r3, sp, r6, lsl #10
     910:	3700000d 	strcc	r0, [r0, -sp]
     914:	02000004 	andeq	r0, r0, #4
     918:	000004d2 	ldrdeq	r0, [r0], -r2
     91c:	000004d8 	ldrdeq	r0, [r0], -r8
     920:	0006fe13 	andeq	pc, r6, r3, lsl lr	; <UNPREDICTABLE>
     924:	02160000 	andseq	r0, r6, #0
     928:	06000009 	streq	r0, [r0], -r9
     92c:	0c041d37 	stceq	13, cr1, [r4], {55}	; 0x37
     930:	04370000 	ldrteq	r0, [r7], #-0
     934:	f1020000 	cps	#0
     938:	f7000004 			; <UNDEFINED> instruction: 0xf7000004
     93c:	13000004 	movwne	r0, #4
     940:	000006fe 	strdeq	r0, [r0], -lr
     944:	09e91700 	stmibeq	r9!, {r8, r9, sl, ip}^
     948:	39060000 	stmdbcc	r6, {}	; <UNPREDICTABLE>
     94c:	00071731 	andeq	r1, r7, r1, lsr r7
     950:	16020c00 	strne	r0, [r2], -r0, lsl #24
     954:	00000668 	andeq	r0, r0, r8, ror #12
     958:	9b093c06 	blls	24f978 <__bss_end+0x24651c>
     95c:	fe00000f 	cdp2	0, 0, cr0, cr0, cr15, {0}
     960:	01000006 	tsteq	r0, r6
     964:	0000051e 	andeq	r0, r0, lr, lsl r5
     968:	00000524 	andeq	r0, r0, r4, lsr #10
     96c:	0006fe13 	andeq	pc, r6, r3, lsl lr	; <UNPREDICTABLE>
     970:	18160000 	ldmdane	r6, {}	; <UNPREDICTABLE>
     974:	06000006 	streq	r0, [r0], -r6
     978:	0e83123f 	mcreq	2, 4, r1, cr3, cr15, {1}
     97c:	004d0000 	subeq	r0, sp, r0
     980:	3d010000 	stccc	0, cr0, [r1, #-0]
     984:	52000005 	andpl	r0, r0, #5
     988:	13000005 	movwne	r0, #5
     98c:	000006fe 	strdeq	r0, [r0], -lr
     990:	00072014 	andeq	r2, r7, r4, lsl r0
     994:	005e1400 	subseq	r1, lr, r0, lsl #8
     998:	09140000 	ldmdbeq	r4, {}	; <UNPREDICTABLE>
     99c:	00000002 	andeq	r0, r0, r2
     9a0:	000dd518 	andeq	sp, sp, r8, lsl r5
     9a4:	0e420600 	cdpeq	6, 4, cr0, cr2, cr0, {0}
     9a8:	00000b93 	muleq	r0, r3, fp
     9ac:	00056701 	andeq	r6, r5, r1, lsl #14
     9b0:	00056d00 	andeq	r6, r5, r0, lsl #26
     9b4:	06fe1300 	ldrbteq	r1, [lr], r0, lsl #6
     9b8:	16000000 	strne	r0, [r0], -r0
     9bc:	00000841 	andeq	r0, r0, r1, asr #16
     9c0:	8c174506 	cfldr32hi	mvfx4, [r7], {6}
     9c4:	3d000005 	stccc	0, cr0, [r0, #-20]	; 0xffffffec
     9c8:	01000004 	tsteq	r0, r4
     9cc:	00000586 	andeq	r0, r0, r6, lsl #11
     9d0:	0000058c 	andeq	r0, r0, ip, lsl #11
     9d4:	00072613 	andeq	r2, r7, r3, lsl r6
     9d8:	c5160000 	ldrgt	r0, [r6, #-0]
     9dc:	06000005 	streq	r0, [r0], -r5
     9e0:	0d4d1748 	stcleq	7, cr1, [sp, #-288]	; 0xfffffee0
     9e4:	043d0000 	ldrteq	r0, [sp], #-0
     9e8:	a5010000 	strge	r0, [r1, #-0]
     9ec:	b0000005 	andlt	r0, r0, r5
     9f0:	13000005 	movwne	r0, #5
     9f4:	00000726 	andeq	r0, r0, r6, lsr #14
     9f8:	00004d14 	andeq	r4, r0, r4, lsl sp
     9fc:	fa180000 	blx	600a04 <__bss_end+0x5f75a8>
     a00:	0600000e 	streq	r0, [r0], -lr
     a04:	050e0e4b 	streq	r0, [lr, #-3659]	; 0xfffff1b5
     a08:	c5010000 	strgt	r0, [r1, #-0]
     a0c:	cb000005 	blgt	a28 <_start-0x75d8>
     a10:	13000005 	movwne	r0, #5
     a14:	000006fe 	strdeq	r0, [r0], -lr
     a18:	0dc61600 	stcleq	6, cr1, [r6]
     a1c:	4d060000 	stcmi	0, cr0, [r6, #-0]
     a20:	00075f0e 	andeq	r5, r7, lr, lsl #30
     a24:	00020900 	andeq	r0, r2, r0, lsl #18
     a28:	05e40100 	strbeq	r0, [r4, #256]!	; 0x100
     a2c:	05ef0000 	strbeq	r0, [pc, #0]!	; a34 <_start-0x75cc>
     a30:	fe130000 	cdp2	0, 1, cr0, cr3, cr0, {0}
     a34:	14000006 	strne	r0, [r0], #-6
     a38:	0000004d 	andeq	r0, r0, sp, asr #32
     a3c:	08661600 	stmdaeq	r6!, {r9, sl, ip}^
     a40:	50060000 	andpl	r0, r6, r0
     a44:	000bb412 	andeq	fp, fp, r2, lsl r4
     a48:	00004d00 	andeq	r4, r0, r0, lsl #26
     a4c:	06080100 	streq	r0, [r8], -r0, lsl #2
     a50:	06130000 	ldreq	r0, [r3], -r0
     a54:	fe130000 	cdp2	0, 1, cr0, cr3, cr0, {0}
     a58:	14000006 	strne	r0, [r0], #-6
     a5c:	00000216 	andeq	r0, r0, r6, lsl r2
     a60:	05551600 	ldrbeq	r1, [r5, #-1536]	; 0xfffffa00
     a64:	53060000 	movwpl	r0, #24576	; 0x6000
     a68:	0007a10e 	andeq	sl, r7, lr, lsl #2
     a6c:	00020900 	andeq	r0, r2, r0, lsl #18
     a70:	062c0100 	strteq	r0, [ip], -r0, lsl #2
     a74:	06370000 	ldrteq	r0, [r7], -r0
     a78:	fe130000 	cdp2	0, 1, cr0, cr3, cr0, {0}
     a7c:	14000006 	strne	r0, [r0], #-6
     a80:	0000004d 	andeq	r0, r0, sp, asr #32
     a84:	08e91800 	stmiaeq	r9!, {fp, ip}^
     a88:	56060000 	strpl	r0, [r6], -r0
     a8c:	000e200e 	andeq	r2, lr, lr
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
     ab8:	0d7a1800 	ldcleq	8, cr1, [sl, #-0]
     abc:	58060000 	stmdapl	r6, {}	; <UNPREDICTABLE>
     ac0:	0006bc0e 	andeq	fp, r6, lr, lsl #24
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
     aec:	0bf21800 	bleq	ffc86af4 <__bss_end+0xffc7d698>
     af0:	5a060000 	bpl	180af8 <__bss_end+0x17769c>
     af4:	00087a0e 	andeq	r7, r8, lr, lsl #20
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
     b20:	06551900 	ldrbeq	r1, [r5], -r0, lsl #18
     b24:	5d060000 	stcpl	0, cr0, [r6, #-0]
     b28:	0006790e 	andeq	r7, r6, lr, lsl #18
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
     b98:	00000855 	andeq	r0, r0, r5, asr r8
     b9c:	440ca401 	strmi	sl, [ip], #-1025	; 0xfffffbff
     ba0:	05000007 	streq	r0, [r0, #-7]
     ba4:	00942c03 	addseq	r2, r4, r3, lsl #24
     ba8:	05871f00 	streq	r1, [r7, #3840]	; 0xf00
     bac:	a6010000 	strge	r0, [r1], -r0
     bb0:	0009fc0a 	andeq	pc, r9, sl, lsl #24
     bb4:	00004d00 	andeq	r4, r0, r0, lsl #26
     bb8:	00862000 	addeq	r2, r6, r0
     bbc:	0000b000 	andeq	fp, r0, r0
     bc0:	b99c0100 	ldmiblt	ip, {r8}
     bc4:	20000007 	andcs	r0, r0, r7
     bc8:	00000ef5 	strdeq	r0, [r0], -r5
     bcc:	101ba601 	andsne	sl, fp, r1, lsl #12
     bd0:	03000002 	movweq	r0, #2
     bd4:	207fac91 			; <UNDEFINED> instruction: 0x207fac91
     bd8:	00000ab4 			; <UNDEFINED> instruction: 0x00000ab4
     bdc:	4d2aa601 	stcmi	6, cr10, [sl, #-4]!
     be0:	03000000 	movweq	r0, #0
     be4:	1e7fa891 	mrcne	8, 3, sl, cr15, cr1, {4}
     be8:	00000994 	muleq	r0, r4, r9
     bec:	b90aa801 	stmdblt	sl, {r0, fp, sp, pc}
     bf0:	03000007 	movweq	r0, #7
     bf4:	1e7fb491 	mrcne	4, 3, fp, cr15, cr1, {4}
     bf8:	0000056f 	andeq	r0, r0, pc, ror #10
     bfc:	3809ac01 	stmdacc	r9, {r0, sl, fp, sp, pc}
     c00:	02000000 	andeq	r0, r0, #0
     c04:	0f007491 	svceq	0x00007491
     c08:	00000025 	andeq	r0, r0, r5, lsr #32
     c0c:	000007c9 	andeq	r0, r0, r9, asr #15
     c10:	00005e10 	andeq	r5, r0, r0, lsl lr
     c14:	21003f00 	tstcs	r0, r0, lsl #30
     c18:	00000a99 	muleq	r0, r9, sl
     c1c:	730a9801 	movwvc	r9, #43009	; 0xa801
     c20:	4d00000c 	stcmi	0, cr0, [r0, #-48]	; 0xffffffd0
     c24:	e4000000 	str	r0, [r0], #-0
     c28:	3c000085 	stccc	0, cr0, [r0], {133}	; 0x85
     c2c:	01000000 	mrseq	r0, (UNDEF: 0)
     c30:	0008069c 	muleq	r8, ip, r6
     c34:	65722200 	ldrbvs	r2, [r2, #-512]!	; 0xfffffe00
     c38:	9a010071 	bls	40e04 <__bss_end+0x379a8>
     c3c:	0003fd20 	andeq	pc, r3, r0, lsr #26
     c40:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     c44:	0009e31e 	andeq	lr, r9, lr, lsl r3
     c48:	0e9b0100 	fmleqe	f0, f3, f0
     c4c:	0000004d 	andeq	r0, r0, sp, asr #32
     c50:	00709102 	rsbseq	r9, r0, r2, lsl #2
     c54:	000b8123 	andeq	r8, fp, r3, lsr #2
     c58:	068f0100 	streq	r0, [pc], r0, lsl #2
     c5c:	00000627 	andeq	r0, r0, r7, lsr #12
     c60:	000085a8 	andeq	r8, r0, r8, lsr #11
     c64:	0000003c 	andeq	r0, r0, ip, lsr r0
     c68:	083f9c01 	ldmdaeq	pc!, {r0, sl, fp, ip, pc}	; <UNPREDICTABLE>
     c6c:	0f200000 	svceq	0x00200000
     c70:	01000008 	tsteq	r0, r8
     c74:	004d218f 	subeq	r2, sp, pc, lsl #3
     c78:	91020000 	mrsls	r0, (UNDEF: 2)
     c7c:	6572226c 	ldrbvs	r2, [r2, #-620]!	; 0xfffffd94
     c80:	91010071 	tstls	r1, r1, ror r0
     c84:	0003fd20 	andeq	pc, r3, r0, lsr #26
     c88:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     c8c:	0a6f2100 	beq	1bc9094 <__bss_end+0x1bbfc38>
     c90:	83010000 	movwhi	r0, #4096	; 0x1000
     c94:	0008d50a 	andeq	sp, r8, sl, lsl #10
     c98:	00004d00 	andeq	r4, r0, r0, lsl #26
     c9c:	00856c00 	addeq	r6, r5, r0, lsl #24
     ca0:	00003c00 	andeq	r3, r0, r0, lsl #24
     ca4:	7c9c0100 	ldfvcs	f0, [ip], {0}
     ca8:	22000008 	andcs	r0, r0, #8
     cac:	00716572 	rsbseq	r6, r1, r2, ror r5
     cb0:	d9208501 	stmdble	r0!, {r0, r8, sl, pc}
     cb4:	02000003 	andeq	r0, r0, #3
     cb8:	681e7491 	ldmdavs	lr, {r0, r4, r7, sl, ip, sp, lr}
     cbc:	01000005 	tsteq	r0, r5
     cc0:	004d0e86 	subeq	r0, sp, r6, lsl #29
     cc4:	91020000 	mrsls	r0, (UNDEF: 2)
     cc8:	d8210070 	stmdale	r1!, {r4, r5, r6}
     ccc:	0100000e 	tsteq	r0, lr
     cd0:	08230a77 	stmdaeq	r3!, {r0, r1, r2, r4, r5, r6, r9, fp}
     cd4:	004d0000 	subeq	r0, sp, r0
     cd8:	85300000 	ldrhi	r0, [r0, #-0]!
     cdc:	003c0000 	eorseq	r0, ip, r0
     ce0:	9c010000 	stcls	0, cr0, [r1], {-0}
     ce4:	000008b9 			; <UNDEFINED> instruction: 0x000008b9
     ce8:	71657222 	cmnvc	r5, r2, lsr #4
     cec:	20790100 	rsbscs	r0, r9, r0, lsl #2
     cf0:	000003d9 	ldrdeq	r0, [r0], -r9
     cf4:	1e749102 	expnes	f1, f2
     cf8:	00000568 	andeq	r0, r0, r8, ror #10
     cfc:	4d0e7a01 	vstrmi	s14, [lr, #-4]
     d00:	02000000 	andeq	r0, r0, #0
     d04:	21007091 	swpcs	r7, r1, [r0]
     d08:	000008fc 	strdeq	r0, [r0], -ip
     d0c:	2a066b01 	bcs	19b918 <__bss_end+0x1924bc>
     d10:	0900000c 	stmdbeq	r0, {r2, r3}
     d14:	dc000002 	stcle	0, cr0, [r0], {2}
     d18:	54000084 	strpl	r0, [r0], #-132	; 0xffffff7c
     d1c:	01000000 	mrseq	r0, (UNDEF: 0)
     d20:	0009059c 	muleq	r9, ip, r5
     d24:	09e32000 	stmibeq	r3!, {sp}^
     d28:	6b010000 	blvs	40d30 <__bss_end+0x378d4>
     d2c:	00004d15 	andeq	r4, r0, r5, lsl sp
     d30:	6c910200 	lfmvs	f0, 4, [r1], {0}
     d34:	00078f20 	andeq	r8, r7, r0, lsr #30
     d38:	256b0100 	strbcs	r0, [fp, #-256]!	; 0xffffff00
     d3c:	0000004d 	andeq	r0, r0, sp, asr #32
     d40:	1e689102 	lgnnee	f1, f2
     d44:	00000ed0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     d48:	4d0e6d01 	stcmi	13, cr6, [lr, #-4]
     d4c:	02000000 	andeq	r0, r0, #0
     d50:	21007491 			; <UNDEFINED> instruction: 0x21007491
     d54:	0000063e 	andeq	r0, r0, lr, lsr r6
     d58:	c5125e01 	ldrgt	r5, [r2, #-3585]	; 0xfffff1ff
     d5c:	8b00000c 	blhi	d94 <_start-0x726c>
     d60:	8c000000 	stchi	0, cr0, [r0], {-0}
     d64:	50000084 	andpl	r0, r0, r4, lsl #1
     d68:	01000000 	mrseq	r0, (UNDEF: 0)
     d6c:	0009609c 	muleq	r9, ip, r0
     d70:	0c352000 	ldceq	0, cr2, [r5], #-0
     d74:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
     d78:	00004d20 	andeq	r4, r0, r0, lsr #26
     d7c:	6c910200 	lfmvs	f0, 4, [r1], {0}
     d80:	000a7820 	andeq	r7, sl, r0, lsr #16
     d84:	2f5e0100 	svccs	0x005e0100
     d88:	0000004d 	andeq	r0, r0, sp, asr #32
     d8c:	20689102 	rsbcs	r9, r8, r2, lsl #2
     d90:	0000078f 	andeq	r0, r0, pc, lsl #15
     d94:	4d3f5e01 	ldcmi	14, cr5, [pc, #-4]!	; d98 <_start-0x7268>
     d98:	02000000 	andeq	r0, r0, #0
     d9c:	d01e6491 	mulsle	lr, r1, r4
     da0:	0100000e 	tsteq	r0, lr
     da4:	008b1660 	addeq	r1, fp, r0, ror #12
     da8:	91020000 	mrsls	r0, (UNDEF: 2)
     dac:	0e210074 	mcreq	0, 1, r0, cr1, cr4, {3}
     db0:	0100000d 	tsteq	r0, sp
     db4:	06490a52 			; <UNDEFINED> instruction: 0x06490a52
     db8:	004d0000 	subeq	r0, sp, r0
     dbc:	84480000 	strbhi	r0, [r8], #-0
     dc0:	00440000 	subeq	r0, r4, r0
     dc4:	9c010000 	stcls	0, cr0, [r1], {-0}
     dc8:	000009ac 	andeq	r0, r0, ip, lsr #19
     dcc:	000c3520 	andeq	r3, ip, r0, lsr #10
     dd0:	1a520100 	bne	14811d8 <__bss_end+0x1477d7c>
     dd4:	0000004d 	andeq	r0, r0, sp, asr #32
     dd8:	206c9102 	rsbcs	r9, ip, r2, lsl #2
     ddc:	00000a78 	andeq	r0, r0, r8, ror sl
     de0:	4d295201 	sfmmi	f5, 4, [r9, #-4]!
     de4:	02000000 	andeq	r0, r0, #0
     de8:	f41e6891 			; <UNDEFINED> instruction: 0xf41e6891
     dec:	0100000c 	tsteq	r0, ip
     df0:	004d0e54 	subeq	r0, sp, r4, asr lr
     df4:	91020000 	mrsls	r0, (UNDEF: 2)
     df8:	ee210074 	mcr	0, 1, r0, cr1, cr4, {3}
     dfc:	0100000c 	tsteq	r0, ip
     e00:	0cd00a45 	vldmiaeq	r0, {s1-s69}
     e04:	004d0000 	subeq	r0, sp, r0
     e08:	83f80000 	mvnshi	r0, #0
     e0c:	00500000 	subseq	r0, r0, r0
     e10:	9c010000 	stcls	0, cr0, [r1], {-0}
     e14:	00000a07 	andeq	r0, r0, r7, lsl #20
     e18:	000c3520 	andeq	r3, ip, r0, lsr #10
     e1c:	19450100 	stmdbne	r5, {r8}^
     e20:	0000004d 	andeq	r0, r0, sp, asr #32
     e24:	206c9102 	rsbcs	r9, ip, r2, lsl #2
     e28:	0000094e 	andeq	r0, r0, lr, asr #18
     e2c:	36304501 	ldrtcc	r4, [r0], -r1, lsl #10
     e30:	02000001 	andeq	r0, r0, #1
     e34:	85206891 	strhi	r6, [r0, #-2193]!	; 0xfffff76f
     e38:	0100000a 	tsteq	r0, sl
     e3c:	07324145 	ldreq	r4, [r2, -r5, asr #2]!
     e40:	91020000 	mrsls	r0, (UNDEF: 2)
     e44:	0ed01e64 	cdpeq	14, 13, cr1, cr0, cr4, {3}
     e48:	47010000 	strmi	r0, [r1, -r0]
     e4c:	00004d0e 	andeq	r4, r0, lr, lsl #26
     e50:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     e54:	053d2300 	ldreq	r2, [sp, #-768]!	; 0xfffffd00
     e58:	3f010000 	svccc	0x00010000
     e5c:	00095806 	andeq	r5, r9, r6, lsl #16
     e60:	0083cc00 	addeq	ip, r3, r0, lsl #24
     e64:	00002c00 	andeq	r2, r0, r0, lsl #24
     e68:	319c0100 	orrscc	r0, ip, r0, lsl #2
     e6c:	2000000a 	andcs	r0, r0, sl
     e70:	00000c35 	andeq	r0, r0, r5, lsr ip
     e74:	4d153f01 	ldcmi	15, cr3, [r5, #-4]
     e78:	02000000 	andeq	r0, r0, #0
     e7c:	21007491 			; <UNDEFINED> instruction: 0x21007491
     e80:	000009d3 	ldrdeq	r0, [r0], -r3
     e84:	8b0a3201 	blhi	28d690 <__bss_end+0x284234>
     e88:	4d00000a 	stcmi	0, cr0, [r0, #-40]	; 0xffffffd8
     e8c:	7c000000 	stcvc	0, cr0, [r0], {-0}
     e90:	50000083 	andpl	r0, r0, r3, lsl #1
     e94:	01000000 	mrseq	r0, (UNDEF: 0)
     e98:	000a8c9c 	muleq	sl, ip, ip
     e9c:	0c352000 	ldceq	0, cr2, [r5], #-0
     ea0:	32010000 	andcc	r0, r1, #0
     ea4:	00004d19 	andeq	r4, r0, r9, lsl sp
     ea8:	6c910200 	lfmvs	f0, 4, [r1], {0}
     eac:	000d3a20 	andeq	r3, sp, r0, lsr #20
     eb0:	2b320100 	blcs	c812b8 <__bss_end+0xc77e5c>
     eb4:	00000210 	andeq	r0, r0, r0, lsl r2
     eb8:	20689102 	rsbcs	r9, r8, r2, lsl #2
     ebc:	00000ab8 			; <UNDEFINED> instruction: 0x00000ab8
     ec0:	4d3c3201 	lfmmi	f3, 4, [ip, #-4]!
     ec4:	02000000 	andeq	r0, r0, #0
     ec8:	bf1e6491 	svclt	0x001e6491
     ecc:	0100000c 	tsteq	r0, ip
     ed0:	004d0e34 	subeq	r0, sp, r4, lsr lr
     ed4:	91020000 	mrsls	r0, (UNDEF: 2)
     ed8:	10210074 	eorne	r0, r1, r4, ror r0
     edc:	0100000f 	tsteq	r0, pc
     ee0:	0dba0a25 			; <UNDEFINED> instruction: 0x0dba0a25
     ee4:	004d0000 	subeq	r0, sp, r0
     ee8:	832c0000 			; <UNDEFINED> instruction: 0x832c0000
     eec:	00500000 	subseq	r0, r0, r0
     ef0:	9c010000 	stcls	0, cr0, [r1], {-0}
     ef4:	00000ae7 	andeq	r0, r0, r7, ror #21
     ef8:	000c3520 	andeq	r3, ip, r0, lsr #10
     efc:	18250100 	stmdane	r5!, {r8}
     f00:	0000004d 	andeq	r0, r0, sp, asr #32
     f04:	206c9102 	rsbcs	r9, ip, r2, lsl #2
     f08:	00000d3a 	andeq	r0, r0, sl, lsr sp
     f0c:	ed2a2501 	cfstr32	mvfx2, [sl, #-4]!
     f10:	0200000a 	andeq	r0, r0, #10
     f14:	b8206891 	stmdalt	r0!, {r0, r4, r7, fp, sp, lr}
     f18:	0100000a 	tsteq	r0, sl
     f1c:	004d3b25 	subeq	r3, sp, r5, lsr #22
     f20:	91020000 	mrsls	r0, (UNDEF: 2)
     f24:	05ba1e64 	ldreq	r1, [sl, #3684]!	; 0xe64
     f28:	27010000 	strcs	r0, [r1, -r0]
     f2c:	00004d0e 	andeq	r4, r0, lr, lsl #26
     f30:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     f34:	25040d00 	strcs	r0, [r4, #-3328]	; 0xfffff300
     f38:	03000000 	movweq	r0, #0
     f3c:	00000ae7 	andeq	r0, r0, r7, ror #21
     f40:	0009f721 	andeq	pc, r9, r1, lsr #14
     f44:	0a190100 	beq	64134c <__bss_end+0x637ef0>
     f48:	00000f2d 	andeq	r0, r0, sp, lsr #30
     f4c:	0000004d 	andeq	r0, r0, sp, asr #32
     f50:	000082e8 	andeq	r8, r0, r8, ror #5
     f54:	00000044 	andeq	r0, r0, r4, asr #32
     f58:	0b3e9c01 	bleq	fa7f64 <__bss_end+0xf9eb08>
     f5c:	f1200000 			; <UNDEFINED> instruction: 0xf1200000
     f60:	0100000e 	tsteq	r0, lr
     f64:	02101b19 	andseq	r1, r0, #25600	; 0x6400
     f68:	91020000 	mrsls	r0, (UNDEF: 2)
     f6c:	0d1f206c 	ldceq	0, cr2, [pc, #-432]	; dc4 <_start-0x723c>
     f70:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
     f74:	0001df35 	andeq	sp, r1, r5, lsr pc
     f78:	68910200 	ldmvs	r1, {r9}
     f7c:	000c351e 	andeq	r3, ip, lr, lsl r5
     f80:	0e1b0100 	mufeqe	f0, f3, f0
     f84:	0000004d 	andeq	r0, r0, sp, asr #32
     f88:	00749102 	rsbseq	r9, r4, r2, lsl #2
     f8c:	00080324 	andeq	r0, r8, r4, lsr #6
     f90:	06140100 	ldreq	r0, [r4], -r0, lsl #2
     f94:	000005d8 	ldrdeq	r0, [r0], -r8
     f98:	000082cc 	andeq	r8, r0, ip, asr #5
     f9c:	0000001c 	andeq	r0, r0, ip, lsl r0
     fa0:	15239c01 	strne	r9, [r3, #-3073]!	; 0xfffff3ff
     fa4:	0100000d 	tsteq	r0, sp
     fa8:	092c060e 	stmdbeq	ip!, {r1, r2, r3, r9, sl}
     fac:	82a00000 	adchi	r0, r0, #0
     fb0:	002c0000 	eoreq	r0, ip, r0
     fb4:	9c010000 	stcls	0, cr0, [r1], {-0}
     fb8:	00000b7e 	andeq	r0, r0, lr, ror fp
     fbc:	00075020 	andeq	r5, r7, r0, lsr #32
     fc0:	140e0100 	strne	r0, [lr], #-256	; 0xffffff00
     fc4:	00000038 	andeq	r0, r0, r8, lsr r0
     fc8:	00749102 	rsbseq	r9, r4, r2, lsl #2
     fcc:	000f2625 	andeq	r2, pc, r5, lsr #12
     fd0:	0a040100 	beq	1013d8 <__bss_end+0xf7f7c>
     fd4:	00000989 	andeq	r0, r0, r9, lsl #19
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
    1000:	bd010400 	cfstrslt	mvf0, [r1, #-0]
    1004:	0400000a 	streq	r0, [r0], #-10
    1008:	00001012 	andeq	r1, r0, r2, lsl r0
    100c:	00000f54 	andeq	r0, r0, r4, asr pc
    1010:	000086d0 	ldrdeq	r8, [r0], -r0
    1014:	00000c38 	andeq	r0, r0, r8, lsr ip
    1018:	000006d3 	ldrdeq	r0, [r0], -r3
    101c:	00004902 	andeq	r4, r0, r2, lsl #18
    1020:	10e80300 	rscne	r0, r8, r0, lsl #6
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
    1060:	000003dc 	ldrdeq	r0, [r0], -ip
    1064:	1d080108 	stfnes	f0, [r8, #-32]	; 0xffffffe0
    1068:	07000004 	streq	r0, [r0, -r4]
    106c:	0000006d 	andeq	r0, r0, sp, rrx
    1070:	00002a09 	andeq	r2, r0, r9, lsl #20
    1074:	11060a00 	tstne	r6, r0, lsl #20
    1078:	fd010000 	stc2	0, cr0, [r1, #-0]
    107c:	000fcf06 	andeq	ip, pc, r6, lsl #30
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
    10bc:	0010f90c 	andseq	pc, r0, ip, lsl #18
    10c0:	0eff0100 	cdpeq	1, 15, cr0, cr15, cr0, {0}
    10c4:	00000112 	andeq	r0, r0, r2, lsl r1
    10c8:	0d709102 	ldfeqp	f1, [r0, #-8]!
    10cc:	000010e1 	andeq	r1, r0, r1, ror #1
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
    1114:	11000a00 	tstne	r0, r0, lsl #20
    1118:	f5010000 			; <UNDEFINED> instruction: 0xf5010000
    111c:	00108906 	andseq	r8, r0, r6, lsl #18
    1120:	00922000 	addseq	r2, r2, r0
    1124:	00006800 	andeq	r6, r0, r0, lsl #16
    1128:	7d9c0100 	ldfvcs	f0, [ip]
    112c:	14000001 	strne	r0, [r0], #-1
    1130:	0000116b 	andeq	r1, r0, fp, ror #2
    1134:	0412f501 	ldreq	pc, [r2], #-1281	; 0xfffffaff
    1138:	02000001 	andeq	r0, r0, #1
    113c:	72146c91 	andsvc	r6, r4, #37120	; 0x9100
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
    1174:	00100b16 	andseq	r0, r0, r6, lsl fp
    1178:	05eb0100 	strbeq	r0, [fp, #256]!	; 0x100
    117c:	0000113a 	andeq	r1, r0, sl, lsr r1
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
    11ac:	11121600 	tstne	r2, r0, lsl #12
    11b0:	db010000 	blle	411b8 <__bss_end+0x37d5c>
    11b4:	00114705 	andseq	r4, r1, r5, lsl #14
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
    1214:	04140801 	ldreq	r0, [r4], #-2049	; 0xfffff7ff
    1218:	82160000 	andshi	r0, r6, #0
    121c:	01000010 	tsteq	r0, r0, lsl r0
    1220:	10c707cd 	sbcne	r0, r7, sp, asr #15
    1224:	01180000 	tsteq	r8, r0
    1228:	904c0000 	subls	r0, ip, r0
    122c:	00d40000 	sbcseq	r0, r4, r0
    1230:	9c010000 	stcls	0, cr0, [r1], {-0}
    1234:	0000027a 	andeq	r0, r0, sl, ror r2
    1238:	00106614 	andseq	r6, r0, r4, lsl r6
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
    1270:	109d1600 	addsne	r1, sp, r0, lsl #12
    1274:	c1010000 	mrsgt	r0, (UNDEF: 1)
    1278:	0010b607 	andseq	fp, r0, r7, lsl #12
    127c:	00011800 	andeq	r1, r1, r0, lsl #16
    1280:	008f8c00 	addeq	r8, pc, r0, lsl #24
    1284:	0000c000 	andeq	ip, r0, r0
    1288:	d39c0100 	orrsle	r0, ip, #0, 2
    128c:	14000002 	strne	r0, [r0], #-2
    1290:	00001066 	andeq	r1, r0, r6, rrx
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
    12c8:	f4170074 			; <UNDEFINED> instruction: 0xf4170074
    12cc:	01000010 	tsteq	r0, r0, lsl r0
    12d0:	10a5068b 	adcne	r0, r5, fp, lsl #13
    12d4:	8d540000 	ldclhi	0, cr0, [r4, #-0]
    12d8:	02380000 	eorseq	r0, r8, #0
    12dc:	9c010000 	stcls	0, cr0, [r1], {-0}
    12e0:	0000036f 	andeq	r0, r0, pc, ror #6
    12e4:	000d3a14 	andeq	r3, sp, r4, lsl sl
    12e8:	118b0100 	orrne	r0, fp, r0, lsl #2
    12ec:	00000118 	andeq	r0, r0, r8, lsl r1
    12f0:	145c9102 	ldrbne	r9, [ip], #-258	; 0xfffffefe
    12f4:	00000feb 	andeq	r0, r0, fp, ror #31
    12f8:	6f1f8b01 	svcvs	0x001f8b01
    12fc:	02000003 	andeq	r0, r0, #3
    1300:	fd0c5891 	stc2	8, cr5, [ip, #-580]	; 0xfffffdbc
    1304:	0100000f 	tsteq	r0, pc
    1308:	01060994 			; <UNDEFINED> instruction: 0x01060994
    130c:	91020000 	mrsls	r0, (UNDEF: 2)
    1310:	11790c74 	cmnne	r9, r4, ror ip
    1314:	95010000 	strls	r0, [r1, #-0]
    1318:	00010609 	andeq	r0, r1, r9, lsl #12
    131c:	70910200 	addsvc	r0, r1, r0, lsl #4
    1320:	00111a0c 	andseq	r1, r1, ip, lsl #20
    1324:	0f960100 	svceq	0x00960100
    1328:	0000010d 	andeq	r0, r0, sp, lsl #2
    132c:	186c9102 	stmdane	ip!, {r1, r8, ip, pc}^
    1330:	00008dfc 	strdeq	r8, [r0], -ip
    1334:	00000070 	andeq	r0, r0, r0, ror r0
    1338:	00000355 	andeq	r0, r0, r5, asr r3
    133c:	0010d60c 	andseq	sp, r0, ip, lsl #12
    1340:	0da60100 	stfeqs	f0, [r6]
    1344:	00000106 	andeq	r0, r0, r6, lsl #2
    1348:	00689102 	rsbeq	r9, r8, r2, lsl #2
    134c:	008ef80e 	addeq	pc, lr, lr, lsl #16
    1350:	00007000 	andeq	r7, r0, r0
    1354:	10d60c00 	sbcsne	r0, r6, r0, lsl #24
    1358:	b9010000 	stmdblt	r1, {}	; <UNPREDICTABLE>
    135c:	0001060d 	andeq	r0, r1, sp, lsl #12
    1360:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1364:	04080000 	streq	r0, [r8], #-0
    1368:	000fdf04 	andeq	sp, pc, r4, lsl #30
    136c:	10dc1600 	sbcsne	r1, ip, r0, lsl #12
    1370:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    1374:	00112007 	andseq	r2, r1, r7
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
    13c8:	0010780c 	andseq	r7, r0, ip, lsl #16
    13cc:	09710100 	ldmdbeq	r1!, {r8}^
    13d0:	00000106 	andeq	r0, r0, r6, lsl #2
    13d4:	15689102 	strbne	r9, [r8, #-258]!	; 0xfffffefe
    13d8:	72010069 	andvc	r0, r1, #105	; 0x69
    13dc:	00010609 	andeq	r0, r1, r9, lsl #12
    13e0:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    13e4:	e5190000 	ldr	r0, [r9, #-0]
    13e8:	0100000f 	tsteq	r0, pc
    13ec:	106b064d 	rsbne	r0, fp, sp, asr #12
    13f0:	04670000 	strbteq	r0, [r7], #-0
    13f4:	89c00000 	stmibhi	r0, {}^	; <UNPREDICTABLE>
    13f8:	00dc0000 	sbcseq	r0, ip, r0
    13fc:	9c010000 	stcls	0, cr0, [r1], {-0}
    1400:	00000467 	andeq	r0, r0, r7, ror #8
    1404:	0100730b 	tsteq	r0, fp, lsl #6
    1408:	0112184d 	tsteq	r2, sp, asr #16
    140c:	91020000 	mrsls	r0, (UNDEF: 2)
    1410:	10951464 	addsne	r1, r5, r4, ror #8
    1414:	4d010000 	stcmi	0, cr0, [r1, #-0]
    1418:	00046720 	andeq	r6, r4, r0, lsr #14
    141c:	63910200 	orrsvs	r0, r1, #0, 4
    1420:	0011720c 	andseq	r7, r1, ip, lsl #4
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
    1460:	0003e902 	andeq	lr, r3, r2, lsl #18
    1464:	0fc51600 	svceq	0x00c51600
    1468:	3c010000 	stccc	0, cr0, [r1], {-0}
    146c:	00112b05 	andseq	r2, r1, r5, lsl #22
    1470:	00010600 	andeq	r0, r1, r0, lsl #12
    1474:	0088fc00 	addeq	pc, r8, r0, lsl #24
    1478:	0000c400 	andeq	ip, r0, r0, lsl #8
    147c:	ba9c0100 	blt	fe701884 <__bss_end+0xfe6f8428>
    1480:	0b000004 	bleq	1498 <_start-0x6b68>
    1484:	006c6176 	rsbeq	r6, ip, r6, ror r1
    1488:	ba163c01 	blt	590494 <__bss_end+0x587038>
    148c:	02000004 	andeq	r0, r0, #4
    1490:	fd0c6c91 	stc2	12, cr6, [ip, #-580]	; 0xfffffdbc
    1494:	0100000f 	tsteq	r0, pc
    1498:	0106093d 	tsteq	r6, sp, lsr r9
    149c:	91020000 	mrsls	r0, (UNDEF: 2)
    14a0:	0feb0c74 	svceq	0x00eb0c74
    14a4:	3e010000 	cdpcc	0, 0, cr0, cr1, cr0, {0}
    14a8:	00036f0b 	andeq	r6, r3, fp, lsl #30
    14ac:	70910200 	addsvc	r0, r1, r0, lsl #4
    14b0:	6f041000 	svcvs	0x00041000
    14b4:	19000003 	stmdbne	r0, {r0, r1}
    14b8:	00001006 	andeq	r1, r0, r6
    14bc:	59052601 	stmdbpl	r5, {r0, r9, sl, sp}
    14c0:	06000011 			; <UNDEFINED> instruction: 0x06000011
    14c4:	44000001 	strmi	r0, [r0], #-1
    14c8:	b8000088 	stmdalt	r0, {r3, r7}
    14cc:	01000000 	mrseq	r0, (UNDEF: 0)
    14d0:	0004fd9c 	muleq	r4, ip, sp
    14d4:	10b01400 	adcsne	r1, r0, r0, lsl #8
    14d8:	26010000 	strcs	r0, [r1], -r0
    14dc:	00011216 	andeq	r1, r1, r6, lsl r2
    14e0:	6c910200 	lfmvs	f0, 4, [r1], {0}
    14e4:	0011640c 	andseq	r6, r1, ip, lsl #8
    14e8:	06280100 	strteq	r0, [r8], -r0, lsl #2
    14ec:	00000106 	andeq	r0, r0, r6, lsl #2
    14f0:	00749102 	rsbseq	r9, r4, r2, lsl #2
    14f4:	00107d1a 	andseq	r7, r0, sl, lsl sp
    14f8:	060a0100 	streq	r0, [sl], -r0, lsl #2
    14fc:	00000ff1 	strdeq	r0, [r0], -r1
    1500:	000086d0 	ldrdeq	r8, [r0], -r0
    1504:	00000174 	andeq	r0, r0, r4, ror r1
    1508:	b0149c01 	andslt	r9, r4, r1, lsl #24
    150c:	01000010 	tsteq	r0, r0, lsl r0
    1510:	0066180a 	rsbeq	r1, r6, sl, lsl #16
    1514:	91020000 	mrsls	r0, (UNDEF: 2)
    1518:	11641464 	cmnne	r4, r4, ror #8
    151c:	0a010000 	beq	41524 <__bss_end+0x380c8>
    1520:	00011825 	andeq	r1, r1, r5, lsr #16
    1524:	60910200 	addsvs	r0, r1, r0, lsl #4
    1528:	00110d14 	andseq	r0, r1, r4, lsl sp
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
      30:	732f534f 			; <UNDEFINED> instruction: 0x732f534f
      34:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
      38:	752f7365 	strvc	r7, [pc, #-869]!	; fffffcdb <__bss_end+0xffff687f>
      3c:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
      40:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
      44:	7472632f 	ldrbtvc	r6, [r2], #-815	; 0xfffffcd1
      48:	00732e30 	rsbseq	r2, r3, r0, lsr lr
      4c:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
      50:	752f632f 	strvc	r6, [pc, #-815]!	; fffffd29 <__bss_end+0xffff68cd>
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
      84:	752f7365 	strvc	r7, [pc, #-869]!	; fffffd27 <__bss_end+0xffff68cb>
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
     120:	6a363731 	bvs	d8ddec <__bss_end+0xd84990>
     124:	732d667a 			; <UNDEFINED> instruction: 0x732d667a
     128:	616d2d20 	cmnvs	sp, r0, lsr #26
     12c:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
     130:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
     134:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
     138:	7a36766d 	bvc	d9daf4 <__bss_end+0xd94698>
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
     310:	752f632f 	strvc	r6, [pc, #-815]!	; ffffffe9 <__bss_end+0xffff6b8d>
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
     344:	752f7365 	strvc	r7, [pc, #-869]!	; ffffffe7 <__bss_end+0xffff6b8b>
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
     398:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     39c:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     3a0:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
     3a4:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     3a8:	61006874 	tstvs	r0, r4, ror r8
     3ac:	00636772 	rsbeq	r6, r3, r2, ror r7
     3b0:	6b636f4c 	blvs	18dc0e8 <__bss_end+0x18d2c8c>
     3b4:	6c6e555f 	cfstr64vs	mvdx5, [lr], #-380	; 0xfffffe84
     3b8:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     3bc:	6f4e0064 	svcvs	0x004e0064
     3c0:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     3c4:	006c6c41 	rsbeq	r6, ip, r1, asr #24
     3c8:	61766e49 	cmnvs	r6, r9, asr #28
     3cc:	5f64696c 	svcpl	0x0064696c
     3d0:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     3d4:	6c00656c 	cfstr32vs	mvfx6, [r0], {108}	; 0x6c
     3d8:	20676e6f 	rsbcs	r6, r7, pc, ror #28
     3dc:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     3e0:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
     3e4:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
     3e8:	6f6f6200 	svcvs	0x006f6200
     3ec:	6544006c 	strbvs	r0, [r4, #-108]	; 0xffffff94
     3f0:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     3f4:	555f656e 	ldrbpl	r6, [pc, #-1390]	; fffffe8e <__bss_end+0xffff6a32>
     3f8:	6168636e 	cmnvs	r8, lr, ror #6
     3fc:	6465676e 	strbtvs	r6, [r5], #-1902	; 0xfffff892
     400:	466f4e00 	strbtmi	r4, [pc], -r0, lsl #28
     404:	73656c69 	cmnvc	r5, #26880	; 0x6900
     408:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     40c:	6972446d 	ldmdbvs	r2!, {r0, r2, r3, r5, r6, sl, lr}^
     410:	00726576 	rsbseq	r6, r2, r6, ror r5
     414:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     418:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
     41c:	61686320 	cmnvs	r8, r0, lsr #6
     420:	616d0072 	smcvs	53250	; 0xd002
     424:	75006e69 	strvc	r6, [r0, #-3689]	; 0xfffff197
     428:	33746e69 	cmncc	r4, #1680	; 0x690
     42c:	00745f32 	rsbseq	r5, r4, r2, lsr pc
     430:	6b636f4c 	blvs	18dc168 <__bss_end+0x18d2d0c>
     434:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     438:	0064656b 	rsbeq	r6, r4, fp, ror #10
     43c:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
     440:	752f632f 	strvc	r6, [pc, #-815]!	; 119 <_start-0x7ee7>
     444:	2f726573 	svccs	0x00726573
     448:	76697270 			; <UNDEFINED> instruction: 0x76697270
     44c:	57657461 	strbpl	r7, [r5, -r1, ror #8]!
     450:	736b726f 	cmnvc	fp, #-268435450	; 0xf0000006
     454:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     458:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
     45c:	2f6c6f6f 	svccs	0x006c6f6f
     460:	532f534f 			; <UNDEFINED> instruction: 0x532f534f
     464:	494b2f50 	stmdbmi	fp, {r4, r6, r8, r9, sl, fp, sp}^
     468:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
     46c:	732f534f 			; <UNDEFINED> instruction: 0x732f534f
     470:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     474:	752f7365 	strvc	r7, [pc, #-869]!	; 117 <_start-0x7ee9>
     478:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     47c:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     480:	696e692f 	stmdbvs	lr!, {r0, r1, r2, r3, r5, r8, fp, sp, lr}^
     484:	61745f74 	cmnvs	r4, r4, ror pc
     488:	6d2f6b73 	fstmdbxvs	pc!, {d6-d62}	;@ Deprecated
     48c:	2e6e6961 	vnmulcs.f16	s13, s28, s3	; <UNPREDICTABLE>
     490:	00707063 	rsbseq	r7, r0, r3, rrx
     494:	65646e49 	strbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     498:	696e6966 	stmdbvs	lr!, {r1, r2, r5, r6, r8, fp, sp, lr}^
     49c:	73006574 	movwvc	r6, #1396	; 0x574
     4a0:	74726f68 	ldrbtvc	r6, [r2], #-3944	; 0xfffff098
     4a4:	736e7520 	cmnvc	lr, #32, 10	; 0x8000000
     4a8:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
     4ac:	6e692064 	cdpvs	0, 6, cr2, cr9, cr4, {3}
     4b0:	614d0074 	hvcvs	53252	; 0xd004
     4b4:	72505f78 	subsvc	r5, r0, #120, 30	; 0x1e0
     4b8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     4bc:	704f5f73 	subvc	r5, pc, r3, ror pc	; <UNPREDICTABLE>
     4c0:	64656e65 	strbtvs	r6, [r5], #-3685	; 0xfffff19b
     4c4:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     4c8:	4d007365 	stcmi	3, cr7, [r0, #-404]	; 0xfffffe6c
     4cc:	61507861 	cmpvs	r0, r1, ror #16
     4d0:	654c6874 	strbvs	r6, [ip, #-2164]	; 0xfffff78c
     4d4:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     4d8:	6f687300 	svcvs	0x00687300
     4dc:	69207472 	stmdbvs	r0!, {r1, r4, r5, r6, sl, ip, sp, lr}
     4e0:	4d00746e 	cfstrsmi	mvf7, [r0, #-440]	; 0xfffffe48
     4e4:	53467861 	movtpl	r7, #26721	; 0x6861
     4e8:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     4ec:	614e7265 	cmpvs	lr, r5, ror #4
     4f0:	654c656d 	strbvs	r6, [ip, #-1389]	; 0xfffffa93
     4f4:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     4f8:	67726100 	ldrbvs	r6, [r2, -r0, lsl #2]!
     4fc:	69540076 	ldmdbvs	r4, {r1, r2, r4, r5, r6}^
     500:	435f6b63 	cmpmi	pc, #101376	; 0x18c00
     504:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     508:	65704f00 	ldrbvs	r4, [r0, #-3840]!	; 0xfffff100
     50c:	5a5f006e 	bpl	17c06cc <__bss_end+0x17b7270>
     510:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     514:	636f7250 	cmnvs	pc, #80, 4
     518:	5f737365 	svcpl	0x00737365
     51c:	616e614d 	cmnvs	lr, sp, asr #2
     520:	32726567 	rsbscc	r6, r2, #432013312	; 0x19c00000
     524:	6f6c4231 	svcvs	0x006c4231
     528:	435f6b63 	cmpmi	pc, #101376	; 0x18c00
     52c:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     530:	505f746e 	subspl	r7, pc, lr, ror #8
     534:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     538:	76457373 			; <UNDEFINED> instruction: 0x76457373
     53c:	6f6c6300 	svcvs	0x006c6300
     540:	70006573 	andvc	r6, r0, r3, ror r5
     544:	00766572 	rsbseq	r6, r6, r2, ror r5
     548:	5f746553 	svcpl	0x00746553
     54c:	616c6552 	cmnvs	ip, r2, asr r5
     550:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
     554:	6d6e5500 	cfstr64vs	mvdx5, [lr, #-0]
     558:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
     55c:	5f656c69 	svcpl	0x00656c69
     560:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     564:	00746e65 	rsbseq	r6, r4, r5, ror #28
     568:	76746572 			; <UNDEFINED> instruction: 0x76746572
     56c:	6e006c61 	cdpvs	12, 0, cr6, cr0, cr1, {3}
     570:	00727563 	rsbseq	r7, r2, r3, ror #10
     574:	6f72506d 	svcvs	0x0072506d
     578:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     57c:	73694c5f 	cmnvc	r9, #24320	; 0x5f00
     580:	65485f74 	strbvs	r5, [r8, #-3956]	; 0xfffff08c
     584:	70006461 	andvc	r6, r0, r1, ror #8
     588:	00657069 	rsbeq	r7, r5, r9, rrx
     58c:	4b4e5a5f 	blmi	1396f10 <__bss_end+0x138dab4>
     590:	50433631 	subpl	r3, r3, r1, lsr r6
     594:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     598:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 3d4 <_start-0x7c2c>
     59c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     5a0:	39317265 	ldmdbcc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     5a4:	5f746547 	svcpl	0x00746547
     5a8:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     5ac:	5f746e65 	svcpl	0x00746e65
     5b0:	636f7250 	cmnvs	pc, #80, 4
     5b4:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     5b8:	64720076 	ldrbtvs	r0, [r2], #-118	; 0xffffff8a
     5bc:	006d756e 	rsbeq	r7, sp, lr, ror #10
     5c0:	7478656e 	ldrbtvc	r6, [r8], #-1390	; 0xfffffa92
     5c4:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     5c8:	6f72505f 	svcvs	0x0072505f
     5cc:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     5d0:	5f79425f 	svcpl	0x0079425f
     5d4:	00444950 	subeq	r4, r4, r0, asr r9
     5d8:	31315a5f 	teqcc	r1, pc, asr sl
     5dc:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
     5e0:	69795f64 	ldmdbvs	r9!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     5e4:	76646c65 	strbtvc	r6, [r4], -r5, ror #24
     5e8:	57534e00 	ldrbpl	r4, [r3, -r0, lsl #28]
     5ec:	72505f49 	subsvc	r5, r0, #292	; 0x124
     5f0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     5f4:	65535f73 	ldrbvs	r5, [r3, #-3955]	; 0xfffff08d
     5f8:	63697672 	cmnvs	r9, #119537664	; 0x7200000
     5fc:	65520065 	ldrbvs	r0, [r2, #-101]	; 0xffffff9b
     600:	41006461 	tstmi	r0, r1, ror #8
     604:	76697463 	strbtvc	r7, [r9], -r3, ror #8
     608:	72505f65 	subsvc	r5, r0, #404	; 0x194
     60c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     610:	6f435f73 	svcvs	0x00435f73
     614:	00746e75 	rsbseq	r6, r4, r5, ror lr
     618:	61657243 	cmnvs	r5, r3, asr #4
     61c:	505f6574 	subspl	r6, pc, r4, ror r5	; <UNPREDICTABLE>
     620:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     624:	5f007373 	svcpl	0x00007373
     628:	7337315a 	teqvc	r7, #-2147483626	; 0x80000016
     62c:	745f7465 	ldrbvc	r7, [pc], #-1125	; 634 <_start-0x79cc>
     630:	5f6b7361 	svcpl	0x006b7361
     634:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
     638:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     63c:	6177006a 	cmnvs	r7, sl, rrx
     640:	73007469 	movwvc	r7, #1129	; 0x469
     644:	65746174 	ldrbvs	r6, [r4, #-372]!	; 0xfffffe8c
     648:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
     64c:	69746f6e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     650:	6a6a7966 	bvs	1a9ebf0 <__bss_end+0x1a95794>
     654:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     658:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     65c:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     660:	495f7265 	ldmdbmi	pc, {r0, r2, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
     664:	006f666e 	rsbeq	r6, pc, lr, ror #12
     668:	6f725043 	svcvs	0x00725043
     66c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     670:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     674:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     678:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     67c:	50433631 	subpl	r3, r3, r1, lsr r6
     680:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     684:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 4c0 <_start-0x7b40>
     688:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     68c:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     690:	5f746547 	svcpl	0x00746547
     694:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     698:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     69c:	6e495f72 	mcrvs	15, 2, r5, cr9, cr2, {3}
     6a0:	32456f66 	subcc	r6, r5, #408	; 0x198
     6a4:	65474e30 	strbvs	r4, [r7, #-3632]	; 0xfffff1d0
     6a8:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     6ac:	5f646568 	svcpl	0x00646568
     6b0:	6f666e49 	svcvs	0x00666e49
     6b4:	7079545f 	rsbsvc	r5, r9, pc, asr r4
     6b8:	00765065 	rsbseq	r5, r6, r5, rrx
     6bc:	314e5a5f 	cmpcc	lr, pc, asr sl
     6c0:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     6c4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     6c8:	614d5f73 	hvcvs	54771	; 0xd5f3
     6cc:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     6d0:	48313272 	ldmdami	r1!, {r1, r4, r5, r6, r9, ip, sp}
     6d4:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     6d8:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     6dc:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     6e0:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     6e4:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     6e8:	4e333245 	cdpmi	2, 3, cr3, cr3, cr5, {2}
     6ec:	5f495753 	svcpl	0x00495753
     6f0:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     6f4:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     6f8:	535f6d65 	cmppl	pc, #6464	; 0x1940
     6fc:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     700:	6a6a6563 	bvs	1a99c94 <__bss_end+0x1a90838>
     704:	3131526a 	teqcc	r1, sl, ror #4
     708:	49575354 	ldmdbmi	r7, {r2, r4, r6, r8, r9, ip, lr}^
     70c:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
     710:	00746c75 	rsbseq	r6, r4, r5, ror ip
     714:	70616568 	rsbvc	r6, r1, r8, ror #10
     718:	7968705f 	stmdbvc	r8!, {r0, r1, r2, r3, r4, r6, ip, sp, lr}^
     71c:	61636973 	smcvs	13971	; 0x3693
     720:	696c5f6c 	stmdbvs	ip!, {r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     724:	0074696d 	rsbseq	r6, r4, sp, ror #18
     728:	6e65706f 	cdpvs	0, 6, cr7, cr5, cr15, {3}
     72c:	665f6465 	ldrbvs	r6, [pc], -r5, ror #8
     730:	73656c69 	cmnvc	r5, #26880	; 0x6900
     734:	69614600 	stmdbvs	r1!, {r9, sl, lr}^
     738:	4354006c 	cmpmi	r4, #108	; 0x6c
     73c:	435f5550 	cmpmi	pc, #80, 10	; 0x14000000
     740:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
     744:	44007478 	strmi	r7, [r0], #-1144	; 0xfffffb88
     748:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     74c:	00656e69 	rsbeq	r6, r5, r9, ror #28
     750:	74697865 	strbtvc	r7, [r9], #-2149	; 0xfffff79b
     754:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
     758:	62747400 	rsbsvs	r7, r4, #0, 8
     75c:	5f003072 	svcpl	0x00003072
     760:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     764:	6f725043 	svcvs	0x00725043
     768:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     76c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     770:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     774:	6f4e3431 	svcvs	0x004e3431
     778:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     77c:	6f72505f 	svcvs	0x0072505f
     780:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     784:	47006a45 	strmi	r6, [r0, -r5, asr #20]
     788:	505f7465 	subspl	r7, pc, r5, ror #8
     78c:	6e004449 	cdpvs	4, 0, cr4, cr0, cr9, {2}
     790:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     794:	5f646569 	svcpl	0x00646569
     798:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
     79c:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     7a0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     7a4:	50433631 	subpl	r3, r3, r1, lsr r6
     7a8:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     7ac:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 5e8 <_start-0x7a18>
     7b0:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     7b4:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     7b8:	616d6e55 	cmnvs	sp, r5, asr lr
     7bc:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     7c0:	435f656c 	cmpmi	pc, #108, 10	; 0x1b000000
     7c4:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     7c8:	6a45746e 	bvs	115d988 <__bss_end+0x115452c>
     7cc:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     7d0:	50433631 	subpl	r3, r3, r1, lsr r6
     7d4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     7d8:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 614 <_start-0x79ec>
     7dc:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     7e0:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
     7e4:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     7e8:	505f7966 	subspl	r7, pc, r6, ror #18
     7ec:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     7f0:	50457373 	subpl	r7, r5, r3, ror r3
     7f4:	54543231 	ldrbpl	r3, [r4], #-561	; 0xfffffdcf
     7f8:	5f6b7361 	svcpl	0x006b7361
     7fc:	75727453 	ldrbvc	r7, [r2, #-1107]!	; 0xfffffbad
     800:	73007463 	movwvc	r7, #1123	; 0x463
     804:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     808:	6569795f 	strbvs	r7, [r9, #-2399]!	; 0xfffff6a1
     80c:	7400646c 	strvc	r6, [r0], #-1132	; 0xfffffb94
     810:	5f6b6369 	svcpl	0x006b6369
     814:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     818:	65725f74 	ldrbvs	r5, [r2, #-3956]!	; 0xfffff08c
     81c:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
     820:	5f006465 	svcpl	0x00006465
     824:	6734325a 			; <UNDEFINED> instruction: 0x6734325a
     828:	615f7465 	cmpvs	pc, r5, ror #8
     82c:	76697463 	strbtvc	r7, [r9], -r3, ror #8
     830:	72705f65 	rsbsvc	r5, r0, #404	; 0x194
     834:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     838:	6f635f73 	svcvs	0x00635f73
     83c:	76746e75 			; <UNDEFINED> instruction: 0x76746e75
     840:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     844:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     848:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     84c:	6f72505f 	svcvs	0x0072505f
     850:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     854:	70695000 	rsbvc	r5, r9, r0
     858:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     85c:	505f656c 	subspl	r6, pc, ip, ror #10
     860:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     864:	614d0078 	hvcvs	53256	; 0xd008
     868:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     86c:	545f656c 	ldrbpl	r6, [pc], #-1388	; 874 <_start-0x778c>
     870:	75435f6f 	strbvc	r5, [r3, #-3951]	; 0xfffff091
     874:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     878:	5a5f0074 	bpl	17c0a50 <__bss_end+0x17b75f4>
     87c:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     880:	636f7250 	cmnvs	pc, #80, 4
     884:	5f737365 	svcpl	0x00737365
     888:	616e614d 	cmnvs	lr, sp, asr #2
     88c:	31726567 	cmncc	r2, r7, ror #10
     890:	6e614837 	mcrvs	8, 3, r4, cr1, cr7, {1}
     894:	5f656c64 	svcpl	0x00656c64
     898:	6f6d654d 	svcvs	0x006d654d
     89c:	535f7972 	cmppl	pc, #1867776	; 0x1c8000
     8a0:	31454957 	cmpcc	r5, r7, asr r9
     8a4:	57534e39 	smmlarpl	r3, r9, lr, r4
     8a8:	654d5f49 	strbvs	r5, [sp, #-3913]	; 0xfffff0b7
     8ac:	79726f6d 	ldmdbvc	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     8b0:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     8b4:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     8b8:	526a6a6a 	rsbpl	r6, sl, #434176	; 0x6a000
     8bc:	53543131 	cmppl	r4, #1073741836	; 0x4000000c
     8c0:	525f4957 	subspl	r4, pc, #1425408	; 0x15c000
     8c4:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
     8c8:	65530074 	ldrbvs	r0, [r3, #-116]	; 0xffffff8c
     8cc:	61505f74 	cmpvs	r0, r4, ror pc
     8d0:	736d6172 	cmnvc	sp, #-2147483620	; 0x8000001c
     8d4:	315a5f00 	cmpcc	sl, r0, lsl #30
     8d8:	74656734 	strbtvc	r6, [r5], #-1844	; 0xfffff8cc
     8dc:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
     8e0:	6f635f6b 	svcvs	0x00635f6b
     8e4:	76746e75 			; <UNDEFINED> instruction: 0x76746e75
     8e8:	6e614800 	cdpvs	8, 6, cr4, cr1, cr0, {0}
     8ec:	5f656c64 	svcpl	0x00656c64
     8f0:	636f7250 	cmnvs	pc, #80, 4
     8f4:	5f737365 	svcpl	0x00737365
     8f8:	00495753 	subeq	r5, r9, r3, asr r7
     8fc:	65656c73 	strbvs	r6, [r5, #-3187]!	; 0xfffff38d
     900:	63530070 	cmpvs	r3, #112	; 0x70
     904:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     908:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 3a4 <_start-0x7c5c>
     90c:	57004644 	strpl	r4, [r0, -r4, asr #12]
     910:	00746961 	rsbseq	r6, r4, r1, ror #18
     914:	61736944 	cmnvs	r3, r4, asr #18
     918:	5f656c62 	svcpl	0x00656c62
     91c:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     920:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     924:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     928:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     92c:	74395a5f 	ldrtvc	r5, [r9], #-2655	; 0xfffff5a1
     930:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     934:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
     938:	6e490069 	cdpvs	0, 4, cr0, cr9, cr9, {3}
     93c:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     940:	61747075 	cmnvs	r4, r5, ror r0
     944:	5f656c62 	svcpl	0x00656c62
     948:	65656c53 	strbvs	r6, [r5, #-3155]!	; 0xfffff3ad
     94c:	706f0070 	rsbvc	r0, pc, r0, ror r0	; <UNPREDICTABLE>
     950:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
     954:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     958:	63355a5f 	teqvs	r5, #389120	; 0x5f000
     95c:	65736f6c 	ldrbvs	r6, [r3, #-3948]!	; 0xfffff094
     960:	4c6d006a 	stclmi	0, cr0, [sp], #-424	; 0xfffffe58
     964:	5f747361 	svcpl	0x00747361
     968:	00444950 	subeq	r4, r4, r0, asr r9
     96c:	636f6c42 	cmnvs	pc, #16896	; 0x4200
     970:	0064656b 	rsbeq	r6, r4, fp, ror #10
     974:	7465474e 	strbtvc	r4, [r5], #-1870	; 0xfffff8b2
     978:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     97c:	495f6465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     980:	5f6f666e 	svcpl	0x006f666e
     984:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     988:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
     98c:	70746567 	rsbsvc	r6, r4, r7, ror #10
     990:	00766469 	rsbseq	r6, r6, r9, ror #8
     994:	6d616e66 	stclvs	14, cr6, [r1, #-408]!	; 0xfffffe68
     998:	75520065 	ldrbvc	r0, [r2, #-101]	; 0xffffff9b
     99c:	62616e6e 	rsbvs	r6, r1, #1760	; 0x6e0
     9a0:	4e00656c 	cfsh32mi	mvfx6, mvfx0, #60
     9a4:	6b736154 	blvs	1cd8efc <__bss_end+0x1ccfaa0>
     9a8:	6174535f 	cmnvs	r4, pc, asr r3
     9ac:	73006574 	movwvc	r6, #1396	; 0x574
     9b0:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     9b4:	756f635f 	strbvc	r6, [pc, #-863]!	; 65d <_start-0x79a3>
     9b8:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     9bc:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
     9c0:	735f6465 	cmpvc	pc, #1694498816	; 0x65000000
     9c4:	69746174 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, sp, lr}^
     9c8:	72705f63 	rsbsvc	r5, r0, #396	; 0x18c
     9cc:	69726f69 	ldmdbvs	r2!, {r0, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     9d0:	77007974 	smlsdxvc	r0, r4, r9, r7
     9d4:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
     9d8:	69786500 	ldmdbvs	r8!, {r8, sl, sp, lr}^
     9dc:	6f635f74 	svcvs	0x00635f74
     9e0:	74006564 	strvc	r6, [r0], #-1380	; 0xfffffa9c
     9e4:	736b6369 	cmnvc	fp, #-1543503871	; 0xa4000001
     9e8:	63536d00 	cmpvs	r3, #0, 26
     9ec:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     9f0:	465f656c 	ldrbmi	r6, [pc], -ip, ror #10
     9f4:	6f00636e 	svcvs	0x0000636e
     9f8:	006e6570 	rsbeq	r6, lr, r0, ror r5
     9fc:	70345a5f 	eorsvc	r5, r4, pc, asr sl
     a00:	50657069 	rsbpl	r7, r5, r9, rrx
     a04:	006a634b 	rsbeq	r6, sl, fp, asr #6
     a08:	6165444e 	cmnvs	r5, lr, asr #8
     a0c:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     a10:	75535f65 	ldrbvc	r5, [r3, #-3941]	; 0xfffff09b
     a14:	72657362 	rsbvc	r7, r5, #-2013265919	; 0x88000001
     a18:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     a1c:	6e6d2f00 	cdpvs	15, 6, cr2, cr13, cr0, {0}
     a20:	2f632f74 	svccs	0x00632f74
     a24:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     a28:	6972702f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, ip, sp, lr}^
     a2c:	65746176 	ldrbvs	r6, [r4, #-374]!	; 0xfffffe8a
     a30:	6b726f57 	blvs	1c9c794 <__bss_end+0x1c93338>
     a34:	63617073 	cmnvs	r1, #115	; 0x73
     a38:	63532f65 	cmpvs	r3, #404	; 0x194
     a3c:	6c6f6f68 	stclvs	15, cr6, [pc], #-416	; 8a4 <_start-0x775c>
     a40:	2f534f2f 	svccs	0x00534f2f
     a44:	4b2f5053 	blmi	bd4b98 <__bss_end+0xbcb73c>
     a48:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
     a4c:	2f534f54 	svccs	0x00534f54
     a50:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     a54:	2f736563 	svccs	0x00736563
     a58:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
     a5c:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
     a60:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
     a64:	69666474 	stmdbvs	r6!, {r2, r4, r5, r6, sl, sp, lr}^
     a68:	632e656c 			; <UNDEFINED> instruction: 0x632e656c
     a6c:	67007070 	smlsdxvs	r0, r0, r0, r7
     a70:	745f7465 	ldrbvc	r7, [pc], #-1125	; a78 <_start-0x7588>
     a74:	5f6b6369 	svcpl	0x006b6369
     a78:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     a7c:	6f4e0074 	svcvs	0x004e0074
     a80:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     a84:	72617000 	rsbvc	r7, r1, #0
     a88:	5f006d61 	svcpl	0x00006d61
     a8c:	7277355a 	rsbsvc	r3, r7, #377487360	; 0x16800000
     a90:	6a657469 	bvs	195dc3c <__bss_end+0x19547e0>
     a94:	6a634b50 	bvs	18d37dc <__bss_end+0x18ca380>
     a98:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
     a9c:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     aa0:	69745f6b 	ldmdbvs	r4!, {r0, r1, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     aa4:	5f736b63 	svcpl	0x00736b63
     aa8:	645f6f74 	ldrbvs	r6, [pc], #-3956	; ab0 <_start-0x7550>
     aac:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     ab0:	00656e69 	rsbeq	r6, r5, r9, ror #28
     ab4:	5f667562 	svcpl	0x00667562
     ab8:	657a6973 	ldrbvs	r6, [sl, #-2419]!	; 0xfffff68d
     abc:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
     ac0:	2b2b4320 	blcs	ad1748 <__bss_end+0xac82ec>
     ac4:	31203431 			; <UNDEFINED> instruction: 0x31203431
     ac8:	2e332e30 	mrccs	14, 1, r2, cr3, cr0, {1}
     acc:	6d2d2030 	stcvs	0, cr2, [sp, #-192]!	; 0xffffff40
     ad0:	616f6c66 	cmnvs	pc, r6, ror #24
     ad4:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
     ad8:	61683d69 	cmnvs	r8, r9, ror #26
     adc:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
     ae0:	7570666d 	ldrbvc	r6, [r0, #-1645]!	; 0xfffff993
     ae4:	7066763d 	rsbvc	r7, r6, sp, lsr r6
     ae8:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     aec:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
     af0:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
     af4:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
     af8:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
     afc:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
     b00:	20706676 	rsbscs	r6, r0, r6, ror r6
     b04:	75746d2d 	ldrbvc	r6, [r4, #-3373]!	; 0xfffff2d3
     b08:	613d656e 	teqvs	sp, lr, ror #10
     b0c:	31316d72 	teqcc	r1, r2, ror sp
     b10:	7a6a3637 	bvc	1a8e3f4 <__bss_end+0x1a84f98>
     b14:	20732d66 	rsbscs	r2, r3, r6, ror #26
     b18:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
     b1c:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
     b20:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
     b24:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
     b28:	6b7a3676 	blvs	1e8e508 <__bss_end+0x1e850ac>
     b2c:	2070662b 	rsbscs	r6, r0, fp, lsr #12
     b30:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
     b34:	672d2067 	strvs	r2, [sp, -r7, rrx]!
     b38:	304f2d20 	subcc	r2, pc, r0, lsr #26
     b3c:	304f2d20 	subcc	r2, pc, r0, lsr #26
     b40:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
     b44:	78652d6f 	stmdavc	r5!, {r0, r1, r2, r3, r5, r6, r8, sl, fp, sp}^
     b48:	74706563 	ldrbtvc	r6, [r0], #-1379	; 0xfffffa9d
     b4c:	736e6f69 	cmnvc	lr, #420	; 0x1a4
     b50:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
     b54:	74722d6f 	ldrbtvc	r2, [r2], #-3439	; 0xfffff291
     b58:	52006974 	andpl	r6, r0, #116, 18	; 0x1d0000
     b5c:	5f646165 	svcpl	0x00646165
     b60:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
     b64:	6f5a0065 	svcvs	0x005a0065
     b68:	6569626d 	strbvs	r6, [r9, #-621]!	; 0xfffffd93
     b6c:	72627300 	rsbvc	r7, r2, #0, 6
     b70:	6547006b 	strbvs	r0, [r7, #-107]	; 0xffffff95
     b74:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     b78:	5f646568 	svcpl	0x00646568
     b7c:	6f666e49 	svcvs	0x00666e49
     b80:	74657300 	strbtvc	r7, [r5], #-768	; 0xfffffd00
     b84:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     b88:	65645f6b 	strbvs	r5, [r4, #-3947]!	; 0xfffff095
     b8c:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     b90:	5f00656e 	svcpl	0x0000656e
     b94:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     b98:	6f725043 	svcvs	0x00725043
     b9c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     ba0:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     ba4:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     ba8:	68635338 	stmdavs	r3!, {r3, r4, r5, r8, r9, ip, lr}^
     bac:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     bb0:	00764565 	rsbseq	r4, r6, r5, ror #10
     bb4:	314e5a5f 	cmpcc	lr, pc, asr sl
     bb8:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     bbc:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     bc0:	614d5f73 	hvcvs	54771	; 0xd5f3
     bc4:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     bc8:	4d393172 	ldfmis	f3, [r9, #-456]!	; 0xfffffe38
     bcc:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
     bd0:	5f656c69 	svcpl	0x00656c69
     bd4:	435f6f54 	cmpmi	pc, #84, 30	; 0x150
     bd8:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     bdc:	5045746e 	subpl	r7, r5, lr, ror #8
     be0:	69464935 	stmdbvs	r6, {r0, r2, r4, r5, r8, fp, lr}^
     be4:	4700656c 	strmi	r6, [r0, -ip, ror #10]
     be8:	505f7465 	subspl	r7, pc, r5, ror #8
     bec:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
     bf0:	61480073 	hvcvs	32771	; 0x8003
     bf4:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     bf8:	6d654d5f 	stclvs	13, cr4, [r5, #-380]!	; 0xfffffe84
     bfc:	5f79726f 	svcpl	0x0079726f
     c00:	00495753 	subeq	r5, r9, r3, asr r7
     c04:	314e5a5f 	cmpcc	lr, pc, asr sl
     c08:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     c0c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     c10:	614d5f73 	hvcvs	54771	; 0xd5f3
     c14:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     c18:	53323172 	teqpl	r2, #-2147483620	; 0x8000001c
     c1c:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     c20:	5f656c75 	svcpl	0x00656c75
     c24:	45464445 	strbmi	r4, [r6, #-1093]	; 0xfffffbbb
     c28:	5a5f0076 	bpl	17c0e08 <__bss_end+0x17b79ac>
     c2c:	656c7335 	strbvs	r7, [ip, #-821]!	; 0xfffffccb
     c30:	6a6a7065 	bvs	1a9cdcc <__bss_end+0x1a93970>
     c34:	6c696600 	stclvs	6, cr6, [r9], #-0
     c38:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     c3c:	65525f74 	ldrbvs	r5, [r2, #-3956]	; 0xfffff08c
     c40:	6e69616d 	powvsez	f6, f1, #5.0
     c44:	00676e69 	rsbeq	r6, r7, r9, ror #28
     c48:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
     c4c:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 6e8 <_start-0x7918>
     c50:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     c54:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     c58:	69746365 	ldmdbvs	r4!, {r0, r2, r5, r6, r8, r9, sp, lr}^
     c5c:	4e006e6f 	cdpmi	14, 0, cr6, cr0, cr15, {3}
     c60:	5f495753 	svcpl	0x00495753
     c64:	6f6d654d 	svcvs	0x006d654d
     c68:	535f7972 	cmppl	pc, #1867776	; 0x1c8000
     c6c:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     c70:	5f006563 	svcpl	0x00006563
     c74:	6736325a 			; <UNDEFINED> instruction: 0x6736325a
     c78:	745f7465 	ldrbvc	r7, [pc], #-1125	; c80 <_start-0x7380>
     c7c:	5f6b7361 	svcpl	0x006b7361
     c80:	6b636974 	blvs	18db258 <__bss_end+0x18d1dfc>
     c84:	6f745f73 	svcvs	0x00745f73
     c88:	6165645f 	cmnvs	r5, pc, asr r4
     c8c:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     c90:	4e007665 	cfmadd32mi	mvax3, mvfx7, mvfx0, mvfx5
     c94:	5f495753 	svcpl	0x00495753
     c98:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
     c9c:	435f746c 	cmpmi	pc, #108, 8	; 0x6c000000
     ca0:	0065646f 	rsbeq	r6, r5, pc, ror #8
     ca4:	6e6e7552 	mcrvs	5, 3, r7, cr14, cr2, {2}
     ca8:	00676e69 	rsbeq	r6, r7, r9, ror #28
     cac:	70616568 	rsbvc	r6, r1, r8, ror #10
     cb0:	676f6c5f 			; <UNDEFINED> instruction: 0x676f6c5f
     cb4:	6c616369 	stclvs	3, cr6, [r1], #-420	; 0xfffffe5c
     cb8:	6d696c5f 	stclvs	12, cr6, [r9, #-380]!	; 0xfffffe84
     cbc:	77007469 	strvc	r7, [r0, -r9, ror #8]
     cc0:	6d756e72 	ldclvs	14, cr6, [r5, #-456]!	; 0xfffffe38
     cc4:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
     cc8:	74696177 	strbtvc	r6, [r9], #-375	; 0xfffffe89
     ccc:	006a6a6a 	rsbeq	r6, sl, sl, ror #20
     cd0:	69355a5f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}
     cd4:	6c74636f 	ldclvs	3, cr6, [r4], #-444	; 0xfffffe44
     cd8:	4e36316a 	rsfmisz	f3, f6, #2.0
     cdc:	74434f49 	strbvc	r4, [r3], #-3913	; 0xfffff0b7
     ce0:	704f5f6c 	subvc	r5, pc, ip, ror #30
     ce4:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
     ce8:	506e6f69 	rsbpl	r6, lr, r9, ror #30
     cec:	6f690076 	svcvs	0x00690076
     cf0:	006c7463 	rsbeq	r7, ip, r3, ror #8
     cf4:	63746572 	cmnvs	r4, #478150656	; 0x1c800000
     cf8:	6d00746e 	cfstrsvs	mvf7, [r0, #-440]	; 0xfffffe48
     cfc:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     d00:	5f746e65 	svcpl	0x00746e65
     d04:	6b736154 	blvs	1cd925c <__bss_end+0x1ccfe00>
     d08:	646f4e5f 	strbtvs	r4, [pc], #-3679	; d10 <_start-0x72f0>
     d0c:	6f6e0065 	svcvs	0x006e0065
     d10:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     d14:	72657400 	rsbvc	r7, r5, #0, 8
     d18:	616e696d 	cmnvs	lr, sp, ror #18
     d1c:	6d006574 	cfstr32vs	mvfx6, [r0, #-464]	; 0xfffffe30
     d20:	0065646f 	rsbeq	r6, r5, pc, ror #8
     d24:	5f757063 	svcpl	0x00757063
     d28:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
     d2c:	00747865 	rsbseq	r7, r4, r5, ror #16
     d30:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     d34:	6c6e4f5f 	stclvs	15, cr4, [lr], #-380	; 0xfffffe84
     d38:	75620079 	strbvc	r0, [r2, #-121]!	; 0xffffff87
     d3c:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
     d40:	656c7300 	strbvs	r7, [ip, #-768]!	; 0xfffffd00
     d44:	745f7065 	ldrbvc	r7, [pc], #-101	; d4c <_start-0x72b4>
     d48:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     d4c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     d50:	4336314b 	teqmi	r6, #-1073741806	; 0xc0000012
     d54:	636f7250 	cmnvs	pc, #80, 4
     d58:	5f737365 	svcpl	0x00737365
     d5c:	616e614d 	cmnvs	lr, sp, asr #2
     d60:	31726567 	cmncc	r2, r7, ror #10
     d64:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     d68:	6f72505f 	svcvs	0x0072505f
     d6c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     d70:	5f79425f 	svcpl	0x0079425f
     d74:	45444950 	strbmi	r4, [r4, #-2384]	; 0xfffff6b0
     d78:	6148006a 	cmpvs	r8, sl, rrx
     d7c:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     d80:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     d84:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     d88:	5f6d6574 	svcpl	0x006d6574
     d8c:	00495753 	subeq	r5, r9, r3, asr r7
     d90:	314e5a5f 	cmpcc	lr, pc, asr sl
     d94:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     d98:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     d9c:	614d5f73 	hvcvs	54771	; 0xd5f3
     da0:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     da4:	53313172 	teqpl	r1, #-2147483620	; 0x8000001c
     da8:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     dac:	5f656c75 	svcpl	0x00656c75
     db0:	76455252 			; <UNDEFINED> instruction: 0x76455252
     db4:	73617400 	cmnvc	r1, #0, 8
     db8:	5a5f006b 	bpl	17c0f6c <__bss_end+0x17b7b10>
     dbc:	61657234 	cmnvs	r5, r4, lsr r2
     dc0:	63506a64 	cmpvs	r0, #100, 20	; 0x64000
     dc4:	6f4e006a 	svcvs	0x004e006a
     dc8:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     dcc:	6f72505f 	svcvs	0x0072505f
     dd0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     dd4:	68635300 	stmdavs	r3!, {r8, r9, ip, lr}^
     dd8:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     ddc:	5a5f0065 	bpl	17c0f78 <__bss_end+0x17b7b1c>
     de0:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     de4:	636f7250 	cmnvs	pc, #80, 4
     de8:	5f737365 	svcpl	0x00737365
     dec:	616e614d 	cmnvs	lr, sp, asr #2
     df0:	39726567 	ldmdbcc	r2!, {r0, r1, r2, r5, r6, r8, sl, sp, lr}^
     df4:	74697753 	strbtvc	r7, [r9], #-1875	; 0xfffff8ad
     df8:	545f6863 	ldrbpl	r6, [pc], #-2147	; e00 <_start-0x7200>
     dfc:	3150456f 	cmpcc	r0, pc, ror #10
     e00:	72504338 	subsvc	r4, r0, #56, 6	; 0xe0000000
     e04:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     e08:	694c5f73 	stmdbvs	ip, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     e0c:	4e5f7473 	mrcmi	4, 2, r7, cr15, cr3, {3}
     e10:	0065646f 	rsbeq	r6, r5, pc, ror #8
     e14:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     e18:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     e1c:	0052525f 	subseq	r5, r2, pc, asr r2
     e20:	314e5a5f 	cmpcc	lr, pc, asr sl
     e24:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     e28:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     e2c:	614d5f73 	hvcvs	54771	; 0xd5f3
     e30:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     e34:	48383172 	ldmdami	r8!, {r1, r4, r5, r6, r8, ip, sp}
     e38:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     e3c:	72505f65 	subsvc	r5, r0, #404	; 0x194
     e40:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     e44:	57535f73 			; <UNDEFINED> instruction: 0x57535f73
     e48:	30324549 	eorscc	r4, r2, r9, asr #10
     e4c:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     e50:	6f72505f 	svcvs	0x0072505f
     e54:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     e58:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     e5c:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     e60:	526a6a6a 	rsbpl	r6, sl, #434176	; 0x6a000
     e64:	53543131 	cmppl	r4, #1073741836	; 0x4000000c
     e68:	525f4957 	subspl	r4, pc, #1425408	; 0x15c000
     e6c:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
     e70:	494e0074 	stmdbmi	lr, {r2, r4, r5, r6}^
     e74:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
     e78:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
     e7c:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
     e80:	5f006e6f 	svcpl	0x00006e6f
     e84:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     e88:	6f725043 	svcvs	0x00725043
     e8c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     e90:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     e94:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     e98:	72433431 	subvc	r3, r3, #822083584	; 0x31000000
     e9c:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
     ea0:	6f72505f 	svcvs	0x0072505f
     ea4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     ea8:	6a685045 	bvs	1a14fc4 <__bss_end+0x1a0bb68>
     eac:	77530062 	ldrbvc	r0, [r3, -r2, rrx]
     eb0:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     eb4:	006f545f 	rsbeq	r5, pc, pc, asr r4	; <UNPREDICTABLE>
     eb8:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     ebc:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     ec0:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     ec4:	5f6d6574 	svcpl	0x006d6574
     ec8:	76726553 			; <UNDEFINED> instruction: 0x76726553
     ecc:	00656369 	rsbeq	r6, r5, r9, ror #6
     ed0:	63746572 	cmnvs	r4, #478150656	; 0x1c800000
     ed4:	0065646f 	rsbeq	r6, r5, pc, ror #8
     ed8:	5f746567 	svcpl	0x00746567
     edc:	69746361 	ldmdbvs	r4!, {r0, r5, r6, r8, r9, sp, lr}^
     ee0:	705f6576 	subsvc	r6, pc, r6, ror r5	; <UNPREDICTABLE>
     ee4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     ee8:	635f7373 	cmpvs	pc, #-872415231	; 0xcc000001
     eec:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     ef0:	6c696600 	stclvs	6, cr6, [r9], #-0
     ef4:	6d616e65 	stclvs	14, cr6, [r1, #-404]!	; 0xfffffe6c
     ef8:	6c420065 	mcrrvs	0, 6, r0, r2, cr5
     efc:	5f6b636f 	svcpl	0x006b636f
     f00:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     f04:	5f746e65 	svcpl	0x00746e65
     f08:	636f7250 	cmnvs	pc, #80, 4
     f0c:	00737365 	rsbseq	r7, r3, r5, ror #6
     f10:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
     f14:	6f6c4300 	svcvs	0x006c4300
     f18:	68006573 	stmdavs	r0, {r0, r1, r4, r5, r6, r8, sl, sp, lr}
     f1c:	5f706165 	svcpl	0x00706165
     f20:	72617473 	rsbvc	r7, r1, #1929379840	; 0x73000000
     f24:	65670074 	strbvs	r0, [r7, #-116]!	; 0xffffff8c
     f28:	64697074 	strbtvs	r7, [r9], #-116	; 0xffffff8c
     f2c:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
     f30:	6e65706f 	cdpvs	0, 6, cr7, cr5, cr15, {3}
     f34:	31634b50 	cmncc	r3, r0, asr fp
     f38:	69464e35 	stmdbvs	r6, {r0, r2, r4, r5, r9, sl, fp, lr}^
     f3c:	4f5f656c 	svcmi	0x005f656c
     f40:	5f6e6570 	svcpl	0x006e6570
     f44:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
     f48:	69725700 	ldmdbvs	r2!, {r8, r9, sl, ip, lr}^
     f4c:	4f5f6574 	svcmi	0x005f6574
     f50:	00796c6e 	rsbseq	r6, r9, lr, ror #24
     f54:	746e6d2f 	strbtvc	r6, [lr], #-3375	; 0xfffff2d1
     f58:	752f632f 	strvc	r6, [pc, #-815]!	; c31 <_start-0x73cf>
     f5c:	2f726573 	svccs	0x00726573
     f60:	76697270 			; <UNDEFINED> instruction: 0x76697270
     f64:	57657461 	strbpl	r7, [r5, -r1, ror #8]!
     f68:	736b726f 	cmnvc	fp, #-268435450	; 0xf0000006
     f6c:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     f70:	6863532f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, lr}^
     f74:	2f6c6f6f 	svccs	0x006c6f6f
     f78:	532f534f 			; <UNDEFINED> instruction: 0x532f534f
     f7c:	494b2f50 	stmdbmi	fp, {r4, r6, r8, r9, sl, fp, sp}^
     f80:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
     f84:	732f534f 			; <UNDEFINED> instruction: 0x732f534f
     f88:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     f8c:	622f7365 	eorvs	r7, pc, #-1811939327	; 0x94000001
     f90:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
     f94:	65695900 	strbvs	r5, [r9, #-2304]!	; 0xfffff700
     f98:	5f00646c 	svcpl	0x0000646c
     f9c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     fa0:	6f725043 	svcvs	0x00725043
     fa4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     fa8:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     fac:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     fb0:	76453443 	strbvc	r3, [r5], -r3, asr #8
     fb4:	72655400 	rsbvc	r5, r5, #0, 8
     fb8:	616e696d 	cmnvs	lr, sp, ror #18
     fbc:	49006574 	stmdbmi	r0, {r2, r4, r5, r6, r8, sl, sp, lr}
     fc0:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
     fc4:	726f6e00 	rsbvc	r6, pc, #0, 28
     fc8:	696c616d 	stmdbvs	ip!, {r0, r2, r3, r5, r6, r8, sp, lr}^
     fcc:	5f00657a 	svcpl	0x0000657a
     fd0:	656d365a 	strbvs	r3, [sp, #-1626]!	; 0xfffff9a6
     fd4:	7970636d 	ldmdbvc	r0!, {r0, r2, r3, r5, r6, r8, r9, sp, lr}^
     fd8:	50764b50 	rsbspl	r4, r6, r0, asr fp
     fdc:	66006976 			; <UNDEFINED> instruction: 0x66006976
     fe0:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
     fe4:	6e736900 	vaddvs.f16	s13, s6, s0	; <UNPREDICTABLE>
     fe8:	76006e61 	strvc	r6, [r0], -r1, ror #28
     fec:	65756c61 	ldrbvs	r6, [r5, #-3169]!	; 0xfffff39f
     ff0:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
     ff4:	616f7469 	cmnvs	pc, r9, ror #8
     ff8:	6a63506a 	bvs	18d51a8 <__bss_end+0x18cbd4c>
     ffc:	70786500 	rsbsvc	r6, r8, r0, lsl #10
    1000:	6e656e6f 	cdpvs	14, 6, cr6, cr5, cr15, {3}
    1004:	74610074 	strbtvc	r0, [r1], #-116	; 0xffffff8c
    1008:	7300696f 	movwvc	r6, #2415	; 0x96f
    100c:	656c7274 	strbvs	r7, [ip, #-628]!	; 0xfffffd8c
    1010:	6d2f006e 	stcvs	0, cr0, [pc, #-440]!	; e60 <_start-0x71a0>
    1014:	632f746e 			; <UNDEFINED> instruction: 0x632f746e
    1018:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
    101c:	72702f72 	rsbsvc	r2, r0, #456	; 0x1c8
    1020:	74617669 	strbtvc	r7, [r1], #-1641	; 0xfffff997
    1024:	726f5765 	rsbvc	r5, pc, #26476544	; 0x1940000
    1028:	6170736b 	cmnvs	r0, fp, ror #6
    102c:	532f6563 			; <UNDEFINED> instruction: 0x532f6563
    1030:	6f6f6863 	svcvs	0x006f6863
    1034:	534f2f6c 	movtpl	r2, #65388	; 0xff6c
    1038:	2f50532f 	svccs	0x0050532f
    103c:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
    1040:	534f5452 	movtpl	r5, #62546	; 0xf452
    1044:	756f732f 	strbvc	r7, [pc, #-815]!	; d1d <_start-0x72e3>
    1048:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    104c:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    1050:	2f62696c 	svccs	0x0062696c
    1054:	2f637273 	svccs	0x00637273
    1058:	73647473 	cmnvc	r4, #1929379840	; 0x73000000
    105c:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    1060:	70632e67 	rsbvc	r2, r3, r7, ror #28
    1064:	65640070 	strbvs	r0, [r4, #-112]!	; 0xffffff90
    1068:	5f007473 	svcpl	0x00007473
    106c:	7369355a 	cmnvc	r9, #377487360	; 0x16800000
    1070:	506e616e 	rsbpl	r6, lr, lr, ror #2
    1074:	0062634b 	rsbeq	r6, r2, fp, asr #6
    1078:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
    107c:	6f746900 	svcvs	0x00746900
    1080:	74730061 	ldrbtvc	r0, [r3], #-97	; 0xffffff9f
    1084:	74616372 	strbtvc	r6, [r1], #-882	; 0xfffffc8e
    1088:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    108c:	72657a62 	rsbvc	r7, r5, #401408	; 0x62000
    1090:	6976506f 	ldmdbvs	r6!, {r0, r1, r2, r3, r5, r6, ip, lr}^
    1094:	46736900 	ldrbtmi	r6, [r3], -r0, lsl #18
    1098:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    109c:	72747300 	rsbsvc	r7, r4, #0, 6
    10a0:	7970636e 	ldmdbvc	r0!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
    10a4:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    10a8:	616f7466 	cmnvs	pc, r6, ror #8
    10ac:	00666350 	rsbeq	r6, r6, r0, asr r3
    10b0:	75706e69 	ldrbvc	r6, [r0, #-3689]!	; 0xfffff197
    10b4:	5a5f0074 	bpl	17c128c <__bss_end+0x17b7e30>
    10b8:	72747337 	rsbsvc	r7, r4, #-603979776	; 0xdc000000
    10bc:	7970636e 	ldmdbvc	r0!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
    10c0:	4b506350 	blmi	1419e08 <__bss_end+0x14109ac>
    10c4:	5f006963 	svcpl	0x00006963
    10c8:	7473365a 	ldrbtvc	r3, [r3], #-1626	; 0xfffff9a6
    10cc:	74616372 	strbtvc	r6, [r1], #-882	; 0xfffffc8e
    10d0:	4b506350 	blmi	1419e18 <__bss_end+0x14109bc>
    10d4:	69640063 	stmdbvs	r4!, {r0, r1, r5, r6}^
    10d8:	00746967 	rsbseq	r6, r4, r7, ror #18
    10dc:	666f7461 	strbtvs	r7, [pc], -r1, ror #8
    10e0:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    10e4:	00747364 	rsbseq	r7, r4, r4, ror #6
    10e8:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
    10ec:	766e6f43 	strbtvc	r6, [lr], -r3, asr #30
    10f0:	00727241 	rsbseq	r7, r2, r1, asr #4
    10f4:	616f7466 	cmnvs	pc, r6, ror #8
    10f8:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    10fc:	00637273 	rsbeq	r7, r3, r3, ror r2
    1100:	72657a62 	rsbvc	r7, r5, #401408	; 0x62000
    1104:	656d006f 	strbvs	r0, [sp, #-111]!	; 0xffffff91
    1108:	7970636d 	ldmdbvc	r0!, {r0, r2, r3, r5, r6, r8, r9, sp, lr}^
    110c:	73616200 	cmnvc	r1, #0, 4
    1110:	74730065 	ldrbtvc	r0, [r3], #-101	; 0xffffff9b
    1114:	6d636e72 	stclvs	14, cr6, [r3, #-456]!	; 0xfffffe38
    1118:	69770070 	ldmdbvs	r7!, {r4, r5, r6}^
    111c:	00687464 	rsbeq	r7, r8, r4, ror #8
    1120:	61345a5f 	teqvs	r4, pc, asr sl
    1124:	50666f74 	rsbpl	r6, r6, r4, ror pc
    1128:	5f00634b 	svcpl	0x0000634b
    112c:	6f6e395a 	svcvs	0x006e395a
    1130:	6c616d72 	stclvs	13, cr6, [r1], #-456	; 0xfffffe38
    1134:	50657a69 	rsbpl	r7, r5, r9, ror #20
    1138:	5a5f0066 	bpl	17c12d8 <__bss_end+0x17b7e7c>
    113c:	72747336 	rsbsvc	r7, r4, #-671088640	; 0xd8000000
    1140:	506e656c 	rsbpl	r6, lr, ip, ror #10
    1144:	5f00634b 	svcpl	0x0000634b
    1148:	7473375a 	ldrbtvc	r3, [r3], #-1882	; 0xfffff8a6
    114c:	6d636e72 	stclvs	14, cr6, [r3, #-456]!	; 0xfffffe38
    1150:	634b5070 	movtvs	r5, #45168	; 0xb070
    1154:	695f3053 	ldmdbvs	pc, {r0, r1, r4, r6, ip, sp}^	; <UNPREDICTABLE>
    1158:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    115c:	696f7461 	stmdbvs	pc!, {r0, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1160:	00634b50 	rsbeq	r4, r3, r0, asr fp
    1164:	7074756f 	rsbsvc	r7, r4, pc, ror #10
    1168:	6d007475 	cfstrsvs	mvf7, [r0, #-468]	; 0xfffffe2c
    116c:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
    1170:	656c0079 	strbvs	r0, [ip, #-121]!	; 0xffffff87
    1174:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
    1178:	616c7000 	cmnvs	ip, r0
    117c:	00736563 	rsbseq	r6, r3, r3, ror #10

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
