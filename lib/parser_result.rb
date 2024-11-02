class ParserResult
  attr_reader :success, :remaining, :matched, :output
  def initialize(success, remaining, matched, output=nil)
    @success   = success
    @remaining = remaining
    @matched   = matched
    @output = output.nil? ? [matched] : output
  end

  def self.ok(output=nil, matched: "", remaining: "")
#    yield matched if block_given?
    output = [matched] if output.nil?
    ParserResult.new(true, remaining, matched, output)
  end

  def self.fail(remaining)
    ParserResult.new(false, remaining, "")
  end

  def ok?
    success
  end

  def fail?
    success == false
  end

  def ==(other)
    return other.instance_of?(self.class) && other.success == success && other.remaining == remaining && other.matched == matched
  end

  def to_s()
    "ParserResult: {\n" +
    "\tSuccess: " + success.to_s + 
    "\n\tRemaining: '" + remaining.to_s + 
    "'\n\tMatched: '" + matched.to_s + 
    "'\n\tOutput: " + output.to_s + "\n}"
  end
end
