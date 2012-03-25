# Authority should never be destroyed to preserve non-recyclability
class Authority < ActiveRecord::Base
  CID_Values = %W{ 1 2 3 4 5 6 7 8 9 0 A B C D E F }

  validates_format_of :canonical_id, :with => /^(=|@)(!([A-F0-9]{4,4}\.?){2,4})*$/
  validates_uniqueness_of :canonical_id
  validates_presence_of :canonical_id

  has_many :synonyms, :order => :position

  class << self
    def new_canonical_id(parent_cid = '@')
      cid = generate_canonical_id(parent_cid)
      until Authority.find_by_canonical_id(cid).nil?
        cid = generate_canonical_id(parent_cid)
      end
      cid
    end

    def generate_canonical_id(parent_cid, quads = 2)
      parent_cid + '!' + ((1..quads).map { |e| self.generate_cid_quad } * '.')
    end

    def generate_cid_quad
      "#{CID_Values[rand(16)]}#{CID_Values[rand(16)]}#{CID_Values[rand(16)]}#{CID_Values[rand(16)]}"
    end

  end

end
