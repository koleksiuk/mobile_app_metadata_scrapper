class WebsiteScrapper
  module Store
    class Base
      class NullNode
        def text
        end
      end

      NotFoundNode = NullNode.new

      def self.get_app_details(xpath_doc)
        new(xpath_doc).get_app_details
      end

      def initialize(xpath_doc)
        @xpath_doc = xpath_doc
      end

      def get_app_details
        App.new(app_type: app_type).tap do |app|
          props.each do |attr, xpath_node|
            app.set(attr, fetch_node(xpath_node))
          end
        end
      end

      private

      attr_reader :xpath_doc

      def fetch_node(xpath_node)
        [
          xpath_doc.xpath("//meta[@name='#{xpath_node}']/@content"),
          xpath_doc.xpath("//meta[@property='#{xpath_node}']/@content"),
          NotFoundNode
        ].lazy.find(&:present?).text
      end

      def app_type
        raise NotImplementedError
      end

      def props
        raise NotImplementedError
      end
    end
  end
end
