class Uberkit::Forms::Builder < ActionView::Helpers::FormBuilder
  include ActionView::Helpers::CaptureHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  
  helpers = field_helpers + %w(date_select datetime_select time_select select html_area state_select country_select) - %w(hidden_field label fields_for) 
  
  helpers.each do |name|
    define_method(name) do |field, *args|
      options = args.extract_options!
      class_names = array_from_classes(options[:class])
      class_names << name
      options[:class] = class_names.join(" ")
      args << options
      generic_field(options[:label],field,super(field,*args),{:description => options.delete(:description), :help => options.delete(:help), :required => options.delete(:required)})
    end
  end
  
  def generic_field(label_text,field,content,options = {})
    required = options.delete(:required)
    help = options.delete(:help)
    description = options.delete(:description)
    hide_validation = options.delete(:hide_validation)

    content_tag(:div, :class => "field_row#{' required' if required}#{' labelless' if label_text == ""}") do
      ret = label(field, (label_text || field.to_s.titleize).to_s + ":") unless label_text == ""
      ret << content
      ret << content_tag(:span, help, :class => "help") if help
      ret << content_tag(:span, description, :class => "description") if description
      ret << @template.validation_tag(@object, field).to_s unless hide_validation
      ret
    end
  end
  
  # create a submit helper
  def submit(value = "Submit", options = {})
    @template.submit_tag(value, options)
  end

  # create a image_submit helper
  def image_submit(img_path, options = {})
    @template.image_submit_tag(img_path, options)
  end
  
  # create an error messages helper
  def error_messages(object_name = nil)
    @template.error_messages_for object_name || @object_name
  end
  
  def custom(options = {}, &block)
    concat("<div class='field_row#{' labelless' unless options[:label]}'>#{"<label#{" for='#{options[:for]}'" if options[:for]}>#{options[:label] + ":" if options[:label]}</label>" if options[:label]}<div class='pseudo_field'>",block.binding)
    yield
    concat("</div> <br/></div>",block.binding)
  end 
  
  def array_from_classes(html_classes)
    html_classes ? html_classes.split(" ") : []
  end
  
  def fieldset(legend=nil,&block)
    concat("<fieldset>#{"<legend>#{legend}</legend>" if legend}",block.binding)
    yield
    concat("</fieldset>",block.binding)
  end
  
  def output_buffer
    @template.output_buffer
  end
  
  def output_buffer=(buf)
    @template.output_buffer = buf
  end
  
  def is_haml?
    if respond_to?(:is_haml?)
      return is_haml?
    else
      return false
    end
  end
end