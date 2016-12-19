class AddSuggestedPackageVersions < ActiveRecord::Migration
  def up
    add_index :suggested_package_version, :suggested_package_id
    add_index :suggested_package_version, :version_id
  end

  def down
    remove_index :suggested_package_version, :suggested_package_id
    remove_index :suggested_package_version, :version_id
  end
end
