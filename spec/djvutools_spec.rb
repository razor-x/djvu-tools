require 'djvu-tools'

describe DjVuTools do

  before :each do
    File.stub(:exists?).and_return(true)
    Which.stub(:which).and_return( ['djvused'] )
    @tool = DjVuTools.new 'input file.djvu'
  end

  describe ".run" do
    it "calls save on the DjVused object" do
      @tool.instance_eval{ @djvu }.should_receive(:save)
      @tool.run
    end
  end

end
