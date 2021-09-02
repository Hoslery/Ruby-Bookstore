# frozen_string_literal: true

require 'dry-schema'

require_relative 'schema_types'

BookNewFormSchema = Dry::Schema.Params do
  required(:author).filled(SchemaTypes::StrippedString)
  required(:title).filled(SchemaTypes::StrippedString)
  required(:genre).filled(SchemaTypes::StrippedString)
  required(:price).filled(:float, gt?: 0)
end
