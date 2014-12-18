require "simple_mapper/version"
require 'sequel'
require 'ostruct'

module SimpleMapper
  def initialize(dataset, container: nil)
    @dataset = dataset.clone
    @container = container
    @dataset.row_proc = method(:data_to_object)
  end

  def create(object)
    dataset.insert object_to_data(object)
  end

  def find(key)
    find_object(key: key).first
  end
  alias :[] :find

  def update(object)
    find_object(object).update(object_to_data(object))
  end

  def delete(object)
    find_object(object).delete
  end

  def perist(object)
    if find_object(object).nil?
      create(object)
    else
      update(object)
    end
  end

  private

  attr_reader :dataset, :container

  def object_to_data(object)
    dataset.columns.reduce({}) do |hash, column|
      hash[column] = object.public_send(column)
      hash
    end
  end

  def data_to_object(data)
    model_klass.new data
  end

  def find_object(object=nil, key: object.public_send(primary_key))
    dataset.where(primary_key => key) if key
  end

  def model_klass
    self.class.model_klass || OpenStruct
  end

  def primary_key
    self.class.primary_key || :id
  end

  module ClassMethods
    def model(model_klass)
      @model_klass = model_klass
    end

    def key(primary_key)
      @primary_key = primary_key
    end

    attr_reader :model_klass, :primary_key
  end

  def self.included(receiver)
    receiver.extend ClassMethods
  end

end
