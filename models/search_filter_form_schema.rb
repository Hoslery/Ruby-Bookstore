# frozen_string_literal: true

require 'dry-schema'

require_relative 'schema_types'

SearchFilterFormSchema = Dry::Schema.Params do
  optional(:s_title).maybe(SchemaTypes::StrippedString)
  optional(:s_genre).maybe(SchemaTypes::StrippedString)
end
