# frozen_string_literal: true

RSpec.describe SolidusSitemap::SolidusDefaults do
  subject { interpreter.new }

  let(:interpreter) do
    Class.new do
      attr_accessor :entries

      include SolidusSitemap::SolidusDefaults

      def initialize
        self.entries = []
      end

      def add(url, _options)
        entries << url
      end
    end
  end

  context 'Interpreter' do
    %w( add_login
        add_signup
        add_account
        add_password_reset
        add_products
        add_product
        add_pages
        add_taxons
        add_taxons ).each do |method|
      it "inherit included method #{method.to_sym}" do
        expect(subject.respond_to?(method.to_sym)).to be(true)
      end
    end
  end

  describe '.default_url_options' do
    it 'returns a hash' do
      expect(subject.default_url_options).to be_a Hash
    end
  end

  describe '.gem_available?' do
    it 'verifies that gem is available' do
      expect(subject).to be_gem_available('rspec-rails')
    end

    context 'when there is no such gem' do
      it 'returns false' do
        expect(subject.gem_available?('fake_solidus_gem_name')).to be false
      end
    end
  end

  describe '.main_app' do
    context 'returns the url helpers module for the application' do
      it { expect(subject.main_app).to respond_to(:url_for, :spree_path, :_routes) }
    end
  end

  skip '.add_login(options = {})'
  skip '.add_signup(options = {})'
  skip '.add_account(options = {})'
  skip '.add_password_reset(options = {})'

  describe '.add_products(options = {})' do
    let!(:not_available) { create(:product, available_on: 1.week.from_now) }

    if Spree.solidus_gem_version >= Gem::Version.new('2.5.0')
      let!(:soft_deleted) { create(:product).tap(&:discard) }
    else
      let!(:soft_deleted) { create(:product).tap(&:destroy) }
    end

    let!(:available) { create(:product) }

    it "includes the product index" do
      subject.add_products

      expect(subject.entries).to include("/products")
    end

    it "includes available products" do
      subject.add_products

      expect(subject.entries).to include("/products/#{available.slug}")
    end

    it "doesn't include unavailable products" do
      subject.add_products

      expect(subject.entries).not_to include("/products/#{not_available.slug}")
      expect(subject.entries).not_to include("/products/#{soft_deleted.slug}")
    end
  end

  skip '.add_product(product, options = {})'
  skip '.add_pages(options = {})'

  describe '.add_taxons(options = {})' do
    subject { sitemap_generator.add_taxons(options) }

    let(:sitemap_generator) { interpreter.new }
    let(:options) { {} }
    let(:taxonomy) { create :taxonomy, name: 'Sample taxonomy' }
    let!(:taxon) { create :taxon, name: 'Sample taxon', taxonomy: taxonomy }

    it 'add login path' do
      expect { subject }.to change(sitemap_generator, :entries).from([])
        .to contain_exactly(*taxonomy.taxons.map { |taxon| "/t/#{taxon.permalink}" })
    end
  end

  describe '.add_taxon(taxon, options = {})' do
    subject { sitemap_generator.add_taxon(taxon, options) }

    let(:sitemap_generator) { interpreter.new }
    let(:taxon) { create(:taxon, name: 'Sample Taxon') }
    let(:options) { {} }

    it 'add login path' do
      expect { subject }.to change(sitemap_generator, :entries).from([])
        .to contain_exactly("/t/#{taxon.permalink}")
    end
  end
end
