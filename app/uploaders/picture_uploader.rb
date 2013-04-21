# encoding: utf-8

class PictureUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  # File storage if in test environment
  Rails.env.test? ? storage(:file) : storage(:fog)
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:

  version :large do
    process :resize_to_limit => [600, 0]
  end

  #putting 0 in the second parameter makes it resize to the width only. Preservers aspect ratio,
  version :cover do
    #process :cover_crop
    #not using the cropping right now. Might add this later.
    process :resize_to_limit => [360, 0]
  end

  version :thumb do
    #resize_to_fill will also fill in the image if it is smaller than the parameters to begin with. 
    #adding in the cropping method below
    #process :crop
    process :resize_to_limit => [80, 80]
  end

  def crop
    if model.crop_x.present?
      resize_to_limit(600, 600)
      manipulate! do |img|
        x = model.crop_x.to_i
        y = model.crop_y.to_i
        w = model.crop_w.to_i
        h = model.crop_h.to_i
        img.crop!(x, y, w, h)
      end
    end
  end

  def cover_crop
    if model.crop_x.present?
      resize_to_limit(500, 500)
      manipulate! do |img|
        x = model.crop_x.to_i
        y = model.crop_y.to_i
        w = model.crop_w.to_i
        h = model.crop_h.to_i
        img.crop!(x, y, w, h)
      end
    end
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    if original_filename 
      @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
      "#{@name}.#{file.extension}"
    end
    # time_var = Time.now.to_i
    # "project-image-#{time_var}.png" if original_filename
  end

  def geometry
    @geometry ||= get_geometry
  end

  def get_geometry
    if @file
      img = ::Magick::Image::read(@file.file).first
      geometry = { width: img.columns, height: img.rows }
    end
  end

end
