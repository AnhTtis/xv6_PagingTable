
user/_pgtbltest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <err>:

char *testname = "???";

void
err(char *why)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	84aa                	mv	s1,a0
  printf("pgtbltest: %s failed: %s, pid=%d\n", testname, why, getpid());
   e:	00001917          	auipc	s2,0x1
  12:	ff293903          	ld	s2,-14(s2) # 1000 <testname>
  16:	63e000ef          	jal	654 <getpid>
  1a:	86aa                	mv	a3,a0
  1c:	8626                	mv	a2,s1
  1e:	85ca                	mv	a1,s2
  20:	00001517          	auipc	a0,0x1
  24:	bc050513          	addi	a0,a0,-1088 # be0 <malloc+0x100>
  28:	205000ef          	jal	a2c <printf>
  exit(1);
  2c:	4505                	li	a0,1
  2e:	5a6000ef          	jal	5d4 <exit>

0000000000000032 <print_pte>:
}

void
print_pte(uint64 va)
{
  32:	1101                	addi	sp,sp,-32
  34:	ec06                	sd	ra,24(sp)
  36:	e822                	sd	s0,16(sp)
  38:	e426                	sd	s1,8(sp)
  3a:	1000                	addi	s0,sp,32
  3c:	84aa                	mv	s1,a0
    pte_t pte = (pte_t) pgpte((void *) va);
  3e:	658000ef          	jal	696 <pgpte>
  42:	862a                	mv	a2,a0
    printf("va 0x%lx pte 0x%lx pa 0x%lx perm 0x%lx\n", va, pte, PTE2PA(pte), PTE_FLAGS(pte));
  44:	00a55693          	srli	a3,a0,0xa
  48:	3ff57713          	andi	a4,a0,1023
  4c:	06b2                	slli	a3,a3,0xc
  4e:	85a6                	mv	a1,s1
  50:	00001517          	auipc	a0,0x1
  54:	bb850513          	addi	a0,a0,-1096 # c08 <malloc+0x128>
  58:	1d5000ef          	jal	a2c <printf>
}
  5c:	60e2                	ld	ra,24(sp)
  5e:	6442                	ld	s0,16(sp)
  60:	64a2                	ld	s1,8(sp)
  62:	6105                	addi	sp,sp,32
  64:	8082                	ret

0000000000000066 <print_pgtbl>:

