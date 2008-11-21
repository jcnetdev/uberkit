module Uberkit::Forms::Helper
  def parse_options(*args)
    options = args.extract_options!
    options.merge!(:builder => Uberkit::Forms::Builder)
    options[:html] ||= {}
    class_names = options[:html][:class] ? options[:html][:class].split(" ") : []
    class_names << "uberform"
    class_names << options.delete(:kind).to_s
    options[:html][:class] = class_names.join(" ")
    args << options
  end
  
  def uberform_for(name_or_object_or_array, *args, &proc)
    args = parse_options(*args)
    form_for(name_or_object_or_array, *args, &proc)
  end
  alias :build_form_for :uberform_for
  
  def uberform_fields_for(record_or_name_or_array, *args, &proc)
    args = parse_options(*args)
    fields_for(record_or_name_or_array, *args, &proc)
  end
  alias :build_fields_for :uberform_fields_for
  
  def remote_uberform_for(name_or_object_or_array, *args, &proc)
    args = parse_options(*args)
    remote_form_for(name_or_object_or_array, *args, &proc)
  end
  alias :build_remote_form_for :remote_uberform_for
  
  # show validation error for a model and attribute
  def validation_tag(model, attribute, options = {})
    return if model.blank? or model.errors.blank?    
    unless model.errors[attribute].blank?
      # generate error markup
      return content_tag :span, [model.errors[attribute]].flatten.join(options[:separator] || ", ").to_s, :class => "error-message"
    end
  end
end