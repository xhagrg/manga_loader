class LoadMangaController < ActionController::Base
  layout 'application'
  def index
    url = params['url']
    if url
      template = Phantomjs.run("#{Rails.root}/lib/phantom_renderer.js", url)
      raw_html = Nokogiri::HTML.parse(template)
      image_url = raw_html.css('div#imgholder a').first

      if image_url.present?
        url_array = url.split('/')
        @last_page = url_array.pop()
        @image_url = image_url.children.first.attributes['src']
        if url_array.length == 5
          @next_page_url = (url_array << (@last_page.to_i + 1)).join('/')
        elsif @last_page == @image_url.value.split('/')[-2].to_s
          @next_page_url = url + '/' + '1'
        end
      end

    end
  end
end