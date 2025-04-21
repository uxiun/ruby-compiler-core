.class cmm
.super java/lang/Object

.method public <init>()V
  aload_0
  invokespecial java/lang/Object/<init>()V
  return
.end method
.method public static main([Ljava/lang/String;)V
  .limit stack 10
  .limit locals 2
  invokestatic libcmm/gets()Ljava/lang/String;
  invokestatic java/lang/Integer/parseInt(Ljava/lang/String;)I
  istore 1
  iload 1
  iload 1
  imul
  getstatic java/lang/System/out Ljava/io/PrintStream;
  swap
  invokevirtual java/io/PrintStream/println(I)V
  return
.end method
