require 'seeder'

describe Seeder do

  it 'can be instantiated' do
    seeder = Seeder.new
    expect(seeder.is_a?(Seeder)).to eq(true)
  end

end