void
print_pgtbl()
{
  66:	7179                	addi	sp,sp,-48
  68:	f406                	sd	ra,40(sp)
  6a:	f022                	sd	s0,32(sp)
  6c:	ec26                	sd	s1,24(sp)
  6e:	e84a                	sd	s2,16(sp)
  70:	e44e                	sd	s3,8(sp)
  72:	1800                	addi	s0,sp,48
  printf("print_pgtbl starting\n");
  74:	00001517          	auipc	a0,0x1
  78:	bbc50513          	addi	a0,a0,-1092 # c30 <malloc+0x150>
  7c:	1b1000ef          	jal	a2c <printf>
  80:	4481                	li	s1,0
  for (uint64 i = 0; i < 10; i++) {
  82:	6985                	lui	s3,0x1
  84:	6929                	lui	s2,0xa
    print_pte(i * PGSIZE);
  86:	8526                	mv	a0,s1
  88:	fabff0ef          	jal	32 <print_pte>
  for (uint64 i = 0; i < 10; i++) {
  8c:	94ce                	add	s1,s1,s3
  8e:	ff249ce3          	bne	s1,s2,86 <print_pgtbl+0x20>
  92:	020004b7          	lui	s1,0x2000
  96:	14ed                	addi	s1,s1,-5 # 1fffffb <base+0x1ffefdb>
  98:	04b6                	slli	s1,s1,0xd
  }
  uint64 top = MAXVA/PGSIZE;
  for (uint64 i = top-10; i < top; i++) {
  9a:	6985                	lui	s3,0x1
  9c:	4905                	li	s2,1
  9e:	191a                	slli	s2,s2,0x26
    print_pte(i * PGSIZE);
  a0:	8526                	mv	a0,s1
  a2:	f91ff0ef          	jal	32 <print_pte>
  for (uint64 i = top-10; i < top; i++) {
  a6:	94ce                	add	s1,s1,s3
  a8:	ff249ce3          	bne	s1,s2,a0 <print_pgtbl+0x3a>
  }
  printf("print_pgtbl: OK\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	b9c50513          	addi	a0,a0,-1124 # c48 <malloc+0x168>
  b4:	179000ef          	jal	a2c <printf>
}
  b8:	70a2                	ld	ra,40(sp)
  ba:	7402                	ld	s0,32(sp)
  bc:	64e2                	ld	s1,24(sp)
  be:	6942                	ld	s2,16(sp)
  c0:	69a2                	ld	s3,8(sp)
  c2:	6145                	addi	sp,sp,48
  c4:	8082                	ret

00000000000000c6 <ugetpid_test>:

void
ugetpid_test()
{
  c6:	7179                	addi	sp,sp,-48
  c8:	f406                	sd	ra,40(sp)
  ca:	f022                	sd	s0,32(sp)
  cc:	ec26                	sd	s1,24(sp)
  ce:	1800                	addi	s0,sp,48
  int i;

  printf("ugetpid_test starting\n");
  d0:	00001517          	auipc	a0,0x1
  d4:	b9050513          	addi	a0,a0,-1136 # c60 <malloc+0x180>
  d8:	155000ef          	jal	a2c <printf>
  testname = "ugetpid_test";
  dc:	00001797          	auipc	a5,0x1
  e0:	b9c78793          	addi	a5,a5,-1124 # c78 <malloc+0x198>
  e4:	00001717          	auipc	a4,0x1
  e8:	f0f73e23          	sd	a5,-228(a4) # 1000 <testname>
  ec:	04000493          	li	s1,64

  for (i = 0; i < 64; i++) {
    int ret = fork();
  f0:	4dc000ef          	jal	5cc <fork>
  f4:	fca42e23          	sw	a0,-36(s0)
    if (ret != 0) {
  f8:	c905                	beqz	a0,128 <ugetpid_test+0x62>
      wait(&ret);
  fa:	fdc40513          	addi	a0,s0,-36
  fe:	4de000ef          	jal	5dc <wait>
      if (ret != 0)
 102:	fdc42783          	lw	a5,-36(s0)
 106:	ef91                	bnez	a5,122 <ugetpid_test+0x5c>
  for (i = 0; i < 64; i++) {
 108:	34fd                	addiw	s1,s1,-1
 10a:	f0fd                	bnez	s1,f0 <ugetpid_test+0x2a>
    }
    if (getpid() != ugetpid())
      err("missmatched PID");
    exit(0);
  }
  printf("ugetpid_test: OK\n");
 10c:	00001517          	auipc	a0,0x1
 110:	b8c50513          	addi	a0,a0,-1140 # c98 <malloc+0x1b8>
 114:	119000ef          	jal	a2c <printf>
}
 118:	70a2                	ld	ra,40(sp)
 11a:	7402                	ld	s0,32(sp)
 11c:	64e2                	ld	s1,24(sp)
 11e:	6145                	addi	sp,sp,48
 120:	8082                	ret
        exit(1);
 122:	4505                	li	a0,1
 124:	4b0000ef          	jal	5d4 <exit>
    if (getpid() != ugetpid())
 128:	52c000ef          	jal	654 <getpid>
 12c:	84aa                	mv	s1,a0
 12e:	488000ef          	jal	5b6 <ugetpid>
 132:	00a48863          	beq	s1,a0,142 <ugetpid_test+0x7c>
      err("missmatched PID");
 136:	00001517          	auipc	a0,0x1
 13a:	b5250513          	addi	a0,a0,-1198 # c88 <malloc+0x1a8>
 13e:	ec3ff0ef          	jal	0 <err>
    exit(0);
 142:	4501                	li	a0,0
 144:	490000ef          	jal	5d4 <exit>

0000000000000148 <print_kpgtbl>:

void
print_kpgtbl()
{
 148:	1141                	addi	sp,sp,-16
 14a:	e406                	sd	ra,8(sp)
 14c:	e022                	sd	s0,0(sp)
 14e:	0800                	addi	s0,sp,16
  printf("print_kpgtbl starting\n");
 150:	00001517          	auipc	a0,0x1
 154:	b6050513          	addi	a0,a0,-1184 # cb0 <malloc+0x1d0>
 158:	0d5000ef          	jal	a2c <printf>
  kpgtbl();
 15c:	544000ef          	jal	6a0 <kpgtbl>
  printf("print_kpgtbl: OK\n");
 160:	00001517          	auipc	a0,0x1
 164:	b6850513          	addi	a0,a0,-1176 # cc8 <malloc+0x1e8>
 168:	0c5000ef          	jal	a2c <printf>
}
 16c:	60a2                	ld	ra,8(sp)
 16e:	6402                	ld	s0,0(sp)
 170:	0141                	addi	sp,sp,16
 172:	8082                	ret

0000000000000174 <supercheck>:


void
supercheck(uint64 s)
{
 174:	7139                	addi	sp,sp,-64
 176:	fc06                	sd	ra,56(sp)
 178:	f822                	sd	s0,48(sp)
 17a:	ec4e                	sd	s3,24(sp)
 17c:	e05a                	sd	s6,0(sp)
 17e:	0080                	addi	s0,sp,64
 180:	8b2a                	mv	s6,a0
  pte_t last_pte = 0;

  for (uint64 p = s;  p < s + 512 * PGSIZE; p += PGSIZE) {
 182:	002009b7          	lui	s3,0x200
 186:	99aa                	add	s3,s3,a0
 188:	ffe007b7          	lui	a5,0xffe00
 18c:	06f57163          	bgeu	a0,a5,1ee <supercheck+0x7a>
 190:	f426                	sd	s1,40(sp)
 192:	f04a                	sd	s2,32(sp)
 194:	e852                	sd	s4,16(sp)
 196:	e456                	sd	s5,8(sp)
 198:	84aa                	mv	s1,a0
  pte_t last_pte = 0;
 19a:	4501                	li	a0,0
    if(pte == 0)
      err("no pte");
    if ((uint64) last_pte != 0 && pte != last_pte) {
        err("pte different");
    }
    if((pte & PTE_V) == 0 || (pte & PTE_R) == 0 || (pte & PTE_W) == 0){
 19c:	4a9d                	li	s5,7
  for (uint64 p = s;  p < s + 512 * PGSIZE; p += PGSIZE) {
 19e:	6a05                	lui	s4,0x1
 1a0:	a831                	j	1bc <supercheck+0x48>
      err("no pte");
 1a2:	00001517          	auipc	a0,0x1
 1a6:	b3e50513          	addi	a0,a0,-1218 # ce0 <malloc+0x200>
 1aa:	e57ff0ef          	jal	0 <err>
    if((pte & PTE_V) == 0 || (pte & PTE_R) == 0 || (pte & PTE_W) == 0){
 1ae:	00757793          	andi	a5,a0,7
 1b2:	03579463          	bne	a5,s5,1da <supercheck+0x66>
  for (uint64 p = s;  p < s + 512 * PGSIZE; p += PGSIZE) {
 1b6:	94d2                	add	s1,s1,s4
 1b8:	0334f763          	bgeu	s1,s3,1e6 <supercheck+0x72>
    pte_t pte = (pte_t) pgpte((void *) p);
 1bc:	892a                	mv	s2,a0
 1be:	8526                	mv	a0,s1
 1c0:	4d6000ef          	jal	696 <pgpte>
    if(pte == 0)
 1c4:	dd79                	beqz	a0,1a2 <supercheck+0x2e>
    if ((uint64) last_pte != 0 && pte != last_pte) {
 1c6:	fe0904e3          	beqz	s2,1ae <supercheck+0x3a>
 1ca:	ff2502e3          	beq	a0,s2,1ae <supercheck+0x3a>
        err("pte different");
 1ce:	00001517          	auipc	a0,0x1
 1d2:	b1a50513          	addi	a0,a0,-1254 # ce8 <malloc+0x208>
 1d6:	e2bff0ef          	jal	0 <err>
      err("pte wrong");
 1da:	00001517          	auipc	a0,0x1
 1de:	b1e50513          	addi	a0,a0,-1250 # cf8 <malloc+0x218>
 1e2:	e1fff0ef          	jal	0 <err>
 1e6:	74a2                	ld	s1,40(sp)
 1e8:	7902                	ld	s2,32(sp)
 1ea:	6a42                	ld	s4,16(sp)
 1ec:	6aa2                	ld	s5,8(sp)
    }
    last_pte = pte;
  }

  for(int i = 0; i < 512; i += PGSIZE){
    *(int*)(s+i) = i;
 1ee:	000b2023          	sw	zero,0(s6)

  for(int i = 0; i < 512; i += PGSIZE){
    if(*(int*)(s+i) != i)
      err("wrong value");
  }
}
 1f2:	70e2                	ld	ra,56(sp)
 1f4:	7442                	ld	s0,48(sp)
 1f6:	69e2                	ld	s3,24(sp)
 1f8:	6b02                	ld	s6,0(sp)
 1fa:	6121                	addi	sp,sp,64
 1fc:	8082                	ret

00000000000001fe <superpg_test>:

void
superpg_test()
{
 1fe:	7179                	addi	sp,sp,-48
 200:	f406                	sd	ra,40(sp)
 202:	f022                	sd	s0,32(sp)
 204:	ec26                	sd	s1,24(sp)
 206:	1800                	addi	s0,sp,48
  int pid;
  
  printf("superpg_test starting\n");
 208:	00001517          	auipc	a0,0x1
 20c:	b0050513          	addi	a0,a0,-1280 # d08 <malloc+0x228>
 210:	01d000ef          	jal	a2c <printf>
  testname = "superpg_test";
 214:	00001797          	auipc	a5,0x1
 218:	b0c78793          	addi	a5,a5,-1268 # d20 <malloc+0x240>
 21c:	00001717          	auipc	a4,0x1
 220:	def73223          	sd	a5,-540(a4) # 1000 <testname>
  
  char *end = sbrk(N);
 224:	00800537          	lui	a0,0x800
 228:	434000ef          	jal	65c <sbrk>
  if (end == 0 || end == (char*)0xffffffffffffffff)
 22c:	fff50713          	addi	a4,a0,-1 # 7fffff <base+0x7fefdf>
 230:	57f5                	li	a5,-3
 232:	04e7e463          	bltu	a5,a4,27a <superpg_test+0x7c>
    err("sbrk failed");
  
  uint64 s = SUPERPGROUNDUP((uint64) end);
 236:	002007b7          	lui	a5,0x200
 23a:	17fd                	addi	a5,a5,-1 # 1fffff <base+0x1fefdf>
 23c:	953e                	add	a0,a0,a5
 23e:	ffe007b7          	lui	a5,0xffe00
 242:	00f574b3          	and	s1,a0,a5
  supercheck(s);
 246:	8526                	mv	a0,s1
 248:	f2dff0ef          	jal	174 <supercheck>
  if((pid = fork()) < 0) {
 24c:	380000ef          	jal	5cc <fork>
 250:	02054b63          	bltz	a0,286 <superpg_test+0x88>
    err("fork");
  } else if(pid == 0) {
 254:	cd1d                	beqz	a0,292 <superpg_test+0x94>
    supercheck(s);
    exit(0);
  } else {
    int status;
    wait(&status);
 256:	fdc40513          	addi	a0,s0,-36
 25a:	382000ef          	jal	5dc <wait>
    if (status != 0) {
 25e:	fdc42783          	lw	a5,-36(s0)
 262:	ef95                	bnez	a5,29e <superpg_test+0xa0>
      exit(0);
    }
  }
  printf("superpg_test: OK\n");  
 264:	00001517          	auipc	a0,0x1
 268:	ae450513          	addi	a0,a0,-1308 # d48 <malloc+0x268>
 26c:	7c0000ef          	jal	a2c <printf>
}
 270:	70a2                	ld	ra,40(sp)
 272:	7402                	ld	s0,32(sp)
 274:	64e2                	ld	s1,24(sp)
 276:	6145                	addi	sp,sp,48
 278:	8082                	ret
    err("sbrk failed");
 27a:	00001517          	auipc	a0,0x1
 27e:	ab650513          	addi	a0,a0,-1354 # d30 <malloc+0x250>
 282:	d7fff0ef          	jal	0 <err>
    err("fork");
 286:	00001517          	auipc	a0,0x1
 28a:	aba50513          	addi	a0,a0,-1350 # d40 <malloc+0x260>
 28e:	d73ff0ef          	jal	0 <err>
    supercheck(s);
 292:	8526                	mv	a0,s1
 294:	ee1ff0ef          	jal	174 <supercheck>
    exit(0);
 298:	4501                	li	a0,0
 29a:	33a000ef          	jal	5d4 <exit>
      exit(0);
 29e:	4501                	li	a0,0
 2a0:	334000ef          	jal	5d4 <exit>

00000000000002a4 <pgaccess_test>:

void pgaccess_test() {
 2a4:	1101                	addi	sp,sp,-32
 2a6:	ec06                	sd	ra,24(sp)
 2a8:	e822                	sd	s0,16(sp)
 2aa:	1000                	addi	s0,sp,32
  printf("pgaccess_test starting\n");
 2ac:	00001517          	auipc	a0,0x1
 2b0:	ab450513          	addi	a0,a0,-1356 # d60 <malloc+0x280>
 2b4:	778000ef          	jal	a2c <printf>
  testname = "pgaccess_test";
 2b8:	00001797          	auipc	a5,0x1
 2bc:	ac078793          	addi	a5,a5,-1344 # d78 <malloc+0x298>
 2c0:	00001717          	auipc	a4,0x1
 2c4:	d4f73023          	sd	a5,-704(a4) # 1000 <testname>

  int num_pages = 5;
  uint64 mask = 0;
 2c8:	fe043423          	sd	zero,-24(s0)
  
  // Allocate memory for at least `num_pages`
  char *buf = sbrk(num_pages * PGSIZE);
 2cc:	6515                	lui	a0,0x5
 2ce:	38e000ef          	jal	65c <sbrk>
  if (buf == (char*)-1)
 2d2:	57fd                	li	a5,-1
 2d4:	04f50563          	beq	a0,a5,31e <pgaccess_test+0x7a>
    err("sbrk failed");

  // Touch some pages to set the access bit
  buf[0] = 1;                   // Page 0
 2d8:	4785                	li	a5,1
 2da:	00f50023          	sb	a5,0(a0) # 5000 <base+0x3fe0>
  buf[PGSIZE * 2] = 2;          // Page 2
 2de:	6789                	lui	a5,0x2
 2e0:	97aa                	add	a5,a5,a0
 2e2:	4709                	li	a4,2
 2e4:	00e78023          	sb	a4,0(a5) # 2000 <base+0xfe0>
  buf[PGSIZE * 4] = 3;          // Page 4
 2e8:	6791                	lui	a5,0x4
 2ea:	97aa                	add	a5,a5,a0
 2ec:	470d                	li	a4,3
 2ee:	00e78023          	sb	a4,0(a5) # 4000 <base+0x2fe0>

  // Call pgaccess to check accessed pages
  if (pgaccess(buf, num_pages, &mask) < 0)
 2f2:	fe840613          	addi	a2,s0,-24
 2f6:	4595                	li	a1,5
 2f8:	3b2000ef          	jal	6aa <pgaccess>
 2fc:	02054763          	bltz	a0,32a <pgaccess_test+0x86>
    err("pgaccess syscall failed");

  // Expected bitmask: 0b10101 (Page 0, 2, and 4 accessed)
  if (mask != 0b10101)
 300:	fe843703          	ld	a4,-24(s0)
 304:	47d5                	li	a5,21
 306:	02f71863          	bne	a4,a5,336 <pgaccess_test+0x92>
    err("bitmask incorrect");

  printf("pgaccess_test: OK\n");
 30a:	00001517          	auipc	a0,0x1
 30e:	aae50513          	addi	a0,a0,-1362 # db8 <malloc+0x2d8>
 312:	71a000ef          	jal	a2c <printf>
 316:	60e2                	ld	ra,24(sp)
 318:	6442                	ld	s0,16(sp)
 31a:	6105                	addi	sp,sp,32
 31c:	8082                	ret
    err("sbrk failed");
 31e:	00001517          	auipc	a0,0x1
 322:	a1250513          	addi	a0,a0,-1518 # d30 <malloc+0x250>
 326:	cdbff0ef          	jal	0 <err>
    err("pgaccess syscall failed");
 32a:	00001517          	auipc	a0,0x1
 32e:	a5e50513          	addi	a0,a0,-1442 # d88 <malloc+0x2a8>
 332:	ccfff0ef          	jal	0 <err>
    err("bitmask incorrect");
 336:	00001517          	auipc	a0,0x1
 33a:	a6a50513          	addi	a0,a0,-1430 # da0 <malloc+0x2c0>
 33e:	cc3ff0ef          	jal	0 <err>

0000000000000342 <main>:
{
 342:	1141                	addi	sp,sp,-16
 344:	e406                	sd	ra,8(sp)
 346:	e022                	sd	s0,0(sp)
 348:	0800                	addi	s0,sp,16
  pgaccess_test();
 34a:	f5bff0ef          	jal	2a4 <pgaccess_test>
  exit(0);
 34e:	4501                	li	a0,0
 350:	284000ef          	jal	5d4 <exit>

0000000000000354 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 354:	1141                	addi	sp,sp,-16
 356:	e406                	sd	ra,8(sp)
 358:	e022                	sd	s0,0(sp)
 35a:	0800                	addi	s0,sp,16
  extern int main();
  main();
 35c:	fe7ff0ef          	jal	342 <main>
  exit(0);
 360:	4501                	li	a0,0
 362:	272000ef          	jal	5d4 <exit>

0000000000000366 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 366:	1141                	addi	sp,sp,-16
 368:	e422                	sd	s0,8(sp)
 36a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 36c:	87aa                	mv	a5,a0
 36e:	0585                	addi	a1,a1,1
 370:	0785                	addi	a5,a5,1
 372:	fff5c703          	lbu	a4,-1(a1)
 376:	fee78fa3          	sb	a4,-1(a5)
 37a:	fb75                	bnez	a4,36e <strcpy+0x8>
    ;
  return os;
}
 37c:	6422                	ld	s0,8(sp)
 37e:	0141                	addi	sp,sp,16
 380:	8082                	ret

0000000000000382 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 382:	1141                	addi	sp,sp,-16
 384:	e422                	sd	s0,8(sp)
 386:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 388:	00054783          	lbu	a5,0(a0)
 38c:	cb91                	beqz	a5,3a0 <strcmp+0x1e>
 38e:	0005c703          	lbu	a4,0(a1)
 392:	00f71763          	bne	a4,a5,3a0 <strcmp+0x1e>
    p++, q++;
 396:	0505                	addi	a0,a0,1
 398:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 39a:	00054783          	lbu	a5,0(a0)
 39e:	fbe5                	bnez	a5,38e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 3a0:	0005c503          	lbu	a0,0(a1)
}
 3a4:	40a7853b          	subw	a0,a5,a0
 3a8:	6422                	ld	s0,8(sp)
 3aa:	0141                	addi	sp,sp,16
 3ac:	8082                	ret

00000000000003ae <strlen>:

uint
strlen(const char *s)
{
 3ae:	1141                	addi	sp,sp,-16
 3b0:	e422                	sd	s0,8(sp)
 3b2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 3b4:	00054783          	lbu	a5,0(a0)
 3b8:	cf91                	beqz	a5,3d4 <strlen+0x26>
 3ba:	0505                	addi	a0,a0,1
 3bc:	87aa                	mv	a5,a0
 3be:	86be                	mv	a3,a5
 3c0:	0785                	addi	a5,a5,1
 3c2:	fff7c703          	lbu	a4,-1(a5)
 3c6:	ff65                	bnez	a4,3be <strlen+0x10>
 3c8:	40a6853b          	subw	a0,a3,a0
 3cc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 3ce:	6422                	ld	s0,8(sp)
 3d0:	0141                	addi	sp,sp,16
 3d2:	8082                	ret
  for(n = 0; s[n]; n++)
 3d4:	4501                	li	a0,0
 3d6:	bfe5                	j	3ce <strlen+0x20>

00000000000003d8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3d8:	1141                	addi	sp,sp,-16
 3da:	e422                	sd	s0,8(sp)
 3dc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 3de:	ca19                	beqz	a2,3f4 <memset+0x1c>
 3e0:	87aa                	mv	a5,a0
 3e2:	1602                	slli	a2,a2,0x20
 3e4:	9201                	srli	a2,a2,0x20
 3e6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 3ea:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 3ee:	0785                	addi	a5,a5,1
 3f0:	fee79de3          	bne	a5,a4,3ea <memset+0x12>
  }
  return dst;
}
 3f4:	6422                	ld	s0,8(sp)
 3f6:	0141                	addi	sp,sp,16
 3f8:	8082                	ret

00000000000003fa <strchr>:

char*
strchr(const char *s, char c)
{
 3fa:	1141                	addi	sp,sp,-16
 3fc:	e422                	sd	s0,8(sp)
 3fe:	0800                	addi	s0,sp,16
  for(; *s; s++)
 400:	00054783          	lbu	a5,0(a0)
 404:	cb99                	beqz	a5,41a <strchr+0x20>
    if(*s == c)
 406:	00f58763          	beq	a1,a5,414 <strchr+0x1a>
  for(; *s; s++)
 40a:	0505                	addi	a0,a0,1
 40c:	00054783          	lbu	a5,0(a0)
 410:	fbfd                	bnez	a5,406 <strchr+0xc>
      return (char*)s;
  return 0;
 412:	4501                	li	a0,0
}
 414:	6422                	ld	s0,8(sp)
 416:	0141                	addi	sp,sp,16
 418:	8082                	ret
  return 0;
 41a:	4501                	li	a0,0
 41c:	bfe5                	j	414 <strchr+0x1a>

000000000000041e <gets>:

char*
gets(char *buf, int max)
{
 41e:	711d                	addi	sp,sp,-96
 420:	ec86                	sd	ra,88(sp)
 422:	e8a2                	sd	s0,80(sp)
 424:	e4a6                	sd	s1,72(sp)
 426:	e0ca                	sd	s2,64(sp)
 428:	fc4e                	sd	s3,56(sp)
 42a:	f852                	sd	s4,48(sp)
 42c:	f456                	sd	s5,40(sp)
 42e:	f05a                	sd	s6,32(sp)
 430:	ec5e                	sd	s7,24(sp)
 432:	1080                	addi	s0,sp,96
 434:	8baa                	mv	s7,a0
 436:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 438:	892a                	mv	s2,a0
 43a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 43c:	4aa9                	li	s5,10
 43e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 440:	89a6                	mv	s3,s1
 442:	2485                	addiw	s1,s1,1
 444:	0344d663          	bge	s1,s4,470 <gets+0x52>
    cc = read(0, &c, 1);
 448:	4605                	li	a2,1
 44a:	faf40593          	addi	a1,s0,-81
 44e:	4501                	li	a0,0
 450:	19c000ef          	jal	5ec <read>
    if(cc < 1)
 454:	00a05e63          	blez	a0,470 <gets+0x52>
    buf[i++] = c;
 458:	faf44783          	lbu	a5,-81(s0)
 45c:	00f90023          	sb	a5,0(s2) # a000 <base+0x8fe0>
    if(c == '\n' || c == '\r')
 460:	01578763          	beq	a5,s5,46e <gets+0x50>
 464:	0905                	addi	s2,s2,1
 466:	fd679de3          	bne	a5,s6,440 <gets+0x22>
    buf[i++] = c;
 46a:	89a6                	mv	s3,s1
 46c:	a011                	j	470 <gets+0x52>
 46e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 470:	99de                	add	s3,s3,s7
 472:	00098023          	sb	zero,0(s3) # 200000 <base+0x1fefe0>
  return buf;
}
 476:	855e                	mv	a0,s7
 478:	60e6                	ld	ra,88(sp)
 47a:	6446                	ld	s0,80(sp)
 47c:	64a6                	ld	s1,72(sp)
 47e:	6906                	ld	s2,64(sp)
 480:	79e2                	ld	s3,56(sp)
 482:	7a42                	ld	s4,48(sp)
 484:	7aa2                	ld	s5,40(sp)
 486:	7b02                	ld	s6,32(sp)
 488:	6be2                	ld	s7,24(sp)
 48a:	6125                	addi	sp,sp,96
 48c:	8082                	ret

000000000000048e <stat>:

int
stat(const char *n, struct stat *st)
{
 48e:	1101                	addi	sp,sp,-32
 490:	ec06                	sd	ra,24(sp)
 492:	e822                	sd	s0,16(sp)
 494:	e04a                	sd	s2,0(sp)
 496:	1000                	addi	s0,sp,32
 498:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 49a:	4581                	li	a1,0
 49c:	178000ef          	jal	614 <open>
  if(fd < 0)
 4a0:	02054263          	bltz	a0,4c4 <stat+0x36>
 4a4:	e426                	sd	s1,8(sp)
 4a6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 4a8:	85ca                	mv	a1,s2
 4aa:	182000ef          	jal	62c <fstat>
 4ae:	892a                	mv	s2,a0
  close(fd);
 4b0:	8526                	mv	a0,s1
 4b2:	14a000ef          	jal	5fc <close>
  return r;
 4b6:	64a2                	ld	s1,8(sp)
}
 4b8:	854a                	mv	a0,s2
 4ba:	60e2                	ld	ra,24(sp)
 4bc:	6442                	ld	s0,16(sp)
 4be:	6902                	ld	s2,0(sp)
 4c0:	6105                	addi	sp,sp,32
 4c2:	8082                	ret
    return -1;
 4c4:	597d                	li	s2,-1
 4c6:	bfcd                	j	4b8 <stat+0x2a>

00000000000004c8 <atoi>:

int
atoi(const char *s)
{
 4c8:	1141                	addi	sp,sp,-16
 4ca:	e422                	sd	s0,8(sp)
 4cc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4ce:	00054683          	lbu	a3,0(a0)
 4d2:	fd06879b          	addiw	a5,a3,-48
 4d6:	0ff7f793          	zext.b	a5,a5
 4da:	4625                	li	a2,9
 4dc:	02f66863          	bltu	a2,a5,50c <atoi+0x44>
 4e0:	872a                	mv	a4,a0
  n = 0;
 4e2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 4e4:	0705                	addi	a4,a4,1
 4e6:	0025179b          	slliw	a5,a0,0x2
 4ea:	9fa9                	addw	a5,a5,a0
 4ec:	0017979b          	slliw	a5,a5,0x1
 4f0:	9fb5                	addw	a5,a5,a3
 4f2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4f6:	00074683          	lbu	a3,0(a4)
 4fa:	fd06879b          	addiw	a5,a3,-48
 4fe:	0ff7f793          	zext.b	a5,a5
 502:	fef671e3          	bgeu	a2,a5,4e4 <atoi+0x1c>
  return n;
}
 506:	6422                	ld	s0,8(sp)
 508:	0141                	addi	sp,sp,16
 50a:	8082                	ret
  n = 0;
 50c:	4501                	li	a0,0
 50e:	bfe5                	j	506 <atoi+0x3e>

0000000000000510 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 510:	1141                	addi	sp,sp,-16
 512:	e422                	sd	s0,8(sp)
 514:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 516:	02b57463          	bgeu	a0,a1,53e <memmove+0x2e>
    while(n-- > 0)
 51a:	00c05f63          	blez	a2,538 <memmove+0x28>
 51e:	1602                	slli	a2,a2,0x20
 520:	9201                	srli	a2,a2,0x20
 522:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 526:	872a                	mv	a4,a0
      *dst++ = *src++;
 528:	0585                	addi	a1,a1,1
 52a:	0705                	addi	a4,a4,1
 52c:	fff5c683          	lbu	a3,-1(a1)
 530:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 534:	fef71ae3          	bne	a4,a5,528 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 538:	6422                	ld	s0,8(sp)
 53a:	0141                	addi	sp,sp,16
 53c:	8082                	ret
    dst += n;
 53e:	00c50733          	add	a4,a0,a2
    src += n;
 542:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 544:	fec05ae3          	blez	a2,538 <memmove+0x28>
 548:	fff6079b          	addiw	a5,a2,-1
 54c:	1782                	slli	a5,a5,0x20
 54e:	9381                	srli	a5,a5,0x20
 550:	fff7c793          	not	a5,a5
 554:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 556:	15fd                	addi	a1,a1,-1
 558:	177d                	addi	a4,a4,-1
 55a:	0005c683          	lbu	a3,0(a1)
 55e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 562:	fee79ae3          	bne	a5,a4,556 <memmove+0x46>
 566:	bfc9                	j	538 <memmove+0x28>

0000000000000568 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 568:	1141                	addi	sp,sp,-16
 56a:	e422                	sd	s0,8(sp)
 56c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 56e:	ca05                	beqz	a2,59e <memcmp+0x36>
 570:	fff6069b          	addiw	a3,a2,-1
 574:	1682                	slli	a3,a3,0x20
 576:	9281                	srli	a3,a3,0x20
 578:	0685                	addi	a3,a3,1
 57a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 57c:	00054783          	lbu	a5,0(a0)
 580:	0005c703          	lbu	a4,0(a1)
 584:	00e79863          	bne	a5,a4,594 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 588:	0505                	addi	a0,a0,1
    p2++;
 58a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 58c:	fed518e3          	bne	a0,a3,57c <memcmp+0x14>
  }
  return 0;
 590:	4501                	li	a0,0
 592:	a019                	j	598 <memcmp+0x30>
      return *p1 - *p2;
 594:	40e7853b          	subw	a0,a5,a4
}
 598:	6422                	ld	s0,8(sp)
 59a:	0141                	addi	sp,sp,16
 59c:	8082                	ret
  return 0;
 59e:	4501                	li	a0,0
 5a0:	bfe5                	j	598 <memcmp+0x30>

00000000000005a2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 5a2:	1141                	addi	sp,sp,-16
 5a4:	e406                	sd	ra,8(sp)
 5a6:	e022                	sd	s0,0(sp)
 5a8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 5aa:	f67ff0ef          	jal	510 <memmove>
}
 5ae:	60a2                	ld	ra,8(sp)
 5b0:	6402                	ld	s0,0(sp)
 5b2:	0141                	addi	sp,sp,16
 5b4:	8082                	ret

00000000000005b6 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 5b6:	1141                	addi	sp,sp,-16
 5b8:	e422                	sd	s0,8(sp)
 5ba:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 5bc:	040007b7          	lui	a5,0x4000
 5c0:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ffefdd>
 5c2:	07b2                	slli	a5,a5,0xc
}
 5c4:	4388                	lw	a0,0(a5)
 5c6:	6422                	ld	s0,8(sp)
 5c8:	0141                	addi	sp,sp,16
 5ca:	8082                	ret

00000000000005cc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5cc:	4885                	li	a7,1
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 5d4:	4889                	li	a7,2
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <wait>:
.global wait
wait:
 li a7, SYS_wait
 5dc:	488d                	li	a7,3
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5e4:	4891                	li	a7,4
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <read>:
.global read
read:
 li a7, SYS_read
 5ec:	4895                	li	a7,5
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <write>:
.global write
write:
 li a7, SYS_write
 5f4:	48c1                	li	a7,16
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <close>:
.global close
close:
 li a7, SYS_close
 5fc:	48d5                	li	a7,21
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <kill>:
.global kill
kill:
 li a7, SYS_kill
 604:	4899                	li	a7,6
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <exec>:
.global exec
exec:
 li a7, SYS_exec
 60c:	489d                	li	a7,7
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <open>:
.global open
open:
 li a7, SYS_open
 614:	48bd                	li	a7,15
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 61c:	48c5                	li	a7,17
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 624:	48c9                	li	a7,18
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 62c:	48a1                	li	a7,8
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <link>:
.global link
link:
 li a7, SYS_link
 634:	48cd                	li	a7,19
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 63c:	48d1                	li	a7,20
 ecall
 63e:	00000073          	ecall
 ret
 642:	8082                	ret

0000000000000644 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 644:	48a5                	li	a7,9
 ecall
 646:	00000073          	ecall
 ret
 64a:	8082                	ret

000000000000064c <dup>:
.global dup
dup:
 li a7, SYS_dup
 64c:	48a9                	li	a7,10
 ecall
 64e:	00000073          	ecall
 ret
 652:	8082                	ret

0000000000000654 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 654:	48ad                	li	a7,11
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 65c:	48b1                	li	a7,12
 ecall
 65e:	00000073          	ecall
 ret
 662:	8082                	ret

0000000000000664 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 664:	48b5                	li	a7,13
 ecall
 666:	00000073          	ecall
 ret
 66a:	8082                	ret

000000000000066c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 66c:	48b9                	li	a7,14
 ecall
 66e:	00000073          	ecall
 ret
 672:	8082                	ret

0000000000000674 <bind>:
.global bind
bind:
 li a7, SYS_bind
 674:	48f5                	li	a7,29
 ecall
 676:	00000073          	ecall
 ret
 67a:	8082                	ret

000000000000067c <unbind>:
.global unbind
unbind:
 li a7, SYS_unbind
 67c:	48f9                	li	a7,30
 ecall
 67e:	00000073          	ecall
 ret
 682:	8082                	ret

0000000000000684 <send>:
.global send
send:
 li a7, SYS_send
 684:	48fd                	li	a7,31
 ecall
 686:	00000073          	ecall
 ret
 68a:	8082                	ret

000000000000068c <recv>:
.global recv
recv:
 li a7, SYS_recv
 68c:	02000893          	li	a7,32
 ecall
 690:	00000073          	ecall
 ret
 694:	8082                	ret

0000000000000696 <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 696:	02100893          	li	a7,33
 ecall
 69a:	00000073          	ecall
 ret
 69e:	8082                	ret

00000000000006a0 <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 6a0:	02200893          	li	a7,34
 ecall
 6a4:	00000073          	ecall
 ret
 6a8:	8082                	ret

00000000000006aa <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 6aa:	02300893          	li	a7,35
 ecall
 6ae:	00000073          	ecall
 ret
 6b2:	8082                	ret

00000000000006b4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6b4:	1101                	addi	sp,sp,-32
 6b6:	ec06                	sd	ra,24(sp)
 6b8:	e822                	sd	s0,16(sp)
 6ba:	1000                	addi	s0,sp,32
 6bc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 6c0:	4605                	li	a2,1
 6c2:	fef40593          	addi	a1,s0,-17
 6c6:	f2fff0ef          	jal	5f4 <write>
}
 6ca:	60e2                	ld	ra,24(sp)
 6cc:	6442                	ld	s0,16(sp)
 6ce:	6105                	addi	sp,sp,32
 6d0:	8082                	ret

00000000000006d2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6d2:	7139                	addi	sp,sp,-64
 6d4:	fc06                	sd	ra,56(sp)
 6d6:	f822                	sd	s0,48(sp)
 6d8:	f426                	sd	s1,40(sp)
 6da:	0080                	addi	s0,sp,64
 6dc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6de:	c299                	beqz	a3,6e4 <printint+0x12>
 6e0:	0805c963          	bltz	a1,772 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 6e4:	2581                	sext.w	a1,a1
  neg = 0;
 6e6:	4881                	li	a7,0
 6e8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 6ec:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 6ee:	2601                	sext.w	a2,a2
 6f0:	00000517          	auipc	a0,0x0
 6f4:	6f050513          	addi	a0,a0,1776 # de0 <digits>
 6f8:	883a                	mv	a6,a4
 6fa:	2705                	addiw	a4,a4,1
 6fc:	02c5f7bb          	remuw	a5,a1,a2
 700:	1782                	slli	a5,a5,0x20
 702:	9381                	srli	a5,a5,0x20
 704:	97aa                	add	a5,a5,a0
 706:	0007c783          	lbu	a5,0(a5)
 70a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 70e:	0005879b          	sext.w	a5,a1
 712:	02c5d5bb          	divuw	a1,a1,a2
 716:	0685                	addi	a3,a3,1
 718:	fec7f0e3          	bgeu	a5,a2,6f8 <printint+0x26>
  if(neg)
 71c:	00088c63          	beqz	a7,734 <printint+0x62>
    buf[i++] = '-';
 720:	fd070793          	addi	a5,a4,-48
 724:	00878733          	add	a4,a5,s0
 728:	02d00793          	li	a5,45
 72c:	fef70823          	sb	a5,-16(a4)
 730:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 734:	02e05a63          	blez	a4,768 <printint+0x96>
 738:	f04a                	sd	s2,32(sp)
 73a:	ec4e                	sd	s3,24(sp)
 73c:	fc040793          	addi	a5,s0,-64
 740:	00e78933          	add	s2,a5,a4
 744:	fff78993          	addi	s3,a5,-1
 748:	99ba                	add	s3,s3,a4
 74a:	377d                	addiw	a4,a4,-1
 74c:	1702                	slli	a4,a4,0x20
 74e:	9301                	srli	a4,a4,0x20
 750:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 754:	fff94583          	lbu	a1,-1(s2)
 758:	8526                	mv	a0,s1
 75a:	f5bff0ef          	jal	6b4 <putc>
  while(--i >= 0)
 75e:	197d                	addi	s2,s2,-1
 760:	ff391ae3          	bne	s2,s3,754 <printint+0x82>
 764:	7902                	ld	s2,32(sp)
 766:	69e2                	ld	s3,24(sp)
}
 768:	70e2                	ld	ra,56(sp)
 76a:	7442                	ld	s0,48(sp)
 76c:	74a2                	ld	s1,40(sp)
 76e:	6121                	addi	sp,sp,64
 770:	8082                	ret
    x = -xx;
 772:	40b005bb          	negw	a1,a1
    neg = 1;
 776:	4885                	li	a7,1
    x = -xx;
 778:	bf85                	j	6e8 <printint+0x16>

000000000000077a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 77a:	711d                	addi	sp,sp,-96
 77c:	ec86                	sd	ra,88(sp)
 77e:	e8a2                	sd	s0,80(sp)
 780:	e0ca                	sd	s2,64(sp)
 782:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 784:	0005c903          	lbu	s2,0(a1)
 788:	26090863          	beqz	s2,9f8 <vprintf+0x27e>
 78c:	e4a6                	sd	s1,72(sp)
 78e:	fc4e                	sd	s3,56(sp)
 790:	f852                	sd	s4,48(sp)
 792:	f456                	sd	s5,40(sp)
 794:	f05a                	sd	s6,32(sp)
 796:	ec5e                	sd	s7,24(sp)
 798:	e862                	sd	s8,16(sp)
 79a:	e466                	sd	s9,8(sp)
 79c:	8b2a                	mv	s6,a0
 79e:	8a2e                	mv	s4,a1
 7a0:	8bb2                	mv	s7,a2
  state = 0;
 7a2:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 7a4:	4481                	li	s1,0
 7a6:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 7a8:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 7ac:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 7b0:	06c00c93          	li	s9,108
 7b4:	a005                	j	7d4 <vprintf+0x5a>
        putc(fd, c0);
 7b6:	85ca                	mv	a1,s2
 7b8:	855a                	mv	a0,s6
 7ba:	efbff0ef          	jal	6b4 <putc>
 7be:	a019                	j	7c4 <vprintf+0x4a>
    } else if(state == '%'){
 7c0:	03598263          	beq	s3,s5,7e4 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 7c4:	2485                	addiw	s1,s1,1
 7c6:	8726                	mv	a4,s1
 7c8:	009a07b3          	add	a5,s4,s1
 7cc:	0007c903          	lbu	s2,0(a5)
 7d0:	20090c63          	beqz	s2,9e8 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 7d4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 7d8:	fe0994e3          	bnez	s3,7c0 <vprintf+0x46>
      if(c0 == '%'){
 7dc:	fd579de3          	bne	a5,s5,7b6 <vprintf+0x3c>
        state = '%';
 7e0:	89be                	mv	s3,a5
 7e2:	b7cd                	j	7c4 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 7e4:	00ea06b3          	add	a3,s4,a4
 7e8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 7ec:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 7ee:	c681                	beqz	a3,7f6 <vprintf+0x7c>
 7f0:	9752                	add	a4,a4,s4
 7f2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 7f6:	03878f63          	beq	a5,s8,834 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 7fa:	05978963          	beq	a5,s9,84c <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 7fe:	07500713          	li	a4,117
 802:	0ee78363          	beq	a5,a4,8e8 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 806:	07800713          	li	a4,120
 80a:	12e78563          	beq	a5,a4,934 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 80e:	07000713          	li	a4,112
 812:	14e78a63          	beq	a5,a4,966 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 816:	07300713          	li	a4,115
 81a:	18e78a63          	beq	a5,a4,9ae <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 81e:	02500713          	li	a4,37
 822:	04e79563          	bne	a5,a4,86c <vprintf+0xf2>
        putc(fd, '%');
 826:	02500593          	li	a1,37
 82a:	855a                	mv	a0,s6
 82c:	e89ff0ef          	jal	6b4 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 830:	4981                	li	s3,0
 832:	bf49                	j	7c4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 834:	008b8913          	addi	s2,s7,8
 838:	4685                	li	a3,1
 83a:	4629                	li	a2,10
 83c:	000ba583          	lw	a1,0(s7)
 840:	855a                	mv	a0,s6
 842:	e91ff0ef          	jal	6d2 <printint>
 846:	8bca                	mv	s7,s2
      state = 0;
 848:	4981                	li	s3,0
 84a:	bfad                	j	7c4 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 84c:	06400793          	li	a5,100
 850:	02f68963          	beq	a3,a5,882 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 854:	06c00793          	li	a5,108
 858:	04f68263          	beq	a3,a5,89c <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 85c:	07500793          	li	a5,117
 860:	0af68063          	beq	a3,a5,900 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 864:	07800793          	li	a5,120
 868:	0ef68263          	beq	a3,a5,94c <vprintf+0x1d2>
        putc(fd, '%');
 86c:	02500593          	li	a1,37
 870:	855a                	mv	a0,s6
 872:	e43ff0ef          	jal	6b4 <putc>
        putc(fd, c0);
 876:	85ca                	mv	a1,s2
 878:	855a                	mv	a0,s6
 87a:	e3bff0ef          	jal	6b4 <putc>
      state = 0;
 87e:	4981                	li	s3,0
 880:	b791                	j	7c4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 882:	008b8913          	addi	s2,s7,8
 886:	4685                	li	a3,1
 888:	4629                	li	a2,10
 88a:	000ba583          	lw	a1,0(s7)
 88e:	855a                	mv	a0,s6
 890:	e43ff0ef          	jal	6d2 <printint>
        i += 1;
 894:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 896:	8bca                	mv	s7,s2
      state = 0;
 898:	4981                	li	s3,0
        i += 1;
 89a:	b72d                	j	7c4 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 89c:	06400793          	li	a5,100
 8a0:	02f60763          	beq	a2,a5,8ce <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 8a4:	07500793          	li	a5,117
 8a8:	06f60963          	beq	a2,a5,91a <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 8ac:	07800793          	li	a5,120
 8b0:	faf61ee3          	bne	a2,a5,86c <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 8b4:	008b8913          	addi	s2,s7,8
 8b8:	4681                	li	a3,0
 8ba:	4641                	li	a2,16
 8bc:	000ba583          	lw	a1,0(s7)
 8c0:	855a                	mv	a0,s6
 8c2:	e11ff0ef          	jal	6d2 <printint>
        i += 2;
 8c6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 8c8:	8bca                	mv	s7,s2
      state = 0;
 8ca:	4981                	li	s3,0
        i += 2;
 8cc:	bde5                	j	7c4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 8ce:	008b8913          	addi	s2,s7,8
 8d2:	4685                	li	a3,1
 8d4:	4629                	li	a2,10
 8d6:	000ba583          	lw	a1,0(s7)
 8da:	855a                	mv	a0,s6
 8dc:	df7ff0ef          	jal	6d2 <printint>
        i += 2;
 8e0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 8e2:	8bca                	mv	s7,s2
      state = 0;
 8e4:	4981                	li	s3,0
        i += 2;
 8e6:	bdf9                	j	7c4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 8e8:	008b8913          	addi	s2,s7,8
 8ec:	4681                	li	a3,0
 8ee:	4629                	li	a2,10
 8f0:	000ba583          	lw	a1,0(s7)
 8f4:	855a                	mv	a0,s6
 8f6:	dddff0ef          	jal	6d2 <printint>
 8fa:	8bca                	mv	s7,s2
      state = 0;
 8fc:	4981                	li	s3,0
 8fe:	b5d9                	j	7c4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 900:	008b8913          	addi	s2,s7,8
 904:	4681                	li	a3,0
 906:	4629                	li	a2,10
 908:	000ba583          	lw	a1,0(s7)
 90c:	855a                	mv	a0,s6
 90e:	dc5ff0ef          	jal	6d2 <printint>
        i += 1;
 912:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 914:	8bca                	mv	s7,s2
      state = 0;
 916:	4981                	li	s3,0
        i += 1;
 918:	b575                	j	7c4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 91a:	008b8913          	addi	s2,s7,8
 91e:	4681                	li	a3,0
 920:	4629                	li	a2,10
 922:	000ba583          	lw	a1,0(s7)
 926:	855a                	mv	a0,s6
 928:	dabff0ef          	jal	6d2 <printint>
        i += 2;
 92c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 92e:	8bca                	mv	s7,s2
      state = 0;
 930:	4981                	li	s3,0
        i += 2;
 932:	bd49                	j	7c4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 934:	008b8913          	addi	s2,s7,8
 938:	4681                	li	a3,0
 93a:	4641                	li	a2,16
 93c:	000ba583          	lw	a1,0(s7)
 940:	855a                	mv	a0,s6
 942:	d91ff0ef          	jal	6d2 <printint>
 946:	8bca                	mv	s7,s2
      state = 0;
 948:	4981                	li	s3,0
 94a:	bdad                	j	7c4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 94c:	008b8913          	addi	s2,s7,8
 950:	4681                	li	a3,0
 952:	4641                	li	a2,16
 954:	000ba583          	lw	a1,0(s7)
 958:	855a                	mv	a0,s6
 95a:	d79ff0ef          	jal	6d2 <printint>
        i += 1;
 95e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 960:	8bca                	mv	s7,s2
      state = 0;
 962:	4981                	li	s3,0
        i += 1;
 964:	b585                	j	7c4 <vprintf+0x4a>
 966:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 968:	008b8d13          	addi	s10,s7,8
 96c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 970:	03000593          	li	a1,48
 974:	855a                	mv	a0,s6
 976:	d3fff0ef          	jal	6b4 <putc>
  putc(fd, 'x');
 97a:	07800593          	li	a1,120
 97e:	855a                	mv	a0,s6
 980:	d35ff0ef          	jal	6b4 <putc>
 984:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 986:	00000b97          	auipc	s7,0x0
 98a:	45ab8b93          	addi	s7,s7,1114 # de0 <digits>
 98e:	03c9d793          	srli	a5,s3,0x3c
 992:	97de                	add	a5,a5,s7
 994:	0007c583          	lbu	a1,0(a5)
 998:	855a                	mv	a0,s6
 99a:	d1bff0ef          	jal	6b4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 99e:	0992                	slli	s3,s3,0x4
 9a0:	397d                	addiw	s2,s2,-1
 9a2:	fe0916e3          	bnez	s2,98e <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 9a6:	8bea                	mv	s7,s10
      state = 0;
 9a8:	4981                	li	s3,0
 9aa:	6d02                	ld	s10,0(sp)
 9ac:	bd21                	j	7c4 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 9ae:	008b8993          	addi	s3,s7,8
 9b2:	000bb903          	ld	s2,0(s7)
 9b6:	00090f63          	beqz	s2,9d4 <vprintf+0x25a>
        for(; *s; s++)
 9ba:	00094583          	lbu	a1,0(s2)
 9be:	c195                	beqz	a1,9e2 <vprintf+0x268>
          putc(fd, *s);
 9c0:	855a                	mv	a0,s6
 9c2:	cf3ff0ef          	jal	6b4 <putc>
        for(; *s; s++)
 9c6:	0905                	addi	s2,s2,1
 9c8:	00094583          	lbu	a1,0(s2)
 9cc:	f9f5                	bnez	a1,9c0 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 9ce:	8bce                	mv	s7,s3
      state = 0;
 9d0:	4981                	li	s3,0
 9d2:	bbcd                	j	7c4 <vprintf+0x4a>
          s = "(null)";
 9d4:	00000917          	auipc	s2,0x0
 9d8:	40490913          	addi	s2,s2,1028 # dd8 <malloc+0x2f8>
        for(; *s; s++)
 9dc:	02800593          	li	a1,40
 9e0:	b7c5                	j	9c0 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 9e2:	8bce                	mv	s7,s3
      state = 0;
 9e4:	4981                	li	s3,0
 9e6:	bbf9                	j	7c4 <vprintf+0x4a>
 9e8:	64a6                	ld	s1,72(sp)
 9ea:	79e2                	ld	s3,56(sp)
 9ec:	7a42                	ld	s4,48(sp)
 9ee:	7aa2                	ld	s5,40(sp)
 9f0:	7b02                	ld	s6,32(sp)
 9f2:	6be2                	ld	s7,24(sp)
 9f4:	6c42                	ld	s8,16(sp)
 9f6:	6ca2                	ld	s9,8(sp)
    }
  }
}
 9f8:	60e6                	ld	ra,88(sp)
 9fa:	6446                	ld	s0,80(sp)
 9fc:	6906                	ld	s2,64(sp)
 9fe:	6125                	addi	sp,sp,96
 a00:	8082                	ret

