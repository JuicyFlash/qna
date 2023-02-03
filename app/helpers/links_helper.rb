module LinksHelper

  def format_link(link)
    if gist?(link.url)
      content_tag :div, '', id: "link-#{link.id}", data: { gist_url: link.url }
    else
      link_to link.name, link.url, target: "_blank"
    end
  end

  private

  def gist?(url)
    url.include?("gist.github.com")
  end
end
