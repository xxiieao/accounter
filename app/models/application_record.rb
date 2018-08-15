# frozen_string_literal: true

# Basic model class
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
