class InsertIsoCodeToCountry < ActiveRecord::Migration[6.0]
  def up
    ApplicationRecord.country_context_with 'global' do
      PaperTrail.request(enabled: false) do
        {th: 'THB', vn: 'VND'}.each do |short_name, iso_code|
          country = Country.find_by(short_name: short_name)
          unless country.nil?
            seed_data = Country.seed_data.select { |con| con[:short_name] == short_name.to_s }.first
            country.assign_attributes(seed_data)
            country.iso_code = iso_code
            country.save!
          end

        end
      end
    end
  end
end
