class SymMngr
  Int = :int
  Real = :real
  String = :string

  Item = Struct.new(:name, :kind, :nparams, :label)

  def initialize
    @tables = []
    @label = 0
  end

  attr_reader :maxdepth, :currentfunction

  def enterBlock(offset = 0)
    @tables.push({})
    @offset = offset
    @maxdepth = 0
  end

  def leaveBlock
    noo = @tables[-1].size # Number of object
    depth = 0
    @tables.each do |t|
      t.each do |k, v|
        depth += 1 if %i[variable param].include?(v.kind)
      end
    end
    @maxdepth = depth if depth > @maxdepth
    @offset -= noo
    @tables.pop
  end

  def enterInnerBlock
    @tables.push({})
  end

  def leaveInnerBlock
    leaveBlock
  end

  def enterId(name, kind, nparams, label)
    if @tables[-1][name]
      puts "#{name} is already declared."
      exit
    elsif kind == :function
      f = Item.new
      f.name = name
      f.kind = :function
      f.label = label
      @tables[-1][name] = f
      @currentfunction = f
      #        p @tables
    elsif kind == :variable
      item = Item.new
      item.name = name
      item.kind = :variable
      item.label = @offset
      @tables[-1][name] = item
      @offset += 1
    elsif kind == :param
      item = Item.new
      item.name = name
      item.kind = kind
      item.label = label
      @tables[-1][name] = item
      @offset += 1
    end
    #    p @tables
  end

  def searchId(name)
    @tables[-1][name]
  end

  def searchAll(name)
    @tables.reverse_each do |e|
      return e[name] if e[name]
    end
    nil
  end

  def searchF(name)
    @tables[0][name]
  end

  def setNoP(name, nop)
    # p @tables
    f = searchF(name)
    f.nparams = nop
    # p "f=", searchF(name)
  end

  def makeLabel
    @label += 1
    "L#{@label}"
  end
end
