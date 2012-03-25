class Synonym < ActiveRecord::Base
  belongs_to :authority
  validates_presence_of :authority_id
  validates_presence_of :synonym
  validates_uniqueness_of :synonym, :case_sensitive => false

  def to_s
    self.synonym
  end

  def canonical_id
    self.authority.canonical_id
  end

end
