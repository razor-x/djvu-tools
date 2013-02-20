# Interface to djvused.
class DjVused

  attr_reader :file
  attr_accessor :command

  # @see DjVused#new
  def initialize file
    raise SystemCallError, 'djvused command not found' if ( Which::which 'djvused' ).empty?

    @file = File.expand_path file
    raise RuntimeError, 'File not found' unless ( File.exists? @file )
    @command = ""
  end

  # Appends command to set page title.
  # @param [Integer] page number
  # @param [String] title cannot contain single or double quotes
  # @return [String] command string
  def title_page page, title
    raise ArgumentError, 'Argument is not an integer' unless page.is_a? Integer
    raise ArgumentError, 'Argument is cannot contain a single or double quote' if title =~ /['"]/

    @command << %Q{select #{page}; set-page-title "#{title}";}
  end

  # Runs djvused with command and saves to file.
  def save
    system *['djvused', '-s','-e', @command, @file]
  end
end
