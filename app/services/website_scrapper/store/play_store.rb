class WebsiteScrapper
  module Store
    class PlayStore < Base
      private

      def app_type
        :android
      end

      def props
        {
          url: "al:android:url",
          store_id: "al:android:package",
          name: "al:android:app_name"
        }
      end
    end
  end
end
