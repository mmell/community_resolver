class SampleAuthorityAndSynonym < ActiveRecord::Migration
  def change
    create_table "authorities", :force => true do |t|
      t.string   "canonical_id", :null => false
      t.timestamps
    end

    add_index "authorities", ["canonical_id"], :name => "canonical_id"

    create_table "synonyms", :force => true do |t|
      t.integer  "authority_id",                :null => false
      t.string   "synonym",                     :null => false
      t.timestamps
    end

    add_index "synonyms", ["authority_id"], :name => "authority_idx"
    add_index "synonyms", ["synonym"], :name => "synonym_idx"

  end
end
