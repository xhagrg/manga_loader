class LoadMangaController < ActionController::Base
  layout 'application'
  def index
    @url = params['url']
    if @url
      source = @url.split('.').second
      template = Phantomjs.run("#{Rails.root}/lib/phantom_renderer.js", @url)
      raw_html = Nokogiri::HTML.parse(template)
      send("handle_#{source}", raw_html)
    end
  end

  private
    def handle_mangapanda(raw_html)
      image_url = raw_html.css('div#imgholder a').first
      handle_image_url(image_url) if image_url
    end

    def handle_hellocomic(raw_html)
      image_url = raw_html.css('div.coverIssue a').first
      handle_image_url(image_url, page_prefix = 'p') if image_url
    end

    def handle_magastack(raw_html)
      image_url = raw_html.css('div.coverIssue a').first
      url_array = url.split('?page=') || 2
      @last_page = url_array.pop()
      @image_url = image_url.children.first.attributes['src']
      @next_page_url = image_url + "?page=#{@last_page.to_i + 1}"
    end

    def handle_image_url(image_url, page_prefix = '')
      url_array = url.split('/')
      @last_page = url_array.pop()
      @image_url = image_url.children.first.attributes['src']
      if url_array.length == 5
        @next_page_url = (url_array << ("#{page_prefix}#{@last_page.to_i + 1}")).join('/')
      elsif @last_page == @image_url.value.split('/')[-2].to_s
        @next_page_url = url + '/' + "#{page_prefix}" +'1'
      end
    end
end
