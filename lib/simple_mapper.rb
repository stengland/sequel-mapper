require "simple_mapper/version"
require "simple_mapper/struct"
require 'sequel/core'
require 'forwardable'

module SimpleMapper
  extend Forwardable

  def initialize(options)
    if options.is_a? Sequel::Dataset
      @db = options.db
      @dataset = options.clone
    elsif options.is_a? Sequel::Database
      @db = options
      raise ArgumentError 'no dataset defined' if self.class._dataset.nil?
      @dataset = db[self.class._dataset]
    else
      raise ArgumentError 'no database or dataset'
    end
    @dataset.row_proc = method(:data_to_object)
    @model = self.class._model || SimpleMapper::Struct.new(*dataset.columns)
    @primary_key = self.class._primary_key || :id
  end

  attr_reader :dataset

  def create(object)
    id = dataset.insert create_data(object)
    object.send("#{primary_key}=", id) unless object.public_send(primary_key)
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

  def_delegators :dataset, :count, :all, :each

  %w{where order grep limit}.each do |sc|
    define_method sc do |*args|
      scope dataset.public_send(sc, *args)
    end
  end

  def graph(*args)
    scope dataset.extension(:graph_each).graph(*args)
  end

  private

  attr_reader :db, :model, :primary_key

  def object_to_data(object)
    dataset.columns.reduce({}) do |hash, column|
      hash[column] = object.public_send(column) if object.respond_to?(column)
      hash
    end
  end

  def create_data(object)
    object_to_data(object).delete_if { |k, v| v.to_s.strip == '' }
  end

  def data_to_object(data)
    model.new data
  end

  def find_object(object=nil, key: object.public_send(primary_key))
    dataset.where(primary_key => key) if key
  end

  def scope(dataset)
    self.class.new(dataset)
  end

  module ClassMethods
    def model(model)
      @_model = model
    end

    def primary_key(primary_key)
      @_primary_key = primary_key
    end
    alias :key :primary_key

    def dataset(dataset)
      @_dataset = dataset
    end

    attr_reader :_model, :_primary_key, :_dataset
  end

  def self.included(receiver)
    receiver.extend ClassMethods
  end

end
