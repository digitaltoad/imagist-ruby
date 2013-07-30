require 'sinatra/base'
require 'RMagick'

module Imagist
  class App < Sinatra::Base
    enable :logging

    before do
      if params[:color] && /\A([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})\z/.match(params[:color]).nil?
        halt 'Invalid color'
      end
    end

    get /\A\/([0-9]+)x([0-9]+).(png|gif|jpg)\z/ do |height, width, format|
      height = Integer(height)
      width  = Integer(width)

      if height > 2000 || width > 2000
        halt 'Image too big!'
      end

      text   = params[:text]  || "#{height}x#{width}"
      color  = params[:color] || 'eee'

      image = Magick::Image.new(height, width)
      image.format = format
      image.background_color = "##{color}"
      image.erase!
      draw = Magick::Draw.new
      draw.font_family = 'HelveticaNeue'
      draw.fill = '#888'
      draw.pointsize = ((height + width) / 2) * 0.10
      draw.gravity = Magick::CenterGravity
      draw.annotate(image, 0, 0, 0, 0, text)

      content_type image.mime_type

      stream do |out|
        out << image.to_blob
      end
    end
  end
end
