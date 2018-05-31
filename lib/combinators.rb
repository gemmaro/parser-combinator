# Combinators allow us to "combine" parsers together.
# For example: run this parser first, if it fails, run this other one
#              run this parser first, and then run this other parser
module Combinators
  # Logical OR.
  # Usage:
  #   myParser | otherParser
  #
  def |(other)
    Parser.new do |input|
      first = run(input)
      if first.ok?
        first
      else
        other.run(input)
      end
    end
  end

  # Logical AND.
  # Usage:
  #   myParser >> otherParser
  #
  def >>(other)
    Parser.new do |input|
      first = run(input)
      matched = "" 
      output = []
      if first.ok?
        matched = matched + first.matched
        output += first.output
        second = other.run(first.remaining)
        if second.ok?
          matched = matched + second.matched
          output = [*output, second.output]
          ParserResult.ok(output, matched: matched, remaining: second.remaining)
        else
          ParserResult.fail(input)
        end
      else
        first
      end
    end
  end

  # Match this, other is optional
  def >(other)
    Parser.new do |input|
      first = run(input)
      matched = ""
      output = []
      if first.ok?
        matched = first.matched
        output += first.output
        second  = other.run(first.remaining)
        if second.ok?
          matched = matched + second.matched
          output = [*output, second.output]
          ParserResult.ok(output, matched: matched, remaining: second.remaining)
        else
          first
        end
      else
        ParserResult.fail(input)
      end
    end
  end

  # Match other, this is optional
  def <(other)
    Parser.new do |input|
      first     = run(input)
      matched   = ""
      output    = []
      remaining = input

      if first.ok?
        matched   = first.matched
        output += first.output
        remaining = first.remaining
      end

      second = other.run(remaining)
      if second.ok?
        matched = matched + second.matched
        output = [*output, second.output]
        ParserResult.ok(output, matched: matched, remaining: second.remaining)
      else
        ParserResult.fail(input)
      end
    end
  end

  # Match this, other is ignored but consumed
  def >=(other)
    Parser.new do |input|
      first = run(input)
      if first.ok?
        second  = other.run(first.remaining)
        if second.ok?
          ParserResult.ok(first.output, matched: first.matched, remaining: second.remaining)
        else
          first
        end
      else
        ParserResult.fail(input)
      end
    end
  end

  # Match other, this is ignored but consumed
  def <=(other)
    Parser.new do |input|
      first     = run(input)
      remaining = input
      remaining = first.remaining if first.ok?
      second    = other.run(remaining)
      second.ok? ? second : ParserResult.fail(input)
    end
  end

  # Match this, other is QUIETLY consumed
  def /(other)
    Parser.new do |input|
      first = run(input)
      matched = "" 
      if first.ok?
        matched = matched + first.matched
        second = other.run(first.remaining)
        if second.ok?
          matched = matched + second.matched
          ParserResult.ok(first.output, matched: matched, remaining: second.remaining)
        else
          ParserResult.fail(input)
        end
      else
        first
      end
    end
  end

  # Match other, this is QUIETLY consumed
  def *(other)
    Parser.new do |input|
      first = run(input)
      matched = "" 
      
      if first.ok?
        matched += first.matched
        second = other.run(first.remaining)
        if second.ok?
          matched += second.matched
          ParserResult.ok(second.output, matched: matched, remaining: second.remaining)
        else
          ParserResult.fail(input)
        end
      else
        first
      end
    end
  end

  # other needs to fail for this to succeed; other is only peeking, not consuming
  def !=(other)
    Parser.new do |input|
      second = other.run(input)

      if second.ok?
        ParserResult.fail(input)
      else
        run(input)
      end
    end
  end

end
