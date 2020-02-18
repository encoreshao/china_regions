# frozen_string_literal: true

module ChinaRegions
  module Helpers
    module FormHelper
      def region_select(object_name, fields, options = {}, html_options = {})
        output = []

        preselected_choices = setup_regions_options(options)

        html_options[:class] ?
          html_options[:class].prepend('region_select ') :
            (html_options[:class] = 'region_select')

        dropdown_prefix = options[:prefix] ? options[:prefix].to_s + '_' : ''

        if fields.is_a?(Array)
          fields.each_with_index do |field, field_index|
            if region_klass = field.to_s.classify.safe_constantize
              choices = fetch_choices(region_klass, field, preselected_choices, field_index)
              choices = prioritize_choices(options[:priority][field], choices) if options[:priority].try(:[], field)

              next_method = fields.at(field_index + 1)

              set_prompt(field, options, region_klass)
              set_html_options(object_name, field, html_options, next_method, dropdown_prefix)

              if options[:default] && options[:default][field]
                options[:selected] = options[:default][field] if options[:default][field]
              end

              output << select(object_name, "#{dropdown_prefix}#{field}_id", choices, options, html_options)
            else
              raise "Method '#{field}' is not a vaild attribute of #{object_name}"
            end
          end
        else
          inner_methods = if fields.to_s.include?('_id')
            inner_methods = fields
            fields = fields.to_s.gsub(/(_id)$/, '')
            inner_methods
          else
            (fields.to_s + '_id').to_sym
          end

          if region_klass = fields.to_s.classify.safe_constantize
            options[:prompt] = region_prompt(region_klass)
            options[:selected] = preselected_choices[:province_id] if fields == :province && preselected_choices[:province_id]

            output << select(object_name, inner_methods, region_options(region_klass), options: options, html_options: html_options)
          else
            raise "Method '#{fields}' is not a vaild attribute of #{object_name}"
          end
        end
        output.join.html_safe
      end

      private
      def fetch_choices(region_klass, method, preselected_choices, index)
        return preselected_choices[method] if preselected_choices[method]

        index.zero? ? region_options(region_klass) : []
      end

      def region_options(region_klass)
        @region_options ||= region_klass.where(nil).collect { |p| [p.name, p.id] }
      end

      def prioritize_choices(priorities, choices)
        return choices if priorities.empty?

        temp_choices = []
        priority_choices = []
        sorting_map = {}

        priorities.each_with_index do |value, i|
          sorting_map[value.to_sym] = i
        end

        choices.each do |name, id|
          if sorting_map[name.to_sym]
            priority_choices[sorting_map[name.to_sym]] = [name, id]
          else
            temp_choices.push([name, id])
          end
        end
        priority_choices.compact + temp_choices
      end

      def setup_regions_options(options)
        return {} unless options[:default] && options[:default][:province]

        # Add validator to check if the passed province, city or district exists within the models
        province_id = get_province_id(options[:default][:province])
        cities = City.for_province(province_id)
        districts = District.for_city(city_id: cities)

        {
          province_id: province_id,
          city:        cities.collect { |c| [c.name, c.id] },
          district:    districts.collect { |d| [d.name, d.id] }
        }
      end

      def set_prompt(method, options, region_klass)
        options[:prompt] = if respond_to?("#{method}_select_prompt")
          __send__("#{method}_select_prompt")
        else
          region_prompt(region_klass)
        end
      end

      def get_province_id(province)
        return province if province.to_s =~ /\A[0-9]*\z/

        Province.filter(province.downcase).first.id
      end

      def set_html_options(object_name, method, html_options, next_region, prefix)
        html_options[:data] ? (html_options[:data][:region_klass] = method.to_s) : (html_options[:data] = { region_klass: method.to_s })
        if next_region
          object_name = object_name.dup.tr('[', '_')
          object_name = object_name.dup.delete(']')
          html_options[:data].merge!(region_target: "#{object_name}_#{prefix}#{next_region}_id", region_target_klass: next_region.to_s)
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
