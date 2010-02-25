class HashThatDisallowsAnAnyKey < Hash
  RestrictedKey = Class.new(RuntimeError)
  def []=(key, value)
    raise RestrictedKey if key == :any
    super
  end
end

class MicroMachine
  InvalidEvent = Class.new(NoMethodError)

  attr :transitions_for
  attr :state

  def initialize initial_state
    @state = initial_state
    @transitions_for = HashThatDisallowsAnAnyKey.new
    @callbacks = Hash.new { |hash, key| hash[key] = [] }
  end

  def on key, &block
    @callbacks[key] << block
  end

  def trigger event
    if trigger?(event)
      @state = transitions_for[event][@state].nil? ? transitions_for[event][:any] : transitions_for[event][@state]
      callbacks = @callbacks[@state] + @callbacks[:any]
      callbacks.each { |callback| callback.call }
      true
    end
  end

  def trigger?(event)
    transitions_for[event][state] || transitions_for[event][:any]
  rescue NoMethodError
    raise InvalidEvent
  end
end
