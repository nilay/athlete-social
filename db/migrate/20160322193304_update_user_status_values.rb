class UpdateUserStatusValues < ActiveRecord::Migration[5.0]
  def change
    Athlete.all.each do |a|
      a.status = a.active? ? :active : :inactive
      a.save!
    end
    Fan.all.each do |f|
      f.status = f.active? ? :active : :inactive
      f.save!
    end
    CmsAdmin.all.each do |c|
      c.status = c.active? ? :active : :inactive
      c.save!
    end
    BrandUser.all.each do |b|
      b.status = b.active? ? :active : :inactive
      b.save!
    end
  end
end
