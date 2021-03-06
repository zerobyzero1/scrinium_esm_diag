module ScriniumEsmDiag
  class Actions
    def self.vinterp_accepted_options
      { :on => Array, :interp_type => Symbol, :extrap => [ TrueClass, FalseClass ], :delete_input => [ TrueClass, FalseClass ] }
    end

    def self.vinterp dataset, metric, tag, var, options
      ActionHelpers.start(dataset.variables[var][:pipelines], options).each do |status_pipeline|
        pipeline = status_pipeline.last
        if status_pipeline.first == :active
          ps_path = ActionHelpers.create_file_name 'PS', tag
          input_file_name = ActionHelpers.create_file_name var, tag, pipeline
          pipeline << ".vinterp#{options[:on].join(':')}"
          output_file_name = ActionHelpers.create_file_name var, tag, pipeline
          if not Cache.already_generated? output_file_name
            interp_type = options[:interp_type] ? { :linear => 1, :log => 2, :loglog => 3 }[options[:interp_type]] : 1
            extrap = options[:extrap] ? 'True' : 'False'
            ncl_script = "#{ENV['SCRINIUM_ESM_DIAG_ROOT']}/ncl_scripts/models/#{ConfigManager.model_id.downcase}/vinterp.ncl"
            if File.exist? ncl_script
              ncl "#{ncl_script} " +
                "ps_path=\\\"#{ps_path}\\\" " +
                "var_path=\\\"#{input_file_name}\\\" " +
                "var_name=\\\"#{var}\\\" " +
                "'plevs=(/#{options[:on].join(',')}/)' " +
                "interp_type=#{interp_type} " +
                "extrap=#{extrap} "+
                "out_path=\\\"#{output_file_name}\\\""
            else
              CLI.report_error "Under construction!"
            end
            Cache.save_pipeline output_file_name
          end
        end
        dataset.variables[var][:pipelines] << pipeline
      end
    end
  end
end
