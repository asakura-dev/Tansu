module Third
  class ProductImageController < ApplicationController
    def show
      white_list = ["http://item.shopping.c.yimg.jp/"]
      url = params["url"]
      white_list.each do |domain|
        if /^#{domain}/ =~ url
          res = get_image(url)
          mime =  MimeMagic.by_magic(res).to_s.gsub(/^.*?\//, '')
          if ["jpeg","png"].include?(mime)
            send_data res, :type => "image/#{mime}", :disposition => "inline"
            return 
          end
        end
      end
      render :json => {'status' => 'error'}
    end
    private 
    def get_image(url)
      res = Net::HTTP.get URI(url)
    end
  end
end
