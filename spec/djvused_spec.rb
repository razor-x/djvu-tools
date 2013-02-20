require 'djvu-tools/djvused'

describe DjVused do

  describe ".new" do

    it "fails when djvused command is not installed" do
      Which.stub(:which).and_return( [] )
      expect { DjVused.new 'input.djvu' }.to raise_error SystemCallError
    end

    it "fails when file does not exist" do
      File.stub(:exists?).and_return(false)
      expect { DjVused.new 'input.djvu' }.to raise_error RuntimeError
    end

    it "creates a new object with path to input file" do
      File.stub(:exists?).and_return(true)
      djvu = DjVused.new 'input.djvu'
      djvu.file.should eql ( File.expand_path 'input.djvu' )
    end
  end

  context "when a new DjVused object can be created" do

    before :each do
      File.stub(:exists?).and_return(true)
      Which.stub(:which).and_return( ['djvused'] )
      @djvu = DjVused.new 'input file.djvu'
    end

    describe ".title_page" do

      context "when given bad arguments" do

        it "fails if page number is not an integer" do
          expect { @djvu.title_page '1', 'the title' }.to raise_error ArgumentError
        end

        it "fails if title contains single or double quotes" do
          %W{ 'the title' "the title" 'the title" }.each do |w|
            expect { @djvu.title_page 1, w }.to raise_error ArgumentError
          end
        end
      end

      context "when given valid arguments" do

        before :each do
          @args_1 = [ 1, 'the title' ]
          @args_2 = [ 42, 'the other title' ]

          def cmd args
            %Q{select #{args[0]}; set-page-title "#{args[1]}";}
          end
        end

        it "generates the command section to set a page title" do
          ( @djvu.title_page *@args_1 ).should eql ( cmd @args_1 )
        end

        it "adds the command section to the full command" do
          @djvu.title_page *@args_1
          @djvu.title_page *@args_2

          @djvu.command.should match /^#{cmd @args_1}/
          @djvu.command.should match /#{cmd @args_2}$/
        end
      end
    end

    describe ".save" do

      it "runs the command and saves to file" do
        @djvu.command = 'full; command;'
        @djvu.should_receive(:system).with('djvused', '-s', '-e', @djvu.command, an_instance_of(String) )
        @djvu.save
      end
    end
  end
end
