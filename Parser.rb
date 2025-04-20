require './lexer'
require './symMngr'

class Parser
  def initialize(l)
    @lexer = l
    @sm = SymMngr.new
  end

  def parse
    @lexer.lex do |t, l|
      @lexime = l
      @token = t
    end
    program
  end

  def program
    code = ".class cmm
.super java/lang/Object

.method public <init>()V
  aload_0
  invokespecial java/lang/Object/<init>()V
  return
.end method
"
    @sm.enterBlock
    code += fdecls
    code += main
    @sm.leaveBlock
    code
  end

  def main
    checktoken('main', :main)
    @sm.enterBlock(1)
    codebody = body
    @sm.leaveBlock
    code = '.method public static main([Ljava/lang/String;)V'
    limit = "
  .limit stack 10
  .limit locals #{@sm.maxdepth + 1}"
    code += "#{limit}
#{codebody}  return
.end method\n"
    code
  end

  def fdecls # 関数宣言
    code = ''
    while @token == :ident
      name = @lexime
      checktoken('fdecls', :ident)
      @sm.enterId(name, :function, 0, nil)
      checktoken('fdecls', :lpar)
      @sm.enterBlock
      nop = params
      checktoken('fdecls', :rpar)
      code += ".method public static #{name}(#{'I' * nop})I"
      codebody = body
      @sm.leaveBlock
      code += "
  .limit stack 10
  .limit locals #{@sm.maxdepth + 1}
#{codebody}  ireturn
  return
.end method\n"
      @sm.setNoP(name, nop)
    end
    code
  end

  def params # 仮引数列
    nop = 0
    case @token
    when :ident
      name = @lexime
      checktoken('params', :ident)
      @sm.enterId(name, :param, 0, nop)
      nop += 1
      while @token == :comma
        checktoken('params', :comma)
        name = @lexime
        checktoken('params', :ident)
        @sm.enterId(name, :param, 0, nop)
        nop += 1
      end
    end
    nop
  end

  def body
    code = ''
    checktoken('body', :lbra)
    vardecls
    code += stmts
    checktoken('body', :rbra)
    code
  end

  def vardecls # 変数宣言
    case @token
    when :var
      while @token == :var
        checktoken('vardecls', :var)
        identList
        checktoken('vardecls', :semi)
      end
    end
  end

  def identList
    name = @lexime
    checktoken('identList', :ident)
    @sm.enterId(name, :variable, 0, 0)
    while @token == :comma
      checktoken('identList', :comma)
      name = @lexime
      checktoken('identList', :ident)
      @sm.enterId(name, :variable, 0, 0)
    end
  end

  def stmts
    code = ''
    case @token
    when :write, :writeln, :read, :ident, :if, :while, :lbra, :return
      while @token == :write ||
            @token == :writeln ||
            @token == :read ||
            @token == :ident ||
            @token == :if ||
            @token == :while ||
            @token == :return ||
            @token == :lbra
        code += stmt
      end
    else
      errormsg('stmts', @token, :write, :writeln,
               :read, :ident, :if, :while, :lbra, :return)
    end
    code
  end

  def stmt # statement, 文
    code = ''
    case @token
    when :write
      checktoken('stmt', :write)
      code += "#{expression}  getstatic java/lang/System/out Ljava/io/PrintStream;
  swap
  invokevirtual java/io/PrintStream/println(I)V\n"
      checktoken('stmt', :semi)
    when :writeln
      code += "getstatic java/lang/System/out Ljava/io/PrintStream;
  swap
  invokevirtual java/io/PrintStream/println(I)V\n"
      checktoken('stmt', :writeln)
      checktoken('stmt', :semi)
    when :read
      checktoken('stmt', :read)
      name = @lexime
      checktoken('stmt', :ident)
      o = @sm.searchAll(name)
      if o.nil?
        puts "#{name} is not declared."
        exit
      end
      code = "  invokestatic libcmm/gets()Ljava/lang/String;
  invokestatic java/lang/Integer/parseInt(Ljava/lang/String;)I
  istore #{o.label}
"
      checktoken('stmt', :semi)
    when :ident
      name = @lexime
      checktoken('stmt', :ident)
      o = @sm.searchAll(name)
      if o.nil?
        puts "#{name} is not declared."
        exit
      end
      checktoken('stmt', :coleq)
      code += expression
      checktoken('stmt', :semi)
      code += "  istore #{o.label}\n"
    when :if
      code += ifstmt
    when :while
      code += whilestmt
    when :lbra
      @sm.enterInnerBlock
      code += body
      @sm.leaveInnerBlock
    when :return
      checktoken('stmt', :return)
      code += expression
      checktoken('stmt', :semi)
    else
      errormsg('stmts', @token, :write, :writeln,
               :read, :ident, :if, :while, :lbra)
    end
    code
  end

  def ifstmt
    checktoken('ifstmt', :if)
    code = condition

    checktoken('ifstmt', :then)
    clause_true = stmt
    case @token
    when :endif
      checktoken('ifstmt', :endif)
      label_false = @sm.makeLabel
      code += "  ifeq #{label_false}
