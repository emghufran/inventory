class DataFile < ActiveRecord::Base
  def self.save(upload, unique_prepend = "")
    name =  upload['datafile'].original_filename
    name = unique_prepend + "_" + self.sanitize_filename(name)
    directory = "public/data"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
    return path
  end

  def self.sanitize_filename(file_name)
    # get only the filename, not the whole path (from IE)
    just_filename = File.basename(file_name) 
    # replace all none alphanumeric, underscore or perioids
    # with underscore
    just_filename.sub(/[^\w\.\-]/,'_') 
  end
end
