# frozen_string_literal: true

require 'debug'
require 'hexapdf'
require 'redcarpet'

# Renders an adminsitrative document
class PaperpasseRender < Redcarpet::Render::Base
  attr_reader :composer

  attr_accessor :list_context_open,
                :list_context,
                :title,
                :subtitle,
                :header_done

  def initialize
    @composer = HexaPDF::Composer.new(page_size: :A4, margin: 48)

    @title = "Audit reco"
    @subtitle = "This is great"

    @header_done = false

    setup_fonts!
    setup_style!

    super
  end

  def doc_header
    @composer.image('./logo.png', height: 100, position: :float)
    @composer.text(@title.upcase, style: :title, margin: [150, 0, 0, 0])
    @composer.text(@subtitle.upcase, style: :subtitle)

    nil
  end

  def in_list?
    list_context_open == true
  end

  def header(title, level)
    nil
  end

  def list(_content, _list_type)
    # list_context.yield

    # list_context_open = false
  end

  def list_item(text, _list_type)
    composer.list { |l| l.text(text) }

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
    font_files = Dir.glob(File.join(__dir__, '../fonts/*.ttf'))

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
  end
end
