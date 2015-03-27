# encoding: utf-8
module ChinaRegions
  module Helpers
    module FormHelper
      def region_select(object_name, methods, options = {}, html_options = {})
        output = ''
        preselected_choices = {}

        set_preselected_choices(preselected_choices, options)

        html_options[:class] ?
          (html_options[:class].prepend('region_select ')) :
            (html_options[:class] = 'region_select')

        dropdown_prefix = options[:prefix] ? options[:prefix].to_s + "_" : ""

        if Array === methods
          methods.each_with_index do |method, index|
            if region_klass = method.to_s.classify.safe_constantize
              choices = get_choices(region_klass, method, preselected_choices, index)
              next_method = methods.at(index + 1)

              set_prompt(method, options, region_klass)
              set_html_options(object_name, method, html_options, next_method, dropdown_prefix)

              if method == :province and preselected_choices[:province_id]
                options[:selected] = preselected_choices[:province_id]
              end

              output << select(object_name, "#{dropdown_prefix}#{method.to_s}_id", choices, options, html_options)
              options.delete(:selected) unless method == :province
            else
              raise "Method '#{method}' is not a vaild attribute of #{object_name}"
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

            if methods == :province and preselected_choices[:province_id]
              options[:selected] = preselected_choices[:province_id]
            end

            output << select(object_name, _methods, region_klass.where(nil).collect {|p| [ p.name, p.id ] }, options = options, html_options = html_options)
          else
            raise "Method '#{method}' is not a vaild attribute of #{object_name}"
          end
        end
        output.html_safe
      end

      private

      def get_choices(region_klass, method, preselected_choices, index)
        choices = (index == 0 ? region_klass.where(nil).collect { |p| [ p.name, p.id ] } : [])

        choices = preselected_choices[:cities] if preselected_choices[:cities] && method == :city
        choices = preselected_choices[:districts] if preselected_choices[:districts] && method == :district

        choices
      end

      def set_preselected_choices(preselected_choices, options)
        return unless options[:province]

        province_id = get_province_id(options[:province])
        cities = City.where(province_id: province_id)
        districts = District.where(city_id: cities)

        options.delete(:province)

        city_choices = cities.collect { |c| [ c.name, c.id ] }
        district_choices = districts.collect { |d| [ d.name, d.id ] }

        preselected_choices[:province_id] = province_id
        preselected_choices[:cities]      = city_choices
        preselected_choices[:districts]   = district_choices
      end

      def set_prompt(method, options, region_klass)
        if respond_to?("#{method}_select_prompt")
          options[:prompt] = __send__("#{method}_select_prompt")
        else
          options[:prompt] = region_prompt(region_klass)
        end
      end

      def get_province_id(province)
        Province.where('name_en = ? OR name = ?', province.downcase, province).first.id
      end

      def set_html_options(object_name, method, html_options, next_region, prefix)
        html_options[:data] ? (html_options[:data][:region_klass] = "#{method.to_s}") : (html_options[:data] = { region_klass: "#{method.to_s}" })
        if next_region
          object_name = object_name.dup.gsub(/\[/, '_')
          object_name = object_name.dup.gsub(/\]/, '')
          html_options[:data].merge!(region_target: "#{object_name}_#{prefix}#{next_region.to_s}_id", region_target_klass: next_region.to_s)
        else
          html_options[:data].delete(:region_target)
          html_options[:data].delete(:region_target_klass)
        end
      end

      def region_prompt(region_klass)
        t('views.select', model: region_klass.model_name.human)
      end
    end

    module FormBuilder
      def region_select(methods, options = {}, html_options = {})
        @template.region_select(@object_name.to_s, methods, options = options, html_options = html_options)
      end
    end

  end
end

ActionView::Base.send :include, ChinaRegions::Helpers::FormHelper
ActionView::Helpers::FormBuilder.send :include, ChinaRegions::Helpers::FormBuilder
