require_relative 'router/route'

module Simpler
  class Router

    def initialize
      @routes = []
    end

    def get(path, route_point)
      add_route(:get, path, route_point)
    end

    def post(path, route_point)
      add_route(:post, path, route_point)
    end

    def route_for(env)
      puts "route_for call #{env}"
      method = env['REQUEST_METHOD'].downcase.to_sym
      puts "LOG METHOD route_for #{method}"
      path = env['PATH_INFO']
      params = env['simpler.route_params'] ||= {}
      puts "LOG path route_for #{path}"
      puts "LOG routes FIND #{@routes.find { |route| route.match?(method, path,params) }}"
  

      params = env['simpler.route_params'] ||= {}
      @routes.find { |route| route.match?(method, path, params) }
    end

    private

    def add_route(method, path, route_point)
      route_point = route_point.split('#')
      controller = controller_from_string(route_point[0])
      action = route_point[1]
      route = Route.new(method, path, controller, action)

      @routes.push(route)
    end

    def controller_from_string(controller_name)
      Object.const_get("#{controller_name.capitalize}Controller")
    end

  end
end
