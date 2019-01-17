require 'seeder'

describe Seed do

  let(:seed_file_path) { File.expand_path('../support/basic-seed.md', __dir__) }
  let(:seed) { Seed.new(seed_file_path) }

  describe '#intialize' do
    it 'sets appropriate variables' do
      expect(seed.instance_variable_get("@file_path")).to eq(seed_file_path)
      expect(seed.raw).to eq(File.read(seed_file_path))
    end
  end

  describe '#parse_file!' do
    it 'parses the body, frontmatter, and fields'
  end

  describe '#create_entry!' do
    it 'raises an error when attempting to create without parsing the fields' do
      expect { seed.create_entry! }.to raise_error(RuntimeError)
    end
    it 'creates an entry if the fields have been parsed first'
  end

  describe '#publish_entry!' do
    it 'raises an error when attempting to publish without first creating' do
      expect { seed.publish_entry! }.to raise_error(RuntimeError)
    end
    it 'attempts to publish an entry if the entry exists'
  end

  describe '#extract_body!' do
    it 'extracts the body from the markdown file and strips its ends' do
      seed.send(:extract_body!)
      expect(seed.body).to eq("This is the body\n\n---\n\nAnd it has a newline.")
    end
  end

  describe '#extract_frontmatter!' do
    it 'does something ...'
  end

  describe '#extract_fields!' do
    it 'does something ...'
  end

  describe '#parse_field_links!' do
    it 'does something ...'
  end

  describe '#set_body_field!' do
    it 'does something ...'
  end

  describe '#raw_frontmatter' do
    it 'extracts the text that will be processed as frontmatter' do
      fm = seed.send(:raw_frontmatter)
      expect(fm).to eq("---\n_content_type: article\ntitle: Article Title\nslug: article-slug\nimage: 4Zxm0bwR9eWSiuw442WAqS\nauthor: 2VBUQyLmh22eacKWw08E4o\ntags:\n  - luZPICyHVQUYQYSAa6Imu\n  - 1JWjoImLpWAeWMCWI2WOaM\n  - 31xMlxGaBWKw0aYK2ESgQA\n---")
    end
  end

  describe '#contentful, #content_type' do
    it 'represents the contentful content type' do
      VCR.use_cassette('ctf/content_types/article') do
        seed.send(:extract_frontmatter!)
        ct = seed.send(:content_type)
        expect(ct.id).to eq('article')
      end
    end
  end


end
