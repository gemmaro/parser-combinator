class ParserResult
  attr_reader :success, :remaining, :matched, :output
  def initialize(success, remaining, matched, output=nil)
    @success   = success
    @remaining = remaining
    @matched   = matched
    @output = output.nil? ? [matched] : output
  end

  def self.ok(output=nil, matched:, remaining:)
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
    "Success: " + success.to_s + ", Remaining: '" + remaining.to_s + "', Matched: '" + matched.to_s + "', Output: " + output.to_s
  end
end
