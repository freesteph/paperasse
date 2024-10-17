# frozen_string_literal: true

require_relative 'lib/renderer'

content = File.read('./note.md')

doc = Redcarpet::Markdown.new(PaperpasseRender)

puts "Generating document..."

doc.render(content)

puts "Done."
