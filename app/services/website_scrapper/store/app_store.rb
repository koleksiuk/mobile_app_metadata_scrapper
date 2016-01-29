class WebsiteScrapper
  module Store
    class AppStore < Base
      private

      def app_type
        :ios
      end

      def props
        {
          url: "al:ios:url",
          store_id: "al:ios:app_store_id",
          name: "al:ios:app_name"
        }
      end
    end
  end
end
