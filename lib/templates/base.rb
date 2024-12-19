# frozen_string_literal: true

require 'hexapdf'
require 'redcarpet'

require_relative '../frontmatter'

# Renders an adminsitrative document
module Paperasse
  class Base < Redcarpet::Render::Base
    attr_reader :composer

    attr_accessor :title,
                  :subtitle

    def initialize(data)
      @composer = HexaPDF::Composer.new(page_size: :A4, margin: 48)

      @title = data[:title]
      @subtitle = data[:subtitle]

      setup_fonts!
      setup_style!

      super()
    end

    def doc_header
      @composer.image('./logo.png', height: 100, position: :float)

      nil
    end

    def header(title, level)
      case level
      when 1
        @composer.text(title.upcase, style: :title, margin: [150, 0, 0, 0])
      when 2
        @composer.text(title.upcase, style: :subtitle)
      end

      nil
    end

    def list_item(text, _list_type)
      composer.list { |l| l.text(text) }

      nil
    end

    def double_emphasis(text)
      nil
    end

    def emphasis(text)
      composer.text(text, style: :bold)

      nil
    end

    def paragraph(text)
      composer.text(text)

      nil
    end

    def postprocess(_full_doc)
      composer.write('./output.pdf')
    end

    private

    def setup_fonts!
      font_files = Dir.glob(File.join(__dir__, '../../fonts/*.ttf'))

      arial_font_map = {
        'Arial' => font_files.reduce({}) do |memo, font_path|
          variant = infer_variant(font_path) || :none

          memo.tap { |m| m[variant] = font_path }
        end
      }

      @composer.document.config['font.map'] = arial_font_map
    end

    # some/path/Arial Bold Italic.tff => :bold_italic
    def infer_variant(filename)
      components = File.basename(filename, '.*')
                     .split
                     .slice(1..)

      return nil if components.empty?

      components.join('_').downcase.to_sym
    end

    def setup_style!
      composer.style(:base, font: 'Arial', font_size: 10, line_spacing: 1.3, last_line_gap: true, padding: [3, 0, 0, 0])
      composer.style(:title, font: ['Arial', { variant: :bold }], font_size: 12, align: :center, padding: [10, 0])
      composer.style(:direction, font_size: 12, align: :right)
      composer.style(:subtitle, align: :center, padding: [0, 30], line_height: 12)
      composer.style(:paragraph_title, font: ['Arial', { variant: :bold }], font_size: 10, margin: [10, 0, 0, 0])
      composer.style(:legal, font: ['Arial', { variant: :italic }])
      composer.style(:bold, font: ['Arial', { variant: :bold }])
    end
  end
end
