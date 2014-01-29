# http://devblog.avdi.org/2011/05/30/null-objects-and-falsiness/

class NullObject
  def method_missing(*args, &block)
    nil
  end
end