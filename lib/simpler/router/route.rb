module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
      end

      def match?(method, path, params)
        @method == method && parse_path(path, params)
      end

      private

      def parse_path(path, params)
        
        router_path_parts = split_path(@path)
        request_path_parts = split_path(path)

        return false if request_path_parts.nil? || (request_path_parts.size != router_path_parts.size)

        router_path_parts.each_with_index do |part, index|
          if part.start_with?(':')
            set_param(params, part, request_path_parts[index])
          else
            return false if part != request_path_parts[index]
          end
        end
      end

      def set_param(params, parameter, value)
        parameter = parameter.delete!(':').to_sym
        params[parameter] = value
      end

      def split_path(path)
        path.split('/').reject(&:empty?)
      end

    end
  end
end