0000000000000a02 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a02:	715d                	addi	sp,sp,-80
 a04:	ec06                	sd	ra,24(sp)
 a06:	e822                	sd	s0,16(sp)
 a08:	1000                	addi	s0,sp,32
 a0a:	e010                	sd	a2,0(s0)
 a0c:	e414                	sd	a3,8(s0)
 a0e:	e818                	sd	a4,16(s0)
 a10:	ec1c                	sd	a5,24(s0)
 a12:	03043023          	sd	a6,32(s0)
 a16:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a1a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a1e:	8622                	mv	a2,s0
 a20:	d5bff0ef          	jal	77a <vprintf>
}
 a24:	60e2                	ld	ra,24(sp)
 a26:	6442                	ld	s0,16(sp)
 a28:	6161                	addi	sp,sp,80
 a2a:	8082                	ret

0000000000000a2c <printf>:

void
printf(const char *fmt, ...)
{
 a2c:	711d                	addi	sp,sp,-96
 a2e:	ec06                	sd	ra,24(sp)
 a30:	e822                	sd	s0,16(sp)
 a32:	1000                	addi	s0,sp,32
 a34:	e40c                	sd	a1,8(s0)
 a36:	e810                	sd	a2,16(s0)
 a38:	ec14                	sd	a3,24(s0)
 a3a:	f018                	sd	a4,32(s0)
 a3c:	f41c                	sd	a5,40(s0)
 a3e:	03043823          	sd	a6,48(s0)
 a42:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a46:	00840613          	addi	a2,s0,8
 a4a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a4e:	85aa                	mv	a1,a0
 a50:	4505                	li	a0,1
 a52:	d29ff0ef          	jal	77a <vprintf>
}
 a56:	60e2                	ld	ra,24(sp)
 a58:	6442                	ld	s0,16(sp)
 a5a:	6125                	addi	sp,sp,96
 a5c:	8082                	ret

