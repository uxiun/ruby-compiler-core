#!/usr/local/bin/ruby

class Lexer
  
  def initialize(f)
    @srcfile=f
    @line = ""
    @lineno = 0
  end

  attr_reader :lineno

  def lex()
    if @line == nil
      false
    else
      if /^\s+/ =~ @line 
        @line = $'
      end
      while @line.empty?  do
        @line = @srcfile.gets()
        if @line == nil 
          return false
        end
        @lineno += 1
        if /^\s+/ =~ @line 
          @line = $'
        end
      end
      
      case @line
      when /\Avar/
        yield :var, $&
      when /\Amain/
        yield :main, $&
      when /\A\(/
        yield :lpar, $&
      when /\A\)/
        yield :rpar, $&
      when /\A\,/
        yield :comma, $&
      when /\A\{/
        yield :lbra, $&
      when /\A\}/
        yield :rbra, $&
      when /\Awriteln/
        yield :writeln, $&
      when /\Awrite/
        yield :write, $&
      when /\A\;/
        yield :semi, $&
      when /\A\+/
        yield :plus, $&
      when /\A\-/
        yield :minus, $&
      when /\A\*/
        yield :mult, $&
      when /\A\//
        yield :div, $&
      when /\Aif/
        yield :if, $&
      when /\Athen/
        yield :then, $&
      when /\Aelse/
        yield :else, $&
      when /\Aendif/
        yield :endif, $&
      when /\Awhile/
        yield :while, $&
      when /\Ado/
        yield :do, $&
      when /\Aread/
        yield :read, $&
      when /\A:=/
        yield :coleq, $&
      when /\A\==/
        yield :eq, $&
      when /\A!=/
        yield :neq, $&
      when /\A</
        yield :lt, $&
      when /\A>/
        yield :gt, $&
      when /\A<=/
        yield :leq, $&
      when /\A>=/
        yield :geq, $&
      when /\Areturn/
        yield :return, $&
      when /\A[a-zA-Z_][a-zA-Z_0-9]*/
        yield :ident, $&
      when /\A[0-9]+/
        yield :number, $&
      when /\A./
        yield :other, $&
      end
#      print "@line2 = \'", @line, "\'\n"
      @line = $'
#      print "remaining = \'", @line, "\'\n"
      true
    end
  end
end  
  
