# frozen_string_literal: true

require_relative 'lib/templates/base'
require_relative 'lib/frontmatter'

content = File.read('./note.md')

puts 'Generating document...'

Paperasse::FrontmatterParser.parse(content) => { data:, content: }

Redcarpet::Markdown.new(Paperasse::Base.new(data)).render(content)

puts 'Done.'
