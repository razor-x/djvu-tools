require 'roman-numerals'
require 'which'

require 'djvu-tools/version'
require 'djvu-tools/djvused'
require 'djvu-tools/djvu-numberer'

# Ruby toolbox for manipulating DjVu files.
class DjVuTools

  # @see DjVused#new
  def initialize file
    @djvu = DjVused.new file
  end

  # Run djvused with the current command string.
  def run
    @djvu.save
  end
end
