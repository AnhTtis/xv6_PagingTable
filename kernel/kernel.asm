
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00019117          	auipc	sp,0x19
    80000004:	c0010113          	addi	sp,sp,-1024 # 80018c00 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	799040ef          	jal	80004fae <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	e7a9                	bnez	a5,80000076 <kfree+0x5a>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00021797          	auipc	a5,0x21
    80000034:	cd078793          	addi	a5,a5,-816 # 80020d00 <end>
    80000038:	02f56f63          	bltu	a0,a5,80000076 <kfree+0x5a>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57b63          	bgeu	a0,a5,80000076 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	106000ef          	jal	8000014e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    8000004c:	00008917          	auipc	s2,0x8
    80000050:	98490913          	addi	s2,s2,-1660 # 800079d0 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	1bb050ef          	jal	80005a10 <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	243050ef          	jal	80005aa8 <release>
}
    8000006a:	60e2                	ld	ra,24(sp)
    8000006c:	6442                	ld	s0,16(sp)
    8000006e:	64a2                	ld	s1,8(sp)
    80000070:	6902                	ld	s2,0(sp)
    80000072:	6105                	addi	sp,sp,32
    80000074:	8082                	ret
    panic("kfree");
    80000076:	00007517          	auipc	a0,0x7
    8000007a:	f8a50513          	addi	a0,a0,-118 # 80007000 <etext>
    8000007e:	664050ef          	jal	800056e2 <panic>

0000000080000082 <freerange>:
{
    80000082:	7179                	addi	sp,sp,-48
    80000084:	f406                	sd	ra,40(sp)
    80000086:	f022                	sd	s0,32(sp)
    80000088:	ec26                	sd	s1,24(sp)
    8000008a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000008c:	6785                	lui	a5,0x1
    8000008e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000092:	00e504b3          	add	s1,a0,a4
    80000096:	777d                	lui	a4,0xfffff
    80000098:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000009a:	94be                	add	s1,s1,a5
    8000009c:	0295e263          	bltu	a1,s1,800000c0 <freerange+0x3e>
    800000a0:	e84a                	sd	s2,16(sp)
    800000a2:	e44e                	sd	s3,8(sp)
    800000a4:	e052                	sd	s4,0(sp)
    800000a6:	892e                	mv	s2,a1
    kfree(p);
    800000a8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	6985                	lui	s3,0x1
    kfree(p);
    800000ac:	01448533          	add	a0,s1,s4
    800000b0:	f6dff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b4:	94ce                	add	s1,s1,s3
    800000b6:	fe997be3          	bgeu	s2,s1,800000ac <freerange+0x2a>
    800000ba:	6942                	ld	s2,16(sp)
    800000bc:	69a2                	ld	s3,8(sp)
    800000be:	6a02                	ld	s4,0(sp)
}
    800000c0:	70a2                	ld	ra,40(sp)
    800000c2:	7402                	ld	s0,32(sp)
    800000c4:	64e2                	ld	s1,24(sp)
    800000c6:	6145                	addi	sp,sp,48
    800000c8:	8082                	ret

00000000800000ca <kinit>:
{
    800000ca:	1141                	addi	sp,sp,-16
    800000cc:	e406                	sd	ra,8(sp)
    800000ce:	e022                	sd	s0,0(sp)
    800000d0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000d2:	00007597          	auipc	a1,0x7
    800000d6:	f3e58593          	addi	a1,a1,-194 # 80007010 <etext+0x10>
    800000da:	00008517          	auipc	a0,0x8
    800000de:	8f650513          	addi	a0,a0,-1802 # 800079d0 <kmem>
    800000e2:	0af050ef          	jal	80005990 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e6:	45c5                	li	a1,17
    800000e8:	05ee                	slli	a1,a1,0x1b
    800000ea:	00021517          	auipc	a0,0x21
    800000ee:	c1650513          	addi	a0,a0,-1002 # 80020d00 <end>
    800000f2:	f91ff0ef          	jal	80000082 <freerange>
}
    800000f6:	60a2                	ld	ra,8(sp)
    800000f8:	6402                	ld	s0,0(sp)
    800000fa:	0141                	addi	sp,sp,16
    800000fc:	8082                	ret

00000000800000fe <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000fe:	1101                	addi	sp,sp,-32
    80000100:	ec06                	sd	ra,24(sp)
    80000102:	e822                	sd	s0,16(sp)
    80000104:	e426                	sd	s1,8(sp)
    80000106:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000108:	00008497          	auipc	s1,0x8
    8000010c:	8c848493          	addi	s1,s1,-1848 # 800079d0 <kmem>
    80000110:	8526                	mv	a0,s1
    80000112:	0ff050ef          	jal	80005a10 <acquire>
  r = kmem.freelist;
    80000116:	6c84                	ld	s1,24(s1)
  if(r)
    80000118:	c485                	beqz	s1,80000140 <kalloc+0x42>
    kmem.freelist = r->next;
    8000011a:	609c                	ld	a5,0(s1)
    8000011c:	00008517          	auipc	a0,0x8
    80000120:	8b450513          	addi	a0,a0,-1868 # 800079d0 <kmem>
    80000124:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000126:	183050ef          	jal	80005aa8 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000012a:	6605                	lui	a2,0x1
    8000012c:	4595                	li	a1,5
    8000012e:	8526                	mv	a0,s1
    80000130:	01e000ef          	jal	8000014e <memset>
  return (void*)r;
}
    80000134:	8526                	mv	a0,s1
    80000136:	60e2                	ld	ra,24(sp)
    80000138:	6442                	ld	s0,16(sp)
    8000013a:	64a2                	ld	s1,8(sp)
    8000013c:	6105                	addi	sp,sp,32
    8000013e:	8082                	ret
  release(&kmem.lock);
    80000140:	00008517          	auipc	a0,0x8
    80000144:	89050513          	addi	a0,a0,-1904 # 800079d0 <kmem>
    80000148:	161050ef          	jal	80005aa8 <release>
  if(r)
    8000014c:	b7e5                	j	80000134 <kalloc+0x36>

000000008000014e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000014e:	1141                	addi	sp,sp,-16
    80000150:	e422                	sd	s0,8(sp)
    80000152:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000154:	ca19                	beqz	a2,8000016a <memset+0x1c>
    80000156:	87aa                	mv	a5,a0
    80000158:	1602                	slli	a2,a2,0x20
    8000015a:	9201                	srli	a2,a2,0x20
    8000015c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000160:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000164:	0785                	addi	a5,a5,1
    80000166:	fee79de3          	bne	a5,a4,80000160 <memset+0x12>
  }
  return dst;
}
    8000016a:	6422                	ld	s0,8(sp)
    8000016c:	0141                	addi	sp,sp,16
    8000016e:	8082                	ret

0000000080000170 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000170:	1141                	addi	sp,sp,-16
    80000172:	e422                	sd	s0,8(sp)
    80000174:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000176:	ca05                	beqz	a2,800001a6 <memcmp+0x36>
    80000178:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    8000017c:	1682                	slli	a3,a3,0x20
    8000017e:	9281                	srli	a3,a3,0x20
    80000180:	0685                	addi	a3,a3,1
    80000182:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000184:	00054783          	lbu	a5,0(a0)
    80000188:	0005c703          	lbu	a4,0(a1)
    8000018c:	00e79863          	bne	a5,a4,8000019c <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000190:	0505                	addi	a0,a0,1
    80000192:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000194:	fed518e3          	bne	a0,a3,80000184 <memcmp+0x14>
  }

  return 0;
    80000198:	4501                	li	a0,0
    8000019a:	a019                	j	800001a0 <memcmp+0x30>
      return *s1 - *s2;
    8000019c:	40e7853b          	subw	a0,a5,a4
}
    800001a0:	6422                	ld	s0,8(sp)
    800001a2:	0141                	addi	sp,sp,16
    800001a4:	8082                	ret
  return 0;
    800001a6:	4501                	li	a0,0
    800001a8:	bfe5                	j	800001a0 <memcmp+0x30>

00000000800001aa <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001aa:	1141                	addi	sp,sp,-16
    800001ac:	e422                	sd	s0,8(sp)
    800001ae:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001b0:	c205                	beqz	a2,800001d0 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001b2:	02a5e263          	bltu	a1,a0,800001d6 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001b6:	1602                	slli	a2,a2,0x20
    800001b8:	9201                	srli	a2,a2,0x20
    800001ba:	00c587b3          	add	a5,a1,a2
{
    800001be:	872a                	mv	a4,a0
      *d++ = *s++;
    800001c0:	0585                	addi	a1,a1,1
    800001c2:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffde301>
    800001c4:	fff5c683          	lbu	a3,-1(a1)
    800001c8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001cc:	feb79ae3          	bne	a5,a1,800001c0 <memmove+0x16>

  return dst;
}
    800001d0:	6422                	ld	s0,8(sp)
    800001d2:	0141                	addi	sp,sp,16
    800001d4:	8082                	ret
  if(s < d && s + n > d){
    800001d6:	02061693          	slli	a3,a2,0x20
    800001da:	9281                	srli	a3,a3,0x20
    800001dc:	00d58733          	add	a4,a1,a3
    800001e0:	fce57be3          	bgeu	a0,a4,800001b6 <memmove+0xc>
    d += n;
    800001e4:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800001e6:	fff6079b          	addiw	a5,a2,-1
    800001ea:	1782                	slli	a5,a5,0x20
    800001ec:	9381                	srli	a5,a5,0x20
    800001ee:	fff7c793          	not	a5,a5
    800001f2:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800001f4:	177d                	addi	a4,a4,-1
    800001f6:	16fd                	addi	a3,a3,-1
    800001f8:	00074603          	lbu	a2,0(a4)
    800001fc:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000200:	fef71ae3          	bne	a4,a5,800001f4 <memmove+0x4a>
    80000204:	b7f1                	j	800001d0 <memmove+0x26>

0000000080000206 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000206:	1141                	addi	sp,sp,-16
    80000208:	e406                	sd	ra,8(sp)
    8000020a:	e022                	sd	s0,0(sp)
    8000020c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000020e:	f9dff0ef          	jal	800001aa <memmove>
}
    80000212:	60a2                	ld	ra,8(sp)
    80000214:	6402                	ld	s0,0(sp)
    80000216:	0141                	addi	sp,sp,16
    80000218:	8082                	ret

000000008000021a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000021a:	1141                	addi	sp,sp,-16
    8000021c:	e422                	sd	s0,8(sp)
    8000021e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000220:	ce11                	beqz	a2,8000023c <strncmp+0x22>
    80000222:	00054783          	lbu	a5,0(a0)
    80000226:	cf89                	beqz	a5,80000240 <strncmp+0x26>
    80000228:	0005c703          	lbu	a4,0(a1)
    8000022c:	00f71a63          	bne	a4,a5,80000240 <strncmp+0x26>
    n--, p++, q++;
    80000230:	367d                	addiw	a2,a2,-1
    80000232:	0505                	addi	a0,a0,1
    80000234:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000236:	f675                	bnez	a2,80000222 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000238:	4501                	li	a0,0
    8000023a:	a801                	j	8000024a <strncmp+0x30>
    8000023c:	4501                	li	a0,0
    8000023e:	a031                	j	8000024a <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000240:	00054503          	lbu	a0,0(a0)
    80000244:	0005c783          	lbu	a5,0(a1)
    80000248:	9d1d                	subw	a0,a0,a5
}
    8000024a:	6422                	ld	s0,8(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000256:	87aa                	mv	a5,a0
    80000258:	86b2                	mv	a3,a2
    8000025a:	367d                	addiw	a2,a2,-1
    8000025c:	02d05563          	blez	a3,80000286 <strncpy+0x36>
    80000260:	0785                	addi	a5,a5,1
    80000262:	0005c703          	lbu	a4,0(a1)
    80000266:	fee78fa3          	sb	a4,-1(a5)
    8000026a:	0585                	addi	a1,a1,1
    8000026c:	f775                	bnez	a4,80000258 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000026e:	873e                	mv	a4,a5
    80000270:	9fb5                	addw	a5,a5,a3
    80000272:	37fd                	addiw	a5,a5,-1
    80000274:	00c05963          	blez	a2,80000286 <strncpy+0x36>
    *s++ = 0;
    80000278:	0705                	addi	a4,a4,1
    8000027a:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    8000027e:	40e786bb          	subw	a3,a5,a4
    80000282:	fed04be3          	bgtz	a3,80000278 <strncpy+0x28>
  return os;
}
    80000286:	6422                	ld	s0,8(sp)
    80000288:	0141                	addi	sp,sp,16
    8000028a:	8082                	ret

000000008000028c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000292:	02c05363          	blez	a2,800002b8 <safestrcpy+0x2c>
    80000296:	fff6069b          	addiw	a3,a2,-1
    8000029a:	1682                	slli	a3,a3,0x20
    8000029c:	9281                	srli	a3,a3,0x20
    8000029e:	96ae                	add	a3,a3,a1
    800002a0:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002a2:	00d58963          	beq	a1,a3,800002b4 <safestrcpy+0x28>
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	0785                	addi	a5,a5,1
    800002aa:	fff5c703          	lbu	a4,-1(a1)
    800002ae:	fee78fa3          	sb	a4,-1(a5)
    800002b2:	fb65                	bnez	a4,800002a2 <safestrcpy+0x16>
    ;
  *s = 0;
    800002b4:	00078023          	sb	zero,0(a5)
  return os;
}
    800002b8:	6422                	ld	s0,8(sp)
    800002ba:	0141                	addi	sp,sp,16
    800002bc:	8082                	ret

00000000800002be <strlen>:

int
strlen(const char *s)
{
    800002be:	1141                	addi	sp,sp,-16
    800002c0:	e422                	sd	s0,8(sp)
    800002c2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002c4:	00054783          	lbu	a5,0(a0)
    800002c8:	cf91                	beqz	a5,800002e4 <strlen+0x26>
    800002ca:	0505                	addi	a0,a0,1
    800002cc:	87aa                	mv	a5,a0
    800002ce:	86be                	mv	a3,a5
    800002d0:	0785                	addi	a5,a5,1
    800002d2:	fff7c703          	lbu	a4,-1(a5)
    800002d6:	ff65                	bnez	a4,800002ce <strlen+0x10>
    800002d8:	40a6853b          	subw	a0,a3,a0
    800002dc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    800002de:	6422                	ld	s0,8(sp)
    800002e0:	0141                	addi	sp,sp,16
    800002e2:	8082                	ret
  for(n = 0; s[n]; n++)
    800002e4:	4501                	li	a0,0
    800002e6:	bfe5                	j	800002de <strlen+0x20>

00000000800002e8 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800002e8:	1141                	addi	sp,sp,-16
    800002ea:	e406                	sd	ra,8(sp)
    800002ec:	e022                	sd	s0,0(sp)
    800002ee:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800002f0:	34f000ef          	jal	80000e3e <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800002f4:	00007717          	auipc	a4,0x7
    800002f8:	6ac70713          	addi	a4,a4,1708 # 800079a0 <started>
  if(cpuid() == 0){
    800002fc:	c51d                	beqz	a0,8000032a <main+0x42>
    while(started == 0)
    800002fe:	431c                	lw	a5,0(a4)
    80000300:	2781                	sext.w	a5,a5
    80000302:	dff5                	beqz	a5,800002fe <main+0x16>
      ;
    __sync_synchronize();
    80000304:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000308:	337000ef          	jal	80000e3e <cpuid>
    8000030c:	85aa                	mv	a1,a0
    8000030e:	00007517          	auipc	a0,0x7
    80000312:	d2a50513          	addi	a0,a0,-726 # 80007038 <etext+0x38>
    80000316:	0fa050ef          	jal	80005410 <printf>
    kvminithart();    // turn on paging
    8000031a:	080000ef          	jal	8000039a <kvminithart>
    trapinithart();   // install kernel trap vector
    8000031e:	63c010ef          	jal	8000195a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000322:	6a6040ef          	jal	800049c8 <plicinithart>
  }

  scheduler();        
    80000326:	779000ef          	jal	8000129e <scheduler>
    consoleinit();
    8000032a:	010050ef          	jal	8000533a <consoleinit>
    printfinit();
    8000032e:	3ee050ef          	jal	8000571c <printfinit>
    printf("\n");
    80000332:	00007517          	auipc	a0,0x7
    80000336:	ce650513          	addi	a0,a0,-794 # 80007018 <etext+0x18>
    8000033a:	0d6050ef          	jal	80005410 <printf>
    printf("xv6 kernel is booting\n");
    8000033e:	00007517          	auipc	a0,0x7
    80000342:	ce250513          	addi	a0,a0,-798 # 80007020 <etext+0x20>
    80000346:	0ca050ef          	jal	80005410 <printf>
    printf("\n");
    8000034a:	00007517          	auipc	a0,0x7
    8000034e:	cce50513          	addi	a0,a0,-818 # 80007018 <etext+0x18>
    80000352:	0be050ef          	jal	80005410 <printf>
    kinit();         // physical page allocator
    80000356:	d75ff0ef          	jal	800000ca <kinit>
    kvminit();       // create kernel page table
    8000035a:	2d4000ef          	jal	8000062e <kvminit>
    kvminithart();   // turn on paging
    8000035e:	03c000ef          	jal	8000039a <kvminithart>
    procinit();      // process table
    80000362:	229000ef          	jal	80000d8a <procinit>
    trapinit();      // trap vectors
    80000366:	5d0010ef          	jal	80001936 <trapinit>
    trapinithart();  // install kernel trap vector
    8000036a:	5f0010ef          	jal	8000195a <trapinithart>
    plicinit();      // set up interrupt controller
    8000036e:	640040ef          	jal	800049ae <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000372:	656040ef          	jal	800049c8 <plicinithart>
    binit();         // buffer cache
    80000376:	52f010ef          	jal	800020a4 <binit>
    iinit();         // inode table
    8000037a:	320020ef          	jal	8000269a <iinit>
    fileinit();      // file table
    8000037e:	0cc030ef          	jal	8000344a <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000382:	736040ef          	jal	80004ab8 <virtio_disk_init>
    userinit();      // first user process
    80000386:	54d000ef          	jal	800010d2 <userinit>
    __sync_synchronize();
    8000038a:	0ff0000f          	fence
    started = 1;
    8000038e:	4785                	li	a5,1
    80000390:	00007717          	auipc	a4,0x7
    80000394:	60f72823          	sw	a5,1552(a4) # 800079a0 <started>
    80000398:	b779                	j	80000326 <main+0x3e>

000000008000039a <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000039a:	1141                	addi	sp,sp,-16
    8000039c:	e422                	sd	s0,8(sp)
    8000039e:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800003a0:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003a4:	00007797          	auipc	a5,0x7
    800003a8:	6047b783          	ld	a5,1540(a5) # 800079a8 <kernel_pagetable>
    800003ac:	83b1                	srli	a5,a5,0xc
    800003ae:	577d                	li	a4,-1
    800003b0:	177e                	slli	a4,a4,0x3f
    800003b2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003b4:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800003b8:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003bc:	6422                	ld	s0,8(sp)
    800003be:	0141                	addi	sp,sp,16
    800003c0:	8082                	ret

00000000800003c2 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003c2:	7139                	addi	sp,sp,-64
    800003c4:	fc06                	sd	ra,56(sp)
    800003c6:	f822                	sd	s0,48(sp)
    800003c8:	f426                	sd	s1,40(sp)
    800003ca:	f04a                	sd	s2,32(sp)
    800003cc:	ec4e                	sd	s3,24(sp)
    800003ce:	e852                	sd	s4,16(sp)
    800003d0:	e456                	sd	s5,8(sp)
    800003d2:	e05a                	sd	s6,0(sp)
    800003d4:	0080                	addi	s0,sp,64
    800003d6:	892a                	mv	s2,a0
    800003d8:	89ae                	mv	s3,a1
    800003da:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800003dc:	57fd                	li	a5,-1
    800003de:	83e9                	srli	a5,a5,0x1a
    800003e0:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800003e2:	4b31                	li	s6,12
  if(va >= MAXVA)
    800003e4:	02b7fb63          	bgeu	a5,a1,8000041a <walk+0x58>
    panic("walk");
    800003e8:	00007517          	auipc	a0,0x7
    800003ec:	c6850513          	addi	a0,a0,-920 # 80007050 <etext+0x50>
    800003f0:	2f2050ef          	jal	800056e2 <panic>
      if(PTE_LEAF(*pte)) {
        return pte;
      }
#endif
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800003f4:	060a8563          	beqz	s5,8000045e <walk+0x9c>
    800003f8:	d07ff0ef          	jal	800000fe <kalloc>
    800003fc:	892a                	mv	s2,a0
    800003fe:	c135                	beqz	a0,80000462 <walk+0xa0>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000400:	6605                	lui	a2,0x1
    80000402:	4581                	li	a1,0
    80000404:	d4bff0ef          	jal	8000014e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000408:	00c95793          	srli	a5,s2,0xc
    8000040c:	07aa                	slli	a5,a5,0xa
    8000040e:	0017e793          	ori	a5,a5,1
    80000412:	e09c                	sd	a5,0(s1)
  for(int level = 2; level > 0; level--) {
    80000414:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffde2f7>
    80000416:	036a0263          	beq	s4,s6,8000043a <walk+0x78>
    pte_t *pte = &pagetable[PX(level, va)];
    8000041a:	0149d4b3          	srl	s1,s3,s4
    8000041e:	1ff4f493          	andi	s1,s1,511
    80000422:	048e                	slli	s1,s1,0x3
    80000424:	94ca                	add	s1,s1,s2
    if(*pte & PTE_V) {
    80000426:	609c                	ld	a5,0(s1)
    80000428:	0017f713          	andi	a4,a5,1
    8000042c:	d761                	beqz	a4,800003f4 <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000042e:	00a7d913          	srli	s2,a5,0xa
    80000432:	0932                	slli	s2,s2,0xc
      if(PTE_LEAF(*pte)) {
    80000434:	8bb9                	andi	a5,a5,14
    80000436:	dff9                	beqz	a5,80000414 <walk+0x52>
    80000438:	a801                	j	80000448 <walk+0x86>
    }
  }
  return &pagetable[PX(0, va)];
    8000043a:	00c9d993          	srli	s3,s3,0xc
    8000043e:	1ff9f993          	andi	s3,s3,511
    80000442:	098e                	slli	s3,s3,0x3
    80000444:	013904b3          	add	s1,s2,s3
}
    80000448:	8526                	mv	a0,s1
    8000044a:	70e2                	ld	ra,56(sp)
    8000044c:	7442                	ld	s0,48(sp)
    8000044e:	74a2                	ld	s1,40(sp)
    80000450:	7902                	ld	s2,32(sp)
    80000452:	69e2                	ld	s3,24(sp)
    80000454:	6a42                	ld	s4,16(sp)
    80000456:	6aa2                	ld	s5,8(sp)
    80000458:	6b02                	ld	s6,0(sp)
    8000045a:	6121                	addi	sp,sp,64
    8000045c:	8082                	ret
        return 0;
    8000045e:	4481                	li	s1,0
    80000460:	b7e5                	j	80000448 <walk+0x86>
    80000462:	84aa                	mv	s1,a0
    80000464:	b7d5                	j	80000448 <walk+0x86>

0000000080000466 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000466:	57fd                	li	a5,-1
    80000468:	83e9                	srli	a5,a5,0x1a
    8000046a:	00b7f463          	bgeu	a5,a1,80000472 <walkaddr+0xc>
    return 0;
    8000046e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000470:	8082                	ret
{
    80000472:	1141                	addi	sp,sp,-16
    80000474:	e406                	sd	ra,8(sp)
    80000476:	e022                	sd	s0,0(sp)
    80000478:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000047a:	4601                	li	a2,0
    8000047c:	f47ff0ef          	jal	800003c2 <walk>
  if(pte == 0)
    80000480:	c105                	beqz	a0,800004a0 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000482:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000484:	0117f693          	andi	a3,a5,17
    80000488:	4745                	li	a4,17
    return 0;
    8000048a:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000048c:	00e68663          	beq	a3,a4,80000498 <walkaddr+0x32>
}
    80000490:	60a2                	ld	ra,8(sp)
    80000492:	6402                	ld	s0,0(sp)
    80000494:	0141                	addi	sp,sp,16
    80000496:	8082                	ret
  pa = PTE2PA(*pte);
    80000498:	83a9                	srli	a5,a5,0xa
    8000049a:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000049e:	bfcd                	j	80000490 <walkaddr+0x2a>
    return 0;
    800004a0:	4501                	li	a0,0
    800004a2:	b7fd                	j	80000490 <walkaddr+0x2a>

00000000800004a4 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800004a4:	715d                	addi	sp,sp,-80
    800004a6:	e486                	sd	ra,72(sp)
    800004a8:	e0a2                	sd	s0,64(sp)
    800004aa:	fc26                	sd	s1,56(sp)
    800004ac:	f84a                	sd	s2,48(sp)
    800004ae:	f44e                	sd	s3,40(sp)
    800004b0:	f052                	sd	s4,32(sp)
    800004b2:	ec56                	sd	s5,24(sp)
    800004b4:	e85a                	sd	s6,16(sp)
    800004b6:	e45e                	sd	s7,8(sp)
    800004b8:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004ba:	03459793          	slli	a5,a1,0x34
    800004be:	e7a9                	bnez	a5,80000508 <mappages+0x64>
    800004c0:	8aaa                	mv	s5,a0
    800004c2:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004c4:	03461793          	slli	a5,a2,0x34
    800004c8:	e7b1                	bnez	a5,80000514 <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    800004ca:	ca39                	beqz	a2,80000520 <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800004cc:	77fd                	lui	a5,0xfffff
    800004ce:	963e                	add	a2,a2,a5
    800004d0:	00b609b3          	add	s3,a2,a1
  a = va;
    800004d4:	892e                	mv	s2,a1
    800004d6:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800004da:	6b85                	lui	s7,0x1
    800004dc:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800004e0:	4605                	li	a2,1
    800004e2:	85ca                	mv	a1,s2
    800004e4:	8556                	mv	a0,s5
    800004e6:	eddff0ef          	jal	800003c2 <walk>
    800004ea:	c539                	beqz	a0,80000538 <mappages+0x94>
    if(*pte & PTE_V)
    800004ec:	611c                	ld	a5,0(a0)
    800004ee:	8b85                	andi	a5,a5,1
    800004f0:	ef95                	bnez	a5,8000052c <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800004f2:	80b1                	srli	s1,s1,0xc
    800004f4:	04aa                	slli	s1,s1,0xa
    800004f6:	0164e4b3          	or	s1,s1,s6
    800004fa:	0014e493          	ori	s1,s1,1
    800004fe:	e104                	sd	s1,0(a0)
    if(a == last)
    80000500:	05390863          	beq	s2,s3,80000550 <mappages+0xac>
    a += PGSIZE;
    80000504:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80000506:	bfd9                	j	800004dc <mappages+0x38>
    panic("mappages: va not aligned");
    80000508:	00007517          	auipc	a0,0x7
    8000050c:	b5050513          	addi	a0,a0,-1200 # 80007058 <etext+0x58>
    80000510:	1d2050ef          	jal	800056e2 <panic>
    panic("mappages: size not aligned");
    80000514:	00007517          	auipc	a0,0x7
    80000518:	b6450513          	addi	a0,a0,-1180 # 80007078 <etext+0x78>
    8000051c:	1c6050ef          	jal	800056e2 <panic>
    panic("mappages: size");
    80000520:	00007517          	auipc	a0,0x7
    80000524:	b7850513          	addi	a0,a0,-1160 # 80007098 <etext+0x98>
    80000528:	1ba050ef          	jal	800056e2 <panic>
      panic("mappages: remap");
    8000052c:	00007517          	auipc	a0,0x7
    80000530:	b7c50513          	addi	a0,a0,-1156 # 800070a8 <etext+0xa8>
    80000534:	1ae050ef          	jal	800056e2 <panic>
      return -1;
    80000538:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000053a:	60a6                	ld	ra,72(sp)
    8000053c:	6406                	ld	s0,64(sp)
    8000053e:	74e2                	ld	s1,56(sp)
    80000540:	7942                	ld	s2,48(sp)
    80000542:	79a2                	ld	s3,40(sp)
    80000544:	7a02                	ld	s4,32(sp)
    80000546:	6ae2                	ld	s5,24(sp)
    80000548:	6b42                	ld	s6,16(sp)
    8000054a:	6ba2                	ld	s7,8(sp)
    8000054c:	6161                	addi	sp,sp,80
    8000054e:	8082                	ret
  return 0;
    80000550:	4501                	li	a0,0
    80000552:	b7e5                	j	8000053a <mappages+0x96>

0000000080000554 <kvmmap>:
{
    80000554:	1141                	addi	sp,sp,-16
    80000556:	e406                	sd	ra,8(sp)
    80000558:	e022                	sd	s0,0(sp)
    8000055a:	0800                	addi	s0,sp,16
    8000055c:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000055e:	86b2                	mv	a3,a2
    80000560:	863e                	mv	a2,a5
    80000562:	f43ff0ef          	jal	800004a4 <mappages>
    80000566:	e509                	bnez	a0,80000570 <kvmmap+0x1c>
}
    80000568:	60a2                	ld	ra,8(sp)
    8000056a:	6402                	ld	s0,0(sp)
    8000056c:	0141                	addi	sp,sp,16
    8000056e:	8082                	ret
    panic("kvmmap");
    80000570:	00007517          	auipc	a0,0x7
    80000574:	b4850513          	addi	a0,a0,-1208 # 800070b8 <etext+0xb8>
    80000578:	16a050ef          	jal	800056e2 <panic>

000000008000057c <kvmmake>:
{
    8000057c:	1101                	addi	sp,sp,-32
    8000057e:	ec06                	sd	ra,24(sp)
    80000580:	e822                	sd	s0,16(sp)
    80000582:	e426                	sd	s1,8(sp)
    80000584:	e04a                	sd	s2,0(sp)
    80000586:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000588:	b77ff0ef          	jal	800000fe <kalloc>
    8000058c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000058e:	6605                	lui	a2,0x1
    80000590:	4581                	li	a1,0
    80000592:	bbdff0ef          	jal	8000014e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000596:	4719                	li	a4,6
    80000598:	6685                	lui	a3,0x1
    8000059a:	10000637          	lui	a2,0x10000
    8000059e:	100005b7          	lui	a1,0x10000
    800005a2:	8526                	mv	a0,s1
    800005a4:	fb1ff0ef          	jal	80000554 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800005a8:	4719                	li	a4,6
    800005aa:	6685                	lui	a3,0x1
    800005ac:	10001637          	lui	a2,0x10001
    800005b0:	100015b7          	lui	a1,0x10001
    800005b4:	8526                	mv	a0,s1
    800005b6:	f9fff0ef          	jal	80000554 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005ba:	4719                	li	a4,6
    800005bc:	040006b7          	lui	a3,0x4000
    800005c0:	0c000637          	lui	a2,0xc000
    800005c4:	0c0005b7          	lui	a1,0xc000
    800005c8:	8526                	mv	a0,s1
    800005ca:	f8bff0ef          	jal	80000554 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800005ce:	00007917          	auipc	s2,0x7
    800005d2:	a3290913          	addi	s2,s2,-1486 # 80007000 <etext>
    800005d6:	4729                	li	a4,10
    800005d8:	80007697          	auipc	a3,0x80007
    800005dc:	a2868693          	addi	a3,a3,-1496 # 7000 <_entry-0x7fff9000>
    800005e0:	4605                	li	a2,1
    800005e2:	067e                	slli	a2,a2,0x1f
    800005e4:	85b2                	mv	a1,a2
    800005e6:	8526                	mv	a0,s1
    800005e8:	f6dff0ef          	jal	80000554 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800005ec:	46c5                	li	a3,17
    800005ee:	06ee                	slli	a3,a3,0x1b
    800005f0:	4719                	li	a4,6
    800005f2:	412686b3          	sub	a3,a3,s2
    800005f6:	864a                	mv	a2,s2
    800005f8:	85ca                	mv	a1,s2
    800005fa:	8526                	mv	a0,s1
    800005fc:	f59ff0ef          	jal	80000554 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000600:	4729                	li	a4,10
    80000602:	6685                	lui	a3,0x1
    80000604:	00006617          	auipc	a2,0x6
    80000608:	9fc60613          	addi	a2,a2,-1540 # 80006000 <_trampoline>
    8000060c:	040005b7          	lui	a1,0x4000
    80000610:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000612:	05b2                	slli	a1,a1,0xc
    80000614:	8526                	mv	a0,s1
    80000616:	f3fff0ef          	jal	80000554 <kvmmap>
  proc_mapstacks(kpgtbl);
    8000061a:	8526                	mv	a0,s1
    8000061c:	6d8000ef          	jal	80000cf4 <proc_mapstacks>
}
    80000620:	8526                	mv	a0,s1
    80000622:	60e2                	ld	ra,24(sp)
    80000624:	6442                	ld	s0,16(sp)
    80000626:	64a2                	ld	s1,8(sp)
    80000628:	6902                	ld	s2,0(sp)
    8000062a:	6105                	addi	sp,sp,32
    8000062c:	8082                	ret

000000008000062e <kvminit>:
{
    8000062e:	1141                	addi	sp,sp,-16
    80000630:	e406                	sd	ra,8(sp)
    80000632:	e022                	sd	s0,0(sp)
    80000634:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000636:	f47ff0ef          	jal	8000057c <kvmmake>
    8000063a:	00007797          	auipc	a5,0x7
    8000063e:	36a7b723          	sd	a0,878(a5) # 800079a8 <kernel_pagetable>
}
    80000642:	60a2                	ld	ra,8(sp)
    80000644:	6402                	ld	s0,0(sp)
    80000646:	0141                	addi	sp,sp,16
    80000648:	8082                	ret

000000008000064a <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000064a:	715d                	addi	sp,sp,-80
    8000064c:	e486                	sd	ra,72(sp)
    8000064e:	e0a2                	sd	s0,64(sp)
    80000650:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;
  int sz;

  if((va % PGSIZE) != 0)
    80000652:	03459793          	slli	a5,a1,0x34
    80000656:	e39d                	bnez	a5,8000067c <uvmunmap+0x32>
    80000658:	f84a                	sd	s2,48(sp)
    8000065a:	f44e                	sd	s3,40(sp)
    8000065c:	f052                	sd	s4,32(sp)
    8000065e:	ec56                	sd	s5,24(sp)
    80000660:	e85a                	sd	s6,16(sp)
    80000662:	e45e                	sd	s7,8(sp)
    80000664:	8a2a                	mv	s4,a0
    80000666:	892e                	mv	s2,a1
    80000668:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += sz){
    8000066a:	0632                	slli	a2,a2,0xc
    8000066c:	00b609b3          	add	s3,a2,a1
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0) {
      printf("va=%ld pte=%ld\n", a, *pte);
      panic("uvmunmap: not mapped");
    }
    if(PTE_FLAGS(*pte) == PTE_V)
    80000670:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += sz){
    80000672:	6b05                	lui	s6,0x1
    80000674:	0935f763          	bgeu	a1,s3,80000702 <uvmunmap+0xb8>
    80000678:	fc26                	sd	s1,56(sp)
    8000067a:	a8a1                	j	800006d2 <uvmunmap+0x88>
    8000067c:	fc26                	sd	s1,56(sp)
    8000067e:	f84a                	sd	s2,48(sp)
    80000680:	f44e                	sd	s3,40(sp)
    80000682:	f052                	sd	s4,32(sp)
    80000684:	ec56                	sd	s5,24(sp)
    80000686:	e85a                	sd	s6,16(sp)
    80000688:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    8000068a:	00007517          	auipc	a0,0x7
    8000068e:	a3650513          	addi	a0,a0,-1482 # 800070c0 <etext+0xc0>
    80000692:	050050ef          	jal	800056e2 <panic>
      panic("uvmunmap: walk");
    80000696:	00007517          	auipc	a0,0x7
    8000069a:	a4250513          	addi	a0,a0,-1470 # 800070d8 <etext+0xd8>
    8000069e:	044050ef          	jal	800056e2 <panic>
      printf("va=%ld pte=%ld\n", a, *pte);
    800006a2:	85ca                	mv	a1,s2
    800006a4:	00007517          	auipc	a0,0x7
    800006a8:	a4450513          	addi	a0,a0,-1468 # 800070e8 <etext+0xe8>
    800006ac:	565040ef          	jal	80005410 <printf>
      panic("uvmunmap: not mapped");
    800006b0:	00007517          	auipc	a0,0x7
    800006b4:	a4850513          	addi	a0,a0,-1464 # 800070f8 <etext+0xf8>
    800006b8:	02a050ef          	jal	800056e2 <panic>
      panic("uvmunmap: not a leaf");
    800006bc:	00007517          	auipc	a0,0x7
    800006c0:	a5450513          	addi	a0,a0,-1452 # 80007110 <etext+0x110>
    800006c4:	01e050ef          	jal	800056e2 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800006c8:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += sz){
    800006cc:	995a                	add	s2,s2,s6
    800006ce:	03397963          	bgeu	s2,s3,80000700 <uvmunmap+0xb6>
    if((pte = walk(pagetable, a, 0)) == 0)
    800006d2:	4601                	li	a2,0
    800006d4:	85ca                	mv	a1,s2
    800006d6:	8552                	mv	a0,s4
    800006d8:	cebff0ef          	jal	800003c2 <walk>
    800006dc:	84aa                	mv	s1,a0
    800006de:	dd45                	beqz	a0,80000696 <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0) {
    800006e0:	6110                	ld	a2,0(a0)
    800006e2:	00167793          	andi	a5,a2,1
    800006e6:	dfd5                	beqz	a5,800006a2 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    800006e8:	3ff67793          	andi	a5,a2,1023
    800006ec:	fd7788e3          	beq	a5,s7,800006bc <uvmunmap+0x72>
    if(do_free){
    800006f0:	fc0a8ce3          	beqz	s5,800006c8 <uvmunmap+0x7e>
      uint64 pa = PTE2PA(*pte);
    800006f4:	8229                	srli	a2,a2,0xa
      kfree((void*)pa);
    800006f6:	00c61513          	slli	a0,a2,0xc
    800006fa:	923ff0ef          	jal	8000001c <kfree>
    800006fe:	b7e9                	j	800006c8 <uvmunmap+0x7e>
    80000700:	74e2                	ld	s1,56(sp)
    80000702:	7942                	ld	s2,48(sp)
    80000704:	79a2                	ld	s3,40(sp)
    80000706:	7a02                	ld	s4,32(sp)
    80000708:	6ae2                	ld	s5,24(sp)
    8000070a:	6b42                	ld	s6,16(sp)
    8000070c:	6ba2                	ld	s7,8(sp)
  }
}
    8000070e:	60a6                	ld	ra,72(sp)
    80000710:	6406                	ld	s0,64(sp)
    80000712:	6161                	addi	sp,sp,80
    80000714:	8082                	ret

0000000080000716 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000716:	1101                	addi	sp,sp,-32
    80000718:	ec06                	sd	ra,24(sp)
    8000071a:	e822                	sd	s0,16(sp)
    8000071c:	e426                	sd	s1,8(sp)
    8000071e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000720:	9dfff0ef          	jal	800000fe <kalloc>
    80000724:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000726:	c509                	beqz	a0,80000730 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000728:	6605                	lui	a2,0x1
    8000072a:	4581                	li	a1,0
    8000072c:	a23ff0ef          	jal	8000014e <memset>
  return pagetable;
}
    80000730:	8526                	mv	a0,s1
    80000732:	60e2                	ld	ra,24(sp)
    80000734:	6442                	ld	s0,16(sp)
    80000736:	64a2                	ld	s1,8(sp)
    80000738:	6105                	addi	sp,sp,32
    8000073a:	8082                	ret

000000008000073c <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000073c:	7179                	addi	sp,sp,-48
    8000073e:	f406                	sd	ra,40(sp)
    80000740:	f022                	sd	s0,32(sp)
    80000742:	ec26                	sd	s1,24(sp)
    80000744:	e84a                	sd	s2,16(sp)
    80000746:	e44e                	sd	s3,8(sp)
    80000748:	e052                	sd	s4,0(sp)
    8000074a:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000074c:	6785                	lui	a5,0x1
    8000074e:	04f67063          	bgeu	a2,a5,8000078e <uvmfirst+0x52>
    80000752:	8a2a                	mv	s4,a0
    80000754:	89ae                	mv	s3,a1
    80000756:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000758:	9a7ff0ef          	jal	800000fe <kalloc>
    8000075c:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000075e:	6605                	lui	a2,0x1
    80000760:	4581                	li	a1,0
    80000762:	9edff0ef          	jal	8000014e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000766:	4779                	li	a4,30
    80000768:	86ca                	mv	a3,s2
    8000076a:	6605                	lui	a2,0x1
    8000076c:	4581                	li	a1,0
    8000076e:	8552                	mv	a0,s4
    80000770:	d35ff0ef          	jal	800004a4 <mappages>
  memmove(mem, src, sz);
    80000774:	8626                	mv	a2,s1
    80000776:	85ce                	mv	a1,s3
    80000778:	854a                	mv	a0,s2
    8000077a:	a31ff0ef          	jal	800001aa <memmove>
}
    8000077e:	70a2                	ld	ra,40(sp)
    80000780:	7402                	ld	s0,32(sp)
    80000782:	64e2                	ld	s1,24(sp)
    80000784:	6942                	ld	s2,16(sp)
    80000786:	69a2                	ld	s3,8(sp)
    80000788:	6a02                	ld	s4,0(sp)
    8000078a:	6145                	addi	sp,sp,48
    8000078c:	8082                	ret
    panic("uvmfirst: more than a page");
    8000078e:	00007517          	auipc	a0,0x7
    80000792:	99a50513          	addi	a0,a0,-1638 # 80007128 <etext+0x128>
    80000796:	74d040ef          	jal	800056e2 <panic>

000000008000079a <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000079a:	1101                	addi	sp,sp,-32
    8000079c:	ec06                	sd	ra,24(sp)
    8000079e:	e822                	sd	s0,16(sp)
    800007a0:	e426                	sd	s1,8(sp)
    800007a2:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800007a4:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800007a6:	00b67d63          	bgeu	a2,a1,800007c0 <uvmdealloc+0x26>
    800007aa:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800007ac:	6785                	lui	a5,0x1
    800007ae:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007b0:	00f60733          	add	a4,a2,a5
    800007b4:	76fd                	lui	a3,0xfffff
    800007b6:	8f75                	and	a4,a4,a3
    800007b8:	97ae                	add	a5,a5,a1
    800007ba:	8ff5                	and	a5,a5,a3
    800007bc:	00f76863          	bltu	a4,a5,800007cc <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800007c0:	8526                	mv	a0,s1
    800007c2:	60e2                	ld	ra,24(sp)
    800007c4:	6442                	ld	s0,16(sp)
    800007c6:	64a2                	ld	s1,8(sp)
    800007c8:	6105                	addi	sp,sp,32
    800007ca:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800007cc:	8f99                	sub	a5,a5,a4
    800007ce:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800007d0:	4685                	li	a3,1
    800007d2:	0007861b          	sext.w	a2,a5
    800007d6:	85ba                	mv	a1,a4
    800007d8:	e73ff0ef          	jal	8000064a <uvmunmap>
    800007dc:	b7d5                	j	800007c0 <uvmdealloc+0x26>

00000000800007de <uvmalloc>:
  if(newsz < oldsz)
    800007de:	08b66f63          	bltu	a2,a1,8000087c <uvmalloc+0x9e>
{
    800007e2:	7139                	addi	sp,sp,-64
    800007e4:	fc06                	sd	ra,56(sp)
    800007e6:	f822                	sd	s0,48(sp)
    800007e8:	ec4e                	sd	s3,24(sp)
    800007ea:	e852                	sd	s4,16(sp)
    800007ec:	e456                	sd	s5,8(sp)
    800007ee:	0080                	addi	s0,sp,64
    800007f0:	8aaa                	mv	s5,a0
    800007f2:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800007f4:	6785                	lui	a5,0x1
    800007f6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007f8:	95be                	add	a1,a1,a5
    800007fa:	77fd                	lui	a5,0xfffff
    800007fc:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += sz){
    80000800:	08c9f063          	bgeu	s3,a2,80000880 <uvmalloc+0xa2>
    80000804:	f426                	sd	s1,40(sp)
    80000806:	f04a                	sd	s2,32(sp)
    80000808:	e05a                	sd	s6,0(sp)
    8000080a:	894e                	mv	s2,s3
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000080c:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000810:	8efff0ef          	jal	800000fe <kalloc>
    80000814:	84aa                	mv	s1,a0
    if(mem == 0){
    80000816:	c515                	beqz	a0,80000842 <uvmalloc+0x64>
    memset(mem, 0, sz);
    80000818:	6605                	lui	a2,0x1
    8000081a:	4581                	li	a1,0
    8000081c:	933ff0ef          	jal	8000014e <memset>
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000820:	875a                	mv	a4,s6
    80000822:	86a6                	mv	a3,s1
    80000824:	6605                	lui	a2,0x1
    80000826:	85ca                	mv	a1,s2
    80000828:	8556                	mv	a0,s5
    8000082a:	c7bff0ef          	jal	800004a4 <mappages>
    8000082e:	e915                	bnez	a0,80000862 <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += sz){
    80000830:	6785                	lui	a5,0x1
    80000832:	993e                	add	s2,s2,a5
    80000834:	fd496ee3          	bltu	s2,s4,80000810 <uvmalloc+0x32>
  return newsz;
    80000838:	8552                	mv	a0,s4
    8000083a:	74a2                	ld	s1,40(sp)
    8000083c:	7902                	ld	s2,32(sp)
    8000083e:	6b02                	ld	s6,0(sp)
    80000840:	a811                	j	80000854 <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    80000842:	864e                	mv	a2,s3
    80000844:	85ca                	mv	a1,s2
    80000846:	8556                	mv	a0,s5
    80000848:	f53ff0ef          	jal	8000079a <uvmdealloc>
      return 0;
    8000084c:	4501                	li	a0,0
    8000084e:	74a2                	ld	s1,40(sp)
    80000850:	7902                	ld	s2,32(sp)
    80000852:	6b02                	ld	s6,0(sp)
}
    80000854:	70e2                	ld	ra,56(sp)
    80000856:	7442                	ld	s0,48(sp)
    80000858:	69e2                	ld	s3,24(sp)
    8000085a:	6a42                	ld	s4,16(sp)
    8000085c:	6aa2                	ld	s5,8(sp)
    8000085e:	6121                	addi	sp,sp,64
    80000860:	8082                	ret
      kfree(mem);
    80000862:	8526                	mv	a0,s1
    80000864:	fb8ff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000868:	864e                	mv	a2,s3
    8000086a:	85ca                	mv	a1,s2
    8000086c:	8556                	mv	a0,s5
    8000086e:	f2dff0ef          	jal	8000079a <uvmdealloc>
      return 0;
    80000872:	4501                	li	a0,0
    80000874:	74a2                	ld	s1,40(sp)
    80000876:	7902                	ld	s2,32(sp)
    80000878:	6b02                	ld	s6,0(sp)
    8000087a:	bfe9                	j	80000854 <uvmalloc+0x76>
    return oldsz;
    8000087c:	852e                	mv	a0,a1
}
    8000087e:	8082                	ret
  return newsz;
    80000880:	8532                	mv	a0,a2
    80000882:	bfc9                	j	80000854 <uvmalloc+0x76>

0000000080000884 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000884:	7179                	addi	sp,sp,-48
    80000886:	f406                	sd	ra,40(sp)
    80000888:	f022                	sd	s0,32(sp)
    8000088a:	ec26                	sd	s1,24(sp)
    8000088c:	e84a                	sd	s2,16(sp)
    8000088e:	e44e                	sd	s3,8(sp)
    80000890:	e052                	sd	s4,0(sp)
    80000892:	1800                	addi	s0,sp,48
    80000894:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000896:	84aa                	mv	s1,a0
    80000898:	6905                	lui	s2,0x1
    8000089a:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000089c:	4985                	li	s3,1
    8000089e:	a819                	j	800008b4 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800008a0:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800008a2:	00c79513          	slli	a0,a5,0xc
    800008a6:	fdfff0ef          	jal	80000884 <freewalk>
      pagetable[i] = 0;
    800008aa:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800008ae:	04a1                	addi	s1,s1,8
    800008b0:	01248f63          	beq	s1,s2,800008ce <freewalk+0x4a>
    pte_t pte = pagetable[i];
    800008b4:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800008b6:	00f7f713          	andi	a4,a5,15
    800008ba:	ff3703e3          	beq	a4,s3,800008a0 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800008be:	8b85                	andi	a5,a5,1
    800008c0:	d7fd                	beqz	a5,800008ae <freewalk+0x2a>
      panic("freewalk: leaf");
    800008c2:	00007517          	auipc	a0,0x7
    800008c6:	88650513          	addi	a0,a0,-1914 # 80007148 <etext+0x148>
    800008ca:	619040ef          	jal	800056e2 <panic>
    }
  }
  kfree((void*)pagetable);
    800008ce:	8552                	mv	a0,s4
    800008d0:	f4cff0ef          	jal	8000001c <kfree>
}
    800008d4:	70a2                	ld	ra,40(sp)
    800008d6:	7402                	ld	s0,32(sp)
    800008d8:	64e2                	ld	s1,24(sp)
    800008da:	6942                	ld	s2,16(sp)
    800008dc:	69a2                	ld	s3,8(sp)
    800008de:	6a02                	ld	s4,0(sp)
    800008e0:	6145                	addi	sp,sp,48
    800008e2:	8082                	ret

00000000800008e4 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800008e4:	1101                	addi	sp,sp,-32
    800008e6:	ec06                	sd	ra,24(sp)
    800008e8:	e822                	sd	s0,16(sp)
    800008ea:	e426                	sd	s1,8(sp)
    800008ec:	1000                	addi	s0,sp,32
    800008ee:	84aa                	mv	s1,a0
  if(sz > 0)
    800008f0:	e989                	bnez	a1,80000902 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800008f2:	8526                	mv	a0,s1
    800008f4:	f91ff0ef          	jal	80000884 <freewalk>
}
    800008f8:	60e2                	ld	ra,24(sp)
    800008fa:	6442                	ld	s0,16(sp)
    800008fc:	64a2                	ld	s1,8(sp)
    800008fe:	6105                	addi	sp,sp,32
    80000900:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000902:	6785                	lui	a5,0x1
    80000904:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000906:	95be                	add	a1,a1,a5
    80000908:	4685                	li	a3,1
    8000090a:	00c5d613          	srli	a2,a1,0xc
    8000090e:	4581                	li	a1,0
    80000910:	d3bff0ef          	jal	8000064a <uvmunmap>
    80000914:	bff9                	j	800008f2 <uvmfree+0xe>

0000000080000916 <uvmcopy>:
  uint64 pa, i;
  uint flags;
  char *mem;
  int szinc;

  for(i = 0; i < sz; i += szinc){
    80000916:	c65d                	beqz	a2,800009c4 <uvmcopy+0xae>
{
    80000918:	715d                	addi	sp,sp,-80
    8000091a:	e486                	sd	ra,72(sp)
    8000091c:	e0a2                	sd	s0,64(sp)
    8000091e:	fc26                	sd	s1,56(sp)
    80000920:	f84a                	sd	s2,48(sp)
    80000922:	f44e                	sd	s3,40(sp)
    80000924:	f052                	sd	s4,32(sp)
    80000926:	ec56                	sd	s5,24(sp)
    80000928:	e85a                	sd	s6,16(sp)
    8000092a:	e45e                	sd	s7,8(sp)
    8000092c:	0880                	addi	s0,sp,80
    8000092e:	8b2a                	mv	s6,a0
    80000930:	8aae                	mv	s5,a1
    80000932:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += szinc){
    80000934:	4981                	li	s3,0
    szinc = PGSIZE;
    szinc = PGSIZE;
    if((pte = walk(old, i, 0)) == 0)
    80000936:	4601                	li	a2,0
    80000938:	85ce                	mv	a1,s3
    8000093a:	855a                	mv	a0,s6
    8000093c:	a87ff0ef          	jal	800003c2 <walk>
    80000940:	c121                	beqz	a0,80000980 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000942:	6118                	ld	a4,0(a0)
    80000944:	00177793          	andi	a5,a4,1
    80000948:	c3b1                	beqz	a5,8000098c <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    8000094a:	00a75593          	srli	a1,a4,0xa
    8000094e:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000952:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000956:	fa8ff0ef          	jal	800000fe <kalloc>
    8000095a:	892a                	mv	s2,a0
    8000095c:	c129                	beqz	a0,8000099e <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    8000095e:	6605                	lui	a2,0x1
    80000960:	85de                	mv	a1,s7
    80000962:	849ff0ef          	jal	800001aa <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000966:	8726                	mv	a4,s1
    80000968:	86ca                	mv	a3,s2
    8000096a:	6605                	lui	a2,0x1
    8000096c:	85ce                	mv	a1,s3
    8000096e:	8556                	mv	a0,s5
    80000970:	b35ff0ef          	jal	800004a4 <mappages>
    80000974:	e115                	bnez	a0,80000998 <uvmcopy+0x82>
  for(i = 0; i < sz; i += szinc){
    80000976:	6785                	lui	a5,0x1
    80000978:	99be                	add	s3,s3,a5
    8000097a:	fb49eee3          	bltu	s3,s4,80000936 <uvmcopy+0x20>
    8000097e:	a805                	j	800009ae <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    80000980:	00006517          	auipc	a0,0x6
    80000984:	7d850513          	addi	a0,a0,2008 # 80007158 <etext+0x158>
    80000988:	55b040ef          	jal	800056e2 <panic>
      panic("uvmcopy: page not present");
    8000098c:	00006517          	auipc	a0,0x6
    80000990:	7ec50513          	addi	a0,a0,2028 # 80007178 <etext+0x178>
    80000994:	54f040ef          	jal	800056e2 <panic>
      kfree(mem);
    80000998:	854a                	mv	a0,s2
    8000099a:	e82ff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    8000099e:	4685                	li	a3,1
    800009a0:	00c9d613          	srli	a2,s3,0xc
    800009a4:	4581                	li	a1,0
    800009a6:	8556                	mv	a0,s5
    800009a8:	ca3ff0ef          	jal	8000064a <uvmunmap>
  return -1;
    800009ac:	557d                	li	a0,-1
}
    800009ae:	60a6                	ld	ra,72(sp)
    800009b0:	6406                	ld	s0,64(sp)
    800009b2:	74e2                	ld	s1,56(sp)
    800009b4:	7942                	ld	s2,48(sp)
    800009b6:	79a2                	ld	s3,40(sp)
    800009b8:	7a02                	ld	s4,32(sp)
    800009ba:	6ae2                	ld	s5,24(sp)
    800009bc:	6b42                	ld	s6,16(sp)
    800009be:	6ba2                	ld	s7,8(sp)
    800009c0:	6161                	addi	sp,sp,80
    800009c2:	8082                	ret
  return 0;
    800009c4:	4501                	li	a0,0
}
    800009c6:	8082                	ret

00000000800009c8 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800009c8:	1141                	addi	sp,sp,-16
    800009ca:	e406                	sd	ra,8(sp)
    800009cc:	e022                	sd	s0,0(sp)
    800009ce:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800009d0:	4601                	li	a2,0
    800009d2:	9f1ff0ef          	jal	800003c2 <walk>
  if(pte == 0)
    800009d6:	c901                	beqz	a0,800009e6 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800009d8:	611c                	ld	a5,0(a0)
    800009da:	9bbd                	andi	a5,a5,-17
    800009dc:	e11c                	sd	a5,0(a0)
}
    800009de:	60a2                	ld	ra,8(sp)
    800009e0:	6402                	ld	s0,0(sp)
    800009e2:	0141                	addi	sp,sp,16
    800009e4:	8082                	ret
    panic("uvmclear");
    800009e6:	00006517          	auipc	a0,0x6
    800009ea:	7b250513          	addi	a0,a0,1970 # 80007198 <etext+0x198>
    800009ee:	4f5040ef          	jal	800056e2 <panic>

00000000800009f2 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    800009f2:	cac1                	beqz	a3,80000a82 <copyout+0x90>
{
    800009f4:	711d                	addi	sp,sp,-96
    800009f6:	ec86                	sd	ra,88(sp)
    800009f8:	e8a2                	sd	s0,80(sp)
    800009fa:	e4a6                	sd	s1,72(sp)
    800009fc:	fc4e                	sd	s3,56(sp)
    800009fe:	f852                	sd	s4,48(sp)
    80000a00:	f456                	sd	s5,40(sp)
    80000a02:	f05a                	sd	s6,32(sp)
    80000a04:	1080                	addi	s0,sp,96
    80000a06:	8b2a                	mv	s6,a0
    80000a08:	8a2e                	mv	s4,a1
    80000a0a:	8ab2                	mv	s5,a2
    80000a0c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000a0e:	74fd                	lui	s1,0xfffff
    80000a10:	8ced                	and	s1,s1,a1
    if (va0 >= MAXVA)
    80000a12:	57fd                	li	a5,-1
    80000a14:	83e9                	srli	a5,a5,0x1a
    80000a16:	0697e863          	bltu	a5,s1,80000a86 <copyout+0x94>
    80000a1a:	e0ca                	sd	s2,64(sp)
    80000a1c:	ec5e                	sd	s7,24(sp)
    80000a1e:	e862                	sd	s8,16(sp)
    80000a20:	e466                	sd	s9,8(sp)
    80000a22:	6c05                	lui	s8,0x1
    80000a24:	8bbe                	mv	s7,a5
    80000a26:	a015                	j	80000a4a <copyout+0x58>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000a28:	409a04b3          	sub	s1,s4,s1
    80000a2c:	0009061b          	sext.w	a2,s2
    80000a30:	85d6                	mv	a1,s5
    80000a32:	9526                	add	a0,a0,s1
    80000a34:	f76ff0ef          	jal	800001aa <memmove>

    len -= n;
    80000a38:	412989b3          	sub	s3,s3,s2
    src += n;
    80000a3c:	9aca                	add	s5,s5,s2
  while(len > 0){
    80000a3e:	02098c63          	beqz	s3,80000a76 <copyout+0x84>
    if (va0 >= MAXVA)
    80000a42:	059be463          	bltu	s7,s9,80000a8a <copyout+0x98>
    80000a46:	84e6                	mv	s1,s9
    80000a48:	8a66                	mv	s4,s9
    if((pte = walk(pagetable, va0, 0)) == 0) {
    80000a4a:	4601                	li	a2,0
    80000a4c:	85a6                	mv	a1,s1
    80000a4e:	855a                	mv	a0,s6
    80000a50:	973ff0ef          	jal	800003c2 <walk>
    80000a54:	c129                	beqz	a0,80000a96 <copyout+0xa4>
    if((*pte & PTE_W) == 0)
    80000a56:	611c                	ld	a5,0(a0)
    80000a58:	8b91                	andi	a5,a5,4
    80000a5a:	cfa1                	beqz	a5,80000ab2 <copyout+0xc0>
    pa0 = walkaddr(pagetable, va0);
    80000a5c:	85a6                	mv	a1,s1
    80000a5e:	855a                	mv	a0,s6
    80000a60:	a07ff0ef          	jal	80000466 <walkaddr>
    if(pa0 == 0)
    80000a64:	cd29                	beqz	a0,80000abe <copyout+0xcc>
    n = PGSIZE - (dstva - va0);
    80000a66:	01848cb3          	add	s9,s1,s8
    80000a6a:	414c8933          	sub	s2,s9,s4
    if(n > len)
    80000a6e:	fb29fde3          	bgeu	s3,s2,80000a28 <copyout+0x36>
    80000a72:	894e                	mv	s2,s3
    80000a74:	bf55                	j	80000a28 <copyout+0x36>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80000a76:	4501                	li	a0,0
    80000a78:	6906                	ld	s2,64(sp)
    80000a7a:	6be2                	ld	s7,24(sp)
    80000a7c:	6c42                	ld	s8,16(sp)
    80000a7e:	6ca2                	ld	s9,8(sp)
    80000a80:	a005                	j	80000aa0 <copyout+0xae>
    80000a82:	4501                	li	a0,0
}
    80000a84:	8082                	ret
      return -1;
    80000a86:	557d                	li	a0,-1
    80000a88:	a821                	j	80000aa0 <copyout+0xae>
    80000a8a:	557d                	li	a0,-1
    80000a8c:	6906                	ld	s2,64(sp)
    80000a8e:	6be2                	ld	s7,24(sp)
    80000a90:	6c42                	ld	s8,16(sp)
    80000a92:	6ca2                	ld	s9,8(sp)
    80000a94:	a031                	j	80000aa0 <copyout+0xae>
      return -1;
    80000a96:	557d                	li	a0,-1
    80000a98:	6906                	ld	s2,64(sp)
    80000a9a:	6be2                	ld	s7,24(sp)
    80000a9c:	6c42                	ld	s8,16(sp)
    80000a9e:	6ca2                	ld	s9,8(sp)
}
    80000aa0:	60e6                	ld	ra,88(sp)
    80000aa2:	6446                	ld	s0,80(sp)
    80000aa4:	64a6                	ld	s1,72(sp)
    80000aa6:	79e2                	ld	s3,56(sp)
    80000aa8:	7a42                	ld	s4,48(sp)
    80000aaa:	7aa2                	ld	s5,40(sp)
    80000aac:	7b02                	ld	s6,32(sp)
    80000aae:	6125                	addi	sp,sp,96
    80000ab0:	8082                	ret
      return -1;
    80000ab2:	557d                	li	a0,-1
    80000ab4:	6906                	ld	s2,64(sp)
    80000ab6:	6be2                	ld	s7,24(sp)
    80000ab8:	6c42                	ld	s8,16(sp)
    80000aba:	6ca2                	ld	s9,8(sp)
    80000abc:	b7d5                	j	80000aa0 <copyout+0xae>
      return -1;
    80000abe:	557d                	li	a0,-1
    80000ac0:	6906                	ld	s2,64(sp)
    80000ac2:	6be2                	ld	s7,24(sp)
    80000ac4:	6c42                	ld	s8,16(sp)
    80000ac6:	6ca2                	ld	s9,8(sp)
    80000ac8:	bfe1                	j	80000aa0 <copyout+0xae>

0000000080000aca <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;
  
  while(len > 0){
    80000aca:	c6a5                	beqz	a3,80000b32 <copyin+0x68>
{
    80000acc:	715d                	addi	sp,sp,-80
    80000ace:	e486                	sd	ra,72(sp)
    80000ad0:	e0a2                	sd	s0,64(sp)
    80000ad2:	fc26                	sd	s1,56(sp)
    80000ad4:	f84a                	sd	s2,48(sp)
    80000ad6:	f44e                	sd	s3,40(sp)
    80000ad8:	f052                	sd	s4,32(sp)
    80000ada:	ec56                	sd	s5,24(sp)
    80000adc:	e85a                	sd	s6,16(sp)
    80000ade:	e45e                	sd	s7,8(sp)
    80000ae0:	e062                	sd	s8,0(sp)
    80000ae2:	0880                	addi	s0,sp,80
    80000ae4:	8b2a                	mv	s6,a0
    80000ae6:	8a2e                	mv	s4,a1
    80000ae8:	8c32                	mv	s8,a2
    80000aea:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000aec:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000aee:	6a85                	lui	s5,0x1
    80000af0:	a00d                	j	80000b12 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000af2:	018505b3          	add	a1,a0,s8
    80000af6:	0004861b          	sext.w	a2,s1
    80000afa:	412585b3          	sub	a1,a1,s2
    80000afe:	8552                	mv	a0,s4
    80000b00:	eaaff0ef          	jal	800001aa <memmove>

    len -= n;
    80000b04:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000b08:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000b0a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b0e:	02098063          	beqz	s3,80000b2e <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80000b12:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b16:	85ca                	mv	a1,s2
    80000b18:	855a                	mv	a0,s6
    80000b1a:	94dff0ef          	jal	80000466 <walkaddr>
    if(pa0 == 0)
    80000b1e:	cd01                	beqz	a0,80000b36 <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80000b20:	418904b3          	sub	s1,s2,s8
    80000b24:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b26:	fc99f6e3          	bgeu	s3,s1,80000af2 <copyin+0x28>
    80000b2a:	84ce                	mv	s1,s3
    80000b2c:	b7d9                	j	80000af2 <copyin+0x28>
  }
  return 0;
    80000b2e:	4501                	li	a0,0
    80000b30:	a021                	j	80000b38 <copyin+0x6e>
    80000b32:	4501                	li	a0,0
}
    80000b34:	8082                	ret
      return -1;
    80000b36:	557d                	li	a0,-1
}
    80000b38:	60a6                	ld	ra,72(sp)
    80000b3a:	6406                	ld	s0,64(sp)
    80000b3c:	74e2                	ld	s1,56(sp)
    80000b3e:	7942                	ld	s2,48(sp)
    80000b40:	79a2                	ld	s3,40(sp)
    80000b42:	7a02                	ld	s4,32(sp)
    80000b44:	6ae2                	ld	s5,24(sp)
    80000b46:	6b42                	ld	s6,16(sp)
    80000b48:	6ba2                	ld	s7,8(sp)
    80000b4a:	6c02                	ld	s8,0(sp)
    80000b4c:	6161                	addi	sp,sp,80
    80000b4e:	8082                	ret

0000000080000b50 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000b50:	c6dd                	beqz	a3,80000bfe <copyinstr+0xae>
{
    80000b52:	715d                	addi	sp,sp,-80
    80000b54:	e486                	sd	ra,72(sp)
    80000b56:	e0a2                	sd	s0,64(sp)
    80000b58:	fc26                	sd	s1,56(sp)
    80000b5a:	f84a                	sd	s2,48(sp)
    80000b5c:	f44e                	sd	s3,40(sp)
    80000b5e:	f052                	sd	s4,32(sp)
    80000b60:	ec56                	sd	s5,24(sp)
    80000b62:	e85a                	sd	s6,16(sp)
    80000b64:	e45e                	sd	s7,8(sp)
    80000b66:	0880                	addi	s0,sp,80
    80000b68:	8a2a                	mv	s4,a0
    80000b6a:	8b2e                	mv	s6,a1
    80000b6c:	8bb2                	mv	s7,a2
    80000b6e:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000b70:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b72:	6985                	lui	s3,0x1
    80000b74:	a825                	j	80000bac <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000b76:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000b7a:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000b7c:	37fd                	addiw	a5,a5,-1
    80000b7e:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000b82:	60a6                	ld	ra,72(sp)
    80000b84:	6406                	ld	s0,64(sp)
    80000b86:	74e2                	ld	s1,56(sp)
    80000b88:	7942                	ld	s2,48(sp)
    80000b8a:	79a2                	ld	s3,40(sp)
    80000b8c:	7a02                	ld	s4,32(sp)
    80000b8e:	6ae2                	ld	s5,24(sp)
    80000b90:	6b42                	ld	s6,16(sp)
    80000b92:	6ba2                	ld	s7,8(sp)
    80000b94:	6161                	addi	sp,sp,80
    80000b96:	8082                	ret
    80000b98:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000b9c:	9742                	add	a4,a4,a6
      --max;
    80000b9e:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000ba2:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000ba6:	04e58463          	beq	a1,a4,80000bee <copyinstr+0x9e>
{
    80000baa:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000bac:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000bb0:	85a6                	mv	a1,s1
    80000bb2:	8552                	mv	a0,s4
    80000bb4:	8b3ff0ef          	jal	80000466 <walkaddr>
    if(pa0 == 0)
    80000bb8:	cd0d                	beqz	a0,80000bf2 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000bba:	417486b3          	sub	a3,s1,s7
    80000bbe:	96ce                	add	a3,a3,s3
    if(n > max)
    80000bc0:	00d97363          	bgeu	s2,a3,80000bc6 <copyinstr+0x76>
    80000bc4:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000bc6:	955e                	add	a0,a0,s7
    80000bc8:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000bca:	c695                	beqz	a3,80000bf6 <copyinstr+0xa6>
    80000bcc:	87da                	mv	a5,s6
    80000bce:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000bd0:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000bd4:	96da                	add	a3,a3,s6
    80000bd6:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000bd8:	00f60733          	add	a4,a2,a5
    80000bdc:	00074703          	lbu	a4,0(a4)
    80000be0:	db59                	beqz	a4,80000b76 <copyinstr+0x26>
        *dst = *p;
    80000be2:	00e78023          	sb	a4,0(a5)
      dst++;
    80000be6:	0785                	addi	a5,a5,1
    while(n > 0){
    80000be8:	fed797e3          	bne	a5,a3,80000bd6 <copyinstr+0x86>
    80000bec:	b775                	j	80000b98 <copyinstr+0x48>
    80000bee:	4781                	li	a5,0
    80000bf0:	b771                	j	80000b7c <copyinstr+0x2c>
      return -1;
    80000bf2:	557d                	li	a0,-1
    80000bf4:	b779                	j	80000b82 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000bf6:	6b85                	lui	s7,0x1
    80000bf8:	9ba6                	add	s7,s7,s1
    80000bfa:	87da                	mv	a5,s6
    80000bfc:	b77d                	j	80000baa <copyinstr+0x5a>
  int got_null = 0;
    80000bfe:	4781                	li	a5,0
  if(got_null){
    80000c00:	37fd                	addiw	a5,a5,-1
    80000c02:	0007851b          	sext.w	a0,a5
}
    80000c06:	8082                	ret

0000000080000c08 <vmprint_helper>:


#ifdef LAB_PGTBL
void vmprint_helper(pagetable_t pagetable, int level) {
  if (pagetable == 0)
    80000c08:	c545                	beqz	a0,80000cb0 <vmprint_helper+0xa8>
void vmprint_helper(pagetable_t pagetable, int level) {
    80000c0a:	7159                	addi	sp,sp,-112
    80000c0c:	f486                	sd	ra,104(sp)
    80000c0e:	f0a2                	sd	s0,96(sp)
    80000c10:	eca6                	sd	s1,88(sp)
    80000c12:	e8ca                	sd	s2,80(sp)
    80000c14:	e4ce                	sd	s3,72(sp)
    80000c16:	e0d2                	sd	s4,64(sp)
    80000c18:	fc56                	sd	s5,56(sp)
    80000c1a:	f85a                	sd	s6,48(sp)
    80000c1c:	f45e                	sd	s7,40(sp)
    80000c1e:	f062                	sd	s8,32(sp)
    80000c20:	ec66                	sd	s9,24(sp)
    80000c22:	e86a                	sd	s10,16(sp)
    80000c24:	e46e                	sd	s11,8(sp)
    80000c26:	1880                	addi	s0,sp,112
    80000c28:	8a2a                	mv	s4,a0
    80000c2a:	8aae                	mv	s5,a1
      return;
  
  for (int i = 0; i < PGSIZE / sizeof(pte_t); i++) {
    80000c2c:	4981                	li	s3,0
          
          // Print indentation based on level
          for (int j = 0; j < level; j++)
                printf(" ..");

           printf("%d: pte %p pa %p\n", i, (void *)pte, (void *)pa);
    80000c2e:	00006c97          	auipc	s9,0x6
    80000c32:	582c8c93          	addi	s9,s9,1410 # 800071b0 <etext+0x1b0>
          
          if ((pte & (PTE_R | PTE_W | PTE_X)) == 0) { // If it's an intermediate page table
              vmprint_helper((pagetable_t)pa, level + 1);
    80000c36:	00158d9b          	addiw	s11,a1,1
          for (int j = 0; j < level; j++)
    80000c3a:	4d01                	li	s10,0
                printf(" ..");
    80000c3c:	00006b17          	auipc	s6,0x6
    80000c40:	56cb0b13          	addi	s6,s6,1388 # 800071a8 <etext+0x1a8>
  for (int i = 0; i < PGSIZE / sizeof(pte_t); i++) {
    80000c44:	20000c13          	li	s8,512
    80000c48:	a029                	j	80000c52 <vmprint_helper+0x4a>
    80000c4a:	2985                	addiw	s3,s3,1 # 1001 <_entry-0x7fffefff>
    80000c4c:	0a21                	addi	s4,s4,8
    80000c4e:	05898263          	beq	s3,s8,80000c92 <vmprint_helper+0x8a>
      pte_t pte = pagetable[i];
    80000c52:	000a3903          	ld	s2,0(s4)
      if (pte & PTE_V) { // Only print valid PTEs
    80000c56:	00197793          	andi	a5,s2,1
    80000c5a:	dbe5                	beqz	a5,80000c4a <vmprint_helper+0x42>
          uint64 pa = PTE2PA(pte);
    80000c5c:	00a95b93          	srli	s7,s2,0xa
    80000c60:	0bb2                	slli	s7,s7,0xc
          for (int j = 0; j < level; j++)
    80000c62:	01505963          	blez	s5,80000c74 <vmprint_helper+0x6c>
    80000c66:	84ea                	mv	s1,s10
                printf(" ..");
    80000c68:	855a                	mv	a0,s6
    80000c6a:	7a6040ef          	jal	80005410 <printf>
          for (int j = 0; j < level; j++)
    80000c6e:	2485                	addiw	s1,s1,1 # fffffffffffff001 <end+0xffffffff7ffde301>
    80000c70:	fe9a9ce3          	bne	s5,s1,80000c68 <vmprint_helper+0x60>
           printf("%d: pte %p pa %p\n", i, (void *)pte, (void *)pa);
    80000c74:	86de                	mv	a3,s7
    80000c76:	864a                	mv	a2,s2
    80000c78:	85ce                	mv	a1,s3
    80000c7a:	8566                	mv	a0,s9
    80000c7c:	794040ef          	jal	80005410 <printf>
          if ((pte & (PTE_R | PTE_W | PTE_X)) == 0) { // If it's an intermediate page table
    80000c80:	00e97913          	andi	s2,s2,14
    80000c84:	fc0913e3          	bnez	s2,80000c4a <vmprint_helper+0x42>
              vmprint_helper((pagetable_t)pa, level + 1);
    80000c88:	85ee                	mv	a1,s11
    80000c8a:	855e                	mv	a0,s7
    80000c8c:	f7dff0ef          	jal	80000c08 <vmprint_helper>
    80000c90:	bf6d                	j	80000c4a <vmprint_helper+0x42>
          }
      }
  }
}
    80000c92:	70a6                	ld	ra,104(sp)
    80000c94:	7406                	ld	s0,96(sp)
    80000c96:	64e6                	ld	s1,88(sp)
    80000c98:	6946                	ld	s2,80(sp)
    80000c9a:	69a6                	ld	s3,72(sp)
    80000c9c:	6a06                	ld	s4,64(sp)
    80000c9e:	7ae2                	ld	s5,56(sp)
    80000ca0:	7b42                	ld	s6,48(sp)
    80000ca2:	7ba2                	ld	s7,40(sp)
    80000ca4:	7c02                	ld	s8,32(sp)
    80000ca6:	6ce2                	ld	s9,24(sp)
    80000ca8:	6d42                	ld	s10,16(sp)
    80000caa:	6da2                	ld	s11,8(sp)
    80000cac:	6165                	addi	sp,sp,112
    80000cae:	8082                	ret
    80000cb0:	8082                	ret

0000000080000cb2 <vmprint>:
void vmprint(pagetable_t pagetable) {
    80000cb2:	1101                	addi	sp,sp,-32
    80000cb4:	ec06                	sd	ra,24(sp)
    80000cb6:	e822                	sd	s0,16(sp)
    80000cb8:	e426                	sd	s1,8(sp)
    80000cba:	1000                	addi	s0,sp,32
    80000cbc:	84aa                	mv	s1,a0
  printf("page table %p\n", pagetable);
    80000cbe:	85aa                	mv	a1,a0
    80000cc0:	00006517          	auipc	a0,0x6
    80000cc4:	50850513          	addi	a0,a0,1288 # 800071c8 <etext+0x1c8>
    80000cc8:	748040ef          	jal	80005410 <printf>
  vmprint_helper(pagetable, 1);
    80000ccc:	4585                	li	a1,1
    80000cce:	8526                	mv	a0,s1
    80000cd0:	f39ff0ef          	jal	80000c08 <vmprint_helper>
}
    80000cd4:	60e2                	ld	ra,24(sp)
    80000cd6:	6442                	ld	s0,16(sp)
    80000cd8:	64a2                	ld	s1,8(sp)
    80000cda:	6105                	addi	sp,sp,32
    80000cdc:	8082                	ret

0000000080000cde <pgpte>:



#ifdef LAB_PGTBL
pte_t*
pgpte(pagetable_t pagetable, uint64 va) {
    80000cde:	1141                	addi	sp,sp,-16
    80000ce0:	e406                	sd	ra,8(sp)
    80000ce2:	e022                	sd	s0,0(sp)
    80000ce4:	0800                	addi	s0,sp,16
  return walk(pagetable, va, 0);
    80000ce6:	4601                	li	a2,0
    80000ce8:	edaff0ef          	jal	800003c2 <walk>
}
    80000cec:	60a2                	ld	ra,8(sp)
    80000cee:	6402                	ld	s0,0(sp)
    80000cf0:	0141                	addi	sp,sp,16
    80000cf2:	8082                	ret

0000000080000cf4 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000cf4:	7139                	addi	sp,sp,-64
    80000cf6:	fc06                	sd	ra,56(sp)
    80000cf8:	f822                	sd	s0,48(sp)
    80000cfa:	f426                	sd	s1,40(sp)
    80000cfc:	f04a                	sd	s2,32(sp)
    80000cfe:	ec4e                	sd	s3,24(sp)
    80000d00:	e852                	sd	s4,16(sp)
    80000d02:	e456                	sd	s5,8(sp)
    80000d04:	e05a                	sd	s6,0(sp)
    80000d06:	0080                	addi	s0,sp,64
    80000d08:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d0a:	00007497          	auipc	s1,0x7
    80000d0e:	11648493          	addi	s1,s1,278 # 80007e20 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d12:	8b26                	mv	s6,s1
    80000d14:	04fa5937          	lui	s2,0x4fa5
    80000d18:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000d1c:	0932                	slli	s2,s2,0xc
    80000d1e:	fa590913          	addi	s2,s2,-91
    80000d22:	0932                	slli	s2,s2,0xc
    80000d24:	fa590913          	addi	s2,s2,-91
    80000d28:	0932                	slli	s2,s2,0xc
    80000d2a:	fa590913          	addi	s2,s2,-91
    80000d2e:	010009b7          	lui	s3,0x1000
    80000d32:	19fd                	addi	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80000d34:	09ba                	slli	s3,s3,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d36:	0000da97          	auipc	s5,0xd
    80000d3a:	aeaa8a93          	addi	s5,s5,-1302 # 8000d820 <tickslock>
    char *pa = kalloc();
    80000d3e:	bc0ff0ef          	jal	800000fe <kalloc>
    80000d42:	862a                	mv	a2,a0
    if(pa == 0)
    80000d44:	cd0d                	beqz	a0,80000d7e <proc_mapstacks+0x8a>
    uint64 va = KSTACK((int) (p - proc));
    80000d46:	416485b3          	sub	a1,s1,s6
    80000d4a:	858d                	srai	a1,a1,0x3
    80000d4c:	032585b3          	mul	a1,a1,s2
    80000d50:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d54:	4719                	li	a4,6
    80000d56:	6685                	lui	a3,0x1
    80000d58:	40b985b3          	sub	a1,s3,a1
    80000d5c:	8552                	mv	a0,s4
    80000d5e:	ff6ff0ef          	jal	80000554 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d62:	16848493          	addi	s1,s1,360
    80000d66:	fd549ce3          	bne	s1,s5,80000d3e <proc_mapstacks+0x4a>
  }
}
    80000d6a:	70e2                	ld	ra,56(sp)
    80000d6c:	7442                	ld	s0,48(sp)
    80000d6e:	74a2                	ld	s1,40(sp)
    80000d70:	7902                	ld	s2,32(sp)
    80000d72:	69e2                	ld	s3,24(sp)
    80000d74:	6a42                	ld	s4,16(sp)
    80000d76:	6aa2                	ld	s5,8(sp)
    80000d78:	6b02                	ld	s6,0(sp)
    80000d7a:	6121                	addi	sp,sp,64
    80000d7c:	8082                	ret
      panic("kalloc");
    80000d7e:	00006517          	auipc	a0,0x6
    80000d82:	45a50513          	addi	a0,a0,1114 # 800071d8 <etext+0x1d8>
    80000d86:	15d040ef          	jal	800056e2 <panic>

0000000080000d8a <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000d8a:	7139                	addi	sp,sp,-64
    80000d8c:	fc06                	sd	ra,56(sp)
    80000d8e:	f822                	sd	s0,48(sp)
    80000d90:	f426                	sd	s1,40(sp)
    80000d92:	f04a                	sd	s2,32(sp)
    80000d94:	ec4e                	sd	s3,24(sp)
    80000d96:	e852                	sd	s4,16(sp)
    80000d98:	e456                	sd	s5,8(sp)
    80000d9a:	e05a                	sd	s6,0(sp)
    80000d9c:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d9e:	00006597          	auipc	a1,0x6
    80000da2:	44258593          	addi	a1,a1,1090 # 800071e0 <etext+0x1e0>
    80000da6:	00007517          	auipc	a0,0x7
    80000daa:	c4a50513          	addi	a0,a0,-950 # 800079f0 <pid_lock>
    80000dae:	3e3040ef          	jal	80005990 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000db2:	00006597          	auipc	a1,0x6
    80000db6:	43658593          	addi	a1,a1,1078 # 800071e8 <etext+0x1e8>
    80000dba:	00007517          	auipc	a0,0x7
    80000dbe:	c4e50513          	addi	a0,a0,-946 # 80007a08 <wait_lock>
    80000dc2:	3cf040ef          	jal	80005990 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dc6:	00007497          	auipc	s1,0x7
    80000dca:	05a48493          	addi	s1,s1,90 # 80007e20 <proc>
      initlock(&p->lock, "proc");
    80000dce:	00006b17          	auipc	s6,0x6
    80000dd2:	42ab0b13          	addi	s6,s6,1066 # 800071f8 <etext+0x1f8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000dd6:	8aa6                	mv	s5,s1
    80000dd8:	04fa5937          	lui	s2,0x4fa5
    80000ddc:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000de0:	0932                	slli	s2,s2,0xc
    80000de2:	fa590913          	addi	s2,s2,-91
    80000de6:	0932                	slli	s2,s2,0xc
    80000de8:	fa590913          	addi	s2,s2,-91
    80000dec:	0932                	slli	s2,s2,0xc
    80000dee:	fa590913          	addi	s2,s2,-91
    80000df2:	010009b7          	lui	s3,0x1000
    80000df6:	19fd                	addi	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80000df8:	09ba                	slli	s3,s3,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dfa:	0000da17          	auipc	s4,0xd
    80000dfe:	a26a0a13          	addi	s4,s4,-1498 # 8000d820 <tickslock>
      initlock(&p->lock, "proc");
    80000e02:	85da                	mv	a1,s6
    80000e04:	8526                	mv	a0,s1
    80000e06:	38b040ef          	jal	80005990 <initlock>
      p->state = UNUSED;
    80000e0a:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000e0e:	415487b3          	sub	a5,s1,s5
    80000e12:	878d                	srai	a5,a5,0x3
    80000e14:	032787b3          	mul	a5,a5,s2
    80000e18:	00d7979b          	slliw	a5,a5,0xd
    80000e1c:	40f987b3          	sub	a5,s3,a5
    80000e20:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e22:	16848493          	addi	s1,s1,360
    80000e26:	fd449ee3          	bne	s1,s4,80000e02 <procinit+0x78>
  }
}
    80000e2a:	70e2                	ld	ra,56(sp)
    80000e2c:	7442                	ld	s0,48(sp)
    80000e2e:	74a2                	ld	s1,40(sp)
    80000e30:	7902                	ld	s2,32(sp)
    80000e32:	69e2                	ld	s3,24(sp)
    80000e34:	6a42                	ld	s4,16(sp)
    80000e36:	6aa2                	ld	s5,8(sp)
    80000e38:	6b02                	ld	s6,0(sp)
    80000e3a:	6121                	addi	sp,sp,64
    80000e3c:	8082                	ret

0000000080000e3e <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e3e:	1141                	addi	sp,sp,-16
    80000e40:	e422                	sd	s0,8(sp)
    80000e42:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e44:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e46:	2501                	sext.w	a0,a0
    80000e48:	6422                	ld	s0,8(sp)
    80000e4a:	0141                	addi	sp,sp,16
    80000e4c:	8082                	ret

0000000080000e4e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e4e:	1141                	addi	sp,sp,-16
    80000e50:	e422                	sd	s0,8(sp)
    80000e52:	0800                	addi	s0,sp,16
    80000e54:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e56:	2781                	sext.w	a5,a5
    80000e58:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e5a:	00007517          	auipc	a0,0x7
    80000e5e:	bc650513          	addi	a0,a0,-1082 # 80007a20 <cpus>
    80000e62:	953e                	add	a0,a0,a5
    80000e64:	6422                	ld	s0,8(sp)
    80000e66:	0141                	addi	sp,sp,16
    80000e68:	8082                	ret

0000000080000e6a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000e6a:	1101                	addi	sp,sp,-32
    80000e6c:	ec06                	sd	ra,24(sp)
    80000e6e:	e822                	sd	s0,16(sp)
    80000e70:	e426                	sd	s1,8(sp)
    80000e72:	1000                	addi	s0,sp,32
  push_off();
    80000e74:	35d040ef          	jal	800059d0 <push_off>
    80000e78:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e7a:	2781                	sext.w	a5,a5
    80000e7c:	079e                	slli	a5,a5,0x7
    80000e7e:	00007717          	auipc	a4,0x7
    80000e82:	b7270713          	addi	a4,a4,-1166 # 800079f0 <pid_lock>
    80000e86:	97ba                	add	a5,a5,a4
    80000e88:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e8a:	3cb040ef          	jal	80005a54 <pop_off>
  return p;
}
    80000e8e:	8526                	mv	a0,s1
    80000e90:	60e2                	ld	ra,24(sp)
    80000e92:	6442                	ld	s0,16(sp)
    80000e94:	64a2                	ld	s1,8(sp)
    80000e96:	6105                	addi	sp,sp,32
    80000e98:	8082                	ret

0000000080000e9a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e9a:	1141                	addi	sp,sp,-16
    80000e9c:	e406                	sd	ra,8(sp)
    80000e9e:	e022                	sd	s0,0(sp)
    80000ea0:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000ea2:	fc9ff0ef          	jal	80000e6a <myproc>
    80000ea6:	403040ef          	jal	80005aa8 <release>

  if (first) {
    80000eaa:	00007797          	auipc	a5,0x7
    80000eae:	aa67a783          	lw	a5,-1370(a5) # 80007950 <first.1>
    80000eb2:	e799                	bnez	a5,80000ec0 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000eb4:	2bf000ef          	jal	80001972 <usertrapret>
}
    80000eb8:	60a2                	ld	ra,8(sp)
    80000eba:	6402                	ld	s0,0(sp)
    80000ebc:	0141                	addi	sp,sp,16
    80000ebe:	8082                	ret
    fsinit(ROOTDEV);
    80000ec0:	4505                	li	a0,1
    80000ec2:	76c010ef          	jal	8000262e <fsinit>
    first = 0;
    80000ec6:	00007797          	auipc	a5,0x7
    80000eca:	a807a523          	sw	zero,-1398(a5) # 80007950 <first.1>
    __sync_synchronize();
    80000ece:	0ff0000f          	fence
    80000ed2:	b7cd                	j	80000eb4 <forkret+0x1a>

0000000080000ed4 <allocpid>:
{
    80000ed4:	1101                	addi	sp,sp,-32
    80000ed6:	ec06                	sd	ra,24(sp)
    80000ed8:	e822                	sd	s0,16(sp)
    80000eda:	e426                	sd	s1,8(sp)
    80000edc:	e04a                	sd	s2,0(sp)
    80000ede:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ee0:	00007917          	auipc	s2,0x7
    80000ee4:	b1090913          	addi	s2,s2,-1264 # 800079f0 <pid_lock>
    80000ee8:	854a                	mv	a0,s2
    80000eea:	327040ef          	jal	80005a10 <acquire>
  pid = nextpid;
    80000eee:	00007797          	auipc	a5,0x7
    80000ef2:	a6678793          	addi	a5,a5,-1434 # 80007954 <nextpid>
    80000ef6:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ef8:	0014871b          	addiw	a4,s1,1
    80000efc:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000efe:	854a                	mv	a0,s2
    80000f00:	3a9040ef          	jal	80005aa8 <release>
}
    80000f04:	8526                	mv	a0,s1
    80000f06:	60e2                	ld	ra,24(sp)
    80000f08:	6442                	ld	s0,16(sp)
    80000f0a:	64a2                	ld	s1,8(sp)
    80000f0c:	6902                	ld	s2,0(sp)
    80000f0e:	6105                	addi	sp,sp,32
    80000f10:	8082                	ret

0000000080000f12 <proc_pagetable>:
{
    80000f12:	1101                	addi	sp,sp,-32
    80000f14:	ec06                	sd	ra,24(sp)
    80000f16:	e822                	sd	s0,16(sp)
    80000f18:	e426                	sd	s1,8(sp)
    80000f1a:	e04a                	sd	s2,0(sp)
    80000f1c:	1000                	addi	s0,sp,32
    80000f1e:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f20:	ff6ff0ef          	jal	80000716 <uvmcreate>
    80000f24:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f26:	cd05                	beqz	a0,80000f5e <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f28:	4729                	li	a4,10
    80000f2a:	00005697          	auipc	a3,0x5
    80000f2e:	0d668693          	addi	a3,a3,214 # 80006000 <_trampoline>
    80000f32:	6605                	lui	a2,0x1
    80000f34:	040005b7          	lui	a1,0x4000
    80000f38:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f3a:	05b2                	slli	a1,a1,0xc
    80000f3c:	d68ff0ef          	jal	800004a4 <mappages>
    80000f40:	02054663          	bltz	a0,80000f6c <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f44:	4719                	li	a4,6
    80000f46:	05893683          	ld	a3,88(s2)
    80000f4a:	6605                	lui	a2,0x1
    80000f4c:	020005b7          	lui	a1,0x2000
    80000f50:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f52:	05b6                	slli	a1,a1,0xd
    80000f54:	8526                	mv	a0,s1
    80000f56:	d4eff0ef          	jal	800004a4 <mappages>
    80000f5a:	00054f63          	bltz	a0,80000f78 <proc_pagetable+0x66>
}
    80000f5e:	8526                	mv	a0,s1
    80000f60:	60e2                	ld	ra,24(sp)
    80000f62:	6442                	ld	s0,16(sp)
    80000f64:	64a2                	ld	s1,8(sp)
    80000f66:	6902                	ld	s2,0(sp)
    80000f68:	6105                	addi	sp,sp,32
    80000f6a:	8082                	ret
    uvmfree(pagetable, 0);
    80000f6c:	4581                	li	a1,0
    80000f6e:	8526                	mv	a0,s1
    80000f70:	975ff0ef          	jal	800008e4 <uvmfree>
    return 0;
    80000f74:	4481                	li	s1,0
    80000f76:	b7e5                	j	80000f5e <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f78:	4681                	li	a3,0
    80000f7a:	4605                	li	a2,1
    80000f7c:	040005b7          	lui	a1,0x4000
    80000f80:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f82:	05b2                	slli	a1,a1,0xc
    80000f84:	8526                	mv	a0,s1
    80000f86:	ec4ff0ef          	jal	8000064a <uvmunmap>
    uvmfree(pagetable, 0);
    80000f8a:	4581                	li	a1,0
    80000f8c:	8526                	mv	a0,s1
    80000f8e:	957ff0ef          	jal	800008e4 <uvmfree>
    return 0;
    80000f92:	4481                	li	s1,0
    80000f94:	b7e9                	j	80000f5e <proc_pagetable+0x4c>

0000000080000f96 <proc_freepagetable>:
{
    80000f96:	1101                	addi	sp,sp,-32
    80000f98:	ec06                	sd	ra,24(sp)
    80000f9a:	e822                	sd	s0,16(sp)
    80000f9c:	e426                	sd	s1,8(sp)
    80000f9e:	e04a                	sd	s2,0(sp)
    80000fa0:	1000                	addi	s0,sp,32
    80000fa2:	84aa                	mv	s1,a0
    80000fa4:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fa6:	4681                	li	a3,0
    80000fa8:	4605                	li	a2,1
    80000faa:	040005b7          	lui	a1,0x4000
    80000fae:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fb0:	05b2                	slli	a1,a1,0xc
    80000fb2:	e98ff0ef          	jal	8000064a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fb6:	4681                	li	a3,0
    80000fb8:	4605                	li	a2,1
    80000fba:	020005b7          	lui	a1,0x2000
    80000fbe:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fc0:	05b6                	slli	a1,a1,0xd
    80000fc2:	8526                	mv	a0,s1
    80000fc4:	e86ff0ef          	jal	8000064a <uvmunmap>
  uvmfree(pagetable, sz);
    80000fc8:	85ca                	mv	a1,s2
    80000fca:	8526                	mv	a0,s1
    80000fcc:	919ff0ef          	jal	800008e4 <uvmfree>
}
    80000fd0:	60e2                	ld	ra,24(sp)
    80000fd2:	6442                	ld	s0,16(sp)
    80000fd4:	64a2                	ld	s1,8(sp)
    80000fd6:	6902                	ld	s2,0(sp)
    80000fd8:	6105                	addi	sp,sp,32
    80000fda:	8082                	ret

0000000080000fdc <freeproc>:
{
    80000fdc:	1101                	addi	sp,sp,-32
    80000fde:	ec06                	sd	ra,24(sp)
    80000fe0:	e822                	sd	s0,16(sp)
    80000fe2:	e426                	sd	s1,8(sp)
    80000fe4:	1000                	addi	s0,sp,32
    80000fe6:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000fe8:	6d28                	ld	a0,88(a0)
    80000fea:	c119                	beqz	a0,80000ff0 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000fec:	830ff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000ff0:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000ff4:	68a8                	ld	a0,80(s1)
    80000ff6:	c501                	beqz	a0,80000ffe <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000ff8:	64ac                	ld	a1,72(s1)
    80000ffa:	f9dff0ef          	jal	80000f96 <proc_freepagetable>
  p->pagetable = 0;
    80000ffe:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001002:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001006:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000100a:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000100e:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001012:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001016:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000101a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000101e:	0004ac23          	sw	zero,24(s1)
}
    80001022:	60e2                	ld	ra,24(sp)
    80001024:	6442                	ld	s0,16(sp)
    80001026:	64a2                	ld	s1,8(sp)
    80001028:	6105                	addi	sp,sp,32
    8000102a:	8082                	ret

000000008000102c <allocproc>:
{
    8000102c:	1101                	addi	sp,sp,-32
    8000102e:	ec06                	sd	ra,24(sp)
    80001030:	e822                	sd	s0,16(sp)
    80001032:	e426                	sd	s1,8(sp)
    80001034:	e04a                	sd	s2,0(sp)
    80001036:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001038:	00007497          	auipc	s1,0x7
    8000103c:	de848493          	addi	s1,s1,-536 # 80007e20 <proc>
    80001040:	0000c917          	auipc	s2,0xc
    80001044:	7e090913          	addi	s2,s2,2016 # 8000d820 <tickslock>
    acquire(&p->lock);
    80001048:	8526                	mv	a0,s1
    8000104a:	1c7040ef          	jal	80005a10 <acquire>
    if(p->state == UNUSED) {
    8000104e:	4c9c                	lw	a5,24(s1)
    80001050:	cb91                	beqz	a5,80001064 <allocproc+0x38>
      release(&p->lock);
    80001052:	8526                	mv	a0,s1
    80001054:	255040ef          	jal	80005aa8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001058:	16848493          	addi	s1,s1,360
    8000105c:	ff2496e3          	bne	s1,s2,80001048 <allocproc+0x1c>
  return 0;
    80001060:	4481                	li	s1,0
    80001062:	a089                	j	800010a4 <allocproc+0x78>
  p->pid = allocpid();
    80001064:	e71ff0ef          	jal	80000ed4 <allocpid>
    80001068:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000106a:	4785                	li	a5,1
    8000106c:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000106e:	890ff0ef          	jal	800000fe <kalloc>
    80001072:	892a                	mv	s2,a0
    80001074:	eca8                	sd	a0,88(s1)
    80001076:	cd15                	beqz	a0,800010b2 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001078:	8526                	mv	a0,s1
    8000107a:	e99ff0ef          	jal	80000f12 <proc_pagetable>
    8000107e:	892a                	mv	s2,a0
    80001080:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001082:	c121                	beqz	a0,800010c2 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001084:	07000613          	li	a2,112
    80001088:	4581                	li	a1,0
    8000108a:	06048513          	addi	a0,s1,96
    8000108e:	8c0ff0ef          	jal	8000014e <memset>
  p->context.ra = (uint64)forkret;
    80001092:	00000797          	auipc	a5,0x0
    80001096:	e0878793          	addi	a5,a5,-504 # 80000e9a <forkret>
    8000109a:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000109c:	60bc                	ld	a5,64(s1)
    8000109e:	6705                	lui	a4,0x1
    800010a0:	97ba                	add	a5,a5,a4
    800010a2:	f4bc                	sd	a5,104(s1)
}
    800010a4:	8526                	mv	a0,s1
    800010a6:	60e2                	ld	ra,24(sp)
    800010a8:	6442                	ld	s0,16(sp)
    800010aa:	64a2                	ld	s1,8(sp)
    800010ac:	6902                	ld	s2,0(sp)
    800010ae:	6105                	addi	sp,sp,32
    800010b0:	8082                	ret
    freeproc(p);
    800010b2:	8526                	mv	a0,s1
    800010b4:	f29ff0ef          	jal	80000fdc <freeproc>
    release(&p->lock);
    800010b8:	8526                	mv	a0,s1
    800010ba:	1ef040ef          	jal	80005aa8 <release>
    return 0;
    800010be:	84ca                	mv	s1,s2
    800010c0:	b7d5                	j	800010a4 <allocproc+0x78>
    freeproc(p);
    800010c2:	8526                	mv	a0,s1
    800010c4:	f19ff0ef          	jal	80000fdc <freeproc>
    release(&p->lock);
    800010c8:	8526                	mv	a0,s1
    800010ca:	1df040ef          	jal	80005aa8 <release>
    return 0;
    800010ce:	84ca                	mv	s1,s2
    800010d0:	bfd1                	j	800010a4 <allocproc+0x78>

00000000800010d2 <userinit>:
{
    800010d2:	1101                	addi	sp,sp,-32
    800010d4:	ec06                	sd	ra,24(sp)
    800010d6:	e822                	sd	s0,16(sp)
    800010d8:	e426                	sd	s1,8(sp)
    800010da:	1000                	addi	s0,sp,32
  p = allocproc();
    800010dc:	f51ff0ef          	jal	8000102c <allocproc>
    800010e0:	84aa                	mv	s1,a0
  initproc = p;
    800010e2:	00007797          	auipc	a5,0x7
    800010e6:	8ca7b723          	sd	a0,-1842(a5) # 800079b0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800010ea:	03400613          	li	a2,52
    800010ee:	00007597          	auipc	a1,0x7
    800010f2:	87258593          	addi	a1,a1,-1934 # 80007960 <initcode>
    800010f6:	6928                	ld	a0,80(a0)
    800010f8:	e44ff0ef          	jal	8000073c <uvmfirst>
  p->sz = PGSIZE;
    800010fc:	6785                	lui	a5,0x1
    800010fe:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001100:	6cb8                	ld	a4,88(s1)
    80001102:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001106:	6cb8                	ld	a4,88(s1)
    80001108:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000110a:	4641                	li	a2,16
    8000110c:	00006597          	auipc	a1,0x6
    80001110:	0f458593          	addi	a1,a1,244 # 80007200 <etext+0x200>
    80001114:	15848513          	addi	a0,s1,344
    80001118:	974ff0ef          	jal	8000028c <safestrcpy>
  p->cwd = namei("/");
    8000111c:	00006517          	auipc	a0,0x6
    80001120:	0f450513          	addi	a0,a0,244 # 80007210 <etext+0x210>
    80001124:	619010ef          	jal	80002f3c <namei>
    80001128:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000112c:	478d                	li	a5,3
    8000112e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001130:	8526                	mv	a0,s1
    80001132:	177040ef          	jal	80005aa8 <release>
}
    80001136:	60e2                	ld	ra,24(sp)
    80001138:	6442                	ld	s0,16(sp)
    8000113a:	64a2                	ld	s1,8(sp)
    8000113c:	6105                	addi	sp,sp,32
    8000113e:	8082                	ret

0000000080001140 <growproc>:
{
    80001140:	1101                	addi	sp,sp,-32
    80001142:	ec06                	sd	ra,24(sp)
    80001144:	e822                	sd	s0,16(sp)
    80001146:	e426                	sd	s1,8(sp)
    80001148:	e04a                	sd	s2,0(sp)
    8000114a:	1000                	addi	s0,sp,32
    8000114c:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000114e:	d1dff0ef          	jal	80000e6a <myproc>
    80001152:	84aa                	mv	s1,a0
  sz = p->sz;
    80001154:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001156:	01204c63          	bgtz	s2,8000116e <growproc+0x2e>
  } else if(n < 0){
    8000115a:	02094463          	bltz	s2,80001182 <growproc+0x42>
  p->sz = sz;
    8000115e:	e4ac                	sd	a1,72(s1)
  return 0;
    80001160:	4501                	li	a0,0
}
    80001162:	60e2                	ld	ra,24(sp)
    80001164:	6442                	ld	s0,16(sp)
    80001166:	64a2                	ld	s1,8(sp)
    80001168:	6902                	ld	s2,0(sp)
    8000116a:	6105                	addi	sp,sp,32
    8000116c:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000116e:	4691                	li	a3,4
    80001170:	00b90633          	add	a2,s2,a1
    80001174:	6928                	ld	a0,80(a0)
    80001176:	e68ff0ef          	jal	800007de <uvmalloc>
    8000117a:	85aa                	mv	a1,a0
    8000117c:	f16d                	bnez	a0,8000115e <growproc+0x1e>
      return -1;
    8000117e:	557d                	li	a0,-1
    80001180:	b7cd                	j	80001162 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001182:	00b90633          	add	a2,s2,a1
    80001186:	6928                	ld	a0,80(a0)
    80001188:	e12ff0ef          	jal	8000079a <uvmdealloc>
    8000118c:	85aa                	mv	a1,a0
    8000118e:	bfc1                	j	8000115e <growproc+0x1e>

0000000080001190 <fork>:
{
    80001190:	7139                	addi	sp,sp,-64
    80001192:	fc06                	sd	ra,56(sp)
    80001194:	f822                	sd	s0,48(sp)
    80001196:	f04a                	sd	s2,32(sp)
    80001198:	e456                	sd	s5,8(sp)
    8000119a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000119c:	ccfff0ef          	jal	80000e6a <myproc>
    800011a0:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800011a2:	e8bff0ef          	jal	8000102c <allocproc>
    800011a6:	0e050a63          	beqz	a0,8000129a <fork+0x10a>
    800011aa:	e852                	sd	s4,16(sp)
    800011ac:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800011ae:	048ab603          	ld	a2,72(s5)
    800011b2:	692c                	ld	a1,80(a0)
    800011b4:	050ab503          	ld	a0,80(s5)
    800011b8:	f5eff0ef          	jal	80000916 <uvmcopy>
    800011bc:	04054a63          	bltz	a0,80001210 <fork+0x80>
    800011c0:	f426                	sd	s1,40(sp)
    800011c2:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800011c4:	048ab783          	ld	a5,72(s5)
    800011c8:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800011cc:	058ab683          	ld	a3,88(s5)
    800011d0:	87b6                	mv	a5,a3
    800011d2:	058a3703          	ld	a4,88(s4)
    800011d6:	12068693          	addi	a3,a3,288
    800011da:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800011de:	6788                	ld	a0,8(a5)
    800011e0:	6b8c                	ld	a1,16(a5)
    800011e2:	6f90                	ld	a2,24(a5)
    800011e4:	01073023          	sd	a6,0(a4)
    800011e8:	e708                	sd	a0,8(a4)
    800011ea:	eb0c                	sd	a1,16(a4)
    800011ec:	ef10                	sd	a2,24(a4)
    800011ee:	02078793          	addi	a5,a5,32
    800011f2:	02070713          	addi	a4,a4,32
    800011f6:	fed792e3          	bne	a5,a3,800011da <fork+0x4a>
  np->trapframe->a0 = 0;
    800011fa:	058a3783          	ld	a5,88(s4)
    800011fe:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001202:	0d0a8493          	addi	s1,s5,208
    80001206:	0d0a0913          	addi	s2,s4,208
    8000120a:	150a8993          	addi	s3,s5,336
    8000120e:	a831                	j	8000122a <fork+0x9a>
    freeproc(np);
    80001210:	8552                	mv	a0,s4
    80001212:	dcbff0ef          	jal	80000fdc <freeproc>
    release(&np->lock);
    80001216:	8552                	mv	a0,s4
    80001218:	091040ef          	jal	80005aa8 <release>
    return -1;
    8000121c:	597d                	li	s2,-1
    8000121e:	6a42                	ld	s4,16(sp)
    80001220:	a0b5                	j	8000128c <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001222:	04a1                	addi	s1,s1,8
    80001224:	0921                	addi	s2,s2,8
    80001226:	01348963          	beq	s1,s3,80001238 <fork+0xa8>
    if(p->ofile[i])
    8000122a:	6088                	ld	a0,0(s1)
    8000122c:	d97d                	beqz	a0,80001222 <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    8000122e:	29e020ef          	jal	800034cc <filedup>
    80001232:	00a93023          	sd	a0,0(s2)
    80001236:	b7f5                	j	80001222 <fork+0x92>
  np->cwd = idup(p->cwd);
    80001238:	150ab503          	ld	a0,336(s5)
    8000123c:	5f0010ef          	jal	8000282c <idup>
    80001240:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001244:	4641                	li	a2,16
    80001246:	158a8593          	addi	a1,s5,344
    8000124a:	158a0513          	addi	a0,s4,344
    8000124e:	83eff0ef          	jal	8000028c <safestrcpy>
  pid = np->pid;
    80001252:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001256:	8552                	mv	a0,s4
    80001258:	051040ef          	jal	80005aa8 <release>
  acquire(&wait_lock);
    8000125c:	00006497          	auipc	s1,0x6
    80001260:	7ac48493          	addi	s1,s1,1964 # 80007a08 <wait_lock>
    80001264:	8526                	mv	a0,s1
    80001266:	7aa040ef          	jal	80005a10 <acquire>
  np->parent = p;
    8000126a:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000126e:	8526                	mv	a0,s1
    80001270:	039040ef          	jal	80005aa8 <release>
  acquire(&np->lock);
    80001274:	8552                	mv	a0,s4
    80001276:	79a040ef          	jal	80005a10 <acquire>
  np->state = RUNNABLE;
    8000127a:	478d                	li	a5,3
    8000127c:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001280:	8552                	mv	a0,s4
    80001282:	027040ef          	jal	80005aa8 <release>
  return pid;
    80001286:	74a2                	ld	s1,40(sp)
    80001288:	69e2                	ld	s3,24(sp)
    8000128a:	6a42                	ld	s4,16(sp)
}
    8000128c:	854a                	mv	a0,s2
    8000128e:	70e2                	ld	ra,56(sp)
    80001290:	7442                	ld	s0,48(sp)
    80001292:	7902                	ld	s2,32(sp)
    80001294:	6aa2                	ld	s5,8(sp)
    80001296:	6121                	addi	sp,sp,64
    80001298:	8082                	ret
    return -1;
    8000129a:	597d                	li	s2,-1
    8000129c:	bfc5                	j	8000128c <fork+0xfc>

000000008000129e <scheduler>:
{
    8000129e:	715d                	addi	sp,sp,-80
    800012a0:	e486                	sd	ra,72(sp)
    800012a2:	e0a2                	sd	s0,64(sp)
    800012a4:	fc26                	sd	s1,56(sp)
    800012a6:	f84a                	sd	s2,48(sp)
    800012a8:	f44e                	sd	s3,40(sp)
    800012aa:	f052                	sd	s4,32(sp)
    800012ac:	ec56                	sd	s5,24(sp)
    800012ae:	e85a                	sd	s6,16(sp)
    800012b0:	e45e                	sd	s7,8(sp)
    800012b2:	e062                	sd	s8,0(sp)
    800012b4:	0880                	addi	s0,sp,80
    800012b6:	8792                	mv	a5,tp
  int id = r_tp();
    800012b8:	2781                	sext.w	a5,a5
  c->proc = 0;
    800012ba:	00779b13          	slli	s6,a5,0x7
    800012be:	00006717          	auipc	a4,0x6
    800012c2:	73270713          	addi	a4,a4,1842 # 800079f0 <pid_lock>
    800012c6:	975a                	add	a4,a4,s6
    800012c8:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800012cc:	00006717          	auipc	a4,0x6
    800012d0:	75c70713          	addi	a4,a4,1884 # 80007a28 <cpus+0x8>
    800012d4:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    800012d6:	4c11                	li	s8,4
        c->proc = p;
    800012d8:	079e                	slli	a5,a5,0x7
    800012da:	00006a17          	auipc	s4,0x6
    800012de:	716a0a13          	addi	s4,s4,1814 # 800079f0 <pid_lock>
    800012e2:	9a3e                	add	s4,s4,a5
        found = 1;
    800012e4:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    800012e6:	0000c997          	auipc	s3,0xc
    800012ea:	53a98993          	addi	s3,s3,1338 # 8000d820 <tickslock>
    800012ee:	a0a9                	j	80001338 <scheduler+0x9a>
      release(&p->lock);
    800012f0:	8526                	mv	a0,s1
    800012f2:	7b6040ef          	jal	80005aa8 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800012f6:	16848493          	addi	s1,s1,360
    800012fa:	03348563          	beq	s1,s3,80001324 <scheduler+0x86>
      acquire(&p->lock);
    800012fe:	8526                	mv	a0,s1
    80001300:	710040ef          	jal	80005a10 <acquire>
      if(p->state == RUNNABLE) {
    80001304:	4c9c                	lw	a5,24(s1)
    80001306:	ff2795e3          	bne	a5,s2,800012f0 <scheduler+0x52>
        p->state = RUNNING;
    8000130a:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    8000130e:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001312:	06048593          	addi	a1,s1,96
    80001316:	855a                	mv	a0,s6
    80001318:	5b4000ef          	jal	800018cc <swtch>
        c->proc = 0;
    8000131c:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001320:	8ade                	mv	s5,s7
    80001322:	b7f9                	j	800012f0 <scheduler+0x52>
    if(found == 0) {
    80001324:	000a9a63          	bnez	s5,80001338 <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001328:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000132c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001330:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001334:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001338:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000133c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001340:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001344:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001346:	00007497          	auipc	s1,0x7
    8000134a:	ada48493          	addi	s1,s1,-1318 # 80007e20 <proc>
      if(p->state == RUNNABLE) {
    8000134e:	490d                	li	s2,3
    80001350:	b77d                	j	800012fe <scheduler+0x60>

0000000080001352 <sched>:
{
    80001352:	7179                	addi	sp,sp,-48
    80001354:	f406                	sd	ra,40(sp)
    80001356:	f022                	sd	s0,32(sp)
    80001358:	ec26                	sd	s1,24(sp)
    8000135a:	e84a                	sd	s2,16(sp)
    8000135c:	e44e                	sd	s3,8(sp)
    8000135e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001360:	b0bff0ef          	jal	80000e6a <myproc>
    80001364:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001366:	640040ef          	jal	800059a6 <holding>
    8000136a:	c92d                	beqz	a0,800013dc <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000136c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000136e:	2781                	sext.w	a5,a5
    80001370:	079e                	slli	a5,a5,0x7
    80001372:	00006717          	auipc	a4,0x6
    80001376:	67e70713          	addi	a4,a4,1662 # 800079f0 <pid_lock>
    8000137a:	97ba                	add	a5,a5,a4
    8000137c:	0a87a703          	lw	a4,168(a5)
    80001380:	4785                	li	a5,1
    80001382:	06f71363          	bne	a4,a5,800013e8 <sched+0x96>
  if(p->state == RUNNING)
    80001386:	4c98                	lw	a4,24(s1)
    80001388:	4791                	li	a5,4
    8000138a:	06f70563          	beq	a4,a5,800013f4 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000138e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001392:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001394:	e7b5                	bnez	a5,80001400 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001396:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001398:	00006917          	auipc	s2,0x6
    8000139c:	65890913          	addi	s2,s2,1624 # 800079f0 <pid_lock>
    800013a0:	2781                	sext.w	a5,a5
    800013a2:	079e                	slli	a5,a5,0x7
    800013a4:	97ca                	add	a5,a5,s2
    800013a6:	0ac7a983          	lw	s3,172(a5)
    800013aa:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800013ac:	2781                	sext.w	a5,a5
    800013ae:	079e                	slli	a5,a5,0x7
    800013b0:	00006597          	auipc	a1,0x6
    800013b4:	67858593          	addi	a1,a1,1656 # 80007a28 <cpus+0x8>
    800013b8:	95be                	add	a1,a1,a5
    800013ba:	06048513          	addi	a0,s1,96
    800013be:	50e000ef          	jal	800018cc <swtch>
    800013c2:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800013c4:	2781                	sext.w	a5,a5
    800013c6:	079e                	slli	a5,a5,0x7
    800013c8:	993e                	add	s2,s2,a5
    800013ca:	0b392623          	sw	s3,172(s2)
}
    800013ce:	70a2                	ld	ra,40(sp)
    800013d0:	7402                	ld	s0,32(sp)
    800013d2:	64e2                	ld	s1,24(sp)
    800013d4:	6942                	ld	s2,16(sp)
    800013d6:	69a2                	ld	s3,8(sp)
    800013d8:	6145                	addi	sp,sp,48
    800013da:	8082                	ret
    panic("sched p->lock");
    800013dc:	00006517          	auipc	a0,0x6
    800013e0:	e3c50513          	addi	a0,a0,-452 # 80007218 <etext+0x218>
    800013e4:	2fe040ef          	jal	800056e2 <panic>
    panic("sched locks");
    800013e8:	00006517          	auipc	a0,0x6
    800013ec:	e4050513          	addi	a0,a0,-448 # 80007228 <etext+0x228>
    800013f0:	2f2040ef          	jal	800056e2 <panic>
    panic("sched running");
    800013f4:	00006517          	auipc	a0,0x6
    800013f8:	e4450513          	addi	a0,a0,-444 # 80007238 <etext+0x238>
    800013fc:	2e6040ef          	jal	800056e2 <panic>
    panic("sched interruptible");
    80001400:	00006517          	auipc	a0,0x6
    80001404:	e4850513          	addi	a0,a0,-440 # 80007248 <etext+0x248>
    80001408:	2da040ef          	jal	800056e2 <panic>

000000008000140c <yield>:
{
    8000140c:	1101                	addi	sp,sp,-32
    8000140e:	ec06                	sd	ra,24(sp)
    80001410:	e822                	sd	s0,16(sp)
    80001412:	e426                	sd	s1,8(sp)
    80001414:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001416:	a55ff0ef          	jal	80000e6a <myproc>
    8000141a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000141c:	5f4040ef          	jal	80005a10 <acquire>
  p->state = RUNNABLE;
    80001420:	478d                	li	a5,3
    80001422:	cc9c                	sw	a5,24(s1)
  sched();
    80001424:	f2fff0ef          	jal	80001352 <sched>
  release(&p->lock);
    80001428:	8526                	mv	a0,s1
    8000142a:	67e040ef          	jal	80005aa8 <release>
}
    8000142e:	60e2                	ld	ra,24(sp)
    80001430:	6442                	ld	s0,16(sp)
    80001432:	64a2                	ld	s1,8(sp)
    80001434:	6105                	addi	sp,sp,32
    80001436:	8082                	ret

0000000080001438 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001438:	7179                	addi	sp,sp,-48
    8000143a:	f406                	sd	ra,40(sp)
    8000143c:	f022                	sd	s0,32(sp)
    8000143e:	ec26                	sd	s1,24(sp)
    80001440:	e84a                	sd	s2,16(sp)
    80001442:	e44e                	sd	s3,8(sp)
    80001444:	1800                	addi	s0,sp,48
    80001446:	89aa                	mv	s3,a0
    80001448:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000144a:	a21ff0ef          	jal	80000e6a <myproc>
    8000144e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001450:	5c0040ef          	jal	80005a10 <acquire>
  release(lk);
    80001454:	854a                	mv	a0,s2
    80001456:	652040ef          	jal	80005aa8 <release>

  // Go to sleep.
  p->chan = chan;
    8000145a:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000145e:	4789                	li	a5,2
    80001460:	cc9c                	sw	a5,24(s1)

  sched();
    80001462:	ef1ff0ef          	jal	80001352 <sched>

  // Tidy up.
  p->chan = 0;
    80001466:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000146a:	8526                	mv	a0,s1
    8000146c:	63c040ef          	jal	80005aa8 <release>
  acquire(lk);
    80001470:	854a                	mv	a0,s2
    80001472:	59e040ef          	jal	80005a10 <acquire>
}
    80001476:	70a2                	ld	ra,40(sp)
    80001478:	7402                	ld	s0,32(sp)
    8000147a:	64e2                	ld	s1,24(sp)
    8000147c:	6942                	ld	s2,16(sp)
    8000147e:	69a2                	ld	s3,8(sp)
    80001480:	6145                	addi	sp,sp,48
    80001482:	8082                	ret

0000000080001484 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001484:	7139                	addi	sp,sp,-64
    80001486:	fc06                	sd	ra,56(sp)
    80001488:	f822                	sd	s0,48(sp)
    8000148a:	f426                	sd	s1,40(sp)
    8000148c:	f04a                	sd	s2,32(sp)
    8000148e:	ec4e                	sd	s3,24(sp)
    80001490:	e852                	sd	s4,16(sp)
    80001492:	e456                	sd	s5,8(sp)
    80001494:	0080                	addi	s0,sp,64
    80001496:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001498:	00007497          	auipc	s1,0x7
    8000149c:	98848493          	addi	s1,s1,-1656 # 80007e20 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800014a0:	4989                	li	s3,2
        p->state = RUNNABLE;
    800014a2:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800014a4:	0000c917          	auipc	s2,0xc
    800014a8:	37c90913          	addi	s2,s2,892 # 8000d820 <tickslock>
    800014ac:	a801                	j	800014bc <wakeup+0x38>
      }
      release(&p->lock);
    800014ae:	8526                	mv	a0,s1
    800014b0:	5f8040ef          	jal	80005aa8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800014b4:	16848493          	addi	s1,s1,360
    800014b8:	03248263          	beq	s1,s2,800014dc <wakeup+0x58>
    if(p != myproc()){
    800014bc:	9afff0ef          	jal	80000e6a <myproc>
    800014c0:	fea48ae3          	beq	s1,a0,800014b4 <wakeup+0x30>
      acquire(&p->lock);
    800014c4:	8526                	mv	a0,s1
    800014c6:	54a040ef          	jal	80005a10 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800014ca:	4c9c                	lw	a5,24(s1)
    800014cc:	ff3791e3          	bne	a5,s3,800014ae <wakeup+0x2a>
    800014d0:	709c                	ld	a5,32(s1)
    800014d2:	fd479ee3          	bne	a5,s4,800014ae <wakeup+0x2a>
        p->state = RUNNABLE;
    800014d6:	0154ac23          	sw	s5,24(s1)
    800014da:	bfd1                	j	800014ae <wakeup+0x2a>
    }
  }
}
    800014dc:	70e2                	ld	ra,56(sp)
    800014de:	7442                	ld	s0,48(sp)
    800014e0:	74a2                	ld	s1,40(sp)
    800014e2:	7902                	ld	s2,32(sp)
    800014e4:	69e2                	ld	s3,24(sp)
    800014e6:	6a42                	ld	s4,16(sp)
    800014e8:	6aa2                	ld	s5,8(sp)
    800014ea:	6121                	addi	sp,sp,64
    800014ec:	8082                	ret

00000000800014ee <reparent>:
{
    800014ee:	7179                	addi	sp,sp,-48
    800014f0:	f406                	sd	ra,40(sp)
    800014f2:	f022                	sd	s0,32(sp)
    800014f4:	ec26                	sd	s1,24(sp)
    800014f6:	e84a                	sd	s2,16(sp)
    800014f8:	e44e                	sd	s3,8(sp)
    800014fa:	e052                	sd	s4,0(sp)
    800014fc:	1800                	addi	s0,sp,48
    800014fe:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001500:	00007497          	auipc	s1,0x7
    80001504:	92048493          	addi	s1,s1,-1760 # 80007e20 <proc>
      pp->parent = initproc;
    80001508:	00006a17          	auipc	s4,0x6
    8000150c:	4a8a0a13          	addi	s4,s4,1192 # 800079b0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001510:	0000c997          	auipc	s3,0xc
    80001514:	31098993          	addi	s3,s3,784 # 8000d820 <tickslock>
    80001518:	a029                	j	80001522 <reparent+0x34>
    8000151a:	16848493          	addi	s1,s1,360
    8000151e:	01348b63          	beq	s1,s3,80001534 <reparent+0x46>
    if(pp->parent == p){
    80001522:	7c9c                	ld	a5,56(s1)
    80001524:	ff279be3          	bne	a5,s2,8000151a <reparent+0x2c>
      pp->parent = initproc;
    80001528:	000a3503          	ld	a0,0(s4)
    8000152c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000152e:	f57ff0ef          	jal	80001484 <wakeup>
    80001532:	b7e5                	j	8000151a <reparent+0x2c>
}
    80001534:	70a2                	ld	ra,40(sp)
    80001536:	7402                	ld	s0,32(sp)
    80001538:	64e2                	ld	s1,24(sp)
    8000153a:	6942                	ld	s2,16(sp)
    8000153c:	69a2                	ld	s3,8(sp)
    8000153e:	6a02                	ld	s4,0(sp)
    80001540:	6145                	addi	sp,sp,48
    80001542:	8082                	ret

0000000080001544 <exit>:
{
    80001544:	7179                	addi	sp,sp,-48
    80001546:	f406                	sd	ra,40(sp)
    80001548:	f022                	sd	s0,32(sp)
    8000154a:	ec26                	sd	s1,24(sp)
    8000154c:	e84a                	sd	s2,16(sp)
    8000154e:	e44e                	sd	s3,8(sp)
    80001550:	e052                	sd	s4,0(sp)
    80001552:	1800                	addi	s0,sp,48
    80001554:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001556:	915ff0ef          	jal	80000e6a <myproc>
    8000155a:	89aa                	mv	s3,a0
  if(p == initproc)
    8000155c:	00006797          	auipc	a5,0x6
    80001560:	4547b783          	ld	a5,1108(a5) # 800079b0 <initproc>
    80001564:	0d050493          	addi	s1,a0,208
    80001568:	15050913          	addi	s2,a0,336
    8000156c:	00a79f63          	bne	a5,a0,8000158a <exit+0x46>
    panic("init exiting");
    80001570:	00006517          	auipc	a0,0x6
    80001574:	cf050513          	addi	a0,a0,-784 # 80007260 <etext+0x260>
    80001578:	16a040ef          	jal	800056e2 <panic>
      fileclose(f);
    8000157c:	797010ef          	jal	80003512 <fileclose>
      p->ofile[fd] = 0;
    80001580:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001584:	04a1                	addi	s1,s1,8
    80001586:	01248563          	beq	s1,s2,80001590 <exit+0x4c>
    if(p->ofile[fd]){
    8000158a:	6088                	ld	a0,0(s1)
    8000158c:	f965                	bnez	a0,8000157c <exit+0x38>
    8000158e:	bfdd                	j	80001584 <exit+0x40>
  begin_op();
    80001590:	369010ef          	jal	800030f8 <begin_op>
  iput(p->cwd);
    80001594:	1509b503          	ld	a0,336(s3)
    80001598:	44c010ef          	jal	800029e4 <iput>
  end_op();
    8000159c:	3c7010ef          	jal	80003162 <end_op>
  p->cwd = 0;
    800015a0:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800015a4:	00006497          	auipc	s1,0x6
    800015a8:	46448493          	addi	s1,s1,1124 # 80007a08 <wait_lock>
    800015ac:	8526                	mv	a0,s1
    800015ae:	462040ef          	jal	80005a10 <acquire>
  reparent(p);
    800015b2:	854e                	mv	a0,s3
    800015b4:	f3bff0ef          	jal	800014ee <reparent>
  wakeup(p->parent);
    800015b8:	0389b503          	ld	a0,56(s3)
    800015bc:	ec9ff0ef          	jal	80001484 <wakeup>
  acquire(&p->lock);
    800015c0:	854e                	mv	a0,s3
    800015c2:	44e040ef          	jal	80005a10 <acquire>
  p->xstate = status;
    800015c6:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800015ca:	4795                	li	a5,5
    800015cc:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800015d0:	8526                	mv	a0,s1
    800015d2:	4d6040ef          	jal	80005aa8 <release>
  sched();
    800015d6:	d7dff0ef          	jal	80001352 <sched>
  panic("zombie exit");
    800015da:	00006517          	auipc	a0,0x6
    800015de:	c9650513          	addi	a0,a0,-874 # 80007270 <etext+0x270>
    800015e2:	100040ef          	jal	800056e2 <panic>

00000000800015e6 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800015e6:	7179                	addi	sp,sp,-48
    800015e8:	f406                	sd	ra,40(sp)
    800015ea:	f022                	sd	s0,32(sp)
    800015ec:	ec26                	sd	s1,24(sp)
    800015ee:	e84a                	sd	s2,16(sp)
    800015f0:	e44e                	sd	s3,8(sp)
    800015f2:	1800                	addi	s0,sp,48
    800015f4:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800015f6:	00007497          	auipc	s1,0x7
    800015fa:	82a48493          	addi	s1,s1,-2006 # 80007e20 <proc>
    800015fe:	0000c997          	auipc	s3,0xc
    80001602:	22298993          	addi	s3,s3,546 # 8000d820 <tickslock>
    acquire(&p->lock);
    80001606:	8526                	mv	a0,s1
    80001608:	408040ef          	jal	80005a10 <acquire>
    if(p->pid == pid){
    8000160c:	589c                	lw	a5,48(s1)
    8000160e:	01278b63          	beq	a5,s2,80001624 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001612:	8526                	mv	a0,s1
    80001614:	494040ef          	jal	80005aa8 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001618:	16848493          	addi	s1,s1,360
    8000161c:	ff3495e3          	bne	s1,s3,80001606 <kill+0x20>
  }
  return -1;
    80001620:	557d                	li	a0,-1
    80001622:	a819                	j	80001638 <kill+0x52>
      p->killed = 1;
    80001624:	4785                	li	a5,1
    80001626:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001628:	4c98                	lw	a4,24(s1)
    8000162a:	4789                	li	a5,2
    8000162c:	00f70d63          	beq	a4,a5,80001646 <kill+0x60>
      release(&p->lock);
    80001630:	8526                	mv	a0,s1
    80001632:	476040ef          	jal	80005aa8 <release>
      return 0;
    80001636:	4501                	li	a0,0
}
    80001638:	70a2                	ld	ra,40(sp)
    8000163a:	7402                	ld	s0,32(sp)
    8000163c:	64e2                	ld	s1,24(sp)
    8000163e:	6942                	ld	s2,16(sp)
    80001640:	69a2                	ld	s3,8(sp)
    80001642:	6145                	addi	sp,sp,48
    80001644:	8082                	ret
        p->state = RUNNABLE;
    80001646:	478d                	li	a5,3
    80001648:	cc9c                	sw	a5,24(s1)
    8000164a:	b7dd                	j	80001630 <kill+0x4a>

000000008000164c <setkilled>:

void
setkilled(struct proc *p)
{
    8000164c:	1101                	addi	sp,sp,-32
    8000164e:	ec06                	sd	ra,24(sp)
    80001650:	e822                	sd	s0,16(sp)
    80001652:	e426                	sd	s1,8(sp)
    80001654:	1000                	addi	s0,sp,32
    80001656:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001658:	3b8040ef          	jal	80005a10 <acquire>
  p->killed = 1;
    8000165c:	4785                	li	a5,1
    8000165e:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001660:	8526                	mv	a0,s1
    80001662:	446040ef          	jal	80005aa8 <release>
}
    80001666:	60e2                	ld	ra,24(sp)
    80001668:	6442                	ld	s0,16(sp)
    8000166a:	64a2                	ld	s1,8(sp)
    8000166c:	6105                	addi	sp,sp,32
    8000166e:	8082                	ret

0000000080001670 <killed>:

int
killed(struct proc *p)
{
    80001670:	1101                	addi	sp,sp,-32
    80001672:	ec06                	sd	ra,24(sp)
    80001674:	e822                	sd	s0,16(sp)
    80001676:	e426                	sd	s1,8(sp)
    80001678:	e04a                	sd	s2,0(sp)
    8000167a:	1000                	addi	s0,sp,32
    8000167c:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000167e:	392040ef          	jal	80005a10 <acquire>
  k = p->killed;
    80001682:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001686:	8526                	mv	a0,s1
    80001688:	420040ef          	jal	80005aa8 <release>
  return k;
}
    8000168c:	854a                	mv	a0,s2
    8000168e:	60e2                	ld	ra,24(sp)
    80001690:	6442                	ld	s0,16(sp)
    80001692:	64a2                	ld	s1,8(sp)
    80001694:	6902                	ld	s2,0(sp)
    80001696:	6105                	addi	sp,sp,32
    80001698:	8082                	ret

000000008000169a <wait>:
{
    8000169a:	715d                	addi	sp,sp,-80
    8000169c:	e486                	sd	ra,72(sp)
    8000169e:	e0a2                	sd	s0,64(sp)
    800016a0:	fc26                	sd	s1,56(sp)
    800016a2:	f84a                	sd	s2,48(sp)
    800016a4:	f44e                	sd	s3,40(sp)
    800016a6:	f052                	sd	s4,32(sp)
    800016a8:	ec56                	sd	s5,24(sp)
    800016aa:	e85a                	sd	s6,16(sp)
    800016ac:	e45e                	sd	s7,8(sp)
    800016ae:	e062                	sd	s8,0(sp)
    800016b0:	0880                	addi	s0,sp,80
    800016b2:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800016b4:	fb6ff0ef          	jal	80000e6a <myproc>
    800016b8:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800016ba:	00006517          	auipc	a0,0x6
    800016be:	34e50513          	addi	a0,a0,846 # 80007a08 <wait_lock>
    800016c2:	34e040ef          	jal	80005a10 <acquire>
    havekids = 0;
    800016c6:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800016c8:	4a15                	li	s4,5
        havekids = 1;
    800016ca:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016cc:	0000c997          	auipc	s3,0xc
    800016d0:	15498993          	addi	s3,s3,340 # 8000d820 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016d4:	00006c17          	auipc	s8,0x6
    800016d8:	334c0c13          	addi	s8,s8,820 # 80007a08 <wait_lock>
    800016dc:	a871                	j	80001778 <wait+0xde>
          pid = pp->pid;
    800016de:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800016e2:	000b0c63          	beqz	s6,800016fa <wait+0x60>
    800016e6:	4691                	li	a3,4
    800016e8:	02c48613          	addi	a2,s1,44
    800016ec:	85da                	mv	a1,s6
    800016ee:	05093503          	ld	a0,80(s2)
    800016f2:	b00ff0ef          	jal	800009f2 <copyout>
    800016f6:	02054b63          	bltz	a0,8000172c <wait+0x92>
          freeproc(pp);
    800016fa:	8526                	mv	a0,s1
    800016fc:	8e1ff0ef          	jal	80000fdc <freeproc>
          release(&pp->lock);
    80001700:	8526                	mv	a0,s1
    80001702:	3a6040ef          	jal	80005aa8 <release>
          release(&wait_lock);
    80001706:	00006517          	auipc	a0,0x6
    8000170a:	30250513          	addi	a0,a0,770 # 80007a08 <wait_lock>
    8000170e:	39a040ef          	jal	80005aa8 <release>
}
    80001712:	854e                	mv	a0,s3
    80001714:	60a6                	ld	ra,72(sp)
    80001716:	6406                	ld	s0,64(sp)
    80001718:	74e2                	ld	s1,56(sp)
    8000171a:	7942                	ld	s2,48(sp)
    8000171c:	79a2                	ld	s3,40(sp)
    8000171e:	7a02                	ld	s4,32(sp)
    80001720:	6ae2                	ld	s5,24(sp)
    80001722:	6b42                	ld	s6,16(sp)
    80001724:	6ba2                	ld	s7,8(sp)
    80001726:	6c02                	ld	s8,0(sp)
    80001728:	6161                	addi	sp,sp,80
    8000172a:	8082                	ret
            release(&pp->lock);
    8000172c:	8526                	mv	a0,s1
    8000172e:	37a040ef          	jal	80005aa8 <release>
            release(&wait_lock);
    80001732:	00006517          	auipc	a0,0x6
    80001736:	2d650513          	addi	a0,a0,726 # 80007a08 <wait_lock>
    8000173a:	36e040ef          	jal	80005aa8 <release>
            return -1;
    8000173e:	59fd                	li	s3,-1
    80001740:	bfc9                	j	80001712 <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001742:	16848493          	addi	s1,s1,360
    80001746:	03348063          	beq	s1,s3,80001766 <wait+0xcc>
      if(pp->parent == p){
    8000174a:	7c9c                	ld	a5,56(s1)
    8000174c:	ff279be3          	bne	a5,s2,80001742 <wait+0xa8>
        acquire(&pp->lock);
    80001750:	8526                	mv	a0,s1
    80001752:	2be040ef          	jal	80005a10 <acquire>
        if(pp->state == ZOMBIE){
    80001756:	4c9c                	lw	a5,24(s1)
    80001758:	f94783e3          	beq	a5,s4,800016de <wait+0x44>
        release(&pp->lock);
    8000175c:	8526                	mv	a0,s1
    8000175e:	34a040ef          	jal	80005aa8 <release>
        havekids = 1;
    80001762:	8756                	mv	a4,s5
    80001764:	bff9                	j	80001742 <wait+0xa8>
    if(!havekids || killed(p)){
    80001766:	cf19                	beqz	a4,80001784 <wait+0xea>
    80001768:	854a                	mv	a0,s2
    8000176a:	f07ff0ef          	jal	80001670 <killed>
    8000176e:	e919                	bnez	a0,80001784 <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001770:	85e2                	mv	a1,s8
    80001772:	854a                	mv	a0,s2
    80001774:	cc5ff0ef          	jal	80001438 <sleep>
    havekids = 0;
    80001778:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000177a:	00006497          	auipc	s1,0x6
    8000177e:	6a648493          	addi	s1,s1,1702 # 80007e20 <proc>
    80001782:	b7e1                	j	8000174a <wait+0xb0>
      release(&wait_lock);
    80001784:	00006517          	auipc	a0,0x6
    80001788:	28450513          	addi	a0,a0,644 # 80007a08 <wait_lock>
    8000178c:	31c040ef          	jal	80005aa8 <release>
      return -1;
    80001790:	59fd                	li	s3,-1
    80001792:	b741                	j	80001712 <wait+0x78>

0000000080001794 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001794:	7179                	addi	sp,sp,-48
    80001796:	f406                	sd	ra,40(sp)
    80001798:	f022                	sd	s0,32(sp)
    8000179a:	ec26                	sd	s1,24(sp)
    8000179c:	e84a                	sd	s2,16(sp)
    8000179e:	e44e                	sd	s3,8(sp)
    800017a0:	e052                	sd	s4,0(sp)
    800017a2:	1800                	addi	s0,sp,48
    800017a4:	84aa                	mv	s1,a0
    800017a6:	892e                	mv	s2,a1
    800017a8:	89b2                	mv	s3,a2
    800017aa:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800017ac:	ebeff0ef          	jal	80000e6a <myproc>
  if(user_dst){
    800017b0:	cc99                	beqz	s1,800017ce <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800017b2:	86d2                	mv	a3,s4
    800017b4:	864e                	mv	a2,s3
    800017b6:	85ca                	mv	a1,s2
    800017b8:	6928                	ld	a0,80(a0)
    800017ba:	a38ff0ef          	jal	800009f2 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800017be:	70a2                	ld	ra,40(sp)
    800017c0:	7402                	ld	s0,32(sp)
    800017c2:	64e2                	ld	s1,24(sp)
    800017c4:	6942                	ld	s2,16(sp)
    800017c6:	69a2                	ld	s3,8(sp)
    800017c8:	6a02                	ld	s4,0(sp)
    800017ca:	6145                	addi	sp,sp,48
    800017cc:	8082                	ret
    memmove((char *)dst, src, len);
    800017ce:	000a061b          	sext.w	a2,s4
    800017d2:	85ce                	mv	a1,s3
    800017d4:	854a                	mv	a0,s2
    800017d6:	9d5fe0ef          	jal	800001aa <memmove>
    return 0;
    800017da:	8526                	mv	a0,s1
    800017dc:	b7cd                	j	800017be <either_copyout+0x2a>

00000000800017de <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800017de:	7179                	addi	sp,sp,-48
    800017e0:	f406                	sd	ra,40(sp)
    800017e2:	f022                	sd	s0,32(sp)
    800017e4:	ec26                	sd	s1,24(sp)
    800017e6:	e84a                	sd	s2,16(sp)
    800017e8:	e44e                	sd	s3,8(sp)
    800017ea:	e052                	sd	s4,0(sp)
    800017ec:	1800                	addi	s0,sp,48
    800017ee:	892a                	mv	s2,a0
    800017f0:	84ae                	mv	s1,a1
    800017f2:	89b2                	mv	s3,a2
    800017f4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800017f6:	e74ff0ef          	jal	80000e6a <myproc>
  if(user_src){
    800017fa:	cc99                	beqz	s1,80001818 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800017fc:	86d2                	mv	a3,s4
    800017fe:	864e                	mv	a2,s3
    80001800:	85ca                	mv	a1,s2
    80001802:	6928                	ld	a0,80(a0)
    80001804:	ac6ff0ef          	jal	80000aca <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001808:	70a2                	ld	ra,40(sp)
    8000180a:	7402                	ld	s0,32(sp)
    8000180c:	64e2                	ld	s1,24(sp)
    8000180e:	6942                	ld	s2,16(sp)
    80001810:	69a2                	ld	s3,8(sp)
    80001812:	6a02                	ld	s4,0(sp)
    80001814:	6145                	addi	sp,sp,48
    80001816:	8082                	ret
    memmove(dst, (char*)src, len);
    80001818:	000a061b          	sext.w	a2,s4
    8000181c:	85ce                	mv	a1,s3
    8000181e:	854a                	mv	a0,s2
    80001820:	98bfe0ef          	jal	800001aa <memmove>
    return 0;
    80001824:	8526                	mv	a0,s1
    80001826:	b7cd                	j	80001808 <either_copyin+0x2a>

0000000080001828 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001828:	715d                	addi	sp,sp,-80
    8000182a:	e486                	sd	ra,72(sp)
    8000182c:	e0a2                	sd	s0,64(sp)
    8000182e:	fc26                	sd	s1,56(sp)
    80001830:	f84a                	sd	s2,48(sp)
    80001832:	f44e                	sd	s3,40(sp)
    80001834:	f052                	sd	s4,32(sp)
    80001836:	ec56                	sd	s5,24(sp)
    80001838:	e85a                	sd	s6,16(sp)
    8000183a:	e45e                	sd	s7,8(sp)
    8000183c:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000183e:	00005517          	auipc	a0,0x5
    80001842:	7da50513          	addi	a0,a0,2010 # 80007018 <etext+0x18>
    80001846:	3cb030ef          	jal	80005410 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000184a:	00006497          	auipc	s1,0x6
    8000184e:	72e48493          	addi	s1,s1,1838 # 80007f78 <proc+0x158>
    80001852:	0000c917          	auipc	s2,0xc
    80001856:	12690913          	addi	s2,s2,294 # 8000d978 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000185a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000185c:	00006997          	auipc	s3,0x6
    80001860:	a2498993          	addi	s3,s3,-1500 # 80007280 <etext+0x280>
    printf("%d %s %s", p->pid, state, p->name);
    80001864:	00006a97          	auipc	s5,0x6
    80001868:	a24a8a93          	addi	s5,s5,-1500 # 80007288 <etext+0x288>
    printf("\n");
    8000186c:	00005a17          	auipc	s4,0x5
    80001870:	7aca0a13          	addi	s4,s4,1964 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001874:	00006b97          	auipc	s7,0x6
    80001878:	f54b8b93          	addi	s7,s7,-172 # 800077c8 <states.0>
    8000187c:	a829                	j	80001896 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    8000187e:	ed86a583          	lw	a1,-296(a3)
    80001882:	8556                	mv	a0,s5
    80001884:	38d030ef          	jal	80005410 <printf>
    printf("\n");
    80001888:	8552                	mv	a0,s4
    8000188a:	387030ef          	jal	80005410 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000188e:	16848493          	addi	s1,s1,360
    80001892:	03248263          	beq	s1,s2,800018b6 <procdump+0x8e>
    if(p->state == UNUSED)
    80001896:	86a6                	mv	a3,s1
    80001898:	ec04a783          	lw	a5,-320(s1)
    8000189c:	dbed                	beqz	a5,8000188e <procdump+0x66>
      state = "???";
    8000189e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800018a0:	fcfb6fe3          	bltu	s6,a5,8000187e <procdump+0x56>
    800018a4:	02079713          	slli	a4,a5,0x20
    800018a8:	01d75793          	srli	a5,a4,0x1d
    800018ac:	97de                	add	a5,a5,s7
    800018ae:	6390                	ld	a2,0(a5)
    800018b0:	f679                	bnez	a2,8000187e <procdump+0x56>
      state = "???";
    800018b2:	864e                	mv	a2,s3
    800018b4:	b7e9                	j	8000187e <procdump+0x56>
  }
}
    800018b6:	60a6                	ld	ra,72(sp)
    800018b8:	6406                	ld	s0,64(sp)
    800018ba:	74e2                	ld	s1,56(sp)
    800018bc:	7942                	ld	s2,48(sp)
    800018be:	79a2                	ld	s3,40(sp)
    800018c0:	7a02                	ld	s4,32(sp)
    800018c2:	6ae2                	ld	s5,24(sp)
    800018c4:	6b42                	ld	s6,16(sp)
    800018c6:	6ba2                	ld	s7,8(sp)
    800018c8:	6161                	addi	sp,sp,80
    800018ca:	8082                	ret

00000000800018cc <swtch>:
    800018cc:	00153023          	sd	ra,0(a0)
    800018d0:	00253423          	sd	sp,8(a0)
    800018d4:	e900                	sd	s0,16(a0)
    800018d6:	ed04                	sd	s1,24(a0)
    800018d8:	03253023          	sd	s2,32(a0)
    800018dc:	03353423          	sd	s3,40(a0)
    800018e0:	03453823          	sd	s4,48(a0)
    800018e4:	03553c23          	sd	s5,56(a0)
    800018e8:	05653023          	sd	s6,64(a0)
    800018ec:	05753423          	sd	s7,72(a0)
    800018f0:	05853823          	sd	s8,80(a0)
    800018f4:	05953c23          	sd	s9,88(a0)
    800018f8:	07a53023          	sd	s10,96(a0)
    800018fc:	07b53423          	sd	s11,104(a0)
    80001900:	0005b083          	ld	ra,0(a1)
    80001904:	0085b103          	ld	sp,8(a1)
    80001908:	6980                	ld	s0,16(a1)
    8000190a:	6d84                	ld	s1,24(a1)
    8000190c:	0205b903          	ld	s2,32(a1)
    80001910:	0285b983          	ld	s3,40(a1)
    80001914:	0305ba03          	ld	s4,48(a1)
    80001918:	0385ba83          	ld	s5,56(a1)
    8000191c:	0405bb03          	ld	s6,64(a1)
    80001920:	0485bb83          	ld	s7,72(a1)
    80001924:	0505bc03          	ld	s8,80(a1)
    80001928:	0585bc83          	ld	s9,88(a1)
    8000192c:	0605bd03          	ld	s10,96(a1)
    80001930:	0685bd83          	ld	s11,104(a1)
    80001934:	8082                	ret

0000000080001936 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001936:	1141                	addi	sp,sp,-16
    80001938:	e406                	sd	ra,8(sp)
    8000193a:	e022                	sd	s0,0(sp)
    8000193c:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000193e:	00006597          	auipc	a1,0x6
    80001942:	98a58593          	addi	a1,a1,-1654 # 800072c8 <etext+0x2c8>
    80001946:	0000c517          	auipc	a0,0xc
    8000194a:	eda50513          	addi	a0,a0,-294 # 8000d820 <tickslock>
    8000194e:	042040ef          	jal	80005990 <initlock>
}
    80001952:	60a2                	ld	ra,8(sp)
    80001954:	6402                	ld	s0,0(sp)
    80001956:	0141                	addi	sp,sp,16
    80001958:	8082                	ret

000000008000195a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    8000195a:	1141                	addi	sp,sp,-16
    8000195c:	e422                	sd	s0,8(sp)
    8000195e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001960:	00003797          	auipc	a5,0x3
    80001964:	ff078793          	addi	a5,a5,-16 # 80004950 <kernelvec>
    80001968:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000196c:	6422                	ld	s0,8(sp)
    8000196e:	0141                	addi	sp,sp,16
    80001970:	8082                	ret

0000000080001972 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001972:	1141                	addi	sp,sp,-16
    80001974:	e406                	sd	ra,8(sp)
    80001976:	e022                	sd	s0,0(sp)
    80001978:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000197a:	cf0ff0ef          	jal	80000e6a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000197e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001982:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001984:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001988:	00004697          	auipc	a3,0x4
    8000198c:	67868693          	addi	a3,a3,1656 # 80006000 <_trampoline>
    80001990:	00004717          	auipc	a4,0x4
    80001994:	67070713          	addi	a4,a4,1648 # 80006000 <_trampoline>
    80001998:	8f15                	sub	a4,a4,a3
    8000199a:	040007b7          	lui	a5,0x4000
    8000199e:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800019a0:	07b2                	slli	a5,a5,0xc
    800019a2:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800019a4:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800019a8:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800019aa:	18002673          	csrr	a2,satp
    800019ae:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800019b0:	6d30                	ld	a2,88(a0)
    800019b2:	6138                	ld	a4,64(a0)
    800019b4:	6585                	lui	a1,0x1
    800019b6:	972e                	add	a4,a4,a1
    800019b8:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800019ba:	6d38                	ld	a4,88(a0)
    800019bc:	00000617          	auipc	a2,0x0
    800019c0:	11060613          	addi	a2,a2,272 # 80001acc <usertrap>
    800019c4:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800019c6:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800019c8:	8612                	mv	a2,tp
    800019ca:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800019cc:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800019d0:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800019d4:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800019d8:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800019dc:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800019de:	6f18                	ld	a4,24(a4)
    800019e0:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800019e4:	6928                	ld	a0,80(a0)
    800019e6:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800019e8:	00004717          	auipc	a4,0x4
    800019ec:	6b470713          	addi	a4,a4,1716 # 8000609c <userret>
    800019f0:	8f15                	sub	a4,a4,a3
    800019f2:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800019f4:	577d                	li	a4,-1
    800019f6:	177e                	slli	a4,a4,0x3f
    800019f8:	8d59                	or	a0,a0,a4
    800019fa:	9782                	jalr	a5
}
    800019fc:	60a2                	ld	ra,8(sp)
    800019fe:	6402                	ld	s0,0(sp)
    80001a00:	0141                	addi	sp,sp,16
    80001a02:	8082                	ret

0000000080001a04 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001a04:	1101                	addi	sp,sp,-32
    80001a06:	ec06                	sd	ra,24(sp)
    80001a08:	e822                	sd	s0,16(sp)
    80001a0a:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80001a0c:	c32ff0ef          	jal	80000e3e <cpuid>
    80001a10:	cd11                	beqz	a0,80001a2c <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80001a12:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001a16:	000f4737          	lui	a4,0xf4
    80001a1a:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80001a1e:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001a20:	14d79073          	csrw	stimecmp,a5
}
    80001a24:	60e2                	ld	ra,24(sp)
    80001a26:	6442                	ld	s0,16(sp)
    80001a28:	6105                	addi	sp,sp,32
    80001a2a:	8082                	ret
    80001a2c:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    80001a2e:	0000c497          	auipc	s1,0xc
    80001a32:	df248493          	addi	s1,s1,-526 # 8000d820 <tickslock>
    80001a36:	8526                	mv	a0,s1
    80001a38:	7d9030ef          	jal	80005a10 <acquire>
    ticks++;
    80001a3c:	00006517          	auipc	a0,0x6
    80001a40:	f7c50513          	addi	a0,a0,-132 # 800079b8 <ticks>
    80001a44:	411c                	lw	a5,0(a0)
    80001a46:	2785                	addiw	a5,a5,1
    80001a48:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001a4a:	a3bff0ef          	jal	80001484 <wakeup>
    release(&tickslock);
    80001a4e:	8526                	mv	a0,s1
    80001a50:	058040ef          	jal	80005aa8 <release>
    80001a54:	64a2                	ld	s1,8(sp)
    80001a56:	bf75                	j	80001a12 <clockintr+0xe>

0000000080001a58 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001a58:	1101                	addi	sp,sp,-32
    80001a5a:	ec06                	sd	ra,24(sp)
    80001a5c:	e822                	sd	s0,16(sp)
    80001a5e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a60:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80001a64:	57fd                	li	a5,-1
    80001a66:	17fe                	slli	a5,a5,0x3f
    80001a68:	07a5                	addi	a5,a5,9
    80001a6a:	00f70c63          	beq	a4,a5,80001a82 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80001a6e:	57fd                	li	a5,-1
    80001a70:	17fe                	slli	a5,a5,0x3f
    80001a72:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001a74:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001a76:	04f70763          	beq	a4,a5,80001ac4 <devintr+0x6c>
  }
}
    80001a7a:	60e2                	ld	ra,24(sp)
    80001a7c:	6442                	ld	s0,16(sp)
    80001a7e:	6105                	addi	sp,sp,32
    80001a80:	8082                	ret
    80001a82:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001a84:	779020ef          	jal	800049fc <plic_claim>
    80001a88:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001a8a:	47a9                	li	a5,10
    80001a8c:	00f50963          	beq	a0,a5,80001a9e <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80001a90:	4785                	li	a5,1
    80001a92:	00f50963          	beq	a0,a5,80001aa4 <devintr+0x4c>
    return 1;
    80001a96:	4505                	li	a0,1
    } else if(irq){
    80001a98:	e889                	bnez	s1,80001aaa <devintr+0x52>
    80001a9a:	64a2                	ld	s1,8(sp)
    80001a9c:	bff9                	j	80001a7a <devintr+0x22>
      uartintr();
    80001a9e:	6b7030ef          	jal	80005954 <uartintr>
    if(irq)
    80001aa2:	a819                	j	80001ab8 <devintr+0x60>
      virtio_disk_intr();
    80001aa4:	41e030ef          	jal	80004ec2 <virtio_disk_intr>
    if(irq)
    80001aa8:	a801                	j	80001ab8 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80001aaa:	85a6                	mv	a1,s1
    80001aac:	00006517          	auipc	a0,0x6
    80001ab0:	82450513          	addi	a0,a0,-2012 # 800072d0 <etext+0x2d0>
    80001ab4:	15d030ef          	jal	80005410 <printf>
      plic_complete(irq);
    80001ab8:	8526                	mv	a0,s1
    80001aba:	763020ef          	jal	80004a1c <plic_complete>
    return 1;
    80001abe:	4505                	li	a0,1
    80001ac0:	64a2                	ld	s1,8(sp)
    80001ac2:	bf65                	j	80001a7a <devintr+0x22>
    clockintr();
    80001ac4:	f41ff0ef          	jal	80001a04 <clockintr>
    return 2;
    80001ac8:	4509                	li	a0,2
    80001aca:	bf45                	j	80001a7a <devintr+0x22>

0000000080001acc <usertrap>:
{
    80001acc:	1101                	addi	sp,sp,-32
    80001ace:	ec06                	sd	ra,24(sp)
    80001ad0:	e822                	sd	s0,16(sp)
    80001ad2:	e426                	sd	s1,8(sp)
    80001ad4:	e04a                	sd	s2,0(sp)
    80001ad6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ad8:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001adc:	1007f793          	andi	a5,a5,256
    80001ae0:	ef85                	bnez	a5,80001b18 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ae2:	00003797          	auipc	a5,0x3
    80001ae6:	e6e78793          	addi	a5,a5,-402 # 80004950 <kernelvec>
    80001aea:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001aee:	b7cff0ef          	jal	80000e6a <myproc>
    80001af2:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001af4:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001af6:	14102773          	csrr	a4,sepc
    80001afa:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001afc:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001b00:	47a1                	li	a5,8
    80001b02:	02f70163          	beq	a4,a5,80001b24 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    80001b06:	f53ff0ef          	jal	80001a58 <devintr>
    80001b0a:	892a                	mv	s2,a0
    80001b0c:	c135                	beqz	a0,80001b70 <usertrap+0xa4>
  if(killed(p))
    80001b0e:	8526                	mv	a0,s1
    80001b10:	b61ff0ef          	jal	80001670 <killed>
    80001b14:	cd1d                	beqz	a0,80001b52 <usertrap+0x86>
    80001b16:	a81d                	j	80001b4c <usertrap+0x80>
    panic("usertrap: not from user mode");
    80001b18:	00005517          	auipc	a0,0x5
    80001b1c:	7d850513          	addi	a0,a0,2008 # 800072f0 <etext+0x2f0>
    80001b20:	3c3030ef          	jal	800056e2 <panic>
    if(killed(p))
    80001b24:	b4dff0ef          	jal	80001670 <killed>
    80001b28:	e121                	bnez	a0,80001b68 <usertrap+0x9c>
    p->trapframe->epc += 4;
    80001b2a:	6cb8                	ld	a4,88(s1)
    80001b2c:	6f1c                	ld	a5,24(a4)
    80001b2e:	0791                	addi	a5,a5,4
    80001b30:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b32:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001b36:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b3a:	10079073          	csrw	sstatus,a5
    syscall();
    80001b3e:	248000ef          	jal	80001d86 <syscall>
  if(killed(p))
    80001b42:	8526                	mv	a0,s1
    80001b44:	b2dff0ef          	jal	80001670 <killed>
    80001b48:	c901                	beqz	a0,80001b58 <usertrap+0x8c>
    80001b4a:	4901                	li	s2,0
    exit(-1);
    80001b4c:	557d                	li	a0,-1
    80001b4e:	9f7ff0ef          	jal	80001544 <exit>
  if(which_dev == 2)
    80001b52:	4789                	li	a5,2
    80001b54:	04f90563          	beq	s2,a5,80001b9e <usertrap+0xd2>
  usertrapret();
    80001b58:	e1bff0ef          	jal	80001972 <usertrapret>
}
    80001b5c:	60e2                	ld	ra,24(sp)
    80001b5e:	6442                	ld	s0,16(sp)
    80001b60:	64a2                	ld	s1,8(sp)
    80001b62:	6902                	ld	s2,0(sp)
    80001b64:	6105                	addi	sp,sp,32
    80001b66:	8082                	ret
      exit(-1);
    80001b68:	557d                	li	a0,-1
    80001b6a:	9dbff0ef          	jal	80001544 <exit>
    80001b6e:	bf75                	j	80001b2a <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b70:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001b74:	5890                	lw	a2,48(s1)
    80001b76:	00005517          	auipc	a0,0x5
    80001b7a:	79a50513          	addi	a0,a0,1946 # 80007310 <etext+0x310>
    80001b7e:	093030ef          	jal	80005410 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b82:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b86:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001b8a:	00005517          	auipc	a0,0x5
    80001b8e:	7b650513          	addi	a0,a0,1974 # 80007340 <etext+0x340>
    80001b92:	07f030ef          	jal	80005410 <printf>
    setkilled(p);
    80001b96:	8526                	mv	a0,s1
    80001b98:	ab5ff0ef          	jal	8000164c <setkilled>
    80001b9c:	b75d                	j	80001b42 <usertrap+0x76>
    yield();
    80001b9e:	86fff0ef          	jal	8000140c <yield>
    80001ba2:	bf5d                	j	80001b58 <usertrap+0x8c>

0000000080001ba4 <kerneltrap>:
{
    80001ba4:	7179                	addi	sp,sp,-48
    80001ba6:	f406                	sd	ra,40(sp)
    80001ba8:	f022                	sd	s0,32(sp)
    80001baa:	ec26                	sd	s1,24(sp)
    80001bac:	e84a                	sd	s2,16(sp)
    80001bae:	e44e                	sd	s3,8(sp)
    80001bb0:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001bb2:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bb6:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bba:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001bbe:	1004f793          	andi	a5,s1,256
    80001bc2:	c795                	beqz	a5,80001bee <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bc4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001bc8:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001bca:	eb85                	bnez	a5,80001bfa <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001bcc:	e8dff0ef          	jal	80001a58 <devintr>
    80001bd0:	c91d                	beqz	a0,80001c06 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001bd2:	4789                	li	a5,2
    80001bd4:	04f50a63          	beq	a0,a5,80001c28 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bd8:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bdc:	10049073          	csrw	sstatus,s1
}
    80001be0:	70a2                	ld	ra,40(sp)
    80001be2:	7402                	ld	s0,32(sp)
    80001be4:	64e2                	ld	s1,24(sp)
    80001be6:	6942                	ld	s2,16(sp)
    80001be8:	69a2                	ld	s3,8(sp)
    80001bea:	6145                	addi	sp,sp,48
    80001bec:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001bee:	00005517          	auipc	a0,0x5
    80001bf2:	77a50513          	addi	a0,a0,1914 # 80007368 <etext+0x368>
    80001bf6:	2ed030ef          	jal	800056e2 <panic>
    panic("kerneltrap: interrupts enabled");
    80001bfa:	00005517          	auipc	a0,0x5
    80001bfe:	79650513          	addi	a0,a0,1942 # 80007390 <etext+0x390>
    80001c02:	2e1030ef          	jal	800056e2 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c06:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001c0a:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001c0e:	85ce                	mv	a1,s3
    80001c10:	00005517          	auipc	a0,0x5
    80001c14:	7a050513          	addi	a0,a0,1952 # 800073b0 <etext+0x3b0>
    80001c18:	7f8030ef          	jal	80005410 <printf>
    panic("kerneltrap");
    80001c1c:	00005517          	auipc	a0,0x5
    80001c20:	7bc50513          	addi	a0,a0,1980 # 800073d8 <etext+0x3d8>
    80001c24:	2bf030ef          	jal	800056e2 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001c28:	a42ff0ef          	jal	80000e6a <myproc>
    80001c2c:	d555                	beqz	a0,80001bd8 <kerneltrap+0x34>
    yield();
    80001c2e:	fdeff0ef          	jal	8000140c <yield>
    80001c32:	b75d                	j	80001bd8 <kerneltrap+0x34>

0000000080001c34 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001c34:	1101                	addi	sp,sp,-32
    80001c36:	ec06                	sd	ra,24(sp)
    80001c38:	e822                	sd	s0,16(sp)
    80001c3a:	e426                	sd	s1,8(sp)
    80001c3c:	1000                	addi	s0,sp,32
    80001c3e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001c40:	a2aff0ef          	jal	80000e6a <myproc>
  switch (n) {
    80001c44:	4795                	li	a5,5
    80001c46:	0497e163          	bltu	a5,s1,80001c88 <argraw+0x54>
    80001c4a:	048a                	slli	s1,s1,0x2
    80001c4c:	00006717          	auipc	a4,0x6
    80001c50:	bac70713          	addi	a4,a4,-1108 # 800077f8 <states.0+0x30>
    80001c54:	94ba                	add	s1,s1,a4
    80001c56:	409c                	lw	a5,0(s1)
    80001c58:	97ba                	add	a5,a5,a4
    80001c5a:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001c5c:	6d3c                	ld	a5,88(a0)
    80001c5e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001c60:	60e2                	ld	ra,24(sp)
    80001c62:	6442                	ld	s0,16(sp)
    80001c64:	64a2                	ld	s1,8(sp)
    80001c66:	6105                	addi	sp,sp,32
    80001c68:	8082                	ret
    return p->trapframe->a1;
    80001c6a:	6d3c                	ld	a5,88(a0)
    80001c6c:	7fa8                	ld	a0,120(a5)
    80001c6e:	bfcd                	j	80001c60 <argraw+0x2c>
    return p->trapframe->a2;
    80001c70:	6d3c                	ld	a5,88(a0)
    80001c72:	63c8                	ld	a0,128(a5)
    80001c74:	b7f5                	j	80001c60 <argraw+0x2c>
    return p->trapframe->a3;
    80001c76:	6d3c                	ld	a5,88(a0)
    80001c78:	67c8                	ld	a0,136(a5)
    80001c7a:	b7dd                	j	80001c60 <argraw+0x2c>
    return p->trapframe->a4;
    80001c7c:	6d3c                	ld	a5,88(a0)
    80001c7e:	6bc8                	ld	a0,144(a5)
    80001c80:	b7c5                	j	80001c60 <argraw+0x2c>
    return p->trapframe->a5;
    80001c82:	6d3c                	ld	a5,88(a0)
    80001c84:	6fc8                	ld	a0,152(a5)
    80001c86:	bfe9                	j	80001c60 <argraw+0x2c>
  panic("argraw");
    80001c88:	00005517          	auipc	a0,0x5
    80001c8c:	76050513          	addi	a0,a0,1888 # 800073e8 <etext+0x3e8>
    80001c90:	253030ef          	jal	800056e2 <panic>

0000000080001c94 <fetchaddr>:
{
    80001c94:	1101                	addi	sp,sp,-32
    80001c96:	ec06                	sd	ra,24(sp)
    80001c98:	e822                	sd	s0,16(sp)
    80001c9a:	e426                	sd	s1,8(sp)
    80001c9c:	e04a                	sd	s2,0(sp)
    80001c9e:	1000                	addi	s0,sp,32
    80001ca0:	84aa                	mv	s1,a0
    80001ca2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ca4:	9c6ff0ef          	jal	80000e6a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001ca8:	653c                	ld	a5,72(a0)
    80001caa:	02f4f663          	bgeu	s1,a5,80001cd6 <fetchaddr+0x42>
    80001cae:	00848713          	addi	a4,s1,8
    80001cb2:	02e7e463          	bltu	a5,a4,80001cda <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001cb6:	46a1                	li	a3,8
    80001cb8:	8626                	mv	a2,s1
    80001cba:	85ca                	mv	a1,s2
    80001cbc:	6928                	ld	a0,80(a0)
    80001cbe:	e0dfe0ef          	jal	80000aca <copyin>
    80001cc2:	00a03533          	snez	a0,a0
    80001cc6:	40a00533          	neg	a0,a0
}
    80001cca:	60e2                	ld	ra,24(sp)
    80001ccc:	6442                	ld	s0,16(sp)
    80001cce:	64a2                	ld	s1,8(sp)
    80001cd0:	6902                	ld	s2,0(sp)
    80001cd2:	6105                	addi	sp,sp,32
    80001cd4:	8082                	ret
    return -1;
    80001cd6:	557d                	li	a0,-1
    80001cd8:	bfcd                	j	80001cca <fetchaddr+0x36>
    80001cda:	557d                	li	a0,-1
    80001cdc:	b7fd                	j	80001cca <fetchaddr+0x36>

0000000080001cde <fetchstr>:
{
    80001cde:	7179                	addi	sp,sp,-48
    80001ce0:	f406                	sd	ra,40(sp)
    80001ce2:	f022                	sd	s0,32(sp)
    80001ce4:	ec26                	sd	s1,24(sp)
    80001ce6:	e84a                	sd	s2,16(sp)
    80001ce8:	e44e                	sd	s3,8(sp)
    80001cea:	1800                	addi	s0,sp,48
    80001cec:	892a                	mv	s2,a0
    80001cee:	84ae                	mv	s1,a1
    80001cf0:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001cf2:	978ff0ef          	jal	80000e6a <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001cf6:	86ce                	mv	a3,s3
    80001cf8:	864a                	mv	a2,s2
    80001cfa:	85a6                	mv	a1,s1
    80001cfc:	6928                	ld	a0,80(a0)
    80001cfe:	e53fe0ef          	jal	80000b50 <copyinstr>
    80001d02:	00054c63          	bltz	a0,80001d1a <fetchstr+0x3c>
  return strlen(buf);
    80001d06:	8526                	mv	a0,s1
    80001d08:	db6fe0ef          	jal	800002be <strlen>
}
    80001d0c:	70a2                	ld	ra,40(sp)
    80001d0e:	7402                	ld	s0,32(sp)
    80001d10:	64e2                	ld	s1,24(sp)
    80001d12:	6942                	ld	s2,16(sp)
    80001d14:	69a2                	ld	s3,8(sp)
    80001d16:	6145                	addi	sp,sp,48
    80001d18:	8082                	ret
    return -1;
    80001d1a:	557d                	li	a0,-1
    80001d1c:	bfc5                	j	80001d0c <fetchstr+0x2e>

0000000080001d1e <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001d1e:	1101                	addi	sp,sp,-32
    80001d20:	ec06                	sd	ra,24(sp)
    80001d22:	e822                	sd	s0,16(sp)
    80001d24:	e426                	sd	s1,8(sp)
    80001d26:	1000                	addi	s0,sp,32
    80001d28:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001d2a:	f0bff0ef          	jal	80001c34 <argraw>
    80001d2e:	c088                	sw	a0,0(s1)
}
    80001d30:	60e2                	ld	ra,24(sp)
    80001d32:	6442                	ld	s0,16(sp)
    80001d34:	64a2                	ld	s1,8(sp)
    80001d36:	6105                	addi	sp,sp,32
    80001d38:	8082                	ret

0000000080001d3a <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001d3a:	1101                	addi	sp,sp,-32
    80001d3c:	ec06                	sd	ra,24(sp)
    80001d3e:	e822                	sd	s0,16(sp)
    80001d40:	e426                	sd	s1,8(sp)
    80001d42:	1000                	addi	s0,sp,32
    80001d44:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001d46:	eefff0ef          	jal	80001c34 <argraw>
    80001d4a:	e088                	sd	a0,0(s1)
}
    80001d4c:	60e2                	ld	ra,24(sp)
    80001d4e:	6442                	ld	s0,16(sp)
    80001d50:	64a2                	ld	s1,8(sp)
    80001d52:	6105                	addi	sp,sp,32
    80001d54:	8082                	ret

0000000080001d56 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001d56:	7179                	addi	sp,sp,-48
    80001d58:	f406                	sd	ra,40(sp)
    80001d5a:	f022                	sd	s0,32(sp)
    80001d5c:	ec26                	sd	s1,24(sp)
    80001d5e:	e84a                	sd	s2,16(sp)
    80001d60:	1800                	addi	s0,sp,48
    80001d62:	84ae                	mv	s1,a1
    80001d64:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001d66:	fd840593          	addi	a1,s0,-40
    80001d6a:	fd1ff0ef          	jal	80001d3a <argaddr>
  return fetchstr(addr, buf, max);
    80001d6e:	864a                	mv	a2,s2
    80001d70:	85a6                	mv	a1,s1
    80001d72:	fd843503          	ld	a0,-40(s0)
    80001d76:	f69ff0ef          	jal	80001cde <fetchstr>
}
    80001d7a:	70a2                	ld	ra,40(sp)
    80001d7c:	7402                	ld	s0,32(sp)
    80001d7e:	64e2                	ld	s1,24(sp)
    80001d80:	6942                	ld	s2,16(sp)
    80001d82:	6145                	addi	sp,sp,48
    80001d84:	8082                	ret

0000000080001d86 <syscall>:



void
syscall(void)
{
    80001d86:	1101                	addi	sp,sp,-32
    80001d88:	ec06                	sd	ra,24(sp)
    80001d8a:	e822                	sd	s0,16(sp)
    80001d8c:	e426                	sd	s1,8(sp)
    80001d8e:	e04a                	sd	s2,0(sp)
    80001d90:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001d92:	8d8ff0ef          	jal	80000e6a <myproc>
    80001d96:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001d98:	05853903          	ld	s2,88(a0)
    80001d9c:	0a893783          	ld	a5,168(s2)
    80001da0:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001da4:	37fd                	addiw	a5,a5,-1
    80001da6:	02200713          	li	a4,34
    80001daa:	00f76f63          	bltu	a4,a5,80001dc8 <syscall+0x42>
    80001dae:	00369713          	slli	a4,a3,0x3
    80001db2:	00006797          	auipc	a5,0x6
    80001db6:	a5e78793          	addi	a5,a5,-1442 # 80007810 <syscalls>
    80001dba:	97ba                	add	a5,a5,a4
    80001dbc:	639c                	ld	a5,0(a5)
    80001dbe:	c789                	beqz	a5,80001dc8 <syscall+0x42>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001dc0:	9782                	jalr	a5
    80001dc2:	06a93823          	sd	a0,112(s2)
    80001dc6:	a829                	j	80001de0 <syscall+0x5a>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001dc8:	15848613          	addi	a2,s1,344
    80001dcc:	588c                	lw	a1,48(s1)
    80001dce:	00005517          	auipc	a0,0x5
    80001dd2:	62250513          	addi	a0,a0,1570 # 800073f0 <etext+0x3f0>
    80001dd6:	63a030ef          	jal	80005410 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001dda:	6cbc                	ld	a5,88(s1)
    80001ddc:	577d                	li	a4,-1
    80001dde:	fbb8                	sd	a4,112(a5)
  }
}
    80001de0:	60e2                	ld	ra,24(sp)
    80001de2:	6442                	ld	s0,16(sp)
    80001de4:	64a2                	ld	s1,8(sp)
    80001de6:	6902                	ld	s2,0(sp)
    80001de8:	6105                	addi	sp,sp,32
    80001dea:	8082                	ret

0000000080001dec <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80001dec:	1101                	addi	sp,sp,-32
    80001dee:	ec06                	sd	ra,24(sp)
    80001df0:	e822                	sd	s0,16(sp)
    80001df2:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001df4:	fec40593          	addi	a1,s0,-20
    80001df8:	4501                	li	a0,0
    80001dfa:	f25ff0ef          	jal	80001d1e <argint>
  exit(n);
    80001dfe:	fec42503          	lw	a0,-20(s0)
    80001e02:	f42ff0ef          	jal	80001544 <exit>
  return 0;  // not reached
}
    80001e06:	4501                	li	a0,0
    80001e08:	60e2                	ld	ra,24(sp)
    80001e0a:	6442                	ld	s0,16(sp)
    80001e0c:	6105                	addi	sp,sp,32
    80001e0e:	8082                	ret

0000000080001e10 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001e10:	1141                	addi	sp,sp,-16
    80001e12:	e406                	sd	ra,8(sp)
    80001e14:	e022                	sd	s0,0(sp)
    80001e16:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001e18:	852ff0ef          	jal	80000e6a <myproc>
}
    80001e1c:	5908                	lw	a0,48(a0)
    80001e1e:	60a2                	ld	ra,8(sp)
    80001e20:	6402                	ld	s0,0(sp)
    80001e22:	0141                	addi	sp,sp,16
    80001e24:	8082                	ret

0000000080001e26 <sys_fork>:

uint64
sys_fork(void)
{
    80001e26:	1141                	addi	sp,sp,-16
    80001e28:	e406                	sd	ra,8(sp)
    80001e2a:	e022                	sd	s0,0(sp)
    80001e2c:	0800                	addi	s0,sp,16
  return fork();
    80001e2e:	b62ff0ef          	jal	80001190 <fork>
}
    80001e32:	60a2                	ld	ra,8(sp)
    80001e34:	6402                	ld	s0,0(sp)
    80001e36:	0141                	addi	sp,sp,16
    80001e38:	8082                	ret

0000000080001e3a <sys_wait>:

uint64
sys_wait(void)
{
    80001e3a:	1101                	addi	sp,sp,-32
    80001e3c:	ec06                	sd	ra,24(sp)
    80001e3e:	e822                	sd	s0,16(sp)
    80001e40:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001e42:	fe840593          	addi	a1,s0,-24
    80001e46:	4501                	li	a0,0
    80001e48:	ef3ff0ef          	jal	80001d3a <argaddr>
  return wait(p);
    80001e4c:	fe843503          	ld	a0,-24(s0)
    80001e50:	84bff0ef          	jal	8000169a <wait>
}
    80001e54:	60e2                	ld	ra,24(sp)
    80001e56:	6442                	ld	s0,16(sp)
    80001e58:	6105                	addi	sp,sp,32
    80001e5a:	8082                	ret

0000000080001e5c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001e5c:	7179                	addi	sp,sp,-48
    80001e5e:	f406                	sd	ra,40(sp)
    80001e60:	f022                	sd	s0,32(sp)
    80001e62:	ec26                	sd	s1,24(sp)
    80001e64:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80001e66:	fdc40593          	addi	a1,s0,-36
    80001e6a:	4501                	li	a0,0
    80001e6c:	eb3ff0ef          	jal	80001d1e <argint>
  addr = myproc()->sz;
    80001e70:	ffbfe0ef          	jal	80000e6a <myproc>
    80001e74:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80001e76:	fdc42503          	lw	a0,-36(s0)
    80001e7a:	ac6ff0ef          	jal	80001140 <growproc>
    80001e7e:	00054863          	bltz	a0,80001e8e <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80001e82:	8526                	mv	a0,s1
    80001e84:	70a2                	ld	ra,40(sp)
    80001e86:	7402                	ld	s0,32(sp)
    80001e88:	64e2                	ld	s1,24(sp)
    80001e8a:	6145                	addi	sp,sp,48
    80001e8c:	8082                	ret
    return -1;
    80001e8e:	54fd                	li	s1,-1
    80001e90:	bfcd                	j	80001e82 <sys_sbrk+0x26>

0000000080001e92 <sys_sleep>:

uint64
sys_sleep(void)
{
    80001e92:	7139                	addi	sp,sp,-64
    80001e94:	fc06                	sd	ra,56(sp)
    80001e96:	f822                	sd	s0,48(sp)
    80001e98:	f04a                	sd	s2,32(sp)
    80001e9a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  argint(0, &n);
    80001e9c:	fcc40593          	addi	a1,s0,-52
    80001ea0:	4501                	li	a0,0
    80001ea2:	e7dff0ef          	jal	80001d1e <argint>
  if(n < 0)
    80001ea6:	fcc42783          	lw	a5,-52(s0)
    80001eaa:	0607c763          	bltz	a5,80001f18 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80001eae:	0000c517          	auipc	a0,0xc
    80001eb2:	97250513          	addi	a0,a0,-1678 # 8000d820 <tickslock>
    80001eb6:	35b030ef          	jal	80005a10 <acquire>
  ticks0 = ticks;
    80001eba:	00006917          	auipc	s2,0x6
    80001ebe:	afe92903          	lw	s2,-1282(s2) # 800079b8 <ticks>
  while(ticks - ticks0 < n){
    80001ec2:	fcc42783          	lw	a5,-52(s0)
    80001ec6:	cf8d                	beqz	a5,80001f00 <sys_sleep+0x6e>
    80001ec8:	f426                	sd	s1,40(sp)
    80001eca:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001ecc:	0000c997          	auipc	s3,0xc
    80001ed0:	95498993          	addi	s3,s3,-1708 # 8000d820 <tickslock>
    80001ed4:	00006497          	auipc	s1,0x6
    80001ed8:	ae448493          	addi	s1,s1,-1308 # 800079b8 <ticks>
    if(killed(myproc())){
    80001edc:	f8ffe0ef          	jal	80000e6a <myproc>
    80001ee0:	f90ff0ef          	jal	80001670 <killed>
    80001ee4:	ed0d                	bnez	a0,80001f1e <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80001ee6:	85ce                	mv	a1,s3
    80001ee8:	8526                	mv	a0,s1
    80001eea:	d4eff0ef          	jal	80001438 <sleep>
  while(ticks - ticks0 < n){
    80001eee:	409c                	lw	a5,0(s1)
    80001ef0:	412787bb          	subw	a5,a5,s2
    80001ef4:	fcc42703          	lw	a4,-52(s0)
    80001ef8:	fee7e2e3          	bltu	a5,a4,80001edc <sys_sleep+0x4a>
    80001efc:	74a2                	ld	s1,40(sp)
    80001efe:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001f00:	0000c517          	auipc	a0,0xc
    80001f04:	92050513          	addi	a0,a0,-1760 # 8000d820 <tickslock>
    80001f08:	3a1030ef          	jal	80005aa8 <release>
  return 0;
    80001f0c:	4501                	li	a0,0
}
    80001f0e:	70e2                	ld	ra,56(sp)
    80001f10:	7442                	ld	s0,48(sp)
    80001f12:	7902                	ld	s2,32(sp)
    80001f14:	6121                	addi	sp,sp,64
    80001f16:	8082                	ret
    n = 0;
    80001f18:	fc042623          	sw	zero,-52(s0)
    80001f1c:	bf49                	j	80001eae <sys_sleep+0x1c>
      release(&tickslock);
    80001f1e:	0000c517          	auipc	a0,0xc
    80001f22:	90250513          	addi	a0,a0,-1790 # 8000d820 <tickslock>
    80001f26:	383030ef          	jal	80005aa8 <release>
      return -1;
    80001f2a:	557d                	li	a0,-1
    80001f2c:	74a2                	ld	s1,40(sp)
    80001f2e:	69e2                	ld	s3,24(sp)
    80001f30:	bff9                	j	80001f0e <sys_sleep+0x7c>

0000000080001f32 <sys_pgpte>:


#ifdef LAB_PGTBL
int
sys_pgpte(void)
{
    80001f32:	7179                	addi	sp,sp,-48
    80001f34:	f406                	sd	ra,40(sp)
    80001f36:	f022                	sd	s0,32(sp)
    80001f38:	ec26                	sd	s1,24(sp)
    80001f3a:	1800                	addi	s0,sp,48
  uint64 va;
  struct proc *p;  

  p = myproc();
    80001f3c:	f2ffe0ef          	jal	80000e6a <myproc>
    80001f40:	84aa                	mv	s1,a0
  argaddr(0, &va);
    80001f42:	fd840593          	addi	a1,s0,-40
    80001f46:	4501                	li	a0,0
    80001f48:	df3ff0ef          	jal	80001d3a <argaddr>
  pte_t *pte = pgpte(p->pagetable, va);
    80001f4c:	fd843583          	ld	a1,-40(s0)
    80001f50:	68a8                	ld	a0,80(s1)
    80001f52:	d8dfe0ef          	jal	80000cde <pgpte>
    80001f56:	87aa                	mv	a5,a0
  if(pte != 0) {
      return (uint64) *pte;
  }
  return 0;
    80001f58:	4501                	li	a0,0
  if(pte != 0) {
    80001f5a:	c391                	beqz	a5,80001f5e <sys_pgpte+0x2c>
      return (uint64) *pte;
    80001f5c:	4388                	lw	a0,0(a5)
}
    80001f5e:	70a2                	ld	ra,40(sp)
    80001f60:	7402                	ld	s0,32(sp)
    80001f62:	64e2                	ld	s1,24(sp)
    80001f64:	6145                	addi	sp,sp,48
    80001f66:	8082                	ret

0000000080001f68 <sys_kpgtbl>:
#endif

#ifdef LAB_PGTBL
int
sys_kpgtbl(void)
{
    80001f68:	1141                	addi	sp,sp,-16
    80001f6a:	e406                	sd	ra,8(sp)
    80001f6c:	e022                	sd	s0,0(sp)
    80001f6e:	0800                	addi	s0,sp,16
  struct proc *p;  

  p = myproc();
    80001f70:	efbfe0ef          	jal	80000e6a <myproc>
  vmprint(p->pagetable);
    80001f74:	6928                	ld	a0,80(a0)
    80001f76:	d3dfe0ef          	jal	80000cb2 <vmprint>
  return 0;
}
    80001f7a:	4501                	li	a0,0
    80001f7c:	60a2                	ld	ra,8(sp)
    80001f7e:	6402                	ld	s0,0(sp)
    80001f80:	0141                	addi	sp,sp,16
    80001f82:	8082                	ret

0000000080001f84 <sys_kill>:
#endif


uint64
sys_kill(void)
{
    80001f84:	1101                	addi	sp,sp,-32
    80001f86:	ec06                	sd	ra,24(sp)
    80001f88:	e822                	sd	s0,16(sp)
    80001f8a:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001f8c:	fec40593          	addi	a1,s0,-20
    80001f90:	4501                	li	a0,0
    80001f92:	d8dff0ef          	jal	80001d1e <argint>
  return kill(pid);
    80001f96:	fec42503          	lw	a0,-20(s0)
    80001f9a:	e4cff0ef          	jal	800015e6 <kill>
}
    80001f9e:	60e2                	ld	ra,24(sp)
    80001fa0:	6442                	ld	s0,16(sp)
    80001fa2:	6105                	addi	sp,sp,32
    80001fa4:	8082                	ret

0000000080001fa6 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001fa6:	1101                	addi	sp,sp,-32
    80001fa8:	ec06                	sd	ra,24(sp)
    80001faa:	e822                	sd	s0,16(sp)
    80001fac:	e426                	sd	s1,8(sp)
    80001fae:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001fb0:	0000c517          	auipc	a0,0xc
    80001fb4:	87050513          	addi	a0,a0,-1936 # 8000d820 <tickslock>
    80001fb8:	259030ef          	jal	80005a10 <acquire>
  xticks = ticks;
    80001fbc:	00006497          	auipc	s1,0x6
    80001fc0:	9fc4a483          	lw	s1,-1540(s1) # 800079b8 <ticks>
  release(&tickslock);
    80001fc4:	0000c517          	auipc	a0,0xc
    80001fc8:	85c50513          	addi	a0,a0,-1956 # 8000d820 <tickslock>
    80001fcc:	2dd030ef          	jal	80005aa8 <release>
  return xticks;
}
    80001fd0:	02049513          	slli	a0,s1,0x20
    80001fd4:	9101                	srli	a0,a0,0x20
    80001fd6:	60e2                	ld	ra,24(sp)
    80001fd8:	6442                	ld	s0,16(sp)
    80001fda:	64a2                	ld	s1,8(sp)
    80001fdc:	6105                	addi	sp,sp,32
    80001fde:	8082                	ret

0000000080001fe0 <sys_pgaccess>:
uint64 sys_pgaccess(void) {
    80001fe0:	715d                	addi	sp,sp,-80
    80001fe2:	e486                	sd	ra,72(sp)
    80001fe4:	e0a2                	sd	s0,64(sp)
    80001fe6:	0880                	addi	s0,sp,80
  uint64 start_addr; // Địa chỉ ảo bắt đầu
  int num_pages;     // Số trang cần kiểm tra
  uint64 user_mask;  // Địa chỉ user để lưu kết quả

  // Lấy tham số từ user space
  argaddr(0, &start_addr);
    80001fe8:	fc840593          	addi	a1,s0,-56
    80001fec:	4501                	li	a0,0
    80001fee:	d4dff0ef          	jal	80001d3a <argaddr>
  argint(1, &num_pages);
    80001ff2:	fc440593          	addi	a1,s0,-60
    80001ff6:	4505                	li	a0,1
    80001ff8:	d27ff0ef          	jal	80001d1e <argint>
  argaddr(2, &user_mask);
    80001ffc:	fb840593          	addi	a1,s0,-72
    80002000:	4509                	li	a0,2
    80002002:	d39ff0ef          	jal	80001d3a <argaddr>

  // Giới hạn số trang để tránh ảnh hưởng hiệu suất
  if (num_pages <= 0 || num_pages > 64)
    80002006:	fc442783          	lw	a5,-60(s0)
    8000200a:	37fd                	addiw	a5,a5,-1
    8000200c:	03f00713          	li	a4,63
      return -1;
    80002010:	557d                	li	a0,-1
  if (num_pages <= 0 || num_pages > 64)
    80002012:	08f76563          	bltu	a4,a5,8000209c <sys_pgaccess+0xbc>
    80002016:	f84a                	sd	s2,48(sp)

  struct proc *p = myproc();
    80002018:	e53fe0ef          	jal	80000e6a <myproc>
    8000201c:	892a                	mv	s2,a0
  uint64 mask = 0; // Lưu kết quả bitmask
    8000201e:	fa043823          	sd	zero,-80(s0)

  // Kiểm tra từng trang
  for (int i = 0; i < num_pages; i++) {
    80002022:	fc442783          	lw	a5,-60(s0)
    80002026:	06f05063          	blez	a5,80002086 <sys_pgaccess+0xa6>
    8000202a:	fc26                	sd	s1,56(sp)
    8000202c:	f44e                	sd	s3,40(sp)
    8000202e:	f052                	sd	s4,32(sp)
    80002030:	4481                	li	s1,0

      pte_t *pte = walk(pagetable, va, 0);
      if (pte == 0 || (*pte & PTE_V) == 0) // Nếu không có trang hợp lệ
          continue;

      if (*pte & PTE_A) { // Nếu trang đã được truy cập
    80002032:	04100993          	li	s3,65
          mask |= (1UL << i); // Ghi nhận vào bitmask
    80002036:	4a05                	li	s4,1
    80002038:	a801                	j	80002048 <sys_pgaccess+0x68>
  for (int i = 0; i < num_pages; i++) {
    8000203a:	0485                	addi	s1,s1,1
    8000203c:	fc442703          	lw	a4,-60(s0)
    80002040:	0004879b          	sext.w	a5,s1
    80002044:	02e7de63          	bge	a5,a4,80002080 <sys_pgaccess+0xa0>
      uint64 va = start_addr + i * PGSIZE; // Tính địa chỉ trang
    80002048:	00c49593          	slli	a1,s1,0xc
      pte_t *pte = walk(pagetable, va, 0);
    8000204c:	4601                	li	a2,0
    8000204e:	fc843783          	ld	a5,-56(s0)
    80002052:	95be                	add	a1,a1,a5
    80002054:	05093503          	ld	a0,80(s2)
    80002058:	b6afe0ef          	jal	800003c2 <walk>
      if (pte == 0 || (*pte & PTE_V) == 0) // Nếu không có trang hợp lệ
    8000205c:	dd79                	beqz	a0,8000203a <sys_pgaccess+0x5a>
      if (*pte & PTE_A) { // Nếu trang đã được truy cập
    8000205e:	611c                	ld	a5,0(a0)
    80002060:	0417f793          	andi	a5,a5,65
    80002064:	fd379be3          	bne	a5,s3,8000203a <sys_pgaccess+0x5a>
          mask |= (1UL << i); // Ghi nhận vào bitmask
    80002068:	009a1733          	sll	a4,s4,s1
    8000206c:	fb043783          	ld	a5,-80(s0)
    80002070:	8fd9                	or	a5,a5,a4
    80002072:	faf43823          	sd	a5,-80(s0)
          *pte &= ~PTE_A; // Xóa bit PTE_A để reset trạng thái
    80002076:	611c                	ld	a5,0(a0)
    80002078:	fbf7f793          	andi	a5,a5,-65
    8000207c:	e11c                	sd	a5,0(a0)
    8000207e:	bf75                	j	8000203a <sys_pgaccess+0x5a>
    80002080:	74e2                	ld	s1,56(sp)
    80002082:	79a2                	ld	s3,40(sp)
    80002084:	7a02                	ld	s4,32(sp)
      }
  }

  // Copy bitmask từ kernel về user space
  if (copyout(p->pagetable, user_mask, (char *)&mask, sizeof(mask)) < 0)
    80002086:	46a1                	li	a3,8
    80002088:	fb040613          	addi	a2,s0,-80
    8000208c:	fb843583          	ld	a1,-72(s0)
    80002090:	05093503          	ld	a0,80(s2)
    80002094:	95ffe0ef          	jal	800009f2 <copyout>
    80002098:	957d                	srai	a0,a0,0x3f
    8000209a:	7942                	ld	s2,48(sp)
      return -1;

  return 0; // Thành công
    8000209c:	60a6                	ld	ra,72(sp)
    8000209e:	6406                	ld	s0,64(sp)
    800020a0:	6161                	addi	sp,sp,80
    800020a2:	8082                	ret

00000000800020a4 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800020a4:	7179                	addi	sp,sp,-48
    800020a6:	f406                	sd	ra,40(sp)
    800020a8:	f022                	sd	s0,32(sp)
    800020aa:	ec26                	sd	s1,24(sp)
    800020ac:	e84a                	sd	s2,16(sp)
    800020ae:	e44e                	sd	s3,8(sp)
    800020b0:	e052                	sd	s4,0(sp)
    800020b2:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800020b4:	00005597          	auipc	a1,0x5
    800020b8:	35c58593          	addi	a1,a1,860 # 80007410 <etext+0x410>
    800020bc:	0000b517          	auipc	a0,0xb
    800020c0:	77c50513          	addi	a0,a0,1916 # 8000d838 <bcache>
    800020c4:	0cd030ef          	jal	80005990 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800020c8:	00013797          	auipc	a5,0x13
    800020cc:	77078793          	addi	a5,a5,1904 # 80015838 <bcache+0x8000>
    800020d0:	00014717          	auipc	a4,0x14
    800020d4:	9d070713          	addi	a4,a4,-1584 # 80015aa0 <bcache+0x8268>
    800020d8:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800020dc:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800020e0:	0000b497          	auipc	s1,0xb
    800020e4:	77048493          	addi	s1,s1,1904 # 8000d850 <bcache+0x18>
    b->next = bcache.head.next;
    800020e8:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800020ea:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800020ec:	00005a17          	auipc	s4,0x5
    800020f0:	32ca0a13          	addi	s4,s4,812 # 80007418 <etext+0x418>
    b->next = bcache.head.next;
    800020f4:	2b893783          	ld	a5,696(s2)
    800020f8:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800020fa:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800020fe:	85d2                	mv	a1,s4
    80002100:	01048513          	addi	a0,s1,16
    80002104:	248010ef          	jal	8000334c <initsleeplock>
    bcache.head.next->prev = b;
    80002108:	2b893783          	ld	a5,696(s2)
    8000210c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000210e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002112:	45848493          	addi	s1,s1,1112
    80002116:	fd349fe3          	bne	s1,s3,800020f4 <binit+0x50>
  }
}
    8000211a:	70a2                	ld	ra,40(sp)
    8000211c:	7402                	ld	s0,32(sp)
    8000211e:	64e2                	ld	s1,24(sp)
    80002120:	6942                	ld	s2,16(sp)
    80002122:	69a2                	ld	s3,8(sp)
    80002124:	6a02                	ld	s4,0(sp)
    80002126:	6145                	addi	sp,sp,48
    80002128:	8082                	ret

000000008000212a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000212a:	7179                	addi	sp,sp,-48
    8000212c:	f406                	sd	ra,40(sp)
    8000212e:	f022                	sd	s0,32(sp)
    80002130:	ec26                	sd	s1,24(sp)
    80002132:	e84a                	sd	s2,16(sp)
    80002134:	e44e                	sd	s3,8(sp)
    80002136:	1800                	addi	s0,sp,48
    80002138:	892a                	mv	s2,a0
    8000213a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000213c:	0000b517          	auipc	a0,0xb
    80002140:	6fc50513          	addi	a0,a0,1788 # 8000d838 <bcache>
    80002144:	0cd030ef          	jal	80005a10 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002148:	00014497          	auipc	s1,0x14
    8000214c:	9a84b483          	ld	s1,-1624(s1) # 80015af0 <bcache+0x82b8>
    80002150:	00014797          	auipc	a5,0x14
    80002154:	95078793          	addi	a5,a5,-1712 # 80015aa0 <bcache+0x8268>
    80002158:	02f48b63          	beq	s1,a5,8000218e <bread+0x64>
    8000215c:	873e                	mv	a4,a5
    8000215e:	a021                	j	80002166 <bread+0x3c>
    80002160:	68a4                	ld	s1,80(s1)
    80002162:	02e48663          	beq	s1,a4,8000218e <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002166:	449c                	lw	a5,8(s1)
    80002168:	ff279ce3          	bne	a5,s2,80002160 <bread+0x36>
    8000216c:	44dc                	lw	a5,12(s1)
    8000216e:	ff3799e3          	bne	a5,s3,80002160 <bread+0x36>
      b->refcnt++;
    80002172:	40bc                	lw	a5,64(s1)
    80002174:	2785                	addiw	a5,a5,1
    80002176:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002178:	0000b517          	auipc	a0,0xb
    8000217c:	6c050513          	addi	a0,a0,1728 # 8000d838 <bcache>
    80002180:	129030ef          	jal	80005aa8 <release>
      acquiresleep(&b->lock);
    80002184:	01048513          	addi	a0,s1,16
    80002188:	1fa010ef          	jal	80003382 <acquiresleep>
      return b;
    8000218c:	a889                	j	800021de <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000218e:	00014497          	auipc	s1,0x14
    80002192:	95a4b483          	ld	s1,-1702(s1) # 80015ae8 <bcache+0x82b0>
    80002196:	00014797          	auipc	a5,0x14
    8000219a:	90a78793          	addi	a5,a5,-1782 # 80015aa0 <bcache+0x8268>
    8000219e:	00f48863          	beq	s1,a5,800021ae <bread+0x84>
    800021a2:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800021a4:	40bc                	lw	a5,64(s1)
    800021a6:	cb91                	beqz	a5,800021ba <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800021a8:	64a4                	ld	s1,72(s1)
    800021aa:	fee49de3          	bne	s1,a4,800021a4 <bread+0x7a>
  panic("bget: no buffers");
    800021ae:	00005517          	auipc	a0,0x5
    800021b2:	27250513          	addi	a0,a0,626 # 80007420 <etext+0x420>
    800021b6:	52c030ef          	jal	800056e2 <panic>
      b->dev = dev;
    800021ba:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800021be:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800021c2:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800021c6:	4785                	li	a5,1
    800021c8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800021ca:	0000b517          	auipc	a0,0xb
    800021ce:	66e50513          	addi	a0,a0,1646 # 8000d838 <bcache>
    800021d2:	0d7030ef          	jal	80005aa8 <release>
      acquiresleep(&b->lock);
    800021d6:	01048513          	addi	a0,s1,16
    800021da:	1a8010ef          	jal	80003382 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800021de:	409c                	lw	a5,0(s1)
    800021e0:	cb89                	beqz	a5,800021f2 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800021e2:	8526                	mv	a0,s1
    800021e4:	70a2                	ld	ra,40(sp)
    800021e6:	7402                	ld	s0,32(sp)
    800021e8:	64e2                	ld	s1,24(sp)
    800021ea:	6942                	ld	s2,16(sp)
    800021ec:	69a2                	ld	s3,8(sp)
    800021ee:	6145                	addi	sp,sp,48
    800021f0:	8082                	ret
    virtio_disk_rw(b, 0);
    800021f2:	4581                	li	a1,0
    800021f4:	8526                	mv	a0,s1
    800021f6:	2bb020ef          	jal	80004cb0 <virtio_disk_rw>
    b->valid = 1;
    800021fa:	4785                	li	a5,1
    800021fc:	c09c                	sw	a5,0(s1)
  return b;
    800021fe:	b7d5                	j	800021e2 <bread+0xb8>

0000000080002200 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002200:	1101                	addi	sp,sp,-32
    80002202:	ec06                	sd	ra,24(sp)
    80002204:	e822                	sd	s0,16(sp)
    80002206:	e426                	sd	s1,8(sp)
    80002208:	1000                	addi	s0,sp,32
    8000220a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000220c:	0541                	addi	a0,a0,16
    8000220e:	1f2010ef          	jal	80003400 <holdingsleep>
    80002212:	c911                	beqz	a0,80002226 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002214:	4585                	li	a1,1
    80002216:	8526                	mv	a0,s1
    80002218:	299020ef          	jal	80004cb0 <virtio_disk_rw>
}
    8000221c:	60e2                	ld	ra,24(sp)
    8000221e:	6442                	ld	s0,16(sp)
    80002220:	64a2                	ld	s1,8(sp)
    80002222:	6105                	addi	sp,sp,32
    80002224:	8082                	ret
    panic("bwrite");
    80002226:	00005517          	auipc	a0,0x5
    8000222a:	21250513          	addi	a0,a0,530 # 80007438 <etext+0x438>
    8000222e:	4b4030ef          	jal	800056e2 <panic>

0000000080002232 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002232:	1101                	addi	sp,sp,-32
    80002234:	ec06                	sd	ra,24(sp)
    80002236:	e822                	sd	s0,16(sp)
    80002238:	e426                	sd	s1,8(sp)
    8000223a:	e04a                	sd	s2,0(sp)
    8000223c:	1000                	addi	s0,sp,32
    8000223e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002240:	01050913          	addi	s2,a0,16
    80002244:	854a                	mv	a0,s2
    80002246:	1ba010ef          	jal	80003400 <holdingsleep>
    8000224a:	c135                	beqz	a0,800022ae <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    8000224c:	854a                	mv	a0,s2
    8000224e:	17a010ef          	jal	800033c8 <releasesleep>

  acquire(&bcache.lock);
    80002252:	0000b517          	auipc	a0,0xb
    80002256:	5e650513          	addi	a0,a0,1510 # 8000d838 <bcache>
    8000225a:	7b6030ef          	jal	80005a10 <acquire>
  b->refcnt--;
    8000225e:	40bc                	lw	a5,64(s1)
    80002260:	37fd                	addiw	a5,a5,-1
    80002262:	0007871b          	sext.w	a4,a5
    80002266:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002268:	e71d                	bnez	a4,80002296 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000226a:	68b8                	ld	a4,80(s1)
    8000226c:	64bc                	ld	a5,72(s1)
    8000226e:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002270:	68b8                	ld	a4,80(s1)
    80002272:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002274:	00013797          	auipc	a5,0x13
    80002278:	5c478793          	addi	a5,a5,1476 # 80015838 <bcache+0x8000>
    8000227c:	2b87b703          	ld	a4,696(a5)
    80002280:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002282:	00014717          	auipc	a4,0x14
    80002286:	81e70713          	addi	a4,a4,-2018 # 80015aa0 <bcache+0x8268>
    8000228a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000228c:	2b87b703          	ld	a4,696(a5)
    80002290:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002292:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002296:	0000b517          	auipc	a0,0xb
    8000229a:	5a250513          	addi	a0,a0,1442 # 8000d838 <bcache>
    8000229e:	00b030ef          	jal	80005aa8 <release>
}
    800022a2:	60e2                	ld	ra,24(sp)
    800022a4:	6442                	ld	s0,16(sp)
    800022a6:	64a2                	ld	s1,8(sp)
    800022a8:	6902                	ld	s2,0(sp)
    800022aa:	6105                	addi	sp,sp,32
    800022ac:	8082                	ret
    panic("brelse");
    800022ae:	00005517          	auipc	a0,0x5
    800022b2:	19250513          	addi	a0,a0,402 # 80007440 <etext+0x440>
    800022b6:	42c030ef          	jal	800056e2 <panic>

00000000800022ba <bpin>:

void
bpin(struct buf *b) {
    800022ba:	1101                	addi	sp,sp,-32
    800022bc:	ec06                	sd	ra,24(sp)
    800022be:	e822                	sd	s0,16(sp)
    800022c0:	e426                	sd	s1,8(sp)
    800022c2:	1000                	addi	s0,sp,32
    800022c4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800022c6:	0000b517          	auipc	a0,0xb
    800022ca:	57250513          	addi	a0,a0,1394 # 8000d838 <bcache>
    800022ce:	742030ef          	jal	80005a10 <acquire>
  b->refcnt++;
    800022d2:	40bc                	lw	a5,64(s1)
    800022d4:	2785                	addiw	a5,a5,1
    800022d6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800022d8:	0000b517          	auipc	a0,0xb
    800022dc:	56050513          	addi	a0,a0,1376 # 8000d838 <bcache>
    800022e0:	7c8030ef          	jal	80005aa8 <release>
}
    800022e4:	60e2                	ld	ra,24(sp)
    800022e6:	6442                	ld	s0,16(sp)
    800022e8:	64a2                	ld	s1,8(sp)
    800022ea:	6105                	addi	sp,sp,32
    800022ec:	8082                	ret

00000000800022ee <bunpin>:

void
bunpin(struct buf *b) {
    800022ee:	1101                	addi	sp,sp,-32
    800022f0:	ec06                	sd	ra,24(sp)
    800022f2:	e822                	sd	s0,16(sp)
    800022f4:	e426                	sd	s1,8(sp)
    800022f6:	1000                	addi	s0,sp,32
    800022f8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800022fa:	0000b517          	auipc	a0,0xb
    800022fe:	53e50513          	addi	a0,a0,1342 # 8000d838 <bcache>
    80002302:	70e030ef          	jal	80005a10 <acquire>
  b->refcnt--;
    80002306:	40bc                	lw	a5,64(s1)
    80002308:	37fd                	addiw	a5,a5,-1
    8000230a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000230c:	0000b517          	auipc	a0,0xb
    80002310:	52c50513          	addi	a0,a0,1324 # 8000d838 <bcache>
    80002314:	794030ef          	jal	80005aa8 <release>
}
    80002318:	60e2                	ld	ra,24(sp)
    8000231a:	6442                	ld	s0,16(sp)
    8000231c:	64a2                	ld	s1,8(sp)
    8000231e:	6105                	addi	sp,sp,32
    80002320:	8082                	ret

0000000080002322 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002322:	1101                	addi	sp,sp,-32
    80002324:	ec06                	sd	ra,24(sp)
    80002326:	e822                	sd	s0,16(sp)
    80002328:	e426                	sd	s1,8(sp)
    8000232a:	e04a                	sd	s2,0(sp)
    8000232c:	1000                	addi	s0,sp,32
    8000232e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002330:	00d5d59b          	srliw	a1,a1,0xd
    80002334:	00014797          	auipc	a5,0x14
    80002338:	be07a783          	lw	a5,-1056(a5) # 80015f14 <sb+0x1c>
    8000233c:	9dbd                	addw	a1,a1,a5
    8000233e:	dedff0ef          	jal	8000212a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002342:	0074f713          	andi	a4,s1,7
    80002346:	4785                	li	a5,1
    80002348:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000234c:	14ce                	slli	s1,s1,0x33
    8000234e:	90d9                	srli	s1,s1,0x36
    80002350:	00950733          	add	a4,a0,s1
    80002354:	05874703          	lbu	a4,88(a4)
    80002358:	00e7f6b3          	and	a3,a5,a4
    8000235c:	c29d                	beqz	a3,80002382 <bfree+0x60>
    8000235e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002360:	94aa                	add	s1,s1,a0
    80002362:	fff7c793          	not	a5,a5
    80002366:	8f7d                	and	a4,a4,a5
    80002368:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000236c:	711000ef          	jal	8000327c <log_write>
  brelse(bp);
    80002370:	854a                	mv	a0,s2
    80002372:	ec1ff0ef          	jal	80002232 <brelse>
}
    80002376:	60e2                	ld	ra,24(sp)
    80002378:	6442                	ld	s0,16(sp)
    8000237a:	64a2                	ld	s1,8(sp)
    8000237c:	6902                	ld	s2,0(sp)
    8000237e:	6105                	addi	sp,sp,32
    80002380:	8082                	ret
    panic("freeing free block");
    80002382:	00005517          	auipc	a0,0x5
    80002386:	0c650513          	addi	a0,a0,198 # 80007448 <etext+0x448>
    8000238a:	358030ef          	jal	800056e2 <panic>

000000008000238e <balloc>:
{
    8000238e:	711d                	addi	sp,sp,-96
    80002390:	ec86                	sd	ra,88(sp)
    80002392:	e8a2                	sd	s0,80(sp)
    80002394:	e4a6                	sd	s1,72(sp)
    80002396:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002398:	00014797          	auipc	a5,0x14
    8000239c:	b647a783          	lw	a5,-1180(a5) # 80015efc <sb+0x4>
    800023a0:	0e078f63          	beqz	a5,8000249e <balloc+0x110>
    800023a4:	e0ca                	sd	s2,64(sp)
    800023a6:	fc4e                	sd	s3,56(sp)
    800023a8:	f852                	sd	s4,48(sp)
    800023aa:	f456                	sd	s5,40(sp)
    800023ac:	f05a                	sd	s6,32(sp)
    800023ae:	ec5e                	sd	s7,24(sp)
    800023b0:	e862                	sd	s8,16(sp)
    800023b2:	e466                	sd	s9,8(sp)
    800023b4:	8baa                	mv	s7,a0
    800023b6:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800023b8:	00014b17          	auipc	s6,0x14
    800023bc:	b40b0b13          	addi	s6,s6,-1216 # 80015ef8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800023c0:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800023c2:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800023c4:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800023c6:	6c89                	lui	s9,0x2
    800023c8:	a0b5                	j	80002434 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    800023ca:	97ca                	add	a5,a5,s2
    800023cc:	8e55                	or	a2,a2,a3
    800023ce:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800023d2:	854a                	mv	a0,s2
    800023d4:	6a9000ef          	jal	8000327c <log_write>
        brelse(bp);
    800023d8:	854a                	mv	a0,s2
    800023da:	e59ff0ef          	jal	80002232 <brelse>
  bp = bread(dev, bno);
    800023de:	85a6                	mv	a1,s1
    800023e0:	855e                	mv	a0,s7
    800023e2:	d49ff0ef          	jal	8000212a <bread>
    800023e6:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800023e8:	40000613          	li	a2,1024
    800023ec:	4581                	li	a1,0
    800023ee:	05850513          	addi	a0,a0,88
    800023f2:	d5dfd0ef          	jal	8000014e <memset>
  log_write(bp);
    800023f6:	854a                	mv	a0,s2
    800023f8:	685000ef          	jal	8000327c <log_write>
  brelse(bp);
    800023fc:	854a                	mv	a0,s2
    800023fe:	e35ff0ef          	jal	80002232 <brelse>
}
    80002402:	6906                	ld	s2,64(sp)
    80002404:	79e2                	ld	s3,56(sp)
    80002406:	7a42                	ld	s4,48(sp)
    80002408:	7aa2                	ld	s5,40(sp)
    8000240a:	7b02                	ld	s6,32(sp)
    8000240c:	6be2                	ld	s7,24(sp)
    8000240e:	6c42                	ld	s8,16(sp)
    80002410:	6ca2                	ld	s9,8(sp)
}
    80002412:	8526                	mv	a0,s1
    80002414:	60e6                	ld	ra,88(sp)
    80002416:	6446                	ld	s0,80(sp)
    80002418:	64a6                	ld	s1,72(sp)
    8000241a:	6125                	addi	sp,sp,96
    8000241c:	8082                	ret
    brelse(bp);
    8000241e:	854a                	mv	a0,s2
    80002420:	e13ff0ef          	jal	80002232 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002424:	015c87bb          	addw	a5,s9,s5
    80002428:	00078a9b          	sext.w	s5,a5
    8000242c:	004b2703          	lw	a4,4(s6)
    80002430:	04eaff63          	bgeu	s5,a4,8000248e <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80002434:	41fad79b          	sraiw	a5,s5,0x1f
    80002438:	0137d79b          	srliw	a5,a5,0x13
    8000243c:	015787bb          	addw	a5,a5,s5
    80002440:	40d7d79b          	sraiw	a5,a5,0xd
    80002444:	01cb2583          	lw	a1,28(s6)
    80002448:	9dbd                	addw	a1,a1,a5
    8000244a:	855e                	mv	a0,s7
    8000244c:	cdfff0ef          	jal	8000212a <bread>
    80002450:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002452:	004b2503          	lw	a0,4(s6)
    80002456:	000a849b          	sext.w	s1,s5
    8000245a:	8762                	mv	a4,s8
    8000245c:	fca4f1e3          	bgeu	s1,a0,8000241e <balloc+0x90>
      m = 1 << (bi % 8);
    80002460:	00777693          	andi	a3,a4,7
    80002464:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002468:	41f7579b          	sraiw	a5,a4,0x1f
    8000246c:	01d7d79b          	srliw	a5,a5,0x1d
    80002470:	9fb9                	addw	a5,a5,a4
    80002472:	4037d79b          	sraiw	a5,a5,0x3
    80002476:	00f90633          	add	a2,s2,a5
    8000247a:	05864603          	lbu	a2,88(a2)
    8000247e:	00c6f5b3          	and	a1,a3,a2
    80002482:	d5a1                	beqz	a1,800023ca <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002484:	2705                	addiw	a4,a4,1
    80002486:	2485                	addiw	s1,s1,1
    80002488:	fd471ae3          	bne	a4,s4,8000245c <balloc+0xce>
    8000248c:	bf49                	j	8000241e <balloc+0x90>
    8000248e:	6906                	ld	s2,64(sp)
    80002490:	79e2                	ld	s3,56(sp)
    80002492:	7a42                	ld	s4,48(sp)
    80002494:	7aa2                	ld	s5,40(sp)
    80002496:	7b02                	ld	s6,32(sp)
    80002498:	6be2                	ld	s7,24(sp)
    8000249a:	6c42                	ld	s8,16(sp)
    8000249c:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    8000249e:	00005517          	auipc	a0,0x5
    800024a2:	fc250513          	addi	a0,a0,-62 # 80007460 <etext+0x460>
    800024a6:	76b020ef          	jal	80005410 <printf>
  return 0;
    800024aa:	4481                	li	s1,0
    800024ac:	b79d                	j	80002412 <balloc+0x84>

00000000800024ae <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800024ae:	7179                	addi	sp,sp,-48
    800024b0:	f406                	sd	ra,40(sp)
    800024b2:	f022                	sd	s0,32(sp)
    800024b4:	ec26                	sd	s1,24(sp)
    800024b6:	e84a                	sd	s2,16(sp)
    800024b8:	e44e                	sd	s3,8(sp)
    800024ba:	1800                	addi	s0,sp,48
    800024bc:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800024be:	47ad                	li	a5,11
    800024c0:	02b7e663          	bltu	a5,a1,800024ec <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    800024c4:	02059793          	slli	a5,a1,0x20
    800024c8:	01e7d593          	srli	a1,a5,0x1e
    800024cc:	00b504b3          	add	s1,a0,a1
    800024d0:	0504a903          	lw	s2,80(s1)
    800024d4:	06091a63          	bnez	s2,80002548 <bmap+0x9a>
      addr = balloc(ip->dev);
    800024d8:	4108                	lw	a0,0(a0)
    800024da:	eb5ff0ef          	jal	8000238e <balloc>
    800024de:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800024e2:	06090363          	beqz	s2,80002548 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    800024e6:	0524a823          	sw	s2,80(s1)
    800024ea:	a8b9                	j	80002548 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800024ec:	ff45849b          	addiw	s1,a1,-12
    800024f0:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800024f4:	0ff00793          	li	a5,255
    800024f8:	06e7ee63          	bltu	a5,a4,80002574 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800024fc:	08052903          	lw	s2,128(a0)
    80002500:	00091d63          	bnez	s2,8000251a <bmap+0x6c>
      addr = balloc(ip->dev);
    80002504:	4108                	lw	a0,0(a0)
    80002506:	e89ff0ef          	jal	8000238e <balloc>
    8000250a:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000250e:	02090d63          	beqz	s2,80002548 <bmap+0x9a>
    80002512:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002514:	0929a023          	sw	s2,128(s3)
    80002518:	a011                	j	8000251c <bmap+0x6e>
    8000251a:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    8000251c:	85ca                	mv	a1,s2
    8000251e:	0009a503          	lw	a0,0(s3)
    80002522:	c09ff0ef          	jal	8000212a <bread>
    80002526:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002528:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000252c:	02049713          	slli	a4,s1,0x20
    80002530:	01e75593          	srli	a1,a4,0x1e
    80002534:	00b784b3          	add	s1,a5,a1
    80002538:	0004a903          	lw	s2,0(s1)
    8000253c:	00090e63          	beqz	s2,80002558 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002540:	8552                	mv	a0,s4
    80002542:	cf1ff0ef          	jal	80002232 <brelse>
    return addr;
    80002546:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002548:	854a                	mv	a0,s2
    8000254a:	70a2                	ld	ra,40(sp)
    8000254c:	7402                	ld	s0,32(sp)
    8000254e:	64e2                	ld	s1,24(sp)
    80002550:	6942                	ld	s2,16(sp)
    80002552:	69a2                	ld	s3,8(sp)
    80002554:	6145                	addi	sp,sp,48
    80002556:	8082                	ret
      addr = balloc(ip->dev);
    80002558:	0009a503          	lw	a0,0(s3)
    8000255c:	e33ff0ef          	jal	8000238e <balloc>
    80002560:	0005091b          	sext.w	s2,a0
      if(addr){
    80002564:	fc090ee3          	beqz	s2,80002540 <bmap+0x92>
        a[bn] = addr;
    80002568:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000256c:	8552                	mv	a0,s4
    8000256e:	50f000ef          	jal	8000327c <log_write>
    80002572:	b7f9                	j	80002540 <bmap+0x92>
    80002574:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002576:	00005517          	auipc	a0,0x5
    8000257a:	f0250513          	addi	a0,a0,-254 # 80007478 <etext+0x478>
    8000257e:	164030ef          	jal	800056e2 <panic>

0000000080002582 <iget>:
{
    80002582:	7179                	addi	sp,sp,-48
    80002584:	f406                	sd	ra,40(sp)
    80002586:	f022                	sd	s0,32(sp)
    80002588:	ec26                	sd	s1,24(sp)
    8000258a:	e84a                	sd	s2,16(sp)
    8000258c:	e44e                	sd	s3,8(sp)
    8000258e:	e052                	sd	s4,0(sp)
    80002590:	1800                	addi	s0,sp,48
    80002592:	89aa                	mv	s3,a0
    80002594:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002596:	00014517          	auipc	a0,0x14
    8000259a:	98250513          	addi	a0,a0,-1662 # 80015f18 <itable>
    8000259e:	472030ef          	jal	80005a10 <acquire>
  empty = 0;
    800025a2:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800025a4:	00014497          	auipc	s1,0x14
    800025a8:	98c48493          	addi	s1,s1,-1652 # 80015f30 <itable+0x18>
    800025ac:	00015697          	auipc	a3,0x15
    800025b0:	41468693          	addi	a3,a3,1044 # 800179c0 <log>
    800025b4:	a039                	j	800025c2 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800025b6:	02090963          	beqz	s2,800025e8 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800025ba:	08848493          	addi	s1,s1,136
    800025be:	02d48863          	beq	s1,a3,800025ee <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800025c2:	449c                	lw	a5,8(s1)
    800025c4:	fef059e3          	blez	a5,800025b6 <iget+0x34>
    800025c8:	4098                	lw	a4,0(s1)
    800025ca:	ff3716e3          	bne	a4,s3,800025b6 <iget+0x34>
    800025ce:	40d8                	lw	a4,4(s1)
    800025d0:	ff4713e3          	bne	a4,s4,800025b6 <iget+0x34>
      ip->ref++;
    800025d4:	2785                	addiw	a5,a5,1
    800025d6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800025d8:	00014517          	auipc	a0,0x14
    800025dc:	94050513          	addi	a0,a0,-1728 # 80015f18 <itable>
    800025e0:	4c8030ef          	jal	80005aa8 <release>
      return ip;
    800025e4:	8926                	mv	s2,s1
    800025e6:	a02d                	j	80002610 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800025e8:	fbe9                	bnez	a5,800025ba <iget+0x38>
      empty = ip;
    800025ea:	8926                	mv	s2,s1
    800025ec:	b7f9                	j	800025ba <iget+0x38>
  if(empty == 0)
    800025ee:	02090a63          	beqz	s2,80002622 <iget+0xa0>
  ip->dev = dev;
    800025f2:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800025f6:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800025fa:	4785                	li	a5,1
    800025fc:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002600:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002604:	00014517          	auipc	a0,0x14
    80002608:	91450513          	addi	a0,a0,-1772 # 80015f18 <itable>
    8000260c:	49c030ef          	jal	80005aa8 <release>
}
    80002610:	854a                	mv	a0,s2
    80002612:	70a2                	ld	ra,40(sp)
    80002614:	7402                	ld	s0,32(sp)
    80002616:	64e2                	ld	s1,24(sp)
    80002618:	6942                	ld	s2,16(sp)
    8000261a:	69a2                	ld	s3,8(sp)
    8000261c:	6a02                	ld	s4,0(sp)
    8000261e:	6145                	addi	sp,sp,48
    80002620:	8082                	ret
    panic("iget: no inodes");
    80002622:	00005517          	auipc	a0,0x5
    80002626:	e6e50513          	addi	a0,a0,-402 # 80007490 <etext+0x490>
    8000262a:	0b8030ef          	jal	800056e2 <panic>

000000008000262e <fsinit>:
fsinit(int dev) {
    8000262e:	7179                	addi	sp,sp,-48
    80002630:	f406                	sd	ra,40(sp)
    80002632:	f022                	sd	s0,32(sp)
    80002634:	ec26                	sd	s1,24(sp)
    80002636:	e84a                	sd	s2,16(sp)
    80002638:	e44e                	sd	s3,8(sp)
    8000263a:	1800                	addi	s0,sp,48
    8000263c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000263e:	4585                	li	a1,1
    80002640:	aebff0ef          	jal	8000212a <bread>
    80002644:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002646:	00014997          	auipc	s3,0x14
    8000264a:	8b298993          	addi	s3,s3,-1870 # 80015ef8 <sb>
    8000264e:	02000613          	li	a2,32
    80002652:	05850593          	addi	a1,a0,88
    80002656:	854e                	mv	a0,s3
    80002658:	b53fd0ef          	jal	800001aa <memmove>
  brelse(bp);
    8000265c:	8526                	mv	a0,s1
    8000265e:	bd5ff0ef          	jal	80002232 <brelse>
  if(sb.magic != FSMAGIC)
    80002662:	0009a703          	lw	a4,0(s3)
    80002666:	102037b7          	lui	a5,0x10203
    8000266a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000266e:	02f71063          	bne	a4,a5,8000268e <fsinit+0x60>
  initlog(dev, &sb);
    80002672:	00014597          	auipc	a1,0x14
    80002676:	88658593          	addi	a1,a1,-1914 # 80015ef8 <sb>
    8000267a:	854a                	mv	a0,s2
    8000267c:	1f9000ef          	jal	80003074 <initlog>
}
    80002680:	70a2                	ld	ra,40(sp)
    80002682:	7402                	ld	s0,32(sp)
    80002684:	64e2                	ld	s1,24(sp)
    80002686:	6942                	ld	s2,16(sp)
    80002688:	69a2                	ld	s3,8(sp)
    8000268a:	6145                	addi	sp,sp,48
    8000268c:	8082                	ret
    panic("invalid file system");
    8000268e:	00005517          	auipc	a0,0x5
    80002692:	e1250513          	addi	a0,a0,-494 # 800074a0 <etext+0x4a0>
    80002696:	04c030ef          	jal	800056e2 <panic>

000000008000269a <iinit>:
{
    8000269a:	7179                	addi	sp,sp,-48
    8000269c:	f406                	sd	ra,40(sp)
    8000269e:	f022                	sd	s0,32(sp)
    800026a0:	ec26                	sd	s1,24(sp)
    800026a2:	e84a                	sd	s2,16(sp)
    800026a4:	e44e                	sd	s3,8(sp)
    800026a6:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800026a8:	00005597          	auipc	a1,0x5
    800026ac:	e1058593          	addi	a1,a1,-496 # 800074b8 <etext+0x4b8>
    800026b0:	00014517          	auipc	a0,0x14
    800026b4:	86850513          	addi	a0,a0,-1944 # 80015f18 <itable>
    800026b8:	2d8030ef          	jal	80005990 <initlock>
  for(i = 0; i < NINODE; i++) {
    800026bc:	00014497          	auipc	s1,0x14
    800026c0:	88448493          	addi	s1,s1,-1916 # 80015f40 <itable+0x28>
    800026c4:	00015997          	auipc	s3,0x15
    800026c8:	30c98993          	addi	s3,s3,780 # 800179d0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800026cc:	00005917          	auipc	s2,0x5
    800026d0:	df490913          	addi	s2,s2,-524 # 800074c0 <etext+0x4c0>
    800026d4:	85ca                	mv	a1,s2
    800026d6:	8526                	mv	a0,s1
    800026d8:	475000ef          	jal	8000334c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800026dc:	08848493          	addi	s1,s1,136
    800026e0:	ff349ae3          	bne	s1,s3,800026d4 <iinit+0x3a>
}
    800026e4:	70a2                	ld	ra,40(sp)
    800026e6:	7402                	ld	s0,32(sp)
    800026e8:	64e2                	ld	s1,24(sp)
    800026ea:	6942                	ld	s2,16(sp)
    800026ec:	69a2                	ld	s3,8(sp)
    800026ee:	6145                	addi	sp,sp,48
    800026f0:	8082                	ret

00000000800026f2 <ialloc>:
{
    800026f2:	7139                	addi	sp,sp,-64
    800026f4:	fc06                	sd	ra,56(sp)
    800026f6:	f822                	sd	s0,48(sp)
    800026f8:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800026fa:	00014717          	auipc	a4,0x14
    800026fe:	80a72703          	lw	a4,-2038(a4) # 80015f04 <sb+0xc>
    80002702:	4785                	li	a5,1
    80002704:	06e7f063          	bgeu	a5,a4,80002764 <ialloc+0x72>
    80002708:	f426                	sd	s1,40(sp)
    8000270a:	f04a                	sd	s2,32(sp)
    8000270c:	ec4e                	sd	s3,24(sp)
    8000270e:	e852                	sd	s4,16(sp)
    80002710:	e456                	sd	s5,8(sp)
    80002712:	e05a                	sd	s6,0(sp)
    80002714:	8aaa                	mv	s5,a0
    80002716:	8b2e                	mv	s6,a1
    80002718:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000271a:	00013a17          	auipc	s4,0x13
    8000271e:	7dea0a13          	addi	s4,s4,2014 # 80015ef8 <sb>
    80002722:	00495593          	srli	a1,s2,0x4
    80002726:	018a2783          	lw	a5,24(s4)
    8000272a:	9dbd                	addw	a1,a1,a5
    8000272c:	8556                	mv	a0,s5
    8000272e:	9fdff0ef          	jal	8000212a <bread>
    80002732:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002734:	05850993          	addi	s3,a0,88
    80002738:	00f97793          	andi	a5,s2,15
    8000273c:	079a                	slli	a5,a5,0x6
    8000273e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002740:	00099783          	lh	a5,0(s3)
    80002744:	cb9d                	beqz	a5,8000277a <ialloc+0x88>
    brelse(bp);
    80002746:	aedff0ef          	jal	80002232 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000274a:	0905                	addi	s2,s2,1
    8000274c:	00ca2703          	lw	a4,12(s4)
    80002750:	0009079b          	sext.w	a5,s2
    80002754:	fce7e7e3          	bltu	a5,a4,80002722 <ialloc+0x30>
    80002758:	74a2                	ld	s1,40(sp)
    8000275a:	7902                	ld	s2,32(sp)
    8000275c:	69e2                	ld	s3,24(sp)
    8000275e:	6a42                	ld	s4,16(sp)
    80002760:	6aa2                	ld	s5,8(sp)
    80002762:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002764:	00005517          	auipc	a0,0x5
    80002768:	d6450513          	addi	a0,a0,-668 # 800074c8 <etext+0x4c8>
    8000276c:	4a5020ef          	jal	80005410 <printf>
  return 0;
    80002770:	4501                	li	a0,0
}
    80002772:	70e2                	ld	ra,56(sp)
    80002774:	7442                	ld	s0,48(sp)
    80002776:	6121                	addi	sp,sp,64
    80002778:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000277a:	04000613          	li	a2,64
    8000277e:	4581                	li	a1,0
    80002780:	854e                	mv	a0,s3
    80002782:	9cdfd0ef          	jal	8000014e <memset>
      dip->type = type;
    80002786:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000278a:	8526                	mv	a0,s1
    8000278c:	2f1000ef          	jal	8000327c <log_write>
      brelse(bp);
    80002790:	8526                	mv	a0,s1
    80002792:	aa1ff0ef          	jal	80002232 <brelse>
      return iget(dev, inum);
    80002796:	0009059b          	sext.w	a1,s2
    8000279a:	8556                	mv	a0,s5
    8000279c:	de7ff0ef          	jal	80002582 <iget>
    800027a0:	74a2                	ld	s1,40(sp)
    800027a2:	7902                	ld	s2,32(sp)
    800027a4:	69e2                	ld	s3,24(sp)
    800027a6:	6a42                	ld	s4,16(sp)
    800027a8:	6aa2                	ld	s5,8(sp)
    800027aa:	6b02                	ld	s6,0(sp)
    800027ac:	b7d9                	j	80002772 <ialloc+0x80>

00000000800027ae <iupdate>:
{
    800027ae:	1101                	addi	sp,sp,-32
    800027b0:	ec06                	sd	ra,24(sp)
    800027b2:	e822                	sd	s0,16(sp)
    800027b4:	e426                	sd	s1,8(sp)
    800027b6:	e04a                	sd	s2,0(sp)
    800027b8:	1000                	addi	s0,sp,32
    800027ba:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800027bc:	415c                	lw	a5,4(a0)
    800027be:	0047d79b          	srliw	a5,a5,0x4
    800027c2:	00013597          	auipc	a1,0x13
    800027c6:	74e5a583          	lw	a1,1870(a1) # 80015f10 <sb+0x18>
    800027ca:	9dbd                	addw	a1,a1,a5
    800027cc:	4108                	lw	a0,0(a0)
    800027ce:	95dff0ef          	jal	8000212a <bread>
    800027d2:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800027d4:	05850793          	addi	a5,a0,88
    800027d8:	40d8                	lw	a4,4(s1)
    800027da:	8b3d                	andi	a4,a4,15
    800027dc:	071a                	slli	a4,a4,0x6
    800027de:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800027e0:	04449703          	lh	a4,68(s1)
    800027e4:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800027e8:	04649703          	lh	a4,70(s1)
    800027ec:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800027f0:	04849703          	lh	a4,72(s1)
    800027f4:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800027f8:	04a49703          	lh	a4,74(s1)
    800027fc:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002800:	44f8                	lw	a4,76(s1)
    80002802:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002804:	03400613          	li	a2,52
    80002808:	05048593          	addi	a1,s1,80
    8000280c:	00c78513          	addi	a0,a5,12
    80002810:	99bfd0ef          	jal	800001aa <memmove>
  log_write(bp);
    80002814:	854a                	mv	a0,s2
    80002816:	267000ef          	jal	8000327c <log_write>
  brelse(bp);
    8000281a:	854a                	mv	a0,s2
    8000281c:	a17ff0ef          	jal	80002232 <brelse>
}
    80002820:	60e2                	ld	ra,24(sp)
    80002822:	6442                	ld	s0,16(sp)
    80002824:	64a2                	ld	s1,8(sp)
    80002826:	6902                	ld	s2,0(sp)
    80002828:	6105                	addi	sp,sp,32
    8000282a:	8082                	ret

000000008000282c <idup>:
{
    8000282c:	1101                	addi	sp,sp,-32
    8000282e:	ec06                	sd	ra,24(sp)
    80002830:	e822                	sd	s0,16(sp)
    80002832:	e426                	sd	s1,8(sp)
    80002834:	1000                	addi	s0,sp,32
    80002836:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002838:	00013517          	auipc	a0,0x13
    8000283c:	6e050513          	addi	a0,a0,1760 # 80015f18 <itable>
    80002840:	1d0030ef          	jal	80005a10 <acquire>
  ip->ref++;
    80002844:	449c                	lw	a5,8(s1)
    80002846:	2785                	addiw	a5,a5,1
    80002848:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000284a:	00013517          	auipc	a0,0x13
    8000284e:	6ce50513          	addi	a0,a0,1742 # 80015f18 <itable>
    80002852:	256030ef          	jal	80005aa8 <release>
}
    80002856:	8526                	mv	a0,s1
    80002858:	60e2                	ld	ra,24(sp)
    8000285a:	6442                	ld	s0,16(sp)
    8000285c:	64a2                	ld	s1,8(sp)
    8000285e:	6105                	addi	sp,sp,32
    80002860:	8082                	ret

0000000080002862 <ilock>:
{
    80002862:	1101                	addi	sp,sp,-32
    80002864:	ec06                	sd	ra,24(sp)
    80002866:	e822                	sd	s0,16(sp)
    80002868:	e426                	sd	s1,8(sp)
    8000286a:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000286c:	cd19                	beqz	a0,8000288a <ilock+0x28>
    8000286e:	84aa                	mv	s1,a0
    80002870:	451c                	lw	a5,8(a0)
    80002872:	00f05c63          	blez	a5,8000288a <ilock+0x28>
  acquiresleep(&ip->lock);
    80002876:	0541                	addi	a0,a0,16
    80002878:	30b000ef          	jal	80003382 <acquiresleep>
  if(ip->valid == 0){
    8000287c:	40bc                	lw	a5,64(s1)
    8000287e:	cf89                	beqz	a5,80002898 <ilock+0x36>
}
    80002880:	60e2                	ld	ra,24(sp)
    80002882:	6442                	ld	s0,16(sp)
    80002884:	64a2                	ld	s1,8(sp)
    80002886:	6105                	addi	sp,sp,32
    80002888:	8082                	ret
    8000288a:	e04a                	sd	s2,0(sp)
    panic("ilock");
    8000288c:	00005517          	auipc	a0,0x5
    80002890:	c5450513          	addi	a0,a0,-940 # 800074e0 <etext+0x4e0>
    80002894:	64f020ef          	jal	800056e2 <panic>
    80002898:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000289a:	40dc                	lw	a5,4(s1)
    8000289c:	0047d79b          	srliw	a5,a5,0x4
    800028a0:	00013597          	auipc	a1,0x13
    800028a4:	6705a583          	lw	a1,1648(a1) # 80015f10 <sb+0x18>
    800028a8:	9dbd                	addw	a1,a1,a5
    800028aa:	4088                	lw	a0,0(s1)
    800028ac:	87fff0ef          	jal	8000212a <bread>
    800028b0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800028b2:	05850593          	addi	a1,a0,88
    800028b6:	40dc                	lw	a5,4(s1)
    800028b8:	8bbd                	andi	a5,a5,15
    800028ba:	079a                	slli	a5,a5,0x6
    800028bc:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800028be:	00059783          	lh	a5,0(a1)
    800028c2:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800028c6:	00259783          	lh	a5,2(a1)
    800028ca:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800028ce:	00459783          	lh	a5,4(a1)
    800028d2:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800028d6:	00659783          	lh	a5,6(a1)
    800028da:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800028de:	459c                	lw	a5,8(a1)
    800028e0:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800028e2:	03400613          	li	a2,52
    800028e6:	05b1                	addi	a1,a1,12
    800028e8:	05048513          	addi	a0,s1,80
    800028ec:	8bffd0ef          	jal	800001aa <memmove>
    brelse(bp);
    800028f0:	854a                	mv	a0,s2
    800028f2:	941ff0ef          	jal	80002232 <brelse>
    ip->valid = 1;
    800028f6:	4785                	li	a5,1
    800028f8:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800028fa:	04449783          	lh	a5,68(s1)
    800028fe:	c399                	beqz	a5,80002904 <ilock+0xa2>
    80002900:	6902                	ld	s2,0(sp)
    80002902:	bfbd                	j	80002880 <ilock+0x1e>
      panic("ilock: no type");
    80002904:	00005517          	auipc	a0,0x5
    80002908:	be450513          	addi	a0,a0,-1052 # 800074e8 <etext+0x4e8>
    8000290c:	5d7020ef          	jal	800056e2 <panic>

0000000080002910 <iunlock>:
{
    80002910:	1101                	addi	sp,sp,-32
    80002912:	ec06                	sd	ra,24(sp)
    80002914:	e822                	sd	s0,16(sp)
    80002916:	e426                	sd	s1,8(sp)
    80002918:	e04a                	sd	s2,0(sp)
    8000291a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000291c:	c505                	beqz	a0,80002944 <iunlock+0x34>
    8000291e:	84aa                	mv	s1,a0
    80002920:	01050913          	addi	s2,a0,16
    80002924:	854a                	mv	a0,s2
    80002926:	2db000ef          	jal	80003400 <holdingsleep>
    8000292a:	cd09                	beqz	a0,80002944 <iunlock+0x34>
    8000292c:	449c                	lw	a5,8(s1)
    8000292e:	00f05b63          	blez	a5,80002944 <iunlock+0x34>
  releasesleep(&ip->lock);
    80002932:	854a                	mv	a0,s2
    80002934:	295000ef          	jal	800033c8 <releasesleep>
}
    80002938:	60e2                	ld	ra,24(sp)
    8000293a:	6442                	ld	s0,16(sp)
    8000293c:	64a2                	ld	s1,8(sp)
    8000293e:	6902                	ld	s2,0(sp)
    80002940:	6105                	addi	sp,sp,32
    80002942:	8082                	ret
    panic("iunlock");
    80002944:	00005517          	auipc	a0,0x5
    80002948:	bb450513          	addi	a0,a0,-1100 # 800074f8 <etext+0x4f8>
    8000294c:	597020ef          	jal	800056e2 <panic>

0000000080002950 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002950:	7179                	addi	sp,sp,-48
    80002952:	f406                	sd	ra,40(sp)
    80002954:	f022                	sd	s0,32(sp)
    80002956:	ec26                	sd	s1,24(sp)
    80002958:	e84a                	sd	s2,16(sp)
    8000295a:	e44e                	sd	s3,8(sp)
    8000295c:	1800                	addi	s0,sp,48
    8000295e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002960:	05050493          	addi	s1,a0,80
    80002964:	08050913          	addi	s2,a0,128
    80002968:	a021                	j	80002970 <itrunc+0x20>
    8000296a:	0491                	addi	s1,s1,4
    8000296c:	01248b63          	beq	s1,s2,80002982 <itrunc+0x32>
    if(ip->addrs[i]){
    80002970:	408c                	lw	a1,0(s1)
    80002972:	dde5                	beqz	a1,8000296a <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002974:	0009a503          	lw	a0,0(s3)
    80002978:	9abff0ef          	jal	80002322 <bfree>
      ip->addrs[i] = 0;
    8000297c:	0004a023          	sw	zero,0(s1)
    80002980:	b7ed                	j	8000296a <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002982:	0809a583          	lw	a1,128(s3)
    80002986:	ed89                	bnez	a1,800029a0 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002988:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000298c:	854e                	mv	a0,s3
    8000298e:	e21ff0ef          	jal	800027ae <iupdate>
}
    80002992:	70a2                	ld	ra,40(sp)
    80002994:	7402                	ld	s0,32(sp)
    80002996:	64e2                	ld	s1,24(sp)
    80002998:	6942                	ld	s2,16(sp)
    8000299a:	69a2                	ld	s3,8(sp)
    8000299c:	6145                	addi	sp,sp,48
    8000299e:	8082                	ret
    800029a0:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800029a2:	0009a503          	lw	a0,0(s3)
    800029a6:	f84ff0ef          	jal	8000212a <bread>
    800029aa:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800029ac:	05850493          	addi	s1,a0,88
    800029b0:	45850913          	addi	s2,a0,1112
    800029b4:	a021                	j	800029bc <itrunc+0x6c>
    800029b6:	0491                	addi	s1,s1,4
    800029b8:	01248963          	beq	s1,s2,800029ca <itrunc+0x7a>
      if(a[j])
    800029bc:	408c                	lw	a1,0(s1)
    800029be:	dde5                	beqz	a1,800029b6 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800029c0:	0009a503          	lw	a0,0(s3)
    800029c4:	95fff0ef          	jal	80002322 <bfree>
    800029c8:	b7fd                	j	800029b6 <itrunc+0x66>
    brelse(bp);
    800029ca:	8552                	mv	a0,s4
    800029cc:	867ff0ef          	jal	80002232 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800029d0:	0809a583          	lw	a1,128(s3)
    800029d4:	0009a503          	lw	a0,0(s3)
    800029d8:	94bff0ef          	jal	80002322 <bfree>
    ip->addrs[NDIRECT] = 0;
    800029dc:	0809a023          	sw	zero,128(s3)
    800029e0:	6a02                	ld	s4,0(sp)
    800029e2:	b75d                	j	80002988 <itrunc+0x38>

00000000800029e4 <iput>:
{
    800029e4:	1101                	addi	sp,sp,-32
    800029e6:	ec06                	sd	ra,24(sp)
    800029e8:	e822                	sd	s0,16(sp)
    800029ea:	e426                	sd	s1,8(sp)
    800029ec:	1000                	addi	s0,sp,32
    800029ee:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800029f0:	00013517          	auipc	a0,0x13
    800029f4:	52850513          	addi	a0,a0,1320 # 80015f18 <itable>
    800029f8:	018030ef          	jal	80005a10 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800029fc:	4498                	lw	a4,8(s1)
    800029fe:	4785                	li	a5,1
    80002a00:	02f70063          	beq	a4,a5,80002a20 <iput+0x3c>
  ip->ref--;
    80002a04:	449c                	lw	a5,8(s1)
    80002a06:	37fd                	addiw	a5,a5,-1
    80002a08:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002a0a:	00013517          	auipc	a0,0x13
    80002a0e:	50e50513          	addi	a0,a0,1294 # 80015f18 <itable>
    80002a12:	096030ef          	jal	80005aa8 <release>
}
    80002a16:	60e2                	ld	ra,24(sp)
    80002a18:	6442                	ld	s0,16(sp)
    80002a1a:	64a2                	ld	s1,8(sp)
    80002a1c:	6105                	addi	sp,sp,32
    80002a1e:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002a20:	40bc                	lw	a5,64(s1)
    80002a22:	d3ed                	beqz	a5,80002a04 <iput+0x20>
    80002a24:	04a49783          	lh	a5,74(s1)
    80002a28:	fff1                	bnez	a5,80002a04 <iput+0x20>
    80002a2a:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002a2c:	01048913          	addi	s2,s1,16
    80002a30:	854a                	mv	a0,s2
    80002a32:	151000ef          	jal	80003382 <acquiresleep>
    release(&itable.lock);
    80002a36:	00013517          	auipc	a0,0x13
    80002a3a:	4e250513          	addi	a0,a0,1250 # 80015f18 <itable>
    80002a3e:	06a030ef          	jal	80005aa8 <release>
    itrunc(ip);
    80002a42:	8526                	mv	a0,s1
    80002a44:	f0dff0ef          	jal	80002950 <itrunc>
    ip->type = 0;
    80002a48:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002a4c:	8526                	mv	a0,s1
    80002a4e:	d61ff0ef          	jal	800027ae <iupdate>
    ip->valid = 0;
    80002a52:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002a56:	854a                	mv	a0,s2
    80002a58:	171000ef          	jal	800033c8 <releasesleep>
    acquire(&itable.lock);
    80002a5c:	00013517          	auipc	a0,0x13
    80002a60:	4bc50513          	addi	a0,a0,1212 # 80015f18 <itable>
    80002a64:	7ad020ef          	jal	80005a10 <acquire>
    80002a68:	6902                	ld	s2,0(sp)
    80002a6a:	bf69                	j	80002a04 <iput+0x20>

0000000080002a6c <iunlockput>:
{
    80002a6c:	1101                	addi	sp,sp,-32
    80002a6e:	ec06                	sd	ra,24(sp)
    80002a70:	e822                	sd	s0,16(sp)
    80002a72:	e426                	sd	s1,8(sp)
    80002a74:	1000                	addi	s0,sp,32
    80002a76:	84aa                	mv	s1,a0
  iunlock(ip);
    80002a78:	e99ff0ef          	jal	80002910 <iunlock>
  iput(ip);
    80002a7c:	8526                	mv	a0,s1
    80002a7e:	f67ff0ef          	jal	800029e4 <iput>
}
    80002a82:	60e2                	ld	ra,24(sp)
    80002a84:	6442                	ld	s0,16(sp)
    80002a86:	64a2                	ld	s1,8(sp)
    80002a88:	6105                	addi	sp,sp,32
    80002a8a:	8082                	ret

0000000080002a8c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002a8c:	1141                	addi	sp,sp,-16
    80002a8e:	e422                	sd	s0,8(sp)
    80002a90:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002a92:	411c                	lw	a5,0(a0)
    80002a94:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002a96:	415c                	lw	a5,4(a0)
    80002a98:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002a9a:	04451783          	lh	a5,68(a0)
    80002a9e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002aa2:	04a51783          	lh	a5,74(a0)
    80002aa6:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002aaa:	04c56783          	lwu	a5,76(a0)
    80002aae:	e99c                	sd	a5,16(a1)
}
    80002ab0:	6422                	ld	s0,8(sp)
    80002ab2:	0141                	addi	sp,sp,16
    80002ab4:	8082                	ret

0000000080002ab6 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ab6:	457c                	lw	a5,76(a0)
    80002ab8:	0ed7eb63          	bltu	a5,a3,80002bae <readi+0xf8>
{
    80002abc:	7159                	addi	sp,sp,-112
    80002abe:	f486                	sd	ra,104(sp)
    80002ac0:	f0a2                	sd	s0,96(sp)
    80002ac2:	eca6                	sd	s1,88(sp)
    80002ac4:	e0d2                	sd	s4,64(sp)
    80002ac6:	fc56                	sd	s5,56(sp)
    80002ac8:	f85a                	sd	s6,48(sp)
    80002aca:	f45e                	sd	s7,40(sp)
    80002acc:	1880                	addi	s0,sp,112
    80002ace:	8b2a                	mv	s6,a0
    80002ad0:	8bae                	mv	s7,a1
    80002ad2:	8a32                	mv	s4,a2
    80002ad4:	84b6                	mv	s1,a3
    80002ad6:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002ad8:	9f35                	addw	a4,a4,a3
    return 0;
    80002ada:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002adc:	0cd76063          	bltu	a4,a3,80002b9c <readi+0xe6>
    80002ae0:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002ae2:	00e7f463          	bgeu	a5,a4,80002aea <readi+0x34>
    n = ip->size - off;
    80002ae6:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002aea:	080a8f63          	beqz	s5,80002b88 <readi+0xd2>
    80002aee:	e8ca                	sd	s2,80(sp)
    80002af0:	f062                	sd	s8,32(sp)
    80002af2:	ec66                	sd	s9,24(sp)
    80002af4:	e86a                	sd	s10,16(sp)
    80002af6:	e46e                	sd	s11,8(sp)
    80002af8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002afa:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002afe:	5c7d                	li	s8,-1
    80002b00:	a80d                	j	80002b32 <readi+0x7c>
    80002b02:	020d1d93          	slli	s11,s10,0x20
    80002b06:	020ddd93          	srli	s11,s11,0x20
    80002b0a:	05890613          	addi	a2,s2,88
    80002b0e:	86ee                	mv	a3,s11
    80002b10:	963a                	add	a2,a2,a4
    80002b12:	85d2                	mv	a1,s4
    80002b14:	855e                	mv	a0,s7
    80002b16:	c7ffe0ef          	jal	80001794 <either_copyout>
    80002b1a:	05850763          	beq	a0,s8,80002b68 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002b1e:	854a                	mv	a0,s2
    80002b20:	f12ff0ef          	jal	80002232 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002b24:	013d09bb          	addw	s3,s10,s3
    80002b28:	009d04bb          	addw	s1,s10,s1
    80002b2c:	9a6e                	add	s4,s4,s11
    80002b2e:	0559f763          	bgeu	s3,s5,80002b7c <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80002b32:	00a4d59b          	srliw	a1,s1,0xa
    80002b36:	855a                	mv	a0,s6
    80002b38:	977ff0ef          	jal	800024ae <bmap>
    80002b3c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002b40:	c5b1                	beqz	a1,80002b8c <readi+0xd6>
    bp = bread(ip->dev, addr);
    80002b42:	000b2503          	lw	a0,0(s6)
    80002b46:	de4ff0ef          	jal	8000212a <bread>
    80002b4a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b4c:	3ff4f713          	andi	a4,s1,1023
    80002b50:	40ec87bb          	subw	a5,s9,a4
    80002b54:	413a86bb          	subw	a3,s5,s3
    80002b58:	8d3e                	mv	s10,a5
    80002b5a:	2781                	sext.w	a5,a5
    80002b5c:	0006861b          	sext.w	a2,a3
    80002b60:	faf671e3          	bgeu	a2,a5,80002b02 <readi+0x4c>
    80002b64:	8d36                	mv	s10,a3
    80002b66:	bf71                	j	80002b02 <readi+0x4c>
      brelse(bp);
    80002b68:	854a                	mv	a0,s2
    80002b6a:	ec8ff0ef          	jal	80002232 <brelse>
      tot = -1;
    80002b6e:	59fd                	li	s3,-1
      break;
    80002b70:	6946                	ld	s2,80(sp)
    80002b72:	7c02                	ld	s8,32(sp)
    80002b74:	6ce2                	ld	s9,24(sp)
    80002b76:	6d42                	ld	s10,16(sp)
    80002b78:	6da2                	ld	s11,8(sp)
    80002b7a:	a831                	j	80002b96 <readi+0xe0>
    80002b7c:	6946                	ld	s2,80(sp)
    80002b7e:	7c02                	ld	s8,32(sp)
    80002b80:	6ce2                	ld	s9,24(sp)
    80002b82:	6d42                	ld	s10,16(sp)
    80002b84:	6da2                	ld	s11,8(sp)
    80002b86:	a801                	j	80002b96 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002b88:	89d6                	mv	s3,s5
    80002b8a:	a031                	j	80002b96 <readi+0xe0>
    80002b8c:	6946                	ld	s2,80(sp)
    80002b8e:	7c02                	ld	s8,32(sp)
    80002b90:	6ce2                	ld	s9,24(sp)
    80002b92:	6d42                	ld	s10,16(sp)
    80002b94:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002b96:	0009851b          	sext.w	a0,s3
    80002b9a:	69a6                	ld	s3,72(sp)
}
    80002b9c:	70a6                	ld	ra,104(sp)
    80002b9e:	7406                	ld	s0,96(sp)
    80002ba0:	64e6                	ld	s1,88(sp)
    80002ba2:	6a06                	ld	s4,64(sp)
    80002ba4:	7ae2                	ld	s5,56(sp)
    80002ba6:	7b42                	ld	s6,48(sp)
    80002ba8:	7ba2                	ld	s7,40(sp)
    80002baa:	6165                	addi	sp,sp,112
    80002bac:	8082                	ret
    return 0;
    80002bae:	4501                	li	a0,0
}
    80002bb0:	8082                	ret

0000000080002bb2 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002bb2:	457c                	lw	a5,76(a0)
    80002bb4:	10d7e063          	bltu	a5,a3,80002cb4 <writei+0x102>
{
    80002bb8:	7159                	addi	sp,sp,-112
    80002bba:	f486                	sd	ra,104(sp)
    80002bbc:	f0a2                	sd	s0,96(sp)
    80002bbe:	e8ca                	sd	s2,80(sp)
    80002bc0:	e0d2                	sd	s4,64(sp)
    80002bc2:	fc56                	sd	s5,56(sp)
    80002bc4:	f85a                	sd	s6,48(sp)
    80002bc6:	f45e                	sd	s7,40(sp)
    80002bc8:	1880                	addi	s0,sp,112
    80002bca:	8aaa                	mv	s5,a0
    80002bcc:	8bae                	mv	s7,a1
    80002bce:	8a32                	mv	s4,a2
    80002bd0:	8936                	mv	s2,a3
    80002bd2:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002bd4:	00e687bb          	addw	a5,a3,a4
    80002bd8:	0ed7e063          	bltu	a5,a3,80002cb8 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002bdc:	00043737          	lui	a4,0x43
    80002be0:	0cf76e63          	bltu	a4,a5,80002cbc <writei+0x10a>
    80002be4:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002be6:	0a0b0f63          	beqz	s6,80002ca4 <writei+0xf2>
    80002bea:	eca6                	sd	s1,88(sp)
    80002bec:	f062                	sd	s8,32(sp)
    80002bee:	ec66                	sd	s9,24(sp)
    80002bf0:	e86a                	sd	s10,16(sp)
    80002bf2:	e46e                	sd	s11,8(sp)
    80002bf4:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002bf6:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002bfa:	5c7d                	li	s8,-1
    80002bfc:	a825                	j	80002c34 <writei+0x82>
    80002bfe:	020d1d93          	slli	s11,s10,0x20
    80002c02:	020ddd93          	srli	s11,s11,0x20
    80002c06:	05848513          	addi	a0,s1,88
    80002c0a:	86ee                	mv	a3,s11
    80002c0c:	8652                	mv	a2,s4
    80002c0e:	85de                	mv	a1,s7
    80002c10:	953a                	add	a0,a0,a4
    80002c12:	bcdfe0ef          	jal	800017de <either_copyin>
    80002c16:	05850a63          	beq	a0,s8,80002c6a <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002c1a:	8526                	mv	a0,s1
    80002c1c:	660000ef          	jal	8000327c <log_write>
    brelse(bp);
    80002c20:	8526                	mv	a0,s1
    80002c22:	e10ff0ef          	jal	80002232 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002c26:	013d09bb          	addw	s3,s10,s3
    80002c2a:	012d093b          	addw	s2,s10,s2
    80002c2e:	9a6e                	add	s4,s4,s11
    80002c30:	0569f063          	bgeu	s3,s6,80002c70 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002c34:	00a9559b          	srliw	a1,s2,0xa
    80002c38:	8556                	mv	a0,s5
    80002c3a:	875ff0ef          	jal	800024ae <bmap>
    80002c3e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002c42:	c59d                	beqz	a1,80002c70 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002c44:	000aa503          	lw	a0,0(s5)
    80002c48:	ce2ff0ef          	jal	8000212a <bread>
    80002c4c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002c4e:	3ff97713          	andi	a4,s2,1023
    80002c52:	40ec87bb          	subw	a5,s9,a4
    80002c56:	413b06bb          	subw	a3,s6,s3
    80002c5a:	8d3e                	mv	s10,a5
    80002c5c:	2781                	sext.w	a5,a5
    80002c5e:	0006861b          	sext.w	a2,a3
    80002c62:	f8f67ee3          	bgeu	a2,a5,80002bfe <writei+0x4c>
    80002c66:	8d36                	mv	s10,a3
    80002c68:	bf59                	j	80002bfe <writei+0x4c>
      brelse(bp);
    80002c6a:	8526                	mv	a0,s1
    80002c6c:	dc6ff0ef          	jal	80002232 <brelse>
  }

  if(off > ip->size)
    80002c70:	04caa783          	lw	a5,76(s5)
    80002c74:	0327fa63          	bgeu	a5,s2,80002ca8 <writei+0xf6>
    ip->size = off;
    80002c78:	052aa623          	sw	s2,76(s5)
    80002c7c:	64e6                	ld	s1,88(sp)
    80002c7e:	7c02                	ld	s8,32(sp)
    80002c80:	6ce2                	ld	s9,24(sp)
    80002c82:	6d42                	ld	s10,16(sp)
    80002c84:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002c86:	8556                	mv	a0,s5
    80002c88:	b27ff0ef          	jal	800027ae <iupdate>

  return tot;
    80002c8c:	0009851b          	sext.w	a0,s3
    80002c90:	69a6                	ld	s3,72(sp)
}
    80002c92:	70a6                	ld	ra,104(sp)
    80002c94:	7406                	ld	s0,96(sp)
    80002c96:	6946                	ld	s2,80(sp)
    80002c98:	6a06                	ld	s4,64(sp)
    80002c9a:	7ae2                	ld	s5,56(sp)
    80002c9c:	7b42                	ld	s6,48(sp)
    80002c9e:	7ba2                	ld	s7,40(sp)
    80002ca0:	6165                	addi	sp,sp,112
    80002ca2:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ca4:	89da                	mv	s3,s6
    80002ca6:	b7c5                	j	80002c86 <writei+0xd4>
    80002ca8:	64e6                	ld	s1,88(sp)
    80002caa:	7c02                	ld	s8,32(sp)
    80002cac:	6ce2                	ld	s9,24(sp)
    80002cae:	6d42                	ld	s10,16(sp)
    80002cb0:	6da2                	ld	s11,8(sp)
    80002cb2:	bfd1                	j	80002c86 <writei+0xd4>
    return -1;
    80002cb4:	557d                	li	a0,-1
}
    80002cb6:	8082                	ret
    return -1;
    80002cb8:	557d                	li	a0,-1
    80002cba:	bfe1                	j	80002c92 <writei+0xe0>
    return -1;
    80002cbc:	557d                	li	a0,-1
    80002cbe:	bfd1                	j	80002c92 <writei+0xe0>

0000000080002cc0 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002cc0:	1141                	addi	sp,sp,-16
    80002cc2:	e406                	sd	ra,8(sp)
    80002cc4:	e022                	sd	s0,0(sp)
    80002cc6:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002cc8:	4639                	li	a2,14
    80002cca:	d50fd0ef          	jal	8000021a <strncmp>
}
    80002cce:	60a2                	ld	ra,8(sp)
    80002cd0:	6402                	ld	s0,0(sp)
    80002cd2:	0141                	addi	sp,sp,16
    80002cd4:	8082                	ret

0000000080002cd6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002cd6:	7139                	addi	sp,sp,-64
    80002cd8:	fc06                	sd	ra,56(sp)
    80002cda:	f822                	sd	s0,48(sp)
    80002cdc:	f426                	sd	s1,40(sp)
    80002cde:	f04a                	sd	s2,32(sp)
    80002ce0:	ec4e                	sd	s3,24(sp)
    80002ce2:	e852                	sd	s4,16(sp)
    80002ce4:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002ce6:	04451703          	lh	a4,68(a0)
    80002cea:	4785                	li	a5,1
    80002cec:	00f71a63          	bne	a4,a5,80002d00 <dirlookup+0x2a>
    80002cf0:	892a                	mv	s2,a0
    80002cf2:	89ae                	mv	s3,a1
    80002cf4:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002cf6:	457c                	lw	a5,76(a0)
    80002cf8:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002cfa:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002cfc:	e39d                	bnez	a5,80002d22 <dirlookup+0x4c>
    80002cfe:	a095                	j	80002d62 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002d00:	00005517          	auipc	a0,0x5
    80002d04:	80050513          	addi	a0,a0,-2048 # 80007500 <etext+0x500>
    80002d08:	1db020ef          	jal	800056e2 <panic>
      panic("dirlookup read");
    80002d0c:	00005517          	auipc	a0,0x5
    80002d10:	80c50513          	addi	a0,a0,-2036 # 80007518 <etext+0x518>
    80002d14:	1cf020ef          	jal	800056e2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d18:	24c1                	addiw	s1,s1,16
    80002d1a:	04c92783          	lw	a5,76(s2)
    80002d1e:	04f4f163          	bgeu	s1,a5,80002d60 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002d22:	4741                	li	a4,16
    80002d24:	86a6                	mv	a3,s1
    80002d26:	fc040613          	addi	a2,s0,-64
    80002d2a:	4581                	li	a1,0
    80002d2c:	854a                	mv	a0,s2
    80002d2e:	d89ff0ef          	jal	80002ab6 <readi>
    80002d32:	47c1                	li	a5,16
    80002d34:	fcf51ce3          	bne	a0,a5,80002d0c <dirlookup+0x36>
    if(de.inum == 0)
    80002d38:	fc045783          	lhu	a5,-64(s0)
    80002d3c:	dff1                	beqz	a5,80002d18 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002d3e:	fc240593          	addi	a1,s0,-62
    80002d42:	854e                	mv	a0,s3
    80002d44:	f7dff0ef          	jal	80002cc0 <namecmp>
    80002d48:	f961                	bnez	a0,80002d18 <dirlookup+0x42>
      if(poff)
    80002d4a:	000a0463          	beqz	s4,80002d52 <dirlookup+0x7c>
        *poff = off;
    80002d4e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002d52:	fc045583          	lhu	a1,-64(s0)
    80002d56:	00092503          	lw	a0,0(s2)
    80002d5a:	829ff0ef          	jal	80002582 <iget>
    80002d5e:	a011                	j	80002d62 <dirlookup+0x8c>
  return 0;
    80002d60:	4501                	li	a0,0
}
    80002d62:	70e2                	ld	ra,56(sp)
    80002d64:	7442                	ld	s0,48(sp)
    80002d66:	74a2                	ld	s1,40(sp)
    80002d68:	7902                	ld	s2,32(sp)
    80002d6a:	69e2                	ld	s3,24(sp)
    80002d6c:	6a42                	ld	s4,16(sp)
    80002d6e:	6121                	addi	sp,sp,64
    80002d70:	8082                	ret

0000000080002d72 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002d72:	711d                	addi	sp,sp,-96
    80002d74:	ec86                	sd	ra,88(sp)
    80002d76:	e8a2                	sd	s0,80(sp)
    80002d78:	e4a6                	sd	s1,72(sp)
    80002d7a:	e0ca                	sd	s2,64(sp)
    80002d7c:	fc4e                	sd	s3,56(sp)
    80002d7e:	f852                	sd	s4,48(sp)
    80002d80:	f456                	sd	s5,40(sp)
    80002d82:	f05a                	sd	s6,32(sp)
    80002d84:	ec5e                	sd	s7,24(sp)
    80002d86:	e862                	sd	s8,16(sp)
    80002d88:	e466                	sd	s9,8(sp)
    80002d8a:	1080                	addi	s0,sp,96
    80002d8c:	84aa                	mv	s1,a0
    80002d8e:	8b2e                	mv	s6,a1
    80002d90:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002d92:	00054703          	lbu	a4,0(a0)
    80002d96:	02f00793          	li	a5,47
    80002d9a:	00f70e63          	beq	a4,a5,80002db6 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002d9e:	8ccfe0ef          	jal	80000e6a <myproc>
    80002da2:	15053503          	ld	a0,336(a0)
    80002da6:	a87ff0ef          	jal	8000282c <idup>
    80002daa:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002dac:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002db0:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002db2:	4b85                	li	s7,1
    80002db4:	a871                	j	80002e50 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80002db6:	4585                	li	a1,1
    80002db8:	4505                	li	a0,1
    80002dba:	fc8ff0ef          	jal	80002582 <iget>
    80002dbe:	8a2a                	mv	s4,a0
    80002dc0:	b7f5                	j	80002dac <namex+0x3a>
      iunlockput(ip);
    80002dc2:	8552                	mv	a0,s4
    80002dc4:	ca9ff0ef          	jal	80002a6c <iunlockput>
      return 0;
    80002dc8:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002dca:	8552                	mv	a0,s4
    80002dcc:	60e6                	ld	ra,88(sp)
    80002dce:	6446                	ld	s0,80(sp)
    80002dd0:	64a6                	ld	s1,72(sp)
    80002dd2:	6906                	ld	s2,64(sp)
    80002dd4:	79e2                	ld	s3,56(sp)
    80002dd6:	7a42                	ld	s4,48(sp)
    80002dd8:	7aa2                	ld	s5,40(sp)
    80002dda:	7b02                	ld	s6,32(sp)
    80002ddc:	6be2                	ld	s7,24(sp)
    80002dde:	6c42                	ld	s8,16(sp)
    80002de0:	6ca2                	ld	s9,8(sp)
    80002de2:	6125                	addi	sp,sp,96
    80002de4:	8082                	ret
      iunlock(ip);
    80002de6:	8552                	mv	a0,s4
    80002de8:	b29ff0ef          	jal	80002910 <iunlock>
      return ip;
    80002dec:	bff9                	j	80002dca <namex+0x58>
      iunlockput(ip);
    80002dee:	8552                	mv	a0,s4
    80002df0:	c7dff0ef          	jal	80002a6c <iunlockput>
      return 0;
    80002df4:	8a4e                	mv	s4,s3
    80002df6:	bfd1                	j	80002dca <namex+0x58>
  len = path - s;
    80002df8:	40998633          	sub	a2,s3,s1
    80002dfc:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002e00:	099c5063          	bge	s8,s9,80002e80 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80002e04:	4639                	li	a2,14
    80002e06:	85a6                	mv	a1,s1
    80002e08:	8556                	mv	a0,s5
    80002e0a:	ba0fd0ef          	jal	800001aa <memmove>
    80002e0e:	84ce                	mv	s1,s3
  while(*path == '/')
    80002e10:	0004c783          	lbu	a5,0(s1)
    80002e14:	01279763          	bne	a5,s2,80002e22 <namex+0xb0>
    path++;
    80002e18:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002e1a:	0004c783          	lbu	a5,0(s1)
    80002e1e:	ff278de3          	beq	a5,s2,80002e18 <namex+0xa6>
    ilock(ip);
    80002e22:	8552                	mv	a0,s4
    80002e24:	a3fff0ef          	jal	80002862 <ilock>
    if(ip->type != T_DIR){
    80002e28:	044a1783          	lh	a5,68(s4)
    80002e2c:	f9779be3          	bne	a5,s7,80002dc2 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80002e30:	000b0563          	beqz	s6,80002e3a <namex+0xc8>
    80002e34:	0004c783          	lbu	a5,0(s1)
    80002e38:	d7dd                	beqz	a5,80002de6 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002e3a:	4601                	li	a2,0
    80002e3c:	85d6                	mv	a1,s5
    80002e3e:	8552                	mv	a0,s4
    80002e40:	e97ff0ef          	jal	80002cd6 <dirlookup>
    80002e44:	89aa                	mv	s3,a0
    80002e46:	d545                	beqz	a0,80002dee <namex+0x7c>
    iunlockput(ip);
    80002e48:	8552                	mv	a0,s4
    80002e4a:	c23ff0ef          	jal	80002a6c <iunlockput>
    ip = next;
    80002e4e:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002e50:	0004c783          	lbu	a5,0(s1)
    80002e54:	01279763          	bne	a5,s2,80002e62 <namex+0xf0>
    path++;
    80002e58:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002e5a:	0004c783          	lbu	a5,0(s1)
    80002e5e:	ff278de3          	beq	a5,s2,80002e58 <namex+0xe6>
  if(*path == 0)
    80002e62:	cb8d                	beqz	a5,80002e94 <namex+0x122>
  while(*path != '/' && *path != 0)
    80002e64:	0004c783          	lbu	a5,0(s1)
    80002e68:	89a6                	mv	s3,s1
  len = path - s;
    80002e6a:	4c81                	li	s9,0
    80002e6c:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002e6e:	01278963          	beq	a5,s2,80002e80 <namex+0x10e>
    80002e72:	d3d9                	beqz	a5,80002df8 <namex+0x86>
    path++;
    80002e74:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002e76:	0009c783          	lbu	a5,0(s3)
    80002e7a:	ff279ce3          	bne	a5,s2,80002e72 <namex+0x100>
    80002e7e:	bfad                	j	80002df8 <namex+0x86>
    memmove(name, s, len);
    80002e80:	2601                	sext.w	a2,a2
    80002e82:	85a6                	mv	a1,s1
    80002e84:	8556                	mv	a0,s5
    80002e86:	b24fd0ef          	jal	800001aa <memmove>
    name[len] = 0;
    80002e8a:	9cd6                	add	s9,s9,s5
    80002e8c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80002e90:	84ce                	mv	s1,s3
    80002e92:	bfbd                	j	80002e10 <namex+0x9e>
  if(nameiparent){
    80002e94:	f20b0be3          	beqz	s6,80002dca <namex+0x58>
    iput(ip);
    80002e98:	8552                	mv	a0,s4
    80002e9a:	b4bff0ef          	jal	800029e4 <iput>
    return 0;
    80002e9e:	4a01                	li	s4,0
    80002ea0:	b72d                	j	80002dca <namex+0x58>

0000000080002ea2 <dirlink>:
{
    80002ea2:	7139                	addi	sp,sp,-64
    80002ea4:	fc06                	sd	ra,56(sp)
    80002ea6:	f822                	sd	s0,48(sp)
    80002ea8:	f04a                	sd	s2,32(sp)
    80002eaa:	ec4e                	sd	s3,24(sp)
    80002eac:	e852                	sd	s4,16(sp)
    80002eae:	0080                	addi	s0,sp,64
    80002eb0:	892a                	mv	s2,a0
    80002eb2:	8a2e                	mv	s4,a1
    80002eb4:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002eb6:	4601                	li	a2,0
    80002eb8:	e1fff0ef          	jal	80002cd6 <dirlookup>
    80002ebc:	e535                	bnez	a0,80002f28 <dirlink+0x86>
    80002ebe:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ec0:	04c92483          	lw	s1,76(s2)
    80002ec4:	c48d                	beqz	s1,80002eee <dirlink+0x4c>
    80002ec6:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002ec8:	4741                	li	a4,16
    80002eca:	86a6                	mv	a3,s1
    80002ecc:	fc040613          	addi	a2,s0,-64
    80002ed0:	4581                	li	a1,0
    80002ed2:	854a                	mv	a0,s2
    80002ed4:	be3ff0ef          	jal	80002ab6 <readi>
    80002ed8:	47c1                	li	a5,16
    80002eda:	04f51b63          	bne	a0,a5,80002f30 <dirlink+0x8e>
    if(de.inum == 0)
    80002ede:	fc045783          	lhu	a5,-64(s0)
    80002ee2:	c791                	beqz	a5,80002eee <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ee4:	24c1                	addiw	s1,s1,16
    80002ee6:	04c92783          	lw	a5,76(s2)
    80002eea:	fcf4efe3          	bltu	s1,a5,80002ec8 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80002eee:	4639                	li	a2,14
    80002ef0:	85d2                	mv	a1,s4
    80002ef2:	fc240513          	addi	a0,s0,-62
    80002ef6:	b5afd0ef          	jal	80000250 <strncpy>
  de.inum = inum;
    80002efa:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002efe:	4741                	li	a4,16
    80002f00:	86a6                	mv	a3,s1
    80002f02:	fc040613          	addi	a2,s0,-64
    80002f06:	4581                	li	a1,0
    80002f08:	854a                	mv	a0,s2
    80002f0a:	ca9ff0ef          	jal	80002bb2 <writei>
    80002f0e:	1541                	addi	a0,a0,-16
    80002f10:	00a03533          	snez	a0,a0
    80002f14:	40a00533          	neg	a0,a0
    80002f18:	74a2                	ld	s1,40(sp)
}
    80002f1a:	70e2                	ld	ra,56(sp)
    80002f1c:	7442                	ld	s0,48(sp)
    80002f1e:	7902                	ld	s2,32(sp)
    80002f20:	69e2                	ld	s3,24(sp)
    80002f22:	6a42                	ld	s4,16(sp)
    80002f24:	6121                	addi	sp,sp,64
    80002f26:	8082                	ret
    iput(ip);
    80002f28:	abdff0ef          	jal	800029e4 <iput>
    return -1;
    80002f2c:	557d                	li	a0,-1
    80002f2e:	b7f5                	j	80002f1a <dirlink+0x78>
      panic("dirlink read");
    80002f30:	00004517          	auipc	a0,0x4
    80002f34:	5f850513          	addi	a0,a0,1528 # 80007528 <etext+0x528>
    80002f38:	7aa020ef          	jal	800056e2 <panic>

0000000080002f3c <namei>:

struct inode*
namei(char *path)
{
    80002f3c:	1101                	addi	sp,sp,-32
    80002f3e:	ec06                	sd	ra,24(sp)
    80002f40:	e822                	sd	s0,16(sp)
    80002f42:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002f44:	fe040613          	addi	a2,s0,-32
    80002f48:	4581                	li	a1,0
    80002f4a:	e29ff0ef          	jal	80002d72 <namex>
}
    80002f4e:	60e2                	ld	ra,24(sp)
    80002f50:	6442                	ld	s0,16(sp)
    80002f52:	6105                	addi	sp,sp,32
    80002f54:	8082                	ret

0000000080002f56 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002f56:	1141                	addi	sp,sp,-16
    80002f58:	e406                	sd	ra,8(sp)
    80002f5a:	e022                	sd	s0,0(sp)
    80002f5c:	0800                	addi	s0,sp,16
    80002f5e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002f60:	4585                	li	a1,1
    80002f62:	e11ff0ef          	jal	80002d72 <namex>
}
    80002f66:	60a2                	ld	ra,8(sp)
    80002f68:	6402                	ld	s0,0(sp)
    80002f6a:	0141                	addi	sp,sp,16
    80002f6c:	8082                	ret

0000000080002f6e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002f6e:	1101                	addi	sp,sp,-32
    80002f70:	ec06                	sd	ra,24(sp)
    80002f72:	e822                	sd	s0,16(sp)
    80002f74:	e426                	sd	s1,8(sp)
    80002f76:	e04a                	sd	s2,0(sp)
    80002f78:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002f7a:	00015917          	auipc	s2,0x15
    80002f7e:	a4690913          	addi	s2,s2,-1466 # 800179c0 <log>
    80002f82:	01892583          	lw	a1,24(s2)
    80002f86:	02892503          	lw	a0,40(s2)
    80002f8a:	9a0ff0ef          	jal	8000212a <bread>
    80002f8e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002f90:	02c92603          	lw	a2,44(s2)
    80002f94:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002f96:	00c05f63          	blez	a2,80002fb4 <write_head+0x46>
    80002f9a:	00015717          	auipc	a4,0x15
    80002f9e:	a5670713          	addi	a4,a4,-1450 # 800179f0 <log+0x30>
    80002fa2:	87aa                	mv	a5,a0
    80002fa4:	060a                	slli	a2,a2,0x2
    80002fa6:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002fa8:	4314                	lw	a3,0(a4)
    80002faa:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002fac:	0711                	addi	a4,a4,4
    80002fae:	0791                	addi	a5,a5,4
    80002fb0:	fec79ce3          	bne	a5,a2,80002fa8 <write_head+0x3a>
  }
  bwrite(buf);
    80002fb4:	8526                	mv	a0,s1
    80002fb6:	a4aff0ef          	jal	80002200 <bwrite>
  brelse(buf);
    80002fba:	8526                	mv	a0,s1
    80002fbc:	a76ff0ef          	jal	80002232 <brelse>
}
    80002fc0:	60e2                	ld	ra,24(sp)
    80002fc2:	6442                	ld	s0,16(sp)
    80002fc4:	64a2                	ld	s1,8(sp)
    80002fc6:	6902                	ld	s2,0(sp)
    80002fc8:	6105                	addi	sp,sp,32
    80002fca:	8082                	ret

0000000080002fcc <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002fcc:	00015797          	auipc	a5,0x15
    80002fd0:	a207a783          	lw	a5,-1504(a5) # 800179ec <log+0x2c>
    80002fd4:	08f05f63          	blez	a5,80003072 <install_trans+0xa6>
{
    80002fd8:	7139                	addi	sp,sp,-64
    80002fda:	fc06                	sd	ra,56(sp)
    80002fdc:	f822                	sd	s0,48(sp)
    80002fde:	f426                	sd	s1,40(sp)
    80002fe0:	f04a                	sd	s2,32(sp)
    80002fe2:	ec4e                	sd	s3,24(sp)
    80002fe4:	e852                	sd	s4,16(sp)
    80002fe6:	e456                	sd	s5,8(sp)
    80002fe8:	e05a                	sd	s6,0(sp)
    80002fea:	0080                	addi	s0,sp,64
    80002fec:	8b2a                	mv	s6,a0
    80002fee:	00015a97          	auipc	s5,0x15
    80002ff2:	a02a8a93          	addi	s5,s5,-1534 # 800179f0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002ff6:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002ff8:	00015997          	auipc	s3,0x15
    80002ffc:	9c898993          	addi	s3,s3,-1592 # 800179c0 <log>
    80003000:	a829                	j	8000301a <install_trans+0x4e>
    brelse(lbuf);
    80003002:	854a                	mv	a0,s2
    80003004:	a2eff0ef          	jal	80002232 <brelse>
    brelse(dbuf);
    80003008:	8526                	mv	a0,s1
    8000300a:	a28ff0ef          	jal	80002232 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000300e:	2a05                	addiw	s4,s4,1
    80003010:	0a91                	addi	s5,s5,4
    80003012:	02c9a783          	lw	a5,44(s3)
    80003016:	04fa5463          	bge	s4,a5,8000305e <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000301a:	0189a583          	lw	a1,24(s3)
    8000301e:	014585bb          	addw	a1,a1,s4
    80003022:	2585                	addiw	a1,a1,1
    80003024:	0289a503          	lw	a0,40(s3)
    80003028:	902ff0ef          	jal	8000212a <bread>
    8000302c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000302e:	000aa583          	lw	a1,0(s5)
    80003032:	0289a503          	lw	a0,40(s3)
    80003036:	8f4ff0ef          	jal	8000212a <bread>
    8000303a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000303c:	40000613          	li	a2,1024
    80003040:	05890593          	addi	a1,s2,88
    80003044:	05850513          	addi	a0,a0,88
    80003048:	962fd0ef          	jal	800001aa <memmove>
    bwrite(dbuf);  // write dst to disk
    8000304c:	8526                	mv	a0,s1
    8000304e:	9b2ff0ef          	jal	80002200 <bwrite>
    if(recovering == 0)
    80003052:	fa0b18e3          	bnez	s6,80003002 <install_trans+0x36>
      bunpin(dbuf);
    80003056:	8526                	mv	a0,s1
    80003058:	a96ff0ef          	jal	800022ee <bunpin>
    8000305c:	b75d                	j	80003002 <install_trans+0x36>
}
    8000305e:	70e2                	ld	ra,56(sp)
    80003060:	7442                	ld	s0,48(sp)
    80003062:	74a2                	ld	s1,40(sp)
    80003064:	7902                	ld	s2,32(sp)
    80003066:	69e2                	ld	s3,24(sp)
    80003068:	6a42                	ld	s4,16(sp)
    8000306a:	6aa2                	ld	s5,8(sp)
    8000306c:	6b02                	ld	s6,0(sp)
    8000306e:	6121                	addi	sp,sp,64
    80003070:	8082                	ret
    80003072:	8082                	ret

0000000080003074 <initlog>:
{
    80003074:	7179                	addi	sp,sp,-48
    80003076:	f406                	sd	ra,40(sp)
    80003078:	f022                	sd	s0,32(sp)
    8000307a:	ec26                	sd	s1,24(sp)
    8000307c:	e84a                	sd	s2,16(sp)
    8000307e:	e44e                	sd	s3,8(sp)
    80003080:	1800                	addi	s0,sp,48
    80003082:	892a                	mv	s2,a0
    80003084:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003086:	00015497          	auipc	s1,0x15
    8000308a:	93a48493          	addi	s1,s1,-1734 # 800179c0 <log>
    8000308e:	00004597          	auipc	a1,0x4
    80003092:	4aa58593          	addi	a1,a1,1194 # 80007538 <etext+0x538>
    80003096:	8526                	mv	a0,s1
    80003098:	0f9020ef          	jal	80005990 <initlock>
  log.start = sb->logstart;
    8000309c:	0149a583          	lw	a1,20(s3)
    800030a0:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800030a2:	0109a783          	lw	a5,16(s3)
    800030a6:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800030a8:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800030ac:	854a                	mv	a0,s2
    800030ae:	87cff0ef          	jal	8000212a <bread>
  log.lh.n = lh->n;
    800030b2:	4d30                	lw	a2,88(a0)
    800030b4:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800030b6:	00c05f63          	blez	a2,800030d4 <initlog+0x60>
    800030ba:	87aa                	mv	a5,a0
    800030bc:	00015717          	auipc	a4,0x15
    800030c0:	93470713          	addi	a4,a4,-1740 # 800179f0 <log+0x30>
    800030c4:	060a                	slli	a2,a2,0x2
    800030c6:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800030c8:	4ff4                	lw	a3,92(a5)
    800030ca:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800030cc:	0791                	addi	a5,a5,4
    800030ce:	0711                	addi	a4,a4,4
    800030d0:	fec79ce3          	bne	a5,a2,800030c8 <initlog+0x54>
  brelse(buf);
    800030d4:	95eff0ef          	jal	80002232 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800030d8:	4505                	li	a0,1
    800030da:	ef3ff0ef          	jal	80002fcc <install_trans>
  log.lh.n = 0;
    800030de:	00015797          	auipc	a5,0x15
    800030e2:	9007a723          	sw	zero,-1778(a5) # 800179ec <log+0x2c>
  write_head(); // clear the log
    800030e6:	e89ff0ef          	jal	80002f6e <write_head>
}
    800030ea:	70a2                	ld	ra,40(sp)
    800030ec:	7402                	ld	s0,32(sp)
    800030ee:	64e2                	ld	s1,24(sp)
    800030f0:	6942                	ld	s2,16(sp)
    800030f2:	69a2                	ld	s3,8(sp)
    800030f4:	6145                	addi	sp,sp,48
    800030f6:	8082                	ret

00000000800030f8 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800030f8:	1101                	addi	sp,sp,-32
    800030fa:	ec06                	sd	ra,24(sp)
    800030fc:	e822                	sd	s0,16(sp)
    800030fe:	e426                	sd	s1,8(sp)
    80003100:	e04a                	sd	s2,0(sp)
    80003102:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003104:	00015517          	auipc	a0,0x15
    80003108:	8bc50513          	addi	a0,a0,-1860 # 800179c0 <log>
    8000310c:	105020ef          	jal	80005a10 <acquire>
  while(1){
    if(log.committing){
    80003110:	00015497          	auipc	s1,0x15
    80003114:	8b048493          	addi	s1,s1,-1872 # 800179c0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003118:	4979                	li	s2,30
    8000311a:	a029                	j	80003124 <begin_op+0x2c>
      sleep(&log, &log.lock);
    8000311c:	85a6                	mv	a1,s1
    8000311e:	8526                	mv	a0,s1
    80003120:	b18fe0ef          	jal	80001438 <sleep>
    if(log.committing){
    80003124:	50dc                	lw	a5,36(s1)
    80003126:	fbfd                	bnez	a5,8000311c <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003128:	5098                	lw	a4,32(s1)
    8000312a:	2705                	addiw	a4,a4,1
    8000312c:	0027179b          	slliw	a5,a4,0x2
    80003130:	9fb9                	addw	a5,a5,a4
    80003132:	0017979b          	slliw	a5,a5,0x1
    80003136:	54d4                	lw	a3,44(s1)
    80003138:	9fb5                	addw	a5,a5,a3
    8000313a:	00f95763          	bge	s2,a5,80003148 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000313e:	85a6                	mv	a1,s1
    80003140:	8526                	mv	a0,s1
    80003142:	af6fe0ef          	jal	80001438 <sleep>
    80003146:	bff9                	j	80003124 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003148:	00015517          	auipc	a0,0x15
    8000314c:	87850513          	addi	a0,a0,-1928 # 800179c0 <log>
    80003150:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003152:	157020ef          	jal	80005aa8 <release>
      break;
    }
  }
}
    80003156:	60e2                	ld	ra,24(sp)
    80003158:	6442                	ld	s0,16(sp)
    8000315a:	64a2                	ld	s1,8(sp)
    8000315c:	6902                	ld	s2,0(sp)
    8000315e:	6105                	addi	sp,sp,32
    80003160:	8082                	ret

0000000080003162 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003162:	7139                	addi	sp,sp,-64
    80003164:	fc06                	sd	ra,56(sp)
    80003166:	f822                	sd	s0,48(sp)
    80003168:	f426                	sd	s1,40(sp)
    8000316a:	f04a                	sd	s2,32(sp)
    8000316c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000316e:	00015497          	auipc	s1,0x15
    80003172:	85248493          	addi	s1,s1,-1966 # 800179c0 <log>
    80003176:	8526                	mv	a0,s1
    80003178:	099020ef          	jal	80005a10 <acquire>
  log.outstanding -= 1;
    8000317c:	509c                	lw	a5,32(s1)
    8000317e:	37fd                	addiw	a5,a5,-1
    80003180:	0007891b          	sext.w	s2,a5
    80003184:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003186:	50dc                	lw	a5,36(s1)
    80003188:	ef9d                	bnez	a5,800031c6 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    8000318a:	04091763          	bnez	s2,800031d8 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    8000318e:	00015497          	auipc	s1,0x15
    80003192:	83248493          	addi	s1,s1,-1998 # 800179c0 <log>
    80003196:	4785                	li	a5,1
    80003198:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000319a:	8526                	mv	a0,s1
    8000319c:	10d020ef          	jal	80005aa8 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800031a0:	54dc                	lw	a5,44(s1)
    800031a2:	04f04b63          	bgtz	a5,800031f8 <end_op+0x96>
    acquire(&log.lock);
    800031a6:	00015497          	auipc	s1,0x15
    800031aa:	81a48493          	addi	s1,s1,-2022 # 800179c0 <log>
    800031ae:	8526                	mv	a0,s1
    800031b0:	061020ef          	jal	80005a10 <acquire>
    log.committing = 0;
    800031b4:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800031b8:	8526                	mv	a0,s1
    800031ba:	acafe0ef          	jal	80001484 <wakeup>
    release(&log.lock);
    800031be:	8526                	mv	a0,s1
    800031c0:	0e9020ef          	jal	80005aa8 <release>
}
    800031c4:	a025                	j	800031ec <end_op+0x8a>
    800031c6:	ec4e                	sd	s3,24(sp)
    800031c8:	e852                	sd	s4,16(sp)
    800031ca:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800031cc:	00004517          	auipc	a0,0x4
    800031d0:	37450513          	addi	a0,a0,884 # 80007540 <etext+0x540>
    800031d4:	50e020ef          	jal	800056e2 <panic>
    wakeup(&log);
    800031d8:	00014497          	auipc	s1,0x14
    800031dc:	7e848493          	addi	s1,s1,2024 # 800179c0 <log>
    800031e0:	8526                	mv	a0,s1
    800031e2:	aa2fe0ef          	jal	80001484 <wakeup>
  release(&log.lock);
    800031e6:	8526                	mv	a0,s1
    800031e8:	0c1020ef          	jal	80005aa8 <release>
}
    800031ec:	70e2                	ld	ra,56(sp)
    800031ee:	7442                	ld	s0,48(sp)
    800031f0:	74a2                	ld	s1,40(sp)
    800031f2:	7902                	ld	s2,32(sp)
    800031f4:	6121                	addi	sp,sp,64
    800031f6:	8082                	ret
    800031f8:	ec4e                	sd	s3,24(sp)
    800031fa:	e852                	sd	s4,16(sp)
    800031fc:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800031fe:	00014a97          	auipc	s5,0x14
    80003202:	7f2a8a93          	addi	s5,s5,2034 # 800179f0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003206:	00014a17          	auipc	s4,0x14
    8000320a:	7baa0a13          	addi	s4,s4,1978 # 800179c0 <log>
    8000320e:	018a2583          	lw	a1,24(s4)
    80003212:	012585bb          	addw	a1,a1,s2
    80003216:	2585                	addiw	a1,a1,1
    80003218:	028a2503          	lw	a0,40(s4)
    8000321c:	f0ffe0ef          	jal	8000212a <bread>
    80003220:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003222:	000aa583          	lw	a1,0(s5)
    80003226:	028a2503          	lw	a0,40(s4)
    8000322a:	f01fe0ef          	jal	8000212a <bread>
    8000322e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003230:	40000613          	li	a2,1024
    80003234:	05850593          	addi	a1,a0,88
    80003238:	05848513          	addi	a0,s1,88
    8000323c:	f6ffc0ef          	jal	800001aa <memmove>
    bwrite(to);  // write the log
    80003240:	8526                	mv	a0,s1
    80003242:	fbffe0ef          	jal	80002200 <bwrite>
    brelse(from);
    80003246:	854e                	mv	a0,s3
    80003248:	febfe0ef          	jal	80002232 <brelse>
    brelse(to);
    8000324c:	8526                	mv	a0,s1
    8000324e:	fe5fe0ef          	jal	80002232 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003252:	2905                	addiw	s2,s2,1
    80003254:	0a91                	addi	s5,s5,4
    80003256:	02ca2783          	lw	a5,44(s4)
    8000325a:	faf94ae3          	blt	s2,a5,8000320e <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000325e:	d11ff0ef          	jal	80002f6e <write_head>
    install_trans(0); // Now install writes to home locations
    80003262:	4501                	li	a0,0
    80003264:	d69ff0ef          	jal	80002fcc <install_trans>
    log.lh.n = 0;
    80003268:	00014797          	auipc	a5,0x14
    8000326c:	7807a223          	sw	zero,1924(a5) # 800179ec <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003270:	cffff0ef          	jal	80002f6e <write_head>
    80003274:	69e2                	ld	s3,24(sp)
    80003276:	6a42                	ld	s4,16(sp)
    80003278:	6aa2                	ld	s5,8(sp)
    8000327a:	b735                	j	800031a6 <end_op+0x44>

000000008000327c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000327c:	1101                	addi	sp,sp,-32
    8000327e:	ec06                	sd	ra,24(sp)
    80003280:	e822                	sd	s0,16(sp)
    80003282:	e426                	sd	s1,8(sp)
    80003284:	e04a                	sd	s2,0(sp)
    80003286:	1000                	addi	s0,sp,32
    80003288:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000328a:	00014917          	auipc	s2,0x14
    8000328e:	73690913          	addi	s2,s2,1846 # 800179c0 <log>
    80003292:	854a                	mv	a0,s2
    80003294:	77c020ef          	jal	80005a10 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003298:	02c92603          	lw	a2,44(s2)
    8000329c:	47f5                	li	a5,29
    8000329e:	06c7c363          	blt	a5,a2,80003304 <log_write+0x88>
    800032a2:	00014797          	auipc	a5,0x14
    800032a6:	73a7a783          	lw	a5,1850(a5) # 800179dc <log+0x1c>
    800032aa:	37fd                	addiw	a5,a5,-1
    800032ac:	04f65c63          	bge	a2,a5,80003304 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800032b0:	00014797          	auipc	a5,0x14
    800032b4:	7307a783          	lw	a5,1840(a5) # 800179e0 <log+0x20>
    800032b8:	04f05c63          	blez	a5,80003310 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800032bc:	4781                	li	a5,0
    800032be:	04c05f63          	blez	a2,8000331c <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800032c2:	44cc                	lw	a1,12(s1)
    800032c4:	00014717          	auipc	a4,0x14
    800032c8:	72c70713          	addi	a4,a4,1836 # 800179f0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800032cc:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800032ce:	4314                	lw	a3,0(a4)
    800032d0:	04b68663          	beq	a3,a1,8000331c <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    800032d4:	2785                	addiw	a5,a5,1
    800032d6:	0711                	addi	a4,a4,4
    800032d8:	fef61be3          	bne	a2,a5,800032ce <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    800032dc:	0621                	addi	a2,a2,8
    800032de:	060a                	slli	a2,a2,0x2
    800032e0:	00014797          	auipc	a5,0x14
    800032e4:	6e078793          	addi	a5,a5,1760 # 800179c0 <log>
    800032e8:	97b2                	add	a5,a5,a2
    800032ea:	44d8                	lw	a4,12(s1)
    800032ec:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800032ee:	8526                	mv	a0,s1
    800032f0:	fcbfe0ef          	jal	800022ba <bpin>
    log.lh.n++;
    800032f4:	00014717          	auipc	a4,0x14
    800032f8:	6cc70713          	addi	a4,a4,1740 # 800179c0 <log>
    800032fc:	575c                	lw	a5,44(a4)
    800032fe:	2785                	addiw	a5,a5,1
    80003300:	d75c                	sw	a5,44(a4)
    80003302:	a80d                	j	80003334 <log_write+0xb8>
    panic("too big a transaction");
    80003304:	00004517          	auipc	a0,0x4
    80003308:	24c50513          	addi	a0,a0,588 # 80007550 <etext+0x550>
    8000330c:	3d6020ef          	jal	800056e2 <panic>
    panic("log_write outside of trans");
    80003310:	00004517          	auipc	a0,0x4
    80003314:	25850513          	addi	a0,a0,600 # 80007568 <etext+0x568>
    80003318:	3ca020ef          	jal	800056e2 <panic>
  log.lh.block[i] = b->blockno;
    8000331c:	00878693          	addi	a3,a5,8
    80003320:	068a                	slli	a3,a3,0x2
    80003322:	00014717          	auipc	a4,0x14
    80003326:	69e70713          	addi	a4,a4,1694 # 800179c0 <log>
    8000332a:	9736                	add	a4,a4,a3
    8000332c:	44d4                	lw	a3,12(s1)
    8000332e:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003330:	faf60fe3          	beq	a2,a5,800032ee <log_write+0x72>
  }
  release(&log.lock);
    80003334:	00014517          	auipc	a0,0x14
    80003338:	68c50513          	addi	a0,a0,1676 # 800179c0 <log>
    8000333c:	76c020ef          	jal	80005aa8 <release>
}
    80003340:	60e2                	ld	ra,24(sp)
    80003342:	6442                	ld	s0,16(sp)
    80003344:	64a2                	ld	s1,8(sp)
    80003346:	6902                	ld	s2,0(sp)
    80003348:	6105                	addi	sp,sp,32
    8000334a:	8082                	ret

000000008000334c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000334c:	1101                	addi	sp,sp,-32
    8000334e:	ec06                	sd	ra,24(sp)
    80003350:	e822                	sd	s0,16(sp)
    80003352:	e426                	sd	s1,8(sp)
    80003354:	e04a                	sd	s2,0(sp)
    80003356:	1000                	addi	s0,sp,32
    80003358:	84aa                	mv	s1,a0
    8000335a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000335c:	00004597          	auipc	a1,0x4
    80003360:	22c58593          	addi	a1,a1,556 # 80007588 <etext+0x588>
    80003364:	0521                	addi	a0,a0,8
    80003366:	62a020ef          	jal	80005990 <initlock>
  lk->name = name;
    8000336a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000336e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003372:	0204a423          	sw	zero,40(s1)
}
    80003376:	60e2                	ld	ra,24(sp)
    80003378:	6442                	ld	s0,16(sp)
    8000337a:	64a2                	ld	s1,8(sp)
    8000337c:	6902                	ld	s2,0(sp)
    8000337e:	6105                	addi	sp,sp,32
    80003380:	8082                	ret

0000000080003382 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003382:	1101                	addi	sp,sp,-32
    80003384:	ec06                	sd	ra,24(sp)
    80003386:	e822                	sd	s0,16(sp)
    80003388:	e426                	sd	s1,8(sp)
    8000338a:	e04a                	sd	s2,0(sp)
    8000338c:	1000                	addi	s0,sp,32
    8000338e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003390:	00850913          	addi	s2,a0,8
    80003394:	854a                	mv	a0,s2
    80003396:	67a020ef          	jal	80005a10 <acquire>
  while (lk->locked) {
    8000339a:	409c                	lw	a5,0(s1)
    8000339c:	c799                	beqz	a5,800033aa <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    8000339e:	85ca                	mv	a1,s2
    800033a0:	8526                	mv	a0,s1
    800033a2:	896fe0ef          	jal	80001438 <sleep>
  while (lk->locked) {
    800033a6:	409c                	lw	a5,0(s1)
    800033a8:	fbfd                	bnez	a5,8000339e <acquiresleep+0x1c>
  }
  lk->locked = 1;
    800033aa:	4785                	li	a5,1
    800033ac:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800033ae:	abdfd0ef          	jal	80000e6a <myproc>
    800033b2:	591c                	lw	a5,48(a0)
    800033b4:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800033b6:	854a                	mv	a0,s2
    800033b8:	6f0020ef          	jal	80005aa8 <release>
}
    800033bc:	60e2                	ld	ra,24(sp)
    800033be:	6442                	ld	s0,16(sp)
    800033c0:	64a2                	ld	s1,8(sp)
    800033c2:	6902                	ld	s2,0(sp)
    800033c4:	6105                	addi	sp,sp,32
    800033c6:	8082                	ret

00000000800033c8 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800033c8:	1101                	addi	sp,sp,-32
    800033ca:	ec06                	sd	ra,24(sp)
    800033cc:	e822                	sd	s0,16(sp)
    800033ce:	e426                	sd	s1,8(sp)
    800033d0:	e04a                	sd	s2,0(sp)
    800033d2:	1000                	addi	s0,sp,32
    800033d4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800033d6:	00850913          	addi	s2,a0,8
    800033da:	854a                	mv	a0,s2
    800033dc:	634020ef          	jal	80005a10 <acquire>
  lk->locked = 0;
    800033e0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800033e4:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800033e8:	8526                	mv	a0,s1
    800033ea:	89afe0ef          	jal	80001484 <wakeup>
  release(&lk->lk);
    800033ee:	854a                	mv	a0,s2
    800033f0:	6b8020ef          	jal	80005aa8 <release>
}
    800033f4:	60e2                	ld	ra,24(sp)
    800033f6:	6442                	ld	s0,16(sp)
    800033f8:	64a2                	ld	s1,8(sp)
    800033fa:	6902                	ld	s2,0(sp)
    800033fc:	6105                	addi	sp,sp,32
    800033fe:	8082                	ret

0000000080003400 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003400:	7179                	addi	sp,sp,-48
    80003402:	f406                	sd	ra,40(sp)
    80003404:	f022                	sd	s0,32(sp)
    80003406:	ec26                	sd	s1,24(sp)
    80003408:	e84a                	sd	s2,16(sp)
    8000340a:	1800                	addi	s0,sp,48
    8000340c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000340e:	00850913          	addi	s2,a0,8
    80003412:	854a                	mv	a0,s2
    80003414:	5fc020ef          	jal	80005a10 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003418:	409c                	lw	a5,0(s1)
    8000341a:	ef81                	bnez	a5,80003432 <holdingsleep+0x32>
    8000341c:	4481                	li	s1,0
  release(&lk->lk);
    8000341e:	854a                	mv	a0,s2
    80003420:	688020ef          	jal	80005aa8 <release>
  return r;
}
    80003424:	8526                	mv	a0,s1
    80003426:	70a2                	ld	ra,40(sp)
    80003428:	7402                	ld	s0,32(sp)
    8000342a:	64e2                	ld	s1,24(sp)
    8000342c:	6942                	ld	s2,16(sp)
    8000342e:	6145                	addi	sp,sp,48
    80003430:	8082                	ret
    80003432:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003434:	0284a983          	lw	s3,40(s1)
    80003438:	a33fd0ef          	jal	80000e6a <myproc>
    8000343c:	5904                	lw	s1,48(a0)
    8000343e:	413484b3          	sub	s1,s1,s3
    80003442:	0014b493          	seqz	s1,s1
    80003446:	69a2                	ld	s3,8(sp)
    80003448:	bfd9                	j	8000341e <holdingsleep+0x1e>

000000008000344a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000344a:	1141                	addi	sp,sp,-16
    8000344c:	e406                	sd	ra,8(sp)
    8000344e:	e022                	sd	s0,0(sp)
    80003450:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003452:	00004597          	auipc	a1,0x4
    80003456:	14658593          	addi	a1,a1,326 # 80007598 <etext+0x598>
    8000345a:	00014517          	auipc	a0,0x14
    8000345e:	6ae50513          	addi	a0,a0,1710 # 80017b08 <ftable>
    80003462:	52e020ef          	jal	80005990 <initlock>
}
    80003466:	60a2                	ld	ra,8(sp)
    80003468:	6402                	ld	s0,0(sp)
    8000346a:	0141                	addi	sp,sp,16
    8000346c:	8082                	ret

000000008000346e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000346e:	1101                	addi	sp,sp,-32
    80003470:	ec06                	sd	ra,24(sp)
    80003472:	e822                	sd	s0,16(sp)
    80003474:	e426                	sd	s1,8(sp)
    80003476:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003478:	00014517          	auipc	a0,0x14
    8000347c:	69050513          	addi	a0,a0,1680 # 80017b08 <ftable>
    80003480:	590020ef          	jal	80005a10 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003484:	00014497          	auipc	s1,0x14
    80003488:	69c48493          	addi	s1,s1,1692 # 80017b20 <ftable+0x18>
    8000348c:	00015717          	auipc	a4,0x15
    80003490:	63470713          	addi	a4,a4,1588 # 80018ac0 <disk>
    if(f->ref == 0){
    80003494:	40dc                	lw	a5,4(s1)
    80003496:	cf89                	beqz	a5,800034b0 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003498:	02848493          	addi	s1,s1,40
    8000349c:	fee49ce3          	bne	s1,a4,80003494 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800034a0:	00014517          	auipc	a0,0x14
    800034a4:	66850513          	addi	a0,a0,1640 # 80017b08 <ftable>
    800034a8:	600020ef          	jal	80005aa8 <release>
  return 0;
    800034ac:	4481                	li	s1,0
    800034ae:	a809                	j	800034c0 <filealloc+0x52>
      f->ref = 1;
    800034b0:	4785                	li	a5,1
    800034b2:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800034b4:	00014517          	auipc	a0,0x14
    800034b8:	65450513          	addi	a0,a0,1620 # 80017b08 <ftable>
    800034bc:	5ec020ef          	jal	80005aa8 <release>
}
    800034c0:	8526                	mv	a0,s1
    800034c2:	60e2                	ld	ra,24(sp)
    800034c4:	6442                	ld	s0,16(sp)
    800034c6:	64a2                	ld	s1,8(sp)
    800034c8:	6105                	addi	sp,sp,32
    800034ca:	8082                	ret

00000000800034cc <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800034cc:	1101                	addi	sp,sp,-32
    800034ce:	ec06                	sd	ra,24(sp)
    800034d0:	e822                	sd	s0,16(sp)
    800034d2:	e426                	sd	s1,8(sp)
    800034d4:	1000                	addi	s0,sp,32
    800034d6:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800034d8:	00014517          	auipc	a0,0x14
    800034dc:	63050513          	addi	a0,a0,1584 # 80017b08 <ftable>
    800034e0:	530020ef          	jal	80005a10 <acquire>
  if(f->ref < 1)
    800034e4:	40dc                	lw	a5,4(s1)
    800034e6:	02f05063          	blez	a5,80003506 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800034ea:	2785                	addiw	a5,a5,1
    800034ec:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800034ee:	00014517          	auipc	a0,0x14
    800034f2:	61a50513          	addi	a0,a0,1562 # 80017b08 <ftable>
    800034f6:	5b2020ef          	jal	80005aa8 <release>
  return f;
}
    800034fa:	8526                	mv	a0,s1
    800034fc:	60e2                	ld	ra,24(sp)
    800034fe:	6442                	ld	s0,16(sp)
    80003500:	64a2                	ld	s1,8(sp)
    80003502:	6105                	addi	sp,sp,32
    80003504:	8082                	ret
    panic("filedup");
    80003506:	00004517          	auipc	a0,0x4
    8000350a:	09a50513          	addi	a0,a0,154 # 800075a0 <etext+0x5a0>
    8000350e:	1d4020ef          	jal	800056e2 <panic>

0000000080003512 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003512:	7139                	addi	sp,sp,-64
    80003514:	fc06                	sd	ra,56(sp)
    80003516:	f822                	sd	s0,48(sp)
    80003518:	f426                	sd	s1,40(sp)
    8000351a:	0080                	addi	s0,sp,64
    8000351c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000351e:	00014517          	auipc	a0,0x14
    80003522:	5ea50513          	addi	a0,a0,1514 # 80017b08 <ftable>
    80003526:	4ea020ef          	jal	80005a10 <acquire>
  if(f->ref < 1)
    8000352a:	40dc                	lw	a5,4(s1)
    8000352c:	04f05a63          	blez	a5,80003580 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80003530:	37fd                	addiw	a5,a5,-1
    80003532:	0007871b          	sext.w	a4,a5
    80003536:	c0dc                	sw	a5,4(s1)
    80003538:	04e04e63          	bgtz	a4,80003594 <fileclose+0x82>
    8000353c:	f04a                	sd	s2,32(sp)
    8000353e:	ec4e                	sd	s3,24(sp)
    80003540:	e852                	sd	s4,16(sp)
    80003542:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003544:	0004a903          	lw	s2,0(s1)
    80003548:	0094ca83          	lbu	s5,9(s1)
    8000354c:	0104ba03          	ld	s4,16(s1)
    80003550:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003554:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003558:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000355c:	00014517          	auipc	a0,0x14
    80003560:	5ac50513          	addi	a0,a0,1452 # 80017b08 <ftable>
    80003564:	544020ef          	jal	80005aa8 <release>

  if(ff.type == FD_PIPE){
    80003568:	4785                	li	a5,1
    8000356a:	04f90063          	beq	s2,a5,800035aa <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000356e:	3979                	addiw	s2,s2,-2
    80003570:	4785                	li	a5,1
    80003572:	0527f563          	bgeu	a5,s2,800035bc <fileclose+0xaa>
    80003576:	7902                	ld	s2,32(sp)
    80003578:	69e2                	ld	s3,24(sp)
    8000357a:	6a42                	ld	s4,16(sp)
    8000357c:	6aa2                	ld	s5,8(sp)
    8000357e:	a00d                	j	800035a0 <fileclose+0x8e>
    80003580:	f04a                	sd	s2,32(sp)
    80003582:	ec4e                	sd	s3,24(sp)
    80003584:	e852                	sd	s4,16(sp)
    80003586:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003588:	00004517          	auipc	a0,0x4
    8000358c:	02050513          	addi	a0,a0,32 # 800075a8 <etext+0x5a8>
    80003590:	152020ef          	jal	800056e2 <panic>
    release(&ftable.lock);
    80003594:	00014517          	auipc	a0,0x14
    80003598:	57450513          	addi	a0,a0,1396 # 80017b08 <ftable>
    8000359c:	50c020ef          	jal	80005aa8 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800035a0:	70e2                	ld	ra,56(sp)
    800035a2:	7442                	ld	s0,48(sp)
    800035a4:	74a2                	ld	s1,40(sp)
    800035a6:	6121                	addi	sp,sp,64
    800035a8:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800035aa:	85d6                	mv	a1,s5
    800035ac:	8552                	mv	a0,s4
    800035ae:	336000ef          	jal	800038e4 <pipeclose>
    800035b2:	7902                	ld	s2,32(sp)
    800035b4:	69e2                	ld	s3,24(sp)
    800035b6:	6a42                	ld	s4,16(sp)
    800035b8:	6aa2                	ld	s5,8(sp)
    800035ba:	b7dd                	j	800035a0 <fileclose+0x8e>
    begin_op();
    800035bc:	b3dff0ef          	jal	800030f8 <begin_op>
    iput(ff.ip);
    800035c0:	854e                	mv	a0,s3
    800035c2:	c22ff0ef          	jal	800029e4 <iput>
    end_op();
    800035c6:	b9dff0ef          	jal	80003162 <end_op>
    800035ca:	7902                	ld	s2,32(sp)
    800035cc:	69e2                	ld	s3,24(sp)
    800035ce:	6a42                	ld	s4,16(sp)
    800035d0:	6aa2                	ld	s5,8(sp)
    800035d2:	b7f9                	j	800035a0 <fileclose+0x8e>

00000000800035d4 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800035d4:	715d                	addi	sp,sp,-80
    800035d6:	e486                	sd	ra,72(sp)
    800035d8:	e0a2                	sd	s0,64(sp)
    800035da:	fc26                	sd	s1,56(sp)
    800035dc:	f44e                	sd	s3,40(sp)
    800035de:	0880                	addi	s0,sp,80
    800035e0:	84aa                	mv	s1,a0
    800035e2:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800035e4:	887fd0ef          	jal	80000e6a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800035e8:	409c                	lw	a5,0(s1)
    800035ea:	37f9                	addiw	a5,a5,-2
    800035ec:	4705                	li	a4,1
    800035ee:	04f76063          	bltu	a4,a5,8000362e <filestat+0x5a>
    800035f2:	f84a                	sd	s2,48(sp)
    800035f4:	892a                	mv	s2,a0
    ilock(f->ip);
    800035f6:	6c88                	ld	a0,24(s1)
    800035f8:	a6aff0ef          	jal	80002862 <ilock>
    stati(f->ip, &st);
    800035fc:	fb840593          	addi	a1,s0,-72
    80003600:	6c88                	ld	a0,24(s1)
    80003602:	c8aff0ef          	jal	80002a8c <stati>
    iunlock(f->ip);
    80003606:	6c88                	ld	a0,24(s1)
    80003608:	b08ff0ef          	jal	80002910 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000360c:	46e1                	li	a3,24
    8000360e:	fb840613          	addi	a2,s0,-72
    80003612:	85ce                	mv	a1,s3
    80003614:	05093503          	ld	a0,80(s2)
    80003618:	bdafd0ef          	jal	800009f2 <copyout>
    8000361c:	41f5551b          	sraiw	a0,a0,0x1f
    80003620:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003622:	60a6                	ld	ra,72(sp)
    80003624:	6406                	ld	s0,64(sp)
    80003626:	74e2                	ld	s1,56(sp)
    80003628:	79a2                	ld	s3,40(sp)
    8000362a:	6161                	addi	sp,sp,80
    8000362c:	8082                	ret
  return -1;
    8000362e:	557d                	li	a0,-1
    80003630:	bfcd                	j	80003622 <filestat+0x4e>

0000000080003632 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003632:	7179                	addi	sp,sp,-48
    80003634:	f406                	sd	ra,40(sp)
    80003636:	f022                	sd	s0,32(sp)
    80003638:	e84a                	sd	s2,16(sp)
    8000363a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000363c:	00854783          	lbu	a5,8(a0)
    80003640:	cfd1                	beqz	a5,800036dc <fileread+0xaa>
    80003642:	ec26                	sd	s1,24(sp)
    80003644:	e44e                	sd	s3,8(sp)
    80003646:	84aa                	mv	s1,a0
    80003648:	89ae                	mv	s3,a1
    8000364a:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    8000364c:	411c                	lw	a5,0(a0)
    8000364e:	4705                	li	a4,1
    80003650:	04e78363          	beq	a5,a4,80003696 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003654:	470d                	li	a4,3
    80003656:	04e78763          	beq	a5,a4,800036a4 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000365a:	4709                	li	a4,2
    8000365c:	06e79a63          	bne	a5,a4,800036d0 <fileread+0x9e>
    ilock(f->ip);
    80003660:	6d08                	ld	a0,24(a0)
    80003662:	a00ff0ef          	jal	80002862 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003666:	874a                	mv	a4,s2
    80003668:	5094                	lw	a3,32(s1)
    8000366a:	864e                	mv	a2,s3
    8000366c:	4585                	li	a1,1
    8000366e:	6c88                	ld	a0,24(s1)
    80003670:	c46ff0ef          	jal	80002ab6 <readi>
    80003674:	892a                	mv	s2,a0
    80003676:	00a05563          	blez	a0,80003680 <fileread+0x4e>
      f->off += r;
    8000367a:	509c                	lw	a5,32(s1)
    8000367c:	9fa9                	addw	a5,a5,a0
    8000367e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003680:	6c88                	ld	a0,24(s1)
    80003682:	a8eff0ef          	jal	80002910 <iunlock>
    80003686:	64e2                	ld	s1,24(sp)
    80003688:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000368a:	854a                	mv	a0,s2
    8000368c:	70a2                	ld	ra,40(sp)
    8000368e:	7402                	ld	s0,32(sp)
    80003690:	6942                	ld	s2,16(sp)
    80003692:	6145                	addi	sp,sp,48
    80003694:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003696:	6908                	ld	a0,16(a0)
    80003698:	388000ef          	jal	80003a20 <piperead>
    8000369c:	892a                	mv	s2,a0
    8000369e:	64e2                	ld	s1,24(sp)
    800036a0:	69a2                	ld	s3,8(sp)
    800036a2:	b7e5                	j	8000368a <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800036a4:	02451783          	lh	a5,36(a0)
    800036a8:	03079693          	slli	a3,a5,0x30
    800036ac:	92c1                	srli	a3,a3,0x30
    800036ae:	4725                	li	a4,9
    800036b0:	02d76863          	bltu	a4,a3,800036e0 <fileread+0xae>
    800036b4:	0792                	slli	a5,a5,0x4
    800036b6:	00014717          	auipc	a4,0x14
    800036ba:	3b270713          	addi	a4,a4,946 # 80017a68 <devsw>
    800036be:	97ba                	add	a5,a5,a4
    800036c0:	639c                	ld	a5,0(a5)
    800036c2:	c39d                	beqz	a5,800036e8 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    800036c4:	4505                	li	a0,1
    800036c6:	9782                	jalr	a5
    800036c8:	892a                	mv	s2,a0
    800036ca:	64e2                	ld	s1,24(sp)
    800036cc:	69a2                	ld	s3,8(sp)
    800036ce:	bf75                	j	8000368a <fileread+0x58>
    panic("fileread");
    800036d0:	00004517          	auipc	a0,0x4
    800036d4:	ee850513          	addi	a0,a0,-280 # 800075b8 <etext+0x5b8>
    800036d8:	00a020ef          	jal	800056e2 <panic>
    return -1;
    800036dc:	597d                	li	s2,-1
    800036de:	b775                	j	8000368a <fileread+0x58>
      return -1;
    800036e0:	597d                	li	s2,-1
    800036e2:	64e2                	ld	s1,24(sp)
    800036e4:	69a2                	ld	s3,8(sp)
    800036e6:	b755                	j	8000368a <fileread+0x58>
    800036e8:	597d                	li	s2,-1
    800036ea:	64e2                	ld	s1,24(sp)
    800036ec:	69a2                	ld	s3,8(sp)
    800036ee:	bf71                	j	8000368a <fileread+0x58>

00000000800036f0 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800036f0:	00954783          	lbu	a5,9(a0)
    800036f4:	10078b63          	beqz	a5,8000380a <filewrite+0x11a>
{
    800036f8:	715d                	addi	sp,sp,-80
    800036fa:	e486                	sd	ra,72(sp)
    800036fc:	e0a2                	sd	s0,64(sp)
    800036fe:	f84a                	sd	s2,48(sp)
    80003700:	f052                	sd	s4,32(sp)
    80003702:	e85a                	sd	s6,16(sp)
    80003704:	0880                	addi	s0,sp,80
    80003706:	892a                	mv	s2,a0
    80003708:	8b2e                	mv	s6,a1
    8000370a:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    8000370c:	411c                	lw	a5,0(a0)
    8000370e:	4705                	li	a4,1
    80003710:	02e78763          	beq	a5,a4,8000373e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003714:	470d                	li	a4,3
    80003716:	02e78863          	beq	a5,a4,80003746 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000371a:	4709                	li	a4,2
    8000371c:	0ce79c63          	bne	a5,a4,800037f4 <filewrite+0x104>
    80003720:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003722:	0ac05863          	blez	a2,800037d2 <filewrite+0xe2>
    80003726:	fc26                	sd	s1,56(sp)
    80003728:	ec56                	sd	s5,24(sp)
    8000372a:	e45e                	sd	s7,8(sp)
    8000372c:	e062                	sd	s8,0(sp)
    int i = 0;
    8000372e:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003730:	6b85                	lui	s7,0x1
    80003732:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003736:	6c05                	lui	s8,0x1
    80003738:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    8000373c:	a8b5                	j	800037b8 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    8000373e:	6908                	ld	a0,16(a0)
    80003740:	1fc000ef          	jal	8000393c <pipewrite>
    80003744:	a04d                	j	800037e6 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003746:	02451783          	lh	a5,36(a0)
    8000374a:	03079693          	slli	a3,a5,0x30
    8000374e:	92c1                	srli	a3,a3,0x30
    80003750:	4725                	li	a4,9
    80003752:	0ad76e63          	bltu	a4,a3,8000380e <filewrite+0x11e>
    80003756:	0792                	slli	a5,a5,0x4
    80003758:	00014717          	auipc	a4,0x14
    8000375c:	31070713          	addi	a4,a4,784 # 80017a68 <devsw>
    80003760:	97ba                	add	a5,a5,a4
    80003762:	679c                	ld	a5,8(a5)
    80003764:	c7dd                	beqz	a5,80003812 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    80003766:	4505                	li	a0,1
    80003768:	9782                	jalr	a5
    8000376a:	a8b5                	j	800037e6 <filewrite+0xf6>
      if(n1 > max)
    8000376c:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003770:	989ff0ef          	jal	800030f8 <begin_op>
      ilock(f->ip);
    80003774:	01893503          	ld	a0,24(s2)
    80003778:	8eaff0ef          	jal	80002862 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000377c:	8756                	mv	a4,s5
    8000377e:	02092683          	lw	a3,32(s2)
    80003782:	01698633          	add	a2,s3,s6
    80003786:	4585                	li	a1,1
    80003788:	01893503          	ld	a0,24(s2)
    8000378c:	c26ff0ef          	jal	80002bb2 <writei>
    80003790:	84aa                	mv	s1,a0
    80003792:	00a05763          	blez	a0,800037a0 <filewrite+0xb0>
        f->off += r;
    80003796:	02092783          	lw	a5,32(s2)
    8000379a:	9fa9                	addw	a5,a5,a0
    8000379c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800037a0:	01893503          	ld	a0,24(s2)
    800037a4:	96cff0ef          	jal	80002910 <iunlock>
      end_op();
    800037a8:	9bbff0ef          	jal	80003162 <end_op>

      if(r != n1){
    800037ac:	029a9563          	bne	s5,s1,800037d6 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    800037b0:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800037b4:	0149da63          	bge	s3,s4,800037c8 <filewrite+0xd8>
      int n1 = n - i;
    800037b8:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    800037bc:	0004879b          	sext.w	a5,s1
    800037c0:	fafbd6e3          	bge	s7,a5,8000376c <filewrite+0x7c>
    800037c4:	84e2                	mv	s1,s8
    800037c6:	b75d                	j	8000376c <filewrite+0x7c>
    800037c8:	74e2                	ld	s1,56(sp)
    800037ca:	6ae2                	ld	s5,24(sp)
    800037cc:	6ba2                	ld	s7,8(sp)
    800037ce:	6c02                	ld	s8,0(sp)
    800037d0:	a039                	j	800037de <filewrite+0xee>
    int i = 0;
    800037d2:	4981                	li	s3,0
    800037d4:	a029                	j	800037de <filewrite+0xee>
    800037d6:	74e2                	ld	s1,56(sp)
    800037d8:	6ae2                	ld	s5,24(sp)
    800037da:	6ba2                	ld	s7,8(sp)
    800037dc:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    800037de:	033a1c63          	bne	s4,s3,80003816 <filewrite+0x126>
    800037e2:	8552                	mv	a0,s4
    800037e4:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800037e6:	60a6                	ld	ra,72(sp)
    800037e8:	6406                	ld	s0,64(sp)
    800037ea:	7942                	ld	s2,48(sp)
    800037ec:	7a02                	ld	s4,32(sp)
    800037ee:	6b42                	ld	s6,16(sp)
    800037f0:	6161                	addi	sp,sp,80
    800037f2:	8082                	ret
    800037f4:	fc26                	sd	s1,56(sp)
    800037f6:	f44e                	sd	s3,40(sp)
    800037f8:	ec56                	sd	s5,24(sp)
    800037fa:	e45e                	sd	s7,8(sp)
    800037fc:	e062                	sd	s8,0(sp)
    panic("filewrite");
    800037fe:	00004517          	auipc	a0,0x4
    80003802:	dca50513          	addi	a0,a0,-566 # 800075c8 <etext+0x5c8>
    80003806:	6dd010ef          	jal	800056e2 <panic>
    return -1;
    8000380a:	557d                	li	a0,-1
}
    8000380c:	8082                	ret
      return -1;
    8000380e:	557d                	li	a0,-1
    80003810:	bfd9                	j	800037e6 <filewrite+0xf6>
    80003812:	557d                	li	a0,-1
    80003814:	bfc9                	j	800037e6 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    80003816:	557d                	li	a0,-1
    80003818:	79a2                	ld	s3,40(sp)
    8000381a:	b7f1                	j	800037e6 <filewrite+0xf6>

000000008000381c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000381c:	7179                	addi	sp,sp,-48
    8000381e:	f406                	sd	ra,40(sp)
    80003820:	f022                	sd	s0,32(sp)
    80003822:	ec26                	sd	s1,24(sp)
    80003824:	e052                	sd	s4,0(sp)
    80003826:	1800                	addi	s0,sp,48
    80003828:	84aa                	mv	s1,a0
    8000382a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000382c:	0005b023          	sd	zero,0(a1)
    80003830:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003834:	c3bff0ef          	jal	8000346e <filealloc>
    80003838:	e088                	sd	a0,0(s1)
    8000383a:	c549                	beqz	a0,800038c4 <pipealloc+0xa8>
    8000383c:	c33ff0ef          	jal	8000346e <filealloc>
    80003840:	00aa3023          	sd	a0,0(s4)
    80003844:	cd25                	beqz	a0,800038bc <pipealloc+0xa0>
    80003846:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003848:	8b7fc0ef          	jal	800000fe <kalloc>
    8000384c:	892a                	mv	s2,a0
    8000384e:	c12d                	beqz	a0,800038b0 <pipealloc+0x94>
    80003850:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003852:	4985                	li	s3,1
    80003854:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003858:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000385c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003860:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003864:	00004597          	auipc	a1,0x4
    80003868:	d7458593          	addi	a1,a1,-652 # 800075d8 <etext+0x5d8>
    8000386c:	124020ef          	jal	80005990 <initlock>
  (*f0)->type = FD_PIPE;
    80003870:	609c                	ld	a5,0(s1)
    80003872:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003876:	609c                	ld	a5,0(s1)
    80003878:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000387c:	609c                	ld	a5,0(s1)
    8000387e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003882:	609c                	ld	a5,0(s1)
    80003884:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003888:	000a3783          	ld	a5,0(s4)
    8000388c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003890:	000a3783          	ld	a5,0(s4)
    80003894:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003898:	000a3783          	ld	a5,0(s4)
    8000389c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800038a0:	000a3783          	ld	a5,0(s4)
    800038a4:	0127b823          	sd	s2,16(a5)
  return 0;
    800038a8:	4501                	li	a0,0
    800038aa:	6942                	ld	s2,16(sp)
    800038ac:	69a2                	ld	s3,8(sp)
    800038ae:	a01d                	j	800038d4 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800038b0:	6088                	ld	a0,0(s1)
    800038b2:	c119                	beqz	a0,800038b8 <pipealloc+0x9c>
    800038b4:	6942                	ld	s2,16(sp)
    800038b6:	a029                	j	800038c0 <pipealloc+0xa4>
    800038b8:	6942                	ld	s2,16(sp)
    800038ba:	a029                	j	800038c4 <pipealloc+0xa8>
    800038bc:	6088                	ld	a0,0(s1)
    800038be:	c10d                	beqz	a0,800038e0 <pipealloc+0xc4>
    fileclose(*f0);
    800038c0:	c53ff0ef          	jal	80003512 <fileclose>
  if(*f1)
    800038c4:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800038c8:	557d                	li	a0,-1
  if(*f1)
    800038ca:	c789                	beqz	a5,800038d4 <pipealloc+0xb8>
    fileclose(*f1);
    800038cc:	853e                	mv	a0,a5
    800038ce:	c45ff0ef          	jal	80003512 <fileclose>
  return -1;
    800038d2:	557d                	li	a0,-1
}
    800038d4:	70a2                	ld	ra,40(sp)
    800038d6:	7402                	ld	s0,32(sp)
    800038d8:	64e2                	ld	s1,24(sp)
    800038da:	6a02                	ld	s4,0(sp)
    800038dc:	6145                	addi	sp,sp,48
    800038de:	8082                	ret
  return -1;
    800038e0:	557d                	li	a0,-1
    800038e2:	bfcd                	j	800038d4 <pipealloc+0xb8>

00000000800038e4 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800038e4:	1101                	addi	sp,sp,-32
    800038e6:	ec06                	sd	ra,24(sp)
    800038e8:	e822                	sd	s0,16(sp)
    800038ea:	e426                	sd	s1,8(sp)
    800038ec:	e04a                	sd	s2,0(sp)
    800038ee:	1000                	addi	s0,sp,32
    800038f0:	84aa                	mv	s1,a0
    800038f2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800038f4:	11c020ef          	jal	80005a10 <acquire>
  if(writable){
    800038f8:	02090763          	beqz	s2,80003926 <pipeclose+0x42>
    pi->writeopen = 0;
    800038fc:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003900:	21848513          	addi	a0,s1,536
    80003904:	b81fd0ef          	jal	80001484 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003908:	2204b783          	ld	a5,544(s1)
    8000390c:	e785                	bnez	a5,80003934 <pipeclose+0x50>
    release(&pi->lock);
    8000390e:	8526                	mv	a0,s1
    80003910:	198020ef          	jal	80005aa8 <release>
    kfree((char*)pi);
    80003914:	8526                	mv	a0,s1
    80003916:	f06fc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    8000391a:	60e2                	ld	ra,24(sp)
    8000391c:	6442                	ld	s0,16(sp)
    8000391e:	64a2                	ld	s1,8(sp)
    80003920:	6902                	ld	s2,0(sp)
    80003922:	6105                	addi	sp,sp,32
    80003924:	8082                	ret
    pi->readopen = 0;
    80003926:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000392a:	21c48513          	addi	a0,s1,540
    8000392e:	b57fd0ef          	jal	80001484 <wakeup>
    80003932:	bfd9                	j	80003908 <pipeclose+0x24>
    release(&pi->lock);
    80003934:	8526                	mv	a0,s1
    80003936:	172020ef          	jal	80005aa8 <release>
}
    8000393a:	b7c5                	j	8000391a <pipeclose+0x36>

000000008000393c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000393c:	711d                	addi	sp,sp,-96
    8000393e:	ec86                	sd	ra,88(sp)
    80003940:	e8a2                	sd	s0,80(sp)
    80003942:	e4a6                	sd	s1,72(sp)
    80003944:	e0ca                	sd	s2,64(sp)
    80003946:	fc4e                	sd	s3,56(sp)
    80003948:	f852                	sd	s4,48(sp)
    8000394a:	f456                	sd	s5,40(sp)
    8000394c:	1080                	addi	s0,sp,96
    8000394e:	84aa                	mv	s1,a0
    80003950:	8aae                	mv	s5,a1
    80003952:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003954:	d16fd0ef          	jal	80000e6a <myproc>
    80003958:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000395a:	8526                	mv	a0,s1
    8000395c:	0b4020ef          	jal	80005a10 <acquire>
  while(i < n){
    80003960:	0b405a63          	blez	s4,80003a14 <pipewrite+0xd8>
    80003964:	f05a                	sd	s6,32(sp)
    80003966:	ec5e                	sd	s7,24(sp)
    80003968:	e862                	sd	s8,16(sp)
  int i = 0;
    8000396a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000396c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000396e:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003972:	21c48b93          	addi	s7,s1,540
    80003976:	a81d                	j	800039ac <pipewrite+0x70>
      release(&pi->lock);
    80003978:	8526                	mv	a0,s1
    8000397a:	12e020ef          	jal	80005aa8 <release>
      return -1;
    8000397e:	597d                	li	s2,-1
    80003980:	7b02                	ld	s6,32(sp)
    80003982:	6be2                	ld	s7,24(sp)
    80003984:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003986:	854a                	mv	a0,s2
    80003988:	60e6                	ld	ra,88(sp)
    8000398a:	6446                	ld	s0,80(sp)
    8000398c:	64a6                	ld	s1,72(sp)
    8000398e:	6906                	ld	s2,64(sp)
    80003990:	79e2                	ld	s3,56(sp)
    80003992:	7a42                	ld	s4,48(sp)
    80003994:	7aa2                	ld	s5,40(sp)
    80003996:	6125                	addi	sp,sp,96
    80003998:	8082                	ret
      wakeup(&pi->nread);
    8000399a:	8562                	mv	a0,s8
    8000399c:	ae9fd0ef          	jal	80001484 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800039a0:	85a6                	mv	a1,s1
    800039a2:	855e                	mv	a0,s7
    800039a4:	a95fd0ef          	jal	80001438 <sleep>
  while(i < n){
    800039a8:	05495b63          	bge	s2,s4,800039fe <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    800039ac:	2204a783          	lw	a5,544(s1)
    800039b0:	d7e1                	beqz	a5,80003978 <pipewrite+0x3c>
    800039b2:	854e                	mv	a0,s3
    800039b4:	cbdfd0ef          	jal	80001670 <killed>
    800039b8:	f161                	bnez	a0,80003978 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800039ba:	2184a783          	lw	a5,536(s1)
    800039be:	21c4a703          	lw	a4,540(s1)
    800039c2:	2007879b          	addiw	a5,a5,512
    800039c6:	fcf70ae3          	beq	a4,a5,8000399a <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800039ca:	4685                	li	a3,1
    800039cc:	01590633          	add	a2,s2,s5
    800039d0:	faf40593          	addi	a1,s0,-81
    800039d4:	0509b503          	ld	a0,80(s3)
    800039d8:	8f2fd0ef          	jal	80000aca <copyin>
    800039dc:	03650e63          	beq	a0,s6,80003a18 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800039e0:	21c4a783          	lw	a5,540(s1)
    800039e4:	0017871b          	addiw	a4,a5,1
    800039e8:	20e4ae23          	sw	a4,540(s1)
    800039ec:	1ff7f793          	andi	a5,a5,511
    800039f0:	97a6                	add	a5,a5,s1
    800039f2:	faf44703          	lbu	a4,-81(s0)
    800039f6:	00e78c23          	sb	a4,24(a5)
      i++;
    800039fa:	2905                	addiw	s2,s2,1
    800039fc:	b775                	j	800039a8 <pipewrite+0x6c>
    800039fe:	7b02                	ld	s6,32(sp)
    80003a00:	6be2                	ld	s7,24(sp)
    80003a02:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80003a04:	21848513          	addi	a0,s1,536
    80003a08:	a7dfd0ef          	jal	80001484 <wakeup>
  release(&pi->lock);
    80003a0c:	8526                	mv	a0,s1
    80003a0e:	09a020ef          	jal	80005aa8 <release>
  return i;
    80003a12:	bf95                	j	80003986 <pipewrite+0x4a>
  int i = 0;
    80003a14:	4901                	li	s2,0
    80003a16:	b7fd                	j	80003a04 <pipewrite+0xc8>
    80003a18:	7b02                	ld	s6,32(sp)
    80003a1a:	6be2                	ld	s7,24(sp)
    80003a1c:	6c42                	ld	s8,16(sp)
    80003a1e:	b7dd                	j	80003a04 <pipewrite+0xc8>

0000000080003a20 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003a20:	715d                	addi	sp,sp,-80
    80003a22:	e486                	sd	ra,72(sp)
    80003a24:	e0a2                	sd	s0,64(sp)
    80003a26:	fc26                	sd	s1,56(sp)
    80003a28:	f84a                	sd	s2,48(sp)
    80003a2a:	f44e                	sd	s3,40(sp)
    80003a2c:	f052                	sd	s4,32(sp)
    80003a2e:	ec56                	sd	s5,24(sp)
    80003a30:	0880                	addi	s0,sp,80
    80003a32:	84aa                	mv	s1,a0
    80003a34:	892e                	mv	s2,a1
    80003a36:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003a38:	c32fd0ef          	jal	80000e6a <myproc>
    80003a3c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003a3e:	8526                	mv	a0,s1
    80003a40:	7d1010ef          	jal	80005a10 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003a44:	2184a703          	lw	a4,536(s1)
    80003a48:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003a4c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003a50:	02f71563          	bne	a4,a5,80003a7a <piperead+0x5a>
    80003a54:	2244a783          	lw	a5,548(s1)
    80003a58:	cb85                	beqz	a5,80003a88 <piperead+0x68>
    if(killed(pr)){
    80003a5a:	8552                	mv	a0,s4
    80003a5c:	c15fd0ef          	jal	80001670 <killed>
    80003a60:	ed19                	bnez	a0,80003a7e <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003a62:	85a6                	mv	a1,s1
    80003a64:	854e                	mv	a0,s3
    80003a66:	9d3fd0ef          	jal	80001438 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003a6a:	2184a703          	lw	a4,536(s1)
    80003a6e:	21c4a783          	lw	a5,540(s1)
    80003a72:	fef701e3          	beq	a4,a5,80003a54 <piperead+0x34>
    80003a76:	e85a                	sd	s6,16(sp)
    80003a78:	a809                	j	80003a8a <piperead+0x6a>
    80003a7a:	e85a                	sd	s6,16(sp)
    80003a7c:	a039                	j	80003a8a <piperead+0x6a>
      release(&pi->lock);
    80003a7e:	8526                	mv	a0,s1
    80003a80:	028020ef          	jal	80005aa8 <release>
      return -1;
    80003a84:	59fd                	li	s3,-1
    80003a86:	a8b1                	j	80003ae2 <piperead+0xc2>
    80003a88:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a8a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003a8c:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a8e:	05505263          	blez	s5,80003ad2 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80003a92:	2184a783          	lw	a5,536(s1)
    80003a96:	21c4a703          	lw	a4,540(s1)
    80003a9a:	02f70c63          	beq	a4,a5,80003ad2 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003a9e:	0017871b          	addiw	a4,a5,1
    80003aa2:	20e4ac23          	sw	a4,536(s1)
    80003aa6:	1ff7f793          	andi	a5,a5,511
    80003aaa:	97a6                	add	a5,a5,s1
    80003aac:	0187c783          	lbu	a5,24(a5)
    80003ab0:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003ab4:	4685                	li	a3,1
    80003ab6:	fbf40613          	addi	a2,s0,-65
    80003aba:	85ca                	mv	a1,s2
    80003abc:	050a3503          	ld	a0,80(s4)
    80003ac0:	f33fc0ef          	jal	800009f2 <copyout>
    80003ac4:	01650763          	beq	a0,s6,80003ad2 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003ac8:	2985                	addiw	s3,s3,1
    80003aca:	0905                	addi	s2,s2,1
    80003acc:	fd3a93e3          	bne	s5,s3,80003a92 <piperead+0x72>
    80003ad0:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003ad2:	21c48513          	addi	a0,s1,540
    80003ad6:	9affd0ef          	jal	80001484 <wakeup>
  release(&pi->lock);
    80003ada:	8526                	mv	a0,s1
    80003adc:	7cd010ef          	jal	80005aa8 <release>
    80003ae0:	6b42                	ld	s6,16(sp)
  return i;
}
    80003ae2:	854e                	mv	a0,s3
    80003ae4:	60a6                	ld	ra,72(sp)
    80003ae6:	6406                	ld	s0,64(sp)
    80003ae8:	74e2                	ld	s1,56(sp)
    80003aea:	7942                	ld	s2,48(sp)
    80003aec:	79a2                	ld	s3,40(sp)
    80003aee:	7a02                	ld	s4,32(sp)
    80003af0:	6ae2                	ld	s5,24(sp)
    80003af2:	6161                	addi	sp,sp,80
    80003af4:	8082                	ret

0000000080003af6 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003af6:	1141                	addi	sp,sp,-16
    80003af8:	e422                	sd	s0,8(sp)
    80003afa:	0800                	addi	s0,sp,16
    80003afc:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003afe:	8905                	andi	a0,a0,1
    80003b00:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80003b02:	8b89                	andi	a5,a5,2
    80003b04:	c399                	beqz	a5,80003b0a <flags2perm+0x14>
      perm |= PTE_W;
    80003b06:	00456513          	ori	a0,a0,4
    return perm;
}
    80003b0a:	6422                	ld	s0,8(sp)
    80003b0c:	0141                	addi	sp,sp,16
    80003b0e:	8082                	ret

0000000080003b10 <exec>:

int
exec(char *path, char **argv)
{
    80003b10:	cf010113          	addi	sp,sp,-784
    80003b14:	30113423          	sd	ra,776(sp)
    80003b18:	30813023          	sd	s0,768(sp)
    80003b1c:	2e913c23          	sd	s1,760(sp)
    80003b20:	2f213823          	sd	s2,752(sp)
    80003b24:	2f313423          	sd	s3,744(sp)
    80003b28:	0e00                	addi	s0,sp,784
    80003b2a:	89aa                	mv	s3,a0
    80003b2c:	d0a43023          	sd	a0,-768(s0)
    80003b30:	892e                	mv	s2,a1
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003b32:	b38fd0ef          	jal	80000e6a <myproc>
    80003b36:	84aa                	mv	s1,a0

  begin_op();
    80003b38:	dc0ff0ef          	jal	800030f8 <begin_op>

  if((ip = namei(path)) == 0){
    80003b3c:	854e                	mv	a0,s3
    80003b3e:	bfeff0ef          	jal	80002f3c <namei>
    80003b42:	c125                	beqz	a0,80003ba2 <exec+0x92>
    80003b44:	2f413023          	sd	s4,736(sp)
    80003b48:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003b4a:	d19fe0ef          	jal	80002862 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003b4e:	04000713          	li	a4,64
    80003b52:	4681                	li	a3,0
    80003b54:	e5040613          	addi	a2,s0,-432
    80003b58:	4581                	li	a1,0
    80003b5a:	8552                	mv	a0,s4
    80003b5c:	f5bfe0ef          	jal	80002ab6 <readi>
    80003b60:	04000793          	li	a5,64
    80003b64:	00f51a63          	bne	a0,a5,80003b78 <exec+0x68>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003b68:	e5042703          	lw	a4,-432(s0)
    80003b6c:	464c47b7          	lui	a5,0x464c4
    80003b70:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003b74:	02f70b63          	beq	a4,a5,80003baa <exec+0x9a>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003b78:	8552                	mv	a0,s4
    80003b7a:	ef3fe0ef          	jal	80002a6c <iunlockput>
    end_op();
    80003b7e:	de4ff0ef          	jal	80003162 <end_op>
  }
  return -1;
    80003b82:	557d                	li	a0,-1
    80003b84:	2e013a03          	ld	s4,736(sp)
}
    80003b88:	30813083          	ld	ra,776(sp)
    80003b8c:	30013403          	ld	s0,768(sp)
    80003b90:	2f813483          	ld	s1,760(sp)
    80003b94:	2f013903          	ld	s2,752(sp)
    80003b98:	2e813983          	ld	s3,744(sp)
    80003b9c:	31010113          	addi	sp,sp,784
    80003ba0:	8082                	ret
    end_op();
    80003ba2:	dc0ff0ef          	jal	80003162 <end_op>
    return -1;
    80003ba6:	557d                	li	a0,-1
    80003ba8:	b7c5                	j	80003b88 <exec+0x78>
    80003baa:	2d613823          	sd	s6,720(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003bae:	8526                	mv	a0,s1
    80003bb0:	b62fd0ef          	jal	80000f12 <proc_pagetable>
    80003bb4:	8b2a                	mv	s6,a0
    80003bb6:	38050863          	beqz	a0,80003f46 <exec+0x436>
    80003bba:	2d513c23          	sd	s5,728(sp)
    80003bbe:	2d713423          	sd	s7,712(sp)
    80003bc2:	2d813023          	sd	s8,704(sp)
    80003bc6:	2b913c23          	sd	s9,696(sp)
    80003bca:	2ba13823          	sd	s10,688(sp)
  for (int i = 0; argv[i] != 0; i++) {
    80003bce:	00093503          	ld	a0,0(s2)
    80003bd2:	c125                	beqz	a0,80003c32 <exec+0x122>
    80003bd4:	00890593          	addi	a1,s2,8
  int new_argc = 0;
    80003bd8:	4801                	li	a6,0
  int print_pagetable = 0;
    80003bda:	ce043823          	sd	zero,-784(s0)
      while (arg[j] == opt[j] && arg[j] != '\0' && opt[j] != '\0') {
    80003bde:	02d00893          	li	a7,45
          print_pagetable = 1;
    80003be2:	4305                	li	t1,1
    80003be4:	a015                	j	80003c08 <exec+0xf8>
      if (arg[j] == '\0' && opt[j] == '\0') { 
    80003be6:	8fd1                	or	a5,a5,a2
    80003be8:	e781                	bnez	a5,80003bf0 <exec+0xe0>
          print_pagetable = 1;
    80003bea:	ce643823          	sd	t1,-784(s0)
    80003bee:	a809                	j	80003c00 <exec+0xf0>
          new_argv[new_argc++] = argv[i];
    80003bf0:	00381793          	slli	a5,a6,0x3
    80003bf4:	f9078793          	addi	a5,a5,-112
    80003bf8:	97a2                	add	a5,a5,s0
    80003bfa:	d8a7b423          	sd	a0,-632(a5)
    80003bfe:	2805                	addiw	a6,a6,1
  for (int i = 0; argv[i] != 0; i++) {
    80003c00:	05a1                	addi	a1,a1,8
    80003c02:	ff85b503          	ld	a0,-8(a1)
    80003c06:	c90d                	beqz	a0,80003c38 <exec+0x128>
      while (arg[j] == opt[j] && arg[j] != '\0' && opt[j] != '\0') {
    80003c08:	00054783          	lbu	a5,0(a0)
    80003c0c:	ff1792e3          	bne	a5,a7,80003bf0 <exec+0xe0>
    80003c10:	00150693          	addi	a3,a0,1
    80003c14:	00004717          	auipc	a4,0x4
    80003c18:	9cd70713          	addi	a4,a4,-1587 # 800075e1 <etext+0x5e1>
    80003c1c:	0006c603          	lbu	a2,0(a3)
    80003c20:	00074783          	lbu	a5,0(a4)
    80003c24:	0685                	addi	a3,a3,1
    80003c26:	0705                	addi	a4,a4,1
    80003c28:	faf61fe3          	bne	a2,a5,80003be6 <exec+0xd6>
    80003c2c:	de4d                	beqz	a2,80003be6 <exec+0xd6>
    80003c2e:	f7fd                	bnez	a5,80003c1c <exec+0x10c>
    80003c30:	b7c1                	j	80003bf0 <exec+0xe0>
  int new_argc = 0;
    80003c32:	4801                	li	a6,0
  int print_pagetable = 0;
    80003c34:	ce043823          	sd	zero,-784(s0)
  new_argv[new_argc] = 0; 
    80003c38:	00381793          	slli	a5,a6,0x3
    80003c3c:	f9078793          	addi	a5,a5,-112
    80003c40:	97a2                	add	a5,a5,s0
    80003c42:	d807b423          	sd	zero,-632(a5)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003c46:	e7042d03          	lw	s10,-400(s0)
    80003c4a:	e8845783          	lhu	a5,-376(s0)
    80003c4e:	12078b63          	beqz	a5,80003d84 <exec+0x274>
    80003c52:	2bb13423          	sd	s11,680(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003c56:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003c58:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80003c5a:	6c85                	lui	s9,0x1
    80003c5c:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003c60:	cef43c23          	sd	a5,-776(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003c64:	6a85                	lui	s5,0x1
    80003c66:	a085                	j	80003cc6 <exec+0x1b6>
      panic("loadseg: address should exist");
    80003c68:	00004517          	auipc	a0,0x4
    80003c6c:	99050513          	addi	a0,a0,-1648 # 800075f8 <etext+0x5f8>
    80003c70:	273010ef          	jal	800056e2 <panic>
    if(sz - i < PGSIZE)
    80003c74:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003c76:	8726                	mv	a4,s1
    80003c78:	012c06bb          	addw	a3,s8,s2
    80003c7c:	4581                	li	a1,0
    80003c7e:	8552                	mv	a0,s4
    80003c80:	e37fe0ef          	jal	80002ab6 <readi>
    80003c84:	2501                	sext.w	a0,a0
    80003c86:	26a49a63          	bne	s1,a0,80003efa <exec+0x3ea>
  for(i = 0; i < sz; i += PGSIZE){
    80003c8a:	012a893b          	addw	s2,s5,s2
    80003c8e:	03397363          	bgeu	s2,s3,80003cb4 <exec+0x1a4>
    pa = walkaddr(pagetable, va + i);
    80003c92:	02091593          	slli	a1,s2,0x20
    80003c96:	9181                	srli	a1,a1,0x20
    80003c98:	95de                	add	a1,a1,s7
    80003c9a:	855a                	mv	a0,s6
    80003c9c:	fcafc0ef          	jal	80000466 <walkaddr>
    80003ca0:	862a                	mv	a2,a0
    if(pa == 0)
    80003ca2:	d179                	beqz	a0,80003c68 <exec+0x158>
    if(sz - i < PGSIZE)
    80003ca4:	412984bb          	subw	s1,s3,s2
    80003ca8:	0004879b          	sext.w	a5,s1
    80003cac:	fcfcf4e3          	bgeu	s9,a5,80003c74 <exec+0x164>
    80003cb0:	84d6                	mv	s1,s5
    80003cb2:	b7c9                	j	80003c74 <exec+0x164>
    sz = sz1;
    80003cb4:	d0843483          	ld	s1,-760(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003cb8:	2d85                	addiw	s11,s11,1
    80003cba:	038d0d1b          	addiw	s10,s10,56
    80003cbe:	e8845783          	lhu	a5,-376(s0)
    80003cc2:	08fdd063          	bge	s11,a5,80003d42 <exec+0x232>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003cc6:	2d01                	sext.w	s10,s10
    80003cc8:	03800713          	li	a4,56
    80003ccc:	86ea                	mv	a3,s10
    80003cce:	e1840613          	addi	a2,s0,-488
    80003cd2:	4581                	li	a1,0
    80003cd4:	8552                	mv	a0,s4
    80003cd6:	de1fe0ef          	jal	80002ab6 <readi>
    80003cda:	03800793          	li	a5,56
    80003cde:	1ef51163          	bne	a0,a5,80003ec0 <exec+0x3b0>
    if(ph.type != ELF_PROG_LOAD)
    80003ce2:	e1842783          	lw	a5,-488(s0)
    80003ce6:	4705                	li	a4,1
    80003ce8:	fce798e3          	bne	a5,a4,80003cb8 <exec+0x1a8>
    if(ph.memsz < ph.filesz)
    80003cec:	e4043903          	ld	s2,-448(s0)
    80003cf0:	e3843783          	ld	a5,-456(s0)
    80003cf4:	1cf96b63          	bltu	s2,a5,80003eca <exec+0x3ba>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003cf8:	e2843783          	ld	a5,-472(s0)
    80003cfc:	993e                	add	s2,s2,a5
    80003cfe:	1cf96b63          	bltu	s2,a5,80003ed4 <exec+0x3c4>
    if(ph.vaddr % PGSIZE != 0)
    80003d02:	cf843703          	ld	a4,-776(s0)
    80003d06:	8ff9                	and	a5,a5,a4
    80003d08:	1c079b63          	bnez	a5,80003ede <exec+0x3ce>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003d0c:	e1c42503          	lw	a0,-484(s0)
    80003d10:	de7ff0ef          	jal	80003af6 <flags2perm>
    80003d14:	86aa                	mv	a3,a0
    80003d16:	864a                	mv	a2,s2
    80003d18:	85a6                	mv	a1,s1
    80003d1a:	855a                	mv	a0,s6
    80003d1c:	ac3fc0ef          	jal	800007de <uvmalloc>
    80003d20:	d0a43423          	sd	a0,-760(s0)
    80003d24:	1c050263          	beqz	a0,80003ee8 <exec+0x3d8>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003d28:	e2843b83          	ld	s7,-472(s0)
    80003d2c:	e2042c03          	lw	s8,-480(s0)
    80003d30:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003d34:	00098463          	beqz	s3,80003d3c <exec+0x22c>
    80003d38:	4901                	li	s2,0
    80003d3a:	bfa1                	j	80003c92 <exec+0x182>
    sz = sz1;
    80003d3c:	d0843483          	ld	s1,-760(s0)
    80003d40:	bfa5                	j	80003cb8 <exec+0x1a8>
    80003d42:	2a813d83          	ld	s11,680(sp)
  iunlockput(ip);
    80003d46:	8552                	mv	a0,s4
    80003d48:	d25fe0ef          	jal	80002a6c <iunlockput>
  end_op();
    80003d4c:	c16ff0ef          	jal	80003162 <end_op>
  p = myproc();
    80003d50:	91afd0ef          	jal	80000e6a <myproc>
    80003d54:	8caa                	mv	s9,a0
  uint64 oldsz = p->sz;
    80003d56:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80003d5a:	6985                	lui	s3,0x1
    80003d5c:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003d5e:	99a6                	add	s3,s3,s1
    80003d60:	77fd                	lui	a5,0xfffff
    80003d62:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003d66:	4691                	li	a3,4
    80003d68:	6609                	lui	a2,0x2
    80003d6a:	964e                	add	a2,a2,s3
    80003d6c:	85ce                	mv	a1,s3
    80003d6e:	855a                	mv	a0,s6
    80003d70:	a6ffc0ef          	jal	800007de <uvmalloc>
    80003d74:	892a                	mv	s2,a0
    80003d76:	d0a43423          	sd	a0,-760(s0)
    80003d7a:	e519                	bnez	a0,80003d88 <exec+0x278>
  if(pagetable)
    80003d7c:	d1343423          	sd	s3,-760(s0)
    80003d80:	4a01                	li	s4,0
    80003d82:	aab5                	j	80003efe <exec+0x3ee>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003d84:	4481                	li	s1,0
    80003d86:	b7c1                	j	80003d46 <exec+0x236>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003d88:	75f9                	lui	a1,0xffffe
    80003d8a:	95aa                	add	a1,a1,a0
    80003d8c:	855a                	mv	a0,s6
    80003d8e:	c3bfc0ef          	jal	800009c8 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003d92:	7bfd                	lui	s7,0xfffff
    80003d94:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80003d96:	d1843983          	ld	s3,-744(s0)
    80003d9a:	04098d63          	beqz	s3,80003df4 <exec+0x2e4>
    80003d9e:	e9040a93          	addi	s5,s0,-368
    80003da2:	d2040a13          	addi	s4,s0,-736
    80003da6:	4481                	li	s1,0
    if(argc >= MAXARG)
    80003da8:	02000c13          	li	s8,32
    sp -= strlen(argv[argc]) + 1;
    80003dac:	854e                	mv	a0,s3
    80003dae:	d10fc0ef          	jal	800002be <strlen>
    80003db2:	0015079b          	addiw	a5,a0,1
    80003db6:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003dba:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003dbe:	13796a63          	bltu	s2,s7,80003ef2 <exec+0x3e2>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003dc2:	854e                	mv	a0,s3
    80003dc4:	cfafc0ef          	jal	800002be <strlen>
    80003dc8:	0015069b          	addiw	a3,a0,1
    80003dcc:	864e                	mv	a2,s3
    80003dce:	85ca                	mv	a1,s2
    80003dd0:	855a                	mv	a0,s6
    80003dd2:	c21fc0ef          	jal	800009f2 <copyout>
    80003dd6:	12054063          	bltz	a0,80003ef6 <exec+0x3e6>
    ustack[argc] = sp;
    80003dda:	012ab023          	sd	s2,0(s5) # 1000 <_entry-0x7ffff000>
  for(argc = 0; argv[argc]; argc++) {
    80003dde:	0485                	addi	s1,s1,1
    80003de0:	000a3983          	ld	s3,0(s4)
    80003de4:	00098b63          	beqz	s3,80003dfa <exec+0x2ea>
    if(argc >= MAXARG)
    80003de8:	0aa1                	addi	s5,s5,8
    80003dea:	0a21                	addi	s4,s4,8
    80003dec:	fd8490e3          	bne	s1,s8,80003dac <exec+0x29c>
  ip = 0;
    80003df0:	4a01                	li	s4,0
    80003df2:	a231                	j	80003efe <exec+0x3ee>
  sp = sz;
    80003df4:	d0843903          	ld	s2,-760(s0)
  for(argc = 0; argv[argc]; argc++) {
    80003df8:	4481                	li	s1,0
  ustack[argc] = 0;
    80003dfa:	00349793          	slli	a5,s1,0x3
    80003dfe:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffde290>
    80003e02:	97a2                	add	a5,a5,s0
    80003e04:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003e08:	00148693          	addi	a3,s1,1
    80003e0c:	068e                	slli	a3,a3,0x3
    80003e0e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003e12:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003e16:	d0843983          	ld	s3,-760(s0)
  if(sp < stackbase)
    80003e1a:	f77961e3          	bltu	s2,s7,80003d7c <exec+0x26c>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003e1e:	e9040613          	addi	a2,s0,-368
    80003e22:	85ca                	mv	a1,s2
    80003e24:	855a                	mv	a0,s6
    80003e26:	bcdfc0ef          	jal	800009f2 <copyout>
    80003e2a:	12054163          	bltz	a0,80003f4c <exec+0x43c>
  p->trapframe->a1 = sp;
    80003e2e:	058cb783          	ld	a5,88(s9)
    80003e32:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003e36:	d0043783          	ld	a5,-768(s0)
    80003e3a:	0007c703          	lbu	a4,0(a5)
    80003e3e:	cf11                	beqz	a4,80003e5a <exec+0x34a>
    80003e40:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003e42:	02f00693          	li	a3,47
    80003e46:	a029                	j	80003e50 <exec+0x340>
  for(last=s=path; *s; s++)
    80003e48:	0785                	addi	a5,a5,1
    80003e4a:	fff7c703          	lbu	a4,-1(a5)
    80003e4e:	c711                	beqz	a4,80003e5a <exec+0x34a>
    if(*s == '/')
    80003e50:	fed71ce3          	bne	a4,a3,80003e48 <exec+0x338>
      last = s+1;
    80003e54:	d0f43023          	sd	a5,-768(s0)
    80003e58:	bfc5                	j	80003e48 <exec+0x338>
  safestrcpy(p->name, last, sizeof(p->name));
    80003e5a:	4641                	li	a2,16
    80003e5c:	d0043583          	ld	a1,-768(s0)
    80003e60:	158c8513          	addi	a0,s9,344
    80003e64:	c28fc0ef          	jal	8000028c <safestrcpy>
  oldpagetable = p->pagetable;
    80003e68:	050cb503          	ld	a0,80(s9)
  p->pagetable = pagetable;
    80003e6c:	056cb823          	sd	s6,80(s9)
  p->sz = sz;
    80003e70:	d0843783          	ld	a5,-760(s0)
    80003e74:	04fcb423          	sd	a5,72(s9)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003e78:	058cb783          	ld	a5,88(s9)
    80003e7c:	e6843703          	ld	a4,-408(s0)
    80003e80:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003e82:	058cb783          	ld	a5,88(s9)
    80003e86:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003e8a:	85ea                	mv	a1,s10
    80003e8c:	90afd0ef          	jal	80000f96 <proc_freepagetable>
  if (print_pagetable) {
    80003e90:	cf043783          	ld	a5,-784(s0)
    80003e94:	e395                	bnez	a5,80003eb8 <exec+0x3a8>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003e96:	0004851b          	sext.w	a0,s1
    80003e9a:	2e013a03          	ld	s4,736(sp)
    80003e9e:	2d813a83          	ld	s5,728(sp)
    80003ea2:	2d013b03          	ld	s6,720(sp)
    80003ea6:	2c813b83          	ld	s7,712(sp)
    80003eaa:	2c013c03          	ld	s8,704(sp)
    80003eae:	2b813c83          	ld	s9,696(sp)
    80003eb2:	2b013d03          	ld	s10,688(sp)
    80003eb6:	b9c9                	j	80003b88 <exec+0x78>
    vmprint(pagetable);
    80003eb8:	855a                	mv	a0,s6
    80003eba:	df9fc0ef          	jal	80000cb2 <vmprint>
    80003ebe:	bfe1                	j	80003e96 <exec+0x386>
    80003ec0:	d0943423          	sd	s1,-760(s0)
    80003ec4:	2a813d83          	ld	s11,680(sp)
    80003ec8:	a81d                	j	80003efe <exec+0x3ee>
    80003eca:	d0943423          	sd	s1,-760(s0)
    80003ece:	2a813d83          	ld	s11,680(sp)
    80003ed2:	a035                	j	80003efe <exec+0x3ee>
    80003ed4:	d0943423          	sd	s1,-760(s0)
    80003ed8:	2a813d83          	ld	s11,680(sp)
    80003edc:	a00d                	j	80003efe <exec+0x3ee>
    80003ede:	d0943423          	sd	s1,-760(s0)
    80003ee2:	2a813d83          	ld	s11,680(sp)
    80003ee6:	a821                	j	80003efe <exec+0x3ee>
    80003ee8:	d0943423          	sd	s1,-760(s0)
    80003eec:	2a813d83          	ld	s11,680(sp)
    80003ef0:	a039                	j	80003efe <exec+0x3ee>
  ip = 0;
    80003ef2:	4a01                	li	s4,0
    80003ef4:	a029                	j	80003efe <exec+0x3ee>
    80003ef6:	4a01                	li	s4,0
  if(pagetable)
    80003ef8:	a019                	j	80003efe <exec+0x3ee>
    80003efa:	2a813d83          	ld	s11,680(sp)
    proc_freepagetable(pagetable, sz);
    80003efe:	d0843583          	ld	a1,-760(s0)
    80003f02:	855a                	mv	a0,s6
    80003f04:	892fd0ef          	jal	80000f96 <proc_freepagetable>
  return -1;
    80003f08:	557d                	li	a0,-1
  if(ip){
    80003f0a:	020a1163          	bnez	s4,80003f2c <exec+0x41c>
    80003f0e:	2e013a03          	ld	s4,736(sp)
    80003f12:	2d813a83          	ld	s5,728(sp)
    80003f16:	2d013b03          	ld	s6,720(sp)
    80003f1a:	2c813b83          	ld	s7,712(sp)
    80003f1e:	2c013c03          	ld	s8,704(sp)
    80003f22:	2b813c83          	ld	s9,696(sp)
    80003f26:	2b013d03          	ld	s10,688(sp)
    80003f2a:	b9b9                	j	80003b88 <exec+0x78>
    80003f2c:	2d813a83          	ld	s5,728(sp)
    80003f30:	2d013b03          	ld	s6,720(sp)
    80003f34:	2c813b83          	ld	s7,712(sp)
    80003f38:	2c013c03          	ld	s8,704(sp)
    80003f3c:	2b813c83          	ld	s9,696(sp)
    80003f40:	2b013d03          	ld	s10,688(sp)
    80003f44:	b915                	j	80003b78 <exec+0x68>
    80003f46:	2d013b03          	ld	s6,720(sp)
    80003f4a:	b13d                	j	80003b78 <exec+0x68>
  sz = sz1;
    80003f4c:	d0843983          	ld	s3,-760(s0)
    80003f50:	b535                	j	80003d7c <exec+0x26c>

0000000080003f52 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003f52:	7179                	addi	sp,sp,-48
    80003f54:	f406                	sd	ra,40(sp)
    80003f56:	f022                	sd	s0,32(sp)
    80003f58:	ec26                	sd	s1,24(sp)
    80003f5a:	e84a                	sd	s2,16(sp)
    80003f5c:	1800                	addi	s0,sp,48
    80003f5e:	892e                	mv	s2,a1
    80003f60:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003f62:	fdc40593          	addi	a1,s0,-36
    80003f66:	db9fd0ef          	jal	80001d1e <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003f6a:	fdc42703          	lw	a4,-36(s0)
    80003f6e:	47bd                	li	a5,15
    80003f70:	02e7e963          	bltu	a5,a4,80003fa2 <argfd+0x50>
    80003f74:	ef7fc0ef          	jal	80000e6a <myproc>
    80003f78:	fdc42703          	lw	a4,-36(s0)
    80003f7c:	01a70793          	addi	a5,a4,26
    80003f80:	078e                	slli	a5,a5,0x3
    80003f82:	953e                	add	a0,a0,a5
    80003f84:	611c                	ld	a5,0(a0)
    80003f86:	c385                	beqz	a5,80003fa6 <argfd+0x54>
    return -1;
  if(pfd)
    80003f88:	00090463          	beqz	s2,80003f90 <argfd+0x3e>
    *pfd = fd;
    80003f8c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003f90:	4501                	li	a0,0
  if(pf)
    80003f92:	c091                	beqz	s1,80003f96 <argfd+0x44>
    *pf = f;
    80003f94:	e09c                	sd	a5,0(s1)
}
    80003f96:	70a2                	ld	ra,40(sp)
    80003f98:	7402                	ld	s0,32(sp)
    80003f9a:	64e2                	ld	s1,24(sp)
    80003f9c:	6942                	ld	s2,16(sp)
    80003f9e:	6145                	addi	sp,sp,48
    80003fa0:	8082                	ret
    return -1;
    80003fa2:	557d                	li	a0,-1
    80003fa4:	bfcd                	j	80003f96 <argfd+0x44>
    80003fa6:	557d                	li	a0,-1
    80003fa8:	b7fd                	j	80003f96 <argfd+0x44>

0000000080003faa <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003faa:	1101                	addi	sp,sp,-32
    80003fac:	ec06                	sd	ra,24(sp)
    80003fae:	e822                	sd	s0,16(sp)
    80003fb0:	e426                	sd	s1,8(sp)
    80003fb2:	1000                	addi	s0,sp,32
    80003fb4:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003fb6:	eb5fc0ef          	jal	80000e6a <myproc>
    80003fba:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003fbc:	0d050793          	addi	a5,a0,208
    80003fc0:	4501                	li	a0,0
    80003fc2:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003fc4:	6398                	ld	a4,0(a5)
    80003fc6:	cb19                	beqz	a4,80003fdc <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003fc8:	2505                	addiw	a0,a0,1
    80003fca:	07a1                	addi	a5,a5,8
    80003fcc:	fed51ce3          	bne	a0,a3,80003fc4 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003fd0:	557d                	li	a0,-1
}
    80003fd2:	60e2                	ld	ra,24(sp)
    80003fd4:	6442                	ld	s0,16(sp)
    80003fd6:	64a2                	ld	s1,8(sp)
    80003fd8:	6105                	addi	sp,sp,32
    80003fda:	8082                	ret
      p->ofile[fd] = f;
    80003fdc:	01a50793          	addi	a5,a0,26
    80003fe0:	078e                	slli	a5,a5,0x3
    80003fe2:	963e                	add	a2,a2,a5
    80003fe4:	e204                	sd	s1,0(a2)
      return fd;
    80003fe6:	b7f5                	j	80003fd2 <fdalloc+0x28>

0000000080003fe8 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003fe8:	715d                	addi	sp,sp,-80
    80003fea:	e486                	sd	ra,72(sp)
    80003fec:	e0a2                	sd	s0,64(sp)
    80003fee:	fc26                	sd	s1,56(sp)
    80003ff0:	f84a                	sd	s2,48(sp)
    80003ff2:	f44e                	sd	s3,40(sp)
    80003ff4:	ec56                	sd	s5,24(sp)
    80003ff6:	e85a                	sd	s6,16(sp)
    80003ff8:	0880                	addi	s0,sp,80
    80003ffa:	8b2e                	mv	s6,a1
    80003ffc:	89b2                	mv	s3,a2
    80003ffe:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004000:	fb040593          	addi	a1,s0,-80
    80004004:	f53fe0ef          	jal	80002f56 <nameiparent>
    80004008:	84aa                	mv	s1,a0
    8000400a:	10050a63          	beqz	a0,8000411e <create+0x136>
    return 0;

  ilock(dp);
    8000400e:	855fe0ef          	jal	80002862 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004012:	4601                	li	a2,0
    80004014:	fb040593          	addi	a1,s0,-80
    80004018:	8526                	mv	a0,s1
    8000401a:	cbdfe0ef          	jal	80002cd6 <dirlookup>
    8000401e:	8aaa                	mv	s5,a0
    80004020:	c129                	beqz	a0,80004062 <create+0x7a>
    iunlockput(dp);
    80004022:	8526                	mv	a0,s1
    80004024:	a49fe0ef          	jal	80002a6c <iunlockput>
    ilock(ip);
    80004028:	8556                	mv	a0,s5
    8000402a:	839fe0ef          	jal	80002862 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000402e:	4789                	li	a5,2
    80004030:	02fb1463          	bne	s6,a5,80004058 <create+0x70>
    80004034:	044ad783          	lhu	a5,68(s5)
    80004038:	37f9                	addiw	a5,a5,-2
    8000403a:	17c2                	slli	a5,a5,0x30
    8000403c:	93c1                	srli	a5,a5,0x30
    8000403e:	4705                	li	a4,1
    80004040:	00f76c63          	bltu	a4,a5,80004058 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004044:	8556                	mv	a0,s5
    80004046:	60a6                	ld	ra,72(sp)
    80004048:	6406                	ld	s0,64(sp)
    8000404a:	74e2                	ld	s1,56(sp)
    8000404c:	7942                	ld	s2,48(sp)
    8000404e:	79a2                	ld	s3,40(sp)
    80004050:	6ae2                	ld	s5,24(sp)
    80004052:	6b42                	ld	s6,16(sp)
    80004054:	6161                	addi	sp,sp,80
    80004056:	8082                	ret
    iunlockput(ip);
    80004058:	8556                	mv	a0,s5
    8000405a:	a13fe0ef          	jal	80002a6c <iunlockput>
    return 0;
    8000405e:	4a81                	li	s5,0
    80004060:	b7d5                	j	80004044 <create+0x5c>
    80004062:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004064:	85da                	mv	a1,s6
    80004066:	4088                	lw	a0,0(s1)
    80004068:	e8afe0ef          	jal	800026f2 <ialloc>
    8000406c:	8a2a                	mv	s4,a0
    8000406e:	cd15                	beqz	a0,800040aa <create+0xc2>
  ilock(ip);
    80004070:	ff2fe0ef          	jal	80002862 <ilock>
  ip->major = major;
    80004074:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004078:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000407c:	4905                	li	s2,1
    8000407e:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004082:	8552                	mv	a0,s4
    80004084:	f2afe0ef          	jal	800027ae <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004088:	032b0763          	beq	s6,s2,800040b6 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    8000408c:	004a2603          	lw	a2,4(s4)
    80004090:	fb040593          	addi	a1,s0,-80
    80004094:	8526                	mv	a0,s1
    80004096:	e0dfe0ef          	jal	80002ea2 <dirlink>
    8000409a:	06054563          	bltz	a0,80004104 <create+0x11c>
  iunlockput(dp);
    8000409e:	8526                	mv	a0,s1
    800040a0:	9cdfe0ef          	jal	80002a6c <iunlockput>
  return ip;
    800040a4:	8ad2                	mv	s5,s4
    800040a6:	7a02                	ld	s4,32(sp)
    800040a8:	bf71                	j	80004044 <create+0x5c>
    iunlockput(dp);
    800040aa:	8526                	mv	a0,s1
    800040ac:	9c1fe0ef          	jal	80002a6c <iunlockput>
    return 0;
    800040b0:	8ad2                	mv	s5,s4
    800040b2:	7a02                	ld	s4,32(sp)
    800040b4:	bf41                	j	80004044 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800040b6:	004a2603          	lw	a2,4(s4)
    800040ba:	00003597          	auipc	a1,0x3
    800040be:	55e58593          	addi	a1,a1,1374 # 80007618 <etext+0x618>
    800040c2:	8552                	mv	a0,s4
    800040c4:	ddffe0ef          	jal	80002ea2 <dirlink>
    800040c8:	02054e63          	bltz	a0,80004104 <create+0x11c>
    800040cc:	40d0                	lw	a2,4(s1)
    800040ce:	00003597          	auipc	a1,0x3
    800040d2:	55258593          	addi	a1,a1,1362 # 80007620 <etext+0x620>
    800040d6:	8552                	mv	a0,s4
    800040d8:	dcbfe0ef          	jal	80002ea2 <dirlink>
    800040dc:	02054463          	bltz	a0,80004104 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    800040e0:	004a2603          	lw	a2,4(s4)
    800040e4:	fb040593          	addi	a1,s0,-80
    800040e8:	8526                	mv	a0,s1
    800040ea:	db9fe0ef          	jal	80002ea2 <dirlink>
    800040ee:	00054b63          	bltz	a0,80004104 <create+0x11c>
    dp->nlink++;  // for ".."
    800040f2:	04a4d783          	lhu	a5,74(s1)
    800040f6:	2785                	addiw	a5,a5,1
    800040f8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800040fc:	8526                	mv	a0,s1
    800040fe:	eb0fe0ef          	jal	800027ae <iupdate>
    80004102:	bf71                	j	8000409e <create+0xb6>
  ip->nlink = 0;
    80004104:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004108:	8552                	mv	a0,s4
    8000410a:	ea4fe0ef          	jal	800027ae <iupdate>
  iunlockput(ip);
    8000410e:	8552                	mv	a0,s4
    80004110:	95dfe0ef          	jal	80002a6c <iunlockput>
  iunlockput(dp);
    80004114:	8526                	mv	a0,s1
    80004116:	957fe0ef          	jal	80002a6c <iunlockput>
  return 0;
    8000411a:	7a02                	ld	s4,32(sp)
    8000411c:	b725                	j	80004044 <create+0x5c>
    return 0;
    8000411e:	8aaa                	mv	s5,a0
    80004120:	b715                	j	80004044 <create+0x5c>

0000000080004122 <sys_dup>:
{
    80004122:	7179                	addi	sp,sp,-48
    80004124:	f406                	sd	ra,40(sp)
    80004126:	f022                	sd	s0,32(sp)
    80004128:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000412a:	fd840613          	addi	a2,s0,-40
    8000412e:	4581                	li	a1,0
    80004130:	4501                	li	a0,0
    80004132:	e21ff0ef          	jal	80003f52 <argfd>
    return -1;
    80004136:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004138:	02054363          	bltz	a0,8000415e <sys_dup+0x3c>
    8000413c:	ec26                	sd	s1,24(sp)
    8000413e:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004140:	fd843903          	ld	s2,-40(s0)
    80004144:	854a                	mv	a0,s2
    80004146:	e65ff0ef          	jal	80003faa <fdalloc>
    8000414a:	84aa                	mv	s1,a0
    return -1;
    8000414c:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000414e:	00054d63          	bltz	a0,80004168 <sys_dup+0x46>
  filedup(f);
    80004152:	854a                	mv	a0,s2
    80004154:	b78ff0ef          	jal	800034cc <filedup>
  return fd;
    80004158:	87a6                	mv	a5,s1
    8000415a:	64e2                	ld	s1,24(sp)
    8000415c:	6942                	ld	s2,16(sp)
}
    8000415e:	853e                	mv	a0,a5
    80004160:	70a2                	ld	ra,40(sp)
    80004162:	7402                	ld	s0,32(sp)
    80004164:	6145                	addi	sp,sp,48
    80004166:	8082                	ret
    80004168:	64e2                	ld	s1,24(sp)
    8000416a:	6942                	ld	s2,16(sp)
    8000416c:	bfcd                	j	8000415e <sys_dup+0x3c>

000000008000416e <sys_read>:
{
    8000416e:	7179                	addi	sp,sp,-48
    80004170:	f406                	sd	ra,40(sp)
    80004172:	f022                	sd	s0,32(sp)
    80004174:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004176:	fd840593          	addi	a1,s0,-40
    8000417a:	4505                	li	a0,1
    8000417c:	bbffd0ef          	jal	80001d3a <argaddr>
  argint(2, &n);
    80004180:	fe440593          	addi	a1,s0,-28
    80004184:	4509                	li	a0,2
    80004186:	b99fd0ef          	jal	80001d1e <argint>
  if(argfd(0, 0, &f) < 0)
    8000418a:	fe840613          	addi	a2,s0,-24
    8000418e:	4581                	li	a1,0
    80004190:	4501                	li	a0,0
    80004192:	dc1ff0ef          	jal	80003f52 <argfd>
    80004196:	87aa                	mv	a5,a0
    return -1;
    80004198:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000419a:	0007ca63          	bltz	a5,800041ae <sys_read+0x40>
  return fileread(f, p, n);
    8000419e:	fe442603          	lw	a2,-28(s0)
    800041a2:	fd843583          	ld	a1,-40(s0)
    800041a6:	fe843503          	ld	a0,-24(s0)
    800041aa:	c88ff0ef          	jal	80003632 <fileread>
}
    800041ae:	70a2                	ld	ra,40(sp)
    800041b0:	7402                	ld	s0,32(sp)
    800041b2:	6145                	addi	sp,sp,48
    800041b4:	8082                	ret

00000000800041b6 <sys_write>:
{
    800041b6:	7179                	addi	sp,sp,-48
    800041b8:	f406                	sd	ra,40(sp)
    800041ba:	f022                	sd	s0,32(sp)
    800041bc:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800041be:	fd840593          	addi	a1,s0,-40
    800041c2:	4505                	li	a0,1
    800041c4:	b77fd0ef          	jal	80001d3a <argaddr>
  argint(2, &n);
    800041c8:	fe440593          	addi	a1,s0,-28
    800041cc:	4509                	li	a0,2
    800041ce:	b51fd0ef          	jal	80001d1e <argint>
  if(argfd(0, 0, &f) < 0)
    800041d2:	fe840613          	addi	a2,s0,-24
    800041d6:	4581                	li	a1,0
    800041d8:	4501                	li	a0,0
    800041da:	d79ff0ef          	jal	80003f52 <argfd>
    800041de:	87aa                	mv	a5,a0
    return -1;
    800041e0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800041e2:	0007ca63          	bltz	a5,800041f6 <sys_write+0x40>
  return filewrite(f, p, n);
    800041e6:	fe442603          	lw	a2,-28(s0)
    800041ea:	fd843583          	ld	a1,-40(s0)
    800041ee:	fe843503          	ld	a0,-24(s0)
    800041f2:	cfeff0ef          	jal	800036f0 <filewrite>
}
    800041f6:	70a2                	ld	ra,40(sp)
    800041f8:	7402                	ld	s0,32(sp)
    800041fa:	6145                	addi	sp,sp,48
    800041fc:	8082                	ret

00000000800041fe <sys_close>:
{
    800041fe:	1101                	addi	sp,sp,-32
    80004200:	ec06                	sd	ra,24(sp)
    80004202:	e822                	sd	s0,16(sp)
    80004204:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004206:	fe040613          	addi	a2,s0,-32
    8000420a:	fec40593          	addi	a1,s0,-20
    8000420e:	4501                	li	a0,0
    80004210:	d43ff0ef          	jal	80003f52 <argfd>
    return -1;
    80004214:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004216:	02054063          	bltz	a0,80004236 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    8000421a:	c51fc0ef          	jal	80000e6a <myproc>
    8000421e:	fec42783          	lw	a5,-20(s0)
    80004222:	07e9                	addi	a5,a5,26
    80004224:	078e                	slli	a5,a5,0x3
    80004226:	953e                	add	a0,a0,a5
    80004228:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000422c:	fe043503          	ld	a0,-32(s0)
    80004230:	ae2ff0ef          	jal	80003512 <fileclose>
  return 0;
    80004234:	4781                	li	a5,0
}
    80004236:	853e                	mv	a0,a5
    80004238:	60e2                	ld	ra,24(sp)
    8000423a:	6442                	ld	s0,16(sp)
    8000423c:	6105                	addi	sp,sp,32
    8000423e:	8082                	ret

0000000080004240 <sys_fstat>:
{
    80004240:	1101                	addi	sp,sp,-32
    80004242:	ec06                	sd	ra,24(sp)
    80004244:	e822                	sd	s0,16(sp)
    80004246:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004248:	fe040593          	addi	a1,s0,-32
    8000424c:	4505                	li	a0,1
    8000424e:	aedfd0ef          	jal	80001d3a <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004252:	fe840613          	addi	a2,s0,-24
    80004256:	4581                	li	a1,0
    80004258:	4501                	li	a0,0
    8000425a:	cf9ff0ef          	jal	80003f52 <argfd>
    8000425e:	87aa                	mv	a5,a0
    return -1;
    80004260:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004262:	0007c863          	bltz	a5,80004272 <sys_fstat+0x32>
  return filestat(f, st);
    80004266:	fe043583          	ld	a1,-32(s0)
    8000426a:	fe843503          	ld	a0,-24(s0)
    8000426e:	b66ff0ef          	jal	800035d4 <filestat>
}
    80004272:	60e2                	ld	ra,24(sp)
    80004274:	6442                	ld	s0,16(sp)
    80004276:	6105                	addi	sp,sp,32
    80004278:	8082                	ret

000000008000427a <sys_link>:
{
    8000427a:	7169                	addi	sp,sp,-304
    8000427c:	f606                	sd	ra,296(sp)
    8000427e:	f222                	sd	s0,288(sp)
    80004280:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004282:	08000613          	li	a2,128
    80004286:	ed040593          	addi	a1,s0,-304
    8000428a:	4501                	li	a0,0
    8000428c:	acbfd0ef          	jal	80001d56 <argstr>
    return -1;
    80004290:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004292:	0c054e63          	bltz	a0,8000436e <sys_link+0xf4>
    80004296:	08000613          	li	a2,128
    8000429a:	f5040593          	addi	a1,s0,-176
    8000429e:	4505                	li	a0,1
    800042a0:	ab7fd0ef          	jal	80001d56 <argstr>
    return -1;
    800042a4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800042a6:	0c054463          	bltz	a0,8000436e <sys_link+0xf4>
    800042aa:	ee26                	sd	s1,280(sp)
  begin_op();
    800042ac:	e4dfe0ef          	jal	800030f8 <begin_op>
  if((ip = namei(old)) == 0){
    800042b0:	ed040513          	addi	a0,s0,-304
    800042b4:	c89fe0ef          	jal	80002f3c <namei>
    800042b8:	84aa                	mv	s1,a0
    800042ba:	c53d                	beqz	a0,80004328 <sys_link+0xae>
  ilock(ip);
    800042bc:	da6fe0ef          	jal	80002862 <ilock>
  if(ip->type == T_DIR){
    800042c0:	04449703          	lh	a4,68(s1)
    800042c4:	4785                	li	a5,1
    800042c6:	06f70663          	beq	a4,a5,80004332 <sys_link+0xb8>
    800042ca:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800042cc:	04a4d783          	lhu	a5,74(s1)
    800042d0:	2785                	addiw	a5,a5,1
    800042d2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800042d6:	8526                	mv	a0,s1
    800042d8:	cd6fe0ef          	jal	800027ae <iupdate>
  iunlock(ip);
    800042dc:	8526                	mv	a0,s1
    800042de:	e32fe0ef          	jal	80002910 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800042e2:	fd040593          	addi	a1,s0,-48
    800042e6:	f5040513          	addi	a0,s0,-176
    800042ea:	c6dfe0ef          	jal	80002f56 <nameiparent>
    800042ee:	892a                	mv	s2,a0
    800042f0:	cd21                	beqz	a0,80004348 <sys_link+0xce>
  ilock(dp);
    800042f2:	d70fe0ef          	jal	80002862 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800042f6:	00092703          	lw	a4,0(s2)
    800042fa:	409c                	lw	a5,0(s1)
    800042fc:	04f71363          	bne	a4,a5,80004342 <sys_link+0xc8>
    80004300:	40d0                	lw	a2,4(s1)
    80004302:	fd040593          	addi	a1,s0,-48
    80004306:	854a                	mv	a0,s2
    80004308:	b9bfe0ef          	jal	80002ea2 <dirlink>
    8000430c:	02054b63          	bltz	a0,80004342 <sys_link+0xc8>
  iunlockput(dp);
    80004310:	854a                	mv	a0,s2
    80004312:	f5afe0ef          	jal	80002a6c <iunlockput>
  iput(ip);
    80004316:	8526                	mv	a0,s1
    80004318:	eccfe0ef          	jal	800029e4 <iput>
  end_op();
    8000431c:	e47fe0ef          	jal	80003162 <end_op>
  return 0;
    80004320:	4781                	li	a5,0
    80004322:	64f2                	ld	s1,280(sp)
    80004324:	6952                	ld	s2,272(sp)
    80004326:	a0a1                	j	8000436e <sys_link+0xf4>
    end_op();
    80004328:	e3bfe0ef          	jal	80003162 <end_op>
    return -1;
    8000432c:	57fd                	li	a5,-1
    8000432e:	64f2                	ld	s1,280(sp)
    80004330:	a83d                	j	8000436e <sys_link+0xf4>
    iunlockput(ip);
    80004332:	8526                	mv	a0,s1
    80004334:	f38fe0ef          	jal	80002a6c <iunlockput>
    end_op();
    80004338:	e2bfe0ef          	jal	80003162 <end_op>
    return -1;
    8000433c:	57fd                	li	a5,-1
    8000433e:	64f2                	ld	s1,280(sp)
    80004340:	a03d                	j	8000436e <sys_link+0xf4>
    iunlockput(dp);
    80004342:	854a                	mv	a0,s2
    80004344:	f28fe0ef          	jal	80002a6c <iunlockput>
  ilock(ip);
    80004348:	8526                	mv	a0,s1
    8000434a:	d18fe0ef          	jal	80002862 <ilock>
  ip->nlink--;
    8000434e:	04a4d783          	lhu	a5,74(s1)
    80004352:	37fd                	addiw	a5,a5,-1
    80004354:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004358:	8526                	mv	a0,s1
    8000435a:	c54fe0ef          	jal	800027ae <iupdate>
  iunlockput(ip);
    8000435e:	8526                	mv	a0,s1
    80004360:	f0cfe0ef          	jal	80002a6c <iunlockput>
  end_op();
    80004364:	dfffe0ef          	jal	80003162 <end_op>
  return -1;
    80004368:	57fd                	li	a5,-1
    8000436a:	64f2                	ld	s1,280(sp)
    8000436c:	6952                	ld	s2,272(sp)
}
    8000436e:	853e                	mv	a0,a5
    80004370:	70b2                	ld	ra,296(sp)
    80004372:	7412                	ld	s0,288(sp)
    80004374:	6155                	addi	sp,sp,304
    80004376:	8082                	ret

0000000080004378 <sys_unlink>:
{
    80004378:	7151                	addi	sp,sp,-240
    8000437a:	f586                	sd	ra,232(sp)
    8000437c:	f1a2                	sd	s0,224(sp)
    8000437e:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004380:	08000613          	li	a2,128
    80004384:	f3040593          	addi	a1,s0,-208
    80004388:	4501                	li	a0,0
    8000438a:	9cdfd0ef          	jal	80001d56 <argstr>
    8000438e:	16054063          	bltz	a0,800044ee <sys_unlink+0x176>
    80004392:	eda6                	sd	s1,216(sp)
  begin_op();
    80004394:	d65fe0ef          	jal	800030f8 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004398:	fb040593          	addi	a1,s0,-80
    8000439c:	f3040513          	addi	a0,s0,-208
    800043a0:	bb7fe0ef          	jal	80002f56 <nameiparent>
    800043a4:	84aa                	mv	s1,a0
    800043a6:	c945                	beqz	a0,80004456 <sys_unlink+0xde>
  ilock(dp);
    800043a8:	cbafe0ef          	jal	80002862 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800043ac:	00003597          	auipc	a1,0x3
    800043b0:	26c58593          	addi	a1,a1,620 # 80007618 <etext+0x618>
    800043b4:	fb040513          	addi	a0,s0,-80
    800043b8:	909fe0ef          	jal	80002cc0 <namecmp>
    800043bc:	10050e63          	beqz	a0,800044d8 <sys_unlink+0x160>
    800043c0:	00003597          	auipc	a1,0x3
    800043c4:	26058593          	addi	a1,a1,608 # 80007620 <etext+0x620>
    800043c8:	fb040513          	addi	a0,s0,-80
    800043cc:	8f5fe0ef          	jal	80002cc0 <namecmp>
    800043d0:	10050463          	beqz	a0,800044d8 <sys_unlink+0x160>
    800043d4:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800043d6:	f2c40613          	addi	a2,s0,-212
    800043da:	fb040593          	addi	a1,s0,-80
    800043de:	8526                	mv	a0,s1
    800043e0:	8f7fe0ef          	jal	80002cd6 <dirlookup>
    800043e4:	892a                	mv	s2,a0
    800043e6:	0e050863          	beqz	a0,800044d6 <sys_unlink+0x15e>
  ilock(ip);
    800043ea:	c78fe0ef          	jal	80002862 <ilock>
  if(ip->nlink < 1)
    800043ee:	04a91783          	lh	a5,74(s2)
    800043f2:	06f05763          	blez	a5,80004460 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800043f6:	04491703          	lh	a4,68(s2)
    800043fa:	4785                	li	a5,1
    800043fc:	06f70963          	beq	a4,a5,8000446e <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004400:	4641                	li	a2,16
    80004402:	4581                	li	a1,0
    80004404:	fc040513          	addi	a0,s0,-64
    80004408:	d47fb0ef          	jal	8000014e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000440c:	4741                	li	a4,16
    8000440e:	f2c42683          	lw	a3,-212(s0)
    80004412:	fc040613          	addi	a2,s0,-64
    80004416:	4581                	li	a1,0
    80004418:	8526                	mv	a0,s1
    8000441a:	f98fe0ef          	jal	80002bb2 <writei>
    8000441e:	47c1                	li	a5,16
    80004420:	08f51b63          	bne	a0,a5,800044b6 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80004424:	04491703          	lh	a4,68(s2)
    80004428:	4785                	li	a5,1
    8000442a:	08f70d63          	beq	a4,a5,800044c4 <sys_unlink+0x14c>
  iunlockput(dp);
    8000442e:	8526                	mv	a0,s1
    80004430:	e3cfe0ef          	jal	80002a6c <iunlockput>
  ip->nlink--;
    80004434:	04a95783          	lhu	a5,74(s2)
    80004438:	37fd                	addiw	a5,a5,-1
    8000443a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000443e:	854a                	mv	a0,s2
    80004440:	b6efe0ef          	jal	800027ae <iupdate>
  iunlockput(ip);
    80004444:	854a                	mv	a0,s2
    80004446:	e26fe0ef          	jal	80002a6c <iunlockput>
  end_op();
    8000444a:	d19fe0ef          	jal	80003162 <end_op>
  return 0;
    8000444e:	4501                	li	a0,0
    80004450:	64ee                	ld	s1,216(sp)
    80004452:	694e                	ld	s2,208(sp)
    80004454:	a849                	j	800044e6 <sys_unlink+0x16e>
    end_op();
    80004456:	d0dfe0ef          	jal	80003162 <end_op>
    return -1;
    8000445a:	557d                	li	a0,-1
    8000445c:	64ee                	ld	s1,216(sp)
    8000445e:	a061                	j	800044e6 <sys_unlink+0x16e>
    80004460:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004462:	00003517          	auipc	a0,0x3
    80004466:	1c650513          	addi	a0,a0,454 # 80007628 <etext+0x628>
    8000446a:	278010ef          	jal	800056e2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000446e:	04c92703          	lw	a4,76(s2)
    80004472:	02000793          	li	a5,32
    80004476:	f8e7f5e3          	bgeu	a5,a4,80004400 <sys_unlink+0x88>
    8000447a:	e5ce                	sd	s3,200(sp)
    8000447c:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004480:	4741                	li	a4,16
    80004482:	86ce                	mv	a3,s3
    80004484:	f1840613          	addi	a2,s0,-232
    80004488:	4581                	li	a1,0
    8000448a:	854a                	mv	a0,s2
    8000448c:	e2afe0ef          	jal	80002ab6 <readi>
    80004490:	47c1                	li	a5,16
    80004492:	00f51c63          	bne	a0,a5,800044aa <sys_unlink+0x132>
    if(de.inum != 0)
    80004496:	f1845783          	lhu	a5,-232(s0)
    8000449a:	efa1                	bnez	a5,800044f2 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000449c:	29c1                	addiw	s3,s3,16
    8000449e:	04c92783          	lw	a5,76(s2)
    800044a2:	fcf9efe3          	bltu	s3,a5,80004480 <sys_unlink+0x108>
    800044a6:	69ae                	ld	s3,200(sp)
    800044a8:	bfa1                	j	80004400 <sys_unlink+0x88>
      panic("isdirempty: readi");
    800044aa:	00003517          	auipc	a0,0x3
    800044ae:	19650513          	addi	a0,a0,406 # 80007640 <etext+0x640>
    800044b2:	230010ef          	jal	800056e2 <panic>
    800044b6:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    800044b8:	00003517          	auipc	a0,0x3
    800044bc:	1a050513          	addi	a0,a0,416 # 80007658 <etext+0x658>
    800044c0:	222010ef          	jal	800056e2 <panic>
    dp->nlink--;
    800044c4:	04a4d783          	lhu	a5,74(s1)
    800044c8:	37fd                	addiw	a5,a5,-1
    800044ca:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800044ce:	8526                	mv	a0,s1
    800044d0:	adefe0ef          	jal	800027ae <iupdate>
    800044d4:	bfa9                	j	8000442e <sys_unlink+0xb6>
    800044d6:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800044d8:	8526                	mv	a0,s1
    800044da:	d92fe0ef          	jal	80002a6c <iunlockput>
  end_op();
    800044de:	c85fe0ef          	jal	80003162 <end_op>
  return -1;
    800044e2:	557d                	li	a0,-1
    800044e4:	64ee                	ld	s1,216(sp)
}
    800044e6:	70ae                	ld	ra,232(sp)
    800044e8:	740e                	ld	s0,224(sp)
    800044ea:	616d                	addi	sp,sp,240
    800044ec:	8082                	ret
    return -1;
    800044ee:	557d                	li	a0,-1
    800044f0:	bfdd                	j	800044e6 <sys_unlink+0x16e>
    iunlockput(ip);
    800044f2:	854a                	mv	a0,s2
    800044f4:	d78fe0ef          	jal	80002a6c <iunlockput>
    goto bad;
    800044f8:	694e                	ld	s2,208(sp)
    800044fa:	69ae                	ld	s3,200(sp)
    800044fc:	bff1                	j	800044d8 <sys_unlink+0x160>

00000000800044fe <sys_open>:

uint64
sys_open(void)
{
    800044fe:	7131                	addi	sp,sp,-192
    80004500:	fd06                	sd	ra,184(sp)
    80004502:	f922                	sd	s0,176(sp)
    80004504:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004506:	f4c40593          	addi	a1,s0,-180
    8000450a:	4505                	li	a0,1
    8000450c:	813fd0ef          	jal	80001d1e <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004510:	08000613          	li	a2,128
    80004514:	f5040593          	addi	a1,s0,-176
    80004518:	4501                	li	a0,0
    8000451a:	83dfd0ef          	jal	80001d56 <argstr>
    8000451e:	87aa                	mv	a5,a0
    return -1;
    80004520:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004522:	0a07c263          	bltz	a5,800045c6 <sys_open+0xc8>
    80004526:	f526                	sd	s1,168(sp)

  begin_op();
    80004528:	bd1fe0ef          	jal	800030f8 <begin_op>

  if(omode & O_CREATE){
    8000452c:	f4c42783          	lw	a5,-180(s0)
    80004530:	2007f793          	andi	a5,a5,512
    80004534:	c3d5                	beqz	a5,800045d8 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004536:	4681                	li	a3,0
    80004538:	4601                	li	a2,0
    8000453a:	4589                	li	a1,2
    8000453c:	f5040513          	addi	a0,s0,-176
    80004540:	aa9ff0ef          	jal	80003fe8 <create>
    80004544:	84aa                	mv	s1,a0
    if(ip == 0){
    80004546:	c541                	beqz	a0,800045ce <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004548:	04449703          	lh	a4,68(s1)
    8000454c:	478d                	li	a5,3
    8000454e:	00f71763          	bne	a4,a5,8000455c <sys_open+0x5e>
    80004552:	0464d703          	lhu	a4,70(s1)
    80004556:	47a5                	li	a5,9
    80004558:	0ae7ed63          	bltu	a5,a4,80004612 <sys_open+0x114>
    8000455c:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000455e:	f11fe0ef          	jal	8000346e <filealloc>
    80004562:	892a                	mv	s2,a0
    80004564:	c179                	beqz	a0,8000462a <sys_open+0x12c>
    80004566:	ed4e                	sd	s3,152(sp)
    80004568:	a43ff0ef          	jal	80003faa <fdalloc>
    8000456c:	89aa                	mv	s3,a0
    8000456e:	0a054a63          	bltz	a0,80004622 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004572:	04449703          	lh	a4,68(s1)
    80004576:	478d                	li	a5,3
    80004578:	0cf70263          	beq	a4,a5,8000463c <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000457c:	4789                	li	a5,2
    8000457e:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004582:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004586:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    8000458a:	f4c42783          	lw	a5,-180(s0)
    8000458e:	0017c713          	xori	a4,a5,1
    80004592:	8b05                	andi	a4,a4,1
    80004594:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004598:	0037f713          	andi	a4,a5,3
    8000459c:	00e03733          	snez	a4,a4
    800045a0:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800045a4:	4007f793          	andi	a5,a5,1024
    800045a8:	c791                	beqz	a5,800045b4 <sys_open+0xb6>
    800045aa:	04449703          	lh	a4,68(s1)
    800045ae:	4789                	li	a5,2
    800045b0:	08f70d63          	beq	a4,a5,8000464a <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    800045b4:	8526                	mv	a0,s1
    800045b6:	b5afe0ef          	jal	80002910 <iunlock>
  end_op();
    800045ba:	ba9fe0ef          	jal	80003162 <end_op>

  return fd;
    800045be:	854e                	mv	a0,s3
    800045c0:	74aa                	ld	s1,168(sp)
    800045c2:	790a                	ld	s2,160(sp)
    800045c4:	69ea                	ld	s3,152(sp)
}
    800045c6:	70ea                	ld	ra,184(sp)
    800045c8:	744a                	ld	s0,176(sp)
    800045ca:	6129                	addi	sp,sp,192
    800045cc:	8082                	ret
      end_op();
    800045ce:	b95fe0ef          	jal	80003162 <end_op>
      return -1;
    800045d2:	557d                	li	a0,-1
    800045d4:	74aa                	ld	s1,168(sp)
    800045d6:	bfc5                	j	800045c6 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    800045d8:	f5040513          	addi	a0,s0,-176
    800045dc:	961fe0ef          	jal	80002f3c <namei>
    800045e0:	84aa                	mv	s1,a0
    800045e2:	c11d                	beqz	a0,80004608 <sys_open+0x10a>
    ilock(ip);
    800045e4:	a7efe0ef          	jal	80002862 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800045e8:	04449703          	lh	a4,68(s1)
    800045ec:	4785                	li	a5,1
    800045ee:	f4f71de3          	bne	a4,a5,80004548 <sys_open+0x4a>
    800045f2:	f4c42783          	lw	a5,-180(s0)
    800045f6:	d3bd                	beqz	a5,8000455c <sys_open+0x5e>
      iunlockput(ip);
    800045f8:	8526                	mv	a0,s1
    800045fa:	c72fe0ef          	jal	80002a6c <iunlockput>
      end_op();
    800045fe:	b65fe0ef          	jal	80003162 <end_op>
      return -1;
    80004602:	557d                	li	a0,-1
    80004604:	74aa                	ld	s1,168(sp)
    80004606:	b7c1                	j	800045c6 <sys_open+0xc8>
      end_op();
    80004608:	b5bfe0ef          	jal	80003162 <end_op>
      return -1;
    8000460c:	557d                	li	a0,-1
    8000460e:	74aa                	ld	s1,168(sp)
    80004610:	bf5d                	j	800045c6 <sys_open+0xc8>
    iunlockput(ip);
    80004612:	8526                	mv	a0,s1
    80004614:	c58fe0ef          	jal	80002a6c <iunlockput>
    end_op();
    80004618:	b4bfe0ef          	jal	80003162 <end_op>
    return -1;
    8000461c:	557d                	li	a0,-1
    8000461e:	74aa                	ld	s1,168(sp)
    80004620:	b75d                	j	800045c6 <sys_open+0xc8>
      fileclose(f);
    80004622:	854a                	mv	a0,s2
    80004624:	eeffe0ef          	jal	80003512 <fileclose>
    80004628:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    8000462a:	8526                	mv	a0,s1
    8000462c:	c40fe0ef          	jal	80002a6c <iunlockput>
    end_op();
    80004630:	b33fe0ef          	jal	80003162 <end_op>
    return -1;
    80004634:	557d                	li	a0,-1
    80004636:	74aa                	ld	s1,168(sp)
    80004638:	790a                	ld	s2,160(sp)
    8000463a:	b771                	j	800045c6 <sys_open+0xc8>
    f->type = FD_DEVICE;
    8000463c:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004640:	04649783          	lh	a5,70(s1)
    80004644:	02f91223          	sh	a5,36(s2)
    80004648:	bf3d                	j	80004586 <sys_open+0x88>
    itrunc(ip);
    8000464a:	8526                	mv	a0,s1
    8000464c:	b04fe0ef          	jal	80002950 <itrunc>
    80004650:	b795                	j	800045b4 <sys_open+0xb6>

0000000080004652 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004652:	7175                	addi	sp,sp,-144
    80004654:	e506                	sd	ra,136(sp)
    80004656:	e122                	sd	s0,128(sp)
    80004658:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000465a:	a9ffe0ef          	jal	800030f8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000465e:	08000613          	li	a2,128
    80004662:	f7040593          	addi	a1,s0,-144
    80004666:	4501                	li	a0,0
    80004668:	eeefd0ef          	jal	80001d56 <argstr>
    8000466c:	02054363          	bltz	a0,80004692 <sys_mkdir+0x40>
    80004670:	4681                	li	a3,0
    80004672:	4601                	li	a2,0
    80004674:	4585                	li	a1,1
    80004676:	f7040513          	addi	a0,s0,-144
    8000467a:	96fff0ef          	jal	80003fe8 <create>
    8000467e:	c911                	beqz	a0,80004692 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004680:	becfe0ef          	jal	80002a6c <iunlockput>
  end_op();
    80004684:	adffe0ef          	jal	80003162 <end_op>
  return 0;
    80004688:	4501                	li	a0,0
}
    8000468a:	60aa                	ld	ra,136(sp)
    8000468c:	640a                	ld	s0,128(sp)
    8000468e:	6149                	addi	sp,sp,144
    80004690:	8082                	ret
    end_op();
    80004692:	ad1fe0ef          	jal	80003162 <end_op>
    return -1;
    80004696:	557d                	li	a0,-1
    80004698:	bfcd                	j	8000468a <sys_mkdir+0x38>

000000008000469a <sys_mknod>:

uint64
sys_mknod(void)
{
    8000469a:	7135                	addi	sp,sp,-160
    8000469c:	ed06                	sd	ra,152(sp)
    8000469e:	e922                	sd	s0,144(sp)
    800046a0:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800046a2:	a57fe0ef          	jal	800030f8 <begin_op>
  argint(1, &major);
    800046a6:	f6c40593          	addi	a1,s0,-148
    800046aa:	4505                	li	a0,1
    800046ac:	e72fd0ef          	jal	80001d1e <argint>
  argint(2, &minor);
    800046b0:	f6840593          	addi	a1,s0,-152
    800046b4:	4509                	li	a0,2
    800046b6:	e68fd0ef          	jal	80001d1e <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800046ba:	08000613          	li	a2,128
    800046be:	f7040593          	addi	a1,s0,-144
    800046c2:	4501                	li	a0,0
    800046c4:	e92fd0ef          	jal	80001d56 <argstr>
    800046c8:	02054563          	bltz	a0,800046f2 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800046cc:	f6841683          	lh	a3,-152(s0)
    800046d0:	f6c41603          	lh	a2,-148(s0)
    800046d4:	458d                	li	a1,3
    800046d6:	f7040513          	addi	a0,s0,-144
    800046da:	90fff0ef          	jal	80003fe8 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800046de:	c911                	beqz	a0,800046f2 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800046e0:	b8cfe0ef          	jal	80002a6c <iunlockput>
  end_op();
    800046e4:	a7ffe0ef          	jal	80003162 <end_op>
  return 0;
    800046e8:	4501                	li	a0,0
}
    800046ea:	60ea                	ld	ra,152(sp)
    800046ec:	644a                	ld	s0,144(sp)
    800046ee:	610d                	addi	sp,sp,160
    800046f0:	8082                	ret
    end_op();
    800046f2:	a71fe0ef          	jal	80003162 <end_op>
    return -1;
    800046f6:	557d                	li	a0,-1
    800046f8:	bfcd                	j	800046ea <sys_mknod+0x50>

00000000800046fa <sys_chdir>:

uint64
sys_chdir(void)
{
    800046fa:	7135                	addi	sp,sp,-160
    800046fc:	ed06                	sd	ra,152(sp)
    800046fe:	e922                	sd	s0,144(sp)
    80004700:	e14a                	sd	s2,128(sp)
    80004702:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004704:	f66fc0ef          	jal	80000e6a <myproc>
    80004708:	892a                	mv	s2,a0
  
  begin_op();
    8000470a:	9effe0ef          	jal	800030f8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000470e:	08000613          	li	a2,128
    80004712:	f6040593          	addi	a1,s0,-160
    80004716:	4501                	li	a0,0
    80004718:	e3efd0ef          	jal	80001d56 <argstr>
    8000471c:	04054363          	bltz	a0,80004762 <sys_chdir+0x68>
    80004720:	e526                	sd	s1,136(sp)
    80004722:	f6040513          	addi	a0,s0,-160
    80004726:	817fe0ef          	jal	80002f3c <namei>
    8000472a:	84aa                	mv	s1,a0
    8000472c:	c915                	beqz	a0,80004760 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    8000472e:	934fe0ef          	jal	80002862 <ilock>
  if(ip->type != T_DIR){
    80004732:	04449703          	lh	a4,68(s1)
    80004736:	4785                	li	a5,1
    80004738:	02f71963          	bne	a4,a5,8000476a <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000473c:	8526                	mv	a0,s1
    8000473e:	9d2fe0ef          	jal	80002910 <iunlock>
  iput(p->cwd);
    80004742:	15093503          	ld	a0,336(s2)
    80004746:	a9efe0ef          	jal	800029e4 <iput>
  end_op();
    8000474a:	a19fe0ef          	jal	80003162 <end_op>
  p->cwd = ip;
    8000474e:	14993823          	sd	s1,336(s2)
  return 0;
    80004752:	4501                	li	a0,0
    80004754:	64aa                	ld	s1,136(sp)
}
    80004756:	60ea                	ld	ra,152(sp)
    80004758:	644a                	ld	s0,144(sp)
    8000475a:	690a                	ld	s2,128(sp)
    8000475c:	610d                	addi	sp,sp,160
    8000475e:	8082                	ret
    80004760:	64aa                	ld	s1,136(sp)
    end_op();
    80004762:	a01fe0ef          	jal	80003162 <end_op>
    return -1;
    80004766:	557d                	li	a0,-1
    80004768:	b7fd                	j	80004756 <sys_chdir+0x5c>
    iunlockput(ip);
    8000476a:	8526                	mv	a0,s1
    8000476c:	b00fe0ef          	jal	80002a6c <iunlockput>
    end_op();
    80004770:	9f3fe0ef          	jal	80003162 <end_op>
    return -1;
    80004774:	557d                	li	a0,-1
    80004776:	64aa                	ld	s1,136(sp)
    80004778:	bff9                	j	80004756 <sys_chdir+0x5c>

000000008000477a <sys_exec>:

uint64
sys_exec(void)
{
    8000477a:	7121                	addi	sp,sp,-448
    8000477c:	ff06                	sd	ra,440(sp)
    8000477e:	fb22                	sd	s0,432(sp)
    80004780:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004782:	e4840593          	addi	a1,s0,-440
    80004786:	4505                	li	a0,1
    80004788:	db2fd0ef          	jal	80001d3a <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000478c:	08000613          	li	a2,128
    80004790:	f5040593          	addi	a1,s0,-176
    80004794:	4501                	li	a0,0
    80004796:	dc0fd0ef          	jal	80001d56 <argstr>
    8000479a:	87aa                	mv	a5,a0
    return -1;
    8000479c:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000479e:	0c07c463          	bltz	a5,80004866 <sys_exec+0xec>
    800047a2:	f726                	sd	s1,424(sp)
    800047a4:	f34a                	sd	s2,416(sp)
    800047a6:	ef4e                	sd	s3,408(sp)
    800047a8:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800047aa:	10000613          	li	a2,256
    800047ae:	4581                	li	a1,0
    800047b0:	e5040513          	addi	a0,s0,-432
    800047b4:	99bfb0ef          	jal	8000014e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800047b8:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800047bc:	89a6                	mv	s3,s1
    800047be:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800047c0:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800047c4:	00391513          	slli	a0,s2,0x3
    800047c8:	e4040593          	addi	a1,s0,-448
    800047cc:	e4843783          	ld	a5,-440(s0)
    800047d0:	953e                	add	a0,a0,a5
    800047d2:	cc2fd0ef          	jal	80001c94 <fetchaddr>
    800047d6:	02054663          	bltz	a0,80004802 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    800047da:	e4043783          	ld	a5,-448(s0)
    800047de:	c3a9                	beqz	a5,80004820 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800047e0:	91ffb0ef          	jal	800000fe <kalloc>
    800047e4:	85aa                	mv	a1,a0
    800047e6:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800047ea:	cd01                	beqz	a0,80004802 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800047ec:	6605                	lui	a2,0x1
    800047ee:	e4043503          	ld	a0,-448(s0)
    800047f2:	cecfd0ef          	jal	80001cde <fetchstr>
    800047f6:	00054663          	bltz	a0,80004802 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    800047fa:	0905                	addi	s2,s2,1
    800047fc:	09a1                	addi	s3,s3,8
    800047fe:	fd4913e3          	bne	s2,s4,800047c4 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004802:	f5040913          	addi	s2,s0,-176
    80004806:	6088                	ld	a0,0(s1)
    80004808:	c931                	beqz	a0,8000485c <sys_exec+0xe2>
    kfree(argv[i]);
    8000480a:	813fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000480e:	04a1                	addi	s1,s1,8
    80004810:	ff249be3          	bne	s1,s2,80004806 <sys_exec+0x8c>
  return -1;
    80004814:	557d                	li	a0,-1
    80004816:	74ba                	ld	s1,424(sp)
    80004818:	791a                	ld	s2,416(sp)
    8000481a:	69fa                	ld	s3,408(sp)
    8000481c:	6a5a                	ld	s4,400(sp)
    8000481e:	a0a1                	j	80004866 <sys_exec+0xec>
      argv[i] = 0;
    80004820:	0009079b          	sext.w	a5,s2
    80004824:	078e                	slli	a5,a5,0x3
    80004826:	fd078793          	addi	a5,a5,-48
    8000482a:	97a2                	add	a5,a5,s0
    8000482c:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004830:	e5040593          	addi	a1,s0,-432
    80004834:	f5040513          	addi	a0,s0,-176
    80004838:	ad8ff0ef          	jal	80003b10 <exec>
    8000483c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000483e:	f5040993          	addi	s3,s0,-176
    80004842:	6088                	ld	a0,0(s1)
    80004844:	c511                	beqz	a0,80004850 <sys_exec+0xd6>
    kfree(argv[i]);
    80004846:	fd6fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000484a:	04a1                	addi	s1,s1,8
    8000484c:	ff349be3          	bne	s1,s3,80004842 <sys_exec+0xc8>
  return ret;
    80004850:	854a                	mv	a0,s2
    80004852:	74ba                	ld	s1,424(sp)
    80004854:	791a                	ld	s2,416(sp)
    80004856:	69fa                	ld	s3,408(sp)
    80004858:	6a5a                	ld	s4,400(sp)
    8000485a:	a031                	j	80004866 <sys_exec+0xec>
  return -1;
    8000485c:	557d                	li	a0,-1
    8000485e:	74ba                	ld	s1,424(sp)
    80004860:	791a                	ld	s2,416(sp)
    80004862:	69fa                	ld	s3,408(sp)
    80004864:	6a5a                	ld	s4,400(sp)
}
    80004866:	70fa                	ld	ra,440(sp)
    80004868:	745a                	ld	s0,432(sp)
    8000486a:	6139                	addi	sp,sp,448
    8000486c:	8082                	ret

000000008000486e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000486e:	7139                	addi	sp,sp,-64
    80004870:	fc06                	sd	ra,56(sp)
    80004872:	f822                	sd	s0,48(sp)
    80004874:	f426                	sd	s1,40(sp)
    80004876:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004878:	df2fc0ef          	jal	80000e6a <myproc>
    8000487c:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000487e:	fd840593          	addi	a1,s0,-40
    80004882:	4501                	li	a0,0
    80004884:	cb6fd0ef          	jal	80001d3a <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004888:	fc840593          	addi	a1,s0,-56
    8000488c:	fd040513          	addi	a0,s0,-48
    80004890:	f8dfe0ef          	jal	8000381c <pipealloc>
    return -1;
    80004894:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004896:	0a054463          	bltz	a0,8000493e <sys_pipe+0xd0>
  fd0 = -1;
    8000489a:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000489e:	fd043503          	ld	a0,-48(s0)
    800048a2:	f08ff0ef          	jal	80003faa <fdalloc>
    800048a6:	fca42223          	sw	a0,-60(s0)
    800048aa:	08054163          	bltz	a0,8000492c <sys_pipe+0xbe>
    800048ae:	fc843503          	ld	a0,-56(s0)
    800048b2:	ef8ff0ef          	jal	80003faa <fdalloc>
    800048b6:	fca42023          	sw	a0,-64(s0)
    800048ba:	06054063          	bltz	a0,8000491a <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800048be:	4691                	li	a3,4
    800048c0:	fc440613          	addi	a2,s0,-60
    800048c4:	fd843583          	ld	a1,-40(s0)
    800048c8:	68a8                	ld	a0,80(s1)
    800048ca:	928fc0ef          	jal	800009f2 <copyout>
    800048ce:	00054e63          	bltz	a0,800048ea <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800048d2:	4691                	li	a3,4
    800048d4:	fc040613          	addi	a2,s0,-64
    800048d8:	fd843583          	ld	a1,-40(s0)
    800048dc:	0591                	addi	a1,a1,4
    800048de:	68a8                	ld	a0,80(s1)
    800048e0:	912fc0ef          	jal	800009f2 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800048e4:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800048e6:	04055c63          	bgez	a0,8000493e <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800048ea:	fc442783          	lw	a5,-60(s0)
    800048ee:	07e9                	addi	a5,a5,26
    800048f0:	078e                	slli	a5,a5,0x3
    800048f2:	97a6                	add	a5,a5,s1
    800048f4:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800048f8:	fc042783          	lw	a5,-64(s0)
    800048fc:	07e9                	addi	a5,a5,26
    800048fe:	078e                	slli	a5,a5,0x3
    80004900:	94be                	add	s1,s1,a5
    80004902:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004906:	fd043503          	ld	a0,-48(s0)
    8000490a:	c09fe0ef          	jal	80003512 <fileclose>
    fileclose(wf);
    8000490e:	fc843503          	ld	a0,-56(s0)
    80004912:	c01fe0ef          	jal	80003512 <fileclose>
    return -1;
    80004916:	57fd                	li	a5,-1
    80004918:	a01d                	j	8000493e <sys_pipe+0xd0>
    if(fd0 >= 0)
    8000491a:	fc442783          	lw	a5,-60(s0)
    8000491e:	0007c763          	bltz	a5,8000492c <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80004922:	07e9                	addi	a5,a5,26
    80004924:	078e                	slli	a5,a5,0x3
    80004926:	97a6                	add	a5,a5,s1
    80004928:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000492c:	fd043503          	ld	a0,-48(s0)
    80004930:	be3fe0ef          	jal	80003512 <fileclose>
    fileclose(wf);
    80004934:	fc843503          	ld	a0,-56(s0)
    80004938:	bdbfe0ef          	jal	80003512 <fileclose>
    return -1;
    8000493c:	57fd                	li	a5,-1
}
    8000493e:	853e                	mv	a0,a5
    80004940:	70e2                	ld	ra,56(sp)
    80004942:	7442                	ld	s0,48(sp)
    80004944:	74a2                	ld	s1,40(sp)
    80004946:	6121                	addi	sp,sp,64
    80004948:	8082                	ret
    8000494a:	0000                	unimp
    8000494c:	0000                	unimp
	...

0000000080004950 <kernelvec>:
    80004950:	7111                	addi	sp,sp,-256
    80004952:	e006                	sd	ra,0(sp)
    80004954:	e40a                	sd	sp,8(sp)
    80004956:	e80e                	sd	gp,16(sp)
    80004958:	ec12                	sd	tp,24(sp)
    8000495a:	f016                	sd	t0,32(sp)
    8000495c:	f41a                	sd	t1,40(sp)
    8000495e:	f81e                	sd	t2,48(sp)
    80004960:	e4aa                	sd	a0,72(sp)
    80004962:	e8ae                	sd	a1,80(sp)
    80004964:	ecb2                	sd	a2,88(sp)
    80004966:	f0b6                	sd	a3,96(sp)
    80004968:	f4ba                	sd	a4,104(sp)
    8000496a:	f8be                	sd	a5,112(sp)
    8000496c:	fcc2                	sd	a6,120(sp)
    8000496e:	e146                	sd	a7,128(sp)
    80004970:	edf2                	sd	t3,216(sp)
    80004972:	f1f6                	sd	t4,224(sp)
    80004974:	f5fa                	sd	t5,232(sp)
    80004976:	f9fe                	sd	t6,240(sp)
    80004978:	a2cfd0ef          	jal	80001ba4 <kerneltrap>
    8000497c:	6082                	ld	ra,0(sp)
    8000497e:	6122                	ld	sp,8(sp)
    80004980:	61c2                	ld	gp,16(sp)
    80004982:	7282                	ld	t0,32(sp)
    80004984:	7322                	ld	t1,40(sp)
    80004986:	73c2                	ld	t2,48(sp)
    80004988:	6526                	ld	a0,72(sp)
    8000498a:	65c6                	ld	a1,80(sp)
    8000498c:	6666                	ld	a2,88(sp)
    8000498e:	7686                	ld	a3,96(sp)
    80004990:	7726                	ld	a4,104(sp)
    80004992:	77c6                	ld	a5,112(sp)
    80004994:	7866                	ld	a6,120(sp)
    80004996:	688a                	ld	a7,128(sp)
    80004998:	6e6e                	ld	t3,216(sp)
    8000499a:	7e8e                	ld	t4,224(sp)
    8000499c:	7f2e                	ld	t5,232(sp)
    8000499e:	7fce                	ld	t6,240(sp)
    800049a0:	6111                	addi	sp,sp,256
    800049a2:	10200073          	sret
	...

00000000800049ae <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800049ae:	1141                	addi	sp,sp,-16
    800049b0:	e422                	sd	s0,8(sp)
    800049b2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800049b4:	0c0007b7          	lui	a5,0xc000
    800049b8:	4705                	li	a4,1
    800049ba:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800049bc:	0c0007b7          	lui	a5,0xc000
    800049c0:	c3d8                	sw	a4,4(a5)
}
    800049c2:	6422                	ld	s0,8(sp)
    800049c4:	0141                	addi	sp,sp,16
    800049c6:	8082                	ret

00000000800049c8 <plicinithart>:

void
plicinithart(void)
{
    800049c8:	1141                	addi	sp,sp,-16
    800049ca:	e406                	sd	ra,8(sp)
    800049cc:	e022                	sd	s0,0(sp)
    800049ce:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800049d0:	c6efc0ef          	jal	80000e3e <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800049d4:	0085171b          	slliw	a4,a0,0x8
    800049d8:	0c0027b7          	lui	a5,0xc002
    800049dc:	97ba                	add	a5,a5,a4
    800049de:	40200713          	li	a4,1026
    800049e2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800049e6:	00d5151b          	slliw	a0,a0,0xd
    800049ea:	0c2017b7          	lui	a5,0xc201
    800049ee:	97aa                	add	a5,a5,a0
    800049f0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800049f4:	60a2                	ld	ra,8(sp)
    800049f6:	6402                	ld	s0,0(sp)
    800049f8:	0141                	addi	sp,sp,16
    800049fa:	8082                	ret

00000000800049fc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800049fc:	1141                	addi	sp,sp,-16
    800049fe:	e406                	sd	ra,8(sp)
    80004a00:	e022                	sd	s0,0(sp)
    80004a02:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004a04:	c3afc0ef          	jal	80000e3e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004a08:	00d5151b          	slliw	a0,a0,0xd
    80004a0c:	0c2017b7          	lui	a5,0xc201
    80004a10:	97aa                	add	a5,a5,a0
  return irq;
}
    80004a12:	43c8                	lw	a0,4(a5)
    80004a14:	60a2                	ld	ra,8(sp)
    80004a16:	6402                	ld	s0,0(sp)
    80004a18:	0141                	addi	sp,sp,16
    80004a1a:	8082                	ret

0000000080004a1c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80004a1c:	1101                	addi	sp,sp,-32
    80004a1e:	ec06                	sd	ra,24(sp)
    80004a20:	e822                	sd	s0,16(sp)
    80004a22:	e426                	sd	s1,8(sp)
    80004a24:	1000                	addi	s0,sp,32
    80004a26:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004a28:	c16fc0ef          	jal	80000e3e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80004a2c:	00d5151b          	slliw	a0,a0,0xd
    80004a30:	0c2017b7          	lui	a5,0xc201
    80004a34:	97aa                	add	a5,a5,a0
    80004a36:	c3c4                	sw	s1,4(a5)
}
    80004a38:	60e2                	ld	ra,24(sp)
    80004a3a:	6442                	ld	s0,16(sp)
    80004a3c:	64a2                	ld	s1,8(sp)
    80004a3e:	6105                	addi	sp,sp,32
    80004a40:	8082                	ret

0000000080004a42 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004a42:	1141                	addi	sp,sp,-16
    80004a44:	e406                	sd	ra,8(sp)
    80004a46:	e022                	sd	s0,0(sp)
    80004a48:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80004a4a:	479d                	li	a5,7
    80004a4c:	04a7ca63          	blt	a5,a0,80004aa0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004a50:	00014797          	auipc	a5,0x14
    80004a54:	07078793          	addi	a5,a5,112 # 80018ac0 <disk>
    80004a58:	97aa                	add	a5,a5,a0
    80004a5a:	0187c783          	lbu	a5,24(a5)
    80004a5e:	e7b9                	bnez	a5,80004aac <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004a60:	00451693          	slli	a3,a0,0x4
    80004a64:	00014797          	auipc	a5,0x14
    80004a68:	05c78793          	addi	a5,a5,92 # 80018ac0 <disk>
    80004a6c:	6398                	ld	a4,0(a5)
    80004a6e:	9736                	add	a4,a4,a3
    80004a70:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80004a74:	6398                	ld	a4,0(a5)
    80004a76:	9736                	add	a4,a4,a3
    80004a78:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80004a7c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004a80:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004a84:	97aa                	add	a5,a5,a0
    80004a86:	4705                	li	a4,1
    80004a88:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80004a8c:	00014517          	auipc	a0,0x14
    80004a90:	04c50513          	addi	a0,a0,76 # 80018ad8 <disk+0x18>
    80004a94:	9f1fc0ef          	jal	80001484 <wakeup>
}
    80004a98:	60a2                	ld	ra,8(sp)
    80004a9a:	6402                	ld	s0,0(sp)
    80004a9c:	0141                	addi	sp,sp,16
    80004a9e:	8082                	ret
    panic("free_desc 1");
    80004aa0:	00003517          	auipc	a0,0x3
    80004aa4:	bc850513          	addi	a0,a0,-1080 # 80007668 <etext+0x668>
    80004aa8:	43b000ef          	jal	800056e2 <panic>
    panic("free_desc 2");
    80004aac:	00003517          	auipc	a0,0x3
    80004ab0:	bcc50513          	addi	a0,a0,-1076 # 80007678 <etext+0x678>
    80004ab4:	42f000ef          	jal	800056e2 <panic>

0000000080004ab8 <virtio_disk_init>:
{
    80004ab8:	1101                	addi	sp,sp,-32
    80004aba:	ec06                	sd	ra,24(sp)
    80004abc:	e822                	sd	s0,16(sp)
    80004abe:	e426                	sd	s1,8(sp)
    80004ac0:	e04a                	sd	s2,0(sp)
    80004ac2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004ac4:	00003597          	auipc	a1,0x3
    80004ac8:	bc458593          	addi	a1,a1,-1084 # 80007688 <etext+0x688>
    80004acc:	00014517          	auipc	a0,0x14
    80004ad0:	11c50513          	addi	a0,a0,284 # 80018be8 <disk+0x128>
    80004ad4:	6bd000ef          	jal	80005990 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004ad8:	100017b7          	lui	a5,0x10001
    80004adc:	4398                	lw	a4,0(a5)
    80004ade:	2701                	sext.w	a4,a4
    80004ae0:	747277b7          	lui	a5,0x74727
    80004ae4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004ae8:	18f71063          	bne	a4,a5,80004c68 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004aec:	100017b7          	lui	a5,0x10001
    80004af0:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80004af2:	439c                	lw	a5,0(a5)
    80004af4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004af6:	4709                	li	a4,2
    80004af8:	16e79863          	bne	a5,a4,80004c68 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004afc:	100017b7          	lui	a5,0x10001
    80004b00:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80004b02:	439c                	lw	a5,0(a5)
    80004b04:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004b06:	16e79163          	bne	a5,a4,80004c68 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004b0a:	100017b7          	lui	a5,0x10001
    80004b0e:	47d8                	lw	a4,12(a5)
    80004b10:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004b12:	554d47b7          	lui	a5,0x554d4
    80004b16:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004b1a:	14f71763          	bne	a4,a5,80004c68 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b1e:	100017b7          	lui	a5,0x10001
    80004b22:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b26:	4705                	li	a4,1
    80004b28:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b2a:	470d                	li	a4,3
    80004b2c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004b2e:	10001737          	lui	a4,0x10001
    80004b32:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004b34:	c7ffe737          	lui	a4,0xc7ffe
    80004b38:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdda5f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004b3c:	8ef9                	and	a3,a3,a4
    80004b3e:	10001737          	lui	a4,0x10001
    80004b42:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b44:	472d                	li	a4,11
    80004b46:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b48:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004b4c:	439c                	lw	a5,0(a5)
    80004b4e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004b52:	8ba1                	andi	a5,a5,8
    80004b54:	12078063          	beqz	a5,80004c74 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004b58:	100017b7          	lui	a5,0x10001
    80004b5c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004b60:	100017b7          	lui	a5,0x10001
    80004b64:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80004b68:	439c                	lw	a5,0(a5)
    80004b6a:	2781                	sext.w	a5,a5
    80004b6c:	10079a63          	bnez	a5,80004c80 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004b70:	100017b7          	lui	a5,0x10001
    80004b74:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80004b78:	439c                	lw	a5,0(a5)
    80004b7a:	2781                	sext.w	a5,a5
  if(max == 0)
    80004b7c:	10078863          	beqz	a5,80004c8c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80004b80:	471d                	li	a4,7
    80004b82:	10f77b63          	bgeu	a4,a5,80004c98 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80004b86:	d78fb0ef          	jal	800000fe <kalloc>
    80004b8a:	00014497          	auipc	s1,0x14
    80004b8e:	f3648493          	addi	s1,s1,-202 # 80018ac0 <disk>
    80004b92:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004b94:	d6afb0ef          	jal	800000fe <kalloc>
    80004b98:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004b9a:	d64fb0ef          	jal	800000fe <kalloc>
    80004b9e:	87aa                	mv	a5,a0
    80004ba0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004ba2:	6088                	ld	a0,0(s1)
    80004ba4:	10050063          	beqz	a0,80004ca4 <virtio_disk_init+0x1ec>
    80004ba8:	00014717          	auipc	a4,0x14
    80004bac:	f2073703          	ld	a4,-224(a4) # 80018ac8 <disk+0x8>
    80004bb0:	0e070a63          	beqz	a4,80004ca4 <virtio_disk_init+0x1ec>
    80004bb4:	0e078863          	beqz	a5,80004ca4 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80004bb8:	6605                	lui	a2,0x1
    80004bba:	4581                	li	a1,0
    80004bbc:	d92fb0ef          	jal	8000014e <memset>
  memset(disk.avail, 0, PGSIZE);
    80004bc0:	00014497          	auipc	s1,0x14
    80004bc4:	f0048493          	addi	s1,s1,-256 # 80018ac0 <disk>
    80004bc8:	6605                	lui	a2,0x1
    80004bca:	4581                	li	a1,0
    80004bcc:	6488                	ld	a0,8(s1)
    80004bce:	d80fb0ef          	jal	8000014e <memset>
  memset(disk.used, 0, PGSIZE);
    80004bd2:	6605                	lui	a2,0x1
    80004bd4:	4581                	li	a1,0
    80004bd6:	6888                	ld	a0,16(s1)
    80004bd8:	d76fb0ef          	jal	8000014e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004bdc:	100017b7          	lui	a5,0x10001
    80004be0:	4721                	li	a4,8
    80004be2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004be4:	4098                	lw	a4,0(s1)
    80004be6:	100017b7          	lui	a5,0x10001
    80004bea:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004bee:	40d8                	lw	a4,4(s1)
    80004bf0:	100017b7          	lui	a5,0x10001
    80004bf4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004bf8:	649c                	ld	a5,8(s1)
    80004bfa:	0007869b          	sext.w	a3,a5
    80004bfe:	10001737          	lui	a4,0x10001
    80004c02:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004c06:	9781                	srai	a5,a5,0x20
    80004c08:	10001737          	lui	a4,0x10001
    80004c0c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004c10:	689c                	ld	a5,16(s1)
    80004c12:	0007869b          	sext.w	a3,a5
    80004c16:	10001737          	lui	a4,0x10001
    80004c1a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004c1e:	9781                	srai	a5,a5,0x20
    80004c20:	10001737          	lui	a4,0x10001
    80004c24:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004c28:	10001737          	lui	a4,0x10001
    80004c2c:	4785                	li	a5,1
    80004c2e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004c30:	00f48c23          	sb	a5,24(s1)
    80004c34:	00f48ca3          	sb	a5,25(s1)
    80004c38:	00f48d23          	sb	a5,26(s1)
    80004c3c:	00f48da3          	sb	a5,27(s1)
    80004c40:	00f48e23          	sb	a5,28(s1)
    80004c44:	00f48ea3          	sb	a5,29(s1)
    80004c48:	00f48f23          	sb	a5,30(s1)
    80004c4c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004c50:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c54:	100017b7          	lui	a5,0x10001
    80004c58:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80004c5c:	60e2                	ld	ra,24(sp)
    80004c5e:	6442                	ld	s0,16(sp)
    80004c60:	64a2                	ld	s1,8(sp)
    80004c62:	6902                	ld	s2,0(sp)
    80004c64:	6105                	addi	sp,sp,32
    80004c66:	8082                	ret
    panic("could not find virtio disk");
    80004c68:	00003517          	auipc	a0,0x3
    80004c6c:	a3050513          	addi	a0,a0,-1488 # 80007698 <etext+0x698>
    80004c70:	273000ef          	jal	800056e2 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004c74:	00003517          	auipc	a0,0x3
    80004c78:	a4450513          	addi	a0,a0,-1468 # 800076b8 <etext+0x6b8>
    80004c7c:	267000ef          	jal	800056e2 <panic>
    panic("virtio disk should not be ready");
    80004c80:	00003517          	auipc	a0,0x3
    80004c84:	a5850513          	addi	a0,a0,-1448 # 800076d8 <etext+0x6d8>
    80004c88:	25b000ef          	jal	800056e2 <panic>
    panic("virtio disk has no queue 0");
    80004c8c:	00003517          	auipc	a0,0x3
    80004c90:	a6c50513          	addi	a0,a0,-1428 # 800076f8 <etext+0x6f8>
    80004c94:	24f000ef          	jal	800056e2 <panic>
    panic("virtio disk max queue too short");
    80004c98:	00003517          	auipc	a0,0x3
    80004c9c:	a8050513          	addi	a0,a0,-1408 # 80007718 <etext+0x718>
    80004ca0:	243000ef          	jal	800056e2 <panic>
    panic("virtio disk kalloc");
    80004ca4:	00003517          	auipc	a0,0x3
    80004ca8:	a9450513          	addi	a0,a0,-1388 # 80007738 <etext+0x738>
    80004cac:	237000ef          	jal	800056e2 <panic>

0000000080004cb0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004cb0:	7159                	addi	sp,sp,-112
    80004cb2:	f486                	sd	ra,104(sp)
    80004cb4:	f0a2                	sd	s0,96(sp)
    80004cb6:	eca6                	sd	s1,88(sp)
    80004cb8:	e8ca                	sd	s2,80(sp)
    80004cba:	e4ce                	sd	s3,72(sp)
    80004cbc:	e0d2                	sd	s4,64(sp)
    80004cbe:	fc56                	sd	s5,56(sp)
    80004cc0:	f85a                	sd	s6,48(sp)
    80004cc2:	f45e                	sd	s7,40(sp)
    80004cc4:	f062                	sd	s8,32(sp)
    80004cc6:	ec66                	sd	s9,24(sp)
    80004cc8:	1880                	addi	s0,sp,112
    80004cca:	8a2a                	mv	s4,a0
    80004ccc:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004cce:	00c52c83          	lw	s9,12(a0)
    80004cd2:	001c9c9b          	slliw	s9,s9,0x1
    80004cd6:	1c82                	slli	s9,s9,0x20
    80004cd8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80004cdc:	00014517          	auipc	a0,0x14
    80004ce0:	f0c50513          	addi	a0,a0,-244 # 80018be8 <disk+0x128>
    80004ce4:	52d000ef          	jal	80005a10 <acquire>
  for(int i = 0; i < 3; i++){
    80004ce8:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80004cea:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004cec:	00014b17          	auipc	s6,0x14
    80004cf0:	dd4b0b13          	addi	s6,s6,-556 # 80018ac0 <disk>
  for(int i = 0; i < 3; i++){
    80004cf4:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004cf6:	00014c17          	auipc	s8,0x14
    80004cfa:	ef2c0c13          	addi	s8,s8,-270 # 80018be8 <disk+0x128>
    80004cfe:	a8b9                	j	80004d5c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80004d00:	00fb0733          	add	a4,s6,a5
    80004d04:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80004d08:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004d0a:	0207c563          	bltz	a5,80004d34 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80004d0e:	2905                	addiw	s2,s2,1
    80004d10:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004d12:	05590963          	beq	s2,s5,80004d64 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80004d16:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004d18:	00014717          	auipc	a4,0x14
    80004d1c:	da870713          	addi	a4,a4,-600 # 80018ac0 <disk>
    80004d20:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80004d22:	01874683          	lbu	a3,24(a4)
    80004d26:	fee9                	bnez	a3,80004d00 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80004d28:	2785                	addiw	a5,a5,1
    80004d2a:	0705                	addi	a4,a4,1
    80004d2c:	fe979be3          	bne	a5,s1,80004d22 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80004d30:	57fd                	li	a5,-1
    80004d32:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80004d34:	01205d63          	blez	s2,80004d4e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004d38:	f9042503          	lw	a0,-112(s0)
    80004d3c:	d07ff0ef          	jal	80004a42 <free_desc>
      for(int j = 0; j < i; j++)
    80004d40:	4785                	li	a5,1
    80004d42:	0127d663          	bge	a5,s2,80004d4e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004d46:	f9442503          	lw	a0,-108(s0)
    80004d4a:	cf9ff0ef          	jal	80004a42 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004d4e:	85e2                	mv	a1,s8
    80004d50:	00014517          	auipc	a0,0x14
    80004d54:	d8850513          	addi	a0,a0,-632 # 80018ad8 <disk+0x18>
    80004d58:	ee0fc0ef          	jal	80001438 <sleep>
  for(int i = 0; i < 3; i++){
    80004d5c:	f9040613          	addi	a2,s0,-112
    80004d60:	894e                	mv	s2,s3
    80004d62:	bf55                	j	80004d16 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004d64:	f9042503          	lw	a0,-112(s0)
    80004d68:	00451693          	slli	a3,a0,0x4

  if(write)
    80004d6c:	00014797          	auipc	a5,0x14
    80004d70:	d5478793          	addi	a5,a5,-684 # 80018ac0 <disk>
    80004d74:	00a50713          	addi	a4,a0,10
    80004d78:	0712                	slli	a4,a4,0x4
    80004d7a:	973e                	add	a4,a4,a5
    80004d7c:	01703633          	snez	a2,s7
    80004d80:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004d82:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004d86:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004d8a:	6398                	ld	a4,0(a5)
    80004d8c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004d8e:	0a868613          	addi	a2,a3,168
    80004d92:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004d94:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004d96:	6390                	ld	a2,0(a5)
    80004d98:	00d605b3          	add	a1,a2,a3
    80004d9c:	4741                	li	a4,16
    80004d9e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004da0:	4805                	li	a6,1
    80004da2:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004da6:	f9442703          	lw	a4,-108(s0)
    80004daa:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004dae:	0712                	slli	a4,a4,0x4
    80004db0:	963a                	add	a2,a2,a4
    80004db2:	058a0593          	addi	a1,s4,88
    80004db6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004db8:	0007b883          	ld	a7,0(a5)
    80004dbc:	9746                	add	a4,a4,a7
    80004dbe:	40000613          	li	a2,1024
    80004dc2:	c710                	sw	a2,8(a4)
  if(write)
    80004dc4:	001bb613          	seqz	a2,s7
    80004dc8:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004dcc:	00166613          	ori	a2,a2,1
    80004dd0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004dd4:	f9842583          	lw	a1,-104(s0)
    80004dd8:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004ddc:	00250613          	addi	a2,a0,2
    80004de0:	0612                	slli	a2,a2,0x4
    80004de2:	963e                	add	a2,a2,a5
    80004de4:	577d                	li	a4,-1
    80004de6:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004dea:	0592                	slli	a1,a1,0x4
    80004dec:	98ae                	add	a7,a7,a1
    80004dee:	03068713          	addi	a4,a3,48
    80004df2:	973e                	add	a4,a4,a5
    80004df4:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004df8:	6398                	ld	a4,0(a5)
    80004dfa:	972e                	add	a4,a4,a1
    80004dfc:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004e00:	4689                	li	a3,2
    80004e02:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004e06:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004e0a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80004e0e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004e12:	6794                	ld	a3,8(a5)
    80004e14:	0026d703          	lhu	a4,2(a3)
    80004e18:	8b1d                	andi	a4,a4,7
    80004e1a:	0706                	slli	a4,a4,0x1
    80004e1c:	96ba                	add	a3,a3,a4
    80004e1e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004e22:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004e26:	6798                	ld	a4,8(a5)
    80004e28:	00275783          	lhu	a5,2(a4)
    80004e2c:	2785                	addiw	a5,a5,1
    80004e2e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004e32:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004e36:	100017b7          	lui	a5,0x10001
    80004e3a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004e3e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80004e42:	00014917          	auipc	s2,0x14
    80004e46:	da690913          	addi	s2,s2,-602 # 80018be8 <disk+0x128>
  while(b->disk == 1) {
    80004e4a:	4485                	li	s1,1
    80004e4c:	01079a63          	bne	a5,a6,80004e60 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004e50:	85ca                	mv	a1,s2
    80004e52:	8552                	mv	a0,s4
    80004e54:	de4fc0ef          	jal	80001438 <sleep>
  while(b->disk == 1) {
    80004e58:	004a2783          	lw	a5,4(s4)
    80004e5c:	fe978ae3          	beq	a5,s1,80004e50 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004e60:	f9042903          	lw	s2,-112(s0)
    80004e64:	00290713          	addi	a4,s2,2
    80004e68:	0712                	slli	a4,a4,0x4
    80004e6a:	00014797          	auipc	a5,0x14
    80004e6e:	c5678793          	addi	a5,a5,-938 # 80018ac0 <disk>
    80004e72:	97ba                	add	a5,a5,a4
    80004e74:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004e78:	00014997          	auipc	s3,0x14
    80004e7c:	c4898993          	addi	s3,s3,-952 # 80018ac0 <disk>
    80004e80:	00491713          	slli	a4,s2,0x4
    80004e84:	0009b783          	ld	a5,0(s3)
    80004e88:	97ba                	add	a5,a5,a4
    80004e8a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004e8e:	854a                	mv	a0,s2
    80004e90:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004e94:	bafff0ef          	jal	80004a42 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004e98:	8885                	andi	s1,s1,1
    80004e9a:	f0fd                	bnez	s1,80004e80 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004e9c:	00014517          	auipc	a0,0x14
    80004ea0:	d4c50513          	addi	a0,a0,-692 # 80018be8 <disk+0x128>
    80004ea4:	405000ef          	jal	80005aa8 <release>
}
    80004ea8:	70a6                	ld	ra,104(sp)
    80004eaa:	7406                	ld	s0,96(sp)
    80004eac:	64e6                	ld	s1,88(sp)
    80004eae:	6946                	ld	s2,80(sp)
    80004eb0:	69a6                	ld	s3,72(sp)
    80004eb2:	6a06                	ld	s4,64(sp)
    80004eb4:	7ae2                	ld	s5,56(sp)
    80004eb6:	7b42                	ld	s6,48(sp)
    80004eb8:	7ba2                	ld	s7,40(sp)
    80004eba:	7c02                	ld	s8,32(sp)
    80004ebc:	6ce2                	ld	s9,24(sp)
    80004ebe:	6165                	addi	sp,sp,112
    80004ec0:	8082                	ret

0000000080004ec2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004ec2:	1101                	addi	sp,sp,-32
    80004ec4:	ec06                	sd	ra,24(sp)
    80004ec6:	e822                	sd	s0,16(sp)
    80004ec8:	e426                	sd	s1,8(sp)
    80004eca:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004ecc:	00014497          	auipc	s1,0x14
    80004ed0:	bf448493          	addi	s1,s1,-1036 # 80018ac0 <disk>
    80004ed4:	00014517          	auipc	a0,0x14
    80004ed8:	d1450513          	addi	a0,a0,-748 # 80018be8 <disk+0x128>
    80004edc:	335000ef          	jal	80005a10 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004ee0:	100017b7          	lui	a5,0x10001
    80004ee4:	53b8                	lw	a4,96(a5)
    80004ee6:	8b0d                	andi	a4,a4,3
    80004ee8:	100017b7          	lui	a5,0x10001
    80004eec:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80004eee:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004ef2:	689c                	ld	a5,16(s1)
    80004ef4:	0204d703          	lhu	a4,32(s1)
    80004ef8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004efc:	04f70663          	beq	a4,a5,80004f48 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80004f00:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004f04:	6898                	ld	a4,16(s1)
    80004f06:	0204d783          	lhu	a5,32(s1)
    80004f0a:	8b9d                	andi	a5,a5,7
    80004f0c:	078e                	slli	a5,a5,0x3
    80004f0e:	97ba                	add	a5,a5,a4
    80004f10:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004f12:	00278713          	addi	a4,a5,2
    80004f16:	0712                	slli	a4,a4,0x4
    80004f18:	9726                	add	a4,a4,s1
    80004f1a:	01074703          	lbu	a4,16(a4)
    80004f1e:	e321                	bnez	a4,80004f5e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004f20:	0789                	addi	a5,a5,2
    80004f22:	0792                	slli	a5,a5,0x4
    80004f24:	97a6                	add	a5,a5,s1
    80004f26:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004f28:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004f2c:	d58fc0ef          	jal	80001484 <wakeup>

    disk.used_idx += 1;
    80004f30:	0204d783          	lhu	a5,32(s1)
    80004f34:	2785                	addiw	a5,a5,1
    80004f36:	17c2                	slli	a5,a5,0x30
    80004f38:	93c1                	srli	a5,a5,0x30
    80004f3a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004f3e:	6898                	ld	a4,16(s1)
    80004f40:	00275703          	lhu	a4,2(a4)
    80004f44:	faf71ee3          	bne	a4,a5,80004f00 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004f48:	00014517          	auipc	a0,0x14
    80004f4c:	ca050513          	addi	a0,a0,-864 # 80018be8 <disk+0x128>
    80004f50:	359000ef          	jal	80005aa8 <release>
}
    80004f54:	60e2                	ld	ra,24(sp)
    80004f56:	6442                	ld	s0,16(sp)
    80004f58:	64a2                	ld	s1,8(sp)
    80004f5a:	6105                	addi	sp,sp,32
    80004f5c:	8082                	ret
      panic("virtio_disk_intr status");
    80004f5e:	00002517          	auipc	a0,0x2
    80004f62:	7f250513          	addi	a0,a0,2034 # 80007750 <etext+0x750>
    80004f66:	77c000ef          	jal	800056e2 <panic>

0000000080004f6a <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004f6a:	1141                	addi	sp,sp,-16
    80004f6c:	e422                	sd	s0,8(sp)
    80004f6e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004f70:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004f74:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004f78:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004f7c:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004f80:	577d                	li	a4,-1
    80004f82:	177e                	slli	a4,a4,0x3f
    80004f84:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004f86:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004f8a:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004f8e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004f92:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004f96:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004f9a:	000f4737          	lui	a4,0xf4
    80004f9e:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004fa2:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004fa4:	14d79073          	csrw	stimecmp,a5
}
    80004fa8:	6422                	ld	s0,8(sp)
    80004faa:	0141                	addi	sp,sp,16
    80004fac:	8082                	ret

0000000080004fae <start>:
{
    80004fae:	1141                	addi	sp,sp,-16
    80004fb0:	e406                	sd	ra,8(sp)
    80004fb2:	e022                	sd	s0,0(sp)
    80004fb4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004fb6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004fba:	7779                	lui	a4,0xffffe
    80004fbc:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffddaff>
    80004fc0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004fc2:	6705                	lui	a4,0x1
    80004fc4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004fc8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004fca:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004fce:	ffffb797          	auipc	a5,0xffffb
    80004fd2:	31a78793          	addi	a5,a5,794 # 800002e8 <main>
    80004fd6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004fda:	4781                	li	a5,0
    80004fdc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004fe0:	67c1                	lui	a5,0x10
    80004fe2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004fe4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004fe8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004fec:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80004ff0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80004ff4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004ff8:	57fd                	li	a5,-1
    80004ffa:	83a9                	srli	a5,a5,0xa
    80004ffc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005000:	47bd                	li	a5,15
    80005002:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005006:	f65ff0ef          	jal	80004f6a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000500a:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000500e:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005010:	823e                	mv	tp,a5
  asm volatile("mret");
    80005012:	30200073          	mret
}
    80005016:	60a2                	ld	ra,8(sp)
    80005018:	6402                	ld	s0,0(sp)
    8000501a:	0141                	addi	sp,sp,16
    8000501c:	8082                	ret

000000008000501e <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000501e:	715d                	addi	sp,sp,-80
    80005020:	e486                	sd	ra,72(sp)
    80005022:	e0a2                	sd	s0,64(sp)
    80005024:	f84a                	sd	s2,48(sp)
    80005026:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005028:	04c05263          	blez	a2,8000506c <consolewrite+0x4e>
    8000502c:	fc26                	sd	s1,56(sp)
    8000502e:	f44e                	sd	s3,40(sp)
    80005030:	f052                	sd	s4,32(sp)
    80005032:	ec56                	sd	s5,24(sp)
    80005034:	8a2a                	mv	s4,a0
    80005036:	84ae                	mv	s1,a1
    80005038:	89b2                	mv	s3,a2
    8000503a:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000503c:	5afd                	li	s5,-1
    8000503e:	4685                	li	a3,1
    80005040:	8626                	mv	a2,s1
    80005042:	85d2                	mv	a1,s4
    80005044:	fbf40513          	addi	a0,s0,-65
    80005048:	f96fc0ef          	jal	800017de <either_copyin>
    8000504c:	03550263          	beq	a0,s5,80005070 <consolewrite+0x52>
      break;
    uartputc(c);
    80005050:	fbf44503          	lbu	a0,-65(s0)
    80005054:	035000ef          	jal	80005888 <uartputc>
  for(i = 0; i < n; i++){
    80005058:	2905                	addiw	s2,s2,1
    8000505a:	0485                	addi	s1,s1,1
    8000505c:	ff2991e3          	bne	s3,s2,8000503e <consolewrite+0x20>
    80005060:	894e                	mv	s2,s3
    80005062:	74e2                	ld	s1,56(sp)
    80005064:	79a2                	ld	s3,40(sp)
    80005066:	7a02                	ld	s4,32(sp)
    80005068:	6ae2                	ld	s5,24(sp)
    8000506a:	a039                	j	80005078 <consolewrite+0x5a>
    8000506c:	4901                	li	s2,0
    8000506e:	a029                	j	80005078 <consolewrite+0x5a>
    80005070:	74e2                	ld	s1,56(sp)
    80005072:	79a2                	ld	s3,40(sp)
    80005074:	7a02                	ld	s4,32(sp)
    80005076:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005078:	854a                	mv	a0,s2
    8000507a:	60a6                	ld	ra,72(sp)
    8000507c:	6406                	ld	s0,64(sp)
    8000507e:	7942                	ld	s2,48(sp)
    80005080:	6161                	addi	sp,sp,80
    80005082:	8082                	ret

0000000080005084 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005084:	711d                	addi	sp,sp,-96
    80005086:	ec86                	sd	ra,88(sp)
    80005088:	e8a2                	sd	s0,80(sp)
    8000508a:	e4a6                	sd	s1,72(sp)
    8000508c:	e0ca                	sd	s2,64(sp)
    8000508e:	fc4e                	sd	s3,56(sp)
    80005090:	f852                	sd	s4,48(sp)
    80005092:	f456                	sd	s5,40(sp)
    80005094:	f05a                	sd	s6,32(sp)
    80005096:	1080                	addi	s0,sp,96
    80005098:	8aaa                	mv	s5,a0
    8000509a:	8a2e                	mv	s4,a1
    8000509c:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000509e:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800050a2:	0001c517          	auipc	a0,0x1c
    800050a6:	b5e50513          	addi	a0,a0,-1186 # 80020c00 <cons>
    800050aa:	167000ef          	jal	80005a10 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800050ae:	0001c497          	auipc	s1,0x1c
    800050b2:	b5248493          	addi	s1,s1,-1198 # 80020c00 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800050b6:	0001c917          	auipc	s2,0x1c
    800050ba:	be290913          	addi	s2,s2,-1054 # 80020c98 <cons+0x98>
  while(n > 0){
    800050be:	0b305d63          	blez	s3,80005178 <consoleread+0xf4>
    while(cons.r == cons.w){
    800050c2:	0984a783          	lw	a5,152(s1)
    800050c6:	09c4a703          	lw	a4,156(s1)
    800050ca:	0af71263          	bne	a4,a5,8000516e <consoleread+0xea>
      if(killed(myproc())){
    800050ce:	d9dfb0ef          	jal	80000e6a <myproc>
    800050d2:	d9efc0ef          	jal	80001670 <killed>
    800050d6:	e12d                	bnez	a0,80005138 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    800050d8:	85a6                	mv	a1,s1
    800050da:	854a                	mv	a0,s2
    800050dc:	b5cfc0ef          	jal	80001438 <sleep>
    while(cons.r == cons.w){
    800050e0:	0984a783          	lw	a5,152(s1)
    800050e4:	09c4a703          	lw	a4,156(s1)
    800050e8:	fef703e3          	beq	a4,a5,800050ce <consoleread+0x4a>
    800050ec:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800050ee:	0001c717          	auipc	a4,0x1c
    800050f2:	b1270713          	addi	a4,a4,-1262 # 80020c00 <cons>
    800050f6:	0017869b          	addiw	a3,a5,1
    800050fa:	08d72c23          	sw	a3,152(a4)
    800050fe:	07f7f693          	andi	a3,a5,127
    80005102:	9736                	add	a4,a4,a3
    80005104:	01874703          	lbu	a4,24(a4)
    80005108:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    8000510c:	4691                	li	a3,4
    8000510e:	04db8663          	beq	s7,a3,8000515a <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005112:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005116:	4685                	li	a3,1
    80005118:	faf40613          	addi	a2,s0,-81
    8000511c:	85d2                	mv	a1,s4
    8000511e:	8556                	mv	a0,s5
    80005120:	e74fc0ef          	jal	80001794 <either_copyout>
    80005124:	57fd                	li	a5,-1
    80005126:	04f50863          	beq	a0,a5,80005176 <consoleread+0xf2>
      break;

    dst++;
    8000512a:	0a05                	addi	s4,s4,1
    --n;
    8000512c:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000512e:	47a9                	li	a5,10
    80005130:	04fb8d63          	beq	s7,a5,8000518a <consoleread+0x106>
    80005134:	6be2                	ld	s7,24(sp)
    80005136:	b761                	j	800050be <consoleread+0x3a>
        release(&cons.lock);
    80005138:	0001c517          	auipc	a0,0x1c
    8000513c:	ac850513          	addi	a0,a0,-1336 # 80020c00 <cons>
    80005140:	169000ef          	jal	80005aa8 <release>
        return -1;
    80005144:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005146:	60e6                	ld	ra,88(sp)
    80005148:	6446                	ld	s0,80(sp)
    8000514a:	64a6                	ld	s1,72(sp)
    8000514c:	6906                	ld	s2,64(sp)
    8000514e:	79e2                	ld	s3,56(sp)
    80005150:	7a42                	ld	s4,48(sp)
    80005152:	7aa2                	ld	s5,40(sp)
    80005154:	7b02                	ld	s6,32(sp)
    80005156:	6125                	addi	sp,sp,96
    80005158:	8082                	ret
      if(n < target){
    8000515a:	0009871b          	sext.w	a4,s3
    8000515e:	01677a63          	bgeu	a4,s6,80005172 <consoleread+0xee>
        cons.r--;
    80005162:	0001c717          	auipc	a4,0x1c
    80005166:	b2f72b23          	sw	a5,-1226(a4) # 80020c98 <cons+0x98>
    8000516a:	6be2                	ld	s7,24(sp)
    8000516c:	a031                	j	80005178 <consoleread+0xf4>
    8000516e:	ec5e                	sd	s7,24(sp)
    80005170:	bfbd                	j	800050ee <consoleread+0x6a>
    80005172:	6be2                	ld	s7,24(sp)
    80005174:	a011                	j	80005178 <consoleread+0xf4>
    80005176:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005178:	0001c517          	auipc	a0,0x1c
    8000517c:	a8850513          	addi	a0,a0,-1400 # 80020c00 <cons>
    80005180:	129000ef          	jal	80005aa8 <release>
  return target - n;
    80005184:	413b053b          	subw	a0,s6,s3
    80005188:	bf7d                	j	80005146 <consoleread+0xc2>
    8000518a:	6be2                	ld	s7,24(sp)
    8000518c:	b7f5                	j	80005178 <consoleread+0xf4>

000000008000518e <consputc>:
{
    8000518e:	1141                	addi	sp,sp,-16
    80005190:	e406                	sd	ra,8(sp)
    80005192:	e022                	sd	s0,0(sp)
    80005194:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005196:	10000793          	li	a5,256
    8000519a:	00f50863          	beq	a0,a5,800051aa <consputc+0x1c>
    uartputc_sync(c);
    8000519e:	604000ef          	jal	800057a2 <uartputc_sync>
}
    800051a2:	60a2                	ld	ra,8(sp)
    800051a4:	6402                	ld	s0,0(sp)
    800051a6:	0141                	addi	sp,sp,16
    800051a8:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800051aa:	4521                	li	a0,8
    800051ac:	5f6000ef          	jal	800057a2 <uartputc_sync>
    800051b0:	02000513          	li	a0,32
    800051b4:	5ee000ef          	jal	800057a2 <uartputc_sync>
    800051b8:	4521                	li	a0,8
    800051ba:	5e8000ef          	jal	800057a2 <uartputc_sync>
    800051be:	b7d5                	j	800051a2 <consputc+0x14>

00000000800051c0 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800051c0:	1101                	addi	sp,sp,-32
    800051c2:	ec06                	sd	ra,24(sp)
    800051c4:	e822                	sd	s0,16(sp)
    800051c6:	e426                	sd	s1,8(sp)
    800051c8:	1000                	addi	s0,sp,32
    800051ca:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800051cc:	0001c517          	auipc	a0,0x1c
    800051d0:	a3450513          	addi	a0,a0,-1484 # 80020c00 <cons>
    800051d4:	03d000ef          	jal	80005a10 <acquire>

  switch(c){
    800051d8:	47d5                	li	a5,21
    800051da:	08f48f63          	beq	s1,a5,80005278 <consoleintr+0xb8>
    800051de:	0297c563          	blt	a5,s1,80005208 <consoleintr+0x48>
    800051e2:	47a1                	li	a5,8
    800051e4:	0ef48463          	beq	s1,a5,800052cc <consoleintr+0x10c>
    800051e8:	47c1                	li	a5,16
    800051ea:	10f49563          	bne	s1,a5,800052f4 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    800051ee:	e3afc0ef          	jal	80001828 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800051f2:	0001c517          	auipc	a0,0x1c
    800051f6:	a0e50513          	addi	a0,a0,-1522 # 80020c00 <cons>
    800051fa:	0af000ef          	jal	80005aa8 <release>
}
    800051fe:	60e2                	ld	ra,24(sp)
    80005200:	6442                	ld	s0,16(sp)
    80005202:	64a2                	ld	s1,8(sp)
    80005204:	6105                	addi	sp,sp,32
    80005206:	8082                	ret
  switch(c){
    80005208:	07f00793          	li	a5,127
    8000520c:	0cf48063          	beq	s1,a5,800052cc <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005210:	0001c717          	auipc	a4,0x1c
    80005214:	9f070713          	addi	a4,a4,-1552 # 80020c00 <cons>
    80005218:	0a072783          	lw	a5,160(a4)
    8000521c:	09872703          	lw	a4,152(a4)
    80005220:	9f99                	subw	a5,a5,a4
    80005222:	07f00713          	li	a4,127
    80005226:	fcf766e3          	bltu	a4,a5,800051f2 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    8000522a:	47b5                	li	a5,13
    8000522c:	0cf48763          	beq	s1,a5,800052fa <consoleintr+0x13a>
      consputc(c);
    80005230:	8526                	mv	a0,s1
    80005232:	f5dff0ef          	jal	8000518e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005236:	0001c797          	auipc	a5,0x1c
    8000523a:	9ca78793          	addi	a5,a5,-1590 # 80020c00 <cons>
    8000523e:	0a07a683          	lw	a3,160(a5)
    80005242:	0016871b          	addiw	a4,a3,1
    80005246:	0007061b          	sext.w	a2,a4
    8000524a:	0ae7a023          	sw	a4,160(a5)
    8000524e:	07f6f693          	andi	a3,a3,127
    80005252:	97b6                	add	a5,a5,a3
    80005254:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005258:	47a9                	li	a5,10
    8000525a:	0cf48563          	beq	s1,a5,80005324 <consoleintr+0x164>
    8000525e:	4791                	li	a5,4
    80005260:	0cf48263          	beq	s1,a5,80005324 <consoleintr+0x164>
    80005264:	0001c797          	auipc	a5,0x1c
    80005268:	a347a783          	lw	a5,-1484(a5) # 80020c98 <cons+0x98>
    8000526c:	9f1d                	subw	a4,a4,a5
    8000526e:	08000793          	li	a5,128
    80005272:	f8f710e3          	bne	a4,a5,800051f2 <consoleintr+0x32>
    80005276:	a07d                	j	80005324 <consoleintr+0x164>
    80005278:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000527a:	0001c717          	auipc	a4,0x1c
    8000527e:	98670713          	addi	a4,a4,-1658 # 80020c00 <cons>
    80005282:	0a072783          	lw	a5,160(a4)
    80005286:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000528a:	0001c497          	auipc	s1,0x1c
    8000528e:	97648493          	addi	s1,s1,-1674 # 80020c00 <cons>
    while(cons.e != cons.w &&
    80005292:	4929                	li	s2,10
    80005294:	02f70863          	beq	a4,a5,800052c4 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005298:	37fd                	addiw	a5,a5,-1
    8000529a:	07f7f713          	andi	a4,a5,127
    8000529e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800052a0:	01874703          	lbu	a4,24(a4)
    800052a4:	03270263          	beq	a4,s2,800052c8 <consoleintr+0x108>
      cons.e--;
    800052a8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800052ac:	10000513          	li	a0,256
    800052b0:	edfff0ef          	jal	8000518e <consputc>
    while(cons.e != cons.w &&
    800052b4:	0a04a783          	lw	a5,160(s1)
    800052b8:	09c4a703          	lw	a4,156(s1)
    800052bc:	fcf71ee3          	bne	a4,a5,80005298 <consoleintr+0xd8>
    800052c0:	6902                	ld	s2,0(sp)
    800052c2:	bf05                	j	800051f2 <consoleintr+0x32>
    800052c4:	6902                	ld	s2,0(sp)
    800052c6:	b735                	j	800051f2 <consoleintr+0x32>
    800052c8:	6902                	ld	s2,0(sp)
    800052ca:	b725                	j	800051f2 <consoleintr+0x32>
    if(cons.e != cons.w){
    800052cc:	0001c717          	auipc	a4,0x1c
    800052d0:	93470713          	addi	a4,a4,-1740 # 80020c00 <cons>
    800052d4:	0a072783          	lw	a5,160(a4)
    800052d8:	09c72703          	lw	a4,156(a4)
    800052dc:	f0f70be3          	beq	a4,a5,800051f2 <consoleintr+0x32>
      cons.e--;
    800052e0:	37fd                	addiw	a5,a5,-1
    800052e2:	0001c717          	auipc	a4,0x1c
    800052e6:	9af72f23          	sw	a5,-1602(a4) # 80020ca0 <cons+0xa0>
      consputc(BACKSPACE);
    800052ea:	10000513          	li	a0,256
    800052ee:	ea1ff0ef          	jal	8000518e <consputc>
    800052f2:	b701                	j	800051f2 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800052f4:	ee048fe3          	beqz	s1,800051f2 <consoleintr+0x32>
    800052f8:	bf21                	j	80005210 <consoleintr+0x50>
      consputc(c);
    800052fa:	4529                	li	a0,10
    800052fc:	e93ff0ef          	jal	8000518e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005300:	0001c797          	auipc	a5,0x1c
    80005304:	90078793          	addi	a5,a5,-1792 # 80020c00 <cons>
    80005308:	0a07a703          	lw	a4,160(a5)
    8000530c:	0017069b          	addiw	a3,a4,1
    80005310:	0006861b          	sext.w	a2,a3
    80005314:	0ad7a023          	sw	a3,160(a5)
    80005318:	07f77713          	andi	a4,a4,127
    8000531c:	97ba                	add	a5,a5,a4
    8000531e:	4729                	li	a4,10
    80005320:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005324:	0001c797          	auipc	a5,0x1c
    80005328:	96c7ac23          	sw	a2,-1672(a5) # 80020c9c <cons+0x9c>
        wakeup(&cons.r);
    8000532c:	0001c517          	auipc	a0,0x1c
    80005330:	96c50513          	addi	a0,a0,-1684 # 80020c98 <cons+0x98>
    80005334:	950fc0ef          	jal	80001484 <wakeup>
    80005338:	bd6d                	j	800051f2 <consoleintr+0x32>

000000008000533a <consoleinit>:

void
consoleinit(void)
{
    8000533a:	1141                	addi	sp,sp,-16
    8000533c:	e406                	sd	ra,8(sp)
    8000533e:	e022                	sd	s0,0(sp)
    80005340:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005342:	00002597          	auipc	a1,0x2
    80005346:	42658593          	addi	a1,a1,1062 # 80007768 <etext+0x768>
    8000534a:	0001c517          	auipc	a0,0x1c
    8000534e:	8b650513          	addi	a0,a0,-1866 # 80020c00 <cons>
    80005352:	63e000ef          	jal	80005990 <initlock>

  uartinit();
    80005356:	3f4000ef          	jal	8000574a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000535a:	00012797          	auipc	a5,0x12
    8000535e:	70e78793          	addi	a5,a5,1806 # 80017a68 <devsw>
    80005362:	00000717          	auipc	a4,0x0
    80005366:	d2270713          	addi	a4,a4,-734 # 80005084 <consoleread>
    8000536a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000536c:	00000717          	auipc	a4,0x0
    80005370:	cb270713          	addi	a4,a4,-846 # 8000501e <consolewrite>
    80005374:	ef98                	sd	a4,24(a5)
}
    80005376:	60a2                	ld	ra,8(sp)
    80005378:	6402                	ld	s0,0(sp)
    8000537a:	0141                	addi	sp,sp,16
    8000537c:	8082                	ret

000000008000537e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000537e:	7179                	addi	sp,sp,-48
    80005380:	f406                	sd	ra,40(sp)
    80005382:	f022                	sd	s0,32(sp)
    80005384:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80005386:	c219                	beqz	a2,8000538c <printint+0xe>
    80005388:	08054063          	bltz	a0,80005408 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    8000538c:	4881                	li	a7,0
    8000538e:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005392:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80005394:	00002617          	auipc	a2,0x2
    80005398:	59c60613          	addi	a2,a2,1436 # 80007930 <digits>
    8000539c:	883e                	mv	a6,a5
    8000539e:	2785                	addiw	a5,a5,1
    800053a0:	02b57733          	remu	a4,a0,a1
    800053a4:	9732                	add	a4,a4,a2
    800053a6:	00074703          	lbu	a4,0(a4)
    800053aa:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    800053ae:	872a                	mv	a4,a0
    800053b0:	02b55533          	divu	a0,a0,a1
    800053b4:	0685                	addi	a3,a3,1
    800053b6:	feb773e3          	bgeu	a4,a1,8000539c <printint+0x1e>

  if(sign)
    800053ba:	00088a63          	beqz	a7,800053ce <printint+0x50>
    buf[i++] = '-';
    800053be:	1781                	addi	a5,a5,-32
    800053c0:	97a2                	add	a5,a5,s0
    800053c2:	02d00713          	li	a4,45
    800053c6:	fee78823          	sb	a4,-16(a5)
    800053ca:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    800053ce:	02f05963          	blez	a5,80005400 <printint+0x82>
    800053d2:	ec26                	sd	s1,24(sp)
    800053d4:	e84a                	sd	s2,16(sp)
    800053d6:	fd040713          	addi	a4,s0,-48
    800053da:	00f704b3          	add	s1,a4,a5
    800053de:	fff70913          	addi	s2,a4,-1
    800053e2:	993e                	add	s2,s2,a5
    800053e4:	37fd                	addiw	a5,a5,-1
    800053e6:	1782                	slli	a5,a5,0x20
    800053e8:	9381                	srli	a5,a5,0x20
    800053ea:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800053ee:	fff4c503          	lbu	a0,-1(s1)
    800053f2:	d9dff0ef          	jal	8000518e <consputc>
  while(--i >= 0)
    800053f6:	14fd                	addi	s1,s1,-1
    800053f8:	ff249be3          	bne	s1,s2,800053ee <printint+0x70>
    800053fc:	64e2                	ld	s1,24(sp)
    800053fe:	6942                	ld	s2,16(sp)
}
    80005400:	70a2                	ld	ra,40(sp)
    80005402:	7402                	ld	s0,32(sp)
    80005404:	6145                	addi	sp,sp,48
    80005406:	8082                	ret
    x = -xx;
    80005408:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    8000540c:	4885                	li	a7,1
    x = -xx;
    8000540e:	b741                	j	8000538e <printint+0x10>

0000000080005410 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005410:	7155                	addi	sp,sp,-208
    80005412:	e506                	sd	ra,136(sp)
    80005414:	e122                	sd	s0,128(sp)
    80005416:	f0d2                	sd	s4,96(sp)
    80005418:	0900                	addi	s0,sp,144
    8000541a:	8a2a                	mv	s4,a0
    8000541c:	e40c                	sd	a1,8(s0)
    8000541e:	e810                	sd	a2,16(s0)
    80005420:	ec14                	sd	a3,24(s0)
    80005422:	f018                	sd	a4,32(s0)
    80005424:	f41c                	sd	a5,40(s0)
    80005426:	03043823          	sd	a6,48(s0)
    8000542a:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    8000542e:	0001c797          	auipc	a5,0x1c
    80005432:	8927a783          	lw	a5,-1902(a5) # 80020cc0 <pr+0x18>
    80005436:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    8000543a:	e3a1                	bnez	a5,8000547a <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    8000543c:	00840793          	addi	a5,s0,8
    80005440:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005444:	00054503          	lbu	a0,0(a0)
    80005448:	26050763          	beqz	a0,800056b6 <printf+0x2a6>
    8000544c:	fca6                	sd	s1,120(sp)
    8000544e:	f8ca                	sd	s2,112(sp)
    80005450:	f4ce                	sd	s3,104(sp)
    80005452:	ecd6                	sd	s5,88(sp)
    80005454:	e8da                	sd	s6,80(sp)
    80005456:	e0e2                	sd	s8,64(sp)
    80005458:	fc66                	sd	s9,56(sp)
    8000545a:	f86a                	sd	s10,48(sp)
    8000545c:	f46e                	sd	s11,40(sp)
    8000545e:	4981                	li	s3,0
    if(cx != '%'){
    80005460:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80005464:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80005468:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000546c:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005470:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005474:	07000d93          	li	s11,112
    80005478:	a815                	j	800054ac <printf+0x9c>
    acquire(&pr.lock);
    8000547a:	0001c517          	auipc	a0,0x1c
    8000547e:	82e50513          	addi	a0,a0,-2002 # 80020ca8 <pr>
    80005482:	58e000ef          	jal	80005a10 <acquire>
  va_start(ap, fmt);
    80005486:	00840793          	addi	a5,s0,8
    8000548a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000548e:	000a4503          	lbu	a0,0(s4)
    80005492:	fd4d                	bnez	a0,8000544c <printf+0x3c>
    80005494:	a481                	j	800056d4 <printf+0x2c4>
      consputc(cx);
    80005496:	cf9ff0ef          	jal	8000518e <consputc>
      continue;
    8000549a:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000549c:	0014899b          	addiw	s3,s1,1
    800054a0:	013a07b3          	add	a5,s4,s3
    800054a4:	0007c503          	lbu	a0,0(a5)
    800054a8:	1e050b63          	beqz	a0,8000569e <printf+0x28e>
    if(cx != '%'){
    800054ac:	ff5515e3          	bne	a0,s5,80005496 <printf+0x86>
    i++;
    800054b0:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    800054b4:	009a07b3          	add	a5,s4,s1
    800054b8:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    800054bc:	1e090163          	beqz	s2,8000569e <printf+0x28e>
    800054c0:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    800054c4:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    800054c6:	c789                	beqz	a5,800054d0 <printf+0xc0>
    800054c8:	009a0733          	add	a4,s4,s1
    800054cc:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    800054d0:	03690763          	beq	s2,s6,800054fe <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    800054d4:	05890163          	beq	s2,s8,80005516 <printf+0x106>
    } else if(c0 == 'u'){
    800054d8:	0d990b63          	beq	s2,s9,800055ae <printf+0x19e>
    } else if(c0 == 'x'){
    800054dc:	13a90163          	beq	s2,s10,800055fe <printf+0x1ee>
    } else if(c0 == 'p'){
    800054e0:	13b90b63          	beq	s2,s11,80005616 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    800054e4:	07300793          	li	a5,115
    800054e8:	16f90a63          	beq	s2,a5,8000565c <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    800054ec:	1b590463          	beq	s2,s5,80005694 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800054f0:	8556                	mv	a0,s5
    800054f2:	c9dff0ef          	jal	8000518e <consputc>
      consputc(c0);
    800054f6:	854a                	mv	a0,s2
    800054f8:	c97ff0ef          	jal	8000518e <consputc>
    800054fc:	b745                	j	8000549c <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    800054fe:	f8843783          	ld	a5,-120(s0)
    80005502:	00878713          	addi	a4,a5,8
    80005506:	f8e43423          	sd	a4,-120(s0)
    8000550a:	4605                	li	a2,1
    8000550c:	45a9                	li	a1,10
    8000550e:	4388                	lw	a0,0(a5)
    80005510:	e6fff0ef          	jal	8000537e <printint>
    80005514:	b761                	j	8000549c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    80005516:	03678663          	beq	a5,s6,80005542 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000551a:	05878263          	beq	a5,s8,8000555e <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    8000551e:	0b978463          	beq	a5,s9,800055c6 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    80005522:	fda797e3          	bne	a5,s10,800054f0 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80005526:	f8843783          	ld	a5,-120(s0)
    8000552a:	00878713          	addi	a4,a5,8
    8000552e:	f8e43423          	sd	a4,-120(s0)
    80005532:	4601                	li	a2,0
    80005534:	45c1                	li	a1,16
    80005536:	6388                	ld	a0,0(a5)
    80005538:	e47ff0ef          	jal	8000537e <printint>
      i += 1;
    8000553c:	0029849b          	addiw	s1,s3,2
    80005540:	bfb1                	j	8000549c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005542:	f8843783          	ld	a5,-120(s0)
    80005546:	00878713          	addi	a4,a5,8
    8000554a:	f8e43423          	sd	a4,-120(s0)
    8000554e:	4605                	li	a2,1
    80005550:	45a9                	li	a1,10
    80005552:	6388                	ld	a0,0(a5)
    80005554:	e2bff0ef          	jal	8000537e <printint>
      i += 1;
    80005558:	0029849b          	addiw	s1,s3,2
    8000555c:	b781                	j	8000549c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000555e:	06400793          	li	a5,100
    80005562:	02f68863          	beq	a3,a5,80005592 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005566:	07500793          	li	a5,117
    8000556a:	06f68c63          	beq	a3,a5,800055e2 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000556e:	07800793          	li	a5,120
    80005572:	f6f69fe3          	bne	a3,a5,800054f0 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80005576:	f8843783          	ld	a5,-120(s0)
    8000557a:	00878713          	addi	a4,a5,8
    8000557e:	f8e43423          	sd	a4,-120(s0)
    80005582:	4601                	li	a2,0
    80005584:	45c1                	li	a1,16
    80005586:	6388                	ld	a0,0(a5)
    80005588:	df7ff0ef          	jal	8000537e <printint>
      i += 2;
    8000558c:	0039849b          	addiw	s1,s3,3
    80005590:	b731                	j	8000549c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005592:	f8843783          	ld	a5,-120(s0)
    80005596:	00878713          	addi	a4,a5,8
    8000559a:	f8e43423          	sd	a4,-120(s0)
    8000559e:	4605                	li	a2,1
    800055a0:	45a9                	li	a1,10
    800055a2:	6388                	ld	a0,0(a5)
    800055a4:	ddbff0ef          	jal	8000537e <printint>
      i += 2;
    800055a8:	0039849b          	addiw	s1,s3,3
    800055ac:	bdc5                	j	8000549c <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    800055ae:	f8843783          	ld	a5,-120(s0)
    800055b2:	00878713          	addi	a4,a5,8
    800055b6:	f8e43423          	sd	a4,-120(s0)
    800055ba:	4601                	li	a2,0
    800055bc:	45a9                	li	a1,10
    800055be:	4388                	lw	a0,0(a5)
    800055c0:	dbfff0ef          	jal	8000537e <printint>
    800055c4:	bde1                	j	8000549c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800055c6:	f8843783          	ld	a5,-120(s0)
    800055ca:	00878713          	addi	a4,a5,8
    800055ce:	f8e43423          	sd	a4,-120(s0)
    800055d2:	4601                	li	a2,0
    800055d4:	45a9                	li	a1,10
    800055d6:	6388                	ld	a0,0(a5)
    800055d8:	da7ff0ef          	jal	8000537e <printint>
      i += 1;
    800055dc:	0029849b          	addiw	s1,s3,2
    800055e0:	bd75                	j	8000549c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800055e2:	f8843783          	ld	a5,-120(s0)
    800055e6:	00878713          	addi	a4,a5,8
    800055ea:	f8e43423          	sd	a4,-120(s0)
    800055ee:	4601                	li	a2,0
    800055f0:	45a9                	li	a1,10
    800055f2:	6388                	ld	a0,0(a5)
    800055f4:	d8bff0ef          	jal	8000537e <printint>
      i += 2;
    800055f8:	0039849b          	addiw	s1,s3,3
    800055fc:	b545                	j	8000549c <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    800055fe:	f8843783          	ld	a5,-120(s0)
    80005602:	00878713          	addi	a4,a5,8
    80005606:	f8e43423          	sd	a4,-120(s0)
    8000560a:	4601                	li	a2,0
    8000560c:	45c1                	li	a1,16
    8000560e:	4388                	lw	a0,0(a5)
    80005610:	d6fff0ef          	jal	8000537e <printint>
    80005614:	b561                	j	8000549c <printf+0x8c>
    80005616:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    80005618:	f8843783          	ld	a5,-120(s0)
    8000561c:	00878713          	addi	a4,a5,8
    80005620:	f8e43423          	sd	a4,-120(s0)
    80005624:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005628:	03000513          	li	a0,48
    8000562c:	b63ff0ef          	jal	8000518e <consputc>
  consputc('x');
    80005630:	07800513          	li	a0,120
    80005634:	b5bff0ef          	jal	8000518e <consputc>
    80005638:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000563a:	00002b97          	auipc	s7,0x2
    8000563e:	2f6b8b93          	addi	s7,s7,758 # 80007930 <digits>
    80005642:	03c9d793          	srli	a5,s3,0x3c
    80005646:	97de                	add	a5,a5,s7
    80005648:	0007c503          	lbu	a0,0(a5)
    8000564c:	b43ff0ef          	jal	8000518e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005650:	0992                	slli	s3,s3,0x4
    80005652:	397d                	addiw	s2,s2,-1
    80005654:	fe0917e3          	bnez	s2,80005642 <printf+0x232>
    80005658:	6ba6                	ld	s7,72(sp)
    8000565a:	b589                	j	8000549c <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    8000565c:	f8843783          	ld	a5,-120(s0)
    80005660:	00878713          	addi	a4,a5,8
    80005664:	f8e43423          	sd	a4,-120(s0)
    80005668:	0007b903          	ld	s2,0(a5)
    8000566c:	00090d63          	beqz	s2,80005686 <printf+0x276>
      for(; *s; s++)
    80005670:	00094503          	lbu	a0,0(s2)
    80005674:	e20504e3          	beqz	a0,8000549c <printf+0x8c>
        consputc(*s);
    80005678:	b17ff0ef          	jal	8000518e <consputc>
      for(; *s; s++)
    8000567c:	0905                	addi	s2,s2,1
    8000567e:	00094503          	lbu	a0,0(s2)
    80005682:	f97d                	bnez	a0,80005678 <printf+0x268>
    80005684:	bd21                	j	8000549c <printf+0x8c>
        s = "(null)";
    80005686:	00002917          	auipc	s2,0x2
    8000568a:	0ea90913          	addi	s2,s2,234 # 80007770 <etext+0x770>
      for(; *s; s++)
    8000568e:	02800513          	li	a0,40
    80005692:	b7dd                	j	80005678 <printf+0x268>
      consputc('%');
    80005694:	02500513          	li	a0,37
    80005698:	af7ff0ef          	jal	8000518e <consputc>
    8000569c:	b501                	j	8000549c <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    8000569e:	f7843783          	ld	a5,-136(s0)
    800056a2:	e385                	bnez	a5,800056c2 <printf+0x2b2>
    800056a4:	74e6                	ld	s1,120(sp)
    800056a6:	7946                	ld	s2,112(sp)
    800056a8:	79a6                	ld	s3,104(sp)
    800056aa:	6ae6                	ld	s5,88(sp)
    800056ac:	6b46                	ld	s6,80(sp)
    800056ae:	6c06                	ld	s8,64(sp)
    800056b0:	7ce2                	ld	s9,56(sp)
    800056b2:	7d42                	ld	s10,48(sp)
    800056b4:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    800056b6:	4501                	li	a0,0
    800056b8:	60aa                	ld	ra,136(sp)
    800056ba:	640a                	ld	s0,128(sp)
    800056bc:	7a06                	ld	s4,96(sp)
    800056be:	6169                	addi	sp,sp,208
    800056c0:	8082                	ret
    800056c2:	74e6                	ld	s1,120(sp)
    800056c4:	7946                	ld	s2,112(sp)
    800056c6:	79a6                	ld	s3,104(sp)
    800056c8:	6ae6                	ld	s5,88(sp)
    800056ca:	6b46                	ld	s6,80(sp)
    800056cc:	6c06                	ld	s8,64(sp)
    800056ce:	7ce2                	ld	s9,56(sp)
    800056d0:	7d42                	ld	s10,48(sp)
    800056d2:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    800056d4:	0001b517          	auipc	a0,0x1b
    800056d8:	5d450513          	addi	a0,a0,1492 # 80020ca8 <pr>
    800056dc:	3cc000ef          	jal	80005aa8 <release>
    800056e0:	bfd9                	j	800056b6 <printf+0x2a6>

00000000800056e2 <panic>:

void
panic(char *s)
{
    800056e2:	1101                	addi	sp,sp,-32
    800056e4:	ec06                	sd	ra,24(sp)
    800056e6:	e822                	sd	s0,16(sp)
    800056e8:	e426                	sd	s1,8(sp)
    800056ea:	1000                	addi	s0,sp,32
    800056ec:	84aa                	mv	s1,a0
  pr.locking = 0;
    800056ee:	0001b797          	auipc	a5,0x1b
    800056f2:	5c07a923          	sw	zero,1490(a5) # 80020cc0 <pr+0x18>
  printf("panic: ");
    800056f6:	00002517          	auipc	a0,0x2
    800056fa:	08250513          	addi	a0,a0,130 # 80007778 <etext+0x778>
    800056fe:	d13ff0ef          	jal	80005410 <printf>
  printf("%s\n", s);
    80005702:	85a6                	mv	a1,s1
    80005704:	00002517          	auipc	a0,0x2
    80005708:	07c50513          	addi	a0,a0,124 # 80007780 <etext+0x780>
    8000570c:	d05ff0ef          	jal	80005410 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005710:	4785                	li	a5,1
    80005712:	00002717          	auipc	a4,0x2
    80005716:	2af72523          	sw	a5,682(a4) # 800079bc <panicked>
  for(;;)
    8000571a:	a001                	j	8000571a <panic+0x38>

000000008000571c <printfinit>:
    ;
}

void
printfinit(void)
{
    8000571c:	1101                	addi	sp,sp,-32
    8000571e:	ec06                	sd	ra,24(sp)
    80005720:	e822                	sd	s0,16(sp)
    80005722:	e426                	sd	s1,8(sp)
    80005724:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005726:	0001b497          	auipc	s1,0x1b
    8000572a:	58248493          	addi	s1,s1,1410 # 80020ca8 <pr>
    8000572e:	00002597          	auipc	a1,0x2
    80005732:	05a58593          	addi	a1,a1,90 # 80007788 <etext+0x788>
    80005736:	8526                	mv	a0,s1
    80005738:	258000ef          	jal	80005990 <initlock>
  pr.locking = 1;
    8000573c:	4785                	li	a5,1
    8000573e:	cc9c                	sw	a5,24(s1)
}
    80005740:	60e2                	ld	ra,24(sp)
    80005742:	6442                	ld	s0,16(sp)
    80005744:	64a2                	ld	s1,8(sp)
    80005746:	6105                	addi	sp,sp,32
    80005748:	8082                	ret

000000008000574a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000574a:	1141                	addi	sp,sp,-16
    8000574c:	e406                	sd	ra,8(sp)
    8000574e:	e022                	sd	s0,0(sp)
    80005750:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005752:	100007b7          	lui	a5,0x10000
    80005756:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000575a:	10000737          	lui	a4,0x10000
    8000575e:	f8000693          	li	a3,-128
    80005762:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005766:	468d                	li	a3,3
    80005768:	10000637          	lui	a2,0x10000
    8000576c:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005770:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005774:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005778:	10000737          	lui	a4,0x10000
    8000577c:	461d                	li	a2,7
    8000577e:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005782:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005786:	00002597          	auipc	a1,0x2
    8000578a:	00a58593          	addi	a1,a1,10 # 80007790 <etext+0x790>
    8000578e:	0001b517          	auipc	a0,0x1b
    80005792:	53a50513          	addi	a0,a0,1338 # 80020cc8 <uart_tx_lock>
    80005796:	1fa000ef          	jal	80005990 <initlock>
}
    8000579a:	60a2                	ld	ra,8(sp)
    8000579c:	6402                	ld	s0,0(sp)
    8000579e:	0141                	addi	sp,sp,16
    800057a0:	8082                	ret

00000000800057a2 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800057a2:	1101                	addi	sp,sp,-32
    800057a4:	ec06                	sd	ra,24(sp)
    800057a6:	e822                	sd	s0,16(sp)
    800057a8:	e426                	sd	s1,8(sp)
    800057aa:	1000                	addi	s0,sp,32
    800057ac:	84aa                	mv	s1,a0
  push_off();
    800057ae:	222000ef          	jal	800059d0 <push_off>

  if(panicked){
    800057b2:	00002797          	auipc	a5,0x2
    800057b6:	20a7a783          	lw	a5,522(a5) # 800079bc <panicked>
    800057ba:	e795                	bnez	a5,800057e6 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800057bc:	10000737          	lui	a4,0x10000
    800057c0:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800057c2:	00074783          	lbu	a5,0(a4)
    800057c6:	0207f793          	andi	a5,a5,32
    800057ca:	dfe5                	beqz	a5,800057c2 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    800057cc:	0ff4f513          	zext.b	a0,s1
    800057d0:	100007b7          	lui	a5,0x10000
    800057d4:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800057d8:	27c000ef          	jal	80005a54 <pop_off>
}
    800057dc:	60e2                	ld	ra,24(sp)
    800057de:	6442                	ld	s0,16(sp)
    800057e0:	64a2                	ld	s1,8(sp)
    800057e2:	6105                	addi	sp,sp,32
    800057e4:	8082                	ret
    for(;;)
    800057e6:	a001                	j	800057e6 <uartputc_sync+0x44>

00000000800057e8 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800057e8:	00002797          	auipc	a5,0x2
    800057ec:	1d87b783          	ld	a5,472(a5) # 800079c0 <uart_tx_r>
    800057f0:	00002717          	auipc	a4,0x2
    800057f4:	1d873703          	ld	a4,472(a4) # 800079c8 <uart_tx_w>
    800057f8:	08f70263          	beq	a4,a5,8000587c <uartstart+0x94>
{
    800057fc:	7139                	addi	sp,sp,-64
    800057fe:	fc06                	sd	ra,56(sp)
    80005800:	f822                	sd	s0,48(sp)
    80005802:	f426                	sd	s1,40(sp)
    80005804:	f04a                	sd	s2,32(sp)
    80005806:	ec4e                	sd	s3,24(sp)
    80005808:	e852                	sd	s4,16(sp)
    8000580a:	e456                	sd	s5,8(sp)
    8000580c:	e05a                	sd	s6,0(sp)
    8000580e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005810:	10000937          	lui	s2,0x10000
    80005814:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005816:	0001ba97          	auipc	s5,0x1b
    8000581a:	4b2a8a93          	addi	s5,s5,1202 # 80020cc8 <uart_tx_lock>
    uart_tx_r += 1;
    8000581e:	00002497          	auipc	s1,0x2
    80005822:	1a248493          	addi	s1,s1,418 # 800079c0 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005826:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000582a:	00002997          	auipc	s3,0x2
    8000582e:	19e98993          	addi	s3,s3,414 # 800079c8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005832:	00094703          	lbu	a4,0(s2)
    80005836:	02077713          	andi	a4,a4,32
    8000583a:	c71d                	beqz	a4,80005868 <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000583c:	01f7f713          	andi	a4,a5,31
    80005840:	9756                	add	a4,a4,s5
    80005842:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80005846:	0785                	addi	a5,a5,1
    80005848:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000584a:	8526                	mv	a0,s1
    8000584c:	c39fb0ef          	jal	80001484 <wakeup>
    WriteReg(THR, c);
    80005850:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80005854:	609c                	ld	a5,0(s1)
    80005856:	0009b703          	ld	a4,0(s3)
    8000585a:	fcf71ce3          	bne	a4,a5,80005832 <uartstart+0x4a>
      ReadReg(ISR);
    8000585e:	100007b7          	lui	a5,0x10000
    80005862:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005864:	0007c783          	lbu	a5,0(a5)
  }
}
    80005868:	70e2                	ld	ra,56(sp)
    8000586a:	7442                	ld	s0,48(sp)
    8000586c:	74a2                	ld	s1,40(sp)
    8000586e:	7902                	ld	s2,32(sp)
    80005870:	69e2                	ld	s3,24(sp)
    80005872:	6a42                	ld	s4,16(sp)
    80005874:	6aa2                	ld	s5,8(sp)
    80005876:	6b02                	ld	s6,0(sp)
    80005878:	6121                	addi	sp,sp,64
    8000587a:	8082                	ret
      ReadReg(ISR);
    8000587c:	100007b7          	lui	a5,0x10000
    80005880:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005882:	0007c783          	lbu	a5,0(a5)
      return;
    80005886:	8082                	ret

0000000080005888 <uartputc>:
{
    80005888:	7179                	addi	sp,sp,-48
    8000588a:	f406                	sd	ra,40(sp)
    8000588c:	f022                	sd	s0,32(sp)
    8000588e:	ec26                	sd	s1,24(sp)
    80005890:	e84a                	sd	s2,16(sp)
    80005892:	e44e                	sd	s3,8(sp)
    80005894:	e052                	sd	s4,0(sp)
    80005896:	1800                	addi	s0,sp,48
    80005898:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000589a:	0001b517          	auipc	a0,0x1b
    8000589e:	42e50513          	addi	a0,a0,1070 # 80020cc8 <uart_tx_lock>
    800058a2:	16e000ef          	jal	80005a10 <acquire>
  if(panicked){
    800058a6:	00002797          	auipc	a5,0x2
    800058aa:	1167a783          	lw	a5,278(a5) # 800079bc <panicked>
    800058ae:	efbd                	bnez	a5,8000592c <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800058b0:	00002717          	auipc	a4,0x2
    800058b4:	11873703          	ld	a4,280(a4) # 800079c8 <uart_tx_w>
    800058b8:	00002797          	auipc	a5,0x2
    800058bc:	1087b783          	ld	a5,264(a5) # 800079c0 <uart_tx_r>
    800058c0:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800058c4:	0001b997          	auipc	s3,0x1b
    800058c8:	40498993          	addi	s3,s3,1028 # 80020cc8 <uart_tx_lock>
    800058cc:	00002497          	auipc	s1,0x2
    800058d0:	0f448493          	addi	s1,s1,244 # 800079c0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800058d4:	00002917          	auipc	s2,0x2
    800058d8:	0f490913          	addi	s2,s2,244 # 800079c8 <uart_tx_w>
    800058dc:	00e79d63          	bne	a5,a4,800058f6 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    800058e0:	85ce                	mv	a1,s3
    800058e2:	8526                	mv	a0,s1
    800058e4:	b55fb0ef          	jal	80001438 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800058e8:	00093703          	ld	a4,0(s2)
    800058ec:	609c                	ld	a5,0(s1)
    800058ee:	02078793          	addi	a5,a5,32
    800058f2:	fee787e3          	beq	a5,a4,800058e0 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800058f6:	0001b497          	auipc	s1,0x1b
    800058fa:	3d248493          	addi	s1,s1,978 # 80020cc8 <uart_tx_lock>
    800058fe:	01f77793          	andi	a5,a4,31
    80005902:	97a6                	add	a5,a5,s1
    80005904:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005908:	0705                	addi	a4,a4,1
    8000590a:	00002797          	auipc	a5,0x2
    8000590e:	0ae7bf23          	sd	a4,190(a5) # 800079c8 <uart_tx_w>
  uartstart();
    80005912:	ed7ff0ef          	jal	800057e8 <uartstart>
  release(&uart_tx_lock);
    80005916:	8526                	mv	a0,s1
    80005918:	190000ef          	jal	80005aa8 <release>
}
    8000591c:	70a2                	ld	ra,40(sp)
    8000591e:	7402                	ld	s0,32(sp)
    80005920:	64e2                	ld	s1,24(sp)
    80005922:	6942                	ld	s2,16(sp)
    80005924:	69a2                	ld	s3,8(sp)
    80005926:	6a02                	ld	s4,0(sp)
    80005928:	6145                	addi	sp,sp,48
    8000592a:	8082                	ret
    for(;;)
    8000592c:	a001                	j	8000592c <uartputc+0xa4>

000000008000592e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000592e:	1141                	addi	sp,sp,-16
    80005930:	e422                	sd	s0,8(sp)
    80005932:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005934:	100007b7          	lui	a5,0x10000
    80005938:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    8000593a:	0007c783          	lbu	a5,0(a5)
    8000593e:	8b85                	andi	a5,a5,1
    80005940:	cb81                	beqz	a5,80005950 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80005942:	100007b7          	lui	a5,0x10000
    80005946:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000594a:	6422                	ld	s0,8(sp)
    8000594c:	0141                	addi	sp,sp,16
    8000594e:	8082                	ret
    return -1;
    80005950:	557d                	li	a0,-1
    80005952:	bfe5                	j	8000594a <uartgetc+0x1c>

0000000080005954 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005954:	1101                	addi	sp,sp,-32
    80005956:	ec06                	sd	ra,24(sp)
    80005958:	e822                	sd	s0,16(sp)
    8000595a:	e426                	sd	s1,8(sp)
    8000595c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000595e:	54fd                	li	s1,-1
    80005960:	a019                	j	80005966 <uartintr+0x12>
      break;
    consoleintr(c);
    80005962:	85fff0ef          	jal	800051c0 <consoleintr>
    int c = uartgetc();
    80005966:	fc9ff0ef          	jal	8000592e <uartgetc>
    if(c == -1)
    8000596a:	fe951ce3          	bne	a0,s1,80005962 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000596e:	0001b497          	auipc	s1,0x1b
    80005972:	35a48493          	addi	s1,s1,858 # 80020cc8 <uart_tx_lock>
    80005976:	8526                	mv	a0,s1
    80005978:	098000ef          	jal	80005a10 <acquire>
  uartstart();
    8000597c:	e6dff0ef          	jal	800057e8 <uartstart>
  release(&uart_tx_lock);
    80005980:	8526                	mv	a0,s1
    80005982:	126000ef          	jal	80005aa8 <release>
}
    80005986:	60e2                	ld	ra,24(sp)
    80005988:	6442                	ld	s0,16(sp)
    8000598a:	64a2                	ld	s1,8(sp)
    8000598c:	6105                	addi	sp,sp,32
    8000598e:	8082                	ret

0000000080005990 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005990:	1141                	addi	sp,sp,-16
    80005992:	e422                	sd	s0,8(sp)
    80005994:	0800                	addi	s0,sp,16
  lk->name = name;
    80005996:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005998:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000599c:	00053823          	sd	zero,16(a0)
}
    800059a0:	6422                	ld	s0,8(sp)
    800059a2:	0141                	addi	sp,sp,16
    800059a4:	8082                	ret

00000000800059a6 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800059a6:	411c                	lw	a5,0(a0)
    800059a8:	e399                	bnez	a5,800059ae <holding+0x8>
    800059aa:	4501                	li	a0,0
  return r;
}
    800059ac:	8082                	ret
{
    800059ae:	1101                	addi	sp,sp,-32
    800059b0:	ec06                	sd	ra,24(sp)
    800059b2:	e822                	sd	s0,16(sp)
    800059b4:	e426                	sd	s1,8(sp)
    800059b6:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800059b8:	6904                	ld	s1,16(a0)
    800059ba:	c94fb0ef          	jal	80000e4e <mycpu>
    800059be:	40a48533          	sub	a0,s1,a0
    800059c2:	00153513          	seqz	a0,a0
}
    800059c6:	60e2                	ld	ra,24(sp)
    800059c8:	6442                	ld	s0,16(sp)
    800059ca:	64a2                	ld	s1,8(sp)
    800059cc:	6105                	addi	sp,sp,32
    800059ce:	8082                	ret

00000000800059d0 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800059d0:	1101                	addi	sp,sp,-32
    800059d2:	ec06                	sd	ra,24(sp)
    800059d4:	e822                	sd	s0,16(sp)
    800059d6:	e426                	sd	s1,8(sp)
    800059d8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800059da:	100024f3          	csrr	s1,sstatus
    800059de:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800059e2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800059e4:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800059e8:	c66fb0ef          	jal	80000e4e <mycpu>
    800059ec:	5d3c                	lw	a5,120(a0)
    800059ee:	cb99                	beqz	a5,80005a04 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800059f0:	c5efb0ef          	jal	80000e4e <mycpu>
    800059f4:	5d3c                	lw	a5,120(a0)
    800059f6:	2785                	addiw	a5,a5,1
    800059f8:	dd3c                	sw	a5,120(a0)
}
    800059fa:	60e2                	ld	ra,24(sp)
    800059fc:	6442                	ld	s0,16(sp)
    800059fe:	64a2                	ld	s1,8(sp)
    80005a00:	6105                	addi	sp,sp,32
    80005a02:	8082                	ret
    mycpu()->intena = old;
    80005a04:	c4afb0ef          	jal	80000e4e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80005a08:	8085                	srli	s1,s1,0x1
    80005a0a:	8885                	andi	s1,s1,1
    80005a0c:	dd64                	sw	s1,124(a0)
    80005a0e:	b7cd                	j	800059f0 <push_off+0x20>

0000000080005a10 <acquire>:
{
    80005a10:	1101                	addi	sp,sp,-32
    80005a12:	ec06                	sd	ra,24(sp)
    80005a14:	e822                	sd	s0,16(sp)
    80005a16:	e426                	sd	s1,8(sp)
    80005a18:	1000                	addi	s0,sp,32
    80005a1a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005a1c:	fb5ff0ef          	jal	800059d0 <push_off>
  if(holding(lk))
    80005a20:	8526                	mv	a0,s1
    80005a22:	f85ff0ef          	jal	800059a6 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005a26:	4705                	li	a4,1
  if(holding(lk))
    80005a28:	e105                	bnez	a0,80005a48 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005a2a:	87ba                	mv	a5,a4
    80005a2c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005a30:	2781                	sext.w	a5,a5
    80005a32:	ffe5                	bnez	a5,80005a2a <acquire+0x1a>
  __sync_synchronize();
    80005a34:	0ff0000f          	fence
  lk->cpu = mycpu();
    80005a38:	c16fb0ef          	jal	80000e4e <mycpu>
    80005a3c:	e888                	sd	a0,16(s1)
}
    80005a3e:	60e2                	ld	ra,24(sp)
    80005a40:	6442                	ld	s0,16(sp)
    80005a42:	64a2                	ld	s1,8(sp)
    80005a44:	6105                	addi	sp,sp,32
    80005a46:	8082                	ret
    panic("acquire");
    80005a48:	00002517          	auipc	a0,0x2
    80005a4c:	d5050513          	addi	a0,a0,-688 # 80007798 <etext+0x798>
    80005a50:	c93ff0ef          	jal	800056e2 <panic>

0000000080005a54 <pop_off>:

void
pop_off(void)
{
    80005a54:	1141                	addi	sp,sp,-16
    80005a56:	e406                	sd	ra,8(sp)
    80005a58:	e022                	sd	s0,0(sp)
    80005a5a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005a5c:	bf2fb0ef          	jal	80000e4e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005a60:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005a64:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005a66:	e78d                	bnez	a5,80005a90 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005a68:	5d3c                	lw	a5,120(a0)
    80005a6a:	02f05963          	blez	a5,80005a9c <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80005a6e:	37fd                	addiw	a5,a5,-1
    80005a70:	0007871b          	sext.w	a4,a5
    80005a74:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005a76:	eb09                	bnez	a4,80005a88 <pop_off+0x34>
    80005a78:	5d7c                	lw	a5,124(a0)
    80005a7a:	c799                	beqz	a5,80005a88 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005a7c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005a80:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005a84:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005a88:	60a2                	ld	ra,8(sp)
    80005a8a:	6402                	ld	s0,0(sp)
    80005a8c:	0141                	addi	sp,sp,16
    80005a8e:	8082                	ret
    panic("pop_off - interruptible");
    80005a90:	00002517          	auipc	a0,0x2
    80005a94:	d1050513          	addi	a0,a0,-752 # 800077a0 <etext+0x7a0>
    80005a98:	c4bff0ef          	jal	800056e2 <panic>
    panic("pop_off");
    80005a9c:	00002517          	auipc	a0,0x2
    80005aa0:	d1c50513          	addi	a0,a0,-740 # 800077b8 <etext+0x7b8>
    80005aa4:	c3fff0ef          	jal	800056e2 <panic>

0000000080005aa8 <release>:
{
    80005aa8:	1101                	addi	sp,sp,-32
    80005aaa:	ec06                	sd	ra,24(sp)
    80005aac:	e822                	sd	s0,16(sp)
    80005aae:	e426                	sd	s1,8(sp)
    80005ab0:	1000                	addi	s0,sp,32
    80005ab2:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005ab4:	ef3ff0ef          	jal	800059a6 <holding>
    80005ab8:	c105                	beqz	a0,80005ad8 <release+0x30>
  lk->cpu = 0;
    80005aba:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80005abe:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80005ac2:	0f50000f          	fence	iorw,ow
    80005ac6:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80005aca:	f8bff0ef          	jal	80005a54 <pop_off>
}
    80005ace:	60e2                	ld	ra,24(sp)
    80005ad0:	6442                	ld	s0,16(sp)
    80005ad2:	64a2                	ld	s1,8(sp)
    80005ad4:	6105                	addi	sp,sp,32
    80005ad6:	8082                	ret
    panic("release");
    80005ad8:	00002517          	auipc	a0,0x2
    80005adc:	ce850513          	addi	a0,a0,-792 # 800077c0 <etext+0x7c0>
    80005ae0:	c03ff0ef          	jal	800056e2 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
