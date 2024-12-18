# frozen_string_literal: true

require 'yaml'

module Paperasse
  class FrontmatterParser
    DELIMITER_RE = /---.*---/m.freeze

    def self.parse(raw)
      match = DELIMITER_RE.match(raw)[0]

      {
        content: raw.tap { |str| str.slice!(match) },
        data: YAML.safe_load(match)
      }
    end
  end
end
