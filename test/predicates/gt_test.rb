require 'test_helper'

describe 'Predicates: gt?' do
  before do
    @validator = Class.new do
      include Hanami::Validations

      validates(:name) { gt?(23) }
    end
  end

  it 'raises error for missing data' do
    exception = -> { @validator.new({}).validate }.must_raise(NoMethodError)
    exception.message.must_equal "undefined method `>' for nil:NilClass"
  end

  it 'raises error for nil data' do
    exception = -> { @validator.new(name: nil).validate }.must_raise(NoMethodError)
    exception.message.must_equal "undefined method `>' for nil:NilClass"
  end

  it 'raises error for blank string' do
    exception = -> { @validator.new(name: '').validate }.must_raise(ArgumentError)
    exception.message.must_equal "comparison of String with 23 failed"
  end

  it 'raises error for filled string' do
    exception = -> { @validator.new(name: '23').validate }.must_raise(ArgumentError)
    exception.message.must_equal "comparison of String with 23 failed"
  end

  it 'raises error for empty array' do
    exception = -> { @validator.new(name: []).validate }.must_raise(NoMethodError)
    exception.message.must_equal "undefined method `>' for []:Array"
  end

  it 'raises error for filled array' do
    exception = -> { @validator.new(name: [23]).validate }.must_raise(NoMethodError)
    exception.message.must_equal "undefined method `>' for [23]:Array"
  end

  it 'raises error for empty hash' do
    exception = -> { @validator.new(name: {}).validate }.must_raise(TypeError)
    exception.message.must_equal "no implicit conversion of Fixnum into Hash"
  end

  it 'raises error for filled hash' do
    exception = -> { @validator.new(name: { a: 23 }).validate }.must_raise(TypeError)
    exception.message.must_equal "no implicit conversion of Fixnum into Hash"
  end

  it 'returns successful result for greater than fixnum' do
    result = @validator.new(name: 24).validate

    result.must_be :success?
    result.errors.must_be_empty
  end

  it 'returns failing result for equal fixnum' do
    result = @validator.new(name: 23).validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Rules::Error.new(:name, :gt?, 23, 23)
    ]
  end

  it 'returns failing result for less than fixnum' do
    result = @validator.new(name: 22).validate

    result.wont_be :success?
    result.errors.fetch(:name).must_equal [
      Hanami::Validations::Rules::Error.new(:name, :gt?, 23, 22)
    ]
  end
end