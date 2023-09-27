# frozen_string_literal: true

require_relative './lib/renderer'

content = <<~HEREDOC
  # Titre officiel important machin
  ## second titre

  ### titre 3

  Ceci est du texte incroyable machin

  ### titre 4

  Trop cool la vida

  Sinon voilà :

    - il faut que
    - si jamais
    - au cas où

HEREDOC

doc = Redcarpet::Markdown.new(PaperpasseRender, {})

doc.render(File.read('./arnaud.md'))
