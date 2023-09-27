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
    @header_done = false
    setup_style!

    super
  end

  def in_list?
    list_context_open == true
  end

  def header(title, level)
    if level == 1
      @title = title
      return
    elsif level == 2
      @subtitle = title

      render_header
      return
    end

    composer.text(title, style: :paragraph_title)
  end

  def list(_content, _list_type)
    # list_context.yield

    # list_context_open = false
  end

  def list_item(text, list_type)
    composer.list { |l| l.text(text) }
  end

  def paragraph(text)
    composer.text(text)
  end

  def postprocess(_full_doc)
    composer.write('./output.pdf')
  end

  def render_header
    return if header_done

    composer.image('./logo.png', height: 100, position: :float)
    composer.text(@title.upcase, style: :title, margin: [150, 0, 0, 0])
    composer.text(@subtitle.upcase, style: :subtitle)

    @header_done = true
  end

  private

  def setup_style!
    composer.style(:base, font: 'Times', font_size: 10, line_spacing: 1.3, last_line_gap: true, padding: [3, 0, 0, 0])
    composer.style(:title, font: ['Times', { variant: :bold }], font_size: 12, align: :center, padding: [10, 0])
    composer.style(:direction, font_size: 12, align: :right)
    composer.style(:subtitle, align: :center, padding: [0, 30], line_height: 12)
    composer.style(:paragraph_title, font: ['Times', { variant: :bold }], font_size: 10, margin: [10, 0, 0, 0])
    composer.style(:legal, font: ['Times', { variant: :italic }])
  end
end
