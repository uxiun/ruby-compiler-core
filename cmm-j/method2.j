.class cmm
.super java/lang/Object

.method public <init>()V
  aload_0
  invokespecial java/lang/Object/<init>()V
  return
.end method
.method public static add3(III)I
  .limit stack 10
  .limit locals 4
  iload 0
  iload 1
  isub
  iload 2
  isub
  ireturn
  return
.end method
.method public static main([Ljava/lang/String;)V
  .limit stack 10
  .limit locals 1
  ldc 5
  ldc 7
  ldc 9
  invokestatic cmm/add3(III)I
  getstatic java/lang/System/out Ljava/io/PrintStream;
  swap
  invokevirtual java/io/PrintStream/println(I)V
  return
.end method
