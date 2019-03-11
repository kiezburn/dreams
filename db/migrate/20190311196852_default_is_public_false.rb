class DefaultIsPublicFalse < ActiveRecord::Migration
    def change
      change_column_default :camps, :is_public, false
    end
  end
  