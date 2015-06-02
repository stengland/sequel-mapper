require 'simple_mapper'
require 'ostruct'

describe SimpleMapper do
  class Things
    include SimpleMapper
  end

  class Stuff
    include SimpleMapper
    key :url
  end

  MyThing = SimpleMapper::Struct.new(:id, :title, :description)

  class MyThings
    include SimpleMapper
    model MyThing
  end

  let(:db) { Sequel.connect 'sqlite:memory:smtest' }

  before do
    db.create_table? :things do
      primary_key :id
      String :title
      String :description
    end
    db.create_table? :stuff do
      String :url, primary_key: true
      String :title
      String :description
    end
  end

  subject { Things.new db[:things] }
  let(:thing) { OpenStruct.new title: 'Test', description: 'A thingy' }

  describe '#create' do
    it 'maps object to database rows and creats a record' do
      subject.create(thing)
      expect(db[:things].count).to eq 1
      expect(db[:things].first[:title]).to eq 'Test'
    end

    it 'sets the primary key on the object' do
      subject.create(thing)
      expect(thing.id).to eq 1
    end

    it 'removes primary key from data if it is nil' do
      dataset = subject.send(:dataset)
      expect(dataset).to receive(:insert)
        .with({title: 'Test', description: 'A thingy'})
      subject.create(thing)
    end
  end

  context 'record saved in database' do
    before { subject.create(thing) }
    let(:found_thing) { subject.find(1) }

    describe '#find' do
      it 'returns a object found by key' do
        expect(found_thing.title).to eq 'Test'
        expect(found_thing.description).to eq 'A thingy'
      end
    end

    describe '#update' do
      it 'updates the record' do
        found_thing.title = 'Thing'
        subject.update(found_thing)
        new_found_thing = subject[1]
        expect(new_found_thing.title).to eq 'Thing'
      end
    end

    describe '#delete' do
      it 'deletes the record' do
        subject.delete(found_thing)
        expect(subject.find(1)).to be_nil
      end
    end

    describe '#persist' do
      it 'updates the record if it exists' do
        thing.id = 1
        thing.title = 'Thing'
        subject.perist(thing)
        new_found_thing = subject[1]
        expect(new_found_thing.title).to eq 'Thing'
      end

      it 'creates a record if it does not exist' do
        new_thing = OpenStruct.new title: 'New thing', description: 'Some thing'

        subject.perist(new_thing)
        new_found_thing = subject[2]
        expect(new_found_thing.title).to eq 'New thing'
      end
    end
  end

  describe '.model' do
    subject { MyThings.new db[:things] }
    let(:thing) { MyThing.new title: 'Test', description: 'A thingy' }

    it 'sets the the class of the PORO returned by mapper' do
      subject.create(thing)
      expect(subject[1]).to be_a MyThing
    end
  end

  describe '.key' do
    subject { Stuff.new db[:stuff] }
    it 'sets the name of the primary key' do
      url_thing = OpenStruct.new(url: 'http://google.com', title: 'Google')
      subject.create(url_thing)
      expect(url_thing.url).to eq 'http://google.com'
      expect(subject.find('http://google.com').title).to eq 'Google'
    end

    specify 'if not set defaults to "id"' do
      subject.find(1)
    end
  end

end
