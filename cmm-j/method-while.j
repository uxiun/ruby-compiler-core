.class cmm
.super java/lang/Object

.method public <init>()V
  aload_0
  invokespecial java/lang/Object/<init>()V
  return
.end method
.method public static power(I)I
  .limit stack 10
  .limit locals 2
  iload 0
  iload 0
  imul
  ireturn
  return
.end method
.method public static main([Ljava/lang/String;)V
  .limit stack 10
  .limit locals 2
  ldc 2
  istore 1
L1:
  iload 1
  ldc 1000000
  if_icmplt L3
  iconst_0
  goto L4
L3:
  iconst_1
L4:
  ifeq L2
  iload 1
  getstatic java/lang/System/out Ljava/io/PrintStream;
  swap
  invokevirtual java/io/PrintStream/println(I)V
  iload 1
  invokestatic cmm/power(I)I
  istore 1

  goto L1
L2:
  return
.end method
