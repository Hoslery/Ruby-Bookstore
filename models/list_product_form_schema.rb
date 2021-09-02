# frozen_string_literal: true

require 'dry-schema'

require_relative 'schema_types'

ListProductFormSchema = Dry::Schema.Params do
  required(:title).filled(SchemaTypes::StrippedString)
end
