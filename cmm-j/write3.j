.class cmm
.super java/lang/Object

.method public <init>()V
  aload_0
  invokespecial java/lang/Object/<init>()V
  return
.end method
.method public static main([Ljava/lang/String;)V
  .limit stack 10
  .limit locals 4
  ldc 3
  istore 1
  ldc 4
  istore 2
  ldc 5
  istore 3
  iload 1
  iload 1
  imul
  iload 2
  iload 2
  imul
  iadd
  iload 3
  iload 3
  imul
  iadd
  getstatic java/lang/System/out Ljava/io/PrintStream;
  swap
  invokevirtual java/io/PrintStream/println(I)V
  return
.end method
