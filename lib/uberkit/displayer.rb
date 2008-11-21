module Uberkit
  class Displayer
    include ActionView::Helpers::CaptureHelper
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::TagHelper

    def initialize(template)
      @template = template
    end
    
    def is_haml?
      !@haml_buffer.nil? && @haml_buffer.active?
    end
  end
end