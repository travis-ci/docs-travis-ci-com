require 'dpl'

module Dpl
  module Docs
    extend self

    SKIP = [Cl::Help]

    def write
      providers.each do |cmd|
        Provider.new(cmd).write
      end
    end

    def providers
      consts = Dpl::Provider.registry.values
      consts = consts.uniq.sort_by(&:name)
      consts - SKIP
    end

    class Provider < Struct.new(:cmd)
      def write
        puts "writing #{path} ..."
        File.write(path, content)
      end

      def path
        "_includes/deploy/providers/#{cmd.registry_key.to_s.gsub(':', '_')}.md"
      end

      def content
        parts = []
        parts << minimal.to_s
        parts << maturity
        parts << opts.to_s
        parts << shared.to_s
        parts << env.to_s
        parts << vars.to_s
        parts << secrets if secrets?
        parts.join("\n")
      end

      def minimal
        Minimal.new(cmd)
      end

      def maturity
        "## Status\n\n#{Maturity.new(cmd).to_s}"
      end

      def opts
        Opts.new(cmd)
      end

      def shared
        Opts.new(cmd, true)
      end

      def env
        @env ||= Env.new(cmd)
      end

      def vars
        @vars ||= Vars.new(cmd)
      end

      def secrets
        %({% include deploy/secrets.md name="#{env.opt.name}" env_name="#{env.example_name}" %})
      end

      def secrets?
        !!env.opt
      end
    end

    class Minimal < Struct.new(:cmd)
      STR = <<~str
        {### unless include.minimal == false ###}
        For a minimal configuration, add the following to your `.travis.yml`:

        ```yaml
        deploy:
          provider: %s
        %s
          edge: true # opt in to dpl v2
        ```
        {: data-file=".travis.yml"}

        %s

        {{ include.content }}
        {### endunless ###}
      str

      ALT = <<~str
        Alternatively, you can use %s:

        ```yaml
        deploy:
          provider: %s
        %s
        ```
        {: data-file=".travis.yml"}
      str

      def to_s
        str = STR % [cmd.registry_key, format(opts), alt]
        str.gsub('###', '%')
      end

      def alt
        ALT % [alt_names, cmd.registry_key, format(alts + required)] if alts
      end

      def opts
        return required unless cmd.required.any?
        opts = Array(cmd.required.first.first)
        opts = opts.map { |name| cmd.opts[name] }
        opts + required
      end

      def alts
        return unless cmd.required.any?
        opts = Array(cmd.required.first.last)
        opts.map { |name| cmd.opts[name] }
      end

      def alt_names
        strs = alts.map { |opt| "`#{opt.name}`" }
        sentence(strs, 'and')
      end

      def required
        cmd.opts.select(&:required?)
      end

      def format(opts)
        opts = opts.map { |opt| [opt.name, value(opt)].join(': ') }.join("\n")
        opts = indent(opts, 2)
      end

      def value(opt)
        "<#{'encrypted ' if opt.secret?}#{opt.name}>"
      end

      def indent(str, width)
        str.split("\n").map { |str| "#{" " * width}#{str}" }.join("\n")
      end

      def sentence(strs, sep = 'or')
        return strs.join if strs.size == 1
        [strs[0..-2].join(', '), strs[-1]].join(" #{sep} ")
      end
    end

    class Maturity < Struct.new(:cmd)
      STATUS = %i(dev alpha beta stable deprecated)

      MSG = {
        dev:        'Support for deployments to %s is in **development**',
        alpha:      'Support for deployments to %s is in **alpha**',
        beta:       'Support for deployments to %s is in **beta**',
        stable:     'Support for deployments to %s is *stable**',
        deprecated: 'Support for deployments to %s is *deprecated**',
        pre_stable: 'Please see [Maturity Levels](%s) for details.'
      }

      URL = '/user/deployment-v2#maturity-levels'

      def to_s
        msg = "#{MSG[status] % name}."
        msg << " #{MSG[:pre_stable] % URL}" if pre_stable?
        msg
      end

      def pre_stable?
        STATUS.index(status) < STATUS.index(:stable)
      end

      def name
        cmd.full_name
      end

      def status
        cmd.status.status
      end
    end

    class Opts < Struct.new(:cmd, :shared?)
      KNOWN = <<~str
        ## Known options

        Use the following options to further configure the deployment. %s

        %s
      str

      SHARED = <<~str
        ### Shared options

        %s%s
      str


      SKIP = %i(help)

      def to_s
        opts = self.opts.reject(&:internal?)
        opts = opts.reject { |opt| SKIP.include?(opt.name) }
        opts = opts.map { |opt| "| #{format_opt(opt)} |" }
        str = shared? ? SHARED : KNOWN
        str = str % [requireds, opts.join("\n")]
        str.gsub(/ +$/, '')
      end

      def requireds
        return if shared?
        opts = cmd.required.map do |opts|
          opts = opts.map { |opts| sentence(quote(*opts), 'and') }
          "Either #{sentence(opts, 'or')} are required."
        end.join(' ')
      end

      def opts
        shared? ? shared : cmd.opts.to_a - shared
      end

      def shared
        opts = []
        const = cmd
        until const == Cl::Cmd
          opts.append(*opts_from(const.superclass))
          const = const.superclass
        end
        opts
      end

      def opts_from(const)
        return [] unless const.respond_to?(:opts)
        const.opts.to_a - opts_from(const.superclass)
      end

      def format_opt(opt)
        ["`#{opt.name}`", Obj.new(opt).format].join(' | ')
      end

      def quote(*strs)
        strs.map { |str| "`#{str}`" }
      end

      def sentence(strs, sep = 'or')
        return strs.join if strs.size == 1
        [strs[0..-2].join(', '), strs[-1]].join(" #{sep} ")
      end
    end

    class Env < Struct.new(:cmd)
      STR = <<~str
        ## Environment variables

        All options can be given as environment variables if prefixed with %s.

        For example, `%s` can be given as %s
      str

      def opt
        @opt ||= cmd.opts.detect { |opt| opt.secret? }
      end

      def to_s
        str = opt ? STR % [pattern, opt.name, example] : nil
        str.strip if str
      end

      def pattern
        strs = env.strs.map { |str| "#{str}_" }
        strs += env.strs if env.opts[:allow_skip_underscore]
        strs = strs.map { |str| "`#{str}`" }
        sentence(strs)
      end

      def example
        strs = env.strs.map { |str| format(opt, str, '_') }
        strs += env.strs.map { |str| format(opt, str) } if env.opts[:allow_skip_underscore]
        bullets(strs)
      end

      def example_name
        [env.strs.first, opt.name.upcase].join('_')
      end

      def format(opt, str, sep = nil)
        "`#{str}#{sep}#{opt.name.upcase}=<#{opt.name}>`"
      end

      def bullets(strs)
        return "#{strs.join}." if strs.size == 1
        "\n\n#{strs.map { |str| "* #{str}" }.join(" or \n")}\n"
      end

      def sentence(strs, sep = ' or ')
        return strs.join if strs.size == 1
        [strs[0..-2].join(', '), strs[-1]].join(' or ')
      end

      def env # TODO
        cmd.instance_variable_get(:@env) || cmd.superclass.instance_variable_get(:@env)
      end
    end

    class Vars < Struct.new(:cmd)
      STR = <<~str
        ## Interpolation variables

        The following variables are available for interpolation on %s:

        %s

        Interpolation uses the syntax `@@{variable-name}`. For example,
        `"Current commit sha: @@{git_sha}"` would result in a string with the
        current Git sha embedded.

        Furthermore, environment variables present in the current build
        environment can be used through standard Bash variable interpolation.
        For example: "Current build number: ${TRAVIS_BUILD_NUMBER}".
        See [here](/user/environment-variables/#default-environment-variables)
        for a list of default environment variables set.
      str

      def to_s
        return unless opts.any?
        str = STR % [names, vars]
        str.gsub('@@', '%')
      end

      def opts
        cmd.opts.select(&:interpolate?)
      end

      def names
        opts.map(&:name).map { |name| "`#{name}`" }.join(', ')
      end

      def vars
        cmd.vars.map { |var| "* `#{var}`" }.join("\n")
      end
    end

    class Obj < Struct.new(:obj)
      def format
        opts = []
        opts << '**required**' if obj.required?
        opts << '**secret**' if obj.secret?
        opts << "type: #{type(obj)}"
        opts += Opt.new(obj).format if obj.is_a?(Cl::Opt)
        opts = opts.join(', ')
        opts = "&mdash; #{opts}" if obj.description && !opts.empty?
        opts = [obj.description, opts]
        opts.compact.map(&:strip).join(' ')
      end

      def type(obj)
        case obj.type
        when :flag
          :boolean
        when :array
          'string or array of strings'
        else
          obj.type
        end
      end
    end

    class Opt < Struct.new(:opt)
      def format
        opts = []
        opts << "alias: #{format_aliases(opt)}" if opt.aliases?
        opts << "requires: `#{opt.requires.join(', ')}`" if opt.requires?
        opts << "default: `#{format_default(opt)}`" if opt.default?
        opts << "known values: #{format_enum(opt)}" if opt.enum?
        opts << "format: `#{opt.format}`" if opt.format?
        opts << "downcase: true" if opt.downcase?
        opts << "upcase: true" if opt.upcase?
        opts << "min: #{opt.min}" if opt.min?
        opts << "max: #{opt.max}" if opt.max?
        opts << "e.g.: #{opt.example}" if opt.example?
        opts << "note: #{opt.note}" if opt.note?
        opts << "see: #{format_see(opt.see)}" if opt.see?
        opts << format_deprecated(opt) if opt.deprecated?
        opts.compact
      end

      def format_aliases(opt)
        opt.aliases.map do |name|
          strs = ["`#{name}`"]
          strs << "(deprecated, please use `#{opt.name}`)" if opt.deprecated[0] == name
          strs.join(' ')
        end.join(', ')
      end

      def format_enum(opt)
        opt.enum.map { |value| "`#{format_regex(value)}`" }.join(', ')
      end

      def format_default(opt)
        opt.default.is_a?(Symbol) ? opt.default.to_s.sub('_', ' ') : opt.default
      end

      def format_deprecated(opt)
        return "deprecated (#{opt.deprecated[1]})" if opt.deprecated[0] == opt.name
      end

      def format_regex(str)
        return str unless str.is_a?(Regexp)
        "/#{str.to_s.sub('(?-mix:', '').sub(/\)$/, '')}/"
      end

      def format_see(see)
        see = "[#{see}](#{see})" if see.start_with?('http')
        see
      end
    end
  end
end
