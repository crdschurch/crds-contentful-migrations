require 'seeder'

describe Seed do

  let(:new_seed_path) { File.expand_path('../support/basic-seed.md', __dir__) }
  let(:updated_seed_path) { File.expand_path('../support/update-location.md', __dir__) }
  let(:seed) { Seed.new(new_seed_path) }

  describe '#intialize' do
    it 'sets appropriate variables' do
      expect(seed.instance_variable_get("@file_path")).to eq(new_seed_path)
      expect(seed.raw).to eq(File.read(new_seed_path))
    end
  end

  describe '#parse_file!' do
    it 'parses the body, frontmatter, and fields' do
      VCR.use_cassette('basic_seed') do
        seed.parse_file!
        expect(seed.frontmatter.keys).to eq(%i{_content_type title slug image author category published_at tags})
        expect(seed.fields.keys).to eq(%i{title slug image author category published_at tags body})
      end
    end
  end

  describe '#init_entry!' do
    it 'raises an error when attempting to create without parsing the fields' do
      expect { seed.init_entry! }.to raise_error(RuntimeError)
    end
    it 'intializes an entry if the fields have been parsed first' do
      VCR.use_cassette('init_entry') do
        seed.parse_file!
        seed.init_entry!
        expect(seed.entry.title).to eq(seed.fields[:title])
        expect(seed.entry.slug).to eq(seed.fields[:slug])
        expect(seed.entry.body).to eq(seed.fields[:body])
        expect(seed.entry.image.id).to eq(seed.frontmatter[:image])
        expect(seed.entry.author.id).to eq(seed.frontmatter[:author])
        expect(seed.entry.tags.collect { |t| t.id }).to eq(seed.frontmatter[:tags])
      end
    end
    it 'finds an existing entry and overwrites new fields' do
      seed = Seed.new(updated_seed_path)
      VCR.use_cassette('init_update_entry') do
        seed.parse_file!
        seed.init_entry!
        expect(seed.entry.id).to eq('Y5BXL5M8WA6mQwu0gEwsq')
        expect(seed.entry.name).to eq('Cleveland [NEW]')
        expect(seed.entry.spotlight_title).to eq('Drop Us A Line')
      end
    end
  end

  describe '#save_entry!' do
    it 'raises an error when attempting to create without initializing an entry' do
      expect { seed.save_entry! }.to raise_error(RuntimeError)
    end
    it 'creates an entry if the fields have been parsed first' do
      VCR.use_cassette('save_entry') do
        seed.parse_file!
        seed.init_entry!
        seed.save_entry!
        expect(seed.entry.title).to eq(seed.fields[:title])
        expect(seed.entry.slug).to eq(seed.fields[:slug])
        expect(seed.entry.body).to eq(seed.fields[:body])
        expect(seed.entry.image.dig('sys', 'id')).to eq(seed.frontmatter[:image])
        expect(seed.entry.author.dig('sys', 'id')).to eq(seed.frontmatter[:author])
        expect(seed.entry.tags.collect { |t| t.dig('sys', 'id') }).to eq(seed.frontmatter[:tags])
      end
    end
  end

  describe '#publish_entry!' do
    it 'raises an error when attempting to publish without first creating' do
      expect { seed.publish_entry! }.to raise_error(RuntimeError)
    end
    it 'publishes a valid entry' do
      VCR.use_cassette('publish_entry') do
        seed.parse_file!
        seed.fields[:slug] = SecureRandom.hex(24)
        seed.init_entry!
        seed.save_entry!
        expect(seed.entry.published?).to eq(false)
        seed.publish_entry!
        expect(seed.entry.published?).to eq(true)
      end
    end
  end

  describe '#extract_body!' do
    it 'extracts the body from the markdown file and strips its ends' do
      seed.send(:extract_body!)
      expect(seed.body).to eq("This is the body\n\n---\n\nAnd it has a newline.")
    end
  end

  describe '#extract_frontmatter!' do
    it 'maintains a reference to linked ID values after parsing a field' do
      VCR.use_cassette('basic_seed') do
        seed.send(:extract_frontmatter!)
        seed.send(:extract_body!)
        seed.send(:extract_fields!)
        expect(seed.frontmatter[:image]).to eq('4Zxm0bwR9eWSiuw442WAqS')
        expect(seed.frontmatter[:author]).to eq('gHpeahicxiSI8UWMWookw')
        expect(seed.frontmatter[:tags]).to eq(%w{luZPICyHVQUYQYSAa6Imu 1JWjoImLpWAeWMCWI2WOaM 31xMlxGaBWKw0aYK2ESgQA})
      end
    end
    it 'does not remove metadata fields' do
      VCR.use_cassette('basic_seed') do
        seed.send(:extract_frontmatter!)
        expect(seed.frontmatter[:_content_type]).to eq('article')
      end
    end
  end

  describe '#extract_fields!, #parse_field_links!, #set_body_field!' do
    it 'raises an error if trying to parse fields prior to extracting frontmatter' do
      expect { seed.send(:extract_fields!) }.to raise_error(RuntimeError)
    end
    it 'raises an error if trying to parse links before fields are available' do
      expect { seed.send(:parse_field_links!) }.to raise_error(RuntimeError)
    end
    it 'raises an error if trying to set the body before fields are available' do
      expect { seed.send(:set_body_field!) }.to raise_error(RuntimeError)
    end
    it 'removes metadata fields' do
      VCR.use_cassette('basic_seed') do
        seed.send(:extract_frontmatter!)
        seed.send(:extract_body!)
        seed.send(:extract_fields!)
        expect(seed.fields[:_content_type]).to eq(nil)
      end
    end
    it 'automatically links entry(ies) and asset(s)' do
      VCR.use_cassette('basic_seed') do
        seed.send(:extract_frontmatter!)
        seed.send(:extract_body!)
        seed.send(:extract_fields!)
        expect(seed.fields[:image].class).to eq(Contentful::Management::Asset)
        expect(seed.fields[:author].class).to eq(Contentful::Management::Entry)
        expect(seed.fields[:tags].map(&:class)).to eq(
          [Contentful::Management::Entry, Contentful::Management::Entry, Contentful::Management::Entry]
        )
      end
    end
    it 'sets body content to body field by default' do
      VCR.use_cassette('basic_seed') do
        seed.send(:extract_frontmatter!)
        seed.send(:extract_body!)
        seed.send(:extract_fields!)
        expect(seed.fields[:body]).to eq(seed.body)
      end
    end
    it 'can use _body_field metadata to set the body content to a custom field' do
      VCR.use_cassette('basic_seed') do
        seed.send(:extract_frontmatter!)
        seed.frontmatter[:_body_field] = 'lead_text'
        seed.send(:extract_body!)
        seed.send(:extract_fields!)
        expect(seed.fields[:body]).to eq(nil)
        expect(seed.fields[:lead_text]).to eq(seed.body)
      end
    end
    it 'will not override frontmatter that was already set' do
      VCR.use_cassette('basic_seed') do
        seed.send(:extract_frontmatter!)
        seed.frontmatter[:body] = 'Hello World!'
        seed.send(:extract_body!)
        seed.send(:extract_fields!)
        expect(seed.fields[:body]).to eq('Hello World!')
      end
    end
  end

  describe '#raw_frontmatter' do
    it 'extracts the text that will be processed as frontmatter' do
      fm = seed.send(:raw_frontmatter)
      expect(fm).to eq("---\n_content_type: article\ntitle: Article Title\nslug: article-slug\nimage: 4Zxm0bwR9eWSiuw442WAqS\nauthor: gHpeahicxiSI8UWMWookw\ncategory: 5Gti0XC6Tm0moa4WMYM0cw\npublished_at: 2019-01-01\ntags:\n  - luZPICyHVQUYQYSAa6Imu\n  - 1JWjoImLpWAeWMCWI2WOaM\n  - 31xMlxGaBWKw0aYK2ESgQA\n---")
    end
  end

  describe '#contentful, #content_type' do
    it 'represents the contentful content type' do
      VCR.use_cassette('article_content_type') do
        seed.send(:extract_frontmatter!)
        ct = seed.send(:content_type)
        expect(ct.id).to eq('article')
      end
    end
  end
end
