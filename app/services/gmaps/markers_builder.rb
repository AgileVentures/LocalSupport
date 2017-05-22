# extracted from 'gmaps4rails' gem
# link = https://github.com/apneadiving/Google-Maps-for-Rails/blob/master/lib/gmaps4rails/markers_builder.rb
module Gmaps
  # the to_gmaps4rails method accepts a block to customize:
  # - infowindow
  # - picture
  # - shadow
  # - title
  # - sidebar
  # - json
  #
  # This works this way:
  #   @users = User.all
  #   @json  = Gmaps::MarkersBuilder.generate @users do |user, marker|
  #     marker.lat user.latitude
  #     marker.lng user.longitude
  #     marker.infowindow render_to_string(
  #       :partial => "/users/my_template",
  #       :locals => { :object => user}
  #       ).gsub(/\n/, '').gsub(/"/, '\"')
  #     marker.picture({
  #       :url    => "http://www.blankdots.com/img/github-32x32.png",
  #       :width  => "64",
  #       :height => "64",
  #       :scaledWidth => "32", # Scaled width is half of the retina resolution; optional
  #       :scaledHeight => "32", # Scaled width is half of the retina resolution; optional
  #       })
  #     marker.title   "i'm the title"
  #     marker.json({ :id => user.id })
  #   end


  class MarkersBuilder

    def self.generate(collection, &block)
      MarkersBuilder.new(collection).call(&block)
    end

    def initialize(collection)
      @collection = Array(collection)
    end

    def call(&block)
      @collection.map do |object|
        MarkerBuilder.new(object).call(&block)
      end
    end

    class MarkerBuilder

      attr_reader :object, :hash
      def initialize(object)
        @object = object
        @hash   = {}
      end

      def call(&block)
        block.call(object, self)
        hash
      end

      def lat(float)
        @hash[:lat] = float
      end

      def lng(float)
        @hash[:lng] = float
      end

      def infowindow(string)
        @hash[:infowindow] = string
      end

      def title(string)
        @hash[:marker_title] = string
      end

      def json(hash)
        @hash.merge! hash
      end

      def picture(hash)
        @hash[:picture] = hash
      end

      def shadow(hash)
        @hash[:shadow] = hash
      end
    end
  end
end
