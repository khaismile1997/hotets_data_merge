# frozen_string_literal: true

module Swagger
  module Definition
    def self.call
      # The purpose of the method is to parse swagger definition yaml
      #   `JsonRefs` parses only one layer, it fails to parse multi layer parse.
      hash = YAML.load_file(Rails.root.join("swagger/definition.yml"))
      v1 = YAML.load_file(Rails.root.join("swagger/v1/main.yml")) || {}
      hash["paths"] = JsonRefs.call(v1)

      hash
    end
  end
end
