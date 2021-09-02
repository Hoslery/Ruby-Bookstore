# frozen_string_literal: true

require 'dry-schema'

ProductDeleteSchema = Dry::Schema.Params do
  required(:confirmation).filled(true)
end
