# frozen_string_literal: true

module ChinaRegions
  class FetchOptionsController < ::ActionController::Metal
    def index
      if params_valid?(params) && (parent_klass = params[:parent_klass].classify.safe_constantize.find(params[:parent_id]))
        table_name = params[:klass].tableize
        regions = parent_klass.__send__(table_name).select("#{table_name}.id, #{table_name}.name")
        regions = if level_column?(params[:klass])
          regions.order('level ASC')
        else
          regions.order('name ASC')
        end
      else
        regions = []
      end

      self.response_body = regions.to_json
    end

    protected

    def level_column?(klass_name)
      klass_name.classify.safe_constantize.try(:column_names).to_a.include?('level')
    end

    def params_valid?(params)
      params[:klass].present? && params[:parent_klass] =~ /^province|city$/i && params[:parent_id].present?
    end
  end
end
