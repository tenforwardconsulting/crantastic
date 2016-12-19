class OtherRelatedIndices < ActiveRecord::Migration
  def up
    add_index :enhanced_package_version, :enhanced_package_id
    add_index :enhanced_package_version, :version_id

    add_index :required_package_version, :required_package_id
    add_index :required_package_version, :version_id
  end

  def down
    remove_index :enhanced_package_version, :enhanced_package_id
    remove_index :enhanced_package_version, :version_id

    remove_index :required_package_version, :required_package_id
    remove_index :required_package_version, :version_id
  end
end
