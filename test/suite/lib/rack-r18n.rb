BareTest.suite "rack-r18n" do
  suite "#session_locale" do
    setup do
      @locales = Object.new
      @r18n = Rack::R18n.new(proc {})
    end
    suite "setting a locale" do
      suite "if a locale is given" do
        assert "it gets written to the session" do
          @r18n.session_locale(@session = {}, @locales, "en")
          equal("en", @session[:locale])
        end
        assert "it doesn't bail if there's no session" do
          equal("en", @r18n.session_locale(nil, @locales, "en"))
        end
      end
      suite "if no locale is given" do
        assert "it takes the one from session of avaible" do
          equal("en", @r18n.session_locale({:locale => "en"}, @locales, nil))
        end
      end
    end
    suite "not setting a locale" do
      assert "nothing is set" do
        equal(nil, @r18n.session_locale(nil, @locales, nil))
      end
    end
  end
end