0000000000000a5e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a5e:	1141                	addi	sp,sp,-16
 a60:	e422                	sd	s0,8(sp)
 a62:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a64:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a68:	00000797          	auipc	a5,0x0
 a6c:	5a87b783          	ld	a5,1448(a5) # 1010 <freep>
 a70:	a02d                	j	a9a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a72:	4618                	lw	a4,8(a2)
 a74:	9f2d                	addw	a4,a4,a1
 a76:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a7a:	6398                	ld	a4,0(a5)
 a7c:	6310                	ld	a2,0(a4)
 a7e:	a83d                	j	abc <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a80:	ff852703          	lw	a4,-8(a0)
 a84:	9f31                	addw	a4,a4,a2
 a86:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a88:	ff053683          	ld	a3,-16(a0)
 a8c:	a091                	j	ad0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a8e:	6398                	ld	a4,0(a5)
 a90:	00e7e463          	bltu	a5,a4,a98 <free+0x3a>
 a94:	00e6ea63          	bltu	a3,a4,aa8 <free+0x4a>
{
 a98:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a9a:	fed7fae3          	bgeu	a5,a3,a8e <free+0x30>
 a9e:	6398                	ld	a4,0(a5)
 aa0:	00e6e463          	bltu	a3,a4,aa8 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 aa4:	fee7eae3          	bltu	a5,a4,a98 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 aa8:	ff852583          	lw	a1,-8(a0)
 aac:	6390                	ld	a2,0(a5)
 aae:	02059813          	slli	a6,a1,0x20
 ab2:	01c85713          	srli	a4,a6,0x1c
 ab6:	9736                	add	a4,a4,a3
 ab8:	fae60de3          	beq	a2,a4,a72 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 abc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 ac0:	4790                	lw	a2,8(a5)
 ac2:	02061593          	slli	a1,a2,0x20
 ac6:	01c5d713          	srli	a4,a1,0x1c
 aca:	973e                	add	a4,a4,a5
 acc:	fae68ae3          	beq	a3,a4,a80 <free+0x22>
    p->s.ptr = bp->s.ptr;
 ad0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 ad2:	00000717          	auipc	a4,0x0
 ad6:	52f73f23          	sd	a5,1342(a4) # 1010 <freep>
}
 ada:	6422                	ld	s0,8(sp)
 adc:	0141                	addi	sp,sp,16
 ade:	8082                	ret

