.class cmm
.super java/lang/Object

.method public <init>()V
  aload_0
  invokespecial java/lang/Object/<init>()V
  return
.end method
.method public static main([Ljava/lang/String;)V
  .limit stack 10
  .limit locals 1
  ldc 100
  ldc 2
  idiv
  ldc 18
  if_icmplt L1
  iconst_0
  goto L2
L1:
  iconst_1
L2:
  ifeq L3
  ldc 100
  getstatic java/lang/System/out Ljava/io/PrintStream;
  swap
  invokevirtual java/io/PrintStream/println(I)V
  goto L4
L3:
  ldc 50
  getstatic java/lang/System/out Ljava/io/PrintStream;
  swap
  invokevirtual java/io/PrintStream/println(I)V
  ldc 50
  ldc 2
  idiv
  ldc 18
  if_icmplt L5
  iconst_0
  goto L6
L5:
  iconst_1
L6:
  ifeq L7
  ldc 75
  getstatic java/lang/System/out Ljava/io/PrintStream;
  swap
  invokevirtual java/io/PrintStream/println(I)V
  goto L8
L7:
  ldc 25
  getstatic java/lang/System/out Ljava/io/PrintStream;
  swap
  invokevirtual java/io/PrintStream/println(I)V
L8:
L4:
  return
.end method
