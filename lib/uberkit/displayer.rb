module Uberkit
  class Displayer
    include ActionView::Helpers::CaptureHelper
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::TagHelper

    def initialize(template)
      @template = template
    end
    
    def is_haml?
      if respond_to?(:is_haml?)
        return is_haml?
      else
        return false
      end
    end
  end
end