0000000000000ae0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 ae0:	7139                	addi	sp,sp,-64
 ae2:	fc06                	sd	ra,56(sp)
 ae4:	f822                	sd	s0,48(sp)
 ae6:	f426                	sd	s1,40(sp)
 ae8:	ec4e                	sd	s3,24(sp)
 aea:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 aec:	02051493          	slli	s1,a0,0x20
 af0:	9081                	srli	s1,s1,0x20
 af2:	04bd                	addi	s1,s1,15
 af4:	8091                	srli	s1,s1,0x4
 af6:	0014899b          	addiw	s3,s1,1
 afa:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 afc:	00000517          	auipc	a0,0x0
 b00:	51453503          	ld	a0,1300(a0) # 1010 <freep>
 b04:	c915                	beqz	a0,b38 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b06:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b08:	4798                	lw	a4,8(a5)
 b0a:	08977a63          	bgeu	a4,s1,b9e <malloc+0xbe>
 b0e:	f04a                	sd	s2,32(sp)
 b10:	e852                	sd	s4,16(sp)
 b12:	e456                	sd	s5,8(sp)
 b14:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 b16:	8a4e                	mv	s4,s3
 b18:	0009871b          	sext.w	a4,s3
 b1c:	6685                	lui	a3,0x1
 b1e:	00d77363          	bgeu	a4,a3,b24 <malloc+0x44>
 b22:	6a05                	lui	s4,0x1
 b24:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b28:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b2c:	00000917          	auipc	s2,0x0
 b30:	4e490913          	addi	s2,s2,1252 # 1010 <freep>
  if(p == (char*)-1)
 b34:	5afd                	li	s5,-1
 b36:	a081                	j	b76 <malloc+0x96>
 b38:	f04a                	sd	s2,32(sp)
 b3a:	e852                	sd	s4,16(sp)
 b3c:	e456                	sd	s5,8(sp)
 b3e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 b40:	00000797          	auipc	a5,0x0
 b44:	4e078793          	addi	a5,a5,1248 # 1020 <base>
 b48:	00000717          	auipc	a4,0x0
 b4c:	4cf73423          	sd	a5,1224(a4) # 1010 <freep>
 b50:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b52:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b56:	b7c1                	j	b16 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 b58:	6398                	ld	a4,0(a5)
 b5a:	e118                	sd	a4,0(a0)
 b5c:	a8a9                	j	bb6 <malloc+0xd6>
  hp->s.size = nu;
 b5e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b62:	0541                	addi	a0,a0,16
 b64:	efbff0ef          	jal	a5e <free>
  return freep;
 b68:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b6c:	c12d                	beqz	a0,bce <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b6e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b70:	4798                	lw	a4,8(a5)
 b72:	02977263          	bgeu	a4,s1,b96 <malloc+0xb6>
    if(p == freep)
 b76:	00093703          	ld	a4,0(s2)
 b7a:	853e                	mv	a0,a5
 b7c:	fef719e3          	bne	a4,a5,b6e <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 b80:	8552                	mv	a0,s4
 b82:	adbff0ef          	jal	65c <sbrk>
  if(p == (char*)-1)
 b86:	fd551ce3          	bne	a0,s5,b5e <malloc+0x7e>
        return 0;
 b8a:	4501                	li	a0,0
 b8c:	7902                	ld	s2,32(sp)
 b8e:	6a42                	ld	s4,16(sp)
 b90:	6aa2                	ld	s5,8(sp)
 b92:	6b02                	ld	s6,0(sp)
 b94:	a03d                	j	bc2 <malloc+0xe2>
 b96:	7902                	ld	s2,32(sp)
 b98:	6a42                	ld	s4,16(sp)
 b9a:	6aa2                	ld	s5,8(sp)
 b9c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 b9e:	fae48de3          	beq	s1,a4,b58 <malloc+0x78>
        p->s.size -= nunits;
 ba2:	4137073b          	subw	a4,a4,s3
 ba6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ba8:	02071693          	slli	a3,a4,0x20
 bac:	01c6d713          	srli	a4,a3,0x1c
 bb0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 bb2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 bb6:	00000717          	auipc	a4,0x0
 bba:	44a73d23          	sd	a0,1114(a4) # 1010 <freep>
      return (void*)(p + 1);
 bbe:	01078513          	addi	a0,a5,16
  }
}
 bc2:	70e2                	ld	ra,56(sp)
 bc4:	7442                	ld	s0,48(sp)
 bc6:	74a2                	ld	s1,40(sp)
 bc8:	69e2                	ld	s3,24(sp)
 bca:	6121                	addi	sp,sp,64
 bcc:	8082                	ret
 bce:	7902                	ld	s2,32(sp)
 bd0:	6a42                	ld	s4,16(sp)
 bd2:	6aa2                	ld	s5,8(sp)
 bd4:	6b02                	ld	s6,0(sp)
 bd6:	b7f5                	j	bc2 <malloc+0xe2>
