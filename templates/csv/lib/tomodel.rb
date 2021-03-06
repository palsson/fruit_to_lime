require 'fruit_to_lime'

class ToModel
    def to_organization(row)
        organization = FruitToLime::Organization.new
        organization.integration_id = row['id']
        organization.name = row['name']
        return organization
    end

    def to_model(organization_file_name)
        rootmodel = FruitToLime::RootModel.new
        if organization_file_name != nil
            organization_file_data = File.open(organization_file_name, 'r').read.encode('UTF-8',"ISO-8859-1")
            rows = FruitToLime::CsvHelper::text_to_hashes(organization_file_data)
            rows.each do |row|
                rootmodel.organizations.push(to_organization(row))
            end
        end        
        return rootmodel
    end

    def save_xml(file)
        File.open(file,'w') do |f|
            f.write(FruitToLime::SerializeHelper::serialize(to_xml_model))
        end
    end
end

require "thor"
require "fileutils"
require 'pathname'

class Cli < Thor
    desc "to_go ORGANIZATIONS FILE", "Exports xml to FILE using for ORGANIZATIONS csv file."
    def to_go(organizations, file = nil)
        file = 'export.xml' if file == nil
        toModel = ToModel.new()
        model = toModel.to_model(organizations)
        model.serialize_to_file(file)  
    end
end
