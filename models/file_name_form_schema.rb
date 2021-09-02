# frozen_string_literal: true

require 'dry-schema'

require_relative 'schema_types'

FileNameFormSchema = Dry::Schema.Params do
  required(:file_name).filled(SchemaTypes::StrippedString)
end
