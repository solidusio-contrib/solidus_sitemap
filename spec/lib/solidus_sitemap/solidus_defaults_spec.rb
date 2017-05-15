RSpec.describe SolidusSitemap::SolidusDefaults do
  let(:interpreter) do
    Class.new do
      attr_accessor :entries

      include SolidusSitemap::SolidusDefaults

      def initialize
        self.entries = []
      end

      def add(url, options)
        self.entries << url
      end
    end
  end

  subject { interpreter.new }

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

  context '.default_url_options' do
    it 'returns a hash' do
      expect(subject.default_url_options).to be_a Hash
    end
  end

  context '.gem_available?' do
    it 'verifies that gem is available' do
      expect(subject.gem_available?('rspec-rails')).to be_truthy
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
    let!(:soft_deleted) { create(:product).tap(&:destroy) }
    let!(:available) { create(:product) }

    it "includes the product index" do
      subject.add_products

      expect(subject.entries).to include("/products")
    end

    it "includes avilable products" do
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
  skip '.add_taxons(options = {})'
  skip '.add_taxon(taxon, options = {})'
end
