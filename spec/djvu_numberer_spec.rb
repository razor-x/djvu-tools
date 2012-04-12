require 'djvu-tools/djvu-numberer'

describe DjVuNumberer do

  before :each do
    File.stub(:exists?).and_return(true)
    Which.stub(:which).and_return( ['djvused'] )
    @numberer = DjVuNumberer.new 'input file.djvu'
  end

  describe ".add_section" do

    it "titles a single page" do
      section = { title: 'the title', range: (10..10) }
      @numberer.instance_eval{ @djvu }.should_receive(:title_page).with(10, section[:title])
      @numberer.add_section section
    end

    it "will not title a range of pages with a single title" do
      section = { title: 'the title', range: (10..12) }
      expect { @numberer.add_section section }.to raise_error ArgumentError
    end

    it "titles a range of pages with arabic numerals" do
      section = { start: 42, range: (10..12), type: :arabic }
      section[:range].each_with_index do |n, i|
        @numberer.instance_eval{ @djvu }.should_receive(:title_page).with(n, "#{section[:start] + i}")
      end
      @numberer.add_section section
    end

    it "titles a range of pages with uppercase roman numerals" do
      section = { start: 3, range: (10..11), type: :upper_roman }
      @numberer.instance_eval{ @djvu }.should_receive(:title_page).with(10, "III")
      @numberer.instance_eval{ @djvu }.should_receive(:title_page).with(11, "IV")
      @numberer.add_section section
    end

    it "titles a range of pages with lowercaseroman numerals" do
      section = { start: 9, range: (20..21), type: :lower_roman }
      @numberer.instance_eval{ @djvu }.should_receive(:title_page).with(20, "ix")
      @numberer.instance_eval{ @djvu }.should_receive(:title_page).with(21, "x")
      @numberer.add_section section
    end
  end
end