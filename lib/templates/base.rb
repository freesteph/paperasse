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

      @data = data

      @title = data["title"]
      @subtitle = data["subtitle"]

      setup_fonts!
      setup_style!

      # @composer.document.config['debug'] = true
      super()
    end

    def doc_header
      @composer.container do |container|
        container.image('./logo.png', height: 100, style: { mask_mode: :box })
        container.text(author, text_align: :right, font: ['Arial', { variant: :bold }], font_size: 12)
      end

      @composer.container(style: { padding: [49, 0, 35, 0] }) do |container|
        container.text(@title.upcase, style: :title) # don't upcase, style it
        container.text(@subtitle, style: :subtitle) unless @subtitle.nil?
      end

      nil
    end

    def author
      "Direction\nInterministérielle\ndu Numérique"
    end

    def header(title, level)
      case level
      when 1
        @composer.text(title.upcase, style: :title, margin: [150, 0, 0, 0])
      when 2
        @composer.text(title.upcase, style: :paragraph_title)
      end

      nil
    end

    def list_item(text, _list_type)
      composer.list { |l| l.text(text, margin: [3, 0]) }

      nil
    end

    def paragraph(text)
      composer.text(text, style: :base, margin: [5, 0])

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
      composer.style(:base, font: 'Arial', font_size: 10, last_line_gap: true)
      composer.style(:title, font: ['Arial', { variant: :bold }], font_size: 12, align: :center)
      composer.style(:direction, font_size: 12, align: :right)
      composer.style(:subtitle, align: :center, line_height: 12)
      composer.style(:paragraph_title, font: ['Arial', { variant: :bold }], font_size: 10)
      composer.style(:legal, font: ['Arial', { variant: :italic }])
      composer.style(:bold, font: ['Arial', { variant: :bold }])
    end
  end
end
