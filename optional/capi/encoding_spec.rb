require File.expand_path('../spec_helper', __FILE__)

ruby_version_is "1.9" do
  load_extension('encoding')

  describe "C-API Encoding function" do
    before :each do
      @s = CApiEncodingSpecs.new
    end

    describe "rb_enc_find" do
      it "returns the encoding of an Encoding" do
        @s.rb_enc_find("UTF-8").should == "UTF-8"
      end

      it "returns the encoding of an Encoding specified with lower case" do
        @s.rb_enc_find("utf-8").should == "UTF-8"
      end
    end

    describe "rb_enc_find_index" do
      it "returns the index of an Encoding" do
        @s.rb_enc_find_index("UTF-8").should >= 0
      end

      it "returns the index of an Encoding specified with lower case" do
        @s.rb_enc_find_index("utf-8").should >= 0
      end
    end

    describe "rb_enc_from_index" do
      it "returns an Encoding" do
        @s.rb_enc_from_index(0).should be_an_instance_of(String)
      end
    end

    describe "rb_usascii_encoding" do
      it "returns the encoding for Encoding::US_ASCII" do
        @s.rb_usascii_encoding.should == "US-ASCII"
      end
    end

    describe "rb_ascii8bit_encoding" do
      it "returns the encoding for Encoding::ASCII_8BIT" do
        @s.rb_ascii8bit_encoding.should == "ASCII-8BIT"
      end
    end

    describe "rb_utf8_encoding" do
      it "returns the encoding for Encoding::UTF_8" do
        @s.rb_utf8_encoding.should == "UTF-8"
      end
    end

    describe "rb_enc_from_encoding" do
      it "returns an Encoding instance from an encoding data structure" do
        @s.rb_enc_from_encoding("UTF-8").should == Encoding::UTF_8
      end
    end

    describe "rb_locale_encoding" do
      it "returns the encoding for the current locale" do
        @s.rb_locale_encoding.should == Encoding.find('locale').name
      end
    end

    describe "rb_filesystem_encoding" do
      it "returns the encoding for the current filesystem" do
        @s.rb_filesystem_encoding.should == Encoding.find('filesystem').name
      end
    end

    describe "rb_enc_get" do
      it "returns the encoding ossociated with an object" do
        str = "abc".encode Encoding::ASCII_8BIT
        @s.rb_enc_get(str).should == "ASCII-8BIT"
      end
    end

    describe "rb_enc_get_index" do
      it "returns the index of the encoding of a String" do
        @s.rb_enc_get_index("string").should >= 0
      end

      it "returns the index of the encoding of a Regexp" do
        @s.rb_enc_get_index(/regexp/).should >= 0
      end

      it "returns the index of the encoding of a Symbol" do
        @s.rb_enc_get_index(:symbol).should >= 0
      end
    end

    describe "rb_to_encoding" do
      it "returns the encoding for the Encoding instance passed" do
        @s.rb_to_encoding(Encoding::BINARY).should == "ASCII-8BIT"
      end

      it "returns the encoding when passed a String" do
        @s.rb_to_encoding("ASCII").should == "US-ASCII"
      end

      it "calls #to_str to convert the argument to a String" do
        obj = mock("rb_to_encoding Encoding name")
        obj.should_receive(:to_str).and_return("utf-8")

        @s.rb_to_encoding(obj).should == "UTF-8"
      end
    end

    describe "rb_to_encoding_index" do
      it "returns the index of the encoding for the Encoding instance passed" do
        @s.rb_to_encoding_index(Encoding::BINARY).should >= 0
      end

      it "returns the index of the encoding when passed a String" do
        @s.rb_to_encoding_index("ASCII").should >= 0
      end

      it "calls #to_str to convert the argument to a String" do
        obj = mock("rb_to_encoding Encoding name")
        obj.should_receive(:to_str).and_return("utf-8")

        @s.rb_to_encoding_index(obj).should >= 0
      end
    end

    describe "rb_enc_copy" do
      before :each do
        @obj = "rb_enc_copy".encode(Encoding::US_ASCII)
      end

      it "sets the encoding of a String to that of the second argument" do
        @s.rb_enc_copy("string", @obj).encoding.should == Encoding::US_ASCII
      end

      it "sets the encoding of a Regexp to that of the second argument" do
        @s.rb_enc_copy(/regexp/, @obj).encoding.should == Encoding::US_ASCII
      end

      it "sets the encoding of a Symbol to that of the second argument" do
        @s.rb_enc_copy(:symbol, @obj).encoding.should == Encoding::US_ASCII
      end
    end

    describe "rb_default_internal_encoding" do
      it "returns 0 if Encoding.default_internal is nil" do
        Encoding.default_internal = nil
        @s.rb_default_internal_encoding.should be_nil
      end

      it "returns the encoding for Encoding.default_internal" do
        Encoding.default_internal = "US-ASCII"
        @s.rb_default_internal_encoding.should == "US-ASCII"
        Encoding.default_internal = "UTF-8"
        @s.rb_default_internal_encoding.should == "UTF-8"
      end
    end

    describe "rb_enc_associate" do
      it "sets the encoding of a String to the encoding" do
        @s.rb_enc_associate("string", "ASCII-8BIT").encoding.should == Encoding::ASCII_8BIT
      end

      it "sets the encoding of a Regexp to the encoding" do
        @s.rb_enc_associate(/regexp/, "ASCII-8BIT").encoding.should == Encoding::ASCII_8BIT
      end

      it "sets the encoding of a Symbol to the encoding" do
        @s.rb_enc_associate(:symbol, "US-ASCII").encoding.should == Encoding::US_ASCII
      end
    end

    describe "rb_enc_associate_index" do
      it "sets the encoding of a String to the encoding" do
        enc = @s.rb_enc_associate_index("string", "ASCII-8BIT").encoding
        enc.should == Encoding::ASCII_8BIT
      end

      it "sets the encoding of a Regexp to the encoding" do
        enc = @s.rb_enc_associate_index(/regexp/, "ASCII-8BIT").encoding
        enc.should == Encoding::ASCII_8BIT
      end

      it "sets the encoding of a Symbol to the encoding" do
        enc = @s.rb_enc_associate(:symbol, "US-ASCII").encoding
        enc.should == Encoding::US_ASCII
      end
    end

    describe "rb_ascii8bit_encindex" do
      it "returns an index for the ASCII-8BIT encoding" do
        @s.rb_ascii8bit_encindex().should >= 0
      end
    end

    describe "rb_utf8_encindex" do
      it "returns an index for the UTF-8 encoding" do
        @s.rb_utf8_encindex().should >= 0
      end
    end

    describe "rb_usascii_encindex" do
      it "returns an index for the US-ASCII encoding" do
        @s.rb_usascii_encindex().should >= 0
      end
    end

    describe "rb_locale_encindex" do
      it "returns an index for the locale encoding" do
        @s.rb_locale_encindex().should >= 0
      end
    end

    describe "rb_filesystem_encindex" do
      it "returns an index for the filesystem encoding" do
        @s.rb_filesystem_encindex().should >= 0
      end
    end
  end
end
