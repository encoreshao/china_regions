# encoding: utf-8

module ChinaRegions
  module Helpers
    module FormHelper
      
      def region_select(object, methods, options = {}, html_options = {})
        output = ''

        html_options[:class] ? 
          (html_options[:class].prepend('region_select ')) : 
            (html_options[:class] = 'region_select')
            
        if Array === methods
          methods.each_with_index do |method, index|
            if region_klass = method.to_s.classify.safe_constantize
              choices = (index == 0 ? region_klass.scoped.collect {|p| [ p.name, p.id ] } : [])
              next_method = methods.at(index + 1)
              
              set_options(method, options, region_klass)
              set_html_options(object, method, html_options, next_method)
              
              output << select(object, "#{method.to_s}_id", choices, options = options, html_options = html_options)
            else
              raise "Method '#{method}' is not a vaild attribute of #{object}"
            end
          end
        else

          _methods = unless methods.to_s.include?('_id')
            (methods.to_s + ('_id')).to_sym 
          else
            _methods = methods
            methods = methods.to_s.gsub(/(_id)$/, '')
            _methods
          end

          if region_klass = methods.to_s.classify.safe_constantize
            options[:prompt] = region_prompt(region_klass)
            
            output << select(object, _methods, region_klass.scoped.collect {|p| [ p.name, p.id ] }, options = options, html_options = html_options)
          else
            raise "Method '#{method}' is not a vaild attribute of #{object}"
          end
        end
        
        output << javascript_tag(js_output)
        output.html_safe
      end
    
    
      private
      
      def set_options(method, options, region_klass)
        if respond_to?("#{method}_select_prompt")
          options[:prompt] = __send__("#{method}_select_prompt")
        else
          options[:prompt] = region_prompt(region_klass)
        end
      end
      
      def set_html_options(object, method, html_options, next_region)
        html_options[:data] ? (html_options[:data][:region_klass] = "#{method.to_s}") : (html_options[:data] = { region_klass: "#{method.to_s}" })
        if next_region
          html_options[:data].merge!(region_target: "#{object}_#{next_region.to_s}_id", region_target_klass: next_region.to_s)
        else
          html_options[:data].delete(:region_target)
          html_options[:data].delete(:region_target_klass)
        end
      end
        
      def region_prompt(region_klass)
        t('views.select', model: region_klass.model_name.human)
      end
      
      def js_output
        %~
          $(function(){
            $('body').on('change', '.region_select', function(event) {
              var self, targetDom;
              self = $(event.currentTarget);
              targetDom = $('#' + self.data('region-target'));
              if (targetDom.size() > 0) {
                $.getJSON('/china_regions/fetch_options', {klass: self.data('region-target-klass'), parent_klass: self.data('region-klass'), parent_id: self.val()}, function(data) {
                  $('option[value!=""]', targetDom).remove();
                  $.each(data, function(index, value) {
                    targetDom.append("<option value='" + value.id + "'>" + value.name + "</option>");
                  });
                })
              }
            });
          });
        ~
      end
  
    end
    
    
    module FormBuilder
      def region_select(methods, options = {}, html_options = {})
        @template.region_select(@object_name, methods, options = options, html_options = html_options)
      end
    end

  end
end

ActionView::Base.send :include, ChinaRegions::Helpers::FormHelper
ActionView::Helpers::FormBuilder.send :include, ChinaRegions::Helpers::FormBuilder
