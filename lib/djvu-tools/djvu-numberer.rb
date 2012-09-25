# Page title management for page number generation
class DjVuNumberer < DjVuTools

  # @see ObjectName#method
  def initialize file
    super
    @sections = []
  end

  # Add a labeled section.
  # @param [Hash] section
  # @see file:README.rdoc The Numberer section in the README
  def add_section section

    section[:delta] ||= 1

    if section[:start].nil?
      raise ArgumentError, 'Cannot label a range of pages with the same title' if ( section[:range].max - section[:range].min > 0 )
      section[:range].each { |n| @djvu.title_page n, section[:title]  }
    else
      section[:range].each_with_index do |n, i|
        number = section[:start] + i * section[:delta].to_i
        number =
          case section[:type]
          when :arabic
            number.to_s
          when :upper_roman
            RomanNumerals::to_roman(number).upcase
          when :lower_roman
            RomanNumerals::to_roman(number).downcase
          end
        @djvu.title_page n, "#{section[:prefix]}#{number}#{section[:suffix]}"
      end
    end
  end
end