#{clause_true}#{label_false}:
"
    when :else
      label_false = @sm.makeLabel
      l = @sm.makeLabel
      checktoken('ifstmt', :else)
      code += "  ifeq #{label_false}
#{clause_true}  goto #{l}
#{label_false}:
#{stmt}#{l}:
"
      checktoken('ifstmt', :endif)
    else
      errormsg('ifstmts', @token, :endif, :else)
    end
    checktoken('ifstmt', :semi)
    code
  end

  def whilestmt
    l1 = @sm.makeLabel
    l2 = @sm.makeLabel
    checktoken('whilestmt', :while)
    code = "#{l1}:
#{condition}  ifeq #{l2}
"
    checktoken('whilestmt', :do)
    code += "#{stmt}
  goto #{l1}
#{l2}:
"
    code
  end

  def condition
    cexp
  end

  def cexp # 比較式
    code = expression
    case @token
    when :eq
      checktoken('cexp', :eq)
      op = 'eq'
    when :neq
      checktoken('cexp', :neq)
      op = 'ne'
    when :lt
      checktoken('cexp', :lt)
      op = 'lt'
    when :geq
      checktoken('cexp', :geq)
      op = 'ge'
    when :gt
      checktoken('cexp', :gt)
      op = 'gt'
    when :leq
      checktoken('cexp', :leq)
      op = 'le'
    else
      errormsg('cexp', @token, :eq, :neq, :lt, :gt, :leq, :geq)
    end
    x = @sm.makeLabel
    y = @sm.makeLabel
    code += "#{expression}  if_icmp#{op} #{x}
  iconst_0
  goto #{y}
#{x}:
  iconst_1
#{y}:
"
    code
  end

  def expression # 式
    code = ''
    uop = 0
    if @token == :plus
      uop = 'iadd'
      checktoken('expression', :plus)
    elsif @token == :minus
      uop = 'isub'
      checktoken('expression', :minus)
    end
    code += term
    op = 0
    while @token == :plus || @token == :minus
      if @token == :plus
        op = 'iadd'
        checktoken('expression', :plus)
      elsif @token == :minus
        op = 'isub'
        checktoken('expression', :minus)
      else
      end
      code += term
      code += "  #{op}\n"
    end
    code
  end

  def term
    code = factor
    op = 0
    while @token == :mult || @token == :div
      if @token == :mult
        op = 'imul'
        checktoken('term', :mult)
      else
        op = 'idiv'
        checktoken('term', :div)
      end
      code += factor
      code += "  #{op}\n"
    end
    code
  end

  def factor
    code = ''
    case @token
    when :number
      code += "  ldc #{@lexime}\n"
      checktoken('factor', :number)
    when :lpar
      checktoken('factor', :lpar)
      code += expression
      checktoken('factor', :rpar)
    when :ident
      name = @lexime
      checktoken('factor', :ident)
      o = @sm.searchAll(name)
      if o.nil?
        puts "#{name} is not declared."
        exit
      end
      if @token == :lpar # 関数呼び出し
        checktoken('factor', :lpar)
        nop = 0
        if @token != :rpar
          nop, params = aparams
          if nop != o.nparams
            puts "incorrect number of params for (#{name})"
            exit
          end
          code = params
        end
        checktoken('factor', :rpar)
        code += "  invokestatic cmm/#{name}(#{'I' * (nop - 1)}I)I\n"
      else # 変数参照
        code = "  iload #{o.label}\n"
      end
    end
    code
  end

  def aparams # 関数に渡す引数
    code = expression
    nop = 1
    while @token == :comma
      checktoken('aparams', :comma)
      code += expression
      nop += 1
    end
    [nop, code]
  end

  def checktoken(f, expected)
    if @token == expected
      @lexer.lex do |t, l|
        @token = t
        @lexime = l
      end
    else
      errormsg(f, @token, expected)
    end
  end

  def errormsg(f, et, *tokens)
    tks = tokens.join(' or ')
    puts "syntax error (#{f}(#{et})) : #{tks} is expected."
    exit(1)
  end
end

lexer = Lexer.new($stdin)
parser = Parser.new(lexer)
code = parser.parse
print code
