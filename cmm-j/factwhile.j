.class cmm
.super java/lang/Object

.method public <init>()V
  aload_0
  invokespecial java/lang/Object/<init>()V
  return
.end method
.method public static main([Ljava/lang/String;)V
  .limit stack 10
  .limit locals 3
  ldc 1
  istore 2
  ldc 1
  istore 1
  invokestatic libcmm/gets()Ljava/lang/String;
  invokestatic java/lang/Integer/parseInt(Ljava/lang/String;)I
  istore 1
L1:
  iload 1
  ldc 0
  if_icmpgt L3
  iconst_0
  goto L4
L3:
  iconst_1
L4:
  ifeq L2
  iload 2
  iload 1
  imul
  istore 2
  iload 1
  ldc 1
  isub
  istore 1

  goto L1
L2:
  iload 2
  getstatic java/lang/System/out Ljava/io/PrintStream;
  swap
  invokevirtual java/io/PrintStream/println(I)V
  return
.end method
