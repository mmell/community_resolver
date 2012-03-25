Factory.define :authority do |f|
  f.canonical_id { Authority.new_canonical_id }
end

Factory.sequence :synonym do |n|
  "@example*synonym.0#{n.to_s + Time.now.to_i.to_s + Factory.next(:nnn) }"
end
