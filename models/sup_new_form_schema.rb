# frozen_string_literal: true

require 'dry-schema'

require_relative 'schema_types'

SupNewFormSchema = Dry::Schema.Params do
  required(:title).filled(SchemaTypes::StrippedString)
  required(:price).filled(:float, gt?: 0)
end
