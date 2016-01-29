class WebsiteScrapper
  module Store
    class App
      include Comparable

      attr_reader :app_type, :name, :store_id, :url

      def initialize(app_type:, name: nil, store_id: nil, url: nil)
        @app_type = app_type
        @name = name
        @store_id = store_id
        @url = url
      end

      def set(attr, value)
        send("#{attr}=", value)
      end

      def present?
        [name, store_id, url].all?(&:present?)
      end

      private

      attr_writer :name, :store_id, :url
    end
  end
end
