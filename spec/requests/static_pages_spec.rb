require 'spec_helper'

describe "StaticPages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('title', text: heading) }
    it { should have_selector('h1', text: full_title(page_title)) }
    it { should have_link('Home', href: root_path) }
    it { should have_link('About', href: about_path) }
    it { should have_link('Contact', href: contact_path) }
  end

  describe "landing page" do
    before { visit root_path }
    let(:heading) { "EnableMe" }
    let(:page_title) { "" }

    it_should_behave_like "all static pages"
  end

  describe "about page" do
    before { visit about_path }
    let(:heading) { "About" }
    let(:page_title) { "About" }

    it_should_behave_like "all static pages"
  end

  describe "contact page" do
    before { visit contact_path }
    let(:heading) { "Contact Us" }
    let(:page_title) { "Contact Us" }

    it_should_behave_like "all static pages"
  end
end
