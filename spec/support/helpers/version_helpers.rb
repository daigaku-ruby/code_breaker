module VersionHelpers
  def fixnum_or_integer
    RUBY_VERSION < '2.4.0' ? Fixnum : Integer
  end

  def bignum_or_integer
    RUBY_VERSION < '2.4.0' ? Bignum : Integer
  end
end
