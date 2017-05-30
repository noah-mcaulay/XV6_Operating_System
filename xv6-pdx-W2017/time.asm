
_time:     file format elf32-i386


Disassembly of section .text:

00000000 <time>:
// a console command (which is its input). Note that the input could be
// a nested time command.
// Added for Project 2: The "time" Command
int
time(char *argv[])
{ 
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 14             	sub    $0x14,%esp
  uint ticks_total = 0;
   7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  uint ticks_in = 0;
   e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  // get pid of parent
  uint pid = getpid();
  15:	e8 96 04 00 00       	call   4b0 <getpid>
  1a:	89 45 ec             	mov    %eax,-0x14(%ebp)

  // fork before tracking time so we don't include the overhead of fork
  fork();
  1d:	e8 06 04 00 00       	call   428 <fork>

  // get starting ticks (adds a tiny bit of overhead to calculation)
  ticks_in = uptime();
  22:	e8 a1 04 00 00       	call   4c8 <uptime>
  27:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // if current proc is parent, then wait for child and track the time delta
  if (pid == getpid())
  2a:	e8 81 04 00 00       	call   4b0 <getpid>
  2f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  32:	0f 85 8f 00 00 00    	jne    c7 <time+0xc7>
  {
    wait();
  38:	e8 fb 03 00 00       	call   438 <wait>
    
    // calculate time delta
    ticks_total += uptime() - ticks_in;
  3d:	e8 86 04 00 00       	call   4c8 <uptime>
  42:	2b 45 f0             	sub    -0x10(%ebp),%eax
  45:	01 45 f4             	add    %eax,-0xc(%ebp)
    // print result
    printf(1, "%s ran in %d.%d%d seconds.\n",
              argv[0],
              ticks_total / 100,
              ticks_total % 100 / 10,
              ticks_total % 100 % 10);
  48:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  4b:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  50:	89 c8                	mov    %ecx,%eax
  52:	f7 e2                	mul    %edx
  54:	89 d3                	mov    %edx,%ebx
  56:	c1 eb 05             	shr    $0x5,%ebx
  59:	6b c3 64             	imul   $0x64,%ebx,%eax
  5c:	29 c1                	sub    %eax,%ecx
  5e:	89 cb                	mov    %ecx,%ebx
    
    // calculate time delta
    ticks_total += uptime() - ticks_in;
    
    // print result
    printf(1, "%s ran in %d.%d%d seconds.\n",
  60:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  65:	89 d8                	mov    %ebx,%eax
  67:	f7 e2                	mul    %edx
  69:	89 d1                	mov    %edx,%ecx
  6b:	c1 e9 03             	shr    $0x3,%ecx
  6e:	89 c8                	mov    %ecx,%eax
  70:	c1 e0 02             	shl    $0x2,%eax
  73:	01 c8                	add    %ecx,%eax
  75:	01 c0                	add    %eax,%eax
  77:	29 c3                	sub    %eax,%ebx
  79:	89 d9                	mov    %ebx,%ecx
              argv[0],
              ticks_total / 100,
              ticks_total % 100 / 10,
  7b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  7e:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  83:	89 d8                	mov    %ebx,%eax
  85:	f7 e2                	mul    %edx
  87:	89 d0                	mov    %edx,%eax
  89:	c1 e8 05             	shr    $0x5,%eax
  8c:	6b c0 64             	imul   $0x64,%eax,%eax
  8f:	29 c3                	sub    %eax,%ebx
  91:	89 d8                	mov    %ebx,%eax
    
    // calculate time delta
    ticks_total += uptime() - ticks_in;
    
    // print result
    printf(1, "%s ran in %d.%d%d seconds.\n",
  93:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  98:	f7 e2                	mul    %edx
  9a:	89 d3                	mov    %edx,%ebx
  9c:	c1 eb 03             	shr    $0x3,%ebx
  9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  a2:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  a7:	f7 e2                	mul    %edx
  a9:	c1 ea 05             	shr    $0x5,%edx
  ac:	8b 45 08             	mov    0x8(%ebp),%eax
  af:	8b 00                	mov    (%eax),%eax
  b1:	83 ec 08             	sub    $0x8,%esp
  b4:	51                   	push   %ecx
  b5:	53                   	push   %ebx
  b6:	52                   	push   %edx
  b7:	50                   	push   %eax
  b8:	68 bd 09 00 00       	push   $0x9bd
  bd:	6a 01                	push   $0x1
  bf:	e8 43 05 00 00       	call   607 <printf>
  c4:	83 c4 20             	add    $0x20,%esp
              ticks_total % 100 % 10);
    
  }
 
  // if current proc is not parent, then exec
  if (pid != getpid())
  c7:	e8 e4 03 00 00       	call   4b0 <getpid>
  cc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  cf:	74 26                	je     f7 <time+0xf7>
  {
    exec(argv[0], &argv[0]);
  d1:	8b 45 08             	mov    0x8(%ebp),%eax
  d4:	8b 00                	mov    (%eax),%eax
  d6:	83 ec 08             	sub    $0x8,%esp
  d9:	ff 75 08             	pushl  0x8(%ebp)
  dc:	50                   	push   %eax
  dd:	e8 86 03 00 00       	call   468 <exec>
  e2:	83 c4 10             	add    $0x10,%esp
    
    // if the executed command is not valid, print an error
    printf(1, "Not a valid command. \n");
  e5:	83 ec 08             	sub    $0x8,%esp
  e8:	68 d9 09 00 00       	push   $0x9d9
  ed:	6a 01                	push   $0x1
  ef:	e8 13 05 00 00       	call   607 <printf>
  f4:	83 c4 10             	add    $0x10,%esp
  }

  return 0;
  f7:	b8 00 00 00 00       	mov    $0x0,%eax
} 
  fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  ff:	c9                   	leave  
 100:	c3                   	ret    

00000101 <main>:

int
main(int argc, char *argv[])
{
 101:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 105:	83 e4 f0             	and    $0xfffffff0,%esp
 108:	ff 71 fc             	pushl  -0x4(%ecx)
 10b:	55                   	push   %ebp
 10c:	89 e5                	mov    %esp,%ebp
 10e:	51                   	push   %ecx
 10f:	83 ec 04             	sub    $0x4,%esp
 112:	89 c8                	mov    %ecx,%eax

  // if there is an arg then keep track of the time,
  // otherwise no program, so 0.00 secs is printed
  if (argv[1] != 0)
 114:	8b 50 04             	mov    0x4(%eax),%edx
 117:	83 c2 04             	add    $0x4,%edx
 11a:	8b 12                	mov    (%edx),%edx
 11c:	85 d2                	test   %edx,%edx
 11e:	74 14                	je     134 <main+0x33>
    time(&argv[1]);
 120:	8b 40 04             	mov    0x4(%eax),%eax
 123:	83 c0 04             	add    $0x4,%eax
 126:	83 ec 0c             	sub    $0xc,%esp
 129:	50                   	push   %eax
 12a:	e8 d1 fe ff ff       	call   0 <time>
 12f:	83 c4 10             	add    $0x10,%esp
 132:	eb 12                	jmp    146 <main+0x45>
  else
    printf(1, "ran in 0.00 seconds.\n");
 134:	83 ec 08             	sub    $0x8,%esp
 137:	68 f0 09 00 00       	push   $0x9f0
 13c:	6a 01                	push   $0x1
 13e:	e8 c4 04 00 00       	call   607 <printf>
 143:	83 c4 10             	add    $0x10,%esp
  exit();
 146:	e8 e5 02 00 00       	call   430 <exit>

0000014b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 14b:	55                   	push   %ebp
 14c:	89 e5                	mov    %esp,%ebp
 14e:	57                   	push   %edi
 14f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 150:	8b 4d 08             	mov    0x8(%ebp),%ecx
 153:	8b 55 10             	mov    0x10(%ebp),%edx
 156:	8b 45 0c             	mov    0xc(%ebp),%eax
 159:	89 cb                	mov    %ecx,%ebx
 15b:	89 df                	mov    %ebx,%edi
 15d:	89 d1                	mov    %edx,%ecx
 15f:	fc                   	cld    
 160:	f3 aa                	rep stos %al,%es:(%edi)
 162:	89 ca                	mov    %ecx,%edx
 164:	89 fb                	mov    %edi,%ebx
 166:	89 5d 08             	mov    %ebx,0x8(%ebp)
 169:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 16c:	90                   	nop
 16d:	5b                   	pop    %ebx
 16e:	5f                   	pop    %edi
 16f:	5d                   	pop    %ebp
 170:	c3                   	ret    

00000171 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 171:	55                   	push   %ebp
 172:	89 e5                	mov    %esp,%ebp
 174:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 177:	8b 45 08             	mov    0x8(%ebp),%eax
 17a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 17d:	90                   	nop
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	8d 50 01             	lea    0x1(%eax),%edx
 184:	89 55 08             	mov    %edx,0x8(%ebp)
 187:	8b 55 0c             	mov    0xc(%ebp),%edx
 18a:	8d 4a 01             	lea    0x1(%edx),%ecx
 18d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 190:	0f b6 12             	movzbl (%edx),%edx
 193:	88 10                	mov    %dl,(%eax)
 195:	0f b6 00             	movzbl (%eax),%eax
 198:	84 c0                	test   %al,%al
 19a:	75 e2                	jne    17e <strcpy+0xd>
    ;
  return os;
 19c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 19f:	c9                   	leave  
 1a0:	c3                   	ret    

000001a1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1a1:	55                   	push   %ebp
 1a2:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1a4:	eb 08                	jmp    1ae <strcmp+0xd>
    p++, q++;
 1a6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1aa:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1ae:	8b 45 08             	mov    0x8(%ebp),%eax
 1b1:	0f b6 00             	movzbl (%eax),%eax
 1b4:	84 c0                	test   %al,%al
 1b6:	74 10                	je     1c8 <strcmp+0x27>
 1b8:	8b 45 08             	mov    0x8(%ebp),%eax
 1bb:	0f b6 10             	movzbl (%eax),%edx
 1be:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c1:	0f b6 00             	movzbl (%eax),%eax
 1c4:	38 c2                	cmp    %al,%dl
 1c6:	74 de                	je     1a6 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1c8:	8b 45 08             	mov    0x8(%ebp),%eax
 1cb:	0f b6 00             	movzbl (%eax),%eax
 1ce:	0f b6 d0             	movzbl %al,%edx
 1d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d4:	0f b6 00             	movzbl (%eax),%eax
 1d7:	0f b6 c0             	movzbl %al,%eax
 1da:	29 c2                	sub    %eax,%edx
 1dc:	89 d0                	mov    %edx,%eax
}
 1de:	5d                   	pop    %ebp
 1df:	c3                   	ret    

000001e0 <strlen>:

uint
strlen(char *s)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1ed:	eb 04                	jmp    1f3 <strlen+0x13>
 1ef:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1f6:	8b 45 08             	mov    0x8(%ebp),%eax
 1f9:	01 d0                	add    %edx,%eax
 1fb:	0f b6 00             	movzbl (%eax),%eax
 1fe:	84 c0                	test   %al,%al
 200:	75 ed                	jne    1ef <strlen+0xf>
    ;
  return n;
 202:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 205:	c9                   	leave  
 206:	c3                   	ret    

00000207 <memset>:

void*
memset(void *dst, int c, uint n)
{
 207:	55                   	push   %ebp
 208:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 20a:	8b 45 10             	mov    0x10(%ebp),%eax
 20d:	50                   	push   %eax
 20e:	ff 75 0c             	pushl  0xc(%ebp)
 211:	ff 75 08             	pushl  0x8(%ebp)
 214:	e8 32 ff ff ff       	call   14b <stosb>
 219:	83 c4 0c             	add    $0xc,%esp
  return dst;
 21c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 21f:	c9                   	leave  
 220:	c3                   	ret    

00000221 <strchr>:

char*
strchr(const char *s, char c)
{
 221:	55                   	push   %ebp
 222:	89 e5                	mov    %esp,%ebp
 224:	83 ec 04             	sub    $0x4,%esp
 227:	8b 45 0c             	mov    0xc(%ebp),%eax
 22a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 22d:	eb 14                	jmp    243 <strchr+0x22>
    if(*s == c)
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	0f b6 00             	movzbl (%eax),%eax
 235:	3a 45 fc             	cmp    -0x4(%ebp),%al
 238:	75 05                	jne    23f <strchr+0x1e>
      return (char*)s;
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	eb 13                	jmp    252 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 23f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 243:	8b 45 08             	mov    0x8(%ebp),%eax
 246:	0f b6 00             	movzbl (%eax),%eax
 249:	84 c0                	test   %al,%al
 24b:	75 e2                	jne    22f <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 24d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 252:	c9                   	leave  
 253:	c3                   	ret    

00000254 <gets>:

char*
gets(char *buf, int max)
{
 254:	55                   	push   %ebp
 255:	89 e5                	mov    %esp,%ebp
 257:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 261:	eb 42                	jmp    2a5 <gets+0x51>
    cc = read(0, &c, 1);
 263:	83 ec 04             	sub    $0x4,%esp
 266:	6a 01                	push   $0x1
 268:	8d 45 ef             	lea    -0x11(%ebp),%eax
 26b:	50                   	push   %eax
 26c:	6a 00                	push   $0x0
 26e:	e8 d5 01 00 00       	call   448 <read>
 273:	83 c4 10             	add    $0x10,%esp
 276:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 279:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 27d:	7e 33                	jle    2b2 <gets+0x5e>
      break;
    buf[i++] = c;
 27f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 282:	8d 50 01             	lea    0x1(%eax),%edx
 285:	89 55 f4             	mov    %edx,-0xc(%ebp)
 288:	89 c2                	mov    %eax,%edx
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	01 c2                	add    %eax,%edx
 28f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 293:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 295:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 299:	3c 0a                	cmp    $0xa,%al
 29b:	74 16                	je     2b3 <gets+0x5f>
 29d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a1:	3c 0d                	cmp    $0xd,%al
 2a3:	74 0e                	je     2b3 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2a8:	83 c0 01             	add    $0x1,%eax
 2ab:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2ae:	7c b3                	jl     263 <gets+0xf>
 2b0:	eb 01                	jmp    2b3 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2b2:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2b6:	8b 45 08             	mov    0x8(%ebp),%eax
 2b9:	01 d0                	add    %edx,%eax
 2bb:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2be:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c1:	c9                   	leave  
 2c2:	c3                   	ret    

000002c3 <stat>:

int
stat(char *n, struct stat *st)
{
 2c3:	55                   	push   %ebp
 2c4:	89 e5                	mov    %esp,%ebp
 2c6:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c9:	83 ec 08             	sub    $0x8,%esp
 2cc:	6a 00                	push   $0x0
 2ce:	ff 75 08             	pushl  0x8(%ebp)
 2d1:	e8 9a 01 00 00       	call   470 <open>
 2d6:	83 c4 10             	add    $0x10,%esp
 2d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2e0:	79 07                	jns    2e9 <stat+0x26>
    return -1;
 2e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2e7:	eb 25                	jmp    30e <stat+0x4b>
  r = fstat(fd, st);
 2e9:	83 ec 08             	sub    $0x8,%esp
 2ec:	ff 75 0c             	pushl  0xc(%ebp)
 2ef:	ff 75 f4             	pushl  -0xc(%ebp)
 2f2:	e8 91 01 00 00       	call   488 <fstat>
 2f7:	83 c4 10             	add    $0x10,%esp
 2fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2fd:	83 ec 0c             	sub    $0xc,%esp
 300:	ff 75 f4             	pushl  -0xc(%ebp)
 303:	e8 50 01 00 00       	call   458 <close>
 308:	83 c4 10             	add    $0x10,%esp
  return r;
 30b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 30e:	c9                   	leave  
 30f:	c3                   	ret    

00000310 <atoi>:

int
atoi(const char *s)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 316:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 31d:	eb 25                	jmp    344 <atoi+0x34>
    n = n*10 + *s++ - '0';
 31f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 322:	89 d0                	mov    %edx,%eax
 324:	c1 e0 02             	shl    $0x2,%eax
 327:	01 d0                	add    %edx,%eax
 329:	01 c0                	add    %eax,%eax
 32b:	89 c1                	mov    %eax,%ecx
 32d:	8b 45 08             	mov    0x8(%ebp),%eax
 330:	8d 50 01             	lea    0x1(%eax),%edx
 333:	89 55 08             	mov    %edx,0x8(%ebp)
 336:	0f b6 00             	movzbl (%eax),%eax
 339:	0f be c0             	movsbl %al,%eax
 33c:	01 c8                	add    %ecx,%eax
 33e:	83 e8 30             	sub    $0x30,%eax
 341:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 344:	8b 45 08             	mov    0x8(%ebp),%eax
 347:	0f b6 00             	movzbl (%eax),%eax
 34a:	3c 2f                	cmp    $0x2f,%al
 34c:	7e 0a                	jle    358 <atoi+0x48>
 34e:	8b 45 08             	mov    0x8(%ebp),%eax
 351:	0f b6 00             	movzbl (%eax),%eax
 354:	3c 39                	cmp    $0x39,%al
 356:	7e c7                	jle    31f <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 358:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 35b:	c9                   	leave  
 35c:	c3                   	ret    

0000035d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 35d:	55                   	push   %ebp
 35e:	89 e5                	mov    %esp,%ebp
 360:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 363:	8b 45 08             	mov    0x8(%ebp),%eax
 366:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 369:	8b 45 0c             	mov    0xc(%ebp),%eax
 36c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 36f:	eb 17                	jmp    388 <memmove+0x2b>
    *dst++ = *src++;
 371:	8b 45 fc             	mov    -0x4(%ebp),%eax
 374:	8d 50 01             	lea    0x1(%eax),%edx
 377:	89 55 fc             	mov    %edx,-0x4(%ebp)
 37a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 37d:	8d 4a 01             	lea    0x1(%edx),%ecx
 380:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 383:	0f b6 12             	movzbl (%edx),%edx
 386:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 388:	8b 45 10             	mov    0x10(%ebp),%eax
 38b:	8d 50 ff             	lea    -0x1(%eax),%edx
 38e:	89 55 10             	mov    %edx,0x10(%ebp)
 391:	85 c0                	test   %eax,%eax
 393:	7f dc                	jg     371 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 395:	8b 45 08             	mov    0x8(%ebp),%eax
}
 398:	c9                   	leave  
 399:	c3                   	ret    

0000039a <atoo>:

int
atoo(const char *s)
{
 39a:	55                   	push   %ebp
 39b:	89 e5                	mov    %esp,%ebp
 39d:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 3a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 3a7:	eb 04                	jmp    3ad <atoo+0x13>
 3a9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3ad:	8b 45 08             	mov    0x8(%ebp),%eax
 3b0:	0f b6 00             	movzbl (%eax),%eax
 3b3:	3c 20                	cmp    $0x20,%al
 3b5:	74 f2                	je     3a9 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 3b7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ba:	0f b6 00             	movzbl (%eax),%eax
 3bd:	3c 2d                	cmp    $0x2d,%al
 3bf:	75 07                	jne    3c8 <atoo+0x2e>
 3c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3c6:	eb 05                	jmp    3cd <atoo+0x33>
 3c8:	b8 01 00 00 00       	mov    $0x1,%eax
 3cd:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 3d0:	8b 45 08             	mov    0x8(%ebp),%eax
 3d3:	0f b6 00             	movzbl (%eax),%eax
 3d6:	3c 2b                	cmp    $0x2b,%al
 3d8:	74 0a                	je     3e4 <atoo+0x4a>
 3da:	8b 45 08             	mov    0x8(%ebp),%eax
 3dd:	0f b6 00             	movzbl (%eax),%eax
 3e0:	3c 2d                	cmp    $0x2d,%al
 3e2:	75 27                	jne    40b <atoo+0x71>
    s++;
 3e4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 3e8:	eb 21                	jmp    40b <atoo+0x71>
    n = n*8 + *s++ - '0';
 3ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3ed:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 3f4:	8b 45 08             	mov    0x8(%ebp),%eax
 3f7:	8d 50 01             	lea    0x1(%eax),%edx
 3fa:	89 55 08             	mov    %edx,0x8(%ebp)
 3fd:	0f b6 00             	movzbl (%eax),%eax
 400:	0f be c0             	movsbl %al,%eax
 403:	01 c8                	add    %ecx,%eax
 405:	83 e8 30             	sub    $0x30,%eax
 408:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 40b:	8b 45 08             	mov    0x8(%ebp),%eax
 40e:	0f b6 00             	movzbl (%eax),%eax
 411:	3c 2f                	cmp    $0x2f,%al
 413:	7e 0a                	jle    41f <atoo+0x85>
 415:	8b 45 08             	mov    0x8(%ebp),%eax
 418:	0f b6 00             	movzbl (%eax),%eax
 41b:	3c 37                	cmp    $0x37,%al
 41d:	7e cb                	jle    3ea <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 41f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 422:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 426:	c9                   	leave  
 427:	c3                   	ret    

00000428 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 428:	b8 01 00 00 00       	mov    $0x1,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <exit>:
SYSCALL(exit)
 430:	b8 02 00 00 00       	mov    $0x2,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <wait>:
SYSCALL(wait)
 438:	b8 03 00 00 00       	mov    $0x3,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <pipe>:
SYSCALL(pipe)
 440:	b8 04 00 00 00       	mov    $0x4,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <read>:
SYSCALL(read)
 448:	b8 05 00 00 00       	mov    $0x5,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <write>:
SYSCALL(write)
 450:	b8 10 00 00 00       	mov    $0x10,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <close>:
SYSCALL(close)
 458:	b8 15 00 00 00       	mov    $0x15,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <kill>:
SYSCALL(kill)
 460:	b8 06 00 00 00       	mov    $0x6,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    

00000468 <exec>:
SYSCALL(exec)
 468:	b8 07 00 00 00       	mov    $0x7,%eax
 46d:	cd 40                	int    $0x40
 46f:	c3                   	ret    

00000470 <open>:
SYSCALL(open)
 470:	b8 0f 00 00 00       	mov    $0xf,%eax
 475:	cd 40                	int    $0x40
 477:	c3                   	ret    

00000478 <mknod>:
SYSCALL(mknod)
 478:	b8 11 00 00 00       	mov    $0x11,%eax
 47d:	cd 40                	int    $0x40
 47f:	c3                   	ret    

00000480 <unlink>:
SYSCALL(unlink)
 480:	b8 12 00 00 00       	mov    $0x12,%eax
 485:	cd 40                	int    $0x40
 487:	c3                   	ret    

00000488 <fstat>:
SYSCALL(fstat)
 488:	b8 08 00 00 00       	mov    $0x8,%eax
 48d:	cd 40                	int    $0x40
 48f:	c3                   	ret    

00000490 <link>:
SYSCALL(link)
 490:	b8 13 00 00 00       	mov    $0x13,%eax
 495:	cd 40                	int    $0x40
 497:	c3                   	ret    

00000498 <mkdir>:
SYSCALL(mkdir)
 498:	b8 14 00 00 00       	mov    $0x14,%eax
 49d:	cd 40                	int    $0x40
 49f:	c3                   	ret    

000004a0 <chdir>:
SYSCALL(chdir)
 4a0:	b8 09 00 00 00       	mov    $0x9,%eax
 4a5:	cd 40                	int    $0x40
 4a7:	c3                   	ret    

000004a8 <dup>:
SYSCALL(dup)
 4a8:	b8 0a 00 00 00       	mov    $0xa,%eax
 4ad:	cd 40                	int    $0x40
 4af:	c3                   	ret    

000004b0 <getpid>:
SYSCALL(getpid)
 4b0:	b8 0b 00 00 00       	mov    $0xb,%eax
 4b5:	cd 40                	int    $0x40
 4b7:	c3                   	ret    

000004b8 <sbrk>:
SYSCALL(sbrk)
 4b8:	b8 0c 00 00 00       	mov    $0xc,%eax
 4bd:	cd 40                	int    $0x40
 4bf:	c3                   	ret    

000004c0 <sleep>:
SYSCALL(sleep)
 4c0:	b8 0d 00 00 00       	mov    $0xd,%eax
 4c5:	cd 40                	int    $0x40
 4c7:	c3                   	ret    

000004c8 <uptime>:
SYSCALL(uptime)
 4c8:	b8 0e 00 00 00       	mov    $0xe,%eax
 4cd:	cd 40                	int    $0x40
 4cf:	c3                   	ret    

000004d0 <halt>:
SYSCALL(halt)
 4d0:	b8 16 00 00 00       	mov    $0x16,%eax
 4d5:	cd 40                	int    $0x40
 4d7:	c3                   	ret    

000004d8 <date>:
SYSCALL(date) // Added for Project 1: The date() System Call
 4d8:	b8 17 00 00 00       	mov    $0x17,%eax
 4dd:	cd 40                	int    $0x40
 4df:	c3                   	ret    

000004e0 <getuid>:
SYSCALL(getuid) // Added for Project 2: UIDs and GIDs and PPIDs
 4e0:	b8 18 00 00 00       	mov    $0x18,%eax
 4e5:	cd 40                	int    $0x40
 4e7:	c3                   	ret    

000004e8 <getgid>:
SYSCALL(getgid) // Added for Project 2: UIDs and GIDs and PPIDs
 4e8:	b8 19 00 00 00       	mov    $0x19,%eax
 4ed:	cd 40                	int    $0x40
 4ef:	c3                   	ret    

000004f0 <getppid>:
SYSCALL(getppid) // Added for Project 2: UIDs and GIDs and PPIDs
 4f0:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4f5:	cd 40                	int    $0x40
 4f7:	c3                   	ret    

000004f8 <setuid>:
SYSCALL(setuid) // Added for Project 2: UIDs and GIDs and PPIDs
 4f8:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4fd:	cd 40                	int    $0x40
 4ff:	c3                   	ret    

00000500 <setgid>:
SYSCALL(setgid) // Added for Project 2: UIDs and GIDs and PPIDs  
 500:	b8 1c 00 00 00       	mov    $0x1c,%eax
 505:	cd 40                	int    $0x40
 507:	c3                   	ret    

00000508 <getprocs>:
SYSCALL(getprocs) // Added for Project 2: The "ps" Command
 508:	b8 1a 00 00 00       	mov    $0x1a,%eax
 50d:	cd 40                	int    $0x40
 50f:	c3                   	ret    

00000510 <setpriority>:
SYSCALL(setpriority) // Added for Project 4: The setpriority() System Call
 510:	b8 1b 00 00 00       	mov    $0x1b,%eax
 515:	cd 40                	int    $0x40
 517:	c3                   	ret    

00000518 <chmod>:
SYSCALL(chmod) // Added for Project 5: New System Calls
 518:	b8 1c 00 00 00       	mov    $0x1c,%eax
 51d:	cd 40                	int    $0x40
 51f:	c3                   	ret    

00000520 <chown>:
SYSCALL(chown) // Added for Project 5: New System Calls
 520:	b8 1d 00 00 00       	mov    $0x1d,%eax
 525:	cd 40                	int    $0x40
 527:	c3                   	ret    

00000528 <chgrp>:
SYSCALL(chgrp) // Added for Project 5: New System Calls
 528:	b8 1e 00 00 00       	mov    $0x1e,%eax
 52d:	cd 40                	int    $0x40
 52f:	c3                   	ret    

00000530 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	83 ec 18             	sub    $0x18,%esp
 536:	8b 45 0c             	mov    0xc(%ebp),%eax
 539:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 53c:	83 ec 04             	sub    $0x4,%esp
 53f:	6a 01                	push   $0x1
 541:	8d 45 f4             	lea    -0xc(%ebp),%eax
 544:	50                   	push   %eax
 545:	ff 75 08             	pushl  0x8(%ebp)
 548:	e8 03 ff ff ff       	call   450 <write>
 54d:	83 c4 10             	add    $0x10,%esp
}
 550:	90                   	nop
 551:	c9                   	leave  
 552:	c3                   	ret    

00000553 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 553:	55                   	push   %ebp
 554:	89 e5                	mov    %esp,%ebp
 556:	53                   	push   %ebx
 557:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 55a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 561:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 565:	74 17                	je     57e <printint+0x2b>
 567:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 56b:	79 11                	jns    57e <printint+0x2b>
    neg = 1;
 56d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 574:	8b 45 0c             	mov    0xc(%ebp),%eax
 577:	f7 d8                	neg    %eax
 579:	89 45 ec             	mov    %eax,-0x14(%ebp)
 57c:	eb 06                	jmp    584 <printint+0x31>
  } else {
    x = xx;
 57e:	8b 45 0c             	mov    0xc(%ebp),%eax
 581:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 584:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 58b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 58e:	8d 41 01             	lea    0x1(%ecx),%eax
 591:	89 45 f4             	mov    %eax,-0xc(%ebp)
 594:	8b 5d 10             	mov    0x10(%ebp),%ebx
 597:	8b 45 ec             	mov    -0x14(%ebp),%eax
 59a:	ba 00 00 00 00       	mov    $0x0,%edx
 59f:	f7 f3                	div    %ebx
 5a1:	89 d0                	mov    %edx,%eax
 5a3:	0f b6 80 9c 0c 00 00 	movzbl 0xc9c(%eax),%eax
 5aa:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5b4:	ba 00 00 00 00       	mov    $0x0,%edx
 5b9:	f7 f3                	div    %ebx
 5bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5c2:	75 c7                	jne    58b <printint+0x38>
  if(neg)
 5c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5c8:	74 2d                	je     5f7 <printint+0xa4>
    buf[i++] = '-';
 5ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5cd:	8d 50 01             	lea    0x1(%eax),%edx
 5d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5d3:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5d8:	eb 1d                	jmp    5f7 <printint+0xa4>
    putc(fd, buf[i]);
 5da:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e0:	01 d0                	add    %edx,%eax
 5e2:	0f b6 00             	movzbl (%eax),%eax
 5e5:	0f be c0             	movsbl %al,%eax
 5e8:	83 ec 08             	sub    $0x8,%esp
 5eb:	50                   	push   %eax
 5ec:	ff 75 08             	pushl  0x8(%ebp)
 5ef:	e8 3c ff ff ff       	call   530 <putc>
 5f4:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5f7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ff:	79 d9                	jns    5da <printint+0x87>
    putc(fd, buf[i]);
}
 601:	90                   	nop
 602:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 605:	c9                   	leave  
 606:	c3                   	ret    

00000607 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 607:	55                   	push   %ebp
 608:	89 e5                	mov    %esp,%ebp
 60a:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 60d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 614:	8d 45 0c             	lea    0xc(%ebp),%eax
 617:	83 c0 04             	add    $0x4,%eax
 61a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 61d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 624:	e9 59 01 00 00       	jmp    782 <printf+0x17b>
    c = fmt[i] & 0xff;
 629:	8b 55 0c             	mov    0xc(%ebp),%edx
 62c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 62f:	01 d0                	add    %edx,%eax
 631:	0f b6 00             	movzbl (%eax),%eax
 634:	0f be c0             	movsbl %al,%eax
 637:	25 ff 00 00 00       	and    $0xff,%eax
 63c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 63f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 643:	75 2c                	jne    671 <printf+0x6a>
      if(c == '%'){
 645:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 649:	75 0c                	jne    657 <printf+0x50>
        state = '%';
 64b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 652:	e9 27 01 00 00       	jmp    77e <printf+0x177>
      } else {
        putc(fd, c);
 657:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 65a:	0f be c0             	movsbl %al,%eax
 65d:	83 ec 08             	sub    $0x8,%esp
 660:	50                   	push   %eax
 661:	ff 75 08             	pushl  0x8(%ebp)
 664:	e8 c7 fe ff ff       	call   530 <putc>
 669:	83 c4 10             	add    $0x10,%esp
 66c:	e9 0d 01 00 00       	jmp    77e <printf+0x177>
      }
    } else if(state == '%'){
 671:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 675:	0f 85 03 01 00 00    	jne    77e <printf+0x177>
      if(c == 'd'){
 67b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 67f:	75 1e                	jne    69f <printf+0x98>
        printint(fd, *ap, 10, 1);
 681:	8b 45 e8             	mov    -0x18(%ebp),%eax
 684:	8b 00                	mov    (%eax),%eax
 686:	6a 01                	push   $0x1
 688:	6a 0a                	push   $0xa
 68a:	50                   	push   %eax
 68b:	ff 75 08             	pushl  0x8(%ebp)
 68e:	e8 c0 fe ff ff       	call   553 <printint>
 693:	83 c4 10             	add    $0x10,%esp
        ap++;
 696:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 69a:	e9 d8 00 00 00       	jmp    777 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 69f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6a3:	74 06                	je     6ab <printf+0xa4>
 6a5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6a9:	75 1e                	jne    6c9 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 6ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6ae:	8b 00                	mov    (%eax),%eax
 6b0:	6a 00                	push   $0x0
 6b2:	6a 10                	push   $0x10
 6b4:	50                   	push   %eax
 6b5:	ff 75 08             	pushl  0x8(%ebp)
 6b8:	e8 96 fe ff ff       	call   553 <printint>
 6bd:	83 c4 10             	add    $0x10,%esp
        ap++;
 6c0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6c4:	e9 ae 00 00 00       	jmp    777 <printf+0x170>
      } else if(c == 's'){
 6c9:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6cd:	75 43                	jne    712 <printf+0x10b>
        s = (char*)*ap;
 6cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6d2:	8b 00                	mov    (%eax),%eax
 6d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6d7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6df:	75 25                	jne    706 <printf+0xff>
          s = "(null)";
 6e1:	c7 45 f4 06 0a 00 00 	movl   $0xa06,-0xc(%ebp)
        while(*s != 0){
 6e8:	eb 1c                	jmp    706 <printf+0xff>
          putc(fd, *s);
 6ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ed:	0f b6 00             	movzbl (%eax),%eax
 6f0:	0f be c0             	movsbl %al,%eax
 6f3:	83 ec 08             	sub    $0x8,%esp
 6f6:	50                   	push   %eax
 6f7:	ff 75 08             	pushl  0x8(%ebp)
 6fa:	e8 31 fe ff ff       	call   530 <putc>
 6ff:	83 c4 10             	add    $0x10,%esp
          s++;
 702:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 706:	8b 45 f4             	mov    -0xc(%ebp),%eax
 709:	0f b6 00             	movzbl (%eax),%eax
 70c:	84 c0                	test   %al,%al
 70e:	75 da                	jne    6ea <printf+0xe3>
 710:	eb 65                	jmp    777 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 712:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 716:	75 1d                	jne    735 <printf+0x12e>
        putc(fd, *ap);
 718:	8b 45 e8             	mov    -0x18(%ebp),%eax
 71b:	8b 00                	mov    (%eax),%eax
 71d:	0f be c0             	movsbl %al,%eax
 720:	83 ec 08             	sub    $0x8,%esp
 723:	50                   	push   %eax
 724:	ff 75 08             	pushl  0x8(%ebp)
 727:	e8 04 fe ff ff       	call   530 <putc>
 72c:	83 c4 10             	add    $0x10,%esp
        ap++;
 72f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 733:	eb 42                	jmp    777 <printf+0x170>
      } else if(c == '%'){
 735:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 739:	75 17                	jne    752 <printf+0x14b>
        putc(fd, c);
 73b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 73e:	0f be c0             	movsbl %al,%eax
 741:	83 ec 08             	sub    $0x8,%esp
 744:	50                   	push   %eax
 745:	ff 75 08             	pushl  0x8(%ebp)
 748:	e8 e3 fd ff ff       	call   530 <putc>
 74d:	83 c4 10             	add    $0x10,%esp
 750:	eb 25                	jmp    777 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 752:	83 ec 08             	sub    $0x8,%esp
 755:	6a 25                	push   $0x25
 757:	ff 75 08             	pushl  0x8(%ebp)
 75a:	e8 d1 fd ff ff       	call   530 <putc>
 75f:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 762:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 765:	0f be c0             	movsbl %al,%eax
 768:	83 ec 08             	sub    $0x8,%esp
 76b:	50                   	push   %eax
 76c:	ff 75 08             	pushl  0x8(%ebp)
 76f:	e8 bc fd ff ff       	call   530 <putc>
 774:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 777:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 77e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 782:	8b 55 0c             	mov    0xc(%ebp),%edx
 785:	8b 45 f0             	mov    -0x10(%ebp),%eax
 788:	01 d0                	add    %edx,%eax
 78a:	0f b6 00             	movzbl (%eax),%eax
 78d:	84 c0                	test   %al,%al
 78f:	0f 85 94 fe ff ff    	jne    629 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 795:	90                   	nop
 796:	c9                   	leave  
 797:	c3                   	ret    

00000798 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 798:	55                   	push   %ebp
 799:	89 e5                	mov    %esp,%ebp
 79b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 79e:	8b 45 08             	mov    0x8(%ebp),%eax
 7a1:	83 e8 08             	sub    $0x8,%eax
 7a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a7:	a1 b8 0c 00 00       	mov    0xcb8,%eax
 7ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7af:	eb 24                	jmp    7d5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b4:	8b 00                	mov    (%eax),%eax
 7b6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7b9:	77 12                	ja     7cd <free+0x35>
 7bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7be:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7c1:	77 24                	ja     7e7 <free+0x4f>
 7c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c6:	8b 00                	mov    (%eax),%eax
 7c8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7cb:	77 1a                	ja     7e7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d0:	8b 00                	mov    (%eax),%eax
 7d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7db:	76 d4                	jbe    7b1 <free+0x19>
 7dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e0:	8b 00                	mov    (%eax),%eax
 7e2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7e5:	76 ca                	jbe    7b1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ea:	8b 40 04             	mov    0x4(%eax),%eax
 7ed:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f7:	01 c2                	add    %eax,%edx
 7f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fc:	8b 00                	mov    (%eax),%eax
 7fe:	39 c2                	cmp    %eax,%edx
 800:	75 24                	jne    826 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 802:	8b 45 f8             	mov    -0x8(%ebp),%eax
 805:	8b 50 04             	mov    0x4(%eax),%edx
 808:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80b:	8b 00                	mov    (%eax),%eax
 80d:	8b 40 04             	mov    0x4(%eax),%eax
 810:	01 c2                	add    %eax,%edx
 812:	8b 45 f8             	mov    -0x8(%ebp),%eax
 815:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 818:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81b:	8b 00                	mov    (%eax),%eax
 81d:	8b 10                	mov    (%eax),%edx
 81f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 822:	89 10                	mov    %edx,(%eax)
 824:	eb 0a                	jmp    830 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 826:	8b 45 fc             	mov    -0x4(%ebp),%eax
 829:	8b 10                	mov    (%eax),%edx
 82b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 82e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 830:	8b 45 fc             	mov    -0x4(%ebp),%eax
 833:	8b 40 04             	mov    0x4(%eax),%eax
 836:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 83d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 840:	01 d0                	add    %edx,%eax
 842:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 845:	75 20                	jne    867 <free+0xcf>
    p->s.size += bp->s.size;
 847:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84a:	8b 50 04             	mov    0x4(%eax),%edx
 84d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 850:	8b 40 04             	mov    0x4(%eax),%eax
 853:	01 c2                	add    %eax,%edx
 855:	8b 45 fc             	mov    -0x4(%ebp),%eax
 858:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 85b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 85e:	8b 10                	mov    (%eax),%edx
 860:	8b 45 fc             	mov    -0x4(%ebp),%eax
 863:	89 10                	mov    %edx,(%eax)
 865:	eb 08                	jmp    86f <free+0xd7>
  } else
    p->s.ptr = bp;
 867:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 86d:	89 10                	mov    %edx,(%eax)
  freep = p;
 86f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 872:	a3 b8 0c 00 00       	mov    %eax,0xcb8
}
 877:	90                   	nop
 878:	c9                   	leave  
 879:	c3                   	ret    

0000087a <morecore>:

static Header*
morecore(uint nu)
{
 87a:	55                   	push   %ebp
 87b:	89 e5                	mov    %esp,%ebp
 87d:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 880:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 887:	77 07                	ja     890 <morecore+0x16>
    nu = 4096;
 889:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 890:	8b 45 08             	mov    0x8(%ebp),%eax
 893:	c1 e0 03             	shl    $0x3,%eax
 896:	83 ec 0c             	sub    $0xc,%esp
 899:	50                   	push   %eax
 89a:	e8 19 fc ff ff       	call   4b8 <sbrk>
 89f:	83 c4 10             	add    $0x10,%esp
 8a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8a5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8a9:	75 07                	jne    8b2 <morecore+0x38>
    return 0;
 8ab:	b8 00 00 00 00       	mov    $0x0,%eax
 8b0:	eb 26                	jmp    8d8 <morecore+0x5e>
  hp = (Header*)p;
 8b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8bb:	8b 55 08             	mov    0x8(%ebp),%edx
 8be:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c4:	83 c0 08             	add    $0x8,%eax
 8c7:	83 ec 0c             	sub    $0xc,%esp
 8ca:	50                   	push   %eax
 8cb:	e8 c8 fe ff ff       	call   798 <free>
 8d0:	83 c4 10             	add    $0x10,%esp
  return freep;
 8d3:	a1 b8 0c 00 00       	mov    0xcb8,%eax
}
 8d8:	c9                   	leave  
 8d9:	c3                   	ret    

000008da <malloc>:

void*
malloc(uint nbytes)
{
 8da:	55                   	push   %ebp
 8db:	89 e5                	mov    %esp,%ebp
 8dd:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8e0:	8b 45 08             	mov    0x8(%ebp),%eax
 8e3:	83 c0 07             	add    $0x7,%eax
 8e6:	c1 e8 03             	shr    $0x3,%eax
 8e9:	83 c0 01             	add    $0x1,%eax
 8ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8ef:	a1 b8 0c 00 00       	mov    0xcb8,%eax
 8f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8fb:	75 23                	jne    920 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8fd:	c7 45 f0 b0 0c 00 00 	movl   $0xcb0,-0x10(%ebp)
 904:	8b 45 f0             	mov    -0x10(%ebp),%eax
 907:	a3 b8 0c 00 00       	mov    %eax,0xcb8
 90c:	a1 b8 0c 00 00       	mov    0xcb8,%eax
 911:	a3 b0 0c 00 00       	mov    %eax,0xcb0
    base.s.size = 0;
 916:	c7 05 b4 0c 00 00 00 	movl   $0x0,0xcb4
 91d:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 920:	8b 45 f0             	mov    -0x10(%ebp),%eax
 923:	8b 00                	mov    (%eax),%eax
 925:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 928:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92b:	8b 40 04             	mov    0x4(%eax),%eax
 92e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 931:	72 4d                	jb     980 <malloc+0xa6>
      if(p->s.size == nunits)
 933:	8b 45 f4             	mov    -0xc(%ebp),%eax
 936:	8b 40 04             	mov    0x4(%eax),%eax
 939:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 93c:	75 0c                	jne    94a <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 93e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 941:	8b 10                	mov    (%eax),%edx
 943:	8b 45 f0             	mov    -0x10(%ebp),%eax
 946:	89 10                	mov    %edx,(%eax)
 948:	eb 26                	jmp    970 <malloc+0x96>
      else {
        p->s.size -= nunits;
 94a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94d:	8b 40 04             	mov    0x4(%eax),%eax
 950:	2b 45 ec             	sub    -0x14(%ebp),%eax
 953:	89 c2                	mov    %eax,%edx
 955:	8b 45 f4             	mov    -0xc(%ebp),%eax
 958:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 95b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95e:	8b 40 04             	mov    0x4(%eax),%eax
 961:	c1 e0 03             	shl    $0x3,%eax
 964:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 967:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96a:	8b 55 ec             	mov    -0x14(%ebp),%edx
 96d:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 970:	8b 45 f0             	mov    -0x10(%ebp),%eax
 973:	a3 b8 0c 00 00       	mov    %eax,0xcb8
      return (void*)(p + 1);
 978:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97b:	83 c0 08             	add    $0x8,%eax
 97e:	eb 3b                	jmp    9bb <malloc+0xe1>
    }
    if(p == freep)
 980:	a1 b8 0c 00 00       	mov    0xcb8,%eax
 985:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 988:	75 1e                	jne    9a8 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 98a:	83 ec 0c             	sub    $0xc,%esp
 98d:	ff 75 ec             	pushl  -0x14(%ebp)
 990:	e8 e5 fe ff ff       	call   87a <morecore>
 995:	83 c4 10             	add    $0x10,%esp
 998:	89 45 f4             	mov    %eax,-0xc(%ebp)
 99b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 99f:	75 07                	jne    9a8 <malloc+0xce>
        return 0;
 9a1:	b8 00 00 00 00       	mov    $0x0,%eax
 9a6:	eb 13                	jmp    9bb <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b1:	8b 00                	mov    (%eax),%eax
 9b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9b6:	e9 6d ff ff ff       	jmp    928 <malloc+0x4e>
}
 9bb:	c9                   	leave  
 9bc:	c3                   	ret    
