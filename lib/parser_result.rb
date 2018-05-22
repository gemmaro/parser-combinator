class ParserResult
  attr_reader :success, :remaining, :matched, :output
  def initialize(success, remaining, matched, output=[])
    @success   = success
    @remaining = remaining
    @matched   = matched
    @output = output
  end

  def self.ok(output=nil, matched:, remaining:)
#    yield matched if block_given?
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
end
