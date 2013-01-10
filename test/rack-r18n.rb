require 'minitest/spec'
require 'minitest/autorun'

require_relative '../lib/rack-r18n'

describe "rack-r18n" do
  describe "#session_locale" do
    before do
      @locales = Object.new
      @r18n = Rack::R18n.new(proc {})
    end
    describe "setting a locale" do
      describe "if a locale is given" do
        it "gets written to the session" do
          @r18n.session_locale(@session = {}, @locales, "en")
          @session[:locale].must_equal "en"
        end
        it " doesn't bail if there's no session" do
          @r18n.session_locale(nil, @locales, "en").must_equal "en"
        end
      end
      describe "if no locale is given" do
        it "takes the one from session of avaible" do
          @r18n.session_locale({:locale => "en"}, @locales, nil).must_equal "en"
        end
      end
    end
    describe "not setting a locale" do
      it "nothing is set" do
        @r18n.session_locale(nil, @locales, nil).must_be_nil
      end
    end
  end
end
