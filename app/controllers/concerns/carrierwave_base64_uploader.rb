module CarrierwaveBase64Uploader
  extend ActiveSupport::Concern
  private
  
  def base64_conversion(uri_str, filename = 'icon')
    image_data = split_base64(uri_str)
    image_data_string = image_data[:data]
    image_data_binary = Base64.decode64(image_data_string)
    
    temp_img_file = Tempfile.new(filename)
    temp_img_file.binmode
    temp_img_file << image_data_binary
    temp_img_file.rewind

    img_params = {:filename => "#{filename}.#{image_data[:extension]}",
    :type => image_data[:type], :tempfile => temp_img_file}
    ActionDispatch::Http::UploadedFile.new(img_params)
  end

  def split_base64(uri_str)
    if uri_str.match(%r{data:(.*?);(.*?),(.*?)$})
      uri = Hash.new
      uri[:type] = $1
      uri[:encorder] = $2
      uri[:data] = $3
      uri[:extension] = $1.split('/')[1]
      return uri
    else
      return nil
    end
  end

end
