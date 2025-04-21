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
  ldc 1
  ldc 0
  if_icmplt L1
  iconst_0
  goto L2
L1:
  iconst_1
L2:
  ifeq L3
  ldc 1
  getstatic java/lang/System/out Ljava/io/PrintStream;
  swap
  invokevirtual java/io/PrintStream/println(I)V
  goto L4
L3:
  ldc 2
  getstatic java/lang/System/out Ljava/io/PrintStream;
  swap
  invokevirtual java/io/PrintStream/println(I)V
L4:
  return
.end method
